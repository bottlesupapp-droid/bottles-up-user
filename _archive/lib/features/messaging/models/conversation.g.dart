// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationImpl _$$ConversationImplFromJson(Map<String, dynamic> json) =>
    _$ConversationImpl(
      id: json['id'] as String,
      name: json['name'] as String?,
      type: $enumDecode(_$ConversationTypeEnumMap, json['type']),
      imageUrl: json['imageUrl'] as String?,
      createdBy: json['createdBy'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      lastMessageAt: DateTime.parse(json['lastMessageAt'] as String),
      lastMessageContent: json['lastMessageContent'] as String?,
      lastMessageSenderId: json['lastMessageSenderId'] as String?,
      lastMessageSenderName: json['lastMessageSenderName'] as String?,
      unreadCount: (json['unreadCount'] as num?)?.toInt(),
      participants: (json['participants'] as List<dynamic>?)
          ?.map((e) =>
              ConversationParticipant.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ConversationImplToJson(_$ConversationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$ConversationTypeEnumMap[instance.type]!,
      'imageUrl': instance.imageUrl,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'lastMessageAt': instance.lastMessageAt.toIso8601String(),
      'lastMessageContent': instance.lastMessageContent,
      'lastMessageSenderId': instance.lastMessageSenderId,
      'lastMessageSenderName': instance.lastMessageSenderName,
      'unreadCount': instance.unreadCount,
      'participants': instance.participants,
    };

const _$ConversationTypeEnumMap = {
  ConversationType.direct: 'direct',
  ConversationType.group: 'group',
};

_$ConversationParticipantImpl _$$ConversationParticipantImplFromJson(
        Map<String, dynamic> json) =>
    _$ConversationParticipantImpl(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      userId: json['userId'] as String,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      lastReadAt: DateTime.parse(json['lastReadAt'] as String),
      isAdmin: json['isAdmin'] as bool? ?? false,
      userName: json['userName'] as String?,
      userEmail: json['userEmail'] as String?,
      userAvatarUrl: json['userAvatarUrl'] as String?,
    );

Map<String, dynamic> _$$ConversationParticipantImplToJson(
        _$ConversationParticipantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'userId': instance.userId,
      'joinedAt': instance.joinedAt.toIso8601String(),
      'lastReadAt': instance.lastReadAt.toIso8601String(),
      'isAdmin': instance.isAdmin,
      'userName': instance.userName,
      'userEmail': instance.userEmail,
      'userAvatarUrl': instance.userAvatarUrl,
    };
