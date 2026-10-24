import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/table_booking.dart';
import '../../../site/money.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/table_rules.dart';
import '../../../site/site_error.dart';
import '../../../site/when.dart';
import '../../tickets_site/widgets/ticket_qr.dart';

/// One table booking: the QR code to show at the door, where and when, the guests, and what it cost, line by line, including what is still to pay at the club and anything refunded.
class TableBookingDetailScreen extends ConsumerWidget {
  const TableBookingDetailScreen({super.key, required this.bookingId, DateTime? now}) : _now = now;

  final String bookingId;
  final DateTime? _now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(tableBookingProvider(bookingId));
    return Scaffold(
      appBar: AppBar(title: const Text('Table booking')),
      body: booking.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => LoadFailed(message: error is SiteException ? error.message : loadFailedMessage('this booking'), onRetry: () => ref.invalidate(tableBookingProvider(bookingId))),
        data: (b) {
          if (b == null) return const EmptyState(icon: Icons.table_restaurant_outlined, title: 'Booking not found', text: 'It may have been removed. Check your bookings.');
          return _Body(booking: b, now: _now ?? DateTime.now());
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.booking, required this.now});

  final TableBooking booking;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final b = booking;
    String money(int c) => formatMoney(c, currency: b.currency);
    final over = b.isOver(now);
    final usable = b.isPaid && !over;
    final night = nightOf(b.bookingDate, b.startTime);
    final crossesMidnight = b.startTime != null && isAfterMidnightSlot(b.startTime!);
    Widget line(String label, String value, String key, {bool bold = false, Color? color}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            children: [
              Expanded(child: Text(label, key: Key(key), style: (bold ? theme.textTheme.titleSmall : theme.textTheme.bodyLarge)?.copyWith(color: color))),
              Text(value, key: Key('$key-value'), style: (bold ? theme.textTheme.titleMedium : theme.textTheme.bodyLarge)?.copyWith(color: color)),
            ],
          ),
        );
    final live = [for (final l in b.bottles) if (!l.cancelled) l];
    return ListView(
      key: const Key('booking-detail'),
      padding: const EdgeInsets.all(20),
      children: [
        Text(b.venueName, key: const Key('bd-venue'), style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800), textAlign: TextAlign.center),
        Text(b.tableName, key: const Key('bd-table'), style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
        const SizedBox(height: 6),
        Text(bookingWhen(b), key: const Key('bd-when'), textAlign: TextAlign.center, style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary)),
        if (crossesMidnight)
          Text('${DateFormat('EEEE').format(night)} night\'s event · arriving ${DateFormat('EEEE').format(b.bookingDate)}', key: const Key('bd-night'), textAlign: TextAlign.center, style: theme.textTheme.bodySmall),
        if (b.venueAddress != null) Text(b.venueAddress!, key: const Key('bd-address'), textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 12),
        Center(child: Chip(key: const Key('bd-status'), label: Text(b.isPaid && b.isCheckedIn ? 'Checked in' : b.status.label))),
        const SizedBox(height: 12),
        if (b.isCancelled || b.isRefunded)
          Container(
            key: const Key('bd-closed'),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(12)),
            child: Text(
              b.isRefunded ? 'This booking was refunded, so the code cannot be used.' : 'This booking was cancelled${b.cancellationReason == null ? '' : ': ${b.cancellationReason}'}.',
              textAlign: TextAlign.center,
            ),
          )
        else if (b.isPaid && b.confirmationCode != null) ...[
          Center(child: Opacity(opacity: usable ? 1 : 0.35, child: TicketQr(code: b.confirmationCode!))),
          const SizedBox(height: 8),
          Text(over ? 'This booking has ended.' : 'Show this at the door.', key: Key(over ? 'bd-ended' : 'bd-show'), textAlign: TextAlign.center),
        ] else
          Text('This booking is not confirmed yet.', key: const Key('bd-unconfirmed'), textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 16),
        if (b.clubPayments.isNotEmpty)
          for (final p in b.clubPayments)
            Card(
              key: Key('bd-club-payment-${p.id}'),
              color: theme.colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Text(
                  'The club recorded a payment of ${money(p.paidCents)}${p.method.isEmpty ? '' : ' (${p.method})'} for your bottles and is waiting for you to confirm it. Use the link in the email we sent you.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                line('Guests', '${b.guestCount}', 'bd-guests'),
                if (b.hours != null) line('Hours', '${b.hours}', 'bd-hours'),
                const Divider(height: 20),
                line(b.hours != null ? 'Table (${b.hours} hr)' : 'Table deposit', money(b.depositCents), 'bd-line-table'),
                for (final l in live)
                  line('${l.displayName} × ${l.quantity}${l.dueAtClub ? ' · pay at the club' : ''}', money(l.lineTotalCents), 'bd-line-bottle-${l.id}'),
                for (final l in b.bottles)
                  if (l.cancelled) line('${l.displayName} × ${l.quantity} · cancelled', money(l.lineTotalCents), 'bd-line-cancelled-${l.id}', color: theme.disabledColor),
                if (b.discountCents > 0) line('Promo code', '-${money(b.discountCents)}', 'bd-line-discount'),
                if (b.taxCents > 0) line('Tax', money(b.taxCents), 'bd-line-tax'),
                if (b.feeCents > 0) line('BottlesUp fee', money(b.feeCents), 'bd-line-fee'),
                const Divider(height: 20),
                line('Total', money(b.totalCents), 'bd-line-total', bold: true),
                line('Paid', money(b.paidCents), 'bd-line-paid'),
                if (b.dueAtClubCents > 0) line('To pay at the club', money(b.dueAtClubCents), 'bd-line-due', bold: true, color: theme.colorScheme.primary),
              ],
            ),
          ),
        ),
        if (b.refunds.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text('Refunds', style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          for (var i = 0; i < b.refunds.length; i++)
            line('${money(b.refunds[i].amountCents)}${b.refunds[i].recordedAt == null ? '' : ' · ${formatDay(b.refunds[i].recordedAt!)}'}${b.refunds[i].reason.isEmpty ? '' : ' · ${b.refunds[i].reason}'}', '', 'bd-refund-$i'),
        ],
        if (b.confirmationCode != null) ...[
          const SizedBox(height: 12),
          Text('Booked ${formatWhen(b.createdAt)}', key: const Key('bd-booked'), textAlign: TextAlign.center, style: theme.textTheme.bodySmall),
        ],
      ],
    );
  }
}
