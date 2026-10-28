import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/features.dart';
import '../../../site/models/jobs.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/jobs_rules.dart';
import '../../../site/services/jobs_service.dart';
import '../../../site/site_error.dart';
import '../../hiring/widgets/hiring_widgets.dart';
import '../../social/widgets/rules_gate.dart';

/// Posting a job, or changing one: what it is, what it pays, where, when and by which day to apply. [jobId] is the job being changed, or null for a new one; [asId] is the business profile
/// that posts it.
class JobFormScreen extends ConsumerWidget {
  const JobFormScreen({super.key, required this.asId, this.jobId});

  final String asId;
  final String? jobId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = jobId == null ? 'Post a job' : 'Change this job';
    if (!ref.watch(featureOnProvider(Feature.jobs))) {
      return Scaffold(appBar: AppBar(title: Text(title)), body: const EmptyState(icon: Icons.hourglass_empty, title: 'Coming soon', text: 'Jobs are not open yet.'));
    }
    final id = jobId;
    if (id == null) return _JobForm(asId: asId, title: title);
    final job = ref.watch(jobProvider((actor: asId, id: id)));
    return job.when(
      loading: () => Scaffold(appBar: AppBar(title: Text(title)), body: const Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(appBar: AppBar(title: Text(title)), body: LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('this job'), onRetry: () => ref.invalidate(jobProvider((actor: asId, id: id))))),
      data: (j) => _JobForm(asId: asId, title: title, job: j),
    );
  }
}

class _JobForm extends ConsumerStatefulWidget {
  const _JobForm({required this.asId, required this.title, this.job});

  final String asId;
  final String title;
  final Job? job;

  @override
  ConsumerState<_JobForm> createState() => _JobFormState();
}

class _JobFormState extends ConsumerState<_JobForm> {
  late final _title = TextEditingController(text: widget.job?.title ?? '');
  late final _description = TextEditingController(text: widget.job?.description ?? '');
  late final _requirements = TextEditingController(text: widget.job?.requirements ?? '');
  late final _compensation = TextEditingController(text: widget.job?.compensation ?? '');
  late final _location = TextEditingController(text: widget.job?.location ?? '');
  late final _schedule = TextEditingController(text: widget.job?.schedule ?? '');
  late JobKind? _kind = widget.job?.kind;
  late bool _remote = widget.job?.remote ?? false;
  late DateTime? _deadline = widget.job?.deadline;
  bool _busy = false;
  String? _problem;

  @override
  void dispose() {
    for (final c in [_title, _description, _requirements, _compensation, _location, _schedule]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final today = clock.now();
    final first = DateTime(today.year, today.month, today.day);
    final last = DateTime(today.year, today.month, today.day + maxJobDeadlineDays);
    final picked = await ref.read(dayPickerProvider)(context, first: first, last: last, initial: _deadline != null && !_deadline!.isBefore(first) && !_deadline!.isAfter(last) ? _deadline! : DateTime(first.year, first.month, first.day + 30));
    if (picked == null || !mounted) return;
    setState(() {
      _deadline = DateTime(picked.year, picked.month, picked.day);
      _problem = null;
    });
  }

  Future<void> _save() async {
    if (_busy) return;
    final wrong = checkJob(
      title: _title.text,
      kind: _kind,
      description: _description.text,
      requirements: _requirements.text,
      compensation: _compensation.text,
      location: _location.text,
      remote: _remote,
      schedule: _schedule.text,
      deadline: _deadline,
      today: clock.now(),
    );
    if (wrong != null) return setState(() => _problem = wrong);
    // Busy from here on, so a second tap while the rules are being checked sends nothing.
    setState(() {
      _busy = true;
      _problem = null;
    });
    try {
      if (widget.job == null && !await ensureRulesAccepted(context, ref)) return;
      final draft = JobDraft(
        title: _title.text,
        kind: _kind!,
        description: _description.text,
        requirements: _requirements.text,
        compensation: _compensation.text,
        location: _location.text,
        remote: _remote,
        schedule: _schedule.text,
        deadline: _deadline!,
      );
      final service = ref.read(jobsServiceProvider);
      final saved = widget.job == null ? await service.create(actor: widget.asId, draft: draft) : await service.update(actor: widget.asId, id: widget.job!.id, draft: draft);
      ref.invalidate(jobsMineProvider(widget.asId));
      ref.invalidate(jobsListProvider);
      ref.invalidate(jobProvider);
      if (mounted) context.pushReplacement('/jobs/${saved.id}');
    } on SiteException catch (e) {
      if (mounted) setState(() => _problem = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView(key: const Key('job-form'), padding: const EdgeInsets.fromLTRB(16, 16, 16, 40), children: [
        Text('Say clearly what the job is and what it pays. People apply for free, and only you see their applications.', style: theme.textTheme.bodyMedium),
        const SizedBox(height: 12),
        TextField(key: const Key('job-title-field'), controller: _title, maxLength: maxJobTitleLength, decoration: const InputDecoration(labelText: 'Title')),
        DropdownButtonFormField<JobKind>(
          key: const Key('job-kind-field'),
          initialValue: _kind,
          decoration: const InputDecoration(labelText: 'What kind of job'),
          items: [for (final k in JobKind.values) DropdownMenuItem(value: k, child: Text(k.label))],
          onChanged: (v) => setState(() => _kind = v),
        ),
        const SizedBox(height: 12),
        TextField(key: const Key('job-description-field'), controller: _description, minLines: 4, maxLines: 10, maxLength: maxJobDescriptionLength, decoration: const InputDecoration(labelText: 'About the job', alignLabelWithHint: true)),
        TextField(key: const Key('job-requirements-field'), controller: _requirements, minLines: 2, maxLines: 6, maxLength: maxJobRequirementsLength, decoration: const InputDecoration(labelText: 'What you need (optional)', alignLabelWithHint: true)),
        TextField(key: const Key('job-compensation-field'), controller: _compensation, maxLength: maxCompensationLength, decoration: const InputDecoration(labelText: 'What it pays', hintText: '\$20 an hour plus tips')),
        TextField(key: const Key('job-location-field'), controller: _location, maxLength: maxJobLocationLength, decoration: const InputDecoration(labelText: 'Where')),
        SwitchListTile(key: const Key('job-remote-field'), contentPadding: EdgeInsets.zero, title: const Text('Can be done remotely'), value: _remote, onChanged: (v) => setState(() => _remote = v)),
        TextField(key: const Key('job-schedule-field'), controller: _schedule, maxLength: maxJobScheduleLength, decoration: const InputDecoration(labelText: 'Schedule (optional)', hintText: 'Fri and Sat nights')),
        const SizedBox(height: 8),
        OutlinedButton.icon(key: const Key('job-deadline-field'), onPressed: _pickDeadline, icon: const Icon(Icons.event_outlined), label: Text(_deadline == null ? 'Last day to apply' : 'Apply by ${dayText(_deadline!)}')),
        if (_problem != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_problem!, key: const Key('job-problem'), style: TextStyle(color: theme.colorScheme.error))),
        const SizedBox(height: 16),
        FilledButton(key: const Key('job-save'), onPressed: _busy ? null : _save, child: Text(_busy ? 'Saving...' : (widget.job == null ? 'Post the job' : 'Save the changes'))),
      ]),
    );
  }
}
