// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Friend _$FriendFromJson(Map<String, dynamic> json) {
  return _Friend.fromJson(json);
}

/// @nodoc
mixin _$Friend {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get friendId => throw _privateConstructorUsedError;
  String get friendName => throw _privateConstructorUsedError;
  String? get friendAvatar => throw _privateConstructorUsedError;
  String? get friendEmail => throw _privateConstructorUsedError;
  FriendshipStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get acceptedAt => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this Friend to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Friend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendCopyWith<Friend> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendCopyWith<$Res> {
  factory $FriendCopyWith(Friend value, $Res Function(Friend) then) =
      _$FriendCopyWithImpl<$Res, Friend>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String friendId,
      String friendName,
      String? friendAvatar,
      String? friendEmail,
      FriendshipStatus status,
      DateTime createdAt,
      DateTime? acceptedAt,
      bool isFavorite,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$FriendCopyWithImpl<$Res, $Val extends Friend>
    implements $FriendCopyWith<$Res> {
  _$FriendCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Friend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? friendId = null,
    Object? friendName = null,
    Object? friendAvatar = freezed,
    Object? friendEmail = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? acceptedAt = freezed,
    Object? isFavorite = null,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      friendId: null == friendId
          ? _value.friendId
          : friendId // ignore: cast_nullable_to_non_nullable
              as String,
      friendName: null == friendName
          ? _value.friendName
          : friendName // ignore: cast_nullable_to_non_nullable
              as String,
      friendAvatar: freezed == friendAvatar
          ? _value.friendAvatar
          : friendAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      friendEmail: freezed == friendEmail
          ? _value.friendEmail
          : friendEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FriendshipStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      acceptedAt: freezed == acceptedAt
          ? _value.acceptedAt
          : acceptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FriendImplCopyWith<$Res> implements $FriendCopyWith<$Res> {
  factory _$$FriendImplCopyWith(
          _$FriendImpl value, $Res Function(_$FriendImpl) then) =
      __$$FriendImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String friendId,
      String friendName,
      String? friendAvatar,
      String? friendEmail,
      FriendshipStatus status,
      DateTime createdAt,
      DateTime? acceptedAt,
      bool isFavorite,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$FriendImplCopyWithImpl<$Res>
    extends _$FriendCopyWithImpl<$Res, _$FriendImpl>
    implements _$$FriendImplCopyWith<$Res> {
  __$$FriendImplCopyWithImpl(
      _$FriendImpl _value, $Res Function(_$FriendImpl) _then)
      : super(_value, _then);

  /// Create a copy of Friend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? friendId = null,
    Object? friendName = null,
    Object? friendAvatar = freezed,
    Object? friendEmail = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? acceptedAt = freezed,
    Object? isFavorite = null,
    Object? metadata = freezed,
  }) {
    return _then(_$FriendImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      friendId: null == friendId
          ? _value.friendId
          : friendId // ignore: cast_nullable_to_non_nullable
              as String,
      friendName: null == friendName
          ? _value.friendName
          : friendName // ignore: cast_nullable_to_non_nullable
              as String,
      friendAvatar: freezed == friendAvatar
          ? _value.friendAvatar
          : friendAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      friendEmail: freezed == friendEmail
          ? _value.friendEmail
          : friendEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FriendshipStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      acceptedAt: freezed == acceptedAt
          ? _value.acceptedAt
          : acceptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FriendImpl implements _Friend {
  const _$FriendImpl(
      {required this.id,
      required this.userId,
      required this.friendId,
      required this.friendName,
      this.friendAvatar,
      this.friendEmail,
      required this.status,
      required this.createdAt,
      this.acceptedAt,
      this.isFavorite = false,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$FriendImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String friendId;
  @override
  final String friendName;
  @override
  final String? friendAvatar;
  @override
  final String? friendEmail;
  @override
  final FriendshipStatus status;
  @override
  final DateTime createdAt;
  @override
  final DateTime? acceptedAt;
  @override
  @JsonKey()
  final bool isFavorite;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Friend(id: $id, userId: $userId, friendId: $friendId, friendName: $friendName, friendAvatar: $friendAvatar, friendEmail: $friendEmail, status: $status, createdAt: $createdAt, acceptedAt: $acceptedAt, isFavorite: $isFavorite, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.friendId, friendId) ||
                other.friendId == friendId) &&
            (identical(other.friendName, friendName) ||
                other.friendName == friendName) &&
            (identical(other.friendAvatar, friendAvatar) ||
                other.friendAvatar == friendAvatar) &&
            (identical(other.friendEmail, friendEmail) ||
                other.friendEmail == friendEmail) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.acceptedAt, acceptedAt) ||
                other.acceptedAt == acceptedAt) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      friendId,
      friendName,
      friendAvatar,
      friendEmail,
      status,
      createdAt,
      acceptedAt,
      isFavorite,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of Friend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendImplCopyWith<_$FriendImpl> get copyWith =>
      __$$FriendImplCopyWithImpl<_$FriendImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendImplToJson(
      this,
    );
  }
}

abstract class _Friend implements Friend {
  const factory _Friend(
      {required final String id,
      required final String userId,
      required final String friendId,
      required final String friendName,
      final String? friendAvatar,
      final String? friendEmail,
      required final FriendshipStatus status,
      required final DateTime createdAt,
      final DateTime? acceptedAt,
      final bool isFavorite,
      final Map<String, dynamic>? metadata}) = _$FriendImpl;

  factory _Friend.fromJson(Map<String, dynamic> json) = _$FriendImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get friendId;
  @override
  String get friendName;
  @override
  String? get friendAvatar;
  @override
  String? get friendEmail;
  @override
  FriendshipStatus get status;
  @override
  DateTime get createdAt;
  @override
  DateTime? get acceptedAt;
  @override
  bool get isFavorite;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of Friend
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendImplCopyWith<_$FriendImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FriendInvitation _$FriendInvitationFromJson(Map<String, dynamic> json) {
  return _FriendInvitation.fromJson(json);
}

/// @nodoc
mixin _$FriendInvitation {
  String get id => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String get senderName => throw _privateConstructorUsedError;
  String? get senderAvatar => throw _privateConstructorUsedError;
  String? get recipientId => throw _privateConstructorUsedError;
  String? get recipientEmail => throw _privateConstructorUsedError;
  String? get recipientPhone => throw _privateConstructorUsedError;
  InvitationMethod get method => throw _privateConstructorUsedError;
  FriendshipStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  String? get invitationCode => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this FriendInvitation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FriendInvitation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendInvitationCopyWith<FriendInvitation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendInvitationCopyWith<$Res> {
  factory $FriendInvitationCopyWith(
          FriendInvitation value, $Res Function(FriendInvitation) then) =
      _$FriendInvitationCopyWithImpl<$Res, FriendInvitation>;
  @useResult
  $Res call(
      {String id,
      String senderId,
      String senderName,
      String? senderAvatar,
      String? recipientId,
      String? recipientEmail,
      String? recipientPhone,
      InvitationMethod method,
      FriendshipStatus status,
      DateTime createdAt,
      DateTime? expiresAt,
      String? invitationCode,
      String? message});
}

/// @nodoc
class _$FriendInvitationCopyWithImpl<$Res, $Val extends FriendInvitation>
    implements $FriendInvitationCopyWith<$Res> {
  _$FriendInvitationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FriendInvitation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderId = null,
    Object? senderName = null,
    Object? senderAvatar = freezed,
    Object? recipientId = freezed,
    Object? recipientEmail = freezed,
    Object? recipientPhone = freezed,
    Object? method = null,
    Object? status = null,
    Object? createdAt = null,
    Object? expiresAt = freezed,
    Object? invitationCode = freezed,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      senderName: null == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String,
      senderAvatar: freezed == senderAvatar
          ? _value.senderAvatar
          : senderAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      recipientId: freezed == recipientId
          ? _value.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String?,
      recipientEmail: freezed == recipientEmail
          ? _value.recipientEmail
          : recipientEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      recipientPhone: freezed == recipientPhone
          ? _value.recipientPhone
          : recipientPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as InvitationMethod,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FriendshipStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      invitationCode: freezed == invitationCode
          ? _value.invitationCode
          : invitationCode // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FriendInvitationImplCopyWith<$Res>
    implements $FriendInvitationCopyWith<$Res> {
  factory _$$FriendInvitationImplCopyWith(_$FriendInvitationImpl value,
          $Res Function(_$FriendInvitationImpl) then) =
      __$$FriendInvitationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String senderId,
      String senderName,
      String? senderAvatar,
      String? recipientId,
      String? recipientEmail,
      String? recipientPhone,
      InvitationMethod method,
      FriendshipStatus status,
      DateTime createdAt,
      DateTime? expiresAt,
      String? invitationCode,
      String? message});
}

/// @nodoc
class __$$FriendInvitationImplCopyWithImpl<$Res>
    extends _$FriendInvitationCopyWithImpl<$Res, _$FriendInvitationImpl>
    implements _$$FriendInvitationImplCopyWith<$Res> {
  __$$FriendInvitationImplCopyWithImpl(_$FriendInvitationImpl _value,
      $Res Function(_$FriendInvitationImpl) _then)
      : super(_value, _then);

  /// Create a copy of FriendInvitation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderId = null,
    Object? senderName = null,
    Object? senderAvatar = freezed,
    Object? recipientId = freezed,
    Object? recipientEmail = freezed,
    Object? recipientPhone = freezed,
    Object? method = null,
    Object? status = null,
    Object? createdAt = null,
    Object? expiresAt = freezed,
    Object? invitationCode = freezed,
    Object? message = freezed,
  }) {
    return _then(_$FriendInvitationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      senderName: null == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String,
      senderAvatar: freezed == senderAvatar
          ? _value.senderAvatar
          : senderAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      recipientId: freezed == recipientId
          ? _value.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String?,
      recipientEmail: freezed == recipientEmail
          ? _value.recipientEmail
          : recipientEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      recipientPhone: freezed == recipientPhone
          ? _value.recipientPhone
          : recipientPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as InvitationMethod,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FriendshipStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      invitationCode: freezed == invitationCode
          ? _value.invitationCode
          : invitationCode // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FriendInvitationImpl implements _FriendInvitation {
  const _$FriendInvitationImpl(
      {required this.id,
      required this.senderId,
      required this.senderName,
      this.senderAvatar,
      this.recipientId,
      this.recipientEmail,
      this.recipientPhone,
      required this.method,
      this.status = FriendshipStatus.pending,
      required this.createdAt,
      this.expiresAt,
      this.invitationCode,
      this.message});

  factory _$FriendInvitationImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendInvitationImplFromJson(json);

  @override
  final String id;
  @override
  final String senderId;
  @override
  final String senderName;
  @override
  final String? senderAvatar;
  @override
  final String? recipientId;
  @override
  final String? recipientEmail;
  @override
  final String? recipientPhone;
  @override
  final InvitationMethod method;
  @override
  @JsonKey()
  final FriendshipStatus status;
  @override
  final DateTime createdAt;
  @override
  final DateTime? expiresAt;
  @override
  final String? invitationCode;
  @override
  final String? message;

  @override
  String toString() {
    return 'FriendInvitation(id: $id, senderId: $senderId, senderName: $senderName, senderAvatar: $senderAvatar, recipientId: $recipientId, recipientEmail: $recipientEmail, recipientPhone: $recipientPhone, method: $method, status: $status, createdAt: $createdAt, expiresAt: $expiresAt, invitationCode: $invitationCode, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendInvitationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.senderAvatar, senderAvatar) ||
                other.senderAvatar == senderAvatar) &&
            (identical(other.recipientId, recipientId) ||
                other.recipientId == recipientId) &&
            (identical(other.recipientEmail, recipientEmail) ||
                other.recipientEmail == recipientEmail) &&
            (identical(other.recipientPhone, recipientPhone) ||
                other.recipientPhone == recipientPhone) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.invitationCode, invitationCode) ||
                other.invitationCode == invitationCode) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      senderId,
      senderName,
      senderAvatar,
      recipientId,
      recipientEmail,
      recipientPhone,
      method,
      status,
      createdAt,
      expiresAt,
      invitationCode,
      message);

  /// Create a copy of FriendInvitation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendInvitationImplCopyWith<_$FriendInvitationImpl> get copyWith =>
      __$$FriendInvitationImplCopyWithImpl<_$FriendInvitationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendInvitationImplToJson(
      this,
    );
  }
}

