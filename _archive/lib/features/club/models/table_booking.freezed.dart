// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TableBooking _$TableBookingFromJson(Map<String, dynamic> json) {
  return _TableBooking.fromJson(json);
}

/// @nodoc
mixin _$TableBooking {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get tableId => throw _privateConstructorUsedError;
  int get guestCount => throw _privateConstructorUsedError;
  DateTime get bookingDate => throw _privateConstructorUsedError;
  String get timeSlot => throw _privateConstructorUsedError;
  String? get startTime => throw _privateConstructorUsedError;
  String? get endTime => throw _privateConstructorUsedError;
  double get totalPrice => throw _privateConstructorUsedError;
  String? get specialRequests => throw _privateConstructorUsedError;
  String? get contactPhone => throw _privateConstructorUsedError;
  String? get contactEmail => throw _privateConstructorUsedError;
  String? get confirmationCode => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError; // Related data
  String? get tableName => throw _privateConstructorUsedError;
  String? get clubId => throw _privateConstructorUsedError;
  String? get clubName => throw _privateConstructorUsedError;

  /// Serializes this TableBooking to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TableBooking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TableBookingCopyWith<TableBooking> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TableBookingCopyWith<$Res> {
  factory $TableBookingCopyWith(
          TableBooking value, $Res Function(TableBooking) then) =
      _$TableBookingCopyWithImpl<$Res, TableBooking>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String tableId,
      int guestCount,
      DateTime bookingDate,
      String timeSlot,
      String? startTime,
      String? endTime,
      double totalPrice,
      String? specialRequests,
      String? contactPhone,
      String? contactEmail,
      String? confirmationCode,
      String status,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? tableName,
      String? clubId,
      String? clubName});
}

/// @nodoc
class _$TableBookingCopyWithImpl<$Res, $Val extends TableBooking>
    implements $TableBookingCopyWith<$Res> {
  _$TableBookingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TableBooking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? tableId = null,
    Object? guestCount = null,
    Object? bookingDate = null,
    Object? timeSlot = null,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? totalPrice = null,
    Object? specialRequests = freezed,
    Object? contactPhone = freezed,
    Object? contactEmail = freezed,
    Object? confirmationCode = freezed,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? tableName = freezed,
    Object? clubId = freezed,
    Object? clubName = freezed,
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
      tableId: null == tableId
          ? _value.tableId
          : tableId // ignore: cast_nullable_to_non_nullable
              as String,
      guestCount: null == guestCount
          ? _value.guestCount
          : guestCount // ignore: cast_nullable_to_non_nullable
              as int,
      bookingDate: null == bookingDate
          ? _value.bookingDate
          : bookingDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      timeSlot: null == timeSlot
          ? _value.timeSlot
          : timeSlot // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String?,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      specialRequests: freezed == specialRequests
          ? _value.specialRequests
          : specialRequests // ignore: cast_nullable_to_non_nullable
              as String?,
      contactPhone: freezed == contactPhone
          ? _value.contactPhone
          : contactPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      contactEmail: freezed == contactEmail
          ? _value.contactEmail
          : contactEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmationCode: freezed == confirmationCode
          ? _value.confirmationCode
          : confirmationCode // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tableName: freezed == tableName
          ? _value.tableName
          : tableName // ignore: cast_nullable_to_non_nullable
              as String?,
      clubId: freezed == clubId
          ? _value.clubId
          : clubId // ignore: cast_nullable_to_non_nullable
              as String?,
      clubName: freezed == clubName
          ? _value.clubName
          : clubName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TableBookingImplCopyWith<$Res>
    implements $TableBookingCopyWith<$Res> {
  factory _$$TableBookingImplCopyWith(
          _$TableBookingImpl value, $Res Function(_$TableBookingImpl) then) =
      __$$TableBookingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String tableId,
      int guestCount,
      DateTime bookingDate,
      String timeSlot,
      String? startTime,
      String? endTime,
      double totalPrice,
      String? specialRequests,
      String? contactPhone,
      String? contactEmail,
      String? confirmationCode,
      String status,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? tableName,
      String? clubId,
      String? clubName});
}

