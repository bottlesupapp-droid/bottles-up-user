import 'package:flutter/material.dart';
import '../models/waitlist.dart';
import '../services/waitlist_service.dart';

class JoinWaitlistDialog extends StatefulWidget {
  final String eventId;
  final String eventName;

  const JoinWaitlistDialog({
    super.key,
    required this.eventId,
    required this.eventName,
  });

  @override
  State<JoinWaitlistDialog> createState() => _JoinWaitlistDialogState();
}

class _JoinWaitlistDialogState extends State<JoinWaitlistDialog> {
  final _waitlistService = WaitlistService();
  final _notesController = TextEditingController();
  int _partySize = 1;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _joinWaitlist() async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      final entry = await _waitlistService.joinWaitlist(
        eventId: widget.eventId,
        partySize: _partySize,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      if (mounted) {
        Navigator.pop(context, entry);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Joined waitlist at position #${entry.position}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Join Waitlist'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This event is currently sold out. Join the waitlist to be notified if tickets become available.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              'Event: ${widget.eventName}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Party Size',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  onPressed: _partySize > 1
                      ? () => setState(() => _partySize--)
                      : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Container(
                  width: 60,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '$_partySize',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _partySize < 20
                      ? () => setState(() => _partySize++)
                      : null,
                  icon: const Icon(Icons.add_circle_outline),
                ),
                const SizedBox(width: 8),
                Text(
                  'guest${_partySize > 1 ? 's' : ''}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Notes (optional)',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Any special requirements or preferences...',
                contentPadding: EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'You\'ll be notified by email and app notification when a spot opens up. Response within 24 hours required.',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _isSubmitting ? null : _joinWaitlist,
          icon: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.playlist_add),
          label: const Text('Join Waitlist'),
        ),
      ],
    );
  }
}
