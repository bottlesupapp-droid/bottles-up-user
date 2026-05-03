// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GroupBooking _$GroupBookingFromJson(Map<String, dynamic> json) {
  return _GroupBooking.fromJson(json);
}

/// @nodoc
mixin _$GroupBooking {
  String get id => throw _privateConstructorUsedError;
  String get organizerId => throw _privateConstructorUsedError;
  String get organizerName => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  String get eventName => throw _privateConstructorUsedError;
  int get maxMembers => throw _privateConstructorUsedError;
  int get currentMembers => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  double get amountPerPerson => throw _privateConstructorUsedError;
  GroupBookingStatus get status => throw _privateConstructorUsedError;
  DateTime? get confirmationDeadline => throw _privateConstructorUsedError;
  String? get specialRequests => throw _privateConstructorUsedError;
  List<GroupMember> get members => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this GroupBooking to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupBooking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupBookingCopyWith<GroupBooking> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupBookingCopyWith<$Res> {
  factory $GroupBookingCopyWith(
          GroupBooking value, $Res Function(GroupBooking) then) =
      _$GroupBookingCopyWithImpl<$Res, GroupBooking>;
  @useResult
  $Res call(
      {String id,
      String organizerId,
      String organizerName,
      String eventId,
      String eventName,
      int maxMembers,
      int currentMembers,
      double totalAmount,
      double amountPerPerson,
      GroupBookingStatus status,
      DateTime? confirmationDeadline,
      String? specialRequests,
      List<GroupMember> members,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$GroupBookingCopyWithImpl<$Res, $Val extends GroupBooking>
    implements $GroupBookingCopyWith<$Res> {
  _$GroupBookingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupBooking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizerId = null,
    Object? organizerName = null,
    Object? eventId = null,
    Object? eventName = null,
    Object? maxMembers = null,
    Object? currentMembers = null,
    Object? totalAmount = null,
    Object? amountPerPerson = null,
    Object? status = null,
    Object? confirmationDeadline = freezed,
    Object? specialRequests = freezed,
    Object? members = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      organizerId: null == organizerId
          ? _value.organizerId
          : organizerId // ignore: cast_nullable_to_non_nullable
              as String,
      organizerName: null == organizerName
          ? _value.organizerName
          : organizerName // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      eventName: null == eventName
          ? _value.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String,
      maxMembers: null == maxMembers
          ? _value.maxMembers
          : maxMembers // ignore: cast_nullable_to_non_nullable
              as int,
      currentMembers: null == currentMembers
          ? _value.currentMembers
          : currentMembers // ignore: cast_nullable_to_non_nullable
              as int,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      amountPerPerson: null == amountPerPerson
          ? _value.amountPerPerson
          : amountPerPerson // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as GroupBookingStatus,
      confirmationDeadline: freezed == confirmationDeadline
          ? _value.confirmationDeadline
          : confirmationDeadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      specialRequests: freezed == specialRequests
          ? _value.specialRequests
          : specialRequests // ignore: cast_nullable_to_non_nullable
              as String?,
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<GroupMember>,
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
abstract class _$$GroupBookingImplCopyWith<$Res>
    implements $GroupBookingCopyWith<$Res> {
  factory _$$GroupBookingImplCopyWith(
          _$GroupBookingImpl value, $Res Function(_$GroupBookingImpl) then) =
      __$$GroupBookingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String organizerId,
      String organizerName,
      String eventId,
      String eventName,
      int maxMembers,
      int currentMembers,
      double totalAmount,
      double amountPerPerson,
      GroupBookingStatus status,
      DateTime? confirmationDeadline,
      String? specialRequests,
      List<GroupMember> members,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$GroupBookingImplCopyWithImpl<$Res>
    extends _$GroupBookingCopyWithImpl<$Res, _$GroupBookingImpl>
    implements _$$GroupBookingImplCopyWith<$Res> {
  __$$GroupBookingImplCopyWithImpl(
      _$GroupBookingImpl _value, $Res Function(_$GroupBookingImpl) _then)
      : super(_value, _then);

  /// Create a copy of GroupBooking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizerId = null,
    Object? organizerName = null,
    Object? eventId = null,
    Object? eventName = null,
    Object? maxMembers = null,
    Object? currentMembers = null,
    Object? totalAmount = null,
    Object? amountPerPerson = null,
    Object? status = null,
    Object? confirmationDeadline = freezed,
    Object? specialRequests = freezed,
    Object? members = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$GroupBookingImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      organizerId: null == organizerId
          ? _value.organizerId
          : organizerId // ignore: cast_nullable_to_non_nullable
              as String,
      organizerName: null == organizerName
          ? _value.organizerName
          : organizerName // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      eventName: null == eventName
          ? _value.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String,
      maxMembers: null == maxMembers
          ? _value.maxMembers
          : maxMembers // ignore: cast_nullable_to_non_nullable
              as int,
      currentMembers: null == currentMembers
          ? _value.currentMembers
          : currentMembers // ignore: cast_nullable_to_non_nullable
              as int,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      amountPerPerson: null == amountPerPerson
          ? _value.amountPerPerson
          : amountPerPerson // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as GroupBookingStatus,
      confirmationDeadline: freezed == confirmationDeadline
          ? _value.confirmationDeadline
          : confirmationDeadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      specialRequests: freezed == specialRequests
          ? _value.specialRequests
          : specialRequests // ignore: cast_nullable_to_non_nullable
              as String?,
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<GroupMember>,
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
class _$GroupBookingImpl implements _GroupBooking {
  const _$GroupBookingImpl(
      {required this.id,
      required this.organizerId,
      required this.organizerName,
      required this.eventId,
      required this.eventName,
      required this.maxMembers,
      required this.currentMembers,
      required this.totalAmount,
      required this.amountPerPerson,
      this.status = GroupBookingStatus.pending,
      this.confirmationDeadline,
      this.specialRequests,
      final List<GroupMember> members = const [],
      required this.createdAt,
      this.updatedAt})
      : _members = members;

  factory _$GroupBookingImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupBookingImplFromJson(json);

  @override
  final String id;
  @override
  final String organizerId;
  @override
  final String organizerName;
  @override
  final String eventId;
  @override
  final String eventName;
  @override
  final int maxMembers;
  @override
  final int currentMembers;
  @override
  final double totalAmount;
  @override
  final double amountPerPerson;
  @override
  @JsonKey()
  final GroupBookingStatus status;
  @override
  final DateTime? confirmationDeadline;
  @override
  final String? specialRequests;
  final List<GroupMember> _members;
  @override
  @JsonKey()
  List<GroupMember> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'GroupBooking(id: $id, organizerId: $organizerId, organizerName: $organizerName, eventId: $eventId, eventName: $eventName, maxMembers: $maxMembers, currentMembers: $currentMembers, totalAmount: $totalAmount, amountPerPerson: $amountPerPerson, status: $status, confirmationDeadline: $confirmationDeadline, specialRequests: $specialRequests, members: $members, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupBookingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.organizerId, organizerId) ||
                other.organizerId == organizerId) &&
            (identical(other.organizerName, organizerName) ||
                other.organizerName == organizerName) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.eventName, eventName) ||
                other.eventName == eventName) &&
            (identical(other.maxMembers, maxMembers) ||
                other.maxMembers == maxMembers) &&
            (identical(other.currentMembers, currentMembers) ||
                other.currentMembers == currentMembers) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.amountPerPerson, amountPerPerson) ||
                other.amountPerPerson == amountPerPerson) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.confirmationDeadline, confirmationDeadline) ||
                other.confirmationDeadline == confirmationDeadline) &&
            (identical(other.specialRequests, specialRequests) ||
                other.specialRequests == specialRequests) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
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
      organizerId,
      organizerName,
      eventId,
      eventName,
      maxMembers,
      currentMembers,
      totalAmount,
      amountPerPerson,
      status,
      confirmationDeadline,
      specialRequests,
      const DeepCollectionEquality().hash(_members),
      createdAt,
      updatedAt);

  /// Create a copy of GroupBooking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupBookingImplCopyWith<_$GroupBookingImpl> get copyWith =>
      __$$GroupBookingImplCopyWithImpl<_$GroupBookingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupBookingImplToJson(
      this,
    );
  }
}

