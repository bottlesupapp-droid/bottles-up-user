// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserActivity _$UserActivityFromJson(Map<String, dynamic> json) {
  return _UserActivity.fromJson(json);
}

/// @nodoc
mixin _$UserActivity {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  ActivityType get type => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get relatedId => throw _privateConstructorUsedError;
  String? get relatedType => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this UserActivity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserActivity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserActivityCopyWith<UserActivity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserActivityCopyWith<$Res> {
  factory $UserActivityCopyWith(
          UserActivity value, $Res Function(UserActivity) then) =
      _$UserActivityCopyWithImpl<$Res, UserActivity>;
  @useResult
  $Res call(
      {String id,
      String userId,
      ActivityType type,
      String description,
      String? relatedId,
      String? relatedType,
      Map<String, dynamic>? metadata,
      DateTime createdAt});
}

/// @nodoc
class _$UserActivityCopyWithImpl<$Res, $Val extends UserActivity>
    implements $UserActivityCopyWith<$Res> {
  _$UserActivityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserActivity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? description = null,
    Object? relatedId = freezed,
    Object? relatedType = freezed,
    Object? metadata = freezed,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ActivityType,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      relatedId: freezed == relatedId
          ? _value.relatedId
          : relatedId // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedType: freezed == relatedType
          ? _value.relatedType
          : relatedType // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserActivityImplCopyWith<$Res>
    implements $UserActivityCopyWith<$Res> {
  factory _$$UserActivityImplCopyWith(
          _$UserActivityImpl value, $Res Function(_$UserActivityImpl) then) =
      __$$UserActivityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      ActivityType type,
      String description,
      String? relatedId,
      String? relatedType,
      Map<String, dynamic>? metadata,
      DateTime createdAt});
}

