// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'venue.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Venue _$VenueFromJson(Map<String, dynamic> json) {
  return _Venue.fromJson(json);
}

/// @nodoc
mixin _$Venue {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get state => throw _privateConstructorUsedError;
  String get zipCode => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  List<String>? get images => throw _privateConstructorUsedError;
  int get capacity => throw _privateConstructorUsedError;
  double get pricePerHour => throw _privateConstructorUsedError;
  String get contactEmail => throw _privateConstructorUsedError;
  String get contactPhone => throw _privateConstructorUsedError;
  String? get website => throw _privateConstructorUsedError;
  List<String> get amenities => throw _privateConstructorUsedError;
  List<String> get venueTypes => throw _privateConstructorUsedError;
  double get averageRating => throw _privateConstructorUsedError;
  int get reviewCount => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  String? get managerId => throw _privateConstructorUsedError;
  Map<String, dynamic>? get availability => throw _privateConstructorUsedError;
  Map<String, dynamic>? get pricing => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Venue to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Venue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VenueCopyWith<Venue> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VenueCopyWith<$Res> {
  factory $VenueCopyWith(Venue value, $Res Function(Venue) then) =
      _$VenueCopyWithImpl<$Res, Venue>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String address,
      String city,
      String state,
      String zipCode,
      double latitude,
      double longitude,
      String? imageUrl,
      List<String>? images,
      int capacity,
      double pricePerHour,
      String contactEmail,
      String contactPhone,
      String? website,
      List<String> amenities,
      List<String> venueTypes,
      double averageRating,
      int reviewCount,
      bool isActive,
      bool isVerified,
      String? managerId,
      Map<String, dynamic>? availability,
      Map<String, dynamic>? pricing,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$VenueCopyWithImpl<$Res, $Val extends Venue>
    implements $VenueCopyWith<$Res> {
  _$VenueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Venue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? address = null,
    Object? city = null,
    Object? state = null,
    Object? zipCode = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? imageUrl = freezed,
    Object? images = freezed,
    Object? capacity = null,
    Object? pricePerHour = null,
    Object? contactEmail = null,
    Object? contactPhone = null,
    Object? website = freezed,
    Object? amenities = null,
    Object? venueTypes = null,
    Object? averageRating = null,
    Object? reviewCount = null,
    Object? isActive = null,
    Object? isVerified = null,
    Object? managerId = freezed,
    Object? availability = freezed,
    Object? pricing = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      zipCode: null == zipCode
          ? _value.zipCode
          : zipCode // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      images: freezed == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      capacity: null == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int,
      pricePerHour: null == pricePerHour
          ? _value.pricePerHour
          : pricePerHour // ignore: cast_nullable_to_non_nullable
              as double,
      contactEmail: null == contactEmail
          ? _value.contactEmail
          : contactEmail // ignore: cast_nullable_to_non_nullable
              as String,
      contactPhone: null == contactPhone
          ? _value.contactPhone
          : contactPhone // ignore: cast_nullable_to_non_nullable
              as String,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      amenities: null == amenities
          ? _value.amenities
          : amenities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      venueTypes: null == venueTypes
          ? _value.venueTypes
          : venueTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      managerId: freezed == managerId
          ? _value.managerId
          : managerId // ignore: cast_nullable_to_non_nullable
              as String?,
      availability: freezed == availability
          ? _value.availability
          : availability // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      pricing: freezed == pricing
          ? _value.pricing
          : pricing // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VenueImplCopyWith<$Res> implements $VenueCopyWith<$Res> {
  factory _$$VenueImplCopyWith(
          _$VenueImpl value, $Res Function(_$VenueImpl) then) =
      __$$VenueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String address,
      String city,
      String state,
      String zipCode,
      double latitude,
      double longitude,
      String? imageUrl,
      List<String>? images,
      int capacity,
      double pricePerHour,
      String contactEmail,
      String contactPhone,
      String? website,
      List<String> amenities,
      List<String> venueTypes,
      double averageRating,
      int reviewCount,
      bool isActive,
      bool isVerified,
      String? managerId,
      Map<String, dynamic>? availability,
      Map<String, dynamic>? pricing,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$VenueImplCopyWithImpl<$Res>
    extends _$VenueCopyWithImpl<$Res, _$VenueImpl>
    implements _$$VenueImplCopyWith<$Res> {
  __$$VenueImplCopyWithImpl(
      _$VenueImpl _value, $Res Function(_$VenueImpl) _then)
      : super(_value, _then);

  /// Create a copy of Venue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? address = null,
    Object? city = null,
    Object? state = null,
    Object? zipCode = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? imageUrl = freezed,
    Object? images = freezed,
    Object? capacity = null,
    Object? pricePerHour = null,
    Object? contactEmail = null,
    Object? contactPhone = null,
    Object? website = freezed,
    Object? amenities = null,
    Object? venueTypes = null,
    Object? averageRating = null,
    Object? reviewCount = null,
    Object? isActive = null,
    Object? isVerified = null,
    Object? managerId = freezed,
    Object? availability = freezed,
    Object? pricing = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$VenueImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      zipCode: null == zipCode
          ? _value.zipCode
          : zipCode // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      images: freezed == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      capacity: null == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int,
      pricePerHour: null == pricePerHour
          ? _value.pricePerHour
          : pricePerHour // ignore: cast_nullable_to_non_nullable
              as double,
      contactEmail: null == contactEmail
          ? _value.contactEmail
          : contactEmail // ignore: cast_nullable_to_non_nullable
              as String,
      contactPhone: null == contactPhone
          ? _value.contactPhone
          : contactPhone // ignore: cast_nullable_to_non_nullable
              as String,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      amenities: null == amenities
          ? _value._amenities
          : amenities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      venueTypes: null == venueTypes
          ? _value._venueTypes
          : venueTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      managerId: freezed == managerId
          ? _value.managerId
          : managerId // ignore: cast_nullable_to_non_nullable
              as String?,
      availability: freezed == availability
          ? _value._availability
          : availability // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      pricing: freezed == pricing
          ? _value._pricing
          : pricing // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VenueImpl implements _Venue {
  const _$VenueImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.address,
      required this.city,
      required this.state,
      required this.zipCode,
      required this.latitude,
      required this.longitude,
      this.imageUrl,
      final List<String>? images,
      required this.capacity,
      required this.pricePerHour,
      required this.contactEmail,
      required this.contactPhone,
      this.website,
      final List<String> amenities = const [],
      final List<String> venueTypes = const [],
      this.averageRating = 0.0,
      this.reviewCount = 0,
      this.isActive = true,
      this.isVerified = false,
      this.managerId,
      final Map<String, dynamic>? availability,
      final Map<String, dynamic>? pricing,
      this.createdAt,
      this.updatedAt})
      : _images = images,
        _amenities = amenities,
        _venueTypes = venueTypes,
        _availability = availability,
        _pricing = pricing;

  factory _$VenueImpl.fromJson(Map<String, dynamic> json) =>
      _$$VenueImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final String address;
  @override
  final String city;
  @override
  final String state;
  @override
  final String zipCode;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String? imageUrl;
  final List<String>? _images;
  @override
  List<String>? get images {
    final value = _images;
    if (value == null) return null;
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int capacity;
  @override
  final double pricePerHour;
  @override
  final String contactEmail;
  @override
  final String contactPhone;
  @override
  final String? website;
  final List<String> _amenities;
  @override
  @JsonKey()
  List<String> get amenities {
    if (_amenities is EqualUnmodifiableListView) return _amenities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_amenities);
  }

  final List<String> _venueTypes;
  @override
  @JsonKey()
  List<String> get venueTypes {
    if (_venueTypes is EqualUnmodifiableListView) return _venueTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_venueTypes);
  }

  @override
  @JsonKey()
  final double averageRating;
  @override
  @JsonKey()
  final int reviewCount;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isVerified;
  @override
  final String? managerId;
  final Map<String, dynamic>? _availability;
  @override
  Map<String, dynamic>? get availability {
    final value = _availability;
    if (value == null) return null;
    if (_availability is EqualUnmodifiableMapView) return _availability;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _pricing;
  @override
  Map<String, dynamic>? get pricing {
    final value = _pricing;
    if (value == null) return null;
    if (_pricing is EqualUnmodifiableMapView) return _pricing;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Venue(id: $id, name: $name, description: $description, address: $address, city: $city, state: $state, zipCode: $zipCode, latitude: $latitude, longitude: $longitude, imageUrl: $imageUrl, images: $images, capacity: $capacity, pricePerHour: $pricePerHour, contactEmail: $contactEmail, contactPhone: $contactPhone, website: $website, amenities: $amenities, venueTypes: $venueTypes, averageRating: $averageRating, reviewCount: $reviewCount, isActive: $isActive, isVerified: $isVerified, managerId: $managerId, availability: $availability, pricing: $pricing, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VenueImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.zipCode, zipCode) || other.zipCode == zipCode) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            (identical(other.pricePerHour, pricePerHour) ||
                other.pricePerHour == pricePerHour) &&
            (identical(other.contactEmail, contactEmail) ||
                other.contactEmail == contactEmail) &&
            (identical(other.contactPhone, contactPhone) ||
                other.contactPhone == contactPhone) &&
            (identical(other.website, website) || other.website == website) &&
            const DeepCollectionEquality()
                .equals(other._amenities, _amenities) &&
            const DeepCollectionEquality()
                .equals(other._venueTypes, _venueTypes) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.managerId, managerId) ||
                other.managerId == managerId) &&
            const DeepCollectionEquality()
                .equals(other._availability, _availability) &&
            const DeepCollectionEquality().equals(other._pricing, _pricing) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        description,
        address,
        city,
        state,
        zipCode,
        latitude,
        longitude,
        imageUrl,
        const DeepCollectionEquality().hash(_images),
        capacity,
        pricePerHour,
        contactEmail,
        contactPhone,
        website,
        const DeepCollectionEquality().hash(_amenities),
        const DeepCollectionEquality().hash(_venueTypes),
        averageRating,
        reviewCount,
        isActive,
        isVerified,
        managerId,
        const DeepCollectionEquality().hash(_availability),
        const DeepCollectionEquality().hash(_pricing),
        createdAt,
        updatedAt
      ]);

  /// Create a copy of Venue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VenueImplCopyWith<_$VenueImpl> get copyWith =>
      __$$VenueImplCopyWithImpl<_$VenueImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VenueImplToJson(
      this,
    );
  }
}

