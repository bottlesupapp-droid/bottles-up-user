import 'package:flutter/material.dart';

/// A question with a box to type in, for cancelling, declining and disputing. Answers what was typed (empty when the person typed nothing and the box is optional), or null when they
/// chose to keep things as they are. The box belongs to the dialog, so it lives as long as the dialog's closing animation does.
Future<String?> showTextDialog(
  BuildContext context, {
  required String title,
  required String label,
  required String confirmText,
  required String keepText,
  required Key fieldKey,
  required Key confirmKey,
  required Key keepKey,
  String? intro,
  Key? introKey,
  int maxLength = 300,
  int minLines = 1,
  int maxLines = 1,
  String? Function(String text)? check,
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => _TextDialog(
      title: title,
      label: label,
      confirmText: confirmText,
      keepText: keepText,
      fieldKey: fieldKey,
      confirmKey: confirmKey,
      keepKey: keepKey,
      intro: intro,
      introKey: introKey,
      maxLength: maxLength,
      minLines: minLines,
      maxLines: maxLines,
      check: check,
    ),
  );
}

class _TextDialog extends StatefulWidget {
  const _TextDialog({
    required this.title,
    required this.label,
    required this.confirmText,
    required this.keepText,
    required this.fieldKey,
    required this.confirmKey,
    required this.keepKey,
    required this.maxLength,
    required this.minLines,
    required this.maxLines,
    this.intro,
    this.introKey,
    this.check,
  });

  final String title;
  final String label;
  final String confirmText;
  final String keepText;
  final Key fieldKey;
  final Key confirmKey;
  final Key keepKey;
  final String? intro;
  final Key? introKey;
  final int maxLength;
  final int minLines;
  final int maxLines;
  final String? Function(String text)? check;

  @override
  State<_TextDialog> createState() => _TextDialogState();
}

class _TextDialogState extends State<_TextDialog> {
  final _text = TextEditingController();
  String? _wrong;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _confirm() {
    final wrong = widget.check?.call(_text.text);
    if (wrong != null) return setState(() => _wrong = wrong);
    Navigator.pop(context, _text.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (widget.intro != null) ...[Text(widget.intro!, key: widget.introKey), const SizedBox(height: 12)],
          TextField(key: widget.fieldKey, controller: _text, minLines: widget.minLines, maxLines: widget.maxLines, maxLength: widget.maxLength, decoration: InputDecoration(labelText: widget.label, errorText: _wrong)),
        ]),
      ),
      actions: [
        TextButton(key: widget.keepKey, onPressed: () => Navigator.pop(context), child: Text(widget.keepText)),
        FilledButton(key: widget.confirmKey, onPressed: _confirm, child: Text(widget.confirmText)),
      ],
    );
  }
}
