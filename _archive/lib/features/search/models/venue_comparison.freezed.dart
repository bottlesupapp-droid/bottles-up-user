// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'venue_comparison.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VenueComparison _$VenueComparisonFromJson(Map<String, dynamic> json) {
  return _VenueComparison.fromJson(json);
}

/// @nodoc
mixin _$VenueComparison {
  List<ComparisonVenue> get venues => throw _privateConstructorUsedError;
  List<ComparisonFeature> get features => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this VenueComparison to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VenueComparison
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VenueComparisonCopyWith<VenueComparison> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VenueComparisonCopyWith<$Res> {
  factory $VenueComparisonCopyWith(
          VenueComparison value, $Res Function(VenueComparison) then) =
      _$VenueComparisonCopyWithImpl<$Res, VenueComparison>;
  @useResult
  $Res call(
      {List<ComparisonVenue> venues,
      List<ComparisonFeature> features,
      DateTime createdAt});
}

/// @nodoc
class _$VenueComparisonCopyWithImpl<$Res, $Val extends VenueComparison>
    implements $VenueComparisonCopyWith<$Res> {
  _$VenueComparisonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VenueComparison
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? venues = null,
    Object? features = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      venues: null == venues
          ? _value.venues
          : venues // ignore: cast_nullable_to_non_nullable
              as List<ComparisonVenue>,
      features: null == features
          ? _value.features
          : features // ignore: cast_nullable_to_non_nullable
              as List<ComparisonFeature>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VenueComparisonImplCopyWith<$Res>
    implements $VenueComparisonCopyWith<$Res> {
  factory _$$VenueComparisonImplCopyWith(_$VenueComparisonImpl value,
          $Res Function(_$VenueComparisonImpl) then) =
      __$$VenueComparisonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ComparisonVenue> venues,
      List<ComparisonFeature> features,
      DateTime createdAt});
}

/// @nodoc
class __$$VenueComparisonImplCopyWithImpl<$Res>
    extends _$VenueComparisonCopyWithImpl<$Res, _$VenueComparisonImpl>
    implements _$$VenueComparisonImplCopyWith<$Res> {
  __$$VenueComparisonImplCopyWithImpl(
      _$VenueComparisonImpl _value, $Res Function(_$VenueComparisonImpl) _then)
      : super(_value, _then);

  /// Create a copy of VenueComparison
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? venues = null,
    Object? features = null,
    Object? createdAt = null,
  }) {
    return _then(_$VenueComparisonImpl(
      venues: null == venues
          ? _value._venues
          : venues // ignore: cast_nullable_to_non_nullable
              as List<ComparisonVenue>,
      features: null == features
          ? _value._features
          : features // ignore: cast_nullable_to_non_nullable
              as List<ComparisonFeature>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VenueComparisonImpl implements _VenueComparison {
  const _$VenueComparisonImpl(
      {required final List<ComparisonVenue> venues,
      required final List<ComparisonFeature> features,
      required this.createdAt})
      : _venues = venues,
        _features = features;

  factory _$VenueComparisonImpl.fromJson(Map<String, dynamic> json) =>
      _$$VenueComparisonImplFromJson(json);

  final List<ComparisonVenue> _venues;
  @override
  List<ComparisonVenue> get venues {
    if (_venues is EqualUnmodifiableListView) return _venues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_venues);
  }

  final List<ComparisonFeature> _features;
  @override
  List<ComparisonFeature> get features {
    if (_features is EqualUnmodifiableListView) return _features;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_features);
  }

  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'VenueComparison(venues: $venues, features: $features, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VenueComparisonImpl &&
            const DeepCollectionEquality().equals(other._venues, _venues) &&
            const DeepCollectionEquality().equals(other._features, _features) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_venues),
      const DeepCollectionEquality().hash(_features),
      createdAt);

  /// Create a copy of VenueComparison
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VenueComparisonImplCopyWith<_$VenueComparisonImpl> get copyWith =>
      __$$VenueComparisonImplCopyWithImpl<_$VenueComparisonImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VenueComparisonImplToJson(
      this,
    );
  }
}

abstract class _VenueComparison implements VenueComparison {
  const factory _VenueComparison(
      {required final List<ComparisonVenue> venues,
      required final List<ComparisonFeature> features,
      required final DateTime createdAt}) = _$VenueComparisonImpl;

