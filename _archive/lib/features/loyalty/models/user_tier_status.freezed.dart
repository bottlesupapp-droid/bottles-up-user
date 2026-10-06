// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_tier_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserTierStatus _$UserTierStatusFromJson(Map<String, dynamic> json) {
  return _UserTierStatus.fromJson(json);
}

/// @nodoc
mixin _$UserTierStatus {
  String get userId => throw _privateConstructorUsedError;
  TierLevel get currentTier => throw _privateConstructorUsedError;
  int get totalPoints => throw _privateConstructorUsedError;
  double get totalSpend => throw _privateConstructorUsedError;
  int get yearlyPoints => throw _privateConstructorUsedError;
  double get yearlySpend => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;
  TierLevel? get nextTier => throw _privateConstructorUsedError;
  int? get pointsToNextTier => throw _privateConstructorUsedError;
  double? get spendToNextTier => throw _privateConstructorUsedError;
  List<TierTransaction> get recentTransactions =>
      throw _privateConstructorUsedError;
  DateTime? get birthdayRewardClaimedAt => throw _privateConstructorUsedError;
  int get referralCount => throw _privateConstructorUsedError;
  int get referralPoints => throw _privateConstructorUsedError;

  /// Serializes this UserTierStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserTierStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserTierStatusCopyWith<UserTierStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserTierStatusCopyWith<$Res> {
  factory $UserTierStatusCopyWith(
          UserTierStatus value, $Res Function(UserTierStatus) then) =
      _$UserTierStatusCopyWithImpl<$Res, UserTierStatus>;
  @useResult
  $Res call(
      {String userId,
      TierLevel currentTier,
      int totalPoints,
      double totalSpend,
      int yearlyPoints,
      double yearlySpend,
      DateTime lastUpdated,
      TierLevel? nextTier,
      int? pointsToNextTier,
      double? spendToNextTier,
      List<TierTransaction> recentTransactions,
      DateTime? birthdayRewardClaimedAt,
      int referralCount,
      int referralPoints});
}

/// @nodoc
class _$UserTierStatusCopyWithImpl<$Res, $Val extends UserTierStatus>
    implements $UserTierStatusCopyWith<$Res> {
  _$UserTierStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserTierStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? currentTier = null,
    Object? totalPoints = null,
    Object? totalSpend = null,
    Object? yearlyPoints = null,
    Object? yearlySpend = null,
    Object? lastUpdated = null,
    Object? nextTier = freezed,
    Object? pointsToNextTier = freezed,
    Object? spendToNextTier = freezed,
    Object? recentTransactions = null,
    Object? birthdayRewardClaimedAt = freezed,
    Object? referralCount = null,
    Object? referralPoints = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      currentTier: null == currentTier
          ? _value.currentTier
          : currentTier // ignore: cast_nullable_to_non_nullable
              as TierLevel,
      totalPoints: null == totalPoints
          ? _value.totalPoints
          : totalPoints // ignore: cast_nullable_to_non_nullable
              as int,
      totalSpend: null == totalSpend
          ? _value.totalSpend
          : totalSpend // ignore: cast_nullable_to_non_nullable
              as double,
      yearlyPoints: null == yearlyPoints
          ? _value.yearlyPoints
          : yearlyPoints // ignore: cast_nullable_to_non_nullable
              as int,
      yearlySpend: null == yearlySpend
          ? _value.yearlySpend
          : yearlySpend // ignore: cast_nullable_to_non_nullable
              as double,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      nextTier: freezed == nextTier
          ? _value.nextTier
          : nextTier // ignore: cast_nullable_to_non_nullable
              as TierLevel?,
      pointsToNextTier: freezed == pointsToNextTier
          ? _value.pointsToNextTier
          : pointsToNextTier // ignore: cast_nullable_to_non_nullable
              as int?,
      spendToNextTier: freezed == spendToNextTier
          ? _value.spendToNextTier
          : spendToNextTier // ignore: cast_nullable_to_non_nullable
              as double?,
      recentTransactions: null == recentTransactions
          ? _value.recentTransactions
          : recentTransactions // ignore: cast_nullable_to_non_nullable
              as List<TierTransaction>,
      birthdayRewardClaimedAt: freezed == birthdayRewardClaimedAt
          ? _value.birthdayRewardClaimedAt
          : birthdayRewardClaimedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      referralCount: null == referralCount
          ? _value.referralCount
          : referralCount // ignore: cast_nullable_to_non_nullable
              as int,
      referralPoints: null == referralPoints
          ? _value.referralPoints
          : referralPoints // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserTierStatusImplCopyWith<$Res>
    implements $UserTierStatusCopyWith<$Res> {
  factory _$$UserTierStatusImplCopyWith(_$UserTierStatusImpl value,
          $Res Function(_$UserTierStatusImpl) then) =
      __$$UserTierStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      TierLevel currentTier,
      int totalPoints,
      double totalSpend,
      int yearlyPoints,
      double yearlySpend,
      DateTime lastUpdated,
      TierLevel? nextTier,
      int? pointsToNextTier,
      double? spendToNextTier,
      List<TierTransaction> recentTransactions,
      DateTime? birthdayRewardClaimedAt,
      int referralCount,
      int referralPoints});
}

