// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnnouncementImpl _$$AnnouncementImplFromJson(Map<String, dynamic> json) =>
    _$AnnouncementImpl(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      hostId: json['hostId'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      isPinned: json['isPinned'] as bool? ?? false,
      priority: (json['priority'] as num?)?.toInt() ?? 0,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      link: json['link'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      hostName: json['hostName'] as String?,
      hostAvatar: json['hostAvatar'] as String?,
      eventName: json['eventName'] as String?,
    );

Map<String, dynamic> _$$AnnouncementImplToJson(_$AnnouncementImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'hostId': instance.hostId,
      'title': instance.title,
      'message': instance.message,
      'isPinned': instance.isPinned,
      'priority': instance.priority,
      'images': instance.images,
      'link': instance.link,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'hostName': instance.hostName,
      'hostAvatar': instance.hostAvatar,
      'eventName': instance.eventName,
    };
