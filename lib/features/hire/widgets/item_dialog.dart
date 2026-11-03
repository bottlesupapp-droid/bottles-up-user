import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../site/rules/hire_rules.dart';
import '../../hiring/widgets/hiring_widgets.dart';
import 'hire_widgets.dart';

/// What the person typed for a new task or schedule item.
typedef NewItem = ({bool schedule, String title, String? atTime, DateTime? dueOn});

/// Asks for a task (a title and, if they like, a day) or a schedule item (a title and a time of day). The boxes belong to the dialog, so they live as long as its closing animation.
Future<NewItem?> showItemDialog(BuildContext context, {required bool schedule}) => showDialog<NewItem>(context: context, builder: (_) => _ItemDialog(schedule: schedule));

class _ItemDialog extends ConsumerStatefulWidget {
  const _ItemDialog({required this.schedule});

  final bool schedule;

  @override
  ConsumerState<_ItemDialog> createState() => _ItemDialogState();
}

class _ItemDialogState extends ConsumerState<_ItemDialog> {
  final _title = TextEditingController();
  String? _time;
  DateTime? _due;
  String? _wrong;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await ref.read(timePickerProvider)(context, initial: const TimeOfDay(hour: 21, minute: 0));
    if (picked != null && mounted) setState(() => _time = hhmm(picked.hour, picked.minute));
  }

  Future<void> _pickDue() async {
    final now = clock.now();
    final first = DateTime(now.year, now.month, now.day);
    final picked = await ref.read(dayPickerProvider)(context, first: first, last: DateTime(first.year, first.month, first.day + 730), initial: first);
    if (picked != null && mounted) setState(() => _due = DateTime(picked.year, picked.month, picked.day));
  }

  void _add() {
    final wrong = checkHireItem(schedule: widget.schedule, title: _title.text, today: clock.now(), atTime: _time, dueOn: _due);
    if (wrong != null) return setState(() => _wrong = wrong);
    Navigator.pop<NewItem>(context, (schedule: widget.schedule, title: _title.text.trim(), atTime: _time, dueOn: _due));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.schedule ? 'Add to the schedule' : 'Add a task'),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextField(key: const Key('item-title'), controller: _title, maxLength: maxItemTitleLength, decoration: InputDecoration(labelText: widget.schedule ? 'What happens' : 'What needs doing', errorText: _wrong)),
          if (widget.schedule) OutlinedButton.icon(key: const Key('item-time'), onPressed: _pickTime, icon: const Icon(Icons.schedule), label: Text(_time == null ? 'Choose the time' : timeText(_time!))),
          if (!widget.schedule) OutlinedButton.icon(key: const Key('item-due'), onPressed: _pickDue, icon: const Icon(Icons.event_outlined), label: Text(_due == null ? 'Due day (optional)' : dayText(_due!))),
        ]),
      ),
      actions: [
        TextButton(key: const Key('item-cancel'), onPressed: () => Navigator.pop(context), child: const Text('Not now')),
        FilledButton(key: const Key('item-add'), onPressed: _add, child: const Text('Add')),
      ],
    );
  }
}
