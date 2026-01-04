// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Event _$EventFromJson(Map<String, dynamic> json) {
  return _Event.fromJson(json);
}

/// @nodoc
mixin _$Event {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get categoryId => throw _privateConstructorUsedError;
  String get clubId => throw _privateConstructorUsedError;
  String get zoneId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime get eventDate => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError;
  String get endTime => throw _privateConstructorUsedError;
  double get ticketPrice => throw _privateConstructorUsedError;
  int get maxCapacity => throw _privateConstructorUsedError;
  int? get currentBookings => throw _privateConstructorUsedError;
  int? get rsvpCount => throw _privateConstructorUsedError;
  int? get tableBookingCount => throw _privateConstructorUsedError;
  String? get dressCode => throw _privateConstructorUsedError;
  String? get invitationCode => throw _privateConstructorUsedError;
  bool get isPrivate => throw _privateConstructorUsedError;
  bool get locationHidden => throw _privateConstructorUsedError;
  List<String>? get images => throw _privateConstructorUsedError;
  String? get tableArrangementImageUrl => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isFeatured => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // Related data from joins
  String? get categoryName => throw _privateConstructorUsedError;
  String? get clubName => throw _privateConstructorUsedError;
  String? get clubLocation => throw _privateConstructorUsedError;
  String? get clubImageUrl => throw _privateConstructorUsedError;
  String? get zoneName => throw _privateConstructorUsedError;
  String? get zoneDescription => throw _privateConstructorUsedError;

  /// Serializes this Event to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventCopyWith<Event> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventCopyWith<$Res> {
  factory $EventCopyWith(Event value, $Res Function(Event) then) =
      _$EventCopyWithImpl<$Res, Event>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String categoryId,
      String clubId,
      String zoneId,
      String name,
      String description,
      DateTime eventDate,
      String startTime,
      String endTime,
      double ticketPrice,
      int maxCapacity,
      int? currentBookings,
      int? rsvpCount,
      int? tableBookingCount,
      String? dressCode,
      String? invitationCode,
      bool isPrivate,
      bool locationHidden,
      List<String>? images,
      String? tableArrangementImageUrl,
      String status,
      bool isActive,
      bool isFeatured,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? categoryName,
      String? clubName,
      String? clubLocation,
      String? clubImageUrl,
      String? zoneName,
      String? zoneDescription});
}

