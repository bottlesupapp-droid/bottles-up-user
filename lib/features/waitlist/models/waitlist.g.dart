// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waitlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WaitlistEntryImpl _$$WaitlistEntryImplFromJson(Map<String, dynamic> json) =>
    _$WaitlistEntryImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      eventId: json['eventId'] as String,
      position: (json['position'] as num).toInt(),
      partySize: (json['partySize'] as num).toInt(),
      userName: json['userName'] as String?,
      userEmail: json['userEmail'] as String?,
      userPhone: json['userPhone'] as String?,
      eventName: json['eventName'] as String?,
      eventDate: json['eventDate'] == null
          ? null
          : DateTime.parse(json['eventDate'] as String),
      status: $enumDecodeNullable(_$WaitlistStatusEnumMap, json['status']) ??
          WaitlistStatus.active,
      notes: json['notes'] as String?,
      notifiedAt: json['notifiedAt'] == null
          ? null
          : DateTime.parse(json['notifiedAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$WaitlistEntryImplToJson(_$WaitlistEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'eventId': instance.eventId,
      'position': instance.position,
      'partySize': instance.partySize,
      'userName': instance.userName,
      'userEmail': instance.userEmail,
      'userPhone': instance.userPhone,
      'eventName': instance.eventName,
      'eventDate': instance.eventDate?.toIso8601String(),
      'status': _$WaitlistStatusEnumMap[instance.status]!,
      'notes': instance.notes,
      'notifiedAt': instance.notifiedAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$WaitlistStatusEnumMap = {
  WaitlistStatus.active: 'active',
  WaitlistStatus.converted: 'converted',
  WaitlistStatus.expired: 'expired',
  WaitlistStatus.cancelled: 'cancelled',
};

_$WaitlistStatsImpl _$$WaitlistStatsImplFromJson(Map<String, dynamic> json) =>
    _$WaitlistStatsImpl(
      eventId: json['eventId'] as String,
      totalWaiting: (json['totalWaiting'] as num).toInt(),
      averageWaitTime: (json['averageWaitTime'] as num).toInt(),
      conversionRate: (json['conversionRate'] as num).toInt(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$WaitlistStatsImplToJson(_$WaitlistStatsImpl instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'totalWaiting': instance.totalWaiting,
      'averageWaitTime': instance.averageWaitTime,
      'conversionRate': instance.conversionRate,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };
