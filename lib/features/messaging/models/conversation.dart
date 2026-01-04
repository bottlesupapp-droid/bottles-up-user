import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation.freezed.dart';
part 'conversation.g.dart';

enum ConversationType { direct, group }

@freezed
class Conversation with _$Conversation {
  const factory Conversation({
    required String id,
    String? name,
    required ConversationType type,
    String? imageUrl,
    String? createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    required DateTime lastMessageAt,

    // Joined data
    String? lastMessageContent,
    String? lastMessageSenderId,
    String? lastMessageSenderName,
    int? unreadCount,
    List<ConversationParticipant>? participants,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) => _$ConversationFromJson(json);

  factory Conversation.fromSupabase(Map<String, dynamic> data) {
    return Conversation(
      id: data['id'] as String,
      name: data['name'] as String?,
      type: ConversationType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => ConversationType.direct,
      ),
      imageUrl: data['image_url'] as String?,
      createdBy: data['created_by'] as String?,
      createdAt: DateTime.parse(data['created_at'] as String),
      updatedAt: DateTime.parse(data['updated_at'] as String),
      lastMessageAt: DateTime.parse(data['last_message_at'] as String),
      lastMessageContent: data['last_message_content'] as String?,
      lastMessageSenderId: data['last_message_sender_id'] as String?,
      lastMessageSenderName: data['last_message_sender_name'] as String?,
      unreadCount: data['unread_count'] as int?,
    );
  }
}

@freezed
class ConversationParticipant with _$ConversationParticipant {
  const factory ConversationParticipant({
    required String id,
    required String conversationId,
    required String userId,
    required DateTime joinedAt,
    required DateTime lastReadAt,
    @Default(false) bool isAdmin,

    // User details from join
    String? userName,
    String? userEmail,
    String? userAvatarUrl,
  }) = _ConversationParticipant;

  factory ConversationParticipant.fromJson(Map<String, dynamic> json) =>
      _$ConversationParticipantFromJson(json);

  factory ConversationParticipant.fromSupabase(Map<String, dynamic> data) {
    return ConversationParticipant(
      id: data['id'] as String,
      conversationId: data['conversation_id'] as String,
      userId: data['user_id'] as String,
      joinedAt: DateTime.parse(data['joined_at'] as String),
      lastReadAt: DateTime.parse(data['last_read_at'] as String),
      isAdmin: data['is_admin'] as bool? ?? false,
      userName: data['user_name'] as String?,
      userEmail: data['user_email'] as String?,
      userAvatarUrl: data['user_avatar_url'] as String?,
    );
  }
}