abstract class _Venue implements Venue {
  const factory _Venue(
      {required final String id,
      required final String name,
      required final String description,
      required final String address,
      required final String city,
      required final String state,
      required final String zipCode,
      required final double latitude,
      required final double longitude,
      final String? imageUrl,
      final List<String>? images,
      required final int capacity,
      required final double pricePerHour,
      required final String contactEmail,
      required final String contactPhone,
      final String? website,
      final List<String> amenities,
      final List<String> venueTypes,
      final double averageRating,
      final int reviewCount,
      final bool isActive,
      final bool isVerified,
      final String? managerId,
      final Map<String, dynamic>? availability,
      final Map<String, dynamic>? pricing,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$VenueImpl;

  factory _Venue.fromJson(Map<String, dynamic> json) = _$VenueImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  String get address;
  @override
  String get city;
  @override
  String get state;
  @override
  String get zipCode;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String? get imageUrl;
  @override
  List<String>? get images;
  @override
  int get capacity;
  @override
  double get pricePerHour;
  @override
  String get contactEmail;
  @override
  String get contactPhone;
  @override
  String? get website;
  @override
  List<String> get amenities;
  @override
  List<String> get venueTypes;
  @override
  double get averageRating;
  @override
  int get reviewCount;
  @override
  bool get isActive;
  @override
  bool get isVerified;
  @override
  String? get managerId;
  @override
  Map<String, dynamic>? get availability;
  @override
  Map<String, dynamic>? get pricing;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Venue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VenueImplCopyWith<_$VenueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VenueInquiry _$VenueInquiryFromJson(Map<String, dynamic> json) {
  return _VenueInquiry.fromJson(json);
}

/// @nodoc
mixin _$VenueInquiry {
  String get id => throw _privateConstructorUsedError;
  String get venueId => throw _privateConstructorUsedError;
  String get organizerId => throw _privateConstructorUsedError;
  String get eventName => throw _privateConstructorUsedError;
  DateTime get eventDate => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError;
  String get endTime => throw _privateConstructorUsedError;
  int get expectedGuests => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get venueResponse => throw _privateConstructorUsedError;
  DateTime? get responseDate => throw _privateConstructorUsedError;
  double? get quotedPrice => throw _privateConstructorUsedError;
  Map<String, dynamic>? get additionalDetails =>
      throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError; // Joined data
  String? get venueName => throw _privateConstructorUsedError;
  String? get venueImageUrl => throw _privateConstructorUsedError;
  String? get organizerName => throw _privateConstructorUsedError;
  String? get organizerEmail => throw _privateConstructorUsedError;

  /// Serializes this VenueInquiry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VenueInquiry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VenueInquiryCopyWith<VenueInquiry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VenueInquiryCopyWith<$Res> {
  factory $VenueInquiryCopyWith(
          VenueInquiry value, $Res Function(VenueInquiry) then) =
      _$VenueInquiryCopyWithImpl<$Res, VenueInquiry>;
  @useResult
  $Res call(
      {String id,
      String venueId,
      String organizerId,
      String eventName,
      DateTime eventDate,
      String startTime,
      String endTime,
      int expectedGuests,
      String message,
      String status,
      String? venueResponse,
      DateTime? responseDate,
      double? quotedPrice,
      Map<String, dynamic>? additionalDetails,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? venueName,
      String? venueImageUrl,
      String? organizerName,
      String? organizerEmail});
}

/// @nodoc
class _$VenueInquiryCopyWithImpl<$Res, $Val extends VenueInquiry>
    implements $VenueInquiryCopyWith<$Res> {
  _$VenueInquiryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VenueInquiry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? venueId = null,
    Object? organizerId = null,
    Object? eventName = null,
    Object? eventDate = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? expectedGuests = null,
    Object? message = null,
    Object? status = null,
    Object? venueResponse = freezed,
    Object? responseDate = freezed,
    Object? quotedPrice = freezed,
    Object? additionalDetails = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? venueName = freezed,
    Object? venueImageUrl = freezed,
    Object? organizerName = freezed,
    Object? organizerEmail = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      venueId: null == venueId
          ? _value.venueId
          : venueId // ignore: cast_nullable_to_non_nullable
              as String,
      organizerId: null == organizerId
          ? _value.organizerId
          : organizerId // ignore: cast_nullable_to_non_nullable
              as String,
      eventName: null == eventName
          ? _value.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String,
      eventDate: null == eventDate
          ? _value.eventDate
          : eventDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      expectedGuests: null == expectedGuests
          ? _value.expectedGuests
          : expectedGuests // ignore: cast_nullable_to_non_nullable
              as int,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      venueResponse: freezed == venueResponse
          ? _value.venueResponse
          : venueResponse // ignore: cast_nullable_to_non_nullable
              as String?,
      responseDate: freezed == responseDate
          ? _value.responseDate
          : responseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      quotedPrice: freezed == quotedPrice
          ? _value.quotedPrice
          : quotedPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      additionalDetails: freezed == additionalDetails
          ? _value.additionalDetails
          : additionalDetails // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      venueName: freezed == venueName
          ? _value.venueName
          : venueName // ignore: cast_nullable_to_non_nullable
              as String?,
      venueImageUrl: freezed == venueImageUrl
          ? _value.venueImageUrl
          : venueImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      organizerName: freezed == organizerName
          ? _value.organizerName
          : organizerName // ignore: cast_nullable_to_non_nullable
              as String?,
      organizerEmail: freezed == organizerEmail
          ? _value.organizerEmail
          : organizerEmail // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VenueInquiryImplCopyWith<$Res>
    implements $VenueInquiryCopyWith<$Res> {
  factory _$$VenueInquiryImplCopyWith(
          _$VenueInquiryImpl value, $Res Function(_$VenueInquiryImpl) then) =
      __$$VenueInquiryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String venueId,
      String organizerId,
      String eventName,
      DateTime eventDate,
      String startTime,
      String endTime,
      int expectedGuests,
      String message,
      String status,
      String? venueResponse,
      DateTime? responseDate,
      double? quotedPrice,
      Map<String, dynamic>? additionalDetails,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? venueName,
      String? venueImageUrl,
      String? organizerName,
      String? organizerEmail});
}

/// @nodoc
class __$$VenueInquiryImplCopyWithImpl<$Res>
    extends _$VenueInquiryCopyWithImpl<$Res, _$VenueInquiryImpl>
    implements _$$VenueInquiryImplCopyWith<$Res> {
  __$$VenueInquiryImplCopyWithImpl(
      _$VenueInquiryImpl _value, $Res Function(_$VenueInquiryImpl) _then)
      : super(_value, _then);

  /// Create a copy of VenueInquiry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? venueId = null,
    Object? organizerId = null,
    Object? eventName = null,
    Object? eventDate = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? expectedGuests = null,
    Object? message = null,
    Object? status = null,
    Object? venueResponse = freezed,
    Object? responseDate = freezed,
    Object? quotedPrice = freezed,
    Object? additionalDetails = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? venueName = freezed,
    Object? venueImageUrl = freezed,
    Object? organizerName = freezed,
    Object? organizerEmail = freezed,
  }) {
    return _then(_$VenueInquiryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      venueId: null == venueId
          ? _value.venueId
          : venueId // ignore: cast_nullable_to_non_nullable
              as String,
      organizerId: null == organizerId
          ? _value.organizerId
          : organizerId // ignore: cast_nullable_to_non_nullable
              as String,
      eventName: null == eventName
          ? _value.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String,
      eventDate: null == eventDate
          ? _value.eventDate
          : eventDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      expectedGuests: null == expectedGuests
          ? _value.expectedGuests
          : expectedGuests // ignore: cast_nullable_to_non_nullable
              as int,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      venueResponse: freezed == venueResponse
          ? _value.venueResponse
          : venueResponse // ignore: cast_nullable_to_non_nullable
              as String?,
      responseDate: freezed == responseDate
          ? _value.responseDate
          : responseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      quotedPrice: freezed == quotedPrice
          ? _value.quotedPrice
          : quotedPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      additionalDetails: freezed == additionalDetails
          ? _value._additionalDetails
          : additionalDetails // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      venueName: freezed == venueName
          ? _value.venueName
          : venueName // ignore: cast_nullable_to_non_nullable
              as String?,
      venueImageUrl: freezed == venueImageUrl
          ? _value.venueImageUrl
          : venueImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      organizerName: freezed == organizerName
          ? _value.organizerName
          : organizerName // ignore: cast_nullable_to_non_nullable
              as String?,
      organizerEmail: freezed == organizerEmail
          ? _value.organizerEmail
          : organizerEmail // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VenueInquiryImpl implements _VenueInquiry {
  const _$VenueInquiryImpl(
      {required this.id,
      required this.venueId,
      required this.organizerId,
      required this.eventName,
      required this.eventDate,
      required this.startTime,
      required this.endTime,
      required this.expectedGuests,
      required this.message,
      this.status = 'pending',
      this.venueResponse,
      this.responseDate,
      this.quotedPrice,
      final Map<String, dynamic>? additionalDetails,
      this.createdAt,
      this.updatedAt,
      this.venueName,
      this.venueImageUrl,
      this.organizerName,
      this.organizerEmail})
      : _additionalDetails = additionalDetails;

  factory _$VenueInquiryImpl.fromJson(Map<String, dynamic> json) =>
      _$$VenueInquiryImplFromJson(json);

  @override
  final String id;
  @override
  final String venueId;
  @override
  final String organizerId;
  @override
  final String eventName;
  @override
  final DateTime eventDate;
  @override
  final String startTime;
  @override
  final String endTime;
  @override
  final int expectedGuests;
  @override
  final String message;
  @override
  @JsonKey()
  final String status;
  @override
  final String? venueResponse;
  @override
  final DateTime? responseDate;
  @override
  final double? quotedPrice;
  final Map<String, dynamic>? _additionalDetails;
  @override
  Map<String, dynamic>? get additionalDetails {
    final value = _additionalDetails;
    if (value == null) return null;
    if (_additionalDetails is EqualUnmodifiableMapView)
      return _additionalDetails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
// Joined data
  @override
  final String? venueName;
  @override
  final String? venueImageUrl;
  @override
  final String? organizerName;
  @override
  final String? organizerEmail;

  @override
  String toString() {
    return 'VenueInquiry(id: $id, venueId: $venueId, organizerId: $organizerId, eventName: $eventName, eventDate: $eventDate, startTime: $startTime, endTime: $endTime, expectedGuests: $expectedGuests, message: $message, status: $status, venueResponse: $venueResponse, responseDate: $responseDate, quotedPrice: $quotedPrice, additionalDetails: $additionalDetails, createdAt: $createdAt, updatedAt: $updatedAt, venueName: $venueName, venueImageUrl: $venueImageUrl, organizerName: $organizerName, organizerEmail: $organizerEmail)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VenueInquiryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.venueId, venueId) || other.venueId == venueId) &&
            (identical(other.organizerId, organizerId) ||
                other.organizerId == organizerId) &&
            (identical(other.eventName, eventName) ||
                other.eventName == eventName) &&
            (identical(other.eventDate, eventDate) ||
                other.eventDate == eventDate) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.expectedGuests, expectedGuests) ||
                other.expectedGuests == expectedGuests) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.venueResponse, venueResponse) ||
                other.venueResponse == venueResponse) &&
            (identical(other.responseDate, responseDate) ||
                other.responseDate == responseDate) &&
            (identical(other.quotedPrice, quotedPrice) ||
                other.quotedPrice == quotedPrice) &&
            const DeepCollectionEquality()
                .equals(other._additionalDetails, _additionalDetails) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.venueName, venueName) ||
                other.venueName == venueName) &&
            (identical(other.venueImageUrl, venueImageUrl) ||
                other.venueImageUrl == venueImageUrl) &&
            (identical(other.organizerName, organizerName) ||
                other.organizerName == organizerName) &&
            (identical(other.organizerEmail, organizerEmail) ||
                other.organizerEmail == organizerEmail));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        venueId,
        organizerId,
        eventName,
        eventDate,
        startTime,
        endTime,
        expectedGuests,
        message,
        status,
        venueResponse,
        responseDate,
        quotedPrice,
        const DeepCollectionEquality().hash(_additionalDetails),
        createdAt,
        updatedAt,
        venueName,
        venueImageUrl,
        organizerName,
        organizerEmail
      ]);

  /// Create a copy of VenueInquiry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VenueInquiryImplCopyWith<_$VenueInquiryImpl> get copyWith =>
      __$$VenueInquiryImplCopyWithImpl<_$VenueInquiryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VenueInquiryImplToJson(
      this,
    );
  }
}