/// @nodoc
class __$$TableBookingImplCopyWithImpl<$Res>
    extends _$TableBookingCopyWithImpl<$Res, _$TableBookingImpl>
    implements _$$TableBookingImplCopyWith<$Res> {
  __$$TableBookingImplCopyWithImpl(
      _$TableBookingImpl _value, $Res Function(_$TableBookingImpl) _then)
      : super(_value, _then);

  /// Create a copy of TableBooking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? tableId = null,
    Object? guestCount = null,
    Object? bookingDate = null,
    Object? timeSlot = null,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? totalPrice = null,
    Object? specialRequests = freezed,
    Object? contactPhone = freezed,
    Object? contactEmail = freezed,
    Object? confirmationCode = freezed,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? tableName = freezed,
    Object? clubId = freezed,
    Object? clubName = freezed,
  }) {
    return _then(_$TableBookingImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      tableId: null == tableId
          ? _value.tableId
          : tableId // ignore: cast_nullable_to_non_nullable
              as String,
      guestCount: null == guestCount
          ? _value.guestCount
          : guestCount // ignore: cast_nullable_to_non_nullable
              as int,
      bookingDate: null == bookingDate
          ? _value.bookingDate
          : bookingDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      timeSlot: null == timeSlot
          ? _value.timeSlot
          : timeSlot // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String?,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      specialRequests: freezed == specialRequests
          ? _value.specialRequests
          : specialRequests // ignore: cast_nullable_to_non_nullable
              as String?,
      contactPhone: freezed == contactPhone
          ? _value.contactPhone
          : contactPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      contactEmail: freezed == contactEmail
          ? _value.contactEmail
          : contactEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmationCode: freezed == confirmationCode
          ? _value.confirmationCode
          : confirmationCode // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tableName: freezed == tableName
          ? _value.tableName
          : tableName // ignore: cast_nullable_to_non_nullable
              as String?,
      clubId: freezed == clubId
          ? _value.clubId
          : clubId // ignore: cast_nullable_to_non_nullable
              as String?,
      clubName: freezed == clubName
          ? _value.clubName
          : clubName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TableBookingImpl implements _TableBooking {
  const _$TableBookingImpl(
      {required this.id,
      required this.userId,
      required this.tableId,
      required this.guestCount,
      required this.bookingDate,
      required this.timeSlot,
      this.startTime,
      this.endTime,
      required this.totalPrice,
      this.specialRequests,
      this.contactPhone,
      this.contactEmail,
      this.confirmationCode,
      this.status = 'pending',
      this.createdAt,
      this.updatedAt,
      this.tableName,
      this.clubId,
      this.clubName});

  factory _$TableBookingImpl.fromJson(Map<String, dynamic> json) =>
      _$$TableBookingImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String tableId;
  @override
  final int guestCount;
  @override
  final DateTime bookingDate;
  @override
  final String timeSlot;
  @override
  final String? startTime;
  @override
  final String? endTime;
  @override
  final double totalPrice;
  @override
  final String? specialRequests;
  @override
  final String? contactPhone;
  @override
  final String? contactEmail;
  @override
  final String? confirmationCode;
  @override
  @JsonKey()
  final String status;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
// Related data
  @override
  final String? tableName;
  @override
  final String? clubId;
  @override
  final String? clubName;

  @override
  String toString() {
    return 'TableBooking(id: $id, userId: $userId, tableId: $tableId, guestCount: $guestCount, bookingDate: $bookingDate, timeSlot: $timeSlot, startTime: $startTime, endTime: $endTime, totalPrice: $totalPrice, specialRequests: $specialRequests, contactPhone: $contactPhone, contactEmail: $contactEmail, confirmationCode: $confirmationCode, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, tableName: $tableName, clubId: $clubId, clubName: $clubName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TableBookingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.tableId, tableId) || other.tableId == tableId) &&
            (identical(other.guestCount, guestCount) ||
                other.guestCount == guestCount) &&
            (identical(other.bookingDate, bookingDate) ||
                other.bookingDate == bookingDate) &&
            (identical(other.timeSlot, timeSlot) ||
                other.timeSlot == timeSlot) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.specialRequests, specialRequests) ||
                other.specialRequests == specialRequests) &&
            (identical(other.contactPhone, contactPhone) ||
                other.contactPhone == contactPhone) &&
            (identical(other.contactEmail, contactEmail) ||
                other.contactEmail == contactEmail) &&
            (identical(other.confirmationCode, confirmationCode) ||
                other.confirmationCode == confirmationCode) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.tableName, tableName) ||
                other.tableName == tableName) &&
            (identical(other.clubId, clubId) || other.clubId == clubId) &&
            (identical(other.clubName, clubName) ||
                other.clubName == clubName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        tableId,
        guestCount,
        bookingDate,
        timeSlot,
        startTime,
        endTime,
        totalPrice,
        specialRequests,
        contactPhone,
        contactEmail,
        confirmationCode,
        status,
        createdAt,
        updatedAt,
        tableName,
        clubId,
        clubName
      ]);

  /// Create a copy of TableBooking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TableBookingImplCopyWith<_$TableBookingImpl> get copyWith =>
      __$$TableBookingImplCopyWithImpl<_$TableBookingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TableBookingImplToJson(
      this,
    );
  }
}