abstract class _GroupBooking implements GroupBooking {
  const factory _GroupBooking(
      {required final String id,
      required final String organizerId,
      required final String organizerName,
      required final String eventId,
      required final String eventName,
      required final int maxMembers,
      required final int currentMembers,
      required final double totalAmount,
      required final double amountPerPerson,
      final GroupBookingStatus status,
      final DateTime? confirmationDeadline,
      final String? specialRequests,
      final List<GroupMember> members,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$GroupBookingImpl;

  factory _GroupBooking.fromJson(Map<String, dynamic> json) =
      _$GroupBookingImpl.fromJson;

  @override
  String get id;
  @override
  String get organizerId;
  @override
  String get organizerName;
  @override
  String get eventId;
  @override
  String get eventName;
  @override
  int get maxMembers;
  @override
  int get currentMembers;
  @override
  double get totalAmount;
  @override
  double get amountPerPerson;
  @override
  GroupBookingStatus get status;
  @override
  DateTime? get confirmationDeadline;
  @override
  String? get specialRequests;
  @override
  List<GroupMember> get members;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of GroupBooking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupBookingImplCopyWith<_$GroupBookingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GroupMember _$GroupMemberFromJson(Map<String, dynamic> json) {
  return _GroupMember.fromJson(json);
}

/// @nodoc
mixin _$GroupMember {
  String get id => throw _privateConstructorUsedError;
  String get groupBookingId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String? get userEmail => throw _privateConstructorUsedError;
  String? get userPhone => throw _privateConstructorUsedError;
  double get amountOwed => throw _privateConstructorUsedError;
  double? get amountPaid => throw _privateConstructorUsedError;
  MemberStatus get status => throw _privateConstructorUsedError;
  DateTime? get invitedAt => throw _privateConstructorUsedError;
  DateTime? get respondedAt => throw _privateConstructorUsedError;
  DateTime? get paidAt => throw _privateConstructorUsedError;
  String? get paymentIntentId => throw _privateConstructorUsedError;

  /// Serializes this GroupMember to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupMemberCopyWith<GroupMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupMemberCopyWith<$Res> {
  factory $GroupMemberCopyWith(
          GroupMember value, $Res Function(GroupMember) then) =
      _$GroupMemberCopyWithImpl<$Res, GroupMember>;
  @useResult
  $Res call(
      {String id,
      String groupBookingId,
      String userId,
      String userName,
      String? userEmail,
      String? userPhone,
      double amountOwed,
      double? amountPaid,
      MemberStatus status,
      DateTime? invitedAt,
      DateTime? respondedAt,
      DateTime? paidAt,
      String? paymentIntentId});
}

/// @nodoc
class _$GroupMemberCopyWithImpl<$Res, $Val extends GroupMember>
    implements $GroupMemberCopyWith<$Res> {
  _$GroupMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? groupBookingId = null,
    Object? userId = null,
    Object? userName = null,
    Object? userEmail = freezed,
    Object? userPhone = freezed,
    Object? amountOwed = null,
    Object? amountPaid = freezed,
    Object? status = null,
    Object? invitedAt = freezed,
    Object? respondedAt = freezed,
    Object? paidAt = freezed,
    Object? paymentIntentId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      groupBookingId: null == groupBookingId
          ? _value.groupBookingId
          : groupBookingId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userEmail: freezed == userEmail
          ? _value.userEmail
          : userEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      userPhone: freezed == userPhone
          ? _value.userPhone
          : userPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      amountOwed: null == amountOwed
          ? _value.amountOwed
          : amountOwed // ignore: cast_nullable_to_non_nullable
              as double,
      amountPaid: freezed == amountPaid
          ? _value.amountPaid
          : amountPaid // ignore: cast_nullable_to_non_nullable
              as double?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MemberStatus,
      invitedAt: freezed == invitedAt
          ? _value.invitedAt
          : invitedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      paymentIntentId: freezed == paymentIntentId
          ? _value.paymentIntentId
          : paymentIntentId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GroupMemberImplCopyWith<$Res>
    implements $GroupMemberCopyWith<$Res> {
  factory _$$GroupMemberImplCopyWith(
          _$GroupMemberImpl value, $Res Function(_$GroupMemberImpl) then) =
      __$$GroupMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String groupBookingId,
      String userId,
      String userName,
      String? userEmail,
      String? userPhone,
      double amountOwed,
      double? amountPaid,
      MemberStatus status,
      DateTime? invitedAt,
      DateTime? respondedAt,
      DateTime? paidAt,
      String? paymentIntentId});
}

/// @nodoc
class __$$GroupMemberImplCopyWithImpl<$Res>
    extends _$GroupMemberCopyWithImpl<$Res, _$GroupMemberImpl>
    implements _$$GroupMemberImplCopyWith<$Res> {
  __$$GroupMemberImplCopyWithImpl(
      _$GroupMemberImpl _value, $Res Function(_$GroupMemberImpl) _then)
      : super(_value, _then);

  /// Create a copy of GroupMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? groupBookingId = null,
    Object? userId = null,
    Object? userName = null,
    Object? userEmail = freezed,
    Object? userPhone = freezed,
    Object? amountOwed = null,
    Object? amountPaid = freezed,
    Object? status = null,
    Object? invitedAt = freezed,
    Object? respondedAt = freezed,
    Object? paidAt = freezed,
    Object? paymentIntentId = freezed,
  }) {
    return _then(_$GroupMemberImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      groupBookingId: null == groupBookingId
          ? _value.groupBookingId
          : groupBookingId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userEmail: freezed == userEmail
          ? _value.userEmail
          : userEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      userPhone: freezed == userPhone
          ? _value.userPhone
          : userPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      amountOwed: null == amountOwed
          ? _value.amountOwed
          : amountOwed // ignore: cast_nullable_to_non_nullable
              as double,
      amountPaid: freezed == amountPaid
          ? _value.amountPaid
          : amountPaid // ignore: cast_nullable_to_non_nullable
              as double?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MemberStatus,
      invitedAt: freezed == invitedAt
          ? _value.invitedAt
          : invitedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      paymentIntentId: freezed == paymentIntentId
          ? _value.paymentIntentId
          : paymentIntentId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupMemberImpl implements _GroupMember {
  const _$GroupMemberImpl(
      {required this.id,
      required this.groupBookingId,
      required this.userId,
      required this.userName,
      this.userEmail,
      this.userPhone,
      required this.amountOwed,
      this.amountPaid,
      this.status = MemberStatus.invited,
      this.invitedAt,
      this.respondedAt,
      this.paidAt,
      this.paymentIntentId});

  factory _$GroupMemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupMemberImplFromJson(json);

  @override
  final String id;
  @override
  final String groupBookingId;
  @override
  final String userId;
  @override
  final String userName;
  @override
  final String? userEmail;
  @override
  final String? userPhone;
  @override
  final double amountOwed;
  @override
  final double? amountPaid;
  @override
  @JsonKey()
  final MemberStatus status;
  @override
  final DateTime? invitedAt;
  @override
  final DateTime? respondedAt;
  @override
  final DateTime? paidAt;
  @override
  final String? paymentIntentId;

  @override
  String toString() {
    return 'GroupMember(id: $id, groupBookingId: $groupBookingId, userId: $userId, userName: $userName, userEmail: $userEmail, userPhone: $userPhone, amountOwed: $amountOwed, amountPaid: $amountPaid, status: $status, invitedAt: $invitedAt, respondedAt: $respondedAt, paidAt: $paidAt, paymentIntentId: $paymentIntentId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupMemberImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.groupBookingId, groupBookingId) ||
                other.groupBookingId == groupBookingId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userEmail, userEmail) ||
                other.userEmail == userEmail) &&
            (identical(other.userPhone, userPhone) ||
                other.userPhone == userPhone) &&
            (identical(other.amountOwed, amountOwed) ||
                other.amountOwed == amountOwed) &&
            (identical(other.amountPaid, amountPaid) ||
                other.amountPaid == amountPaid) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.invitedAt, invitedAt) ||
                other.invitedAt == invitedAt) &&
            (identical(other.respondedAt, respondedAt) ||
                other.respondedAt == respondedAt) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            (identical(other.paymentIntentId, paymentIntentId) ||
                other.paymentIntentId == paymentIntentId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      groupBookingId,
      userId,
      userName,
      userEmail,
      userPhone,
      amountOwed,
      amountPaid,
      status,
      invitedAt,
      respondedAt,
      paidAt,
      paymentIntentId);