abstract class _FriendInvitation implements FriendInvitation {
  const factory _FriendInvitation(
      {required final String id,
      required final String senderId,
      required final String senderName,
      final String? senderAvatar,
      final String? recipientId,
      final String? recipientEmail,
      final String? recipientPhone,
      required final InvitationMethod method,
      final FriendshipStatus status,
      required final DateTime createdAt,
      final DateTime? expiresAt,
      final String? invitationCode,
      final String? message}) = _$FriendInvitationImpl;

  factory _FriendInvitation.fromJson(Map<String, dynamic> json) =
      _$FriendInvitationImpl.fromJson;

  @override
  String get id;
  @override
  String get senderId;
  @override
  String get senderName;
  @override
  String? get senderAvatar;
  @override
  String? get recipientId;
  @override
  String? get recipientEmail;
  @override
  String? get recipientPhone;
  @override
  InvitationMethod get method;
  @override
  FriendshipStatus get status;
  @override
  DateTime get createdAt;
  @override
  DateTime? get expiresAt;
  @override
  String? get invitationCode;
  @override
  String? get message;

  /// Create a copy of FriendInvitation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendInvitationImplCopyWith<_$FriendInvitationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ContactSuggestion _$ContactSuggestionFromJson(Map<String, dynamic> json) {
  return _ContactSuggestion.fromJson(json);
}