abstract class _TableBooking implements TableBooking {
  const factory _TableBooking(
      {required final String id,
      required final String userId,
      required final String tableId,
      required final int guestCount,
      required final DateTime bookingDate,
      required final String timeSlot,
      final String? startTime,
      final String? endTime,
      required final double totalPrice,
      final String? specialRequests,
      final String? contactPhone,
      final String? contactEmail,
      final String? confirmationCode,
      final String status,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final String? tableName,
      final String? clubId,
      final String? clubName}) = _$TableBookingImpl;

  factory _TableBooking.fromJson(Map<String, dynamic> json) =
      _$TableBookingImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get tableId;
  @override
  int get guestCount;
  @override
  DateTime get bookingDate;
  @override
  String get timeSlot;
  @override
  String? get startTime;
  @override
  String? get endTime;
  @override
  double get totalPrice;
  @override
  String? get specialRequests;
  @override
  String? get contactPhone;
  @override
  String? get contactEmail;
  @override
  String? get confirmationCode;
  @override
  String get status;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt; // Related data
  @override
  String? get tableName;
  @override
  String? get clubId;
  @override
  String? get clubName;

  /// Create a copy of TableBooking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TableBookingImplCopyWith<_$TableBookingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ClubTable _$ClubTableFromJson(Map<String, dynamic> json) {
  return _ClubTable.fromJson(json);
}