/// @nodoc
class __$$UserActivityImplCopyWithImpl<$Res>
    extends _$UserActivityCopyWithImpl<$Res, _$UserActivityImpl>
    implements _$$UserActivityImplCopyWith<$Res> {
  __$$UserActivityImplCopyWithImpl(
      _$UserActivityImpl _value, $Res Function(_$UserActivityImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserActivity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? description = null,
    Object? relatedId = freezed,
    Object? relatedType = freezed,
    Object? metadata = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$UserActivityImpl(
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
              as ActivityType,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      relatedId: freezed == relatedId
          ? _value.relatedId
          : relatedId // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedType: freezed == relatedType
          ? _value.relatedType
          : relatedType // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserActivityImpl implements _UserActivity {
  const _$UserActivityImpl(
      {required this.id,
      required this.userId,
      required this.type,
      required this.description,
      this.relatedId,
      this.relatedType,
      final Map<String, dynamic>? metadata,
      required this.createdAt})
      : _metadata = metadata;

  factory _$UserActivityImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserActivityImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final ActivityType type;
  @override
  final String description;
  @override
  final String? relatedId;
  @override
  final String? relatedType;
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
  final DateTime createdAt;

  @override
  String toString() {
    return 'UserActivity(id: $id, userId: $userId, type: $type, description: $description, relatedId: $relatedId, relatedType: $relatedType, metadata: $metadata, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserActivityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.relatedId, relatedId) ||
                other.relatedId == relatedId) &&
            (identical(other.relatedType, relatedType) ||
                other.relatedType == relatedType) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      type,
      description,
      relatedId,
      relatedType,
      const DeepCollectionEquality().hash(_metadata),
      createdAt);

  /// Create a copy of UserActivity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserActivityImplCopyWith<_$UserActivityImpl> get copyWith =>
      __$$UserActivityImplCopyWithImpl<_$UserActivityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserActivityImplToJson(
      this,
    );
  }
}

abstract class _UserActivity implements UserActivity {
  const factory _UserActivity(
      {required final String id,
      required final String userId,
      required final ActivityType type,
      required final String description,
      final String? relatedId,
      final String? relatedType,
      final Map<String, dynamic>? metadata,
      required final DateTime createdAt}) = _$UserActivityImpl;

  factory _UserActivity.fromJson(Map<String, dynamic> json) =
      _$UserActivityImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  ActivityType get type;
  @override
  String get description;
  @override
  String? get relatedId;
  @override
  String? get relatedType;
  @override
  Map<String, dynamic>? get metadata;
  @override
  DateTime get createdAt;

  /// Create a copy of UserActivity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserActivityImplCopyWith<_$UserActivityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActivityStats _$ActivityStatsFromJson(Map<String, dynamic> json) {
  return _ActivityStats.fromJson(json);
}

/// @nodoc
mixin _$ActivityStats {
  int get totalActivities => throw _privateConstructorUsedError;
  int get bookingsCount => throw _privateConstructorUsedError;
  int get reviewsCount => throw _privateConstructorUsedError;
  int get checkInsCount => throw _privateConstructorUsedError;
  int get sharesCount => throw _privateConstructorUsedError;
  int get favoritesCount => throw _privateConstructorUsedError;
  Map<String, int> get activitiesByType => throw _privateConstructorUsedError;
  Map<String, int> get activitiesByMonth => throw _privateConstructorUsedError;
  DateTime? get firstActivityDate => throw _privateConstructorUsedError;
  DateTime? get lastActivityDate => throw _privateConstructorUsedError;
  int get currentStreak => throw _privateConstructorUsedError;
  int get longestStreak => throw _privateConstructorUsedError;

  /// Serializes this ActivityStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityStatsCopyWith<ActivityStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityStatsCopyWith<$Res> {
  factory $ActivityStatsCopyWith(
          ActivityStats value, $Res Function(ActivityStats) then) =
      _$ActivityStatsCopyWithImpl<$Res, ActivityStats>;
  @useResult
  $Res call(
      {int totalActivities,
      int bookingsCount,
      int reviewsCount,
      int checkInsCount,
      int sharesCount,
      int favoritesCount,
      Map<String, int> activitiesByType,
      Map<String, int> activitiesByMonth,
      DateTime? firstActivityDate,
      DateTime? lastActivityDate,
      int currentStreak,
      int longestStreak});
}

/// @nodoc
class _$ActivityStatsCopyWithImpl<$Res, $Val extends ActivityStats>
    implements $ActivityStatsCopyWith<$Res> {
  _$ActivityStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalActivities = null,
    Object? bookingsCount = null,
    Object? reviewsCount = null,
    Object? checkInsCount = null,
    Object? sharesCount = null,
    Object? favoritesCount = null,
    Object? activitiesByType = null,
    Object? activitiesByMonth = null,
    Object? firstActivityDate = freezed,
    Object? lastActivityDate = freezed,
    Object? currentStreak = null,
    Object? longestStreak = null,
  }) {
    return _then(_value.copyWith(
      totalActivities: null == totalActivities
          ? _value.totalActivities
          : totalActivities // ignore: cast_nullable_to_non_nullable
              as int,
      bookingsCount: null == bookingsCount
          ? _value.bookingsCount
          : bookingsCount // ignore: cast_nullable_to_non_nullable
              as int,
      reviewsCount: null == reviewsCount
          ? _value.reviewsCount
          : reviewsCount // ignore: cast_nullable_to_non_nullable
              as int,
      checkInsCount: null == checkInsCount
          ? _value.checkInsCount
          : checkInsCount // ignore: cast_nullable_to_non_nullable
              as int,
      sharesCount: null == sharesCount
          ? _value.sharesCount
          : sharesCount // ignore: cast_nullable_to_non_nullable
              as int,
      favoritesCount: null == favoritesCount
          ? _value.favoritesCount
          : favoritesCount // ignore: cast_nullable_to_non_nullable
              as int,
      activitiesByType: null == activitiesByType
          ? _value.activitiesByType
          : activitiesByType // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      activitiesByMonth: null == activitiesByMonth
          ? _value.activitiesByMonth
          : activitiesByMonth // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      firstActivityDate: freezed == firstActivityDate
          ? _value.firstActivityDate
          : firstActivityDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastActivityDate: freezed == lastActivityDate
          ? _value.lastActivityDate
          : lastActivityDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActivityStatsImplCopyWith<$Res>
    implements $ActivityStatsCopyWith<$Res> {
  factory _$$ActivityStatsImplCopyWith(
          _$ActivityStatsImpl value, $Res Function(_$ActivityStatsImpl) then) =
      __$$ActivityStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalActivities,
      int bookingsCount,
      int reviewsCount,
      int checkInsCount,
      int sharesCount,
      int favoritesCount,
      Map<String, int> activitiesByType,
      Map<String, int> activitiesByMonth,
      DateTime? firstActivityDate,
      DateTime? lastActivityDate,
      int currentStreak,
      int longestStreak});
}

/// @nodoc
class __$$ActivityStatsImplCopyWithImpl<$Res>
    extends _$ActivityStatsCopyWithImpl<$Res, _$ActivityStatsImpl>
    implements _$$ActivityStatsImplCopyWith<$Res> {
  __$$ActivityStatsImplCopyWithImpl(
      _$ActivityStatsImpl _value, $Res Function(_$ActivityStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActivityStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalActivities = null,
    Object? bookingsCount = null,
    Object? reviewsCount = null,
    Object? checkInsCount = null,
    Object? sharesCount = null,
    Object? favoritesCount = null,
    Object? activitiesByType = null,
    Object? activitiesByMonth = null,
    Object? firstActivityDate = freezed,
    Object? lastActivityDate = freezed,
    Object? currentStreak = null,
    Object? longestStreak = null,
  }) {
    return _then(_$ActivityStatsImpl(
      totalActivities: null == totalActivities
          ? _value.totalActivities
          : totalActivities // ignore: cast_nullable_to_non_nullable
              as int,
      bookingsCount: null == bookingsCount
          ? _value.bookingsCount
          : bookingsCount // ignore: cast_nullable_to_non_nullable
              as int,
      reviewsCount: null == reviewsCount
          ? _value.reviewsCount
          : reviewsCount // ignore: cast_nullable_to_non_nullable
              as int,
      checkInsCount: null == checkInsCount
          ? _value.checkInsCount
          : checkInsCount // ignore: cast_nullable_to_non_nullable
              as int,
      sharesCount: null == sharesCount
          ? _value.sharesCount
          : sharesCount // ignore: cast_nullable_to_non_nullable
              as int,
      favoritesCount: null == favoritesCount
          ? _value.favoritesCount
          : favoritesCount // ignore: cast_nullable_to_non_nullable
              as int,
      activitiesByType: null == activitiesByType
          ? _value._activitiesByType
          : activitiesByType // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      activitiesByMonth: null == activitiesByMonth
          ? _value._activitiesByMonth
          : activitiesByMonth // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      firstActivityDate: freezed == firstActivityDate
          ? _value.firstActivityDate
          : firstActivityDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastActivityDate: freezed == lastActivityDate
          ? _value.lastActivityDate
          : lastActivityDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityStatsImpl implements _ActivityStats {
  const _$ActivityStatsImpl(
      {required this.totalActivities,
      required this.bookingsCount,
      required this.reviewsCount,
      required this.checkInsCount,
      required this.sharesCount,
      required this.favoritesCount,
      required final Map<String, int> activitiesByType,
      required final Map<String, int> activitiesByMonth,
      this.firstActivityDate,
      this.lastActivityDate,
      this.currentStreak = 0,
      this.longestStreak = 0})
      : _activitiesByType = activitiesByType,
        _activitiesByMonth = activitiesByMonth;

  factory _$ActivityStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityStatsImplFromJson(json);

  @override
  final int totalActivities;
  @override
  final int bookingsCount;
  @override
  final int reviewsCount;
  @override
  final int checkInsCount;
  @override
  final int sharesCount;
  @override
  final int favoritesCount;
  final Map<String, int> _activitiesByType;
  @override
  Map<String, int> get activitiesByType {
    if (_activitiesByType is EqualUnmodifiableMapView) return _activitiesByType;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_activitiesByType);
  }

  final Map<String, int> _activitiesByMonth;
  @override
  Map<String, int> get activitiesByMonth {
    if (_activitiesByMonth is EqualUnmodifiableMapView)
      return _activitiesByMonth;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_activitiesByMonth);
  }

  @override
  final DateTime? firstActivityDate;
  @override
  final DateTime? lastActivityDate;
  @override
  @JsonKey()
  final int currentStreak;
  @override
  @JsonKey()
  final int longestStreak;

  @override
  String toString() {
    return 'ActivityStats(totalActivities: $totalActivities, bookingsCount: $bookingsCount, reviewsCount: $reviewsCount, checkInsCount: $checkInsCount, sharesCount: $sharesCount, favoritesCount: $favoritesCount, activitiesByType: $activitiesByType, activitiesByMonth: $activitiesByMonth, firstActivityDate: $firstActivityDate, lastActivityDate: $lastActivityDate, currentStreak: $currentStreak, longestStreak: $longestStreak)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityStatsImpl &&
            (identical(other.totalActivities, totalActivities) ||
                other.totalActivities == totalActivities) &&
            (identical(other.bookingsCount, bookingsCount) ||
                other.bookingsCount == bookingsCount) &&
            (identical(other.reviewsCount, reviewsCount) ||
                other.reviewsCount == reviewsCount) &&
            (identical(other.checkInsCount, checkInsCount) ||
                other.checkInsCount == checkInsCount) &&
            (identical(other.sharesCount, sharesCount) ||
                other.sharesCount == sharesCount) &&
            (identical(other.favoritesCount, favoritesCount) ||
                other.favoritesCount == favoritesCount) &&
            const DeepCollectionEquality()
                .equals(other._activitiesByType, _activitiesByType) &&
            const DeepCollectionEquality()
                .equals(other._activitiesByMonth, _activitiesByMonth) &&
            (identical(other.firstActivityDate, firstActivityDate) ||
                other.firstActivityDate == firstActivityDate) &&
            (identical(other.lastActivityDate, lastActivityDate) ||
                other.lastActivityDate == lastActivityDate) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalActivities,
      bookingsCount,
      reviewsCount,
      checkInsCount,
      sharesCount,
      favoritesCount,
      const DeepCollectionEquality().hash(_activitiesByType),
      const DeepCollectionEquality().hash(_activitiesByMonth),
      firstActivityDate,
      lastActivityDate,
      currentStreak,
      longestStreak);

  /// Create a copy of ActivityStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityStatsImplCopyWith<_$ActivityStatsImpl> get copyWith =>
      __$$ActivityStatsImplCopyWithImpl<_$ActivityStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityStatsImplToJson(
      this,
    );
  }
}

abstract class _ActivityStats implements ActivityStats {
  const factory _ActivityStats(
      {required final int totalActivities,
      required final int bookingsCount,
      required final int reviewsCount,
      required final int checkInsCount,
      required final int sharesCount,
      required final int favoritesCount,
      required final Map<String, int> activitiesByType,
      required final Map<String, int> activitiesByMonth,
      final DateTime? firstActivityDate,
      final DateTime? lastActivityDate,
      final int currentStreak,
      final int longestStreak}) = _$ActivityStatsImpl;

  factory _ActivityStats.fromJson(Map<String, dynamic> json) =
      _$ActivityStatsImpl.fromJson;

  @override
  int get totalActivities;
  @override
  int get bookingsCount;
  @override
  int get reviewsCount;
  @override
  int get checkInsCount;
  @override
  int get sharesCount;
  @override
  int get favoritesCount;
  @override
  Map<String, int> get activitiesByType;
  @override
  Map<String, int> get activitiesByMonth;
  @override
  DateTime? get firstActivityDate;
  @override
  DateTime? get lastActivityDate;
  @override
  int get currentStreak;
  @override
  int get longestStreak;

  /// Create a copy of ActivityStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityStatsImplCopyWith<_$ActivityStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SavedItem _$SavedItemFromJson(Map<String, dynamic> json) {
  return _SavedItem.fromJson(json);
}

/// @nodoc
mixin _$SavedItem {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get itemId => throw _privateConstructorUsedError;
  String get itemType => throw _privateConstructorUsedError;
  String get itemName => throw _privateConstructorUsedError;
  String? get itemImage => throw _privateConstructorUsedError;
  Map<String, dynamic>? get itemData => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime get savedAt => throw _privateConstructorUsedError;

  /// Serializes this SavedItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SavedItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SavedItemCopyWith<SavedItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SavedItemCopyWith<$Res> {
  factory $SavedItemCopyWith(SavedItem value, $Res Function(SavedItem) then) =
      _$SavedItemCopyWithImpl<$Res, SavedItem>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String itemId,
      String itemType,
      String itemName,
      String? itemImage,
      Map<String, dynamic>? itemData,
      List<String> tags,
      String? notes,
      DateTime savedAt});
}

