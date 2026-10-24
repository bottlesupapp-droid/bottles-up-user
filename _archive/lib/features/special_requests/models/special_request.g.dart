// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'special_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpecialRequestImpl _$$SpecialRequestImplFromJson(Map<String, dynamic> json) =>
    _$SpecialRequestImpl(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$RequestTypeEnumMap, json['type']),
      title: json['title'] as String,
      description: json['description'] as String,
      status: $enumDecodeNullable(_$RequestStatusEnumMap, json['status']) ??
          RequestStatus.pending,
      responseMessage: json['responseMessage'] as String?,
      responseTime: json['responseTime'] == null
          ? null
          : DateTime.parse(json['responseTime'] as String),
      isPriority: json['isPriority'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$SpecialRequestImplToJson(
        _$SpecialRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookingId': instance.bookingId,
      'userId': instance.userId,
      'type': _$RequestTypeEnumMap[instance.type]!,
      'title': instance.title,
      'description': instance.description,
      'status': _$RequestStatusEnumMap[instance.status]!,
      'responseMessage': instance.responseMessage,
      'responseTime': instance.responseTime?.toIso8601String(),
      'isPriority': instance.isPriority,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$RequestTypeEnumMap = {
  RequestType.dietary: 'dietary',
  RequestType.accessibility: 'accessibility',
  RequestType.music: 'music',
  RequestType.seating: 'seating',
  RequestType.celebration: 'celebration',
  RequestType.other: 'other',
};

const _$RequestStatusEnumMap = {
  RequestStatus.pending: 'pending',
  RequestStatus.acknowledged: 'acknowledged',
  RequestStatus.approved: 'approved',
  RequestStatus.declined: 'declined',
  RequestStatus.completed: 'completed',
};

_$RequestTemplateImpl _$$RequestTemplateImplFromJson(
        Map<String, dynamic> json) =>
    _$RequestTemplateImpl(
      id: json['id'] as String,
      type: $enumDecode(_$RequestTypeEnumMap, json['type']),
      title: json['title'] as String,
      description: json['description'] as String,
      exampleText: json['exampleText'] as String?,
      isPopular: json['isPopular'] as bool? ?? false,
    );

Map<String, dynamic> _$$RequestTemplateImplToJson(
        _$RequestTemplateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$RequestTypeEnumMap[instance.type]!,
      'title': instance.title,
      'description': instance.description,
      'exampleText': instance.exampleText,
      'isPopular': instance.isPopular,
    };