abstract class _VenueInquiry implements VenueInquiry {
  const factory _VenueInquiry(
      {required final String id,
      required final String venueId,
      required final String organizerId,
      required final String eventName,
      required final DateTime eventDate,
      required final String startTime,
      required final String endTime,
      required final int expectedGuests,
      required final String message,
      final String status,
      final String? venueResponse,
      final DateTime? responseDate,
      final double? quotedPrice,
      final Map<String, dynamic>? additionalDetails,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final String? venueName,
      final String? venueImageUrl,
      final String? organizerName,
      final String? organizerEmail}) = _$VenueInquiryImpl;

  factory _VenueInquiry.fromJson(Map<String, dynamic> json) =
      _$VenueInquiryImpl.fromJson;

  @override
  String get id;
  @override
  String get venueId;
  @override
  String get organizerId;
  @override
  String get eventName;
  @override
  DateTime get eventDate;
  @override
  String get startTime;
  @override
  String get endTime;
  @override
  int get expectedGuests;
  @override
  String get message;
  @override
  String get status;
  @override
  String? get venueResponse;
  @override
  DateTime? get responseDate;
  @override
  double? get quotedPrice;
  @override
  Map<String, dynamic>? get additionalDetails;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt; // Joined data
  @override
  String? get venueName;
  @override
  String? get venueImageUrl;
  @override
  String? get organizerName;
  @override
  String? get organizerEmail;