/// @nodoc
class _$SavedItemCopyWithImpl<$Res, $Val extends SavedItem>
    implements $SavedItemCopyWith<$Res> {
  _$SavedItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SavedItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? itemId = null,
    Object? itemType = null,
    Object? itemName = null,
    Object? itemImage = freezed,
    Object? itemData = freezed,
    Object? tags = null,
    Object? notes = freezed,
    Object? savedAt = null,
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
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      itemType: null == itemType
          ? _value.itemType
          : itemType // ignore: cast_nullable_to_non_nullable
              as String,
      itemName: null == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String,
      itemImage: freezed == itemImage
          ? _value.itemImage
          : itemImage // ignore: cast_nullable_to_non_nullable
              as String?,
      itemData: freezed == itemData
          ? _value.itemData
          : itemData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      savedAt: null == savedAt
          ? _value.savedAt
          : savedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SavedItemImplCopyWith<$Res>
    implements $SavedItemCopyWith<$Res> {
  factory _$$SavedItemImplCopyWith(
          _$SavedItemImpl value, $Res Function(_$SavedItemImpl) then) =
      __$$SavedItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String itemId,
      String itemType,
      String itemName,
      String? itemImage,
      Map<String, dynamic>? itemData,
      List<String> tags,
      String? notes,
      DateTime savedAt});
}

