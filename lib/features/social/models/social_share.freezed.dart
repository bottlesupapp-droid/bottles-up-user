// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'social_share.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ShareContent _$ShareContentFromJson(Map<String, dynamic> json) {
  return _ShareContent.fromJson(json);
}

/// @nodoc
mixin _$ShareContent {
  String get id => throw _privateConstructorUsedError;
  ShareContentType get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get deepLink => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ShareContent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShareContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShareContentCopyWith<ShareContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShareContentCopyWith<$Res> {
  factory $ShareContentCopyWith(
          ShareContent value, $Res Function(ShareContent) then) =
      _$ShareContentCopyWithImpl<$Res, ShareContent>;
  @useResult
  $Res call(
      {String id,
      ShareContentType type,
      String title,
      String description,
      String? imageUrl,
      String? deepLink,
      Map<String, dynamic>? metadata,
      DateTime createdAt});
}

/// @nodoc
class _$ShareContentCopyWithImpl<$Res, $Val extends ShareContent>
    implements $ShareContentCopyWith<$Res> {
  _$ShareContentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShareContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? imageUrl = freezed,
    Object? deepLink = freezed,
    Object? metadata = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ShareContentType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      deepLink: freezed == deepLink
          ? _value.deepLink
          : deepLink // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ShareContentImplCopyWith<$Res>
    implements $ShareContentCopyWith<$Res> {
  factory _$$ShareContentImplCopyWith(
          _$ShareContentImpl value, $Res Function(_$ShareContentImpl) then) =
      __$$ShareContentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      ShareContentType type,
      String title,
      String description,
      String? imageUrl,
      String? deepLink,
      Map<String, dynamic>? metadata,
      DateTime createdAt});
}

/// @nodoc
class __$$ShareContentImplCopyWithImpl<$Res>
    extends _$ShareContentCopyWithImpl<$Res, _$ShareContentImpl>
    implements _$$ShareContentImplCopyWith<$Res> {
  __$$ShareContentImplCopyWithImpl(
      _$ShareContentImpl _value, $Res Function(_$ShareContentImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShareContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? imageUrl = freezed,
    Object? deepLink = freezed,
    Object? metadata = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$ShareContentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ShareContentType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      deepLink: freezed == deepLink
          ? _value.deepLink
          : deepLink // ignore: cast_nullable_to_non_nullable
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
class _$ShareContentImpl implements _ShareContent {
  const _$ShareContentImpl(
      {required this.id,
      required this.type,
      required this.title,
      required this.description,
      this.imageUrl,
      this.deepLink,
      final Map<String, dynamic>? metadata,
      required this.createdAt})
      : _metadata = metadata;

  factory _$ShareContentImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShareContentImplFromJson(json);

  @override
  final String id;
  @override
  final ShareContentType type;
  @override
  final String title;
  @override
  final String description;
  @override
  final String? imageUrl;
  @override
  final String? deepLink;
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
    return 'ShareContent(id: $id, type: $type, title: $title, description: $description, imageUrl: $imageUrl, deepLink: $deepLink, metadata: $metadata, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShareContentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.deepLink, deepLink) ||
                other.deepLink == deepLink) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      title,
      description,
      imageUrl,
      deepLink,
      const DeepCollectionEquality().hash(_metadata),
      createdAt);

  /// Create a copy of ShareContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShareContentImplCopyWith<_$ShareContentImpl> get copyWith =>
      __$$ShareContentImplCopyWithImpl<_$ShareContentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShareContentImplToJson(
      this,
    );
  }
}

abstract class _ShareContent implements ShareContent {
  const factory _ShareContent(
      {required final String id,
      required final ShareContentType type,
      required final String title,
      required final String description,
      final String? imageUrl,
      final String? deepLink,
      final Map<String, dynamic>? metadata,
      required final DateTime createdAt}) = _$ShareContentImpl;

  factory _ShareContent.fromJson(Map<String, dynamic> json) =
      _$ShareContentImpl.fromJson;

