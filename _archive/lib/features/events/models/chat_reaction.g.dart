// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatReactionImpl _$$ChatReactionImplFromJson(Map<String, dynamic> json) =>
    _$ChatReactionImpl(
      id: json['id'] as String,
      messageId: json['messageId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String?,
      emoji: json['emoji'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ChatReactionImplToJson(_$ChatReactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'messageId': instance.messageId,
      'userId': instance.userId,
      'userName': instance.userName,
      'userAvatar': instance.userAvatar,
      'emoji': instance.emoji,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$MessageReactionSummaryImpl _$$MessageReactionSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$MessageReactionSummaryImpl(
      messageId: json['messageId'] as String,
      emojiCounts: Map<String, int>.from(json['emojiCounts'] as Map),
      usersByEmoji: (json['usersByEmoji'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ),
      totalReactions: (json['totalReactions'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$MessageReactionSummaryImplToJson(
        _$MessageReactionSummaryImpl instance) =>
    <String, dynamic>{
      'messageId': instance.messageId,
      'emojiCounts': instance.emojiCounts,
      'usersByEmoji': instance.usersByEmoji,
      'totalReactions': instance.totalReactions,
    };