/// @nodoc
class _$EventCopyWithImpl<$Res, $Val extends Event>
    implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? categoryId = null,
    Object? clubId = null,
    Object? zoneId = null,
    Object? name = null,
    Object? description = null,
    Object? eventDate = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? ticketPrice = null,
    Object? maxCapacity = null,
    Object? currentBookings = freezed,
    Object? rsvpCount = freezed,
    Object? tableBookingCount = freezed,
    Object? dressCode = freezed,
    Object? invitationCode = freezed,
    Object? isPrivate = null,
    Object? locationHidden = null,
    Object? images = freezed,
    Object? tableArrangementImageUrl = freezed,
    Object? status = null,
    Object? isActive = null,
    Object? isFeatured = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? categoryName = freezed,
    Object? clubName = freezed,
    Object? clubLocation = freezed,
    Object? clubImageUrl = freezed,
    Object? zoneName = freezed,
    Object? zoneDescription = freezed,
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
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      clubId: null == clubId
          ? _value.clubId
          : clubId // ignore: cast_nullable_to_non_nullable
              as String,
      zoneId: null == zoneId
          ? _value.zoneId
          : zoneId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
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
      ticketPrice: null == ticketPrice
          ? _value.ticketPrice
          : ticketPrice // ignore: cast_nullable_to_non_nullable
              as double,
      maxCapacity: null == maxCapacity
          ? _value.maxCapacity
          : maxCapacity // ignore: cast_nullable_to_non_nullable
              as int,
      currentBookings: freezed == currentBookings
          ? _value.currentBookings
          : currentBookings // ignore: cast_nullable_to_non_nullable
              as int?,
      rsvpCount: freezed == rsvpCount
          ? _value.rsvpCount
          : rsvpCount // ignore: cast_nullable_to_non_nullable
              as int?,
      tableBookingCount: freezed == tableBookingCount
          ? _value.tableBookingCount
          : tableBookingCount // ignore: cast_nullable_to_non_nullable
              as int?,
      dressCode: freezed == dressCode
          ? _value.dressCode
          : dressCode // ignore: cast_nullable_to_non_nullable
              as String?,
      invitationCode: freezed == invitationCode
          ? _value.invitationCode
          : invitationCode // ignore: cast_nullable_to_non_nullable
              as String?,
      isPrivate: null == isPrivate
          ? _value.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool,
      locationHidden: null == locationHidden
          ? _value.locationHidden
          : locationHidden // ignore: cast_nullable_to_non_nullable
              as bool,
      images: freezed == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      tableArrangementImageUrl: freezed == tableArrangementImageUrl
          ? _value.tableArrangementImageUrl
          : tableArrangementImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      clubName: freezed == clubName
          ? _value.clubName
          : clubName // ignore: cast_nullable_to_non_nullable
              as String?,
      clubLocation: freezed == clubLocation
          ? _value.clubLocation
          : clubLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      clubImageUrl: freezed == clubImageUrl
          ? _value.clubImageUrl
          : clubImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      zoneName: freezed == zoneName
          ? _value.zoneName
          : zoneName // ignore: cast_nullable_to_non_nullable
              as String?,
      zoneDescription: freezed == zoneDescription
          ? _value.zoneDescription
          : zoneDescription // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventImplCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$$EventImplCopyWith(
          _$EventImpl value, $Res Function(_$EventImpl) then) =
      __$$EventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String categoryId,
      String clubId,
      String zoneId,
      String name,
      String description,
      DateTime eventDate,
      String startTime,
      String endTime,
      double ticketPrice,
      int maxCapacity,
      int? currentBookings,
      int? rsvpCount,
      int? tableBookingCount,
      String? dressCode,
      String? invitationCode,
      bool isPrivate,
      bool locationHidden,
      List<String>? images,
      String? tableArrangementImageUrl,
      String status,
      bool isActive,
      bool isFeatured,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? categoryName,
      String? clubName,
      String? clubLocation,
      String? clubImageUrl,
      String? zoneName,
      String? zoneDescription});
}

