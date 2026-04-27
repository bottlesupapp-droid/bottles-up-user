// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_cohost.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventCohostImpl _$$EventCohostImplFromJson(Map<String, dynamic> json) =>
    _$EventCohostImpl(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String?,
      invitedBy: json['invitedBy'] as String,
      status: $enumDecode(_$CohostStatusEnumMap, json['status']),
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => $enumDecode(_$CohostPermissionEnumMap, e))
          .toList(),
      invitedAt: DateTime.parse(json['invitedAt'] as String),
      respondedAt: json['respondedAt'] == null
          ? null
          : DateTime.parse(json['respondedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      notes: json['notes'] as String?,
      isPrimaryHost: json['isPrimaryHost'] as bool? ?? false,
    );

Map<String, dynamic> _$$EventCohostImplToJson(_$EventCohostImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'userId': instance.userId,
      'userName': instance.userName,
      'userAvatar': instance.userAvatar,
      'invitedBy': instance.invitedBy,
      'status': _$CohostStatusEnumMap[instance.status]!,
      'permissions': instance.permissions
          .map((e) => _$CohostPermissionEnumMap[e]!)
          .toList(),
      'invitedAt': instance.invitedAt.toIso8601String(),
      'respondedAt': instance.respondedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'notes': instance.notes,
      'isPrimaryHost': instance.isPrimaryHost,
    };

const _$CohostStatusEnumMap = {
  CohostStatus.pending: 'pending',
  CohostStatus.accepted: 'accepted',
  CohostStatus.declined: 'declined',
  CohostStatus.removed: 'removed',
};

const _$CohostPermissionEnumMap = {
  CohostPermission.editEvent: 'editEvent',
  CohostPermission.manageGuestList: 'manageGuestList',
  CohostPermission.sendAnnouncements: 'sendAnnouncements',
  CohostPermission.moderateChat: 'moderateChat',
  CohostPermission.managePoll: 'managePoll',
  CohostPermission.inviteCohost: 'inviteCohost',
  CohostPermission.viewAnalytics: 'viewAnalytics',
};

_$CohostInvitationImpl _$$CohostInvitationImplFromJson(
        Map<String, dynamic> json) =>
    _$CohostInvitationImpl(
      eventId: json['eventId'] as String,
      eventName: json['eventName'] as String,
      userId: json['userId'] as String,
      userEmail: json['userEmail'] as String,
      userName: json['userName'] as String?,
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => $enumDecode(_$CohostPermissionEnumMap, e))
          .toList(),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$CohostInvitationImplToJson(
        _$CohostInvitationImpl instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'eventName': instance.eventName,
      'userId': instance.userId,
      'userEmail': instance.userEmail,
      'userName': instance.userName,
      'permissions': instance.permissions
          .map((e) => _$CohostPermissionEnumMap[e]!)
          .toList(),
      'message': instance.message,
    };