/// @nodoc
class __$$SavedItemImplCopyWithImpl<$Res>
    extends _$SavedItemCopyWithImpl<$Res, _$SavedItemImpl>
    implements _$$SavedItemImplCopyWith<$Res> {
  __$$SavedItemImplCopyWithImpl(
      _$SavedItemImpl _value, $Res Function(_$SavedItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of SavedItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? itemId = null,
    Object? itemType = null,
    Object? itemName = null,
    Object? itemImage = freezed,
    Object? itemData = freezed,
    Object? tags = null,
    Object? notes = freezed,
    Object? savedAt = null,
  }) {
    return _then(_$SavedItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      itemType: null == itemType
          ? _value.itemType
          : itemType // ignore: cast_nullable_to_non_nullable
              as String,
      itemName: null == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String,
      itemImage: freezed == itemImage
          ? _value.itemImage
          : itemImage // ignore: cast_nullable_to_non_nullable
              as String?,
      itemData: freezed == itemData
          ? _value._itemData
          : itemData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      savedAt: null == savedAt
          ? _value.savedAt
          : savedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SavedItemImpl implements _SavedItem {
  const _$SavedItemImpl(
      {required this.id,
      required this.userId,
      required this.itemId,
      required this.itemType,
      required this.itemName,
      this.itemImage,
      final Map<String, dynamic>? itemData,
      final List<String> tags = const [],
      this.notes,
      required this.savedAt})
      : _itemData = itemData,
        _tags = tags;

  factory _$SavedItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$SavedItemImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String itemId;
  @override
  final String itemType;
  @override
  final String itemName;
  @override
  final String? itemImage;
  final Map<String, dynamic>? _itemData;
  @override
  Map<String, dynamic>? get itemData {
    final value = _itemData;
    if (value == null) return null;
    if (_itemData is EqualUnmodifiableMapView) return _itemData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final String? notes;
  @override
  final DateTime savedAt;

  @override
  String toString() {
    return 'SavedItem(id: $id, userId: $userId, itemId: $itemId, itemType: $itemType, itemName: $itemName, itemImage: $itemImage, itemData: $itemData, tags: $tags, notes: $notes, savedAt: $savedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SavedItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.itemType, itemType) ||
                other.itemType == itemType) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.itemImage, itemImage) ||
                other.itemImage == itemImage) &&
            const DeepCollectionEquality().equals(other._itemData, _itemData) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.savedAt, savedAt) || other.savedAt == savedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      itemId,
      itemType,
      itemName,
      itemImage,
      const DeepCollectionEquality().hash(_itemData),
      const DeepCollectionEquality().hash(_tags),
      notes,
      savedAt);

  /// Create a copy of SavedItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SavedItemImplCopyWith<_$SavedItemImpl> get copyWith =>
      __$$SavedItemImplCopyWithImpl<_$SavedItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SavedItemImplToJson(
      this,
    );
  }
}

