// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loyalty_tier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LoyaltyTier _$LoyaltyTierFromJson(Map<String, dynamic> json) {
  return _LoyaltyTier.fromJson(json);
}

/// @nodoc
mixin _$LoyaltyTier {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  TierLevel get level => throw _privateConstructorUsedError;
  int get minPoints => throw _privateConstructorUsedError;
  int get maxPoints => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String> get benefits => throw _privateConstructorUsedError;
  String get iconUrl => throw _privateConstructorUsedError;
  String get colorHex => throw _privateConstructorUsedError;
  int get earlyAccessHours => throw _privateConstructorUsedError;
  double get discountPercentage => throw _privateConstructorUsedError;
  int get priorityBookingDays => throw _privateConstructorUsedError;
  bool get hasExclusiveEvents => throw _privateConstructorUsedError;
  bool get hasBirthdayReward => throw _privateConstructorUsedError;
  double get pointsMultiplier => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this LoyaltyTier to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoyaltyTier
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoyaltyTierCopyWith<LoyaltyTier> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoyaltyTierCopyWith<$Res> {
  factory $LoyaltyTierCopyWith(
          LoyaltyTier value, $Res Function(LoyaltyTier) then) =
      _$LoyaltyTierCopyWithImpl<$Res, LoyaltyTier>;
  @useResult
  $Res call(
      {String id,
      String name,
      TierLevel level,
      int minPoints,
      int maxPoints,
      String description,
      List<String> benefits,
      String iconUrl,
      String colorHex,
      int earlyAccessHours,
      double discountPercentage,
      int priorityBookingDays,
      bool hasExclusiveEvents,
      bool hasBirthdayReward,
      double pointsMultiplier,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$LoyaltyTierCopyWithImpl<$Res, $Val extends LoyaltyTier>
    implements $LoyaltyTierCopyWith<$Res> {
  _$LoyaltyTierCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoyaltyTier
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? level = null,
    Object? minPoints = null,
    Object? maxPoints = null,
    Object? description = null,
    Object? benefits = null,
    Object? iconUrl = null,
    Object? colorHex = null,
    Object? earlyAccessHours = null,
    Object? discountPercentage = null,
    Object? priorityBookingDays = null,
    Object? hasExclusiveEvents = null,
    Object? hasBirthdayReward = null,
    Object? pointsMultiplier = null,
    Object? metadata = freezed,
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
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as TierLevel,
      minPoints: null == minPoints
          ? _value.minPoints
          : minPoints // ignore: cast_nullable_to_non_nullable
              as int,
      maxPoints: null == maxPoints
          ? _value.maxPoints
          : maxPoints // ignore: cast_nullable_to_non_nullable
              as int,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      benefits: null == benefits
          ? _value.benefits
          : benefits // ignore: cast_nullable_to_non_nullable
              as List<String>,
      iconUrl: null == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String,
      colorHex: null == colorHex
          ? _value.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String,
      earlyAccessHours: null == earlyAccessHours
          ? _value.earlyAccessHours
          : earlyAccessHours // ignore: cast_nullable_to_non_nullable
              as int,
      discountPercentage: null == discountPercentage
          ? _value.discountPercentage
          : discountPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      priorityBookingDays: null == priorityBookingDays
          ? _value.priorityBookingDays
          : priorityBookingDays // ignore: cast_nullable_to_non_nullable
              as int,
      hasExclusiveEvents: null == hasExclusiveEvents
          ? _value.hasExclusiveEvents
          : hasExclusiveEvents // ignore: cast_nullable_to_non_nullable
              as bool,
      hasBirthdayReward: null == hasBirthdayReward
          ? _value.hasBirthdayReward
          : hasBirthdayReward // ignore: cast_nullable_to_non_nullable
              as bool,
      pointsMultiplier: null == pointsMultiplier
          ? _value.pointsMultiplier
          : pointsMultiplier // ignore: cast_nullable_to_non_nullable
              as double,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LoyaltyTierImplCopyWith<$Res>
    implements $LoyaltyTierCopyWith<$Res> {
  factory _$$LoyaltyTierImplCopyWith(
          _$LoyaltyTierImpl value, $Res Function(_$LoyaltyTierImpl) then) =
      __$$LoyaltyTierImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      TierLevel level,
      int minPoints,
      int maxPoints,
      String description,
      List<String> benefits,
      String iconUrl,
      String colorHex,
      int earlyAccessHours,
      double discountPercentage,
      int priorityBookingDays,
      bool hasExclusiveEvents,
      bool hasBirthdayReward,
      double pointsMultiplier,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$LoyaltyTierImplCopyWithImpl<$Res>
    extends _$LoyaltyTierCopyWithImpl<$Res, _$LoyaltyTierImpl>
    implements _$$LoyaltyTierImplCopyWith<$Res> {
  __$$LoyaltyTierImplCopyWithImpl(
      _$LoyaltyTierImpl _value, $Res Function(_$LoyaltyTierImpl) _then)
      : super(_value, _then);

  /// Create a copy of LoyaltyTier
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? level = null,
    Object? minPoints = null,
    Object? maxPoints = null,
    Object? description = null,
    Object? benefits = null,
    Object? iconUrl = null,
    Object? colorHex = null,
    Object? earlyAccessHours = null,
    Object? discountPercentage = null,
    Object? priorityBookingDays = null,
    Object? hasExclusiveEvents = null,
    Object? hasBirthdayReward = null,
    Object? pointsMultiplier = null,
    Object? metadata = freezed,
  }) {
    return _then(_$LoyaltyTierImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as TierLevel,
      minPoints: null == minPoints
          ? _value.minPoints
          : minPoints // ignore: cast_nullable_to_non_nullable
              as int,
      maxPoints: null == maxPoints
          ? _value.maxPoints
          : maxPoints // ignore: cast_nullable_to_non_nullable
              as int,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      benefits: null == benefits
          ? _value._benefits
          : benefits // ignore: cast_nullable_to_non_nullable
              as List<String>,
      iconUrl: null == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String,
      colorHex: null == colorHex
          ? _value.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String,
      earlyAccessHours: null == earlyAccessHours
          ? _value.earlyAccessHours
          : earlyAccessHours // ignore: cast_nullable_to_non_nullable
              as int,
      discountPercentage: null == discountPercentage
          ? _value.discountPercentage
          : discountPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      priorityBookingDays: null == priorityBookingDays
          ? _value.priorityBookingDays
          : priorityBookingDays // ignore: cast_nullable_to_non_nullable
              as int,
      hasExclusiveEvents: null == hasExclusiveEvents
          ? _value.hasExclusiveEvents
          : hasExclusiveEvents // ignore: cast_nullable_to_non_nullable
              as bool,
      hasBirthdayReward: null == hasBirthdayReward
          ? _value.hasBirthdayReward
          : hasBirthdayReward // ignore: cast_nullable_to_non_nullable
              as bool,
      pointsMultiplier: null == pointsMultiplier
          ? _value.pointsMultiplier
          : pointsMultiplier // ignore: cast_nullable_to_non_nullable
              as double,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoyaltyTierImpl implements _LoyaltyTier {
  const _$LoyaltyTierImpl(
      {required this.id,
      required this.name,
      required this.level,
      required this.minPoints,
      required this.maxPoints,
      required this.description,
      required final List<String> benefits,
      required this.iconUrl,
      required this.colorHex,
      this.earlyAccessHours = 0,
      this.discountPercentage = 0,
      this.priorityBookingDays = 0,
      this.hasExclusiveEvents = false,
      this.hasBirthdayReward = false,
      this.pointsMultiplier = 0,
      final Map<String, dynamic>? metadata})
      : _benefits = benefits,
        _metadata = metadata;

  factory _$LoyaltyTierImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoyaltyTierImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final TierLevel level;
  @override
  final int minPoints;
  @override
  final int maxPoints;
  @override
  final String description;
  final List<String> _benefits;
  @override
  List<String> get benefits {
    if (_benefits is EqualUnmodifiableListView) return _benefits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_benefits);
  }

  @override
  final String iconUrl;
  @override
  final String colorHex;
  @override
  @JsonKey()
  final int earlyAccessHours;
  @override
  @JsonKey()
  final double discountPercentage;
  @override
  @JsonKey()
  final int priorityBookingDays;
  @override
  @JsonKey()
  final bool hasExclusiveEvents;
  @override
  @JsonKey()
  final bool hasBirthdayReward;
  @override
  @JsonKey()
  final double pointsMultiplier;
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
  String toString() {
    return 'LoyaltyTier(id: $id, name: $name, level: $level, minPoints: $minPoints, maxPoints: $maxPoints, description: $description, benefits: $benefits, iconUrl: $iconUrl, colorHex: $colorHex, earlyAccessHours: $earlyAccessHours, discountPercentage: $discountPercentage, priorityBookingDays: $priorityBookingDays, hasExclusiveEvents: $hasExclusiveEvents, hasBirthdayReward: $hasBirthdayReward, pointsMultiplier: $pointsMultiplier, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoyaltyTierImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.minPoints, minPoints) ||
                other.minPoints == minPoints) &&
            (identical(other.maxPoints, maxPoints) ||
                other.maxPoints == maxPoints) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._benefits, _benefits) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.colorHex, colorHex) ||
                other.colorHex == colorHex) &&
            (identical(other.earlyAccessHours, earlyAccessHours) ||
                other.earlyAccessHours == earlyAccessHours) &&
            (identical(other.discountPercentage, discountPercentage) ||
                other.discountPercentage == discountPercentage) &&
            (identical(other.priorityBookingDays, priorityBookingDays) ||
                other.priorityBookingDays == priorityBookingDays) &&
            (identical(other.hasExclusiveEvents, hasExclusiveEvents) ||
                other.hasExclusiveEvents == hasExclusiveEvents) &&
            (identical(other.hasBirthdayReward, hasBirthdayReward) ||
                other.hasBirthdayReward == hasBirthdayReward) &&
            (identical(other.pointsMultiplier, pointsMultiplier) ||
                other.pointsMultiplier == pointsMultiplier) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      level,
      minPoints,
      maxPoints,
      description,
      const DeepCollectionEquality().hash(_benefits),
      iconUrl,
      colorHex,
      earlyAccessHours,
      discountPercentage,
      priorityBookingDays,
      hasExclusiveEvents,
      hasBirthdayReward,
      pointsMultiplier,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of LoyaltyTier
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoyaltyTierImplCopyWith<_$LoyaltyTierImpl> get copyWith =>
      __$$LoyaltyTierImplCopyWithImpl<_$LoyaltyTierImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoyaltyTierImplToJson(
      this,
    );
  }
}

abstract class _LoyaltyTier implements LoyaltyTier {
  const factory _LoyaltyTier(
      {required final String id,
      required final String name,
      required final TierLevel level,
      required final int minPoints,
      required final int maxPoints,
      required final String description,
      required final List<String> benefits,
      required final String iconUrl,
      required final String colorHex,
      final int earlyAccessHours,
      final double discountPercentage,
      final int priorityBookingDays,
      final bool hasExclusiveEvents,
      final bool hasBirthdayReward,
      final double pointsMultiplier,
      final Map<String, dynamic>? metadata}) = _$LoyaltyTierImpl;

  factory _LoyaltyTier.fromJson(Map<String, dynamic> json) =
      _$LoyaltyTierImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  TierLevel get level;
  @override
  int get minPoints;
  @override
  int get maxPoints;
  @override
  String get description;
  @override
  List<String> get benefits;
  @override
  String get iconUrl;
  @override
  String get colorHex;
  @override
  int get earlyAccessHours;
  @override
  double get discountPercentage;
  @override
  int get priorityBookingDays;
  @override
  bool get hasExclusiveEvents;
  @override
  bool get hasBirthdayReward;
  @override
  double get pointsMultiplier;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of LoyaltyTier
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoyaltyTierImplCopyWith<_$LoyaltyTierImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserLoyaltyStatus _$UserLoyaltyStatusFromJson(Map<String, dynamic> json) {
  return _UserLoyaltyStatus.fromJson(json);
}

/// @nodoc
mixin _$UserLoyaltyStatus {
  String get userId => throw _privateConstructorUsedError;
  LoyaltyTier get currentTier => throw _privateConstructorUsedError;
  int get totalPoints => throw _privateConstructorUsedError;
  int get lifetimePoints => throw _privateConstructorUsedError;
  LoyaltyTier? get nextTier => throw _privateConstructorUsedError;
  int? get pointsToNextTier => throw _privateConstructorUsedError;
  DateTime get joinedAt => throw _privateConstructorUsedError;
  DateTime? get lastActivityAt => throw _privateConstructorUsedError;
  int get tierUpgradeCount => throw _privateConstructorUsedError;
  List<String> get unlockedBenefits => throw _privateConstructorUsedError;

  /// Serializes this UserLoyaltyStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserLoyaltyStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserLoyaltyStatusCopyWith<UserLoyaltyStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserLoyaltyStatusCopyWith<$Res> {
  factory $UserLoyaltyStatusCopyWith(
          UserLoyaltyStatus value, $Res Function(UserLoyaltyStatus) then) =
      _$UserLoyaltyStatusCopyWithImpl<$Res, UserLoyaltyStatus>;
  @useResult
  $Res call(
      {String userId,
      LoyaltyTier currentTier,
      int totalPoints,
      int lifetimePoints,
      LoyaltyTier? nextTier,
      int? pointsToNextTier,
      DateTime joinedAt,
      DateTime? lastActivityAt,
      int tierUpgradeCount,
      List<String> unlockedBenefits});

  $LoyaltyTierCopyWith<$Res> get currentTier;
  $LoyaltyTierCopyWith<$Res>? get nextTier;
}

/// @nodoc
class _$UserLoyaltyStatusCopyWithImpl<$Res, $Val extends UserLoyaltyStatus>
    implements $UserLoyaltyStatusCopyWith<$Res> {
  _$UserLoyaltyStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserLoyaltyStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? currentTier = null,
    Object? totalPoints = null,
    Object? lifetimePoints = null,
    Object? nextTier = freezed,
    Object? pointsToNextTier = freezed,
    Object? joinedAt = null,
    Object? lastActivityAt = freezed,
    Object? tierUpgradeCount = null,
    Object? unlockedBenefits = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      currentTier: null == currentTier
          ? _value.currentTier
          : currentTier // ignore: cast_nullable_to_non_nullable
              as LoyaltyTier,
      totalPoints: null == totalPoints
          ? _value.totalPoints
          : totalPoints // ignore: cast_nullable_to_non_nullable
              as int,
      lifetimePoints: null == lifetimePoints
          ? _value.lifetimePoints
          : lifetimePoints // ignore: cast_nullable_to_non_nullable
              as int,
      nextTier: freezed == nextTier
          ? _value.nextTier
          : nextTier // ignore: cast_nullable_to_non_nullable
              as LoyaltyTier?,
      pointsToNextTier: freezed == pointsToNextTier
          ? _value.pointsToNextTier
          : pointsToNextTier // ignore: cast_nullable_to_non_nullable
              as int?,
      joinedAt: null == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastActivityAt: freezed == lastActivityAt
          ? _value.lastActivityAt
          : lastActivityAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tierUpgradeCount: null == tierUpgradeCount
          ? _value.tierUpgradeCount
          : tierUpgradeCount // ignore: cast_nullable_to_non_nullable
              as int,
      unlockedBenefits: null == unlockedBenefits
          ? _value.unlockedBenefits
          : unlockedBenefits // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }

  /// Create a copy of UserLoyaltyStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LoyaltyTierCopyWith<$Res> get currentTier {
    return $LoyaltyTierCopyWith<$Res>(_value.currentTier, (value) {
      return _then(_value.copyWith(currentTier: value) as $Val);
    });
  }

  /// Create a copy of UserLoyaltyStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LoyaltyTierCopyWith<$Res>? get nextTier {
    if (_value.nextTier == null) {
      return null;
    }

    return $LoyaltyTierCopyWith<$Res>(_value.nextTier!, (value) {
      return _then(_value.copyWith(nextTier: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserLoyaltyStatusImplCopyWith<$Res>
    implements $UserLoyaltyStatusCopyWith<$Res> {
  factory _$$UserLoyaltyStatusImplCopyWith(_$UserLoyaltyStatusImpl value,
          $Res Function(_$UserLoyaltyStatusImpl) then) =
      __$$UserLoyaltyStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      LoyaltyTier currentTier,
      int totalPoints,
      int lifetimePoints,
      LoyaltyTier? nextTier,
      int? pointsToNextTier,
      DateTime joinedAt,
      DateTime? lastActivityAt,
      int tierUpgradeCount,
      List<String> unlockedBenefits});

  @override
  $LoyaltyTierCopyWith<$Res> get currentTier;
  @override
  $LoyaltyTierCopyWith<$Res>? get nextTier;
}

/// @nodoc
class __$$UserLoyaltyStatusImplCopyWithImpl<$Res>
    extends _$UserLoyaltyStatusCopyWithImpl<$Res, _$UserLoyaltyStatusImpl>
    implements _$$UserLoyaltyStatusImplCopyWith<$Res> {
  __$$UserLoyaltyStatusImplCopyWithImpl(_$UserLoyaltyStatusImpl _value,
      $Res Function(_$UserLoyaltyStatusImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserLoyaltyStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? currentTier = null,
    Object? totalPoints = null,
    Object? lifetimePoints = null,
    Object? nextTier = freezed,
    Object? pointsToNextTier = freezed,
    Object? joinedAt = null,
    Object? lastActivityAt = freezed,
    Object? tierUpgradeCount = null,
    Object? unlockedBenefits = null,
  }) {
    return _then(_$UserLoyaltyStatusImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      currentTier: null == currentTier
          ? _value.currentTier
          : currentTier // ignore: cast_nullable_to_non_nullable
              as LoyaltyTier,
      totalPoints: null == totalPoints
          ? _value.totalPoints
          : totalPoints // ignore: cast_nullable_to_non_nullable
              as int,
      lifetimePoints: null == lifetimePoints
          ? _value.lifetimePoints
          : lifetimePoints // ignore: cast_nullable_to_non_nullable
              as int,
      nextTier: freezed == nextTier
          ? _value.nextTier
          : nextTier // ignore: cast_nullable_to_non_nullable
              as LoyaltyTier?,
      pointsToNextTier: freezed == pointsToNextTier
          ? _value.pointsToNextTier
          : pointsToNextTier // ignore: cast_nullable_to_non_nullable
              as int?,
      joinedAt: null == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastActivityAt: freezed == lastActivityAt
          ? _value.lastActivityAt
          : lastActivityAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tierUpgradeCount: null == tierUpgradeCount
          ? _value.tierUpgradeCount
          : tierUpgradeCount // ignore: cast_nullable_to_non_nullable
              as int,
      unlockedBenefits: null == unlockedBenefits
          ? _value._unlockedBenefits
          : unlockedBenefits // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserLoyaltyStatusImpl implements _UserLoyaltyStatus {
  const _$UserLoyaltyStatusImpl(
      {required this.userId,
      required this.currentTier,
      required this.totalPoints,
      required this.lifetimePoints,
      this.nextTier,
      this.pointsToNextTier,
      required this.joinedAt,
      this.lastActivityAt,
      this.tierUpgradeCount = 0,
      final List<String> unlockedBenefits = const []})
      : _unlockedBenefits = unlockedBenefits;

  factory _$UserLoyaltyStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserLoyaltyStatusImplFromJson(json);

  @override
  final String userId;
  @override
  final LoyaltyTier currentTier;
  @override
  final int totalPoints;
  @override
  final int lifetimePoints;
  @override
  final LoyaltyTier? nextTier;
  @override
  final int? pointsToNextTier;
  @override
  final DateTime joinedAt;
  @override
  final DateTime? lastActivityAt;
  @override
  @JsonKey()
  final int tierUpgradeCount;
  final List<String> _unlockedBenefits;
  @override
  @JsonKey()
  List<String> get unlockedBenefits {
    if (_unlockedBenefits is EqualUnmodifiableListView)
      return _unlockedBenefits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unlockedBenefits);
  }

  @override
  String toString() {
    return 'UserLoyaltyStatus(userId: $userId, currentTier: $currentTier, totalPoints: $totalPoints, lifetimePoints: $lifetimePoints, nextTier: $nextTier, pointsToNextTier: $pointsToNextTier, joinedAt: $joinedAt, lastActivityAt: $lastActivityAt, tierUpgradeCount: $tierUpgradeCount, unlockedBenefits: $unlockedBenefits)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserLoyaltyStatusImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.currentTier, currentTier) ||
                other.currentTier == currentTier) &&
            (identical(other.totalPoints, totalPoints) ||
                other.totalPoints == totalPoints) &&
            (identical(other.lifetimePoints, lifetimePoints) ||
                other.lifetimePoints == lifetimePoints) &&
            (identical(other.nextTier, nextTier) ||
                other.nextTier == nextTier) &&
            (identical(other.pointsToNextTier, pointsToNextTier) ||
                other.pointsToNextTier == pointsToNextTier) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt) &&
            (identical(other.lastActivityAt, lastActivityAt) ||
                other.lastActivityAt == lastActivityAt) &&
            (identical(other.tierUpgradeCount, tierUpgradeCount) ||
                other.tierUpgradeCount == tierUpgradeCount) &&
            const DeepCollectionEquality()
                .equals(other._unlockedBenefits, _unlockedBenefits));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      currentTier,
      totalPoints,
      lifetimePoints,
      nextTier,
      pointsToNextTier,
      joinedAt,
      lastActivityAt,
      tierUpgradeCount,
      const DeepCollectionEquality().hash(_unlockedBenefits));

  /// Create a copy of UserLoyaltyStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserLoyaltyStatusImplCopyWith<_$UserLoyaltyStatusImpl> get copyWith =>
      __$$UserLoyaltyStatusImplCopyWithImpl<_$UserLoyaltyStatusImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserLoyaltyStatusImplToJson(
      this,
    );
  }
}

abstract class _UserLoyaltyStatus implements UserLoyaltyStatus {
  const factory _UserLoyaltyStatus(
      {required final String userId,
      required final LoyaltyTier currentTier,
      required final int totalPoints,
      required final int lifetimePoints,
      final LoyaltyTier? nextTier,
      final int? pointsToNextTier,
      required final DateTime joinedAt,
      final DateTime? lastActivityAt,
      final int tierUpgradeCount,
      final List<String> unlockedBenefits}) = _$UserLoyaltyStatusImpl;

  factory _UserLoyaltyStatus.fromJson(Map<String, dynamic> json) =
      _$UserLoyaltyStatusImpl.fromJson;

  @override
  String get userId;
  @override
  LoyaltyTier get currentTier;
  @override
  int get totalPoints;
  @override
  int get lifetimePoints;
  @override
  LoyaltyTier? get nextTier;
  @override
  int? get pointsToNextTier;
  @override
  DateTime get joinedAt;
  @override
  DateTime? get lastActivityAt;
  @override
  int get tierUpgradeCount;
  @override
  List<String> get unlockedBenefits;

  /// Create a copy of UserLoyaltyStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserLoyaltyStatusImplCopyWith<_$UserLoyaltyStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EarlyAccessEvent _$EarlyAccessEventFromJson(Map<String, dynamic> json) {
  return _EarlyAccessEvent.fromJson(json);
}

/// @nodoc
mixin _$EarlyAccessEvent {
  String get id => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  String get eventName => throw _privateConstructorUsedError;
  TierLevel get minimumTier => throw _privateConstructorUsedError;
  DateTime get earlyAccessStartsAt => throw _privateConstructorUsedError;
  DateTime get publicAccessStartsAt => throw _privateConstructorUsedError;
  int get availableSlots => throw _privateConstructorUsedError;
  int get bookedSlots => throw _privateConstructorUsedError;
  String? get eventImageUrl => throw _privateConstructorUsedError;
  bool? get isActive => throw _privateConstructorUsedError;

  /// Serializes this EarlyAccessEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EarlyAccessEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EarlyAccessEventCopyWith<EarlyAccessEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EarlyAccessEventCopyWith<$Res> {
  factory $EarlyAccessEventCopyWith(
          EarlyAccessEvent value, $Res Function(EarlyAccessEvent) then) =
      _$EarlyAccessEventCopyWithImpl<$Res, EarlyAccessEvent>;
  @useResult
  $Res call(
      {String id,
      String eventId,
      String eventName,
      TierLevel minimumTier,
      DateTime earlyAccessStartsAt,
      DateTime publicAccessStartsAt,
      int availableSlots,
      int bookedSlots,
      String? eventImageUrl,
      bool? isActive});
}

/// @nodoc
class _$EarlyAccessEventCopyWithImpl<$Res, $Val extends EarlyAccessEvent>
    implements $EarlyAccessEventCopyWith<$Res> {
  _$EarlyAccessEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EarlyAccessEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? eventName = null,
    Object? minimumTier = null,
    Object? earlyAccessStartsAt = null,
    Object? publicAccessStartsAt = null,
    Object? availableSlots = null,
    Object? bookedSlots = null,
    Object? eventImageUrl = freezed,
    Object? isActive = freezed,
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
      eventName: null == eventName
          ? _value.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String,
      minimumTier: null == minimumTier
          ? _value.minimumTier
          : minimumTier // ignore: cast_nullable_to_non_nullable
              as TierLevel,
      earlyAccessStartsAt: null == earlyAccessStartsAt
          ? _value.earlyAccessStartsAt
          : earlyAccessStartsAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      publicAccessStartsAt: null == publicAccessStartsAt
          ? _value.publicAccessStartsAt
          : publicAccessStartsAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      availableSlots: null == availableSlots
          ? _value.availableSlots
          : availableSlots // ignore: cast_nullable_to_non_nullable
              as int,
      bookedSlots: null == bookedSlots
          ? _value.bookedSlots
          : bookedSlots // ignore: cast_nullable_to_non_nullable
              as int,
      eventImageUrl: freezed == eventImageUrl
          ? _value.eventImageUrl
          : eventImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EarlyAccessEventImplCopyWith<$Res>
    implements $EarlyAccessEventCopyWith<$Res> {
  factory _$$EarlyAccessEventImplCopyWith(_$EarlyAccessEventImpl value,
          $Res Function(_$EarlyAccessEventImpl) then) =
      __$$EarlyAccessEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String eventId,
      String eventName,
      TierLevel minimumTier,
      DateTime earlyAccessStartsAt,
      DateTime publicAccessStartsAt,
      int availableSlots,
      int bookedSlots,
      String? eventImageUrl,
      bool? isActive});
}

/// @nodoc
class __$$EarlyAccessEventImplCopyWithImpl<$Res>
    extends _$EarlyAccessEventCopyWithImpl<$Res, _$EarlyAccessEventImpl>
    implements _$$EarlyAccessEventImplCopyWith<$Res> {
  __$$EarlyAccessEventImplCopyWithImpl(_$EarlyAccessEventImpl _value,
      $Res Function(_$EarlyAccessEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of EarlyAccessEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? eventName = null,
    Object? minimumTier = null,
    Object? earlyAccessStartsAt = null,
    Object? publicAccessStartsAt = null,
    Object? availableSlots = null,
    Object? bookedSlots = null,
    Object? eventImageUrl = freezed,
    Object? isActive = freezed,
  }) {
    return _then(_$EarlyAccessEventImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      eventName: null == eventName
          ? _value.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String,
      minimumTier: null == minimumTier
          ? _value.minimumTier
          : minimumTier // ignore: cast_nullable_to_non_nullable
              as TierLevel,
      earlyAccessStartsAt: null == earlyAccessStartsAt
          ? _value.earlyAccessStartsAt
          : earlyAccessStartsAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      publicAccessStartsAt: null == publicAccessStartsAt
          ? _value.publicAccessStartsAt
          : publicAccessStartsAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      availableSlots: null == availableSlots
          ? _value.availableSlots
          : availableSlots // ignore: cast_nullable_to_non_nullable
              as int,
      bookedSlots: null == bookedSlots
          ? _value.bookedSlots
          : bookedSlots // ignore: cast_nullable_to_non_nullable
              as int,
      eventImageUrl: freezed == eventImageUrl
          ? _value.eventImageUrl
          : eventImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EarlyAccessEventImpl implements _EarlyAccessEvent {
  const _$EarlyAccessEventImpl(
      {required this.id,
      required this.eventId,
      required this.eventName,
      required this.minimumTier,
      required this.earlyAccessStartsAt,
      required this.publicAccessStartsAt,
      required this.availableSlots,
      required this.bookedSlots,
      this.eventImageUrl,
      this.isActive});

  factory _$EarlyAccessEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$EarlyAccessEventImplFromJson(json);

  @override
  final String id;
  @override
  final String eventId;
  @override
  final String eventName;
  @override
  final TierLevel minimumTier;
  @override
  final DateTime earlyAccessStartsAt;
  @override
  final DateTime publicAccessStartsAt;
  @override
  final int availableSlots;
  @override
  final int bookedSlots;
  @override
  final String? eventImageUrl;
  @override
  final bool? isActive;

  @override
  String toString() {
    return 'EarlyAccessEvent(id: $id, eventId: $eventId, eventName: $eventName, minimumTier: $minimumTier, earlyAccessStartsAt: $earlyAccessStartsAt, publicAccessStartsAt: $publicAccessStartsAt, availableSlots: $availableSlots, bookedSlots: $bookedSlots, eventImageUrl: $eventImageUrl, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EarlyAccessEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.eventName, eventName) ||
                other.eventName == eventName) &&
            (identical(other.minimumTier, minimumTier) ||
                other.minimumTier == minimumTier) &&
            (identical(other.earlyAccessStartsAt, earlyAccessStartsAt) ||
                other.earlyAccessStartsAt == earlyAccessStartsAt) &&
            (identical(other.publicAccessStartsAt, publicAccessStartsAt) ||
                other.publicAccessStartsAt == publicAccessStartsAt) &&
            (identical(other.availableSlots, availableSlots) ||
                other.availableSlots == availableSlots) &&
            (identical(other.bookedSlots, bookedSlots) ||
                other.bookedSlots == bookedSlots) &&
            (identical(other.eventImageUrl, eventImageUrl) ||
                other.eventImageUrl == eventImageUrl) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      eventId,
      eventName,
      minimumTier,
      earlyAccessStartsAt,
      publicAccessStartsAt,
      availableSlots,
      bookedSlots,
      eventImageUrl,
      isActive);

  /// Create a copy of EarlyAccessEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EarlyAccessEventImplCopyWith<_$EarlyAccessEventImpl> get copyWith =>
      __$$EarlyAccessEventImplCopyWithImpl<_$EarlyAccessEventImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EarlyAccessEventImplToJson(
      this,
    );
  }
}

abstract class _EarlyAccessEvent implements EarlyAccessEvent {
  const factory _EarlyAccessEvent(
      {required final String id,
      required final String eventId,
      required final String eventName,
      required final TierLevel minimumTier,
      required final DateTime earlyAccessStartsAt,
      required final DateTime publicAccessStartsAt,
      required final int availableSlots,
      required final int bookedSlots,
      final String? eventImageUrl,
      final bool? isActive}) = _$EarlyAccessEventImpl;

  factory _EarlyAccessEvent.fromJson(Map<String, dynamic> json) =
      _$EarlyAccessEventImpl.fromJson;

  @override
  String get id;
  @override
  String get eventId;
  @override
  String get eventName;
  @override
  TierLevel get minimumTier;
  @override
  DateTime get earlyAccessStartsAt;
  @override
  DateTime get publicAccessStartsAt;
  @override
  int get availableSlots;
  @override
  int get bookedSlots;
  @override
  String? get eventImageUrl;
  @override
  bool? get isActive;

  /// Create a copy of EarlyAccessEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EarlyAccessEventImplCopyWith<_$EarlyAccessEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExclusiveEvent _$ExclusiveEventFromJson(Map<String, dynamic> json) {
  return _ExclusiveEvent.fromJson(json);
}

/// @nodoc
mixin _$ExclusiveEvent {
  String get id => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  String get eventName => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  TierLevel get minimumTier => throw _privateConstructorUsedError;
  DateTime get eventDate => throw _privateConstructorUsedError;
  int get maxAttendees => throw _privateConstructorUsedError;
  int get currentAttendees => throw _privateConstructorUsedError;
  String? get venueId => throw _privateConstructorUsedError;
  String? get venueName => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;
  bool get requiresRSVP => throw _privateConstructorUsedError;
  bool get isWaitlistEnabled => throw _privateConstructorUsedError;

  /// Serializes this ExclusiveEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExclusiveEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExclusiveEventCopyWith<ExclusiveEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExclusiveEventCopyWith<$Res> {
  factory $ExclusiveEventCopyWith(
          ExclusiveEvent value, $Res Function(ExclusiveEvent) then) =
      _$ExclusiveEventCopyWithImpl<$Res, ExclusiveEvent>;
  @useResult
  $Res call(
      {String id,
      String eventId,
      String eventName,
      String description,
      TierLevel minimumTier,
      DateTime eventDate,
      int maxAttendees,
      int currentAttendees,
      String? venueId,
      String? venueName,
      String? imageUrl,
      double? price,
      bool requiresRSVP,
      bool isWaitlistEnabled});
}

/// @nodoc
class _$ExclusiveEventCopyWithImpl<$Res, $Val extends ExclusiveEvent>
    implements $ExclusiveEventCopyWith<$Res> {
  _$ExclusiveEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExclusiveEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? eventName = null,
    Object? description = null,
    Object? minimumTier = null,
    Object? eventDate = null,
    Object? maxAttendees = null,
    Object? currentAttendees = null,
    Object? venueId = freezed,
    Object? venueName = freezed,
    Object? imageUrl = freezed,
    Object? price = freezed,
    Object? requiresRSVP = null,
    Object? isWaitlistEnabled = null,
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
      eventName: null == eventName
          ? _value.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      minimumTier: null == minimumTier
          ? _value.minimumTier
          : minimumTier // ignore: cast_nullable_to_non_nullable
              as TierLevel,
      eventDate: null == eventDate
          ? _value.eventDate
          : eventDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      maxAttendees: null == maxAttendees
          ? _value.maxAttendees
          : maxAttendees // ignore: cast_nullable_to_non_nullable
              as int,
      currentAttendees: null == currentAttendees
          ? _value.currentAttendees
          : currentAttendees // ignore: cast_nullable_to_non_nullable
              as int,
      venueId: freezed == venueId
          ? _value.venueId
          : venueId // ignore: cast_nullable_to_non_nullable
              as String?,
      venueName: freezed == venueName
          ? _value.venueName
          : venueName // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      requiresRSVP: null == requiresRSVP
          ? _value.requiresRSVP
          : requiresRSVP // ignore: cast_nullable_to_non_nullable
              as bool,
      isWaitlistEnabled: null == isWaitlistEnabled
          ? _value.isWaitlistEnabled
          : isWaitlistEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExclusiveEventImplCopyWith<$Res>
    implements $ExclusiveEventCopyWith<$Res> {
  factory _$$ExclusiveEventImplCopyWith(_$ExclusiveEventImpl value,
          $Res Function(_$ExclusiveEventImpl) then) =
      __$$ExclusiveEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String eventId,
      String eventName,
      String description,
      TierLevel minimumTier,
      DateTime eventDate,
      int maxAttendees,
      int currentAttendees,
      String? venueId,
      String? venueName,
      String? imageUrl,
      double? price,
      bool requiresRSVP,
      bool isWaitlistEnabled});
}

/// @nodoc
class __$$ExclusiveEventImplCopyWithImpl<$Res>
    extends _$ExclusiveEventCopyWithImpl<$Res, _$ExclusiveEventImpl>
    implements _$$ExclusiveEventImplCopyWith<$Res> {
  __$$ExclusiveEventImplCopyWithImpl(
      _$ExclusiveEventImpl _value, $Res Function(_$ExclusiveEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExclusiveEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? eventName = null,
    Object? description = null,
    Object? minimumTier = null,
    Object? eventDate = null,
    Object? maxAttendees = null,
    Object? currentAttendees = null,
    Object? venueId = freezed,
    Object? venueName = freezed,
    Object? imageUrl = freezed,
    Object? price = freezed,
    Object? requiresRSVP = null,
    Object? isWaitlistEnabled = null,
  }) {
    return _then(_$ExclusiveEventImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      eventName: null == eventName
          ? _value.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      minimumTier: null == minimumTier
          ? _value.minimumTier
          : minimumTier // ignore: cast_nullable_to_non_nullable
              as TierLevel,
      eventDate: null == eventDate
          ? _value.eventDate
          : eventDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      maxAttendees: null == maxAttendees
          ? _value.maxAttendees
          : maxAttendees // ignore: cast_nullable_to_non_nullable
              as int,
      currentAttendees: null == currentAttendees
          ? _value.currentAttendees
          : currentAttendees // ignore: cast_nullable_to_non_nullable
              as int,
      venueId: freezed == venueId
          ? _value.venueId
          : venueId // ignore: cast_nullable_to_non_nullable
              as String?,
      venueName: freezed == venueName
          ? _value.venueName
          : venueName // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      requiresRSVP: null == requiresRSVP
          ? _value.requiresRSVP
          : requiresRSVP // ignore: cast_nullable_to_non_nullable
              as bool,
      isWaitlistEnabled: null == isWaitlistEnabled
          ? _value.isWaitlistEnabled
          : isWaitlistEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExclusiveEventImpl implements _ExclusiveEvent {
  const _$ExclusiveEventImpl(
      {required this.id,
      required this.eventId,
      required this.eventName,
      required this.description,
      required this.minimumTier,
      required this.eventDate,
      required this.maxAttendees,
      required this.currentAttendees,
      this.venueId,
      this.venueName,
      this.imageUrl,
      this.price,
      this.requiresRSVP = true,
      this.isWaitlistEnabled = false});

  factory _$ExclusiveEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExclusiveEventImplFromJson(json);

  @override
  final String id;
  @override
  final String eventId;
  @override
  final String eventName;
  @override
  final String description;
  @override
  final TierLevel minimumTier;
  @override
  final DateTime eventDate;
  @override
  final int maxAttendees;
  @override
  final int currentAttendees;
  @override
  final String? venueId;
  @override
  final String? venueName;
  @override
  final String? imageUrl;
  @override
  final double? price;
  @override
  @JsonKey()
  final bool requiresRSVP;
  @override
  @JsonKey()
  final bool isWaitlistEnabled;

  @override
  String toString() {
    return 'ExclusiveEvent(id: $id, eventId: $eventId, eventName: $eventName, description: $description, minimumTier: $minimumTier, eventDate: $eventDate, maxAttendees: $maxAttendees, currentAttendees: $currentAttendees, venueId: $venueId, venueName: $venueName, imageUrl: $imageUrl, price: $price, requiresRSVP: $requiresRSVP, isWaitlistEnabled: $isWaitlistEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExclusiveEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.eventName, eventName) ||
                other.eventName == eventName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.minimumTier, minimumTier) ||
                other.minimumTier == minimumTier) &&
            (identical(other.eventDate, eventDate) ||
                other.eventDate == eventDate) &&
            (identical(other.maxAttendees, maxAttendees) ||
                other.maxAttendees == maxAttendees) &&
            (identical(other.currentAttendees, currentAttendees) ||
                other.currentAttendees == currentAttendees) &&
            (identical(other.venueId, venueId) || other.venueId == venueId) &&
            (identical(other.venueName, venueName) ||
                other.venueName == venueName) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.requiresRSVP, requiresRSVP) ||
                other.requiresRSVP == requiresRSVP) &&
            (identical(other.isWaitlistEnabled, isWaitlistEnabled) ||
                other.isWaitlistEnabled == isWaitlistEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      eventId,
      eventName,
      description,
      minimumTier,
      eventDate,
      maxAttendees,
      currentAttendees,
      venueId,
      venueName,
      imageUrl,
      price,
      requiresRSVP,
      isWaitlistEnabled);

  /// Create a copy of ExclusiveEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExclusiveEventImplCopyWith<_$ExclusiveEventImpl> get copyWith =>
      __$$ExclusiveEventImplCopyWithImpl<_$ExclusiveEventImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExclusiveEventImplToJson(
      this,
    );
  }
}

abstract class _ExclusiveEvent implements ExclusiveEvent {
  const factory _ExclusiveEvent(
      {required final String id,
      required final String eventId,
      required final String eventName,
      required final String description,
      required final TierLevel minimumTier,
      required final DateTime eventDate,
      required final int maxAttendees,
      required final int currentAttendees,
      final String? venueId,
      final String? venueName,
      final String? imageUrl,
      final double? price,
      final bool requiresRSVP,
      final bool isWaitlistEnabled}) = _$ExclusiveEventImpl;

  factory _ExclusiveEvent.fromJson(Map<String, dynamic> json) =
      _$ExclusiveEventImpl.fromJson;

  @override
  String get id;
  @override
  String get eventId;
  @override
  String get eventName;
  @override
  String get description;
  @override
  TierLevel get minimumTier;
  @override
  DateTime get eventDate;
  @override
  int get maxAttendees;
  @override
  int get currentAttendees;
  @override
  String? get venueId;
  @override
  String? get venueName;
  @override
  String? get imageUrl;
  @override
  double? get price;
  @override
  bool get requiresRSVP;
  @override
  bool get isWaitlistEnabled;

  /// Create a copy of ExclusiveEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExclusiveEventImplCopyWith<_$ExclusiveEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
