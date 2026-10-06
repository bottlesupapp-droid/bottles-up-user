// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TierImpl _$$TierImplFromJson(Map<String, dynamic> json) => _$TierImpl(
      level: $enumDecode(_$TierLevelEnumMap, json['level']),
      name: json['name'] as String,
      description: json['description'] as String,
      minPoints: (json['minPoints'] as num).toInt(),
      minSpend: (json['minSpend'] as num).toInt(),
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      benefits:
          (json['benefits'] as List<dynamic>).map((e) => e as String).toList(),
      colorHex: json['colorHex'] as String,
      iconAsset: json['iconAsset'] as String,
      earlyAccess: json['earlyAccess'] as bool? ?? false,
      priorityBookingHours:
          (json['priorityBookingHours'] as num?)?.toInt() ?? 0,
      pointsMultiplier: (json['pointsMultiplier'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$$TierImplToJson(_$TierImpl instance) =>
    <String, dynamic>{
      'level': _$TierLevelEnumMap[instance.level]!,
      'name': instance.name,
      'description': instance.description,
      'minPoints': instance.minPoints,
      'minSpend': instance.minSpend,
      'discountPercentage': instance.discountPercentage,
      'benefits': instance.benefits,
      'colorHex': instance.colorHex,
      'iconAsset': instance.iconAsset,
      'earlyAccess': instance.earlyAccess,
      'priorityBookingHours': instance.priorityBookingHours,
      'pointsMultiplier': instance.pointsMultiplier,
    };

const _$TierLevelEnumMap = {
  TierLevel.select: 'select',
  TierLevel.signature: 'signature',
  TierLevel.reserve: 'reserve',
  TierLevel.noir: 'noir',
};
