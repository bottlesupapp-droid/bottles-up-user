import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/features.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/hire_rules.dart';
import '../../../site/rules/split_rules.dart';
import '../../../site/site_error.dart';
import '../../hiring/widgets/hiring_widgets.dart';
import '../../social/widgets/profile_widgets.dart';
import '../../social/widgets/rules_gate.dart';
import '../../social/widgets/switcher_sheet.dart';
import '../widgets/hire_widgets.dart';

/// Ask a venue to host an event: the day, the hours, the kind of event, how many are expected, the space, equipment, staffing, a budget and special requests. It is only a request:
/// the venue answers with an offer, and nothing is booked until the venue confirms. Asked as the event group or promoter the person is acting as.
class HireFormScreen extends ConsumerStatefulWidget {
  const HireFormScreen({super.key, required this.venueId});

  /// The venue's profile.
  final String venueId;

  @override
  ConsumerState<HireFormScreen> createState() => _HireFormScreenState();
}

class _HireFormScreenState extends ConsumerState<HireFormScreen> {
  final _hours = TextEditingController();
  final _type = TextEditingController();
  final _attendance = TextEditingController();
  final _space = TextEditingController();
  final _equipment = TextEditingController();
  final _staffing = TextEditingController();
  final _budget = TextEditingController();
  final _notes = TextEditingController();
  DateTime? _date;
  bool _busy = false;
  String? _problem;

  @override
  void dispose() {
    for (final c in [_hours, _type, _attendance, _space, _equipment, _staffing, _budget, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final today = clock.now();
    final first = DateTime(today.year, today.month, today.day + 1);
    final picked = await ref.read(dayPickerProvider)(context, first: first, last: DateTime(today.year, today.month, today.day + 730), initial: _date ?? first);
    if (picked != null && mounted) setState(() => _date = DateTime(picked.year, picked.month, picked.day));
  }

  Future<void> _send(String actor) async {
    if (_busy) return;
    final attendance = _attendance.text.trim().isEmpty ? null : int.tryParse(_attendance.text.trim());
    final budget = _budget.text.trim().isEmpty ? null : parseAmountCents(_budget.text);
    if (_attendance.text.trim().isNotEmpty && attendance == null) return setState(() => _problem = 'Type the expected attendance as a whole number.');
    if (_budget.text.trim().isNotEmpty && budget == null) return setState(() => _problem = 'Type the budget like 5000 or 5000.00.');
    final wrong = checkHireRequest(
      date: _date,
      eventType: _type.text,
      today: clock.now(),
      hours: _hours.text,
      attendance: attendance,
      space: _space.text,
      equipment: _equipment.text,
      staffing: _staffing.text,
      budgetCents: budget,
      notes: _notes.text,
    );
    if (wrong != null) return setState(() => _problem = wrong);
    // Busy from here on, so a second tap while the rules are being checked sends nothing.
    setState(() {
      _busy = true;
      _problem = null;
    });
    try {
      if (!await ensureRulesAccepted(context, ref)) return;
      final hire = await ref.read(hireServiceProvider).request(
            actor: actor,
            venue: widget.venueId,
            date: _date!,
            eventType: _type.text,
            hours: _hours.text,
            attendance: attendance,
            space: _space.text,
            equipment: _equipment.text,
            staffing: _staffing.text,
            budgetCents: budget,
            notes: _notes.text,
          );
      ref.invalidate(hiresMineProvider(actor));
      if (mounted) context.pushReplacement('/hires/${hire.id}?as=$actor');
    } on SiteException catch (e) {
      if (mounted) setState(() => _problem = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Host your event here';
    if (!ref.watch(featureOnProvider(Feature.venueHire))) {
      return Scaffold(appBar: AppBar(title: const Text(title)), body: const EmptyState(icon: Icons.hourglass_empty, title: 'Coming soon', text: 'Hosting events at venues is not open yet.'));
    }
    return ActorGate(
      title: title,
      builder: (context, actor) {
        if (!isOrganizerProfile(actor)) {
          return Scaffold(
            appBar: AppBar(title: const Text(title)),
            body: Column(children: [
              const Expanded(child: EmptyState(icon: Icons.celebration_outlined, title: 'Ask as your event group', text: 'A venue is asked by an event group or a promoter. Switch to yours from the Profile tab.')),
              Padding(padding: const EdgeInsets.only(bottom: 32), child: FilledButton(key: const Key('hire-switch'), onPressed: () => showProfileSwitcher(context), child: const Text('Switch profile'))),
            ]),
          );
        }
        final theme = Theme.of(context);
        return Scaffold(
          appBar: AppBar(title: const Text(title)),
          body: ListView(key: const Key('hire-form'), padding: const EdgeInsets.fromLTRB(16, 16, 16, 40), children: [
            Text('Asking as ${actor.displayName}. This is only a request: the venue answers with an offer, and nothing is booked until the venue confirms the date.', style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
            OutlinedButton.icon(key: const Key('hire-date'), onPressed: _pickDate, icon: const Icon(Icons.event_outlined), label: Text(_date == null ? 'Choose the day' : dayText(_date!))),
            const SizedBox(height: 8),
            TextField(key: const Key('hire-type'), controller: _type, maxLength: maxEventTypeLength, decoration: const InputDecoration(labelText: 'What kind of event is it?', hintText: 'Themed night')),
            TextField(key: const Key('hire-hours'), controller: _hours, maxLength: maxHoursLength, decoration: const InputDecoration(labelText: 'Hours (optional)', hintText: '9pm to 3am')),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: TextField(key: const Key('hire-attendance'), controller: _attendance, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Expected people (optional)'))),
              const SizedBox(width: 12),
              Expanded(child: TextField(key: const Key('hire-budget'), controller: _budget, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Budget (optional)', prefixText: '\$ '))),
            ]),
            TextField(key: const Key('hire-space'), controller: _space, maxLength: maxSpaceLength, decoration: const InputDecoration(labelText: 'Which space? (optional)')),
            TextField(key: const Key('hire-equipment'), controller: _equipment, maxLength: maxHireLineLength, decoration: const InputDecoration(labelText: 'Equipment (optional)')),
            TextField(key: const Key('hire-staffing'), controller: _staffing, maxLength: maxHireLineLength, decoration: const InputDecoration(labelText: 'Staffing (optional)')),
            TextField(key: const Key('hire-notes-field'), controller: _notes, minLines: 3, maxLines: 8, maxLength: maxHireNotesLength, decoration: const InputDecoration(labelText: 'Special requests (optional)', alignLabelWithHint: true)),
            if (_problem != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_problem!, key: const Key('hire-problem'), style: TextStyle(color: theme.colorScheme.error))),
            const SizedBox(height: 16),
            FilledButton(key: const Key('hire-send'), onPressed: _busy ? null : () => _send(actor.id), child: Text(_busy ? 'Sending...' : 'Send the request')),
          ]),
        );
      },
    );
  }
}
