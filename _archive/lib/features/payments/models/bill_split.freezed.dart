// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bill_split.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BillSplit _$BillSplitFromJson(Map<String, dynamic> json) {
  return _BillSplit.fromJson(json);
}

/// @nodoc
mixin _$BillSplit {
  String get id => throw _privateConstructorUsedError;
  String get bookingId => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  SplitMethod get splitMethod => throw _privateConstructorUsedError;
  SplitStatus get status => throw _privateConstructorUsedError;
  List<BillParticipant> get participants => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Serializes this BillSplit to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BillSplit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BillSplitCopyWith<BillSplit> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BillSplitCopyWith<$Res> {
  factory $BillSplitCopyWith(BillSplit value, $Res Function(BillSplit) then) =
      _$BillSplitCopyWithImpl<$Res, BillSplit>;
  @useResult
  $Res call(
      {String id,
      String bookingId,
      double totalAmount,
      SplitMethod splitMethod,
      SplitStatus status,
      List<BillParticipant> participants,
      DateTime createdAt,
      DateTime? completedAt});
}

/// @nodoc
class _$BillSplitCopyWithImpl<$Res, $Val extends BillSplit>
    implements $BillSplitCopyWith<$Res> {
  _$BillSplitCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BillSplit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookingId = null,
    Object? totalAmount = null,
    Object? splitMethod = null,
    Object? status = null,
    Object? participants = null,
    Object? createdAt = null,
    Object? completedAt = freezed,
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
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      splitMethod: null == splitMethod
          ? _value.splitMethod
          : splitMethod // ignore: cast_nullable_to_non_nullable
              as SplitMethod,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SplitStatus,
      participants: null == participants
          ? _value.participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<BillParticipant>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BillSplitImplCopyWith<$Res>
    implements $BillSplitCopyWith<$Res> {
  factory _$$BillSplitImplCopyWith(
          _$BillSplitImpl value, $Res Function(_$BillSplitImpl) then) =
      __$$BillSplitImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String bookingId,
      double totalAmount,
      SplitMethod splitMethod,
      SplitStatus status,
      List<BillParticipant> participants,
      DateTime createdAt,
      DateTime? completedAt});
}

/// @nodoc
class __$$BillSplitImplCopyWithImpl<$Res>
    extends _$BillSplitCopyWithImpl<$Res, _$BillSplitImpl>
    implements _$$BillSplitImplCopyWith<$Res> {
  __$$BillSplitImplCopyWithImpl(
      _$BillSplitImpl _value, $Res Function(_$BillSplitImpl) _then)
      : super(_value, _then);

  /// Create a copy of BillSplit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookingId = null,
    Object? totalAmount = null,
    Object? splitMethod = null,
    Object? status = null,
    Object? participants = null,
    Object? createdAt = null,
    Object? completedAt = freezed,
  }) {
    return _then(_$BillSplitImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      splitMethod: null == splitMethod
          ? _value.splitMethod
          : splitMethod // ignore: cast_nullable_to_non_nullable
              as SplitMethod,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SplitStatus,
      participants: null == participants
          ? _value._participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<BillParticipant>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BillSplitImpl implements _BillSplit {
  const _$BillSplitImpl(
      {required this.id,
      required this.bookingId,
      required this.totalAmount,
      required this.splitMethod,
      this.status = SplitStatus.active,
      final List<BillParticipant> participants = const [],
      required this.createdAt,
      this.completedAt})
      : _participants = participants;

  factory _$BillSplitImpl.fromJson(Map<String, dynamic> json) =>
      _$$BillSplitImplFromJson(json);

  @override
  final String id;
  @override
  final String bookingId;
  @override
  final double totalAmount;
  @override
  final SplitMethod splitMethod;
  @override
  @JsonKey()
  final SplitStatus status;
  final List<BillParticipant> _participants;
  @override
  @JsonKey()
  List<BillParticipant> get participants {
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participants);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'BillSplit(id: $id, bookingId: $bookingId, totalAmount: $totalAmount, splitMethod: $splitMethod, status: $status, participants: $participants, createdAt: $createdAt, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BillSplitImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.splitMethod, splitMethod) ||
                other.splitMethod == splitMethod) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._participants, _participants) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      bookingId,
      totalAmount,
      splitMethod,
      status,
      const DeepCollectionEquality().hash(_participants),
      createdAt,
      completedAt);

  /// Create a copy of BillSplit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BillSplitImplCopyWith<_$BillSplitImpl> get copyWith =>
      __$$BillSplitImplCopyWithImpl<_$BillSplitImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BillSplitImplToJson(
      this,
    );
  }
}

