// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_modification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BookingModification _$BookingModificationFromJson(Map<String, dynamic> json) {
  return _BookingModification.fromJson(json);
}

/// @nodoc
mixin _$BookingModification {
  String get id => throw _privateConstructorUsedError;
  String get bookingId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  ModificationType get modificationType => throw _privateConstructorUsedError;
  ModificationStatus get status => throw _privateConstructorUsedError;
  Map<String, dynamic>? get oldValues => throw _privateConstructorUsedError;
  Map<String, dynamic>? get newValues => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;
  CancellationReason? get cancellationReason =>
      throw _privateConstructorUsedError;
  double? get refundAmount => throw _privateConstructorUsedError;
  double? get additionalCharge => throw _privateConstructorUsedError;
  String? get adminNotes => throw _privateConstructorUsedError;
  String? get userNotes => throw _privateConstructorUsedError;
  DateTime get requestedAt => throw _privateConstructorUsedError;
  DateTime? get processedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  String? get processedBy => throw _privateConstructorUsedError;

  /// Serializes this BookingModification to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingModification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingModificationCopyWith<BookingModification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingModificationCopyWith<$Res> {
  factory $BookingModificationCopyWith(
          BookingModification value, $Res Function(BookingModification) then) =
      _$BookingModificationCopyWithImpl<$Res, BookingModification>;
  @useResult
  $Res call(
      {String id,
      String bookingId,
      String userId,
      ModificationType modificationType,
      ModificationStatus status,
      Map<String, dynamic>? oldValues,
      Map<String, dynamic>? newValues,
      String? reason,
      CancellationReason? cancellationReason,
      double? refundAmount,
      double? additionalCharge,
      String? adminNotes,
      String? userNotes,
      DateTime requestedAt,
      DateTime? processedAt,
      DateTime? completedAt,
      String? processedBy});
}

/// @nodoc
class _$BookingModificationCopyWithImpl<$Res, $Val extends BookingModification>
    implements $BookingModificationCopyWith<$Res> {
  _$BookingModificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingModification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookingId = null,
    Object? userId = null,
    Object? modificationType = null,
    Object? status = null,
    Object? oldValues = freezed,
    Object? newValues = freezed,
    Object? reason = freezed,
    Object? cancellationReason = freezed,
    Object? refundAmount = freezed,
    Object? additionalCharge = freezed,
    Object? adminNotes = freezed,
    Object? userNotes = freezed,
    Object? requestedAt = null,
    Object? processedAt = freezed,
    Object? completedAt = freezed,
    Object? processedBy = freezed,
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
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      modificationType: null == modificationType
          ? _value.modificationType
          : modificationType // ignore: cast_nullable_to_non_nullable
              as ModificationType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ModificationStatus,
      oldValues: freezed == oldValues
          ? _value.oldValues
          : oldValues // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      newValues: freezed == newValues
          ? _value.newValues
          : newValues // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      cancellationReason: freezed == cancellationReason
          ? _value.cancellationReason
          : cancellationReason // ignore: cast_nullable_to_non_nullable
              as CancellationReason?,
      refundAmount: freezed == refundAmount
          ? _value.refundAmount
          : refundAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      additionalCharge: freezed == additionalCharge
          ? _value.additionalCharge
          : additionalCharge // ignore: cast_nullable_to_non_nullable
              as double?,
      adminNotes: freezed == adminNotes
          ? _value.adminNotes
          : adminNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      userNotes: freezed == userNotes
          ? _value.userNotes
          : userNotes // ignore: cast_nullable_to_non_nullable
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
      processedBy: freezed == processedBy
          ? _value.processedBy
          : processedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookingModificationImplCopyWith<$Res>
    implements $BookingModificationCopyWith<$Res> {
  factory _$$BookingModificationImplCopyWith(_$BookingModificationImpl value,
          $Res Function(_$BookingModificationImpl) then) =
      __$$BookingModificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String bookingId,
      String userId,
      ModificationType modificationType,
      ModificationStatus status,
      Map<String, dynamic>? oldValues,
      Map<String, dynamic>? newValues,
      String? reason,
      CancellationReason? cancellationReason,
      double? refundAmount,
      double? additionalCharge,
      String? adminNotes,
      String? userNotes,
      DateTime requestedAt,
      DateTime? processedAt,
      DateTime? completedAt,
      String? processedBy});
}

