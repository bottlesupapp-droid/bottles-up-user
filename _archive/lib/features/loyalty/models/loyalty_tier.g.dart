// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loyalty_tier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoyaltyTierImpl _$$LoyaltyTierImplFromJson(Map<String, dynamic> json) =>
    _$LoyaltyTierImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      level: $enumDecode(_$TierLevelEnumMap, json['level']),
      minPoints: (json['minPoints'] as num).toInt(),
      maxPoints: (json['maxPoints'] as num).toInt(),
      description: json['description'] as String,
      benefits:
          (json['benefits'] as List<dynamic>).map((e) => e as String).toList(),
      iconUrl: json['iconUrl'] as String,
      colorHex: json['colorHex'] as String,
      earlyAccessHours: (json['earlyAccessHours'] as num?)?.toInt() ?? 0,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0,
      priorityBookingDays: (json['priorityBookingDays'] as num?)?.toInt() ?? 0,
      hasExclusiveEvents: json['hasExclusiveEvents'] as bool? ?? false,
      hasBirthdayReward: json['hasBirthdayReward'] as bool? ?? false,
      pointsMultiplier: (json['pointsMultiplier'] as num?)?.toDouble() ?? 0,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$LoyaltyTierImplToJson(_$LoyaltyTierImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'level': _$TierLevelEnumMap[instance.level]!,
      'minPoints': instance.minPoints,
      'maxPoints': instance.maxPoints,
      'description': instance.description,
      'benefits': instance.benefits,
      'iconUrl': instance.iconUrl,
      'colorHex': instance.colorHex,
      'earlyAccessHours': instance.earlyAccessHours,
      'discountPercentage': instance.discountPercentage,
      'priorityBookingDays': instance.priorityBookingDays,
      'hasExclusiveEvents': instance.hasExclusiveEvents,
      'hasBirthdayReward': instance.hasBirthdayReward,
      'pointsMultiplier': instance.pointsMultiplier,
      'metadata': instance.metadata,
    };

const _$TierLevelEnumMap = {
  TierLevel.bronze: 'bronze',
  TierLevel.silver: 'silver',
  TierLevel.gold: 'gold',
  TierLevel.platinum: 'platinum',
  TierLevel.diamond: 'diamond',
};

_$UserLoyaltyStatusImpl _$$UserLoyaltyStatusImplFromJson(
        Map<String, dynamic> json) =>
    _$UserLoyaltyStatusImpl(
      userId: json['userId'] as String,
      currentTier:
          LoyaltyTier.fromJson(json['currentTier'] as Map<String, dynamic>),
      totalPoints: (json['totalPoints'] as num).toInt(),
      lifetimePoints: (json['lifetimePoints'] as num).toInt(),
      nextTier: json['nextTier'] == null
          ? null
          : LoyaltyTier.fromJson(json['nextTier'] as Map<String, dynamic>),
      pointsToNextTier: (json['pointsToNextTier'] as num?)?.toInt(),
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      lastActivityAt: json['lastActivityAt'] == null
          ? null
          : DateTime.parse(json['lastActivityAt'] as String),
      tierUpgradeCount: (json['tierUpgradeCount'] as num?)?.toInt() ?? 0,
      unlockedBenefits: (json['unlockedBenefits'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$UserLoyaltyStatusImplToJson(
        _$UserLoyaltyStatusImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'currentTier': instance.currentTier,
      'totalPoints': instance.totalPoints,
      'lifetimePoints': instance.lifetimePoints,
      'nextTier': instance.nextTier,
      'pointsToNextTier': instance.pointsToNextTier,
      'joinedAt': instance.joinedAt.toIso8601String(),
      'lastActivityAt': instance.lastActivityAt?.toIso8601String(),
      'tierUpgradeCount': instance.tierUpgradeCount,
      'unlockedBenefits': instance.unlockedBenefits,
    };

_$EarlyAccessEventImpl _$$EarlyAccessEventImplFromJson(
        Map<String, dynamic> json) =>
    _$EarlyAccessEventImpl(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      eventName: json['eventName'] as String,
      minimumTier: $enumDecode(_$TierLevelEnumMap, json['minimumTier']),
      earlyAccessStartsAt:
          DateTime.parse(json['earlyAccessStartsAt'] as String),
      publicAccessStartsAt:
          DateTime.parse(json['publicAccessStartsAt'] as String),
      availableSlots: (json['availableSlots'] as num).toInt(),
      bookedSlots: (json['bookedSlots'] as num).toInt(),
      eventImageUrl: json['eventImageUrl'] as String?,
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$$EarlyAccessEventImplToJson(
        _$EarlyAccessEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'eventName': instance.eventName,
      'minimumTier': _$TierLevelEnumMap[instance.minimumTier]!,
      'earlyAccessStartsAt': instance.earlyAccessStartsAt.toIso8601String(),
      'publicAccessStartsAt': instance.publicAccessStartsAt.toIso8601String(),
      'availableSlots': instance.availableSlots,
      'bookedSlots': instance.bookedSlots,
      'eventImageUrl': instance.eventImageUrl,
      'isActive': instance.isActive,
    };

_$ExclusiveEventImpl _$$ExclusiveEventImplFromJson(Map<String, dynamic> json) =>
    _$ExclusiveEventImpl(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      eventName: json['eventName'] as String,
      description: json['description'] as String,
      minimumTier: $enumDecode(_$TierLevelEnumMap, json['minimumTier']),
      eventDate: DateTime.parse(json['eventDate'] as String),
      maxAttendees: (json['maxAttendees'] as num).toInt(),
      currentAttendees: (json['currentAttendees'] as num).toInt(),
      venueId: json['venueId'] as String?,
      venueName: json['venueName'] as String?,
      imageUrl: json['imageUrl'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      requiresRSVP: json['requiresRSVP'] as bool? ?? true,
      isWaitlistEnabled: json['isWaitlistEnabled'] as bool? ?? false,
    );

Map<String, dynamic> _$$ExclusiveEventImplToJson(
        _$ExclusiveEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'eventName': instance.eventName,
      'description': instance.description,
      'minimumTier': _$TierLevelEnumMap[instance.minimumTier]!,
      'eventDate': instance.eventDate.toIso8601String(),
      'maxAttendees': instance.maxAttendees,
      'currentAttendees': instance.currentAttendees,
      'venueId': instance.venueId,
      'venueName': instance.venueName,
      'imageUrl': instance.imageUrl,
      'price': instance.price,
      'requiresRSVP': instance.requiresRSVP,
      'isWaitlistEnabled': instance.isWaitlistEnabled,
    };
