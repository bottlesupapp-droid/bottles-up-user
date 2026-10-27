import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../site/models/post.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/site_error.dart';
import 'post_widgets.dart';

/// A profile's posts and reels as a grid of squares, with how many there are. Posts and Reels can be told apart.
class ProfileGrid extends ConsumerStatefulWidget {
  const ProfileGrid({super.key, required this.actor, required this.profile});

  final SocialProfile actor;
  final SocialProfile profile;

  @override
  ConsumerState<ProfileGrid> createState() => _ProfileGridState();
}

class _ProfileGridState extends ConsumerState<ProfileGrid> {
  final List<SocialPost> _items = [];
  PostKind? _kind;
  int _total = 0;
  bool _loading = true;
  bool _more = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool next = false}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final r = await ref.read(postsServiceProvider).profilePosts(actor: widget.actor.id, profile: widget.profile.id, kind: _kind, limit: 30, after: next && _items.isNotEmpty ? _items.last : null);
      if (!mounted) return;
      setState(() {
        if (!next) _items.clear();
        _items.addAll(r.items);
        _total = r.total;
        _more = r.items.length >= 30;
      });
    } on SiteException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(key: const Key('profile-grid'), crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text(_total == 1 ? '1 post' : '$_total posts', key: const Key('grid-total'), style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
        const Spacer(),
        SegmentedButton<PostKind?>(
          key: const Key('grid-kind'),
          showSelectedIcon: false,
          style: const ButtonStyle(visualDensity: VisualDensity.compact),
          segments: const [ButtonSegment(value: null, label: Text('All')), ButtonSegment(value: PostKind.post, label: Text('Photos')), ButtonSegment(value: PostKind.reel, label: Text('Reels'))],
          selected: {_kind},
          onSelectionChanged: (s) {
            setState(() => _kind = s.first);
            _load();
          },
        ),
      ]),
      const SizedBox(height: 8),
      if (_error != null) Padding(padding: const EdgeInsets.all(8), child: Text(_error!, key: const Key('grid-error'))),
      if (_loading && _items.isEmpty) const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator())),
      if (!_loading && _error == null && _items.isEmpty) const Padding(padding: EdgeInsets.all(24), child: Center(child: Text('No posts yet.', key: Key('grid-empty')))),
      if (_items.isNotEmpty)
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          children: [for (final p in _items) PostGridTile(post: p, onTap: () => context.push('/post/${p.id}'))],
        ),
      if (_more) Padding(padding: const EdgeInsets.all(8), child: Center(child: OutlinedButton(key: const Key('grid-more'), onPressed: _loading ? null : () => _load(next: true), child: const Text('Show more')))),
    ]);
  }
}