  /// Create a copy of GroupMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupMemberImplCopyWith<_$GroupMemberImpl> get copyWith =>
      __$$GroupMemberImplCopyWithImpl<_$GroupMemberImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupMemberImplToJson(
      this,
    );
  }
}

abstract class _GroupMember implements GroupMember {
  const factory _GroupMember(
      {required final String id,
      required final String groupBookingId,
      required final String userId,
      required final String userName,
      final String? userEmail,
      final String? userPhone,
      required final double amountOwed,
      final double? amountPaid,
      final MemberStatus status,
      final DateTime? invitedAt,
      final DateTime? respondedAt,
      final DateTime? paidAt,
      final String? paymentIntentId}) = _$GroupMemberImpl;

  factory _GroupMember.fromJson(Map<String, dynamic> json) =
      _$GroupMemberImpl.fromJson;

  @override
  String get id;
  @override
  String get groupBookingId;
  @override
  String get userId;
  @override
  String get userName;
  @override
  String? get userEmail;
  @override
  String? get userPhone;
  @override
  double get amountOwed;
  @override
  double? get amountPaid;
  @override
  MemberStatus get status;
  @override
  DateTime? get invitedAt;
  @override
  DateTime? get respondedAt;
  @override
  DateTime? get paidAt;
  @override
  String? get paymentIntentId;

