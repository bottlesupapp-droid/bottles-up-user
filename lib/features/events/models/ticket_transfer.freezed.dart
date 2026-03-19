// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ticket_transfer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TicketTransfer _$TicketTransferFromJson(Map<String, dynamic> json) {
  return _TicketTransfer.fromJson(json);
}

/// @nodoc
mixin _$TicketTransfer {
  String get id => throw _privateConstructorUsedError;
  String get ticketId => throw _privateConstructorUsedError;
  String get fromUserId => throw _privateConstructorUsedError;
  String get toUserId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  DateTime? get transferredAt => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError; // Joined data
  String? get fromUserName => throw _privateConstructorUsedError;
  String? get fromUserEmail => throw _privateConstructorUsedError;
  String? get toUserName => throw _privateConstructorUsedError;
  String? get toUserEmail => throw _privateConstructorUsedError;
  String? get eventName => throw _privateConstructorUsedError;
  String? get eventDate => throw _privateConstructorUsedError;

  /// Serializes this TicketTransfer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TicketTransfer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TicketTransferCopyWith<TicketTransfer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketTransferCopyWith<$Res> {
  factory $TicketTransferCopyWith(
          TicketTransfer value, $Res Function(TicketTransfer) then) =
      _$TicketTransferCopyWithImpl<$Res, TicketTransfer>;
  @useResult
  $Res call(
      {String id,
      String ticketId,
      String fromUserId,
      String toUserId,
      String status,
      String? message,
      DateTime? transferredAt,
      DateTime? expiresAt,
      DateTime? createdAt,
      String? fromUserName,
      String? fromUserEmail,
      String? toUserName,
      String? toUserEmail,
      String? eventName,
      String? eventDate});
}

/// @nodoc
class _$TicketTransferCopyWithImpl<$Res, $Val extends TicketTransfer>
    implements $TicketTransferCopyWith<$Res> {
  _$TicketTransferCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TicketTransfer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ticketId = null,
    Object? fromUserId = null,
    Object? toUserId = null,
    Object? status = null,
    Object? message = freezed,
    Object? transferredAt = freezed,
    Object? expiresAt = freezed,
    Object? createdAt = freezed,
    Object? fromUserName = freezed,
    Object? fromUserEmail = freezed,
    Object? toUserName = freezed,
    Object? toUserEmail = freezed,
    Object? eventName = freezed,
    Object? eventDate = freezed,
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
      fromUserId: null == fromUserId
          ? _value.fromUserId
          : fromUserId // ignore: cast_nullable_to_non_nullable
              as String,
      toUserId: null == toUserId
          ? _value.toUserId
          : toUserId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      transferredAt: freezed == transferredAt
          ? _value.transferredAt
          : transferredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      fromUserName: freezed == fromUserName
          ? _value.fromUserName
          : fromUserName // ignore: cast_nullable_to_non_nullable
              as String?,
      fromUserEmail: freezed == fromUserEmail
          ? _value.fromUserEmail
          : fromUserEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      toUserName: freezed == toUserName
          ? _value.toUserName
          : toUserName // ignore: cast_nullable_to_non_nullable
              as String?,
      toUserEmail: freezed == toUserEmail
          ? _value.toUserEmail
          : toUserEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      eventName: freezed == eventName
          ? _value.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String?,
      eventDate: freezed == eventDate
          ? _value.eventDate
          : eventDate // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TicketTransferImplCopyWith<$Res>
    implements $TicketTransferCopyWith<$Res> {
  factory _$$TicketTransferImplCopyWith(_$TicketTransferImpl value,
          $Res Function(_$TicketTransferImpl) then) =
      __$$TicketTransferImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String ticketId,
      String fromUserId,
      String toUserId,
      String status,
      String? message,
      DateTime? transferredAt,
      DateTime? expiresAt,
      DateTime? createdAt,
      String? fromUserName,
      String? fromUserEmail,
      String? toUserName,
      String? toUserEmail,
      String? eventName,
      String? eventDate});
}

