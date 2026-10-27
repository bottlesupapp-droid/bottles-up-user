import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/post.dart';
import '../../../site/models/safety.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/post_rules.dart';
import '../../../site/site_error.dart';
import '../widgets/post_widgets.dart';
import '../widgets/profile_widgets.dart';
import '../widgets/report_sheet.dart';

/// How long a photo stays up before the next story. A video stays up as long as it runs.
const Duration storyPhotoTime = Duration(seconds: 5);

/// A profile's stories one after another, full screen. Tap the right side for the next, the left for the one before, hold to pause. Watching marks a story as seen (the ring goes
/// grey); nobody is told who watched.
class StoryViewerScreen extends ConsumerWidget {
  const StoryViewerScreen({super.key, required this.handle});

  final String handle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ActorGate(
      title: 'Story',
      builder: (context, actor) {
        final profile = ref.watch(socialProfileProvider(ProfileKey(actor: actor.id, handle: handle)));
        return profile.when(
          loading: () => const Scaffold(backgroundColor: Colors.black, body: Center(child: CircularProgressIndicator())),
          error: (e, _) => Scaffold(appBar: AppBar(), body: LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('that story'), onRetry: () => ref.invalidate(socialProfileProvider))),
          data: (p) {
            final stories = ref.watch(storiesOfProvider(PeopleKey(actor: actor.id, profile: p.id, followers: true)));
            return stories.when(
              loading: () => const Scaffold(backgroundColor: Colors.black, body: Center(child: CircularProgressIndicator())),
              error: (e, _) => Scaffold(appBar: AppBar(), body: LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('that story'), onRetry: () => ref.invalidate(storiesOfProvider))),
              data: (list) => list.isEmpty
                  ? Scaffold(appBar: AppBar(), body: const EmptyState(icon: Icons.history_toggle_off, title: 'No story right now', text: 'Stories last 24 hours.'))
                  : _Viewer(actor: actor, owner: p, stories: list),
            );
          },
        );
      },
    );
  }
}

class _Viewer extends ConsumerStatefulWidget {
  const _Viewer({required this.actor, required this.owner, required this.stories});

  final SocialProfile actor;
  final SocialProfile owner;
  final List<SocialPost> stories;

  @override
  ConsumerState<_Viewer> createState() => _ViewerState();
}

class _ViewerState extends ConsumerState<_Viewer> with SingleTickerProviderStateMixin {
  late final AnimationController _timer = AnimationController(vsync: this);
  late int _index = () {
    final firstUnseen = widget.stories.indexWhere((s) => !s.seen);
    return firstUnseen < 0 ? 0 : firstUnseen;
  }();
  late List<SocialPost> _stories = [...widget.stories];

  @override
  void initState() {
    super.initState();
    _timer.addStatusListener((s) {
      if (s == AnimationStatus.completed) _next();
    });
    _show();
  }

  @override
  void dispose() {
    _timer.dispose();
    super.dispose();
  }

  SocialPost get _story => _stories[_index];

  void _show() {
    final s = _story;
    final video = s.media.first.isVideo;
    final ms = video ? (s.media.first.durationMs ?? 15000).clamp(1000, maxVideoMillis) : storyPhotoTime.inMilliseconds;
    _timer
      ..duration = Duration(milliseconds: ms)
      ..forward(from: 0);
    if (!s.seen) {
      ref.read(postsServiceProvider).storySeen(actor: widget.actor.id, story: s.id);
    }
  }

  void _close() {
    ref.invalidate(storyRailProvider(widget.actor.id));
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/');
    }
  }

  void _next() {
    if (_index >= _stories.length - 1) {
      _close();
      return;
    }
    setState(() => _index++);
    _show();
  }

  void _previous() {
    if (_index == 0) {
      _timer.forward(from: 0);
      return;
    }
    setState(() => _index--);
    _show();
  }

  Future<void> _report(SocialPost s) async {
    _timer.stop();
    final result = await showReportSheet(context, actor: widget.actor, kind: ReportKind.post, target: s.id, alsoBlock: widget.owner);
    if (!mounted) return;
    if (result != null && result.blocked) {
      _close();
    } else {
      _timer.forward();
    }
  }

  Future<void> _delete() async {
    _timer.stop();
    final sure = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Delete this story?'),
        actions: [
          TextButton(onPressed: () => c.pop(false), child: const Text('Cancel')),
          FilledButton(key: const Key('confirm-delete-story'), onPressed: () => c.pop(true), child: const Text('Delete')),
        ],
      ),
    );
    if (sure != true) {
      _timer.forward();
      return;
    }
    try {
      await ref.read(postsServiceProvider).delete(actor: widget.actor.id, post: _story.id);
      if (!mounted) return;
      final gone = _story.id;
      if (_stories.length == 1) {
        _close();
        return;
      }
      setState(() {
        _stories = [for (final s in _stories) if (s.id != gone) s];
        if (_index >= _stories.length) _index = _stories.length - 1;
      });
      _show();
    } on SiteException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
        _timer.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = _story;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          key: const Key('story-surface'),
          behavior: HitTestBehavior.opaque,
          onTapUp: (d) => d.localPosition.dx < MediaQuery.of(context).size.width / 3 ? _previous() : _next(),
          onLongPressStart: (_) => _timer.stop(),
          onLongPressEnd: (_) => _timer.forward(),
          child: Stack(children: [
            Positioned.fill(child: MediaItemView(key: ValueKey('story-media-${s.id}'), media: s.media.first, fit: BoxFit.contain, autoplay: true, showControls: false)),
            Positioned(
              top: 8,
              left: 8,
              right: 8,
              child: Column(children: [
                Row(children: [
                  for (var i = 0; i < _stories.length; i++)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: i == _index
                            ? AnimatedBuilder(animation: _timer, builder: (_, __) => LinearProgressIndicator(key: const Key('story-progress-current'), value: _timer.value, minHeight: 3, backgroundColor: Colors.white24, color: Colors.white))
                            : LinearProgressIndicator(key: Key('story-progress-$i'), value: i < _index ? 1 : 0, minHeight: 3, backgroundColor: Colors.white24, color: Colors.white),
                      ),
                    ),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  ProfileAvatar(profile: widget.owner, size: 32),
                  const SizedBox(width: 8),
                  Expanded(child: Text('${widget.owner.displayName}  ${timeAgo(s.createdAt, DateTime.now())}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
                  if (s.isMembersOnly)
                    Container(key: const Key('story-members-badge'), margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: membersOnlyColor, borderRadius: BorderRadius.circular(10)), child: const Text('Members Only', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700))),
                  if (!s.isMine) IconButton(key: const Key('report-story'), tooltip: 'Report', icon: const Icon(Icons.flag_outlined, color: Colors.white), onPressed: () => _report(s)),
                  if (s.isMine) IconButton(key: const Key('delete-story'), tooltip: 'Delete story', icon: const Icon(Icons.delete_outline, color: Colors.white), onPressed: _delete),
                  IconButton(key: const Key('close-story'), tooltip: 'Close', icon: const Icon(Icons.close, color: Colors.white), onPressed: _close),
                ]),
              ]),
            ),
            if (s.caption != null) Positioned(left: 16, right: 16, bottom: 24, child: Text(s.caption!, key: const Key('story-caption'), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16, shadows: [Shadow(blurRadius: 6)]))),
          ]),
        ),
      ),
    );
  }
}
