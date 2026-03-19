import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:bottles_up_user/common_widgets/default_app_bar.dart';
import 'package:bottles_up_user/core/models/payment_models.dart';
import 'package:intl/intl.dart';

class PaymentHistoryScreen extends ConsumerStatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  ConsumerState<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends ConsumerState<PaymentHistoryScreen> {
  // Mock payment history data - in a real app, this would come from your backend
  final List<BookingPayment> _mockPayments = [
    BookingPayment(
      id: '1',
      userId: 'user_1',
      bookingId: 'booking_123',
      type: PaymentType.tableBooking,
      amount: 150.0,
      currency: 'USD',
      status: PaymentStatus.succeeded,
      stripePaymentIntentId: 'pi_1234567890',
      metadata: {
        'table_name': 'T-05',
        'club_name': 'Sky Lounge NYC',
        'date': '2024-01-15',
      },
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    BookingPayment(
      id: '2',
      userId: 'user_1',
      bookingId: 'booking_124',
      type: PaymentType.eventTicket,
      amount: 75.0,
      currency: 'USD',
      status: PaymentStatus.succeeded,
      stripePaymentIntentId: 'pi_1234567891',
      metadata: {
        'event_title': 'Saturday Night Party',
        'club_name': 'The Underground',
        'tickets': '2',
      },
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    BookingPayment(
      id: '3',
      userId: 'user_1',
      bookingId: 'booking_125',
      type: PaymentType.bottleService,
      amount: 300.0,
      currency: 'USD',
      status: PaymentStatus.succeeded,
      stripePaymentIntentId: 'pi_1234567892',
      metadata: {
        'bottle_name': 'Dom Pérignon',
        'club_name': 'Velvet Lounge',
        'quantity': '1',
      },
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(
        title: 'Payment History',
      ),
      body: _mockPayments.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _mockPayments.length,
              itemBuilder: (context, index) {
                final payment = _mockPayments[index];
                return _buildPaymentCard(payment);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Iconsax.card,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const Gap(24),
          Text(
            'No Payment History',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(8),
          Text(
            'Your payment transactions will appear here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(BookingPayment payment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getPaymentTypeColor(payment.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getPaymentTypeIcon(payment.type),
                  color: _getPaymentTypeColor(payment.type),
                  size: 24,
                ),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getPaymentTypeTitle(payment.type),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      payment.metadata?['club_name'] ?? 'Unknown Venue',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${payment.amount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(payment.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getStatusText(payment.status),
                      style: TextStyle(
                        color: _getStatusColor(payment.status),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Gap(16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
              ),
            ),
            child: Column(
              children: [
                _buildDetailRow('Date', DateFormat('MMM dd, yyyy').format(payment.createdAt)),
                const Gap(8),
                _buildDetailRow('Transaction ID', payment.id),
                if (payment.metadata != null) ...
                  _buildMetadataRows(payment),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildMetadataRows(BookingPayment payment) {
    final List<Widget> rows = [];
    
    switch (payment.type) {
      case PaymentType.tableBooking:
        if (payment.metadata?['table_name'] != null) {
          rows.add(const Gap(8));
          rows.add(_buildDetailRow('Table', payment.metadata!['table_name']));
        }
        break;
      case PaymentType.eventTicket:
        if (payment.metadata?['event_title'] != null) {
          rows.add(const Gap(8));
          rows.add(_buildDetailRow('Event', payment.metadata!['event_title']));
        }
        if (payment.metadata?['tickets'] != null) {
          rows.add(const Gap(8));
          rows.add(_buildDetailRow('Tickets', payment.metadata!['tickets']));
        }
        break;
      case PaymentType.bottleService:
        if (payment.metadata?['bottle_name'] != null) {
          rows.add(const Gap(8));
          rows.add(_buildDetailRow('Bottle', payment.metadata!['bottle_name']));
        }
        if (payment.metadata?['quantity'] != null) {
          rows.add(const Gap(8));
          rows.add(_buildDetailRow('Quantity', payment.metadata!['quantity']));
        }
        break;
      case PaymentType.membership:
        break;
    }
    
    return rows;
  }

  IconData _getPaymentTypeIcon(PaymentType type) {
    switch (type) {
      case PaymentType.tableBooking:
        return Iconsax.reserve;
      case PaymentType.eventTicket:
        return Iconsax.ticket;
      case PaymentType.bottleService:
        return Iconsax.cup;
      case PaymentType.membership:
        return Iconsax.crown;
    }
  }

  Color _getPaymentTypeColor(PaymentType type) {
    switch (type) {
      case PaymentType.tableBooking:
        return Colors.blue;
      case PaymentType.eventTicket:
        return Colors.purple;
      case PaymentType.bottleService:
        return Colors.orange;
      case PaymentType.membership:
        return Colors.amber;
    }
  }

  String _getPaymentTypeTitle(PaymentType type) {
    switch (type) {
      case PaymentType.tableBooking:
        return 'Table Booking';
      case PaymentType.eventTicket:
        return 'Event Ticket';
      case PaymentType.bottleService:
        return 'Bottle Service';
      case PaymentType.membership:
        return 'Membership';
    }
  }

  Color _getStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.succeeded:
        return Colors.green;
      case PaymentStatus.processing:
        return Colors.orange;
      case PaymentStatus.canceled:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.succeeded:
        return 'Completed';
      case PaymentStatus.processing:
        return 'Processing';
      case PaymentStatus.canceled:
        return 'Canceled';
      case PaymentStatus.requiresPaymentMethod:
        return 'Pending';
      case PaymentStatus.requiresConfirmation:
        return 'Confirming';
      case PaymentStatus.requiresAction:
        return 'Action Required';
      case PaymentStatus.requiresCapture:
        return 'Capturing';
    }
  }
}