import 'package:freezed_annotation/freezed_annotation.dart';
import 'tier.dart';

part 'user_tier_status.freezed.dart';
part 'user_tier_status.g.dart';

@freezed
class UserTierStatus with _$UserTierStatus {
  const factory UserTierStatus({
    required String userId,
    required TierLevel currentTier,
    required int totalPoints,
    required double totalSpend,
    required int yearlyPoints,
    required double yearlySpend,
    required DateTime lastUpdated,
    TierLevel? nextTier,
    int? pointsToNextTier,
    double? spendToNextTier,
    @Default([]) List<TierTransaction> recentTransactions,
    DateTime? birthdayRewardClaimedAt,
    @Default(0) int referralCount,
    @Default(0) int referralPoints,
  }) = _UserTierStatus;

  factory UserTierStatus.fromJson(Map<String, dynamic> json) =>
      _$UserTierStatusFromJson(json);

  factory UserTierStatus.fromSupabase(Map<String, dynamic> data) {
    return UserTierStatus(
      userId: data['user_id'] as String,
      currentTier: TierLevel.values.firstWhere(
        (t) => t.name == data['current_tier'],
        orElse: () => TierLevel.select,
      ),
      totalPoints: data['total_points'] as int? ?? 0,
      totalSpend: (data['total_spend'] as num?)?.toDouble() ?? 0.0,
      yearlyPoints: data['yearly_points'] as int? ?? 0,
      yearlySpend: (data['yearly_spend'] as num?)?.toDouble() ?? 0.0,
      lastUpdated: DateTime.parse(data['last_updated'] as String),
      nextTier: data['next_tier'] != null
          ? TierLevel.values.firstWhere((t) => t.name == data['next_tier'])
          : null,
      pointsToNextTier: data['points_to_next_tier'] as int?,
      spendToNextTier: (data['spend_to_next_tier'] as num?)?.toDouble(),
      birthdayRewardClaimedAt: data['birthday_reward_claimed_at'] != null
          ? DateTime.parse(data['birthday_reward_claimed_at'] as String)
          : null,
      referralCount: data['referral_count'] as int? ?? 0,
      referralPoints: data['referral_points'] as int? ?? 0,
    );
  }
}

@freezed
class TierTransaction with _$TierTransaction {
  const factory TierTransaction({
    required String id,
    required String userId,
    required TierTransactionType type,
    required int points,
    required double amount,
    required DateTime createdAt,
    String? description,
    String? bookingId,
    String? eventId,
  }) = _TierTransaction;

  factory TierTransaction.fromJson(Map<String, dynamic> json) =>
      _$TierTransactionFromJson(json);

  factory TierTransaction.fromSupabase(Map<String, dynamic> data) {
    return TierTransaction(
      id: data['id'] as String,
      userId: data['user_id'] as String,
      type: TierTransactionType.values.firstWhere(
        (t) => t.name == data['type'],
        orElse: () => TierTransactionType.booking,
      ),
      points: data['points'] as int,
      amount: (data['amount'] as num).toDouble(),
      createdAt: DateTime.parse(data['created_at'] as String),
      description: data['description'] as String?,
      bookingId: data['booking_id'] as String?,
      eventId: data['event_id'] as String?,
    );
  }
}

enum TierTransactionType {
  booking,
  event,
  referral,
  birthday,
  bonus,
  adjustment,
}
