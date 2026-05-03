// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'time_slot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TimeSlot _$TimeSlotFromJson(Map<String, dynamic> json) {
  return _TimeSlot.fromJson(json);
}

/// @nodoc
mixin _$TimeSlot {
  String get id => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;
  double? get minimumSpend => throw _privateConstructorUsedError;
  int? get availableCapacity => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this TimeSlot to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimeSlot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimeSlotCopyWith<TimeSlot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeSlotCopyWith<$Res> {
  factory $TimeSlotCopyWith(TimeSlot value, $Res Function(TimeSlot) then) =
      _$TimeSlotCopyWithImpl<$Res, TimeSlot>;
  @useResult
  $Res call(
      {String id,
      DateTime startTime,
      DateTime endTime,
      bool isAvailable,
      double? price,
      double? minimumSpend,
      int? availableCapacity,
      String? description});
}

/// @nodoc
class _$TimeSlotCopyWithImpl<$Res, $Val extends TimeSlot>
    implements $TimeSlotCopyWith<$Res> {
  _$TimeSlotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimeSlot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? isAvailable = null,
    Object? price = freezed,
    Object? minimumSpend = freezed,
    Object? availableCapacity = freezed,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      minimumSpend: freezed == minimumSpend
          ? _value.minimumSpend
          : minimumSpend // ignore: cast_nullable_to_non_nullable
              as double?,
      availableCapacity: freezed == availableCapacity
          ? _value.availableCapacity
          : availableCapacity // ignore: cast_nullable_to_non_nullable
              as int?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TimeSlotImplCopyWith<$Res>
    implements $TimeSlotCopyWith<$Res> {
  factory _$$TimeSlotImplCopyWith(
          _$TimeSlotImpl value, $Res Function(_$TimeSlotImpl) then) =
      __$$TimeSlotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime startTime,
      DateTime endTime,
      bool isAvailable,
      double? price,
      double? minimumSpend,
      int? availableCapacity,
      String? description});
}

/// @nodoc
class __$$TimeSlotImplCopyWithImpl<$Res>
    extends _$TimeSlotCopyWithImpl<$Res, _$TimeSlotImpl>
    implements _$$TimeSlotImplCopyWith<$Res> {
  __$$TimeSlotImplCopyWithImpl(
      _$TimeSlotImpl _value, $Res Function(_$TimeSlotImpl) _then)
      : super(_value, _then);

  /// Create a copy of TimeSlot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? isAvailable = null,
    Object? price = freezed,
    Object? minimumSpend = freezed,
    Object? availableCapacity = freezed,
    Object? description = freezed,
  }) {
    return _then(_$TimeSlotImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      minimumSpend: freezed == minimumSpend
          ? _value.minimumSpend
          : minimumSpend // ignore: cast_nullable_to_non_nullable
              as double?,
      availableCapacity: freezed == availableCapacity
          ? _value.availableCapacity
          : availableCapacity // ignore: cast_nullable_to_non_nullable
              as int?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TimeSlotImpl implements _TimeSlot {
  const _$TimeSlotImpl(
      {required this.id,
      required this.startTime,
      required this.endTime,
      this.isAvailable = true,
      this.price,
      this.minimumSpend,
      this.availableCapacity,
      this.description});

  factory _$TimeSlotImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimeSlotImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  @JsonKey()
  final bool isAvailable;
  @override
  final double? price;
  @override
  final double? minimumSpend;
  @override
  final int? availableCapacity;
  @override
  final String? description;

  @override
  String toString() {
    return 'TimeSlot(id: $id, startTime: $startTime, endTime: $endTime, isAvailable: $isAvailable, price: $price, minimumSpend: $minimumSpend, availableCapacity: $availableCapacity, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeSlotImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.minimumSpend, minimumSpend) ||
                other.minimumSpend == minimumSpend) &&
            (identical(other.availableCapacity, availableCapacity) ||
                other.availableCapacity == availableCapacity) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, startTime, endTime,
      isAvailable, price, minimumSpend, availableCapacity, description);

  /// Create a copy of TimeSlot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeSlotImplCopyWith<_$TimeSlotImpl> get copyWith =>
      __$$TimeSlotImplCopyWithImpl<_$TimeSlotImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimeSlotImplToJson(
      this,
    );
  }
}