/// @nodoc
mixin _$ClubTable {
  String get id => throw _privateConstructorUsedError;
  String get clubId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get capacity => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String? get locationDescription => throw _privateConstructorUsedError;
  double? get minimumSpend => throw _privateConstructorUsedError;
  bool get isVip => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ClubTable to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClubTable
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClubTableCopyWith<ClubTable> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClubTableCopyWith<$Res> {
  factory $ClubTableCopyWith(ClubTable value, $Res Function(ClubTable) then) =
      _$ClubTableCopyWithImpl<$Res, ClubTable>;
  @useResult
  $Res call(
      {String id,
      String clubId,
      String name,
      int capacity,
      double price,
      String? locationDescription,
      double? minimumSpend,
      bool isVip,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ClubTableCopyWithImpl<$Res, $Val extends ClubTable>
    implements $ClubTableCopyWith<$Res> {
  _$ClubTableCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClubTable
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clubId = null,
    Object? name = null,
    Object? capacity = null,
    Object? price = null,
    Object? locationDescription = freezed,
    Object? minimumSpend = freezed,
    Object? isVip = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      clubId: null == clubId
          ? _value.clubId
          : clubId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      capacity: null == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      locationDescription: freezed == locationDescription
          ? _value.locationDescription
          : locationDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      minimumSpend: freezed == minimumSpend
          ? _value.minimumSpend
          : minimumSpend // ignore: cast_nullable_to_non_nullable
              as double?,
      isVip: null == isVip
          ? _value.isVip
          : isVip // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClubTableImplCopyWith<$Res>
    implements $ClubTableCopyWith<$Res> {
  factory _$$ClubTableImplCopyWith(
          _$ClubTableImpl value, $Res Function(_$ClubTableImpl) then) =
      __$$ClubTableImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String clubId,
      String name,
      int capacity,
      double price,
      String? locationDescription,
      double? minimumSpend,
      bool isVip,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ClubTableImplCopyWithImpl<$Res>
    extends _$ClubTableCopyWithImpl<$Res, _$ClubTableImpl>
    implements _$$ClubTableImplCopyWith<$Res> {
  __$$ClubTableImplCopyWithImpl(
      _$ClubTableImpl _value, $Res Function(_$ClubTableImpl) _then)
      : super(_value, _then);

  /// Create a copy of ClubTable
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clubId = null,
    Object? name = null,
    Object? capacity = null,
    Object? price = null,
    Object? locationDescription = freezed,
    Object? minimumSpend = freezed,
    Object? isVip = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ClubTableImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      clubId: null == clubId
          ? _value.clubId
          : clubId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      capacity: null == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      locationDescription: freezed == locationDescription
          ? _value.locationDescription
          : locationDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      minimumSpend: freezed == minimumSpend
          ? _value.minimumSpend
          : minimumSpend // ignore: cast_nullable_to_non_nullable
              as double?,
      isVip: null == isVip
          ? _value.isVip
          : isVip // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ClubTableImpl implements _ClubTable {
  const _$ClubTableImpl(
      {required this.id,
      required this.clubId,
      required this.name,
      required this.capacity,
      required this.price,
      this.locationDescription,
      this.minimumSpend,
      this.isVip = false,
      this.isActive = true,
      this.createdAt,
      this.updatedAt});

  factory _$ClubTableImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClubTableImplFromJson(json);

  @override
  final String id;
  @override
  final String clubId;
  @override
  final String name;
  @override
  final int capacity;
  @override
  final double price;
  @override
  final String? locationDescription;
  @override
  final double? minimumSpend;
  @override
  @JsonKey()
  final bool isVip;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ClubTable(id: $id, clubId: $clubId, name: $name, capacity: $capacity, price: $price, locationDescription: $locationDescription, minimumSpend: $minimumSpend, isVip: $isVip, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClubTableImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clubId, clubId) || other.clubId == clubId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.locationDescription, locationDescription) ||
                other.locationDescription == locationDescription) &&
            (identical(other.minimumSpend, minimumSpend) ||
                other.minimumSpend == minimumSpend) &&
            (identical(other.isVip, isVip) || other.isVip == isVip) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
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
      clubId,
      name,
      capacity,
      price,
      locationDescription,
      minimumSpend,
      isVip,
      isActive,
      createdAt,
      updatedAt);

  /// Create a copy of ClubTable
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClubTableImplCopyWith<_$ClubTableImpl> get copyWith =>
      __$$ClubTableImplCopyWithImpl<_$ClubTableImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClubTableImplToJson(
      this,
    );
  }
}

abstract class _ClubTable implements ClubTable {
  const factory _ClubTable(
      {required final String id,
      required final String clubId,
      required final String name,
      required final int capacity,
      required final double price,
      final String? locationDescription,
      final double? minimumSpend,
      final bool isVip,
      final bool isActive,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$ClubTableImpl;

  factory _ClubTable.fromJson(Map<String, dynamic> json) =
      _$ClubTableImpl.fromJson;

  @override
  String get id;
  @override
  String get clubId;
  @override
  String get name;
  @override
  int get capacity;
  @override
  double get price;
  @override
  String? get locationDescription;
  @override
  double? get minimumSpend;
  @override
  bool get isVip;
  @override
  bool get isActive;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of ClubTable
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClubTableImplCopyWith<_$ClubTableImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ClubHours _$ClubHoursFromJson(Map<String, dynamic> json) {
  return _ClubHours.fromJson(json);
}

/// @nodoc
mixin _$ClubHours {
  String get id => throw _privateConstructorUsedError;
  String get clubId => throw _privateConstructorUsedError;
  int get dayOfWeek => throw _privateConstructorUsedError;
  String? get openTime => throw _privateConstructorUsedError;
  String? get closeTime => throw _privateConstructorUsedError;
  bool get isClosed => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ClubHours to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClubHours
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClubHoursCopyWith<ClubHours> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClubHoursCopyWith<$Res> {
  factory $ClubHoursCopyWith(ClubHours value, $Res Function(ClubHours) then) =
      _$ClubHoursCopyWithImpl<$Res, ClubHours>;
  @useResult
  $Res call(
      {String id,
      String clubId,
      int dayOfWeek,
      String? openTime,
      String? closeTime,
      bool isClosed,
      DateTime? createdAt});
}

/// @nodoc
class _$ClubHoursCopyWithImpl<$Res, $Val extends ClubHours>
    implements $ClubHoursCopyWith<$Res> {
  _$ClubHoursCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClubHours
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clubId = null,
    Object? dayOfWeek = null,
    Object? openTime = freezed,
    Object? closeTime = freezed,
    Object? isClosed = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      clubId: null == clubId
          ? _value.clubId
          : clubId // ignore: cast_nullable_to_non_nullable
              as String,
      dayOfWeek: null == dayOfWeek
          ? _value.dayOfWeek
          : dayOfWeek // ignore: cast_nullable_to_non_nullable
              as int,
      openTime: freezed == openTime
          ? _value.openTime
          : openTime // ignore: cast_nullable_to_non_nullable
              as String?,
      closeTime: freezed == closeTime
          ? _value.closeTime
          : closeTime // ignore: cast_nullable_to_non_nullable
              as String?,
      isClosed: null == isClosed
          ? _value.isClosed
          : isClosed // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClubHoursImplCopyWith<$Res>
    implements $ClubHoursCopyWith<$Res> {
  factory _$$ClubHoursImplCopyWith(
          _$ClubHoursImpl value, $Res Function(_$ClubHoursImpl) then) =
      __$$ClubHoursImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String clubId,
      int dayOfWeek,
      String? openTime,
      String? closeTime,
      bool isClosed,
      DateTime? createdAt});
}

/// @nodoc
class __$$ClubHoursImplCopyWithImpl<$Res>
    extends _$ClubHoursCopyWithImpl<$Res, _$ClubHoursImpl>
    implements _$$ClubHoursImplCopyWith<$Res> {
  __$$ClubHoursImplCopyWithImpl(
      _$ClubHoursImpl _value, $Res Function(_$ClubHoursImpl) _then)
      : super(_value, _then);

  /// Create a copy of ClubHours
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clubId = null,
    Object? dayOfWeek = null,
    Object? openTime = freezed,
    Object? closeTime = freezed,
    Object? isClosed = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$ClubHoursImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      clubId: null == clubId
          ? _value.clubId
          : clubId // ignore: cast_nullable_to_non_nullable
              as String,
      dayOfWeek: null == dayOfWeek
          ? _value.dayOfWeek
          : dayOfWeek // ignore: cast_nullable_to_non_nullable
              as int,
      openTime: freezed == openTime
          ? _value.openTime
          : openTime // ignore: cast_nullable_to_non_nullable
              as String?,
      closeTime: freezed == closeTime
          ? _value.closeTime
          : closeTime // ignore: cast_nullable_to_non_nullable
              as String?,
      isClosed: null == isClosed
          ? _value.isClosed
          : isClosed // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ClubHoursImpl implements _ClubHours {
  const _$ClubHoursImpl(
      {required this.id,
      required this.clubId,
      required this.dayOfWeek,
      this.openTime,
      this.closeTime,
      this.isClosed = false,
      this.createdAt});

  factory _$ClubHoursImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClubHoursImplFromJson(json);

  @override
  final String id;
  @override
  final String clubId;
  @override
  final int dayOfWeek;
  @override
  final String? openTime;
  @override
  final String? closeTime;
  @override
  @JsonKey()
  final bool isClosed;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'ClubHours(id: $id, clubId: $clubId, dayOfWeek: $dayOfWeek, openTime: $openTime, closeTime: $closeTime, isClosed: $isClosed, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClubHoursImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clubId, clubId) || other.clubId == clubId) &&
            (identical(other.dayOfWeek, dayOfWeek) ||
                other.dayOfWeek == dayOfWeek) &&
            (identical(other.openTime, openTime) ||
                other.openTime == openTime) &&
            (identical(other.closeTime, closeTime) ||
                other.closeTime == closeTime) &&
            (identical(other.isClosed, isClosed) ||
                other.isClosed == isClosed) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, clubId, dayOfWeek, openTime,
      closeTime, isClosed, createdAt);

  /// Create a copy of ClubHours
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClubHoursImplCopyWith<_$ClubHoursImpl> get copyWith =>
      __$$ClubHoursImplCopyWithImpl<_$ClubHoursImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClubHoursImplToJson(
      this,
    );
  }
}

abstract class _ClubHours implements ClubHours {
  const factory _ClubHours(
      {required final String id,
      required final String clubId,
      required final int dayOfWeek,
      final String? openTime,
      final String? closeTime,
      final bool isClosed,
      final DateTime? createdAt}) = _$ClubHoursImpl;

  factory _ClubHours.fromJson(Map<String, dynamic> json) =
      _$ClubHoursImpl.fromJson;

  @override
  String get id;
  @override
  String get clubId;
  @override
  int get dayOfWeek;
  @override
  String? get openTime;
  @override
  String? get closeTime;
  @override
  bool get isClosed;
  @override
  DateTime? get createdAt;

  /// Create a copy of ClubHours
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClubHoursImplCopyWith<_$ClubHoursImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
