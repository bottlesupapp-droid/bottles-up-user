import 'package:freezed_annotation/freezed_annotation.dart';

part 'referral.freezed.dart';
part 'referral.g.dart';

enum ReferralStatus {
  pending,
  completed,
  rewarded,
  expired,
}

enum ReferralRewardType {
  points,
  discount,
  freeItem,
  cashback,
  tierUpgrade,
}

@freezed
class ReferralProgram with _$ReferralProgram {
  const factory ReferralProgram({
    required String id,
    required String name,
    required String description,
    required ReferralRewardType rewardType,
    required int referrerRewardValue,
    required int refereeRewardValue,
    String? referrerRewardDescription,
    String? refereeRewardDescription,
    DateTime? expiresAt,
    int? maxReferrals,
    @Default(true) bool isActive,
    Map<String, dynamic>? terms,
  }) = _ReferralProgram;

  factory ReferralProgram.fromJson(Map<String, dynamic> json) =>
      _$ReferralProgramFromJson(json);

  factory ReferralProgram.fromSupabase(Map<String, dynamic> data) {
    return ReferralProgram(
      id: data['id'] as String,
      name: data['name'] as String,
      description: data['description'] as String,
      rewardType: ReferralRewardType.values.firstWhere(
        (e) => e.name == data['reward_type'],
        orElse: () => ReferralRewardType.points,
      ),
      referrerRewardValue: data['referrer_reward_value'] as int,
      refereeRewardValue: data['referee_reward_value'] as int,
      referrerRewardDescription: data['referrer_reward_description'] as String?,
      refereeRewardDescription: data['referee_reward_description'] as String?,
      expiresAt: data['expires_at'] != null
          ? DateTime.parse(data['expires_at'] as String)
          : null,
      maxReferrals: data['max_referrals'] as int?,
      isActive: data['is_active'] as bool? ?? true,
      terms: data['terms'] != null
          ? Map<String, dynamic>.from(data['terms'] as Map)
          : null,
    );
  }
}

@freezed
class UserReferral with _$UserReferral {
  const factory UserReferral({
    required String id,
    required String referrerId,
    required String referrerName,
    String? referrerAvatar,
    String? refereeId,
    String? refereeName,
    String? refereeAvatar,
    String? refereeEmail,
    String? refereePhone,
    required String referralCode,
    required ReferralStatus status,
    required DateTime createdAt,
    DateTime? completedAt,
    DateTime? rewardedAt,
    DateTime? expiresAt,
    @Default(false) bool referrerRewarded,
    @Default(false) bool refereeRewarded,
    Map<String, dynamic>? metadata,
  }) = _UserReferral;

  factory UserReferral.fromJson(Map<String, dynamic> json) =>
      _$UserReferralFromJson(json);

  factory UserReferral.fromSupabase(Map<String, dynamic> data) {
    return UserReferral(
      id: data['id'] as String,
      referrerId: data['referrer_id'] as String,
      referrerName: data['referrer_name'] as String,
      referrerAvatar: data['referrer_avatar'] as String?,
      refereeId: data['referee_id'] as String?,
      refereeName: data['referee_name'] as String?,
      refereeAvatar: data['referee_avatar'] as String?,
      refereeEmail: data['referee_email'] as String?,
      refereePhone: data['referee_phone'] as String?,
      referralCode: data['referral_code'] as String,
      status: ReferralStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => ReferralStatus.pending,
      ),
      createdAt: DateTime.parse(data['created_at'] as String),
      completedAt: data['completed_at'] != null
          ? DateTime.parse(data['completed_at'] as String)
          : null,
      rewardedAt: data['rewarded_at'] != null
          ? DateTime.parse(data['rewarded_at'] as String)
          : null,
      expiresAt: data['expires_at'] != null
          ? DateTime.parse(data['expires_at'] as String)
          : null,
      referrerRewarded: data['referrer_rewarded'] as bool? ?? false,
      refereeRewarded: data['referee_rewarded'] as bool? ?? false,
      metadata: data['metadata'] != null
          ? Map<String, dynamic>.from(data['metadata'] as Map)
          : null,
    );
  }
}

@freezed
class ReferralStats with _$ReferralStats {
  const factory ReferralStats({
    required int totalReferrals,
    required int completedReferrals,
    required int pendingReferrals,
    required int totalRewardsEarned,
    @Default(0) int pointsEarned,
    @Default(0.0) double cashbackEarned,
    List<String>? topReferredUsers,
    DateTime? lastReferralDate,
    Map<String, int>? referralsByMonth,
  }) = _ReferralStats;

  factory ReferralStats.fromJson(Map<String, dynamic> json) =>
      _$ReferralStatsFromJson(json);

  factory ReferralStats.fromSupabase(Map<String, dynamic> data) {
    return ReferralStats(
      totalReferrals: data['total_referrals'] as int? ?? 0,
      completedReferrals: data['completed_referrals'] as int? ?? 0,
      pendingReferrals: data['pending_referrals'] as int? ?? 0,
      totalRewardsEarned: data['total_rewards_earned'] as int? ?? 0,
      pointsEarned: data['points_earned'] as int? ?? 0,
      cashbackEarned: (data['cashback_earned'] as num?)?.toDouble() ?? 0.0,
      topReferredUsers: data['top_referred_users'] != null
          ? List<String>.from(data['top_referred_users'] as List)
          : null,
      lastReferralDate: data['last_referral_date'] != null
          ? DateTime.parse(data['last_referral_date'] as String)
          : null,
      referralsByMonth: data['referrals_by_month'] != null
          ? Map<String, int>.from(data['referrals_by_month'] as Map)
          : null,
    );
  }
}

@freezed
class ReferralLeaderboard with _$ReferralLeaderboard {
  const factory ReferralLeaderboard({
    required String userId,
    required String userName,
    String? userAvatar,
    required int totalReferrals,
    required int rank,
    @Default(0) int pointsEarned,
  }) = _ReferralLeaderboard;

  factory ReferralLeaderboard.fromJson(Map<String, dynamic> json) =>
      _$ReferralLeaderboardFromJson(json);

  factory ReferralLeaderboard.fromSupabase(Map<String, dynamic> data) {
    return ReferralLeaderboard(
      userId: data['user_id'] as String,
      userName: data['user_name'] as String,
      userAvatar: data['user_avatar'] as String?,
      totalReferrals: data['total_referrals'] as int,
      rank: data['rank'] as int,
      pointsEarned: data['points_earned'] as int? ?? 0,
    );
  }
}
