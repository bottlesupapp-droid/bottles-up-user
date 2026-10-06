// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FriendImpl _$$FriendImplFromJson(Map<String, dynamic> json) => _$FriendImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      friendId: json['friendId'] as String,
      friendName: json['friendName'] as String,
      friendAvatar: json['friendAvatar'] as String?,
      friendEmail: json['friendEmail'] as String?,
      status: $enumDecode(_$FriendshipStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      acceptedAt: json['acceptedAt'] == null
          ? null
          : DateTime.parse(json['acceptedAt'] as String),
      isFavorite: json['isFavorite'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$FriendImplToJson(_$FriendImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'friendId': instance.friendId,
      'friendName': instance.friendName,
      'friendAvatar': instance.friendAvatar,
      'friendEmail': instance.friendEmail,
      'status': _$FriendshipStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'acceptedAt': instance.acceptedAt?.toIso8601String(),
      'isFavorite': instance.isFavorite,
      'metadata': instance.metadata,
    };

const _$FriendshipStatusEnumMap = {
  FriendshipStatus.pending: 'pending',
  FriendshipStatus.accepted: 'accepted',
  FriendshipStatus.declined: 'declined',
  FriendshipStatus.blocked: 'blocked',
};

_$FriendInvitationImpl _$$FriendInvitationImplFromJson(
        Map<String, dynamic> json) =>
    _$FriendInvitationImpl(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      senderAvatar: json['senderAvatar'] as String?,
      recipientId: json['recipientId'] as String?,
      recipientEmail: json['recipientEmail'] as String?,
      recipientPhone: json['recipientPhone'] as String?,
      method: $enumDecode(_$InvitationMethodEnumMap, json['method']),
      status: $enumDecodeNullable(_$FriendshipStatusEnumMap, json['status']) ??
          FriendshipStatus.pending,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      invitationCode: json['invitationCode'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$FriendInvitationImplToJson(
        _$FriendInvitationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'senderAvatar': instance.senderAvatar,
      'recipientId': instance.recipientId,
      'recipientEmail': instance.recipientEmail,
      'recipientPhone': instance.recipientPhone,
      'method': _$InvitationMethodEnumMap[instance.method]!,
      'status': _$FriendshipStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'invitationCode': instance.invitationCode,
      'message': instance.message,
    };

const _$InvitationMethodEnumMap = {
  InvitationMethod.email: 'email',
  InvitationMethod.phone: 'phone',
  InvitationMethod.username: 'username',
  InvitationMethod.contact: 'contact',
  InvitationMethod.qrCode: 'qrCode',
};

_$ContactSuggestionImpl _$$ContactSuggestionImplFromJson(
        Map<String, dynamic> json) =>
    _$ContactSuggestionImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      isAlreadyFriend: json['isAlreadyFriend'] as bool? ?? false,
      hasAppInstalled: json['hasAppInstalled'] as bool? ?? false,
      mutualFriends: (json['mutualFriends'] as num?)?.toInt() ?? 0,
      mutualFriendNames: (json['mutualFriendNames'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$ContactSuggestionImplToJson(
        _$ContactSuggestionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'avatar': instance.avatar,
      'isAlreadyFriend': instance.isAlreadyFriend,
      'hasAppInstalled': instance.hasAppInstalled,
      'mutualFriends': instance.mutualFriends,
      'mutualFriendNames': instance.mutualFriendNames,
    };

_$FriendActivityImpl _$$FriendActivityImplFromJson(Map<String, dynamic> json) =>
    _$FriendActivityImpl(
      id: json['id'] as String,
      friendId: json['friendId'] as String,
      friendName: json['friendName'] as String,
      friendAvatar: json['friendAvatar'] as String?,
      activityType: json['activityType'] as String,
      activityDescription: json['activityDescription'] as String,
      activityData: json['activityData'] as Map<String, dynamic>?,
      activityAt: DateTime.parse(json['activityAt'] as String),
    );

Map<String, dynamic> _$$FriendActivityImplToJson(
        _$FriendActivityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'friendId': instance.friendId,
      'friendName': instance.friendName,
      'friendAvatar': instance.friendAvatar,
      'activityType': instance.activityType,
      'activityDescription': instance.activityDescription,
      'activityData': instance.activityData,
      'activityAt': instance.activityAt.toIso8601String(),
    };
