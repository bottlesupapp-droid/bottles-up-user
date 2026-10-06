// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tip_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TipRecord _$TipRecordFromJson(Map<String, dynamic> json) {
  return _TipRecord.fromJson(json);
}

/// @nodoc
mixin _$TipRecord {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get bookingId => throw _privateConstructorUsedError;
  String? get venueId => throw _privateConstructorUsedError;
  String? get venueName => throw _privateConstructorUsedError;
  String? get staffId => throw _privateConstructorUsedError;
  String? get staffName => throw _privateConstructorUsedError;
  double get tipAmount => throw _privateConstructorUsedError;
  double get billAmount => throw _privateConstructorUsedError;
  TipType get tipType => throw _privateConstructorUsedError;
  double? get tipPercentage => throw _privateConstructorUsedError;
  String? get paymentMethod => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this TipRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TipRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TipRecordCopyWith<TipRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TipRecordCopyWith<$Res> {
  factory $TipRecordCopyWith(TipRecord value, $Res Function(TipRecord) then) =
      _$TipRecordCopyWithImpl<$Res, TipRecord>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String bookingId,
      String? venueId,
      String? venueName,
      String? staffId,
      String? staffName,
      double tipAmount,
      double billAmount,
      TipType tipType,
      double? tipPercentage,
      String? paymentMethod,
      String? currency,
      Map<String, dynamic>? metadata,
      DateTime createdAt});
}

/// @nodoc
class _$TipRecordCopyWithImpl<$Res, $Val extends TipRecord>
    implements $TipRecordCopyWith<$Res> {
  _$TipRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TipRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? bookingId = null,
    Object? venueId = freezed,
    Object? venueName = freezed,
    Object? staffId = freezed,
    Object? staffName = freezed,
    Object? tipAmount = null,
    Object? billAmount = null,
    Object? tipType = null,
    Object? tipPercentage = freezed,
    Object? paymentMethod = freezed,
    Object? currency = freezed,
    Object? metadata = freezed,
    Object? createdAt = null,
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
      venueId: freezed == venueId
          ? _value.venueId
          : venueId // ignore: cast_nullable_to_non_nullable
              as String?,
      venueName: freezed == venueName
          ? _value.venueName
          : venueName // ignore: cast_nullable_to_non_nullable
              as String?,
      staffId: freezed == staffId
          ? _value.staffId
          : staffId // ignore: cast_nullable_to_non_nullable
              as String?,
      staffName: freezed == staffName
          ? _value.staffName
          : staffName // ignore: cast_nullable_to_non_nullable
              as String?,
      tipAmount: null == tipAmount
          ? _value.tipAmount
          : tipAmount // ignore: cast_nullable_to_non_nullable
              as double,
      billAmount: null == billAmount
          ? _value.billAmount
          : billAmount // ignore: cast_nullable_to_non_nullable
              as double,
      tipType: null == tipType
          ? _value.tipType
          : tipType // ignore: cast_nullable_to_non_nullable
              as TipType,
      tipPercentage: freezed == tipPercentage
          ? _value.tipPercentage
          : tipPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TipRecordImplCopyWith<$Res>
    implements $TipRecordCopyWith<$Res> {
  factory _$$TipRecordImplCopyWith(
          _$TipRecordImpl value, $Res Function(_$TipRecordImpl) then) =
      __$$TipRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String bookingId,
      String? venueId,
      String? venueName,
      String? staffId,
      String? staffName,
      double tipAmount,
      double billAmount,
      TipType tipType,
      double? tipPercentage,
      String? paymentMethod,
      String? currency,
      Map<String, dynamic>? metadata,
      DateTime createdAt});
}

