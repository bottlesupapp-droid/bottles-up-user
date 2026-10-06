import 'package:flutter/material.dart';

class MinimumSpendTracker extends StatelessWidget {
  final double currentSpend;
  final double minimumSpend;
  final bool compact;

  const MinimumSpendTracker({
    super.key,
    required this.currentSpend,
    required this.minimumSpend,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentSpend / minimumSpend).clamp(0.0, 1.0);
    final remaining = (minimumSpend - currentSpend).clamp(0.0, minimumSpend);
    final isMetOrExceeded = currentSpend >= minimumSpend;

    if (compact) {
      return _buildCompactTracker(context, progress, isMetOrExceeded);
    }

    return _buildFullTracker(
      context,
      progress,
      remaining,
      isMetOrExceeded,
    );
  }

  Widget _buildCompactTracker(
    BuildContext context,
    double progress,
    bool isMetOrExceeded,
  ) {
    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              isMetOrExceeded ? Colors.green : Theme.of(context).colorScheme.primary,
            ),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '\$${currentSpend.toStringAsFixed(0)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildFullTracker(
    BuildContext context,
    double progress,
    double remaining,
    bool isMetOrExceeded,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isMetOrExceeded
              ? [Colors.green.withOpacity(0.1), Colors.green.withOpacity(0.05)]
              : [
                  Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                  Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isMetOrExceeded
              ? Colors.green
              : Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                isMetOrExceeded ? Icons.check_circle : Icons.trending_up,
                color: isMetOrExceeded ? Colors.green : Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isMetOrExceeded ? 'Minimum Spend Met!' : 'Minimum Spend Progress',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isMetOrExceeded ? Colors.green : null,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress Bar
          Stack(
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isMetOrExceeded
                          ? [Colors.green, Colors.green.shade700]
                          : [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.primaryContainer,
                            ],
                    ),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: (isMetOrExceeded ? Colors.green : Theme.of(context).colorScheme.primary)
                            .withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatColumn(
                label: 'Current Spend',
                value: '\$${currentSpend.toStringAsFixed(2)}',
                color: Theme.of(context).colorScheme.primary,
              ),
              Container(
                width: 1,
                height: 40,
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              ),
              _StatColumn(
                label: 'Minimum Required',
                value: '\$${minimumSpend.toStringAsFixed(2)}',
                color: Colors.grey[700],
              ),
            ],
          ),

          if (!isMetOrExceeded) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.amber, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Spend \$${remaining.toStringAsFixed(2)} more to meet minimum',
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (isMetOrExceeded) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green),
              ),
              child: Row(
                children: [
                  const Icon(Icons.celebration, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Great! You\'ve exceeded the minimum by \$${(currentSpend - minimumSpend).toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Progress Percentage
          const SizedBox(height: 12),
          Center(
            child: Text(
              '${(progress * 100).toStringAsFixed(0)}% Complete',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _StatColumn({
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
