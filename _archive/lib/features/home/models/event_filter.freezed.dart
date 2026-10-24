// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventFilter _$EventFilterFromJson(Map<String, dynamic> json) {
  return _EventFilter.fromJson(json);
}

/// @nodoc
mixin _$EventFilter {
  String? get genre => throw _privateConstructorUsedError;
  DateTime? get date => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;

  /// Serializes this EventFilter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EventFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventFilterCopyWith<EventFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventFilterCopyWith<$Res> {
  factory $EventFilterCopyWith(
          EventFilter value, $Res Function(EventFilter) then) =
      _$EventFilterCopyWithImpl<$Res, EventFilter>;
  @useResult
  $Res call({String? genre, DateTime? date, String? location});
}

/// @nodoc
class _$EventFilterCopyWithImpl<$Res, $Val extends EventFilter>
    implements $EventFilterCopyWith<$Res> {
  _$EventFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? genre = freezed,
    Object? date = freezed,
    Object? location = freezed,
  }) {
    return _then(_value.copyWith(
      genre: freezed == genre
          ? _value.genre
          : genre // ignore: cast_nullable_to_non_nullable
              as String?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventFilterImplCopyWith<$Res>
    implements $EventFilterCopyWith<$Res> {
  factory _$$EventFilterImplCopyWith(
          _$EventFilterImpl value, $Res Function(_$EventFilterImpl) then) =
      __$$EventFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? genre, DateTime? date, String? location});
}

/// @nodoc
class __$$EventFilterImplCopyWithImpl<$Res>
    extends _$EventFilterCopyWithImpl<$Res, _$EventFilterImpl>
    implements _$$EventFilterImplCopyWith<$Res> {
  __$$EventFilterImplCopyWithImpl(
      _$EventFilterImpl _value, $Res Function(_$EventFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of EventFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? genre = freezed,
    Object? date = freezed,
    Object? location = freezed,
  }) {
    return _then(_$EventFilterImpl(
      genre: freezed == genre
          ? _value.genre
          : genre // ignore: cast_nullable_to_non_nullable
              as String?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventFilterImpl implements _EventFilter {
  const _$EventFilterImpl(
      {this.genre = null, this.date = null, this.location = null});

  factory _$EventFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventFilterImplFromJson(json);

  @override
  @JsonKey()
  final String? genre;
  @override
  @JsonKey()
  final DateTime? date;
  @override
  @JsonKey()
  final String? location;

  @override
  String toString() {
    return 'EventFilter(genre: $genre, date: $date, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventFilterImpl &&
            (identical(other.genre, genre) || other.genre == genre) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, genre, date, location);

  /// Create a copy of EventFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventFilterImplCopyWith<_$EventFilterImpl> get copyWith =>
      __$$EventFilterImplCopyWithImpl<_$EventFilterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventFilterImplToJson(
      this,
    );
  }
}

abstract class _EventFilter implements EventFilter {
  const factory _EventFilter(
      {final String? genre,
      final DateTime? date,
      final String? location}) = _$EventFilterImpl;

  factory _EventFilter.fromJson(Map<String, dynamic> json) =
      _$EventFilterImpl.fromJson;

  @override
  String? get genre;
  @override
  DateTime? get date;
  @override
  String? get location;

  /// Create a copy of EventFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventFilterImplCopyWith<_$EventFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
