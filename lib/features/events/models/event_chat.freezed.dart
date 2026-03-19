// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_chat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventChatMessage _$EventChatMessageFromJson(Map<String, dynamic> json) {
  return _EventChatMessage.fromJson(json);
}

/// @nodoc
mixin _$EventChatMessage {
  String get id => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  bool get isPinned => throw _privateConstructorUsedError;
  String? get replyToId => throw _privateConstructorUsedError;
  List<String>? get images => throw _privateConstructorUsedError;
  String? get pollId => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError; // Joined data
  String? get userName => throw _privateConstructorUsedError;
  String? get userAvatar => throw _privateConstructorUsedError;
  String? get replyToMessage => throw _privateConstructorUsedError;
  String? get replyToUserName => throw _privateConstructorUsedError;

  /// Serializes this EventChatMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EventChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventChatMessageCopyWith<EventChatMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventChatMessageCopyWith<$Res> {
  factory $EventChatMessageCopyWith(
          EventChatMessage value, $Res Function(EventChatMessage) then) =
      _$EventChatMessageCopyWithImpl<$Res, EventChatMessage>;
  @useResult
  $Res call(
      {String id,
      String eventId,
      String userId,
      String message,
      bool isPinned,
      String? replyToId,
      List<String>? images,
      String? pollId,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? userName,
      String? userAvatar,
      String? replyToMessage,
      String? replyToUserName});
}

/// @nodoc
class _$EventChatMessageCopyWithImpl<$Res, $Val extends EventChatMessage>
    implements $EventChatMessageCopyWith<$Res> {
  _$EventChatMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? userId = null,
    Object? message = null,
    Object? isPinned = null,
    Object? replyToId = freezed,
    Object? images = freezed,
    Object? pollId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? userName = freezed,
    Object? userAvatar = freezed,
    Object? replyToMessage = freezed,
    Object? replyToUserName = freezed,
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
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      replyToId: freezed == replyToId
          ? _value.replyToId
          : replyToId // ignore: cast_nullable_to_non_nullable
              as String?,
      images: freezed == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      pollId: freezed == pollId
          ? _value.pollId
          : pollId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      userAvatar: freezed == userAvatar
          ? _value.userAvatar
          : userAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      replyToMessage: freezed == replyToMessage
          ? _value.replyToMessage
          : replyToMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      replyToUserName: freezed == replyToUserName
          ? _value.replyToUserName
          : replyToUserName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventChatMessageImplCopyWith<$Res>
    implements $EventChatMessageCopyWith<$Res> {
  factory _$$EventChatMessageImplCopyWith(_$EventChatMessageImpl value,
          $Res Function(_$EventChatMessageImpl) then) =
      __$$EventChatMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String eventId,
      String userId,
      String message,
      bool isPinned,
      String? replyToId,
      List<String>? images,
      String? pollId,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? userName,
      String? userAvatar,
      String? replyToMessage,
      String? replyToUserName});
}

