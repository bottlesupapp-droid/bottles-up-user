// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Tier _$TierFromJson(Map<String, dynamic> json) {
  return _Tier.fromJson(json);
}

/// @nodoc
mixin _$Tier {
  TierLevel get level => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get minPoints => throw _privateConstructorUsedError;
  int get minSpend => throw _privateConstructorUsedError;
  double get discountPercentage => throw _privateConstructorUsedError;
  List<String> get benefits => throw _privateConstructorUsedError;
  String get colorHex => throw _privateConstructorUsedError;
  String get iconAsset => throw _privateConstructorUsedError;
  bool get earlyAccess => throw _privateConstructorUsedError;
  int get priorityBookingHours => throw _privateConstructorUsedError;
  double get pointsMultiplier => throw _privateConstructorUsedError;

  /// Serializes this Tier to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Tier
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TierCopyWith<Tier> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TierCopyWith<$Res> {
  factory $TierCopyWith(Tier value, $Res Function(Tier) then) =
      _$TierCopyWithImpl<$Res, Tier>;
  @useResult
  $Res call(
      {TierLevel level,
      String name,
      String description,
      int minPoints,
      int minSpend,
      double discountPercentage,
      List<String> benefits,
      String colorHex,
      String iconAsset,
      bool earlyAccess,
      int priorityBookingHours,
      double pointsMultiplier});
}

/// @nodoc
class _$TierCopyWithImpl<$Res, $Val extends Tier>
    implements $TierCopyWith<$Res> {
  _$TierCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Tier
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
    Object? name = null,
    Object? description = null,
    Object? minPoints = null,
    Object? minSpend = null,
    Object? discountPercentage = null,
    Object? benefits = null,
    Object? colorHex = null,
    Object? iconAsset = null,
    Object? earlyAccess = null,
    Object? priorityBookingHours = null,
    Object? pointsMultiplier = null,
  }) {
    return _then(_value.copyWith(
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as TierLevel,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      minPoints: null == minPoints
          ? _value.minPoints
          : minPoints // ignore: cast_nullable_to_non_nullable
              as int,
      minSpend: null == minSpend
          ? _value.minSpend
          : minSpend // ignore: cast_nullable_to_non_nullable
              as int,
      discountPercentage: null == discountPercentage
          ? _value.discountPercentage
          : discountPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      benefits: null == benefits
          ? _value.benefits
          : benefits // ignore: cast_nullable_to_non_nullable
              as List<String>,
      colorHex: null == colorHex
          ? _value.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String,
      iconAsset: null == iconAsset
          ? _value.iconAsset
          : iconAsset // ignore: cast_nullable_to_non_nullable
              as String,
      earlyAccess: null == earlyAccess
          ? _value.earlyAccess
          : earlyAccess // ignore: cast_nullable_to_non_nullable
              as bool,
      priorityBookingHours: null == priorityBookingHours
          ? _value.priorityBookingHours
          : priorityBookingHours // ignore: cast_nullable_to_non_nullable
              as int,
      pointsMultiplier: null == pointsMultiplier
          ? _value.pointsMultiplier
          : pointsMultiplier // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TierImplCopyWith<$Res> implements $TierCopyWith<$Res> {
  factory _$$TierImplCopyWith(
          _$TierImpl value, $Res Function(_$TierImpl) then) =
      __$$TierImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {TierLevel level,
      String name,
      String description,
      int minPoints,
      int minSpend,
      double discountPercentage,
      List<String> benefits,
      String colorHex,
      String iconAsset,
      bool earlyAccess,
      int priorityBookingHours,
      double pointsMultiplier});
}

/// @nodoc
class __$$TierImplCopyWithImpl<$Res>
    extends _$TierCopyWithImpl<$Res, _$TierImpl>
    implements _$$TierImplCopyWith<$Res> {
  __$$TierImplCopyWithImpl(_$TierImpl _value, $Res Function(_$TierImpl) _then)
      : super(_value, _then);

  /// Create a copy of Tier
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
    Object? name = null,
    Object? description = null,
    Object? minPoints = null,
    Object? minSpend = null,
    Object? discountPercentage = null,
    Object? benefits = null,
    Object? colorHex = null,
    Object? iconAsset = null,
    Object? earlyAccess = null,
    Object? priorityBookingHours = null,
    Object? pointsMultiplier = null,
  }) {
    return _then(_$TierImpl(
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as TierLevel,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      minPoints: null == minPoints
          ? _value.minPoints
          : minPoints // ignore: cast_nullable_to_non_nullable
              as int,
      minSpend: null == minSpend
          ? _value.minSpend
          : minSpend // ignore: cast_nullable_to_non_nullable
              as int,
      discountPercentage: null == discountPercentage
          ? _value.discountPercentage
          : discountPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      benefits: null == benefits
          ? _value._benefits
          : benefits // ignore: cast_nullable_to_non_nullable
              as List<String>,
      colorHex: null == colorHex
          ? _value.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String,
      iconAsset: null == iconAsset
          ? _value.iconAsset
          : iconAsset // ignore: cast_nullable_to_non_nullable
              as String,
      earlyAccess: null == earlyAccess
          ? _value.earlyAccess
          : earlyAccess // ignore: cast_nullable_to_non_nullable
              as bool,
      priorityBookingHours: null == priorityBookingHours
          ? _value.priorityBookingHours
          : priorityBookingHours // ignore: cast_nullable_to_non_nullable
              as int,
      pointsMultiplier: null == pointsMultiplier
          ? _value.pointsMultiplier
          : pointsMultiplier // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TierImpl implements _Tier {
  const _$TierImpl(
      {required this.level,
      required this.name,
      required this.description,
      required this.minPoints,
      required this.minSpend,
      required this.discountPercentage,
      required final List<String> benefits,
      required this.colorHex,
      required this.iconAsset,
      this.earlyAccess = false,
      this.priorityBookingHours = 0,
      this.pointsMultiplier = 0})
      : _benefits = benefits;

  factory _$TierImpl.fromJson(Map<String, dynamic> json) =>
      _$$TierImplFromJson(json);

  @override
  final TierLevel level;
  @override
  final String name;
  @override
  final String description;
  @override
  final int minPoints;
  @override
  final int minSpend;
  @override
  final double discountPercentage;
  final List<String> _benefits;
  @override
  List<String> get benefits {
    if (_benefits is EqualUnmodifiableListView) return _benefits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_benefits);
  }

  @override
  final String colorHex;
  @override
  final String iconAsset;
  @override
  @JsonKey()
  final bool earlyAccess;
  @override
  @JsonKey()
  final int priorityBookingHours;
  @override
  @JsonKey()
  final double pointsMultiplier;

  @override
  String toString() {
    return 'Tier(level: $level, name: $name, description: $description, minPoints: $minPoints, minSpend: $minSpend, discountPercentage: $discountPercentage, benefits: $benefits, colorHex: $colorHex, iconAsset: $iconAsset, earlyAccess: $earlyAccess, priorityBookingHours: $priorityBookingHours, pointsMultiplier: $pointsMultiplier)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TierImpl &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.minPoints, minPoints) ||
                other.minPoints == minPoints) &&
            (identical(other.minSpend, minSpend) ||
                other.minSpend == minSpend) &&
            (identical(other.discountPercentage, discountPercentage) ||
                other.discountPercentage == discountPercentage) &&
            const DeepCollectionEquality().equals(other._benefits, _benefits) &&
            (identical(other.colorHex, colorHex) ||
                other.colorHex == colorHex) &&
            (identical(other.iconAsset, iconAsset) ||
                other.iconAsset == iconAsset) &&
            (identical(other.earlyAccess, earlyAccess) ||
                other.earlyAccess == earlyAccess) &&
            (identical(other.priorityBookingHours, priorityBookingHours) ||
                other.priorityBookingHours == priorityBookingHours) &&
            (identical(other.pointsMultiplier, pointsMultiplier) ||
                other.pointsMultiplier == pointsMultiplier));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      level,
      name,
      description,
      minPoints,
      minSpend,
      discountPercentage,
      const DeepCollectionEquality().hash(_benefits),
      colorHex,
      iconAsset,
      earlyAccess,
      priorityBookingHours,
      pointsMultiplier);

  /// Create a copy of Tier
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TierImplCopyWith<_$TierImpl> get copyWith =>
      __$$TierImplCopyWithImpl<_$TierImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TierImplToJson(
      this,
    );
  }
}

abstract class _Tier implements Tier {
  const factory _Tier(
      {required final TierLevel level,
      required final String name,
      required final String description,
      required final int minPoints,
      required final int minSpend,
      required final double discountPercentage,
      required final List<String> benefits,
      required final String colorHex,
      required final String iconAsset,
      final bool earlyAccess,
      final int priorityBookingHours,
      final double pointsMultiplier}) = _$TierImpl;

  factory _Tier.fromJson(Map<String, dynamic> json) = _$TierImpl.fromJson;

  @override
  TierLevel get level;
  @override
  String get name;
  @override
  String get description;
  @override
  int get minPoints;
  @override
  int get minSpend;
  @override
  double get discountPercentage;
  @override
  List<String> get benefits;
  @override
  String get colorHex;
  @override
  String get iconAsset;
  @override
  bool get earlyAccess;
  @override
  int get priorityBookingHours;
  @override
  double get pointsMultiplier;

  /// Create a copy of Tier
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TierImplCopyWith<_$TierImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
