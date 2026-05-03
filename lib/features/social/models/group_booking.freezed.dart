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
  String? get organizerAvatar => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  GroupBookingStatus get status => throw _privateConstructorUsedError;
  String? get venueId => throw _privateConstructorUsedError;
  String? get venueName => throw _privateConstructorUsedError;
  String? get eventId => throw _privateConstructorUsedError;
  String? get eventName => throw _privateConstructorUsedError;
  DateTime? get proposedDate => throw _privateConstructorUsedError;
  List<GroupMember> get members => throw _privateConstructorUsedError;
  List<VenueProposal> get venueProposals => throw _privateConstructorUsedError;
  DateTime? get votingDeadline => throw _privateConstructorUsedError;
  Map<String, dynamic>? get bookingDetails =>
      throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get confirmedAt => throw _privateConstructorUsedError;

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
      String? organizerAvatar,
      String name,
      String? description,
      GroupBookingStatus status,
      String? venueId,
      String? venueName,
      String? eventId,
      String? eventName,
      DateTime? proposedDate,
      List<GroupMember> members,
      List<VenueProposal> venueProposals,
      DateTime? votingDeadline,
      Map<String, dynamic>? bookingDetails,
      DateTime createdAt,
      DateTime? confirmedAt});
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
    Object? organizerAvatar = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? status = null,
    Object? venueId = freezed,
    Object? venueName = freezed,
    Object? eventId = freezed,
    Object? eventName = freezed,
    Object? proposedDate = freezed,
    Object? members = null,
    Object? venueProposals = null,
    Object? votingDeadline = freezed,
    Object? bookingDetails = freezed,
    Object? createdAt = null,
    Object? confirmedAt = freezed,
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
      organizerAvatar: freezed == organizerAvatar
          ? _value.organizerAvatar
          : organizerAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as GroupBookingStatus,
      venueId: freezed == venueId
          ? _value.venueId
          : venueId // ignore: cast_nullable_to_non_nullable
              as String?,
      venueName: freezed == venueName
          ? _value.venueName
          : venueName // ignore: cast_nullable_to_non_nullable
              as String?,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String?,
      eventName: freezed == eventName
          ? _value.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String?,
      proposedDate: freezed == proposedDate
          ? _value.proposedDate
          : proposedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<GroupMember>,
      venueProposals: null == venueProposals
          ? _value.venueProposals
          : venueProposals // ignore: cast_nullable_to_non_nullable
              as List<VenueProposal>,
      votingDeadline: freezed == votingDeadline
          ? _value.votingDeadline
          : votingDeadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      bookingDetails: freezed == bookingDetails
          ? _value.bookingDetails
          : bookingDetails // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      confirmedAt: freezed == confirmedAt
          ? _value.confirmedAt
          : confirmedAt // ignore: cast_nullable_to_non_nullable
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
      String? organizerAvatar,
      String name,
      String? description,
      GroupBookingStatus status,
      String? venueId,
      String? venueName,
      String? eventId,
      String? eventName,
      DateTime? proposedDate,
      List<GroupMember> members,
      List<VenueProposal> venueProposals,
      DateTime? votingDeadline,
      Map<String, dynamic>? bookingDetails,
      DateTime createdAt,
      DateTime? confirmedAt});
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
    Object? organizerAvatar = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? status = null,
    Object? venueId = freezed,
    Object? venueName = freezed,
    Object? eventId = freezed,
    Object? eventName = freezed,
    Object? proposedDate = freezed,
    Object? members = null,
    Object? venueProposals = null,
    Object? votingDeadline = freezed,
    Object? bookingDetails = freezed,
    Object? createdAt = null,
    Object? confirmedAt = freezed,
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
      organizerAvatar: freezed == organizerAvatar
          ? _value.organizerAvatar
          : organizerAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as GroupBookingStatus,
      venueId: freezed == venueId
          ? _value.venueId
          : venueId // ignore: cast_nullable_to_non_nullable
              as String?,
      venueName: freezed == venueName
          ? _value.venueName
          : venueName // ignore: cast_nullable_to_non_nullable
              as String?,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String?,
      eventName: freezed == eventName
          ? _value.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String?,
      proposedDate: freezed == proposedDate
          ? _value.proposedDate
          : proposedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<GroupMember>,
      venueProposals: null == venueProposals
          ? _value._venueProposals
          : venueProposals // ignore: cast_nullable_to_non_nullable
              as List<VenueProposal>,
      votingDeadline: freezed == votingDeadline
          ? _value.votingDeadline
          : votingDeadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      bookingDetails: freezed == bookingDetails
          ? _value._bookingDetails
          : bookingDetails // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      confirmedAt: freezed == confirmedAt
          ? _value.confirmedAt
          : confirmedAt // ignore: cast_nullable_to_non_nullable
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
      this.organizerAvatar,
      required this.name,
      this.description,
      required this.status,
      this.venueId,
      this.venueName,
      this.eventId,
      this.eventName,
      this.proposedDate,
      final List<GroupMember> members = const [],
      final List<VenueProposal> venueProposals = const [],
      this.votingDeadline,
      final Map<String, dynamic>? bookingDetails,
      required this.createdAt,
      this.confirmedAt})
      : _members = members,
        _venueProposals = venueProposals,
        _bookingDetails = bookingDetails;

  factory _$GroupBookingImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupBookingImplFromJson(json);

  @override
  final String id;
  @override
  final String organizerId;
  @override
  final String organizerName;
  @override
  final String? organizerAvatar;
  @override
  final String name;
  @override
  final String? description;
  @override
  final GroupBookingStatus status;
  @override
  final String? venueId;
  @override
  final String? venueName;
  @override
  final String? eventId;
  @override
  final String? eventName;
  @override
  final DateTime? proposedDate;
  final List<GroupMember> _members;
  @override
  @JsonKey()
  List<GroupMember> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  final List<VenueProposal> _venueProposals;
  @override
  @JsonKey()
  List<VenueProposal> get venueProposals {
    if (_venueProposals is EqualUnmodifiableListView) return _venueProposals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_venueProposals);
  }

  @override
  final DateTime? votingDeadline;
  final Map<String, dynamic>? _bookingDetails;
  @override
  Map<String, dynamic>? get bookingDetails {
    final value = _bookingDetails;
    if (value == null) return null;
    if (_bookingDetails is EqualUnmodifiableMapView) return _bookingDetails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime? confirmedAt;

  @override
  String toString() {
    return 'GroupBooking(id: $id, organizerId: $organizerId, organizerName: $organizerName, organizerAvatar: $organizerAvatar, name: $name, description: $description, status: $status, venueId: $venueId, venueName: $venueName, eventId: $eventId, eventName: $eventName, proposedDate: $proposedDate, members: $members, venueProposals: $venueProposals, votingDeadline: $votingDeadline, bookingDetails: $bookingDetails, createdAt: $createdAt, confirmedAt: $confirmedAt)';
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
            (identical(other.organizerAvatar, organizerAvatar) ||
                other.organizerAvatar == organizerAvatar) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.venueId, venueId) || other.venueId == venueId) &&
            (identical(other.venueName, venueName) ||
                other.venueName == venueName) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.eventName, eventName) ||
                other.eventName == eventName) &&
            (identical(other.proposedDate, proposedDate) ||
                other.proposedDate == proposedDate) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            const DeepCollectionEquality()
                .equals(other._venueProposals, _venueProposals) &&
            (identical(other.votingDeadline, votingDeadline) ||
                other.votingDeadline == votingDeadline) &&
            const DeepCollectionEquality()
                .equals(other._bookingDetails, _bookingDetails) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.confirmedAt, confirmedAt) ||
                other.confirmedAt == confirmedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      organizerId,
      organizerName,
      organizerAvatar,
      name,
      description,
      status,
      venueId,
      venueName,
      eventId,
      eventName,
      proposedDate,
      const DeepCollectionEquality().hash(_members),
      const DeepCollectionEquality().hash(_venueProposals),
      votingDeadline,
      const DeepCollectionEquality().hash(_bookingDetails),
      createdAt,
      confirmedAt);

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
      final String? organizerAvatar,
      required final String name,
      final String? description,
      required final GroupBookingStatus status,
      final String? venueId,
      final String? venueName,
      final String? eventId,
      final String? eventName,
      final DateTime? proposedDate,
      final List<GroupMember> members,
      final List<VenueProposal> venueProposals,
      final DateTime? votingDeadline,
      final Map<String, dynamic>? bookingDetails,
      required final DateTime createdAt,
      final DateTime? confirmedAt}) = _$GroupBookingImpl;

  factory _GroupBooking.fromJson(Map<String, dynamic> json) =
      _$GroupBookingImpl.fromJson;

  @override
  String get id;
  @override
  String get organizerId;
  @override
  String get organizerName;
  @override
  String? get organizerAvatar;
  @override
  String get name;
  @override
  String? get description;
  @override
  GroupBookingStatus get status;
  @override
  String? get venueId;
  @override
  String? get venueName;
  @override
  String? get eventId;
  @override
  String? get eventName;
  @override
  DateTime? get proposedDate;
  @override
  List<GroupMember> get members;
  @override
  List<VenueProposal> get venueProposals;
  @override
  DateTime? get votingDeadline;
  @override
  Map<String, dynamic>? get bookingDetails;
  @override
  DateTime get createdAt;
  @override
  DateTime? get confirmedAt;

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
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String? get userAvatar => throw _privateConstructorUsedError;
  String? get userEmail => throw _privateConstructorUsedError;
  InvitationResponse get response => throw _privateConstructorUsedError;
  DateTime get invitedAt => throw _privateConstructorUsedError;
  DateTime? get respondedAt => throw _privateConstructorUsedError;
  bool get isOrganizer => throw _privateConstructorUsedError;
  Map<String, dynamic>? get preferences => throw _privateConstructorUsedError;

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
      String userId,
      String userName,
      String? userAvatar,
      String? userEmail,
      InvitationResponse response,
      DateTime invitedAt,
      DateTime? respondedAt,
      bool isOrganizer,
      Map<String, dynamic>? preferences});
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
    Object? userId = null,
    Object? userName = null,
    Object? userAvatar = freezed,
    Object? userEmail = freezed,
    Object? response = null,
    Object? invitedAt = null,
    Object? respondedAt = freezed,
    Object? isOrganizer = null,
    Object? preferences = freezed,
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
      userEmail: freezed == userEmail
          ? _value.userEmail
          : userEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      response: null == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as InvitationResponse,
      invitedAt: null == invitedAt
          ? _value.invitedAt
          : invitedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isOrganizer: null == isOrganizer
          ? _value.isOrganizer
          : isOrganizer // ignore: cast_nullable_to_non_nullable
              as bool,
      preferences: freezed == preferences
          ? _value.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
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
      String userId,
      String userName,
      String? userAvatar,
      String? userEmail,
      InvitationResponse response,
      DateTime invitedAt,
      DateTime? respondedAt,
      bool isOrganizer,
      Map<String, dynamic>? preferences});
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
    Object? userId = null,
    Object? userName = null,
    Object? userAvatar = freezed,
    Object? userEmail = freezed,
    Object? response = null,
    Object? invitedAt = null,
    Object? respondedAt = freezed,
    Object? isOrganizer = null,
    Object? preferences = freezed,
  }) {
    return _then(_$GroupMemberImpl(
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
      userEmail: freezed == userEmail
          ? _value.userEmail
          : userEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      response: null == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as InvitationResponse,
      invitedAt: null == invitedAt
          ? _value.invitedAt
          : invitedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isOrganizer: null == isOrganizer
          ? _value.isOrganizer
          : isOrganizer // ignore: cast_nullable_to_non_nullable
              as bool,
      preferences: freezed == preferences
          ? _value._preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupMemberImpl implements _GroupMember {
  const _$GroupMemberImpl(
      {required this.id,
      required this.userId,
      required this.userName,
      this.userAvatar,
      this.userEmail,
      this.response = InvitationResponse.pending,
      required this.invitedAt,
      this.respondedAt,
      this.isOrganizer = false,
      final Map<String, dynamic>? preferences})
      : _preferences = preferences;

  factory _$GroupMemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupMemberImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String userName;
  @override
  final String? userAvatar;
  @override
  final String? userEmail;
  @override
  @JsonKey()
  final InvitationResponse response;
  @override
  final DateTime invitedAt;
  @override
  final DateTime? respondedAt;
  @override
  @JsonKey()
  final bool isOrganizer;
  final Map<String, dynamic>? _preferences;
  @override
  Map<String, dynamic>? get preferences {
    final value = _preferences;
    if (value == null) return null;
    if (_preferences is EqualUnmodifiableMapView) return _preferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'GroupMember(id: $id, userId: $userId, userName: $userName, userAvatar: $userAvatar, userEmail: $userEmail, response: $response, invitedAt: $invitedAt, respondedAt: $respondedAt, isOrganizer: $isOrganizer, preferences: $preferences)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupMemberImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userAvatar, userAvatar) ||
                other.userAvatar == userAvatar) &&
            (identical(other.userEmail, userEmail) ||
                other.userEmail == userEmail) &&
            (identical(other.response, response) ||
                other.response == response) &&
            (identical(other.invitedAt, invitedAt) ||
                other.invitedAt == invitedAt) &&
            (identical(other.respondedAt, respondedAt) ||
                other.respondedAt == respondedAt) &&
            (identical(other.isOrganizer, isOrganizer) ||
                other.isOrganizer == isOrganizer) &&
            const DeepCollectionEquality()
                .equals(other._preferences, _preferences));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      userName,
      userAvatar,
      userEmail,
      response,
      invitedAt,
      respondedAt,
      isOrganizer,
      const DeepCollectionEquality().hash(_preferences));

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
      required final String userId,
      required final String userName,
      final String? userAvatar,
      final String? userEmail,
      final InvitationResponse response,
      required final DateTime invitedAt,
      final DateTime? respondedAt,
      final bool isOrganizer,
      final Map<String, dynamic>? preferences}) = _$GroupMemberImpl;

  factory _GroupMember.fromJson(Map<String, dynamic> json) =
      _$GroupMemberImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get userName;
  @override
  String? get userAvatar;
  @override
  String? get userEmail;
  @override
  InvitationResponse get response;
  @override
  DateTime get invitedAt;
  @override
  DateTime? get respondedAt;
  @override
  bool get isOrganizer;
  @override
  Map<String, dynamic>? get preferences;

  /// Create a copy of GroupMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupMemberImplCopyWith<_$GroupMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VenueProposal _$VenueProposalFromJson(Map<String, dynamic> json) {
  return _VenueProposal.fromJson(json);
}