/// @nodoc
class __$$EventChatMessageImplCopyWithImpl<$Res>
    extends _$EventChatMessageCopyWithImpl<$Res, _$EventChatMessageImpl>
    implements _$$EventChatMessageImplCopyWith<$Res> {
  __$$EventChatMessageImplCopyWithImpl(_$EventChatMessageImpl _value,
      $Res Function(_$EventChatMessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of EventChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? userId = null,
    Object? message = null,
    Object? isPinned = null,
    Object? replyToId = freezed,
    Object? images = freezed,
    Object? pollId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? userName = freezed,
    Object? userAvatar = freezed,
    Object? replyToMessage = freezed,
    Object? replyToUserName = freezed,
  }) {
    return _then(_$EventChatMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      replyToId: freezed == replyToId
          ? _value.replyToId
          : replyToId // ignore: cast_nullable_to_non_nullable
              as String?,
      images: freezed == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      pollId: freezed == pollId
          ? _value.pollId
          : pollId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      userAvatar: freezed == userAvatar
          ? _value.userAvatar
          : userAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      replyToMessage: freezed == replyToMessage
          ? _value.replyToMessage
          : replyToMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      replyToUserName: freezed == replyToUserName
          ? _value.replyToUserName
          : replyToUserName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventChatMessageImpl implements _EventChatMessage {
  const _$EventChatMessageImpl(
      {required this.id,
      required this.eventId,
      required this.userId,
      required this.message,
      this.isPinned = false,
      this.replyToId,
      final List<String>? images,
      this.pollId,
      this.createdAt,
      this.updatedAt,
      this.userName,
      this.userAvatar,
      this.replyToMessage,
      this.replyToUserName})
      : _images = images;

  factory _$EventChatMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventChatMessageImplFromJson(json);

  @override
  final String id;
  @override
  final String eventId;
  @override
  final String userId;
  @override
  final String message;
  @override
  @JsonKey()
  final bool isPinned;
  @override
  final String? replyToId;
  final List<String>? _images;
  @override
  List<String>? get images {
    final value = _images;
    if (value == null) return null;
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? pollId;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
// Joined data
  @override
  final String? userName;
  @override
  final String? userAvatar;
  @override
  final String? replyToMessage;
  @override
  final String? replyToUserName;

  @override
  String toString() {
    return 'EventChatMessage(id: $id, eventId: $eventId, userId: $userId, message: $message, isPinned: $isPinned, replyToId: $replyToId, images: $images, pollId: $pollId, createdAt: $createdAt, updatedAt: $updatedAt, userName: $userName, userAvatar: $userAvatar, replyToMessage: $replyToMessage, replyToUserName: $replyToUserName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventChatMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.isPinned, isPinned) ||
                other.isPinned == isPinned) &&
            (identical(other.replyToId, replyToId) ||
                other.replyToId == replyToId) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.pollId, pollId) || other.pollId == pollId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userAvatar, userAvatar) ||
                other.userAvatar == userAvatar) &&
            (identical(other.replyToMessage, replyToMessage) ||
                other.replyToMessage == replyToMessage) &&
            (identical(other.replyToUserName, replyToUserName) ||
                other.replyToUserName == replyToUserName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      eventId,
      userId,
      message,
      isPinned,
      replyToId,
      const DeepCollectionEquality().hash(_images),
      pollId,
      createdAt,
      updatedAt,
      userName,
      userAvatar,
      replyToMessage,
      replyToUserName);

  /// Create a copy of EventChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventChatMessageImplCopyWith<_$EventChatMessageImpl> get copyWith =>
      __$$EventChatMessageImplCopyWithImpl<_$EventChatMessageImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventChatMessageImplToJson(
      this,
    );
  }
}

abstract class _EventChatMessage implements EventChatMessage {
  const factory _EventChatMessage(
      {required final String id,
      required final String eventId,
      required final String userId,
      required final String message,
      final bool isPinned,
      final String? replyToId,
      final List<String>? images,
      final String? pollId,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final String? userName,
      final String? userAvatar,
      final String? replyToMessage,
      final String? replyToUserName}) = _$EventChatMessageImpl;

  factory _EventChatMessage.fromJson(Map<String, dynamic> json) =
      _$EventChatMessageImpl.fromJson;

  @override
  String get id;
  @override
  String get eventId;
  @override
  String get userId;
  @override
  String get message;
  @override
  bool get isPinned;
  @override
  String? get replyToId;
  @override
  List<String>? get images;
  @override
  String? get pollId;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt; // Joined data
  @override
  String? get userName;
  @override
  String? get userAvatar;
  @override
  String? get replyToMessage;
  @override
  String? get replyToUserName;

  /// Create a copy of EventChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventChatMessageImplCopyWith<_$EventChatMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EventPoll _$EventPollFromJson(Map<String, dynamic> json) {
  return _EventPoll.fromJson(json);
}

