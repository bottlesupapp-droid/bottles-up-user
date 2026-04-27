// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_follow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VenueFollowImpl _$$VenueFollowImplFromJson(Map<String, dynamic> json) =>
    _$VenueFollowImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      clubId: json['clubId'] as String,
      userName: json['userName'] as String?,
      userAvatar: json['userAvatar'] as String?,
      clubName: json['clubName'] as String?,
      clubLocation: json['clubLocation'] as String?,
      clubImageUrl: json['clubImageUrl'] as String?,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$VenueFollowImplToJson(_$VenueFollowImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'clubId': instance.clubId,
      'userName': instance.userName,
      'userAvatar': instance.userAvatar,
      'clubName': instance.clubName,
      'clubLocation': instance.clubLocation,
      'clubImageUrl': instance.clubImageUrl,
      'notificationsEnabled': instance.notificationsEnabled,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$VenueFollowStatsImpl _$$VenueFollowStatsImplFromJson(
        Map<String, dynamic> json) =>
    _$VenueFollowStatsImpl(
      clubId: json['clubId'] as String,
      followersCount: (json['followersCount'] as num).toInt(),
      eventsCount: (json['eventsCount'] as num).toInt(),
      isFollowing: json['isFollowing'] as bool,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$VenueFollowStatsImplToJson(
        _$VenueFollowStatsImpl instance) =>
    <String, dynamic>{
      'clubId': instance.clubId,
      'followersCount': instance.followersCount,
      'eventsCount': instance.eventsCount,
      'isFollowing': instance.isFollowing,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

_$FollowedVenueUpdateImpl _$$FollowedVenueUpdateImplFromJson(
        Map<String, dynamic> json) =>
    _$FollowedVenueUpdateImpl(
      id: json['id'] as String,
      clubId: json['clubId'] as String,
      clubName: json['clubName'] as String,
      clubImageUrl: json['clubImageUrl'] as String?,
      updateType: $enumDecode(_$UpdateTypeEnumMap, json['updateType']),
      title: json['title'] as String,
      message: json['message'] as String,
      eventId: json['eventId'] as String?,
      eventName: json['eventName'] as String?,
      eventDate: json['eventDate'] == null
          ? null
          : DateTime.parse(json['eventDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
    );

Map<String, dynamic> _$$FollowedVenueUpdateImplToJson(
        _$FollowedVenueUpdateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clubId': instance.clubId,
      'clubName': instance.clubName,
      'clubImageUrl': instance.clubImageUrl,
      'updateType': _$UpdateTypeEnumMap[instance.updateType]!,
      'title': instance.title,
      'message': instance.message,
      'eventId': instance.eventId,
      'eventName': instance.eventName,
      'eventDate': instance.eventDate?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'isRead': instance.isRead,
    };

const _$UpdateTypeEnumMap = {
  UpdateType.newEvent: 'new_event',
  UpdateType.eventUpdate: 'event_update',
  UpdateType.specialOffer: 'special_offer',
  UpdateType.announcement: 'announcement',
  UpdateType.general: 'general',
};