/// @nodoc
class __$$BookingModificationImplCopyWithImpl<$Res>
    extends _$BookingModificationCopyWithImpl<$Res, _$BookingModificationImpl>
    implements _$$BookingModificationImplCopyWith<$Res> {
  __$$BookingModificationImplCopyWithImpl(_$BookingModificationImpl _value,
      $Res Function(_$BookingModificationImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookingModification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookingId = null,
    Object? userId = null,
    Object? modificationType = null,
    Object? status = null,
    Object? oldValues = freezed,
    Object? newValues = freezed,
    Object? reason = freezed,
    Object? cancellationReason = freezed,
    Object? refundAmount = freezed,
    Object? additionalCharge = freezed,
    Object? adminNotes = freezed,
    Object? userNotes = freezed,
    Object? requestedAt = null,
    Object? processedAt = freezed,
    Object? completedAt = freezed,
    Object? processedBy = freezed,
  }) {
    return _then(_$BookingModificationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      modificationType: null == modificationType
          ? _value.modificationType
          : modificationType // ignore: cast_nullable_to_non_nullable
              as ModificationType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ModificationStatus,
      oldValues: freezed == oldValues
          ? _value._oldValues
          : oldValues // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      newValues: freezed == newValues
          ? _value._newValues
          : newValues // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      cancellationReason: freezed == cancellationReason
          ? _value.cancellationReason
          : cancellationReason // ignore: cast_nullable_to_non_nullable
              as CancellationReason?,
      refundAmount: freezed == refundAmount
          ? _value.refundAmount
          : refundAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      additionalCharge: freezed == additionalCharge
          ? _value.additionalCharge
          : additionalCharge // ignore: cast_nullable_to_non_nullable
              as double?,
      adminNotes: freezed == adminNotes
          ? _value.adminNotes
          : adminNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      userNotes: freezed == userNotes
          ? _value.userNotes
          : userNotes // ignore: cast_nullable_to_non_nullable
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
      processedBy: freezed == processedBy
          ? _value.processedBy
          : processedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingModificationImpl implements _BookingModification {
  const _$BookingModificationImpl(
      {required this.id,
      required this.bookingId,
      required this.userId,
      required this.modificationType,
      required this.status,
      final Map<String, dynamic>? oldValues,
      final Map<String, dynamic>? newValues,
      this.reason,
      this.cancellationReason,
      this.refundAmount,
      this.additionalCharge,
      this.adminNotes,
      this.userNotes,
      required this.requestedAt,
      this.processedAt,
      this.completedAt,
      this.processedBy})
      : _oldValues = oldValues,
        _newValues = newValues;

  factory _$BookingModificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingModificationImplFromJson(json);

  @override
  final String id;
  @override
  final String bookingId;
  @override
  final String userId;
  @override
  final ModificationType modificationType;
  @override
  final ModificationStatus status;
  final Map<String, dynamic>? _oldValues;
  @override
  Map<String, dynamic>? get oldValues {
    final value = _oldValues;
    if (value == null) return null;
    if (_oldValues is EqualUnmodifiableMapView) return _oldValues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _newValues;
  @override
  Map<String, dynamic>? get newValues {
    final value = _newValues;
    if (value == null) return null;
    if (_newValues is EqualUnmodifiableMapView) return _newValues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? reason;
  @override
  final CancellationReason? cancellationReason;
  @override
  final double? refundAmount;
  @override
  final double? additionalCharge;
  @override
  final String? adminNotes;
  @override
  final String? userNotes;
  @override
  final DateTime requestedAt;
  @override
  final DateTime? processedAt;
  @override
  final DateTime? completedAt;
  @override
  final String? processedBy;

  @override
  String toString() {
    return 'BookingModification(id: $id, bookingId: $bookingId, userId: $userId, modificationType: $modificationType, status: $status, oldValues: $oldValues, newValues: $newValues, reason: $reason, cancellationReason: $cancellationReason, refundAmount: $refundAmount, additionalCharge: $additionalCharge, adminNotes: $adminNotes, userNotes: $userNotes, requestedAt: $requestedAt, processedAt: $processedAt, completedAt: $completedAt, processedBy: $processedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingModificationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.modificationType, modificationType) ||
                other.modificationType == modificationType) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._oldValues, _oldValues) &&
            const DeepCollectionEquality()
                .equals(other._newValues, _newValues) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.cancellationReason, cancellationReason) ||
                other.cancellationReason == cancellationReason) &&
            (identical(other.refundAmount, refundAmount) ||
                other.refundAmount == refundAmount) &&
            (identical(other.additionalCharge, additionalCharge) ||
                other.additionalCharge == additionalCharge) &&
            (identical(other.adminNotes, adminNotes) ||
                other.adminNotes == adminNotes) &&
            (identical(other.userNotes, userNotes) ||
                other.userNotes == userNotes) &&
            (identical(other.requestedAt, requestedAt) ||
                other.requestedAt == requestedAt) &&
            (identical(other.processedAt, processedAt) ||
                other.processedAt == processedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.processedBy, processedBy) ||
                other.processedBy == processedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      bookingId,
      userId,
      modificationType,
      status,
      const DeepCollectionEquality().hash(_oldValues),
      const DeepCollectionEquality().hash(_newValues),
      reason,
      cancellationReason,
      refundAmount,
      additionalCharge,
      adminNotes,
      userNotes,
      requestedAt,
      processedAt,
      completedAt,
      processedBy);

  /// Create a copy of BookingModification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingModificationImplCopyWith<_$BookingModificationImpl> get copyWith =>
      __$$BookingModificationImplCopyWithImpl<_$BookingModificationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingModificationImplToJson(
      this,
    );
  }
}