  /// Create a copy of GroupMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupMemberImplCopyWith<_$GroupMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GroupInvite _$GroupInviteFromJson(Map<String, dynamic> json) {
  return _GroupInvite.fromJson(json);
}

/// @nodoc
mixin _$GroupInvite {
  String get id => throw _privateConstructorUsedError;
  String get groupBookingId => throw _privateConstructorUsedError;
  String get invitedByUserId => throw _privateConstructorUsedError;
  String get invitedByName => throw _privateConstructorUsedError;
  String? get recipientUserId => throw _privateConstructorUsedError;
  String? get recipientEmail => throw _privateConstructorUsedError;
  String? get recipientPhone => throw _privateConstructorUsedError;
  String get inviteToken => throw _privateConstructorUsedError;
  bool get isAccepted => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  DateTime? get acceptedAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this GroupInvite to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupInvite
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupInviteCopyWith<GroupInvite> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupInviteCopyWith<$Res> {
  factory $GroupInviteCopyWith(
          GroupInvite value, $Res Function(GroupInvite) then) =
      _$GroupInviteCopyWithImpl<$Res, GroupInvite>;
  @useResult
  $Res call(
      {String id,
      String groupBookingId,
      String invitedByUserId,
      String invitedByName,
      String? recipientUserId,
      String? recipientEmail,
      String? recipientPhone,
      String inviteToken,
      bool isAccepted,
      DateTime? expiresAt,
      DateTime? acceptedAt,
      DateTime createdAt});
}

/// @nodoc
class _$GroupInviteCopyWithImpl<$Res, $Val extends GroupInvite>
    implements $GroupInviteCopyWith<$Res> {
  _$GroupInviteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupInvite
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? groupBookingId = null,
    Object? invitedByUserId = null,
    Object? invitedByName = null,
    Object? recipientUserId = freezed,
    Object? recipientEmail = freezed,
    Object? recipientPhone = freezed,
    Object? inviteToken = null,
    Object? isAccepted = null,
    Object? expiresAt = freezed,
    Object? acceptedAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      groupBookingId: null == groupBookingId
          ? _value.groupBookingId
          : groupBookingId // ignore: cast_nullable_to_non_nullable
              as String,
      invitedByUserId: null == invitedByUserId
          ? _value.invitedByUserId
          : invitedByUserId // ignore: cast_nullable_to_non_nullable
              as String,
      invitedByName: null == invitedByName
          ? _value.invitedByName
          : invitedByName // ignore: cast_nullable_to_non_nullable
              as String,
      recipientUserId: freezed == recipientUserId
          ? _value.recipientUserId
          : recipientUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      recipientEmail: freezed == recipientEmail
          ? _value.recipientEmail
          : recipientEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      recipientPhone: freezed == recipientPhone
          ? _value.recipientPhone
          : recipientPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      inviteToken: null == inviteToken
          ? _value.inviteToken
          : inviteToken // ignore: cast_nullable_to_non_nullable
              as String,
      isAccepted: null == isAccepted
          ? _value.isAccepted
          : isAccepted // ignore: cast_nullable_to_non_nullable
              as bool,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      acceptedAt: freezed == acceptedAt
          ? _value.acceptedAt
          : acceptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GroupInviteImplCopyWith<$Res>
    implements $GroupInviteCopyWith<$Res> {
  factory _$$GroupInviteImplCopyWith(
          _$GroupInviteImpl value, $Res Function(_$GroupInviteImpl) then) =
      __$$GroupInviteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String groupBookingId,
      String invitedByUserId,
      String invitedByName,
      String? recipientUserId,
      String? recipientEmail,
      String? recipientPhone,
      String inviteToken,
      bool isAccepted,
      DateTime? expiresAt,
      DateTime? acceptedAt,
      DateTime createdAt});
}