/// @nodoc
mixin _$VenueProposal {
  String get id => throw _privateConstructorUsedError;
  String get venueId => throw _privateConstructorUsedError;
  String get venueName => throw _privateConstructorUsedError;
  String? get venueImage => throw _privateConstructorUsedError;
  String get proposedBy => throw _privateConstructorUsedError;
  String get proposerName => throw _privateConstructorUsedError;
  String? get proposerAvatar => throw _privateConstructorUsedError;
  DateTime? get proposedDate => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  List<VenueVote> get votes => throw _privateConstructorUsedError;
  int get upvotes => throw _privateConstructorUsedError;
  int get downvotes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this VenueProposal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VenueProposal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VenueProposalCopyWith<VenueProposal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VenueProposalCopyWith<$Res> {
  factory $VenueProposalCopyWith(
          VenueProposal value, $Res Function(VenueProposal) then) =
      _$VenueProposalCopyWithImpl<$Res, VenueProposal>;
  @useResult
  $Res call(
      {String id,
      String venueId,
      String venueName,
      String? venueImage,
      String proposedBy,
      String proposerName,
      String? proposerAvatar,
      DateTime? proposedDate,
      String? notes,
      List<VenueVote> votes,
      int upvotes,
      int downvotes,
      DateTime createdAt});
}

/// @nodoc
class _$VenueProposalCopyWithImpl<$Res, $Val extends VenueProposal>
    implements $VenueProposalCopyWith<$Res> {
  _$VenueProposalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VenueProposal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? venueId = null,
    Object? venueName = null,
    Object? venueImage = freezed,
    Object? proposedBy = null,
    Object? proposerName = null,
    Object? proposerAvatar = freezed,
    Object? proposedDate = freezed,
    Object? notes = freezed,
    Object? votes = null,
    Object? upvotes = null,
    Object? downvotes = null,
    Object? createdAt = null,
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
      venueName: null == venueName
          ? _value.venueName
          : venueName // ignore: cast_nullable_to_non_nullable
              as String,
      venueImage: freezed == venueImage
          ? _value.venueImage
          : venueImage // ignore: cast_nullable_to_non_nullable
              as String?,
      proposedBy: null == proposedBy
          ? _value.proposedBy
          : proposedBy // ignore: cast_nullable_to_non_nullable
              as String,
      proposerName: null == proposerName
          ? _value.proposerName
          : proposerName // ignore: cast_nullable_to_non_nullable
              as String,
      proposerAvatar: freezed == proposerAvatar
          ? _value.proposerAvatar
          : proposerAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      proposedDate: freezed == proposedDate
          ? _value.proposedDate
          : proposedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      votes: null == votes
          ? _value.votes
          : votes // ignore: cast_nullable_to_non_nullable
              as List<VenueVote>,
      upvotes: null == upvotes
          ? _value.upvotes
          : upvotes // ignore: cast_nullable_to_non_nullable
              as int,
      downvotes: null == downvotes
          ? _value.downvotes
          : downvotes // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VenueProposalImplCopyWith<$Res>
    implements $VenueProposalCopyWith<$Res> {
  factory _$$VenueProposalImplCopyWith(
          _$VenueProposalImpl value, $Res Function(_$VenueProposalImpl) then) =
      __$$VenueProposalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String venueId,
      String venueName,
      String? venueImage,
      String proposedBy,
      String proposerName,
      String? proposerAvatar,
      DateTime? proposedDate,
      String? notes,
      List<VenueVote> votes,
      int upvotes,
      int downvotes,
      DateTime createdAt});
}

