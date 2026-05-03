// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'special_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SpecialRequest _$SpecialRequestFromJson(Map<String, dynamic> json) {
  return _SpecialRequest.fromJson(json);
}

/// @nodoc
mixin _$SpecialRequest {
  String get id => throw _privateConstructorUsedError;
  String get bookingId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  RequestType get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  RequestStatus get status => throw _privateConstructorUsedError;
  String? get responseMessage => throw _privateConstructorUsedError;
  DateTime? get responseTime => throw _privateConstructorUsedError;
  bool get isPriority => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this SpecialRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpecialRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpecialRequestCopyWith<SpecialRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpecialRequestCopyWith<$Res> {
  factory $SpecialRequestCopyWith(
          SpecialRequest value, $Res Function(SpecialRequest) then) =
      _$SpecialRequestCopyWithImpl<$Res, SpecialRequest>;
  @useResult
  $Res call(
      {String id,
      String bookingId,
      String userId,
      RequestType type,
      String title,
      String description,
      RequestStatus status,
      String? responseMessage,
      DateTime? responseTime,
      bool isPriority,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$SpecialRequestCopyWithImpl<$Res, $Val extends SpecialRequest>
    implements $SpecialRequestCopyWith<$Res> {
  _$SpecialRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpecialRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookingId = null,
    Object? userId = null,
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? status = null,
    Object? responseMessage = freezed,
    Object? responseTime = freezed,
    Object? isPriority = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as RequestType,
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
              as RequestStatus,
      responseMessage: freezed == responseMessage
          ? _value.responseMessage
          : responseMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      responseTime: freezed == responseTime
          ? _value.responseTime
          : responseTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isPriority: null == isPriority
          ? _value.isPriority
          : isPriority // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpecialRequestImplCopyWith<$Res>
    implements $SpecialRequestCopyWith<$Res> {
  factory _$$SpecialRequestImplCopyWith(_$SpecialRequestImpl value,
          $Res Function(_$SpecialRequestImpl) then) =
      __$$SpecialRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String bookingId,
      String userId,
      RequestType type,
      String title,
      String description,
      RequestStatus status,
      String? responseMessage,
      DateTime? responseTime,
      bool isPriority,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$SpecialRequestImplCopyWithImpl<$Res>
    extends _$SpecialRequestCopyWithImpl<$Res, _$SpecialRequestImpl>
    implements _$$SpecialRequestImplCopyWith<$Res> {
  __$$SpecialRequestImplCopyWithImpl(
      _$SpecialRequestImpl _value, $Res Function(_$SpecialRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpecialRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookingId = null,
    Object? userId = null,
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? status = null,
    Object? responseMessage = freezed,
    Object? responseTime = freezed,
    Object? isPriority = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$SpecialRequestImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as RequestType,
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
              as RequestStatus,
      responseMessage: freezed == responseMessage
          ? _value.responseMessage
          : responseMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      responseTime: freezed == responseTime
          ? _value.responseTime
          : responseTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isPriority: null == isPriority
          ? _value.isPriority
          : isPriority // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpecialRequestImpl implements _SpecialRequest {
  const _$SpecialRequestImpl(
      {required this.id,
      required this.bookingId,
      required this.userId,
      required this.type,
      required this.title,
      required this.description,
      this.status = RequestStatus.pending,
      this.responseMessage,
      this.responseTime,
      this.isPriority = false,
      required this.createdAt,
      this.updatedAt});

  factory _$SpecialRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpecialRequestImplFromJson(json);

  @override
  final String id;
  @override
  final String bookingId;
  @override
  final String userId;
  @override
  final RequestType type;
  @override
  final String title;
  @override
  final String description;
  @override
  @JsonKey()
  final RequestStatus status;
  @override
  final String? responseMessage;
  @override
  final DateTime? responseTime;
  @override
  @JsonKey()
  final bool isPriority;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'SpecialRequest(id: $id, bookingId: $bookingId, userId: $userId, type: $type, title: $title, description: $description, status: $status, responseMessage: $responseMessage, responseTime: $responseTime, isPriority: $isPriority, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpecialRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.responseMessage, responseMessage) ||
                other.responseMessage == responseMessage) &&
            (identical(other.responseTime, responseTime) ||
                other.responseTime == responseTime) &&
            (identical(other.isPriority, isPriority) ||
                other.isPriority == isPriority) &&
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
      bookingId,
      userId,
      type,
      title,
      description,
      status,
      responseMessage,
      responseTime,
      isPriority,
      createdAt,
      updatedAt);

  /// Create a copy of SpecialRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpecialRequestImplCopyWith<_$SpecialRequestImpl> get copyWith =>
      __$$SpecialRequestImplCopyWithImpl<_$SpecialRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpecialRequestImplToJson(
      this,
    );
  }
}

abstract class _SpecialRequest implements SpecialRequest {
  const factory _SpecialRequest(
      {required final String id,
      required final String bookingId,
      required final String userId,
      required final RequestType type,
      required final String title,
      required final String description,
      final RequestStatus status,
      final String? responseMessage,
      final DateTime? responseTime,
      final bool isPriority,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$SpecialRequestImpl;

  factory _SpecialRequest.fromJson(Map<String, dynamic> json) =
      _$SpecialRequestImpl.fromJson;

  @override
  String get id;
  @override
  String get bookingId;
  @override
  String get userId;
  @override
  RequestType get type;
  @override
  String get title;
  @override
  String get description;
  @override
  RequestStatus get status;
  @override
  String? get responseMessage;
  @override
  DateTime? get responseTime;
  @override
  bool get isPriority;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of SpecialRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpecialRequestImplCopyWith<_$SpecialRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RequestTemplate _$RequestTemplateFromJson(Map<String, dynamic> json) {
  return _RequestTemplate.fromJson(json);
}

/// @nodoc
mixin _$RequestTemplate {
  String get id => throw _privateConstructorUsedError;
  RequestType get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get exampleText => throw _privateConstructorUsedError;
  bool get isPopular => throw _privateConstructorUsedError;

  /// Serializes this RequestTemplate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RequestTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RequestTemplateCopyWith<RequestTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequestTemplateCopyWith<$Res> {
  factory $RequestTemplateCopyWith(
          RequestTemplate value, $Res Function(RequestTemplate) then) =
      _$RequestTemplateCopyWithImpl<$Res, RequestTemplate>;
  @useResult
  $Res call(
      {String id,
      RequestType type,
      String title,
      String description,
      String? exampleText,
      bool isPopular});
}

/// @nodoc
class _$RequestTemplateCopyWithImpl<$Res, $Val extends RequestTemplate>
    implements $RequestTemplateCopyWith<$Res> {
  _$RequestTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RequestTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? exampleText = freezed,
    Object? isPopular = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as RequestType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      exampleText: freezed == exampleText
          ? _value.exampleText
          : exampleText // ignore: cast_nullable_to_non_nullable
              as String?,
      isPopular: null == isPopular
          ? _value.isPopular
          : isPopular // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RequestTemplateImplCopyWith<$Res>
    implements $RequestTemplateCopyWith<$Res> {
  factory _$$RequestTemplateImplCopyWith(_$RequestTemplateImpl value,
          $Res Function(_$RequestTemplateImpl) then) =
      __$$RequestTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      RequestType type,
      String title,
      String description,
      String? exampleText,
      bool isPopular});
}

/// @nodoc
class __$$RequestTemplateImplCopyWithImpl<$Res>
    extends _$RequestTemplateCopyWithImpl<$Res, _$RequestTemplateImpl>
    implements _$$RequestTemplateImplCopyWith<$Res> {
  __$$RequestTemplateImplCopyWithImpl(
      _$RequestTemplateImpl _value, $Res Function(_$RequestTemplateImpl) _then)
      : super(_value, _then);

  /// Create a copy of RequestTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? exampleText = freezed,
    Object? isPopular = null,
  }) {
    return _then(_$RequestTemplateImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as RequestType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      exampleText: freezed == exampleText
          ? _value.exampleText
          : exampleText // ignore: cast_nullable_to_non_nullable
              as String?,
      isPopular: null == isPopular
          ? _value.isPopular
          : isPopular // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RequestTemplateImpl implements _RequestTemplate {
  const _$RequestTemplateImpl(
      {required this.id,
      required this.type,
      required this.title,
      required this.description,
      this.exampleText,
      this.isPopular = false});

  factory _$RequestTemplateImpl.fromJson(Map<String, dynamic> json) =>
      _$$RequestTemplateImplFromJson(json);

  @override
  final String id;
  @override
  final RequestType type;
  @override
  final String title;
  @override
  final String description;
  @override
  final String? exampleText;
  @override
  @JsonKey()
  final bool isPopular;

  @override
  String toString() {
    return 'RequestTemplate(id: $id, type: $type, title: $title, description: $description, exampleText: $exampleText, isPopular: $isPopular)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequestTemplateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.exampleText, exampleText) ||
                other.exampleText == exampleText) &&
            (identical(other.isPopular, isPopular) ||
                other.isPopular == isPopular));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, type, title, description, exampleText, isPopular);

  /// Create a copy of RequestTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RequestTemplateImplCopyWith<_$RequestTemplateImpl> get copyWith =>
      __$$RequestTemplateImplCopyWithImpl<_$RequestTemplateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RequestTemplateImplToJson(
      this,
    );
  }
}

abstract class _RequestTemplate implements RequestTemplate {
  const factory _RequestTemplate(
      {required final String id,
      required final RequestType type,
      required final String title,
      required final String description,
      final String? exampleText,
      final bool isPopular}) = _$RequestTemplateImpl;

  factory _RequestTemplate.fromJson(Map<String, dynamic> json) =
      _$RequestTemplateImpl.fromJson;

  @override
  String get id;
  @override
  RequestType get type;
  @override
  String get title;
  @override
  String get description;
  @override
  String? get exampleText;
  @override
  bool get isPopular;

  /// Create a copy of RequestTemplate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RequestTemplateImplCopyWith<_$RequestTemplateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