  factory _VenueComparison.fromJson(Map<String, dynamic> json) =
      _$VenueComparisonImpl.fromJson;

  @override
  List<ComparisonVenue> get venues;
  @override
  List<ComparisonFeature> get features;
  @override
  DateTime get createdAt;

  /// Create a copy of VenueComparison
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VenueComparisonImplCopyWith<_$VenueComparisonImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ComparisonVenue _$ComparisonVenueFromJson(Map<String, dynamic> json) {
  return _ComparisonVenue.fromJson(json);
}

/// @nodoc
mixin _$ComparisonVenue {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get reviewCount => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  Map<String, dynamic> get features => throw _privateConstructorUsedError;
  double? get averagePrice => throw _privateConstructorUsedError;
  int? get capacity => throw _privateConstructorUsedError;
  List<String>? get amenities => throw _privateConstructorUsedError;
  List<String>? get musicGenres => throw _privateConstructorUsedError;
  String? get dressCode => throw _privateConstructorUsedError;
  Map<String, String>? get hours => throw _privateConstructorUsedError;

  /// Serializes this ComparisonVenue to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ComparisonVenue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ComparisonVenueCopyWith<ComparisonVenue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ComparisonVenueCopyWith<$Res> {
  factory $ComparisonVenueCopyWith(
          ComparisonVenue value, $Res Function(ComparisonVenue) then) =
      _$ComparisonVenueCopyWithImpl<$Res, ComparisonVenue>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? imageUrl,
      double rating,
      int reviewCount,
      String address,
      Map<String, dynamic> features,
      double? averagePrice,
      int? capacity,
      List<String>? amenities,
      List<String>? musicGenres,
      String? dressCode,
      Map<String, String>? hours});
}

/// @nodoc
class _$ComparisonVenueCopyWithImpl<$Res, $Val extends ComparisonVenue>
    implements $ComparisonVenueCopyWith<$Res> {
  _$ComparisonVenueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ComparisonVenue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? imageUrl = freezed,
    Object? rating = null,
    Object? reviewCount = null,
    Object? address = null,
    Object? features = null,
    Object? averagePrice = freezed,
    Object? capacity = freezed,
    Object? amenities = freezed,
    Object? musicGenres = freezed,
    Object? dressCode = freezed,
    Object? hours = freezed,
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
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      features: null == features
          ? _value.features
          : features // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      averagePrice: freezed == averagePrice
          ? _value.averagePrice
          : averagePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      capacity: freezed == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int?,
      amenities: freezed == amenities
          ? _value.amenities
          : amenities // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      musicGenres: freezed == musicGenres
          ? _value.musicGenres
          : musicGenres // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      dressCode: freezed == dressCode
          ? _value.dressCode
          : dressCode // ignore: cast_nullable_to_non_nullable
              as String?,
      hours: freezed == hours
          ? _value.hours
          : hours // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ComparisonVenueImplCopyWith<$Res>
    implements $ComparisonVenueCopyWith<$Res> {
  factory _$$ComparisonVenueImplCopyWith(_$ComparisonVenueImpl value,
          $Res Function(_$ComparisonVenueImpl) then) =
      __$$ComparisonVenueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? imageUrl,
      double rating,
      int reviewCount,
      String address,
      Map<String, dynamic> features,
      double? averagePrice,
      int? capacity,
      List<String>? amenities,
      List<String>? musicGenres,
      String? dressCode,
      Map<String, String>? hours});
}

