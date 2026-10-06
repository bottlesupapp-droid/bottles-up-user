import 'package:freezed_annotation/freezed_annotation.dart';

part 'enhanced_poll.freezed.dart';
part 'enhanced_poll.g.dart';

enum PollType {
  @JsonValue('single')
  single,
  @JsonValue('multiple')
  multiple,
}

enum PollStatus {
  @JsonValue('active')
  active,
  @JsonValue('closed')
  closed,
  @JsonValue('draft')
  draft,
}

@freezed
class EnhancedPoll with _$EnhancedPoll {
  const factory EnhancedPoll({
    required String id,
    required String eventId,
    required String question,
    required PollType pollType,
    required List<PollOption> options,
    @Default(false) bool isAnonymous,
    @Default(PollStatus.active) PollStatus status,
    DateTime? closesAt,
    required String createdBy,
    String? createdByName,
    String? createdByAvatar,
    @Default(0) int totalVotes,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _EnhancedPoll;

  factory EnhancedPoll.fromJson(Map<String, dynamic> json) =>
      _$EnhancedPollFromJson(json);

  factory EnhancedPoll.fromSupabase(Map<String, dynamic> data) {
    return EnhancedPoll(
      id: data['id'] as String,
      eventId: data['event_id'] as String,
      question: data['question'] as String,
      pollType: PollType.values.firstWhere(
        (t) => t.name == data['poll_type'],
        orElse: () => PollType.single,
      ),
      options: [], // Will be loaded separately
      isAnonymous: data['is_anonymous'] as bool? ?? false,
      status: PollStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => PollStatus.active,
      ),
      closesAt: data['closes_at'] != null
          ? DateTime.parse(data['closes_at'] as String)
          : null,
      createdBy: data['created_by'] as String,
      createdByName: data['created_by_name'] as String?,
      createdByAvatar: data['created_by_avatar'] as String?,
      totalVotes: data['total_votes'] as int? ?? 0,
      createdAt: DateTime.parse(data['created_at'] as String),
      updatedAt: data['updated_at'] != null
          ? DateTime.parse(data['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'event_id': eventId,
      'question': question,
      'poll_type': pollType.name,
      'is_anonymous': isAnonymous,
      'status': status.name,
      'closes_at': closesAt?.toIso8601String(),
      'created_by': createdBy,
    };
  }
}

@freezed
class PollOption with _$PollOption {
  const factory PollOption({
    required String id,
    required String pollId,
    required String optionText,
    @Default(0) int votesCount,
    @Default([]) List<String> voterIds,
    @Default([]) List<String> voterNames,
  }) = _PollOption;

  factory PollOption.fromJson(Map<String, dynamic> json) =>
      _$PollOptionFromJson(json);

  factory PollOption.fromSupabase(Map<String, dynamic> data) {
    return PollOption(
      id: data['id'] as String,
      pollId: data['poll_id'] as String,
      optionText: data['option_text'] as String,
      votesCount: data['votes_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'poll_id': pollId,
      'option_text': optionText,
    };
  }
}

@freezed
class PollVote with _$PollVote {
  const factory PollVote({
    required String id,
    required String pollId,
    required String optionId,
    String? userId,
    String? userName,
    required DateTime createdAt,
  }) = _PollVote;

  factory PollVote.fromJson(Map<String, dynamic> json) =>
      _$PollVoteFromJson(json);

  factory PollVote.fromSupabase(Map<String, dynamic> data) {
    return PollVote(
      id: data['id'] as String,
      pollId: data['poll_id'] as String,
      optionId: data['option_id'] as String,
      userId: data['user_id'] as String?,
      userName: data['user_name'] as String?,
      createdAt: DateTime.parse(data['created_at'] as String),
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'poll_id': pollId,
      'option_id': optionId,
      'user_id': userId,
      'user_name': userName,
    };
  }
}

@freezed
class PollResults with _$PollResults {
  const factory PollResults({
    required String pollId,
    required List<PollOptionResult> options,
    required int totalVotes,
    required bool hasUserVoted,
    List<String>? userVotedOptionIds,
  }) = _PollResults;

  factory PollResults.fromJson(Map<String, dynamic> json) =>
      _$PollResultsFromJson(json);
}

@freezed
class PollOptionResult with _$PollOptionResult {
  const factory PollOptionResult({
    required String optionId,
    required String optionText,
    required int votes,
    required double percentage,
    @Default(false) bool isUserVote,
  }) = _PollOptionResult;

  factory PollOptionResult.fromJson(Map<String, dynamic> json) =>
      _$PollOptionResultFromJson(json);
}
