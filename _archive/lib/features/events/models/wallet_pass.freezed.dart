// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_pass.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WalletPass _$WalletPassFromJson(Map<String, dynamic> json) {
  return _WalletPass.fromJson(json);
}

/// @nodoc
mixin _$WalletPass {
  String get id => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get bookingId => throw _privateConstructorUsedError;
  String get passType =>
      throw _privateConstructorUsedError; // 'rsvp' or 'table_booking'
  String get eventName => throw _privateConstructorUsedError;
  String get venueName => throw _privateConstructorUsedError;
  DateTime get eventDate => throw _privateConstructorUsedError;
  String get eventTime => throw _privateConstructorUsedError;
  String? get qrCodeData => throw _privateConstructorUsedError;
  String? get verificationCode => throw _privateConstructorUsedError;
  String? get tableNumber => throw _privateConstructorUsedError;
  int? get partySize => throw _privateConstructorUsedError;
  String? get passUrl => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this WalletPass to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WalletPass
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalletPassCopyWith<WalletPass> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletPassCopyWith<$Res> {
  factory $WalletPassCopyWith(
          WalletPass value, $Res Function(WalletPass) then) =
      _$WalletPassCopyWithImpl<$Res, WalletPass>;
  @useResult
  $Res call(
      {String id,
      String eventId,
      String userId,
      String bookingId,
      String passType,
      String eventName,
      String venueName,
      DateTime eventDate,
      String eventTime,
      String? qrCodeData,
      String? verificationCode,
      String? tableNumber,
      int? partySize,
      String? passUrl,
      DateTime? createdAt});
}

/// @nodoc
class _$WalletPassCopyWithImpl<$Res, $Val extends WalletPass>
    implements $WalletPassCopyWith<$Res> {
  _$WalletPassCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WalletPass
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? userId = null,
    Object? bookingId = null,
    Object? passType = null,
    Object? eventName = null,
    Object? venueName = null,
    Object? eventDate = null,
    Object? eventTime = null,
    Object? qrCodeData = freezed,
    Object? verificationCode = freezed,
    Object? tableNumber = freezed,
    Object? partySize = freezed,
    Object? passUrl = freezed,
    Object? createdAt = freezed,
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
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      passType: null == passType
          ? _value.passType
          : passType // ignore: cast_nullable_to_non_nullable
              as String,
      eventName: null == eventName
          ? _value.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String,
      venueName: null == venueName
          ? _value.venueName
          : venueName // ignore: cast_nullable_to_non_nullable
              as String,
      eventDate: null == eventDate
          ? _value.eventDate
          : eventDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      eventTime: null == eventTime
          ? _value.eventTime
          : eventTime // ignore: cast_nullable_to_non_nullable
              as String,
      qrCodeData: freezed == qrCodeData
          ? _value.qrCodeData
          : qrCodeData // ignore: cast_nullable_to_non_nullable
              as String?,
      verificationCode: freezed == verificationCode
          ? _value.verificationCode
          : verificationCode // ignore: cast_nullable_to_non_nullable
              as String?,
      tableNumber: freezed == tableNumber
          ? _value.tableNumber
          : tableNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      partySize: freezed == partySize
          ? _value.partySize
          : partySize // ignore: cast_nullable_to_non_nullable
              as int?,
      passUrl: freezed == passUrl
          ? _value.passUrl
          : passUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WalletPassImplCopyWith<$Res>
    implements $WalletPassCopyWith<$Res> {
  factory _$$WalletPassImplCopyWith(
          _$WalletPassImpl value, $Res Function(_$WalletPassImpl) then) =
      __$$WalletPassImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String eventId,
      String userId,
      String bookingId,
      String passType,
      String eventName,
      String venueName,
      DateTime eventDate,
      String eventTime,
      String? qrCodeData,
      String? verificationCode,
      String? tableNumber,
      int? partySize,
      String? passUrl,
      DateTime? createdAt});
}