/// @nodoc
class __$$ComparisonVenueImplCopyWithImpl<$Res>
    extends _$ComparisonVenueCopyWithImpl<$Res, _$ComparisonVenueImpl>
    implements _$$ComparisonVenueImplCopyWith<$Res> {
  __$$ComparisonVenueImplCopyWithImpl(
      _$ComparisonVenueImpl _value, $Res Function(_$ComparisonVenueImpl) _then)
      : super(_value, _then);

  /// Create a copy of ComparisonVenue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? imageUrl = freezed,
    Object? rating = null,
    Object? reviewCount = null,
    Object? address = null,
    Object? features = null,
    Object? averagePrice = freezed,
    Object? capacity = freezed,
    Object? amenities = freezed,
    Object? musicGenres = freezed,
    Object? dressCode = freezed,
    Object? hours = freezed,
  }) {
    return _then(_$ComparisonVenueImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      features: null == features
          ? _value._features
          : features // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      averagePrice: freezed == averagePrice
          ? _value.averagePrice
          : averagePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      capacity: freezed == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int?,
      amenities: freezed == amenities
          ? _value._amenities
          : amenities // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      musicGenres: freezed == musicGenres
          ? _value._musicGenres
          : musicGenres // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      dressCode: freezed == dressCode
          ? _value.dressCode
          : dressCode // ignore: cast_nullable_to_non_nullable
              as String?,
      hours: freezed == hours
          ? _value._hours
          : hours // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ComparisonVenueImpl implements _ComparisonVenue {
  const _$ComparisonVenueImpl(
      {required this.id,
      required this.name,
      this.imageUrl,
      required this.rating,
      required this.reviewCount,
      required this.address,
      required final Map<String, dynamic> features,
      this.averagePrice,
      this.capacity,
      final List<String>? amenities,
      final List<String>? musicGenres,
      this.dressCode,
      final Map<String, String>? hours})
      : _features = features,
        _amenities = amenities,
        _musicGenres = musicGenres,
        _hours = hours;

  factory _$ComparisonVenueImpl.fromJson(Map<String, dynamic> json) =>
      _$$ComparisonVenueImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? imageUrl;
  @override
  final double rating;
  @override
  final int reviewCount;
  @override
  final String address;
  final Map<String, dynamic> _features;
  @override
  Map<String, dynamic> get features {
    if (_features is EqualUnmodifiableMapView) return _features;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_features);
  }

  @override
  final double? averagePrice;
  @override
  final int? capacity;
  final List<String>? _amenities;
  @override
  List<String>? get amenities {
    final value = _amenities;
    if (value == null) return null;
    if (_amenities is EqualUnmodifiableListView) return _amenities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _musicGenres;
  @override
  List<String>? get musicGenres {
    final value = _musicGenres;
    if (value == null) return null;
    if (_musicGenres is EqualUnmodifiableListView) return _musicGenres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? dressCode;
  final Map<String, String>? _hours;
  @override
  Map<String, String>? get hours {
    final value = _hours;
    if (value == null) return null;
    if (_hours is EqualUnmodifiableMapView) return _hours;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ComparisonVenue(id: $id, name: $name, imageUrl: $imageUrl, rating: $rating, reviewCount: $reviewCount, address: $address, features: $features, averagePrice: $averagePrice, capacity: $capacity, amenities: $amenities, musicGenres: $musicGenres, dressCode: $dressCode, hours: $hours)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ComparisonVenueImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.address, address) || other.address == address) &&
            const DeepCollectionEquality().equals(other._features, _features) &&
            (identical(other.averagePrice, averagePrice) ||
                other.averagePrice == averagePrice) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            const DeepCollectionEquality()
                .equals(other._amenities, _amenities) &&
            const DeepCollectionEquality()
                .equals(other._musicGenres, _musicGenres) &&
            (identical(other.dressCode, dressCode) ||
                other.dressCode == dressCode) &&
            const DeepCollectionEquality().equals(other._hours, _hours));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      imageUrl,
      rating,
      reviewCount,
      address,
      const DeepCollectionEquality().hash(_features),
      averagePrice,
      capacity,
      const DeepCollectionEquality().hash(_amenities),
      const DeepCollectionEquality().hash(_musicGenres),
      dressCode,
      const DeepCollectionEquality().hash(_hours));

  /// Create a copy of ComparisonVenue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ComparisonVenueImplCopyWith<_$ComparisonVenueImpl> get copyWith =>
      __$$ComparisonVenueImplCopyWithImpl<_$ComparisonVenueImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ComparisonVenueImplToJson(
      this,
    );
  }
}

abstract class _ComparisonVenue implements ComparisonVenue {
  const factory _ComparisonVenue(
      {required final String id,
      required final String name,
      final String? imageUrl,
      required final double rating,
      required final int reviewCount,
      required final String address,
      required final Map<String, dynamic> features,
      final double? averagePrice,
      final int? capacity,
      final List<String>? amenities,
      final List<String>? musicGenres,
      final String? dressCode,
      final Map<String, String>? hours}) = _$ComparisonVenueImpl;

  factory _ComparisonVenue.fromJson(Map<String, dynamic> json) =
      _$ComparisonVenueImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get imageUrl;
  @override
  double get rating;
  @override
  int get reviewCount;
  @override
  String get address;
  @override
  Map<String, dynamic> get features;
  @override
  double? get averagePrice;
  @override
  int? get capacity;
  @override
  List<String>? get amenities;
  @override
  List<String>? get musicGenres;
  @override
  String? get dressCode;
  @override
  Map<String, String>? get hours;