/// @nodoc
class __$$VenueProposalImplCopyWithImpl<$Res>
    extends _$VenueProposalCopyWithImpl<$Res, _$VenueProposalImpl>
    implements _$$VenueProposalImplCopyWith<$Res> {
  __$$VenueProposalImplCopyWithImpl(
      _$VenueProposalImpl _value, $Res Function(_$VenueProposalImpl) _then)
      : super(_value, _then);

  /// Create a copy of VenueProposal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? venueId = null,
    Object? venueName = null,
    Object? venueImage = freezed,
    Object? proposedBy = null,
    Object? proposerName = null,
    Object? proposerAvatar = freezed,
    Object? proposedDate = freezed,
    Object? notes = freezed,
    Object? votes = null,
    Object? upvotes = null,
    Object? downvotes = null,
    Object? createdAt = null,
  }) {
    return _then(_$VenueProposalImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      venueId: null == venueId
          ? _value.venueId
          : venueId // ignore: cast_nullable_to_non_nullable
              as String,
      venueName: null == venueName
          ? _value.venueName
          : venueName // ignore: cast_nullable_to_non_nullable
              as String,
      venueImage: freezed == venueImage
          ? _value.venueImage
          : venueImage // ignore: cast_nullable_to_non_nullable
              as String?,
      proposedBy: null == proposedBy
          ? _value.proposedBy
          : proposedBy // ignore: cast_nullable_to_non_nullable
              as String,
      proposerName: null == proposerName
          ? _value.proposerName
          : proposerName // ignore: cast_nullable_to_non_nullable
              as String,
      proposerAvatar: freezed == proposerAvatar
          ? _value.proposerAvatar
          : proposerAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      proposedDate: freezed == proposedDate
          ? _value.proposedDate
          : proposedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      votes: null == votes
          ? _value._votes
          : votes // ignore: cast_nullable_to_non_nullable
              as List<VenueVote>,
      upvotes: null == upvotes
          ? _value.upvotes
          : upvotes // ignore: cast_nullable_to_non_nullable
              as int,
      downvotes: null == downvotes
          ? _value.downvotes
          : downvotes // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VenueProposalImpl implements _VenueProposal {
  const _$VenueProposalImpl(
      {required this.id,
      required this.venueId,
      required this.venueName,
      this.venueImage,
      required this.proposedBy,
      required this.proposerName,
      this.proposerAvatar,
      this.proposedDate,
      this.notes,
      final List<VenueVote> votes = const [],
      this.upvotes = 0,
      this.downvotes = 0,
      required this.createdAt})
      : _votes = votes;

  factory _$VenueProposalImpl.fromJson(Map<String, dynamic> json) =>
      _$$VenueProposalImplFromJson(json);

  @override
  final String id;
  @override
  final String venueId;
  @override
  final String venueName;
  @override
  final String? venueImage;
  @override
  final String proposedBy;
  @override
  final String proposerName;
  @override
  final String? proposerAvatar;
  @override
  final DateTime? proposedDate;
  @override
  final String? notes;
  final List<VenueVote> _votes;
  @override
  @JsonKey()
  List<VenueVote> get votes {
    if (_votes is EqualUnmodifiableListView) return _votes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_votes);
  }

  @override
  @JsonKey()
  final int upvotes;
  @override
  @JsonKey()
  final int downvotes;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'VenueProposal(id: $id, venueId: $venueId, venueName: $venueName, venueImage: $venueImage, proposedBy: $proposedBy, proposerName: $proposerName, proposerAvatar: $proposerAvatar, proposedDate: $proposedDate, notes: $notes, votes: $votes, upvotes: $upvotes, downvotes: $downvotes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VenueProposalImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.venueId, venueId) || other.venueId == venueId) &&
            (identical(other.venueName, venueName) ||
                other.venueName == venueName) &&
            (identical(other.venueImage, venueImage) ||
                other.venueImage == venueImage) &&
            (identical(other.proposedBy, proposedBy) ||
                other.proposedBy == proposedBy) &&
            (identical(other.proposerName, proposerName) ||
                other.proposerName == proposerName) &&
            (identical(other.proposerAvatar, proposerAvatar) ||
                other.proposerAvatar == proposerAvatar) &&
            (identical(other.proposedDate, proposedDate) ||
                other.proposedDate == proposedDate) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._votes, _votes) &&
            (identical(other.upvotes, upvotes) || other.upvotes == upvotes) &&
            (identical(other.downvotes, downvotes) ||
                other.downvotes == downvotes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      venueId,
      venueName,
      venueImage,
      proposedBy,
      proposerName,
      proposerAvatar,
      proposedDate,
      notes,
      const DeepCollectionEquality().hash(_votes),
      upvotes,
      downvotes,
      createdAt);

  /// Create a copy of VenueProposal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VenueProposalImplCopyWith<_$VenueProposalImpl> get copyWith =>
      __$$VenueProposalImplCopyWithImpl<_$VenueProposalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VenueProposalImplToJson(
      this,
    );
  }
}