/// @nodoc
class __$$EventImplCopyWithImpl<$Res>
    extends _$EventCopyWithImpl<$Res, _$EventImpl>
    implements _$$EventImplCopyWith<$Res> {
  __$$EventImplCopyWithImpl(
      _$EventImpl _value, $Res Function(_$EventImpl) _then)
      : super(_value, _then);

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? categoryId = null,
    Object? clubId = null,
    Object? zoneId = null,
    Object? name = null,
    Object? description = null,
    Object? eventDate = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? ticketPrice = null,
    Object? maxCapacity = null,
    Object? currentBookings = freezed,
    Object? rsvpCount = freezed,
    Object? tableBookingCount = freezed,
    Object? dressCode = freezed,
    Object? invitationCode = freezed,
    Object? isPrivate = null,
    Object? locationHidden = null,
    Object? images = freezed,
    Object? tableArrangementImageUrl = freezed,
    Object? status = null,
    Object? isActive = null,
    Object? isFeatured = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? categoryName = freezed,
    Object? clubName = freezed,
    Object? clubLocation = freezed,
    Object? clubImageUrl = freezed,
    Object? zoneName = freezed,
    Object? zoneDescription = freezed,
  }) {
    return _then(_$EventImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      clubId: null == clubId
          ? _value.clubId
          : clubId // ignore: cast_nullable_to_non_nullable
              as String,
      zoneId: null == zoneId
          ? _value.zoneId
          : zoneId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
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
      ticketPrice: null == ticketPrice
          ? _value.ticketPrice
          : ticketPrice // ignore: cast_nullable_to_non_nullable
              as double,
      maxCapacity: null == maxCapacity
          ? _value.maxCapacity
          : maxCapacity // ignore: cast_nullable_to_non_nullable
              as int,
      currentBookings: freezed == currentBookings
          ? _value.currentBookings
          : currentBookings // ignore: cast_nullable_to_non_nullable
              as int?,
      rsvpCount: freezed == rsvpCount
          ? _value.rsvpCount
          : rsvpCount // ignore: cast_nullable_to_non_nullable
              as int?,
      tableBookingCount: freezed == tableBookingCount
          ? _value.tableBookingCount
          : tableBookingCount // ignore: cast_nullable_to_non_nullable
              as int?,
      dressCode: freezed == dressCode
          ? _value.dressCode
          : dressCode // ignore: cast_nullable_to_non_nullable
              as String?,
      invitationCode: freezed == invitationCode
          ? _value.invitationCode
          : invitationCode // ignore: cast_nullable_to_non_nullable
              as String?,
      isPrivate: null == isPrivate
          ? _value.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool,
      locationHidden: null == locationHidden
          ? _value.locationHidden
          : locationHidden // ignore: cast_nullable_to_non_nullable
              as bool,
      images: freezed == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      tableArrangementImageUrl: freezed == tableArrangementImageUrl
          ? _value.tableArrangementImageUrl
          : tableArrangementImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      clubName: freezed == clubName
          ? _value.clubName
          : clubName // ignore: cast_nullable_to_non_nullable
              as String?,
      clubLocation: freezed == clubLocation
          ? _value.clubLocation
          : clubLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      clubImageUrl: freezed == clubImageUrl
          ? _value.clubImageUrl
          : clubImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      zoneName: freezed == zoneName
          ? _value.zoneName
          : zoneName // ignore: cast_nullable_to_non_nullable
              as String?,
      zoneDescription: freezed == zoneDescription
          ? _value.zoneDescription
          : zoneDescription // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventImpl implements _Event {
  const _$EventImpl(
      {required this.id,
      required this.userId,
      required this.categoryId,
      required this.clubId,
      required this.zoneId,
      required this.name,
      required this.description,
      required this.eventDate,
      required this.startTime,
      required this.endTime,
      required this.ticketPrice,
      required this.maxCapacity,
      this.currentBookings,
      this.rsvpCount,
      this.tableBookingCount,
      this.dressCode,
      this.invitationCode,
      this.isPrivate = false,
      this.locationHidden = true,
      final List<String>? images,
      this.tableArrangementImageUrl,
      this.status = 'upcoming',
      this.isActive = true,
      this.isFeatured = false,
      this.createdAt,
      this.updatedAt,
      this.categoryName,
      this.clubName,
      this.clubLocation,
      this.clubImageUrl,
      this.zoneName,
      this.zoneDescription})
      : _images = images;

  factory _$EventImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String categoryId;
  @override
  final String clubId;
  @override
  final String zoneId;
  @override
  final String name;
  @override
  final String description;
  @override
  final DateTime eventDate;
  @override
  final String startTime;
  @override
  final String endTime;
  @override
  final double ticketPrice;
  @override
  final int maxCapacity;
  @override
  final int? currentBookings;
  @override
  final int? rsvpCount;
  @override
  final int? tableBookingCount;
  @override
  final String? dressCode;
  @override
  final String? invitationCode;
  @override
  @JsonKey()
  final bool isPrivate;
  @override
  @JsonKey()
  final bool locationHidden;
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
  final String? tableArrangementImageUrl;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isFeatured;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
// Related data from joins
  @override
  final String? categoryName;
  @override
  final String? clubName;
  @override
  final String? clubLocation;
  @override
  final String? clubImageUrl;
  @override
  final String? zoneName;
  @override
  final String? zoneDescription;

  @override
  String toString() {
    return 'Event(id: $id, userId: $userId, categoryId: $categoryId, clubId: $clubId, zoneId: $zoneId, name: $name, description: $description, eventDate: $eventDate, startTime: $startTime, endTime: $endTime, ticketPrice: $ticketPrice, maxCapacity: $maxCapacity, currentBookings: $currentBookings, rsvpCount: $rsvpCount, tableBookingCount: $tableBookingCount, dressCode: $dressCode, invitationCode: $invitationCode, isPrivate: $isPrivate, locationHidden: $locationHidden, images: $images, tableArrangementImageUrl: $tableArrangementImageUrl, status: $status, isActive: $isActive, isFeatured: $isFeatured, createdAt: $createdAt, updatedAt: $updatedAt, categoryName: $categoryName, clubName: $clubName, clubLocation: $clubLocation, clubImageUrl: $clubImageUrl, zoneName: $zoneName, zoneDescription: $zoneDescription)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.clubId, clubId) || other.clubId == clubId) &&
            (identical(other.zoneId, zoneId) || other.zoneId == zoneId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.eventDate, eventDate) ||
                other.eventDate == eventDate) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.ticketPrice, ticketPrice) ||
                other.ticketPrice == ticketPrice) &&
            (identical(other.maxCapacity, maxCapacity) ||
                other.maxCapacity == maxCapacity) &&
            (identical(other.currentBookings, currentBookings) ||
                other.currentBookings == currentBookings) &&
            (identical(other.rsvpCount, rsvpCount) ||
                other.rsvpCount == rsvpCount) &&
            (identical(other.tableBookingCount, tableBookingCount) ||
                other.tableBookingCount == tableBookingCount) &&
            (identical(other.dressCode, dressCode) ||
                other.dressCode == dressCode) &&
            (identical(other.invitationCode, invitationCode) ||
                other.invitationCode == invitationCode) &&
            (identical(other.isPrivate, isPrivate) ||
                other.isPrivate == isPrivate) &&
            (identical(other.locationHidden, locationHidden) ||
                other.locationHidden == locationHidden) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(
                    other.tableArrangementImageUrl, tableArrangementImageUrl) ||
                other.tableArrangementImageUrl == tableArrangementImageUrl) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.clubName, clubName) ||
                other.clubName == clubName) &&
            (identical(other.clubLocation, clubLocation) ||
                other.clubLocation == clubLocation) &&
            (identical(other.clubImageUrl, clubImageUrl) ||
                other.clubImageUrl == clubImageUrl) &&
            (identical(other.zoneName, zoneName) ||
                other.zoneName == zoneName) &&
            (identical(other.zoneDescription, zoneDescription) ||
                other.zoneDescription == zoneDescription));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        categoryId,
        clubId,
        zoneId,
        name,
        description,
        eventDate,
        startTime,
        endTime,
        ticketPrice,
        maxCapacity,
        currentBookings,
        rsvpCount,
        tableBookingCount,
        dressCode,
        invitationCode,
        isPrivate,
        locationHidden,
        const DeepCollectionEquality().hash(_images),
        tableArrangementImageUrl,
        status,
        isActive,
        isFeatured,
        createdAt,
        updatedAt,
        categoryName,
        clubName,
        clubLocation,
        clubImageUrl,
        zoneName,
        zoneDescription
      ]);

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventImplCopyWith<_$EventImpl> get copyWith =>
      __$$EventImplCopyWithImpl<_$EventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventImplToJson(
      this,
    );
  }
}