/// @nodoc
mixin _$ContactSuggestion {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;
  bool get isAlreadyFriend => throw _privateConstructorUsedError;
  bool get hasAppInstalled => throw _privateConstructorUsedError;
  int get mutualFriends => throw _privateConstructorUsedError;
  List<String>? get mutualFriendNames => throw _privateConstructorUsedError;

  /// Serializes this ContactSuggestion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContactSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContactSuggestionCopyWith<ContactSuggestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactSuggestionCopyWith<$Res> {
  factory $ContactSuggestionCopyWith(
          ContactSuggestion value, $Res Function(ContactSuggestion) then) =
      _$ContactSuggestionCopyWithImpl<$Res, ContactSuggestion>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? email,
      String? phone,
      String? avatar,
      bool isAlreadyFriend,
      bool hasAppInstalled,
      int mutualFriends,
      List<String>? mutualFriendNames});
}

/// @nodoc
class _$ContactSuggestionCopyWithImpl<$Res, $Val extends ContactSuggestion>
    implements $ContactSuggestionCopyWith<$Res> {
  _$ContactSuggestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContactSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? avatar = freezed,
    Object? isAlreadyFriend = null,
    Object? hasAppInstalled = null,
    Object? mutualFriends = null,
    Object? mutualFriendNames = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      isAlreadyFriend: null == isAlreadyFriend
          ? _value.isAlreadyFriend
          : isAlreadyFriend // ignore: cast_nullable_to_non_nullable
              as bool,
      hasAppInstalled: null == hasAppInstalled
          ? _value.hasAppInstalled
          : hasAppInstalled // ignore: cast_nullable_to_non_nullable
              as bool,
      mutualFriends: null == mutualFriends
          ? _value.mutualFriends
          : mutualFriends // ignore: cast_nullable_to_non_nullable
              as int,
      mutualFriendNames: freezed == mutualFriendNames
          ? _value.mutualFriendNames
          : mutualFriendNames // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContactSuggestionImplCopyWith<$Res>
    implements $ContactSuggestionCopyWith<$Res> {
  factory _$$ContactSuggestionImplCopyWith(_$ContactSuggestionImpl value,
          $Res Function(_$ContactSuggestionImpl) then) =
      __$$ContactSuggestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? email,
      String? phone,
      String? avatar,
      bool isAlreadyFriend,
      bool hasAppInstalled,
      int mutualFriends,
      List<String>? mutualFriendNames});
}