  /// Create a copy of VenueInquiry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VenueInquiryImplCopyWith<_$VenueInquiryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VenueRating _$VenueRatingFromJson(Map<String, dynamic> json) {
  return _VenueRating.fromJson(json);
}

/// @nodoc
mixin _$VenueRating {
  String get id => throw _privateConstructorUsedError;
  String get venueId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  String get review => throw _privateConstructorUsedError;
  List<String>? get images => throw _privateConstructorUsedError;
  int get helpfulCount => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError; // Joined data
  String? get userName => throw _privateConstructorUsedError;
  String? get userAvatar => throw _privateConstructorUsedError;

  /// Serializes this VenueRating to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VenueRating
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VenueRatingCopyWith<VenueRating> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VenueRatingCopyWith<$Res> {
  factory $VenueRatingCopyWith(
          VenueRating value, $Res Function(VenueRating) then) =
      _$VenueRatingCopyWithImpl<$Res, VenueRating>;
  @useResult
  $Res call(
      {String id,
      String venueId,
      String userId,
      double rating,
      String review,
      List<String>? images,
      int helpfulCount,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? userName,
      String? userAvatar});
}

/// @nodoc
class _$VenueRatingCopyWithImpl<$Res, $Val extends VenueRating>
    implements $VenueRatingCopyWith<$Res> {
  _$VenueRatingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VenueRating
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? venueId = null,
    Object? userId = null,
    Object? rating = null,
    Object? review = null,
    Object? images = freezed,
    Object? helpfulCount = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? userName = freezed,
    Object? userAvatar = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      venueId: null == venueId
          ? _value.venueId
          : venueId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      review: null == review
          ? _value.review
          : review // ignore: cast_nullable_to_non_nullable
              as String,
      images: freezed == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      helpfulCount: null == helpfulCount
          ? _value.helpfulCount
          : helpfulCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      userAvatar: freezed == userAvatar
          ? _value.userAvatar
          : userAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VenueRatingImplCopyWith<$Res>
    implements $VenueRatingCopyWith<$Res> {
  factory _$$VenueRatingImplCopyWith(
          _$VenueRatingImpl value, $Res Function(_$VenueRatingImpl) then) =
      __$$VenueRatingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String venueId,
      String userId,
      double rating,
      String review,
      List<String>? images,
      int helpfulCount,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? userName,
      String? userAvatar});
}

