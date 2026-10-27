import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/features.dart';
import '../../../site/models/post.dart';
import '../../../site/models/safety.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/post_rules.dart';
import '../../../site/site_error.dart';
import 'profile_widgets.dart';
import 'report_sheet.dart';
import 'share_sheet.dart';

/// The colour of the ring round a Members Only story, and of the Members Only badge. BottlesUp orange, as the plan draws it.
const Color membersOnlyColor = Color(0xFFFF6B00);

/// Plays a video from an address. Replaced in tests, which have no video player.
typedef VideoBuilder = Widget Function(String url, {required bool autoplay, required bool loop, required bool showControls});

final postVideoBuilderProvider = Provider<VideoBuilder>((ref) => (url, {required autoplay, required loop, required showControls}) => NetworkVideo(url: url, autoplay: autoplay, loop: loop, showControls: showControls));

class NetworkVideo extends StatefulWidget {
  const NetworkVideo({super.key, required this.url, this.autoplay = false, this.loop = false, this.showControls = true});

  final String url;
  final bool autoplay;
  final bool loop;
  final bool showControls;

  @override
  State<NetworkVideo> createState() => _NetworkVideoState();
}

class _NetworkVideoState extends State<NetworkVideo> {
  late final VideoPlayerController _c = VideoPlayerController.networkUrl(Uri.parse(widget.url));
  bool _ready = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _c.initialize().then((_) {
      if (!mounted) return;
      setState(() => _ready = true);
      _c.setLooping(widget.loop);
      if (widget.autoplay) _c.play();
    }).catchError((Object e) {
      logProblem('play a video', e);
      if (mounted) setState(() => _failed = true);
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) return const Center(child: Icon(Icons.videocam_off_outlined, size: 40));
    if (!_ready) return const Center(child: CircularProgressIndicator());
    return GestureDetector(
      onTap: () => setState(() => _c.value.isPlaying ? _c.pause() : _c.play()),
      child: Stack(alignment: Alignment.center, children: [
        FittedBox(fit: BoxFit.cover, clipBehavior: Clip.hardEdge, child: SizedBox(width: _c.value.size.width, height: _c.value.size.height, child: VideoPlayer(_c))),
        if (widget.showControls && !_c.value.isPlaying) const Icon(Icons.play_circle_fill, size: 64, color: Colors.white70),
      ]),
    );
  }
}

/// One photo or video from the private bucket: it asks storage for a signed address, and shows a quiet placeholder while it waits and if it cannot be shown.
class MediaItemView extends ConsumerWidget {
  const MediaItemView({super.key, required this.media, this.fit = BoxFit.cover, this.autoplay = false, this.loop = false, this.showControls = true});

  final PostMedia media;
  final BoxFit fit;
  final bool autoplay;
  final bool loop;
  final bool showControls;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final placeholder = ColoredBox(color: theme.colorScheme.surfaceContainerHighest, child: Center(child: Icon(media.isVideo ? Icons.videocam_outlined : Icons.image_outlined, color: theme.colorScheme.onSurfaceVariant)));
    final url = ref.watch(signedMediaUrlProvider(media.path));
    return url.when(
      loading: () => placeholder,
      error: (_, __) => placeholder,
      data: (u) {
        if (u == null) return placeholder;
        if (media.isVideo) return ref.watch(postVideoBuilderProvider)(u, autoplay: autoplay, loop: loop, showControls: showControls);
        return NetworkPicture(url: u, radius: 0, fit: fit, width: double.infinity, height: double.infinity);
      },
    );
  }
}

/// A post's photos (swipe through several) or its video, in a frame that is 4 by 5 (a reel is taller).
class PostMediaView extends StatefulWidget {
  const PostMediaView({super.key, required this.post, this.onDoubleTap});

  final SocialPost post;
  final VoidCallback? onDoubleTap;

  @override
  State<PostMediaView> createState() => _PostMediaViewState();
}