  @override
  String get id;
  @override
  ShareContentType get type;
  @override
  String get title;
  @override
  String get description;
  @override
  String? get imageUrl;
  @override
  String? get deepLink;
  @override
  Map<String, dynamic>? get metadata;
  @override
  DateTime get createdAt;

  /// Create a copy of ShareContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShareContentImplCopyWith<_$ShareContentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ShareAnalytics _$ShareAnalyticsFromJson(Map<String, dynamic> json) {
  return _ShareAnalytics.fromJson(json);
}

/// @nodoc
mixin _$ShareAnalytics {
  String get contentId => throw _privateConstructorUsedError;
  ShareContentType get contentType => throw _privateConstructorUsedError;
  Map<SharePlatform, int> get sharesByPlatform =>
      throw _privateConstructorUsedError;
  int get totalShares => throw _privateConstructorUsedError;
  int get clickThroughs => throw _privateConstructorUsedError;
  int get conversions => throw _privateConstructorUsedError;
  DateTime get firstSharedAt => throw _privateConstructorUsedError;
  DateTime? get lastSharedAt => throw _privateConstructorUsedError;

  /// Serializes this ShareAnalytics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShareAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShareAnalyticsCopyWith<ShareAnalytics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShareAnalyticsCopyWith<$Res> {
  factory $ShareAnalyticsCopyWith(
          ShareAnalytics value, $Res Function(ShareAnalytics) then) =
      _$ShareAnalyticsCopyWithImpl<$Res, ShareAnalytics>;
  @useResult
  $Res call(
      {String contentId,
      ShareContentType contentType,
      Map<SharePlatform, int> sharesByPlatform,
      int totalShares,
      int clickThroughs,
      int conversions,
      DateTime firstSharedAt,
      DateTime? lastSharedAt});
}