/// @nodoc
mixin _$EventPoll {
  String get id => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  String get question => throw _privateConstructorUsedError;
  List<String> get options => throw _privateConstructorUsedError;
  bool get allowMultipleChoices => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError; // Joined data
  String? get creatorName => throw _privateConstructorUsedError;
  Map<String, int>? get voteCounts => throw _privateConstructorUsedError;
  List<String>? get userVotes => throw _privateConstructorUsedError;

  /// Serializes this EventPoll to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EventPoll
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventPollCopyWith<EventPoll> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventPollCopyWith<$Res> {
  factory $EventPollCopyWith(EventPoll value, $Res Function(EventPoll) then) =
      _$EventPollCopyWithImpl<$Res, EventPoll>;
  @useResult
  $Res call(
      {String id,
      String eventId,
      String createdBy,
      String question,
      List<String> options,
      bool allowMultipleChoices,
      bool isActive,
      DateTime? expiresAt,
      DateTime? createdAt,
      String? creatorName,
      Map<String, int>? voteCounts,
      List<String>? userVotes});
}

/// @nodoc
class _$EventPollCopyWithImpl<$Res, $Val extends EventPoll>
    implements $EventPollCopyWith<$Res> {
  _$EventPollCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventPoll
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? createdBy = null,
    Object? question = null,
    Object? options = null,
    Object? allowMultipleChoices = null,
    Object? isActive = null,
    Object? expiresAt = freezed,
    Object? createdAt = freezed,
    Object? creatorName = freezed,
    Object? voteCounts = freezed,
    Object? userVotes = freezed,
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
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      options: null == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allowMultipleChoices: null == allowMultipleChoices
          ? _value.allowMultipleChoices
          : allowMultipleChoices // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      creatorName: freezed == creatorName
          ? _value.creatorName
          : creatorName // ignore: cast_nullable_to_non_nullable
              as String?,
      voteCounts: freezed == voteCounts
          ? _value.voteCounts
          : voteCounts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>?,
      userVotes: freezed == userVotes
          ? _value.userVotes
          : userVotes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventPollImplCopyWith<$Res>
    implements $EventPollCopyWith<$Res> {
  factory _$$EventPollImplCopyWith(
          _$EventPollImpl value, $Res Function(_$EventPollImpl) then) =
      __$$EventPollImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String eventId,
      String createdBy,
      String question,
      List<String> options,
      bool allowMultipleChoices,
      bool isActive,
      DateTime? expiresAt,
      DateTime? createdAt,
      String? creatorName,
      Map<String, int>? voteCounts,
      List<String>? userVotes});
}

/// @nodoc
class __$$EventPollImplCopyWithImpl<$Res>
    extends _$EventPollCopyWithImpl<$Res, _$EventPollImpl>
    implements _$$EventPollImplCopyWith<$Res> {
  __$$EventPollImplCopyWithImpl(
      _$EventPollImpl _value, $Res Function(_$EventPollImpl) _then)
      : super(_value, _then);

  /// Create a copy of EventPoll
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? createdBy = null,
    Object? question = null,
    Object? options = null,
    Object? allowMultipleChoices = null,
    Object? isActive = null,
    Object? expiresAt = freezed,
    Object? createdAt = freezed,
    Object? creatorName = freezed,
    Object? voteCounts = freezed,
    Object? userVotes = freezed,
  }) {
    return _then(_$EventPollImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      options: null == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allowMultipleChoices: null == allowMultipleChoices
          ? _value.allowMultipleChoices
          : allowMultipleChoices // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      creatorName: freezed == creatorName
          ? _value.creatorName
          : creatorName // ignore: cast_nullable_to_non_nullable
              as String?,
      voteCounts: freezed == voteCounts
          ? _value._voteCounts
          : voteCounts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>?,
      userVotes: freezed == userVotes
          ? _value._userVotes
          : userVotes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventPollImpl implements _EventPoll {
  const _$EventPollImpl(
      {required this.id,
      required this.eventId,
      required this.createdBy,
      required this.question,
      required final List<String> options,
      this.allowMultipleChoices = false,
      this.isActive = true,
      this.expiresAt,
      this.createdAt,
      this.creatorName,
      final Map<String, int>? voteCounts,
      final List<String>? userVotes})
      : _options = options,
        _voteCounts = voteCounts,
        _userVotes = userVotes;

  factory _$EventPollImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventPollImplFromJson(json);

  @override
  final String id;
  @override
  final String eventId;
  @override
  final String createdBy;
  @override
  final String question;
  final List<String> _options;
  @override
  List<String> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  @JsonKey()
  final bool allowMultipleChoices;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? expiresAt;
  @override
  final DateTime? createdAt;
// Joined data
  @override
  final String? creatorName;
  final Map<String, int>? _voteCounts;
  @override
  Map<String, int>? get voteCounts {
    final value = _voteCounts;
    if (value == null) return null;
    if (_voteCounts is EqualUnmodifiableMapView) return _voteCounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<String>? _userVotes;
  @override
  List<String>? get userVotes {
    final value = _userVotes;
    if (value == null) return null;
    if (_userVotes is EqualUnmodifiableListView) return _userVotes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'EventPoll(id: $id, eventId: $eventId, createdBy: $createdBy, question: $question, options: $options, allowMultipleChoices: $allowMultipleChoices, isActive: $isActive, expiresAt: $expiresAt, createdAt: $createdAt, creatorName: $creatorName, voteCounts: $voteCounts, userVotes: $userVotes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventPollImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.question, question) ||
                other.question == question) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            (identical(other.allowMultipleChoices, allowMultipleChoices) ||
                other.allowMultipleChoices == allowMultipleChoices) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.creatorName, creatorName) ||
                other.creatorName == creatorName) &&
            const DeepCollectionEquality()
                .equals(other._voteCounts, _voteCounts) &&
            const DeepCollectionEquality()
                .equals(other._userVotes, _userVotes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      eventId,
      createdBy,
      question,
      const DeepCollectionEquality().hash(_options),
      allowMultipleChoices,
      isActive,
      expiresAt,
      createdAt,
      creatorName,
      const DeepCollectionEquality().hash(_voteCounts),
      const DeepCollectionEquality().hash(_userVotes));

  /// Create a copy of EventPoll
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventPollImplCopyWith<_$EventPollImpl> get copyWith =>
      __$$EventPollImplCopyWithImpl<_$EventPollImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventPollImplToJson(
      this,
    );
  }
}

