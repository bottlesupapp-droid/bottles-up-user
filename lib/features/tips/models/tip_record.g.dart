// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tip_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TipRecordImpl _$$TipRecordImplFromJson(Map<String, dynamic> json) =>
    _$TipRecordImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      bookingId: json['bookingId'] as String,
      venueId: json['venueId'] as String?,
      venueName: json['venueName'] as String?,
      staffId: json['staffId'] as String?,
      staffName: json['staffName'] as String?,
      tipAmount: (json['tipAmount'] as num).toDouble(),
      billAmount: (json['billAmount'] as num).toDouble(),
      tipType: $enumDecode(_$TipTypeEnumMap, json['tipType']),
      tipPercentage: (json['tipPercentage'] as num?)?.toDouble(),
      paymentMethod: json['paymentMethod'] as String?,
      currency: json['currency'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$TipRecordImplToJson(_$TipRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'bookingId': instance.bookingId,
      'venueId': instance.venueId,
      'venueName': instance.venueName,
      'staffId': instance.staffId,
      'staffName': instance.staffName,
      'tipAmount': instance.tipAmount,
      'billAmount': instance.billAmount,
      'tipType': _$TipTypeEnumMap[instance.tipType]!,
      'tipPercentage': instance.tipPercentage,
      'paymentMethod': instance.paymentMethod,
      'currency': instance.currency,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$TipTypeEnumMap = {
  TipType.percentage: 'percentage',
  TipType.fixed: 'fixed',
  TipType.custom: 'custom',
};

_$TipStatisticsImpl _$$TipStatisticsImplFromJson(Map<String, dynamic> json) =>
    _$TipStatisticsImpl(
      totalTipped: (json['totalTipped'] as num).toDouble(),
      averageTipAmount: (json['averageTipAmount'] as num).toDouble(),
      averageTipPercentage: (json['averageTipPercentage'] as num).toDouble(),
      totalTips: (json['totalTips'] as num).toInt(),
      tipsByVenue: (json['tipsByVenue'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      tipsByMonth: Map<String, int>.from(json['tipsByMonth'] as Map),
      highestTip: (json['highestTip'] as num?)?.toDouble(),
      lowestTip: (json['lowestTip'] as num?)?.toDouble(),
      mostTippedVenue: json['mostTippedVenue'] as String?,
    );

Map<String, dynamic> _$$TipStatisticsImplToJson(_$TipStatisticsImpl instance) =>
    <String, dynamic>{
      'totalTipped': instance.totalTipped,
      'averageTipAmount': instance.averageTipAmount,
      'averageTipPercentage': instance.averageTipPercentage,
      'totalTips': instance.totalTips,
      'tipsByVenue': instance.tipsByVenue,
      'tipsByMonth': instance.tipsByMonth,
      'highestTip': instance.highestTip,
      'lowestTip': instance.lowestTip,
      'mostTippedVenue': instance.mostTippedVenue,
    };

_$TipPresetImpl _$$TipPresetImplFromJson(Map<String, dynamic> json) =>
    _$TipPresetImpl(
      label: json['label'] as String,
      percentage: (json['percentage'] as num).toDouble(),
      isDefault: json['isDefault'] as bool?,
    );

Map<String, dynamic> _$$TipPresetImplToJson(_$TipPresetImpl instance) =>
    <String, dynamic>{
      'label': instance.label,
      'percentage': instance.percentage,
      'isDefault': instance.isDefault,
    };