abstract class _SavedItem implements SavedItem {
  const factory _SavedItem(
      {required final String id,
      required final String userId,
      required final String itemId,
      required final String itemType,
      required final String itemName,
      final String? itemImage,
      final Map<String, dynamic>? itemData,
      final List<String> tags,
      final String? notes,
      required final DateTime savedAt}) = _$SavedItemImpl;

  factory _SavedItem.fromJson(Map<String, dynamic> json) =
      _$SavedItemImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get itemId;
  @override
  String get itemType;
  @override
  String get itemName;
  @override
  String? get itemImage;
  @override
  Map<String, dynamic>? get itemData;
  @override
  List<String> get tags;
  @override
  String? get notes;
  @override
  DateTime get savedAt;

  /// Create a copy of SavedItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SavedItemImplCopyWith<_$SavedItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserStatistics _$UserStatisticsFromJson(Map<String, dynamic> json) {
  return _UserStatistics.fromJson(json);
}

/// @nodoc
mixin _$UserStatistics {
  String get userId => throw _privateConstructorUsedError;
  int get totalBookings => throw _privateConstructorUsedError;
  int get totalReviews => throw _privateConstructorUsedError;
  int get totalCheckIns => throw _privateConstructorUsedError;
  int get totalPointsEarned => throw _privateConstructorUsedError;
  int get totalRewardsRedeemed => throw _privateConstructorUsedError;
  int get totalReferrals => throw _privateConstructorUsedError;
  int get totalFriends => throw _privateConstructorUsedError;
  double get averageRating => throw _privateConstructorUsedError;
  double get totalSpent => throw _privateConstructorUsedError;
  String? get favoriteVenue => throw _privateConstructorUsedError;
  String? get favoriteCategory => throw _privateConstructorUsedError;
  List<String>? get topVenues => throw _privateConstructorUsedError;
  Map<String, int>? get visitsByCategory => throw _privateConstructorUsedError;
  Map<String, double>? get spendingByMonth =>
      throw _privateConstructorUsedError;
  DateTime get memberSince => throw _privateConstructorUsedError;
  DateTime? get lastActive => throw _privateConstructorUsedError;

  /// Serializes this UserStatistics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserStatisticsCopyWith<UserStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStatisticsCopyWith<$Res> {
  factory $UserStatisticsCopyWith(
          UserStatistics value, $Res Function(UserStatistics) then) =
      _$UserStatisticsCopyWithImpl<$Res, UserStatistics>;
  @useResult
  $Res call(
      {String userId,
      int totalBookings,
      int totalReviews,
      int totalCheckIns,
      int totalPointsEarned,
      int totalRewardsRedeemed,
      int totalReferrals,
      int totalFriends,
      double averageRating,
      double totalSpent,
      String? favoriteVenue,
      String? favoriteCategory,
      List<String>? topVenues,
      Map<String, int>? visitsByCategory,
      Map<String, double>? spendingByMonth,
      DateTime memberSince,
      DateTime? lastActive});
}

