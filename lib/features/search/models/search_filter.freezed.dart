// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SearchFilter _$SearchFilterFromJson(Map<String, dynamic> json) {
  return _SearchFilter.fromJson(json);
}

/// @nodoc
mixin _$SearchFilter {
  List<String>? get categories => throw _privateConstructorUsedError;
  DateTimeRange? get dateRange => throw _privateConstructorUsedError;
  PriceRange? get priceRange => throw _privateConstructorUsedError;
  double? get maxDistance => throw _privateConstructorUsedError;
  List<String>? get neighborhoods => throw _privateConstructorUsedError;
  List<String>? get amenities => throw _privateConstructorUsedError;
  bool? get hasAvailability => throw _privateConstructorUsedError;
  bool get mustHaveBottleService => throw _privateConstructorUsedError;
  bool get verifiedVenuesOnly => throw _privateConstructorUsedError;
  String? get sortBy => throw _privateConstructorUsedError;

  /// Serializes this SearchFilter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchFilterCopyWith<SearchFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchFilterCopyWith<$Res> {
  factory $SearchFilterCopyWith(
          SearchFilter value, $Res Function(SearchFilter) then) =
      _$SearchFilterCopyWithImpl<$Res, SearchFilter>;
  @useResult
  $Res call(
      {List<String>? categories,
      DateTimeRange? dateRange,
      PriceRange? priceRange,
      double? maxDistance,
      List<String>? neighborhoods,
      List<String>? amenities,
      bool? hasAvailability,
      bool mustHaveBottleService,
      bool verifiedVenuesOnly,
      String? sortBy});

  $DateTimeRangeCopyWith<$Res>? get dateRange;
  $PriceRangeCopyWith<$Res>? get priceRange;
}