abstract class _BookingModification implements BookingModification {
  const factory _BookingModification(
      {required final String id,
      required final String bookingId,
      required final String userId,
      required final ModificationType modificationType,
      required final ModificationStatus status,
      final Map<String, dynamic>? oldValues,
      final Map<String, dynamic>? newValues,
      final String? reason,
      final CancellationReason? cancellationReason,
      final double? refundAmount,
      final double? additionalCharge,
      final String? adminNotes,
      final String? userNotes,
      required final DateTime requestedAt,
      final DateTime? processedAt,
      final DateTime? completedAt,
      final String? processedBy}) = _$BookingModificationImpl;

  factory _BookingModification.fromJson(Map<String, dynamic> json) =
      _$BookingModificationImpl.fromJson;

  @override
  String get id;
  @override
  String get bookingId;
  @override
  String get userId;
  @override
  ModificationType get modificationType;
  @override
  ModificationStatus get status;
  @override
  Map<String, dynamic>? get oldValues;
  @override
  Map<String, dynamic>? get newValues;
  @override
  String? get reason;
  @override
  CancellationReason? get cancellationReason;
  @override
  double? get refundAmount;
  @override
  double? get additionalCharge;
  @override
  String? get adminNotes;
  @override
  String? get userNotes;
  @override
  DateTime get requestedAt;
  @override
  DateTime? get processedAt;
  @override
  DateTime? get completedAt;
  @override
  String? get processedBy;

  /// Create a copy of BookingModification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingModificationImplCopyWith<_$BookingModificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CancellationPolicy _$CancellationPolicyFromJson(Map<String, dynamic> json) {
  return _CancellationPolicy.fromJson(json);
}

/// @nodoc
mixin _$CancellationPolicy {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get hoursBeforeEvent => throw _privateConstructorUsedError;
  double get refundPercentage => throw _privateConstructorUsedError;
  double get cancellationFeePercentage => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this CancellationPolicy to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CancellationPolicy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CancellationPolicyCopyWith<CancellationPolicy> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CancellationPolicyCopyWith<$Res> {
  factory $CancellationPolicyCopyWith(
          CancellationPolicy value, $Res Function(CancellationPolicy) then) =
      _$CancellationPolicyCopyWithImpl<$Res, CancellationPolicy>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      int hoursBeforeEvent,
      double refundPercentage,
      double cancellationFeePercentage,
      bool isActive});
}

