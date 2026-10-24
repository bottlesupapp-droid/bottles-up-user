import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/table_booking.dart';
import '../../../site/money.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/table_rules.dart';
import '../../../site/site_error.dart';

/// The table bookings the signed-in person has: coming up first, then past ones, then those that were cancelled or refunded. Tapping one shows the QR code and the details.
class MyTableBookingsScreen extends ConsumerWidget {
  const MyTableBookingsScreen({super.key, this.scrollController, this.onOpen, DateTime? now, this.embedded = false}) : _now = now;

  final ScrollController? scrollController;
  final void Function(BuildContext context, TableBooking booking)? onOpen;
  final DateTime? _now;

  /// Shown inside the Bookings tab, which has the title and the safe area already.
  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(myTableBookingsProvider);
    final theme = Theme.of(context);
    final now = _now ?? DateTime.now();
    final body = bookings.when(
      skipLoadingOnRefresh: true,
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => LoadFailed(message: error is SiteException ? error.message : loadFailedMessage('your bookings'), onRetry: () => ref.invalidate(myTableBookingsProvider)),
      data: (all) {
        DateTime when(TableBooking b) => b.arrival ?? b.bookingDate;
        final upcoming = [for (final b in all) if (b.isPaid && !b.isOver(now)) b]..sort((a, b) => when(a).compareTo(when(b)));
        final past = [for (final b in all) if (b.isPaid && b.isOver(now)) b]..sort((a, b) => when(b).compareTo(when(a)));
        final ended = [for (final b in all) if (b.isCancelled || b.isRefunded) b]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(myTableBookingsProvider);
            await ref.read(myTableBookingsProvider.future).catchError((_) => <TableBooking>[]);
          },
          child: ListView(
            key: const Key('my-table-bookings'),
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16, embedded ? 12 : 16, 16, 120),
            children: [
              if (!embedded) ...[
                Text('My tables', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
              ],
              if (all.isEmpty)
                const SizedBox(height: 420, child: EmptyState(icon: Icons.table_restaurant_outlined, title: 'No table bookings yet', text: 'Tables you book appear here, with the QR code to show at the door.'))
              else ...[
                if (upcoming.isEmpty) Padding(padding: const EdgeInsets.only(bottom: 12), child: Text('No upcoming bookings.', key: const Key('no-upcoming-bookings'), style: theme.textTheme.bodyMedium)),
                for (final b in upcoming) _BookingCard(booking: b, now: now, onTap: () => _open(context, b)),
                if (past.isNotEmpty) ...[
                  const _Heading('Past'),
                  for (final b in past) _BookingCard(booking: b, now: now, onTap: () => _open(context, b)),
                ],
                if (ended.isNotEmpty) ...[
                  const _Heading('Cancelled and refunded'),
                  for (final b in ended) _BookingCard(booking: b, now: now, onTap: () => _open(context, b)),
                ],
              ],
            ],
          ),
        );
      },
    );
    return embedded ? body : SafeArea(bottom: false, child: body);
  }

  void _open(BuildContext context, TableBooking b) => (onOpen ?? (c, booking) => c.push('/bookings/${booking.id}'))(context, b);
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(top: 12, bottom: 8), child: Text(text, style: Theme.of(context).textTheme.titleMedium));
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.booking, required this.now, required this.onTap});

  final TableBooking booking;
  final DateTime now;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final b = booking;
    final chip = b.isRefunded ? 'Refunded' : (b.isCancelled ? 'Cancelled' : (b.isOver(now) ? 'Ended' : (b.isCheckedIn ? 'Checked in' : null)));
    return Card(
      key: Key('booking-${b.id}'),
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(b.venueName, key: Key('booking-venue-${b.id}'), style: theme.textTheme.titleMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                    Text(b.tableName, key: Key('booking-title-${b.id}'), style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 2),
                    Text(bookingWhen(b), key: Key('booking-when-${b.id}'), style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.primary)),
                    Text('${b.guestCount} ${b.guestCount == 1 ? 'guest' : 'guests'} · ${formatMoney(b.totalCents, currency: b.currency)}', key: Key('booking-guests-${b.id}'), style: theme.textTheme.bodySmall),
                    if (b.dueAtClubCents > 0 && !b.isOver(now)) Text('${formatMoney(b.dueAtClubCents, currency: b.currency)} to pay at the club', key: Key('booking-due-${b.id}'), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary)),
                  ],
                ),
              ),
              if (chip != null) Chip(key: Key('booking-chip-${b.id}'), label: Text(chip), visualDensity: VisualDensity.compact) else const Icon(Icons.qr_code_2),
            ],
          ),
        ),
      ),
    );
  }
}