abstract class _VenueProposal implements VenueProposal {
  const factory _VenueProposal(
      {required final String id,
      required final String venueId,
      required final String venueName,
      final String? venueImage,
      required final String proposedBy,
      required final String proposerName,
      final String? proposerAvatar,
      final DateTime? proposedDate,
      final String? notes,
      final List<VenueVote> votes,
      final int upvotes,
      final int downvotes,
      required final DateTime createdAt}) = _$VenueProposalImpl;

  factory _VenueProposal.fromJson(Map<String, dynamic> json) =
      _$VenueProposalImpl.fromJson;

  @override
  String get id;
  @override
  String get venueId;
  @override
  String get venueName;
  @override
  String? get venueImage;
  @override
  String get proposedBy;
  @override
  String get proposerName;
  @override
  String? get proposerAvatar;
  @override
  DateTime? get proposedDate;
  @override
  String? get notes;
  @override
  List<VenueVote> get votes;
  @override
  int get upvotes;
  @override
  int get downvotes;
  @override
  DateTime get createdAt;

  /// Create a copy of VenueProposal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VenueProposalImplCopyWith<_$VenueProposalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VenueVote _$VenueVoteFromJson(Map<String, dynamic> json) {
  return _VenueVote.fromJson(json);
}

/// @nodoc
mixin _$VenueVote {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String? get userAvatar => throw _privateConstructorUsedError;
  bool get isUpvote => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  DateTime get votedAt => throw _privateConstructorUsedError;

  /// Serializes this VenueVote to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VenueVote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VenueVoteCopyWith<VenueVote> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VenueVoteCopyWith<$Res> {
  factory $VenueVoteCopyWith(VenueVote value, $Res Function(VenueVote) then) =
      _$VenueVoteCopyWithImpl<$Res, VenueVote>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String userName,
      String? userAvatar,
      bool isUpvote,
      String? comment,
      DateTime votedAt});
}