/// @nodoc
class __$$ContactSuggestionImplCopyWithImpl<$Res>
    extends _$ContactSuggestionCopyWithImpl<$Res, _$ContactSuggestionImpl>
    implements _$$ContactSuggestionImplCopyWith<$Res> {
  __$$ContactSuggestionImplCopyWithImpl(_$ContactSuggestionImpl _value,
      $Res Function(_$ContactSuggestionImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? avatar = freezed,
    Object? isAlreadyFriend = null,
    Object? hasAppInstalled = null,
    Object? mutualFriends = null,
    Object? mutualFriendNames = freezed,
  }) {
    return _then(_$ContactSuggestionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      isAlreadyFriend: null == isAlreadyFriend
          ? _value.isAlreadyFriend
          : isAlreadyFriend // ignore: cast_nullable_to_non_nullable
              as bool,
      hasAppInstalled: null == hasAppInstalled
          ? _value.hasAppInstalled
          : hasAppInstalled // ignore: cast_nullable_to_non_nullable
              as bool,
      mutualFriends: null == mutualFriends
          ? _value.mutualFriends
          : mutualFriends // ignore: cast_nullable_to_non_nullable
              as int,
      mutualFriendNames: freezed == mutualFriendNames
          ? _value._mutualFriendNames
          : mutualFriendNames // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContactSuggestionImpl implements _ContactSuggestion {
  const _$ContactSuggestionImpl(
      {required this.id,
      required this.name,
      this.email,
      this.phone,
      this.avatar,
      this.isAlreadyFriend = false,
      this.hasAppInstalled = false,
      this.mutualFriends = 0,
      final List<String>? mutualFriendNames})
      : _mutualFriendNames = mutualFriendNames;

  factory _$ContactSuggestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactSuggestionImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String? avatar;
  @override
  @JsonKey()
  final bool isAlreadyFriend;
  @override
  @JsonKey()
  final bool hasAppInstalled;
  @override
  @JsonKey()
  final int mutualFriends;
  final List<String>? _mutualFriendNames;
  @override
  List<String>? get mutualFriendNames {
    final value = _mutualFriendNames;
    if (value == null) return null;
    if (_mutualFriendNames is EqualUnmodifiableListView)
      return _mutualFriendNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ContactSuggestion(id: $id, name: $name, email: $email, phone: $phone, avatar: $avatar, isAlreadyFriend: $isAlreadyFriend, hasAppInstalled: $hasAppInstalled, mutualFriends: $mutualFriends, mutualFriendNames: $mutualFriendNames)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactSuggestionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.isAlreadyFriend, isAlreadyFriend) ||
                other.isAlreadyFriend == isAlreadyFriend) &&
            (identical(other.hasAppInstalled, hasAppInstalled) ||
                other.hasAppInstalled == hasAppInstalled) &&
            (identical(other.mutualFriends, mutualFriends) ||
                other.mutualFriends == mutualFriends) &&
            const DeepCollectionEquality()
                .equals(other._mutualFriendNames, _mutualFriendNames));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      email,
      phone,
      avatar,
      isAlreadyFriend,
      hasAppInstalled,
      mutualFriends,
      const DeepCollectionEquality().hash(_mutualFriendNames));

  /// Create a copy of ContactSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactSuggestionImplCopyWith<_$ContactSuggestionImpl> get copyWith =>
      __$$ContactSuggestionImplCopyWithImpl<_$ContactSuggestionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactSuggestionImplToJson(
      this,
    );
  }
}

