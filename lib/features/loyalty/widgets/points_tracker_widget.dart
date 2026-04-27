import 'package:flutter/material.dart';
import '../models/reward.dart';
import '../services/loyalty_service.dart';

class PointsTrackerWidget extends StatefulWidget {
  const PointsTrackerWidget({super.key});

  @override
  State<PointsTrackerWidget> createState() => _PointsTrackerWidgetState();
}

class _PointsTrackerWidgetState extends State<PointsTrackerWidget> {
  final _loyaltyService = LoyaltyService();
  List<PointsTransaction> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() => _isLoading = true);
    try {
      final history = await _loyaltyService.getPointsHistory(limit: 20);
      setState(() {
        _transactions = history
            .map((item) => PointsTransaction.fromSupabase(item))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_transactions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.history, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No points history yet',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _transactions.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final transaction = _transactions[index];
        final isPositive = transaction.points > 0;

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: isPositive
                ? Colors.green.withOpacity(0.1)
                : Colors.red.withOpacity(0.1),
            child: Icon(
              isPositive ? Icons.add : Icons.remove,
              color: isPositive ? Colors.green : Colors.red,
            ),
          ),
          title: Text(
            transaction.reason,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            _formatDate(transaction.createdAt),
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          trailing: Text(
            '${isPositive ? '+' : ''}${transaction.points}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isPositive ? Colors.green : Colors.red,
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return '${diff.inMinutes}m ago';
      }
      return '${diff.inHours}h ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}

// Compact points summary widget
class PointsSummaryWidget extends StatelessWidget {
  final int totalPoints;
  final int pointsThisMonth;
  final double pointsMultiplier;

  const PointsSummaryWidget({
    super.key,
    required this.totalPoints,
    required this.pointsThisMonth,
    required this.pointsMultiplier,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: _buildStat(
                context,
                'Total Points',
                totalPoints.toString(),
                Icons.account_balance_wallet,
                Colors.blue,
              ),
            ),
            Container(
              width: 1,
              height: 48,
              color: Colors.grey[300],
            ),
            Expanded(
              child: _buildStat(
                context,
                'This Month',
                pointsThisMonth.toString(),
                Icons.calendar_today,
                Colors.green,
              ),
            ),
            Container(
              width: 1,
              height: 48,
              color: Colors.grey[300],
            ),
            Expanded(
              child: _buildStat(
                context,
                'Multiplier',
                '${pointsMultiplier}x',
                Icons.trending_up,
                Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// Points earning opportunities widget
class PointsOpportunitiesWidget extends StatelessWidget {
  const PointsOpportunitiesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final opportunities = [
      {
        'title': 'Make a Booking',
        'points': '50-500',
        'icon': Icons.event,
        'color': Colors.blue,
      },
      {
        'title': 'Write a Review',
        'points': '25',
        'icon': Icons.rate_review,
        'color': Colors.orange,
      },
      {
        'title': 'Refer a Friend',
        'points': '100',
        'icon': Icons.person_add,
        'color': Colors.green,
      },
      {
        'title': 'Complete Profile',
        'points': '50',
        'icon': Icons.account_circle,
        'color': Colors.purple,
      },
      {
        'title': 'Birthday Bonus',
        'points': '200',
        'icon': Icons.cake,
        'color': Colors.pink,
      },
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.amber),
                SizedBox(width: 8),
                Text(
                  'Earn More Points',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...opportunities.map((opp) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (opp['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        opp['icon'] as IconData,
                        color: opp['color'] as Color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        opp['title'] as String,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '+${opp['points']} pts',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
