// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_share.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventShare _$EventShareFromJson(Map<String, dynamic> json) {
  return _EventShare.fromJson(json);
}

/// @nodoc
mixin _$EventShare {
  String get id => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  String get shareToken => throw _privateConstructorUsedError;
  String get shareUrl => throw _privateConstructorUsedError;
  String? get sharedBy => throw _privateConstructorUsedError;
  String? get sharedByName => throw _privateConstructorUsedError;
  SharePlatform? get platform => throw _privateConstructorUsedError;
  int get clickCount => throw _privateConstructorUsedError;
  int get signupCount => throw _privateConstructorUsedError;
  String? get referralCode => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get lastClickedAt => throw _privateConstructorUsedError;

  /// Serializes this EventShare to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EventShare
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventShareCopyWith<EventShare> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventShareCopyWith<$Res> {
  factory $EventShareCopyWith(
          EventShare value, $Res Function(EventShare) then) =
      _$EventShareCopyWithImpl<$Res, EventShare>;
  @useResult
  $Res call(
      {String id,
      String eventId,
      String shareToken,
      String shareUrl,
      String? sharedBy,
      String? sharedByName,
      SharePlatform? platform,
      int clickCount,
      int signupCount,
      String? referralCode,
      Map<String, dynamic>? metadata,
      DateTime createdAt,
      DateTime? lastClickedAt});
}

/// @nodoc
class _$EventShareCopyWithImpl<$Res, $Val extends EventShare>
    implements $EventShareCopyWith<$Res> {
  _$EventShareCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventShare
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? shareToken = null,
    Object? shareUrl = null,
    Object? sharedBy = freezed,
    Object? sharedByName = freezed,
    Object? platform = freezed,
    Object? clickCount = null,
    Object? signupCount = null,
    Object? referralCode = freezed,
    Object? metadata = freezed,
    Object? createdAt = null,
    Object? lastClickedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      shareToken: null == shareToken
          ? _value.shareToken
          : shareToken // ignore: cast_nullable_to_non_nullable
              as String,
      shareUrl: null == shareUrl
          ? _value.shareUrl
          : shareUrl // ignore: cast_nullable_to_non_nullable
              as String,
      sharedBy: freezed == sharedBy
          ? _value.sharedBy
          : sharedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      sharedByName: freezed == sharedByName
          ? _value.sharedByName
          : sharedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      platform: freezed == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as SharePlatform?,
      clickCount: null == clickCount
          ? _value.clickCount
          : clickCount // ignore: cast_nullable_to_non_nullable
              as int,
      signupCount: null == signupCount
          ? _value.signupCount
          : signupCount // ignore: cast_nullable_to_non_nullable
              as int,
      referralCode: freezed == referralCode
          ? _value.referralCode
          : referralCode // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastClickedAt: freezed == lastClickedAt
          ? _value.lastClickedAt
          : lastClickedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventShareImplCopyWith<$Res>
    implements $EventShareCopyWith<$Res> {
  factory _$$EventShareImplCopyWith(
          _$EventShareImpl value, $Res Function(_$EventShareImpl) then) =
      __$$EventShareImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String eventId,
      String shareToken,
      String shareUrl,
      String? sharedBy,
      String? sharedByName,
      SharePlatform? platform,
      int clickCount,
      int signupCount,
      String? referralCode,
      Map<String, dynamic>? metadata,
      DateTime createdAt,
      DateTime? lastClickedAt});
}

