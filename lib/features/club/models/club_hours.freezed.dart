// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'club_hours.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ClubHours _$ClubHoursFromJson(Map<String, dynamic> json) {
  return _ClubHours.fromJson(json);
}

/// @nodoc
mixin _$ClubHours {
  String get id => throw _privateConstructorUsedError;
  String get clubId => throw _privateConstructorUsedError;
  int get dayOfWeek =>
      throw _privateConstructorUsedError; // 0 = Sunday, 1 = Monday, ..., 6 = Saturday
  String? get openTime => throw _privateConstructorUsedError;
  String? get closeTime => throw _privateConstructorUsedError;
  bool get isClosed => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ClubHours to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClubHours
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClubHoursCopyWith<ClubHours> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClubHoursCopyWith<$Res> {
  factory $ClubHoursCopyWith(ClubHours value, $Res Function(ClubHours) then) =
      _$ClubHoursCopyWithImpl<$Res, ClubHours>;
  @useResult
  $Res call(
      {String id,
      String clubId,
      int dayOfWeek,
      String? openTime,
      String? closeTime,
      bool isClosed,
      DateTime? createdAt});
}

/// @nodoc
class _$ClubHoursCopyWithImpl<$Res, $Val extends ClubHours>
    implements $ClubHoursCopyWith<$Res> {
  _$ClubHoursCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClubHours
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clubId = null,
    Object? dayOfWeek = null,
    Object? openTime = freezed,
    Object? closeTime = freezed,
    Object? isClosed = null,
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
      dayOfWeek: null == dayOfWeek
          ? _value.dayOfWeek
          : dayOfWeek // ignore: cast_nullable_to_non_nullable
              as int,
      openTime: freezed == openTime
          ? _value.openTime
          : openTime // ignore: cast_nullable_to_non_nullable
              as String?,
      closeTime: freezed == closeTime
          ? _value.closeTime
          : closeTime // ignore: cast_nullable_to_non_nullable
              as String?,
      isClosed: null == isClosed
          ? _value.isClosed
          : isClosed // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClubHoursImplCopyWith<$Res>
    implements $ClubHoursCopyWith<$Res> {
  factory _$$ClubHoursImplCopyWith(
          _$ClubHoursImpl value, $Res Function(_$ClubHoursImpl) then) =
      __$$ClubHoursImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String clubId,
      int dayOfWeek,
      String? openTime,
      String? closeTime,
      bool isClosed,
      DateTime? createdAt});
}

/// @nodoc
class __$$ClubHoursImplCopyWithImpl<$Res>
    extends _$ClubHoursCopyWithImpl<$Res, _$ClubHoursImpl>
    implements _$$ClubHoursImplCopyWith<$Res> {
  __$$ClubHoursImplCopyWithImpl(
      _$ClubHoursImpl _value, $Res Function(_$ClubHoursImpl) _then)
      : super(_value, _then);

  /// Create a copy of ClubHours
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clubId = null,
    Object? dayOfWeek = null,
    Object? openTime = freezed,
    Object? closeTime = freezed,
    Object? isClosed = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$ClubHoursImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      clubId: null == clubId
          ? _value.clubId
          : clubId // ignore: cast_nullable_to_non_nullable
              as String,
      dayOfWeek: null == dayOfWeek
          ? _value.dayOfWeek
          : dayOfWeek // ignore: cast_nullable_to_non_nullable
              as int,
      openTime: freezed == openTime
          ? _value.openTime
          : openTime // ignore: cast_nullable_to_non_nullable
              as String?,
      closeTime: freezed == closeTime
          ? _value.closeTime
          : closeTime // ignore: cast_nullable_to_non_nullable
              as String?,
      isClosed: null == isClosed
          ? _value.isClosed
          : isClosed // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ClubHoursImpl implements _ClubHours {
  const _$ClubHoursImpl(
      {required this.id,
      required this.clubId,
      required this.dayOfWeek,
      this.openTime,
      this.closeTime,
      this.isClosed = false,
      this.createdAt});

  factory _$ClubHoursImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClubHoursImplFromJson(json);

  @override
  final String id;
  @override
  final String clubId;
  @override
  final int dayOfWeek;
// 0 = Sunday, 1 = Monday, ..., 6 = Saturday
  @override
  final String? openTime;
  @override
  final String? closeTime;
  @override
  @JsonKey()
  final bool isClosed;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'ClubHours(id: $id, clubId: $clubId, dayOfWeek: $dayOfWeek, openTime: $openTime, closeTime: $closeTime, isClosed: $isClosed, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClubHoursImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clubId, clubId) || other.clubId == clubId) &&
            (identical(other.dayOfWeek, dayOfWeek) ||
                other.dayOfWeek == dayOfWeek) &&
            (identical(other.openTime, openTime) ||
                other.openTime == openTime) &&
            (identical(other.closeTime, closeTime) ||
                other.closeTime == closeTime) &&
            (identical(other.isClosed, isClosed) ||
                other.isClosed == isClosed) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, clubId, dayOfWeek, openTime,
      closeTime, isClosed, createdAt);

  /// Create a copy of ClubHours
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClubHoursImplCopyWith<_$ClubHoursImpl> get copyWith =>
      __$$ClubHoursImplCopyWithImpl<_$ClubHoursImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClubHoursImplToJson(
      this,
    );
  }
}

abstract class _ClubHours implements ClubHours {
  const factory _ClubHours(
      {required final String id,
      required final String clubId,
      required final int dayOfWeek,
      final String? openTime,
      final String? closeTime,
      final bool isClosed,
      final DateTime? createdAt}) = _$ClubHoursImpl;

  factory _ClubHours.fromJson(Map<String, dynamic> json) =
      _$ClubHoursImpl.fromJson;

  @override
  String get id;
  @override
  String get clubId;
  @override
  int get dayOfWeek; // 0 = Sunday, 1 = Monday, ..., 6 = Saturday
  @override
  String? get openTime;
  @override
  String? get closeTime;
  @override
  bool get isClosed;
  @override
  DateTime? get createdAt;

  /// Create a copy of ClubHours
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClubHoursImplCopyWith<_$ClubHoursImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
