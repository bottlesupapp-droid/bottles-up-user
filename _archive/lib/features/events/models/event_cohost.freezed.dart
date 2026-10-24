// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_cohost.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventCohost _$EventCohostFromJson(Map<String, dynamic> json) {
  return _EventCohost.fromJson(json);
}

/// @nodoc
mixin _$EventCohost {
  String get id => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String? get userAvatar => throw _privateConstructorUsedError;
  String get invitedBy => throw _privateConstructorUsedError;
  CohostStatus get status => throw _privateConstructorUsedError;
  List<CohostPermission> get permissions => throw _privateConstructorUsedError;
  DateTime get invitedAt => throw _privateConstructorUsedError;
  DateTime? get respondedAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  bool get isPrimaryHost => throw _privateConstructorUsedError;

  /// Serializes this EventCohost to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EventCohost
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventCohostCopyWith<EventCohost> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventCohostCopyWith<$Res> {
  factory $EventCohostCopyWith(
          EventCohost value, $Res Function(EventCohost) then) =
      _$EventCohostCopyWithImpl<$Res, EventCohost>;
  @useResult
  $Res call(
      {String id,
      String eventId,
      String userId,
      String userName,
      String? userAvatar,
      String invitedBy,
      CohostStatus status,
      List<CohostPermission> permissions,
      DateTime invitedAt,
      DateTime? respondedAt,
      DateTime? createdAt,
      String? notes,
      bool isPrimaryHost});
}

/// @nodoc
class _$EventCohostCopyWithImpl<$Res, $Val extends EventCohost>
    implements $EventCohostCopyWith<$Res> {
  _$EventCohostCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventCohost
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? userId = null,
    Object? userName = null,
    Object? userAvatar = freezed,
    Object? invitedBy = null,
    Object? status = null,
    Object? permissions = null,
    Object? invitedAt = null,
    Object? respondedAt = freezed,
    Object? createdAt = freezed,
    Object? notes = freezed,
    Object? isPrimaryHost = null,
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
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userAvatar: freezed == userAvatar
          ? _value.userAvatar
          : userAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      invitedBy: null == invitedBy
          ? _value.invitedBy
          : invitedBy // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CohostStatus,
      permissions: null == permissions
          ? _value.permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as List<CohostPermission>,
      invitedAt: null == invitedAt
          ? _value.invitedAt
          : invitedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isPrimaryHost: null == isPrimaryHost
          ? _value.isPrimaryHost
          : isPrimaryHost // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventCohostImplCopyWith<$Res>
    implements $EventCohostCopyWith<$Res> {
  factory _$$EventCohostImplCopyWith(
          _$EventCohostImpl value, $Res Function(_$EventCohostImpl) then) =
      __$$EventCohostImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String eventId,
      String userId,
      String userName,
      String? userAvatar,
      String invitedBy,
      CohostStatus status,
      List<CohostPermission> permissions,
      DateTime invitedAt,
      DateTime? respondedAt,
      DateTime? createdAt,
      String? notes,
      bool isPrimaryHost});
}