/// @nodoc
class __$$EventShareImplCopyWithImpl<$Res>
    extends _$EventShareCopyWithImpl<$Res, _$EventShareImpl>
    implements _$$EventShareImplCopyWith<$Res> {
  __$$EventShareImplCopyWithImpl(
      _$EventShareImpl _value, $Res Function(_$EventShareImpl) _then)
      : super(_value, _then);

  /// Create a copy of EventShare
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? shareToken = null,
    Object? shareUrl = null,
    Object? sharedBy = freezed,
    Object? sharedByName = freezed,
    Object? platform = freezed,
    Object? clickCount = null,
    Object? signupCount = null,
    Object? referralCode = freezed,
    Object? metadata = freezed,
    Object? createdAt = null,
    Object? lastClickedAt = freezed,
  }) {
    return _then(_$EventShareImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      shareToken: null == shareToken
          ? _value.shareToken
          : shareToken // ignore: cast_nullable_to_non_nullable
              as String,
      shareUrl: null == shareUrl
          ? _value.shareUrl
          : shareUrl // ignore: cast_nullable_to_non_nullable
              as String,
      sharedBy: freezed == sharedBy
          ? _value.sharedBy
          : sharedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      sharedByName: freezed == sharedByName
          ? _value.sharedByName
          : sharedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      platform: freezed == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as SharePlatform?,
      clickCount: null == clickCount
          ? _value.clickCount
          : clickCount // ignore: cast_nullable_to_non_nullable
              as int,
      signupCount: null == signupCount
          ? _value.signupCount
          : signupCount // ignore: cast_nullable_to_non_nullable
              as int,
      referralCode: freezed == referralCode
          ? _value.referralCode
          : referralCode // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastClickedAt: freezed == lastClickedAt
          ? _value.lastClickedAt
          : lastClickedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventShareImpl implements _EventShare {
  const _$EventShareImpl(
      {required this.id,
      required this.eventId,
      required this.shareToken,
      required this.shareUrl,
      this.sharedBy,
      this.sharedByName,
      this.platform,
      this.clickCount = 0,
      this.signupCount = 0,
      this.referralCode,
      final Map<String, dynamic>? metadata,
      required this.createdAt,
      this.lastClickedAt})
      : _metadata = metadata;

  factory _$EventShareImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventShareImplFromJson(json);

  @override
  final String id;
  @override
  final String eventId;
  @override
  final String shareToken;
  @override
  final String shareUrl;
  @override
  final String? sharedBy;
  @override
  final String? sharedByName;
  @override
  final SharePlatform? platform;
  @override
  @JsonKey()
  final int clickCount;
  @override
  @JsonKey()
  final int signupCount;
  @override
  final String? referralCode;
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
  final DateTime? lastClickedAt;

  @override
  String toString() {
    return 'EventShare(id: $id, eventId: $eventId, shareToken: $shareToken, shareUrl: $shareUrl, sharedBy: $sharedBy, sharedByName: $sharedByName, platform: $platform, clickCount: $clickCount, signupCount: $signupCount, referralCode: $referralCode, metadata: $metadata, createdAt: $createdAt, lastClickedAt: $lastClickedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventShareImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.shareToken, shareToken) ||
                other.shareToken == shareToken) &&
            (identical(other.shareUrl, shareUrl) ||
                other.shareUrl == shareUrl) &&
            (identical(other.sharedBy, sharedBy) ||
                other.sharedBy == sharedBy) &&
            (identical(other.sharedByName, sharedByName) ||
                other.sharedByName == sharedByName) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.clickCount, clickCount) ||
                other.clickCount == clickCount) &&
            (identical(other.signupCount, signupCount) ||
                other.signupCount == signupCount) &&
            (identical(other.referralCode, referralCode) ||
                other.referralCode == referralCode) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastClickedAt, lastClickedAt) ||
                other.lastClickedAt == lastClickedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      eventId,
      shareToken,
      shareUrl,
      sharedBy,
      sharedByName,
      platform,
      clickCount,
      signupCount,
      referralCode,
      const DeepCollectionEquality().hash(_metadata),
      createdAt,
      lastClickedAt);

  /// Create a copy of EventShare
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventShareImplCopyWith<_$EventShareImpl> get copyWith =>
      __$$EventShareImplCopyWithImpl<_$EventShareImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventShareImplToJson(
      this,
    );
  }
}

abstract class _EventShare implements EventShare {
  const factory _EventShare(
      {required final String id,
      required final String eventId,
      required final String shareToken,
      required final String shareUrl,
      final String? sharedBy,
      final String? sharedByName,
      final SharePlatform? platform,
      final int clickCount,
      final int signupCount,
      final String? referralCode,
      final Map<String, dynamic>? metadata,
      required final DateTime createdAt,
      final DateTime? lastClickedAt}) = _$EventShareImpl;

