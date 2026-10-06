import 'package:flutter/material.dart';
import '../models/event.dart';
import 'event_share_sheet.dart';

class EventShareButton extends StatelessWidget {
  final Event event;
  final bool compact;

  const EventShareButton({
    super.key,
    required this.event,
    this.compact = false,
  });

  void _showShareSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EventShareSheet(event: event),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return IconButton(
        onPressed: () => _showShareSheet(context),
        icon: const Icon(Icons.share),
        tooltip: 'Share event',
      );
    }

    return FilledButton.tonalIcon(
      onPressed: () => _showShareSheet(context),
      icon: const Icon(Icons.share),
      label: const Text('Share Event'),
    );
  }
}