/// @nodoc
class __$$TipRecordImplCopyWithImpl<$Res>
    extends _$TipRecordCopyWithImpl<$Res, _$TipRecordImpl>
    implements _$$TipRecordImplCopyWith<$Res> {
  __$$TipRecordImplCopyWithImpl(
      _$TipRecordImpl _value, $Res Function(_$TipRecordImpl) _then)
      : super(_value, _then);

  /// Create a copy of TipRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? bookingId = null,
    Object? venueId = freezed,
    Object? venueName = freezed,
    Object? staffId = freezed,
    Object? staffName = freezed,
    Object? tipAmount = null,
    Object? billAmount = null,
    Object? tipType = null,
    Object? tipPercentage = freezed,
    Object? paymentMethod = freezed,
    Object? currency = freezed,
    Object? metadata = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$TipRecordImpl(
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
      venueId: freezed == venueId
          ? _value.venueId
          : venueId // ignore: cast_nullable_to_non_nullable
              as String?,
      venueName: freezed == venueName
          ? _value.venueName
          : venueName // ignore: cast_nullable_to_non_nullable
              as String?,
      staffId: freezed == staffId
          ? _value.staffId
          : staffId // ignore: cast_nullable_to_non_nullable
              as String?,
      staffName: freezed == staffName
          ? _value.staffName
          : staffName // ignore: cast_nullable_to_non_nullable
              as String?,
      tipAmount: null == tipAmount
          ? _value.tipAmount
          : tipAmount // ignore: cast_nullable_to_non_nullable
              as double,
      billAmount: null == billAmount
          ? _value.billAmount
          : billAmount // ignore: cast_nullable_to_non_nullable
              as double,
      tipType: null == tipType
          ? _value.tipType
          : tipType // ignore: cast_nullable_to_non_nullable
              as TipType,
      tipPercentage: freezed == tipPercentage
          ? _value.tipPercentage
          : tipPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TipRecordImpl implements _TipRecord {
  const _$TipRecordImpl(
      {required this.id,
      required this.userId,
      required this.bookingId,
      this.venueId,
      this.venueName,
      this.staffId,
      this.staffName,
      required this.tipAmount,
      required this.billAmount,
      required this.tipType,
      this.tipPercentage,
      this.paymentMethod,
      this.currency,
      final Map<String, dynamic>? metadata,
      required this.createdAt})
      : _metadata = metadata;

  factory _$TipRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$TipRecordImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String bookingId;
  @override
  final String? venueId;
  @override
  final String? venueName;
  @override
  final String? staffId;
  @override
  final String? staffName;
  @override
  final double tipAmount;
  @override
  final double billAmount;
  @override
  final TipType tipType;
  @override
  final double? tipPercentage;
  @override
  final String? paymentMethod;
  @override
  final String? currency;
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
  String toString() {
    return 'TipRecord(id: $id, userId: $userId, bookingId: $bookingId, venueId: $venueId, venueName: $venueName, staffId: $staffId, staffName: $staffName, tipAmount: $tipAmount, billAmount: $billAmount, tipType: $tipType, tipPercentage: $tipPercentage, paymentMethod: $paymentMethod, currency: $currency, metadata: $metadata, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TipRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.venueId, venueId) || other.venueId == venueId) &&
            (identical(other.venueName, venueName) ||
                other.venueName == venueName) &&
            (identical(other.staffId, staffId) || other.staffId == staffId) &&
            (identical(other.staffName, staffName) ||
                other.staffName == staffName) &&
            (identical(other.tipAmount, tipAmount) ||
                other.tipAmount == tipAmount) &&
            (identical(other.billAmount, billAmount) ||
                other.billAmount == billAmount) &&
            (identical(other.tipType, tipType) || other.tipType == tipType) &&
            (identical(other.tipPercentage, tipPercentage) ||
                other.tipPercentage == tipPercentage) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      bookingId,
      venueId,
      venueName,
      staffId,
      staffName,
      tipAmount,
      billAmount,
      tipType,
      tipPercentage,
      paymentMethod,
      currency,
      const DeepCollectionEquality().hash(_metadata),
      createdAt);

  /// Create a copy of TipRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TipRecordImplCopyWith<_$TipRecordImpl> get copyWith =>
      __$$TipRecordImplCopyWithImpl<_$TipRecordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TipRecordImplToJson(
      this,
    );
  }
}

abstract class _TipRecord implements TipRecord {
  const factory _TipRecord(
      {required final String id,
      required final String userId,
      required final String bookingId,
      final String? venueId,
      final String? venueName,
      final String? staffId,
      final String? staffName,
      required final double tipAmount,
      required final double billAmount,
      required final TipType tipType,
      final double? tipPercentage,
      final String? paymentMethod,
      final String? currency,
      final Map<String, dynamic>? metadata,
      required final DateTime createdAt}) = _$TipRecordImpl;

  factory _TipRecord.fromJson(Map<String, dynamic> json) =
      _$TipRecordImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get bookingId;
  @override
  String? get venueId;
  @override
  String? get venueName;
  @override
  String? get staffId;
  @override
  String? get staffName;
  @override
  double get tipAmount;
  @override
  double get billAmount;
  @override
  TipType get tipType;
  @override
  double? get tipPercentage;
  @override
  String? get paymentMethod;
  @override
  String? get currency;
  @override
  Map<String, dynamic>? get metadata;
  @override
  DateTime get createdAt;

  /// Create a copy of TipRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TipRecordImplCopyWith<_$TipRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TipStatistics _$TipStatisticsFromJson(Map<String, dynamic> json) {
  return _TipStatistics.fromJson(json);
}

/// @nodoc
mixin _$TipStatistics {
  double get totalTipped => throw _privateConstructorUsedError;
  double get averageTipAmount => throw _privateConstructorUsedError;
  double get averageTipPercentage => throw _privateConstructorUsedError;
  int get totalTips => throw _privateConstructorUsedError;
  Map<String, double> get tipsByVenue => throw _privateConstructorUsedError;
  Map<String, int> get tipsByMonth => throw _privateConstructorUsedError;
  double? get highestTip => throw _privateConstructorUsedError;
  double? get lowestTip => throw _privateConstructorUsedError;
  String? get mostTippedVenue => throw _privateConstructorUsedError;

  /// Serializes this TipStatistics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TipStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TipStatisticsCopyWith<TipStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TipStatisticsCopyWith<$Res> {
  factory $TipStatisticsCopyWith(
          TipStatistics value, $Res Function(TipStatistics) then) =
      _$TipStatisticsCopyWithImpl<$Res, TipStatistics>;
  @useResult
  $Res call(
      {double totalTipped,
      double averageTipAmount,
      double averageTipPercentage,
      int totalTips,
      Map<String, double> tipsByVenue,
      Map<String, int> tipsByMonth,
      double? highestTip,
      double? lowestTip,
      String? mostTippedVenue});
}

/// @nodoc
class _$TipStatisticsCopyWithImpl<$Res, $Val extends TipStatistics>
    implements $TipStatisticsCopyWith<$Res> {
  _$TipStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TipStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalTipped = null,
    Object? averageTipAmount = null,
    Object? averageTipPercentage = null,
    Object? totalTips = null,
    Object? tipsByVenue = null,
    Object? tipsByMonth = null,
    Object? highestTip = freezed,
    Object? lowestTip = freezed,
    Object? mostTippedVenue = freezed,
  }) {
    return _then(_value.copyWith(
      totalTipped: null == totalTipped
          ? _value.totalTipped
          : totalTipped // ignore: cast_nullable_to_non_nullable
              as double,
      averageTipAmount: null == averageTipAmount
          ? _value.averageTipAmount
          : averageTipAmount // ignore: cast_nullable_to_non_nullable
              as double,
      averageTipPercentage: null == averageTipPercentage
          ? _value.averageTipPercentage
          : averageTipPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      totalTips: null == totalTips
          ? _value.totalTips
          : totalTips // ignore: cast_nullable_to_non_nullable
              as int,
      tipsByVenue: null == tipsByVenue
          ? _value.tipsByVenue
          : tipsByVenue // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      tipsByMonth: null == tipsByMonth
          ? _value.tipsByMonth
          : tipsByMonth // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      highestTip: freezed == highestTip
          ? _value.highestTip
          : highestTip // ignore: cast_nullable_to_non_nullable
              as double?,
      lowestTip: freezed == lowestTip
          ? _value.lowestTip
          : lowestTip // ignore: cast_nullable_to_non_nullable
              as double?,
      mostTippedVenue: freezed == mostTippedVenue
          ? _value.mostTippedVenue
          : mostTippedVenue // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TipStatisticsImplCopyWith<$Res>
    implements $TipStatisticsCopyWith<$Res> {
  factory _$$TipStatisticsImplCopyWith(
          _$TipStatisticsImpl value, $Res Function(_$TipStatisticsImpl) then) =
      __$$TipStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double totalTipped,
      double averageTipAmount,
      double averageTipPercentage,
      int totalTips,
      Map<String, double> tipsByVenue,
      Map<String, int> tipsByMonth,
      double? highestTip,
      double? lowestTip,
      String? mostTippedVenue});
}

/// @nodoc
class __$$TipStatisticsImplCopyWithImpl<$Res>
    extends _$TipStatisticsCopyWithImpl<$Res, _$TipStatisticsImpl>
    implements _$$TipStatisticsImplCopyWith<$Res> {
  __$$TipStatisticsImplCopyWithImpl(
      _$TipStatisticsImpl _value, $Res Function(_$TipStatisticsImpl) _then)
      : super(_value, _then);

  /// Create a copy of TipStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalTipped = null,
    Object? averageTipAmount = null,
    Object? averageTipPercentage = null,
    Object? totalTips = null,
    Object? tipsByVenue = null,
    Object? tipsByMonth = null,
    Object? highestTip = freezed,
    Object? lowestTip = freezed,
    Object? mostTippedVenue = freezed,
  }) {
    return _then(_$TipStatisticsImpl(
      totalTipped: null == totalTipped
          ? _value.totalTipped
          : totalTipped // ignore: cast_nullable_to_non_nullable
              as double,
      averageTipAmount: null == averageTipAmount
          ? _value.averageTipAmount
          : averageTipAmount // ignore: cast_nullable_to_non_nullable
              as double,
      averageTipPercentage: null == averageTipPercentage
          ? _value.averageTipPercentage
          : averageTipPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      totalTips: null == totalTips
          ? _value.totalTips
          : totalTips // ignore: cast_nullable_to_non_nullable
              as int,
      tipsByVenue: null == tipsByVenue
          ? _value._tipsByVenue
          : tipsByVenue // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      tipsByMonth: null == tipsByMonth
          ? _value._tipsByMonth
          : tipsByMonth // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      highestTip: freezed == highestTip
          ? _value.highestTip
          : highestTip // ignore: cast_nullable_to_non_nullable
              as double?,
      lowestTip: freezed == lowestTip
          ? _value.lowestTip
          : lowestTip // ignore: cast_nullable_to_non_nullable
              as double?,
      mostTippedVenue: freezed == mostTippedVenue
          ? _value.mostTippedVenue
          : mostTippedVenue // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TipStatisticsImpl implements _TipStatistics {
  const _$TipStatisticsImpl(
      {required this.totalTipped,
      required this.averageTipAmount,
      required this.averageTipPercentage,
      required this.totalTips,
      required final Map<String, double> tipsByVenue,
      required final Map<String, int> tipsByMonth,
      this.highestTip,
      this.lowestTip,
      this.mostTippedVenue})
      : _tipsByVenue = tipsByVenue,
        _tipsByMonth = tipsByMonth;

  factory _$TipStatisticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TipStatisticsImplFromJson(json);

  @override
  final double totalTipped;
  @override
  final double averageTipAmount;
  @override
  final double averageTipPercentage;
  @override
  final int totalTips;
  final Map<String, double> _tipsByVenue;
  @override
  Map<String, double> get tipsByVenue {
    if (_tipsByVenue is EqualUnmodifiableMapView) return _tipsByVenue;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_tipsByVenue);
  }

  final Map<String, int> _tipsByMonth;
  @override
  Map<String, int> get tipsByMonth {
    if (_tipsByMonth is EqualUnmodifiableMapView) return _tipsByMonth;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_tipsByMonth);
  }

  @override
  final double? highestTip;
  @override
  final double? lowestTip;
  @override
  final String? mostTippedVenue;

  @override
  String toString() {
    return 'TipStatistics(totalTipped: $totalTipped, averageTipAmount: $averageTipAmount, averageTipPercentage: $averageTipPercentage, totalTips: $totalTips, tipsByVenue: $tipsByVenue, tipsByMonth: $tipsByMonth, highestTip: $highestTip, lowestTip: $lowestTip, mostTippedVenue: $mostTippedVenue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TipStatisticsImpl &&
            (identical(other.totalTipped, totalTipped) ||
                other.totalTipped == totalTipped) &&
            (identical(other.averageTipAmount, averageTipAmount) ||
                other.averageTipAmount == averageTipAmount) &&
            (identical(other.averageTipPercentage, averageTipPercentage) ||
                other.averageTipPercentage == averageTipPercentage) &&
            (identical(other.totalTips, totalTips) ||
                other.totalTips == totalTips) &&
            const DeepCollectionEquality()
                .equals(other._tipsByVenue, _tipsByVenue) &&
            const DeepCollectionEquality()
                .equals(other._tipsByMonth, _tipsByMonth) &&
            (identical(other.highestTip, highestTip) ||
                other.highestTip == highestTip) &&
            (identical(other.lowestTip, lowestTip) ||
                other.lowestTip == lowestTip) &&
            (identical(other.mostTippedVenue, mostTippedVenue) ||
                other.mostTippedVenue == mostTippedVenue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalTipped,
      averageTipAmount,
      averageTipPercentage,
      totalTips,
      const DeepCollectionEquality().hash(_tipsByVenue),
      const DeepCollectionEquality().hash(_tipsByMonth),
      highestTip,
      lowestTip,
      mostTippedVenue);

  /// Create a copy of TipStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TipStatisticsImplCopyWith<_$TipStatisticsImpl> get copyWith =>
      __$$TipStatisticsImplCopyWithImpl<_$TipStatisticsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TipStatisticsImplToJson(
      this,
    );
  }
}

