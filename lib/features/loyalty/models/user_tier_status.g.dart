// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_tier_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserTierStatusImpl _$$UserTierStatusImplFromJson(Map<String, dynamic> json) =>
    _$UserTierStatusImpl(
      userId: json['userId'] as String,
      currentTier: $enumDecode(_$TierLevelEnumMap, json['currentTier']),
      totalPoints: (json['totalPoints'] as num).toInt(),
      totalSpend: (json['totalSpend'] as num).toDouble(),
      yearlyPoints: (json['yearlyPoints'] as num).toInt(),
      yearlySpend: (json['yearlySpend'] as num).toDouble(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      nextTier: $enumDecodeNullable(_$TierLevelEnumMap, json['nextTier']),
      pointsToNextTier: (json['pointsToNextTier'] as num?)?.toInt(),
      spendToNextTier: (json['spendToNextTier'] as num?)?.toDouble(),
      recentTransactions: (json['recentTransactions'] as List<dynamic>?)
              ?.map((e) => TierTransaction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      birthdayRewardClaimedAt: json['birthdayRewardClaimedAt'] == null
          ? null
          : DateTime.parse(json['birthdayRewardClaimedAt'] as String),
      referralCount: (json['referralCount'] as num?)?.toInt() ?? 0,
      referralPoints: (json['referralPoints'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$UserTierStatusImplToJson(
        _$UserTierStatusImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'currentTier': _$TierLevelEnumMap[instance.currentTier]!,
      'totalPoints': instance.totalPoints,
      'totalSpend': instance.totalSpend,
      'yearlyPoints': instance.yearlyPoints,
      'yearlySpend': instance.yearlySpend,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'nextTier': _$TierLevelEnumMap[instance.nextTier],
      'pointsToNextTier': instance.pointsToNextTier,
      'spendToNextTier': instance.spendToNextTier,
      'recentTransactions': instance.recentTransactions,
      'birthdayRewardClaimedAt':
          instance.birthdayRewardClaimedAt?.toIso8601String(),
      'referralCount': instance.referralCount,
      'referralPoints': instance.referralPoints,
    };

const _$TierLevelEnumMap = {
  TierLevel.select: 'select',
  TierLevel.signature: 'signature',
  TierLevel.reserve: 'reserve',
  TierLevel.noir: 'noir',
};

_$TierTransactionImpl _$$TierTransactionImplFromJson(
        Map<String, dynamic> json) =>
    _$TierTransactionImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$TierTransactionTypeEnumMap, json['type']),
      points: (json['points'] as num).toInt(),
      amount: (json['amount'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      description: json['description'] as String?,
      bookingId: json['bookingId'] as String?,
      eventId: json['eventId'] as String?,
    );

Map<String, dynamic> _$$TierTransactionImplToJson(
        _$TierTransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': _$TierTransactionTypeEnumMap[instance.type]!,
      'points': instance.points,
      'amount': instance.amount,
      'createdAt': instance.createdAt.toIso8601String(),
      'description': instance.description,
      'bookingId': instance.bookingId,
      'eventId': instance.eventId,
    };

const _$TierTransactionTypeEnumMap = {
  TierTransactionType.booking: 'booking',
  TierTransactionType.event: 'event',
  TierTransactionType.referral: 'referral',
  TierTransactionType.birthday: 'birthday',
  TierTransactionType.bonus: 'bonus',
  TierTransactionType.adjustment: 'adjustment',
};
