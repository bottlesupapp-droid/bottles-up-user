import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/site_error.dart';
import '../widgets/profile_widgets.dart';

/// Find people and businesses by the start of a username or a name.
class PeopleSearchScreen extends ConsumerStatefulWidget {
  const PeopleSearchScreen({super.key});

  @override
  ConsumerState<PeopleSearchScreen> createState() => _PeopleSearchScreenState();
}

class _PeopleSearchScreenState extends ConsumerState<PeopleSearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _changed(String text) {
    _debounce?.cancel();
    // Wait until the typing pauses, so one search is made for a word, not for every letter.
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) setState(() => _query = text.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return ActorGate(
      title: 'Find people',
      builder: (context, actor) {
        return Scaffold(
          appBar: AppBar(
            title: TextField(
              key: const Key('people-search-field'),
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(hintText: 'Search people and businesses', border: InputBorder.none),
              onChanged: _changed,
            ),
          ),
          body: _query.length < 2
              ? const EmptyState(icon: Icons.search, title: 'Search BottlesUp', text: 'Type at least 2 letters of a username or a name.')
              : Consumer(builder: (context, ref, _) {
                  final results = ref.watch(profileSearchProvider(SearchKey(actor: actor.id, query: _query)));
                  return results.when(
                    skipLoadingOnRefresh: true,
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('the results'), onRetry: () => ref.invalidate(profileSearchProvider)),
                    data: (list) => list.isEmpty
                        ? EmptyState(icon: Icons.person_search_outlined, title: 'No one found', text: 'Nothing matches "$_query".')
                        : ListView(key: const Key('search-results'), padding: const EdgeInsets.only(bottom: 96), children: [
                            for (final p in list)
                              ProfileTile(
                                profile: p,
                                onTap: () => context.push('/u/${p.handle}'),
                                trailing: p.isMine ? null : SizedBox(width: 120, child: FollowButton(actor: actor, profile: p, compact: true)),
                              ),
                          ]),
                  );
                }),
        );
      },
    );
  }
}
