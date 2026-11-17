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

/// The jobs a business profile has posted, with how many people applied and how many are waiting for an answer. Posting is for a business profile; the website checks the person's role.
class MyJobsScreen extends ConsumerWidget {
  const MyJobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const title = 'My jobs';
    if (!ref.watch(featureOnProvider(Feature.jobs))) {
      return Scaffold(appBar: AppBar(title: const Text(title)), body: const EmptyState(icon: Icons.hourglass_empty, title: 'Coming soon', text: 'Jobs are not open yet.'));
    }
    return ActorGate(
      title: title,
      builder: (context, actor) {
        if (!actor.isBusiness) {
          return Scaffold(
            appBar: AppBar(title: const Text(title)),
            body: const EmptyState(icon: Icons.work_outline, title: 'Switch to a business profile', text: 'Jobs are posted by a business profile (a venue, an event group, a professional). Switch to yours from the Profile tab.'),
          );
        }
        final jobs = ref.watch(jobsMineProvider(actor.id));
        return Scaffold(
          appBar: AppBar(title: Text('Jobs of ${actor.displayName}')),
          floatingActionButton: FloatingActionButton.extended(key: const Key('post-job'), onPressed: () => context.push('/me/jobs/new?as=${actor.id}'), icon: const Icon(Icons.add), label: const Text('Post a job')),
          body: jobs.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('your jobs'), onRetry: () => ref.invalidate(jobsMineProvider(actor.id))),
            data: (list) {
              if (list.isEmpty) return const EmptyState(icon: Icons.work_outline, title: 'No jobs yet', text: 'Post a job, shift or gig and people on BottlesUp can apply. Applying is free for them.');
              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(jobsMineProvider(actor.id));
                  await ref.read(jobsMineProvider(actor.id).future);
                },
                child: ListView(padding: const EdgeInsets.only(bottom: 88), children: [for (final Job j in list) JobCard(job: j, showCounts: true, onTap: () => context.push('/jobs/${j.id}'))]),
              );
            },
          ),
        );
      },
    );
  }
}
