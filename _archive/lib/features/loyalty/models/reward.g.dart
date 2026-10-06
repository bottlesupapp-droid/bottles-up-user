// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RewardImpl _$$RewardImplFromJson(Map<String, dynamic> json) => _$RewardImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: $enumDecode(_$RewardTypeEnumMap, json['type']),
      status: $enumDecode(_$RewardStatusEnumMap, json['status']),
      imageUrl: json['imageUrl'] as String?,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble(),
      discountAmount: (json['discountAmount'] as num?)?.toDouble(),
      pointsCost: (json['pointsCost'] as num?)?.toInt(),
      pointsValue: (json['pointsValue'] as num?)?.toInt(),
      itemId: json['itemId'] as String?,
      itemName: json['itemName'] as String?,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      availableFrom: json['availableFrom'] == null
          ? null
          : DateTime.parse(json['availableFrom'] as String),
      termsAndConditions: json['termsAndConditions'] as String?,
      isBirthdayReward: json['isBirthdayReward'] as bool? ?? false,
      isLimitedTime: json['isLimitedTime'] as bool? ?? false,
      maxRedemptions: (json['maxRedemptions'] as num?)?.toInt(),
      currentRedemptions: (json['currentRedemptions'] as num?)?.toInt(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$RewardImplToJson(_$RewardImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'type': _$RewardTypeEnumMap[instance.type]!,
      'status': _$RewardStatusEnumMap[instance.status]!,
      'imageUrl': instance.imageUrl,
      'discountPercentage': instance.discountPercentage,
      'discountAmount': instance.discountAmount,
      'pointsCost': instance.pointsCost,
      'pointsValue': instance.pointsValue,
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'availableFrom': instance.availableFrom?.toIso8601String(),
      'termsAndConditions': instance.termsAndConditions,
      'isBirthdayReward': instance.isBirthdayReward,
      'isLimitedTime': instance.isLimitedTime,
      'maxRedemptions': instance.maxRedemptions,
      'currentRedemptions': instance.currentRedemptions,
      'metadata': instance.metadata,
    };

const _$RewardTypeEnumMap = {
  RewardType.discount: 'discount',
  RewardType.freeItem: 'freeItem',
  RewardType.upgrade: 'upgrade',
  RewardType.points: 'points',
  RewardType.earlyAccess: 'earlyAccess',
  RewardType.birthdaySpecial: 'birthdaySpecial',
};

const _$RewardStatusEnumMap = {
  RewardStatus.available: 'available',
  RewardStatus.redeemed: 'redeemed',
  RewardStatus.expired: 'expired',
  RewardStatus.pending: 'pending',
};

_$UserRewardImpl _$$UserRewardImplFromJson(Map<String, dynamic> json) =>
    _$UserRewardImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      reward: Reward.fromJson(json['reward'] as Map<String, dynamic>),
      status: $enumDecodeNullable(_$RewardStatusEnumMap, json['status']) ??
          RewardStatus.available,
      acquiredAt: DateTime.parse(json['acquiredAt'] as String),
      redeemedAt: json['redeemedAt'] == null
          ? null
          : DateTime.parse(json['redeemedAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      redemptionCode: json['redemptionCode'] as String?,
      usedAtBookingId: json['usedAtBookingId'] as String?,
    );

Map<String, dynamic> _$$UserRewardImplToJson(_$UserRewardImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'reward': instance.reward,
      'status': _$RewardStatusEnumMap[instance.status]!,
      'acquiredAt': instance.acquiredAt.toIso8601String(),
      'redeemedAt': instance.redeemedAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'redemptionCode': instance.redemptionCode,
      'usedAtBookingId': instance.usedAtBookingId,
    };

_$BirthdayRewardImpl _$$BirthdayRewardImplFromJson(Map<String, dynamic> json) =>
    _$BirthdayRewardImpl(
      userId: json['userId'] as String,
      birthMonth: (json['birthMonth'] as num).toInt(),
      birthDay: (json['birthDay'] as num).toInt(),
      reward: Reward.fromJson(json['reward'] as Map<String, dynamic>),
      hasClaimedThisYear: json['hasClaimedThisYear'] as bool? ?? false,
      lastClaimedAt: json['lastClaimedAt'] == null
          ? null
          : DateTime.parse(json['lastClaimedAt'] as String),
      nextEligibleDate: json['nextEligibleDate'] == null
          ? null
          : DateTime.parse(json['nextEligibleDate'] as String),
    );

Map<String, dynamic> _$$BirthdayRewardImplToJson(
        _$BirthdayRewardImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'birthMonth': instance.birthMonth,
      'birthDay': instance.birthDay,
      'reward': instance.reward,
      'hasClaimedThisYear': instance.hasClaimedThisYear,
      'lastClaimedAt': instance.lastClaimedAt?.toIso8601String(),
      'nextEligibleDate': instance.nextEligibleDate?.toIso8601String(),
    };

_$PointsTransactionImpl _$$PointsTransactionImplFromJson(
        Map<String, dynamic> json) =>
    _$PointsTransactionImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      points: (json['points'] as num).toInt(),
      reason: json['reason'] as String,
      transactionType: json['transactionType'] as String,
      referenceId: json['referenceId'] as String?,
      referenceType: json['referenceType'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$PointsTransactionImplToJson(
        _$PointsTransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'points': instance.points,
      'reason': instance.reason,
      'transactionType': instance.transactionType,
      'referenceId': instance.referenceId,
      'referenceType': instance.referenceType,
      'createdAt': instance.createdAt.toIso8601String(),
      'metadata': instance.metadata,
    };
