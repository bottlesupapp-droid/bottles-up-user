import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../site/models/safety.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/safety_rules.dart';
import '../../../site/site_error.dart';

/// What came of a report: that it went, and whether the person was blocked as well.
class ReportResult {
  const ReportResult({required this.receipt, this.blocked = false, this.blockProblem});

  final ReportReceipt receipt;
  final bool blocked;

  /// Why the block did not go through, when it was asked for and failed (the report itself did go).
  final String? blockProblem;

  String get message => [
        reportThanks(receipt),
        if (blocked) 'They are blocked.',
        if (blockProblem != null) 'We could not block them: $blockProblem',
      ].join(' ');
}

/// Asks why, and sends the report as [actor]. [alsoBlock] is the person behind it: when given, the sheet offers to block them in the same step. Says thank you when it is
/// done and answers what happened, or null when the person closed it.
Future<ReportResult?> showReportSheet(BuildContext context, {required SocialProfile actor, required ReportKind kind, required String target, SocialProfile? alsoBlock}) async {
  final messenger = ScaffoldMessenger.of(context);
  final result = await showModalBottomSheet<ReportResult>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _ReportSheet(actor: actor, kind: kind, target: target, alsoBlock: alsoBlock),
  );
  if (result != null) messenger.showSnackBar(SnackBar(content: Text(result.message)));
  return result;
}

class _ReportSheet extends ConsumerStatefulWidget {
  const _ReportSheet({required this.actor, required this.kind, required this.target, this.alsoBlock});

  final SocialProfile actor;
  final ReportKind kind;
  final String target;
  final SocialProfile? alsoBlock;

  @override
  ConsumerState<_ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends ConsumerState<_ReportSheet> {
  final _details = TextEditingController();
  ReportReason? _reason;
  bool _block = false;
  bool _busy = false;
  String? _problem;

  @override
  void dispose() {
    _details.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final reason = _reason;
    if (reason == null) return;
    setState(() {
      _busy = true;
      _problem = null;
    });
    ReportReceipt receipt;
    try {
      receipt = await ref.read(safetyServiceProvider).report(actor: widget.actor.id, kind: widget.kind, target: widget.target, reason: reason, details: _details.text);
    } on SiteException catch (e) {
      if (mounted) {
        setState(() {
          _problem = e.message;
          _busy = false;
        });
      }
      return;
    }
    var blocked = false;
    String? blockProblem;
    final other = widget.alsoBlock;
    if (_block && other != null) {
      try {
        await ref.read(socialProfilesServiceProvider).setBlocked(actor: widget.actor.id, target: other.id, blocked: true);
        ref.invalidate(blockedProfilesProvider);
        blocked = true;
      } on SiteException catch (e) {
        blockProblem = e.message;
      }
    }
    if (mounted) Navigator.of(context).pop(ReportResult(receipt: receipt, blocked: blocked, blockProblem: blockProblem));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final other = widget.alsoBlock;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(key: const Key('report-sheet'), mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Report this ${reportKindLabel(widget.kind)}', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text('Why are you reporting it? The person is not told it was you.', style: theme.textTheme.bodySmall),
              RadioGroup<ReportReason>(
                groupValue: _reason,
                onChanged: (v) => setState(() => _reason = v),
                child: Column(children: [
                  for (final r in reportReasons)
                    RadioListTile<ReportReason>(key: Key('reason-${r.reason.wire}'), value: r.reason, dense: true, contentPadding: EdgeInsets.zero, title: Text(r.label), subtitle: Text(r.hint)),
                ]),
              ),
              TextField(key: const Key('report-details'), controller: _details, maxLength: reportDetailsMax, minLines: 1, maxLines: 4, decoration: const InputDecoration(labelText: 'Anything else we should know? (optional)')),
              if (other != null)
                CheckboxListTile(
                  key: const Key('report-also-block'),
                  contentPadding: EdgeInsets.zero,
                  value: _block,
                  onChanged: (v) => setState(() => _block = v ?? false),
                  title: Text('Also block @${other.handle}'),
                  subtitle: const Text('You will not see each other, or each other\'s other profiles.'),
                ),
              if (_problem != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_problem!, key: const Key('report-problem'), style: TextStyle(color: theme.colorScheme.error))),
              const SizedBox(height: 8),
              SizedBox(width: double.infinity, child: FilledButton(key: const Key('report-send'), onPressed: _reason == null || _busy ? null : _send, child: Text(_busy ? 'Sending...' : 'Send report'))),
            ]),
          ),
        ),
      ),
    );
  }
}
