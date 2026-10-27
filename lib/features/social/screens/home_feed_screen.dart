import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/features.dart';
import '../../../site/models/post.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/site_error.dart';
import '../widgets/post_widgets.dart';
import '../widgets/profile_widgets.dart';
import '../widgets/story_rail.dart';

const int _feedPage = 20;

/// The home feed: stories on top, then posts and reels from the profiles you follow (and your own), newest first, then a few popular public posts you might like.
class HomeFeedScreen extends ConsumerStatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  ConsumerState<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends ConsumerState<HomeFeedScreen> {
  final List<SocialPost> _posts = [];
  List<SocialPost> _suggested = const [];
  bool _loading = true;
  bool _more = false;
  bool _started = false;
  String? _error;
  String? _forActor;

  Future<void> _load(SocialProfile actor, {bool next = false}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final service = ref.read(postsServiceProvider);
    try {
      final page = await service.feed(actor: actor.id, limit: _feedPage, after: next && _posts.isNotEmpty ? _posts.last : null);
      if (!mounted) return;
      setState(() {
        if (!next) _posts.clear();
        _posts.addAll(page);
        _more = page.length >= _feedPage;
      });
      if (!next) {
        // Suggestions are a nicety: a failure to read them never hides the feed.
        try {
          final s = await service.suggested(actor: actor.id);
          if (mounted) setState(() => _suggested = s);
        } on SiteException {
          if (mounted) setState(() => _suggested = const []);
        }
      }
    } on SiteException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _refresh(SocialProfile actor) async {
    ref.invalidate(storyRailProvider(actor.id));
    await _load(actor);
  }

  @override
  Widget build(BuildContext context) {
    return ActorGate(
      title: 'Home',
      builder: (context, actor) {
        if (!_started || _forActor != actor.id) {
          _started = true;
          _forActor = actor.id;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _load(actor);
          });
        }
        final reelsOn = ref.watch(featureOnProvider(Feature.reels));
        return Scaffold(
          appBar: AppBar(
            title: const Text('BottlesUp'),
            actions: [
              if (reelsOn) IconButton(key: const Key('open-reels'), tooltip: 'Reels', icon: const Icon(Icons.play_circle_outline), onPressed: () => context.push('/reels')),
              IconButton(key: const Key('open-search'), tooltip: 'Find people', icon: const Icon(Icons.search), onPressed: () => context.push('/people')),
              IconButton(key: const Key('open-create'), tooltip: 'Create', icon: const Icon(Icons.add_box_outlined), onPressed: () => context.push('/create')),
            ],
          ),
          body: _body(context, actor),
        );
      },
    );
  }

  Widget _body(BuildContext context, SocialProfile actor) {
    if (_error != null && _posts.isEmpty) return LoadFailed(message: _error!, onRetry: () => _load(actor));
    if (_loading && _posts.isEmpty) return const Center(child: CircularProgressIndicator());
    final shown = [for (final s in _suggested) if (!_posts.any((p) => p.id == s.id)) s];
    return RefreshIndicator(
      onRefresh: () => _refresh(actor),
      child: ListView(
        key: const Key('home-feed'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 96),
        children: [
          StoryRail(actor: actor),
          if (_posts.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              child: Column(key: const Key('empty-feed'), children: [
                const Icon(Icons.dynamic_feed_outlined, size: 40),
                const SizedBox(height: 8),
                Text('Your feed is quiet', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                const Text('Follow people and venues to see their posts here, or share something yourself.', textAlign: TextAlign.center),
                const SizedBox(height: 12),
                Wrap(spacing: 8, children: [
                  FilledButton(key: const Key('empty-find'), onPressed: () => context.push('/people'), child: const Text('Find people')),
                  OutlinedButton(key: const Key('empty-create'), onPressed: () => context.push('/create'), child: const Text('Create a post')),
                ]),
              ]),
            ),
          for (final p in _posts)
            PostCardView(
              key: ValueKey('card-${p.id}'),
              actor: actor,
              post: p,
              onOpen: () => context.push('/post/${p.id}'),
              onDeleted: () => setState(() => _posts.removeWhere((x) => x.id == p.id)),
              onChanged: (u) => setState(() {
                final i = _posts.indexWhere((x) => x.id == p.id);
                if (i >= 0) _posts[i] = u;
              }),
            ),
          if (_error != null) Padding(padding: const EdgeInsets.all(16), child: Text(_error!, textAlign: TextAlign.center)),
          if (_more)
            Padding(
              padding: const EdgeInsets.all(16),
              child: OutlinedButton(key: const Key('feed-more'), onPressed: _loading ? null : () => _load(actor, next: true), child: Text(_loading ? 'Loading...' : 'Show more')),
            ),
          if (shown.isNotEmpty) ...[
            Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 8), child: Text('Suggested for you', key: const Key('suggested-heading'), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800))),
            for (final p in shown) PostCardView(key: ValueKey('suggested-${p.id}'), actor: actor, post: p, onOpen: () => context.push('/post/${p.id}')),
          ],
        ],
      ),
    );
  }
}