/// @nodoc
class __$$VenueRatingImplCopyWithImpl<$Res>
    extends _$VenueRatingCopyWithImpl<$Res, _$VenueRatingImpl>
    implements _$$VenueRatingImplCopyWith<$Res> {
  __$$VenueRatingImplCopyWithImpl(
      _$VenueRatingImpl _value, $Res Function(_$VenueRatingImpl) _then)
      : super(_value, _then);

  /// Create a copy of VenueRating
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? venueId = null,
    Object? userId = null,
    Object? rating = null,
    Object? review = null,
    Object? images = freezed,
    Object? helpfulCount = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? userName = freezed,
    Object? userAvatar = freezed,
  }) {
    return _then(_$VenueRatingImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      venueId: null == venueId
          ? _value.venueId
          : venueId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      review: null == review
          ? _value.review
          : review // ignore: cast_nullable_to_non_nullable
              as String,
      images: freezed == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      helpfulCount: null == helpfulCount
          ? _value.helpfulCount
          : helpfulCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      userAvatar: freezed == userAvatar
          ? _value.userAvatar
          : userAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VenueRatingImpl implements _VenueRating {
  const _$VenueRatingImpl(
      {required this.id,
      required this.venueId,
      required this.userId,
      required this.rating,
      required this.review,
      final List<String>? images,
      this.helpfulCount = 0,
      this.createdAt,
      this.updatedAt,
      this.userName,
      this.userAvatar})
      : _images = images;

  factory _$VenueRatingImpl.fromJson(Map<String, dynamic> json) =>
      _$$VenueRatingImplFromJson(json);

  @override
  final String id;
  @override
  final String venueId;
  @override
  final String userId;
  @override
  final double rating;
  @override
  final String review;
  final List<String>? _images;
  @override
  List<String>? get images {
    final value = _images;
    if (value == null) return null;
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final int helpfulCount;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
// Joined data
  @override
  final String? userName;
  @override
  final String? userAvatar;

  @override
  String toString() {
    return 'VenueRating(id: $id, venueId: $venueId, userId: $userId, rating: $rating, review: $review, images: $images, helpfulCount: $helpfulCount, createdAt: $createdAt, updatedAt: $updatedAt, userName: $userName, userAvatar: $userAvatar)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VenueRatingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.venueId, venueId) || other.venueId == venueId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.review, review) || other.review == review) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.helpfulCount, helpfulCount) ||
                other.helpfulCount == helpfulCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userAvatar, userAvatar) ||
                other.userAvatar == userAvatar));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      venueId,
      userId,
      rating,
      review,
      const DeepCollectionEquality().hash(_images),
      helpfulCount,
      createdAt,
      updatedAt,
      userName,
      userAvatar);

  /// Create a copy of VenueRating
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VenueRatingImplCopyWith<_$VenueRatingImpl> get copyWith =>
      __$$VenueRatingImplCopyWithImpl<_$VenueRatingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VenueRatingImplToJson(
      this,
    );
  }
}

