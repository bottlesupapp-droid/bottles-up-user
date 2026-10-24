// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'advanced_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AnalyticsEvent _$AnalyticsEventFromJson(Map<String, dynamic> json) {
  return _AnalyticsEvent.fromJson(json);
}

/// @nodoc
mixin _$AnalyticsEvent {
  String get eventName => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  Map<String, dynamic>? get parameters => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;
  String? get sessionId => throw _privateConstructorUsedError;

  /// Serializes this AnalyticsEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalyticsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyticsEventCopyWith<AnalyticsEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsEventCopyWith<$Res> {
  factory $AnalyticsEventCopyWith(
          AnalyticsEvent value, $Res Function(AnalyticsEvent) then) =
      _$AnalyticsEventCopyWithImpl<$Res, AnalyticsEvent>;
  @useResult
  $Res call(
      {String eventName,
      DateTime timestamp,
      Map<String, dynamic>? parameters,
      String? userId,
      String? sessionId});
}

/// @nodoc
class _$AnalyticsEventCopyWithImpl<$Res, $Val extends AnalyticsEvent>
    implements $AnalyticsEventCopyWith<$Res> {
  _$AnalyticsEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalyticsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventName = null,
    Object? timestamp = null,
    Object? parameters = freezed,
    Object? userId = freezed,
    Object? sessionId = freezed,
  }) {
    return _then(_value.copyWith(
      eventName: null == eventName
          ? _value.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      parameters: freezed == parameters
          ? _value.parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AnalyticsEventImplCopyWith<$Res>
    implements $AnalyticsEventCopyWith<$Res> {
  factory _$$AnalyticsEventImplCopyWith(_$AnalyticsEventImpl value,
          $Res Function(_$AnalyticsEventImpl) then) =
      __$$AnalyticsEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String eventName,
      DateTime timestamp,
      Map<String, dynamic>? parameters,
      String? userId,
      String? sessionId});
}

/// @nodoc
class __$$AnalyticsEventImplCopyWithImpl<$Res>
    extends _$AnalyticsEventCopyWithImpl<$Res, _$AnalyticsEventImpl>
    implements _$$AnalyticsEventImplCopyWith<$Res> {
  __$$AnalyticsEventImplCopyWithImpl(
      _$AnalyticsEventImpl _value, $Res Function(_$AnalyticsEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnalyticsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventName = null,
    Object? timestamp = null,
    Object? parameters = freezed,
    Object? userId = freezed,
    Object? sessionId = freezed,
  }) {
    return _then(_$AnalyticsEventImpl(
      eventName: null == eventName
          ? _value.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      parameters: freezed == parameters
          ? _value._parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalyticsEventImpl implements _AnalyticsEvent {
  const _$AnalyticsEventImpl(
      {required this.eventName,
      required this.timestamp,
      final Map<String, dynamic>? parameters,
      this.userId,
      this.sessionId})
      : _parameters = parameters;

  factory _$AnalyticsEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalyticsEventImplFromJson(json);

  @override
  final String eventName;
  @override
  final DateTime timestamp;
  final Map<String, dynamic>? _parameters;
  @override
  Map<String, dynamic>? get parameters {
    final value = _parameters;
    if (value == null) return null;
    if (_parameters is EqualUnmodifiableMapView) return _parameters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? userId;
  @override
  final String? sessionId;

  @override
  String toString() {
    return 'AnalyticsEvent(eventName: $eventName, timestamp: $timestamp, parameters: $parameters, userId: $userId, sessionId: $sessionId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsEventImpl &&
            (identical(other.eventName, eventName) ||
                other.eventName == eventName) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality()
                .equals(other._parameters, _parameters) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, eventName, timestamp,
      const DeepCollectionEquality().hash(_parameters), userId, sessionId);

  /// Create a copy of AnalyticsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsEventImplCopyWith<_$AnalyticsEventImpl> get copyWith =>
      __$$AnalyticsEventImplCopyWithImpl<_$AnalyticsEventImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalyticsEventImplToJson(
      this,
    );
  }
}

abstract class _AnalyticsEvent implements AnalyticsEvent {
  const factory _AnalyticsEvent(
      {required final String eventName,
      required final DateTime timestamp,
      final Map<String, dynamic>? parameters,
      final String? userId,
      final String? sessionId}) = _$AnalyticsEventImpl;

  factory _AnalyticsEvent.fromJson(Map<String, dynamic> json) =
      _$AnalyticsEventImpl.fromJson;

  @override
  String get eventName;
  @override
  DateTime get timestamp;
  @override
  Map<String, dynamic>? get parameters;
  @override
  String? get userId;
  @override
  String? get sessionId;

  /// Create a copy of AnalyticsEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsEventImplCopyWith<_$AnalyticsEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Feedback _$FeedbackFromJson(Map<String, dynamic> json) {
  return _Feedback.fromJson(json);
}

/// @nodoc
mixin _$Feedback {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  FeedbackType get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  FeedbackStatus get status => throw _privateConstructorUsedError;
  List<String> get attachments => throw _privateConstructorUsedError;
  String? get contactEmail => throw _privateConstructorUsedError;
  Map<String, dynamic>? get deviceInfo => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get resolvedAt => throw _privateConstructorUsedError;
  String? get adminResponse => throw _privateConstructorUsedError;

  /// Serializes this Feedback to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Feedback
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedbackCopyWith<Feedback> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedbackCopyWith<$Res> {
  factory $FeedbackCopyWith(Feedback value, $Res Function(Feedback) then) =
      _$FeedbackCopyWithImpl<$Res, Feedback>;
  @useResult
  $Res call(
      {String id,
      String userId,
      FeedbackType type,
      String title,
      String description,
      FeedbackStatus status,
      List<String> attachments,
      String? contactEmail,
      Map<String, dynamic>? deviceInfo,
      DateTime createdAt,
      DateTime? resolvedAt,
      String? adminResponse});
}

/// @nodoc
class _$FeedbackCopyWithImpl<$Res, $Val extends Feedback>
    implements $FeedbackCopyWith<$Res> {
  _$FeedbackCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Feedback
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? status = null,
    Object? attachments = null,
    Object? contactEmail = freezed,
    Object? deviceInfo = freezed,
    Object? createdAt = null,
    Object? resolvedAt = freezed,
    Object? adminResponse = freezed,
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
              as FeedbackType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FeedbackStatus,
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>,
      contactEmail: freezed == contactEmail
          ? _value.contactEmail
          : contactEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceInfo: freezed == deviceInfo
          ? _value.deviceInfo
          : deviceInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      resolvedAt: freezed == resolvedAt
          ? _value.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      adminResponse: freezed == adminResponse
          ? _value.adminResponse
          : adminResponse // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FeedbackImplCopyWith<$Res>
    implements $FeedbackCopyWith<$Res> {
  factory _$$FeedbackImplCopyWith(
          _$FeedbackImpl value, $Res Function(_$FeedbackImpl) then) =
      __$$FeedbackImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      FeedbackType type,
      String title,
      String description,
      FeedbackStatus status,
      List<String> attachments,
      String? contactEmail,
      Map<String, dynamic>? deviceInfo,
      DateTime createdAt,
      DateTime? resolvedAt,
      String? adminResponse});
}

/// @nodoc
class __$$FeedbackImplCopyWithImpl<$Res>
    extends _$FeedbackCopyWithImpl<$Res, _$FeedbackImpl>
    implements _$$FeedbackImplCopyWith<$Res> {
  __$$FeedbackImplCopyWithImpl(
      _$FeedbackImpl _value, $Res Function(_$FeedbackImpl) _then)
      : super(_value, _then);

  /// Create a copy of Feedback
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? status = null,
    Object? attachments = null,
    Object? contactEmail = freezed,
    Object? deviceInfo = freezed,
    Object? createdAt = null,
    Object? resolvedAt = freezed,
    Object? adminResponse = freezed,
  }) {
    return _then(_$FeedbackImpl(
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
              as FeedbackType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FeedbackStatus,
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>,
      contactEmail: freezed == contactEmail
          ? _value.contactEmail
          : contactEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceInfo: freezed == deviceInfo
          ? _value._deviceInfo
          : deviceInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      resolvedAt: freezed == resolvedAt
          ? _value.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      adminResponse: freezed == adminResponse
          ? _value.adminResponse
          : adminResponse // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FeedbackImpl implements _Feedback {
  const _$FeedbackImpl(
      {required this.id,
      required this.userId,
      required this.type,
      required this.title,
      required this.description,
      this.status = FeedbackStatus.submitted,
      final List<String> attachments = const [],
      this.contactEmail,
      final Map<String, dynamic>? deviceInfo,
      required this.createdAt,
      this.resolvedAt,
      this.adminResponse})
      : _attachments = attachments,
        _deviceInfo = deviceInfo;

  factory _$FeedbackImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedbackImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final FeedbackType type;
  @override
  final String title;
  @override
  final String description;
  @override
  @JsonKey()
  final FeedbackStatus status;
  final List<String> _attachments;
  @override
  @JsonKey()
  List<String> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  @override
  final String? contactEmail;
  final Map<String, dynamic>? _deviceInfo;
  @override
  Map<String, dynamic>? get deviceInfo {
    final value = _deviceInfo;
    if (value == null) return null;
    if (_deviceInfo is EqualUnmodifiableMapView) return _deviceInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime? resolvedAt;
  @override
  final String? adminResponse;

  @override
  String toString() {
    return 'Feedback(id: $id, userId: $userId, type: $type, title: $title, description: $description, status: $status, attachments: $attachments, contactEmail: $contactEmail, deviceInfo: $deviceInfo, createdAt: $createdAt, resolvedAt: $resolvedAt, adminResponse: $adminResponse)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedbackImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            (identical(other.contactEmail, contactEmail) ||
                other.contactEmail == contactEmail) &&
            const DeepCollectionEquality()
                .equals(other._deviceInfo, _deviceInfo) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt) &&
            (identical(other.adminResponse, adminResponse) ||
                other.adminResponse == adminResponse));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      type,
      title,
      description,
      status,
      const DeepCollectionEquality().hash(_attachments),
      contactEmail,
      const DeepCollectionEquality().hash(_deviceInfo),
      createdAt,
      resolvedAt,
      adminResponse);

  /// Create a copy of Feedback
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedbackImplCopyWith<_$FeedbackImpl> get copyWith =>
      __$$FeedbackImplCopyWithImpl<_$FeedbackImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedbackImplToJson(
      this,
    );
  }
}

abstract class _Feedback implements Feedback {
  const factory _Feedback(
      {required final String id,
      required final String userId,
      required final FeedbackType type,
      required final String title,
      required final String description,
      final FeedbackStatus status,
      final List<String> attachments,
      final String? contactEmail,
      final Map<String, dynamic>? deviceInfo,
      required final DateTime createdAt,
      final DateTime? resolvedAt,
      final String? adminResponse}) = _$FeedbackImpl;

  factory _Feedback.fromJson(Map<String, dynamic> json) =
      _$FeedbackImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  FeedbackType get type;
  @override
  String get title;
  @override
  String get description;
  @override
  FeedbackStatus get status;
  @override
  List<String> get attachments;
  @override
  String? get contactEmail;
  @override
  Map<String, dynamic>? get deviceInfo;
  @override
  DateTime get createdAt;
  @override
  DateTime? get resolvedAt;
  @override
  String? get adminResponse;

  /// Create a copy of Feedback
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedbackImplCopyWith<_$FeedbackImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Referral _$ReferralFromJson(Map<String, dynamic> json) {
  return _Referral.fromJson(json);
}

/// @nodoc
mixin _$Referral {
  String get id => throw _privateConstructorUsedError;
  String get referrerId => throw _privateConstructorUsedError;
  String get referralCode => throw _privateConstructorUsedError;
  String? get referredUserId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  int get pointsEarned => throw _privateConstructorUsedError;
  String? get campaignId => throw _privateConstructorUsedError;

  /// Serializes this Referral to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Referral
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReferralCopyWith<Referral> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReferralCopyWith<$Res> {
  factory $ReferralCopyWith(Referral value, $Res Function(Referral) then) =
      _$ReferralCopyWithImpl<$Res, Referral>;
  @useResult
  $Res call(
      {String id,
      String referrerId,
      String referralCode,
      String? referredUserId,
      DateTime createdAt,
      DateTime? completedAt,
      bool isCompleted,
      int pointsEarned,
      String? campaignId});
}

/// @nodoc
class _$ReferralCopyWithImpl<$Res, $Val extends Referral>
    implements $ReferralCopyWith<$Res> {
  _$ReferralCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Referral
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? referrerId = null,
    Object? referralCode = null,
    Object? referredUserId = freezed,
    Object? createdAt = null,
    Object? completedAt = freezed,
    Object? isCompleted = null,
    Object? pointsEarned = null,
    Object? campaignId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      referrerId: null == referrerId
          ? _value.referrerId
          : referrerId // ignore: cast_nullable_to_non_nullable
              as String,
      referralCode: null == referralCode
          ? _value.referralCode
          : referralCode // ignore: cast_nullable_to_non_nullable
              as String,
      referredUserId: freezed == referredUserId
          ? _value.referredUserId
          : referredUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      pointsEarned: null == pointsEarned
          ? _value.pointsEarned
          : pointsEarned // ignore: cast_nullable_to_non_nullable
              as int,
      campaignId: freezed == campaignId
          ? _value.campaignId
          : campaignId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReferralImplCopyWith<$Res>
    implements $ReferralCopyWith<$Res> {
  factory _$$ReferralImplCopyWith(
          _$ReferralImpl value, $Res Function(_$ReferralImpl) then) =
      __$$ReferralImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String referrerId,
      String referralCode,
      String? referredUserId,
      DateTime createdAt,
      DateTime? completedAt,
      bool isCompleted,
      int pointsEarned,
      String? campaignId});
}

/// @nodoc
class __$$ReferralImplCopyWithImpl<$Res>
    extends _$ReferralCopyWithImpl<$Res, _$ReferralImpl>
    implements _$$ReferralImplCopyWith<$Res> {
  __$$ReferralImplCopyWithImpl(
      _$ReferralImpl _value, $Res Function(_$ReferralImpl) _then)
      : super(_value, _then);

  /// Create a copy of Referral
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? referrerId = null,
    Object? referralCode = null,
    Object? referredUserId = freezed,
    Object? createdAt = null,
    Object? completedAt = freezed,
    Object? isCompleted = null,
    Object? pointsEarned = null,
    Object? campaignId = freezed,
  }) {
    return _then(_$ReferralImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      referrerId: null == referrerId
          ? _value.referrerId
          : referrerId // ignore: cast_nullable_to_non_nullable
              as String,
      referralCode: null == referralCode
          ? _value.referralCode
          : referralCode // ignore: cast_nullable_to_non_nullable
              as String,
      referredUserId: freezed == referredUserId
          ? _value.referredUserId
          : referredUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      pointsEarned: null == pointsEarned
          ? _value.pointsEarned
          : pointsEarned // ignore: cast_nullable_to_non_nullable
              as int,
      campaignId: freezed == campaignId
          ? _value.campaignId
          : campaignId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReferralImpl implements _Referral {
  const _$ReferralImpl(
      {required this.id,
      required this.referrerId,
      required this.referralCode,
      this.referredUserId,
      required this.createdAt,
      this.completedAt,
      this.isCompleted = false,
      this.pointsEarned = 0,
      this.campaignId});

  factory _$ReferralImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReferralImplFromJson(json);

  @override
  final String id;
  @override
  final String referrerId;
  @override
  final String referralCode;
  @override
  final String? referredUserId;
  @override
  final DateTime createdAt;
  @override
  final DateTime? completedAt;
  @override
  @JsonKey()
  final bool isCompleted;
  @override
  @JsonKey()
  final int pointsEarned;
  @override
  final String? campaignId;

  @override
  String toString() {
    return 'Referral(id: $id, referrerId: $referrerId, referralCode: $referralCode, referredUserId: $referredUserId, createdAt: $createdAt, completedAt: $completedAt, isCompleted: $isCompleted, pointsEarned: $pointsEarned, campaignId: $campaignId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReferralImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.referrerId, referrerId) ||
                other.referrerId == referrerId) &&
            (identical(other.referralCode, referralCode) ||
                other.referralCode == referralCode) &&
            (identical(other.referredUserId, referredUserId) ||
                other.referredUserId == referredUserId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.pointsEarned, pointsEarned) ||
                other.pointsEarned == pointsEarned) &&
            (identical(other.campaignId, campaignId) ||
                other.campaignId == campaignId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      referrerId,
      referralCode,
      referredUserId,
      createdAt,
      completedAt,
      isCompleted,
      pointsEarned,
      campaignId);

  /// Create a copy of Referral
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReferralImplCopyWith<_$ReferralImpl> get copyWith =>
      __$$ReferralImplCopyWithImpl<_$ReferralImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReferralImplToJson(
      this,
    );
  }
}

abstract class _Referral implements Referral {
  const factory _Referral(
      {required final String id,
      required final String referrerId,
      required final String referralCode,
      final String? referredUserId,
      required final DateTime createdAt,
      final DateTime? completedAt,
      final bool isCompleted,
      final int pointsEarned,
      final String? campaignId}) = _$ReferralImpl;

  factory _Referral.fromJson(Map<String, dynamic> json) =
      _$ReferralImpl.fromJson;

  @override
  String get id;
  @override
  String get referrerId;
  @override
  String get referralCode;
  @override
  String? get referredUserId;
  @override
  DateTime get createdAt;
  @override
  DateTime? get completedAt;
  @override
  bool get isCompleted;
  @override
  int get pointsEarned;
  @override
  String? get campaignId;

  /// Create a copy of Referral
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReferralImplCopyWith<_$ReferralImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OnboardingProgress _$OnboardingProgressFromJson(Map<String, dynamic> json) {
  return _OnboardingProgress.fromJson(json);
}

/// @nodoc
mixin _$OnboardingProgress {
  String get userId => throw _privateConstructorUsedError;
  OnboardingStep get currentStep => throw _privateConstructorUsedError;
  Map<String, bool> get completedSteps => throw _privateConstructorUsedError;
  bool get isComplete => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Serializes this OnboardingProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OnboardingProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OnboardingProgressCopyWith<OnboardingProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardingProgressCopyWith<$Res> {
  factory $OnboardingProgressCopyWith(
          OnboardingProgress value, $Res Function(OnboardingProgress) then) =
      _$OnboardingProgressCopyWithImpl<$Res, OnboardingProgress>;
  @useResult
  $Res call(
      {String userId,
      OnboardingStep currentStep,
      Map<String, bool> completedSteps,
      bool isComplete,
      DateTime? completedAt});
}

/// @nodoc
class _$OnboardingProgressCopyWithImpl<$Res, $Val extends OnboardingProgress>
    implements $OnboardingProgressCopyWith<$Res> {
  _$OnboardingProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OnboardingProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? currentStep = null,
    Object? completedSteps = null,
    Object? isComplete = null,
    Object? completedAt = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      currentStep: null == currentStep
          ? _value.currentStep
          : currentStep // ignore: cast_nullable_to_non_nullable
              as OnboardingStep,
      completedSteps: null == completedSteps
          ? _value.completedSteps
          : completedSteps // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
      isComplete: null == isComplete
          ? _value.isComplete
          : isComplete // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OnboardingProgressImplCopyWith<$Res>
    implements $OnboardingProgressCopyWith<$Res> {
  factory _$$OnboardingProgressImplCopyWith(_$OnboardingProgressImpl value,
          $Res Function(_$OnboardingProgressImpl) then) =
      __$$OnboardingProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      OnboardingStep currentStep,
      Map<String, bool> completedSteps,
      bool isComplete,
      DateTime? completedAt});
}

/// @nodoc
class __$$OnboardingProgressImplCopyWithImpl<$Res>
    extends _$OnboardingProgressCopyWithImpl<$Res, _$OnboardingProgressImpl>
    implements _$$OnboardingProgressImplCopyWith<$Res> {
  __$$OnboardingProgressImplCopyWithImpl(_$OnboardingProgressImpl _value,
      $Res Function(_$OnboardingProgressImpl) _then)
      : super(_value, _then);

  /// Create a copy of OnboardingProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? currentStep = null,
    Object? completedSteps = null,
    Object? isComplete = null,
    Object? completedAt = freezed,
  }) {
    return _then(_$OnboardingProgressImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      currentStep: null == currentStep
          ? _value.currentStep
          : currentStep // ignore: cast_nullable_to_non_nullable
              as OnboardingStep,
      completedSteps: null == completedSteps
          ? _value._completedSteps
          : completedSteps // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
      isComplete: null == isComplete
          ? _value.isComplete
          : isComplete // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OnboardingProgressImpl implements _OnboardingProgress {
  const _$OnboardingProgressImpl(
      {required this.userId,
      this.currentStep = OnboardingStep.welcome,
      final Map<String, bool> completedSteps = const {},
      this.isComplete = false,
      this.completedAt})
      : _completedSteps = completedSteps;

  factory _$OnboardingProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$OnboardingProgressImplFromJson(json);

  @override
  final String userId;
  @override
  @JsonKey()
  final OnboardingStep currentStep;
  final Map<String, bool> _completedSteps;
  @override
  @JsonKey()
  Map<String, bool> get completedSteps {
    if (_completedSteps is EqualUnmodifiableMapView) return _completedSteps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_completedSteps);
  }

  @override
  @JsonKey()
  final bool isComplete;
  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'OnboardingProgress(userId: $userId, currentStep: $currentStep, completedSteps: $completedSteps, isComplete: $isComplete, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingProgressImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            const DeepCollectionEquality()
                .equals(other._completedSteps, _completedSteps) &&
            (identical(other.isComplete, isComplete) ||
                other.isComplete == isComplete) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      currentStep,
      const DeepCollectionEquality().hash(_completedSteps),
      isComplete,
      completedAt);

  /// Create a copy of OnboardingProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingProgressImplCopyWith<_$OnboardingProgressImpl> get copyWith =>
      __$$OnboardingProgressImplCopyWithImpl<_$OnboardingProgressImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OnboardingProgressImplToJson(
      this,
    );
  }
}

abstract class _OnboardingProgress implements OnboardingProgress {
  const factory _OnboardingProgress(
      {required final String userId,
      final OnboardingStep currentStep,
      final Map<String, bool> completedSteps,
      final bool isComplete,
      final DateTime? completedAt}) = _$OnboardingProgressImpl;

  factory _OnboardingProgress.fromJson(Map<String, dynamic> json) =
      _$OnboardingProgressImpl.fromJson;

  @override
  String get userId;
  @override
  OnboardingStep get currentStep;
  @override
  Map<String, bool> get completedSteps;
  @override
  bool get isComplete;
  @override
  DateTime? get completedAt;

  /// Create a copy of OnboardingProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnboardingProgressImplCopyWith<_$OnboardingProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SyncOperation _$SyncOperationFromJson(Map<String, dynamic> json) {
  return _SyncOperation.fromJson(json);
}

/// @nodoc
mixin _$SyncOperation {
  String get id => throw _privateConstructorUsedError;
  String get operationType => throw _privateConstructorUsedError;
  String get tableName => throw _privateConstructorUsedError;
  Map<String, dynamic> get data => throw _privateConstructorUsedError;
  SyncStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get syncedAt => throw _privateConstructorUsedError;
  int? get retryCount => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Serializes this SyncOperation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SyncOperation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncOperationCopyWith<SyncOperation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncOperationCopyWith<$Res> {
  factory $SyncOperationCopyWith(
          SyncOperation value, $Res Function(SyncOperation) then) =
      _$SyncOperationCopyWithImpl<$Res, SyncOperation>;
  @useResult
  $Res call(
      {String id,
      String operationType,
      String tableName,
      Map<String, dynamic> data,
      SyncStatus status,
      DateTime createdAt,
      DateTime? syncedAt,
      int? retryCount,
      String? errorMessage});
}

/// @nodoc
class _$SyncOperationCopyWithImpl<$Res, $Val extends SyncOperation>
    implements $SyncOperationCopyWith<$Res> {
  _$SyncOperationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncOperation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? operationType = null,
    Object? tableName = null,
    Object? data = null,
    Object? status = null,
    Object? createdAt = null,
    Object? syncedAt = freezed,
    Object? retryCount = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      operationType: null == operationType
          ? _value.operationType
          : operationType // ignore: cast_nullable_to_non_nullable
              as String,
      tableName: null == tableName
          ? _value.tableName
          : tableName // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      syncedAt: freezed == syncedAt
          ? _value.syncedAt
          : syncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      retryCount: freezed == retryCount
          ? _value.retryCount
          : retryCount // ignore: cast_nullable_to_non_nullable
              as int?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SyncOperationImplCopyWith<$Res>
    implements $SyncOperationCopyWith<$Res> {
  factory _$$SyncOperationImplCopyWith(
          _$SyncOperationImpl value, $Res Function(_$SyncOperationImpl) then) =
      __$$SyncOperationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String operationType,
      String tableName,
      Map<String, dynamic> data,
      SyncStatus status,
      DateTime createdAt,
      DateTime? syncedAt,
      int? retryCount,
      String? errorMessage});
}

/// @nodoc
class __$$SyncOperationImplCopyWithImpl<$Res>
    extends _$SyncOperationCopyWithImpl<$Res, _$SyncOperationImpl>
    implements _$$SyncOperationImplCopyWith<$Res> {
  __$$SyncOperationImplCopyWithImpl(
      _$SyncOperationImpl _value, $Res Function(_$SyncOperationImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncOperation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? operationType = null,
    Object? tableName = null,
    Object? data = null,
    Object? status = null,
    Object? createdAt = null,
    Object? syncedAt = freezed,
    Object? retryCount = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_$SyncOperationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      operationType: null == operationType
          ? _value.operationType
          : operationType // ignore: cast_nullable_to_non_nullable
              as String,
      tableName: null == tableName
          ? _value.tableName
          : tableName // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      syncedAt: freezed == syncedAt
          ? _value.syncedAt
          : syncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      retryCount: freezed == retryCount
          ? _value.retryCount
          : retryCount // ignore: cast_nullable_to_non_nullable
              as int?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SyncOperationImpl implements _SyncOperation {
  const _$SyncOperationImpl(
      {required this.id,
      required this.operationType,
      required this.tableName,
      required final Map<String, dynamic> data,
      this.status = SyncStatus.pending,
      required this.createdAt,
      this.syncedAt,
      this.retryCount,
      this.errorMessage})
      : _data = data;

  factory _$SyncOperationImpl.fromJson(Map<String, dynamic> json) =>
      _$$SyncOperationImplFromJson(json);

  @override
  final String id;
  @override
  final String operationType;
  @override
  final String tableName;
  final Map<String, dynamic> _data;
  @override
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  @JsonKey()
  final SyncStatus status;
  @override
  final DateTime createdAt;
  @override
  final DateTime? syncedAt;
  @override
  final int? retryCount;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'SyncOperation(id: $id, operationType: $operationType, tableName: $tableName, data: $data, status: $status, createdAt: $createdAt, syncedAt: $syncedAt, retryCount: $retryCount, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncOperationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.operationType, operationType) ||
                other.operationType == operationType) &&
            (identical(other.tableName, tableName) ||
                other.tableName == tableName) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.syncedAt, syncedAt) ||
                other.syncedAt == syncedAt) &&
            (identical(other.retryCount, retryCount) ||
                other.retryCount == retryCount) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      operationType,
      tableName,
      const DeepCollectionEquality().hash(_data),
      status,
      createdAt,
      syncedAt,
      retryCount,
      errorMessage);

  /// Create a copy of SyncOperation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncOperationImplCopyWith<_$SyncOperationImpl> get copyWith =>
      __$$SyncOperationImplCopyWithImpl<_$SyncOperationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SyncOperationImplToJson(
      this,
    );
  }
}

