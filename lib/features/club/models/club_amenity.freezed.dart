// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'club_amenity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ClubAmenity _$ClubAmenityFromJson(Map<String, dynamic> json) {
  return _ClubAmenity.fromJson(json);
}

/// @nodoc
mixin _$ClubAmenity {
  String get id => throw _privateConstructorUsedError;
  String get clubId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ClubAmenity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClubAmenity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClubAmenityCopyWith<ClubAmenity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClubAmenityCopyWith<$Res> {
  factory $ClubAmenityCopyWith(
          ClubAmenity value, $Res Function(ClubAmenity) then) =
      _$ClubAmenityCopyWithImpl<$Res, ClubAmenity>;
  @useResult
  $Res call(
      {String id,
      String clubId,
      String name,
      String? icon,
      DateTime? createdAt});
}

/// @nodoc
class _$ClubAmenityCopyWithImpl<$Res, $Val extends ClubAmenity>
    implements $ClubAmenityCopyWith<$Res> {
  _$ClubAmenityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClubAmenity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clubId = null,
    Object? name = null,
    Object? icon = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      clubId: null == clubId
          ? _value.clubId
          : clubId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClubAmenityImplCopyWith<$Res>
    implements $ClubAmenityCopyWith<$Res> {
  factory _$$ClubAmenityImplCopyWith(
          _$ClubAmenityImpl value, $Res Function(_$ClubAmenityImpl) then) =
      __$$ClubAmenityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String clubId,
      String name,
      String? icon,
      DateTime? createdAt});
}

/// @nodoc
class __$$ClubAmenityImplCopyWithImpl<$Res>
    extends _$ClubAmenityCopyWithImpl<$Res, _$ClubAmenityImpl>
    implements _$$ClubAmenityImplCopyWith<$Res> {
  __$$ClubAmenityImplCopyWithImpl(
      _$ClubAmenityImpl _value, $Res Function(_$ClubAmenityImpl) _then)
      : super(_value, _then);

  /// Create a copy of ClubAmenity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clubId = null,
    Object? name = null,
    Object? icon = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$ClubAmenityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      clubId: null == clubId
          ? _value.clubId
          : clubId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
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
class _$ClubAmenityImpl implements _ClubAmenity {
  const _$ClubAmenityImpl(
      {required this.id,
      required this.clubId,
      required this.name,
      this.icon,
      this.createdAt});

  factory _$ClubAmenityImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClubAmenityImplFromJson(json);

  @override
  final String id;
  @override
  final String clubId;
  @override
  final String name;
  @override
  final String? icon;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'ClubAmenity(id: $id, clubId: $clubId, name: $name, icon: $icon, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClubAmenityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clubId, clubId) || other.clubId == clubId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, clubId, name, icon, createdAt);

  /// Create a copy of ClubAmenity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClubAmenityImplCopyWith<_$ClubAmenityImpl> get copyWith =>
      __$$ClubAmenityImplCopyWithImpl<_$ClubAmenityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClubAmenityImplToJson(
      this,
    );
  }
}

abstract class _ClubAmenity implements ClubAmenity {
  const factory _ClubAmenity(
      {required final String id,
      required final String clubId,
      required final String name,
      final String? icon,
      final DateTime? createdAt}) = _$ClubAmenityImpl;

  factory _ClubAmenity.fromJson(Map<String, dynamic> json) =
      _$ClubAmenityImpl.fromJson;

  @override
  String get id;
  @override
  String get clubId;
  @override
  String get name;
  @override
  String? get icon;
  @override
  DateTime? get createdAt;

  /// Create a copy of ClubAmenity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClubAmenityImplCopyWith<_$ClubAmenityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
