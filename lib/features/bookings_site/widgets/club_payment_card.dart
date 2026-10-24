import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../site/models/table_booking.dart';
import '../../../site/money.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/site_error.dart';

/// A payment the club recorded for the bottles that the guest has not yet said is right: confirm it, or report a problem with a reason.
class ClubPaymentCard extends ConsumerStatefulWidget {
  const ClubPaymentCard({super.key, required this.bookingId, required this.payment, required this.currency});

  final String bookingId;
  final ClubPaymentRequest payment;
  final String currency;

  @override
  ConsumerState<ClubPaymentCard> createState() => _ClubPaymentCardState();
}

class _ClubPaymentCardState extends ConsumerState<ClubPaymentCard> {
  final _reason = TextEditingController();
  bool _reporting = false;
  bool _busy = false;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  Future<void> _answer({required bool confirm}) async {
    if (_busy) return;
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(bookingActionsServiceProvider).answerClubPayment(token: widget.payment.token, confirm: confirm, reason: _reason.text);
      messenger.showSnackBar(SnackBar(content: Text(confirm ? 'Thanks, payment confirmed.' : 'Thanks, we passed your report to the venue.')));
    } on SiteException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _busy = false);
      ref.invalidate(tableBookingProvider(widget.bookingId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = widget.payment;
    final id = p.id;
    return Card(
      key: Key('bd-club-payment-$id'),
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('The club recorded a payment of ${formatMoney(p.paidCents, currency: widget.currency)}${p.method.isEmpty ? '' : ' (${p.method})'} for your bottles. Is that right?', style: theme.textTheme.bodyMedium),
            const SizedBox(height: 10),
            if (_reporting) ...[
              TextField(key: Key('club-reason-$id'), controller: _reason, maxLength: 500, minLines: 2, maxLines: 4, onChanged: (_) => setState(() {}), decoration: const InputDecoration(hintText: 'What is wrong? For example: I was charged twice', border: OutlineInputBorder())),
              Row(
                children: [
                  FilledButton(key: Key('club-report-send-$id'), onPressed: _busy || _reason.text.trim().length < 3 ? null : () => _answer(confirm: false), child: const Text('Send report')),
                  const SizedBox(width: 8),
                  TextButton(key: Key('club-report-cancel-$id'), onPressed: _busy ? null : () => setState(() => _reporting = false), child: const Text('Back')),
                ],
              ),
            ] else
              Row(
                children: [
                  FilledButton(key: Key('club-confirm-$id'), onPressed: _busy ? null : () => _answer(confirm: true), child: const Text('Yes, that is right')),
                  const SizedBox(width: 8),
                  OutlinedButton(key: Key('club-report-$id'), onPressed: _busy ? null : () => setState(() => _reporting = true), child: const Text('Report a problem')),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