/// @nodoc
class _$SearchFilterCopyWithImpl<$Res, $Val extends SearchFilter>
    implements $SearchFilterCopyWith<$Res> {
  _$SearchFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categories = freezed,
    Object? dateRange = freezed,
    Object? priceRange = freezed,
    Object? maxDistance = freezed,
    Object? neighborhoods = freezed,
    Object? amenities = freezed,
    Object? hasAvailability = freezed,
    Object? mustHaveBottleService = null,
    Object? verifiedVenuesOnly = null,
    Object? sortBy = freezed,
  }) {
    return _then(_value.copyWith(
      categories: freezed == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      dateRange: freezed == dateRange
          ? _value.dateRange
          : dateRange // ignore: cast_nullable_to_non_nullable
              as DateTimeRange?,
      priceRange: freezed == priceRange
          ? _value.priceRange
          : priceRange // ignore: cast_nullable_to_non_nullable
              as PriceRange?,
      maxDistance: freezed == maxDistance
          ? _value.maxDistance
          : maxDistance // ignore: cast_nullable_to_non_nullable
              as double?,
      neighborhoods: freezed == neighborhoods
          ? _value.neighborhoods
          : neighborhoods // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      amenities: freezed == amenities
          ? _value.amenities
          : amenities // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      hasAvailability: freezed == hasAvailability
          ? _value.hasAvailability
          : hasAvailability // ignore: cast_nullable_to_non_nullable
              as bool?,
      mustHaveBottleService: null == mustHaveBottleService
          ? _value.mustHaveBottleService
          : mustHaveBottleService // ignore: cast_nullable_to_non_nullable
              as bool,
      verifiedVenuesOnly: null == verifiedVenuesOnly
          ? _value.verifiedVenuesOnly
          : verifiedVenuesOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      sortBy: freezed == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of SearchFilter
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

  /// Create a copy of SearchFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PriceRangeCopyWith<$Res>? get priceRange {
    if (_value.priceRange == null) {
      return null;
    }

    return $PriceRangeCopyWith<$Res>(_value.priceRange!, (value) {
      return _then(_value.copyWith(priceRange: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SearchFilterImplCopyWith<$Res>
    implements $SearchFilterCopyWith<$Res> {
  factory _$$SearchFilterImplCopyWith(
          _$SearchFilterImpl value, $Res Function(_$SearchFilterImpl) then) =
      __$$SearchFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String>? categories,
      DateTimeRange? dateRange,
      PriceRange? priceRange,
      double? maxDistance,
      List<String>? neighborhoods,
      List<String>? amenities,
      bool? hasAvailability,
      bool mustHaveBottleService,
      bool verifiedVenuesOnly,
      String? sortBy});

  @override
  $DateTimeRangeCopyWith<$Res>? get dateRange;
  @override
  $PriceRangeCopyWith<$Res>? get priceRange;
}

/// @nodoc
class __$$SearchFilterImplCopyWithImpl<$Res>
    extends _$SearchFilterCopyWithImpl<$Res, _$SearchFilterImpl>
    implements _$$SearchFilterImplCopyWith<$Res> {
  __$$SearchFilterImplCopyWithImpl(
      _$SearchFilterImpl _value, $Res Function(_$SearchFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categories = freezed,
    Object? dateRange = freezed,
    Object? priceRange = freezed,
    Object? maxDistance = freezed,
    Object? neighborhoods = freezed,
    Object? amenities = freezed,
    Object? hasAvailability = freezed,
    Object? mustHaveBottleService = null,
    Object? verifiedVenuesOnly = null,
    Object? sortBy = freezed,
  }) {
    return _then(_$SearchFilterImpl(
      categories: freezed == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      dateRange: freezed == dateRange
          ? _value.dateRange
          : dateRange // ignore: cast_nullable_to_non_nullable
              as DateTimeRange?,
      priceRange: freezed == priceRange
          ? _value.priceRange
          : priceRange // ignore: cast_nullable_to_non_nullable
              as PriceRange?,
      maxDistance: freezed == maxDistance
          ? _value.maxDistance
          : maxDistance // ignore: cast_nullable_to_non_nullable
              as double?,
      neighborhoods: freezed == neighborhoods
          ? _value._neighborhoods
          : neighborhoods // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      amenities: freezed == amenities
          ? _value._amenities
          : amenities // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      hasAvailability: freezed == hasAvailability
          ? _value.hasAvailability
          : hasAvailability // ignore: cast_nullable_to_non_nullable
              as bool?,
      mustHaveBottleService: null == mustHaveBottleService
          ? _value.mustHaveBottleService
          : mustHaveBottleService // ignore: cast_nullable_to_non_nullable
              as bool,
      verifiedVenuesOnly: null == verifiedVenuesOnly
          ? _value.verifiedVenuesOnly
          : verifiedVenuesOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      sortBy: freezed == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchFilterImpl implements _SearchFilter {
  const _$SearchFilterImpl(
      {final List<String>? categories,
      this.dateRange,
      this.priceRange,
      this.maxDistance,
      final List<String>? neighborhoods,
      final List<String>? amenities,
      this.hasAvailability,
      this.mustHaveBottleService = false,
      this.verifiedVenuesOnly = false,
      this.sortBy})
      : _categories = categories,
        _neighborhoods = neighborhoods,
        _amenities = amenities;

  factory _$SearchFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchFilterImplFromJson(json);

  final List<String>? _categories;
  @override
  List<String>? get categories {
    final value = _categories;
    if (value == null) return null;
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTimeRange? dateRange;
  @override
  final PriceRange? priceRange;
  @override
  final double? maxDistance;
  final List<String>? _neighborhoods;
  @override
  List<String>? get neighborhoods {
    final value = _neighborhoods;
    if (value == null) return null;
    if (_neighborhoods is EqualUnmodifiableListView) return _neighborhoods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _amenities;
  @override
  List<String>? get amenities {
    final value = _amenities;
    if (value == null) return null;
    if (_amenities is EqualUnmodifiableListView) return _amenities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final bool? hasAvailability;
  @override
  @JsonKey()
  final bool mustHaveBottleService;
  @override
  @JsonKey()
  final bool verifiedVenuesOnly;
  @override
  final String? sortBy;

  @override
  String toString() {
    return 'SearchFilter(categories: $categories, dateRange: $dateRange, priceRange: $priceRange, maxDistance: $maxDistance, neighborhoods: $neighborhoods, amenities: $amenities, hasAvailability: $hasAvailability, mustHaveBottleService: $mustHaveBottleService, verifiedVenuesOnly: $verifiedVenuesOnly, sortBy: $sortBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchFilterImpl &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.dateRange, dateRange) ||
                other.dateRange == dateRange) &&
            (identical(other.priceRange, priceRange) ||
                other.priceRange == priceRange) &&
            (identical(other.maxDistance, maxDistance) ||
                other.maxDistance == maxDistance) &&
            const DeepCollectionEquality()
                .equals(other._neighborhoods, _neighborhoods) &&
            const DeepCollectionEquality()
                .equals(other._amenities, _amenities) &&
            (identical(other.hasAvailability, hasAvailability) ||
                other.hasAvailability == hasAvailability) &&
            (identical(other.mustHaveBottleService, mustHaveBottleService) ||
                other.mustHaveBottleService == mustHaveBottleService) &&
            (identical(other.verifiedVenuesOnly, verifiedVenuesOnly) ||
                other.verifiedVenuesOnly == verifiedVenuesOnly) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_categories),
      dateRange,
      priceRange,
      maxDistance,
      const DeepCollectionEquality().hash(_neighborhoods),
      const DeepCollectionEquality().hash(_amenities),
      hasAvailability,
      mustHaveBottleService,
      verifiedVenuesOnly,
      sortBy);

  /// Create a copy of SearchFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchFilterImplCopyWith<_$SearchFilterImpl> get copyWith =>
      __$$SearchFilterImplCopyWithImpl<_$SearchFilterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchFilterImplToJson(
      this,
    );
  }
}

abstract class _SearchFilter implements SearchFilter {
  const factory _SearchFilter(
      {final List<String>? categories,
      final DateTimeRange? dateRange,
      final PriceRange? priceRange,
      final double? maxDistance,
      final List<String>? neighborhoods,
      final List<String>? amenities,
      final bool? hasAvailability,
      final bool mustHaveBottleService,
      final bool verifiedVenuesOnly,
      final String? sortBy}) = _$SearchFilterImpl;

  factory _SearchFilter.fromJson(Map<String, dynamic> json) =
      _$SearchFilterImpl.fromJson;

  @override
  List<String>? get categories;
  @override
  DateTimeRange? get dateRange;
  @override
  PriceRange? get priceRange;
  @override
  double? get maxDistance;
  @override
  List<String>? get neighborhoods;
  @override
  List<String>? get amenities;
  @override
  bool? get hasAvailability;
  @override
  bool get mustHaveBottleService;
  @override
  bool get verifiedVenuesOnly;
  @override
  String? get sortBy;

  /// Create a copy of SearchFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchFilterImplCopyWith<_$SearchFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PriceRange _$PriceRangeFromJson(Map<String, dynamic> json) {
  return _PriceRange.fromJson(json);
}

/// @nodoc
mixin _$PriceRange {
  double get min => throw _privateConstructorUsedError;
  double get max => throw _privateConstructorUsedError;

  /// Serializes this PriceRange to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PriceRange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PriceRangeCopyWith<PriceRange> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PriceRangeCopyWith<$Res> {
  factory $PriceRangeCopyWith(
          PriceRange value, $Res Function(PriceRange) then) =
      _$PriceRangeCopyWithImpl<$Res, PriceRange>;
  @useResult
  $Res call({double min, double max});
}

/// @nodoc
class _$PriceRangeCopyWithImpl<$Res, $Val extends PriceRange>
    implements $PriceRangeCopyWith<$Res> {
  _$PriceRangeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PriceRange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? min = null,
    Object? max = null,
  }) {
    return _then(_value.copyWith(
      min: null == min
          ? _value.min
          : min // ignore: cast_nullable_to_non_nullable
              as double,
      max: null == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PriceRangeImplCopyWith<$Res>
    implements $PriceRangeCopyWith<$Res> {
  factory _$$PriceRangeImplCopyWith(
          _$PriceRangeImpl value, $Res Function(_$PriceRangeImpl) then) =
      __$$PriceRangeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double min, double max});
}

/// @nodoc
class __$$PriceRangeImplCopyWithImpl<$Res>
    extends _$PriceRangeCopyWithImpl<$Res, _$PriceRangeImpl>
    implements _$$PriceRangeImplCopyWith<$Res> {
  __$$PriceRangeImplCopyWithImpl(
      _$PriceRangeImpl _value, $Res Function(_$PriceRangeImpl) _then)
      : super(_value, _then);

  /// Create a copy of PriceRange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? min = null,
    Object? max = null,
  }) {
    return _then(_$PriceRangeImpl(
      min: null == min
          ? _value.min
          : min // ignore: cast_nullable_to_non_nullable
              as double,
      max: null == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PriceRangeImpl implements _PriceRange {
  const _$PriceRangeImpl({required this.min, required this.max});

  factory _$PriceRangeImpl.fromJson(Map<String, dynamic> json) =>
      _$$PriceRangeImplFromJson(json);

  @override
  final double min;
  @override
  final double max;

  @override
  String toString() {
    return 'PriceRange(min: $min, max: $max)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PriceRangeImpl &&
            (identical(other.min, min) || other.min == min) &&
            (identical(other.max, max) || other.max == max));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, min, max);

  /// Create a copy of PriceRange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PriceRangeImplCopyWith<_$PriceRangeImpl> get copyWith =>
      __$$PriceRangeImplCopyWithImpl<_$PriceRangeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PriceRangeImplToJson(
      this,
    );
  }
}

abstract class _PriceRange implements PriceRange {
  const factory _PriceRange(
      {required final double min,
      required final double max}) = _$PriceRangeImpl;

  factory _PriceRange.fromJson(Map<String, dynamic> json) =
      _$PriceRangeImpl.fromJson;

  @override
  double get min;
  @override
  double get max;

  /// Create a copy of PriceRange
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PriceRangeImplCopyWith<_$PriceRangeImpl> get copyWith =>
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

SearchResult _$SearchResultFromJson(Map<String, dynamic> json) {
  return _SearchResult.fromJson(json);
}

/// @nodoc
mixin _$SearchResult {
  String get id => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // 'event', 'venue', 'promoter'
  String get title => throw _privateConstructorUsedError;
  String? get subtitle => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;
  int? get reviewCount => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  DateTime? get eventDate => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  bool get isFeatured => throw _privateConstructorUsedError;

  /// Serializes this SearchResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchResultCopyWith<SearchResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchResultCopyWith<$Res> {
  factory $SearchResultCopyWith(
          SearchResult value, $Res Function(SearchResult) then) =
      _$SearchResultCopyWithImpl<$Res, SearchResult>;
  @useResult
  $Res call(
      {String id,
      String type,
      String title,
      String? subtitle,
      String? imageUrl,
      double? rating,
      int? reviewCount,
      double? price,
      String? location,
      DateTime? eventDate,
      bool isVerified,
      bool isFeatured});
}

/// @nodoc
class _$SearchResultCopyWithImpl<$Res, $Val extends SearchResult>
    implements $SearchResultCopyWith<$Res> {
  _$SearchResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? subtitle = freezed,
    Object? imageUrl = freezed,
    Object? rating = freezed,
    Object? reviewCount = freezed,
    Object? price = freezed,
    Object? location = freezed,
    Object? eventDate = freezed,
    Object? isVerified = null,
    Object? isFeatured = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: freezed == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      reviewCount: freezed == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      eventDate: freezed == eventDate
          ? _value.eventDate
          : eventDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SearchResultImplCopyWith<$Res>
    implements $SearchResultCopyWith<$Res> {
  factory _$$SearchResultImplCopyWith(
          _$SearchResultImpl value, $Res Function(_$SearchResultImpl) then) =
      __$$SearchResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String type,
      String title,
      String? subtitle,
      String? imageUrl,
      double? rating,
      int? reviewCount,
      double? price,
      String? location,
      DateTime? eventDate,
      bool isVerified,
      bool isFeatured});
}

/// @nodoc
class __$$SearchResultImplCopyWithImpl<$Res>
    extends _$SearchResultCopyWithImpl<$Res, _$SearchResultImpl>
    implements _$$SearchResultImplCopyWith<$Res> {
  __$$SearchResultImplCopyWithImpl(
      _$SearchResultImpl _value, $Res Function(_$SearchResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? subtitle = freezed,
    Object? imageUrl = freezed,
    Object? rating = freezed,
    Object? reviewCount = freezed,
    Object? price = freezed,
    Object? location = freezed,
    Object? eventDate = freezed,
    Object? isVerified = null,
    Object? isFeatured = null,
  }) {
    return _then(_$SearchResultImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: freezed == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      reviewCount: freezed == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      eventDate: freezed == eventDate
          ? _value.eventDate
          : eventDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchResultImpl implements _SearchResult {
  const _$SearchResultImpl(
      {required this.id,
      required this.type,
      required this.title,
      this.subtitle,
      this.imageUrl,
      this.rating,
      this.reviewCount,
      this.price,
      this.location,
      this.eventDate,
      this.isVerified = false,
      this.isFeatured = false});

  factory _$SearchResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchResultImplFromJson(json);

  @override
  final String id;
  @override
  final String type;
// 'event', 'venue', 'promoter'
  @override
  final String title;
  @override
  final String? subtitle;
  @override
  final String? imageUrl;
  @override
  final double? rating;
  @override
  final int? reviewCount;
  @override
  final double? price;
  @override
  final String? location;
  @override
  final DateTime? eventDate;
  @override
  @JsonKey()
  final bool isVerified;
  @override
  @JsonKey()
  final bool isFeatured;

  @override
  String toString() {
    return 'SearchResult(id: $id, type: $type, title: $title, subtitle: $subtitle, imageUrl: $imageUrl, rating: $rating, reviewCount: $reviewCount, price: $price, location: $location, eventDate: $eventDate, isVerified: $isVerified, isFeatured: $isFeatured)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchResultImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.eventDate, eventDate) ||
                other.eventDate == eventDate) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      title,
      subtitle,
      imageUrl,
      rating,
      reviewCount,
      price,
      location,
      eventDate,
      isVerified,
      isFeatured);

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchResultImplCopyWith<_$SearchResultImpl> get copyWith =>
      __$$SearchResultImplCopyWithImpl<_$SearchResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchResultImplToJson(
      this,
    );
  }
}

abstract class _SearchResult implements SearchResult {
  const factory _SearchResult(
      {required final String id,
      required final String type,
      required final String title,
      final String? subtitle,
      final String? imageUrl,
      final double? rating,
      final int? reviewCount,
      final double? price,
      final String? location,
      final DateTime? eventDate,
      final bool isVerified,
      final bool isFeatured}) = _$SearchResultImpl;

  factory _SearchResult.fromJson(Map<String, dynamic> json) =
      _$SearchResultImpl.fromJson;

  @override
  String get id;
  @override
  String get type; // 'event', 'venue', 'promoter'
  @override
  String get title;
  @override
  String? get subtitle;
  @override
  String? get imageUrl;
  @override
  double? get rating;
  @override
  int? get reviewCount;
  @override
  double? get price;
  @override
  String? get location;
  @override
  DateTime? get eventDate;
  @override
  bool get isVerified;
  @override
  bool get isFeatured;

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchResultImplCopyWith<_$SearchResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SearchSuggestion _$SearchSuggestionFromJson(Map<String, dynamic> json) {
  return _SearchSuggestion.fromJson(json);
}

/// @nodoc
mixin _$SearchSuggestion {
  String get text => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // 'query', 'venue', 'event', 'category'
  String? get icon => throw _privateConstructorUsedError;
  String? get subtitle => throw _privateConstructorUsedError;

  /// Serializes this SearchSuggestion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchSuggestionCopyWith<SearchSuggestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchSuggestionCopyWith<$Res> {
  factory $SearchSuggestionCopyWith(
          SearchSuggestion value, $Res Function(SearchSuggestion) then) =
      _$SearchSuggestionCopyWithImpl<$Res, SearchSuggestion>;
  @useResult
  $Res call({String text, String type, String? icon, String? subtitle});
}

/// @nodoc
class _$SearchSuggestionCopyWithImpl<$Res, $Val extends SearchSuggestion>
    implements $SearchSuggestionCopyWith<$Res> {
  _$SearchSuggestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? type = null,
    Object? icon = freezed,
    Object? subtitle = freezed,
  }) {
    return _then(_value.copyWith(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      subtitle: freezed == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SearchSuggestionImplCopyWith<$Res>
    implements $SearchSuggestionCopyWith<$Res> {
  factory _$$SearchSuggestionImplCopyWith(_$SearchSuggestionImpl value,
          $Res Function(_$SearchSuggestionImpl) then) =
      __$$SearchSuggestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String text, String type, String? icon, String? subtitle});
}

/// @nodoc
class __$$SearchSuggestionImplCopyWithImpl<$Res>
    extends _$SearchSuggestionCopyWithImpl<$Res, _$SearchSuggestionImpl>
    implements _$$SearchSuggestionImplCopyWith<$Res> {
  __$$SearchSuggestionImplCopyWithImpl(_$SearchSuggestionImpl _value,
      $Res Function(_$SearchSuggestionImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? type = null,
    Object? icon = freezed,
    Object? subtitle = freezed,
  }) {
    return _then(_$SearchSuggestionImpl(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      subtitle: freezed == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchSuggestionImpl implements _SearchSuggestion {
  const _$SearchSuggestionImpl(
      {required this.text, required this.type, this.icon, this.subtitle});

  factory _$SearchSuggestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchSuggestionImplFromJson(json);

  @override
  final String text;
  @override
  final String type;
// 'query', 'venue', 'event', 'category'
  @override
  final String? icon;
  @override
  final String? subtitle;

  @override
  String toString() {
    return 'SearchSuggestion(text: $text, type: $type, icon: $icon, subtitle: $subtitle)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchSuggestionImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, text, type, icon, subtitle);

  /// Create a copy of SearchSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchSuggestionImplCopyWith<_$SearchSuggestionImpl> get copyWith =>
      __$$SearchSuggestionImplCopyWithImpl<_$SearchSuggestionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchSuggestionImplToJson(
      this,
    );
  }
}

abstract class _SearchSuggestion implements SearchSuggestion {
  const factory _SearchSuggestion(
      {required final String text,
      required final String type,
      final String? icon,
      final String? subtitle}) = _$SearchSuggestionImpl;

  factory _SearchSuggestion.fromJson(Map<String, dynamic> json) =
      _$SearchSuggestionImpl.fromJson;

  @override
  String get text;
  @override
  String get type; // 'query', 'venue', 'event', 'category'
  @override
  String? get icon;
  @override
  String? get subtitle;

  /// Create a copy of SearchSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchSuggestionImplCopyWith<_$SearchSuggestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SearchHistory _$SearchHistoryFromJson(Map<String, dynamic> json) {
  return _SearchHistory.fromJson(json);
}

/// @nodoc
mixin _$SearchHistory {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get query => throw _privateConstructorUsedError;
  SearchFilter? get filters => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SearchHistory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchHistoryCopyWith<SearchHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchHistoryCopyWith<$Res> {
  factory $SearchHistoryCopyWith(
          SearchHistory value, $Res Function(SearchHistory) then) =
      _$SearchHistoryCopyWithImpl<$Res, SearchHistory>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String query,
      SearchFilter? filters,
      DateTime createdAt});

  $SearchFilterCopyWith<$Res>? get filters;
}

/// @nodoc
class _$SearchHistoryCopyWithImpl<$Res, $Val extends SearchHistory>
    implements $SearchHistoryCopyWith<$Res> {
  _$SearchHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? query = null,
    Object? filters = freezed,
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
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      filters: freezed == filters
          ? _value.filters
          : filters // ignore: cast_nullable_to_non_nullable
              as SearchFilter?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of SearchHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SearchFilterCopyWith<$Res>? get filters {
    if (_value.filters == null) {
      return null;
    }

    return $SearchFilterCopyWith<$Res>(_value.filters!, (value) {
      return _then(_value.copyWith(filters: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SearchHistoryImplCopyWith<$Res>
    implements $SearchHistoryCopyWith<$Res> {
  factory _$$SearchHistoryImplCopyWith(
          _$SearchHistoryImpl value, $Res Function(_$SearchHistoryImpl) then) =
      __$$SearchHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String query,
      SearchFilter? filters,
      DateTime createdAt});

  @override
  $SearchFilterCopyWith<$Res>? get filters;
}

/// @nodoc
class __$$SearchHistoryImplCopyWithImpl<$Res>
    extends _$SearchHistoryCopyWithImpl<$Res, _$SearchHistoryImpl>
    implements _$$SearchHistoryImplCopyWith<$Res> {
  __$$SearchHistoryImplCopyWithImpl(
      _$SearchHistoryImpl _value, $Res Function(_$SearchHistoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? query = null,
    Object? filters = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$SearchHistoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      filters: freezed == filters
          ? _value.filters
          : filters // ignore: cast_nullable_to_non_nullable
              as SearchFilter?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchHistoryImpl implements _SearchHistory {
  const _$SearchHistoryImpl(
      {required this.id,
      required this.userId,
      required this.query,
      this.filters,
      required this.createdAt});

  factory _$SearchHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchHistoryImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String query;
  @override
  final SearchFilter? filters;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'SearchHistory(id: $id, userId: $userId, query: $query, filters: $filters, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchHistoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.filters, filters) || other.filters == filters) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, userId, query, filters, createdAt);

  /// Create a copy of SearchHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchHistoryImplCopyWith<_$SearchHistoryImpl> get copyWith =>
      __$$SearchHistoryImplCopyWithImpl<_$SearchHistoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchHistoryImplToJson(
      this,
    );
  }
}

abstract class _SearchHistory implements SearchHistory {
  const factory _SearchHistory(
      {required final String id,
      required final String userId,
      required final String query,
      final SearchFilter? filters,
      required final DateTime createdAt}) = _$SearchHistoryImpl;

  factory _SearchHistory.fromJson(Map<String, dynamic> json) =
      _$SearchHistoryImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get query;
  @override
  SearchFilter? get filters;
  @override
  DateTime get createdAt;

  /// Create a copy of SearchHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchHistoryImplCopyWith<_$SearchHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
