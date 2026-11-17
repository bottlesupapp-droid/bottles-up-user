import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/features.dart';
import '../../../site/models/jobs.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/jobs_rules.dart';
import '../../../site/site_error.dart';
import '../../social/widgets/profile_widgets.dart';
import '../widgets/job_widgets.dart';

/// The jobs the profile the person is acting as has applied for, with where each stands and the business's reply. Tap one to open the job.
class MyApplicationsScreen extends ConsumerWidget {
  const MyApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const title = 'My applications';
    if (!ref.watch(featureOnProvider(Feature.jobs))) {
      return Scaffold(appBar: AppBar(title: const Text(title)), body: const EmptyState(icon: Icons.hourglass_empty, title: 'Coming soon', text: 'Jobs are not open yet.'));
    }
    return ActorGate(
      title: title,
      builder: (context, actor) {
        final list = ref.watch(myApplicationsProvider(actor.id));
        return Scaffold(
          appBar: AppBar(title: const Text(title)),
          body: list.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('your applications'), onRetry: () => ref.invalidate(myApplicationsProvider(actor.id))),
            data: (items) {
              if (items.isEmpty) return const EmptyState(icon: Icons.assignment_outlined, title: 'No applications yet', text: 'Find a job in Opportunities and apply. Applying is free.');
              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(myApplicationsProvider(actor.id));
                  await ref.read(myApplicationsProvider(actor.id).future);
                },
                child: ListView(padding: const EdgeInsets.symmetric(vertical: 8), children: [for (final a in items) _tile(context, a)]),
              );
            },
          ),
        );
      },
    );
  }

  Widget _tile(BuildContext context, JobApplication a) {
    final theme = Theme.of(context);
    return Card(
      key: Key('my-application-${a.id}'),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: () => context.push('/jobs/${a.job.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              ProfileAvatar(profile: a.job.poster, size: 36),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(a.job.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                  Text(a.job.poster.displayName, style: theme.textTheme.bodySmall),
                ]),
              ),
              ApplicationChip(state: a.state),
            ]),
            if (a.reply != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text('Reply: ${a.reply}', key: Key('my-application-reply-${a.id}'))),
            if (a.state == ApplicationState.sent && a.job.open) Padding(padding: const EdgeInsets.only(top: 4), child: Text(deadlineText(a.job.deadline, DateTime.now()), style: theme.textTheme.bodySmall)),
          ]),
        ),
      ),
    );
  }
}