/// @nodoc
class __$$WalletPassImplCopyWithImpl<$Res>
    extends _$WalletPassCopyWithImpl<$Res, _$WalletPassImpl>
    implements _$$WalletPassImplCopyWith<$Res> {
  __$$WalletPassImplCopyWithImpl(
      _$WalletPassImpl _value, $Res Function(_$WalletPassImpl) _then)
      : super(_value, _then);

  /// Create a copy of WalletPass
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? userId = null,
    Object? bookingId = null,
    Object? passType = null,
    Object? eventName = null,
    Object? venueName = null,
    Object? eventDate = null,
    Object? eventTime = null,
    Object? qrCodeData = freezed,
    Object? verificationCode = freezed,
    Object? tableNumber = freezed,
    Object? partySize = freezed,
    Object? passUrl = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$WalletPassImpl(
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
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      passType: null == passType
          ? _value.passType
          : passType // ignore: cast_nullable_to_non_nullable
              as String,
      eventName: null == eventName
          ? _value.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String,
      venueName: null == venueName
          ? _value.venueName
          : venueName // ignore: cast_nullable_to_non_nullable
              as String,
      eventDate: null == eventDate
          ? _value.eventDate
          : eventDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      eventTime: null == eventTime
          ? _value.eventTime
          : eventTime // ignore: cast_nullable_to_non_nullable
              as String,
      qrCodeData: freezed == qrCodeData
          ? _value.qrCodeData
          : qrCodeData // ignore: cast_nullable_to_non_nullable
              as String?,
      verificationCode: freezed == verificationCode
          ? _value.verificationCode
          : verificationCode // ignore: cast_nullable_to_non_nullable
              as String?,
      tableNumber: freezed == tableNumber
          ? _value.tableNumber
          : tableNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      partySize: freezed == partySize
          ? _value.partySize
          : partySize // ignore: cast_nullable_to_non_nullable
              as int?,
      passUrl: freezed == passUrl
          ? _value.passUrl
          : passUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletPassImpl implements _WalletPass {
  const _$WalletPassImpl(
      {required this.id,
      required this.eventId,
      required this.userId,
      required this.bookingId,
      required this.passType,
      required this.eventName,
      required this.venueName,
      required this.eventDate,
      required this.eventTime,
      this.qrCodeData,
      this.verificationCode,
      this.tableNumber,
      this.partySize,
      this.passUrl,
      this.createdAt});

  factory _$WalletPassImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletPassImplFromJson(json);

  @override
  final String id;
  @override
  final String eventId;
  @override
  final String userId;
  @override
  final String bookingId;
  @override
  final String passType;
// 'rsvp' or 'table_booking'
  @override
  final String eventName;
  @override
  final String venueName;
  @override
  final DateTime eventDate;
  @override
  final String eventTime;
  @override
  final String? qrCodeData;
  @override
  final String? verificationCode;
  @override
  final String? tableNumber;
  @override
  final int? partySize;
  @override
  final String? passUrl;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'WalletPass(id: $id, eventId: $eventId, userId: $userId, bookingId: $bookingId, passType: $passType, eventName: $eventName, venueName: $venueName, eventDate: $eventDate, eventTime: $eventTime, qrCodeData: $qrCodeData, verificationCode: $verificationCode, tableNumber: $tableNumber, partySize: $partySize, passUrl: $passUrl, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletPassImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.passType, passType) ||
                other.passType == passType) &&
            (identical(other.eventName, eventName) ||
                other.eventName == eventName) &&
            (identical(other.venueName, venueName) ||
                other.venueName == venueName) &&
            (identical(other.eventDate, eventDate) ||
                other.eventDate == eventDate) &&
            (identical(other.eventTime, eventTime) ||
                other.eventTime == eventTime) &&
            (identical(other.qrCodeData, qrCodeData) ||
                other.qrCodeData == qrCodeData) &&
            (identical(other.verificationCode, verificationCode) ||
                other.verificationCode == verificationCode) &&
            (identical(other.tableNumber, tableNumber) ||
                other.tableNumber == tableNumber) &&
            (identical(other.partySize, partySize) ||
                other.partySize == partySize) &&
            (identical(other.passUrl, passUrl) || other.passUrl == passUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      eventId,
      userId,
      bookingId,
      passType,
      eventName,
      venueName,
      eventDate,
      eventTime,
      qrCodeData,
      verificationCode,
      tableNumber,
      partySize,
      passUrl,
      createdAt);

  /// Create a copy of WalletPass
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletPassImplCopyWith<_$WalletPassImpl> get copyWith =>
      __$$WalletPassImplCopyWithImpl<_$WalletPassImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletPassImplToJson(
      this,
    );
  }
}

abstract class _WalletPass implements WalletPass {
  const factory _WalletPass(
      {required final String id,
      required final String eventId,
      required final String userId,
      required final String bookingId,
      required final String passType,
      required final String eventName,
      required final String venueName,
      required final DateTime eventDate,
      required final String eventTime,
      final String? qrCodeData,
      final String? verificationCode,
      final String? tableNumber,
      final int? partySize,
      final String? passUrl,
      final DateTime? createdAt}) = _$WalletPassImpl;

  factory _WalletPass.fromJson(Map<String, dynamic> json) =
      _$WalletPassImpl.fromJson;

  @override
  String get id;
  @override
  String get eventId;
  @override
  String get userId;
  @override
  String get bookingId;
  @override
  String get passType; // 'rsvp' or 'table_booking'
  @override
  String get eventName;
  @override
  String get venueName;
  @override
  DateTime get eventDate;
  @override
  String get eventTime;
  @override
  String? get qrCodeData;
  @override
  String? get verificationCode;
  @override
  String? get tableNumber;
  @override
  int? get partySize;
  @override
  String? get passUrl;
  @override
  DateTime? get createdAt;

  /// Create a copy of WalletPass
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalletPassImplCopyWith<_$WalletPassImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