abstract class _SyncOperation implements SyncOperation {
  const factory _SyncOperation(
      {required final String id,
      required final String operationType,
      required final String tableName,
      required final Map<String, dynamic> data,
      final SyncStatus status,
      required final DateTime createdAt,
      final DateTime? syncedAt,
      final int? retryCount,
      final String? errorMessage}) = _$SyncOperationImpl;

  factory _SyncOperation.fromJson(Map<String, dynamic> json) =
      _$SyncOperationImpl.fromJson;

  @override
  String get id;
  @override
  String get operationType;
  @override
  String get tableName;
  @override
  Map<String, dynamic> get data;
  @override
  SyncStatus get status;
  @override
  DateTime get createdAt;
  @override
  DateTime? get syncedAt;
  @override
  int? get retryCount;
  @override
  String? get errorMessage;

  /// Create a copy of SyncOperation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncOperationImplCopyWith<_$SyncOperationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DeepLink _$DeepLinkFromJson(Map<String, dynamic> json) {
  return _DeepLink.fromJson(json);
}

/// @nodoc
mixin _$DeepLink {
  DeepLinkType get type => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  Map<String, String>? get parameters => throw _privateConstructorUsedError;
  String? get path => throw _privateConstructorUsedError;

  /// Serializes this DeepLink to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeepLink
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeepLinkCopyWith<DeepLink> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeepLinkCopyWith<$Res> {
  factory $DeepLinkCopyWith(DeepLink value, $Res Function(DeepLink) then) =
      _$DeepLinkCopyWithImpl<$Res, DeepLink>;
  @useResult
  $Res call(
      {DeepLinkType type,
      String id,
      Map<String, String>? parameters,
      String? path});
}

/// @nodoc
class _$DeepLinkCopyWithImpl<$Res, $Val extends DeepLink>
    implements $DeepLinkCopyWith<$Res> {
  _$DeepLinkCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeepLink
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? id = null,
    Object? parameters = freezed,
    Object? path = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as DeepLinkType,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      parameters: freezed == parameters
          ? _value.parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      path: freezed == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeepLinkImplCopyWith<$Res>
    implements $DeepLinkCopyWith<$Res> {
  factory _$$DeepLinkImplCopyWith(
          _$DeepLinkImpl value, $Res Function(_$DeepLinkImpl) then) =
      __$$DeepLinkImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DeepLinkType type,
      String id,
      Map<String, String>? parameters,
      String? path});
}

