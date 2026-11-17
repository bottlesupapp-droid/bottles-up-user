import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../site/models/hiring.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/hiring_rules.dart';
import '../../../site/rules/split_rules.dart';
import '../../../site/site_error.dart';
import 'hiring_widgets.dart';

/// The professional's quote: the total, the deposit, when the balance is due, what is included, and how many days it stays open. Answers the request as it is after the quote is sent.
Future<ProRequest?> showQuoteSheet(BuildContext context, {required ProRequest request}) {
  return showModalBottomSheet<ProRequest>(context: context, isScrollControlled: true, builder: (_) => QuoteSheet(request: request));
}

class QuoteSheet extends ConsumerStatefulWidget {
  const QuoteSheet({super.key, required this.request});

  final ProRequest request;

  @override
  ConsumerState<QuoteSheet> createState() => _QuoteSheetState();
}

class _QuoteSheetState extends ConsumerState<QuoteSheet> {
  late final _total = TextEditingController(text: widget.request.quote == null ? '' : (widget.request.quote!.totalCents / 100).toStringAsFixed(2));
  late final _deposit = TextEditingController(text: widget.request.quote == null ? '' : (widget.request.quote!.depositCents / 100).toStringAsFixed(2));
  late final _scope = TextEditingController(text: widget.request.quote?.scope ?? '');
  late DateTime? _due = widget.request.quote?.balanceDueBy;
  int _days = 7;
  bool _busy = false;
  String? _problem;

  @override
  void dispose() {
    _total.dispose();
    _deposit.dispose();
    _scope.dispose();
    super.dispose();
  }

  Future<void> _pickDue() async {
    final today = clock.now();
    final first = DateTime(today.year, today.month, today.day);
    final last = widget.request.eventDate.subtract(const Duration(days: 1));
    if (last.isBefore(first)) return setState(() => _problem = 'The job is too soon for a balance date: ask for the whole price as the deposit.');
    final picked = await ref.read(dayPickerProvider)(context, first: first, last: last, initial: _due != null && !_due!.isBefore(first) && !_due!.isAfter(last) ? _due! : last);
    if (picked != null && mounted) setState(() => _due = DateTime(picked.year, picked.month, picked.day));
  }

  Future<void> _send() async {
    if (_busy) return;
    final total = parseAmountCents(_total.text);
    final deposit = parseAmountCents(_deposit.text);
    final needsDate = total != null && deposit != null && deposit < total;
    final wrong = checkQuote(totalCents: total, depositCents: deposit, balanceDueBy: needsDate ? _due : null, scope: _scope.text, validDays: _days, eventDate: widget.request.eventDate, today: clock.now());
    if (wrong != null) return setState(() => _problem = wrong);
    final actor = widget.request.provider?.id;
    if (actor == null) return setState(() => _problem = 'This request is no longer available.');
    setState(() {
      _busy = true;
      _problem = null;
    });
    try {
      final updated = await ref.read(hiringServiceProvider).sendQuote(actor: actor, request: widget.request.id, total: total!, deposit: deposit!, balanceDueBy: needsDate ? _due : null, scope: _scope.text, validDays: _days);
      if (mounted) Navigator.of(context).pop(updated);
    } on SiteException catch (e) {
      if (mounted) setState(() => _problem = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = parseAmountCents(_total.text);
    final deposit = parseAmountCents(_deposit.text);
    final needsDate = total != null && deposit != null && deposit < total;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        key: const Key('quote-sheet'),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Send a quote', style: theme.textTheme.titleLarge),
          Text('For ${dayText(widget.request.eventDate)}. The customer pays the deposit to accept; BottlesUp holds it until the job is done.', style: theme.textTheme.bodySmall),
          const SizedBox(height: 12),
          TextField(key: const Key('quote-total'), controller: _total, onChanged: (_) => setState(() {}), keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Total price', prefixText: '\$ ')),
          TextField(key: const Key('quote-deposit'), controller: _deposit, onChanged: (_) => setState(() {}), keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'Deposit to book the date', prefixText: '\$ ', helperText: total == null ? null : 'At least ${cents(minDepositCents(total))}. The whole price means nothing more to pay later.')),
          if (needsDate) Padding(padding: const EdgeInsets.only(top: 8), child: OutlinedButton.icon(key: const Key('quote-due'), onPressed: _pickDue, icon: const Icon(Icons.event_outlined), label: Text(_due == null ? 'Balance due by...' : 'Balance of ${cents(total - deposit)} due by ${dayText(_due!)}'))),
          const SizedBox(height: 8),
          TextField(key: const Key('quote-scope'), controller: _scope, minLines: 3, maxLines: 8, maxLength: maxScopeLength, decoration: const InputDecoration(labelText: 'What is included', alignLabelWithHint: true)),
          DropdownButtonFormField<int>(
            key: const Key('quote-days'),
            initialValue: _days,
            decoration: const InputDecoration(labelText: 'The quote stays open for'),
            items: [for (var d = 1; d <= maxQuoteDays; d++) DropdownMenuItem(value: d, child: Text(d == 1 ? '1 day' : '$d days'))],
            onChanged: (v) => setState(() => _days = v ?? 7),
          ),
          if (_problem != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_problem!, key: const Key('quote-problem'), style: TextStyle(color: theme.colorScheme.error))),
          const SizedBox(height: 12),
          FilledButton(key: const Key('quote-send'), onPressed: _busy ? null : _send, child: Text(_busy ? 'Sending...' : 'Send the quote')),
        ]),
      ),
    );
  }
}
