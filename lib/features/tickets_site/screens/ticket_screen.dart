import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/ticket_order.dart';
import '../../../site/money.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/site_error.dart';
import '../../../site/when.dart';
import '../widgets/ticket_qr.dart';

/// One ticket: the QR code to show at the door, what it is for, and, for a ticket that stays with its buyer, a way to get the 6-digit code the door asks for.
class TicketScreen extends ConsumerStatefulWidget {
  const TicketScreen({super.key, required this.orderId, DateTime? now}) : _now = now;

  final String orderId;
  final DateTime? _now;

  @override
  ConsumerState<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends ConsumerState<TicketScreen> {
  bool _sending = false;
  String? _sent;
  String? _problem;

  Future<void> _sendCode(TicketOrder o) async {
    if (_sending) return;
    setState(() {
      _sending = true;
      _problem = null;
      _sent = null;
    });
    try {
      final r = await ref.read(myTicketsServiceProvider).requestEntryCode(o.id);
      if (mounted) {
        setState(() {
          _sending = false;
          _sent = 'We sent a 6-digit code to ${r.emailPreview}. It works for ${r.expiresIn.inMinutes} minutes. Show it at the door with this QR code.';
        });
      }
    } on SiteException catch (e) {
      if (mounted) {
        setState(() {
          _sending = false;
          _problem = e.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(myTicketOrdersProvider);
    final now = widget._now ?? DateTime.now();
    return Scaffold(
      appBar: AppBar(title: const Text('Ticket')),
      body: orders.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => LoadFailed(message: error is SiteException ? error.message : loadFailedMessage('your tickets'), onRetry: () => ref.invalidate(myTicketOrdersProvider)),
        data: (all) {
          TicketOrder? o;
          for (final x in all) {
            if (x.id == widget.orderId) o = x;
          }
          if (o == null) return const EmptyState(icon: Icons.confirmation_number_outlined, title: 'Ticket not found', text: 'It may have been refunded or removed. Check My tickets.');
          return _body(o, now);
        },
      ),
    );
  }

  Widget _body(TicketOrder o, DateTime now) {
    final theme = Theme.of(context);
    final usable = o.isPaid && !o.isUsed && !o.isPast(now);
    return ListView(
      key: const Key('ticket-page'),
      padding: const EdgeInsets.all(20),
      children: [
        Text(o.eventTitle, key: const Key('ticket-event'), style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800), textAlign: TextAlign.center),
        const SizedBox(height: 6),
        if (o.eventStart != null) Text(formatWhen(o.eventStart!), key: const Key('ticket-when'), textAlign: TextAlign.center, style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary)),
        if (o.venueName != null) Text([o.venueName!, if (o.address != null) o.address!].join(' · '), key: const Key('ticket-where'), textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 20),
        if (o.isRefunded)
          Container(key: const Key('ticket-refunded'), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(12)), child: const Text('This order was refunded, so the ticket cannot be used.', textAlign: TextAlign.center))
        else if (o.ticketCode != null) ...[
          Center(child: Opacity(opacity: usable ? 1 : 0.35, child: TicketQr(code: o.ticketCode!))),
          const SizedBox(height: 12),
          if (o.isUsed) Text('Used ${formatWhen(o.checkedInAt!)}', key: const Key('ticket-used'), textAlign: TextAlign.center, style: theme.textTheme.titleSmall)
          else if (o.isPast(now)) const Text('This event has ended.', key: Key('ticket-ended'), textAlign: TextAlign.center)
          else Text('Show this at the door.', textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
        ],
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                _Row('Tickets', '${o.quantity} × ${o.tierName ?? 'Ticket'}', 'ticket-line'),
                _Row('Total paid', formatPrice(o.amountCents, currency: o.currency), 'ticket-paid'),
                if (o.discountCents > 0) _Row('Promo code', '-${formatMoney(o.discountCents, currency: o.currency)}', 'ticket-discount'),
                _Row('Bought', formatWhen(o.createdAt), 'ticket-bought'),
              ],
            ),
          ),
        ),
        if (usable && o.isNonTransferable) ...[
          const SizedBox(height: 16),
          Text('This ticket stays with you. The door will ask for a 6-digit code that we email to you.', style: theme.textTheme.bodyMedium),
          const SizedBox(height: 8),
          OutlinedButton.icon(key: const Key('send-entry-code'), onPressed: _sending ? null : () => _sendCode(o), icon: const Icon(Icons.mail_outline), label: Text(_sending ? 'Sending...' : 'Email me the entry code')),
          if (_sent != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_sent!, key: const Key('entry-code-sent'), style: TextStyle(color: theme.colorScheme.primary))),
          if (_problem != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_problem!, key: const Key('entry-code-problem'), style: TextStyle(color: theme.colorScheme.error))),
        ],
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value, this.keyName);

  final String label;
  final String value;
  final String keyName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [Expanded(child: Text(label)), Text(value, key: Key(keyName), style: const TextStyle(fontWeight: FontWeight.w600))]),
    );
  }
}
