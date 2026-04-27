// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_reaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatReaction _$ChatReactionFromJson(Map<String, dynamic> json) {
  return _ChatReaction.fromJson(json);
}

/// @nodoc
mixin _$ChatReaction {
  String get id => throw _privateConstructorUsedError;
  String get messageId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String? get userAvatar => throw _privateConstructorUsedError;
  String get emoji => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ChatReaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatReaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatReactionCopyWith<ChatReaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatReactionCopyWith<$Res> {
  factory $ChatReactionCopyWith(
          ChatReaction value, $Res Function(ChatReaction) then) =
      _$ChatReactionCopyWithImpl<$Res, ChatReaction>;
  @useResult
  $Res call(
      {String id,
      String messageId,
      String userId,
      String userName,
      String? userAvatar,
      String emoji,
      DateTime createdAt});
}

/// @nodoc
class _$ChatReactionCopyWithImpl<$Res, $Val extends ChatReaction>
    implements $ChatReactionCopyWith<$Res> {
  _$ChatReactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatReaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? messageId = null,
    Object? userId = null,
    Object? userName = null,
    Object? userAvatar = freezed,
    Object? emoji = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      messageId: null == messageId
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userAvatar: freezed == userAvatar
          ? _value.userAvatar
          : userAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      emoji: null == emoji
          ? _value.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatReactionImplCopyWith<$Res>
    implements $ChatReactionCopyWith<$Res> {
  factory _$$ChatReactionImplCopyWith(
          _$ChatReactionImpl value, $Res Function(_$ChatReactionImpl) then) =
      __$$ChatReactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String messageId,
      String userId,
      String userName,
      String? userAvatar,
      String emoji,
      DateTime createdAt});
}

/// @nodoc
class __$$ChatReactionImplCopyWithImpl<$Res>
    extends _$ChatReactionCopyWithImpl<$Res, _$ChatReactionImpl>
    implements _$$ChatReactionImplCopyWith<$Res> {
  __$$ChatReactionImplCopyWithImpl(
      _$ChatReactionImpl _value, $Res Function(_$ChatReactionImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatReaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? messageId = null,
    Object? userId = null,
    Object? userName = null,
    Object? userAvatar = freezed,
    Object? emoji = null,
    Object? createdAt = null,
  }) {
    return _then(_$ChatReactionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      messageId: null == messageId
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userAvatar: freezed == userAvatar
          ? _value.userAvatar
          : userAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      emoji: null == emoji
          ? _value.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatReactionImpl implements _ChatReaction {
  const _$ChatReactionImpl(
      {required this.id,
      required this.messageId,
      required this.userId,
      required this.userName,
      this.userAvatar,
      required this.emoji,
      required this.createdAt});

  factory _$ChatReactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatReactionImplFromJson(json);

  @override
  final String id;
  @override
  final String messageId;
  @override
  final String userId;
  @override
  final String userName;
  @override
  final String? userAvatar;
  @override
  final String emoji;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ChatReaction(id: $id, messageId: $messageId, userId: $userId, userName: $userName, userAvatar: $userAvatar, emoji: $emoji, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatReactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userAvatar, userAvatar) ||
                other.userAvatar == userAvatar) &&
            (identical(other.emoji, emoji) || other.emoji == emoji) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, messageId, userId, userName,
      userAvatar, emoji, createdAt);

  /// Create a copy of ChatReaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatReactionImplCopyWith<_$ChatReactionImpl> get copyWith =>
      __$$ChatReactionImplCopyWithImpl<_$ChatReactionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatReactionImplToJson(
      this,
    );
  }
}

abstract class _ChatReaction implements ChatReaction {
  const factory _ChatReaction(
      {required final String id,
      required final String messageId,
      required final String userId,
      required final String userName,
      final String? userAvatar,
      required final String emoji,
      required final DateTime createdAt}) = _$ChatReactionImpl;

  factory _ChatReaction.fromJson(Map<String, dynamic> json) =
      _$ChatReactionImpl.fromJson;

  @override
  String get id;
  @override
  String get messageId;
  @override
  String get userId;
  @override
  String get userName;
  @override
  String? get userAvatar;
  @override
  String get emoji;
  @override
  DateTime get createdAt;

  /// Create a copy of ChatReaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatReactionImplCopyWith<_$ChatReactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MessageReactionSummary _$MessageReactionSummaryFromJson(
    Map<String, dynamic> json) {
  return _MessageReactionSummary.fromJson(json);
}

/// @nodoc
mixin _$MessageReactionSummary {
  String get messageId => throw _privateConstructorUsedError;
  Map<String, int> get emojiCounts => throw _privateConstructorUsedError;
  Map<String, List<String>> get usersByEmoji =>
      throw _privateConstructorUsedError;
  int get totalReactions => throw _privateConstructorUsedError;

  /// Serializes this MessageReactionSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageReactionSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageReactionSummaryCopyWith<MessageReactionSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageReactionSummaryCopyWith<$Res> {
  factory $MessageReactionSummaryCopyWith(MessageReactionSummary value,
          $Res Function(MessageReactionSummary) then) =
      _$MessageReactionSummaryCopyWithImpl<$Res, MessageReactionSummary>;
  @useResult
  $Res call(
      {String messageId,
      Map<String, int> emojiCounts,
      Map<String, List<String>> usersByEmoji,
      int totalReactions});
}