abstract class _ContactSuggestion implements ContactSuggestion {
  const factory _ContactSuggestion(
      {required final String id,
      required final String name,
      final String? email,
      final String? phone,
      final String? avatar,
      final bool isAlreadyFriend,
      final bool hasAppInstalled,
      final int mutualFriends,
      final List<String>? mutualFriendNames}) = _$ContactSuggestionImpl;

  factory _ContactSuggestion.fromJson(Map<String, dynamic> json) =
      _$ContactSuggestionImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  String? get avatar;
  @override
  bool get isAlreadyFriend;
  @override
  bool get hasAppInstalled;
  @override
  int get mutualFriends;
  @override
  List<String>? get mutualFriendNames;

  /// Create a copy of ContactSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactSuggestionImplCopyWith<_$ContactSuggestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FriendActivity _$FriendActivityFromJson(Map<String, dynamic> json) {
  return _FriendActivity.fromJson(json);
}

/// @nodoc
mixin _$FriendActivity {
  String get id => throw _privateConstructorUsedError;
  String get friendId => throw _privateConstructorUsedError;
  String get friendName => throw _privateConstructorUsedError;
  String? get friendAvatar => throw _privateConstructorUsedError;
  String get activityType => throw _privateConstructorUsedError;
  String get activityDescription => throw _privateConstructorUsedError;
  Map<String, dynamic>? get activityData => throw _privateConstructorUsedError;
  DateTime get activityAt => throw _privateConstructorUsedError;

  /// Serializes this FriendActivity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FriendActivity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendActivityCopyWith<FriendActivity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendActivityCopyWith<$Res> {
  factory $FriendActivityCopyWith(
          FriendActivity value, $Res Function(FriendActivity) then) =
      _$FriendActivityCopyWithImpl<$Res, FriendActivity>;
  @useResult
  $Res call(
      {String id,
      String friendId,
      String friendName,
      String? friendAvatar,
      String activityType,
      String activityDescription,
      Map<String, dynamic>? activityData,
      DateTime activityAt});
}