/// @nodoc
class __$$UserTierStatusImplCopyWithImpl<$Res>
    extends _$UserTierStatusCopyWithImpl<$Res, _$UserTierStatusImpl>
    implements _$$UserTierStatusImplCopyWith<$Res> {
  __$$UserTierStatusImplCopyWithImpl(
      _$UserTierStatusImpl _value, $Res Function(_$UserTierStatusImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserTierStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? currentTier = null,
    Object? totalPoints = null,
    Object? totalSpend = null,
    Object? yearlyPoints = null,
    Object? yearlySpend = null,
    Object? lastUpdated = null,
    Object? nextTier = freezed,
    Object? pointsToNextTier = freezed,
    Object? spendToNextTier = freezed,
    Object? recentTransactions = null,
    Object? birthdayRewardClaimedAt = freezed,
    Object? referralCount = null,
    Object? referralPoints = null,
  }) {
    return _then(_$UserTierStatusImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      currentTier: null == currentTier
          ? _value.currentTier
          : currentTier // ignore: cast_nullable_to_non_nullable
              as TierLevel,
      totalPoints: null == totalPoints
          ? _value.totalPoints
          : totalPoints // ignore: cast_nullable_to_non_nullable
              as int,
      totalSpend: null == totalSpend
          ? _value.totalSpend
          : totalSpend // ignore: cast_nullable_to_non_nullable
              as double,
      yearlyPoints: null == yearlyPoints
          ? _value.yearlyPoints
          : yearlyPoints // ignore: cast_nullable_to_non_nullable
              as int,
      yearlySpend: null == yearlySpend
          ? _value.yearlySpend
          : yearlySpend // ignore: cast_nullable_to_non_nullable
              as double,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      nextTier: freezed == nextTier
          ? _value.nextTier
          : nextTier // ignore: cast_nullable_to_non_nullable
              as TierLevel?,
      pointsToNextTier: freezed == pointsToNextTier
          ? _value.pointsToNextTier
          : pointsToNextTier // ignore: cast_nullable_to_non_nullable
              as int?,
      spendToNextTier: freezed == spendToNextTier
          ? _value.spendToNextTier
          : spendToNextTier // ignore: cast_nullable_to_non_nullable
              as double?,
      recentTransactions: null == recentTransactions
          ? _value._recentTransactions
          : recentTransactions // ignore: cast_nullable_to_non_nullable
              as List<TierTransaction>,
      birthdayRewardClaimedAt: freezed == birthdayRewardClaimedAt
          ? _value.birthdayRewardClaimedAt
          : birthdayRewardClaimedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      referralCount: null == referralCount
          ? _value.referralCount
          : referralCount // ignore: cast_nullable_to_non_nullable
              as int,
      referralPoints: null == referralPoints
          ? _value.referralPoints
          : referralPoints // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserTierStatusImpl implements _UserTierStatus {
  const _$UserTierStatusImpl(
      {required this.userId,
      required this.currentTier,
      required this.totalPoints,
      required this.totalSpend,
      required this.yearlyPoints,
      required this.yearlySpend,
      required this.lastUpdated,
      this.nextTier,
      this.pointsToNextTier,
      this.spendToNextTier,
      final List<TierTransaction> recentTransactions = const [],
      this.birthdayRewardClaimedAt,
      this.referralCount = 0,
      this.referralPoints = 0})
      : _recentTransactions = recentTransactions;

  factory _$UserTierStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserTierStatusImplFromJson(json);

  @override
  final String userId;
  @override
  final TierLevel currentTier;
  @override
  final int totalPoints;
  @override
  final double totalSpend;
  @override
  final int yearlyPoints;
  @override
  final double yearlySpend;
  @override
  final DateTime lastUpdated;
  @override
  final TierLevel? nextTier;
  @override
  final int? pointsToNextTier;
  @override
  final double? spendToNextTier;
  final List<TierTransaction> _recentTransactions;
  @override
  @JsonKey()
  List<TierTransaction> get recentTransactions {
    if (_recentTransactions is EqualUnmodifiableListView)
      return _recentTransactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentTransactions);
  }

  @override
  final DateTime? birthdayRewardClaimedAt;
  @override
  @JsonKey()
  final int referralCount;
  @override
  @JsonKey()
  final int referralPoints;

  @override
  String toString() {
    return 'UserTierStatus(userId: $userId, currentTier: $currentTier, totalPoints: $totalPoints, totalSpend: $totalSpend, yearlyPoints: $yearlyPoints, yearlySpend: $yearlySpend, lastUpdated: $lastUpdated, nextTier: $nextTier, pointsToNextTier: $pointsToNextTier, spendToNextTier: $spendToNextTier, recentTransactions: $recentTransactions, birthdayRewardClaimedAt: $birthdayRewardClaimedAt, referralCount: $referralCount, referralPoints: $referralPoints)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserTierStatusImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.currentTier, currentTier) ||
                other.currentTier == currentTier) &&
            (identical(other.totalPoints, totalPoints) ||
                other.totalPoints == totalPoints) &&
            (identical(other.totalSpend, totalSpend) ||
                other.totalSpend == totalSpend) &&
            (identical(other.yearlyPoints, yearlyPoints) ||
                other.yearlyPoints == yearlyPoints) &&
            (identical(other.yearlySpend, yearlySpend) ||
                other.yearlySpend == yearlySpend) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.nextTier, nextTier) ||
                other.nextTier == nextTier) &&
            (identical(other.pointsToNextTier, pointsToNextTier) ||
                other.pointsToNextTier == pointsToNextTier) &&
            (identical(other.spendToNextTier, spendToNextTier) ||
                other.spendToNextTier == spendToNextTier) &&
            const DeepCollectionEquality()
                .equals(other._recentTransactions, _recentTransactions) &&
            (identical(
                    other.birthdayRewardClaimedAt, birthdayRewardClaimedAt) ||
                other.birthdayRewardClaimedAt == birthdayRewardClaimedAt) &&
            (identical(other.referralCount, referralCount) ||
                other.referralCount == referralCount) &&
            (identical(other.referralPoints, referralPoints) ||
                other.referralPoints == referralPoints));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      currentTier,
      totalPoints,
      totalSpend,
      yearlyPoints,
      yearlySpend,
      lastUpdated,
      nextTier,
      pointsToNextTier,
      spendToNextTier,
      const DeepCollectionEquality().hash(_recentTransactions),
      birthdayRewardClaimedAt,
      referralCount,
      referralPoints);

  /// Create a copy of UserTierStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserTierStatusImplCopyWith<_$UserTierStatusImpl> get copyWith =>
      __$$UserTierStatusImplCopyWithImpl<_$UserTierStatusImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserTierStatusImplToJson(
      this,
    );
  }
}

