import 'package:flutter/material.dart';
import '../models/tier.dart';

class TierProgressCard extends StatelessWidget {
  final Tier currentTier;
  final Tier nextTier;
  final double pointsProgress;
  final double spendProgress;
  final int pointsNeeded;
  final double spendNeeded;
  final int currentPoints;
  final double currentSpend;

  const TierProgressCard({
    super.key,
    required this.currentTier,
    required this.nextTier,
    required this.pointsProgress,
    required this.spendProgress,
    required this.pointsNeeded,
    required this.spendNeeded,
    required this.currentPoints,
    required this.currentSpend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress to ${nextTier.name}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Icon(
                Icons.trending_up,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Points Progress
          _ProgressIndicator(
            label: 'Points',
            icon: Icons.stars,
            progress: pointsProgress,
            current: currentPoints.toString(),
            needed: pointsNeeded.toString(),
            total: nextTier.minPoints.toString(),
            color: Colors.amber,
          ),
          const SizedBox(height: 16),

          // Spend Progress
          _ProgressIndicator(
            label: 'Spend',
            icon: Icons.attach_money,
            progress: spendProgress,
            current: '\$${currentSpend.toStringAsFixed(0)}',
            needed: '\$${spendNeeded.toStringAsFixed(0)}',
            total: '\$${nextTier.minSpend}',
            color: Colors.green,
          ),
          const SizedBox(height: 16),

          // Motivational Text
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.emoji_events,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getMotivationalText(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMotivationalText() {
    final maxProgress = pointsProgress > spendProgress ? pointsProgress : spendProgress;

    if (maxProgress >= 0.75) {
      return 'You\'re almost there! Just a little more to unlock ${nextTier.name}!';
    } else if (maxProgress >= 0.5) {
      return 'Halfway there! Keep going to reach ${nextTier.name}!';
    } else if (maxProgress >= 0.25) {
      return 'Great start! Continue earning to unlock more benefits!';
    } else {
      return 'Start your journey to ${nextTier.name} and unlock exclusive perks!';
    }
  }
}

class _ProgressIndicator extends StatelessWidget {
  final String label;
  final IconData icon;
  final double progress;
  final String current;
  final String needed;
  final String total;
  final Color color;

  const _ProgressIndicator({
    required this.label,
    required this.icon,
    required this.progress,
    required this.current,
    required this.needed,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            Text(
              '$current / $total',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$needed more needed',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }
}
