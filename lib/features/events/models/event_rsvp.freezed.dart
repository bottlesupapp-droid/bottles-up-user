// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_rsvp.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventRSVP _$EventRSVPFromJson(Map<String, dynamic> json) {
  return _EventRSVP.fromJson(json);
}

/// @nodoc
mixin _$EventRSVP {
  String get id => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  RsvpType get rsvpType => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get specialRequests => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  bool get isAttended => throw _privateConstructorUsedError;
  String? get verificationCode => throw _privateConstructorUsedError;
  String? get qrCodeData => throw _privateConstructorUsedError;
  DateTime? get verifiedAt => throw _privateConstructorUsedError;
  String? get verifiedBy => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this EventRSVP to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EventRSVP
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventRSVPCopyWith<EventRSVP> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventRSVPCopyWith<$Res> {
  factory $EventRSVPCopyWith(EventRSVP value, $Res Function(EventRSVP) then) =
      _$EventRSVPCopyWithImpl<$Res, EventRSVP>;
  @useResult
  $Res call(
      {String id,
      String eventId,
      String userId,
      RsvpType rsvpType,
      String firstName,
      String lastName,
      String email,
      String? phone,
      String? specialRequests,
      String status,
      bool isAttended,
      String? verificationCode,
      String? qrCodeData,
      DateTime? verifiedAt,
      String? verifiedBy,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$EventRSVPCopyWithImpl<$Res, $Val extends EventRSVP>
    implements $EventRSVPCopyWith<$Res> {
  _$EventRSVPCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventRSVP
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? userId = null,
    Object? rsvpType = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? email = null,
    Object? phone = freezed,
    Object? specialRequests = freezed,
    Object? status = null,
    Object? isAttended = null,
    Object? verificationCode = freezed,
    Object? qrCodeData = freezed,
    Object? verifiedAt = freezed,
    Object? verifiedBy = freezed,
    Object? createdAt = freezed,
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
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      rsvpType: null == rsvpType
          ? _value.rsvpType
          : rsvpType // ignore: cast_nullable_to_non_nullable
              as RsvpType,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      specialRequests: freezed == specialRequests
          ? _value.specialRequests
          : specialRequests // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      isAttended: null == isAttended
          ? _value.isAttended
          : isAttended // ignore: cast_nullable_to_non_nullable
              as bool,
      verificationCode: freezed == verificationCode
          ? _value.verificationCode
          : verificationCode // ignore: cast_nullable_to_non_nullable
              as String?,
      qrCodeData: freezed == qrCodeData
          ? _value.qrCodeData
          : qrCodeData // ignore: cast_nullable_to_non_nullable
              as String?,
      verifiedAt: freezed == verifiedAt
          ? _value.verifiedAt
          : verifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      verifiedBy: freezed == verifiedBy
          ? _value.verifiedBy
          : verifiedBy // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$EventRSVPImplCopyWith<$Res>
    implements $EventRSVPCopyWith<$Res> {
  factory _$$EventRSVPImplCopyWith(
          _$EventRSVPImpl value, $Res Function(_$EventRSVPImpl) then) =
      __$$EventRSVPImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String eventId,
      String userId,
      RsvpType rsvpType,
      String firstName,
      String lastName,
      String email,
      String? phone,
      String? specialRequests,
      String status,
      bool isAttended,
      String? verificationCode,
      String? qrCodeData,
      DateTime? verifiedAt,
      String? verifiedBy,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$EventRSVPImplCopyWithImpl<$Res>
    extends _$EventRSVPCopyWithImpl<$Res, _$EventRSVPImpl>
    implements _$$EventRSVPImplCopyWith<$Res> {
  __$$EventRSVPImplCopyWithImpl(
      _$EventRSVPImpl _value, $Res Function(_$EventRSVPImpl) _then)
      : super(_value, _then);

  /// Create a copy of EventRSVP
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? userId = null,
    Object? rsvpType = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? email = null,
    Object? phone = freezed,
    Object? specialRequests = freezed,
    Object? status = null,
    Object? isAttended = null,
    Object? verificationCode = freezed,
    Object? qrCodeData = freezed,
    Object? verifiedAt = freezed,
    Object? verifiedBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$EventRSVPImpl(
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
      rsvpType: null == rsvpType
          ? _value.rsvpType
          : rsvpType // ignore: cast_nullable_to_non_nullable
              as RsvpType,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      specialRequests: freezed == specialRequests
          ? _value.specialRequests
          : specialRequests // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      isAttended: null == isAttended
          ? _value.isAttended
          : isAttended // ignore: cast_nullable_to_non_nullable
              as bool,
      verificationCode: freezed == verificationCode
          ? _value.verificationCode
          : verificationCode // ignore: cast_nullable_to_non_nullable
              as String?,
      qrCodeData: freezed == qrCodeData
          ? _value.qrCodeData
          : qrCodeData // ignore: cast_nullable_to_non_nullable
              as String?,
      verifiedAt: freezed == verifiedAt
          ? _value.verifiedAt
          : verifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      verifiedBy: freezed == verifiedBy
          ? _value.verifiedBy
          : verifiedBy // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$EventRSVPImpl implements _EventRSVP {
  const _$EventRSVPImpl(
      {required this.id,
      required this.eventId,
      required this.userId,
      required this.rsvpType,
      required this.firstName,
      required this.lastName,
      required this.email,
      this.phone,
      this.specialRequests,
      this.status = 'pending',
      this.isAttended = false,
      this.verificationCode,
      this.qrCodeData,
      this.verifiedAt,
      this.verifiedBy,
      this.createdAt,
      this.updatedAt});

  factory _$EventRSVPImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventRSVPImplFromJson(json);

  @override
  final String id;
  @override
  final String eventId;
  @override
  final String userId;
  @override
  final RsvpType rsvpType;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String email;
  @override
  final String? phone;
  @override
  final String? specialRequests;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final bool isAttended;
  @override
  final String? verificationCode;
  @override
  final String? qrCodeData;
  @override
  final DateTime? verifiedAt;
  @override
  final String? verifiedBy;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'EventRSVP(id: $id, eventId: $eventId, userId: $userId, rsvpType: $rsvpType, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, specialRequests: $specialRequests, status: $status, isAttended: $isAttended, verificationCode: $verificationCode, qrCodeData: $qrCodeData, verifiedAt: $verifiedAt, verifiedBy: $verifiedBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventRSVPImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.rsvpType, rsvpType) ||
                other.rsvpType == rsvpType) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.specialRequests, specialRequests) ||
                other.specialRequests == specialRequests) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isAttended, isAttended) ||
                other.isAttended == isAttended) &&
            (identical(other.verificationCode, verificationCode) ||
                other.verificationCode == verificationCode) &&
            (identical(other.qrCodeData, qrCodeData) ||
                other.qrCodeData == qrCodeData) &&
            (identical(other.verifiedAt, verifiedAt) ||
                other.verifiedAt == verifiedAt) &&
            (identical(other.verifiedBy, verifiedBy) ||
                other.verifiedBy == verifiedBy) &&
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
      userId,
      rsvpType,
      firstName,
      lastName,
      email,
      phone,
      specialRequests,
      status,
      isAttended,
      verificationCode,
      qrCodeData,
      verifiedAt,
      verifiedBy,
      createdAt,
      updatedAt);

  /// Create a copy of EventRSVP
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventRSVPImplCopyWith<_$EventRSVPImpl> get copyWith =>
      __$$EventRSVPImplCopyWithImpl<_$EventRSVPImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventRSVPImplToJson(
      this,
    );
  }
}

