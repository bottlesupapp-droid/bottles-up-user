// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'refund_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RefundRequest _$RefundRequestFromJson(Map<String, dynamic> json) {
  return _RefundRequest.fromJson(json);
}

/// @nodoc
mixin _$RefundRequest {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get bookingId => throw _privateConstructorUsedError;
  double get originalAmount => throw _privateConstructorUsedError;
  double get requestedAmount => throw _privateConstructorUsedError;
  double? get approvedAmount => throw _privateConstructorUsedError;
  RefundReason get reason => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String>? get attachments => throw _privateConstructorUsedError;
  RefundStatus get status => throw _privateConstructorUsedError;
  String? get adminNotes => throw _privateConstructorUsedError;
  String? get rejectionReason => throw _privateConstructorUsedError;
  DateTime get requestedAt => throw _privateConstructorUsedError;
  DateTime? get processedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  String? get transactionId => throw _privateConstructorUsedError;

  /// Serializes this RefundRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RefundRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RefundRequestCopyWith<RefundRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RefundRequestCopyWith<$Res> {
  factory $RefundRequestCopyWith(
          RefundRequest value, $Res Function(RefundRequest) then) =
      _$RefundRequestCopyWithImpl<$Res, RefundRequest>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String bookingId,
      double originalAmount,
      double requestedAmount,
      double? approvedAmount,
      RefundReason reason,
      String description,
      List<String>? attachments,
      RefundStatus status,
      String? adminNotes,
      String? rejectionReason,
      DateTime requestedAt,
      DateTime? processedAt,
      DateTime? completedAt,
      String? transactionId});
}

/// @nodoc
class _$RefundRequestCopyWithImpl<$Res, $Val extends RefundRequest>
    implements $RefundRequestCopyWith<$Res> {
  _$RefundRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RefundRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? bookingId = null,
    Object? originalAmount = null,
    Object? requestedAmount = null,
    Object? approvedAmount = freezed,
    Object? reason = null,
    Object? description = null,
    Object? attachments = freezed,
    Object? status = null,
    Object? adminNotes = freezed,
    Object? rejectionReason = freezed,
    Object? requestedAt = null,
    Object? processedAt = freezed,
    Object? completedAt = freezed,
    Object? transactionId = freezed,
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
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      originalAmount: null == originalAmount
          ? _value.originalAmount
          : originalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      requestedAmount: null == requestedAmount
          ? _value.requestedAmount
          : requestedAmount // ignore: cast_nullable_to_non_nullable
              as double,
      approvedAmount: freezed == approvedAmount
          ? _value.approvedAmount
          : approvedAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as RefundReason,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      attachments: freezed == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RefundStatus,
      adminNotes: freezed == adminNotes
          ? _value.adminNotes
          : adminNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      requestedAt: null == requestedAt
          ? _value.requestedAt
          : requestedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      processedAt: freezed == processedAt
          ? _value.processedAt
          : processedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RefundRequestImplCopyWith<$Res>
    implements $RefundRequestCopyWith<$Res> {
  factory _$$RefundRequestImplCopyWith(
          _$RefundRequestImpl value, $Res Function(_$RefundRequestImpl) then) =
      __$$RefundRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String bookingId,
      double originalAmount,
      double requestedAmount,
      double? approvedAmount,
      RefundReason reason,
      String description,
      List<String>? attachments,
      RefundStatus status,
      String? adminNotes,
      String? rejectionReason,
      DateTime requestedAt,
      DateTime? processedAt,
      DateTime? completedAt,
      String? transactionId});
}