abstract class _UserTierStatus implements UserTierStatus {
  const factory _UserTierStatus(
      {required final String userId,
      required final TierLevel currentTier,
      required final int totalPoints,
      required final double totalSpend,
      required final int yearlyPoints,
      required final double yearlySpend,
      required final DateTime lastUpdated,
      final TierLevel? nextTier,
      final int? pointsToNextTier,
      final double? spendToNextTier,
      final List<TierTransaction> recentTransactions,
      final DateTime? birthdayRewardClaimedAt,
      final int referralCount,
      final int referralPoints}) = _$UserTierStatusImpl;

  factory _UserTierStatus.fromJson(Map<String, dynamic> json) =
      _$UserTierStatusImpl.fromJson;

  @override
  String get userId;
  @override
  TierLevel get currentTier;
  @override
  int get totalPoints;
  @override
  double get totalSpend;
  @override
  int get yearlyPoints;
  @override
  double get yearlySpend;
  @override
  DateTime get lastUpdated;
  @override
  TierLevel? get nextTier;
  @override
  int? get pointsToNextTier;
  @override
  double? get spendToNextTier;
  @override
  List<TierTransaction> get recentTransactions;
  @override
  DateTime? get birthdayRewardClaimedAt;
  @override
  int get referralCount;
  @override
  int get referralPoints;

