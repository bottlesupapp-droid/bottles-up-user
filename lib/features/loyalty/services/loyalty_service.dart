import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/loyalty_tier.dart';

class LoyaltyService {
  static final LoyaltyService _instance = LoyaltyService._internal();
  factory LoyaltyService() => _instance;
  LoyaltyService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Get user's loyalty status
  Future<UserLoyaltyStatus?> getUserLoyaltyStatus() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return null;

      final response = await _supabase.rpc('get_user_loyalty_status', params: {
        'user_id_param': currentUser.id,
      });

      return UserLoyaltyStatus.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  // Get all loyalty tiers
  Future<List<LoyaltyTier>> getAllTiers() async {
    try {
      final response = await _supabase
          .from('loyalty_tiers')
          .select()
          .order('min_points', ascending: true);

      return (response as List)
          .map((item) => LoyaltyTier.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Check if user has early access to event
  Future<bool> hasEarlyAccess(String eventId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return false;

      final response = await _supabase.rpc('check_early_access', params: {
        'user_id_param': currentUser.id,
        'event_id_param': eventId,
      });

      return response as bool? ?? false;
    } catch (e) {
      return false;
    }
  }

  // Get early access events for user
  Future<List<EarlyAccessEvent>> getEarlyAccessEvents() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _supabase.rpc('get_early_access_events', params: {
        'user_id_param': currentUser.id,
      });

      return (response as List)
          .map((item) => EarlyAccessEvent.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get exclusive events for user's tier
  Future<List<ExclusiveEvent>> getExclusiveEvents() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _supabase.rpc('get_exclusive_events', params: {
        'user_id_param': currentUser.id,
      });

      return (response as List)
          .map((item) => ExclusiveEvent.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Check if user can access exclusive event
  Future<bool> canAccessExclusiveEvent(String eventId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return false;

      final response = await _supabase.rpc('check_exclusive_event_access', params: {
        'user_id_param': currentUser.id,
        'event_id_param': eventId,
      });

      return response as bool? ?? false;
    } catch (e) {
      return false;
    }
  }

  // RSVP to exclusive event
  Future<void> rsvpExclusiveEvent(String eventId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      await _supabase.from('exclusive_event_rsvps').insert({
        'event_id': eventId,
        'user_id': currentUser.id,
      });
    } catch (e) {
      throw Exception('Failed to RSVP: $e');
    }
  }

  // Get tier by level
  Future<LoyaltyTier?> getTierByLevel(TierLevel level) async {
    try {
      final response = await _supabase
          .from('loyalty_tiers')
          .select()
          .eq('level', level.name)
          .maybeSingle();

      if (response == null) return null;

      return LoyaltyTier.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  // Calculate points for action
  Future<int> calculatePointsForAction({
    required String actionType,
    double? amount,
  }) async {
    try {
      final response = await _supabase.rpc('calculate_loyalty_points', params: {
        'action_type_param': actionType,
        'amount_param': amount,
      });

      return response as int? ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // Award points to user
  Future<void> awardPoints({
    required int points,
    required String reason,
    String? referenceId,
    String? referenceType,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase.from('loyalty_points_history').insert({
        'user_id': currentUser.id,
        'points': points,
        'reason': reason,
        'reference_id': referenceId,
        'reference_type': referenceType,
      });

      // Trigger tier check
      await _checkAndUpgradeTier();
    } catch (e) {
      throw Exception('Failed to award points: $e');
    }
  }

  // Check if user has unlocked benefit
  Future<bool> hasBenefit(String benefitKey) async {
    try {
      final status = await getUserLoyaltyStatus();
      if (status == null) return false;

      return status.unlockedBenefits.contains(benefitKey);
    } catch (e) {
      return false;
    }
  }

  // Get user's points history
  Future<List<Map<String, dynamic>>> getPointsHistory({
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

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      return [];
    }
  }

  // Private method to check and upgrade tier
  Future<void> _checkAndUpgradeTier() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase.rpc('check_and_upgrade_tier', params: {
        'user_id_param': currentUser.id,
      });
    } catch (e) {
      // Non-critical error
    }
  }

  // Get tier progress
  Future<Map<String, dynamic>> getTierProgress() async {
    try {
      final status = await getUserLoyaltyStatus();
      if (status == null) {
        return {
          'current_points': 0,
          'next_tier_points': 0,
          'progress_percentage': 0.0,
        };
      }

      final currentPoints = status.totalPoints;
      final currentTierMin = status.currentTier.minPoints;
      final nextTierPoints = status.nextTier?.minPoints ?? status.currentTier.maxPoints;

      final pointsInCurrentRange = currentPoints - currentTierMin;
      final totalRangePoints = nextTierPoints - currentTierMin;
      final progressPercentage = totalRangePoints > 0
          ? (pointsInCurrentRange / totalRangePoints) * 100
          : 100.0;

      return {
        'current_points': currentPoints,
        'current_tier_min': currentTierMin,
        'next_tier_points': nextTierPoints,
        'points_to_next_tier': status.pointsToNextTier ?? 0,
        'progress_percentage': progressPercentage.clamp(0, 100),
        'current_tier': status.currentTier.name,
        'next_tier': status.nextTier?.name,
      };
    } catch (e) {
      return {
        'current_points': 0,
        'next_tier_points': 0,
        'progress_percentage': 0.0,
      };
    }
  }

  // Subscribe to tier changes
  RealtimeChannel subscribeToTierChanges({
    required Function(Map<String, dynamic>) onTierChange,
  }) {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    final channel = _supabase.channel('tier_changes_${currentUser.id}');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'user_loyalty',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: currentUser.id,
          ),
          callback: (payload) {
            onTierChange(payload.newRecord);
          },
        )
        .subscribe();

    return channel;
  }

  // Get estimated time to next tier
  Future<Map<String, dynamic>> getTimeToNextTier() async {
    try {
      final status = await getUserLoyaltyStatus();
      if (status == null || status.nextTier == null) {
        return {'message': 'Already at highest tier'};
      }

      final pointsHistory = await getPointsHistory(limit: 30);
      if (pointsHistory.isEmpty) {
        return {'message': 'Not enough data'};
      }

      // Calculate average points per day
      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));

      final recentPoints = pointsHistory.where((p) {
        final createdAt = DateTime.parse(p['created_at'] as String);
        return createdAt.isAfter(thirtyDaysAgo);
      }).fold<int>(0, (sum, p) => sum + (p['points'] as int));

      final daysActive = pointsHistory.length;
      final avgPointsPerDay = daysActive > 0 ? recentPoints / daysActive : 0;

      if (avgPointsPerDay <= 0) {
        return {'message': 'No recent activity'};
      }

      final pointsNeeded = status.pointsToNextTier ?? 0;
      final estimatedDays = (pointsNeeded / avgPointsPerDay).ceil();

      return {
        'points_needed': pointsNeeded,
        'avg_points_per_day': avgPointsPerDay.toStringAsFixed(1),
        'estimated_days': estimatedDays,
        'estimated_date': now.add(Duration(days: estimatedDays)).toIso8601String(),
      };
    } catch (e) {
      return {'message': 'Error calculating estimate'};
    }
  }
}
