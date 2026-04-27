import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/referral.dart';

class ReferralService {
  static final ReferralService _instance = ReferralService._internal();
  factory ReferralService() => _instance;
  ReferralService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Get active referral program
  Future<ReferralProgram?> getActiveProgram() async {
    try {
      final response = await _supabase
          .from('referral_programs')
          .select()
          .eq('is_active', true)
          .maybeSingle();

      if (response == null) return null;

      return ReferralProgram.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  // Get user's referral code
  Future<String> getUserReferralCode() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Check if user already has a referral code
      final existing = await _supabase
          .from('users')
          .select('referral_code')
          .eq('id', currentUser.id)
          .single();

      if (existing['referral_code'] != null) {
        return existing['referral_code'] as String;
      }

      // Generate new referral code
      final code = _generateReferralCode(currentUser.id);

      await _supabase.from('users').update({
        'referral_code': code,
      }).eq('id', currentUser.id);

      return code;
    } catch (e) {
      throw Exception('Failed to get referral code: $e');
    }
  }

  // Create referral
  Future<UserReferral> createReferral({
    String? refereeEmail,
    String? refereePhone,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final code = await getUserReferralCode();

      final response = await _supabase.from('user_referrals').insert({
        'referrer_id': currentUser.id,
        'referral_code': code,
        'referee_email': refereeEmail,
        'referee_phone': refereePhone,
        'status': ReferralStatus.pending.name,
        'expires_at': DateTime.now()
            .add(const Duration(days: 30))
            .toIso8601String(),
      }).select().single();

      return UserReferral.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to create referral: $e');
    }
  }

  // Apply referral code (for new users)
  Future<UserReferral?> applyReferralCode(String referralCode) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.rpc('apply_referral_code', params: {
        'referral_code_param': referralCode,
        'referee_id_param': currentUser.id,
      });

      if (response == null) return null;

      return UserReferral.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  // Get user's referrals
  Future<List<UserReferral>> getUserReferrals({
    ReferralStatus? status,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      var query = _supabase
          .from('user_referrals')
          .select()
          .eq('referrer_id', currentUser.id);

      if (status != null) {
        query = query.eq('status', status.name);
      }

      final response = await query.order('created_at', ascending: false);

      return (response as List)
          .map((item) => UserReferral.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get referral statistics
  Future<ReferralStats?> getReferralStats() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return null;

      final response = await _supabase.rpc('get_referral_stats', params: {
        'user_id_param': currentUser.id,
      });

      if (response == null) return null;

      return ReferralStats.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  // Complete referral (called when referee completes required action)
  Future<void> completeReferral(String referralId) async {
    try {
      await _supabase.rpc('complete_referral', params: {
        'referral_id_param': referralId,
      });
    } catch (e) {
      throw Exception('Failed to complete referral: $e');
    }
  }

  // Get referral leaderboard
  Future<List<ReferralLeaderboard>> getLeaderboard({
    int limit = 100,
    String period = 'all_time', // all_time, monthly, weekly
  }) async {
    try {
      final response = await _supabase.rpc('get_referral_leaderboard', params: {
        'limit_param': limit,
        'period_param': period,
      });

      return (response as List)
          .map((item) =>
              ReferralLeaderboard.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get user's rank on leaderboard
  Future<int?> getUserRank() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return null;

      final response = await _supabase.rpc('get_user_referral_rank', params: {
        'user_id_param': currentUser.id,
      });

      return response as int?;
    } catch (e) {
      return null;
    }
  }

  // Generate shareable referral link
  String generateReferralLink(String referralCode) {
    return 'https://bottlesup.com/invite/$referralCode';
  }

  // Generate referral message
  String generateReferralMessage({
    required String referralCode,
    String? userName,
  }) {
    final link = generateReferralLink(referralCode);
    final name = userName ?? 'A friend';

    return '$name invited you to join BottlesUp! Use code $referralCode to get exclusive rewards. Download now: $link';
  }

  // Share referral via social media
  Future<void> shareReferral({
    required String referralCode,
    String? platform,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      // Track share event
      await _supabase.from('referral_shares').insert({
        'user_id': currentUser.id,
        'referral_code': referralCode,
        'platform': platform,
      });
    } catch (e) {
      // Non-critical error
    }
  }

  // Check if referral code is valid
  Future<bool> validateReferralCode(String code) async {
    try {
      final response = await _supabase
          .from('users')
          .select('id')
          .eq('referral_code', code)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }

  // Get pending rewards
  Future<List<Map<String, dynamic>>> getPendingRewards() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _supabase
          .from('user_referrals')
          .select()
          .eq('referrer_id', currentUser.id)
          .eq('status', ReferralStatus.completed.name)
          .eq('referrer_rewarded', false);

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      return [];
    }
  }

  // Claim referral rewards
  Future<void> claimReferralRewards(String referralId) async {
    try {
      await _supabase.rpc('claim_referral_reward', params: {
        'referral_id_param': referralId,
      });
    } catch (e) {
      throw Exception('Failed to claim reward: $e');
    }
  }

  // Generate unique referral code
  String _generateReferralCode(String userId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final userHash = userId.substring(0, 4).toUpperCase();
    final timeHash = (timestamp % 10000).toString().padLeft(4, '0');

    return '$userHash$timeHash';
  }

  // Get referral conversion rate
  Future<double> getConversionRate() async {
    try {
      final stats = await getReferralStats();
      if (stats == null || stats.totalReferrals == 0) return 0.0;

      return (stats.completedReferrals / stats.totalReferrals) * 100;
    } catch (e) {
      return 0.0;
    }
  }

  // Get top referrers
  Future<List<Map<String, dynamic>>> getTopReferrers({
    int limit = 10,
  }) async {
    try {
      final response = await _supabase.rpc('get_top_referrers', params: {
        'limit_param': limit,
      });

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      return [];
    }
  }

  // Subscribe to referral updates
  RealtimeChannel subscribeToReferralUpdates({
    required Function(UserReferral) onReferralUpdate,
  }) {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    final channel = _supabase.channel('referral_updates_${currentUser.id}');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'user_referrals',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'referrer_id',
            value: currentUser.id,
          ),
          callback: (payload) {
            final referral = UserReferral.fromSupabase(payload.newRecord);
            onReferralUpdate(referral);
          },
        )
        .subscribe();

    return channel;
  }
}
