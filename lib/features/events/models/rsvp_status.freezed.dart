// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rsvp_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EnhancedEventRSVP _$EnhancedEventRSVPFromJson(Map<String, dynamic> json) {
  return _EnhancedEventRSVP.fromJson(json);
}

/// @nodoc
mixin _$EnhancedEventRSVP {
  String get id => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String? get userAvatar => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  RsvpResponse get response => throw _privateConstructorUsedError;
  bool get plusOneEnabled => throw _privateConstructorUsedError;
  String? get plusOneName => throw _privateConstructorUsedError;
  String? get specialRequests => throw _privateConstructorUsedError;
  String? get verificationCode => throw _privateConstructorUsedError;
  String? get qrCodeData => throw _privateConstructorUsedError;
  bool get isAttended => throw _privateConstructorUsedError;
  bool get isVisible => throw _privateConstructorUsedError;
  DateTime? get respondedAt => throw _privateConstructorUsedError;
  DateTime? get verifiedAt => throw _privateConstructorUsedError;
  String? get verifiedBy => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this EnhancedEventRSVP to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EnhancedEventRSVP
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EnhancedEventRSVPCopyWith<EnhancedEventRSVP> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EnhancedEventRSVPCopyWith<$Res> {
  factory $EnhancedEventRSVPCopyWith(
          EnhancedEventRSVP value, $Res Function(EnhancedEventRSVP) then) =
      _$EnhancedEventRSVPCopyWithImpl<$Res, EnhancedEventRSVP>;
  @useResult
  $Res call(
      {String id,
      String eventId,
      String userId,
      String userName,
      String? userAvatar,
      String email,
      String? phone,
      RsvpResponse response,
      bool plusOneEnabled,
      String? plusOneName,
      String? specialRequests,
      String? verificationCode,
      String? qrCodeData,
      bool isAttended,
      bool isVisible,
      DateTime? respondedAt,
      DateTime? verifiedAt,
      String? verifiedBy,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$EnhancedEventRSVPCopyWithImpl<$Res, $Val extends EnhancedEventRSVP>
    implements $EnhancedEventRSVPCopyWith<$Res> {
  _$EnhancedEventRSVPCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EnhancedEventRSVP
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? userId = null,
    Object? userName = null,
    Object? userAvatar = freezed,
    Object? email = null,
    Object? phone = freezed,
    Object? response = null,
    Object? plusOneEnabled = null,
    Object? plusOneName = freezed,
    Object? specialRequests = freezed,
    Object? verificationCode = freezed,
    Object? qrCodeData = freezed,
    Object? isAttended = null,
    Object? isVisible = null,
    Object? respondedAt = freezed,
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
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userAvatar: freezed == userAvatar
          ? _value.userAvatar
          : userAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      response: null == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as RsvpResponse,
      plusOneEnabled: null == plusOneEnabled
          ? _value.plusOneEnabled
          : plusOneEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      plusOneName: freezed == plusOneName
          ? _value.plusOneName
          : plusOneName // ignore: cast_nullable_to_non_nullable
              as String?,
      specialRequests: freezed == specialRequests
          ? _value.specialRequests
          : specialRequests // ignore: cast_nullable_to_non_nullable
              as String?,
      verificationCode: freezed == verificationCode
          ? _value.verificationCode
          : verificationCode // ignore: cast_nullable_to_non_nullable
              as String?,
      qrCodeData: freezed == qrCodeData
          ? _value.qrCodeData
          : qrCodeData // ignore: cast_nullable_to_non_nullable
              as String?,
      isAttended: null == isAttended
          ? _value.isAttended
          : isAttended // ignore: cast_nullable_to_non_nullable
              as bool,
      isVisible: null == isVisible
          ? _value.isVisible
          : isVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
abstract class _$$EnhancedEventRSVPImplCopyWith<$Res>
    implements $EnhancedEventRSVPCopyWith<$Res> {
  factory _$$EnhancedEventRSVPImplCopyWith(_$EnhancedEventRSVPImpl value,
          $Res Function(_$EnhancedEventRSVPImpl) then) =
      __$$EnhancedEventRSVPImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String eventId,
      String userId,
      String userName,
      String? userAvatar,
      String email,
      String? phone,
      RsvpResponse response,
      bool plusOneEnabled,
      String? plusOneName,
      String? specialRequests,
      String? verificationCode,
      String? qrCodeData,
      bool isAttended,
      bool isVisible,
      DateTime? respondedAt,
      DateTime? verifiedAt,
      String? verifiedBy,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$EnhancedEventRSVPImplCopyWithImpl<$Res>
    extends _$EnhancedEventRSVPCopyWithImpl<$Res, _$EnhancedEventRSVPImpl>
    implements _$$EnhancedEventRSVPImplCopyWith<$Res> {
  __$$EnhancedEventRSVPImplCopyWithImpl(_$EnhancedEventRSVPImpl _value,
      $Res Function(_$EnhancedEventRSVPImpl) _then)
      : super(_value, _then);

  /// Create a copy of EnhancedEventRSVP
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? userId = null,
    Object? userName = null,
    Object? userAvatar = freezed,
    Object? email = null,
    Object? phone = freezed,
    Object? response = null,
    Object? plusOneEnabled = null,
    Object? plusOneName = freezed,
    Object? specialRequests = freezed,
    Object? verificationCode = freezed,
    Object? qrCodeData = freezed,
    Object? isAttended = null,
    Object? isVisible = null,
    Object? respondedAt = freezed,
    Object? verifiedAt = freezed,
    Object? verifiedBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$EnhancedEventRSVPImpl(
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
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      response: null == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as RsvpResponse,
      plusOneEnabled: null == plusOneEnabled
          ? _value.plusOneEnabled
          : plusOneEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      plusOneName: freezed == plusOneName
          ? _value.plusOneName
          : plusOneName // ignore: cast_nullable_to_non_nullable
              as String?,
      specialRequests: freezed == specialRequests
          ? _value.specialRequests
          : specialRequests // ignore: cast_nullable_to_non_nullable
              as String?,
      verificationCode: freezed == verificationCode
          ? _value.verificationCode
          : verificationCode // ignore: cast_nullable_to_non_nullable
              as String?,
      qrCodeData: freezed == qrCodeData
          ? _value.qrCodeData
          : qrCodeData // ignore: cast_nullable_to_non_nullable
              as String?,
      isAttended: null == isAttended
          ? _value.isAttended
          : isAttended // ignore: cast_nullable_to_non_nullable
              as bool,
      isVisible: null == isVisible
          ? _value.isVisible
          : isVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
class _$EnhancedEventRSVPImpl implements _EnhancedEventRSVP {
  const _$EnhancedEventRSVPImpl(
      {required this.id,
      required this.eventId,
      required this.userId,
      required this.userName,
      this.userAvatar,
      required this.email,
      this.phone,
      required this.response,
      this.plusOneEnabled = false,
      this.plusOneName,
      this.specialRequests,
      this.verificationCode,
      this.qrCodeData,
      this.isAttended = false,
      this.isVisible = false,
      this.respondedAt,
      this.verifiedAt,
      this.verifiedBy,
      this.createdAt,
      this.updatedAt});

  factory _$EnhancedEventRSVPImpl.fromJson(Map<String, dynamic> json) =>
      _$$EnhancedEventRSVPImplFromJson(json);

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
  final String email;
  @override
  final String? phone;
  @override
  final RsvpResponse response;
  @override
  @JsonKey()
  final bool plusOneEnabled;
  @override
  final String? plusOneName;
  @override
  final String? specialRequests;
  @override
  final String? verificationCode;
  @override
  final String? qrCodeData;
  @override
  @JsonKey()
  final bool isAttended;
  @override
  @JsonKey()
  final bool isVisible;
  @override
  final DateTime? respondedAt;
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
    return 'EnhancedEventRSVP(id: $id, eventId: $eventId, userId: $userId, userName: $userName, userAvatar: $userAvatar, email: $email, phone: $phone, response: $response, plusOneEnabled: $plusOneEnabled, plusOneName: $plusOneName, specialRequests: $specialRequests, verificationCode: $verificationCode, qrCodeData: $qrCodeData, isAttended: $isAttended, isVisible: $isVisible, respondedAt: $respondedAt, verifiedAt: $verifiedAt, verifiedBy: $verifiedBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EnhancedEventRSVPImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userAvatar, userAvatar) ||
                other.userAvatar == userAvatar) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.response, response) ||
                other.response == response) &&
            (identical(other.plusOneEnabled, plusOneEnabled) ||
                other.plusOneEnabled == plusOneEnabled) &&
            (identical(other.plusOneName, plusOneName) ||
                other.plusOneName == plusOneName) &&
            (identical(other.specialRequests, specialRequests) ||
                other.specialRequests == specialRequests) &&
            (identical(other.verificationCode, verificationCode) ||
                other.verificationCode == verificationCode) &&
            (identical(other.qrCodeData, qrCodeData) ||
                other.qrCodeData == qrCodeData) &&
            (identical(other.isAttended, isAttended) ||
                other.isAttended == isAttended) &&
            (identical(other.isVisible, isVisible) ||
                other.isVisible == isVisible) &&
            (identical(other.respondedAt, respondedAt) ||
                other.respondedAt == respondedAt) &&
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
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        eventId,
        userId,
        userName,
        userAvatar,
        email,
        phone,
        response,
        plusOneEnabled,
        plusOneName,
        specialRequests,
        verificationCode,
        qrCodeData,
        isAttended,
        isVisible,
        respondedAt,
        verifiedAt,
        verifiedBy,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of EnhancedEventRSVP
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EnhancedEventRSVPImplCopyWith<_$EnhancedEventRSVPImpl> get copyWith =>
      __$$EnhancedEventRSVPImplCopyWithImpl<_$EnhancedEventRSVPImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EnhancedEventRSVPImplToJson(
      this,
    );
  }
}

abstract class _EnhancedEventRSVP implements EnhancedEventRSVP {
  const factory _EnhancedEventRSVP(
      {required final String id,
      required final String eventId,
      required final String userId,
      required final String userName,
      final String? userAvatar,
      required final String email,
      final String? phone,
      required final RsvpResponse response,
      final bool plusOneEnabled,
      final String? plusOneName,
      final String? specialRequests,
      final String? verificationCode,
      final String? qrCodeData,
      final bool isAttended,
      final bool isVisible,
      final DateTime? respondedAt,
      final DateTime? verifiedAt,
      final String? verifiedBy,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$EnhancedEventRSVPImpl;

  factory _EnhancedEventRSVP.fromJson(Map<String, dynamic> json) =
      _$EnhancedEventRSVPImpl.fromJson;

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
  String get email;
  @override
  String? get phone;
  @override
  RsvpResponse get response;
  @override
  bool get plusOneEnabled;
  @override
  String? get plusOneName;
  @override
  String? get specialRequests;
  @override
  String? get verificationCode;
  @override
  String? get qrCodeData;
  @override
  bool get isAttended;
  @override
  bool get isVisible;
  @override
  DateTime? get respondedAt;
  @override
  DateTime? get verifiedAt;
  @override
  String? get verifiedBy;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of EnhancedEventRSVP
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EnhancedEventRSVPImplCopyWith<_$EnhancedEventRSVPImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RsvpCounts _$RsvpCountsFromJson(Map<String, dynamic> json) {
  return _RsvpCounts.fromJson(json);
}

/// @nodoc
mixin _$RsvpCounts {
  int get going => throw _privateConstructorUsedError;
  int get maybe => throw _privateConstructorUsedError;
  int get notGoing => throw _privateConstructorUsedError;
  int get notResponded => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get plusOnes => throw _privateConstructorUsedError;

  /// Serializes this RsvpCounts to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RsvpCounts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RsvpCountsCopyWith<RsvpCounts> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RsvpCountsCopyWith<$Res> {
  factory $RsvpCountsCopyWith(
          RsvpCounts value, $Res Function(RsvpCounts) then) =
      _$RsvpCountsCopyWithImpl<$Res, RsvpCounts>;
  @useResult
  $Res call(
      {int going,
      int maybe,
      int notGoing,
      int notResponded,
      int total,
      int plusOnes});
}

/// @nodoc
class _$RsvpCountsCopyWithImpl<$Res, $Val extends RsvpCounts>
    implements $RsvpCountsCopyWith<$Res> {
  _$RsvpCountsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RsvpCounts
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? going = null,
    Object? maybe = null,
    Object? notGoing = null,
    Object? notResponded = null,
    Object? total = null,
    Object? plusOnes = null,
  }) {
    return _then(_value.copyWith(
      going: null == going
          ? _value.going
          : going // ignore: cast_nullable_to_non_nullable
              as int,
      maybe: null == maybe
          ? _value.maybe
          : maybe // ignore: cast_nullable_to_non_nullable
              as int,
      notGoing: null == notGoing
          ? _value.notGoing
          : notGoing // ignore: cast_nullable_to_non_nullable
              as int,
      notResponded: null == notResponded
          ? _value.notResponded
          : notResponded // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      plusOnes: null == plusOnes
          ? _value.plusOnes
          : plusOnes // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RsvpCountsImplCopyWith<$Res>
    implements $RsvpCountsCopyWith<$Res> {
  factory _$$RsvpCountsImplCopyWith(
          _$RsvpCountsImpl value, $Res Function(_$RsvpCountsImpl) then) =
      __$$RsvpCountsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int going,
      int maybe,
      int notGoing,
      int notResponded,
      int total,
      int plusOnes});
}

/// @nodoc
class __$$RsvpCountsImplCopyWithImpl<$Res>
    extends _$RsvpCountsCopyWithImpl<$Res, _$RsvpCountsImpl>
    implements _$$RsvpCountsImplCopyWith<$Res> {
  __$$RsvpCountsImplCopyWithImpl(
      _$RsvpCountsImpl _value, $Res Function(_$RsvpCountsImpl) _then)
      : super(_value, _then);

  /// Create a copy of RsvpCounts
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? going = null,
    Object? maybe = null,
    Object? notGoing = null,
    Object? notResponded = null,
    Object? total = null,
    Object? plusOnes = null,
  }) {
    return _then(_$RsvpCountsImpl(
      going: null == going
          ? _value.going
          : going // ignore: cast_nullable_to_non_nullable
              as int,
      maybe: null == maybe
          ? _value.maybe
          : maybe // ignore: cast_nullable_to_non_nullable
              as int,
      notGoing: null == notGoing
          ? _value.notGoing
          : notGoing // ignore: cast_nullable_to_non_nullable
              as int,
      notResponded: null == notResponded
          ? _value.notResponded
          : notResponded // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      plusOnes: null == plusOnes
          ? _value.plusOnes
          : plusOnes // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RsvpCountsImpl implements _RsvpCounts {
  const _$RsvpCountsImpl(
      {this.going = 0,
      this.maybe = 0,
      this.notGoing = 0,
      this.notResponded = 0,
      this.total = 0,
      this.plusOnes = 0});

  factory _$RsvpCountsImpl.fromJson(Map<String, dynamic> json) =>
      _$$RsvpCountsImplFromJson(json);

  @override
  @JsonKey()
  final int going;
  @override
  @JsonKey()
  final int maybe;
  @override
  @JsonKey()
  final int notGoing;
  @override
  @JsonKey()
  final int notResponded;
  @override
  @JsonKey()
  final int total;
  @override
  @JsonKey()
  final int plusOnes;

  @override
  String toString() {
    return 'RsvpCounts(going: $going, maybe: $maybe, notGoing: $notGoing, notResponded: $notResponded, total: $total, plusOnes: $plusOnes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RsvpCountsImpl &&
            (identical(other.going, going) || other.going == going) &&
            (identical(other.maybe, maybe) || other.maybe == maybe) &&
            (identical(other.notGoing, notGoing) ||
                other.notGoing == notGoing) &&
            (identical(other.notResponded, notResponded) ||
                other.notResponded == notResponded) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.plusOnes, plusOnes) ||
                other.plusOnes == plusOnes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, going, maybe, notGoing, notResponded, total, plusOnes);

  /// Create a copy of RsvpCounts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RsvpCountsImplCopyWith<_$RsvpCountsImpl> get copyWith =>
      __$$RsvpCountsImplCopyWithImpl<_$RsvpCountsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RsvpCountsImplToJson(
      this,
    );
  }
}

abstract class _RsvpCounts implements RsvpCounts {
  const factory _RsvpCounts(
      {final int going,
      final int maybe,
      final int notGoing,
      final int notResponded,
      final int total,
      final int plusOnes}) = _$RsvpCountsImpl;

  factory _RsvpCounts.fromJson(Map<String, dynamic> json) =
      _$RsvpCountsImpl.fromJson;

  @override
  int get going;
  @override
  int get maybe;
  @override
  int get notGoing;
  @override
  int get notResponded;
  @override
  int get total;
  @override
  int get plusOnes;

  /// Create a copy of RsvpCounts
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RsvpCountsImplCopyWith<_$RsvpCountsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GuestListVisibility _$GuestListVisibilityFromJson(Map<String, dynamic> json) {
  return _GuestListVisibility.fromJson(json);
}

/// @nodoc
mixin _$GuestListVisibility {
  String get eventId => throw _privateConstructorUsedError;
  bool get showGuestList => throw _privateConstructorUsedError;
  bool get showRsvpCount => throw _privateConstructorUsedError;
  bool get showPlusOnes => throw _privateConstructorUsedError;
  bool get onlyShowConfirmed => throw _privateConstructorUsedError;

  /// Serializes this GuestListVisibility to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GuestListVisibility
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GuestListVisibilityCopyWith<GuestListVisibility> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GuestListVisibilityCopyWith<$Res> {
  factory $GuestListVisibilityCopyWith(
          GuestListVisibility value, $Res Function(GuestListVisibility) then) =
      _$GuestListVisibilityCopyWithImpl<$Res, GuestListVisibility>;
  @useResult
  $Res call(
      {String eventId,
      bool showGuestList,
      bool showRsvpCount,
      bool showPlusOnes,
      bool onlyShowConfirmed});
}

/// @nodoc
class _$GuestListVisibilityCopyWithImpl<$Res, $Val extends GuestListVisibility>
    implements $GuestListVisibilityCopyWith<$Res> {
  _$GuestListVisibilityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GuestListVisibility
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? showGuestList = null,
    Object? showRsvpCount = null,
    Object? showPlusOnes = null,
    Object? onlyShowConfirmed = null,
  }) {
    return _then(_value.copyWith(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      showGuestList: null == showGuestList
          ? _value.showGuestList
          : showGuestList // ignore: cast_nullable_to_non_nullable
              as bool,
      showRsvpCount: null == showRsvpCount
          ? _value.showRsvpCount
          : showRsvpCount // ignore: cast_nullable_to_non_nullable
              as bool,
      showPlusOnes: null == showPlusOnes
          ? _value.showPlusOnes
          : showPlusOnes // ignore: cast_nullable_to_non_nullable
              as bool,
      onlyShowConfirmed: null == onlyShowConfirmed
          ? _value.onlyShowConfirmed
          : onlyShowConfirmed // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GuestListVisibilityImplCopyWith<$Res>
    implements $GuestListVisibilityCopyWith<$Res> {
  factory _$$GuestListVisibilityImplCopyWith(_$GuestListVisibilityImpl value,
          $Res Function(_$GuestListVisibilityImpl) then) =
      __$$GuestListVisibilityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String eventId,
      bool showGuestList,
      bool showRsvpCount,
      bool showPlusOnes,
      bool onlyShowConfirmed});
}

/// @nodoc
class __$$GuestListVisibilityImplCopyWithImpl<$Res>
    extends _$GuestListVisibilityCopyWithImpl<$Res, _$GuestListVisibilityImpl>
    implements _$$GuestListVisibilityImplCopyWith<$Res> {
  __$$GuestListVisibilityImplCopyWithImpl(_$GuestListVisibilityImpl _value,
      $Res Function(_$GuestListVisibilityImpl) _then)
      : super(_value, _then);

  /// Create a copy of GuestListVisibility
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? showGuestList = null,
    Object? showRsvpCount = null,
    Object? showPlusOnes = null,
    Object? onlyShowConfirmed = null,
  }) {
    return _then(_$GuestListVisibilityImpl(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      showGuestList: null == showGuestList
          ? _value.showGuestList
          : showGuestList // ignore: cast_nullable_to_non_nullable
              as bool,
      showRsvpCount: null == showRsvpCount
          ? _value.showRsvpCount
          : showRsvpCount // ignore: cast_nullable_to_non_nullable
              as bool,
      showPlusOnes: null == showPlusOnes
          ? _value.showPlusOnes
          : showPlusOnes // ignore: cast_nullable_to_non_nullable
              as bool,
      onlyShowConfirmed: null == onlyShowConfirmed
          ? _value.onlyShowConfirmed
          : onlyShowConfirmed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GuestListVisibilityImpl implements _GuestListVisibility {
  const _$GuestListVisibilityImpl(
      {required this.eventId,
      this.showGuestList = true,
      this.showRsvpCount = true,
      this.showPlusOnes = false,
      this.onlyShowConfirmed = false});

  factory _$GuestListVisibilityImpl.fromJson(Map<String, dynamic> json) =>
      _$$GuestListVisibilityImplFromJson(json);

  @override
  final String eventId;
  @override
  @JsonKey()
  final bool showGuestList;
  @override
  @JsonKey()
  final bool showRsvpCount;
  @override
  @JsonKey()
  final bool showPlusOnes;
  @override
  @JsonKey()
  final bool onlyShowConfirmed;

  @override
  String toString() {
    return 'GuestListVisibility(eventId: $eventId, showGuestList: $showGuestList, showRsvpCount: $showRsvpCount, showPlusOnes: $showPlusOnes, onlyShowConfirmed: $onlyShowConfirmed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GuestListVisibilityImpl &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.showGuestList, showGuestList) ||
                other.showGuestList == showGuestList) &&
            (identical(other.showRsvpCount, showRsvpCount) ||
                other.showRsvpCount == showRsvpCount) &&
            (identical(other.showPlusOnes, showPlusOnes) ||
                other.showPlusOnes == showPlusOnes) &&
            (identical(other.onlyShowConfirmed, onlyShowConfirmed) ||
                other.onlyShowConfirmed == onlyShowConfirmed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, eventId, showGuestList,
      showRsvpCount, showPlusOnes, onlyShowConfirmed);

  /// Create a copy of GuestListVisibility
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GuestListVisibilityImplCopyWith<_$GuestListVisibilityImpl> get copyWith =>
      __$$GuestListVisibilityImplCopyWithImpl<_$GuestListVisibilityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GuestListVisibilityImplToJson(
      this,
    );
  }
}

abstract class _GuestListVisibility implements GuestListVisibility {
  const factory _GuestListVisibility(
      {required final String eventId,
      final bool showGuestList,
      final bool showRsvpCount,
      final bool showPlusOnes,
      final bool onlyShowConfirmed}) = _$GuestListVisibilityImpl;

  factory _GuestListVisibility.fromJson(Map<String, dynamic> json) =
      _$GuestListVisibilityImpl.fromJson;

  @override
  String get eventId;
  @override
  bool get showGuestList;
  @override
  bool get showRsvpCount;
  @override
  bool get showPlusOnes;
  @override
  bool get onlyShowConfirmed;

  /// Create a copy of GuestListVisibility
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GuestListVisibilityImplCopyWith<_$GuestListVisibilityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FriendAttending _$FriendAttendingFromJson(Map<String, dynamic> json) {
  return _FriendAttending.fromJson(json);
}

/// @nodoc
mixin _$FriendAttending {
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String? get userAvatar => throw _privateConstructorUsedError;
  RsvpResponse get response => throw _privateConstructorUsedError;
  bool get plusOneEnabled => throw _privateConstructorUsedError;
  DateTime? get respondedAt => throw _privateConstructorUsedError;

  /// Serializes this FriendAttending to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FriendAttending
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendAttendingCopyWith<FriendAttending> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendAttendingCopyWith<$Res> {
  factory $FriendAttendingCopyWith(
          FriendAttending value, $Res Function(FriendAttending) then) =
      _$FriendAttendingCopyWithImpl<$Res, FriendAttending>;
  @useResult
  $Res call(
      {String userId,
      String userName,
      String? userAvatar,
      RsvpResponse response,
      bool plusOneEnabled,
      DateTime? respondedAt});
}

/// @nodoc
class _$FriendAttendingCopyWithImpl<$Res, $Val extends FriendAttending>
    implements $FriendAttendingCopyWith<$Res> {
  _$FriendAttendingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FriendAttending
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userName = null,
    Object? userAvatar = freezed,
    Object? response = null,
    Object? plusOneEnabled = null,
    Object? respondedAt = freezed,
  }) {
    return _then(_value.copyWith(
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
      response: null == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as RsvpResponse,
      plusOneEnabled: null == plusOneEnabled
          ? _value.plusOneEnabled
          : plusOneEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FriendAttendingImplCopyWith<$Res>
    implements $FriendAttendingCopyWith<$Res> {
  factory _$$FriendAttendingImplCopyWith(_$FriendAttendingImpl value,
          $Res Function(_$FriendAttendingImpl) then) =
      __$$FriendAttendingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String userName,
      String? userAvatar,
      RsvpResponse response,
      bool plusOneEnabled,
      DateTime? respondedAt});
}

/// @nodoc
class __$$FriendAttendingImplCopyWithImpl<$Res>
    extends _$FriendAttendingCopyWithImpl<$Res, _$FriendAttendingImpl>
    implements _$$FriendAttendingImplCopyWith<$Res> {
  __$$FriendAttendingImplCopyWithImpl(
      _$FriendAttendingImpl _value, $Res Function(_$FriendAttendingImpl) _then)
      : super(_value, _then);

  /// Create a copy of FriendAttending
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userName = null,
    Object? userAvatar = freezed,
    Object? response = null,
    Object? plusOneEnabled = null,
    Object? respondedAt = freezed,
  }) {
    return _then(_$FriendAttendingImpl(
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
      response: null == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as RsvpResponse,
      plusOneEnabled: null == plusOneEnabled
          ? _value.plusOneEnabled
          : plusOneEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FriendAttendingImpl implements _FriendAttending {
  const _$FriendAttendingImpl(
      {required this.userId,
      required this.userName,
      this.userAvatar,
      required this.response,
      this.plusOneEnabled = false,
      this.respondedAt});

  factory _$FriendAttendingImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendAttendingImplFromJson(json);

  @override
  final String userId;
  @override
  final String userName;
  @override
  final String? userAvatar;
  @override
  final RsvpResponse response;
  @override
  @JsonKey()
  final bool plusOneEnabled;
  @override
  final DateTime? respondedAt;

  @override
  String toString() {
    return 'FriendAttending(userId: $userId, userName: $userName, userAvatar: $userAvatar, response: $response, plusOneEnabled: $plusOneEnabled, respondedAt: $respondedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendAttendingImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userAvatar, userAvatar) ||
                other.userAvatar == userAvatar) &&
            (identical(other.response, response) ||
                other.response == response) &&
            (identical(other.plusOneEnabled, plusOneEnabled) ||
                other.plusOneEnabled == plusOneEnabled) &&
            (identical(other.respondedAt, respondedAt) ||
                other.respondedAt == respondedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, userName, userAvatar,
      response, plusOneEnabled, respondedAt);

  /// Create a copy of FriendAttending
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendAttendingImplCopyWith<_$FriendAttendingImpl> get copyWith =>
      __$$FriendAttendingImplCopyWithImpl<_$FriendAttendingImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendAttendingImplToJson(
      this,
    );
  }
}

abstract class _FriendAttending implements FriendAttending {
  const factory _FriendAttending(
      {required final String userId,
      required final String userName,
      final String? userAvatar,
      required final RsvpResponse response,
      final bool plusOneEnabled,
      final DateTime? respondedAt}) = _$FriendAttendingImpl;

  factory _FriendAttending.fromJson(Map<String, dynamic> json) =
      _$FriendAttendingImpl.fromJson;

  @override
  String get userId;
  @override
  String get userName;
  @override
  String? get userAvatar;
  @override
  RsvpResponse get response;
  @override
  bool get plusOneEnabled;
  @override
  DateTime? get respondedAt;

  /// Create a copy of FriendAttending
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendAttendingImplCopyWith<_$FriendAttendingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