class _PostMediaViewState extends State<PostMediaView> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final aspect = post.kind == PostKind.reel ? 9 / 14 : 4 / 5;
    final many = post.media.length > 1;
    return AspectRatio(
      aspectRatio: aspect,
      child: GestureDetector(
        onDoubleTap: widget.onDoubleTap,
        child: Stack(children: [
          PageView(
            key: Key('media-${post.id}'),
            onPageChanged: (i) => setState(() => _page = i),
            children: [for (final m in post.media) MediaItemView(key: Key('media-item-${m.id}'), media: m)],
          ),
          if (many)
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (var i = 0; i < post.media.length; i++)
                  Container(margin: const EdgeInsets.symmetric(horizontal: 2), width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: i == _page ? Colors.white : Colors.white54)),
              ]),
            ),
          if (post.isMembersOnly)
            Positioned(top: 8, right: 8, child: _MembersBadge(key: Key('members-badge-${post.id}'))),
        ]),
      ),
    );
  }
}

class _MembersBadge extends StatelessWidget {
  const _MembersBadge({super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: membersOnlyColor, borderRadius: BorderRadius.circular(12)),
        child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.star, size: 14, color: Colors.white), SizedBox(width: 4), Text('Members Only', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700))]),
      );
}

/// A post as it appears in a feed or on its own page: who posted it and when, the pictures, like / comment / save, the words, the tags.
class PostCardView extends ConsumerStatefulWidget {
  const PostCardView({super.key, required this.actor, required this.post, this.onOpen, this.onDeleted, this.onChanged, this.now, this.showAllComments = false});

  final SocialProfile actor;
  final SocialPost post;

  /// Tapping the comments opens the post's own page. Null on that page.
  final VoidCallback? onOpen;
  final VoidCallback? onDeleted;
  final ValueChanged<SocialPost>? onChanged;
  final DateTime? now;

  /// On the post's own page the comments are listed below, so the "view all" line is not shown.
  final bool showAllComments;

  @override
  ConsumerState<PostCardView> createState() => _PostCardViewState();
}

class _PostCardViewState extends ConsumerState<PostCardView> {
  late bool _liked = widget.post.liked;
  late int _likes = widget.post.likes;
  late bool _saved = widget.post.saved;
  late SocialPost _post = widget.post;
  bool _busy = false;

  @override
  void didUpdateWidget(PostCardView old) {
    super.didUpdateWidget(old);
    if (old.post != widget.post) {
      _post = widget.post;
      _liked = widget.post.liked;
      _likes = widget.post.likes;
      _saved = widget.post.saved;
    }
  }