abstract class _BillSplit implements BillSplit {
  const factory _BillSplit(
      {required final String id,
      required final String bookingId,
      required final double totalAmount,
      required final SplitMethod splitMethod,
      final SplitStatus status,
      final List<BillParticipant> participants,
      required final DateTime createdAt,
      final DateTime? completedAt}) = _$BillSplitImpl;

  factory _BillSplit.fromJson(Map<String, dynamic> json) =
      _$BillSplitImpl.fromJson;

  @override
  String get id;
  @override
  String get bookingId;
  @override
  double get totalAmount;
  @override
  SplitMethod get splitMethod;
  @override
  SplitStatus get status;
  @override
  List<BillParticipant> get participants;
  @override
  DateTime get createdAt;
  @override
  DateTime? get completedAt;

  /// Create a copy of BillSplit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BillSplitImplCopyWith<_$BillSplitImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BillParticipant _$BillParticipantFromJson(Map<String, dynamic> json) {
  return _BillParticipant.fromJson(json);
}

/// @nodoc
mixin _$BillParticipant {
  String get id => throw _privateConstructorUsedError;
  String get billSplitId => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;
  String? get userName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  double get amountOwed => throw _privateConstructorUsedError;
  double? get amountPaid => throw _privateConstructorUsedError;
  ParticipantStatus get status => throw _privateConstructorUsedError;
  String? get paymentIntentId => throw _privateConstructorUsedError;
  String? get paymentUrl => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get paidAt => throw _privateConstructorUsedError;

  /// Serializes this BillParticipant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BillParticipant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BillParticipantCopyWith<BillParticipant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BillParticipantCopyWith<$Res> {
  factory $BillParticipantCopyWith(
          BillParticipant value, $Res Function(BillParticipant) then) =
      _$BillParticipantCopyWithImpl<$Res, BillParticipant>;
  @useResult
  $Res call(
      {String id,
      String billSplitId,
      String? userId,
      String? userName,
      String? email,
      String? phone,
      double amountOwed,
      double? amountPaid,
      ParticipantStatus status,
      String? paymentIntentId,
      String? paymentUrl,
      DateTime createdAt,
      DateTime? paidAt});
}

/// @nodoc
class _$BillParticipantCopyWithImpl<$Res, $Val extends BillParticipant>
    implements $BillParticipantCopyWith<$Res> {
  _$BillParticipantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BillParticipant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? billSplitId = null,
    Object? userId = freezed,
    Object? userName = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? amountOwed = null,
    Object? amountPaid = freezed,
    Object? status = null,
    Object? paymentIntentId = freezed,
    Object? paymentUrl = freezed,
    Object? createdAt = null,
    Object? paidAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      billSplitId: null == billSplitId
          ? _value.billSplitId
          : billSplitId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      amountOwed: null == amountOwed
          ? _value.amountOwed
          : amountOwed // ignore: cast_nullable_to_non_nullable
              as double,
      amountPaid: freezed == amountPaid
          ? _value.amountPaid
          : amountPaid // ignore: cast_nullable_to_non_nullable
              as double?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ParticipantStatus,
      paymentIntentId: freezed == paymentIntentId
          ? _value.paymentIntentId
          : paymentIntentId // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentUrl: freezed == paymentUrl
          ? _value.paymentUrl
          : paymentUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BillParticipantImplCopyWith<$Res>
    implements $BillParticipantCopyWith<$Res> {
  factory _$$BillParticipantImplCopyWith(_$BillParticipantImpl value,
          $Res Function(_$BillParticipantImpl) then) =
      __$$BillParticipantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String billSplitId,
      String? userId,
      String? userName,
      String? email,
      String? phone,
      double amountOwed,
      double? amountPaid,
      ParticipantStatus status,
      String? paymentIntentId,
      String? paymentUrl,
      DateTime createdAt,
      DateTime? paidAt});
}