abstract class _VenueRating implements VenueRating {
  const factory _VenueRating(
      {required final String id,
      required final String venueId,
      required final String userId,
      required final double rating,
      required final String review,
      final List<String>? images,
      final int helpfulCount,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final String? userName,
      final String? userAvatar}) = _$VenueRatingImpl;

  factory _VenueRating.fromJson(Map<String, dynamic> json) =
      _$VenueRatingImpl.fromJson;

  @override
  String get id;
  @override
  String get venueId;
  @override
  String get userId;
  @override
  double get rating;
  @override
  String get review;
  @override
  List<String>? get images;
  @override
  int get helpfulCount;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt; // Joined data
  @override
  String? get userName;
  @override
  String? get userAvatar;

  /// Create a copy of VenueRating
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VenueRatingImplCopyWith<_$VenueRatingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VenueComparison _$VenueComparisonFromJson(Map<String, dynamic> json) {
  return _VenueComparison.fromJson(json);
}

/// @nodoc
mixin _$VenueComparison {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  List<String> get venueIds => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  Map<String, dynamic>? get notes => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

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
      {String id,
      String userId,
      List<String> venueIds,
      String? name,
      Map<String, dynamic>? notes,
      DateTime? createdAt,
      DateTime? updatedAt});
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
    Object? id = null,
    Object? userId = null,
    Object? venueIds = null,
    Object? name = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
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
      venueIds: null == venueIds
          ? _value.venueIds
          : venueIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
      {String id,
      String userId,
      List<String> venueIds,
      String? name,
      Map<String, dynamic>? notes,
      DateTime? createdAt,
      DateTime? updatedAt});
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
    Object? id = null,
    Object? userId = null,
    Object? venueIds = null,
    Object? name = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$VenueComparisonImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      venueIds: null == venueIds
          ? _value._venueIds
          : venueIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value._notes
          : notes // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VenueComparisonImpl implements _VenueComparison {
  const _$VenueComparisonImpl(
      {required this.id,
      required this.userId,
      required final List<String> venueIds,
      this.name,
      final Map<String, dynamic>? notes,
      this.createdAt,
      this.updatedAt})
      : _venueIds = venueIds,
        _notes = notes;

  factory _$VenueComparisonImpl.fromJson(Map<String, dynamic> json) =>
      _$$VenueComparisonImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  final List<String> _venueIds;
  @override
  List<String> get venueIds {
    if (_venueIds is EqualUnmodifiableListView) return _venueIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_venueIds);
  }

  @override
  final String? name;
  final Map<String, dynamic>? _notes;
  @override
  Map<String, dynamic>? get notes {
    final value = _notes;
    if (value == null) return null;
    if (_notes is EqualUnmodifiableMapView) return _notes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'VenueComparison(id: $id, userId: $userId, venueIds: $venueIds, name: $name, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VenueComparisonImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality().equals(other._venueIds, _venueIds) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._notes, _notes) &&
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
      const DeepCollectionEquality().hash(_venueIds),
      name,
      const DeepCollectionEquality().hash(_notes),
      createdAt,
      updatedAt);

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
      {required final String id,
      required final String userId,
      required final List<String> venueIds,
      final String? name,
      final Map<String, dynamic>? notes,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$VenueComparisonImpl;

  factory _VenueComparison.fromJson(Map<String, dynamic> json) =
      _$VenueComparisonImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  List<String> get venueIds;
  @override
  String? get name;
  @override
  Map<String, dynamic>? get notes;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of VenueComparison
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VenueComparisonImplCopyWith<_$VenueComparisonImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
