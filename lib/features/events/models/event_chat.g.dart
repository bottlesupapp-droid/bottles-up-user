// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventChatMessageImpl _$$EventChatMessageImplFromJson(
        Map<String, dynamic> json) =>
    _$EventChatMessageImpl(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      userId: json['userId'] as String,
      message: json['message'] as String,
      isPinned: json['isPinned'] as bool? ?? false,
      replyToId: json['replyToId'] as String?,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      pollId: json['pollId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      userName: json['userName'] as String?,
      userAvatar: json['userAvatar'] as String?,
      replyToMessage: json['replyToMessage'] as String?,
      replyToUserName: json['replyToUserName'] as String?,
    );

Map<String, dynamic> _$$EventChatMessageImplToJson(
        _$EventChatMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'userId': instance.userId,
      'message': instance.message,
      'isPinned': instance.isPinned,
      'replyToId': instance.replyToId,
      'images': instance.images,
      'pollId': instance.pollId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'userName': instance.userName,
      'userAvatar': instance.userAvatar,
      'replyToMessage': instance.replyToMessage,
      'replyToUserName': instance.replyToUserName,
    };

_$EventPollImpl _$$EventPollImplFromJson(Map<String, dynamic> json) =>
    _$EventPollImpl(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      createdBy: json['createdBy'] as String,
      question: json['question'] as String,
      options:
          (json['options'] as List<dynamic>).map((e) => e as String).toList(),
      allowMultipleChoices: json['allowMultipleChoices'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      creatorName: json['creatorName'] as String?,
      voteCounts: (json['voteCounts'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      userVotes: (json['userVotes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$EventPollImplToJson(_$EventPollImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'createdBy': instance.createdBy,
      'question': instance.question,
      'options': instance.options,
      'allowMultipleChoices': instance.allowMultipleChoices,
      'isActive': instance.isActive,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'creatorName': instance.creatorName,
      'voteCounts': instance.voteCounts,
      'userVotes': instance.userVotes,
    };

_$PollVoteImpl _$$PollVoteImplFromJson(Map<String, dynamic> json) =>
    _$PollVoteImpl(
      id: json['id'] as String,
      pollId: json['pollId'] as String,
      userId: json['userId'] as String,
      optionIndex: json['optionIndex'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$PollVoteImplToJson(_$PollVoteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pollId': instance.pollId,
      'userId': instance.userId,
      'optionIndex': instance.optionIndex,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
