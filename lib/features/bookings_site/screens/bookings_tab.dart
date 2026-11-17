import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main_navigation/providers/nav_index_provider.dart';
import '../../tickets_site/screens/my_tickets_screen.dart';
import 'my_table_bookings_screen.dart';

/// Bookings (a tab): the tickets bought for events, and the VIP tables booked, one switch apart.
class BookingsTab extends ConsumerWidget {
  const BookingsTab({super.key, this.scrollController, this.now, this.showTitle = true});

  final ScrollController? scrollController;
  final DateTime? now;

  /// The big "Bookings" heading: off when the tab is inside a page that has a title of its own.
  final bool showTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final segment = ref.watch(bookingsSegmentProvider);
    final theme = Theme.of(context);
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          if (showTitle)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(child: Text('Bookings', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800))),
                ],
              ),
            )
          else
            const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: SegmentedButton<BookingsSegment>(
                key: const Key('bookings-segments'),
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(value: BookingsSegment.tickets, label: Text('Tickets', key: Key('segment-tickets')), icon: Icon(Icons.confirmation_number_outlined)),
                  ButtonSegment(value: BookingsSegment.tables, label: Text('Tables', key: Key('segment-tables')), icon: Icon(Icons.table_restaurant_outlined)),
                ],
                selected: {segment},
                onSelectionChanged: (s) => ref.read(bookingsSegmentProvider.notifier).state = s.first,
              ),
            ),
          ),
          Expanded(
            child: segment == BookingsSegment.tickets
                ? MyTicketsScreen(key: const Key('tickets-list'), scrollController: scrollController, embedded: true, now: now)
                : MyTableBookingsScreen(key: const Key('tables-list-mine'), scrollController: scrollController, embedded: true, now: now),
          ),
        ],
      ),
    );
  }
}
