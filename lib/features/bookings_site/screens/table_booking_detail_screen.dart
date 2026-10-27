import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/table_booking.dart';
import '../../../site/money.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/table_rules.dart';
import '../../../site/site_config.dart';
import '../../../site/site_error.dart';
import '../../../site/when.dart';
import '../../tickets_site/widgets/ticket_qr.dart';
import '../../social/widgets/message_venue_button.dart';
import '../widgets/club_payment_card.dart';
import '../widgets/guests_section.dart';
import '../widgets/orders_section.dart';
import '../widgets/refund_section.dart';

/// One table booking, as a private place for the night: the QR code to show at the door, the reservation, the guests and their tickets, what was paid and what is still owed, the bottles
/// (and a way to order more), how to get there, and help with a refund. It reads and acts only through the website's own records and functions.
class TableBookingDetailScreen extends ConsumerWidget {
  const TableBookingDetailScreen({super.key, required this.bookingId, DateTime? now, this.onAddBottles, this.share}) : _now = now;

  final String bookingId;
  final DateTime? _now;

  /// Where "Order more bottles" goes. The app opens the order screen; tests give their own.
  final void Function(BuildContext context, TableBooking booking)? onAddBottles;

  /// Shares a line of text about the booking. Replaced in tests.
  final Future<void> Function(String text)? share;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(tableBookingProvider(bookingId));
    final b = booking.valueOrNull;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Table booking'),
        actions: [
          if (b != null)
            IconButton(
              key: const Key('booking-refresh'),
              tooltip: 'Refresh',
              icon: const Icon(Icons.refresh),
              onPressed: () {
                ref.invalidate(tableBookingProvider(bookingId));
                if (b.confirmationCode != null) ref.invalidate(guestRosterProvider(b.confirmationCode!));
              },
            ),
          if (b != null && b.isPaid)
            IconButton(
              key: const Key('booking-share'),
              icon: const Icon(Icons.ios_share),
              onPressed: () {
                final link = b.venueId == null ? '' : '\n${venuePageUri(b.venueId!)}';
                (share ?? (t) => Share.share(t))('I am going to ${b.venueName} on ${DateFormat('EEE, MMM d').format(b.bookingDate)}.$link');
              },
            ),
        ],
      ),
      body: booking.when(
        skipLoadingOnRefresh: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => LoadFailed(message: error is SiteException ? error.message : loadFailedMessage('this booking'), onRetry: () => ref.invalidate(tableBookingProvider(bookingId))),
        data: (b) {
          if (b == null) return const EmptyState(icon: Icons.table_restaurant_outlined, title: 'Booking not found', text: 'It may have been removed. Check your bookings.');
          return _Body(booking: b, now: _now ?? DateTime.now(), onAddBottles: onAddBottles);
        },
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title, this.keyName, this.child);

  final String title;
  final String keyName;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 22),
        Text(title, key: Key(keyName), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.booking, required this.now, required this.onAddBottles});

  final TableBooking booking;
  final DateTime now;
  final void Function(BuildContext context, TableBooking booking)? onAddBottles;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final b = booking;
    String money(int c) => formatMoney(c, currency: b.currency);
    final over = b.isOver(now);
    final usable = b.isPaid && !over;
    final canManage = usable && b.confirmationCode != null;
    final night = nightOf(b.bookingDate, b.startTime);
    final crossesMidnight = b.startTime != null && isAfterMidnightSlot(b.startTime!);
    final email = ref.watch(accountProvider).valueOrNull?.email;
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
    final opener = ref.read(urlOpenerProvider);
    Future<void> reload() async {
      ref.invalidate(tableBookingProvider(b.id));
      await ref.read(tableBookingProvider(b.id).future).catchError((_) => null);
    }

    return RefreshIndicator(
      onRefresh: reload,
      child: ListView(
      key: const Key('booking-detail'),
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
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
        _Section(
          'Entry',
          'section-entry',
          b.isCancelled || b.isRefunded
              ? Container(
                  key: const Key('bd-closed'),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    b.isRefunded ? 'This booking was refunded, so the code cannot be used.' : 'This booking was cancelled${b.cancellationReason == null ? '' : ': ${b.cancellationReason}'}.',
                    textAlign: TextAlign.center,
                  ),
                )
              : (b.isPaid && b.confirmationCode != null
                  ? Column(
                      children: [
                        Center(child: Opacity(opacity: usable ? 1 : 0.35, child: TicketQr(code: b.confirmationCode!))),
                        const SizedBox(height: 8),
                        Text(over ? 'This booking has ended.' : 'Show this at the door.', key: Key(over ? 'bd-ended' : 'bd-show'), textAlign: TextAlign.center),
                      ],
                    )
                  : Text('This booking is not confirmed yet.', key: const Key('bd-unconfirmed'), textAlign: TextAlign.center, style: theme.textTheme.bodyMedium)),
        ),
        _Section(
          'Reservation',
          'section-reservation',
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  line('Table', b.tableName, 'bd-reservation-table'),
                  line('Guests', '${b.guestCount}', 'bd-guests'),
                  if (b.hours != null) line('Hours', '${b.hours}', 'bd-hours'),
                ],
              ),
            ),
          ),
        ),
        if (canManage) _Section('Guests', 'section-guests', GuestsSection(code: b.confirmationCode!)),
        _Section(
          'Payments',
          'section-payments',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final p in b.clubPayments) ClubPaymentCard(bookingId: b.id, payment: p, currency: b.currency),
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      line(b.hours != null ? 'Table (${b.hours} hr)' : 'Table deposit', money(b.depositCents), 'bd-line-table'),
                      for (final l in live) line('${l.displayName} × ${l.quantity}${l.dueAtClub ? ' · pay at the club' : ''}', money(l.lineTotalCents), 'bd-line-bottle-${l.id}'),
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
                const SizedBox(height: 12),
                Text('Refunds', style: theme.textTheme.titleSmall),
                const SizedBox(height: 4),
                for (var i = 0; i < b.refunds.length; i++)
                  line('${money(b.refunds[i].amountCents)}${b.refunds[i].recordedAt == null ? '' : ' · ${formatDay(b.refunds[i].recordedAt!)}'}${b.refunds[i].reason.isEmpty ? '' : ' · ${b.refunds[i].reason}'}', '', 'bd-refund-$i'),
              ],
              if (b.isPaid) ...[
                const SizedBox(height: 12),
                RefundSection(booking: b, email: email, canAsk: usable && b.paidCents > 0 && !b.isCheckedIn),
              ],
            ],
          ),
        ),
        if (b.isPaid && b.venueId != null && canMessageVenue(ref)) _Section('Messages', 'section-messages', MessageVenueButton(bookingId: b.id)),
        if (b.isPaid)
          _Section(
            'Orders',
            'section-orders',
            OrdersSection(booking: b, canOrder: canManage && b.venueId != null, onAddBottles: () => (onAddBottles ?? (c, x) => c.push('/bookings/${x.id}/bottles'))(context, b)),
          ),
        if (!b.isCancelled && (b.venueAddress != null || b.venuePhone != null))
          _Section(
            'Getting there',
            'section-getting-there',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (b.venueAddress != null) Text(b.venueAddress!, key: const Key('gt-address')),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    if (b.venueAddress != null) OutlinedButton.icon(key: const Key('maps-open'), onPressed: () => opener(mapsSearchUri(b.venueAddress!)), icon: const Icon(Icons.directions_outlined), label: const Text('Directions')),
                    if (b.venuePhone != null) OutlinedButton.icon(key: const Key('venue-call'), onPressed: () => opener(Uri(scheme: 'tel', path: b.venuePhone!.replaceAll(RegExp(r'[^0-9+]'), ''))), icon: const Icon(Icons.phone_outlined), label: const Text('Call the venue')),
                  ],
                ),
                const SizedBox(height: 6),
                Text('Parking and live occupancy are not shown: the venue has not given them to BottlesUp.', style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        if ((over || b.isCancelled || b.isRefunded) && b.venueId != null) ...[
          const SizedBox(height: 22),
          Center(child: OutlinedButton.icon(key: const Key('book-again'), onPressed: () => context.push('/venues/${b.venueId}'), icon: const Icon(Icons.replay), label: Text('Book ${b.venueName} again'))),
        ],
        if (b.confirmationCode != null) ...[
          const SizedBox(height: 20),
          Text('Booked ${formatWhen(b.createdAt)}', key: const Key('bd-booked'), textAlign: TextAlign.center, style: theme.textTheme.bodySmall),
        ],
      ],
      ),
    );
  }
}
