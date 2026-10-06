import 'package:flutter/material.dart';
import '../models/loyalty_tier.dart';
import '../models/reward.dart';
import '../services/loyalty_service.dart';
import '../services/reward_service.dart';

class LoyaltyDashboardScreen extends StatefulWidget {
  const LoyaltyDashboardScreen({super.key});

  @override
  State<LoyaltyDashboardScreen> createState() => _LoyaltyDashboardScreenState();
}

class _LoyaltyDashboardScreenState extends State<LoyaltyDashboardScreen>
    with SingleTickerProviderStateMixin {
  final _loyaltyService = LoyaltyService();
  final _rewardService = RewardService();

  UserLoyaltyStatus? _loyaltyStatus;
  List<EarlyAccessEvent> _earlyAccessEvents = [];
  List<ExclusiveEvent> _exclusiveEvents = [];
  List<UserReward> _userRewards = [];
  BirthdayReward? _birthdayReward;
  Map<String, dynamic>? _tierProgress;
  bool _isLoading = true;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadLoyaltyData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadLoyaltyData() async {
    setState(() => _isLoading = true);
    try {
      final status = await _loyaltyService.getUserLoyaltyStatus();
      final earlyAccess = await _loyaltyService.getEarlyAccessEvents();
      final exclusive = await _loyaltyService.getExclusiveEvents();
      final rewards = await _rewardService.getUserRewards(
        status: RewardStatus.available,
      );
      final birthday = await _rewardService.checkBirthdayReward();
      final progress = await _loyaltyService.getTierProgress();

      setState(() {
        _loyaltyStatus = status;
        _earlyAccessEvents = earlyAccess;
        _exclusiveEvents = exclusive;
        _userRewards = rewards;
        _birthdayReward = birthday;
        _tierProgress = progress;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loyalty Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
            Tab(icon: Icon(Icons.card_giftcard), text: 'Rewards'),
            Tab(icon: Icon(Icons.event_available), text: 'Early Access'),
            Tab(icon: Icon(Icons.stars), text: 'Exclusive'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadLoyaltyData,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildRewardsTab(),
                  _buildEarlyAccessTab(),
                  _buildExclusiveTab(),
                ],
              ),
            ),
    );
  }

  Widget _buildOverviewTab() {
    if (_loyaltyStatus == null) {
      return const Center(child: Text('No loyalty data available'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Birthday reward banner
          if (_birthdayReward != null && !_birthdayReward!.hasClaimedThisYear)
            _buildBirthdayBanner(),

          const SizedBox(height: 16),

          // Current tier card
          _buildCurrentTierCard(),

          const SizedBox(height: 16),

          // Progress to next tier
          _buildTierProgressCard(),

          const SizedBox(height: 16),

          // Points summary
          _buildPointsSummaryCard(),

          const SizedBox(height: 16),

          // Benefits overview
          _buildBenefitsCard(),
        ],
      ),
    );
  }

  Widget _buildBirthdayBanner() {
    return Card(
      color: Colors.purple.shade50,
      child: InkWell(
        onTap: _claimBirthdayReward,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cake,
                  color: Colors.purple,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Happy Birthday! 🎉',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap to claim your birthday reward!',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentTierCard() {
    final tier = _loyaltyStatus!.currentTier;
    final color = _getTierColor(tier.level);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tier.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Icon(
                _getTierIcon(tier.level),
                size: 48,
                color: Colors.white.withOpacity(0.9),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            tier.description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTierStat(
                  'Total Points',
                  '${_loyaltyStatus!.totalPoints}',
                ),
              ),
              Expanded(
                child: _buildTierStat(
                  'Lifetime',
                  '${_loyaltyStatus!.lifetimePoints}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTierStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTierProgressCard() {
    if (_tierProgress == null || _loyaltyStatus!.nextTier == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Icon(Icons.emoji_events, size: 48, color: Colors.amber),
              const SizedBox(height: 12),
              const Text(
                'Maximum Tier Reached!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'You\'ve reached the highest tier. Keep earning points!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    final progress = _tierProgress!['progress_percentage'] as double;
    final pointsToNext = _tierProgress!['points_to_next_tier'] as int;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Next Tier',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  _loyaltyStatus!.nextTier!.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _getTierColor(_loyaltyStatus!.nextTier!.level),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress / 100,
                minHeight: 12,
                backgroundColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${progress.toStringAsFixed(0)}% Complete',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                Text(
                  '$pointsToNext points to go',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsSummaryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.account_balance_wallet, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Points Summary',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildPointsInfo(
                    'Multiplier',
                    '${_loyaltyStatus!.currentTier.pointsMultiplier}x',
                    Icons.trending_up,
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildPointsInfo(
                    'Tier Upgrades',
                    '${_loyaltyStatus!.tierUpgradeCount}',
                    Icons.arrow_upward,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsInfo(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
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
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsCard() {
    final benefits = _loyaltyStatus!.currentTier.benefits;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.verified, color: Colors.purple),
                SizedBox(width: 8),
                Text(
                  'Your Benefits',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...benefits.map((benefit) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 20),
                      const SizedBox(width: 12),
                      Expanded(child: Text(benefit)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardsTab() {
    if (_userRewards.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.card_giftcard, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No rewards available',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Keep earning points to unlock rewards!',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _userRewards.length,
      itemBuilder: (context, index) {
        final userReward = _userRewards[index];
        return _RewardCard(userReward: userReward);
      },
    );
  }

  Widget _buildEarlyAccessTab() {
    if (_earlyAccessEvents.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_available, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No early access events',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _earlyAccessEvents.length,
      itemBuilder: (context, index) {
        final event = _earlyAccessEvents[index];
        return _EarlyAccessEventCard(event: event);
      },
    );
  }

  Widget _buildExclusiveTab() {
    if (_exclusiveEvents.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.stars, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No exclusive events',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _exclusiveEvents.length,
      itemBuilder: (context, index) {
        final event = _exclusiveEvents[index];
        return _ExclusiveEventCard(event: event);
      },
    );
  }

  Future<void> _claimBirthdayReward() async {
    try {
      final reward = await _rewardService.claimBirthdayReward();
      if (reward != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Birthday reward claimed successfully! 🎉'),
            backgroundColor: Colors.green,
          ),
        );
        _loadLoyaltyData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to claim reward: $e')),
        );
      }
    }
  }

  Color _getTierColor(TierLevel level) {
    switch (level) {
      case TierLevel.bronze:
        return Colors.brown;
      case TierLevel.silver:
        return Colors.grey;
      case TierLevel.gold:
        return Colors.amber;
      case TierLevel.platinum:
        return Colors.blueGrey;
      case TierLevel.diamond:
        return Colors.cyan;
    }
  }

  IconData _getTierIcon(TierLevel level) {
    switch (level) {
      case TierLevel.bronze:
        return Icons.workspace_premium;
      case TierLevel.silver:
        return Icons.military_tech;
      case TierLevel.gold:
        return Icons.emoji_events;
      case TierLevel.platinum:
        return Icons.diamond;
      case TierLevel.diamond:
        return Icons.auto_awesome;
    }
  }
}

class _RewardCard extends StatelessWidget {
  final UserReward userReward;

  const _RewardCard({required this.userReward});

  @override
  Widget build(BuildContext context) {
    final reward = userReward.reward;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange.withOpacity(0.2),
          child: const Icon(Icons.card_giftcard, color: Colors.orange),
        ),
        title: Text(
          reward.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(reward.description),
            if (userReward.expiresAt != null) ...[
              const SizedBox(height: 4),
              Text(
                'Expires: ${_formatDate(userReward.expiresAt!)}',
                style: const TextStyle(fontSize: 12, color: Colors.red),
              ),
            ],
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {},
          child: const Text('Use'),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}

class _EarlyAccessEventCard extends StatelessWidget {
  final EarlyAccessEvent event;

  const _EarlyAccessEventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (event.eventImageUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                event.eventImageUrl!,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'EARLY ACCESS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  event.eventName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.event, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      'Early: ${_formatDateTime(event.earlyAccessStartsAt)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${event.bookedSlots}/${event.availableSlots} slots taken',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.month}/${dt.day} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _ExclusiveEventCard extends StatelessWidget {
  final ExclusiveEvent event;

  const _ExclusiveEventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.stars, color: Colors.purple),
        ),
        title: Text(
          event.eventName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(event.description, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.people, size: 14),
                const SizedBox(width: 4),
                Text('${event.currentAttendees}/${event.maxAttendees}'),
              ],
            ),
          ],
        ),
        trailing: event.requiresRSVP
            ? ElevatedButton(
                onPressed: () {},
                child: const Text('RSVP'),
              )
            : null,
      ),
    );
  }
}