/// @nodoc
class _$ShareAnalyticsCopyWithImpl<$Res, $Val extends ShareAnalytics>
    implements $ShareAnalyticsCopyWith<$Res> {
  _$ShareAnalyticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShareAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contentId = null,
    Object? contentType = null,
    Object? sharesByPlatform = null,
    Object? totalShares = null,
    Object? clickThroughs = null,
    Object? conversions = null,
    Object? firstSharedAt = null,
    Object? lastSharedAt = freezed,
  }) {
    return _then(_value.copyWith(
      contentId: null == contentId
          ? _value.contentId
          : contentId // ignore: cast_nullable_to_non_nullable
              as String,
      contentType: null == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as ShareContentType,
      sharesByPlatform: null == sharesByPlatform
          ? _value.sharesByPlatform
          : sharesByPlatform // ignore: cast_nullable_to_non_nullable
              as Map<SharePlatform, int>,
      totalShares: null == totalShares
          ? _value.totalShares
          : totalShares // ignore: cast_nullable_to_non_nullable
              as int,
      clickThroughs: null == clickThroughs
          ? _value.clickThroughs
          : clickThroughs // ignore: cast_nullable_to_non_nullable
              as int,
      conversions: null == conversions
          ? _value.conversions
          : conversions // ignore: cast_nullable_to_non_nullable
              as int,
      firstSharedAt: null == firstSharedAt
          ? _value.firstSharedAt
          : firstSharedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastSharedAt: freezed == lastSharedAt
          ? _value.lastSharedAt
          : lastSharedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShareAnalyticsImplCopyWith<$Res>
    implements $ShareAnalyticsCopyWith<$Res> {
  factory _$$ShareAnalyticsImplCopyWith(_$ShareAnalyticsImpl value,
          $Res Function(_$ShareAnalyticsImpl) then) =
      __$$ShareAnalyticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String contentId,
      ShareContentType contentType,
      Map<SharePlatform, int> sharesByPlatform,
      int totalShares,
      int clickThroughs,
      int conversions,
      DateTime firstSharedAt,
      DateTime? lastSharedAt});
}

/// @nodoc
class __$$ShareAnalyticsImplCopyWithImpl<$Res>
    extends _$ShareAnalyticsCopyWithImpl<$Res, _$ShareAnalyticsImpl>
    implements _$$ShareAnalyticsImplCopyWith<$Res> {
  __$$ShareAnalyticsImplCopyWithImpl(
      _$ShareAnalyticsImpl _value, $Res Function(_$ShareAnalyticsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShareAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contentId = null,
    Object? contentType = null,
    Object? sharesByPlatform = null,
    Object? totalShares = null,
    Object? clickThroughs = null,
    Object? conversions = null,
    Object? firstSharedAt = null,
    Object? lastSharedAt = freezed,
  }) {
    return _then(_$ShareAnalyticsImpl(
      contentId: null == contentId
          ? _value.contentId
          : contentId // ignore: cast_nullable_to_non_nullable
              as String,
      contentType: null == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as ShareContentType,
      sharesByPlatform: null == sharesByPlatform
          ? _value._sharesByPlatform
          : sharesByPlatform // ignore: cast_nullable_to_non_nullable
              as Map<SharePlatform, int>,
      totalShares: null == totalShares
          ? _value.totalShares
          : totalShares // ignore: cast_nullable_to_non_nullable
              as int,
      clickThroughs: null == clickThroughs
          ? _value.clickThroughs
          : clickThroughs // ignore: cast_nullable_to_non_nullable
              as int,
      conversions: null == conversions
          ? _value.conversions
          : conversions // ignore: cast_nullable_to_non_nullable
              as int,
      firstSharedAt: null == firstSharedAt
          ? _value.firstSharedAt
          : firstSharedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastSharedAt: freezed == lastSharedAt
          ? _value.lastSharedAt
          : lastSharedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShareAnalyticsImpl implements _ShareAnalytics {
  const _$ShareAnalyticsImpl(
      {required this.contentId,
      required this.contentType,
      required final Map<SharePlatform, int> sharesByPlatform,
      required this.totalShares,
      required this.clickThroughs,
      required this.conversions,
      required this.firstSharedAt,
      this.lastSharedAt})
      : _sharesByPlatform = sharesByPlatform;

  factory _$ShareAnalyticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShareAnalyticsImplFromJson(json);

  @override
  final String contentId;
  @override
  final ShareContentType contentType;
  final Map<SharePlatform, int> _sharesByPlatform;
  @override
  Map<SharePlatform, int> get sharesByPlatform {
    if (_sharesByPlatform is EqualUnmodifiableMapView) return _sharesByPlatform;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_sharesByPlatform);
  }

  @override
  final int totalShares;
  @override
  final int clickThroughs;
  @override
  final int conversions;
  @override
  final DateTime firstSharedAt;
  @override
  final DateTime? lastSharedAt;

  @override
  String toString() {
    return 'ShareAnalytics(contentId: $contentId, contentType: $contentType, sharesByPlatform: $sharesByPlatform, totalShares: $totalShares, clickThroughs: $clickThroughs, conversions: $conversions, firstSharedAt: $firstSharedAt, lastSharedAt: $lastSharedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShareAnalyticsImpl &&
            (identical(other.contentId, contentId) ||
                other.contentId == contentId) &&
            (identical(other.contentType, contentType) ||
                other.contentType == contentType) &&
            const DeepCollectionEquality()
                .equals(other._sharesByPlatform, _sharesByPlatform) &&
            (identical(other.totalShares, totalShares) ||
                other.totalShares == totalShares) &&
            (identical(other.clickThroughs, clickThroughs) ||
                other.clickThroughs == clickThroughs) &&
            (identical(other.conversions, conversions) ||
                other.conversions == conversions) &&
            (identical(other.firstSharedAt, firstSharedAt) ||
                other.firstSharedAt == firstSharedAt) &&
            (identical(other.lastSharedAt, lastSharedAt) ||
                other.lastSharedAt == lastSharedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      contentId,
      contentType,
      const DeepCollectionEquality().hash(_sharesByPlatform),
      totalShares,
      clickThroughs,
      conversions,
      firstSharedAt,
      lastSharedAt);

  /// Create a copy of ShareAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShareAnalyticsImplCopyWith<_$ShareAnalyticsImpl> get copyWith =>
      __$$ShareAnalyticsImplCopyWithImpl<_$ShareAnalyticsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShareAnalyticsImplToJson(
      this,
    );
  }
}

abstract class _ShareAnalytics implements ShareAnalytics {
  const factory _ShareAnalytics(
      {required final String contentId,
      required final ShareContentType contentType,
      required final Map<SharePlatform, int> sharesByPlatform,
      required final int totalShares,
      required final int clickThroughs,
      required final int conversions,
      required final DateTime firstSharedAt,
      final DateTime? lastSharedAt}) = _$ShareAnalyticsImpl;

  factory _ShareAnalytics.fromJson(Map<String, dynamic> json) =
      _$ShareAnalyticsImpl.fromJson;

  @override
  String get contentId;
  @override
  ShareContentType get contentType;
  @override
  Map<SharePlatform, int> get sharesByPlatform;
  @override
  int get totalShares;
  @override
  int get clickThroughs;
  @override
  int get conversions;
  @override
  DateTime get firstSharedAt;
  @override
  DateTime? get lastSharedAt;

  /// Create a copy of ShareAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShareAnalyticsImplCopyWith<_$ShareAnalyticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SocialPost _$SocialPostFromJson(Map<String, dynamic> json) {
  return _SocialPost.fromJson(json);
}

/// @nodoc
mixin _$SocialPost {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String? get userAvatar => throw _privateConstructorUsedError;
  ShareContent get content => throw _privateConstructorUsedError;
  String? get caption => throw _privateConstructorUsedError;
  List<String> get hashtags => throw _privateConstructorUsedError;
  int get likes => throw _privateConstructorUsedError;
  int get comments => throw _privateConstructorUsedError;
  int get shares => throw _privateConstructorUsedError;
  bool get isLikedByUser => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SocialPost to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SocialPost
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SocialPostCopyWith<SocialPost> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocialPostCopyWith<$Res> {
  factory $SocialPostCopyWith(
          SocialPost value, $Res Function(SocialPost) then) =
      _$SocialPostCopyWithImpl<$Res, SocialPost>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String userName,
      String? userAvatar,
      ShareContent content,
      String? caption,
      List<String> hashtags,
      int likes,
      int comments,
      int shares,
      bool isLikedByUser,
      DateTime createdAt});

  $ShareContentCopyWith<$Res> get content;
}

/// @nodoc
class _$SocialPostCopyWithImpl<$Res, $Val extends SocialPost>
    implements $SocialPostCopyWith<$Res> {
  _$SocialPostCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SocialPost
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userName = null,
    Object? userAvatar = freezed,
    Object? content = null,
    Object? caption = freezed,
    Object? hashtags = null,
    Object? likes = null,
    Object? comments = null,
    Object? shares = null,
    Object? isLikedByUser = null,
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
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userAvatar: freezed == userAvatar
          ? _value.userAvatar
          : userAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as ShareContent,
      caption: freezed == caption
          ? _value.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String?,
      hashtags: null == hashtags
          ? _value.hashtags
          : hashtags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      likes: null == likes
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as int,
      comments: null == comments
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as int,
      shares: null == shares
          ? _value.shares
          : shares // ignore: cast_nullable_to_non_nullable
              as int,
      isLikedByUser: null == isLikedByUser
          ? _value.isLikedByUser
          : isLikedByUser // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of SocialPost
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ShareContentCopyWith<$Res> get content {
    return $ShareContentCopyWith<$Res>(_value.content, (value) {
      return _then(_value.copyWith(content: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SocialPostImplCopyWith<$Res>
    implements $SocialPostCopyWith<$Res> {
  factory _$$SocialPostImplCopyWith(
          _$SocialPostImpl value, $Res Function(_$SocialPostImpl) then) =
      __$$SocialPostImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String userName,
      String? userAvatar,
      ShareContent content,
      String? caption,
      List<String> hashtags,
      int likes,
      int comments,
      int shares,
      bool isLikedByUser,
      DateTime createdAt});

  @override
  $ShareContentCopyWith<$Res> get content;
}

/// @nodoc
class __$$SocialPostImplCopyWithImpl<$Res>
    extends _$SocialPostCopyWithImpl<$Res, _$SocialPostImpl>
    implements _$$SocialPostImplCopyWith<$Res> {
  __$$SocialPostImplCopyWithImpl(
      _$SocialPostImpl _value, $Res Function(_$SocialPostImpl) _then)
      : super(_value, _then);

  /// Create a copy of SocialPost
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userName = null,
    Object? userAvatar = freezed,
    Object? content = null,
    Object? caption = freezed,
    Object? hashtags = null,
    Object? likes = null,
    Object? comments = null,
    Object? shares = null,
    Object? isLikedByUser = null,
    Object? createdAt = null,
  }) {
    return _then(_$SocialPostImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userAvatar: freezed == userAvatar
          ? _value.userAvatar
          : userAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as ShareContent,
      caption: freezed == caption
          ? _value.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String?,
      hashtags: null == hashtags
          ? _value._hashtags
          : hashtags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      likes: null == likes
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as int,
      comments: null == comments
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as int,
      shares: null == shares
          ? _value.shares
          : shares // ignore: cast_nullable_to_non_nullable
              as int,
      isLikedByUser: null == isLikedByUser
          ? _value.isLikedByUser
          : isLikedByUser // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SocialPostImpl implements _SocialPost {
  const _$SocialPostImpl(
      {required this.id,
      required this.userId,
      required this.userName,
      this.userAvatar,
      required this.content,
      this.caption,
      final List<String> hashtags = const [],
      this.likes = 0,
      this.comments = 0,
      this.shares = 0,
      this.isLikedByUser = false,
      required this.createdAt})
      : _hashtags = hashtags;

  factory _$SocialPostImpl.fromJson(Map<String, dynamic> json) =>
      _$$SocialPostImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String userName;
  @override
  final String? userAvatar;
  @override
  final ShareContent content;
  @override
  final String? caption;
  final List<String> _hashtags;
  @override
  @JsonKey()
  List<String> get hashtags {
    if (_hashtags is EqualUnmodifiableListView) return _hashtags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hashtags);
  }

  @override
  @JsonKey()
  final int likes;
  @override
  @JsonKey()
  final int comments;
  @override
  @JsonKey()
  final int shares;
  @override
  @JsonKey()
  final bool isLikedByUser;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'SocialPost(id: $id, userId: $userId, userName: $userName, userAvatar: $userAvatar, content: $content, caption: $caption, hashtags: $hashtags, likes: $likes, comments: $comments, shares: $shares, isLikedByUser: $isLikedByUser, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocialPostImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userAvatar, userAvatar) ||
                other.userAvatar == userAvatar) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            const DeepCollectionEquality().equals(other._hashtags, _hashtags) &&
            (identical(other.likes, likes) || other.likes == likes) &&
            (identical(other.comments, comments) ||
                other.comments == comments) &&
            (identical(other.shares, shares) || other.shares == shares) &&
            (identical(other.isLikedByUser, isLikedByUser) ||
                other.isLikedByUser == isLikedByUser) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      userName,
      userAvatar,
      content,
      caption,
      const DeepCollectionEquality().hash(_hashtags),
      likes,
      comments,
      shares,
      isLikedByUser,
      createdAt);

  /// Create a copy of SocialPost
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SocialPostImplCopyWith<_$SocialPostImpl> get copyWith =>
      __$$SocialPostImplCopyWithImpl<_$SocialPostImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SocialPostImplToJson(
      this,
    );
  }
}

abstract class _SocialPost implements SocialPost {
  const factory _SocialPost(
      {required final String id,
      required final String userId,
      required final String userName,
      final String? userAvatar,
      required final ShareContent content,
      final String? caption,
      final List<String> hashtags,
      final int likes,
      final int comments,
      final int shares,
      final bool isLikedByUser,
      required final DateTime createdAt}) = _$SocialPostImpl;

  factory _SocialPost.fromJson(Map<String, dynamic> json) =
      _$SocialPostImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get userName;
  @override
  String? get userAvatar;
  @override
  ShareContent get content;
  @override
  String? get caption;
  @override
  List<String> get hashtags;
  @override
  int get likes;
  @override
  int get comments;
  @override
  int get shares;
  @override
  bool get isLikedByUser;
  @override
  DateTime get createdAt;

  /// Create a copy of SocialPost
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SocialPostImplCopyWith<_$SocialPostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
