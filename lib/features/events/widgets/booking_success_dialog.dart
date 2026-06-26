import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../models/event.dart';
import '../models/event_rsvp.dart';
import 'add_to_wallet_button.dart';
import 'package:bottles_up_user/features/main_navigation/providers/nav_index_provider.dart';

/// Dialog shown after successful table booking
class BookingSuccessDialog extends ConsumerWidget {
  final String eventId;
  final String bookingId;
  final Event event;
  final EventTableBooking? tableBooking;
  final String? tableName;

  const BookingSuccessDialog({
    super.key,
    required this.eventId,
    required this.bookingId,
    required this.event,
    this.tableBooking,
    this.tableName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 50,
              ),
            ),

            const Gap(20),

            // Title
            Text(
              'Booking Confirmed!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const Gap(12),

            // Description
            Text(
              'Your table reservation has been confirmed. You can add this to your Apple Wallet for easy access.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),

            const Gap(24),

            // Event Details Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(
                    context,
                    Icons.event,
                    'Event',
                    event.name,
                  ),
                  const Gap(8),
                  _buildDetailRow(
                    context,
                    Icons.calendar_today,
                    'Date',
                    event.formattedDate,
                  ),
                  const Gap(8),
                  _buildDetailRow(
                    context,
                    Icons.access_time,
                    'Time',
                    event.formattedTime,
                  ),
                  if (tableName != null) ...[
                    const Gap(8),
                    _buildDetailRow(
                      context,
                      Icons.table_bar,
                      'Table',
                      tableName!,
                    ),
                  ],
                  if (tableBooking?.partySize != null) ...[
                    const Gap(8),
                    _buildDetailRow(
                      context,
                      Icons.people,
                      'Guests',
                      '${tableBooking!.partySize}',
                    ),
                  ],
                ],
              ),
            ),

            const Gap(24),

            // Apple Wallet Button
            if (tableBooking != null && tableName != null)
              AddToWalletButton(
                eventId: eventId,
                bookingId: bookingId,
                passType: 'table_booking',
                event: event,
                tableBooking: tableBooking,
                tableName: tableName,
              ),

            const Gap(16),

            // Done Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Switch to Bookings tab (index 2) and navigate home
                  ref.read(mainNavIndexProvider.notifier).state = 2;
                  context.go('/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Theme.of(context).colorScheme.primary,
        ),
        const Gap(8),
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