/// @nodoc
class __$$TicketTransferImplCopyWithImpl<$Res>
    extends _$TicketTransferCopyWithImpl<$Res, _$TicketTransferImpl>
    implements _$$TicketTransferImplCopyWith<$Res> {
  __$$TicketTransferImplCopyWithImpl(
      _$TicketTransferImpl _value, $Res Function(_$TicketTransferImpl) _then)
      : super(_value, _then);

  /// Create a copy of TicketTransfer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ticketId = null,
    Object? fromUserId = null,
    Object? toUserId = null,
    Object? status = null,
    Object? message = freezed,
    Object? transferredAt = freezed,
    Object? expiresAt = freezed,
    Object? createdAt = freezed,
    Object? fromUserName = freezed,
    Object? fromUserEmail = freezed,
    Object? toUserName = freezed,
    Object? toUserEmail = freezed,
    Object? eventName = freezed,
    Object? eventDate = freezed,
  }) {
    return _then(_$TicketTransferImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ticketId: null == ticketId
          ? _value.ticketId
          : ticketId // ignore: cast_nullable_to_non_nullable
              as String,
      fromUserId: null == fromUserId
          ? _value.fromUserId
          : fromUserId // ignore: cast_nullable_to_non_nullable
              as String,
      toUserId: null == toUserId
          ? _value.toUserId
          : toUserId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      transferredAt: freezed == transferredAt
          ? _value.transferredAt
          : transferredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      fromUserName: freezed == fromUserName
          ? _value.fromUserName
          : fromUserName // ignore: cast_nullable_to_non_nullable
              as String?,
      fromUserEmail: freezed == fromUserEmail
          ? _value.fromUserEmail
          : fromUserEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      toUserName: freezed == toUserName
          ? _value.toUserName
          : toUserName // ignore: cast_nullable_to_non_nullable
              as String?,
      toUserEmail: freezed == toUserEmail
          ? _value.toUserEmail
          : toUserEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      eventName: freezed == eventName
          ? _value.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String?,
      eventDate: freezed == eventDate
          ? _value.eventDate
          : eventDate // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TicketTransferImpl implements _TicketTransfer {
  const _$TicketTransferImpl(
      {required this.id,
      required this.ticketId,
      required this.fromUserId,
      required this.toUserId,
      this.status = 'pending',
      this.message,
      this.transferredAt,
      this.expiresAt,
      this.createdAt,
      this.fromUserName,
      this.fromUserEmail,
      this.toUserName,
      this.toUserEmail,
      this.eventName,
      this.eventDate});

  factory _$TicketTransferImpl.fromJson(Map<String, dynamic> json) =>
      _$$TicketTransferImplFromJson(json);

  @override
  final String id;
  @override
  final String ticketId;
  @override
  final String fromUserId;
  @override
  final String toUserId;
  @override
  @JsonKey()
  final String status;
  @override
  final String? message;
  @override
  final DateTime? transferredAt;
  @override
  final DateTime? expiresAt;
  @override
  final DateTime? createdAt;
// Joined data
  @override
  final String? fromUserName;
  @override
  final String? fromUserEmail;
  @override
  final String? toUserName;
  @override
  final String? toUserEmail;
  @override
  final String? eventName;
  @override
  final String? eventDate;

  @override
  String toString() {
    return 'TicketTransfer(id: $id, ticketId: $ticketId, fromUserId: $fromUserId, toUserId: $toUserId, status: $status, message: $message, transferredAt: $transferredAt, expiresAt: $expiresAt, createdAt: $createdAt, fromUserName: $fromUserName, fromUserEmail: $fromUserEmail, toUserName: $toUserName, toUserEmail: $toUserEmail, eventName: $eventName, eventDate: $eventDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TicketTransferImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ticketId, ticketId) ||
                other.ticketId == ticketId) &&
            (identical(other.fromUserId, fromUserId) ||
                other.fromUserId == fromUserId) &&
            (identical(other.toUserId, toUserId) ||
                other.toUserId == toUserId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.transferredAt, transferredAt) ||
                other.transferredAt == transferredAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.fromUserName, fromUserName) ||
                other.fromUserName == fromUserName) &&
            (identical(other.fromUserEmail, fromUserEmail) ||
                other.fromUserEmail == fromUserEmail) &&
            (identical(other.toUserName, toUserName) ||
                other.toUserName == toUserName) &&
            (identical(other.toUserEmail, toUserEmail) ||
                other.toUserEmail == toUserEmail) &&
            (identical(other.eventName, eventName) ||
                other.eventName == eventName) &&
            (identical(other.eventDate, eventDate) ||
                other.eventDate == eventDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      ticketId,
      fromUserId,
      toUserId,
      status,
      message,
      transferredAt,
      expiresAt,
      createdAt,
      fromUserName,
      fromUserEmail,
      toUserName,
      toUserEmail,
      eventName,
      eventDate);

  /// Create a copy of TicketTransfer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TicketTransferImplCopyWith<_$TicketTransferImpl> get copyWith =>
      __$$TicketTransferImplCopyWithImpl<_$TicketTransferImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TicketTransferImplToJson(
      this,
    );
  }
}

abstract class _TicketTransfer implements TicketTransfer {
  const factory _TicketTransfer(
      {required final String id,
      required final String ticketId,
      required final String fromUserId,
      required final String toUserId,
      final String status,
      final String? message,
      final DateTime? transferredAt,
      final DateTime? expiresAt,
      final DateTime? createdAt,
      final String? fromUserName,
      final String? fromUserEmail,
      final String? toUserName,
      final String? toUserEmail,
      final String? eventName,
      final String? eventDate}) = _$TicketTransferImpl;

  factory _TicketTransfer.fromJson(Map<String, dynamic> json) =
      _$TicketTransferImpl.fromJson;

  @override
  String get id;
  @override
  String get ticketId;
  @override
  String get fromUserId;
  @override
  String get toUserId;
  @override
  String get status;
  @override
  String? get message;
  @override
  DateTime? get transferredAt;
  @override
  DateTime? get expiresAt;
  @override
  DateTime? get createdAt; // Joined data
  @override
  String? get fromUserName;
  @override
  String? get fromUserEmail;
  @override
  String? get toUserName;
  @override
  String? get toUserEmail;
  @override
  String? get eventName;
  @override
  String? get eventDate;

  /// Create a copy of TicketTransfer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TicketTransferImplCopyWith<_$TicketTransferImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
