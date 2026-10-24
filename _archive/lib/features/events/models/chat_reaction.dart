import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_reaction.freezed.dart';
part 'chat_reaction.g.dart';

@freezed
class ChatReaction with _$ChatReaction {
  const factory ChatReaction({
    required String id,
    required String messageId,
    required String userId,
    required String userName,
    String? userAvatar,
    required String emoji,
    required DateTime createdAt,
  }) = _ChatReaction;

  factory ChatReaction.fromJson(Map<String, dynamic> json) =>
      _$ChatReactionFromJson(json);

  factory ChatReaction.fromSupabase(Map<String, dynamic> data) {
    return ChatReaction(
      id: data['id'] as String,
      messageId: data['message_id'] as String,
      userId: data['user_id'] as String,
      userName: data['user_name'] as String? ?? 'Unknown',
      userAvatar: data['user_avatar'] as String?,
      emoji: data['emoji'] as String,
      createdAt: DateTime.parse(data['created_at'] as String),
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'message_id': messageId,
      'user_id': userId,
      'user_name': userName,
      'user_avatar': userAvatar,
      'emoji': emoji,
    };
  }
}

@freezed
class MessageReactionSummary with _$MessageReactionSummary {
  const factory MessageReactionSummary({
    required String messageId,
    required Map<String, int> emojiCounts,
    required Map<String, List<String>> usersByEmoji,
    @Default(0) int totalReactions,
  }) = _MessageReactionSummary;

  factory MessageReactionSummary.fromJson(Map<String, dynamic> json) =>
      _$MessageReactionSummaryFromJson(json);

  factory MessageReactionSummary.fromReactions(
    String messageId,
    List<ChatReaction> reactions,
  ) {
    final emojiCounts = <String, int>{};
    final usersByEmoji = <String, List<String>>{};

    for (final reaction in reactions) {
      emojiCounts[reaction.emoji] = (emojiCounts[reaction.emoji] ?? 0) + 1;
      usersByEmoji[reaction.emoji] = [
        ...(usersByEmoji[reaction.emoji] ?? []),
        reaction.userName,
      ];
    }

    return MessageReactionSummary(
      messageId: messageId,
      emojiCounts: emojiCounts,
      usersByEmoji: usersByEmoji,
      totalReactions: reactions.length,
    );
  }
}

// Popular emoji presets
class EmojiPresets {
  static const List<String> popular = [
    '❤️', // Heart
    '👍', // Thumbs up
    '😂', // Laughing
    '🎉', // Party
    '🔥', // Fire
    '👏', // Clap
    '💯', // 100
    '😍', // Heart eyes
    '🤔', // Thinking
    '😢', // Sad
    '🙌', // Raised hands
    '✨', // Sparkles
  ];

  static const List<String> event = [
    '🎊', // Confetti
    '🥳', // Party face
    '🍾', // Champagne
    '🎵', // Music
    '💃', // Dancing
    '🕺', // Dancing man
    '🎤', // Microphone
    '🎧', // Headphones
  ];
}