abstract class _Event implements Event {
  const factory _Event(
      {required final String id,
      required final String userId,
      required final String categoryId,
      required final String clubId,
      required final String zoneId,
      required final String name,
      required final String description,
      required final DateTime eventDate,
      required final String startTime,
      required final String endTime,
      required final double ticketPrice,
      required final int maxCapacity,
      final int? currentBookings,
      final int? rsvpCount,
      final int? tableBookingCount,
      final String? dressCode,
      final String? invitationCode,
      final bool isPrivate,
      final bool locationHidden,
      final List<String>? images,
      final String? tableArrangementImageUrl,
      final String status,
      final bool isActive,
      final bool isFeatured,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final String? categoryName,
      final String? clubName,
      final String? clubLocation,
      final String? clubImageUrl,
      final String? zoneName,
      final String? zoneDescription}) = _$EventImpl;

  factory _Event.fromJson(Map<String, dynamic> json) = _$EventImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get categoryId;
  @override
  String get clubId;
  @override
  String get zoneId;
  @override
  String get name;
  @override
  String get description;
  @override
  DateTime get eventDate;
  @override
  String get startTime;
  @override
  String get endTime;
  @override
  double get ticketPrice;
  @override
  int get maxCapacity;
  @override
  int? get currentBookings;
  @override
  int? get rsvpCount;
  @override
  int? get tableBookingCount;
  @override
  String? get dressCode;
  @override
  String? get invitationCode;
  @override
  bool get isPrivate;
  @override
  bool get locationHidden;
  @override
  List<String>? get images;
  @override
  String? get tableArrangementImageUrl;
  @override
  String get status;
  @override
  bool get isActive;
  @override
  bool get isFeatured;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt; // Related data from joins
  @override
  String? get categoryName;
  @override
  String? get clubName;
  @override
  String? get clubLocation;
  @override
  String? get clubImageUrl;
  @override
  String? get zoneName;
  @override
  String? get zoneDescription;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventImplCopyWith<_$EventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