abstract class _TipStatistics implements TipStatistics {
  const factory _TipStatistics(
      {required final double totalTipped,
      required final double averageTipAmount,
      required final double averageTipPercentage,
      required final int totalTips,
      required final Map<String, double> tipsByVenue,
      required final Map<String, int> tipsByMonth,
      final double? highestTip,
      final double? lowestTip,
      final String? mostTippedVenue}) = _$TipStatisticsImpl;

  factory _TipStatistics.fromJson(Map<String, dynamic> json) =
      _$TipStatisticsImpl.fromJson;

  @override
  double get totalTipped;
  @override
  double get averageTipAmount;
  @override
  double get averageTipPercentage;
  @override
  int get totalTips;
  @override
  Map<String, double> get tipsByVenue;
  @override
  Map<String, int> get tipsByMonth;
  @override
  double? get highestTip;
  @override
  double? get lowestTip;
  @override
  String? get mostTippedVenue;

  /// Create a copy of TipStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TipStatisticsImplCopyWith<_$TipStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TipPreset _$TipPresetFromJson(Map<String, dynamic> json) {
  return _TipPreset.fromJson(json);
}

/// @nodoc
mixin _$TipPreset {
  String get label => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;
  bool? get isDefault => throw _privateConstructorUsedError;

  /// Serializes this TipPreset to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TipPreset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TipPresetCopyWith<TipPreset> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TipPresetCopyWith<$Res> {
  factory $TipPresetCopyWith(TipPreset value, $Res Function(TipPreset) then) =
      _$TipPresetCopyWithImpl<$Res, TipPreset>;
  @useResult
  $Res call({String label, double percentage, bool? isDefault});
}

