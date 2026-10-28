import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/features.dart';
import '../../../site/models/jobs.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/site_error.dart';
import '../../social/widgets/profile_widgets.dart';
import '../widgets/job_widgets.dart';

const int jobsPageSize = 20;

/// Opportunities: jobs, shifts, gigs and collaborations that businesses on BottlesUp have posted. Filter by kind or by remote, search by words, read a listing and apply. Applying is free.
class OpportunitiesScreen extends ConsumerStatefulWidget {
  const OpportunitiesScreen({super.key});

  @override
  ConsumerState<OpportunitiesScreen> createState() => _OpportunitiesScreenState();
}

class _OpportunitiesScreenState extends ConsumerState<OpportunitiesScreen> {
  final _search = TextEditingController();
  JobKind? _kind;
  bool _remote = false;
  String _query = '';
  final List<Job> _more = [];
  bool _end = false;
  bool _loadingMore = false;
  String? _problem;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _reset() {
    _more.clear();
    _end = false;
    _problem = null;
  }

  Future<void> _loadMore(String actor, List<Job> first) async {
    if (_loadingMore) return;
    final all = [...first, ..._more];
    if (all.isEmpty) return;
    setState(() {
      _loadingMore = true;
      _problem = null;
    });
    try {
      final page = await ref.read(jobsServiceProvider).list(
            actor: actor,
            kind: _kind,
            query: _query,
            remote: _remote ? true : null,
            before: all.last.createdAt,
            beforeId: all.last.id,
            limit: jobsPageSize,
          );
      if (!mounted) return;
      setState(() {
        _more.addAll(page);
        if (page.length < jobsPageSize) _end = true;
      });
    } on SiteException catch (e) {
      if (mounted) setState(() => _problem = e.message);
    } finally {
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Opportunities';
    if (!ref.watch(featureOnProvider(Feature.jobs))) {
      return Scaffold(appBar: AppBar(title: const Text(title)), body: const EmptyState(icon: Icons.hourglass_empty, title: 'Coming soon', text: 'Jobs are not open yet.'));
    }
    return ActorGate(
      title: title,
      builder: (context, actor) {
        final query = JobsQuery(actor: actor.id, kind: _kind, query: _query.isEmpty ? null : _query, remote: _remote ? true : null);
        final first = ref.watch(jobsListProvider(query));
        return Scaffold(
          appBar: AppBar(
            title: const Text(title),
            actions: [
              IconButton(key: const Key('open-my-applications'), tooltip: 'My applications', icon: const Icon(Icons.assignment_outlined), onPressed: () => context.push('/me/applications')),
              if (actor.isBusiness) IconButton(key: const Key('open-my-jobs'), tooltip: 'My jobs', icon: const Icon(Icons.work_outline), onPressed: () => context.push('/me/jobs')),
            ],
          ),
          body: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: TextField(
                key: const Key('jobs-search'),
                controller: _search,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search jobs, places, skills',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _query.isEmpty ? null : IconButton(key: const Key('jobs-search-clear'), icon: const Icon(Icons.close), onPressed: () => setState(() { _search.clear(); _query = ''; _reset(); })),
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                onSubmitted: (v) => setState(() { _query = v.trim(); _reset(); }),
              ),
            ),
            SizedBox(
              height: 48,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(children: [
                  _chip('All', const Key('kind-all'), _kind == null, () => setState(() { _kind = null; _reset(); })),
                  for (final k in JobKind.values) _chip(k.label, Key('kind-${k.wire}'), _kind == k, () => setState(() { _kind = k; _reset(); })),
                  _chip('Remote', const Key('kind-remote'), _remote, () => setState(() { _remote = !_remote; _reset(); })),
                ]),
              ),
            ),
            Expanded(
              child: first.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('the jobs'), onRetry: () => ref.invalidate(jobsListProvider(query))),
                data: (list) {
                  if (list.isEmpty) {
                    return EmptyState(icon: Icons.work_outline, title: 'No jobs here', text: _query.isNotEmpty || _kind != null || _remote ? 'Nothing matches. Try other words or take a filter off.' : 'No business has posted a job yet. Check again soon.');
                  }
                  final all = [...list, ..._more];
                  final canMore = !_end && list.length >= jobsPageSize;
                  return RefreshIndicator(
                    onRefresh: () async {
                      _reset();
                      ref.invalidate(jobsListProvider(query));
                      await ref.read(jobsListProvider(query).future);
                    },
                    child: ListView(children: [
                      for (final j in all) JobCard(job: j, onTap: () => context.push('/jobs/${j.id}')),
                      if (_problem != null) Padding(padding: const EdgeInsets.all(16), child: Text(_problem!, key: const Key('jobs-problem'))),
                      if (canMore) Padding(padding: const EdgeInsets.all(16), child: OutlinedButton(key: const Key('jobs-more'), onPressed: _loadingMore ? null : () => _loadMore(actor.id, list), child: Text(_loadingMore ? 'Loading...' : 'Show more'))),
                      const SizedBox(height: 24),
                    ]),
                  );
                },
              ),
            ),
          ]),
        );
      },
    );
  }

  Widget _chip(String label, Key key, bool selected, VoidCallback onTap) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: ChoiceChip(key: key, label: Text(label), selected: selected, onSelected: (_) => onTap()),
      );
}
