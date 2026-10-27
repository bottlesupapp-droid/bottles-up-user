import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../site/models/features.dart';
import '../../../site/models/post.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/post_rules.dart';
import '../../../site/services/media_picker.dart';
import '../../../site/services/posts_service.dart';
import '../../../site/site_error.dart';
import '../widgets/profile_widgets.dart';
import '../widgets/rules_gate.dart';
import '../widgets/switcher_sheet.dart';

/// Make a post (1 to 10 photos), a reel (one video up to 60 seconds) or a story (one photo or video, up for 24 hours): the words, who may see it, what it is tagged with, and
/// whether people may comment. Files go up first; the post is made only when they are all there.
class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key, this.initialKind = PostKind.post});

  final PostKind initialKind;

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  late PostKind _kind = widget.initialKind;
  final List<PickedMedia> _media = [];
  final _caption = TextEditingController();
  PostAudience _audience = PostAudience.public;
  bool _comments = true;
  final List<PostTag> _tags = [];
  bool _posting = false;
  String? _progress;
  String? _problem;

  @override
  void dispose() {
    _caption.dispose();
    super.dispose();
  }

  void _setKind(PostKind k) {
    if (k == _kind) return;
    setState(() {
      _kind = k;
      _media.clear();
      _problem = null;
    });
  }

  Future<void> _choose() async {
    final picker = ref.read(mediaPickerProvider);
    try {
      if (_kind == PostKind.post) {
        final room = maxPhotosPerPost - _media.length;
        if (room <= 0) {
          setState(() => _problem = 'You can add up to $maxPhotosPerPost photos.');
          return;
        }
        final picked = await picker.photos(max: room);
        final bad = [for (final m in picked) mediaProblem(m)].whereType<String>();
        setState(() {
          _problem = bad.isEmpty ? null : bad.first;
          _media.addAll([for (final m in picked) if (mediaProblem(m) == null) m]);
        });
      } else {
        final v = await picker.video();
        if (v == null) return;
        final problem = mediaProblem(v);
        setState(() {
          _problem = problem;
          if (problem == null) {
            _media
              ..clear()
              ..add(v);
          }
        });
      }
    } on SiteException catch (e) {
      setState(() => _problem = e.message);
    }
  }

  Future<void> _choosePhotoForStory() async {
    try {
      final picked = await ref.read(mediaPickerProvider).photos(max: 1);
      if (picked.isEmpty) return;
      final problem = mediaProblem(picked.first);
      setState(() {
        _problem = problem;
        if (problem == null) {
          _media
            ..clear()
            ..add(picked.first);
        }
      });
    } on SiteException catch (e) {
      setState(() => _problem = e.message);
    }
  }

  String? _shapeProblem() {
    if (_media.isEmpty) return _kind == PostKind.post ? 'Add at least one photo.' : (_kind == PostKind.reel ? 'Choose a video.' : 'Choose a photo or a video.');
    return captionProblem(_caption.text);
  }

  Future<void> _post(SocialProfile actor) async {
    final problem = _shapeProblem();
    if (problem != null) {
      setState(() => _problem = problem);
      return;
    }
    if (!await ensureRulesAccepted(context, ref)) return;
    setState(() {
      _posting = true;
      _problem = null;
    });
    final service = ref.read(postsServiceProvider);
    try {
      final uploaded = <UploadedMedia>[];
      for (var i = 0; i < _media.length; i++) {
        setState(() => _progress = 'Uploading ${i + 1} of ${_media.length}');
        uploaded.add(await service.upload(actor.id, _media[i]));
      }
      setState(() => _progress = 'Posting');
      final post = await service.create(
        actor: actor.id,
        kind: _kind,
        audience: _audience,
        media: uploaded,
        caption: _caption.text.trim().isEmpty ? null : _caption.text,
        tags: [for (final t in _tags) TagRef(t.kind, t.id)],
        commentsEnabled: _kind == PostKind.story ? true : _comments,
      );
      ref.invalidate(storyRailProvider(actor.id));
      ref.invalidate(storiesOfProvider);
      if (!mounted) return;
      if (_kind == PostKind.story) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Your story is up for 24 hours.')));
        context.canPop() ? context.pop() : context.go('/');
      } else {
        context.pushReplacement('/post/${post.id}');
      }
    } on SiteException catch (e) {
      if (mounted) setState(() => _problem = e.message);
    } finally {
      if (mounted) {
        setState(() {
          _posting = false;
          _progress = null;
        });
      }
    }
  }

  Future<void> _tag() async {
    final picked = await showModalBottomSheet<List<PostTag>>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _TagSheet(initial: _tags),
    );
    if (picked != null) setState(() => _tags..clear()..addAll(picked));
  }

  @override
  Widget build(BuildContext context) {
    return ActorGate(
      title: 'Create',
      builder: (context, actor) {
        final theme = Theme.of(context);
        final reels = ref.watch(featureOnProvider(Feature.reels));
        final stories = ref.watch(featureOnProvider(Feature.stories));
        final members = ref.watch(featureOnProvider(Feature.membersOnly));
        final many = (ref.watch(myProfilesProvider).valueOrNull?.length ?? 0) > 1;
        return Scaffold(
          appBar: AppBar(title: const Text('Create')),
          body: ListView(
            key: const Key('create-form'),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            children: [
              Row(children: [
                ProfileAvatar(profile: actor, size: 32),
                const SizedBox(width: 8),
                Expanded(child: Text('Posting as @${actor.handle}', key: const Key('posting-as'))),
                if (many) TextButton(key: const Key('change-profile'), onPressed: () => showProfileSwitcher(context), child: const Text('Change')),
              ]),
              const SizedBox(height: 8),
              SegmentedButton<PostKind>(
                key: const Key('kind-picker'),
                segments: [
                  const ButtonSegment(value: PostKind.post, label: Text('Post')),
                  if (reels) const ButtonSegment(value: PostKind.reel, label: Text('Reel')),
                  if (stories) const ButtonSegment(value: PostKind.story, label: Text('Story')),
                ],
                selected: {_kind},
                onSelectionChanged: _posting ? null : (s) => _setKind(s.first),
              ),
              const SizedBox(height: 12),
              if (_media.isNotEmpty)
                SizedBox(
                  height: 120,
                  child: ListView(scrollDirection: Axis.horizontal, children: [
                    for (var i = 0; i < _media.length; i++)
                      Stack(key: Key('picked-$i'), children: [
                        Container(
                          width: 96,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(12)),
                          clipBehavior: Clip.antiAlias,
                          child: _media[i].isVideo
                              ? const Center(child: Icon(Icons.videocam_outlined, size: 36))
                              : Image.file(File(_media[i].path), fit: BoxFit.cover, width: 96, height: 120, errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.image_outlined))),
                        ),
                        Positioned(
                          top: 0,
                          right: 8,
                          child: IconButton(key: Key('remove-picked-$i'), tooltip: 'Remove', visualDensity: VisualDensity.compact, icon: const Icon(Icons.cancel, color: Colors.white), onPressed: _posting ? null : () => setState(() => _media.removeAt(i))),
                        ),
                      ]),
                  ]),
                ),
              if (_kind == PostKind.post && _media.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 4), child: Text('${_media.length} of $maxPhotosPerPost photos', key: const Key('photo-count'), style: theme.textTheme.bodySmall)),
              const SizedBox(height: 8),
              Wrap(spacing: 8, children: [
                OutlinedButton.icon(
                  key: const Key('choose-media'),
                  onPressed: _posting ? null : _choose,
                  icon: Icon(_kind == PostKind.post ? Icons.photo_library_outlined : Icons.video_library_outlined),
                  label: Text(switch (_kind) { PostKind.post => _media.isEmpty ? 'Choose photos' : 'Add more photos', PostKind.reel => _media.isEmpty ? 'Choose a video' : 'Choose a different video', PostKind.story => _media.isEmpty ? 'Choose a video' : 'Choose a different video' }),
                ),
                if (_kind == PostKind.story) OutlinedButton.icon(key: const Key('choose-story-photo'), onPressed: _posting ? null : _choosePhotoForStory, icon: const Icon(Icons.photo_outlined), label: const Text('Choose a photo')),
              ]),
              const SizedBox(height: 12),
              TextField(key: const Key('caption-field'), controller: _caption, maxLines: 4, maxLength: maxCaptionLength, textCapitalization: TextCapitalization.sentences, decoration: const InputDecoration(labelText: 'Write a caption (optional)')),
              const SizedBox(height: 8),
              Text('Who can see this', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              SegmentedButton<PostAudience>(
                key: const Key('audience-picker'),
                segments: [
                  const ButtonSegment(value: PostAudience.public, label: Text('Public')),
                  const ButtonSegment(value: PostAudience.followers, label: Text('Followers')),
                  if (members) const ButtonSegment(value: PostAudience.members, label: Text('Members')),
                ],
                selected: {_audience},
                onSelectionChanged: _posting ? null : (s) => setState(() => _audience = s.first),
              ),
              Padding(padding: const EdgeInsets.only(top: 4), child: Text(audienceHint(_audience), key: const Key('audience-hint'), style: theme.textTheme.bodySmall)),
              const SizedBox(height: 12),
              OutlinedButton.icon(key: const Key('tag-button'), onPressed: _posting ? null : _tag, icon: const Icon(Icons.sell_outlined), label: Text(_tags.isEmpty ? 'Tag people, events or venues' : 'Tags (${_tags.length})')),
              if (_tags.isNotEmpty)
                Wrap(spacing: 6, children: [
                  for (final t in _tags) InputChip(key: Key('chosen-tag-${t.kind.name}-${t.id}'), label: Text(t.name), onDeleted: _posting ? null : () => setState(() => _tags.remove(t))),
                ]),
              if (_kind != PostKind.story)
                SwitchListTile(key: const Key('comments-switch'), contentPadding: EdgeInsets.zero, value: _comments, onChanged: _posting ? null : (v) => setState(() => _comments = v), title: const Text('Allow comments')),
              if (_problem != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_problem!, key: const Key('create-problem'), style: TextStyle(color: theme.colorScheme.error))),
              if (_progress != null) Padding(padding: const EdgeInsets.only(top: 8), child: Row(children: [const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)), const SizedBox(width: 8), Text(_progress!, key: const Key('create-progress'))])),
              const SizedBox(height: 16),
              FilledButton(key: const Key('publish'), onPressed: _posting ? null : () => _post(actor), child: Text(_posting ? 'Please wait...' : (_kind == PostKind.story ? 'Share to your story' : 'Share'))),
            ],
          ),
        );
      },
    );
  }
}

