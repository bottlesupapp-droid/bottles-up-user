import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

enum MessageType { text, image, file, location }

@freezed
class Message with _$Message {
  const factory Message({
    required String id,
    required String conversationId,
    required String senderId,
    String? content,
    @Default(MessageType.text) MessageType type,
    String? mediaUrl,
    String? replyToId,
    @Default(false) bool isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,

    // Sender details from join
    String? senderName,
    String? senderAvatarUrl,

    // Reply message details
    Message? replyToMessage,

    // Reactions
    List<MessageReaction>? reactions,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  factory Message.fromSupabase(Map<String, dynamic> data) {
    return Message(
      id: data['id'] as String,
      conversationId: data['conversation_id'] as String,
      senderId: data['sender_id'] as String,
      content: data['content'] as String?,
      type: MessageType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => MessageType.text,
      ),
      mediaUrl: data['media_url'] as String?,
      replyToId: data['reply_to_id'] as String?,
      isDeleted: data['is_deleted'] as bool? ?? false,
      createdAt: DateTime.parse(data['created_at'] as String),
      updatedAt: DateTime.parse(data['updated_at'] as String),
      senderName: data['sender_name'] as String?,
      senderAvatarUrl: data['sender_avatar_url'] as String?,
    );
  }
}

@freezed
class MessageReaction with _$MessageReaction {
  const factory MessageReaction({
    required String id,
    required String messageId,
    required String userId,
    required String emoji,
    required DateTime createdAt,

    // User details
    String? userName,
    String? userAvatarUrl,
  }) = _MessageReaction;

  factory MessageReaction.fromJson(Map<String, dynamic> json) =>
      _$MessageReactionFromJson(json);

  factory MessageReaction.fromSupabase(Map<String, dynamic> data) {
    return MessageReaction(
      id: data['id'] as String,
      messageId: data['message_id'] as String,
      userId: data['user_id'] as String,
      emoji: data['emoji'] as String,
      createdAt: DateTime.parse(data['created_at'] as String),
      userName: data['user_name'] as String?,
      userAvatarUrl: data['user_avatar_url'] as String?,
    );
  }
}