  /// Create a copy of UserTierStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserTierStatusImplCopyWith<_$UserTierStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TierTransaction _$TierTransactionFromJson(Map<String, dynamic> json) {
  return _TierTransaction.fromJson(json);
}

/// @nodoc
mixin _$TierTransaction {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  TierTransactionType get type => throw _privateConstructorUsedError;
  int get points => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get bookingId => throw _privateConstructorUsedError;
  String? get eventId => throw _privateConstructorUsedError;

  /// Serializes this TierTransaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TierTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TierTransactionCopyWith<TierTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TierTransactionCopyWith<$Res> {
  factory $TierTransactionCopyWith(
          TierTransaction value, $Res Function(TierTransaction) then) =
      _$TierTransactionCopyWithImpl<$Res, TierTransaction>;
  @useResult
  $Res call(
      {String id,
      String userId,
      TierTransactionType type,
      int points,
      double amount,
      DateTime createdAt,
      String? description,
      String? bookingId,
      String? eventId});
}

/// @nodoc
class _$TierTransactionCopyWithImpl<$Res, $Val extends TierTransaction>
    implements $TierTransactionCopyWith<$Res> {
  _$TierTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TierTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? points = null,
    Object? amount = null,
    Object? createdAt = null,
    Object? description = freezed,
    Object? bookingId = freezed,
    Object? eventId = freezed,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TierTransactionType,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingId: freezed == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String?,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TierTransactionImplCopyWith<$Res>
    implements $TierTransactionCopyWith<$Res> {
  factory _$$TierTransactionImplCopyWith(_$TierTransactionImpl value,
          $Res Function(_$TierTransactionImpl) then) =
      __$$TierTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      TierTransactionType type,
      int points,
      double amount,
      DateTime createdAt,
      String? description,
      String? bookingId,
      String? eventId});
}

/// @nodoc
class __$$TierTransactionImplCopyWithImpl<$Res>
    extends _$TierTransactionCopyWithImpl<$Res, _$TierTransactionImpl>
    implements _$$TierTransactionImplCopyWith<$Res> {
  __$$TierTransactionImplCopyWithImpl(
      _$TierTransactionImpl _value, $Res Function(_$TierTransactionImpl) _then)
      : super(_value, _then);

  /// Create a copy of TierTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? points = null,
    Object? amount = null,
    Object? createdAt = null,
    Object? description = freezed,
    Object? bookingId = freezed,
    Object? eventId = freezed,
  }) {
    return _then(_$TierTransactionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TierTransactionType,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingId: freezed == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String?,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TierTransactionImpl implements _TierTransaction {
  const _$TierTransactionImpl(
      {required this.id,
      required this.userId,
      required this.type,
      required this.points,
      required this.amount,
      required this.createdAt,
      this.description,
      this.bookingId,
      this.eventId});

  factory _$TierTransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TierTransactionImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final TierTransactionType type;
  @override
  final int points;
  @override
  final double amount;
  @override
  final DateTime createdAt;
  @override
  final String? description;
  @override
  final String? bookingId;
  @override
  final String? eventId;

  @override
  String toString() {
    return 'TierTransaction(id: $id, userId: $userId, type: $type, points: $points, amount: $amount, createdAt: $createdAt, description: $description, bookingId: $bookingId, eventId: $eventId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TierTransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.eventId, eventId) || other.eventId == eventId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, type, points, amount,
      createdAt, description, bookingId, eventId);

  /// Create a copy of TierTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TierTransactionImplCopyWith<_$TierTransactionImpl> get copyWith =>
      __$$TierTransactionImplCopyWithImpl<_$TierTransactionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TierTransactionImplToJson(
      this,
    );
  }
}

abstract class _TierTransaction implements TierTransaction {
  const factory _TierTransaction(
      {required final String id,
      required final String userId,
      required final TierTransactionType type,
      required final int points,
      required final double amount,
      required final DateTime createdAt,
      final String? description,
      final String? bookingId,
      final String? eventId}) = _$TierTransactionImpl;

  factory _TierTransaction.fromJson(Map<String, dynamic> json) =
      _$TierTransactionImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  TierTransactionType get type;
  @override
  int get points;
  @override
  double get amount;
  @override
  DateTime get createdAt;
  @override
  String? get description;
  @override
  String? get bookingId;
  @override
  String? get eventId;

  /// Create a copy of TierTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TierTransactionImplCopyWith<_$TierTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
