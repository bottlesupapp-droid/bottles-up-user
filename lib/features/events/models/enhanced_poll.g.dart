// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enhanced_poll.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EnhancedPollImpl _$$EnhancedPollImplFromJson(Map<String, dynamic> json) =>
    _$EnhancedPollImpl(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      question: json['question'] as String,
      pollType: $enumDecode(_$PollTypeEnumMap, json['pollType']),
      options: (json['options'] as List<dynamic>)
          .map((e) => PollOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      isAnonymous: json['isAnonymous'] as bool? ?? false,
      status: $enumDecodeNullable(_$PollStatusEnumMap, json['status']) ??
          PollStatus.active,
      closesAt: json['closesAt'] == null
          ? null
          : DateTime.parse(json['closesAt'] as String),
      createdBy: json['createdBy'] as String,
      createdByName: json['createdByName'] as String?,
      createdByAvatar: json['createdByAvatar'] as String?,
      totalVotes: (json['totalVotes'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$EnhancedPollImplToJson(_$EnhancedPollImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'question': instance.question,
      'pollType': _$PollTypeEnumMap[instance.pollType]!,
      'options': instance.options,
      'isAnonymous': instance.isAnonymous,
      'status': _$PollStatusEnumMap[instance.status]!,
      'closesAt': instance.closesAt?.toIso8601String(),
      'createdBy': instance.createdBy,
      'createdByName': instance.createdByName,
      'createdByAvatar': instance.createdByAvatar,
      'totalVotes': instance.totalVotes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$PollTypeEnumMap = {
  PollType.single: 'single',
  PollType.multiple: 'multiple',
};

const _$PollStatusEnumMap = {
  PollStatus.active: 'active',
  PollStatus.closed: 'closed',
  PollStatus.draft: 'draft',
};

_$PollOptionImpl _$$PollOptionImplFromJson(Map<String, dynamic> json) =>
    _$PollOptionImpl(
      id: json['id'] as String,
      pollId: json['pollId'] as String,
      optionText: json['optionText'] as String,
      votesCount: (json['votesCount'] as num?)?.toInt() ?? 0,
      voterIds: (json['voterIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      voterNames: (json['voterNames'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PollOptionImplToJson(_$PollOptionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pollId': instance.pollId,
      'optionText': instance.optionText,
      'votesCount': instance.votesCount,
      'voterIds': instance.voterIds,
      'voterNames': instance.voterNames,
    };

_$PollVoteImpl _$$PollVoteImplFromJson(Map<String, dynamic> json) =>
    _$PollVoteImpl(
      id: json['id'] as String,
      pollId: json['pollId'] as String,
      optionId: json['optionId'] as String,
      userId: json['userId'] as String?,
      userName: json['userName'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$PollVoteImplToJson(_$PollVoteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pollId': instance.pollId,
      'optionId': instance.optionId,
      'userId': instance.userId,
      'userName': instance.userName,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$PollResultsImpl _$$PollResultsImplFromJson(Map<String, dynamic> json) =>
    _$PollResultsImpl(
      pollId: json['pollId'] as String,
      options: (json['options'] as List<dynamic>)
          .map((e) => PollOptionResult.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalVotes: (json['totalVotes'] as num).toInt(),
      hasUserVoted: json['hasUserVoted'] as bool,
      userVotedOptionIds: (json['userVotedOptionIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$PollResultsImplToJson(_$PollResultsImpl instance) =>
    <String, dynamic>{
      'pollId': instance.pollId,
      'options': instance.options,
      'totalVotes': instance.totalVotes,
      'hasUserVoted': instance.hasUserVoted,
      'userVotedOptionIds': instance.userVotedOptionIds,
    };

_$PollOptionResultImpl _$$PollOptionResultImplFromJson(
        Map<String, dynamic> json) =>
    _$PollOptionResultImpl(
      optionId: json['optionId'] as String,
      optionText: json['optionText'] as String,
      votes: (json['votes'] as num).toInt(),
      percentage: (json['percentage'] as num).toDouble(),
      isUserVote: json['isUserVote'] as bool? ?? false,
    );

Map<String, dynamic> _$$PollOptionResultImplToJson(
        _$PollOptionResultImpl instance) =>
    <String, dynamic>{
      'optionId': instance.optionId,
      'optionText': instance.optionText,
      'votes': instance.votes,
      'percentage': instance.percentage,
      'isUserVote': instance.isUserVote,
    };
