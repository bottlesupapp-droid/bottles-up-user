import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/reward.dart';

class RewardService {
  static final RewardService _instance = RewardService._internal();
  factory RewardService() => _instance;
  RewardService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Get available rewards for user
  Future<List<Reward>> getAvailableRewards() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _supabase.rpc('get_available_rewards', params: {
        'user_id_param': currentUser.id,
      });

      return (response as List)
          .map((item) => Reward.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get user's rewards
  Future<List<UserReward>> getUserRewards({
    RewardStatus? status,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      var query = _supabase
          .from('user_rewards')
          .select('*, reward:rewards(*)')
          .eq('user_id', currentUser.id);

      if (status != null) {
        query = query.eq('status', status.name);
      }

      final response = await query.order('acquired_at', ascending: false);

      return (response as List)
          .map((item) => UserReward.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Redeem reward
  Future<UserReward> redeemReward(String rewardId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.rpc('redeem_reward', params: {
        'user_id_param': currentUser.id,
        'reward_id_param': rewardId,
      });

      return UserReward.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to redeem reward: $e');
    }
  }

  // Use reward at booking
  Future<void> useReward({
    required String userRewardId,
    required String bookingId,
  }) async {
    try {
      await _supabase.from('user_rewards').update({
        'status': RewardStatus.redeemed.name,
        'redeemed_at': DateTime.now().toIso8601String(),
        'used_at_booking_id': bookingId,
      }).eq('id', userRewardId);
    } catch (e) {
      throw Exception('Failed to use reward: $e');
    }
  }

  // Check birthday reward eligibility
  Future<BirthdayReward?> checkBirthdayReward() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return null;

      final response = await _supabase.rpc('check_birthday_reward', params: {
        'user_id_param': currentUser.id,
      });

      if (response == null) return null;

      return BirthdayReward.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  // Claim birthday reward
  Future<UserReward?> claimBirthdayReward() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.rpc('claim_birthday_reward', params: {
        'user_id_param': currentUser.id,
      });

      if (response == null) return null;

      return UserReward.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to claim birthday reward: $e');
    }
  }

  // Check if birthday is coming up (within 30 days)
  Future<bool> isBirthdayUpcoming() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return false;

      final response = await _supabase
          .from('users')
          .select('date_of_birth')
          .eq('id', currentUser.id)
          .single();

      final dob = response['date_of_birth'] as String?;
      if (dob == null) return false;

      final birthDate = DateTime.parse(dob);
      final now = DateTime.now();
      final thisYearBirthday = DateTime(now.year, birthDate.month, birthDate.day);

      final daysDifference = thisYearBirthday.difference(now).inDays;

      return daysDifference >= 0 && daysDifference <= 30;
    } catch (e) {
      return false;
    }
  }

  // Get points transactions
  Future<List<PointsTransaction>> getPointsTransactions({
    int limit = 50,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _supabase
          .from('loyalty_points_history')
          .select()
          .eq('user_id', currentUser.id)
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((item) => PointsTransaction.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get reward by ID
  Future<Reward?> getRewardById(String rewardId) async {
    try {
      final response = await _supabase
          .from('rewards')
          .select()
          .eq('id', rewardId)
          .maybeSingle();

      if (response == null) return null;

      return Reward.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  // Check if user can afford reward
  Future<bool> canAffordReward(String rewardId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return false;

      final response = await _supabase.rpc('can_afford_reward', params: {
        'user_id_param': currentUser.id,
        'reward_id_param': rewardId,
      });

      return response as bool? ?? false;
    } catch (e) {
      return false;
    }
  }

  // Get rewards by type
  Future<List<Reward>> getRewardsByType(RewardType type) async {
    try {
      final response = await _supabase
          .from('rewards')
          .select()
          .eq('type', type.name)
          .eq('status', RewardStatus.available.name);

      return (response as List)
          .map((item) => Reward.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get limited time rewards
  Future<List<Reward>> getLimitedTimeRewards() async {
    try {
      final now = DateTime.now().toIso8601String();
      final response = await _supabase
          .from('rewards')
          .select()
          .eq('is_limited_time', true)
          .eq('status', RewardStatus.available.name)
          .gte('expires_at', now)
          .order('expires_at', ascending: true);

      return (response as List)
          .map((item) => Reward.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Calculate reward discount
  double calculateRewardDiscount({
    required Reward reward,
    required double originalAmount,
  }) {
    if (reward.discountPercentage != null) {
      return originalAmount * (reward.discountPercentage! / 100);
    } else if (reward.discountAmount != null) {
      return reward.discountAmount!;
    }
    return 0;
  }

  // Expire old rewards
  Future<void> expireOldRewards() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase.from('user_rewards').update({
        'status': RewardStatus.expired.name,
      }).eq('user_id', currentUser.id).eq('status', RewardStatus.available.name).lt('expires_at', DateTime.now().toIso8601String());
    } catch (e) {
      // Non-critical error
    }
  }

  // Subscribe to new rewards
  RealtimeChannel subscribeToNewRewards({
    required Function(Reward) onNewReward,
  }) {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    final channel = _supabase.channel('new_rewards_${currentUser.id}');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'user_rewards',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: currentUser.id,
          ),
          callback: (payload) async {
            final rewardId = payload.newRecord['reward_id'] as String;
            final reward = await getRewardById(rewardId);
            if (reward != null) {
              onNewReward(reward);
            }
          },
        )
        .subscribe();

    return channel;
  }
}
