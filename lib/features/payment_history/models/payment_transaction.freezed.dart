// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaymentTransaction _$PaymentTransactionFromJson(Map<String, dynamic> json) {
  return _PaymentTransaction.fromJson(json);
}

/// @nodoc
mixin _$PaymentTransaction {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get bookingId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  PaymentStatus get status => throw _privateConstructorUsedError;
  PaymentMethod get method => throw _privateConstructorUsedError;
  String? get paymentIntentId => throw _privateConstructorUsedError;
  String? get receiptUrl => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  double? get refundedAmount => throw _privateConstructorUsedError;
  DateTime? get refundedAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this PaymentTransaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentTransactionCopyWith<PaymentTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentTransactionCopyWith<$Res> {
  factory $PaymentTransactionCopyWith(
          PaymentTransaction value, $Res Function(PaymentTransaction) then) =
      _$PaymentTransactionCopyWithImpl<$Res, PaymentTransaction>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String? bookingId,
      double amount,
      String currency,
      PaymentStatus status,
      PaymentMethod method,
      String? paymentIntentId,
      String? receiptUrl,
      String? description,
      double? refundedAmount,
      DateTime? refundedAt,
      Map<String, dynamic>? metadata,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$PaymentTransactionCopyWithImpl<$Res, $Val extends PaymentTransaction>
    implements $PaymentTransactionCopyWith<$Res> {
  _$PaymentTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? bookingId = freezed,
    Object? amount = null,
    Object? currency = null,
    Object? status = null,
    Object? method = null,
    Object? paymentIntentId = freezed,
    Object? receiptUrl = freezed,
    Object? description = freezed,
    Object? refundedAmount = freezed,
    Object? refundedAt = freezed,
    Object? metadata = freezed,
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
      bookingId: freezed == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PaymentStatus,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      paymentIntentId: freezed == paymentIntentId
          ? _value.paymentIntentId
          : paymentIntentId // ignore: cast_nullable_to_non_nullable
              as String?,
      receiptUrl: freezed == receiptUrl
          ? _value.receiptUrl
          : receiptUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      refundedAmount: freezed == refundedAmount
          ? _value.refundedAmount
          : refundedAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      refundedAt: freezed == refundedAt
          ? _value.refundedAt
          : refundedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
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
abstract class _$$PaymentTransactionImplCopyWith<$Res>
    implements $PaymentTransactionCopyWith<$Res> {
  factory _$$PaymentTransactionImplCopyWith(_$PaymentTransactionImpl value,
          $Res Function(_$PaymentTransactionImpl) then) =
      __$$PaymentTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String? bookingId,
      double amount,
      String currency,
      PaymentStatus status,
      PaymentMethod method,
      String? paymentIntentId,
      String? receiptUrl,
      String? description,
      double? refundedAmount,
      DateTime? refundedAt,
      Map<String, dynamic>? metadata,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$PaymentTransactionImplCopyWithImpl<$Res>
    extends _$PaymentTransactionCopyWithImpl<$Res, _$PaymentTransactionImpl>
    implements _$$PaymentTransactionImplCopyWith<$Res> {
  __$$PaymentTransactionImplCopyWithImpl(_$PaymentTransactionImpl _value,
      $Res Function(_$PaymentTransactionImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? bookingId = freezed,
    Object? amount = null,
    Object? currency = null,
    Object? status = null,
    Object? method = null,
    Object? paymentIntentId = freezed,
    Object? receiptUrl = freezed,
    Object? description = freezed,
    Object? refundedAmount = freezed,
    Object? refundedAt = freezed,
    Object? metadata = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$PaymentTransactionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      bookingId: freezed == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PaymentStatus,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      paymentIntentId: freezed == paymentIntentId
          ? _value.paymentIntentId
          : paymentIntentId // ignore: cast_nullable_to_non_nullable
              as String?,
      receiptUrl: freezed == receiptUrl
          ? _value.receiptUrl
          : receiptUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      refundedAmount: freezed == refundedAmount
          ? _value.refundedAmount
          : refundedAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      refundedAt: freezed == refundedAt
          ? _value.refundedAt
          : refundedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
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
class _$PaymentTransactionImpl implements _PaymentTransaction {
  const _$PaymentTransactionImpl(
      {required this.id,
      required this.userId,
      this.bookingId,
      required this.amount,
      required this.currency,
      required this.status,
      required this.method,
      this.paymentIntentId,
      this.receiptUrl,
      this.description,
      this.refundedAmount,
      this.refundedAt,
      final Map<String, dynamic>? metadata,
      required this.createdAt,
      this.updatedAt})
      : _metadata = metadata;

  factory _$PaymentTransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentTransactionImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String? bookingId;
  @override
  final double amount;
  @override
  final String currency;
  @override
  final PaymentStatus status;
  @override
  final PaymentMethod method;
  @override
  final String? paymentIntentId;
  @override
  final String? receiptUrl;
  @override
  final String? description;
  @override
  final double? refundedAmount;
  @override
  final DateTime? refundedAt;
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
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'PaymentTransaction(id: $id, userId: $userId, bookingId: $bookingId, amount: $amount, currency: $currency, status: $status, method: $method, paymentIntentId: $paymentIntentId, receiptUrl: $receiptUrl, description: $description, refundedAmount: $refundedAmount, refundedAt: $refundedAt, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentTransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.paymentIntentId, paymentIntentId) ||
                other.paymentIntentId == paymentIntentId) &&
            (identical(other.receiptUrl, receiptUrl) ||
                other.receiptUrl == receiptUrl) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.refundedAmount, refundedAmount) ||
                other.refundedAmount == refundedAmount) &&
            (identical(other.refundedAt, refundedAt) ||
                other.refundedAt == refundedAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
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
      bookingId,
      amount,
      currency,
      status,
      method,
      paymentIntentId,
      receiptUrl,
      description,
      refundedAmount,
      refundedAt,
      const DeepCollectionEquality().hash(_metadata),
      createdAt,
      updatedAt);

  /// Create a copy of PaymentTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentTransactionImplCopyWith<_$PaymentTransactionImpl> get copyWith =>
      __$$PaymentTransactionImplCopyWithImpl<_$PaymentTransactionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentTransactionImplToJson(
      this,
    );
  }
}

abstract class _PaymentTransaction implements PaymentTransaction {
  const factory _PaymentTransaction(
      {required final String id,
      required final String userId,
      final String? bookingId,
      required final double amount,
      required final String currency,
      required final PaymentStatus status,
      required final PaymentMethod method,
      final String? paymentIntentId,
      final String? receiptUrl,
      final String? description,
      final double? refundedAmount,
      final DateTime? refundedAt,
      final Map<String, dynamic>? metadata,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$PaymentTransactionImpl;

  factory _PaymentTransaction.fromJson(Map<String, dynamic> json) =
      _$PaymentTransactionImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String? get bookingId;
  @override
  double get amount;
  @override
  String get currency;
  @override
  PaymentStatus get status;
  @override
  PaymentMethod get method;
  @override
  String? get paymentIntentId;
  @override
  String? get receiptUrl;
  @override
  String? get description;
  @override
  double? get refundedAmount;
  @override
  DateTime? get refundedAt;
  @override
  Map<String, dynamic>? get metadata;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of PaymentTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentTransactionImplCopyWith<_$PaymentTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaymentFilter _$PaymentFilterFromJson(Map<String, dynamic> json) {
  return _PaymentFilter.fromJson(json);
}

/// @nodoc
mixin _$PaymentFilter {
  DateTimeRange? get dateRange => throw _privateConstructorUsedError;
  List<PaymentStatus>? get statuses => throw _privateConstructorUsedError;
  List<PaymentMethod>? get methods => throw _privateConstructorUsedError;
  double? get minAmount => throw _privateConstructorUsedError;
  double? get maxAmount => throw _privateConstructorUsedError;
  String? get searchQuery => throw _privateConstructorUsedError;

  /// Serializes this PaymentFilter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentFilterCopyWith<PaymentFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentFilterCopyWith<$Res> {
  factory $PaymentFilterCopyWith(
          PaymentFilter value, $Res Function(PaymentFilter) then) =
      _$PaymentFilterCopyWithImpl<$Res, PaymentFilter>;
  @useResult
  $Res call(
      {DateTimeRange? dateRange,
      List<PaymentStatus>? statuses,
      List<PaymentMethod>? methods,
      double? minAmount,
      double? maxAmount,
      String? searchQuery});

  $DateTimeRangeCopyWith<$Res>? get dateRange;
}

/// @nodoc
class _$PaymentFilterCopyWithImpl<$Res, $Val extends PaymentFilter>
    implements $PaymentFilterCopyWith<$Res> {
  _$PaymentFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dateRange = freezed,
    Object? statuses = freezed,
    Object? methods = freezed,
    Object? minAmount = freezed,
    Object? maxAmount = freezed,
    Object? searchQuery = freezed,
  }) {
    return _then(_value.copyWith(
      dateRange: freezed == dateRange
          ? _value.dateRange
          : dateRange // ignore: cast_nullable_to_non_nullable
              as DateTimeRange?,
      statuses: freezed == statuses
          ? _value.statuses
          : statuses // ignore: cast_nullable_to_non_nullable
              as List<PaymentStatus>?,
      methods: freezed == methods
          ? _value.methods
          : methods // ignore: cast_nullable_to_non_nullable
              as List<PaymentMethod>?,
      minAmount: freezed == minAmount
          ? _value.minAmount
          : minAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      maxAmount: freezed == maxAmount
          ? _value.maxAmount
          : maxAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of PaymentFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DateTimeRangeCopyWith<$Res>? get dateRange {
    if (_value.dateRange == null) {
      return null;
    }

    return $DateTimeRangeCopyWith<$Res>(_value.dateRange!, (value) {
      return _then(_value.copyWith(dateRange: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PaymentFilterImplCopyWith<$Res>
    implements $PaymentFilterCopyWith<$Res> {
  factory _$$PaymentFilterImplCopyWith(
          _$PaymentFilterImpl value, $Res Function(_$PaymentFilterImpl) then) =
      __$$PaymentFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTimeRange? dateRange,
      List<PaymentStatus>? statuses,
      List<PaymentMethod>? methods,
      double? minAmount,
      double? maxAmount,
      String? searchQuery});

  @override
  $DateTimeRangeCopyWith<$Res>? get dateRange;
}

/// @nodoc
class __$$PaymentFilterImplCopyWithImpl<$Res>
    extends _$PaymentFilterCopyWithImpl<$Res, _$PaymentFilterImpl>
    implements _$$PaymentFilterImplCopyWith<$Res> {
  __$$PaymentFilterImplCopyWithImpl(
      _$PaymentFilterImpl _value, $Res Function(_$PaymentFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dateRange = freezed,
    Object? statuses = freezed,
    Object? methods = freezed,
    Object? minAmount = freezed,
    Object? maxAmount = freezed,
    Object? searchQuery = freezed,
  }) {
    return _then(_$PaymentFilterImpl(
      dateRange: freezed == dateRange
          ? _value.dateRange
          : dateRange // ignore: cast_nullable_to_non_nullable
              as DateTimeRange?,
      statuses: freezed == statuses
          ? _value._statuses
          : statuses // ignore: cast_nullable_to_non_nullable
              as List<PaymentStatus>?,
      methods: freezed == methods
          ? _value._methods
          : methods // ignore: cast_nullable_to_non_nullable
              as List<PaymentMethod>?,
      minAmount: freezed == minAmount
          ? _value.minAmount
          : minAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      maxAmount: freezed == maxAmount
          ? _value.maxAmount
          : maxAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentFilterImpl implements _PaymentFilter {
  const _$PaymentFilterImpl(
      {this.dateRange,
      final List<PaymentStatus>? statuses,
      final List<PaymentMethod>? methods,
      this.minAmount,
      this.maxAmount,
      this.searchQuery})
      : _statuses = statuses,
        _methods = methods;

  factory _$PaymentFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentFilterImplFromJson(json);

  @override
  final DateTimeRange? dateRange;
  final List<PaymentStatus>? _statuses;
  @override
  List<PaymentStatus>? get statuses {
    final value = _statuses;
    if (value == null) return null;
    if (_statuses is EqualUnmodifiableListView) return _statuses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<PaymentMethod>? _methods;
  @override
  List<PaymentMethod>? get methods {
    final value = _methods;
    if (value == null) return null;
    if (_methods is EqualUnmodifiableListView) return _methods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final double? minAmount;
  @override
  final double? maxAmount;
  @override
  final String? searchQuery;

  @override
  String toString() {
    return 'PaymentFilter(dateRange: $dateRange, statuses: $statuses, methods: $methods, minAmount: $minAmount, maxAmount: $maxAmount, searchQuery: $searchQuery)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentFilterImpl &&
            (identical(other.dateRange, dateRange) ||
                other.dateRange == dateRange) &&
            const DeepCollectionEquality().equals(other._statuses, _statuses) &&
            const DeepCollectionEquality().equals(other._methods, _methods) &&
            (identical(other.minAmount, minAmount) ||
                other.minAmount == minAmount) &&
            (identical(other.maxAmount, maxAmount) ||
                other.maxAmount == maxAmount) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      dateRange,
      const DeepCollectionEquality().hash(_statuses),
      const DeepCollectionEquality().hash(_methods),
      minAmount,
      maxAmount,
      searchQuery);

  /// Create a copy of PaymentFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentFilterImplCopyWith<_$PaymentFilterImpl> get copyWith =>
      __$$PaymentFilterImplCopyWithImpl<_$PaymentFilterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentFilterImplToJson(
      this,
    );
  }
}

abstract class _PaymentFilter implements PaymentFilter {
  const factory _PaymentFilter(
      {final DateTimeRange? dateRange,
      final List<PaymentStatus>? statuses,
      final List<PaymentMethod>? methods,
      final double? minAmount,
      final double? maxAmount,
      final String? searchQuery}) = _$PaymentFilterImpl;

  factory _PaymentFilter.fromJson(Map<String, dynamic> json) =
      _$PaymentFilterImpl.fromJson;

  @override
  DateTimeRange? get dateRange;
  @override
  List<PaymentStatus>? get statuses;
  @override
  List<PaymentMethod>? get methods;
  @override
  double? get minAmount;
  @override
  double? get maxAmount;
  @override
  String? get searchQuery;

  /// Create a copy of PaymentFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentFilterImplCopyWith<_$PaymentFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DateTimeRange _$DateTimeRangeFromJson(Map<String, dynamic> json) {
  return _DateTimeRange.fromJson(json);
}

/// @nodoc
mixin _$DateTimeRange {
  DateTime get start => throw _privateConstructorUsedError;
  DateTime get end => throw _privateConstructorUsedError;

  /// Serializes this DateTimeRange to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DateTimeRange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DateTimeRangeCopyWith<DateTimeRange> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DateTimeRangeCopyWith<$Res> {
  factory $DateTimeRangeCopyWith(
          DateTimeRange value, $Res Function(DateTimeRange) then) =
      _$DateTimeRangeCopyWithImpl<$Res, DateTimeRange>;
  @useResult
  $Res call({DateTime start, DateTime end});
}

/// @nodoc
class _$DateTimeRangeCopyWithImpl<$Res, $Val extends DateTimeRange>
    implements $DateTimeRangeCopyWith<$Res> {
  _$DateTimeRangeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DateTimeRange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? start = null,
    Object? end = null,
  }) {
    return _then(_value.copyWith(
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime,
      end: null == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DateTimeRangeImplCopyWith<$Res>
    implements $DateTimeRangeCopyWith<$Res> {
  factory _$$DateTimeRangeImplCopyWith(
          _$DateTimeRangeImpl value, $Res Function(_$DateTimeRangeImpl) then) =
      __$$DateTimeRangeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime start, DateTime end});
}

/// @nodoc
class __$$DateTimeRangeImplCopyWithImpl<$Res>
    extends _$DateTimeRangeCopyWithImpl<$Res, _$DateTimeRangeImpl>
    implements _$$DateTimeRangeImplCopyWith<$Res> {
  __$$DateTimeRangeImplCopyWithImpl(
      _$DateTimeRangeImpl _value, $Res Function(_$DateTimeRangeImpl) _then)
      : super(_value, _then);

  /// Create a copy of DateTimeRange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? start = null,
    Object? end = null,
  }) {
    return _then(_$DateTimeRangeImpl(
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime,
      end: null == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DateTimeRangeImpl implements _DateTimeRange {
  const _$DateTimeRangeImpl({required this.start, required this.end});

  factory _$DateTimeRangeImpl.fromJson(Map<String, dynamic> json) =>
      _$$DateTimeRangeImplFromJson(json);

  @override
  final DateTime start;
  @override
  final DateTime end;

  @override
  String toString() {
    return 'DateTimeRange(start: $start, end: $end)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DateTimeRangeImpl &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, start, end);

  /// Create a copy of DateTimeRange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DateTimeRangeImplCopyWith<_$DateTimeRangeImpl> get copyWith =>
      __$$DateTimeRangeImplCopyWithImpl<_$DateTimeRangeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DateTimeRangeImplToJson(
      this,
    );
  }
}

abstract class _DateTimeRange implements DateTimeRange {
  const factory _DateTimeRange(
      {required final DateTime start,
      required final DateTime end}) = _$DateTimeRangeImpl;

  factory _DateTimeRange.fromJson(Map<String, dynamic> json) =
      _$DateTimeRangeImpl.fromJson;

  @override
  DateTime get start;
  @override
  DateTime get end;

  /// Create a copy of DateTimeRange
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DateTimeRangeImplCopyWith<_$DateTimeRangeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