/// @nodoc
class _$FriendActivityCopyWithImpl<$Res, $Val extends FriendActivity>
    implements $FriendActivityCopyWith<$Res> {
  _$FriendActivityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FriendActivity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? friendId = null,
    Object? friendName = null,
    Object? friendAvatar = freezed,
    Object? activityType = null,
    Object? activityDescription = null,
    Object? activityData = freezed,
    Object? activityAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      friendId: null == friendId
          ? _value.friendId
          : friendId // ignore: cast_nullable_to_non_nullable
              as String,
      friendName: null == friendName
          ? _value.friendName
          : friendName // ignore: cast_nullable_to_non_nullable
              as String,
      friendAvatar: freezed == friendAvatar
          ? _value.friendAvatar
          : friendAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      activityType: null == activityType
          ? _value.activityType
          : activityType // ignore: cast_nullable_to_non_nullable
              as String,
      activityDescription: null == activityDescription
          ? _value.activityDescription
          : activityDescription // ignore: cast_nullable_to_non_nullable
              as String,
      activityData: freezed == activityData
          ? _value.activityData
          : activityData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      activityAt: null == activityAt
          ? _value.activityAt
          : activityAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FriendActivityImplCopyWith<$Res>
    implements $FriendActivityCopyWith<$Res> {
  factory _$$FriendActivityImplCopyWith(_$FriendActivityImpl value,
          $Res Function(_$FriendActivityImpl) then) =
      __$$FriendActivityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String friendId,
      String friendName,
      String? friendAvatar,
      String activityType,
      String activityDescription,
      Map<String, dynamic>? activityData,
      DateTime activityAt});
}

