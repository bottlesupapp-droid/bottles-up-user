import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/features.dart';
import '../../../site/models/hiring.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/hiring_rules.dart';
import '../../../site/rules/split_rules.dart';
import '../../../site/site_error.dart';
import '../../social/widgets/rules_gate.dart';
import '../widgets/hiring_widgets.dart';

/// Ask a professional for a job: the day, an optional service and place, how many guests, a budget, and what it is about. Nothing is charged: the professional answers with a quote.
class ProRequestFormScreen extends ConsumerStatefulWidget {
  const ProRequestFormScreen({super.key, required this.providerId});

  final String providerId;

  @override
  ConsumerState<ProRequestFormScreen> createState() => _ProRequestFormScreenState();
}

class _ProRequestFormScreenState extends ConsumerState<ProRequestFormScreen> {
  final _message = TextEditingController();
  final _time = TextEditingController();
  final _place = TextEditingController();
  final _guests = TextEditingController();
  final _budget = TextEditingController();
  DateTime? _date;
  String? _service;
  bool _busy = false;
  String? _problem;

  @override
  void dispose() {
    _message.dispose();
    _time.dispose();
    _place.dispose();
    _guests.dispose();
    _budget.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final today = clock.now();
    final first = DateTime(today.year, today.month, today.day + 1);
    final picked = await ref.read(dayPickerProvider)(context, first: first, last: DateTime(today.year, today.month, today.day + 730), initial: _date ?? first);
    if (picked == null || !mounted) return;
    final day = DateTime(picked.year, picked.month, picked.day);
    final busy = ref.read(proBusyDaysProvider(widget.providerId)).valueOrNull ?? const <DateTime>[];
    setState(() {
      if (busy.any((d) => d.year == day.year && d.month == day.month && d.day == day.day)) {
        _problem = 'They are not free on ${dayText(day)}. Choose another day.';
      } else {
        _date = day;
        _problem = null;
      }
    });
  }

  Future<void> _send() async {
    if (_busy) return;
    final guests = _guests.text.trim().isEmpty ? null : int.tryParse(_guests.text.trim());
    final budget = _budget.text.trim().isEmpty ? null : parseAmountCents(_budget.text);
    if (_guests.text.trim().isNotEmpty && guests == null) return setState(() => _problem = 'Type the number of guests as a whole number.');
    if (_budget.text.trim().isNotEmpty && budget == null) return setState(() => _problem = 'Type the budget like 1500 or 1500.00.');
    final wrong = checkRequest(date: _date, message: _message.text, today: clock.now(), guests: guests, budgetCents: budget);
    if (wrong != null) return setState(() => _problem = wrong);
    // Busy from here on, so a second tap while the rules are being checked sends nothing.
    setState(() {
      _busy = true;
      _problem = null;
    });
    try {
      if (!await ensureRulesAccepted(context, ref)) return;
      final request = await ref.read(hiringServiceProvider).createRequest(
            provider: widget.providerId,
            service: _service,
            date: _date!,
            timeNote: _time.text,
            location: _place.text,
            guests: guests,
            message: _message.text,
            budgetCents: budget,
          );
      ref.invalidate(myProRequestsProvider);
      if (mounted) context.pushReplacement('/hiring/${request.id}');
    } on SiteException catch (e) {
      if (mounted) setState(() => _problem = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (!ref.watch(featureOnProvider(Feature.marketplace))) {
      return Scaffold(appBar: AppBar(title: const Text('Hire a professional')), body: const EmptyState(icon: Icons.hourglass_empty, title: 'Coming soon', text: 'Hiring professionals is not open yet.'));
    }
    final services = ref.watch(proServicesProvider(widget.providerId)).valueOrNull ?? const <ProService>[];
    ref.watch(proBusyDaysProvider(widget.providerId));
    return Scaffold(
      appBar: AppBar(title: const Text('Hire a professional')),
      body: ListView(key: const Key('request-form'), padding: const EdgeInsets.fromLTRB(16, 16, 16, 40), children: [
        Text('Tell them about the job. They answer with a quote; nothing is charged until you accept it.', style: theme.textTheme.bodyMedium),
        const SizedBox(height: 16),
        OutlinedButton.icon(key: const Key('request-date'), onPressed: _pickDate, icon: const Icon(Icons.event_outlined), label: Text(_date == null ? 'Choose the day' : dayText(_date!))),
        if (services.isNotEmpty) ...[
          const SizedBox(height: 12),
          DropdownButtonFormField<String?>(
            key: const Key('request-service'),
            initialValue: _service,
            decoration: const InputDecoration(labelText: 'Service (optional)'),
            items: [const DropdownMenuItem<String?>(value: null, child: Text('Something else')), for (final s in services) DropdownMenuItem<String?>(value: s.id, child: Text(s.title))],
            onChanged: (v) => setState(() => _service = v),
          ),
        ],
        const SizedBox(height: 12),
        TextField(key: const Key('request-time'), controller: _time, maxLength: 60, decoration: const InputDecoration(labelText: 'Time (optional)', hintText: '9pm to 1am')),
        TextField(key: const Key('request-place'), controller: _place, maxLength: 160, decoration: const InputDecoration(labelText: 'Place (optional)')),
        Row(children: [
          Expanded(child: TextField(key: const Key('request-guests'), controller: _guests, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Guests (optional)'))),
          const SizedBox(width: 12),
          Expanded(child: TextField(key: const Key('request-budget'), controller: _budget, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Budget (optional)', prefixText: '\$ '))),
        ]),
        const SizedBox(height: 12),
        TextField(key: const Key('request-message'), controller: _message, minLines: 3, maxLines: 8, maxLength: maxMessageLength, decoration: const InputDecoration(labelText: 'What is the job?', alignLabelWithHint: true)),
        if (_problem != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_problem!, key: const Key('request-problem'), style: TextStyle(color: theme.colorScheme.error))),
        const SizedBox(height: 16),
        FilledButton(key: const Key('request-send'), onPressed: _busy ? null : _send, child: Text(_busy ? 'Sending...' : 'Send request')),
      ]),
    );
  }
}
