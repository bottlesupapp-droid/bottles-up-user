import 'package:freezed_annotation/freezed_annotation.dart';

part 'reward.freezed.dart';
part 'reward.g.dart';

enum RewardType {
  discount,
  freeItem,
  upgrade,
  points,
  earlyAccess,
  birthdaySpecial,
}

enum RewardStatus {
  available,
  redeemed,
  expired,
  pending,
}

@freezed
class Reward with _$Reward {
  const factory Reward({
    required String id,
    required String name,
    required String description,
    required RewardType type,
    required RewardStatus status,
    String? imageUrl,
    double? discountPercentage,
    double? discountAmount,
    int? pointsCost,
    int? pointsValue,
    String? itemId,
    String? itemName,
    DateTime? expiresAt,
    DateTime? availableFrom,
    String? termsAndConditions,
    @Default(false) bool isBirthdayReward,
    @Default(false) bool isLimitedTime,
    int? maxRedemptions,
    int? currentRedemptions,
    Map<String, dynamic>? metadata,
  }) = _Reward;

  factory Reward.fromJson(Map<String, dynamic> json) =>
      _$RewardFromJson(json);

  factory Reward.fromSupabase(Map<String, dynamic> data) {
    return Reward(
      id: data['id'] as String,
      name: data['name'] as String,
      description: data['description'] as String,
      type: RewardType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => RewardType.discount,
      ),
      status: RewardStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => RewardStatus.available,
      ),
      imageUrl: data['image_url'] as String?,
      discountPercentage: (data['discount_percentage'] as num?)?.toDouble(),
      discountAmount: (data['discount_amount'] as num?)?.toDouble(),
      pointsCost: data['points_cost'] as int?,
      pointsValue: data['points_value'] as int?,
      itemId: data['item_id'] as String?,
      itemName: data['item_name'] as String?,
      expiresAt: data['expires_at'] != null
          ? DateTime.parse(data['expires_at'] as String)
          : null,
      availableFrom: data['available_from'] != null
          ? DateTime.parse(data['available_from'] as String)
          : null,
      termsAndConditions: data['terms_and_conditions'] as String?,
      isBirthdayReward: data['is_birthday_reward'] as bool? ?? false,
      isLimitedTime: data['is_limited_time'] as bool? ?? false,
      maxRedemptions: data['max_redemptions'] as int?,
      currentRedemptions: data['current_redemptions'] as int?,
      metadata: data['metadata'] != null
          ? Map<String, dynamic>.from(data['metadata'] as Map)
          : null,
    );
  }
}

@freezed
class UserReward with _$UserReward {
  const factory UserReward({
    required String id,
    required String userId,
    required Reward reward,
    @Default(RewardStatus.available) RewardStatus status,
    required DateTime acquiredAt,
    DateTime? redeemedAt,
    DateTime? expiresAt,
    String? redemptionCode,
    String? usedAtBookingId,
  }) = _UserReward;

  factory UserReward.fromJson(Map<String, dynamic> json) =>
      _$UserRewardFromJson(json);

  factory UserReward.fromSupabase(Map<String, dynamic> data) {
    return UserReward(
      id: data['id'] as String,
      userId: data['user_id'] as String,
      reward: Reward.fromSupabase(data['reward'] as Map<String, dynamic>),
      status: RewardStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => RewardStatus.available,
      ),
      acquiredAt: DateTime.parse(data['acquired_at'] as String),
      redeemedAt: data['redeemed_at'] != null
          ? DateTime.parse(data['redeemed_at'] as String)
          : null,
      expiresAt: data['expires_at'] != null
          ? DateTime.parse(data['expires_at'] as String)
          : null,
      redemptionCode: data['redemption_code'] as String?,
      usedAtBookingId: data['used_at_booking_id'] as String?,
    );
  }
}

@freezed
class BirthdayReward with _$BirthdayReward {
  const factory BirthdayReward({
    required String userId,
    required int birthMonth,
    required int birthDay,
    required Reward reward,
    @Default(false) bool hasClaimedThisYear,
    DateTime? lastClaimedAt,
    DateTime? nextEligibleDate,
  }) = _BirthdayReward;

  factory BirthdayReward.fromJson(Map<String, dynamic> json) =>
      _$BirthdayRewardFromJson(json);

  factory BirthdayReward.fromSupabase(Map<String, dynamic> data) {
    return BirthdayReward(
      userId: data['user_id'] as String,
      birthMonth: data['birth_month'] as int,
      birthDay: data['birth_day'] as int,
      reward: Reward.fromSupabase(data['reward'] as Map<String, dynamic>),
      hasClaimedThisYear: data['has_claimed_this_year'] as bool? ?? false,
      lastClaimedAt: data['last_claimed_at'] != null
          ? DateTime.parse(data['last_claimed_at'] as String)
          : null,
      nextEligibleDate: data['next_eligible_date'] != null
          ? DateTime.parse(data['next_eligible_date'] as String)
          : null,
    );
  }
}

@freezed
class PointsTransaction with _$PointsTransaction {
  const factory PointsTransaction({
    required String id,
    required String userId,
    required int points,
    required String reason,
    required String transactionType,
    String? referenceId,
    String? referenceType,
    required DateTime createdAt,
    Map<String, dynamic>? metadata,
  }) = _PointsTransaction;

  factory PointsTransaction.fromJson(Map<String, dynamic> json) =>
      _$PointsTransactionFromJson(json);

  factory PointsTransaction.fromSupabase(Map<String, dynamic> data) {
    return PointsTransaction(
      id: data['id'] as String,
      userId: data['user_id'] as String,
      points: data['points'] as int,
      reason: data['reason'] as String,
      transactionType: data['transaction_type'] as String,
      referenceId: data['reference_id'] as String?,
      referenceType: data['reference_type'] as String?,
      createdAt: DateTime.parse(data['created_at'] as String),
      metadata: data['metadata'] != null
          ? Map<String, dynamic>.from(data['metadata'] as Map)
          : null,
    );
  }
}