/// @nodoc
class _$MessageReactionSummaryCopyWithImpl<$Res,
        $Val extends MessageReactionSummary>
    implements $MessageReactionSummaryCopyWith<$Res> {
  _$MessageReactionSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageReactionSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messageId = null,
    Object? emojiCounts = null,
    Object? usersByEmoji = null,
    Object? totalReactions = null,
  }) {
    return _then(_value.copyWith(
      messageId: null == messageId
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      emojiCounts: null == emojiCounts
          ? _value.emojiCounts
          : emojiCounts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      usersByEmoji: null == usersByEmoji
          ? _value.usersByEmoji
          : usersByEmoji // ignore: cast_nullable_to_non_nullable
              as Map<String, List<String>>,
      totalReactions: null == totalReactions
          ? _value.totalReactions
          : totalReactions // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageReactionSummaryImplCopyWith<$Res>
    implements $MessageReactionSummaryCopyWith<$Res> {
  factory _$$MessageReactionSummaryImplCopyWith(
          _$MessageReactionSummaryImpl value,
          $Res Function(_$MessageReactionSummaryImpl) then) =
      __$$MessageReactionSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String messageId,
      Map<String, int> emojiCounts,
      Map<String, List<String>> usersByEmoji,
      int totalReactions});
}

/// @nodoc
class __$$MessageReactionSummaryImplCopyWithImpl<$Res>
    extends _$MessageReactionSummaryCopyWithImpl<$Res,
        _$MessageReactionSummaryImpl>
    implements _$$MessageReactionSummaryImplCopyWith<$Res> {
  __$$MessageReactionSummaryImplCopyWithImpl(
      _$MessageReactionSummaryImpl _value,
      $Res Function(_$MessageReactionSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of MessageReactionSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messageId = null,
    Object? emojiCounts = null,
    Object? usersByEmoji = null,
    Object? totalReactions = null,
  }) {
    return _then(_$MessageReactionSummaryImpl(
      messageId: null == messageId
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      emojiCounts: null == emojiCounts
          ? _value._emojiCounts
          : emojiCounts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      usersByEmoji: null == usersByEmoji
          ? _value._usersByEmoji
          : usersByEmoji // ignore: cast_nullable_to_non_nullable
              as Map<String, List<String>>,
      totalReactions: null == totalReactions
          ? _value.totalReactions
          : totalReactions // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageReactionSummaryImpl implements _MessageReactionSummary {
  const _$MessageReactionSummaryImpl(
      {required this.messageId,
      required final Map<String, int> emojiCounts,
      required final Map<String, List<String>> usersByEmoji,
      this.totalReactions = 0})
      : _emojiCounts = emojiCounts,
        _usersByEmoji = usersByEmoji;

  factory _$MessageReactionSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageReactionSummaryImplFromJson(json);

  @override
  final String messageId;
  final Map<String, int> _emojiCounts;
  @override
  Map<String, int> get emojiCounts {
    if (_emojiCounts is EqualUnmodifiableMapView) return _emojiCounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_emojiCounts);
  }

  final Map<String, List<String>> _usersByEmoji;
  @override
  Map<String, List<String>> get usersByEmoji {
    if (_usersByEmoji is EqualUnmodifiableMapView) return _usersByEmoji;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_usersByEmoji);
  }

  @override
  @JsonKey()
  final int totalReactions;

  @override
  String toString() {
    return 'MessageReactionSummary(messageId: $messageId, emojiCounts: $emojiCounts, usersByEmoji: $usersByEmoji, totalReactions: $totalReactions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageReactionSummaryImpl &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            const DeepCollectionEquality()
                .equals(other._emojiCounts, _emojiCounts) &&
            const DeepCollectionEquality()
                .equals(other._usersByEmoji, _usersByEmoji) &&
            (identical(other.totalReactions, totalReactions) ||
                other.totalReactions == totalReactions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      messageId,
      const DeepCollectionEquality().hash(_emojiCounts),
      const DeepCollectionEquality().hash(_usersByEmoji),
      totalReactions);

  /// Create a copy of MessageReactionSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageReactionSummaryImplCopyWith<_$MessageReactionSummaryImpl>
      get copyWith => __$$MessageReactionSummaryImplCopyWithImpl<
          _$MessageReactionSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageReactionSummaryImplToJson(
      this,
    );
  }
}

abstract class _MessageReactionSummary implements MessageReactionSummary {
  const factory _MessageReactionSummary(
      {required final String messageId,
      required final Map<String, int> emojiCounts,
      required final Map<String, List<String>> usersByEmoji,
      final int totalReactions}) = _$MessageReactionSummaryImpl;

  factory _MessageReactionSummary.fromJson(Map<String, dynamic> json) =
      _$MessageReactionSummaryImpl.fromJson;

  @override
  String get messageId;
  @override
  Map<String, int> get emojiCounts;
  @override
  Map<String, List<String>> get usersByEmoji;
  @override
  int get totalReactions;

  /// Create a copy of MessageReactionSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageReactionSummaryImplCopyWith<_$MessageReactionSummaryImpl>
      get copyWith => throw _privateConstructorUsedError;
}
