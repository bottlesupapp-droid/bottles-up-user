import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/site_error.dart';
import '../widgets/profile_widgets.dart';

const int _pageSize = 30;

/// Who follows a profile, or whom it follows, newest first, a page at a time. A private profile keeps this for its approved followers: the website says so in a sentence that is shown.
class PeopleListScreen extends ConsumerStatefulWidget {
  const PeopleListScreen({super.key, required this.profileId, required this.followers});

  final String profileId;
  final bool followers;

  @override
  ConsumerState<PeopleListScreen> createState() => _PeopleListScreenState();
}

class _PeopleListScreenState extends ConsumerState<PeopleListScreen> {
  final List<SocialProfile> _items = [];
  String? _error;
  bool _loading = true;
  bool _more = false;
  bool _started = false;
  String? _forActor;

  Future<void> _load(String actor, {bool next = false}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final page = await ref.read(socialProfilesServiceProvider).people(
            actor: actor,
            profile: widget.profileId,
            followers: widget.followers,
            before: next && _items.isNotEmpty ? _items.last.at : null,
          );
      if (!mounted) return;
      setState(() {
        if (!next) _items.clear();
        _items.addAll(page);
        _more = page.length >= _pageSize;
      });
    } on SiteException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.followers ? 'Followers' : 'Following';
    return ActorGate(
      title: title,
      builder: (context, actor) {
        if (!_started || _forActor != actor.id) {
          _started = true;
          _forActor = actor.id;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _load(actor.id);
          });
        }
        return Scaffold(
          appBar: AppBar(title: Text(title)),
          body: _body(actor),
        );
      },
    );
  }

  Widget _body(SocialProfile actor) {
    if (_error != null && _items.isEmpty) return LoadFailed(message: _error!, onRetry: () => _load(actor.id));
    if (_loading && _items.isEmpty) return const Center(child: CircularProgressIndicator());
    if (_items.isEmpty) {
      return EmptyState(
        icon: Icons.people_outline,
        title: widget.followers ? 'No followers yet' : 'Not following anyone yet',
        text: widget.followers ? 'People who follow this profile will show here.' : 'Profiles it follows will show here.',
      );
    }
    return ListView(key: const Key('people-list'), padding: const EdgeInsets.only(bottom: 96), children: [
      for (final p in _items)
        ProfileTile(
          profile: p,
          onTap: () => context.push('/u/${p.handle}'),
          trailing: p.isMine ? null : SizedBox(width: 120, child: FollowButton(actor: actor, profile: p, compact: true)),
        ),
      if (_error != null) Padding(padding: const EdgeInsets.all(16), child: Text(_error!, textAlign: TextAlign.center)),
      if (_more)
        Padding(
          padding: const EdgeInsets.all(16),
          child: OutlinedButton(key: const Key('show-more'), onPressed: _loading ? null : () => _load(actor.id, next: true), child: Text(_loading ? 'Loading...' : 'Show more')),
        ),
    ]);
  }
}