/// @nodoc
class __$$EventCohostImplCopyWithImpl<$Res>
    extends _$EventCohostCopyWithImpl<$Res, _$EventCohostImpl>
    implements _$$EventCohostImplCopyWith<$Res> {
  __$$EventCohostImplCopyWithImpl(
      _$EventCohostImpl _value, $Res Function(_$EventCohostImpl) _then)
      : super(_value, _then);

  /// Create a copy of EventCohost
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? userId = null,
    Object? userName = null,
    Object? userAvatar = freezed,
    Object? invitedBy = null,
    Object? status = null,
    Object? permissions = null,
    Object? invitedAt = null,
    Object? respondedAt = freezed,
    Object? createdAt = freezed,
    Object? notes = freezed,
    Object? isPrimaryHost = null,
  }) {
    return _then(_$EventCohostImpl(
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
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userAvatar: freezed == userAvatar
          ? _value.userAvatar
          : userAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      invitedBy: null == invitedBy
          ? _value.invitedBy
          : invitedBy // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CohostStatus,
      permissions: null == permissions
          ? _value._permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as List<CohostPermission>,
      invitedAt: null == invitedAt
          ? _value.invitedAt
          : invitedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isPrimaryHost: null == isPrimaryHost
          ? _value.isPrimaryHost
          : isPrimaryHost // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventCohostImpl implements _EventCohost {
  const _$EventCohostImpl(
      {required this.id,
      required this.eventId,
      required this.userId,
      required this.userName,
      this.userAvatar,
      required this.invitedBy,
      required this.status,
      required final List<CohostPermission> permissions,
      required this.invitedAt,
      this.respondedAt,
      this.createdAt,
      this.notes,
      this.isPrimaryHost = false})
      : _permissions = permissions;

  factory _$EventCohostImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventCohostImplFromJson(json);

  @override
  final String id;
  @override
  final String eventId;
  @override
  final String userId;
  @override
  final String userName;
  @override
  final String? userAvatar;
  @override
  final String invitedBy;
  @override
  final CohostStatus status;
  final List<CohostPermission> _permissions;
  @override
  List<CohostPermission> get permissions {
    if (_permissions is EqualUnmodifiableListView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_permissions);
  }

  @override
  final DateTime invitedAt;
  @override
  final DateTime? respondedAt;
  @override
  final DateTime? createdAt;
  @override
  final String? notes;
  @override
  @JsonKey()
  final bool isPrimaryHost;

  @override
  String toString() {
    return 'EventCohost(id: $id, eventId: $eventId, userId: $userId, userName: $userName, userAvatar: $userAvatar, invitedBy: $invitedBy, status: $status, permissions: $permissions, invitedAt: $invitedAt, respondedAt: $respondedAt, createdAt: $createdAt, notes: $notes, isPrimaryHost: $isPrimaryHost)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventCohostImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userAvatar, userAvatar) ||
                other.userAvatar == userAvatar) &&
            (identical(other.invitedBy, invitedBy) ||
                other.invitedBy == invitedBy) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._permissions, _permissions) &&
            (identical(other.invitedAt, invitedAt) ||
                other.invitedAt == invitedAt) &&
            (identical(other.respondedAt, respondedAt) ||
                other.respondedAt == respondedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isPrimaryHost, isPrimaryHost) ||
                other.isPrimaryHost == isPrimaryHost));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      eventId,
      userId,
      userName,
      userAvatar,
      invitedBy,
      status,
      const DeepCollectionEquality().hash(_permissions),
      invitedAt,
      respondedAt,
      createdAt,
      notes,
      isPrimaryHost);

  /// Create a copy of EventCohost
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventCohostImplCopyWith<_$EventCohostImpl> get copyWith =>
      __$$EventCohostImplCopyWithImpl<_$EventCohostImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventCohostImplToJson(
      this,
    );
  }
}

abstract class _EventCohost implements EventCohost {
  const factory _EventCohost(
      {required final String id,
      required final String eventId,
      required final String userId,
      required final String userName,
      final String? userAvatar,
      required final String invitedBy,
      required final CohostStatus status,
      required final List<CohostPermission> permissions,
      required final DateTime invitedAt,
      final DateTime? respondedAt,
      final DateTime? createdAt,
      final String? notes,
      final bool isPrimaryHost}) = _$EventCohostImpl;

  factory _EventCohost.fromJson(Map<String, dynamic> json) =
      _$EventCohostImpl.fromJson;

  @override
  String get id;
  @override
  String get eventId;
  @override
  String get userId;
  @override
  String get userName;
  @override
  String? get userAvatar;
  @override
  String get invitedBy;
  @override
  CohostStatus get status;
  @override
  List<CohostPermission> get permissions;
  @override
  DateTime get invitedAt;
  @override
  DateTime? get respondedAt;
  @override
  DateTime? get createdAt;
  @override
  String? get notes;
  @override
  bool get isPrimaryHost;