/// @nodoc
class _$VenueVoteCopyWithImpl<$Res, $Val extends VenueVote>
    implements $VenueVoteCopyWith<$Res> {
  _$VenueVoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VenueVote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userName = null,
    Object? userAvatar = freezed,
    Object? isUpvote = null,
    Object? comment = freezed,
    Object? votedAt = null,
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
      isUpvote: null == isUpvote
          ? _value.isUpvote
          : isUpvote // ignore: cast_nullable_to_non_nullable
              as bool,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      votedAt: null == votedAt
          ? _value.votedAt
          : votedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VenueVoteImplCopyWith<$Res>
    implements $VenueVoteCopyWith<$Res> {
  factory _$$VenueVoteImplCopyWith(
          _$VenueVoteImpl value, $Res Function(_$VenueVoteImpl) then) =
      __$$VenueVoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String userName,
      String? userAvatar,
      bool isUpvote,
      String? comment,
      DateTime votedAt});
}

/// @nodoc
class __$$VenueVoteImplCopyWithImpl<$Res>
    extends _$VenueVoteCopyWithImpl<$Res, _$VenueVoteImpl>
    implements _$$VenueVoteImplCopyWith<$Res> {
  __$$VenueVoteImplCopyWithImpl(
      _$VenueVoteImpl _value, $Res Function(_$VenueVoteImpl) _then)
      : super(_value, _then);

  /// Create a copy of VenueVote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userName = null,
    Object? userAvatar = freezed,
    Object? isUpvote = null,
    Object? comment = freezed,
    Object? votedAt = null,
  }) {
    return _then(_$VenueVoteImpl(
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
      isUpvote: null == isUpvote
          ? _value.isUpvote
          : isUpvote // ignore: cast_nullable_to_non_nullable
              as bool,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      votedAt: null == votedAt
          ? _value.votedAt
          : votedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VenueVoteImpl implements _VenueVote {
  const _$VenueVoteImpl(
      {required this.id,
      required this.userId,
      required this.userName,
      this.userAvatar,
      required this.isUpvote,
      this.comment,
      required this.votedAt});

  factory _$VenueVoteImpl.fromJson(Map<String, dynamic> json) =>
      _$$VenueVoteImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String userName;
  @override
  final String? userAvatar;
  @override
  final bool isUpvote;
  @override
  final String? comment;
  @override
  final DateTime votedAt;

  @override
  String toString() {
    return 'VenueVote(id: $id, userId: $userId, userName: $userName, userAvatar: $userAvatar, isUpvote: $isUpvote, comment: $comment, votedAt: $votedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VenueVoteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userAvatar, userAvatar) ||
                other.userAvatar == userAvatar) &&
            (identical(other.isUpvote, isUpvote) ||
                other.isUpvote == isUpvote) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.votedAt, votedAt) || other.votedAt == votedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, userName, userAvatar,
      isUpvote, comment, votedAt);

  /// Create a copy of VenueVote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VenueVoteImplCopyWith<_$VenueVoteImpl> get copyWith =>
      __$$VenueVoteImplCopyWithImpl<_$VenueVoteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VenueVoteImplToJson(
      this,
    );
  }
}

