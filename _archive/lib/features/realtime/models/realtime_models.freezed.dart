// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'realtime_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LiveVenueAvailability _$LiveVenueAvailabilityFromJson(
    Map<String, dynamic> json) {
  return _LiveVenueAvailability.fromJson(json);
}

/// @nodoc
mixin _$LiveVenueAvailability {
  String get venueId => throw _privateConstructorUsedError;
  String get venueName => throw _privateConstructorUsedError;
  VenueAvailabilityStatus get status => throw _privateConstructorUsedError;
  int get currentCapacity => throw _privateConstructorUsedError;
  int get maxCapacity => throw _privateConstructorUsedError;
  int get availableTables => throw _privateConstructorUsedError;
  int get totalTables => throw _privateConstructorUsedError;
  int get estimatedWaitTime => throw _privateConstructorUsedError;
  int get queueLength => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this LiveVenueAvailability to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LiveVenueAvailability
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LiveVenueAvailabilityCopyWith<LiveVenueAvailability> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LiveVenueAvailabilityCopyWith<$Res> {
  factory $LiveVenueAvailabilityCopyWith(LiveVenueAvailability value,
          $Res Function(LiveVenueAvailability) then) =
      _$LiveVenueAvailabilityCopyWithImpl<$Res, LiveVenueAvailability>;
  @useResult
  $Res call(
      {String venueId,
      String venueName,
      VenueAvailabilityStatus status,
      int currentCapacity,
      int maxCapacity,
      int availableTables,
      int totalTables,
      int estimatedWaitTime,
      int queueLength,
      DateTime lastUpdated,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$LiveVenueAvailabilityCopyWithImpl<$Res,
        $Val extends LiveVenueAvailability>
    implements $LiveVenueAvailabilityCopyWith<$Res> {
  _$LiveVenueAvailabilityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LiveVenueAvailability
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? venueId = null,
    Object? venueName = null,
    Object? status = null,
    Object? currentCapacity = null,
    Object? maxCapacity = null,
    Object? availableTables = null,
    Object? totalTables = null,
    Object? estimatedWaitTime = null,
    Object? queueLength = null,
    Object? lastUpdated = null,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      venueId: null == venueId
          ? _value.venueId
          : venueId // ignore: cast_nullable_to_non_nullable
              as String,
      venueName: null == venueName
          ? _value.venueName
          : venueName // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as VenueAvailabilityStatus,
      currentCapacity: null == currentCapacity
          ? _value.currentCapacity
          : currentCapacity // ignore: cast_nullable_to_non_nullable
              as int,
      maxCapacity: null == maxCapacity
          ? _value.maxCapacity
          : maxCapacity // ignore: cast_nullable_to_non_nullable
              as int,
      availableTables: null == availableTables
          ? _value.availableTables
          : availableTables // ignore: cast_nullable_to_non_nullable
              as int,
      totalTables: null == totalTables
          ? _value.totalTables
          : totalTables // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedWaitTime: null == estimatedWaitTime
          ? _value.estimatedWaitTime
          : estimatedWaitTime // ignore: cast_nullable_to_non_nullable
              as int,
      queueLength: null == queueLength
          ? _value.queueLength
          : queueLength // ignore: cast_nullable_to_non_nullable
              as int,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LiveVenueAvailabilityImplCopyWith<$Res>
    implements $LiveVenueAvailabilityCopyWith<$Res> {
  factory _$$LiveVenueAvailabilityImplCopyWith(
          _$LiveVenueAvailabilityImpl value,
          $Res Function(_$LiveVenueAvailabilityImpl) then) =
      __$$LiveVenueAvailabilityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String venueId,
      String venueName,
      VenueAvailabilityStatus status,
      int currentCapacity,
      int maxCapacity,
      int availableTables,
      int totalTables,
      int estimatedWaitTime,
      int queueLength,
      DateTime lastUpdated,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$LiveVenueAvailabilityImplCopyWithImpl<$Res>
    extends _$LiveVenueAvailabilityCopyWithImpl<$Res,
        _$LiveVenueAvailabilityImpl>
    implements _$$LiveVenueAvailabilityImplCopyWith<$Res> {
  __$$LiveVenueAvailabilityImplCopyWithImpl(_$LiveVenueAvailabilityImpl _value,
      $Res Function(_$LiveVenueAvailabilityImpl) _then)
      : super(_value, _then);

  /// Create a copy of LiveVenueAvailability
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? venueId = null,
    Object? venueName = null,
    Object? status = null,
    Object? currentCapacity = null,
    Object? maxCapacity = null,
    Object? availableTables = null,
    Object? totalTables = null,
    Object? estimatedWaitTime = null,
    Object? queueLength = null,
    Object? lastUpdated = null,
    Object? metadata = freezed,
  }) {
    return _then(_$LiveVenueAvailabilityImpl(
      venueId: null == venueId
          ? _value.venueId
          : venueId // ignore: cast_nullable_to_non_nullable
              as String,
      venueName: null == venueName
          ? _value.venueName
          : venueName // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as VenueAvailabilityStatus,
      currentCapacity: null == currentCapacity
          ? _value.currentCapacity
          : currentCapacity // ignore: cast_nullable_to_non_nullable
              as int,
      maxCapacity: null == maxCapacity
          ? _value.maxCapacity
          : maxCapacity // ignore: cast_nullable_to_non_nullable
              as int,
      availableTables: null == availableTables
          ? _value.availableTables
          : availableTables // ignore: cast_nullable_to_non_nullable
              as int,
      totalTables: null == totalTables
          ? _value.totalTables
          : totalTables // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedWaitTime: null == estimatedWaitTime
          ? _value.estimatedWaitTime
          : estimatedWaitTime // ignore: cast_nullable_to_non_nullable
              as int,
      queueLength: null == queueLength
          ? _value.queueLength
          : queueLength // ignore: cast_nullable_to_non_nullable
              as int,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LiveVenueAvailabilityImpl implements _LiveVenueAvailability {
  const _$LiveVenueAvailabilityImpl(
      {required this.venueId,
      required this.venueName,
      required this.status,
      required this.currentCapacity,
      required this.maxCapacity,
      required this.availableTables,
      required this.totalTables,
      this.estimatedWaitTime = 0,
      this.queueLength = 0,
      required this.lastUpdated,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$LiveVenueAvailabilityImpl.fromJson(Map<String, dynamic> json) =>
      _$$LiveVenueAvailabilityImplFromJson(json);

  @override
  final String venueId;
  @override
  final String venueName;
  @override
  final VenueAvailabilityStatus status;
  @override
  final int currentCapacity;
  @override
  final int maxCapacity;
  @override
  final int availableTables;
  @override
  final int totalTables;
  @override
  @JsonKey()
  final int estimatedWaitTime;
  @override
  @JsonKey()
  final int queueLength;
  @override
  final DateTime lastUpdated;
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
    return 'LiveVenueAvailability(venueId: $venueId, venueName: $venueName, status: $status, currentCapacity: $currentCapacity, maxCapacity: $maxCapacity, availableTables: $availableTables, totalTables: $totalTables, estimatedWaitTime: $estimatedWaitTime, queueLength: $queueLength, lastUpdated: $lastUpdated, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LiveVenueAvailabilityImpl &&
            (identical(other.venueId, venueId) || other.venueId == venueId) &&
            (identical(other.venueName, venueName) ||
                other.venueName == venueName) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.currentCapacity, currentCapacity) ||
                other.currentCapacity == currentCapacity) &&
            (identical(other.maxCapacity, maxCapacity) ||
                other.maxCapacity == maxCapacity) &&
            (identical(other.availableTables, availableTables) ||
                other.availableTables == availableTables) &&
            (identical(other.totalTables, totalTables) ||
                other.totalTables == totalTables) &&
            (identical(other.estimatedWaitTime, estimatedWaitTime) ||
                other.estimatedWaitTime == estimatedWaitTime) &&
            (identical(other.queueLength, queueLength) ||
                other.queueLength == queueLength) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      venueId,
      venueName,
      status,
      currentCapacity,
      maxCapacity,
      availableTables,
      totalTables,
      estimatedWaitTime,
      queueLength,
      lastUpdated,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of LiveVenueAvailability
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LiveVenueAvailabilityImplCopyWith<_$LiveVenueAvailabilityImpl>
      get copyWith => __$$LiveVenueAvailabilityImplCopyWithImpl<
          _$LiveVenueAvailabilityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LiveVenueAvailabilityImplToJson(
      this,
    );
  }
}

abstract class _LiveVenueAvailability implements LiveVenueAvailability {
  const factory _LiveVenueAvailability(
      {required final String venueId,
      required final String venueName,
      required final VenueAvailabilityStatus status,
      required final int currentCapacity,
      required final int maxCapacity,
      required final int availableTables,
      required final int totalTables,
      final int estimatedWaitTime,
      final int queueLength,
      required final DateTime lastUpdated,
      final Map<String, dynamic>? metadata}) = _$LiveVenueAvailabilityImpl;

  factory _LiveVenueAvailability.fromJson(Map<String, dynamic> json) =
      _$LiveVenueAvailabilityImpl.fromJson;

  @override
  String get venueId;
  @override
  String get venueName;
  @override
  VenueAvailabilityStatus get status;
  @override
  int get currentCapacity;
  @override
  int get maxCapacity;
  @override
  int get availableTables;
  @override
  int get totalTables;
  @override
  int get estimatedWaitTime;
  @override
  int get queueLength;
  @override
  DateTime get lastUpdated;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of LiveVenueAvailability
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LiveVenueAvailabilityImplCopyWith<_$LiveVenueAvailabilityImpl>
      get copyWith => throw _privateConstructorUsedError;
}

BookingStatusUpdate _$BookingStatusUpdateFromJson(Map<String, dynamic> json) {
  return _BookingStatusUpdate.fromJson(json);
}

/// @nodoc
mixin _$BookingStatusUpdate {
  String get bookingId => throw _privateConstructorUsedError;
  BookingUpdateType get updateType => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  Map<String, dynamic>? get changes => throw _privateConstructorUsedError;
  String? get notificationId => throw _privateConstructorUsedError;

  /// Serializes this BookingStatusUpdate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingStatusUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingStatusUpdateCopyWith<BookingStatusUpdate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingStatusUpdateCopyWith<$Res> {
  factory $BookingStatusUpdateCopyWith(
          BookingStatusUpdate value, $Res Function(BookingStatusUpdate) then) =
      _$BookingStatusUpdateCopyWithImpl<$Res, BookingStatusUpdate>;
  @useResult
  $Res call(
      {String bookingId,
      BookingUpdateType updateType,
      String message,
      DateTime timestamp,
      Map<String, dynamic>? changes,
      String? notificationId});
}

/// @nodoc
class _$BookingStatusUpdateCopyWithImpl<$Res, $Val extends BookingStatusUpdate>
    implements $BookingStatusUpdateCopyWith<$Res> {
  _$BookingStatusUpdateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingStatusUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookingId = null,
    Object? updateType = null,
    Object? message = null,
    Object? timestamp = null,
    Object? changes = freezed,
    Object? notificationId = freezed,
  }) {
    return _then(_value.copyWith(
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      updateType: null == updateType
          ? _value.updateType
          : updateType // ignore: cast_nullable_to_non_nullable
              as BookingUpdateType,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      changes: freezed == changes
          ? _value.changes
          : changes // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      notificationId: freezed == notificationId
          ? _value.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookingStatusUpdateImplCopyWith<$Res>
    implements $BookingStatusUpdateCopyWith<$Res> {
  factory _$$BookingStatusUpdateImplCopyWith(_$BookingStatusUpdateImpl value,
          $Res Function(_$BookingStatusUpdateImpl) then) =
      __$$BookingStatusUpdateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String bookingId,
      BookingUpdateType updateType,
      String message,
      DateTime timestamp,
      Map<String, dynamic>? changes,
      String? notificationId});
}

/// @nodoc
class __$$BookingStatusUpdateImplCopyWithImpl<$Res>
    extends _$BookingStatusUpdateCopyWithImpl<$Res, _$BookingStatusUpdateImpl>
    implements _$$BookingStatusUpdateImplCopyWith<$Res> {
  __$$BookingStatusUpdateImplCopyWithImpl(_$BookingStatusUpdateImpl _value,
      $Res Function(_$BookingStatusUpdateImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookingStatusUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookingId = null,
    Object? updateType = null,
    Object? message = null,
    Object? timestamp = null,
    Object? changes = freezed,
    Object? notificationId = freezed,
  }) {
    return _then(_$BookingStatusUpdateImpl(
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      updateType: null == updateType
          ? _value.updateType
          : updateType // ignore: cast_nullable_to_non_nullable
              as BookingUpdateType,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      changes: freezed == changes
          ? _value._changes
          : changes // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      notificationId: freezed == notificationId
          ? _value.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingStatusUpdateImpl implements _BookingStatusUpdate {
  const _$BookingStatusUpdateImpl(
      {required this.bookingId,
      required this.updateType,
      required this.message,
      required this.timestamp,
      final Map<String, dynamic>? changes,
      this.notificationId})
      : _changes = changes;

  factory _$BookingStatusUpdateImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingStatusUpdateImplFromJson(json);

  @override
  final String bookingId;
  @override
  final BookingUpdateType updateType;
  @override
  final String message;
  @override
  final DateTime timestamp;
  final Map<String, dynamic>? _changes;
  @override
  Map<String, dynamic>? get changes {
    final value = _changes;
    if (value == null) return null;
    if (_changes is EqualUnmodifiableMapView) return _changes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? notificationId;

  @override
  String toString() {
    return 'BookingStatusUpdate(bookingId: $bookingId, updateType: $updateType, message: $message, timestamp: $timestamp, changes: $changes, notificationId: $notificationId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingStatusUpdateImpl &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.updateType, updateType) ||
                other.updateType == updateType) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other._changes, _changes) &&
            (identical(other.notificationId, notificationId) ||
                other.notificationId == notificationId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, bookingId, updateType, message,
      timestamp, const DeepCollectionEquality().hash(_changes), notificationId);

  /// Create a copy of BookingStatusUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingStatusUpdateImplCopyWith<_$BookingStatusUpdateImpl> get copyWith =>
      __$$BookingStatusUpdateImplCopyWithImpl<_$BookingStatusUpdateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingStatusUpdateImplToJson(
      this,
    );
  }
}

abstract class _BookingStatusUpdate implements BookingStatusUpdate {
  const factory _BookingStatusUpdate(
      {required final String bookingId,
      required final BookingUpdateType updateType,
      required final String message,
      required final DateTime timestamp,
      final Map<String, dynamic>? changes,
      final String? notificationId}) = _$BookingStatusUpdateImpl;

  factory _BookingStatusUpdate.fromJson(Map<String, dynamic> json) =
      _$BookingStatusUpdateImpl.fromJson;

  @override
  String get bookingId;
  @override
  BookingUpdateType get updateType;
  @override
  String get message;
  @override
  DateTime get timestamp;
  @override
  Map<String, dynamic>? get changes;
  @override
  String? get notificationId;

  /// Create a copy of BookingStatusUpdate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingStatusUpdateImplCopyWith<_$BookingStatusUpdateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QueueEntry _$QueueEntryFromJson(Map<String, dynamic> json) {
  return _QueueEntry.fromJson(json);
}

/// @nodoc
mixin _$QueueEntry {
  String get id => throw _privateConstructorUsedError;
  String get venueId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String? get userPhone => throw _privateConstructorUsedError;
  int get partySize => throw _privateConstructorUsedError;
  QueueStatus get status => throw _privateConstructorUsedError;
  int get position => throw _privateConstructorUsedError;
  DateTime get joinedAt => throw _privateConstructorUsedError;
  DateTime? get calledAt => throw _privateConstructorUsedError;
  DateTime? get seatedAt => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  int get estimatedWaitMinutes => throw _privateConstructorUsedError;
  Map<String, dynamic>? get preferences => throw _privateConstructorUsedError;

  /// Serializes this QueueEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QueueEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QueueEntryCopyWith<QueueEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QueueEntryCopyWith<$Res> {
  factory $QueueEntryCopyWith(
          QueueEntry value, $Res Function(QueueEntry) then) =
      _$QueueEntryCopyWithImpl<$Res, QueueEntry>;
  @useResult
  $Res call(
      {String id,
      String venueId,
      String userId,
      String userName,
      String? userPhone,
      int partySize,
      QueueStatus status,
      int position,
      DateTime joinedAt,
      DateTime? calledAt,
      DateTime? seatedAt,
      DateTime? expiresAt,
      int estimatedWaitMinutes,
      Map<String, dynamic>? preferences});
}

/// @nodoc
class _$QueueEntryCopyWithImpl<$Res, $Val extends QueueEntry>
    implements $QueueEntryCopyWith<$Res> {
  _$QueueEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QueueEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? venueId = null,
    Object? userId = null,
    Object? userName = null,
    Object? userPhone = freezed,
    Object? partySize = null,
    Object? status = null,
    Object? position = null,
    Object? joinedAt = null,
    Object? calledAt = freezed,
    Object? seatedAt = freezed,
    Object? expiresAt = freezed,
    Object? estimatedWaitMinutes = null,
    Object? preferences = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      venueId: null == venueId
          ? _value.venueId
          : venueId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userPhone: freezed == userPhone
          ? _value.userPhone
          : userPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      partySize: null == partySize
          ? _value.partySize
          : partySize // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as QueueStatus,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as int,
      joinedAt: null == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      calledAt: freezed == calledAt
          ? _value.calledAt
          : calledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      seatedAt: freezed == seatedAt
          ? _value.seatedAt
          : seatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      estimatedWaitMinutes: null == estimatedWaitMinutes
          ? _value.estimatedWaitMinutes
          : estimatedWaitMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      preferences: freezed == preferences
          ? _value.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QueueEntryImplCopyWith<$Res>
    implements $QueueEntryCopyWith<$Res> {
  factory _$$QueueEntryImplCopyWith(
          _$QueueEntryImpl value, $Res Function(_$QueueEntryImpl) then) =
      __$$QueueEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String venueId,
      String userId,
      String userName,
      String? userPhone,
      int partySize,
      QueueStatus status,
      int position,
      DateTime joinedAt,
      DateTime? calledAt,
      DateTime? seatedAt,
      DateTime? expiresAt,
      int estimatedWaitMinutes,
      Map<String, dynamic>? preferences});
}

/// @nodoc
class __$$QueueEntryImplCopyWithImpl<$Res>
    extends _$QueueEntryCopyWithImpl<$Res, _$QueueEntryImpl>
    implements _$$QueueEntryImplCopyWith<$Res> {
  __$$QueueEntryImplCopyWithImpl(
      _$QueueEntryImpl _value, $Res Function(_$QueueEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of QueueEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? venueId = null,
    Object? userId = null,
    Object? userName = null,
    Object? userPhone = freezed,
    Object? partySize = null,
    Object? status = null,
    Object? position = null,
    Object? joinedAt = null,
    Object? calledAt = freezed,
    Object? seatedAt = freezed,
    Object? expiresAt = freezed,
    Object? estimatedWaitMinutes = null,
    Object? preferences = freezed,
  }) {
    return _then(_$QueueEntryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      venueId: null == venueId
          ? _value.venueId
          : venueId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userPhone: freezed == userPhone
          ? _value.userPhone
          : userPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      partySize: null == partySize
          ? _value.partySize
          : partySize // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as QueueStatus,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as int,
      joinedAt: null == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      calledAt: freezed == calledAt
          ? _value.calledAt
          : calledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      seatedAt: freezed == seatedAt
          ? _value.seatedAt
          : seatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      estimatedWaitMinutes: null == estimatedWaitMinutes
          ? _value.estimatedWaitMinutes
          : estimatedWaitMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      preferences: freezed == preferences
          ? _value._preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QueueEntryImpl implements _QueueEntry {
  const _$QueueEntryImpl(
      {required this.id,
      required this.venueId,
      required this.userId,
      required this.userName,
      this.userPhone,
      required this.partySize,
      required this.status,
      required this.position,
      required this.joinedAt,
      this.calledAt,
      this.seatedAt,
      this.expiresAt,
      this.estimatedWaitMinutes = 0,
      final Map<String, dynamic>? preferences})
      : _preferences = preferences;

  factory _$QueueEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$QueueEntryImplFromJson(json);

  @override
  final String id;
  @override
  final String venueId;
  @override
  final String userId;
  @override
  final String userName;
  @override
  final String? userPhone;
  @override
  final int partySize;
  @override
  final QueueStatus status;
  @override
  final int position;
  @override
  final DateTime joinedAt;
  @override
  final DateTime? calledAt;
  @override
  final DateTime? seatedAt;
  @override
  final DateTime? expiresAt;
  @override
  @JsonKey()
  final int estimatedWaitMinutes;
  final Map<String, dynamic>? _preferences;
  @override
  Map<String, dynamic>? get preferences {
    final value = _preferences;
    if (value == null) return null;
    if (_preferences is EqualUnmodifiableMapView) return _preferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'QueueEntry(id: $id, venueId: $venueId, userId: $userId, userName: $userName, userPhone: $userPhone, partySize: $partySize, status: $status, position: $position, joinedAt: $joinedAt, calledAt: $calledAt, seatedAt: $seatedAt, expiresAt: $expiresAt, estimatedWaitMinutes: $estimatedWaitMinutes, preferences: $preferences)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QueueEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.venueId, venueId) || other.venueId == venueId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userPhone, userPhone) ||
                other.userPhone == userPhone) &&
            (identical(other.partySize, partySize) ||
                other.partySize == partySize) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt) &&
            (identical(other.calledAt, calledAt) ||
                other.calledAt == calledAt) &&
            (identical(other.seatedAt, seatedAt) ||
                other.seatedAt == seatedAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.estimatedWaitMinutes, estimatedWaitMinutes) ||
                other.estimatedWaitMinutes == estimatedWaitMinutes) &&
            const DeepCollectionEquality()
                .equals(other._preferences, _preferences));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      venueId,
      userId,
      userName,
      userPhone,
      partySize,
      status,
      position,
      joinedAt,
      calledAt,
      seatedAt,
      expiresAt,
      estimatedWaitMinutes,
      const DeepCollectionEquality().hash(_preferences));

  /// Create a copy of QueueEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QueueEntryImplCopyWith<_$QueueEntryImpl> get copyWith =>
      __$$QueueEntryImplCopyWithImpl<_$QueueEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QueueEntryImplToJson(
      this,
    );
  }
}

abstract class _QueueEntry implements QueueEntry {
  const factory _QueueEntry(
      {required final String id,
      required final String venueId,
      required final String userId,
      required final String userName,
      final String? userPhone,
      required final int partySize,
      required final QueueStatus status,
      required final int position,
      required final DateTime joinedAt,
      final DateTime? calledAt,
      final DateTime? seatedAt,
      final DateTime? expiresAt,
      final int estimatedWaitMinutes,
      final Map<String, dynamic>? preferences}) = _$QueueEntryImpl;

  factory _QueueEntry.fromJson(Map<String, dynamic> json) =
      _$QueueEntryImpl.fromJson;

  @override
  String get id;
  @override
  String get venueId;
  @override
  String get userId;
  @override
  String get userName;
  @override
  String? get userPhone;
  @override
  int get partySize;
  @override
  QueueStatus get status;
  @override
  int get position;
  @override
  DateTime get joinedAt;
  @override
  DateTime? get calledAt;
  @override
  DateTime? get seatedAt;
  @override
  DateTime? get expiresAt;
  @override
  int get estimatedWaitMinutes;
  @override
  Map<String, dynamic>? get preferences;

  /// Create a copy of QueueEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QueueEntryImplCopyWith<_$QueueEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) {
  return _ChatMessage.fromJson(json);
}

/// @nodoc
mixin _$ChatMessage {
  String get id => throw _privateConstructorUsedError;
  String get conversationId => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String get senderName => throw _privateConstructorUsedError;
  String? get senderAvatar => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get messageType => throw _privateConstructorUsedError;
  List<String> get attachments => throw _privateConstructorUsedError;
  DateTime get sentAt => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;
  DateTime? get readAt => throw _privateConstructorUsedError;
  bool get isEdited => throw _privateConstructorUsedError;
  DateTime? get editedAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this ChatMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatMessageCopyWith<ChatMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageCopyWith<$Res> {
  factory $ChatMessageCopyWith(
          ChatMessage value, $Res Function(ChatMessage) then) =
      _$ChatMessageCopyWithImpl<$Res, ChatMessage>;
  @useResult
  $Res call(
      {String id,
      String conversationId,
      String senderId,
      String senderName,
      String? senderAvatar,
      String content,
      String messageType,
      List<String> attachments,
      DateTime sentAt,
      bool isRead,
      DateTime? readAt,
      bool isEdited,
      DateTime? editedAt,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$ChatMessageCopyWithImpl<$Res, $Val extends ChatMessage>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? senderId = null,
    Object? senderName = null,
    Object? senderAvatar = freezed,
    Object? content = null,
    Object? messageType = null,
    Object? attachments = null,
    Object? sentAt = null,
    Object? isRead = null,
    Object? readAt = freezed,
    Object? isEdited = null,
    Object? editedAt = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
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
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as String,
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>,
      sentAt: null == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isEdited: null == isEdited
          ? _value.isEdited
          : isEdited // ignore: cast_nullable_to_non_nullable
              as bool,
      editedAt: freezed == editedAt
          ? _value.editedAt
          : editedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatMessageImplCopyWith<$Res>
    implements $ChatMessageCopyWith<$Res> {
  factory _$$ChatMessageImplCopyWith(
          _$ChatMessageImpl value, $Res Function(_$ChatMessageImpl) then) =
      __$$ChatMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String conversationId,
      String senderId,
      String senderName,
      String? senderAvatar,
      String content,
      String messageType,
      List<String> attachments,
      DateTime sentAt,
      bool isRead,
      DateTime? readAt,
      bool isEdited,
      DateTime? editedAt,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$ChatMessageImplCopyWithImpl<$Res>
    extends _$ChatMessageCopyWithImpl<$Res, _$ChatMessageImpl>
    implements _$$ChatMessageImplCopyWith<$Res> {
  __$$ChatMessageImplCopyWithImpl(
      _$ChatMessageImpl _value, $Res Function(_$ChatMessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? senderId = null,
    Object? senderName = null,
    Object? senderAvatar = freezed,
    Object? content = null,
    Object? messageType = null,
    Object? attachments = null,
    Object? sentAt = null,
    Object? isRead = null,
    Object? readAt = freezed,
    Object? isEdited = null,
    Object? editedAt = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$ChatMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
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
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as String,
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>,
      sentAt: null == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isEdited: null == isEdited
          ? _value.isEdited
          : isEdited // ignore: cast_nullable_to_non_nullable
              as bool,
      editedAt: freezed == editedAt
          ? _value.editedAt
          : editedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageImpl implements _ChatMessage {
  const _$ChatMessageImpl(
      {required this.id,
      required this.conversationId,
      required this.senderId,
      required this.senderName,
      this.senderAvatar,
      required this.content,
      this.messageType = 'text',
      final List<String> attachments = const [],
      required this.sentAt,
      this.isRead = false,
      this.readAt,
      this.isEdited = false,
      this.editedAt,
      final Map<String, dynamic>? metadata})
      : _attachments = attachments,
        _metadata = metadata;

  factory _$ChatMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageImplFromJson(json);

  @override
  final String id;
  @override
  final String conversationId;
  @override
  final String senderId;
  @override
  final String senderName;
  @override
  final String? senderAvatar;
  @override
  final String content;
  @override
  @JsonKey()
  final String messageType;
  final List<String> _attachments;
  @override
  @JsonKey()
  List<String> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  @override
  final DateTime sentAt;
  @override
  @JsonKey()
  final bool isRead;
  @override
  final DateTime? readAt;
  @override
  @JsonKey()
  final bool isEdited;
  @override
  final DateTime? editedAt;
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
    return 'ChatMessage(id: $id, conversationId: $conversationId, senderId: $senderId, senderName: $senderName, senderAvatar: $senderAvatar, content: $content, messageType: $messageType, attachments: $attachments, sentAt: $sentAt, isRead: $isRead, readAt: $readAt, isEdited: $isEdited, editedAt: $editedAt, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.senderAvatar, senderAvatar) ||
                other.senderAvatar == senderAvatar) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.messageType, messageType) ||
                other.messageType == messageType) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            (identical(other.sentAt, sentAt) || other.sentAt == sentAt) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.isEdited, isEdited) ||
                other.isEdited == isEdited) &&
            (identical(other.editedAt, editedAt) ||
                other.editedAt == editedAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      conversationId,
      senderId,
      senderName,
      senderAvatar,
      content,
      messageType,
      const DeepCollectionEquality().hash(_attachments),
      sentAt,
      isRead,
      readAt,
      isEdited,
      editedAt,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      __$$ChatMessageImplCopyWithImpl<_$ChatMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageImplToJson(
      this,
    );
  }
}

abstract class _ChatMessage implements ChatMessage {
  const factory _ChatMessage(
      {required final String id,
      required final String conversationId,
      required final String senderId,
      required final String senderName,
      final String? senderAvatar,
      required final String content,
      final String messageType,
      final List<String> attachments,
      required final DateTime sentAt,
      final bool isRead,
      final DateTime? readAt,
      final bool isEdited,
      final DateTime? editedAt,
      final Map<String, dynamic>? metadata}) = _$ChatMessageImpl;

  factory _ChatMessage.fromJson(Map<String, dynamic> json) =
      _$ChatMessageImpl.fromJson;

  @override
  String get id;
  @override
  String get conversationId;
  @override
  String get senderId;
  @override
  String get senderName;
  @override
  String? get senderAvatar;
  @override
  String get content;
  @override
  String get messageType;
  @override
  List<String> get attachments;
  @override
  DateTime get sentAt;
  @override
  bool get isRead;
  @override
  DateTime? get readAt;
  @override
  bool get isEdited;
  @override
  DateTime? get editedAt;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserPresence _$UserPresenceFromJson(Map<String, dynamic> json) {
  return _UserPresence.fromJson(json);
}

/// @nodoc
mixin _$UserPresence {
  String get userId => throw _privateConstructorUsedError;
  bool get isOnline => throw _privateConstructorUsedError;
  DateTime? get lastSeen => throw _privateConstructorUsedError;
  String? get currentActivity => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this UserPresence to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserPresence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserPresenceCopyWith<UserPresence> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPresenceCopyWith<$Res> {
  factory $UserPresenceCopyWith(
          UserPresence value, $Res Function(UserPresence) then) =
      _$UserPresenceCopyWithImpl<$Res, UserPresence>;
  @useResult
  $Res call(
      {String userId,
      bool isOnline,
      DateTime? lastSeen,
      String? currentActivity,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$UserPresenceCopyWithImpl<$Res, $Val extends UserPresence>
    implements $UserPresenceCopyWith<$Res> {
  _$UserPresenceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserPresence
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? isOnline = null,
    Object? lastSeen = freezed,
    Object? currentActivity = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSeen: freezed == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      currentActivity: freezed == currentActivity
          ? _value.currentActivity
          : currentActivity // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserPresenceImplCopyWith<$Res>
    implements $UserPresenceCopyWith<$Res> {
  factory _$$UserPresenceImplCopyWith(
          _$UserPresenceImpl value, $Res Function(_$UserPresenceImpl) then) =
      __$$UserPresenceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      bool isOnline,
      DateTime? lastSeen,
      String? currentActivity,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$UserPresenceImplCopyWithImpl<$Res>
    extends _$UserPresenceCopyWithImpl<$Res, _$UserPresenceImpl>
    implements _$$UserPresenceImplCopyWith<$Res> {
  __$$UserPresenceImplCopyWithImpl(
      _$UserPresenceImpl _value, $Res Function(_$UserPresenceImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserPresence
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? isOnline = null,
    Object? lastSeen = freezed,
    Object? currentActivity = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$UserPresenceImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSeen: freezed == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      currentActivity: freezed == currentActivity
          ? _value.currentActivity
          : currentActivity // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserPresenceImpl implements _UserPresence {
  const _$UserPresenceImpl(
      {required this.userId,
      required this.isOnline,
      this.lastSeen,
      this.currentActivity,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$UserPresenceImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserPresenceImplFromJson(json);

  @override
  final String userId;
  @override
  final bool isOnline;
  @override
  final DateTime? lastSeen;
  @override
  final String? currentActivity;
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
    return 'UserPresence(userId: $userId, isOnline: $isOnline, lastSeen: $lastSeen, currentActivity: $currentActivity, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPresenceImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(other.lastSeen, lastSeen) ||
                other.lastSeen == lastSeen) &&
            (identical(other.currentActivity, currentActivity) ||
                other.currentActivity == currentActivity) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, isOnline, lastSeen,
      currentActivity, const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of UserPresence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPresenceImplCopyWith<_$UserPresenceImpl> get copyWith =>
      __$$UserPresenceImplCopyWithImpl<_$UserPresenceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserPresenceImplToJson(
      this,
    );
  }
}

abstract class _UserPresence implements UserPresence {
  const factory _UserPresence(
      {required final String userId,
      required final bool isOnline,
      final DateTime? lastSeen,
      final String? currentActivity,
      final Map<String, dynamic>? metadata}) = _$UserPresenceImpl;

  factory _UserPresence.fromJson(Map<String, dynamic> json) =
      _$UserPresenceImpl.fromJson;

  @override
  String get userId;
  @override
  bool get isOnline;
  @override
  DateTime? get lastSeen;
  @override
  String? get currentActivity;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of UserPresence
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserPresenceImplCopyWith<_$UserPresenceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TypingIndicator _$TypingIndicatorFromJson(Map<String, dynamic> json) {
  return _TypingIndicator.fromJson(json);
}

/// @nodoc
mixin _$TypingIndicator {
  String get conversationId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;

  /// Serializes this TypingIndicator to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TypingIndicator
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TypingIndicatorCopyWith<TypingIndicator> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TypingIndicatorCopyWith<$Res> {
  factory $TypingIndicatorCopyWith(
          TypingIndicator value, $Res Function(TypingIndicator) then) =
      _$TypingIndicatorCopyWithImpl<$Res, TypingIndicator>;
  @useResult
  $Res call(
      {String conversationId,
      String userId,
      String userName,
      DateTime startedAt});
}

/// @nodoc
class _$TypingIndicatorCopyWithImpl<$Res, $Val extends TypingIndicator>
    implements $TypingIndicatorCopyWith<$Res> {
  _$TypingIndicatorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TypingIndicator
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversationId = null,
    Object? userId = null,
    Object? userName = null,
    Object? startedAt = null,
  }) {
    return _then(_value.copyWith(
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TypingIndicatorImplCopyWith<$Res>
    implements $TypingIndicatorCopyWith<$Res> {
  factory _$$TypingIndicatorImplCopyWith(_$TypingIndicatorImpl value,
          $Res Function(_$TypingIndicatorImpl) then) =
      __$$TypingIndicatorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String conversationId,
      String userId,
      String userName,
      DateTime startedAt});
}

/// @nodoc
class __$$TypingIndicatorImplCopyWithImpl<$Res>
    extends _$TypingIndicatorCopyWithImpl<$Res, _$TypingIndicatorImpl>
    implements _$$TypingIndicatorImplCopyWith<$Res> {
  __$$TypingIndicatorImplCopyWithImpl(
      _$TypingIndicatorImpl _value, $Res Function(_$TypingIndicatorImpl) _then)
      : super(_value, _then);

  /// Create a copy of TypingIndicator
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversationId = null,
    Object? userId = null,
    Object? userName = null,
    Object? startedAt = null,
  }) {
    return _then(_$TypingIndicatorImpl(
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TypingIndicatorImpl implements _TypingIndicator {
  const _$TypingIndicatorImpl(
      {required this.conversationId,
      required this.userId,
      required this.userName,
      required this.startedAt});

  factory _$TypingIndicatorImpl.fromJson(Map<String, dynamic> json) =>
      _$$TypingIndicatorImplFromJson(json);

  @override
  final String conversationId;
  @override
  final String userId;
  @override
  final String userName;
  @override
  final DateTime startedAt;

  @override
  String toString() {
    return 'TypingIndicator(conversationId: $conversationId, userId: $userId, userName: $userName, startedAt: $startedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TypingIndicatorImpl &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, conversationId, userId, userName, startedAt);

  /// Create a copy of TypingIndicator
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TypingIndicatorImplCopyWith<_$TypingIndicatorImpl> get copyWith =>
      __$$TypingIndicatorImplCopyWithImpl<_$TypingIndicatorImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TypingIndicatorImplToJson(
      this,
    );
  }
}

abstract class _TypingIndicator implements TypingIndicator {
  const factory _TypingIndicator(
      {required final String conversationId,
      required final String userId,
      required final String userName,
      required final DateTime startedAt}) = _$TypingIndicatorImpl;

  factory _TypingIndicator.fromJson(Map<String, dynamic> json) =
      _$TypingIndicatorImpl.fromJson;

  @override
  String get conversationId;
  @override
  String get userId;
  @override
  String get userName;
  @override
  DateTime get startedAt;

  /// Create a copy of TypingIndicator
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TypingIndicatorImplCopyWith<_$TypingIndicatorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EventUpdate _$EventUpdateFromJson(Map<String, dynamic> json) {
  return _EventUpdate.fromJson(json);
}

/// @nodoc
mixin _$EventUpdate {
  String get eventId => throw _privateConstructorUsedError;
  String get updateType => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  Map<String, dynamic>? get changes => throw _privateConstructorUsedError;
  bool get isUrgent => throw _privateConstructorUsedError;

  /// Serializes this EventUpdate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EventUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventUpdateCopyWith<EventUpdate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventUpdateCopyWith<$Res> {
  factory $EventUpdateCopyWith(
          EventUpdate value, $Res Function(EventUpdate) then) =
      _$EventUpdateCopyWithImpl<$Res, EventUpdate>;
  @useResult
  $Res call(
      {String eventId,
      String updateType,
      String message,
      DateTime timestamp,
      Map<String, dynamic>? changes,
      bool isUrgent});
}

/// @nodoc
class _$EventUpdateCopyWithImpl<$Res, $Val extends EventUpdate>
    implements $EventUpdateCopyWith<$Res> {
  _$EventUpdateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? updateType = null,
    Object? message = null,
    Object? timestamp = null,
    Object? changes = freezed,
    Object? isUrgent = null,
  }) {
    return _then(_value.copyWith(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      updateType: null == updateType
          ? _value.updateType
          : updateType // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      changes: freezed == changes
          ? _value.changes
          : changes // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isUrgent: null == isUrgent
          ? _value.isUrgent
          : isUrgent // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventUpdateImplCopyWith<$Res>
    implements $EventUpdateCopyWith<$Res> {
  factory _$$EventUpdateImplCopyWith(
          _$EventUpdateImpl value, $Res Function(_$EventUpdateImpl) then) =
      __$$EventUpdateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String eventId,
      String updateType,
      String message,
      DateTime timestamp,
      Map<String, dynamic>? changes,
      bool isUrgent});
}

/// @nodoc
class __$$EventUpdateImplCopyWithImpl<$Res>
    extends _$EventUpdateCopyWithImpl<$Res, _$EventUpdateImpl>
    implements _$$EventUpdateImplCopyWith<$Res> {
  __$$EventUpdateImplCopyWithImpl(
      _$EventUpdateImpl _value, $Res Function(_$EventUpdateImpl) _then)
      : super(_value, _then);

  /// Create a copy of EventUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? updateType = null,
    Object? message = null,
    Object? timestamp = null,
    Object? changes = freezed,
    Object? isUrgent = null,
  }) {
    return _then(_$EventUpdateImpl(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      updateType: null == updateType
          ? _value.updateType
          : updateType // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      changes: freezed == changes
          ? _value._changes
          : changes // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isUrgent: null == isUrgent
          ? _value.isUrgent
          : isUrgent // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventUpdateImpl implements _EventUpdate {
  const _$EventUpdateImpl(
      {required this.eventId,
      required this.updateType,
      required this.message,
      required this.timestamp,
      final Map<String, dynamic>? changes,
      this.isUrgent = false})
      : _changes = changes;

  factory _$EventUpdateImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventUpdateImplFromJson(json);

  @override
  final String eventId;
  @override
  final String updateType;
  @override
  final String message;
  @override
  final DateTime timestamp;
  final Map<String, dynamic>? _changes;
  @override
  Map<String, dynamic>? get changes {
    final value = _changes;
    if (value == null) return null;
    if (_changes is EqualUnmodifiableMapView) return _changes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final bool isUrgent;

  @override
  String toString() {
    return 'EventUpdate(eventId: $eventId, updateType: $updateType, message: $message, timestamp: $timestamp, changes: $changes, isUrgent: $isUrgent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventUpdateImpl &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.updateType, updateType) ||
                other.updateType == updateType) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other._changes, _changes) &&
            (identical(other.isUrgent, isUrgent) ||
                other.isUrgent == isUrgent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, eventId, updateType, message,
      timestamp, const DeepCollectionEquality().hash(_changes), isUrgent);

  /// Create a copy of EventUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventUpdateImplCopyWith<_$EventUpdateImpl> get copyWith =>
      __$$EventUpdateImplCopyWithImpl<_$EventUpdateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventUpdateImplToJson(
      this,
    );
  }
}

abstract class _EventUpdate implements EventUpdate {
  const factory _EventUpdate(
      {required final String eventId,
      required final String updateType,
      required final String message,
      required final DateTime timestamp,
      final Map<String, dynamic>? changes,
      final bool isUrgent}) = _$EventUpdateImpl;

  factory _EventUpdate.fromJson(Map<String, dynamic> json) =
      _$EventUpdateImpl.fromJson;

  @override
  String get eventId;
  @override
  String get updateType;
  @override
  String get message;
  @override
  DateTime get timestamp;
  @override
  Map<String, dynamic>? get changes;
  @override
  bool get isUrgent;

  /// Create a copy of EventUpdate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventUpdateImplCopyWith<_$EventUpdateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