/// @nodoc
class __$$RefundRequestImplCopyWithImpl<$Res>
    extends _$RefundRequestCopyWithImpl<$Res, _$RefundRequestImpl>
    implements _$$RefundRequestImplCopyWith<$Res> {
  __$$RefundRequestImplCopyWithImpl(
      _$RefundRequestImpl _value, $Res Function(_$RefundRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of RefundRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? bookingId = null,
    Object? originalAmount = null,
    Object? requestedAmount = null,
    Object? approvedAmount = freezed,
    Object? reason = null,
    Object? description = null,
    Object? attachments = freezed,
    Object? status = null,
    Object? adminNotes = freezed,
    Object? rejectionReason = freezed,
    Object? requestedAt = null,
    Object? processedAt = freezed,
    Object? completedAt = freezed,
    Object? transactionId = freezed,
  }) {
    return _then(_$RefundRequestImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      originalAmount: null == originalAmount
          ? _value.originalAmount
          : originalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      requestedAmount: null == requestedAmount
          ? _value.requestedAmount
          : requestedAmount // ignore: cast_nullable_to_non_nullable
              as double,
      approvedAmount: freezed == approvedAmount
          ? _value.approvedAmount
          : approvedAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as RefundReason,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      attachments: freezed == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RefundStatus,
      adminNotes: freezed == adminNotes
          ? _value.adminNotes
          : adminNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      requestedAt: null == requestedAt
          ? _value.requestedAt
          : requestedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      processedAt: freezed == processedAt
          ? _value.processedAt
          : processedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RefundRequestImpl implements _RefundRequest {
  const _$RefundRequestImpl(
      {required this.id,
      required this.userId,
      required this.bookingId,
      required this.originalAmount,
      required this.requestedAmount,
      this.approvedAmount,
      required this.reason,
      required this.description,
      final List<String>? attachments,
      this.status = RefundStatus.pending,
      this.adminNotes,
      this.rejectionReason,
      required this.requestedAt,
      this.processedAt,
      this.completedAt,
      this.transactionId})
      : _attachments = attachments;

  factory _$RefundRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RefundRequestImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String bookingId;
  @override
  final double originalAmount;
  @override
  final double requestedAmount;
  @override
  final double? approvedAmount;
  @override
  final RefundReason reason;
  @override
  final String description;
  final List<String>? _attachments;
  @override
  List<String>? get attachments {
    final value = _attachments;
    if (value == null) return null;
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final RefundStatus status;
  @override
  final String? adminNotes;
  @override
  final String? rejectionReason;
  @override
  final DateTime requestedAt;
  @override
  final DateTime? processedAt;
  @override
  final DateTime? completedAt;
  @override
  final String? transactionId;

  @override
  String toString() {
    return 'RefundRequest(id: $id, userId: $userId, bookingId: $bookingId, originalAmount: $originalAmount, requestedAmount: $requestedAmount, approvedAmount: $approvedAmount, reason: $reason, description: $description, attachments: $attachments, status: $status, adminNotes: $adminNotes, rejectionReason: $rejectionReason, requestedAt: $requestedAt, processedAt: $processedAt, completedAt: $completedAt, transactionId: $transactionId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefundRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.originalAmount, originalAmount) ||
                other.originalAmount == originalAmount) &&
            (identical(other.requestedAmount, requestedAmount) ||
                other.requestedAmount == requestedAmount) &&
            (identical(other.approvedAmount, approvedAmount) ||
                other.approvedAmount == approvedAmount) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.adminNotes, adminNotes) ||
                other.adminNotes == adminNotes) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.requestedAt, requestedAt) ||
                other.requestedAt == requestedAt) &&
            (identical(other.processedAt, processedAt) ||
                other.processedAt == processedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      bookingId,
      originalAmount,
      requestedAmount,
      approvedAmount,
      reason,
      description,
      const DeepCollectionEquality().hash(_attachments),
      status,
      adminNotes,
      rejectionReason,
      requestedAt,
      processedAt,
      completedAt,
      transactionId);

  /// Create a copy of RefundRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RefundRequestImplCopyWith<_$RefundRequestImpl> get copyWith =>
      __$$RefundRequestImplCopyWithImpl<_$RefundRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RefundRequestImplToJson(
      this,
    );
  }
}

abstract class _RefundRequest implements RefundRequest {
  const factory _RefundRequest(
      {required final String id,
      required final String userId,
      required final String bookingId,
      required final double originalAmount,
      required final double requestedAmount,
      final double? approvedAmount,
      required final RefundReason reason,
      required final String description,
      final List<String>? attachments,
      final RefundStatus status,
      final String? adminNotes,
      final String? rejectionReason,
      required final DateTime requestedAt,
      final DateTime? processedAt,
      final DateTime? completedAt,
      final String? transactionId}) = _$RefundRequestImpl;

  factory _RefundRequest.fromJson(Map<String, dynamic> json) =
      _$RefundRequestImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get bookingId;
  @override
  double get originalAmount;
  @override
  double get requestedAmount;
  @override
  double? get approvedAmount;
  @override
  RefundReason get reason;
  @override
  String get description;
  @override
  List<String>? get attachments;
  @override
  RefundStatus get status;
  @override
  String? get adminNotes;
  @override
  String? get rejectionReason;
  @override
  DateTime get requestedAt;
  @override
  DateTime? get processedAt;
  @override
  DateTime? get completedAt;
  @override
  String? get transactionId;

  /// Create a copy of RefundRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RefundRequestImplCopyWith<_$RefundRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