/// @nodoc
class _$UserStatisticsCopyWithImpl<$Res, $Val extends UserStatistics>
    implements $UserStatisticsCopyWith<$Res> {
  _$UserStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? totalBookings = null,
    Object? totalReviews = null,
    Object? totalCheckIns = null,
    Object? totalPointsEarned = null,
    Object? totalRewardsRedeemed = null,
    Object? totalReferrals = null,
    Object? totalFriends = null,
    Object? averageRating = null,
    Object? totalSpent = null,
    Object? favoriteVenue = freezed,
    Object? favoriteCategory = freezed,
    Object? topVenues = freezed,
    Object? visitsByCategory = freezed,
    Object? spendingByMonth = freezed,
    Object? memberSince = null,
    Object? lastActive = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      totalBookings: null == totalBookings
          ? _value.totalBookings
          : totalBookings // ignore: cast_nullable_to_non_nullable
              as int,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      totalCheckIns: null == totalCheckIns
          ? _value.totalCheckIns
          : totalCheckIns // ignore: cast_nullable_to_non_nullable
              as int,
      totalPointsEarned: null == totalPointsEarned
          ? _value.totalPointsEarned
          : totalPointsEarned // ignore: cast_nullable_to_non_nullable
              as int,
      totalRewardsRedeemed: null == totalRewardsRedeemed
          ? _value.totalRewardsRedeemed
          : totalRewardsRedeemed // ignore: cast_nullable_to_non_nullable
              as int,
      totalReferrals: null == totalReferrals
          ? _value.totalReferrals
          : totalReferrals // ignore: cast_nullable_to_non_nullable
              as int,
      totalFriends: null == totalFriends
          ? _value.totalFriends
          : totalFriends // ignore: cast_nullable_to_non_nullable
              as int,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      totalSpent: null == totalSpent
          ? _value.totalSpent
          : totalSpent // ignore: cast_nullable_to_non_nullable
              as double,
      favoriteVenue: freezed == favoriteVenue
          ? _value.favoriteVenue
          : favoriteVenue // ignore: cast_nullable_to_non_nullable
              as String?,
      favoriteCategory: freezed == favoriteCategory
          ? _value.favoriteCategory
          : favoriteCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      topVenues: freezed == topVenues
          ? _value.topVenues
          : topVenues // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      visitsByCategory: freezed == visitsByCategory
          ? _value.visitsByCategory
          : visitsByCategory // ignore: cast_nullable_to_non_nullable
              as Map<String, int>?,
      spendingByMonth: freezed == spendingByMonth
          ? _value.spendingByMonth
          : spendingByMonth // ignore: cast_nullable_to_non_nullable
              as Map<String, double>?,
      memberSince: null == memberSince
          ? _value.memberSince
          : memberSince // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastActive: freezed == lastActive
          ? _value.lastActive
          : lastActive // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserStatisticsImplCopyWith<$Res>
    implements $UserStatisticsCopyWith<$Res> {
  factory _$$UserStatisticsImplCopyWith(_$UserStatisticsImpl value,
          $Res Function(_$UserStatisticsImpl) then) =
      __$$UserStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      int totalBookings,
      int totalReviews,
      int totalCheckIns,
      int totalPointsEarned,
      int totalRewardsRedeemed,
      int totalReferrals,
      int totalFriends,
      double averageRating,
      double totalSpent,
      String? favoriteVenue,
      String? favoriteCategory,
      List<String>? topVenues,
      Map<String, int>? visitsByCategory,
      Map<String, double>? spendingByMonth,
      DateTime memberSince,
      DateTime? lastActive});
}

