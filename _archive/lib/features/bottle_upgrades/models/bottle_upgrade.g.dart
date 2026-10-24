// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bottle_upgrade.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BottleUpgradeImpl _$$BottleUpgradeImplFromJson(Map<String, dynamic> json) =>
    _$BottleUpgradeImpl(
      id: json['id'] as String,
      bottleId: json['bottleId'] as String,
      originalBottleName: json['originalBottleName'] as String,
      upgradeBottleName: json['upgradeBottleName'] as String,
      originalPrice: (json['originalPrice'] as num).toDouble(),
      upgradePrice: (json['upgradePrice'] as num).toDouble(),
      priceDifference: (json['priceDifference'] as num).toDouble(),
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      isAvailable: json['isAvailable'] as bool? ?? false,
      isPremium: json['isPremium'] as bool? ?? false,
      remainingStock: (json['remainingStock'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$BottleUpgradeImplToJson(_$BottleUpgradeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bottleId': instance.bottleId,
      'originalBottleName': instance.originalBottleName,
      'upgradeBottleName': instance.upgradeBottleName,
      'originalPrice': instance.originalPrice,
      'upgradePrice': instance.upgradePrice,
      'priceDifference': instance.priceDifference,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'isAvailable': instance.isAvailable,
      'isPremium': instance.isPremium,
      'remainingStock': instance.remainingStock,
    };

_$UpgradeRequestImpl _$$UpgradeRequestImplFromJson(Map<String, dynamic> json) =>
    _$UpgradeRequestImpl(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String,
      userId: json['userId'] as String,
      originalBottleId: json['originalBottleId'] as String,
      upgradeBottleId: json['upgradeBottleId'] as String,
      priceDifference: (json['priceDifference'] as num).toDouble(),
      status: $enumDecodeNullable(_$UpgradeStatusEnumMap, json['status']) ??
          UpgradeStatus.pending,
      notes: json['notes'] as String?,
      approvedAt: json['approvedAt'] == null
          ? null
          : DateTime.parse(json['approvedAt'] as String),
      rejectedAt: json['rejectedAt'] == null
          ? null
          : DateTime.parse(json['rejectedAt'] as String),
      rejectionReason: json['rejectionReason'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$UpgradeRequestImplToJson(
        _$UpgradeRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookingId': instance.bookingId,
      'userId': instance.userId,
      'originalBottleId': instance.originalBottleId,
      'upgradeBottleId': instance.upgradeBottleId,
      'priceDifference': instance.priceDifference,
      'status': _$UpgradeStatusEnumMap[instance.status]!,
      'notes': instance.notes,
      'approvedAt': instance.approvedAt?.toIso8601String(),
      'rejectedAt': instance.rejectedAt?.toIso8601String(),
      'rejectionReason': instance.rejectionReason,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$UpgradeStatusEnumMap = {
  UpgradeStatus.pending: 'pending',
  UpgradeStatus.approved: 'approved',
  UpgradeStatus.rejected: 'rejected',
  UpgradeStatus.completed: 'completed',
};
