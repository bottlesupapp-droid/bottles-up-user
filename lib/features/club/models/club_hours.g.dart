// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club_hours.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClubHoursImpl _$$ClubHoursImplFromJson(Map<String, dynamic> json) =>
    _$ClubHoursImpl(
      id: json['id'] as String,
      clubId: json['clubId'] as String,
      dayOfWeek: (json['dayOfWeek'] as num).toInt(),
      openTime: json['openTime'] as String?,
      closeTime: json['closeTime'] as String?,
      isClosed: json['isClosed'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ClubHoursImplToJson(_$ClubHoursImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clubId': instance.clubId,
      'dayOfWeek': instance.dayOfWeek,
      'openTime': instance.openTime,
      'closeTime': instance.closeTime,
      'isClosed': instance.isClosed,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