  /// Create a copy of EventCohost
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventCohostImplCopyWith<_$EventCohostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CohostInvitation _$CohostInvitationFromJson(Map<String, dynamic> json) {
  return _CohostInvitation.fromJson(json);
}

/// @nodoc
mixin _$CohostInvitation {
  String get eventId => throw _privateConstructorUsedError;
  String get eventName => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userEmail => throw _privateConstructorUsedError;
  String? get userName => throw _privateConstructorUsedError;
  List<CohostPermission> get permissions => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this CohostInvitation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CohostInvitation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CohostInvitationCopyWith<CohostInvitation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CohostInvitationCopyWith<$Res> {
  factory $CohostInvitationCopyWith(
          CohostInvitation value, $Res Function(CohostInvitation) then) =
      _$CohostInvitationCopyWithImpl<$Res, CohostInvitation>;
  @useResult
  $Res call(
      {String eventId,
      String eventName,
      String userId,
      String userEmail,
      String? userName,
      List<CohostPermission> permissions,
      String? message});
}

/// @nodoc
class _$CohostInvitationCopyWithImpl<$Res, $Val extends CohostInvitation>
    implements $CohostInvitationCopyWith<$Res> {
  _$CohostInvitationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CohostInvitation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? eventName = null,
    Object? userId = null,
    Object? userEmail = null,
    Object? userName = freezed,
    Object? permissions = null,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      eventName: null == eventName
          ? _value.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userEmail: null == userEmail
          ? _value.userEmail
          : userEmail // ignore: cast_nullable_to_non_nullable
              as String,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      permissions: null == permissions
          ? _value.permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as List<CohostPermission>,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CohostInvitationImplCopyWith<$Res>
    implements $CohostInvitationCopyWith<$Res> {
  factory _$$CohostInvitationImplCopyWith(_$CohostInvitationImpl value,
          $Res Function(_$CohostInvitationImpl) then) =
      __$$CohostInvitationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String eventId,
      String eventName,
      String userId,
      String userEmail,
      String? userName,
      List<CohostPermission> permissions,
      String? message});
}

/// @nodoc
class __$$CohostInvitationImplCopyWithImpl<$Res>
    extends _$CohostInvitationCopyWithImpl<$Res, _$CohostInvitationImpl>
    implements _$$CohostInvitationImplCopyWith<$Res> {
  __$$CohostInvitationImplCopyWithImpl(_$CohostInvitationImpl _value,
      $Res Function(_$CohostInvitationImpl) _then)
      : super(_value, _then);

  /// Create a copy of CohostInvitation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? eventName = null,
    Object? userId = null,
    Object? userEmail = null,
    Object? userName = freezed,
    Object? permissions = null,
    Object? message = freezed,
  }) {
    return _then(_$CohostInvitationImpl(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      eventName: null == eventName
          ? _value.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userEmail: null == userEmail
          ? _value.userEmail
          : userEmail // ignore: cast_nullable_to_non_nullable
              as String,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      permissions: null == permissions
          ? _value._permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as List<CohostPermission>,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CohostInvitationImpl implements _CohostInvitation {
  const _$CohostInvitationImpl(
      {required this.eventId,
      required this.eventName,
      required this.userId,
      required this.userEmail,
      this.userName,
      required final List<CohostPermission> permissions,
      this.message})
      : _permissions = permissions;

  factory _$CohostInvitationImpl.fromJson(Map<String, dynamic> json) =>
      _$$CohostInvitationImplFromJson(json);

  @override
  final String eventId;
  @override
  final String eventName;
  @override
  final String userId;
  @override
  final String userEmail;
  @override
  final String? userName;
  final List<CohostPermission> _permissions;
  @override
  List<CohostPermission> get permissions {
    if (_permissions is EqualUnmodifiableListView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_permissions);
  }

  @override
  final String? message;

  @override
  String toString() {
    return 'CohostInvitation(eventId: $eventId, eventName: $eventName, userId: $userId, userEmail: $userEmail, userName: $userName, permissions: $permissions, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CohostInvitationImpl &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.eventName, eventName) ||
                other.eventName == eventName) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userEmail, userEmail) ||
                other.userEmail == userEmail) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            const DeepCollectionEquality()
                .equals(other._permissions, _permissions) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      eventId,
      eventName,
      userId,
      userEmail,
      userName,
      const DeepCollectionEquality().hash(_permissions),
      message);

  /// Create a copy of CohostInvitation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CohostInvitationImplCopyWith<_$CohostInvitationImpl> get copyWith =>
      __$$CohostInvitationImplCopyWithImpl<_$CohostInvitationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CohostInvitationImplToJson(
      this,
    );
  }
}

abstract class _CohostInvitation implements CohostInvitation {
  const factory _CohostInvitation(
      {required final String eventId,
      required final String eventName,
      required final String userId,
      required final String userEmail,
      final String? userName,
      required final List<CohostPermission> permissions,
      final String? message}) = _$CohostInvitationImpl;

  factory _CohostInvitation.fromJson(Map<String, dynamic> json) =
      _$CohostInvitationImpl.fromJson;

  @override
  String get eventId;
  @override
  String get eventName;
  @override
  String get userId;
  @override
  String get userEmail;
  @override
  String? get userName;
  @override
  List<CohostPermission> get permissions;
  @override
  String? get message;

  /// Create a copy of CohostInvitation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CohostInvitationImplCopyWith<_$CohostInvitationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