/// @nodoc
class _$TipPresetCopyWithImpl<$Res, $Val extends TipPreset>
    implements $TipPresetCopyWith<$Res> {
  _$TipPresetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TipPreset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? percentage = null,
    Object? isDefault = freezed,
  }) {
    return _then(_value.copyWith(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
      isDefault: freezed == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TipPresetImplCopyWith<$Res>
    implements $TipPresetCopyWith<$Res> {
  factory _$$TipPresetImplCopyWith(
          _$TipPresetImpl value, $Res Function(_$TipPresetImpl) then) =
      __$$TipPresetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String label, double percentage, bool? isDefault});
}

/// @nodoc
class __$$TipPresetImplCopyWithImpl<$Res>
    extends _$TipPresetCopyWithImpl<$Res, _$TipPresetImpl>
    implements _$$TipPresetImplCopyWith<$Res> {
  __$$TipPresetImplCopyWithImpl(
      _$TipPresetImpl _value, $Res Function(_$TipPresetImpl) _then)
      : super(_value, _then);

  /// Create a copy of TipPreset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? percentage = null,
    Object? isDefault = freezed,
  }) {
    return _then(_$TipPresetImpl(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
      isDefault: freezed == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TipPresetImpl implements _TipPreset {
  const _$TipPresetImpl(
      {required this.label, required this.percentage, this.isDefault});

  factory _$TipPresetImpl.fromJson(Map<String, dynamic> json) =>
      _$$TipPresetImplFromJson(json);

  @override
  final String label;
  @override
  final double percentage;
  @override
  final bool? isDefault;

  @override
  String toString() {
    return 'TipPreset(label: $label, percentage: $percentage, isDefault: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TipPresetImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, label, percentage, isDefault);

  /// Create a copy of TipPreset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TipPresetImplCopyWith<_$TipPresetImpl> get copyWith =>
      __$$TipPresetImplCopyWithImpl<_$TipPresetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TipPresetImplToJson(
      this,
    );
  }
}

abstract class _TipPreset implements TipPreset {
  const factory _TipPreset(
      {required final String label,
      required final double percentage,
      final bool? isDefault}) = _$TipPresetImpl;

  factory _TipPreset.fromJson(Map<String, dynamic> json) =
      _$TipPresetImpl.fromJson;

  @override
  String get label;
  @override
  double get percentage;
  @override
  bool? get isDefault;

  /// Create a copy of TipPreset
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TipPresetImplCopyWith<_$TipPresetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
