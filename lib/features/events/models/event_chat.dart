import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_chat.freezed.dart';
part 'event_chat.g.dart';

@freezed
class EventChatMessage with _$EventChatMessage {
  const factory EventChatMessage({
    required String id,
    required String eventId,
    required String userId,
    required String message,
    @Default(false) bool isPinned,
    String? replyToId,
    List<String>? images,
    String? pollId,
    DateTime? createdAt,
    DateTime? updatedAt,

    // Joined data
    String? userName,
    String? userAvatar,
    String? replyToMessage,
    String? replyToUserName,
  }) = _EventChatMessage;

  factory EventChatMessage.fromJson(Map<String, dynamic> json) => _$EventChatMessageFromJson(json);

  factory EventChatMessage.fromSupabase(Map<String, dynamic> data) {
    return EventChatMessage(
      id: data['id'] as String,
      eventId: data['event_id'] as String,
      userId: data['user_id'] as String,
      message: data['message'] as String,
      isPinned: data['is_pinned'] as bool? ?? false,
      replyToId: data['reply_to_id'] as String?,
      images: data['images'] != null ? List<String>.from(data['images']) : null,
      pollId: data['poll_id'] as String?,
      createdAt: data['created_at'] != null ? DateTime.parse(data['created_at'] as String) : null,
      updatedAt: data['updated_at'] != null ? DateTime.parse(data['updated_at'] as String) : null,
      userName: data['user_name'] as String?,
      userAvatar: data['user_avatar'] as String?,
      replyToMessage: data['reply_to_message'] as String?,
      replyToUserName: data['reply_to_user_name'] as String?,
    );
  }
}

@freezed
class EventPoll with _$EventPoll {
  const factory EventPoll({
    required String id,
    required String eventId,
    required String createdBy,
    required String question,
    required List<String> options,
    @Default(false) bool allowMultipleChoices,
    @Default(true) bool isActive,
    DateTime? expiresAt,
    DateTime? createdAt,

    // Joined data
    String? creatorName,
    Map<String, int>? voteCounts,
    List<String>? userVotes,
  }) = _EventPoll;

  factory EventPoll.fromJson(Map<String, dynamic> json) => _$EventPollFromJson(json);

  factory EventPoll.fromSupabase(Map<String, dynamic> data) {
    return EventPoll(
      id: data['id'] as String,
      eventId: data['event_id'] as String,
      createdBy: data['created_by'] as String,
      question: data['question'] as String,
      options: List<String>.from(data['options']),
      allowMultipleChoices: data['allow_multiple_choices'] as bool? ?? false,
      isActive: data['is_active'] as bool? ?? true,
      expiresAt: data['expires_at'] != null ? DateTime.parse(data['expires_at'] as String) : null,
      createdAt: data['created_at'] != null ? DateTime.parse(data['created_at'] as String) : null,
      creatorName: data['creator_name'] as String?,
      voteCounts: data['vote_counts'] != null ? Map<String, int>.from(data['vote_counts']) : null,
      userVotes: data['user_votes'] != null ? List<String>.from(data['user_votes']) : null,
    );
  }
}

@freezed
class PollVote with _$PollVote {
  const factory PollVote({
    required String id,
    required String pollId,
    required String userId,
    required String optionIndex,
    DateTime? createdAt,
  }) = _PollVote;

  factory PollVote.fromJson(Map<String, dynamic> json) => _$PollVoteFromJson(json);

  factory PollVote.fromSupabase(Map<String, dynamic> data) {
    return PollVote(
      id: data['id'] as String,
      pollId: data['poll_id'] as String,
      userId: data['user_id'] as String,
      optionIndex: data['option_index'] as String,
      createdAt: data['created_at'] != null ? DateTime.parse(data['created_at'] as String) : null,
    );
  }
}

extension EventPollX on EventPoll {
  int get totalVotes {
    if (voteCounts == null) return 0;
    return voteCounts!.values.fold(0, (sum, count) => sum + count);
  }

  double getOptionPercentage(String optionIndex) {
    if (voteCounts == null || totalVotes == 0) return 0.0;
    final count = voteCounts![optionIndex] ?? 0;
    return (count / totalVotes) * 100;
  }

  bool get hasExpired => expiresAt != null && expiresAt!.isBefore(DateTime.now());
}