  void _problem(Object e) {
    final msg = e is SiteException ? e.message : actionFailedMessage;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _toggleLike() async {
    if (_busy) return;
    final want = !_liked;
    setState(() {
      _busy = true;
      _liked = want;
      _likes += want ? 1 : -1;
    });
    try {
      final n = await ref.read(postsServiceProvider).like(actor: widget.actor.id, post: _post.id, liked: want);
      if (mounted) setState(() => _likes = n);
    } catch (e) {
      if (mounted) {
        setState(() {
          _liked = !want;
          _likes += want ? -1 : 1;
        });
        _problem(e);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _toggleSave() async {
    final want = !_saved;
    setState(() => _saved = want);
    try {
      await ref.read(postsServiceProvider).save(actor: widget.actor.id, post: _post.id, saved: want);
    } catch (e) {
      if (mounted) {
        setState(() => _saved = !want);
        _problem(e);
      }
    }
  }

  Future<void> _delete() async {
    final sure = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Delete this post?'),
        content: const Text('It will be removed for everyone, with its likes and comments. This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => c.pop(false), child: const Text('Cancel')),
          FilledButton(key: const Key('confirm-delete-post'), onPressed: () => c.pop(true), child: const Text('Delete')),
        ],
      ),
    );
    if (sure != true || !mounted) return;
    try {
      await ref.read(postsServiceProvider).delete(actor: widget.actor.id, post: _post.id);
      widget.onDeleted?.call();
    } catch (e) {
      if (mounted) _problem(e);
    }
  }

  Future<void> _report() async {
    final result = await showReportSheet(context, actor: widget.actor, kind: ReportKind.post, target: _post.id, alsoBlock: _post.author);
    // A person who was blocked is gone from this feed.
    if (result != null && result.blocked) widget.onDeleted?.call();
  }

  Future<void> _edit() async {
    final updated = await showModalBottomSheet<SocialPost>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _EditSheet(actor: widget.actor, post: _post),
    );
    if (updated != null && mounted) {
      setState(() => _post = updated);
      widget.onChanged?.call(updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = _post;
    final now = widget.now ?? DateTime.now();
    return Column(
      key: Key('post-${p.id}'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          leading: GestureDetector(onTap: () => context.push('/u/${p.author.handle}'), child: ProfileAvatar(profile: p.author, size: 36)),
          title: GestureDetector(
            onTap: () => context.push('/u/${p.author.handle}'),
            child: Row(children: [
              Flexible(child: Text(p.author.displayName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700))),
              if (p.author.verified) ...[const SizedBox(width: 4), const VerifiedTick(size: 14)],
            ]),
          ),
          subtitle: Text('@${p.author.handle} · ${timeAgo(p.createdAt, now)}${p.audience == PostAudience.public ? '' : ' · ${audienceLabel(p.audience)}'}'),
          trailing: p.isMine
              ? PopupMenuButton<String>(
                  key: Key('post-menu-${p.id}'),
                  onSelected: (v) => v == 'edit' ? _edit() : _delete(),
                  itemBuilder: (_) => const [PopupMenuItem(value: 'edit', child: Text('Edit')), PopupMenuItem(value: 'delete', child: Text('Delete'))],
                )
              : PopupMenuButton<String>(
                  key: Key('post-menu-${p.id}'),
                  onSelected: (_) => _report(),
                  itemBuilder: (_) => const [PopupMenuItem(value: 'report', child: Text('Report'))],
                ),
        ),
        PostMediaView(post: p, onDoubleTap: _liked ? null : _toggleLike),
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
          child: Row(children: [
            IconButton(key: Key('like-${p.id}'), tooltip: _liked ? 'Unlike' : 'Like', onPressed: _toggleLike, icon: Icon(_liked ? Icons.favorite : Icons.favorite_border, color: _liked ? Colors.red : null)),
            if (p.commentsEnabled) IconButton(key: Key('comment-${p.id}'), tooltip: 'Comments', onPressed: widget.onOpen, icon: const Icon(Icons.mode_comment_outlined)),
            if (ref.watch(featureOnProvider(Feature.inbox)) && p.audience == PostAudience.public && p.kind != PostKind.story)
              IconButton(
                key: Key('share-${p.id}'),
                tooltip: 'Send',
                onPressed: () async {
                  if (await showShareSheet(context, actor: widget.actor, refKind: 'post', refId: p.id) && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sent.')));
                  }
                },
                icon: const Icon(Icons.send_outlined),
              ),
            const Spacer(),
            IconButton(key: Key('save-${p.id}'), tooltip: _saved ? 'Unsave' : 'Save', onPressed: _toggleSave, icon: Icon(_saved ? Icons.bookmark : Icons.bookmark_border)),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_likes == 1 ? '1 like' : '$_likes likes', key: Key('likes-${p.id}'), style: const TextStyle(fontWeight: FontWeight.w700)),
            if (p.caption != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text.rich(TextSpan(children: [TextSpan(text: '${p.author.handle} ', style: const TextStyle(fontWeight: FontWeight.w700)), TextSpan(text: p.caption)]), key: Key('caption-${p.id}')),
              ),
            if (p.tags.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Wrap(spacing: 6, runSpacing: 0, children: [
                  for (final t in p.tags)
                    ActionChip(
                      key: Key('tag-${t.kind.name}-${t.id}'),
                      visualDensity: VisualDensity.compact,
                      avatar: Icon(switch (t.kind) { TagKind.profile => Icons.person_outline, TagKind.event => Icons.event_outlined, TagKind.venue => Icons.place_outlined }, size: 16),
                      label: Text(t.name),
                      onPressed: () => switch (t.kind) {
                        TagKind.profile => t.handle == null ? null : context.push('/u/${t.handle}'),
                        TagKind.event => context.push('/events/${t.id}'),
                        TagKind.venue => context.push('/venues/${t.id}'),
                      },
                    ),
                ]),
              ),
            if (!widget.showAllComments && p.commentsEnabled && p.comments > 0 && widget.onOpen != null)
              TextButton(
                key: Key('view-comments-${p.id}'),
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 32), alignment: Alignment.centerLeft),
                onPressed: widget.onOpen,
                child: Text(p.comments == 1 ? 'View 1 comment' : 'View all ${p.comments} comments', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
              ),
          ]),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _EditSheet extends ConsumerStatefulWidget {
  const _EditSheet({required this.actor, required this.post});

  final SocialProfile actor;
  final SocialPost post;

  @override
  ConsumerState<_EditSheet> createState() => _EditSheetState();
}

class _EditSheetState extends ConsumerState<_EditSheet> {
  late final TextEditingController _caption = TextEditingController(text: widget.post.caption ?? '');
  late PostAudience _audience = widget.post.audience;
  late bool _comments = widget.post.commentsEnabled;
  bool _saving = false;
  String? _problem;

  @override
  void dispose() {
    _caption.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final problem = captionProblem(_caption.text);
    if (problem != null) {
      setState(() => _problem = problem);
      return;
    }
    setState(() {
      _saving = true;
      _problem = null;
    });
    try {
      final updated = await ref.read(postsServiceProvider).edit(actor: widget.actor.id, post: widget.post.id, caption: _caption.text, audience: _audience, commentsEnabled: _comments);
      if (mounted) Navigator.of(context).pop(updated);
    } on SiteException catch (e) {
      if (mounted) setState(() => _problem = e.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(featureOnProvider('members_only'));
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Edit post', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          TextField(key: const Key('edit-caption'), controller: _caption, maxLines: 4, maxLength: maxCaptionLength, decoration: const InputDecoration(labelText: 'Caption')),
          const SizedBox(height: 8),
          SegmentedButton<PostAudience>(
            key: const Key('edit-audience'),
            segments: [
              for (final a in PostAudience.values)
                if (a != PostAudience.members || members || _audience == PostAudience.members) ButtonSegment(value: a, label: Text(audienceLabel(a))),
            ],
            selected: {_audience},
            onSelectionChanged: (s) => setState(() => _audience = s.first),
          ),
          SwitchListTile(key: const Key('edit-comments'), contentPadding: EdgeInsets.zero, value: _comments, onChanged: (v) => setState(() => _comments = v), title: const Text('Allow comments')),
          if (_problem != null) Text(_problem!, key: const Key('edit-problem'), style: TextStyle(color: Theme.of(context).colorScheme.error)),
          const SizedBox(height: 8),
          FilledButton(key: const Key('save-edit'), onPressed: _saving ? null : _save, child: Text(_saving ? 'Saving...' : 'Save')),
        ]),
      ),
    );
  }
}

/// A square in a profile's grid. A video shows a play badge.
class PostGridTile extends ConsumerWidget {
  const PostGridTile({super.key, required this.post, required this.onTap});

  final SocialPost post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final first = post.media.first;
    final theme = Theme.of(context);
    return GestureDetector(
      key: Key('grid-${post.id}'),
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Stack(fit: StackFit.expand, children: [
        first.isVideo ? ColoredBox(color: theme.colorScheme.surfaceContainerHighest) : MediaItemView(media: first),
        if (first.isVideo) const Center(child: Icon(Icons.play_circle_outline, color: Colors.white, size: 36)),
        if (post.media.length > 1) const Positioned(top: 6, right: 6, child: Icon(Icons.collections, color: Colors.white, size: 18)),
        if (post.isMembersOnly) const Positioned(top: 6, left: 6, child: Icon(Icons.star, color: membersOnlyColor, size: 18)),
      ]),
    );
  }
}