  /// Create a copy of ComparisonVenue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ComparisonVenueImplCopyWith<_$ComparisonVenueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ComparisonFeature _$ComparisonFeatureFromJson(Map<String, dynamic> json) {
  return _ComparisonFeature.fromJson(json);
}

/// @nodoc
mixin _$ComparisonFeature {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  FeatureType get type => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  int? get importance => throw _privateConstructorUsedError;

  /// Serializes this ComparisonFeature to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ComparisonFeature
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ComparisonFeatureCopyWith<ComparisonFeature> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ComparisonFeatureCopyWith<$Res> {
  factory $ComparisonFeatureCopyWith(
          ComparisonFeature value, $Res Function(ComparisonFeature) then) =
      _$ComparisonFeatureCopyWithImpl<$Res, ComparisonFeature>;
  @useResult
  $Res call(
      {String id,
      String name,
      String category,
      FeatureType type,
      String? icon,
      int? importance});
}

/// @nodoc
class _$ComparisonFeatureCopyWithImpl<$Res, $Val extends ComparisonFeature>
    implements $ComparisonFeatureCopyWith<$Res> {
  _$ComparisonFeatureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ComparisonFeature
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? type = null,
    Object? icon = freezed,
    Object? importance = freezed,
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
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as FeatureType,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      importance: freezed == importance
          ? _value.importance
          : importance // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ComparisonFeatureImplCopyWith<$Res>
    implements $ComparisonFeatureCopyWith<$Res> {
  factory _$$ComparisonFeatureImplCopyWith(_$ComparisonFeatureImpl value,
          $Res Function(_$ComparisonFeatureImpl) then) =
      __$$ComparisonFeatureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String category,
      FeatureType type,
      String? icon,
      int? importance});
}

/// @nodoc
class __$$ComparisonFeatureImplCopyWithImpl<$Res>
    extends _$ComparisonFeatureCopyWithImpl<$Res, _$ComparisonFeatureImpl>
    implements _$$ComparisonFeatureImplCopyWith<$Res> {
  __$$ComparisonFeatureImplCopyWithImpl(_$ComparisonFeatureImpl _value,
      $Res Function(_$ComparisonFeatureImpl) _then)
      : super(_value, _then);

  /// Create a copy of ComparisonFeature
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? type = null,
    Object? icon = freezed,
    Object? importance = freezed,
  }) {
    return _then(_$ComparisonFeatureImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as FeatureType,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      importance: freezed == importance
          ? _value.importance
          : importance // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ComparisonFeatureImpl implements _ComparisonFeature {
  const _$ComparisonFeatureImpl(
      {required this.id,
      required this.name,
      required this.category,
      required this.type,
      this.icon,
      this.importance});

  factory _$ComparisonFeatureImpl.fromJson(Map<String, dynamic> json) =>
      _$$ComparisonFeatureImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String category;
  @override
  final FeatureType type;
  @override
  final String? icon;
  @override
  final int? importance;

  @override
  String toString() {
    return 'ComparisonFeature(id: $id, name: $name, category: $category, type: $type, icon: $icon, importance: $importance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ComparisonFeatureImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.importance, importance) ||
                other.importance == importance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, category, type, icon, importance);

  /// Create a copy of ComparisonFeature
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ComparisonFeatureImplCopyWith<_$ComparisonFeatureImpl> get copyWith =>
      __$$ComparisonFeatureImplCopyWithImpl<_$ComparisonFeatureImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ComparisonFeatureImplToJson(
      this,
    );
  }
}

abstract class _ComparisonFeature implements ComparisonFeature {
  const factory _ComparisonFeature(
      {required final String id,
      required final String name,
      required final String category,
      required final FeatureType type,
      final String? icon,
      final int? importance}) = _$ComparisonFeatureImpl;

  factory _ComparisonFeature.fromJson(Map<String, dynamic> json) =
      _$ComparisonFeatureImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get category;
  @override
  FeatureType get type;
  @override
  String? get icon;
  @override
  int? get importance;

  /// Create a copy of ComparisonFeature
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ComparisonFeatureImplCopyWith<_$ComparisonFeatureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