  factory _EventShare.fromJson(Map<String, dynamic> json) =
      _$EventShareImpl.fromJson;

  @override
  String get id;
  @override
  String get eventId;
  @override
  String get shareToken;
  @override
  String get shareUrl;
  @override
  String? get sharedBy;
  @override
  String? get sharedByName;
  @override
  SharePlatform? get platform;
  @override
  int get clickCount;
  @override
  int get signupCount;
  @override
  String? get referralCode;
  @override
  Map<String, dynamic>? get metadata;
  @override
  DateTime get createdAt;
  @override
  DateTime? get lastClickedAt;

  /// Create a copy of EventShare
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventShareImplCopyWith<_$EventShareImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ShareAnalytics _$ShareAnalyticsFromJson(Map<String, dynamic> json) {
  return _ShareAnalytics.fromJson(json);
}

/// @nodoc
mixin _$ShareAnalytics {
  String get eventId => throw _privateConstructorUsedError;
  int get totalShares => throw _privateConstructorUsedError;
  int get totalClicks => throw _privateConstructorUsedError;
  int get totalSignups => throw _privateConstructorUsedError;
  Map<SharePlatform, int> get sharesByPlatform =>
      throw _privateConstructorUsedError;
  Map<SharePlatform, int> get clicksByPlatform =>
      throw _privateConstructorUsedError;
  List<TopSharer> get topSharers => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;

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
      {String eventId,
      int totalShares,
      int totalClicks,
      int totalSignups,
      Map<SharePlatform, int> sharesByPlatform,
      Map<SharePlatform, int> clicksByPlatform,
      List<TopSharer> topSharers,
      DateTime lastUpdated});
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
    Object? eventId = null,
    Object? totalShares = null,
    Object? totalClicks = null,
    Object? totalSignups = null,
    Object? sharesByPlatform = null,
    Object? clicksByPlatform = null,
    Object? topSharers = null,
    Object? lastUpdated = null,
  }) {
    return _then(_value.copyWith(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      totalShares: null == totalShares
          ? _value.totalShares
          : totalShares // ignore: cast_nullable_to_non_nullable
              as int,
      totalClicks: null == totalClicks
          ? _value.totalClicks
          : totalClicks // ignore: cast_nullable_to_non_nullable
              as int,
      totalSignups: null == totalSignups
          ? _value.totalSignups
          : totalSignups // ignore: cast_nullable_to_non_nullable
              as int,
      sharesByPlatform: null == sharesByPlatform
          ? _value.sharesByPlatform
          : sharesByPlatform // ignore: cast_nullable_to_non_nullable
              as Map<SharePlatform, int>,
      clicksByPlatform: null == clicksByPlatform
          ? _value.clicksByPlatform
          : clicksByPlatform // ignore: cast_nullable_to_non_nullable
              as Map<SharePlatform, int>,
      topSharers: null == topSharers
          ? _value.topSharers
          : topSharers // ignore: cast_nullable_to_non_nullable
              as List<TopSharer>,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
      {String eventId,
      int totalShares,
      int totalClicks,
      int totalSignups,
      Map<SharePlatform, int> sharesByPlatform,
      Map<SharePlatform, int> clicksByPlatform,
      List<TopSharer> topSharers,
      DateTime lastUpdated});
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
    Object? eventId = null,
    Object? totalShares = null,
    Object? totalClicks = null,
    Object? totalSignups = null,
    Object? sharesByPlatform = null,
    Object? clicksByPlatform = null,
    Object? topSharers = null,
    Object? lastUpdated = null,
  }) {
    return _then(_$ShareAnalyticsImpl(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      totalShares: null == totalShares
          ? _value.totalShares
          : totalShares // ignore: cast_nullable_to_non_nullable
              as int,
      totalClicks: null == totalClicks
          ? _value.totalClicks
          : totalClicks // ignore: cast_nullable_to_non_nullable
              as int,
      totalSignups: null == totalSignups
          ? _value.totalSignups
          : totalSignups // ignore: cast_nullable_to_non_nullable
              as int,
      sharesByPlatform: null == sharesByPlatform
          ? _value._sharesByPlatform
          : sharesByPlatform // ignore: cast_nullable_to_non_nullable
              as Map<SharePlatform, int>,
      clicksByPlatform: null == clicksByPlatform
          ? _value._clicksByPlatform
          : clicksByPlatform // ignore: cast_nullable_to_non_nullable
              as Map<SharePlatform, int>,
      topSharers: null == topSharers
          ? _value._topSharers
          : topSharers // ignore: cast_nullable_to_non_nullable
              as List<TopSharer>,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShareAnalyticsImpl implements _ShareAnalytics {
  const _$ShareAnalyticsImpl(
      {required this.eventId,
      required this.totalShares,
      required this.totalClicks,
      required this.totalSignups,
      required final Map<SharePlatform, int> sharesByPlatform,
      required final Map<SharePlatform, int> clicksByPlatform,
      required final List<TopSharer> topSharers,
      required this.lastUpdated})
      : _sharesByPlatform = sharesByPlatform,
        _clicksByPlatform = clicksByPlatform,
        _topSharers = topSharers;

  factory _$ShareAnalyticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShareAnalyticsImplFromJson(json);

  @override
  final String eventId;
  @override
  final int totalShares;
  @override
  final int totalClicks;
  @override
  final int totalSignups;
  final Map<SharePlatform, int> _sharesByPlatform;
  @override
  Map<SharePlatform, int> get sharesByPlatform {
    if (_sharesByPlatform is EqualUnmodifiableMapView) return _sharesByPlatform;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_sharesByPlatform);
  }

  final Map<SharePlatform, int> _clicksByPlatform;
  @override
  Map<SharePlatform, int> get clicksByPlatform {
    if (_clicksByPlatform is EqualUnmodifiableMapView) return _clicksByPlatform;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_clicksByPlatform);
  }

  final List<TopSharer> _topSharers;
  @override
  List<TopSharer> get topSharers {
    if (_topSharers is EqualUnmodifiableListView) return _topSharers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topSharers);
  }

  @override
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'ShareAnalytics(eventId: $eventId, totalShares: $totalShares, totalClicks: $totalClicks, totalSignups: $totalSignups, sharesByPlatform: $sharesByPlatform, clicksByPlatform: $clicksByPlatform, topSharers: $topSharers, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShareAnalyticsImpl &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.totalShares, totalShares) ||
                other.totalShares == totalShares) &&
            (identical(other.totalClicks, totalClicks) ||
                other.totalClicks == totalClicks) &&
            (identical(other.totalSignups, totalSignups) ||
                other.totalSignups == totalSignups) &&
            const DeepCollectionEquality()
                .equals(other._sharesByPlatform, _sharesByPlatform) &&
            const DeepCollectionEquality()
                .equals(other._clicksByPlatform, _clicksByPlatform) &&
            const DeepCollectionEquality()
                .equals(other._topSharers, _topSharers) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      eventId,
      totalShares,
      totalClicks,
      totalSignups,
      const DeepCollectionEquality().hash(_sharesByPlatform),
      const DeepCollectionEquality().hash(_clicksByPlatform),
      const DeepCollectionEquality().hash(_topSharers),
      lastUpdated);

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
      {required final String eventId,
      required final int totalShares,
      required final int totalClicks,
      required final int totalSignups,
      required final Map<SharePlatform, int> sharesByPlatform,
      required final Map<SharePlatform, int> clicksByPlatform,
      required final List<TopSharer> topSharers,
      required final DateTime lastUpdated}) = _$ShareAnalyticsImpl;

  factory _ShareAnalytics.fromJson(Map<String, dynamic> json) =
      _$ShareAnalyticsImpl.fromJson;

  @override
  String get eventId;
  @override
  int get totalShares;
  @override
  int get totalClicks;
  @override
  int get totalSignups;
  @override
  Map<SharePlatform, int> get sharesByPlatform;
  @override
  Map<SharePlatform, int> get clicksByPlatform;
  @override
  List<TopSharer> get topSharers;
  @override
  DateTime get lastUpdated;

  /// Create a copy of ShareAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShareAnalyticsImplCopyWith<_$ShareAnalyticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TopSharer _$TopSharerFromJson(Map<String, dynamic> json) {
  return _TopSharer.fromJson(json);
}