abstract class _VenueVote implements VenueVote {
  const factory _VenueVote(
      {required final String id,
      required final String userId,
      required final String userName,
      final String? userAvatar,
      required final bool isUpvote,
      final String? comment,
      required final DateTime votedAt}) = _$VenueVoteImpl;

  factory _VenueVote.fromJson(Map<String, dynamic> json) =
      _$VenueVoteImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get userName;
  @override
  String? get userAvatar;
  @override
  bool get isUpvote;
  @override
  String? get comment;
  @override
  DateTime get votedAt;

  /// Create a copy of VenueVote
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VenueVoteImplCopyWith<_$VenueVoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GroupMessage _$GroupMessageFromJson(Map<String, dynamic> json) {
  return _GroupMessage.fromJson(json);
}

/// @nodoc
mixin _$GroupMessage {
  String get id => throw _privateConstructorUsedError;
  String get groupBookingId => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String get senderName => throw _privateConstructorUsedError;
  String? get senderAvatar => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String? get messageType => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  DateTime get sentAt => throw _privateConstructorUsedError;

  /// Serializes this GroupMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupMessageCopyWith<GroupMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupMessageCopyWith<$Res> {
  factory $GroupMessageCopyWith(
          GroupMessage value, $Res Function(GroupMessage) then) =
      _$GroupMessageCopyWithImpl<$Res, GroupMessage>;
  @useResult
  $Res call(
      {String id,
      String groupBookingId,
      String senderId,
      String senderName,
      String? senderAvatar,
      String message,
      String? messageType,
      Map<String, dynamic>? metadata,
      DateTime sentAt});
}

/// @nodoc
class _$GroupMessageCopyWithImpl<$Res, $Val extends GroupMessage>
    implements $GroupMessageCopyWith<$Res> {
  _$GroupMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? groupBookingId = null,
    Object? senderId = null,
    Object? senderName = null,
    Object? senderAvatar = freezed,
    Object? message = null,
    Object? messageType = freezed,
    Object? metadata = freezed,
    Object? sentAt = null,
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
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      senderName: null == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String,
      senderAvatar: freezed == senderAvatar
          ? _value.senderAvatar
          : senderAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      messageType: freezed == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      sentAt: null == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GroupMessageImplCopyWith<$Res>
    implements $GroupMessageCopyWith<$Res> {
  factory _$$GroupMessageImplCopyWith(
          _$GroupMessageImpl value, $Res Function(_$GroupMessageImpl) then) =
      __$$GroupMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String groupBookingId,
      String senderId,
      String senderName,
      String? senderAvatar,
      String message,
      String? messageType,
      Map<String, dynamic>? metadata,
      DateTime sentAt});
}

