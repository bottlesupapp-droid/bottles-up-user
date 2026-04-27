import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_tier_status.dart';
import '../providers/tier_provider.dart';
import 'package:intl/intl.dart';

class TierTransactionList extends ConsumerWidget {
  const TierTransactionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(recentTierTransactionsProvider);

    return transactionsAsync.when(
      data: (transactions) {
        if (transactions.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.receipt_long,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 12),
                Text(
                  'No transactions yet',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Make a booking to start earning points!',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return Column(
          children: transactions.map((transaction) {
            return _TransactionItem(transaction: transaction);
          }).toList(),
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Error loading transactions',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
        ),
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final TierTransaction transaction;

  const _TransactionItem({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _getTypeColor(context).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getTypeIcon(),
              color: _getTypeColor(context),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description ?? _getDefaultDescription(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM dd, yyyy • hh:mm a')
                      .format(transaction.createdAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+${transaction.points}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: _getTypeColor(context),
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (transaction.amount > 0)
                Text(
                  '\$${transaction.amount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getTypeIcon() {
    switch (transaction.type) {
      case TierTransactionType.booking:
        return Icons.event_seat;
      case TierTransactionType.event:
        return Icons.celebration;
      case TierTransactionType.referral:
        return Icons.people;
      case TierTransactionType.birthday:
        return Icons.cake;
      case TierTransactionType.bonus:
        return Icons.card_giftcard;
      case TierTransactionType.adjustment:
        return Icons.tune;
    }
  }

  Color _getTypeColor(BuildContext context) {
    switch (transaction.type) {
      case TierTransactionType.booking:
        return Colors.blue;
      case TierTransactionType.event:
        return Colors.purple;
      case TierTransactionType.referral:
        return Colors.green;
      case TierTransactionType.birthday:
        return Colors.pink;
      case TierTransactionType.bonus:
        return Colors.orange;
      case TierTransactionType.adjustment:
        return Colors.grey;
    }
  }

  String _getDefaultDescription() {
    switch (transaction.type) {
      case TierTransactionType.booking:
        return 'Table Booking';
      case TierTransactionType.event:
        return 'Event Ticket';
      case TierTransactionType.referral:
        return 'Referral Bonus';
      case TierTransactionType.birthday:
        return 'Birthday Reward';
      case TierTransactionType.bonus:
        return 'Bonus Points';
      case TierTransactionType.adjustment:
        return 'Points Adjustment';
    }
  }
}