/// @nodoc
class __$$GroupInviteImplCopyWithImpl<$Res>
    extends _$GroupInviteCopyWithImpl<$Res, _$GroupInviteImpl>
    implements _$$GroupInviteImplCopyWith<$Res> {
  __$$GroupInviteImplCopyWithImpl(
      _$GroupInviteImpl _value, $Res Function(_$GroupInviteImpl) _then)
      : super(_value, _then);

  /// Create a copy of GroupInvite
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? groupBookingId = null,
    Object? invitedByUserId = null,
    Object? invitedByName = null,
    Object? recipientUserId = freezed,
    Object? recipientEmail = freezed,
    Object? recipientPhone = freezed,
    Object? inviteToken = null,
    Object? isAccepted = null,
    Object? expiresAt = freezed,
    Object? acceptedAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$GroupInviteImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      groupBookingId: null == groupBookingId
          ? _value.groupBookingId
          : groupBookingId // ignore: cast_nullable_to_non_nullable
              as String,
      invitedByUserId: null == invitedByUserId
          ? _value.invitedByUserId
          : invitedByUserId // ignore: cast_nullable_to_non_nullable
              as String,
      invitedByName: null == invitedByName
          ? _value.invitedByName
          : invitedByName // ignore: cast_nullable_to_non_nullable
              as String,
      recipientUserId: freezed == recipientUserId
          ? _value.recipientUserId
          : recipientUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      recipientEmail: freezed == recipientEmail
          ? _value.recipientEmail
          : recipientEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      recipientPhone: freezed == recipientPhone
          ? _value.recipientPhone
          : recipientPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      inviteToken: null == inviteToken
          ? _value.inviteToken
          : inviteToken // ignore: cast_nullable_to_non_nullable
              as String,
      isAccepted: null == isAccepted
          ? _value.isAccepted
          : isAccepted // ignore: cast_nullable_to_non_nullable
              as bool,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      acceptedAt: freezed == acceptedAt
          ? _value.acceptedAt
          : acceptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupInviteImpl implements _GroupInvite {
  const _$GroupInviteImpl(
      {required this.id,
      required this.groupBookingId,
      required this.invitedByUserId,
      required this.invitedByName,
      this.recipientUserId,
      this.recipientEmail,
      this.recipientPhone,
      required this.inviteToken,
      this.isAccepted = false,
      this.expiresAt,
      this.acceptedAt,
      required this.createdAt});

  factory _$GroupInviteImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupInviteImplFromJson(json);

  @override
  final String id;
  @override
  final String groupBookingId;
  @override
  final String invitedByUserId;
  @override
  final String invitedByName;
  @override
  final String? recipientUserId;
  @override
  final String? recipientEmail;
  @override
  final String? recipientPhone;
  @override
  final String inviteToken;
  @override
  @JsonKey()
  final bool isAccepted;
  @override
  final DateTime? expiresAt;
  @override
  final DateTime? acceptedAt;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'GroupInvite(id: $id, groupBookingId: $groupBookingId, invitedByUserId: $invitedByUserId, invitedByName: $invitedByName, recipientUserId: $recipientUserId, recipientEmail: $recipientEmail, recipientPhone: $recipientPhone, inviteToken: $inviteToken, isAccepted: $isAccepted, expiresAt: $expiresAt, acceptedAt: $acceptedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupInviteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.groupBookingId, groupBookingId) ||
                other.groupBookingId == groupBookingId) &&
            (identical(other.invitedByUserId, invitedByUserId) ||
                other.invitedByUserId == invitedByUserId) &&
            (identical(other.invitedByName, invitedByName) ||
                other.invitedByName == invitedByName) &&
            (identical(other.recipientUserId, recipientUserId) ||
                other.recipientUserId == recipientUserId) &&
            (identical(other.recipientEmail, recipientEmail) ||
                other.recipientEmail == recipientEmail) &&
            (identical(other.recipientPhone, recipientPhone) ||
                other.recipientPhone == recipientPhone) &&
            (identical(other.inviteToken, inviteToken) ||
                other.inviteToken == inviteToken) &&
            (identical(other.isAccepted, isAccepted) ||
                other.isAccepted == isAccepted) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.acceptedAt, acceptedAt) ||
                other.acceptedAt == acceptedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      groupBookingId,
      invitedByUserId,
      invitedByName,
      recipientUserId,
      recipientEmail,
      recipientPhone,
      inviteToken,
      isAccepted,
      expiresAt,
      acceptedAt,
      createdAt);

  /// Create a copy of GroupInvite
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupInviteImplCopyWith<_$GroupInviteImpl> get copyWith =>
      __$$GroupInviteImplCopyWithImpl<_$GroupInviteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupInviteImplToJson(
      this,
    );
  }
}

abstract class _GroupInvite implements GroupInvite {
  const factory _GroupInvite(
      {required final String id,
      required final String groupBookingId,
      required final String invitedByUserId,
      required final String invitedByName,
      final String? recipientUserId,
      final String? recipientEmail,
      final String? recipientPhone,
      required final String inviteToken,
      final bool isAccepted,
      final DateTime? expiresAt,
      final DateTime? acceptedAt,
      required final DateTime createdAt}) = _$GroupInviteImpl;

  factory _GroupInvite.fromJson(Map<String, dynamic> json) =
      _$GroupInviteImpl.fromJson;

  @override
  String get id;
  @override
  String get groupBookingId;
  @override
  String get invitedByUserId;
  @override
  String get invitedByName;
  @override
  String? get recipientUserId;
  @override
  String? get recipientEmail;
  @override
  String? get recipientPhone;
  @override
  String get inviteToken;
  @override
  bool get isAccepted;
  @override
  DateTime? get expiresAt;
  @override
  DateTime? get acceptedAt;
  @override
  DateTime get createdAt;

  /// Create a copy of GroupInvite
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupInviteImplCopyWith<_$GroupInviteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