/// @nodoc
class _$CancellationPolicyCopyWithImpl<$Res, $Val extends CancellationPolicy>
    implements $CancellationPolicyCopyWith<$Res> {
  _$CancellationPolicyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CancellationPolicy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? hoursBeforeEvent = null,
    Object? refundPercentage = null,
    Object? cancellationFeePercentage = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      hoursBeforeEvent: null == hoursBeforeEvent
          ? _value.hoursBeforeEvent
          : hoursBeforeEvent // ignore: cast_nullable_to_non_nullable
              as int,
      refundPercentage: null == refundPercentage
          ? _value.refundPercentage
          : refundPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      cancellationFeePercentage: null == cancellationFeePercentage
          ? _value.cancellationFeePercentage
          : cancellationFeePercentage // ignore: cast_nullable_to_non_nullable
              as double,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CancellationPolicyImplCopyWith<$Res>
    implements $CancellationPolicyCopyWith<$Res> {
  factory _$$CancellationPolicyImplCopyWith(_$CancellationPolicyImpl value,
          $Res Function(_$CancellationPolicyImpl) then) =
      __$$CancellationPolicyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      int hoursBeforeEvent,
      double refundPercentage,
      double cancellationFeePercentage,
      bool isActive});
}

/// @nodoc
class __$$CancellationPolicyImplCopyWithImpl<$Res>
    extends _$CancellationPolicyCopyWithImpl<$Res, _$CancellationPolicyImpl>
    implements _$$CancellationPolicyImplCopyWith<$Res> {
  __$$CancellationPolicyImplCopyWithImpl(_$CancellationPolicyImpl _value,
      $Res Function(_$CancellationPolicyImpl) _then)
      : super(_value, _then);

  /// Create a copy of CancellationPolicy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? hoursBeforeEvent = null,
    Object? refundPercentage = null,
    Object? cancellationFeePercentage = null,
    Object? isActive = null,
  }) {
    return _then(_$CancellationPolicyImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      hoursBeforeEvent: null == hoursBeforeEvent
          ? _value.hoursBeforeEvent
          : hoursBeforeEvent // ignore: cast_nullable_to_non_nullable
              as int,
      refundPercentage: null == refundPercentage
          ? _value.refundPercentage
          : refundPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      cancellationFeePercentage: null == cancellationFeePercentage
          ? _value.cancellationFeePercentage
          : cancellationFeePercentage // ignore: cast_nullable_to_non_nullable
              as double,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CancellationPolicyImpl implements _CancellationPolicy {
  const _$CancellationPolicyImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.hoursBeforeEvent,
      required this.refundPercentage,
      this.cancellationFeePercentage = 0,
      this.isActive = true});

  factory _$CancellationPolicyImpl.fromJson(Map<String, dynamic> json) =>
      _$$CancellationPolicyImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final int hoursBeforeEvent;
  @override
  final double refundPercentage;
  @override
  @JsonKey()
  final double cancellationFeePercentage;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'CancellationPolicy(id: $id, name: $name, description: $description, hoursBeforeEvent: $hoursBeforeEvent, refundPercentage: $refundPercentage, cancellationFeePercentage: $cancellationFeePercentage, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CancellationPolicyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.hoursBeforeEvent, hoursBeforeEvent) ||
                other.hoursBeforeEvent == hoursBeforeEvent) &&
            (identical(other.refundPercentage, refundPercentage) ||
                other.refundPercentage == refundPercentage) &&
            (identical(other.cancellationFeePercentage,
                    cancellationFeePercentage) ||
                other.cancellationFeePercentage == cancellationFeePercentage) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description,
      hoursBeforeEvent, refundPercentage, cancellationFeePercentage, isActive);

  /// Create a copy of CancellationPolicy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CancellationPolicyImplCopyWith<_$CancellationPolicyImpl> get copyWith =>
      __$$CancellationPolicyImplCopyWithImpl<_$CancellationPolicyImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CancellationPolicyImplToJson(
      this,
    );
  }
}

abstract class _CancellationPolicy implements CancellationPolicy {
  const factory _CancellationPolicy(
      {required final String id,
      required final String name,
      required final String description,
      required final int hoursBeforeEvent,
      required final double refundPercentage,
      final double cancellationFeePercentage,
      final bool isActive}) = _$CancellationPolicyImpl;

  factory _CancellationPolicy.fromJson(Map<String, dynamic> json) =
      _$CancellationPolicyImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  int get hoursBeforeEvent;
  @override
  double get refundPercentage;
  @override
  double get cancellationFeePercentage;
  @override
  bool get isActive;

