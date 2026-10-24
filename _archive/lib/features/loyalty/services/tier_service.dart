import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/tier.dart';
import '../models/user_tier_status.dart';

class TierService {
  static final TierService _instance = TierService._internal();
  factory TierService() => _instance;
  TierService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Get all available tiers
  List<Tier> getAllTiers() {
    return [
      Tier.select(),
      Tier.signature(),
      Tier.reserve(),
      Tier.noir(),
    ];
  }

  // Get tier by level
  Tier getTierByLevel(TierLevel level) {
    switch (level) {
      case TierLevel.select:
        return Tier.select();
      case TierLevel.signature:
        return Tier.signature();
      case TierLevel.reserve:
        return Tier.reserve();
      case TierLevel.noir:
        return Tier.noir();
    }
  }

  // Calculate tier based on points and spend
  Tier calculateTier(int points, double spend) {
    final tiers = getAllTiers().reversed.toList();

    for (final tier in tiers) {
      if (points >= tier.minPoints && spend >= tier.minSpend) {
        return tier;
      }
    }

    return Tier.select();
  }

  // Get user's tier status
  Future<UserTierStatus> getUserTierStatus(String userId) async {
    try {
      // In a real implementation, this would fetch from Supabase
      // For now, return mock data for frontend development
      final response = await _supabase
          .from('user_tier_status')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response != null) {
        return UserTierStatus.fromSupabase(response);
      }

      // Return default status for new users
      return UserTierStatus(
        userId: userId,
        currentTier: TierLevel.select,
        totalPoints: 0,
        totalSpend: 0.0,
        yearlyPoints: 0,
        yearlySpend: 0.0,
        lastUpdated: DateTime.now(),
        nextTier: TierLevel.signature,
        pointsToNextTier: 500,
        spendToNextTier: 2000.0,
      );
    } catch (e) {
      // Return default status on error (for frontend development)
      return UserTierStatus(
        userId: userId,
        currentTier: TierLevel.select,
        totalPoints: 0,
        totalSpend: 0.0,
        yearlyPoints: 0,
        yearlySpend: 0.0,
        lastUpdated: DateTime.now(),
        nextTier: TierLevel.signature,
        pointsToNextTier: 500,
        spendToNextTier: 2000.0,
      );
    }
  }

  // Calculate points from a purchase
  int calculatePoints(double amount, TierLevel currentTier) {
    final tier = getTierByLevel(currentTier);
    final basePoints = (amount * 0.1).round(); // 10 points per $100 spent
    return (basePoints * tier.pointsMultiplier).round();
  }

  // Add points for a transaction
  Future<void> addPoints({
    required String userId,
    required double amount,
    required TierTransactionType type,
    String? bookingId,
    String? eventId,
    String? description,
  }) async {
    try {
      final status = await getUserTierStatus(userId);
      final points = calculatePoints(amount, status.currentTier);

      await _supabase.from('tier_transactions').insert({
        'user_id': userId,
        'type': type.name,
        'points': points,
        'amount': amount,
        'description': description,
        'booking_id': bookingId,
        'event_id': eventId,
      });

      // Update user tier status (would be handled by database trigger in production)
      await _updateUserTierStatus(userId, points, amount);
    } catch (e) {
      // For frontend development, silently fail
    }
  }

  // Get recent transactions
  Future<List<TierTransaction>> getRecentTransactions(
    String userId, {
    int limit = 10,
  }) async {
    try {
      final response = await _supabase
          .from('tier_transactions')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((data) => TierTransaction.fromSupabase(data))
          .toList();
    } catch (e) {
      // Return empty list for frontend development
      return [];
    }
  }

  // Check if user can claim birthday reward
  Future<bool> canClaimBirthdayReward(String userId) async {
    try {
      final status = await getUserTierStatus(userId);

      // Check if already claimed this year
      if (status.birthdayRewardClaimedAt != null) {
        final lastClaim = status.birthdayRewardClaimedAt!;
        final now = DateTime.now();
        if (lastClaim.year == now.year) {
          return false;
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // Claim birthday reward
  Future<void> claimBirthdayReward(String userId) async {
    try {
      final status = await getUserTierStatus(userId);
      final tier = getTierByLevel(status.currentTier);

      // Calculate birthday bonus points
      int bonusPoints = 100; // Base bonus
      if (tier.level == TierLevel.signature) bonusPoints = 250;
      if (tier.level == TierLevel.reserve) bonusPoints = 500;
      if (tier.level == TierLevel.noir) bonusPoints = 1000;

      await addPoints(
        userId: userId,
        amount: 0,
        type: TierTransactionType.birthday,
        description: 'Birthday reward - ${tier.name}',
      );

      await _supabase
          .from('user_tier_status')
          .update({'birthday_reward_claimed_at': DateTime.now().toIso8601String()})
          .eq('user_id', userId);
    } catch (e) {
    }
  }

  // Add referral points
  Future<void> addReferralPoints(String userId, String referredUserId) async {
    try {
      const referralPoints = 100;
      await addPoints(
        userId: userId,
        amount: 0,
        type: TierTransactionType.referral,
        description: 'Referral bonus',
      );

      // Update referral count
      await _supabase.rpc('increment_referral_count', params: {'user_id': userId});
    } catch (e) {
    }
  }

  // Private helper to update user tier status
  Future<void> _updateUserTierStatus(
    String userId,
    int points,
    double amount,
  ) async {
    try {
      await _supabase.rpc('update_user_tier_status', params: {
        'user_id': userId,
        'points_earned': points,
        'amount_spent': amount,
      });
    } catch (e) {
    }
  }

  // Get progress to next tier
  Map<String, dynamic> getProgressToNextTier(UserTierStatus status) {
    final allTiers = getAllTiers();
    final currentTierIndex =
        allTiers.indexWhere((t) => t.level == status.currentTier);

    if (currentTierIndex == allTiers.length - 1) {
      // Already at max tier
      return {
        'isMaxTier': true,
        'pointsProgress': 1.0,
        'spendProgress': 1.0,
      };
    }

    final nextTier = allTiers[currentTierIndex + 1];
    final currentTier = allTiers[currentTierIndex];

    final pointsProgress = (status.totalPoints - currentTier.minPoints) /
        (nextTier.minPoints - currentTier.minPoints);
    final spendProgress = (status.totalSpend - currentTier.minSpend) /
        (nextTier.minSpend - currentTier.minSpend);

    return {
      'isMaxTier': false,
      'nextTier': nextTier,
      'pointsProgress': pointsProgress.clamp(0.0, 1.0),
      'spendProgress': spendProgress.clamp(0.0, 1.0),
      'pointsNeeded': (nextTier.minPoints - status.totalPoints).clamp(0, double.infinity).toInt(),
      'spendNeeded': (nextTier.minSpend - status.totalSpend).clamp(0.0, double.infinity),
    };
  }
}