/// @nodoc
mixin _$TopSharer {
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String? get userAvatar => throw _privateConstructorUsedError;
  int get shareCount => throw _privateConstructorUsedError;
  int get clickCount => throw _privateConstructorUsedError;
  int get signupCount => throw _privateConstructorUsedError;

  /// Serializes this TopSharer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TopSharer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TopSharerCopyWith<TopSharer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopSharerCopyWith<$Res> {
  factory $TopSharerCopyWith(TopSharer value, $Res Function(TopSharer) then) =
      _$TopSharerCopyWithImpl<$Res, TopSharer>;
  @useResult
  $Res call(
      {String userId,
      String userName,
      String? userAvatar,
      int shareCount,
      int clickCount,
      int signupCount});
}

/// @nodoc
class _$TopSharerCopyWithImpl<$Res, $Val extends TopSharer>
    implements $TopSharerCopyWith<$Res> {
  _$TopSharerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TopSharer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userName = null,
    Object? userAvatar = freezed,
    Object? shareCount = null,
    Object? clickCount = null,
    Object? signupCount = null,
  }) {
    return _then(_value.copyWith(
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
      shareCount: null == shareCount
          ? _value.shareCount
          : shareCount // ignore: cast_nullable_to_non_nullable
              as int,
      clickCount: null == clickCount
          ? _value.clickCount
          : clickCount // ignore: cast_nullable_to_non_nullable
              as int,
      signupCount: null == signupCount
          ? _value.signupCount
          : signupCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TopSharerImplCopyWith<$Res>
    implements $TopSharerCopyWith<$Res> {
  factory _$$TopSharerImplCopyWith(
          _$TopSharerImpl value, $Res Function(_$TopSharerImpl) then) =
      __$$TopSharerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String userName,
      String? userAvatar,
      int shareCount,
      int clickCount,
      int signupCount});
}

/// @nodoc
class __$$TopSharerImplCopyWithImpl<$Res>
    extends _$TopSharerCopyWithImpl<$Res, _$TopSharerImpl>
    implements _$$TopSharerImplCopyWith<$Res> {
  __$$TopSharerImplCopyWithImpl(
      _$TopSharerImpl _value, $Res Function(_$TopSharerImpl) _then)
      : super(_value, _then);

  /// Create a copy of TopSharer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userName = null,
    Object? userAvatar = freezed,
    Object? shareCount = null,
    Object? clickCount = null,
    Object? signupCount = null,
  }) {
    return _then(_$TopSharerImpl(
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
      shareCount: null == shareCount
          ? _value.shareCount
          : shareCount // ignore: cast_nullable_to_non_nullable
              as int,
      clickCount: null == clickCount
          ? _value.clickCount
          : clickCount // ignore: cast_nullable_to_non_nullable
              as int,
      signupCount: null == signupCount
          ? _value.signupCount
          : signupCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TopSharerImpl implements _TopSharer {
  const _$TopSharerImpl(
      {required this.userId,
      required this.userName,
      this.userAvatar,
      required this.shareCount,
      required this.clickCount,
      required this.signupCount});

  factory _$TopSharerImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopSharerImplFromJson(json);

  @override
  final String userId;
  @override
  final String userName;
  @override
  final String? userAvatar;
  @override
  final int shareCount;
  @override
  final int clickCount;
  @override
  final int signupCount;

  @override
  String toString() {
    return 'TopSharer(userId: $userId, userName: $userName, userAvatar: $userAvatar, shareCount: $shareCount, clickCount: $clickCount, signupCount: $signupCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopSharerImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userAvatar, userAvatar) ||
                other.userAvatar == userAvatar) &&
            (identical(other.shareCount, shareCount) ||
                other.shareCount == shareCount) &&
            (identical(other.clickCount, clickCount) ||
                other.clickCount == clickCount) &&
            (identical(other.signupCount, signupCount) ||
                other.signupCount == signupCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, userName, userAvatar,
      shareCount, clickCount, signupCount);

  /// Create a copy of TopSharer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TopSharerImplCopyWith<_$TopSharerImpl> get copyWith =>
      __$$TopSharerImplCopyWithImpl<_$TopSharerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TopSharerImplToJson(
      this,
    );
  }
}

abstract class _TopSharer implements TopSharer {
  const factory _TopSharer(
      {required final String userId,
      required final String userName,
      final String? userAvatar,
      required final int shareCount,
      required final int clickCount,
      required final int signupCount}) = _$TopSharerImpl;

  factory _TopSharer.fromJson(Map<String, dynamic> json) =
      _$TopSharerImpl.fromJson;

  @override
  String get userId;
  @override
  String get userName;
  @override
  String? get userAvatar;
  @override
  int get shareCount;
  @override
  int get clickCount;
  @override
  int get signupCount;

  /// Create a copy of TopSharer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TopSharerImplCopyWith<_$TopSharerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ShareContent _$ShareContentFromJson(Map<String, dynamic> json) {
  return _ShareContent.fromJson(json);
}

/// @nodoc
mixin _$ShareContent {
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  List<String>? get hashtags => throw _privateConstructorUsedError;
  String? get via => throw _privateConstructorUsedError;

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
      {String title,
      String description,
      String url,
      String? imageUrl,
      List<String>? hashtags,
      String? via});
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
    Object? title = null,
    Object? description = null,
    Object? url = null,
    Object? imageUrl = freezed,
    Object? hashtags = freezed,
    Object? via = freezed,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      hashtags: freezed == hashtags
          ? _value.hashtags
          : hashtags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      via: freezed == via
          ? _value.via
          : via // ignore: cast_nullable_to_non_nullable
              as String?,
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
      {String title,
      String description,
      String url,
      String? imageUrl,
      List<String>? hashtags,
      String? via});
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
    Object? title = null,
    Object? description = null,
    Object? url = null,
    Object? imageUrl = freezed,
    Object? hashtags = freezed,
    Object? via = freezed,
  }) {
    return _then(_$ShareContentImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      hashtags: freezed == hashtags
          ? _value._hashtags
          : hashtags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      via: freezed == via
          ? _value.via
          : via // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShareContentImpl implements _ShareContent {
  const _$ShareContentImpl(
      {required this.title,
      required this.description,
      required this.url,
      this.imageUrl,
      final List<String>? hashtags,
      this.via})
      : _hashtags = hashtags;

  factory _$ShareContentImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShareContentImplFromJson(json);

  @override
  final String title;
  @override
  final String description;
  @override
  final String url;
  @override
  final String? imageUrl;
  final List<String>? _hashtags;
  @override
  List<String>? get hashtags {
    final value = _hashtags;
    if (value == null) return null;
    if (_hashtags is EqualUnmodifiableListView) return _hashtags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? via;

  @override
  String toString() {
    return 'ShareContent(title: $title, description: $description, url: $url, imageUrl: $imageUrl, hashtags: $hashtags, via: $via)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShareContentImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality().equals(other._hashtags, _hashtags) &&
            (identical(other.via, via) || other.via == via));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, description, url,
      imageUrl, const DeepCollectionEquality().hash(_hashtags), via);

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
      {required final String title,
      required final String description,
      required final String url,
      final String? imageUrl,
      final List<String>? hashtags,
      final String? via}) = _$ShareContentImpl;

  factory _ShareContent.fromJson(Map<String, dynamic> json) =
      _$ShareContentImpl.fromJson;

  @override
  String get title;
  @override
  String get description;
  @override
  String get url;
  @override
  String? get imageUrl;
  @override
  List<String>? get hashtags;
  @override
  String? get via;

  /// Create a copy of ShareContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShareContentImplCopyWith<_$ShareContentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
