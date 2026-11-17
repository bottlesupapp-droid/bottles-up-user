import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../site/models/table_booking.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/site_error.dart';

/// The venue's cancellation and refund terms, and a way to ask for a refund. Asking refunds nothing: the venue looks at the request against its own terms and answers.
class RefundSection extends ConsumerStatefulWidget {
  const RefundSection({super.key, required this.booking, required this.email, required this.canAsk});

  final TableBooking booking;
  final String? email;

  /// Whether a request makes sense now (paid, something paid, not over, not checked in). The venue's database decides again.
  final bool canAsk;

  @override
  ConsumerState<RefundSection> createState() => _RefundSectionState();
}

class _RefundSectionState extends ConsumerState<RefundSection> {
  final _reason = TextEditingController();
  bool _open = false;
  bool _busy = false;
  String? _sent;
  String? _error;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final code = widget.booking.confirmationCode;
    final email = widget.email;
    if (_busy || code == null || email == null || _reason.text.trim().length < 3) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final said = await ref.read(bookingActionsServiceProvider).requestRefund(code: code, email: email, reason: _reason.text);
      if (mounted) setState(() => _sent = said);
    } on SiteException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final venueId = widget.booking.venueId;
    final policy = venueId == null ? null : ref.watch(venueRefundPolicyProvider(venueId)).valueOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (policy != null) ...[
          Text('Cancellations and refunds', style: theme.textTheme.titleSmall),
          const SizedBox(height: 4),
          Column(key: const Key('refund-policy-detail'), crossAxisAlignment: CrossAxisAlignment.start, children: [for (final l in policy.lines) Padding(padding: const EdgeInsets.symmetric(vertical: 1), child: Text('•  $l', style: theme.textTheme.bodySmall))]),
          const SizedBox(height: 8),
        ],
        if (widget.canAsk && widget.email != null)
          if (_sent != null)
            Text(_sent!, key: const Key('refund-sent'), style: TextStyle(color: theme.colorScheme.primary))
          else if (!_open)
            TextButton(key: const Key('refund-open'), onPressed: () => setState(() => _open = true), child: const Text('Need to cancel? Ask the venue for a refund'))
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(key: const Key('refund-reason'), controller: _reason, maxLength: 500, minLines: 2, maxLines: 4, onChanged: (_) => setState(() {}), decoration: const InputDecoration(hintText: 'For example: I can no longer come on Saturday', border: OutlineInputBorder())),
                if (_error != null) Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(_error!, key: const Key('refund-error'), style: TextStyle(color: theme.colorScheme.error))),
                Text('Asking does not refund anything by itself: the venue looks at your request against its terms.', style: theme.textTheme.bodySmall),
                const SizedBox(height: 8),
                Row(
                  children: [
                    FilledButton(key: const Key('refund-send'), onPressed: _busy || _reason.text.trim().length < 3 ? null : _send, child: Text(_busy ? 'Sending...' : 'Send my request')),
                    const SizedBox(width: 8),
                    TextButton(key: const Key('refund-close'), onPressed: _busy ? null : () => setState(() => _open = false), child: const Text('Back')),
                  ],
                ),
              ],
            ),
      ],
    );
  }
}
