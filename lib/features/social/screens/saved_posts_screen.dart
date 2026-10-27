import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/post.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/site_error.dart';
import '../widgets/post_widgets.dart';
import '../widgets/profile_widgets.dart';

/// The posts the person saved, newest save first. A post they can no longer see is not listed.
class SavedPostsScreen extends ConsumerStatefulWidget {
  const SavedPostsScreen({super.key});

  @override
  ConsumerState<SavedPostsScreen> createState() => _SavedPostsScreenState();
}

class _SavedPostsScreenState extends ConsumerState<SavedPostsScreen> {
  final List<SocialPost> _posts = [];
  DateTime? _last;
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
    try {
      final page = await ref.read(postsServiceProvider).savedPosts(actor: actor.id, limit: 30, before: next ? _last : null);
      if (!mounted) return;
      setState(() {
        if (!next) _posts.clear();
        _posts.addAll(page);
        _more = page.length >= 30;
        _last = page.isEmpty ? _last : page.last.savedAt;
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
      title: 'Saved',
      builder: (context, actor) {
        if (!_started || _forActor != actor.id) {
          _started = true;
          _forActor = actor.id;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _load(actor);
          });
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Saved')),
          body: _error != null && _posts.isEmpty
              ? LoadFailed(message: _error!, onRetry: () => _load(actor))
              : _loading && _posts.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _posts.isEmpty
                      ? const EmptyState(icon: Icons.bookmark_border, title: 'Nothing saved yet', text: 'Tap the bookmark on a post to keep it here.')
                      : ListView(key: const Key('saved-list'), padding: const EdgeInsets.only(bottom: 96), children: [
                          for (final p in _posts)
                            PostCardView(
                              key: ValueKey('saved-${p.id}'),
                              actor: actor,
                              post: p,
                              onOpen: () => context.push('/post/${p.id}'),
                              onDeleted: () => setState(() => _posts.removeWhere((x) => x.id == p.id)),
                            ),
                          if (_more) Padding(padding: const EdgeInsets.all(16), child: OutlinedButton(key: const Key('saved-more'), onPressed: _loading ? null : () => _load(actor, next: true), child: Text(_loading ? 'Loading...' : 'Show more'))),
                        ]),
        );
      },
    );
  }
}