/// @nodoc
class __$$UserStatisticsImplCopyWithImpl<$Res>
    extends _$UserStatisticsCopyWithImpl<$Res, _$UserStatisticsImpl>
    implements _$$UserStatisticsImplCopyWith<$Res> {
  __$$UserStatisticsImplCopyWithImpl(
      _$UserStatisticsImpl _value, $Res Function(_$UserStatisticsImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? totalBookings = null,
    Object? totalReviews = null,
    Object? totalCheckIns = null,
    Object? totalPointsEarned = null,
    Object? totalRewardsRedeemed = null,
    Object? totalReferrals = null,
    Object? totalFriends = null,
    Object? averageRating = null,
    Object? totalSpent = null,
    Object? favoriteVenue = freezed,
    Object? favoriteCategory = freezed,
    Object? topVenues = freezed,
    Object? visitsByCategory = freezed,
    Object? spendingByMonth = freezed,
    Object? memberSince = null,
    Object? lastActive = freezed,
  }) {
    return _then(_$UserStatisticsImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      totalBookings: null == totalBookings
          ? _value.totalBookings
          : totalBookings // ignore: cast_nullable_to_non_nullable
              as int,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      totalCheckIns: null == totalCheckIns
          ? _value.totalCheckIns
          : totalCheckIns // ignore: cast_nullable_to_non_nullable
              as int,
      totalPointsEarned: null == totalPointsEarned
          ? _value.totalPointsEarned
          : totalPointsEarned // ignore: cast_nullable_to_non_nullable
              as int,
      totalRewardsRedeemed: null == totalRewardsRedeemed
          ? _value.totalRewardsRedeemed
          : totalRewardsRedeemed // ignore: cast_nullable_to_non_nullable
              as int,
      totalReferrals: null == totalReferrals
          ? _value.totalReferrals
          : totalReferrals // ignore: cast_nullable_to_non_nullable
              as int,
      totalFriends: null == totalFriends
          ? _value.totalFriends
          : totalFriends // ignore: cast_nullable_to_non_nullable
              as int,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      totalSpent: null == totalSpent
          ? _value.totalSpent
          : totalSpent // ignore: cast_nullable_to_non_nullable
              as double,
      favoriteVenue: freezed == favoriteVenue
          ? _value.favoriteVenue
          : favoriteVenue // ignore: cast_nullable_to_non_nullable
              as String?,
      favoriteCategory: freezed == favoriteCategory
          ? _value.favoriteCategory
          : favoriteCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      topVenues: freezed == topVenues
          ? _value._topVenues
          : topVenues // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      visitsByCategory: freezed == visitsByCategory
          ? _value._visitsByCategory
          : visitsByCategory // ignore: cast_nullable_to_non_nullable
              as Map<String, int>?,
      spendingByMonth: freezed == spendingByMonth
          ? _value._spendingByMonth
          : spendingByMonth // ignore: cast_nullable_to_non_nullable
              as Map<String, double>?,
      memberSince: null == memberSince
          ? _value.memberSince
          : memberSince // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastActive: freezed == lastActive
          ? _value.lastActive
          : lastActive // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserStatisticsImpl implements _UserStatistics {
  const _$UserStatisticsImpl(
      {required this.userId,
      required this.totalBookings,
      required this.totalReviews,
      required this.totalCheckIns,
      required this.totalPointsEarned,
      required this.totalRewardsRedeemed,
      required this.totalReferrals,
      required this.totalFriends,
      this.averageRating = 0.0,
      this.totalSpent = 0.0,
      this.favoriteVenue,
      this.favoriteCategory,
      final List<String>? topVenues,
      final Map<String, int>? visitsByCategory,
      final Map<String, double>? spendingByMonth,
      required this.memberSince,
      this.lastActive})
      : _topVenues = topVenues,
        _visitsByCategory = visitsByCategory,
        _spendingByMonth = spendingByMonth;

  factory _$UserStatisticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserStatisticsImplFromJson(json);

  @override
  final String userId;
  @override
  final int totalBookings;
  @override
  final int totalReviews;
  @override
  final int totalCheckIns;
  @override
  final int totalPointsEarned;
  @override
  final int totalRewardsRedeemed;
  @override
  final int totalReferrals;
  @override
  final int totalFriends;
  @override
  @JsonKey()
  final double averageRating;
  @override
  @JsonKey()
  final double totalSpent;
  @override
  final String? favoriteVenue;
  @override
  final String? favoriteCategory;
  final List<String>? _topVenues;
  @override
  List<String>? get topVenues {
    final value = _topVenues;
    if (value == null) return null;
    if (_topVenues is EqualUnmodifiableListView) return _topVenues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, int>? _visitsByCategory;
  @override
  Map<String, int>? get visitsByCategory {
    final value = _visitsByCategory;
    if (value == null) return null;
    if (_visitsByCategory is EqualUnmodifiableMapView) return _visitsByCategory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, double>? _spendingByMonth;
  @override
  Map<String, double>? get spendingByMonth {
    final value = _spendingByMonth;
    if (value == null) return null;
    if (_spendingByMonth is EqualUnmodifiableMapView) return _spendingByMonth;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime memberSince;
  @override
  final DateTime? lastActive;

  @override
  String toString() {
    return 'UserStatistics(userId: $userId, totalBookings: $totalBookings, totalReviews: $totalReviews, totalCheckIns: $totalCheckIns, totalPointsEarned: $totalPointsEarned, totalRewardsRedeemed: $totalRewardsRedeemed, totalReferrals: $totalReferrals, totalFriends: $totalFriends, averageRating: $averageRating, totalSpent: $totalSpent, favoriteVenue: $favoriteVenue, favoriteCategory: $favoriteCategory, topVenues: $topVenues, visitsByCategory: $visitsByCategory, spendingByMonth: $spendingByMonth, memberSince: $memberSince, lastActive: $lastActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStatisticsImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.totalBookings, totalBookings) ||
                other.totalBookings == totalBookings) &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews) &&
            (identical(other.totalCheckIns, totalCheckIns) ||
                other.totalCheckIns == totalCheckIns) &&
            (identical(other.totalPointsEarned, totalPointsEarned) ||
                other.totalPointsEarned == totalPointsEarned) &&
            (identical(other.totalRewardsRedeemed, totalRewardsRedeemed) ||
                other.totalRewardsRedeemed == totalRewardsRedeemed) &&
            (identical(other.totalReferrals, totalReferrals) ||
                other.totalReferrals == totalReferrals) &&
            (identical(other.totalFriends, totalFriends) ||
                other.totalFriends == totalFriends) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.totalSpent, totalSpent) ||
                other.totalSpent == totalSpent) &&
            (identical(other.favoriteVenue, favoriteVenue) ||
                other.favoriteVenue == favoriteVenue) &&
            (identical(other.favoriteCategory, favoriteCategory) ||
                other.favoriteCategory == favoriteCategory) &&
            const DeepCollectionEquality()
                .equals(other._topVenues, _topVenues) &&
            const DeepCollectionEquality()
                .equals(other._visitsByCategory, _visitsByCategory) &&
            const DeepCollectionEquality()
                .equals(other._spendingByMonth, _spendingByMonth) &&
            (identical(other.memberSince, memberSince) ||
                other.memberSince == memberSince) &&
            (identical(other.lastActive, lastActive) ||
                other.lastActive == lastActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      totalBookings,
      totalReviews,
      totalCheckIns,
      totalPointsEarned,
      totalRewardsRedeemed,
      totalReferrals,
      totalFriends,
      averageRating,
      totalSpent,
      favoriteVenue,
      favoriteCategory,
      const DeepCollectionEquality().hash(_topVenues),
      const DeepCollectionEquality().hash(_visitsByCategory),
      const DeepCollectionEquality().hash(_spendingByMonth),
      memberSince,
      lastActive);

  /// Create a copy of UserStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserStatisticsImplCopyWith<_$UserStatisticsImpl> get copyWith =>
      __$$UserStatisticsImplCopyWithImpl<_$UserStatisticsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserStatisticsImplToJson(
      this,
    );
  }
}

abstract class _UserStatistics implements UserStatistics {
  const factory _UserStatistics(
      {required final String userId,
      required final int totalBookings,
      required final int totalReviews,
      required final int totalCheckIns,
      required final int totalPointsEarned,
      required final int totalRewardsRedeemed,
      required final int totalReferrals,
      required final int totalFriends,
      final double averageRating,
      final double totalSpent,
      final String? favoriteVenue,
      final String? favoriteCategory,
      final List<String>? topVenues,
      final Map<String, int>? visitsByCategory,
      final Map<String, double>? spendingByMonth,
      required final DateTime memberSince,
      final DateTime? lastActive}) = _$UserStatisticsImpl;

  factory _UserStatistics.fromJson(Map<String, dynamic> json) =
      _$UserStatisticsImpl.fromJson;

  @override
  String get userId;
  @override
  int get totalBookings;
  @override
  int get totalReviews;
  @override
  int get totalCheckIns;
  @override
  int get totalPointsEarned;
  @override
  int get totalRewardsRedeemed;
  @override
  int get totalReferrals;
  @override
  int get totalFriends;
  @override
  double get averageRating;
  @override
  double get totalSpent;
  @override
  String? get favoriteVenue;
  @override
  String? get favoriteCategory;
  @override
  List<String>? get topVenues;
  @override
  Map<String, int>? get visitsByCategory;
  @override
  Map<String, double>? get spendingByMonth;
  @override
  DateTime get memberSince;
  @override
  DateTime? get lastActive;

  /// Create a copy of UserStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserStatisticsImplCopyWith<_$UserStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
