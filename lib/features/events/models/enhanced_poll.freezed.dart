// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'enhanced_poll.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EnhancedPoll _$EnhancedPollFromJson(Map<String, dynamic> json) {
  return _EnhancedPoll.fromJson(json);
}

/// @nodoc
mixin _$EnhancedPoll {
  String get id => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  String get question => throw _privateConstructorUsedError;
  PollType get pollType => throw _privateConstructorUsedError;
  List<PollOption> get options => throw _privateConstructorUsedError;
  bool get isAnonymous => throw _privateConstructorUsedError;
  PollStatus get status => throw _privateConstructorUsedError;
  DateTime? get closesAt => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  String? get createdByName => throw _privateConstructorUsedError;
  String? get createdByAvatar => throw _privateConstructorUsedError;
  int get totalVotes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this EnhancedPoll to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EnhancedPoll
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EnhancedPollCopyWith<EnhancedPoll> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EnhancedPollCopyWith<$Res> {
  factory $EnhancedPollCopyWith(
          EnhancedPoll value, $Res Function(EnhancedPoll) then) =
      _$EnhancedPollCopyWithImpl<$Res, EnhancedPoll>;
  @useResult
  $Res call(
      {String id,
      String eventId,
      String question,
      PollType pollType,
      List<PollOption> options,
      bool isAnonymous,
      PollStatus status,
      DateTime? closesAt,
      String createdBy,
      String? createdByName,
      String? createdByAvatar,
      int totalVotes,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$EnhancedPollCopyWithImpl<$Res, $Val extends EnhancedPoll>
    implements $EnhancedPollCopyWith<$Res> {
  _$EnhancedPollCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EnhancedPoll
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? question = null,
    Object? pollType = null,
    Object? options = null,
    Object? isAnonymous = null,
    Object? status = null,
    Object? closesAt = freezed,
    Object? createdBy = null,
    Object? createdByName = freezed,
    Object? createdByAvatar = freezed,
    Object? totalVotes = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      pollType: null == pollType
          ? _value.pollType
          : pollType // ignore: cast_nullable_to_non_nullable
              as PollType,
      options: null == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<PollOption>,
      isAnonymous: null == isAnonymous
          ? _value.isAnonymous
          : isAnonymous // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PollStatus,
      closesAt: freezed == closesAt
          ? _value.closesAt
          : closesAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdByName: freezed == createdByName
          ? _value.createdByName
          : createdByName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdByAvatar: freezed == createdByAvatar
          ? _value.createdByAvatar
          : createdByAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      totalVotes: null == totalVotes
          ? _value.totalVotes
          : totalVotes // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EnhancedPollImplCopyWith<$Res>
    implements $EnhancedPollCopyWith<$Res> {
  factory _$$EnhancedPollImplCopyWith(
          _$EnhancedPollImpl value, $Res Function(_$EnhancedPollImpl) then) =
      __$$EnhancedPollImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String eventId,
      String question,
      PollType pollType,
      List<PollOption> options,
      bool isAnonymous,
      PollStatus status,
      DateTime? closesAt,
      String createdBy,
      String? createdByName,
      String? createdByAvatar,
      int totalVotes,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$EnhancedPollImplCopyWithImpl<$Res>
    extends _$EnhancedPollCopyWithImpl<$Res, _$EnhancedPollImpl>
    implements _$$EnhancedPollImplCopyWith<$Res> {
  __$$EnhancedPollImplCopyWithImpl(
      _$EnhancedPollImpl _value, $Res Function(_$EnhancedPollImpl) _then)
      : super(_value, _then);

  /// Create a copy of EnhancedPoll
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? question = null,
    Object? pollType = null,
    Object? options = null,
    Object? isAnonymous = null,
    Object? status = null,
    Object? closesAt = freezed,
    Object? createdBy = null,
    Object? createdByName = freezed,
    Object? createdByAvatar = freezed,
    Object? totalVotes = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$EnhancedPollImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      pollType: null == pollType
          ? _value.pollType
          : pollType // ignore: cast_nullable_to_non_nullable
              as PollType,
      options: null == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<PollOption>,
      isAnonymous: null == isAnonymous
          ? _value.isAnonymous
          : isAnonymous // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PollStatus,
      closesAt: freezed == closesAt
          ? _value.closesAt
          : closesAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdByName: freezed == createdByName
          ? _value.createdByName
          : createdByName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdByAvatar: freezed == createdByAvatar
          ? _value.createdByAvatar
          : createdByAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      totalVotes: null == totalVotes
          ? _value.totalVotes
          : totalVotes // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EnhancedPollImpl implements _EnhancedPoll {
  const _$EnhancedPollImpl(
      {required this.id,
      required this.eventId,
      required this.question,
      required this.pollType,
      required final List<PollOption> options,
      this.isAnonymous = false,
      this.status = PollStatus.active,
      this.closesAt,
      required this.createdBy,
      this.createdByName,
      this.createdByAvatar,
      this.totalVotes = 0,
      required this.createdAt,
      this.updatedAt})
      : _options = options;

  factory _$EnhancedPollImpl.fromJson(Map<String, dynamic> json) =>
      _$$EnhancedPollImplFromJson(json);

  @override
  final String id;
  @override
  final String eventId;
  @override
  final String question;
  @override
  final PollType pollType;
  final List<PollOption> _options;
  @override
  List<PollOption> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  @JsonKey()
  final bool isAnonymous;
  @override
  @JsonKey()
  final PollStatus status;
  @override
  final DateTime? closesAt;
  @override
  final String createdBy;
  @override
  final String? createdByName;
  @override
  final String? createdByAvatar;
  @override
  @JsonKey()
  final int totalVotes;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'EnhancedPoll(id: $id, eventId: $eventId, question: $question, pollType: $pollType, options: $options, isAnonymous: $isAnonymous, status: $status, closesAt: $closesAt, createdBy: $createdBy, createdByName: $createdByName, createdByAvatar: $createdByAvatar, totalVotes: $totalVotes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EnhancedPollImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.question, question) ||
                other.question == question) &&
            (identical(other.pollType, pollType) ||
                other.pollType == pollType) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            (identical(other.isAnonymous, isAnonymous) ||
                other.isAnonymous == isAnonymous) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.closesAt, closesAt) ||
                other.closesAt == closesAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdByName, createdByName) ||
                other.createdByName == createdByName) &&
            (identical(other.createdByAvatar, createdByAvatar) ||
                other.createdByAvatar == createdByAvatar) &&
            (identical(other.totalVotes, totalVotes) ||
                other.totalVotes == totalVotes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      eventId,
      question,
      pollType,
      const DeepCollectionEquality().hash(_options),
      isAnonymous,
      status,
      closesAt,
      createdBy,
      createdByName,
      createdByAvatar,
      totalVotes,
      createdAt,
      updatedAt);

  /// Create a copy of EnhancedPoll
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EnhancedPollImplCopyWith<_$EnhancedPollImpl> get copyWith =>
      __$$EnhancedPollImplCopyWithImpl<_$EnhancedPollImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EnhancedPollImplToJson(
      this,
    );
  }
}

abstract class _EnhancedPoll implements EnhancedPoll {
  const factory _EnhancedPoll(
      {required final String id,
      required final String eventId,
      required final String question,
      required final PollType pollType,
      required final List<PollOption> options,
      final bool isAnonymous,
      final PollStatus status,
      final DateTime? closesAt,
      required final String createdBy,
      final String? createdByName,
      final String? createdByAvatar,
      final int totalVotes,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$EnhancedPollImpl;

  factory _EnhancedPoll.fromJson(Map<String, dynamic> json) =
      _$EnhancedPollImpl.fromJson;

  @override
  String get id;
  @override
  String get eventId;
  @override
  String get question;
  @override
  PollType get pollType;
  @override
  List<PollOption> get options;
  @override
  bool get isAnonymous;
  @override
  PollStatus get status;
  @override
  DateTime? get closesAt;
  @override
  String get createdBy;
  @override
  String? get createdByName;
  @override
  String? get createdByAvatar;
  @override
  int get totalVotes;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of EnhancedPoll
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EnhancedPollImplCopyWith<_$EnhancedPollImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PollOption _$PollOptionFromJson(Map<String, dynamic> json) {
  return _PollOption.fromJson(json);
}

/// @nodoc
mixin _$PollOption {
  String get id => throw _privateConstructorUsedError;
  String get pollId => throw _privateConstructorUsedError;
  String get optionText => throw _privateConstructorUsedError;
  int get votesCount => throw _privateConstructorUsedError;
  List<String> get voterIds => throw _privateConstructorUsedError;
  List<String> get voterNames => throw _privateConstructorUsedError;

  /// Serializes this PollOption to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PollOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PollOptionCopyWith<PollOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PollOptionCopyWith<$Res> {
  factory $PollOptionCopyWith(
          PollOption value, $Res Function(PollOption) then) =
      _$PollOptionCopyWithImpl<$Res, PollOption>;
  @useResult
  $Res call(
      {String id,
      String pollId,
      String optionText,
      int votesCount,
      List<String> voterIds,
      List<String> voterNames});
}

/// @nodoc
class _$PollOptionCopyWithImpl<$Res, $Val extends PollOption>
    implements $PollOptionCopyWith<$Res> {
  _$PollOptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PollOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pollId = null,
    Object? optionText = null,
    Object? votesCount = null,
    Object? voterIds = null,
    Object? voterNames = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      pollId: null == pollId
          ? _value.pollId
          : pollId // ignore: cast_nullable_to_non_nullable
              as String,
      optionText: null == optionText
          ? _value.optionText
          : optionText // ignore: cast_nullable_to_non_nullable
              as String,
      votesCount: null == votesCount
          ? _value.votesCount
          : votesCount // ignore: cast_nullable_to_non_nullable
              as int,
      voterIds: null == voterIds
          ? _value.voterIds
          : voterIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      voterNames: null == voterNames
          ? _value.voterNames
          : voterNames // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PollOptionImplCopyWith<$Res>
    implements $PollOptionCopyWith<$Res> {
  factory _$$PollOptionImplCopyWith(
          _$PollOptionImpl value, $Res Function(_$PollOptionImpl) then) =
      __$$PollOptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String pollId,
      String optionText,
      int votesCount,
      List<String> voterIds,
      List<String> voterNames});
}

/// @nodoc
class __$$PollOptionImplCopyWithImpl<$Res>
    extends _$PollOptionCopyWithImpl<$Res, _$PollOptionImpl>
    implements _$$PollOptionImplCopyWith<$Res> {
  __$$PollOptionImplCopyWithImpl(
      _$PollOptionImpl _value, $Res Function(_$PollOptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of PollOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pollId = null,
    Object? optionText = null,
    Object? votesCount = null,
    Object? voterIds = null,
    Object? voterNames = null,
  }) {
    return _then(_$PollOptionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      pollId: null == pollId
          ? _value.pollId
          : pollId // ignore: cast_nullable_to_non_nullable
              as String,
      optionText: null == optionText
          ? _value.optionText
          : optionText // ignore: cast_nullable_to_non_nullable
              as String,
      votesCount: null == votesCount
          ? _value.votesCount
          : votesCount // ignore: cast_nullable_to_non_nullable
              as int,
      voterIds: null == voterIds
          ? _value._voterIds
          : voterIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      voterNames: null == voterNames
          ? _value._voterNames
          : voterNames // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PollOptionImpl implements _PollOption {
  const _$PollOptionImpl(
      {required this.id,
      required this.pollId,
      required this.optionText,
      this.votesCount = 0,
      final List<String> voterIds = const [],
      final List<String> voterNames = const []})
      : _voterIds = voterIds,
        _voterNames = voterNames;

  factory _$PollOptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PollOptionImplFromJson(json);

  @override
  final String id;
  @override
  final String pollId;
  @override
  final String optionText;
  @override
  @JsonKey()
  final int votesCount;
  final List<String> _voterIds;
  @override
  @JsonKey()
  List<String> get voterIds {
    if (_voterIds is EqualUnmodifiableListView) return _voterIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_voterIds);
  }

  final List<String> _voterNames;
  @override
  @JsonKey()
  List<String> get voterNames {
    if (_voterNames is EqualUnmodifiableListView) return _voterNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_voterNames);
  }

  @override
  String toString() {
    return 'PollOption(id: $id, pollId: $pollId, optionText: $optionText, votesCount: $votesCount, voterIds: $voterIds, voterNames: $voterNames)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PollOptionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.pollId, pollId) || other.pollId == pollId) &&
            (identical(other.optionText, optionText) ||
                other.optionText == optionText) &&
            (identical(other.votesCount, votesCount) ||
                other.votesCount == votesCount) &&
            const DeepCollectionEquality().equals(other._voterIds, _voterIds) &&
            const DeepCollectionEquality()
                .equals(other._voterNames, _voterNames));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      pollId,
      optionText,
      votesCount,
      const DeepCollectionEquality().hash(_voterIds),
      const DeepCollectionEquality().hash(_voterNames));

  /// Create a copy of PollOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PollOptionImplCopyWith<_$PollOptionImpl> get copyWith =>
      __$$PollOptionImplCopyWithImpl<_$PollOptionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PollOptionImplToJson(
      this,
    );
  }
}

abstract class _PollOption implements PollOption {
  const factory _PollOption(
      {required final String id,
      required final String pollId,
      required final String optionText,
      final int votesCount,
      final List<String> voterIds,
      final List<String> voterNames}) = _$PollOptionImpl;

  factory _PollOption.fromJson(Map<String, dynamic> json) =
      _$PollOptionImpl.fromJson;

  @override
  String get id;
  @override
  String get pollId;
  @override
  String get optionText;
  @override
  int get votesCount;
  @override
  List<String> get voterIds;
  @override
  List<String> get voterNames;

  /// Create a copy of PollOption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PollOptionImplCopyWith<_$PollOptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PollVote _$PollVoteFromJson(Map<String, dynamic> json) {
  return _PollVote.fromJson(json);
}

/// @nodoc
mixin _$PollVote {
  String get id => throw _privateConstructorUsedError;
  String get pollId => throw _privateConstructorUsedError;
  String get optionId => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;
  String? get userName => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this PollVote to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PollVote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PollVoteCopyWith<PollVote> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PollVoteCopyWith<$Res> {
  factory $PollVoteCopyWith(PollVote value, $Res Function(PollVote) then) =
      _$PollVoteCopyWithImpl<$Res, PollVote>;
  @useResult
  $Res call(
      {String id,
      String pollId,
      String optionId,
      String? userId,
      String? userName,
      DateTime createdAt});
}

/// @nodoc
class _$PollVoteCopyWithImpl<$Res, $Val extends PollVote>
    implements $PollVoteCopyWith<$Res> {
  _$PollVoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PollVote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pollId = null,
    Object? optionId = null,
    Object? userId = freezed,
    Object? userName = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      pollId: null == pollId
          ? _value.pollId
          : pollId // ignore: cast_nullable_to_non_nullable
              as String,
      optionId: null == optionId
          ? _value.optionId
          : optionId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PollVoteImplCopyWith<$Res>
    implements $PollVoteCopyWith<$Res> {
  factory _$$PollVoteImplCopyWith(
          _$PollVoteImpl value, $Res Function(_$PollVoteImpl) then) =
      __$$PollVoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String pollId,
      String optionId,
      String? userId,
      String? userName,
      DateTime createdAt});
}

/// @nodoc
class __$$PollVoteImplCopyWithImpl<$Res>
    extends _$PollVoteCopyWithImpl<$Res, _$PollVoteImpl>
    implements _$$PollVoteImplCopyWith<$Res> {
  __$$PollVoteImplCopyWithImpl(
      _$PollVoteImpl _value, $Res Function(_$PollVoteImpl) _then)
      : super(_value, _then);

  /// Create a copy of PollVote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pollId = null,
    Object? optionId = null,
    Object? userId = freezed,
    Object? userName = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$PollVoteImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      pollId: null == pollId
          ? _value.pollId
          : pollId // ignore: cast_nullable_to_non_nullable
              as String,
      optionId: null == optionId
          ? _value.optionId
          : optionId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PollVoteImpl implements _PollVote {
  const _$PollVoteImpl(
      {required this.id,
      required this.pollId,
      required this.optionId,
      this.userId,
      this.userName,
      required this.createdAt});

  factory _$PollVoteImpl.fromJson(Map<String, dynamic> json) =>
      _$$PollVoteImplFromJson(json);

  @override
  final String id;
  @override
  final String pollId;
  @override
  final String optionId;
  @override
  final String? userId;
  @override
  final String? userName;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'PollVote(id: $id, pollId: $pollId, optionId: $optionId, userId: $userId, userName: $userName, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PollVoteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.pollId, pollId) || other.pollId == pollId) &&
            (identical(other.optionId, optionId) ||
                other.optionId == optionId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, pollId, optionId, userId, userName, createdAt);

  /// Create a copy of PollVote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PollVoteImplCopyWith<_$PollVoteImpl> get copyWith =>
      __$$PollVoteImplCopyWithImpl<_$PollVoteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PollVoteImplToJson(
      this,
    );
  }
}

abstract class _PollVote implements PollVote {
  const factory _PollVote(
      {required final String id,
      required final String pollId,
      required final String optionId,
      final String? userId,
      final String? userName,
      required final DateTime createdAt}) = _$PollVoteImpl;

  factory _PollVote.fromJson(Map<String, dynamic> json) =
      _$PollVoteImpl.fromJson;

  @override
  String get id;
  @override
  String get pollId;
  @override
  String get optionId;
  @override
  String? get userId;
  @override
  String? get userName;
  @override
  DateTime get createdAt;

  /// Create a copy of PollVote
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PollVoteImplCopyWith<_$PollVoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PollResults _$PollResultsFromJson(Map<String, dynamic> json) {
  return _PollResults.fromJson(json);
}

/// @nodoc
mixin _$PollResults {
  String get pollId => throw _privateConstructorUsedError;
  List<PollOptionResult> get options => throw _privateConstructorUsedError;
  int get totalVotes => throw _privateConstructorUsedError;
  bool get hasUserVoted => throw _privateConstructorUsedError;
  List<String>? get userVotedOptionIds => throw _privateConstructorUsedError;

  /// Serializes this PollResults to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PollResults
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PollResultsCopyWith<PollResults> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PollResultsCopyWith<$Res> {
  factory $PollResultsCopyWith(
          PollResults value, $Res Function(PollResults) then) =
      _$PollResultsCopyWithImpl<$Res, PollResults>;
  @useResult
  $Res call(
      {String pollId,
      List<PollOptionResult> options,
      int totalVotes,
      bool hasUserVoted,
      List<String>? userVotedOptionIds});
}

/// @nodoc
class _$PollResultsCopyWithImpl<$Res, $Val extends PollResults>
    implements $PollResultsCopyWith<$Res> {
  _$PollResultsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PollResults
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pollId = null,
    Object? options = null,
    Object? totalVotes = null,
    Object? hasUserVoted = null,
    Object? userVotedOptionIds = freezed,
  }) {
    return _then(_value.copyWith(
      pollId: null == pollId
          ? _value.pollId
          : pollId // ignore: cast_nullable_to_non_nullable
              as String,
      options: null == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<PollOptionResult>,
      totalVotes: null == totalVotes
          ? _value.totalVotes
          : totalVotes // ignore: cast_nullable_to_non_nullable
              as int,
      hasUserVoted: null == hasUserVoted
          ? _value.hasUserVoted
          : hasUserVoted // ignore: cast_nullable_to_non_nullable
              as bool,
      userVotedOptionIds: freezed == userVotedOptionIds
          ? _value.userVotedOptionIds
          : userVotedOptionIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PollResultsImplCopyWith<$Res>
    implements $PollResultsCopyWith<$Res> {
  factory _$$PollResultsImplCopyWith(
          _$PollResultsImpl value, $Res Function(_$PollResultsImpl) then) =
      __$$PollResultsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String pollId,
      List<PollOptionResult> options,
      int totalVotes,
      bool hasUserVoted,
      List<String>? userVotedOptionIds});
}

/// @nodoc
class __$$PollResultsImplCopyWithImpl<$Res>
    extends _$PollResultsCopyWithImpl<$Res, _$PollResultsImpl>
    implements _$$PollResultsImplCopyWith<$Res> {
  __$$PollResultsImplCopyWithImpl(
      _$PollResultsImpl _value, $Res Function(_$PollResultsImpl) _then)
      : super(_value, _then);

  /// Create a copy of PollResults
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pollId = null,
    Object? options = null,
    Object? totalVotes = null,
    Object? hasUserVoted = null,
    Object? userVotedOptionIds = freezed,
  }) {
    return _then(_$PollResultsImpl(
      pollId: null == pollId
          ? _value.pollId
          : pollId // ignore: cast_nullable_to_non_nullable
              as String,
      options: null == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<PollOptionResult>,
      totalVotes: null == totalVotes
          ? _value.totalVotes
          : totalVotes // ignore: cast_nullable_to_non_nullable
              as int,
      hasUserVoted: null == hasUserVoted
          ? _value.hasUserVoted
          : hasUserVoted // ignore: cast_nullable_to_non_nullable
              as bool,
      userVotedOptionIds: freezed == userVotedOptionIds
          ? _value._userVotedOptionIds
          : userVotedOptionIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PollResultsImpl implements _PollResults {
  const _$PollResultsImpl(
      {required this.pollId,
      required final List<PollOptionResult> options,
      required this.totalVotes,
      required this.hasUserVoted,
      final List<String>? userVotedOptionIds})
      : _options = options,
        _userVotedOptionIds = userVotedOptionIds;

  factory _$PollResultsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PollResultsImplFromJson(json);

  @override
  final String pollId;
  final List<PollOptionResult> _options;
  @override
  List<PollOptionResult> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  final int totalVotes;
  @override
  final bool hasUserVoted;
  final List<String>? _userVotedOptionIds;
  @override
  List<String>? get userVotedOptionIds {
    final value = _userVotedOptionIds;
    if (value == null) return null;
    if (_userVotedOptionIds is EqualUnmodifiableListView)
      return _userVotedOptionIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'PollResults(pollId: $pollId, options: $options, totalVotes: $totalVotes, hasUserVoted: $hasUserVoted, userVotedOptionIds: $userVotedOptionIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PollResultsImpl &&
            (identical(other.pollId, pollId) || other.pollId == pollId) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            (identical(other.totalVotes, totalVotes) ||
                other.totalVotes == totalVotes) &&
            (identical(other.hasUserVoted, hasUserVoted) ||
                other.hasUserVoted == hasUserVoted) &&
            const DeepCollectionEquality()
                .equals(other._userVotedOptionIds, _userVotedOptionIds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      pollId,
      const DeepCollectionEquality().hash(_options),
      totalVotes,
      hasUserVoted,
      const DeepCollectionEquality().hash(_userVotedOptionIds));

  /// Create a copy of PollResults
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PollResultsImplCopyWith<_$PollResultsImpl> get copyWith =>
      __$$PollResultsImplCopyWithImpl<_$PollResultsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PollResultsImplToJson(
      this,
    );
  }
}

abstract class _PollResults implements PollResults {
  const factory _PollResults(
      {required final String pollId,
      required final List<PollOptionResult> options,
      required final int totalVotes,
      required final bool hasUserVoted,
      final List<String>? userVotedOptionIds}) = _$PollResultsImpl;

  factory _PollResults.fromJson(Map<String, dynamic> json) =
      _$PollResultsImpl.fromJson;

  @override
  String get pollId;
  @override
  List<PollOptionResult> get options;
  @override
  int get totalVotes;
  @override
  bool get hasUserVoted;
  @override
  List<String>? get userVotedOptionIds;

  /// Create a copy of PollResults
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PollResultsImplCopyWith<_$PollResultsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PollOptionResult _$PollOptionResultFromJson(Map<String, dynamic> json) {
  return _PollOptionResult.fromJson(json);
}

/// @nodoc
mixin _$PollOptionResult {
  String get optionId => throw _privateConstructorUsedError;
  String get optionText => throw _privateConstructorUsedError;
  int get votes => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;
  bool get isUserVote => throw _privateConstructorUsedError;

  /// Serializes this PollOptionResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PollOptionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PollOptionResultCopyWith<PollOptionResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PollOptionResultCopyWith<$Res> {
  factory $PollOptionResultCopyWith(
          PollOptionResult value, $Res Function(PollOptionResult) then) =
      _$PollOptionResultCopyWithImpl<$Res, PollOptionResult>;
  @useResult
  $Res call(
      {String optionId,
      String optionText,
      int votes,
      double percentage,
      bool isUserVote});
}

/// @nodoc
class _$PollOptionResultCopyWithImpl<$Res, $Val extends PollOptionResult>
    implements $PollOptionResultCopyWith<$Res> {
  _$PollOptionResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PollOptionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? optionId = null,
    Object? optionText = null,
    Object? votes = null,
    Object? percentage = null,
    Object? isUserVote = null,
  }) {
    return _then(_value.copyWith(
      optionId: null == optionId
          ? _value.optionId
          : optionId // ignore: cast_nullable_to_non_nullable
              as String,
      optionText: null == optionText
          ? _value.optionText
          : optionText // ignore: cast_nullable_to_non_nullable
              as String,
      votes: null == votes
          ? _value.votes
          : votes // ignore: cast_nullable_to_non_nullable
              as int,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
      isUserVote: null == isUserVote
          ? _value.isUserVote
          : isUserVote // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PollOptionResultImplCopyWith<$Res>
    implements $PollOptionResultCopyWith<$Res> {
  factory _$$PollOptionResultImplCopyWith(_$PollOptionResultImpl value,
          $Res Function(_$PollOptionResultImpl) then) =
      __$$PollOptionResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String optionId,
      String optionText,
      int votes,
      double percentage,
      bool isUserVote});
}

/// @nodoc
class __$$PollOptionResultImplCopyWithImpl<$Res>
    extends _$PollOptionResultCopyWithImpl<$Res, _$PollOptionResultImpl>
    implements _$$PollOptionResultImplCopyWith<$Res> {
  __$$PollOptionResultImplCopyWithImpl(_$PollOptionResultImpl _value,
      $Res Function(_$PollOptionResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of PollOptionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? optionId = null,
    Object? optionText = null,
    Object? votes = null,
    Object? percentage = null,
    Object? isUserVote = null,
  }) {
    return _then(_$PollOptionResultImpl(
      optionId: null == optionId
          ? _value.optionId
          : optionId // ignore: cast_nullable_to_non_nullable
              as String,
      optionText: null == optionText
          ? _value.optionText
          : optionText // ignore: cast_nullable_to_non_nullable
              as String,
      votes: null == votes
          ? _value.votes
          : votes // ignore: cast_nullable_to_non_nullable
              as int,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
      isUserVote: null == isUserVote
          ? _value.isUserVote
          : isUserVote // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PollOptionResultImpl implements _PollOptionResult {
  const _$PollOptionResultImpl(
      {required this.optionId,
      required this.optionText,
      required this.votes,
      required this.percentage,
      this.isUserVote = false});

  factory _$PollOptionResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$PollOptionResultImplFromJson(json);

  @override
  final String optionId;
  @override
  final String optionText;
  @override
  final int votes;
  @override
  final double percentage;
  @override
  @JsonKey()
  final bool isUserVote;

  @override
  String toString() {
    return 'PollOptionResult(optionId: $optionId, optionText: $optionText, votes: $votes, percentage: $percentage, isUserVote: $isUserVote)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PollOptionResultImpl &&
            (identical(other.optionId, optionId) ||
                other.optionId == optionId) &&
            (identical(other.optionText, optionText) ||
                other.optionText == optionText) &&
            (identical(other.votes, votes) || other.votes == votes) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage) &&
            (identical(other.isUserVote, isUserVote) ||
                other.isUserVote == isUserVote));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, optionId, optionText, votes, percentage, isUserVote);

  /// Create a copy of PollOptionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PollOptionResultImplCopyWith<_$PollOptionResultImpl> get copyWith =>
      __$$PollOptionResultImplCopyWithImpl<_$PollOptionResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PollOptionResultImplToJson(
      this,
    );
  }
}

abstract class _PollOptionResult implements PollOptionResult {
  const factory _PollOptionResult(
      {required final String optionId,
      required final String optionText,
      required final int votes,
      required final double percentage,
      final bool isUserVote}) = _$PollOptionResultImpl;

  factory _PollOptionResult.fromJson(Map<String, dynamic> json) =
      _$PollOptionResultImpl.fromJson;

  @override
  String get optionId;
  @override
  String get optionText;
  @override
  int get votes;
  @override
  double get percentage;
  @override
  bool get isUserVote;

  /// Create a copy of PollOptionResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PollOptionResultImplCopyWith<_$PollOptionResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
