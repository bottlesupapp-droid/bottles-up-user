import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/post.dart';
import '../../../site/models/safety.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/site_error.dart';
import '../widgets/post_widgets.dart';
import '../widgets/profile_widgets.dart';
import '../widgets/report_sheet.dart';

const int _reelPage = 10;

/// Reels, one full screen at a time, swiped up and down. The one on screen plays.
class ReelsScreen extends ConsumerStatefulWidget {
  const ReelsScreen({super.key});

  @override
  ConsumerState<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends ConsumerState<ReelsScreen> {
  final List<SocialPost> _reels = [];
  final _controller = PageController();
  int _page = 0;
  bool _loading = true;
  bool _more = true;
  bool _started = false;
  String? _error;
  String? _forActor;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _load(SocialProfile actor, {bool next = false}) async {
    if (next && (!_more || _loading)) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final page = await ref.read(postsServiceProvider).reels(actor: actor.id, limit: _reelPage, after: next && _reels.isNotEmpty ? _reels.last : null);
      if (!mounted) return;
      setState(() {
        if (!next) _reels.clear();
        _reels.addAll(page);
        _more = page.length >= _reelPage;
      });
    } on SiteException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ActorGate(
      title: 'Reels',
      builder: (context, actor) {
        if (!_started || _forActor != actor.id) {
          _started = true;
          _forActor = actor.id;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _load(actor);
          });
        }
        if (_error != null && _reels.isEmpty) return Scaffold(appBar: AppBar(title: const Text('Reels')), body: LoadFailed(message: _error!, onRetry: () => _load(actor)));
        if (_loading && _reels.isEmpty) return Scaffold(appBar: AppBar(title: const Text('Reels')), body: const Center(child: CircularProgressIndicator()));
        if (_reels.isEmpty) {
          return Scaffold(appBar: AppBar(title: const Text('Reels')), body: const EmptyState(icon: Icons.play_circle_outline, title: 'No reels yet', text: 'Short videos from people and venues will show here.'));
        }
        return Scaffold(
          backgroundColor: Colors.black,
          extendBodyBehindAppBar: true,
          appBar: AppBar(backgroundColor: Colors.transparent, foregroundColor: Colors.white, elevation: 0, title: const Text('Reels')),
          body: PageView.builder(
            key: const Key('reels-pager'),
            controller: _controller,
            scrollDirection: Axis.vertical,
            itemCount: _reels.length,
            onPageChanged: (i) {
              setState(() => _page = i);
              if (i >= _reels.length - 3) _load(actor, next: true);
            },
            itemBuilder: (context, i) => _ReelPage(key: ValueKey('reel-${_reels[i].id}'), actor: actor, reel: _reels[i], active: i == _page),
          ),
        );
      },
    );
  }
}

class _ReelPage extends ConsumerStatefulWidget {
  const _ReelPage({super.key, required this.actor, required this.reel, required this.active});

  final SocialProfile actor;
  final SocialPost reel;
  final bool active;

  @override
  ConsumerState<_ReelPage> createState() => _ReelPageState();
}

class _ReelPageState extends ConsumerState<_ReelPage> {
  late bool _liked = widget.reel.liked;
  late int _likes = widget.reel.likes;
  late bool _saved = widget.reel.saved;

  Future<void> _like() async {
    final want = !_liked;
    setState(() {
      _liked = want;
      _likes += want ? 1 : -1;
    });
    try {
      final n = await ref.read(postsServiceProvider).like(actor: widget.actor.id, post: widget.reel.id, liked: want);
      if (mounted) setState(() => _likes = n);
    } on SiteException catch (e) {
      if (mounted) {
        setState(() {
          _liked = !want;
          _likes += want ? -1 : 1;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  Future<void> _report() async {
    final result = await showReportSheet(context, actor: widget.actor, kind: ReportKind.post, target: widget.reel.id, alsoBlock: widget.reel.author);
    if (result != null && result.blocked && mounted && context.canPop()) context.pop();
  }

  Future<void> _save() async {
    final want = !_saved;
    setState(() => _saved = want);
    try {
      await ref.read(postsServiceProvider).save(actor: widget.actor.id, post: widget.reel.id, saved: want);
    } on SiteException catch (e) {
      if (mounted) {
        setState(() => _saved = !want);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.reel;
    return Stack(fit: StackFit.expand, children: [
      MediaItemView(media: r.media.first, fit: BoxFit.cover, autoplay: widget.active, loop: true, showControls: false),
      Positioned(
        right: 8,
        bottom: 96,
        child: Column(children: [
          IconButton(key: Key('reel-like-${r.id}'), onPressed: _like, icon: Icon(_liked ? Icons.favorite : Icons.favorite_border, color: _liked ? Colors.red : Colors.white, size: 32)),
          Text('$_likes', key: Key('reel-likes-${r.id}'), style: const TextStyle(color: Colors.white)),
          if (r.commentsEnabled) IconButton(key: Key('reel-comments-${r.id}'), onPressed: () => context.push('/post/${r.id}'), icon: const Icon(Icons.mode_comment_outlined, color: Colors.white, size: 30)),
          if (r.commentsEnabled) Text('${r.comments}', style: const TextStyle(color: Colors.white)),
          IconButton(key: Key('reel-save-${r.id}'), onPressed: _save, icon: Icon(_saved ? Icons.bookmark : Icons.bookmark_border, color: Colors.white, size: 30)),
          if (!r.isMine) IconButton(key: Key('reel-report-${r.id}'), tooltip: 'Report', onPressed: _report, icon: const Icon(Icons.flag_outlined, color: Colors.white, size: 28)),
        ]),
      ),
      Positioned(
        left: 16,
        right: 80,
        bottom: 32,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          GestureDetector(
            onTap: () => context.push('/u/${r.author.handle}'),
            child: Row(children: [
              ProfileAvatar(profile: r.author, size: 32),
              const SizedBox(width: 8),
              Flexible(child: Text('@${r.author.handle}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
              if (r.author.verified) ...[const SizedBox(width: 4), const VerifiedTick(size: 14)],
            ]),
          ),
          if (r.caption != null) Padding(padding: const EdgeInsets.only(top: 6), child: Text(r.caption!, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white))),
        ]),
      ),
    ]);
  }
}