/// @nodoc
class __$$DeepLinkImplCopyWithImpl<$Res>
    extends _$DeepLinkCopyWithImpl<$Res, _$DeepLinkImpl>
    implements _$$DeepLinkImplCopyWith<$Res> {
  __$$DeepLinkImplCopyWithImpl(
      _$DeepLinkImpl _value, $Res Function(_$DeepLinkImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeepLink
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? id = null,
    Object? parameters = freezed,
    Object? path = freezed,
  }) {
    return _then(_$DeepLinkImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as DeepLinkType,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      parameters: freezed == parameters
          ? _value._parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      path: freezed == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeepLinkImpl implements _DeepLink {
  const _$DeepLinkImpl(
      {required this.type,
      required this.id,
      final Map<String, String>? parameters,
      this.path})
      : _parameters = parameters;

  factory _$DeepLinkImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeepLinkImplFromJson(json);

  @override
  final DeepLinkType type;
  @override
  final String id;
  final Map<String, String>? _parameters;
  @override
  Map<String, String>? get parameters {
    final value = _parameters;
    if (value == null) return null;
    if (_parameters is EqualUnmodifiableMapView) return _parameters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? path;

  @override
  String toString() {
    return 'DeepLink(type: $type, id: $id, parameters: $parameters, path: $path)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeepLinkImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality()
                .equals(other._parameters, _parameters) &&
            (identical(other.path, path) || other.path == path));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, id,
      const DeepCollectionEquality().hash(_parameters), path);

  /// Create a copy of DeepLink
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeepLinkImplCopyWith<_$DeepLinkImpl> get copyWith =>
      __$$DeepLinkImplCopyWithImpl<_$DeepLinkImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeepLinkImplToJson(
      this,
    );
  }
}

abstract class _DeepLink implements DeepLink {
  const factory _DeepLink(
      {required final DeepLinkType type,
      required final String id,
      final Map<String, String>? parameters,
      final String? path}) = _$DeepLinkImpl;

  factory _DeepLink.fromJson(Map<String, dynamic> json) =
      _$DeepLinkImpl.fromJson;

  @override
  DeepLinkType get type;
  @override
  String get id;
  @override
  Map<String, String>? get parameters;
  @override
  String? get path;

  /// Create a copy of DeepLink
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeepLinkImplCopyWith<_$DeepLinkImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SupportTicket _$SupportTicketFromJson(Map<String, dynamic> json) {
  return _SupportTicket.fromJson(json);
}

/// @nodoc
mixin _$SupportTicket {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  TicketCategory get category => throw _privateConstructorUsedError;
  String get subject => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  TicketPriority get priority => throw _privateConstructorUsedError;
  FeedbackStatus get status => throw _privateConstructorUsedError;
  List<String> get attachments => throw _privateConstructorUsedError;
  String? get assignedTo => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  DateTime? get resolvedAt => throw _privateConstructorUsedError;

  /// Serializes this SupportTicket to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SupportTicket
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SupportTicketCopyWith<SupportTicket> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SupportTicketCopyWith<$Res> {
  factory $SupportTicketCopyWith(
          SupportTicket value, $Res Function(SupportTicket) then) =
      _$SupportTicketCopyWithImpl<$Res, SupportTicket>;
  @useResult
  $Res call(
      {String id,
      String userId,
      TicketCategory category,
      String subject,
      String description,
      TicketPriority priority,
      FeedbackStatus status,
      List<String> attachments,
      String? assignedTo,
      DateTime createdAt,
      DateTime? updatedAt,
      DateTime? resolvedAt});
}

/// @nodoc
class _$SupportTicketCopyWithImpl<$Res, $Val extends SupportTicket>
    implements $SupportTicketCopyWith<$Res> {
  _$SupportTicketCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SupportTicket
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? category = null,
    Object? subject = null,
    Object? description = null,
    Object? priority = null,
    Object? status = null,
    Object? attachments = null,
    Object? assignedTo = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? resolvedAt = freezed,
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
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as TicketCategory,
      subject: null == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as TicketPriority,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FeedbackStatus,
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>,
      assignedTo: freezed == assignedTo
          ? _value.assignedTo
          : assignedTo // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      resolvedAt: freezed == resolvedAt
          ? _value.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SupportTicketImplCopyWith<$Res>
    implements $SupportTicketCopyWith<$Res> {
  factory _$$SupportTicketImplCopyWith(
          _$SupportTicketImpl value, $Res Function(_$SupportTicketImpl) then) =
      __$$SupportTicketImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      TicketCategory category,
      String subject,
      String description,
      TicketPriority priority,
      FeedbackStatus status,
      List<String> attachments,
      String? assignedTo,
      DateTime createdAt,
      DateTime? updatedAt,
      DateTime? resolvedAt});
}

/// @nodoc
class __$$SupportTicketImplCopyWithImpl<$Res>
    extends _$SupportTicketCopyWithImpl<$Res, _$SupportTicketImpl>
    implements _$$SupportTicketImplCopyWith<$Res> {
  __$$SupportTicketImplCopyWithImpl(
      _$SupportTicketImpl _value, $Res Function(_$SupportTicketImpl) _then)
      : super(_value, _then);

  /// Create a copy of SupportTicket
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? category = null,
    Object? subject = null,
    Object? description = null,
    Object? priority = null,
    Object? status = null,
    Object? attachments = null,
    Object? assignedTo = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? resolvedAt = freezed,
  }) {
    return _then(_$SupportTicketImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as TicketCategory,
      subject: null == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as TicketPriority,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FeedbackStatus,
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>,
      assignedTo: freezed == assignedTo
          ? _value.assignedTo
          : assignedTo // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      resolvedAt: freezed == resolvedAt
          ? _value.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SupportTicketImpl implements _SupportTicket {
  const _$SupportTicketImpl(
      {required this.id,
      required this.userId,
      required this.category,
      required this.subject,
      required this.description,
      this.priority = TicketPriority.medium,
      this.status = FeedbackStatus.submitted,
      final List<String> attachments = const [],
      this.assignedTo,
      required this.createdAt,
      this.updatedAt,
      this.resolvedAt})
      : _attachments = attachments;

  factory _$SupportTicketImpl.fromJson(Map<String, dynamic> json) =>
      _$$SupportTicketImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final TicketCategory category;
  @override
  final String subject;
  @override
  final String description;
  @override
  @JsonKey()
  final TicketPriority priority;
  @override
  @JsonKey()
  final FeedbackStatus status;
  final List<String> _attachments;
  @override
  @JsonKey()
  List<String> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  @override
  final String? assignedTo;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? resolvedAt;

  @override
  String toString() {
    return 'SupportTicket(id: $id, userId: $userId, category: $category, subject: $subject, description: $description, priority: $priority, status: $status, attachments: $attachments, assignedTo: $assignedTo, createdAt: $createdAt, updatedAt: $updatedAt, resolvedAt: $resolvedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SupportTicketImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            (identical(other.assignedTo, assignedTo) ||
                other.assignedTo == assignedTo) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      category,
      subject,
      description,
      priority,
      status,
      const DeepCollectionEquality().hash(_attachments),
      assignedTo,
      createdAt,
      updatedAt,
      resolvedAt);

  /// Create a copy of SupportTicket
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SupportTicketImplCopyWith<_$SupportTicketImpl> get copyWith =>
      __$$SupportTicketImplCopyWithImpl<_$SupportTicketImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SupportTicketImplToJson(
      this,
    );
  }
}

abstract class _SupportTicket implements SupportTicket {
  const factory _SupportTicket(
      {required final String id,
      required final String userId,
      required final TicketCategory category,
      required final String subject,
      required final String description,
      final TicketPriority priority,
      final FeedbackStatus status,
      final List<String> attachments,
      final String? assignedTo,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final DateTime? resolvedAt}) = _$SupportTicketImpl;

  factory _SupportTicket.fromJson(Map<String, dynamic> json) =
      _$SupportTicketImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  TicketCategory get category;
  @override
  String get subject;
  @override
  String get description;
  @override
  TicketPriority get priority;
  @override
  FeedbackStatus get status;
  @override
  List<String> get attachments;
  @override
  String? get assignedTo;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  DateTime? get resolvedAt;

  /// Create a copy of SupportTicket
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SupportTicketImplCopyWith<_$SupportTicketImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TicketMessage _$TicketMessageFromJson(Map<String, dynamic> json) {
  return _TicketMessage.fromJson(json);
}

/// @nodoc
mixin _$TicketMessage {
  String get id => throw _privateConstructorUsedError;
  String get ticketId => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  List<String> get attachments => throw _privateConstructorUsedError;
  bool get isStaff => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this TicketMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TicketMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TicketMessageCopyWith<TicketMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketMessageCopyWith<$Res> {
  factory $TicketMessageCopyWith(
          TicketMessage value, $Res Function(TicketMessage) then) =
      _$TicketMessageCopyWithImpl<$Res, TicketMessage>;
  @useResult
  $Res call(
      {String id,
      String ticketId,
      String senderId,
      String message,
      List<String> attachments,
      bool isStaff,
      DateTime createdAt});
}

/// @nodoc
class _$TicketMessageCopyWithImpl<$Res, $Val extends TicketMessage>
    implements $TicketMessageCopyWith<$Res> {
  _$TicketMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TicketMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ticketId = null,
    Object? senderId = null,
    Object? message = null,
    Object? attachments = null,
    Object? isStaff = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ticketId: null == ticketId
          ? _value.ticketId
          : ticketId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isStaff: null == isStaff
          ? _value.isStaff
          : isStaff // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TicketMessageImplCopyWith<$Res>
    implements $TicketMessageCopyWith<$Res> {
  factory _$$TicketMessageImplCopyWith(
          _$TicketMessageImpl value, $Res Function(_$TicketMessageImpl) then) =
      __$$TicketMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String ticketId,
      String senderId,
      String message,
      List<String> attachments,
      bool isStaff,
      DateTime createdAt});
}

/// @nodoc
class __$$TicketMessageImplCopyWithImpl<$Res>
    extends _$TicketMessageCopyWithImpl<$Res, _$TicketMessageImpl>
    implements _$$TicketMessageImplCopyWith<$Res> {
  __$$TicketMessageImplCopyWithImpl(
      _$TicketMessageImpl _value, $Res Function(_$TicketMessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of TicketMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ticketId = null,
    Object? senderId = null,
    Object? message = null,
    Object? attachments = null,
    Object? isStaff = null,
    Object? createdAt = null,
  }) {
    return _then(_$TicketMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ticketId: null == ticketId
          ? _value.ticketId
          : ticketId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isStaff: null == isStaff
          ? _value.isStaff
          : isStaff // ignore: cast_nullable_to_non_nullable
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
class _$TicketMessageImpl implements _TicketMessage {
  const _$TicketMessageImpl(
      {required this.id,
      required this.ticketId,
      required this.senderId,
      required this.message,
      final List<String> attachments = const [],
      this.isStaff = false,
      required this.createdAt})
      : _attachments = attachments;

  factory _$TicketMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$TicketMessageImplFromJson(json);

  @override
  final String id;
  @override
  final String ticketId;
  @override
  final String senderId;
  @override
  final String message;
  final List<String> _attachments;
  @override
  @JsonKey()
  List<String> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  @override
  @JsonKey()
  final bool isStaff;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'TicketMessage(id: $id, ticketId: $ticketId, senderId: $senderId, message: $message, attachments: $attachments, isStaff: $isStaff, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TicketMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ticketId, ticketId) ||
                other.ticketId == ticketId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            (identical(other.isStaff, isStaff) || other.isStaff == isStaff) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, ticketId, senderId, message,
      const DeepCollectionEquality().hash(_attachments), isStaff, createdAt);

  /// Create a copy of TicketMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TicketMessageImplCopyWith<_$TicketMessageImpl> get copyWith =>
      __$$TicketMessageImplCopyWithImpl<_$TicketMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TicketMessageImplToJson(
      this,
    );
  }
}

abstract class _TicketMessage implements TicketMessage {
  const factory _TicketMessage(
      {required final String id,
      required final String ticketId,
      required final String senderId,
      required final String message,
      final List<String> attachments,
      final bool isStaff,
      required final DateTime createdAt}) = _$TicketMessageImpl;

  factory _TicketMessage.fromJson(Map<String, dynamic> json) =
      _$TicketMessageImpl.fromJson;

  @override
  String get id;
  @override
  String get ticketId;
  @override
  String get senderId;
  @override
  String get message;
  @override
  List<String> get attachments;
  @override
  bool get isStaff;
  @override
  DateTime get createdAt;

  /// Create a copy of TicketMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TicketMessageImplCopyWith<_$TicketMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