/// @nodoc
class __$$BillParticipantImplCopyWithImpl<$Res>
    extends _$BillParticipantCopyWithImpl<$Res, _$BillParticipantImpl>
    implements _$$BillParticipantImplCopyWith<$Res> {
  __$$BillParticipantImplCopyWithImpl(
      _$BillParticipantImpl _value, $Res Function(_$BillParticipantImpl) _then)
      : super(_value, _then);

  /// Create a copy of BillParticipant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? billSplitId = null,
    Object? userId = freezed,
    Object? userName = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? amountOwed = null,
    Object? amountPaid = freezed,
    Object? status = null,
    Object? paymentIntentId = freezed,
    Object? paymentUrl = freezed,
    Object? createdAt = null,
    Object? paidAt = freezed,
  }) {
    return _then(_$BillParticipantImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      billSplitId: null == billSplitId
          ? _value.billSplitId
          : billSplitId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      amountOwed: null == amountOwed
          ? _value.amountOwed
          : amountOwed // ignore: cast_nullable_to_non_nullable
              as double,
      amountPaid: freezed == amountPaid
          ? _value.amountPaid
          : amountPaid // ignore: cast_nullable_to_non_nullable
              as double?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ParticipantStatus,
      paymentIntentId: freezed == paymentIntentId
          ? _value.paymentIntentId
          : paymentIntentId // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentUrl: freezed == paymentUrl
          ? _value.paymentUrl
          : paymentUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BillParticipantImpl implements _BillParticipant {
  const _$BillParticipantImpl(
      {required this.id,
      required this.billSplitId,
      this.userId,
      this.userName,
      this.email,
      this.phone,
      required this.amountOwed,
      this.amountPaid,
      this.status = ParticipantStatus.pending,
      this.paymentIntentId,
      this.paymentUrl,
      required this.createdAt,
      this.paidAt});

  factory _$BillParticipantImpl.fromJson(Map<String, dynamic> json) =>
      _$$BillParticipantImplFromJson(json);

  @override
  final String id;
  @override
  final String billSplitId;
  @override
  final String? userId;
  @override
  final String? userName;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final double amountOwed;
  @override
  final double? amountPaid;
  @override
  @JsonKey()
  final ParticipantStatus status;
  @override
  final String? paymentIntentId;
  @override
  final String? paymentUrl;
  @override
  final DateTime createdAt;
  @override
  final DateTime? paidAt;

  @override
  String toString() {
    return 'BillParticipant(id: $id, billSplitId: $billSplitId, userId: $userId, userName: $userName, email: $email, phone: $phone, amountOwed: $amountOwed, amountPaid: $amountPaid, status: $status, paymentIntentId: $paymentIntentId, paymentUrl: $paymentUrl, createdAt: $createdAt, paidAt: $paidAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BillParticipantImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.billSplitId, billSplitId) ||
                other.billSplitId == billSplitId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.amountOwed, amountOwed) ||
                other.amountOwed == amountOwed) &&
            (identical(other.amountPaid, amountPaid) ||
                other.amountPaid == amountPaid) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paymentIntentId, paymentIntentId) ||
                other.paymentIntentId == paymentIntentId) &&
            (identical(other.paymentUrl, paymentUrl) ||
                other.paymentUrl == paymentUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      billSplitId,
      userId,
      userName,
      email,
      phone,
      amountOwed,
      amountPaid,
      status,
      paymentIntentId,
      paymentUrl,
      createdAt,
      paidAt);

  /// Create a copy of BillParticipant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BillParticipantImplCopyWith<_$BillParticipantImpl> get copyWith =>
      __$$BillParticipantImplCopyWithImpl<_$BillParticipantImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BillParticipantImplToJson(
      this,
    );
  }
}

abstract class _BillParticipant implements BillParticipant {
  const factory _BillParticipant(
      {required final String id,
      required final String billSplitId,
      final String? userId,
      final String? userName,
      final String? email,
      final String? phone,
      required final double amountOwed,
      final double? amountPaid,
      final ParticipantStatus status,
      final String? paymentIntentId,
      final String? paymentUrl,
      required final DateTime createdAt,
      final DateTime? paidAt}) = _$BillParticipantImpl;

  factory _BillParticipant.fromJson(Map<String, dynamic> json) =
      _$BillParticipantImpl.fromJson;

  @override
  String get id;
  @override
  String get billSplitId;
  @override
  String? get userId;
  @override
  String? get userName;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  double get amountOwed;
  @override
  double? get amountPaid;
  @override
  ParticipantStatus get status;
  @override
  String? get paymentIntentId;
  @override
  String? get paymentUrl;
  @override
  DateTime get createdAt;
  @override
  DateTime? get paidAt;

  /// Create a copy of BillParticipant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BillParticipantImplCopyWith<_$BillParticipantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BillItem _$BillItemFromJson(Map<String, dynamic> json) {
  return _BillItem.fromJson(json);
}

