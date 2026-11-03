import 'package:clock/clock.dart';
import 'package:flutter/material.dart';

import '../../../site/models/jobs.dart';
import '../../../site/rules/jobs_rules.dart';
import '../../social/widgets/profile_widgets.dart';

/// One job in a list: what it is, who posts it, what it pays, where, and how long is left to apply.
class JobCard extends StatelessWidget {
  const JobCard({super.key, required this.job, required this.onTap, this.showCounts = false});

  final Job job;
  final VoidCallback onTap;

  /// For the business's own list: how many applications there are and how many wait for an answer.
  final bool showCounts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      key: Key('job-${job.id}'),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              ProfileAvatar(profile: job.poster, size: 36),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(job.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                  Text(job.poster.displayName, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodySmall),
                ]),
              ),
              if (job.applied != null) ApplicationChip(state: job.applied!.state),
            ]),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 4, children: [
              Chip(label: Text(job.kind.label), visualDensity: VisualDensity.compact),
              if (job.where.isNotEmpty) Chip(avatar: const Icon(Icons.place_outlined, size: 16), label: Text(job.where), visualDensity: VisualDensity.compact),
            ]),
            const SizedBox(height: 4),
            Text(job.compensation, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(
              job.status == 'open' ? deadlineText(job.deadline, clock.now()) : (job.isFilled ? 'Filled' : 'Closed'),
              key: Key('job-deadline-${job.id}'),
              style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            if (showCounts && job.applications != null) Text('${job.applications} application${job.applications == 1 ? '' : 's'}${(job.waiting ?? 0) > 0 ? ' · ${job.waiting} waiting' : ''}', key: Key('job-counts-${job.id}'), style: theme.textTheme.bodySmall),
          ]),
        ),
      ),
    );
  }
}

/// Where an application stands, in a few words.
class ApplicationChip extends StatelessWidget {
  const ApplicationChip({super.key, required this.state});

  final ApplicationState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colour = switch (state) {
      ApplicationState.accepted => theme.colorScheme.primary,
      ApplicationState.declined || ApplicationState.withdrawn => theme.colorScheme.onSurfaceVariant,
      _ => theme.colorScheme.secondary,
    };
    return Chip(key: Key('application-${state.wire}'), label: Text(state.label, style: TextStyle(color: colour, fontWeight: FontWeight.w700)), visualDensity: VisualDensity.compact);
  }
}