abstract class _EventPoll implements EventPoll {
  const factory _EventPoll(
      {required final String id,
      required final String eventId,
      required final String createdBy,
      required final String question,
      required final List<String> options,
      final bool allowMultipleChoices,
      final bool isActive,
      final DateTime? expiresAt,
      final DateTime? createdAt,
      final String? creatorName,
      final Map<String, int>? voteCounts,
      final List<String>? userVotes}) = _$EventPollImpl;

  factory _EventPoll.fromJson(Map<String, dynamic> json) =
      _$EventPollImpl.fromJson;

  @override
  String get id;
  @override
  String get eventId;
  @override
  String get createdBy;
  @override
  String get question;
  @override
  List<String> get options;
  @override
  bool get allowMultipleChoices;
  @override
  bool get isActive;
  @override
  DateTime? get expiresAt;
  @override
  DateTime? get createdAt; // Joined data
  @override
  String? get creatorName;
  @override
  Map<String, int>? get voteCounts;
  @override
  List<String>? get userVotes;

  /// Create a copy of EventPoll
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventPollImplCopyWith<_$EventPollImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PollVote _$PollVoteFromJson(Map<String, dynamic> json) {
  return _PollVote.fromJson(json);
}

/// @nodoc
mixin _$PollVote {
  String get id => throw _privateConstructorUsedError;
  String get pollId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get optionIndex => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

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
      String userId,
      String optionIndex,
      DateTime? createdAt});
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
    Object? userId = null,
    Object? optionIndex = null,
    Object? createdAt = freezed,
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
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      optionIndex: null == optionIndex
          ? _value.optionIndex
          : optionIndex // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
      String userId,
      String optionIndex,
      DateTime? createdAt});
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
    Object? userId = null,
    Object? optionIndex = null,
    Object? createdAt = freezed,
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
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      optionIndex: null == optionIndex
          ? _value.optionIndex
          : optionIndex // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PollVoteImpl implements _PollVote {
  const _$PollVoteImpl(
      {required this.id,
      required this.pollId,
      required this.userId,
      required this.optionIndex,
      this.createdAt});

  factory _$PollVoteImpl.fromJson(Map<String, dynamic> json) =>
      _$$PollVoteImplFromJson(json);

  @override
  final String id;
  @override
  final String pollId;
  @override
  final String userId;
  @override
  final String optionIndex;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'PollVote(id: $id, pollId: $pollId, userId: $userId, optionIndex: $optionIndex, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PollVoteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.pollId, pollId) || other.pollId == pollId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.optionIndex, optionIndex) ||
                other.optionIndex == optionIndex) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, pollId, userId, optionIndex, createdAt);

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
      required final String userId,
      required final String optionIndex,
      final DateTime? createdAt}) = _$PollVoteImpl;

  factory _PollVote.fromJson(Map<String, dynamic> json) =
      _$PollVoteImpl.fromJson;

  @override
  String get id;
  @override
  String get pollId;
  @override
  String get userId;
  @override
  String get optionIndex;
  @override
  DateTime? get createdAt;

  /// Create a copy of PollVote
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PollVoteImplCopyWith<_$PollVoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