abstract class _TimeSlot implements TimeSlot {
  const factory _TimeSlot(
      {required final String id,
      required final DateTime startTime,
      required final DateTime endTime,
      final bool isAvailable,
      final double? price,
      final double? minimumSpend,
      final int? availableCapacity,
      final String? description}) = _$TimeSlotImpl;

  factory _TimeSlot.fromJson(Map<String, dynamic> json) =
      _$TimeSlotImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  bool get isAvailable;
  @override
  double? get price;
  @override
  double? get minimumSpend;
  @override
  int? get availableCapacity;
  @override
  String? get description;

  /// Create a copy of TimeSlot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimeSlotImplCopyWith<_$TimeSlotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TimeSlotAvailability _$TimeSlotAvailabilityFromJson(Map<String, dynamic> json) {
  return _TimeSlotAvailability.fromJson(json);
}

/// @nodoc
mixin _$TimeSlotAvailability {
  String get venueId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  List<TimeSlot> get slots => throw _privateConstructorUsedError;
  String? get tableId => throw _privateConstructorUsedError;

  /// Serializes this TimeSlotAvailability to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimeSlotAvailability
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimeSlotAvailabilityCopyWith<TimeSlotAvailability> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeSlotAvailabilityCopyWith<$Res> {
  factory $TimeSlotAvailabilityCopyWith(TimeSlotAvailability value,
          $Res Function(TimeSlotAvailability) then) =
      _$TimeSlotAvailabilityCopyWithImpl<$Res, TimeSlotAvailability>;
  @useResult
  $Res call(
      {String venueId, DateTime date, List<TimeSlot> slots, String? tableId});
}

/// @nodoc
class _$TimeSlotAvailabilityCopyWithImpl<$Res,
        $Val extends TimeSlotAvailability>
    implements $TimeSlotAvailabilityCopyWith<$Res> {
  _$TimeSlotAvailabilityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimeSlotAvailability
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? venueId = null,
    Object? date = null,
    Object? slots = null,
    Object? tableId = freezed,
  }) {
    return _then(_value.copyWith(
      venueId: null == venueId
          ? _value.venueId
          : venueId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      slots: null == slots
          ? _value.slots
          : slots // ignore: cast_nullable_to_non_nullable
              as List<TimeSlot>,
      tableId: freezed == tableId
          ? _value.tableId
          : tableId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TimeSlotAvailabilityImplCopyWith<$Res>
    implements $TimeSlotAvailabilityCopyWith<$Res> {
  factory _$$TimeSlotAvailabilityImplCopyWith(_$TimeSlotAvailabilityImpl value,
          $Res Function(_$TimeSlotAvailabilityImpl) then) =
      __$$TimeSlotAvailabilityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String venueId, DateTime date, List<TimeSlot> slots, String? tableId});
}

/// @nodoc
class __$$TimeSlotAvailabilityImplCopyWithImpl<$Res>
    extends _$TimeSlotAvailabilityCopyWithImpl<$Res, _$TimeSlotAvailabilityImpl>
    implements _$$TimeSlotAvailabilityImplCopyWith<$Res> {
  __$$TimeSlotAvailabilityImplCopyWithImpl(_$TimeSlotAvailabilityImpl _value,
      $Res Function(_$TimeSlotAvailabilityImpl) _then)
      : super(_value, _then);

  /// Create a copy of TimeSlotAvailability
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? venueId = null,
    Object? date = null,
    Object? slots = null,
    Object? tableId = freezed,
  }) {
    return _then(_$TimeSlotAvailabilityImpl(
      venueId: null == venueId
          ? _value.venueId
          : venueId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      slots: null == slots
          ? _value._slots
          : slots // ignore: cast_nullable_to_non_nullable
              as List<TimeSlot>,
      tableId: freezed == tableId
          ? _value.tableId
          : tableId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TimeSlotAvailabilityImpl implements _TimeSlotAvailability {
  const _$TimeSlotAvailabilityImpl(
      {required this.venueId,
      required this.date,
      required final List<TimeSlot> slots,
      this.tableId})
      : _slots = slots;

  factory _$TimeSlotAvailabilityImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimeSlotAvailabilityImplFromJson(json);

  @override
  final String venueId;
  @override
  final DateTime date;
  final List<TimeSlot> _slots;
  @override
  List<TimeSlot> get slots {
    if (_slots is EqualUnmodifiableListView) return _slots;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_slots);
  }

  @override
  final String? tableId;

  @override
  String toString() {
    return 'TimeSlotAvailability(venueId: $venueId, date: $date, slots: $slots, tableId: $tableId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeSlotAvailabilityImpl &&
            (identical(other.venueId, venueId) || other.venueId == venueId) &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality().equals(other._slots, _slots) &&
            (identical(other.tableId, tableId) || other.tableId == tableId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, venueId, date,
      const DeepCollectionEquality().hash(_slots), tableId);

  /// Create a copy of TimeSlotAvailability
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeSlotAvailabilityImplCopyWith<_$TimeSlotAvailabilityImpl>
      get copyWith =>
          __$$TimeSlotAvailabilityImplCopyWithImpl<_$TimeSlotAvailabilityImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimeSlotAvailabilityImplToJson(
      this,
    );
  }
}

abstract class _TimeSlotAvailability implements TimeSlotAvailability {
  const factory _TimeSlotAvailability(
      {required final String venueId,
      required final DateTime date,
      required final List<TimeSlot> slots,
      final String? tableId}) = _$TimeSlotAvailabilityImpl;

  factory _TimeSlotAvailability.fromJson(Map<String, dynamic> json) =
      _$TimeSlotAvailabilityImpl.fromJson;

  @override
  String get venueId;
  @override
  DateTime get date;
  @override
  List<TimeSlot> get slots;
  @override
  String? get tableId;

  /// Create a copy of TimeSlotAvailability
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimeSlotAvailabilityImplCopyWith<_$TimeSlotAvailabilityImpl>
      get copyWith => throw _privateConstructorUsedError;
}

BookingTimeSlot _$BookingTimeSlotFromJson(Map<String, dynamic> json) {
  return _BookingTimeSlot.fromJson(json);
}

/// @nodoc
mixin _$BookingTimeSlot {
  String get id => throw _privateConstructorUsedError;
  String get bookingId => throw _privateConstructorUsedError;
  String get timeSlotId => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  bool get isExtended => throw _privateConstructorUsedError;
  DateTime? get extendedUntil => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this BookingTimeSlot to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingTimeSlot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingTimeSlotCopyWith<BookingTimeSlot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingTimeSlotCopyWith<$Res> {
  factory $BookingTimeSlotCopyWith(
          BookingTimeSlot value, $Res Function(BookingTimeSlot) then) =
      _$BookingTimeSlotCopyWithImpl<$Res, BookingTimeSlot>;
  @useResult
  $Res call(
      {String id,
      String bookingId,
      String timeSlotId,
      DateTime startTime,
      DateTime endTime,
      bool isExtended,
      DateTime? extendedUntil,
      DateTime createdAt});
}

/// @nodoc
class _$BookingTimeSlotCopyWithImpl<$Res, $Val extends BookingTimeSlot>
    implements $BookingTimeSlotCopyWith<$Res> {
  _$BookingTimeSlotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingTimeSlot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookingId = null,
    Object? timeSlotId = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? isExtended = null,
    Object? extendedUntil = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      timeSlotId: null == timeSlotId
          ? _value.timeSlotId
          : timeSlotId // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isExtended: null == isExtended
          ? _value.isExtended
          : isExtended // ignore: cast_nullable_to_non_nullable
              as bool,
      extendedUntil: freezed == extendedUntil
          ? _value.extendedUntil
          : extendedUntil // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookingTimeSlotImplCopyWith<$Res>
    implements $BookingTimeSlotCopyWith<$Res> {
  factory _$$BookingTimeSlotImplCopyWith(_$BookingTimeSlotImpl value,
          $Res Function(_$BookingTimeSlotImpl) then) =
      __$$BookingTimeSlotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String bookingId,
      String timeSlotId,
      DateTime startTime,
      DateTime endTime,
      bool isExtended,
      DateTime? extendedUntil,
      DateTime createdAt});
}

/// @nodoc
class __$$BookingTimeSlotImplCopyWithImpl<$Res>
    extends _$BookingTimeSlotCopyWithImpl<$Res, _$BookingTimeSlotImpl>
    implements _$$BookingTimeSlotImplCopyWith<$Res> {
  __$$BookingTimeSlotImplCopyWithImpl(
      _$BookingTimeSlotImpl _value, $Res Function(_$BookingTimeSlotImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookingTimeSlot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookingId = null,
    Object? timeSlotId = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? isExtended = null,
    Object? extendedUntil = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$BookingTimeSlotImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      timeSlotId: null == timeSlotId
          ? _value.timeSlotId
          : timeSlotId // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isExtended: null == isExtended
          ? _value.isExtended
          : isExtended // ignore: cast_nullable_to_non_nullable
              as bool,
      extendedUntil: freezed == extendedUntil
          ? _value.extendedUntil
          : extendedUntil // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingTimeSlotImpl implements _BookingTimeSlot {
  const _$BookingTimeSlotImpl(
      {required this.id,
      required this.bookingId,
      required this.timeSlotId,
      required this.startTime,
      required this.endTime,
      this.isExtended = false,
      this.extendedUntil,
      required this.createdAt});

  factory _$BookingTimeSlotImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingTimeSlotImplFromJson(json);

  @override
  final String id;
  @override
  final String bookingId;
  @override
  final String timeSlotId;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  @JsonKey()
  final bool isExtended;
  @override
  final DateTime? extendedUntil;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'BookingTimeSlot(id: $id, bookingId: $bookingId, timeSlotId: $timeSlotId, startTime: $startTime, endTime: $endTime, isExtended: $isExtended, extendedUntil: $extendedUntil, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingTimeSlotImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.timeSlotId, timeSlotId) ||
                other.timeSlotId == timeSlotId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.isExtended, isExtended) ||
                other.isExtended == isExtended) &&
            (identical(other.extendedUntil, extendedUntil) ||
                other.extendedUntil == extendedUntil) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, bookingId, timeSlotId,
      startTime, endTime, isExtended, extendedUntil, createdAt);

  /// Create a copy of BookingTimeSlot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingTimeSlotImplCopyWith<_$BookingTimeSlotImpl> get copyWith =>
      __$$BookingTimeSlotImplCopyWithImpl<_$BookingTimeSlotImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingTimeSlotImplToJson(
      this,
    );
  }
}

abstract class _BookingTimeSlot implements BookingTimeSlot {
  const factory _BookingTimeSlot(
      {required final String id,
      required final String bookingId,
      required final String timeSlotId,
      required final DateTime startTime,
      required final DateTime endTime,
      final bool isExtended,
      final DateTime? extendedUntil,
      required final DateTime createdAt}) = _$BookingTimeSlotImpl;

  factory _BookingTimeSlot.fromJson(Map<String, dynamic> json) =
      _$BookingTimeSlotImpl.fromJson;

  @override
  String get id;
  @override
  String get bookingId;
  @override
  String get timeSlotId;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  bool get isExtended;
  @override
  DateTime? get extendedUntil;
  @override
  DateTime get createdAt;

  /// Create a copy of BookingTimeSlot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingTimeSlotImplCopyWith<_$BookingTimeSlotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
