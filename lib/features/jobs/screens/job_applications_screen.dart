import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/features.dart';
import '../../../site/models/jobs.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/jobs_rules.dart';
import '../../../site/site_error.dart';
import '../../hiring/widgets/hiring_dialogs.dart';
import '../../social/widgets/profile_widgets.dart';
import '../widgets/job_widgets.dart';

/// What a business has received for one job. Only the business sees it. It can shortlist, accept or turn down, with a reply the applicant reads. [asId] is the business profile.
class JobApplicationsScreen extends ConsumerStatefulWidget {
  const JobApplicationsScreen({super.key, required this.jobId, required this.asId});

  final String jobId;
  final String asId;

  @override
  ConsumerState<JobApplicationsScreen> createState() => _JobApplicationsScreenState();
}

class _JobApplicationsScreenState extends ConsumerState<JobApplicationsScreen> {
  bool _busy = false;

  void _say(String text) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));

  Future<void> _answer(JobApplication a, ApplicationState state) async {
    String? reply;
    if (state != ApplicationState.shortlisted) {
      reply = await showTextDialog(
        context,
        title: state == ApplicationState.accepted ? 'Accept ${a.applicant.displayName}?' : 'Turn down ${a.applicant.displayName}?',
        intro: 'You can write a reply. They read it with the answer.',
        introKey: const Key('reply-intro'),
        label: 'Reply (optional)',
        confirmText: state == ApplicationState.accepted ? 'Accept' : 'Turn down',
        keepText: 'Not now',
        fieldKey: const Key('reply-field'),
        confirmKey: const Key('reply-confirm'),
        keepKey: const Key('reply-keep'),
        maxLength: maxApplicationReplyLength,
        minLines: 2,
        maxLines: 5,
        check: checkReply,
      );
      if (reply == null || !mounted) return;
    }
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await ref.read(jobsServiceProvider).answer(actor: widget.asId, application: a.id, state: state, reply: reply);
      ref.invalidate(jobApplicationsProvider((actor: widget.asId, job: widget.jobId)));
      ref.invalidate(jobsMineProvider(widget.asId));
      ref.invalidate(jobProvider);
    } on SiteException catch (e) {
      if (mounted) _say(e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Applications';
    if (!ref.watch(featureOnProvider(Feature.jobs))) {
      return Scaffold(appBar: AppBar(title: const Text(title)), body: const EmptyState(icon: Icons.hourglass_empty, title: 'Coming soon', text: 'Jobs are not open yet.'));
    }
    final list = ref.watch(jobApplicationsProvider((actor: widget.asId, job: widget.jobId)));
    return Scaffold(
      appBar: AppBar(title: const Text(title)),
      body: list.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('the applications'), onRetry: () => ref.invalidate(jobApplicationsProvider((actor: widget.asId, job: widget.jobId)))),
        data: (items) {
          if (items.isEmpty) return const EmptyState(icon: Icons.people_outline, title: 'No applications yet', text: 'When someone applies you will see them here, and nobody else will.');
          return ListView(padding: const EdgeInsets.symmetric(vertical: 8), children: [for (final a in items) _tile(context, a)]);
        },
      ),
    );
  }

  Widget _tile(BuildContext context, JobApplication a) {
    final theme = Theme.of(context);
    final link = a.link;
    return Card(
      key: Key('application-${a.id}'),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          InkWell(
            onTap: () => context.push('/u/${a.applicant.handle}'),
            child: Row(children: [
              ProfileAvatar(profile: a.applicant, size: 40),
              const SizedBox(width: 10),
              Expanded(child: Text('${a.applicant.displayName}  @${a.applicant.handle}', maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleSmall)),
              ApplicationChip(state: a.state),
            ]),
          ),
          const SizedBox(height: 8),
          Text(a.message, key: Key('application-message-${a.id}')),
          if (link != null)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                key: Key('application-link-${a.id}'),
                onPressed: () => ref.read(urlOpenerProvider)(Uri.parse(link), inApp: true),
                icon: const Icon(Icons.link, size: 18),
                label: Text(link, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ),
          if (a.reply != null) Padding(padding: const EdgeInsets.only(top: 4), child: Text('Your reply: ${a.reply}', style: theme.textTheme.bodySmall)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, children: [
            if (a.state != ApplicationState.shortlisted && !a.isAnswered) OutlinedButton(key: Key('shortlist-${a.id}'), onPressed: _busy ? null : () => _answer(a, ApplicationState.shortlisted), child: const Text('Shortlist')),
            if (a.state != ApplicationState.accepted) FilledButton(key: Key('accept-${a.id}'), onPressed: _busy ? null : () => _answer(a, ApplicationState.accepted), child: const Text('Accept')),
            if (a.state != ApplicationState.declined) OutlinedButton(key: Key('decline-${a.id}'), onPressed: _busy ? null : () => _answer(a, ApplicationState.declined), child: const Text('Turn down')),
          ]),
        ]),
      ),
    );
  }
}