  /// Create a copy of CancellationPolicy
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CancellationPolicyImplCopyWith<_$CancellationPolicyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RefundCalculation _$RefundCalculationFromJson(Map<String, dynamic> json) {
  return _RefundCalculation.fromJson(json);
}

/// @nodoc
mixin _$RefundCalculation {
  double get originalAmount => throw _privateConstructorUsedError;
  double get refundPercentage => throw _privateConstructorUsedError;
  double get refundAmount => throw _privateConstructorUsedError;
  double get cancellationFee => throw _privateConstructorUsedError;
  double get netRefund => throw _privateConstructorUsedError;
  CancellationPolicy get policy => throw _privateConstructorUsedError;
  int get hoursUntilEvent => throw _privateConstructorUsedError;
  bool get isRefundable => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this RefundCalculation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RefundCalculation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RefundCalculationCopyWith<RefundCalculation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RefundCalculationCopyWith<$Res> {
  factory $RefundCalculationCopyWith(
          RefundCalculation value, $Res Function(RefundCalculation) then) =
      _$RefundCalculationCopyWithImpl<$Res, RefundCalculation>;
  @useResult
  $Res call(
      {double originalAmount,
      double refundPercentage,
      double refundAmount,
      double cancellationFee,
      double netRefund,
      CancellationPolicy policy,
      int hoursUntilEvent,
      bool isRefundable,
      String? message});

  $CancellationPolicyCopyWith<$Res> get policy;
}

/// @nodoc
class _$RefundCalculationCopyWithImpl<$Res, $Val extends RefundCalculation>
    implements $RefundCalculationCopyWith<$Res> {
  _$RefundCalculationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RefundCalculation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalAmount = null,
    Object? refundPercentage = null,
    Object? refundAmount = null,
    Object? cancellationFee = null,
    Object? netRefund = null,
    Object? policy = null,
    Object? hoursUntilEvent = null,
    Object? isRefundable = null,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      originalAmount: null == originalAmount
          ? _value.originalAmount
          : originalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      refundPercentage: null == refundPercentage
          ? _value.refundPercentage
          : refundPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      refundAmount: null == refundAmount
          ? _value.refundAmount
          : refundAmount // ignore: cast_nullable_to_non_nullable
              as double,
      cancellationFee: null == cancellationFee
          ? _value.cancellationFee
          : cancellationFee // ignore: cast_nullable_to_non_nullable
              as double,
      netRefund: null == netRefund
          ? _value.netRefund
          : netRefund // ignore: cast_nullable_to_non_nullable
              as double,
      policy: null == policy
          ? _value.policy
          : policy // ignore: cast_nullable_to_non_nullable
              as CancellationPolicy,
      hoursUntilEvent: null == hoursUntilEvent
          ? _value.hoursUntilEvent
          : hoursUntilEvent // ignore: cast_nullable_to_non_nullable
              as int,
      isRefundable: null == isRefundable
          ? _value.isRefundable
          : isRefundable // ignore: cast_nullable_to_non_nullable
              as bool,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of RefundCalculation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CancellationPolicyCopyWith<$Res> get policy {
    return $CancellationPolicyCopyWith<$Res>(_value.policy, (value) {
      return _then(_value.copyWith(policy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RefundCalculationImplCopyWith<$Res>
    implements $RefundCalculationCopyWith<$Res> {
  factory _$$RefundCalculationImplCopyWith(_$RefundCalculationImpl value,
          $Res Function(_$RefundCalculationImpl) then) =
      __$$RefundCalculationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double originalAmount,
      double refundPercentage,
      double refundAmount,
      double cancellationFee,
      double netRefund,
      CancellationPolicy policy,
      int hoursUntilEvent,
      bool isRefundable,
      String? message});

  @override
  $CancellationPolicyCopyWith<$Res> get policy;
}

/// @nodoc
class __$$RefundCalculationImplCopyWithImpl<$Res>
    extends _$RefundCalculationCopyWithImpl<$Res, _$RefundCalculationImpl>
    implements _$$RefundCalculationImplCopyWith<$Res> {
  __$$RefundCalculationImplCopyWithImpl(_$RefundCalculationImpl _value,
      $Res Function(_$RefundCalculationImpl) _then)
      : super(_value, _then);

  /// Create a copy of RefundCalculation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalAmount = null,
    Object? refundPercentage = null,
    Object? refundAmount = null,
    Object? cancellationFee = null,
    Object? netRefund = null,
    Object? policy = null,
    Object? hoursUntilEvent = null,
    Object? isRefundable = null,
    Object? message = freezed,
  }) {
    return _then(_$RefundCalculationImpl(
      originalAmount: null == originalAmount
          ? _value.originalAmount
          : originalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      refundPercentage: null == refundPercentage
          ? _value.refundPercentage
          : refundPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      refundAmount: null == refundAmount
          ? _value.refundAmount
          : refundAmount // ignore: cast_nullable_to_non_nullable
              as double,
      cancellationFee: null == cancellationFee
          ? _value.cancellationFee
          : cancellationFee // ignore: cast_nullable_to_non_nullable
              as double,
      netRefund: null == netRefund
          ? _value.netRefund
          : netRefund // ignore: cast_nullable_to_non_nullable
              as double,
      policy: null == policy
          ? _value.policy
          : policy // ignore: cast_nullable_to_non_nullable
              as CancellationPolicy,
      hoursUntilEvent: null == hoursUntilEvent
          ? _value.hoursUntilEvent
          : hoursUntilEvent // ignore: cast_nullable_to_non_nullable
              as int,
      isRefundable: null == isRefundable
          ? _value.isRefundable
          : isRefundable // ignore: cast_nullable_to_non_nullable
              as bool,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RefundCalculationImpl implements _RefundCalculation {
  const _$RefundCalculationImpl(
      {required this.originalAmount,
      required this.refundPercentage,
      required this.refundAmount,
      required this.cancellationFee,
      required this.netRefund,
      required this.policy,
      required this.hoursUntilEvent,
      required this.isRefundable,
      this.message});

  factory _$RefundCalculationImpl.fromJson(Map<String, dynamic> json) =>
      _$$RefundCalculationImplFromJson(json);

  @override
  final double originalAmount;
  @override
  final double refundPercentage;
  @override
  final double refundAmount;
  @override
  final double cancellationFee;
  @override
  final double netRefund;
  @override
  final CancellationPolicy policy;
  @override
  final int hoursUntilEvent;
  @override
  final bool isRefundable;
  @override
  final String? message;

  @override
  String toString() {
    return 'RefundCalculation(originalAmount: $originalAmount, refundPercentage: $refundPercentage, refundAmount: $refundAmount, cancellationFee: $cancellationFee, netRefund: $netRefund, policy: $policy, hoursUntilEvent: $hoursUntilEvent, isRefundable: $isRefundable, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefundCalculationImpl &&
            (identical(other.originalAmount, originalAmount) ||
                other.originalAmount == originalAmount) &&
            (identical(other.refundPercentage, refundPercentage) ||
                other.refundPercentage == refundPercentage) &&
            (identical(other.refundAmount, refundAmount) ||
                other.refundAmount == refundAmount) &&
            (identical(other.cancellationFee, cancellationFee) ||
                other.cancellationFee == cancellationFee) &&
            (identical(other.netRefund, netRefund) ||
                other.netRefund == netRefund) &&
            (identical(other.policy, policy) || other.policy == policy) &&
            (identical(other.hoursUntilEvent, hoursUntilEvent) ||
                other.hoursUntilEvent == hoursUntilEvent) &&
            (identical(other.isRefundable, isRefundable) ||
                other.isRefundable == isRefundable) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      originalAmount,
      refundPercentage,
      refundAmount,
      cancellationFee,
      netRefund,
      policy,
      hoursUntilEvent,
      isRefundable,
      message);

  /// Create a copy of RefundCalculation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RefundCalculationImplCopyWith<_$RefundCalculationImpl> get copyWith =>
      __$$RefundCalculationImplCopyWithImpl<_$RefundCalculationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RefundCalculationImplToJson(
      this,
    );
  }
}

abstract class _RefundCalculation implements RefundCalculation {
  const factory _RefundCalculation(
      {required final double originalAmount,
      required final double refundPercentage,
      required final double refundAmount,
      required final double cancellationFee,
      required final double netRefund,
      required final CancellationPolicy policy,
      required final int hoursUntilEvent,
      required final bool isRefundable,
      final String? message}) = _$RefundCalculationImpl;

  factory _RefundCalculation.fromJson(Map<String, dynamic> json) =
      _$RefundCalculationImpl.fromJson;

  @override
  double get originalAmount;
  @override
  double get refundPercentage;
  @override
  double get refundAmount;
  @override
  double get cancellationFee;
  @override
  double get netRefund;
  @override
  CancellationPolicy get policy;
  @override
  int get hoursUntilEvent;
  @override
  bool get isRefundable;
  @override
  String? get message;

  /// Create a copy of RefundCalculation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RefundCalculationImplCopyWith<_$RefundCalculationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