abstract class _EventRSVP implements EventRSVP {
  const factory _EventRSVP(
      {required final String id,
      required final String eventId,
      required final String userId,
      required final RsvpType rsvpType,
      required final String firstName,
      required final String lastName,
      required final String email,
      final String? phone,
      final String? specialRequests,
      final String status,
      final bool isAttended,
      final String? verificationCode,
      final String? qrCodeData,
      final DateTime? verifiedAt,
      final String? verifiedBy,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$EventRSVPImpl;

  factory _EventRSVP.fromJson(Map<String, dynamic> json) =
      _$EventRSVPImpl.fromJson;

  @override
  String get id;
  @override
  String get eventId;
  @override
  String get userId;
  @override
  RsvpType get rsvpType;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String get email;
  @override
  String? get phone;
  @override
  String? get specialRequests;
  @override
  String get status;
  @override
  bool get isAttended;
  @override
  String? get verificationCode;
  @override
  String? get qrCodeData;
  @override
  DateTime? get verifiedAt;
  @override
  String? get verifiedBy;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of EventRSVP
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventRSVPImplCopyWith<_$EventRSVPImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EventTableBooking _$EventTableBookingFromJson(Map<String, dynamic> json) {
  return _EventTableBooking.fromJson(json);
}

/// @nodoc
mixin _$EventTableBooking {
  String get id => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get tableId => throw _privateConstructorUsedError;
  int get partySize => throw _privateConstructorUsedError;
  double get depositAmount => throw _privateConstructorUsedError;
  int get minimumBottles => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  bool get depositPaid => throw _privateConstructorUsedError;
  DateTime? get eventDate => throw _privateConstructorUsedError;
  String? get specialRequests => throw _privateConstructorUsedError;
  List<SplitPaymentParticipant>? get splitPayments =>
      throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this EventTableBooking to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EventTableBooking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventTableBookingCopyWith<EventTableBooking> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventTableBookingCopyWith<$Res> {
  factory $EventTableBookingCopyWith(
          EventTableBooking value, $Res Function(EventTableBooking) then) =
      _$EventTableBookingCopyWithImpl<$Res, EventTableBooking>;
  @useResult
  $Res call(
      {String id,
      String eventId,
      String userId,
      String tableId,
      int partySize,
      double depositAmount,
      int minimumBottles,
      String status,
      bool depositPaid,
      DateTime? eventDate,
      String? specialRequests,
      List<SplitPaymentParticipant>? splitPayments,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$EventTableBookingCopyWithImpl<$Res, $Val extends EventTableBooking>
    implements $EventTableBookingCopyWith<$Res> {
  _$EventTableBookingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventTableBooking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? userId = null,
    Object? tableId = null,
    Object? partySize = null,
    Object? depositAmount = null,
    Object? minimumBottles = null,
    Object? status = null,
    Object? depositPaid = null,
    Object? eventDate = freezed,
    Object? specialRequests = freezed,
    Object? splitPayments = freezed,
    Object? createdAt = freezed,
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
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      tableId: null == tableId
          ? _value.tableId
          : tableId // ignore: cast_nullable_to_non_nullable
              as String,
      partySize: null == partySize
          ? _value.partySize
          : partySize // ignore: cast_nullable_to_non_nullable
              as int,
      depositAmount: null == depositAmount
          ? _value.depositAmount
          : depositAmount // ignore: cast_nullable_to_non_nullable
              as double,
      minimumBottles: null == minimumBottles
          ? _value.minimumBottles
          : minimumBottles // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      depositPaid: null == depositPaid
          ? _value.depositPaid
          : depositPaid // ignore: cast_nullable_to_non_nullable
              as bool,
      eventDate: freezed == eventDate
          ? _value.eventDate
          : eventDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      specialRequests: freezed == specialRequests
          ? _value.specialRequests
          : specialRequests // ignore: cast_nullable_to_non_nullable
              as String?,
      splitPayments: freezed == splitPayments
          ? _value.splitPayments
          : splitPayments // ignore: cast_nullable_to_non_nullable
              as List<SplitPaymentParticipant>?,
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
abstract class _$$EventTableBookingImplCopyWith<$Res>
    implements $EventTableBookingCopyWith<$Res> {
  factory _$$EventTableBookingImplCopyWith(_$EventTableBookingImpl value,
          $Res Function(_$EventTableBookingImpl) then) =
      __$$EventTableBookingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String eventId,
      String userId,
      String tableId,
      int partySize,
      double depositAmount,
      int minimumBottles,
      String status,
      bool depositPaid,
      DateTime? eventDate,
      String? specialRequests,
      List<SplitPaymentParticipant>? splitPayments,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$EventTableBookingImplCopyWithImpl<$Res>
    extends _$EventTableBookingCopyWithImpl<$Res, _$EventTableBookingImpl>
    implements _$$EventTableBookingImplCopyWith<$Res> {
  __$$EventTableBookingImplCopyWithImpl(_$EventTableBookingImpl _value,
      $Res Function(_$EventTableBookingImpl) _then)
      : super(_value, _then);

  /// Create a copy of EventTableBooking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? userId = null,
    Object? tableId = null,
    Object? partySize = null,
    Object? depositAmount = null,
    Object? minimumBottles = null,
    Object? status = null,
    Object? depositPaid = null,
    Object? eventDate = freezed,
    Object? specialRequests = freezed,
    Object? splitPayments = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$EventTableBookingImpl(
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
      tableId: null == tableId
          ? _value.tableId
          : tableId // ignore: cast_nullable_to_non_nullable
              as String,
      partySize: null == partySize
          ? _value.partySize
          : partySize // ignore: cast_nullable_to_non_nullable
              as int,
      depositAmount: null == depositAmount
          ? _value.depositAmount
          : depositAmount // ignore: cast_nullable_to_non_nullable
              as double,
      minimumBottles: null == minimumBottles
          ? _value.minimumBottles
          : minimumBottles // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      depositPaid: null == depositPaid
          ? _value.depositPaid
          : depositPaid // ignore: cast_nullable_to_non_nullable
              as bool,
      eventDate: freezed == eventDate
          ? _value.eventDate
          : eventDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      specialRequests: freezed == specialRequests
          ? _value.specialRequests
          : specialRequests // ignore: cast_nullable_to_non_nullable
              as String?,
      splitPayments: freezed == splitPayments
          ? _value._splitPayments
          : splitPayments // ignore: cast_nullable_to_non_nullable
              as List<SplitPaymentParticipant>?,
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
class _$EventTableBookingImpl implements _EventTableBooking {
  const _$EventTableBookingImpl(
      {required this.id,
      required this.eventId,
      required this.userId,
      required this.tableId,
      required this.partySize,
      required this.depositAmount,
      required this.minimumBottles,
      this.status = 'pending',
      this.depositPaid = false,
      this.eventDate,
      this.specialRequests,
      final List<SplitPaymentParticipant>? splitPayments,
      this.createdAt,
      this.updatedAt})
      : _splitPayments = splitPayments;

  factory _$EventTableBookingImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventTableBookingImplFromJson(json);

  @override
  final String id;
  @override
  final String eventId;
  @override
  final String userId;
  @override
  final String tableId;
  @override
  final int partySize;
  @override
  final double depositAmount;
  @override
  final int minimumBottles;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final bool depositPaid;
  @override
  final DateTime? eventDate;
  @override
  final String? specialRequests;
  final List<SplitPaymentParticipant>? _splitPayments;
  @override
  List<SplitPaymentParticipant>? get splitPayments {
    final value = _splitPayments;
    if (value == null) return null;
    if (_splitPayments is EqualUnmodifiableListView) return _splitPayments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'EventTableBooking(id: $id, eventId: $eventId, userId: $userId, tableId: $tableId, partySize: $partySize, depositAmount: $depositAmount, minimumBottles: $minimumBottles, status: $status, depositPaid: $depositPaid, eventDate: $eventDate, specialRequests: $specialRequests, splitPayments: $splitPayments, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventTableBookingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.tableId, tableId) || other.tableId == tableId) &&
            (identical(other.partySize, partySize) ||
                other.partySize == partySize) &&
            (identical(other.depositAmount, depositAmount) ||
                other.depositAmount == depositAmount) &&
            (identical(other.minimumBottles, minimumBottles) ||
                other.minimumBottles == minimumBottles) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.depositPaid, depositPaid) ||
                other.depositPaid == depositPaid) &&
            (identical(other.eventDate, eventDate) ||
                other.eventDate == eventDate) &&
            (identical(other.specialRequests, specialRequests) ||
                other.specialRequests == specialRequests) &&
            const DeepCollectionEquality()
                .equals(other._splitPayments, _splitPayments) &&
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
      userId,
      tableId,
      partySize,
      depositAmount,
      minimumBottles,
      status,
      depositPaid,
      eventDate,
      specialRequests,
      const DeepCollectionEquality().hash(_splitPayments),
      createdAt,
      updatedAt);

  /// Create a copy of EventTableBooking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventTableBookingImplCopyWith<_$EventTableBookingImpl> get copyWith =>
      __$$EventTableBookingImplCopyWithImpl<_$EventTableBookingImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventTableBookingImplToJson(
      this,
    );
  }
}

abstract class _EventTableBooking implements EventTableBooking {
  const factory _EventTableBooking(
      {required final String id,
      required final String eventId,
      required final String userId,
      required final String tableId,
      required final int partySize,
      required final double depositAmount,
      required final int minimumBottles,
      final String status,
      final bool depositPaid,
      final DateTime? eventDate,
      final String? specialRequests,
      final List<SplitPaymentParticipant>? splitPayments,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$EventTableBookingImpl;

  factory _EventTableBooking.fromJson(Map<String, dynamic> json) =
      _$EventTableBookingImpl.fromJson;

  @override
  String get id;
  @override
  String get eventId;
  @override
  String get userId;
  @override
  String get tableId;
  @override
  int get partySize;
  @override
  double get depositAmount;
  @override
  int get minimumBottles;
  @override
  String get status;
  @override
  bool get depositPaid;
  @override
  DateTime? get eventDate;
  @override
  String? get specialRequests;
  @override
  List<SplitPaymentParticipant>? get splitPayments;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of EventTableBooking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventTableBookingImplCopyWith<_$EventTableBookingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SplitPaymentParticipant _$SplitPaymentParticipantFromJson(
    Map<String, dynamic> json) {
  return _SplitPaymentParticipant.fromJson(json);
}

/// @nodoc
mixin _$SplitPaymentParticipant {
  String get id => throw _privateConstructorUsedError;
  String get tableBookingId => throw _privateConstructorUsedError;
  String get participantName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get paymentStatus => throw _privateConstructorUsedError;
  String? get paymentIntentId => throw _privateConstructorUsedError;
  DateTime? get paidAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SplitPaymentParticipant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SplitPaymentParticipant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SplitPaymentParticipantCopyWith<SplitPaymentParticipant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SplitPaymentParticipantCopyWith<$Res> {
  factory $SplitPaymentParticipantCopyWith(SplitPaymentParticipant value,
          $Res Function(SplitPaymentParticipant) then) =
      _$SplitPaymentParticipantCopyWithImpl<$Res, SplitPaymentParticipant>;
  @useResult
  $Res call(
      {String id,
      String tableBookingId,
      String participantName,
      String email,
      double amount,
      String paymentStatus,
      String? paymentIntentId,
      DateTime? paidAt,
      DateTime? createdAt});
}

/// @nodoc
class _$SplitPaymentParticipantCopyWithImpl<$Res,
        $Val extends SplitPaymentParticipant>
    implements $SplitPaymentParticipantCopyWith<$Res> {
  _$SplitPaymentParticipantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SplitPaymentParticipant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tableBookingId = null,
    Object? participantName = null,
    Object? email = null,
    Object? amount = null,
    Object? paymentStatus = null,
    Object? paymentIntentId = freezed,
    Object? paidAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tableBookingId: null == tableBookingId
          ? _value.tableBookingId
          : tableBookingId // ignore: cast_nullable_to_non_nullable
              as String,
      participantName: null == participantName
          ? _value.participantName
          : participantName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      paymentIntentId: freezed == paymentIntentId
          ? _value.paymentIntentId
          : paymentIntentId // ignore: cast_nullable_to_non_nullable
              as String?,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SplitPaymentParticipantImplCopyWith<$Res>
    implements $SplitPaymentParticipantCopyWith<$Res> {
  factory _$$SplitPaymentParticipantImplCopyWith(
          _$SplitPaymentParticipantImpl value,
          $Res Function(_$SplitPaymentParticipantImpl) then) =
      __$$SplitPaymentParticipantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String tableBookingId,
      String participantName,
      String email,
      double amount,
      String paymentStatus,
      String? paymentIntentId,
      DateTime? paidAt,
      DateTime? createdAt});
}

/// @nodoc
class __$$SplitPaymentParticipantImplCopyWithImpl<$Res>
    extends _$SplitPaymentParticipantCopyWithImpl<$Res,
        _$SplitPaymentParticipantImpl>
    implements _$$SplitPaymentParticipantImplCopyWith<$Res> {
  __$$SplitPaymentParticipantImplCopyWithImpl(
      _$SplitPaymentParticipantImpl _value,
      $Res Function(_$SplitPaymentParticipantImpl) _then)
      : super(_value, _then);

  /// Create a copy of SplitPaymentParticipant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tableBookingId = null,
    Object? participantName = null,
    Object? email = null,
    Object? amount = null,
    Object? paymentStatus = null,
    Object? paymentIntentId = freezed,
    Object? paidAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$SplitPaymentParticipantImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tableBookingId: null == tableBookingId
          ? _value.tableBookingId
          : tableBookingId // ignore: cast_nullable_to_non_nullable
              as String,
      participantName: null == participantName
          ? _value.participantName
          : participantName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      paymentIntentId: freezed == paymentIntentId
          ? _value.paymentIntentId
          : paymentIntentId // ignore: cast_nullable_to_non_nullable
              as String?,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SplitPaymentParticipantImpl implements _SplitPaymentParticipant {
  const _$SplitPaymentParticipantImpl(
      {required this.id,
      required this.tableBookingId,
      required this.participantName,
      required this.email,
      required this.amount,
      this.paymentStatus = 'pending',
      this.paymentIntentId,
      this.paidAt,
      this.createdAt});

  factory _$SplitPaymentParticipantImpl.fromJson(Map<String, dynamic> json) =>
      _$$SplitPaymentParticipantImplFromJson(json);

  @override
  final String id;
  @override
  final String tableBookingId;
  @override
  final String participantName;
  @override
  final String email;
  @override
  final double amount;
  @override
  @JsonKey()
  final String paymentStatus;
  @override
  final String? paymentIntentId;
  @override
  final DateTime? paidAt;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'SplitPaymentParticipant(id: $id, tableBookingId: $tableBookingId, participantName: $participantName, email: $email, amount: $amount, paymentStatus: $paymentStatus, paymentIntentId: $paymentIntentId, paidAt: $paidAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SplitPaymentParticipantImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tableBookingId, tableBookingId) ||
                other.tableBookingId == tableBookingId) &&
            (identical(other.participantName, participantName) ||
                other.participantName == participantName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.paymentIntentId, paymentIntentId) ||
                other.paymentIntentId == paymentIntentId) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      tableBookingId,
      participantName,
      email,
      amount,
      paymentStatus,
      paymentIntentId,
      paidAt,
      createdAt);

  /// Create a copy of SplitPaymentParticipant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SplitPaymentParticipantImplCopyWith<_$SplitPaymentParticipantImpl>
      get copyWith => __$$SplitPaymentParticipantImplCopyWithImpl<
          _$SplitPaymentParticipantImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SplitPaymentParticipantImplToJson(
      this,
    );
  }
}

abstract class _SplitPaymentParticipant implements SplitPaymentParticipant {
  const factory _SplitPaymentParticipant(
      {required final String id,
      required final String tableBookingId,
      required final String participantName,
      required final String email,
      required final double amount,
      final String paymentStatus,
      final String? paymentIntentId,
      final DateTime? paidAt,
      final DateTime? createdAt}) = _$SplitPaymentParticipantImpl;

  factory _SplitPaymentParticipant.fromJson(Map<String, dynamic> json) =
      _$SplitPaymentParticipantImpl.fromJson;

  @override
  String get id;
  @override
  String get tableBookingId;
  @override
  String get participantName;
  @override
  String get email;
  @override
  double get amount;
  @override
  String get paymentStatus;
  @override
  String? get paymentIntentId;
  @override
  DateTime? get paidAt;
  @override
  DateTime? get createdAt;

  /// Create a copy of SplitPaymentParticipant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SplitPaymentParticipantImplCopyWith<_$SplitPaymentParticipantImpl>
      get copyWith => throw _privateConstructorUsedError;
}

EventConfiguration _$EventConfigurationFromJson(Map<String, dynamic> json) {
  return _EventConfiguration.fromJson(json);
}

/// @nodoc
mixin _$EventConfiguration {
  String get id => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  bool get enableGuestlistRsvp => throw _privateConstructorUsedError;
  bool get enableTableBooking => throw _privateConstructorUsedError;
  double get minTableDeposit => throw _privateConstructorUsedError;
  double get maxTableDeposit => throw _privateConstructorUsedError;
  int get minBottleRequirement => throw _privateConstructorUsedError;
  int get maxPartySize => throw _privateConstructorUsedError;
  double get serviceFeeRate => throw _privateConstructorUsedError;
  double get taxRate => throw _privateConstructorUsedError;
  List<String>? get availableTableIds => throw _privateConstructorUsedError;
  Map<String, dynamic>? get tableConfiguration =>
      throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this EventConfiguration to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EventConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventConfigurationCopyWith<EventConfiguration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventConfigurationCopyWith<$Res> {
  factory $EventConfigurationCopyWith(
          EventConfiguration value, $Res Function(EventConfiguration) then) =
      _$EventConfigurationCopyWithImpl<$Res, EventConfiguration>;
  @useResult
  $Res call(
      {String id,
      String eventId,
      bool enableGuestlistRsvp,
      bool enableTableBooking,
      double minTableDeposit,
      double maxTableDeposit,
      int minBottleRequirement,
      int maxPartySize,
      double serviceFeeRate,
      double taxRate,
      List<String>? availableTableIds,
      Map<String, dynamic>? tableConfiguration,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$EventConfigurationCopyWithImpl<$Res, $Val extends EventConfiguration>
    implements $EventConfigurationCopyWith<$Res> {
  _$EventConfigurationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? enableGuestlistRsvp = null,
    Object? enableTableBooking = null,
    Object? minTableDeposit = null,
    Object? maxTableDeposit = null,
    Object? minBottleRequirement = null,
    Object? maxPartySize = null,
    Object? serviceFeeRate = null,
    Object? taxRate = null,
    Object? availableTableIds = freezed,
    Object? tableConfiguration = freezed,
    Object? createdAt = freezed,
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
      enableGuestlistRsvp: null == enableGuestlistRsvp
          ? _value.enableGuestlistRsvp
          : enableGuestlistRsvp // ignore: cast_nullable_to_non_nullable
              as bool,
      enableTableBooking: null == enableTableBooking
          ? _value.enableTableBooking
          : enableTableBooking // ignore: cast_nullable_to_non_nullable
              as bool,
      minTableDeposit: null == minTableDeposit
          ? _value.minTableDeposit
          : minTableDeposit // ignore: cast_nullable_to_non_nullable
              as double,
      maxTableDeposit: null == maxTableDeposit
          ? _value.maxTableDeposit
          : maxTableDeposit // ignore: cast_nullable_to_non_nullable
              as double,
      minBottleRequirement: null == minBottleRequirement
          ? _value.minBottleRequirement
          : minBottleRequirement // ignore: cast_nullable_to_non_nullable
              as int,
      maxPartySize: null == maxPartySize
          ? _value.maxPartySize
          : maxPartySize // ignore: cast_nullable_to_non_nullable
              as int,
      serviceFeeRate: null == serviceFeeRate
          ? _value.serviceFeeRate
          : serviceFeeRate // ignore: cast_nullable_to_non_nullable
              as double,
      taxRate: null == taxRate
          ? _value.taxRate
          : taxRate // ignore: cast_nullable_to_non_nullable
              as double,
      availableTableIds: freezed == availableTableIds
          ? _value.availableTableIds
          : availableTableIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      tableConfiguration: freezed == tableConfiguration
          ? _value.tableConfiguration
          : tableConfiguration // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
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
abstract class _$$EventConfigurationImplCopyWith<$Res>
    implements $EventConfigurationCopyWith<$Res> {
  factory _$$EventConfigurationImplCopyWith(_$EventConfigurationImpl value,
          $Res Function(_$EventConfigurationImpl) then) =
      __$$EventConfigurationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String eventId,
      bool enableGuestlistRsvp,
      bool enableTableBooking,
      double minTableDeposit,
      double maxTableDeposit,
      int minBottleRequirement,
      int maxPartySize,
      double serviceFeeRate,
      double taxRate,
      List<String>? availableTableIds,
      Map<String, dynamic>? tableConfiguration,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$EventConfigurationImplCopyWithImpl<$Res>
    extends _$EventConfigurationCopyWithImpl<$Res, _$EventConfigurationImpl>
    implements _$$EventConfigurationImplCopyWith<$Res> {
  __$$EventConfigurationImplCopyWithImpl(_$EventConfigurationImpl _value,
      $Res Function(_$EventConfigurationImpl) _then)
      : super(_value, _then);

  /// Create a copy of EventConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? enableGuestlistRsvp = null,
    Object? enableTableBooking = null,
    Object? minTableDeposit = null,
    Object? maxTableDeposit = null,
    Object? minBottleRequirement = null,
    Object? maxPartySize = null,
    Object? serviceFeeRate = null,
    Object? taxRate = null,
    Object? availableTableIds = freezed,
    Object? tableConfiguration = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$EventConfigurationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      enableGuestlistRsvp: null == enableGuestlistRsvp
          ? _value.enableGuestlistRsvp
          : enableGuestlistRsvp // ignore: cast_nullable_to_non_nullable
              as bool,
      enableTableBooking: null == enableTableBooking
          ? _value.enableTableBooking
          : enableTableBooking // ignore: cast_nullable_to_non_nullable
              as bool,
      minTableDeposit: null == minTableDeposit
          ? _value.minTableDeposit
          : minTableDeposit // ignore: cast_nullable_to_non_nullable
              as double,
      maxTableDeposit: null == maxTableDeposit
          ? _value.maxTableDeposit
          : maxTableDeposit // ignore: cast_nullable_to_non_nullable
              as double,
      minBottleRequirement: null == minBottleRequirement
          ? _value.minBottleRequirement
          : minBottleRequirement // ignore: cast_nullable_to_non_nullable
              as int,
      maxPartySize: null == maxPartySize
          ? _value.maxPartySize
          : maxPartySize // ignore: cast_nullable_to_non_nullable
              as int,
      serviceFeeRate: null == serviceFeeRate
          ? _value.serviceFeeRate
          : serviceFeeRate // ignore: cast_nullable_to_non_nullable
              as double,
      taxRate: null == taxRate
          ? _value.taxRate
          : taxRate // ignore: cast_nullable_to_non_nullable
              as double,
      availableTableIds: freezed == availableTableIds
          ? _value._availableTableIds
          : availableTableIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      tableConfiguration: freezed == tableConfiguration
          ? _value._tableConfiguration
          : tableConfiguration // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
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
class _$EventConfigurationImpl implements _EventConfiguration {
  const _$EventConfigurationImpl(
      {required this.id,
      required this.eventId,
      this.enableGuestlistRsvp = true,
      this.enableTableBooking = true,
      this.minTableDeposit = 50.0,
      this.maxTableDeposit = 200.0,
      this.minBottleRequirement = 2,
      this.maxPartySize = 10,
      this.serviceFeeRate = 0.07,
      this.taxRate = 0.13,
      final List<String>? availableTableIds,
      final Map<String, dynamic>? tableConfiguration,
      this.createdAt,
      this.updatedAt})
      : _availableTableIds = availableTableIds,
        _tableConfiguration = tableConfiguration;

  factory _$EventConfigurationImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventConfigurationImplFromJson(json);

  @override
  final String id;
  @override
  final String eventId;
  @override
  @JsonKey()
  final bool enableGuestlistRsvp;
  @override
  @JsonKey()
  final bool enableTableBooking;
  @override
  @JsonKey()
  final double minTableDeposit;
  @override
  @JsonKey()
  final double maxTableDeposit;
  @override
  @JsonKey()
  final int minBottleRequirement;
  @override
  @JsonKey()
  final int maxPartySize;
  @override
  @JsonKey()
  final double serviceFeeRate;
  @override
  @JsonKey()
  final double taxRate;
  final List<String>? _availableTableIds;
  @override
  List<String>? get availableTableIds {
    final value = _availableTableIds;
    if (value == null) return null;
    if (_availableTableIds is EqualUnmodifiableListView)
      return _availableTableIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _tableConfiguration;
  @override
  Map<String, dynamic>? get tableConfiguration {
    final value = _tableConfiguration;
    if (value == null) return null;
    if (_tableConfiguration is EqualUnmodifiableMapView)
      return _tableConfiguration;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'EventConfiguration(id: $id, eventId: $eventId, enableGuestlistRsvp: $enableGuestlistRsvp, enableTableBooking: $enableTableBooking, minTableDeposit: $minTableDeposit, maxTableDeposit: $maxTableDeposit, minBottleRequirement: $minBottleRequirement, maxPartySize: $maxPartySize, serviceFeeRate: $serviceFeeRate, taxRate: $taxRate, availableTableIds: $availableTableIds, tableConfiguration: $tableConfiguration, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventConfigurationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.enableGuestlistRsvp, enableGuestlistRsvp) ||
                other.enableGuestlistRsvp == enableGuestlistRsvp) &&
            (identical(other.enableTableBooking, enableTableBooking) ||
                other.enableTableBooking == enableTableBooking) &&
            (identical(other.minTableDeposit, minTableDeposit) ||
                other.minTableDeposit == minTableDeposit) &&
            (identical(other.maxTableDeposit, maxTableDeposit) ||
                other.maxTableDeposit == maxTableDeposit) &&
            (identical(other.minBottleRequirement, minBottleRequirement) ||
                other.minBottleRequirement == minBottleRequirement) &&
            (identical(other.maxPartySize, maxPartySize) ||
                other.maxPartySize == maxPartySize) &&
            (identical(other.serviceFeeRate, serviceFeeRate) ||
                other.serviceFeeRate == serviceFeeRate) &&
            (identical(other.taxRate, taxRate) || other.taxRate == taxRate) &&
            const DeepCollectionEquality()
                .equals(other._availableTableIds, _availableTableIds) &&
            const DeepCollectionEquality()
                .equals(other._tableConfiguration, _tableConfiguration) &&
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
      enableGuestlistRsvp,
      enableTableBooking,
      minTableDeposit,
      maxTableDeposit,
      minBottleRequirement,
      maxPartySize,
      serviceFeeRate,
      taxRate,
      const DeepCollectionEquality().hash(_availableTableIds),
      const DeepCollectionEquality().hash(_tableConfiguration),
      createdAt,
      updatedAt);

  /// Create a copy of EventConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventConfigurationImplCopyWith<_$EventConfigurationImpl> get copyWith =>
      __$$EventConfigurationImplCopyWithImpl<_$EventConfigurationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventConfigurationImplToJson(
      this,
    );
  }
}

abstract class _EventConfiguration implements EventConfiguration {
  const factory _EventConfiguration(
      {required final String id,
      required final String eventId,
      final bool enableGuestlistRsvp,
      final bool enableTableBooking,
      final double minTableDeposit,
      final double maxTableDeposit,
      final int minBottleRequirement,
      final int maxPartySize,
      final double serviceFeeRate,
      final double taxRate,
      final List<String>? availableTableIds,
      final Map<String, dynamic>? tableConfiguration,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$EventConfigurationImpl;

  factory _EventConfiguration.fromJson(Map<String, dynamic> json) =
      _$EventConfigurationImpl.fromJson;

  @override
  String get id;
  @override
  String get eventId;
  @override
  bool get enableGuestlistRsvp;
  @override
  bool get enableTableBooking;
  @override
  double get minTableDeposit;
  @override
  double get maxTableDeposit;
  @override
  int get minBottleRequirement;
  @override
  int get maxPartySize;
  @override
  double get serviceFeeRate;
  @override
  double get taxRate;
  @override
  List<String>? get availableTableIds;
  @override
  Map<String, dynamic>? get tableConfiguration;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of EventConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventConfigurationImplCopyWith<_$EventConfigurationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
