// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'waitlist.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WaitlistEntry _$WaitlistEntryFromJson(Map<String, dynamic> json) {
  return _WaitlistEntry.fromJson(json);
}

/// @nodoc
mixin _$WaitlistEntry {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  int get position => throw _privateConstructorUsedError;
  int get partySize => throw _privateConstructorUsedError;
  String? get userName => throw _privateConstructorUsedError;
  String? get userEmail => throw _privateConstructorUsedError;
  String? get userPhone => throw _privateConstructorUsedError;
  String? get eventName => throw _privateConstructorUsedError;
  DateTime? get eventDate => throw _privateConstructorUsedError;
  WaitlistStatus get status => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get notifiedAt => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this WaitlistEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WaitlistEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WaitlistEntryCopyWith<WaitlistEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WaitlistEntryCopyWith<$Res> {
  factory $WaitlistEntryCopyWith(
          WaitlistEntry value, $Res Function(WaitlistEntry) then) =
      _$WaitlistEntryCopyWithImpl<$Res, WaitlistEntry>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String eventId,
      int position,
      int partySize,
      String? userName,
      String? userEmail,
      String? userPhone,
      String? eventName,
      DateTime? eventDate,
      WaitlistStatus status,
      String? notes,
      DateTime? notifiedAt,
      DateTime? expiresAt,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$WaitlistEntryCopyWithImpl<$Res, $Val extends WaitlistEntry>
    implements $WaitlistEntryCopyWith<$Res> {
  _$WaitlistEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WaitlistEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? eventId = null,
    Object? position = null,
    Object? partySize = null,
    Object? userName = freezed,
    Object? userEmail = freezed,
    Object? userPhone = freezed,
    Object? eventName = freezed,
    Object? eventDate = freezed,
    Object? status = null,
    Object? notes = freezed,
    Object? notifiedAt = freezed,
    Object? expiresAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
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
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as int,
      partySize: null == partySize
          ? _value.partySize
          : partySize // ignore: cast_nullable_to_non_nullable
              as int,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      userEmail: freezed == userEmail
          ? _value.userEmail
          : userEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      userPhone: freezed == userPhone
          ? _value.userPhone
          : userPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      eventName: freezed == eventName
          ? _value.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String?,
      eventDate: freezed == eventDate
          ? _value.eventDate
          : eventDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as WaitlistStatus,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      notifiedAt: freezed == notifiedAt
          ? _value.notifiedAt
          : notifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
abstract class _$$WaitlistEntryImplCopyWith<$Res>
    implements $WaitlistEntryCopyWith<$Res> {
  factory _$$WaitlistEntryImplCopyWith(
          _$WaitlistEntryImpl value, $Res Function(_$WaitlistEntryImpl) then) =
      __$$WaitlistEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String eventId,
      int position,
      int partySize,
      String? userName,
      String? userEmail,
      String? userPhone,
      String? eventName,
      DateTime? eventDate,
      WaitlistStatus status,
      String? notes,
      DateTime? notifiedAt,
      DateTime? expiresAt,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$WaitlistEntryImplCopyWithImpl<$Res>
    extends _$WaitlistEntryCopyWithImpl<$Res, _$WaitlistEntryImpl>
    implements _$$WaitlistEntryImplCopyWith<$Res> {
  __$$WaitlistEntryImplCopyWithImpl(
      _$WaitlistEntryImpl _value, $Res Function(_$WaitlistEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of WaitlistEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? eventId = null,
    Object? position = null,
    Object? partySize = null,
    Object? userName = freezed,
    Object? userEmail = freezed,
    Object? userPhone = freezed,
    Object? eventName = freezed,
    Object? eventDate = freezed,
    Object? status = null,
    Object? notes = freezed,
    Object? notifiedAt = freezed,
    Object? expiresAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$WaitlistEntryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as int,
      partySize: null == partySize
          ? _value.partySize
          : partySize // ignore: cast_nullable_to_non_nullable
              as int,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      userEmail: freezed == userEmail
          ? _value.userEmail
          : userEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      userPhone: freezed == userPhone
          ? _value.userPhone
          : userPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      eventName: freezed == eventName
          ? _value.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String?,
      eventDate: freezed == eventDate
          ? _value.eventDate
          : eventDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as WaitlistStatus,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      notifiedAt: freezed == notifiedAt
          ? _value.notifiedAt
          : notifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
class _$WaitlistEntryImpl extends _WaitlistEntry {
  const _$WaitlistEntryImpl(
      {required this.id,
      required this.userId,
      required this.eventId,
      required this.position,
      required this.partySize,
      this.userName,
      this.userEmail,
      this.userPhone,
      this.eventName,
      this.eventDate,
      this.status = WaitlistStatus.active,
      this.notes,
      this.notifiedAt,
      this.expiresAt,
      required this.createdAt,
      this.updatedAt})
      : super._();

  factory _$WaitlistEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$WaitlistEntryImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String eventId;
  @override
  final int position;
  @override
  final int partySize;
  @override
  final String? userName;
  @override
  final String? userEmail;
  @override
  final String? userPhone;
  @override
  final String? eventName;
  @override
  final DateTime? eventDate;
  @override
  @JsonKey()
  final WaitlistStatus status;
  @override
  final String? notes;
  @override
  final DateTime? notifiedAt;
  @override
  final DateTime? expiresAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'WaitlistEntry(id: $id, userId: $userId, eventId: $eventId, position: $position, partySize: $partySize, userName: $userName, userEmail: $userEmail, userPhone: $userPhone, eventName: $eventName, eventDate: $eventDate, status: $status, notes: $notes, notifiedAt: $notifiedAt, expiresAt: $expiresAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WaitlistEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.partySize, partySize) ||
                other.partySize == partySize) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userEmail, userEmail) ||
                other.userEmail == userEmail) &&
            (identical(other.userPhone, userPhone) ||
                other.userPhone == userPhone) &&
            (identical(other.eventName, eventName) ||
                other.eventName == eventName) &&
            (identical(other.eventDate, eventDate) ||
                other.eventDate == eventDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.notifiedAt, notifiedAt) ||
                other.notifiedAt == notifiedAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
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
      userId,
      eventId,
      position,
      partySize,
      userName,
      userEmail,
      userPhone,
      eventName,
      eventDate,
      status,
      notes,
      notifiedAt,
      expiresAt,
      createdAt,
      updatedAt);

  /// Create a copy of WaitlistEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WaitlistEntryImplCopyWith<_$WaitlistEntryImpl> get copyWith =>
      __$$WaitlistEntryImplCopyWithImpl<_$WaitlistEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WaitlistEntryImplToJson(
      this,
    );
  }
}

abstract class _WaitlistEntry extends WaitlistEntry {
  const factory _WaitlistEntry(
      {required final String id,
      required final String userId,
      required final String eventId,
      required final int position,
      required final int partySize,
      final String? userName,
      final String? userEmail,
      final String? userPhone,
      final String? eventName,
      final DateTime? eventDate,
      final WaitlistStatus status,
      final String? notes,
      final DateTime? notifiedAt,
      final DateTime? expiresAt,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$WaitlistEntryImpl;
  const _WaitlistEntry._() : super._();

  factory _WaitlistEntry.fromJson(Map<String, dynamic> json) =
      _$WaitlistEntryImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get eventId;
  @override
  int get position;
  @override
  int get partySize;
  @override
  String? get userName;
  @override
  String? get userEmail;
  @override
  String? get userPhone;
  @override
  String? get eventName;
  @override
  DateTime? get eventDate;
  @override
  WaitlistStatus get status;
  @override
  String? get notes;
  @override
  DateTime? get notifiedAt;
  @override
  DateTime? get expiresAt;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of WaitlistEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WaitlistEntryImplCopyWith<_$WaitlistEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WaitlistStats _$WaitlistStatsFromJson(Map<String, dynamic> json) {
  return _WaitlistStats.fromJson(json);
}

/// @nodoc
mixin _$WaitlistStats {
  String get eventId => throw _privateConstructorUsedError;
  int get totalWaiting => throw _privateConstructorUsedError;
  int get averageWaitTime => throw _privateConstructorUsedError;
  int get conversionRate => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this WaitlistStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WaitlistStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WaitlistStatsCopyWith<WaitlistStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WaitlistStatsCopyWith<$Res> {
  factory $WaitlistStatsCopyWith(
          WaitlistStats value, $Res Function(WaitlistStats) then) =
      _$WaitlistStatsCopyWithImpl<$Res, WaitlistStats>;
  @useResult
  $Res call(
      {String eventId,
      int totalWaiting,
      int averageWaitTime,
      int conversionRate,
      DateTime lastUpdated});
}

/// @nodoc
class _$WaitlistStatsCopyWithImpl<$Res, $Val extends WaitlistStats>
    implements $WaitlistStatsCopyWith<$Res> {
  _$WaitlistStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WaitlistStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? totalWaiting = null,
    Object? averageWaitTime = null,
    Object? conversionRate = null,
    Object? lastUpdated = null,
  }) {
    return _then(_value.copyWith(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      totalWaiting: null == totalWaiting
          ? _value.totalWaiting
          : totalWaiting // ignore: cast_nullable_to_non_nullable
              as int,
      averageWaitTime: null == averageWaitTime
          ? _value.averageWaitTime
          : averageWaitTime // ignore: cast_nullable_to_non_nullable
              as int,
      conversionRate: null == conversionRate
          ? _value.conversionRate
          : conversionRate // ignore: cast_nullable_to_non_nullable
              as int,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WaitlistStatsImplCopyWith<$Res>
    implements $WaitlistStatsCopyWith<$Res> {
  factory _$$WaitlistStatsImplCopyWith(
          _$WaitlistStatsImpl value, $Res Function(_$WaitlistStatsImpl) then) =
      __$$WaitlistStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String eventId,
      int totalWaiting,
      int averageWaitTime,
      int conversionRate,
      DateTime lastUpdated});
}

/// @nodoc
class __$$WaitlistStatsImplCopyWithImpl<$Res>
    extends _$WaitlistStatsCopyWithImpl<$Res, _$WaitlistStatsImpl>
    implements _$$WaitlistStatsImplCopyWith<$Res> {
  __$$WaitlistStatsImplCopyWithImpl(
      _$WaitlistStatsImpl _value, $Res Function(_$WaitlistStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of WaitlistStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? totalWaiting = null,
    Object? averageWaitTime = null,
    Object? conversionRate = null,
    Object? lastUpdated = null,
  }) {
    return _then(_$WaitlistStatsImpl(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      totalWaiting: null == totalWaiting
          ? _value.totalWaiting
          : totalWaiting // ignore: cast_nullable_to_non_nullable
              as int,
      averageWaitTime: null == averageWaitTime
          ? _value.averageWaitTime
          : averageWaitTime // ignore: cast_nullable_to_non_nullable
              as int,
      conversionRate: null == conversionRate
          ? _value.conversionRate
          : conversionRate // ignore: cast_nullable_to_non_nullable
              as int,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WaitlistStatsImpl implements _WaitlistStats {
  const _$WaitlistStatsImpl(
      {required this.eventId,
      required this.totalWaiting,
      required this.averageWaitTime,
      required this.conversionRate,
      required this.lastUpdated});

  factory _$WaitlistStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$WaitlistStatsImplFromJson(json);

  @override
  final String eventId;
  @override
  final int totalWaiting;
  @override
  final int averageWaitTime;
  @override
  final int conversionRate;
  @override
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'WaitlistStats(eventId: $eventId, totalWaiting: $totalWaiting, averageWaitTime: $averageWaitTime, conversionRate: $conversionRate, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WaitlistStatsImpl &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.totalWaiting, totalWaiting) ||
                other.totalWaiting == totalWaiting) &&
            (identical(other.averageWaitTime, averageWaitTime) ||
                other.averageWaitTime == averageWaitTime) &&
            (identical(other.conversionRate, conversionRate) ||
                other.conversionRate == conversionRate) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, eventId, totalWaiting,
      averageWaitTime, conversionRate, lastUpdated);

  /// Create a copy of WaitlistStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WaitlistStatsImplCopyWith<_$WaitlistStatsImpl> get copyWith =>
      __$$WaitlistStatsImplCopyWithImpl<_$WaitlistStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WaitlistStatsImplToJson(
      this,
    );
  }
}

abstract class _WaitlistStats implements WaitlistStats {
  const factory _WaitlistStats(
      {required final String eventId,
      required final int totalWaiting,
      required final int averageWaitTime,
      required final int conversionRate,
      required final DateTime lastUpdated}) = _$WaitlistStatsImpl;

  factory _WaitlistStats.fromJson(Map<String, dynamic> json) =
      _$WaitlistStatsImpl.fromJson;

  @override
  String get eventId;
  @override
  int get totalWaiting;
  @override
  int get averageWaitTime;
  @override
  int get conversionRate;
  @override
  DateTime get lastUpdated;

  /// Create a copy of WaitlistStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WaitlistStatsImplCopyWith<_$WaitlistStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
