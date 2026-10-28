import 'package:flutter/material.dart';

import '../../../site/rules/jobs_rules.dart';

/// What the person writes to apply: a message, and optionally a link to their work or résumé. Answers both, or null when they close it. The boxes belong to the sheet.
Future<({String message, String? link})?> showApplySheet(BuildContext context, {required String jobTitle, required String asName}) {
  return showModalBottomSheet<({String message, String? link})>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _ApplySheet(jobTitle: jobTitle, asName: asName),
  );
}

class _ApplySheet extends StatefulWidget {
  const _ApplySheet({required this.jobTitle, required this.asName});

  final String jobTitle;
  final String asName;

  @override
  State<_ApplySheet> createState() => _ApplySheetState();
}

class _ApplySheetState extends State<_ApplySheet> {
  final _message = TextEditingController();
  final _link = TextEditingController();
  String? _wrong;

  @override
  void dispose() {
    _message.dispose();
    _link.dispose();
    super.dispose();
  }

  void _send() {
    final wrong = checkApplication(message: _message.text, link: _link.text);
    if (wrong != null) return setState(() => _wrong = wrong);
    final link = _link.text.trim();
    Navigator.pop(context, (message: _message.text.trim(), link: link.isEmpty ? null : link));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.of(context).viewInsets.bottom + 16),
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Apply for ${widget.jobTitle}', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text('You apply as ${widget.asName}. Applying is free, and only the business sees what you write.', key: const Key('apply-intro')),
          const SizedBox(height: 12),
          TextField(
            key: const Key('apply-message'),
            controller: _message,
            minLines: 4,
            maxLines: 8,
            maxLength: maxApplicationLength,
            decoration: const InputDecoration(labelText: 'Why you, and what you have done', alignLabelWithHint: true),
          ),
          TextField(
            key: const Key('apply-link'),
            controller: _link,
            keyboardType: TextInputType.url,
            decoration: const InputDecoration(labelText: 'A link to your work or résumé (optional)', hintText: 'https://'),
          ),
          if (_wrong != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_wrong!, key: const Key('apply-problem'), style: TextStyle(color: Theme.of(context).colorScheme.error))),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: FilledButton(key: const Key('apply-send'), onPressed: _send, child: const Text('Send application'))),
        ]),
      ),
    );
  }
}