/// @nodoc
mixin _$BillItem {
  String get id => throw _privateConstructorUsedError;
  String get billSplitId => throw _privateConstructorUsedError;
  String get itemName => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  List<String> get assignedToUserIds => throw _privateConstructorUsedError;

  /// Serializes this BillItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BillItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BillItemCopyWith<BillItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BillItemCopyWith<$Res> {
  factory $BillItemCopyWith(BillItem value, $Res Function(BillItem) then) =
      _$BillItemCopyWithImpl<$Res, BillItem>;
  @useResult
  $Res call(
      {String id,
      String billSplitId,
      String itemName,
      double price,
      int quantity,
      List<String> assignedToUserIds});
}

/// @nodoc
class _$BillItemCopyWithImpl<$Res, $Val extends BillItem>
    implements $BillItemCopyWith<$Res> {
  _$BillItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BillItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? billSplitId = null,
    Object? itemName = null,
    Object? price = null,
    Object? quantity = null,
    Object? assignedToUserIds = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      billSplitId: null == billSplitId
          ? _value.billSplitId
          : billSplitId // ignore: cast_nullable_to_non_nullable
              as String,
      itemName: null == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      assignedToUserIds: null == assignedToUserIds
          ? _value.assignedToUserIds
          : assignedToUserIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BillItemImplCopyWith<$Res>
    implements $BillItemCopyWith<$Res> {
  factory _$$BillItemImplCopyWith(
          _$BillItemImpl value, $Res Function(_$BillItemImpl) then) =
      __$$BillItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String billSplitId,
      String itemName,
      double price,
      int quantity,
      List<String> assignedToUserIds});
}

/// @nodoc
class __$$BillItemImplCopyWithImpl<$Res>
    extends _$BillItemCopyWithImpl<$Res, _$BillItemImpl>
    implements _$$BillItemImplCopyWith<$Res> {
  __$$BillItemImplCopyWithImpl(
      _$BillItemImpl _value, $Res Function(_$BillItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of BillItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? billSplitId = null,
    Object? itemName = null,
    Object? price = null,
    Object? quantity = null,
    Object? assignedToUserIds = null,
  }) {
    return _then(_$BillItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      billSplitId: null == billSplitId
          ? _value.billSplitId
          : billSplitId // ignore: cast_nullable_to_non_nullable
              as String,
      itemName: null == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      assignedToUserIds: null == assignedToUserIds
          ? _value._assignedToUserIds
          : assignedToUserIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BillItemImpl implements _BillItem {
  const _$BillItemImpl(
      {required this.id,
      required this.billSplitId,
      required this.itemName,
      required this.price,
      this.quantity = 1,
      final List<String> assignedToUserIds = const []})
      : _assignedToUserIds = assignedToUserIds;

  factory _$BillItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$BillItemImplFromJson(json);

  @override
  final String id;
  @override
  final String billSplitId;
  @override
  final String itemName;
  @override
  final double price;
  @override
  @JsonKey()
  final int quantity;
  final List<String> _assignedToUserIds;
  @override
  @JsonKey()
  List<String> get assignedToUserIds {
    if (_assignedToUserIds is EqualUnmodifiableListView)
      return _assignedToUserIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_assignedToUserIds);
  }

  @override
  String toString() {
    return 'BillItem(id: $id, billSplitId: $billSplitId, itemName: $itemName, price: $price, quantity: $quantity, assignedToUserIds: $assignedToUserIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BillItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.billSplitId, billSplitId) ||
                other.billSplitId == billSplitId) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            const DeepCollectionEquality()
                .equals(other._assignedToUserIds, _assignedToUserIds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, billSplitId, itemName, price,
      quantity, const DeepCollectionEquality().hash(_assignedToUserIds));

  /// Create a copy of BillItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BillItemImplCopyWith<_$BillItemImpl> get copyWith =>
      __$$BillItemImplCopyWithImpl<_$BillItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BillItemImplToJson(
      this,
    );
  }
}

abstract class _BillItem implements BillItem {
  const factory _BillItem(
      {required final String id,
      required final String billSplitId,
      required final String itemName,
      required final double price,
      final int quantity,
      final List<String> assignedToUserIds}) = _$BillItemImpl;

  factory _BillItem.fromJson(Map<String, dynamic> json) =
      _$BillItemImpl.fromJson;

  @override
  String get id;
  @override
  String get billSplitId;
  @override
  String get itemName;
  @override
  double get price;
  @override
  int get quantity;
  @override
  List<String> get assignedToUserIds;

  /// Create a copy of BillItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BillItemImplCopyWith<_$BillItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
