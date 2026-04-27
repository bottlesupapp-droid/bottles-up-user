import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/tier.dart';
import '../models/user_tier_status.dart';
import '../providers/tier_provider.dart';
import '../widgets/tier_card.dart';
import '../widgets/tier_progress_card.dart';
import '../widgets/tier_benefits_list.dart';
import '../widgets/tier_transaction_list.dart';

class TierStatusScreen extends ConsumerWidget {
  const TierStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userTierStatusAsync = ref.watch(userTierStatusNotifierProvider);
    final currentTierAsync = ref.watch(currentTierProvider);
    final tierProgressAsync = ref.watch(tierProgressProvider);
    final allTiers = ref.watch(allTiersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tier Status'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showTierInfoDialog(context, allTiers),
          ),
        ],
      ),
      body: userTierStatusAsync.when(
        data: (status) {
          if (status == null) {
            return const Center(
              child: Text('Please log in to view your tier status'),
            );
          }

          return currentTierAsync.when(
            data: (currentTier) => tierProgressAsync.when(
              data: (progress) => RefreshIndicator(
                onRefresh: () async {
                  await ref.read(userTierStatusNotifierProvider.notifier).refresh();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Current Tier Card
                      TierCard(tier: currentTier, isActive: true),
                      const SizedBox(height: 24),

                      // Progress to Next Tier
                      if (!progress['isMaxTier'])
                        TierProgressCard(
                          currentTier: currentTier,
                          nextTier: progress['nextTier'] as Tier,
                          pointsProgress: progress['pointsProgress'] as double,
                          spendProgress: progress['spendProgress'] as double,
                          pointsNeeded: progress['pointsNeeded'] as int,
                          spendNeeded: progress['spendNeeded'] as double,
                          currentPoints: status.totalPoints,
                          currentSpend: status.totalSpend,
                        ),

                      if (!progress['isMaxTier']) const SizedBox(height: 24),

                      // Stats Cards
                      _buildStatsCards(status),
                      const SizedBox(height: 24),

                      // Current Tier Benefits
                      Text(
                        'Your Benefits',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 12),
                      TierBenefitsList(tier: currentTier),
                      const SizedBox(height: 24),

                      // Recent Transactions
                      Text(
                        'Recent Activity',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 12),
                      const TierTransactionList(),
                      const SizedBox(height: 24),

                      // All Tiers Overview
                      Text(
                        'All Tiers',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 12),
                      ...allTiers.map(
                        (tier) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: TierCard(
                            tier: tier,
                            isActive: tier.level == currentTier.level,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error loading tier status: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(userTierStatusNotifierProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards(UserTierStatus status) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'Total Points',
            value: status.totalPoints.toString(),
            icon: Icons.stars,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: 'Total Spend',
            value: '\$${status.totalSpend.toStringAsFixed(0)}',
            icon: Icons.attach_money,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: 'Referrals',
            value: status.referralCount.toString(),
            icon: Icons.people,
          ),
        ),
      ],
    );
  }

  void _showTierInfoDialog(BuildContext context, List<Tier> tiers) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tier System'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Earn points with every booking and unlock exclusive benefits as you climb the tiers.',
              ),
              const SizedBox(height: 16),
              ...tiers.map((tier) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tier.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Min Points: ${tier.minPoints} | Min Spend: \$${tier.minSpend}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
