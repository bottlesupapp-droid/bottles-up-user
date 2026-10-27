import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../site/models/hire.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/hire_rules.dart';
import '../../../site/rules/split_rules.dart';
import '../../../site/site_error.dart';
import '../../hiring/widgets/hiring_widgets.dart';

/// The venue's offer: the rental cost, the deposit, the minimum sales, the bar share, who controls tickets and tables, staffing, equipment, cancellation terms and how long it stays open.
/// Shows what is wrong inside the sheet and answers the hire as it is after the offer is sent.
Future<Hire?> showOfferSheet(BuildContext context, {required Hire hire, required String actor}) {
  return showModalBottomSheet<Hire>(context: context, isScrollControlled: true, builder: (_) => OfferSheet(hire: hire, actor: actor));
}

class OfferSheet extends ConsumerStatefulWidget {
  const OfferSheet({super.key, required this.hire, required this.actor});

  final Hire hire;
  final String actor;

  @override
  ConsumerState<OfferSheet> createState() => _OfferSheetState();
}

String _money(int? cents) => cents == null ? '' : (cents / 100).toStringAsFixed(2);

class _OfferSheetState extends ConsumerState<OfferSheet> {
  late final _rental = TextEditingController(text: _money(widget.hire.offer?.rentalCents));
  late final _deposit = TextEditingController(text: _money(widget.hire.offer?.depositCents));
  late final _sales = TextEditingController(text: _money(widget.hire.offer?.minSalesCents));
  late final _bar = TextEditingController(text: widget.hire.offer == null ? '' : widget.hire.offer!.barShareText.replaceAll('%', ''));
  late final _staffing = TextEditingController(text: widget.hire.offer?.staffing ?? widget.hire.staffing ?? '');
  late final _equipment = TextEditingController(text: widget.hire.offer?.equipment ?? widget.hire.equipment ?? '');
  late final _cancellation = TextEditingController(text: widget.hire.offer?.cancellation ?? '');
  late final _notes = TextEditingController(text: widget.hire.offer?.notes ?? '');
  late HireControl _control = widget.hire.offer?.control ?? HireControl.venue;
  int _days = 7;
  bool _busy = false;
  String? _problem;

  @override
  void dispose() {
    for (final c in [_rental, _deposit, _sales, _bar, _staffing, _equipment, _cancellation, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _send() async {
    if (_busy) return;
    final rental = parseAmountCents(_rental.text);
    final deposit = _deposit.text.trim().isEmpty ? 0 : parseAmountCents(_deposit.text);
    final sales = _sales.text.trim().isEmpty ? 0 : parseAmountCents(_sales.text);
    final bar = _bar.text.trim().isEmpty ? 0 : parseBarShareBps(_bar.text);
    final wrong = checkOffer(
      rentalCents: rental,
      depositCents: deposit,
      minSalesCents: sales,
      barShareBps: bar,
      control: _control,
      validDays: _days,
      staffing: _staffing.text,
      equipment: _equipment.text,
      cancellation: _cancellation.text,
      notes: _notes.text,
    );
    if (wrong != null) return setState(() => _problem = wrong);
    setState(() {
      _busy = true;
      _problem = null;
    });
    try {
      final updated = await ref.read(hireServiceProvider).sendOffer(
            actor: widget.actor,
            hire: widget.hire.id,
            rentalCents: rental!,
            depositCents: deposit!,
            minSalesCents: sales!,
            barShareBps: bar!,
            control: _control,
            staffing: _staffing.text,
            equipment: _equipment.text,
            cancellation: _cancellation.text,
            notes: _notes.text,
            validDays: _days,
          );
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
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        key: const Key('offer-sheet'),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.hire.offer == null ? 'Make an offer' : 'Change the offer', style: theme.textTheme.titleLarge),
          Text('For ${dayText(widget.hire.eventDate)}. The money is agreed here and settled between you and the group: BottlesUp does not take it.', style: theme.textTheme.bodySmall),
          const SizedBox(height: 12),
          TextField(key: const Key('offer-rental'), controller: _rental, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Rental cost', prefixText: '\$ ')),
          TextField(key: const Key('offer-deposit'), controller: _deposit, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Deposit (optional)', prefixText: '\$ ')),
          TextField(key: const Key('offer-sales'), controller: _sales, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Minimum sales (optional)', prefixText: '\$ ')),
          TextField(key: const Key('offer-bar'), controller: _bar, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Bar share (optional)', suffixText: '%')),
          DropdownButtonFormField<HireControl>(
            key: const Key('offer-control'),
            initialValue: _control,
            decoration: const InputDecoration(labelText: 'Who controls tickets and tables'),
            items: [for (final c in HireControl.values) DropdownMenuItem(value: c, child: Text(c.label))],
            onChanged: (v) => setState(() => _control = v ?? _control),
          ),
          TextField(key: const Key('offer-staffing'), controller: _staffing, maxLength: maxHireLineLength, decoration: const InputDecoration(labelText: 'Staffing (optional)')),
          TextField(key: const Key('offer-equipment'), controller: _equipment, maxLength: maxHireLineLength, decoration: const InputDecoration(labelText: 'Equipment (optional)')),
          TextField(key: const Key('offer-cancellation'), controller: _cancellation, minLines: 2, maxLines: 5, maxLength: maxCancellationLength, decoration: const InputDecoration(labelText: 'Cancellation terms (optional)', alignLabelWithHint: true)),
          TextField(key: const Key('offer-notes'), controller: _notes, minLines: 2, maxLines: 5, maxLength: maxHireNotesLength, decoration: const InputDecoration(labelText: 'Anything else (optional)', alignLabelWithHint: true)),
          DropdownButtonFormField<int>(
            key: const Key('offer-days'),
            initialValue: _days,
            decoration: const InputDecoration(labelText: 'The offer stays open for'),
            items: [for (var d = 1; d <= maxOfferDays; d++) DropdownMenuItem(value: d, child: Text(d == 1 ? '1 day' : '$d days'))],
            onChanged: (v) => setState(() => _days = v ?? 7),
          ),
          if (_problem != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_problem!, key: const Key('offer-problem'), style: TextStyle(color: theme.colorScheme.error))),
          const SizedBox(height: 12),
          FilledButton(key: const Key('offer-send'), onPressed: _busy ? null : _send, child: Text(_busy ? 'Sending...' : 'Send the offer')),
        ]),
      ),
    );
  }
}
