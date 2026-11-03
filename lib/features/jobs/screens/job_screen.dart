import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/features.dart';
import '../../../site/models/jobs.dart';
import '../../../site/models/safety.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/jobs_rules.dart';
import '../../../site/site_error.dart';
import '../../social/widgets/profile_widgets.dart';
import '../../social/widgets/report_sheet.dart';
import '../../social/widgets/rules_gate.dart';
import '../widgets/apply_sheet.dart';
import '../widgets/job_widgets.dart';

/// One job: what it is, what it pays, where, when, what it needs, and how to apply. The business that posted it sees its applications and can change or close it; anyone else can apply (free)
/// or take an application back. The website decides who may see what.
class JobScreen extends ConsumerStatefulWidget {
  const JobScreen({super.key, required this.jobId});

  final String jobId;

  @override
  ConsumerState<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends ConsumerState<JobScreen> {
  bool _busy = false;

  void _say(String text) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));

  Future<void> _run(Future<void> Function() action, {String? done}) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
      if (done != null && mounted) _say(done);
    } on SiteException catch (e) {
      if (mounted) _say(e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _refresh(String actor) {
    ref.invalidate(jobProvider((actor: actor, id: widget.jobId)));
    ref.invalidate(myApplicationsProvider(actor));
  }

  Future<void> _apply(SocialProfile actor, Job job) async {
    final r = await showApplySheet(context, jobTitle: job.title, asName: actor.displayName);
    if (r == null || !mounted) return;
    // Busy from here on, so a second tap while the rules are being checked sends nothing.
    await _run(() async {
      if (!await ensureRulesAccepted(context, ref)) return;
      await ref.read(jobsServiceProvider).apply(actor: actor.id, job: job.id, message: r.message, link: r.link);
      _refresh(actor.id);
    }, done: 'Your application was sent.');
  }

  Future<void> _withdraw(SocialProfile actor, Job job) async {
    final applied = job.applied;
    if (applied == null) return;
    final yes = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Take your application back?'),
        content: const Text('The business will not see it any more. You can apply again while the job is open.'),
        actions: [
          TextButton(key: const Key('withdraw-keep'), onPressed: () => Navigator.pop(c, false), child: const Text('Keep it')),
          FilledButton(key: const Key('withdraw-confirm'), onPressed: () => Navigator.pop(c, true), child: const Text('Take it back')),
        ],
      ),
    );
    if (yes != true || !mounted) return;
    await _run(() async {
      await ref.read(jobsServiceProvider).withdraw(actor: actor.id, application: applied.id);
      _refresh(actor.id);
    }, done: 'Your application was taken back.');
  }

  Future<void> _close(SocialProfile actor, Job job) async {
    final choice = await showDialog<String>(
      context: context,
      builder: (c) => SimpleDialog(
        title: const Text('Close this job'),
        children: [
          SimpleDialogOption(key: const Key('close-filled'), onPressed: () => Navigator.pop(c, 'filled'), child: const Text('We found someone')),
          SimpleDialogOption(key: const Key('close-plain'), onPressed: () => Navigator.pop(c, 'closed'), child: const Text('Just close it')),
          SimpleDialogOption(key: const Key('close-keep'), onPressed: () => Navigator.pop(c, null), child: const Text('Keep it open')),
        ],
      ),
    );
    if (choice == null || !mounted) return;
    await _run(() async {
      await ref.read(jobsServiceProvider).close(actor: job.poster.id, id: job.id, filled: choice == 'filled');
      _refresh(actor.id);
      ref.invalidate(jobsMineProvider(job.poster.id));
    }, done: 'The job is closed.');
  }

  Future<void> _report(SocialProfile actor, Job job) async {
    final result = await showReportSheet(context, actor: actor, kind: ReportKind.job, target: job.id, alsoBlock: job.poster);
    if (result != null && mounted) _say('Thank you. Our team will look at it.');
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Job';
    if (!ref.watch(featureOnProvider(Feature.jobs))) {
      return Scaffold(appBar: AppBar(title: const Text(title)), body: const EmptyState(icon: Icons.hourglass_empty, title: 'Coming soon', text: 'Jobs are not open yet.'));
    }
    return ActorGate(
      title: title,
      builder: (context, actor) {
        final job = ref.watch(jobProvider((actor: actor.id, id: widget.jobId)));
        return Scaffold(
          appBar: AppBar(
            title: const Text(title),
            actions: [
              if (job.valueOrNull != null && !job.requireValue.mine)
                PopupMenuButton<String>(
                  key: const Key('job-menu'),
                  onSelected: (_) => _report(actor, job.requireValue),
                  itemBuilder: (_) => const [PopupMenuItem(value: 'report', key: Key('job-report'), child: Text('Report this job'))],
                ),
            ],
          ),
          body: job.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('this job'), onRetry: () => ref.invalidate(jobProvider((actor: actor.id, id: widget.jobId)))),
            data: (j) => _body(context, actor, j),
          ),
        );
      },
    );
  }

  Widget _body(BuildContext context, SocialProfile actor, Job j) {
    final theme = Theme.of(context);
    return ListView(padding: const EdgeInsets.all(16), children: [
      InkWell(
        key: const Key('job-poster'),
        onTap: () => context.push('/u/${j.poster.handle}'),
        child: Row(children: [
          ProfileAvatar(profile: j.poster, size: 44),
          const SizedBox(width: 10),
          Expanded(child: Text(j.poster.displayName, style: theme.textTheme.titleSmall)),
          const Icon(Icons.chevron_right),
        ]),
      ),
      const SizedBox(height: 12),
      Text(j.title, key: const Key('job-title'), style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
      const SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 4, children: [
        Chip(label: Text(j.kind.label)),
        if (j.where.isNotEmpty) Chip(avatar: const Icon(Icons.place_outlined, size: 16), label: Text(j.where)),
      ]),
      const SizedBox(height: 8),
      _line(context, 'Pay', j.compensation, const Key('job-pay')),
      if (j.schedule != null) _line(context, 'Schedule', j.schedule!, const Key('job-schedule')),
      _line(context, 'Apply by', j.open ? '${applyByText(j.deadline)} (${deadlineText(j.deadline, clock.now())})' : (j.isFilled ? 'Filled' : (j.isClosed ? 'Closed' : 'The last day has passed')), const Key('job-deadline')),
      const SizedBox(height: 12),
      Text('About the job', style: theme.textTheme.titleSmall),
      const SizedBox(height: 4),
      Text(j.description, key: const Key('job-description')),
      if (j.requirements != null) ...[
        const SizedBox(height: 12),
        Text('What you need', style: theme.textTheme.titleSmall),
        const SizedBox(height: 4),
        Text(j.requirements!, key: const Key('job-requirements')),
      ],
      const SizedBox(height: 20),
      if (j.mine) ..._mine(context, actor, j) else ..._applicant(context, actor, j),
    ]);
  }

  Widget _line(BuildContext context, String label, String value, Key key) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 84, child: Text(label, style: Theme.of(context).textTheme.bodySmall)),
          Expanded(child: Text(value, key: key)),
        ]),
      );

  List<Widget> _mine(BuildContext context, SocialProfile actor, Job j) => [
        FilledButton.icon(
          key: const Key('see-applications'),
          onPressed: () => context.push('/me/jobs/${j.id}/applications?as=${j.poster.id}'),
          icon: const Icon(Icons.people_outline),
          label: Text('Applications (${j.applications ?? 0}${(j.waiting ?? 0) > 0 ? ', ${j.waiting} waiting' : ''})'),
        ),
        if (j.status == 'open') ...[
          const SizedBox(height: 8),
          OutlinedButton(key: const Key('edit-job'), onPressed: () => context.push('/me/jobs/${j.id}/edit?as=${j.poster.id}'), child: const Text('Change this job')),
          const SizedBox(height: 8),
          OutlinedButton(key: const Key('close-job'), onPressed: _busy ? null : () => _close(actor, j), child: const Text('Close this job')),
        ],
      ];

  List<Widget> _applicant(BuildContext context, SocialProfile actor, Job j) {
    final applied = j.applied;
    final theme = Theme.of(context);
    if (applied != null && applied.state != ApplicationState.withdrawn) {
      return [
        Card(
          key: const Key('my-application'),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Text('Your application', style: theme.textTheme.titleSmall), const SizedBox(width: 8), ApplicationChip(state: applied.state)]),
              const SizedBox(height: 4),
              const Text('Only the business can see it. You will see its answer here and in My applications.'),
            ]),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(key: const Key('withdraw-application'), onPressed: _busy ? null : () => _withdraw(actor, j), child: const Text('Take my application back')),
      ];
    }
    if (!j.open) {
      return [Text(j.isFilled ? 'This job has been filled.' : 'This job is not taking applications.', key: const Key('job-closed'), style: theme.textTheme.bodyMedium)];
    }
    return [
      FilledButton(key: const Key('apply'), onPressed: _busy ? null : () => _apply(actor, j), child: Text(applied != null ? 'Apply again' : 'Apply')),
      const SizedBox(height: 4),
      Text('Applying is free.', style: theme.textTheme.bodySmall),
    ];
  }
}