/// @nodoc
class __$$GroupMessageImplCopyWithImpl<$Res>
    extends _$GroupMessageCopyWithImpl<$Res, _$GroupMessageImpl>
    implements _$$GroupMessageImplCopyWith<$Res> {
  __$$GroupMessageImplCopyWithImpl(
      _$GroupMessageImpl _value, $Res Function(_$GroupMessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of GroupMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? groupBookingId = null,
    Object? senderId = null,
    Object? senderName = null,
    Object? senderAvatar = freezed,
    Object? message = null,
    Object? messageType = freezed,
    Object? metadata = freezed,
    Object? sentAt = null,
  }) {
    return _then(_$GroupMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      groupBookingId: null == groupBookingId
          ? _value.groupBookingId
          : groupBookingId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      senderName: null == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String,
      senderAvatar: freezed == senderAvatar
          ? _value.senderAvatar
          : senderAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      messageType: freezed == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      sentAt: null == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupMessageImpl implements _GroupMessage {
  const _$GroupMessageImpl(
      {required this.id,
      required this.groupBookingId,
      required this.senderId,
      required this.senderName,
      this.senderAvatar,
      required this.message,
      this.messageType,
      final Map<String, dynamic>? metadata,
      required this.sentAt})
      : _metadata = metadata;

  factory _$GroupMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupMessageImplFromJson(json);

  @override
  final String id;
  @override
  final String groupBookingId;
  @override
  final String senderId;
  @override
  final String senderName;
  @override
  final String? senderAvatar;
  @override
  final String message;
  @override
  final String? messageType;
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
  final DateTime sentAt;

  @override
  String toString() {
    return 'GroupMessage(id: $id, groupBookingId: $groupBookingId, senderId: $senderId, senderName: $senderName, senderAvatar: $senderAvatar, message: $message, messageType: $messageType, metadata: $metadata, sentAt: $sentAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.groupBookingId, groupBookingId) ||
                other.groupBookingId == groupBookingId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.senderAvatar, senderAvatar) ||
                other.senderAvatar == senderAvatar) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.messageType, messageType) ||
                other.messageType == messageType) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.sentAt, sentAt) || other.sentAt == sentAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      groupBookingId,
      senderId,
      senderName,
      senderAvatar,
      message,
      messageType,
      const DeepCollectionEquality().hash(_metadata),
      sentAt);

  /// Create a copy of GroupMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupMessageImplCopyWith<_$GroupMessageImpl> get copyWith =>
      __$$GroupMessageImplCopyWithImpl<_$GroupMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupMessageImplToJson(
      this,
    );
  }
}

abstract class _GroupMessage implements GroupMessage {
  const factory _GroupMessage(
      {required final String id,
      required final String groupBookingId,
      required final String senderId,
      required final String senderName,
      final String? senderAvatar,
      required final String message,
      final String? messageType,
      final Map<String, dynamic>? metadata,
      required final DateTime sentAt}) = _$GroupMessageImpl;

  factory _GroupMessage.fromJson(Map<String, dynamic> json) =
      _$GroupMessageImpl.fromJson;

  @override
  String get id;
  @override
  String get groupBookingId;
  @override
  String get senderId;
  @override
  String get senderName;
  @override
  String? get senderAvatar;
  @override
  String get message;
  @override
  String? get messageType;
  @override
  Map<String, dynamic>? get metadata;
  @override
  DateTime get sentAt;

  /// Create a copy of GroupMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupMessageImplCopyWith<_$GroupMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