class _TagSheet extends ConsumerStatefulWidget {
  const _TagSheet({required this.initial});

  final List<PostTag> initial;

  @override
  ConsumerState<_TagSheet> createState() => _TagSheetState();
}

class _TagSheetState extends ConsumerState<_TagSheet> {
  late final List<PostTag> _chosen = [...widget.initial];
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  bool _has(TagKind k, String id) => _chosen.any((t) => t.kind == k && t.id == id);

  void _toggle(PostTag t) => setState(() {
        if (_has(t.kind, t.id)) {
          _chosen.removeWhere((x) => x.kind == t.kind && x.id == t.id);
        } else if (_chosen.length < maxTagsPerPost) {
          _chosen.add(t);
        }
      });

  @override
  Widget build(BuildContext context) {
    final actor = ref.watch(actorProfileProvider);
    final events = ref.watch(upcomingEventsProvider).valueOrNull ?? const [];
    final venues = ref.watch(venuesProvider).valueOrNull ?? const [];
    final q = _query.trim();
    final people = (actor == null || q.length < 2) ? null : ref.watch(profileSearchProvider(SearchKey(actor: actor.id, query: q)));
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(key: const Key('tag-search'), controller: _search, decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search people and businesses'), onChanged: (v) => setState(() => _query = v)),
          ),
          Expanded(
            child: ListView(children: [
              if (people != null)
                ...people.when(
                  loading: () => const [Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator()))],
                  error: (_, __) => const [Padding(padding: EdgeInsets.all(16), child: Text('We could not search just now.'))],
                  data: (list) => [
                    for (final p in list)
                      CheckboxListTile(
                        key: Key('tag-profile-${p.id}'),
                        value: _has(TagKind.profile, p.id),
                        onChanged: (_) => _toggle(PostTag(kind: TagKind.profile, id: p.id, name: p.displayName, handle: p.handle)),
                        title: Text(p.displayName),
                        subtitle: Text('@${p.handle}'),
                      ),
                  ],
                ),
              if (events.isNotEmpty) const Padding(padding: EdgeInsets.fromLTRB(16, 12, 16, 4), child: Text('Events', style: TextStyle(fontWeight: FontWeight.w800))),
              for (final e in events) CheckboxListTile(key: Key('tag-event-${e.id}'), value: _has(TagKind.event, e.id), onChanged: (_) => _toggle(PostTag(kind: TagKind.event, id: e.id, name: e.title)), title: Text(e.title), subtitle: Text(e.venueName)),
              if (venues.isNotEmpty) const Padding(padding: EdgeInsets.fromLTRB(16, 12, 16, 4), child: Text('Venues', style: TextStyle(fontWeight: FontWeight.w800))),
              for (final v in venues) CheckboxListTile(key: Key('tag-venue-${v.id}'), value: _has(TagKind.venue, v.id), onChanged: (_) => _toggle(PostTag(kind: TagKind.venue, id: v.id, name: v.name)), title: Text(v.name)),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(key: const Key('tags-done'), onPressed: () => Navigator.of(context).pop(_chosen), child: Text('Done (${_chosen.length})')),
          ),
        ]),
      ),
    );
  }
}
