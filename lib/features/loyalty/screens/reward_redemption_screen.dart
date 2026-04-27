import 'package:flutter/material.dart';
import '../models/reward.dart';
import '../services/reward_service.dart';
import '../services/loyalty_service.dart';

class RewardRedemptionScreen extends StatefulWidget {
  const RewardRedemptionScreen({super.key});

  @override
  State<RewardRedemptionScreen> createState() => _RewardRedemptionScreenState();
}

class _RewardRedemptionScreenState extends State<RewardRedemptionScreen>
    with SingleTickerProviderStateMixin {
  final _rewardService = RewardService();
  final _loyaltyService = LoyaltyService();

  List<Reward> _availableRewards = [];
  List<UserReward> _myRewards = [];
  int _userPoints = 0;
  bool _isLoading = true;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadRewards();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadRewards() async {
    setState(() => _isLoading = true);
    try {
      final available = await _rewardService.getAvailableRewards();
      final myRewards = await _rewardService.getUserRewards(
        status: RewardStatus.available,
      );
      final status = await _loyaltyService.getUserLoyaltyStatus();

      setState(() {
        _availableRewards = available;
        _myRewards = myRewards;
        _userPoints = status?.totalPoints ?? 0;
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
        title: const Text('Rewards'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Available'),
            Tab(text: 'My Rewards'),
          ],
        ),
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.stars, size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    '$_userPoints pts',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadRewards,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAvailableRewards(),
                  _buildMyRewards(),
                ],
              ),
            ),
    );
  }

  Widget _buildAvailableRewards() {
    if (_availableRewards.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.card_giftcard, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No rewards available',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // Group rewards by type
    final grouped = <RewardType, List<Reward>>{};
    for (final reward in _availableRewards) {
      grouped.putIfAbsent(reward.type, () => []).add(reward);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...grouped.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  _getRewardTypeLabel(entry.key),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...entry.value.map((reward) {
                return RewardCardWidget(
                  reward: reward,
                  userPoints: _userPoints,
                  onRedeem: () => _redeemReward(reward),
                );
              }),
              const SizedBox(height: 16),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildMyRewards() {
    if (_myRewards.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No rewards yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Redeem rewards to see them here',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _myRewards.length,
      itemBuilder: (context, index) {
        final userReward = _myRewards[index];
        return UserRewardCard(
          userReward: userReward,
          onUse: () => _useReward(userReward),
        );
      },
    );
  }

  Future<void> _redeemReward(Reward reward) async {
    // Check if user can afford
    final canAfford = await _rewardService.canAffordReward(reward.id);
    if (!canAfford) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'You need ${reward.pointsCost! - _userPoints} more points',
            ),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    // Show confirmation
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Redeem Reward?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(reward.name),
            const SizedBox(height: 8),
            Text(
              'Cost: ${reward.pointsCost} points',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Remaining: ${_userPoints - reward.pointsCost!} points',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Redeem'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _rewardService.redeemReward(reward.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reward redeemed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        _loadRewards();
        _tabController.animateTo(1); // Switch to My Rewards tab
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to redeem: $e')),
        );
      }
    }
  }

  Future<void> _useReward(UserReward userReward) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.qr_code_2, size: 100),
            const SizedBox(height: 16),
            Text(
              userReward.reward.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            if (userReward.redemptionCode != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  userReward.redemptionCode!,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            const Text(
              'Show this code to staff to redeem',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRewardTypeLabel(RewardType type) {
    switch (type) {
      case RewardType.discount:
        return 'Discounts';
      case RewardType.freeItem:
        return 'Free Items';
      case RewardType.upgrade:
        return 'Upgrades';
      case RewardType.points:
        return 'Bonus Points';
      case RewardType.earlyAccess:
        return 'Early Access';
      case RewardType.birthdaySpecial:
        return 'Birthday Specials';
    }
  }
}

class RewardCardWidget extends StatelessWidget {
  final Reward reward;
  final int userPoints;
  final VoidCallback onRedeem;

  const RewardCardWidget({
    super.key,
    required this.reward,
    required this.userPoints,
    required this.onRedeem,
  });

  @override
  Widget build(BuildContext context) {
    final canAfford = reward.pointsCost != null && userPoints >= reward.pointsCost!;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: canAfford ? onRedeem : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Reward icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _getRewardColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getRewardIcon(),
                  color: _getRewardColor(),
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),

              // Reward details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reward.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      reward.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (reward.expiresAt != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 12,
                            color: Colors.orange[700],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Expires ${_formatDate(reward.expiresAt!)}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.orange[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Points cost & button
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (reward.pointsCost != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: canAfford
                            ? Colors.green.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.stars,
                            size: 14,
                            color: canAfford ? Colors.green : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${reward.pointsCost}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: canAfford ? Colors.green : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: canAfford ? onRedeem : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: const Text('Redeem'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRewardColor() {
    switch (reward.type) {
      case RewardType.discount:
        return Colors.blue;
      case RewardType.freeItem:
        return Colors.green;
      case RewardType.upgrade:
        return Colors.purple;
      case RewardType.points:
        return Colors.amber;
      case RewardType.earlyAccess:
        return Colors.orange;
      case RewardType.birthdaySpecial:
        return Colors.pink;
    }
  }

  IconData _getRewardIcon() {
    switch (reward.type) {
      case RewardType.discount:
        return Icons.discount;
      case RewardType.freeItem:
        return Icons.card_giftcard;
      case RewardType.upgrade:
        return Icons.upgrade;
      case RewardType.points:
        return Icons.stars;
      case RewardType.earlyAccess:
        return Icons.event_available;
      case RewardType.birthdaySpecial:
        return Icons.cake;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}

class UserRewardCard extends StatelessWidget {
  final UserReward userReward;
  final VoidCallback onUse;

  const UserRewardCard({
    super.key,
    required this.userReward,
    required this.onUse,
  });

  @override
  Widget build(BuildContext context) {
    final reward = userReward.reward;
    final isExpiringSoon = userReward.expiresAt != null &&
        userReward.expiresAt!.difference(DateTime.now()).inDays <= 7;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.withOpacity(0.2),
          child: const Icon(Icons.check_circle, color: Colors.green),
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
                style: TextStyle(
                  fontSize: 12,
                  color: isExpiringSoon ? Colors.red : Colors.grey[600],
                  fontWeight: isExpiringSoon ? FontWeight.bold : null,
                ),
              ),
            ],
          ],
        ),
        trailing: ElevatedButton(
          onPressed: onUse,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: const Text('Use'),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