/// @nodoc
class __$$FriendActivityImplCopyWithImpl<$Res>
    extends _$FriendActivityCopyWithImpl<$Res, _$FriendActivityImpl>
    implements _$$FriendActivityImplCopyWith<$Res> {
  __$$FriendActivityImplCopyWithImpl(
      _$FriendActivityImpl _value, $Res Function(_$FriendActivityImpl) _then)
      : super(_value, _then);

  /// Create a copy of FriendActivity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? friendId = null,
    Object? friendName = null,
    Object? friendAvatar = freezed,
    Object? activityType = null,
    Object? activityDescription = null,
    Object? activityData = freezed,
    Object? activityAt = null,
  }) {
    return _then(_$FriendActivityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      friendId: null == friendId
          ? _value.friendId
          : friendId // ignore: cast_nullable_to_non_nullable
              as String,
      friendName: null == friendName
          ? _value.friendName
          : friendName // ignore: cast_nullable_to_non_nullable
              as String,
      friendAvatar: freezed == friendAvatar
          ? _value.friendAvatar
          : friendAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      activityType: null == activityType
          ? _value.activityType
          : activityType // ignore: cast_nullable_to_non_nullable
              as String,
      activityDescription: null == activityDescription
          ? _value.activityDescription
          : activityDescription // ignore: cast_nullable_to_non_nullable
              as String,
      activityData: freezed == activityData
          ? _value._activityData
          : activityData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      activityAt: null == activityAt
          ? _value.activityAt
          : activityAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FriendActivityImpl implements _FriendActivity {
  const _$FriendActivityImpl(
      {required this.id,
      required this.friendId,
      required this.friendName,
      this.friendAvatar,
      required this.activityType,
      required this.activityDescription,
      final Map<String, dynamic>? activityData,
      required this.activityAt})
      : _activityData = activityData;

  factory _$FriendActivityImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendActivityImplFromJson(json);

  @override
  final String id;
  @override
  final String friendId;
  @override
  final String friendName;
  @override
  final String? friendAvatar;
  @override
  final String activityType;
  @override
  final String activityDescription;
  final Map<String, dynamic>? _activityData;
  @override
  Map<String, dynamic>? get activityData {
    final value = _activityData;
    if (value == null) return null;
    if (_activityData is EqualUnmodifiableMapView) return _activityData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime activityAt;

  @override
  String toString() {
    return 'FriendActivity(id: $id, friendId: $friendId, friendName: $friendName, friendAvatar: $friendAvatar, activityType: $activityType, activityDescription: $activityDescription, activityData: $activityData, activityAt: $activityAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendActivityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.friendId, friendId) ||
                other.friendId == friendId) &&
            (identical(other.friendName, friendName) ||
                other.friendName == friendName) &&
            (identical(other.friendAvatar, friendAvatar) ||
                other.friendAvatar == friendAvatar) &&
            (identical(other.activityType, activityType) ||
                other.activityType == activityType) &&
            (identical(other.activityDescription, activityDescription) ||
                other.activityDescription == activityDescription) &&
            const DeepCollectionEquality()
                .equals(other._activityData, _activityData) &&
            (identical(other.activityAt, activityAt) ||
                other.activityAt == activityAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      friendId,
      friendName,
      friendAvatar,
      activityType,
      activityDescription,
      const DeepCollectionEquality().hash(_activityData),
      activityAt);

  /// Create a copy of FriendActivity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendActivityImplCopyWith<_$FriendActivityImpl> get copyWith =>
      __$$FriendActivityImplCopyWithImpl<_$FriendActivityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendActivityImplToJson(
      this,
    );
  }
}

abstract class _FriendActivity implements FriendActivity {
  const factory _FriendActivity(
      {required final String id,
      required final String friendId,
      required final String friendName,
      final String? friendAvatar,
      required final String activityType,
      required final String activityDescription,
      final Map<String, dynamic>? activityData,
      required final DateTime activityAt}) = _$FriendActivityImpl;

  factory _FriendActivity.fromJson(Map<String, dynamic> json) =
      _$FriendActivityImpl.fromJson;

  @override
  String get id;
  @override
  String get friendId;
  @override
  String get friendName;
  @override
  String? get friendAvatar;
  @override
  String get activityType;
  @override
  String get activityDescription;
  @override
  Map<String, dynamic>? get activityData;
  @override
  DateTime get activityAt;

  /// Create a copy of FriendActivity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendActivityImplCopyWith<_$FriendActivityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
