// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'social_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Friendship _$FriendshipFromJson(Map<String, dynamic> json) {
  return _Friendship.fromJson(json);
}

/// @nodoc
mixin _$Friendship {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get friendId => throw _privateConstructorUsedError;
  FriendshipStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get acceptedAt => throw _privateConstructorUsedError;
  DateTime? get blockedAt =>
      throw _privateConstructorUsedError; // Populated fields
  UserProfile? get friend => throw _privateConstructorUsedError;

  /// Serializes this Friendship to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Friendship
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendshipCopyWith<Friendship> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendshipCopyWith<$Res> {
  factory $FriendshipCopyWith(
          Friendship value, $Res Function(Friendship) then) =
      _$FriendshipCopyWithImpl<$Res, Friendship>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String friendId,
      FriendshipStatus status,
      DateTime createdAt,
      DateTime? acceptedAt,
      DateTime? blockedAt,
      UserProfile? friend});

  $UserProfileCopyWith<$Res>? get friend;
}

/// @nodoc
class _$FriendshipCopyWithImpl<$Res, $Val extends Friendship>
    implements $FriendshipCopyWith<$Res> {
  _$FriendshipCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Friendship
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? friendId = null,
    Object? status = null,
    Object? createdAt = null,
    Object? acceptedAt = freezed,
    Object? blockedAt = freezed,
    Object? friend = freezed,
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
      friendId: null == friendId
          ? _value.friendId
          : friendId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FriendshipStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      acceptedAt: freezed == acceptedAt
          ? _value.acceptedAt
          : acceptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      blockedAt: freezed == blockedAt
          ? _value.blockedAt
          : blockedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      friend: freezed == friend
          ? _value.friend
          : friend // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
    ) as $Val);
  }

  /// Create a copy of Friendship
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<$Res>? get friend {
    if (_value.friend == null) {
      return null;
    }

    return $UserProfileCopyWith<$Res>(_value.friend!, (value) {
      return _then(_value.copyWith(friend: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FriendshipImplCopyWith<$Res>
    implements $FriendshipCopyWith<$Res> {
  factory _$$FriendshipImplCopyWith(
          _$FriendshipImpl value, $Res Function(_$FriendshipImpl) then) =
      __$$FriendshipImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String friendId,
      FriendshipStatus status,
      DateTime createdAt,
      DateTime? acceptedAt,
      DateTime? blockedAt,
      UserProfile? friend});

  @override
  $UserProfileCopyWith<$Res>? get friend;
}

/// @nodoc
class __$$FriendshipImplCopyWithImpl<$Res>
    extends _$FriendshipCopyWithImpl<$Res, _$FriendshipImpl>
    implements _$$FriendshipImplCopyWith<$Res> {
  __$$FriendshipImplCopyWithImpl(
      _$FriendshipImpl _value, $Res Function(_$FriendshipImpl) _then)
      : super(_value, _then);

  /// Create a copy of Friendship
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? friendId = null,
    Object? status = null,
    Object? createdAt = null,
    Object? acceptedAt = freezed,
    Object? blockedAt = freezed,
    Object? friend = freezed,
  }) {
    return _then(_$FriendshipImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      friendId: null == friendId
          ? _value.friendId
          : friendId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FriendshipStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      acceptedAt: freezed == acceptedAt
          ? _value.acceptedAt
          : acceptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      blockedAt: freezed == blockedAt
          ? _value.blockedAt
          : blockedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      friend: freezed == friend
          ? _value.friend
          : friend // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FriendshipImpl implements _Friendship {
  const _$FriendshipImpl(
      {required this.id,
      required this.userId,
      required this.friendId,
      required this.status,
      required this.createdAt,
      this.acceptedAt,
      this.blockedAt,
      this.friend});

  factory _$FriendshipImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendshipImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String friendId;
  @override
  final FriendshipStatus status;
  @override
  final DateTime createdAt;
  @override
  final DateTime? acceptedAt;
  @override
  final DateTime? blockedAt;
// Populated fields
  @override
  final UserProfile? friend;

  @override
  String toString() {
    return 'Friendship(id: $id, userId: $userId, friendId: $friendId, status: $status, createdAt: $createdAt, acceptedAt: $acceptedAt, blockedAt: $blockedAt, friend: $friend)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendshipImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.friendId, friendId) ||
                other.friendId == friendId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.acceptedAt, acceptedAt) ||
                other.acceptedAt == acceptedAt) &&
            (identical(other.blockedAt, blockedAt) ||
                other.blockedAt == blockedAt) &&
            (identical(other.friend, friend) || other.friend == friend));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, friendId, status,
      createdAt, acceptedAt, blockedAt, friend);

  /// Create a copy of Friendship
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendshipImplCopyWith<_$FriendshipImpl> get copyWith =>
      __$$FriendshipImplCopyWithImpl<_$FriendshipImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendshipImplToJson(
      this,
    );
  }
}

abstract class _Friendship implements Friendship {
  const factory _Friendship(
      {required final String id,
      required final String userId,
      required final String friendId,
      required final FriendshipStatus status,
      required final DateTime createdAt,
      final DateTime? acceptedAt,
      final DateTime? blockedAt,
      final UserProfile? friend}) = _$FriendshipImpl;

  factory _Friendship.fromJson(Map<String, dynamic> json) =
      _$FriendshipImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get friendId;
  @override
  FriendshipStatus get status;
  @override
  DateTime get createdAt;
  @override
  DateTime? get acceptedAt;
  @override
  DateTime? get blockedAt; // Populated fields
  @override
  UserProfile? get friend;

  /// Create a copy of Friendship
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendshipImplCopyWith<_$FriendshipImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get fullName => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  int get friendsCount => throw _privateConstructorUsedError;
  int get postsCount => throw _privateConstructorUsedError;
  bool get isOnline => throw _privateConstructorUsedError;
  DateTime? get lastSeen => throw _privateConstructorUsedError;

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) then) =
      _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call(
      {String id,
      String email,
      String? fullName,
      String? avatarUrl,
      String? bio,
      String? location,
      int friendsCount,
      int postsCount,
      bool isOnline,
      DateTime? lastSeen});
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? fullName = freezed,
    Object? avatarUrl = freezed,
    Object? bio = freezed,
    Object? location = freezed,
    Object? friendsCount = null,
    Object? postsCount = null,
    Object? isOnline = null,
    Object? lastSeen = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      friendsCount: null == friendsCount
          ? _value.friendsCount
          : friendsCount // ignore: cast_nullable_to_non_nullable
              as int,
      postsCount: null == postsCount
          ? _value.postsCount
          : postsCount // ignore: cast_nullable_to_non_nullable
              as int,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSeen: freezed == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
          _$UserProfileImpl value, $Res Function(_$UserProfileImpl) then) =
      __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      String? fullName,
      String? avatarUrl,
      String? bio,
      String? location,
      int friendsCount,
      int postsCount,
      bool isOnline,
      DateTime? lastSeen});
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
      _$UserProfileImpl _value, $Res Function(_$UserProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? fullName = freezed,
    Object? avatarUrl = freezed,
    Object? bio = freezed,
    Object? location = freezed,
    Object? friendsCount = null,
    Object? postsCount = null,
    Object? isOnline = null,
    Object? lastSeen = freezed,
  }) {
    return _then(_$UserProfileImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      friendsCount: null == friendsCount
          ? _value.friendsCount
          : friendsCount // ignore: cast_nullable_to_non_nullable
              as int,
      postsCount: null == postsCount
          ? _value.postsCount
          : postsCount // ignore: cast_nullable_to_non_nullable
              as int,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSeen: freezed == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileImpl implements _UserProfile {
  const _$UserProfileImpl(
      {required this.id,
      required this.email,
      this.fullName,
      this.avatarUrl,
      this.bio,
      this.location,
      this.friendsCount = 0,
      this.postsCount = 0,
      this.isOnline = false,
      this.lastSeen});

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String? fullName;
  @override
  final String? avatarUrl;
  @override
  final String? bio;
  @override
  final String? location;
  @override
  @JsonKey()
  final int friendsCount;
  @override
  @JsonKey()
  final int postsCount;
  @override
  @JsonKey()
  final bool isOnline;
  @override
  final DateTime? lastSeen;

  @override
  String toString() {
    return 'UserProfile(id: $id, email: $email, fullName: $fullName, avatarUrl: $avatarUrl, bio: $bio, location: $location, friendsCount: $friendsCount, postsCount: $postsCount, isOnline: $isOnline, lastSeen: $lastSeen)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.friendsCount, friendsCount) ||
                other.friendsCount == friendsCount) &&
            (identical(other.postsCount, postsCount) ||
                other.postsCount == postsCount) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(other.lastSeen, lastSeen) ||
                other.lastSeen == lastSeen));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, email, fullName, avatarUrl,
      bio, location, friendsCount, postsCount, isOnline, lastSeen);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(
      this,
    );
  }
}

abstract class _UserProfile implements UserProfile {
  const factory _UserProfile(
      {required final String id,
      required final String email,
      final String? fullName,
      final String? avatarUrl,
      final String? bio,
      final String? location,
      final int friendsCount,
      final int postsCount,
      final bool isOnline,
      final DateTime? lastSeen}) = _$UserProfileImpl;

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String? get fullName;
  @override
  String? get avatarUrl;
  @override
  String? get bio;
  @override
  String? get location;
  @override
  int get friendsCount;
  @override
  int get postsCount;
  @override
  bool get isOnline;
  @override
  DateTime? get lastSeen;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Conversation _$ConversationFromJson(Map<String, dynamic> json) {
  return _Conversation.fromJson(json);
}

/// @nodoc
mixin _$Conversation {
  String get id => throw _privateConstructorUsedError;
  ConversationType get type => throw _privateConstructorUsedError;
  List<String> get participantIds => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  DateTime? get lastMessageAt => throw _privateConstructorUsedError;
  String? get lastMessage => throw _privateConstructorUsedError;
  int get unreadCount => throw _privateConstructorUsedError; // Populated fields
  List<UserProfile>? get participants => throw _privateConstructorUsedError;
  Message? get lastMessageObj => throw _privateConstructorUsedError;

  /// Serializes this Conversation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationCopyWith<Conversation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationCopyWith<$Res> {
  factory $ConversationCopyWith(
          Conversation value, $Res Function(Conversation) then) =
      _$ConversationCopyWithImpl<$Res, Conversation>;
  @useResult
  $Res call(
      {String id,
      ConversationType type,
      List<String> participantIds,
      String? name,
      String? avatarUrl,
      DateTime? lastMessageAt,
      String? lastMessage,
      int unreadCount,
      List<UserProfile>? participants,
      Message? lastMessageObj});

  $MessageCopyWith<$Res>? get lastMessageObj;
}

/// @nodoc
class _$ConversationCopyWithImpl<$Res, $Val extends Conversation>
    implements $ConversationCopyWith<$Res> {
  _$ConversationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? participantIds = null,
    Object? name = freezed,
    Object? avatarUrl = freezed,
    Object? lastMessageAt = freezed,
    Object? lastMessage = freezed,
    Object? unreadCount = null,
    Object? participants = freezed,
    Object? lastMessageObj = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ConversationType,
      participantIds: null == participantIds
          ? _value.participantIds
          : participantIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageAt: freezed == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      participants: freezed == participants
          ? _value.participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<UserProfile>?,
      lastMessageObj: freezed == lastMessageObj
          ? _value.lastMessageObj
          : lastMessageObj // ignore: cast_nullable_to_non_nullable
              as Message?,
    ) as $Val);
  }

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MessageCopyWith<$Res>? get lastMessageObj {
    if (_value.lastMessageObj == null) {
      return null;
    }

    return $MessageCopyWith<$Res>(_value.lastMessageObj!, (value) {
      return _then(_value.copyWith(lastMessageObj: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ConversationImplCopyWith<$Res>
    implements $ConversationCopyWith<$Res> {
  factory _$$ConversationImplCopyWith(
          _$ConversationImpl value, $Res Function(_$ConversationImpl) then) =
      __$$ConversationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      ConversationType type,
      List<String> participantIds,
      String? name,
      String? avatarUrl,
      DateTime? lastMessageAt,
      String? lastMessage,
      int unreadCount,
      List<UserProfile>? participants,
      Message? lastMessageObj});

  @override
  $MessageCopyWith<$Res>? get lastMessageObj;
}

/// @nodoc
class __$$ConversationImplCopyWithImpl<$Res>
    extends _$ConversationCopyWithImpl<$Res, _$ConversationImpl>
    implements _$$ConversationImplCopyWith<$Res> {
  __$$ConversationImplCopyWithImpl(
      _$ConversationImpl _value, $Res Function(_$ConversationImpl) _then)
      : super(_value, _then);

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? participantIds = null,
    Object? name = freezed,
    Object? avatarUrl = freezed,
    Object? lastMessageAt = freezed,
    Object? lastMessage = freezed,
    Object? unreadCount = null,
    Object? participants = freezed,
    Object? lastMessageObj = freezed,
  }) {
    return _then(_$ConversationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ConversationType,
      participantIds: null == participantIds
          ? _value._participantIds
          : participantIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageAt: freezed == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      participants: freezed == participants
          ? _value._participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<UserProfile>?,
      lastMessageObj: freezed == lastMessageObj
          ? _value.lastMessageObj
          : lastMessageObj // ignore: cast_nullable_to_non_nullable
              as Message?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationImpl implements _Conversation {
  const _$ConversationImpl(
      {required this.id,
      required this.type,
      required final List<String> participantIds,
      this.name,
      this.avatarUrl,
      this.lastMessageAt,
      this.lastMessage,
      this.unreadCount = 0,
      final List<UserProfile>? participants,
      this.lastMessageObj})
      : _participantIds = participantIds,
        _participants = participants;

  factory _$ConversationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationImplFromJson(json);

  @override
  final String id;
  @override
  final ConversationType type;
  final List<String> _participantIds;
  @override
  List<String> get participantIds {
    if (_participantIds is EqualUnmodifiableListView) return _participantIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participantIds);
  }

  @override
  final String? name;
  @override
  final String? avatarUrl;
  @override
  final DateTime? lastMessageAt;
  @override
  final String? lastMessage;
  @override
  @JsonKey()
  final int unreadCount;
// Populated fields
  final List<UserProfile>? _participants;
// Populated fields
  @override
  List<UserProfile>? get participants {
    final value = _participants;
    if (value == null) return null;
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final Message? lastMessageObj;

  @override
  String toString() {
    return 'Conversation(id: $id, type: $type, participantIds: $participantIds, name: $name, avatarUrl: $avatarUrl, lastMessageAt: $lastMessageAt, lastMessage: $lastMessage, unreadCount: $unreadCount, participants: $participants, lastMessageObj: $lastMessageObj)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other._participantIds, _participantIds) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.lastMessageAt, lastMessageAt) ||
                other.lastMessageAt == lastMessageAt) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            const DeepCollectionEquality()
                .equals(other._participants, _participants) &&
            (identical(other.lastMessageObj, lastMessageObj) ||
                other.lastMessageObj == lastMessageObj));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      const DeepCollectionEquality().hash(_participantIds),
      name,
      avatarUrl,
      lastMessageAt,
      lastMessage,
      unreadCount,
      const DeepCollectionEquality().hash(_participants),
      lastMessageObj);

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationImplCopyWith<_$ConversationImpl> get copyWith =>
      __$$ConversationImplCopyWithImpl<_$ConversationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationImplToJson(
      this,
    );
  }
}

abstract class _Conversation implements Conversation {
  const factory _Conversation(
      {required final String id,
      required final ConversationType type,
      required final List<String> participantIds,
      final String? name,
      final String? avatarUrl,
      final DateTime? lastMessageAt,
      final String? lastMessage,
      final int unreadCount,
      final List<UserProfile>? participants,
      final Message? lastMessageObj}) = _$ConversationImpl;

  factory _Conversation.fromJson(Map<String, dynamic> json) =
      _$ConversationImpl.fromJson;

  @override
  String get id;
  @override
  ConversationType get type;
  @override
  List<String> get participantIds;
  @override
  String? get name;
  @override
  String? get avatarUrl;
  @override
  DateTime? get lastMessageAt;
  @override
  String? get lastMessage;
  @override
  int get unreadCount; // Populated fields
  @override
  List<UserProfile>? get participants;
  @override
  Message? get lastMessageObj;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationImplCopyWith<_$ConversationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Message _$MessageFromJson(Map<String, dynamic> json) {
  return _Message.fromJson(json);
}

/// @nodoc
mixin _$Message {
  String get id => throw _privateConstructorUsedError;
  String get conversationId => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get messageType => throw _privateConstructorUsedError;
  MessageStatus get status => throw _privateConstructorUsedError;
  DateTime get sentAt => throw _privateConstructorUsedError;
  DateTime? get readAt => throw _privateConstructorUsedError;
  bool get isEdited => throw _privateConstructorUsedError;
  DateTime? get editedAt => throw _privateConstructorUsedError;
  List<String> get attachments => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata =>
      throw _privateConstructorUsedError; // Populated fields
  UserProfile? get sender => throw _privateConstructorUsedError;

  /// Serializes this Message to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageCopyWith<Message> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageCopyWith<$Res> {
  factory $MessageCopyWith(Message value, $Res Function(Message) then) =
      _$MessageCopyWithImpl<$Res, Message>;
  @useResult
  $Res call(
      {String id,
      String conversationId,
      String senderId,
      String content,
      String messageType,
      MessageStatus status,
      DateTime sentAt,
      DateTime? readAt,
      bool isEdited,
      DateTime? editedAt,
      List<String> attachments,
      Map<String, dynamic>? metadata,
      UserProfile? sender});

  $UserProfileCopyWith<$Res>? get sender;
}

/// @nodoc
class _$MessageCopyWithImpl<$Res, $Val extends Message>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? senderId = null,
    Object? content = null,
    Object? messageType = null,
    Object? status = null,
    Object? sentAt = null,
    Object? readAt = freezed,
    Object? isEdited = null,
    Object? editedAt = freezed,
    Object? attachments = null,
    Object? metadata = freezed,
    Object? sender = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MessageStatus,
      sentAt: null == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isEdited: null == isEdited
          ? _value.isEdited
          : isEdited // ignore: cast_nullable_to_non_nullable
              as bool,
      editedAt: freezed == editedAt
          ? _value.editedAt
          : editedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      sender: freezed == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
    ) as $Val);
  }

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<$Res>? get sender {
    if (_value.sender == null) {
      return null;
    }

    return $UserProfileCopyWith<$Res>(_value.sender!, (value) {
      return _then(_value.copyWith(sender: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MessageImplCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$$MessageImplCopyWith(
          _$MessageImpl value, $Res Function(_$MessageImpl) then) =
      __$$MessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String conversationId,
      String senderId,
      String content,
      String messageType,
      MessageStatus status,
      DateTime sentAt,
      DateTime? readAt,
      bool isEdited,
      DateTime? editedAt,
      List<String> attachments,
      Map<String, dynamic>? metadata,
      UserProfile? sender});

  @override
  $UserProfileCopyWith<$Res>? get sender;
}

/// @nodoc
class __$$MessageImplCopyWithImpl<$Res>
    extends _$MessageCopyWithImpl<$Res, _$MessageImpl>
    implements _$$MessageImplCopyWith<$Res> {
  __$$MessageImplCopyWithImpl(
      _$MessageImpl _value, $Res Function(_$MessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? senderId = null,
    Object? content = null,
    Object? messageType = null,
    Object? status = null,
    Object? sentAt = null,
    Object? readAt = freezed,
    Object? isEdited = null,
    Object? editedAt = freezed,
    Object? attachments = null,
    Object? metadata = freezed,
    Object? sender = freezed,
  }) {
    return _then(_$MessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MessageStatus,
      sentAt: null == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isEdited: null == isEdited
          ? _value.isEdited
          : isEdited // ignore: cast_nullable_to_non_nullable
              as bool,
      editedAt: freezed == editedAt
          ? _value.editedAt
          : editedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      sender: freezed == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageImpl implements _Message {
  const _$MessageImpl(
      {required this.id,
      required this.conversationId,
      required this.senderId,
      required this.content,
      this.messageType = 'text',
      this.status = MessageStatus.sent,
      required this.sentAt,
      this.readAt,
      this.isEdited = false,
      this.editedAt,
      final List<String> attachments = const [],
      final Map<String, dynamic>? metadata,
      this.sender})
      : _attachments = attachments,
        _metadata = metadata;

  factory _$MessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageImplFromJson(json);

  @override
  final String id;
  @override
  final String conversationId;
  @override
  final String senderId;
  @override
  final String content;
  @override
  @JsonKey()
  final String messageType;
  @override
  @JsonKey()
  final MessageStatus status;
  @override
  final DateTime sentAt;
  @override
  final DateTime? readAt;
  @override
  @JsonKey()
  final bool isEdited;
  @override
  final DateTime? editedAt;
  final List<String> _attachments;
  @override
  @JsonKey()
  List<String> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// Populated fields
  @override
  final UserProfile? sender;

  @override
  String toString() {
    return 'Message(id: $id, conversationId: $conversationId, senderId: $senderId, content: $content, messageType: $messageType, status: $status, sentAt: $sentAt, readAt: $readAt, isEdited: $isEdited, editedAt: $editedAt, attachments: $attachments, metadata: $metadata, sender: $sender)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.messageType, messageType) ||
                other.messageType == messageType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.sentAt, sentAt) || other.sentAt == sentAt) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.isEdited, isEdited) ||
                other.isEdited == isEdited) &&
            (identical(other.editedAt, editedAt) ||
                other.editedAt == editedAt) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.sender, sender) || other.sender == sender));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      conversationId,
      senderId,
      content,
      messageType,
      status,
      sentAt,
      readAt,
      isEdited,
      editedAt,
      const DeepCollectionEquality().hash(_attachments),
      const DeepCollectionEquality().hash(_metadata),
      sender);

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      __$$MessageImplCopyWithImpl<_$MessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageImplToJson(
      this,
    );
  }
}

abstract class _Message implements Message {
  const factory _Message(
      {required final String id,
      required final String conversationId,
      required final String senderId,
      required final String content,
      final String messageType,
      final MessageStatus status,
      required final DateTime sentAt,
      final DateTime? readAt,
      final bool isEdited,
      final DateTime? editedAt,
      final List<String> attachments,
      final Map<String, dynamic>? metadata,
      final UserProfile? sender}) = _$MessageImpl;

  factory _Message.fromJson(Map<String, dynamic> json) = _$MessageImpl.fromJson;

  @override
  String get id;
  @override
  String get conversationId;
  @override
  String get senderId;
  @override
  String get content;
  @override
  String get messageType;
  @override
  MessageStatus get status;
  @override
  DateTime get sentAt;
  @override
  DateTime? get readAt;
  @override
  bool get isEdited;
  @override
  DateTime? get editedAt;
  @override
  List<String> get attachments;
  @override
  Map<String, dynamic>? get metadata; // Populated fields
  @override
  UserProfile? get sender;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Post _$PostFromJson(Map<String, dynamic> json) {
  return _Post.fromJson(json);
}

/// @nodoc
mixin _$Post {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  PostType get type => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  PostVisibility get visibility => throw _privateConstructorUsedError;
  List<String> get mediaUrls => throw _privateConstructorUsedError;
  List<String> get taggedUserIds => throw _privateConstructorUsedError;
  String? get venueId => throw _privateConstructorUsedError;
  String? get eventId => throw _privateConstructorUsedError;
  String? get reviewId => throw _privateConstructorUsedError;
  int get likesCount => throw _privateConstructorUsedError;
  int get commentsCount => throw _privateConstructorUsedError;
  int get sharesCount => throw _privateConstructorUsedError;
  bool get isLiked => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // Populated fields
  UserProfile? get author => throw _privateConstructorUsedError;
  List<UserProfile>? get taggedUsers => throw _privateConstructorUsedError;
  VenueInfo? get venue => throw _privateConstructorUsedError;
  List<Comment>? get comments => throw _privateConstructorUsedError;

  /// Serializes this Post to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostCopyWith<Post> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostCopyWith<$Res> {
  factory $PostCopyWith(Post value, $Res Function(Post) then) =
      _$PostCopyWithImpl<$Res, Post>;
  @useResult
  $Res call(
      {String id,
      String userId,
      PostType type,
      String content,
      PostVisibility visibility,
      List<String> mediaUrls,
      List<String> taggedUserIds,
      String? venueId,
      String? eventId,
      String? reviewId,
      int likesCount,
      int commentsCount,
      int sharesCount,
      bool isLiked,
      DateTime createdAt,
      DateTime? updatedAt,
      UserProfile? author,
      List<UserProfile>? taggedUsers,
      VenueInfo? venue,
      List<Comment>? comments});

  $UserProfileCopyWith<$Res>? get author;
  $VenueInfoCopyWith<$Res>? get venue;
}

/// @nodoc
class _$PostCopyWithImpl<$Res, $Val extends Post>
    implements $PostCopyWith<$Res> {
  _$PostCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? content = null,
    Object? visibility = null,
    Object? mediaUrls = null,
    Object? taggedUserIds = null,
    Object? venueId = freezed,
    Object? eventId = freezed,
    Object? reviewId = freezed,
    Object? likesCount = null,
    Object? commentsCount = null,
    Object? sharesCount = null,
    Object? isLiked = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? author = freezed,
    Object? taggedUsers = freezed,
    Object? venue = freezed,
    Object? comments = freezed,
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
              as PostType,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as PostVisibility,
      mediaUrls: null == mediaUrls
          ? _value.mediaUrls
          : mediaUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      taggedUserIds: null == taggedUserIds
          ? _value.taggedUserIds
          : taggedUserIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      venueId: freezed == venueId
          ? _value.venueId
          : venueId // ignore: cast_nullable_to_non_nullable
              as String?,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewId: freezed == reviewId
          ? _value.reviewId
          : reviewId // ignore: cast_nullable_to_non_nullable
              as String?,
      likesCount: null == likesCount
          ? _value.likesCount
          : likesCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentsCount: null == commentsCount
          ? _value.commentsCount
          : commentsCount // ignore: cast_nullable_to_non_nullable
              as int,
      sharesCount: null == sharesCount
          ? _value.sharesCount
          : sharesCount // ignore: cast_nullable_to_non_nullable
              as int,
      isLiked: null == isLiked
          ? _value.isLiked
          : isLiked // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
      taggedUsers: freezed == taggedUsers
          ? _value.taggedUsers
          : taggedUsers // ignore: cast_nullable_to_non_nullable
              as List<UserProfile>?,
      venue: freezed == venue
          ? _value.venue
          : venue // ignore: cast_nullable_to_non_nullable
              as VenueInfo?,
      comments: freezed == comments
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<Comment>?,
    ) as $Val);
  }

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<$Res>? get author {
    if (_value.author == null) {
      return null;
    }

    return $UserProfileCopyWith<$Res>(_value.author!, (value) {
      return _then(_value.copyWith(author: value) as $Val);
    });
  }

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VenueInfoCopyWith<$Res>? get venue {
    if (_value.venue == null) {
      return null;
    }

    return $VenueInfoCopyWith<$Res>(_value.venue!, (value) {
      return _then(_value.copyWith(venue: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PostImplCopyWith<$Res> implements $PostCopyWith<$Res> {
  factory _$$PostImplCopyWith(
          _$PostImpl value, $Res Function(_$PostImpl) then) =
      __$$PostImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      PostType type,
      String content,
      PostVisibility visibility,
      List<String> mediaUrls,
      List<String> taggedUserIds,
      String? venueId,
      String? eventId,
      String? reviewId,
      int likesCount,
      int commentsCount,
      int sharesCount,
      bool isLiked,
      DateTime createdAt,
      DateTime? updatedAt,
      UserProfile? author,
      List<UserProfile>? taggedUsers,
      VenueInfo? venue,
      List<Comment>? comments});

  @override
  $UserProfileCopyWith<$Res>? get author;
  @override
  $VenueInfoCopyWith<$Res>? get venue;
}

/// @nodoc
class __$$PostImplCopyWithImpl<$Res>
    extends _$PostCopyWithImpl<$Res, _$PostImpl>
    implements _$$PostImplCopyWith<$Res> {
  __$$PostImplCopyWithImpl(_$PostImpl _value, $Res Function(_$PostImpl) _then)
      : super(_value, _then);

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? content = null,
    Object? visibility = null,
    Object? mediaUrls = null,
    Object? taggedUserIds = null,
    Object? venueId = freezed,
    Object? eventId = freezed,
    Object? reviewId = freezed,
    Object? likesCount = null,
    Object? commentsCount = null,
    Object? sharesCount = null,
    Object? isLiked = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? author = freezed,
    Object? taggedUsers = freezed,
    Object? venue = freezed,
    Object? comments = freezed,
  }) {
    return _then(_$PostImpl(
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
              as PostType,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as PostVisibility,
      mediaUrls: null == mediaUrls
          ? _value._mediaUrls
          : mediaUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      taggedUserIds: null == taggedUserIds
          ? _value._taggedUserIds
          : taggedUserIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      venueId: freezed == venueId
          ? _value.venueId
          : venueId // ignore: cast_nullable_to_non_nullable
              as String?,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewId: freezed == reviewId
          ? _value.reviewId
          : reviewId // ignore: cast_nullable_to_non_nullable
              as String?,
      likesCount: null == likesCount
          ? _value.likesCount
          : likesCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentsCount: null == commentsCount
          ? _value.commentsCount
          : commentsCount // ignore: cast_nullable_to_non_nullable
              as int,
      sharesCount: null == sharesCount
          ? _value.sharesCount
          : sharesCount // ignore: cast_nullable_to_non_nullable
              as int,
      isLiked: null == isLiked
          ? _value.isLiked
          : isLiked // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
      taggedUsers: freezed == taggedUsers
          ? _value._taggedUsers
          : taggedUsers // ignore: cast_nullable_to_non_nullable
              as List<UserProfile>?,
      venue: freezed == venue
          ? _value.venue
          : venue // ignore: cast_nullable_to_non_nullable
              as VenueInfo?,
      comments: freezed == comments
          ? _value._comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<Comment>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PostImpl implements _Post {
  const _$PostImpl(
      {required this.id,
      required this.userId,
      required this.type,
      required this.content,
      this.visibility = PostVisibility.friends,
      final List<String> mediaUrls = const [],
      final List<String> taggedUserIds = const [],
      this.venueId,
      this.eventId,
      this.reviewId,
      this.likesCount = 0,
      this.commentsCount = 0,
      this.sharesCount = 0,
      this.isLiked = false,
      required this.createdAt,
      this.updatedAt,
      this.author,
      final List<UserProfile>? taggedUsers,
      this.venue,
      final List<Comment>? comments})
      : _mediaUrls = mediaUrls,
        _taggedUserIds = taggedUserIds,
        _taggedUsers = taggedUsers,
        _comments = comments;

  factory _$PostImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final PostType type;
  @override
  final String content;
  @override
  @JsonKey()
  final PostVisibility visibility;
  final List<String> _mediaUrls;
  @override
  @JsonKey()
  List<String> get mediaUrls {
    if (_mediaUrls is EqualUnmodifiableListView) return _mediaUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mediaUrls);
  }

  final List<String> _taggedUserIds;
  @override
  @JsonKey()
  List<String> get taggedUserIds {
    if (_taggedUserIds is EqualUnmodifiableListView) return _taggedUserIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_taggedUserIds);
  }

  @override
  final String? venueId;
  @override
  final String? eventId;
  @override
  final String? reviewId;
  @override
  @JsonKey()
  final int likesCount;
  @override
  @JsonKey()
  final int commentsCount;
  @override
  @JsonKey()
  final int sharesCount;
  @override
  @JsonKey()
  final bool isLiked;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
// Populated fields
  @override
  final UserProfile? author;
  final List<UserProfile>? _taggedUsers;
  @override
  List<UserProfile>? get taggedUsers {
    final value = _taggedUsers;
    if (value == null) return null;
    if (_taggedUsers is EqualUnmodifiableListView) return _taggedUsers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final VenueInfo? venue;
  final List<Comment>? _comments;
  @override
  List<Comment>? get comments {
    final value = _comments;
    if (value == null) return null;
    if (_comments is EqualUnmodifiableListView) return _comments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Post(id: $id, userId: $userId, type: $type, content: $content, visibility: $visibility, mediaUrls: $mediaUrls, taggedUserIds: $taggedUserIds, venueId: $venueId, eventId: $eventId, reviewId: $reviewId, likesCount: $likesCount, commentsCount: $commentsCount, sharesCount: $sharesCount, isLiked: $isLiked, createdAt: $createdAt, updatedAt: $updatedAt, author: $author, taggedUsers: $taggedUsers, venue: $venue, comments: $comments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            const DeepCollectionEquality()
                .equals(other._mediaUrls, _mediaUrls) &&
            const DeepCollectionEquality()
                .equals(other._taggedUserIds, _taggedUserIds) &&
            (identical(other.venueId, venueId) || other.venueId == venueId) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.reviewId, reviewId) ||
                other.reviewId == reviewId) &&
            (identical(other.likesCount, likesCount) ||
                other.likesCount == likesCount) &&
            (identical(other.commentsCount, commentsCount) ||
                other.commentsCount == commentsCount) &&
            (identical(other.sharesCount, sharesCount) ||
                other.sharesCount == sharesCount) &&
            (identical(other.isLiked, isLiked) || other.isLiked == isLiked) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.author, author) || other.author == author) &&
            const DeepCollectionEquality()
                .equals(other._taggedUsers, _taggedUsers) &&
            (identical(other.venue, venue) || other.venue == venue) &&
            const DeepCollectionEquality().equals(other._comments, _comments));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        type,
        content,
        visibility,
        const DeepCollectionEquality().hash(_mediaUrls),
        const DeepCollectionEquality().hash(_taggedUserIds),
        venueId,
        eventId,
        reviewId,
        likesCount,
        commentsCount,
        sharesCount,
        isLiked,
        createdAt,
        updatedAt,
        author,
        const DeepCollectionEquality().hash(_taggedUsers),
        venue,
        const DeepCollectionEquality().hash(_comments)
      ]);

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostImplCopyWith<_$PostImpl> get copyWith =>
      __$$PostImplCopyWithImpl<_$PostImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostImplToJson(
      this,
    );
  }
}

abstract class _Post implements Post {
  const factory _Post(
      {required final String id,
      required final String userId,
      required final PostType type,
      required final String content,
      final PostVisibility visibility,
      final List<String> mediaUrls,
      final List<String> taggedUserIds,
      final String? venueId,
      final String? eventId,
      final String? reviewId,
      final int likesCount,
      final int commentsCount,
      final int sharesCount,
      final bool isLiked,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final UserProfile? author,
      final List<UserProfile>? taggedUsers,
      final VenueInfo? venue,
      final List<Comment>? comments}) = _$PostImpl;

  factory _Post.fromJson(Map<String, dynamic> json) = _$PostImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  PostType get type;
  @override
  String get content;
  @override
  PostVisibility get visibility;
  @override
  List<String> get mediaUrls;
  @override
  List<String> get taggedUserIds;
  @override
  String? get venueId;
  @override
  String? get eventId;
  @override
  String? get reviewId;
  @override
  int get likesCount;
  @override
  int get commentsCount;
  @override
  int get sharesCount;
  @override
  bool get isLiked;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt; // Populated fields
  @override
  UserProfile? get author;
  @override
  List<UserProfile>? get taggedUsers;
  @override
  VenueInfo? get venue;
  @override
  List<Comment>? get comments;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostImplCopyWith<_$PostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return _Comment.fromJson(json);
}

/// @nodoc
mixin _$Comment {
  String get id => throw _privateConstructorUsedError;
  String get postId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String? get parentCommentId => throw _privateConstructorUsedError;
  int get likesCount => throw _privateConstructorUsedError;
  bool get isLiked => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // Populated fields
  UserProfile? get author => throw _privateConstructorUsedError;
  List<Comment>? get replies => throw _privateConstructorUsedError;

  /// Serializes this Comment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentCopyWith<Comment> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentCopyWith<$Res> {
  factory $CommentCopyWith(Comment value, $Res Function(Comment) then) =
      _$CommentCopyWithImpl<$Res, Comment>;
  @useResult
  $Res call(
      {String id,
      String postId,
      String userId,
      String content,
      String? parentCommentId,
      int likesCount,
      bool isLiked,
      DateTime createdAt,
      DateTime? updatedAt,
      UserProfile? author,
      List<Comment>? replies});

  $UserProfileCopyWith<$Res>? get author;
}

/// @nodoc
class _$CommentCopyWithImpl<$Res, $Val extends Comment>
    implements $CommentCopyWith<$Res> {
  _$CommentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? postId = null,
    Object? userId = null,
    Object? content = null,
    Object? parentCommentId = freezed,
    Object? likesCount = null,
    Object? isLiked = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? author = freezed,
    Object? replies = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      parentCommentId: freezed == parentCommentId
          ? _value.parentCommentId
          : parentCommentId // ignore: cast_nullable_to_non_nullable
              as String?,
      likesCount: null == likesCount
          ? _value.likesCount
          : likesCount // ignore: cast_nullable_to_non_nullable
              as int,
      isLiked: null == isLiked
          ? _value.isLiked
          : isLiked // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
      replies: freezed == replies
          ? _value.replies
          : replies // ignore: cast_nullable_to_non_nullable
              as List<Comment>?,
    ) as $Val);
  }

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<$Res>? get author {
    if (_value.author == null) {
      return null;
    }

    return $UserProfileCopyWith<$Res>(_value.author!, (value) {
      return _then(_value.copyWith(author: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CommentImplCopyWith<$Res> implements $CommentCopyWith<$Res> {
  factory _$$CommentImplCopyWith(
          _$CommentImpl value, $Res Function(_$CommentImpl) then) =
      __$$CommentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String postId,
      String userId,
      String content,
      String? parentCommentId,
      int likesCount,
      bool isLiked,
      DateTime createdAt,
      DateTime? updatedAt,
      UserProfile? author,
      List<Comment>? replies});

  @override
  $UserProfileCopyWith<$Res>? get author;
}

/// @nodoc
class __$$CommentImplCopyWithImpl<$Res>
    extends _$CommentCopyWithImpl<$Res, _$CommentImpl>
    implements _$$CommentImplCopyWith<$Res> {
  __$$CommentImplCopyWithImpl(
      _$CommentImpl _value, $Res Function(_$CommentImpl) _then)
      : super(_value, _then);

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? postId = null,
    Object? userId = null,
    Object? content = null,
    Object? parentCommentId = freezed,
    Object? likesCount = null,
    Object? isLiked = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? author = freezed,
    Object? replies = freezed,
  }) {
    return _then(_$CommentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      parentCommentId: freezed == parentCommentId
          ? _value.parentCommentId
          : parentCommentId // ignore: cast_nullable_to_non_nullable
              as String?,
      likesCount: null == likesCount
          ? _value.likesCount
          : likesCount // ignore: cast_nullable_to_non_nullable
              as int,
      isLiked: null == isLiked
          ? _value.isLiked
          : isLiked // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
      replies: freezed == replies
          ? _value._replies
          : replies // ignore: cast_nullable_to_non_nullable
              as List<Comment>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommentImpl implements _Comment {
  const _$CommentImpl(
      {required this.id,
      required this.postId,
      required this.userId,
      required this.content,
      this.parentCommentId,
      this.likesCount = 0,
      this.isLiked = false,
      required this.createdAt,
      this.updatedAt,
      this.author,
      final List<Comment>? replies})
      : _replies = replies;

  factory _$CommentImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentImplFromJson(json);

  @override
  final String id;
  @override
  final String postId;
  @override
  final String userId;
  @override
  final String content;
  @override
  final String? parentCommentId;
  @override
  @JsonKey()
  final int likesCount;
  @override
  @JsonKey()
  final bool isLiked;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
// Populated fields
  @override
  final UserProfile? author;
  final List<Comment>? _replies;
  @override
  List<Comment>? get replies {
    final value = _replies;
    if (value == null) return null;
    if (_replies is EqualUnmodifiableListView) return _replies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Comment(id: $id, postId: $postId, userId: $userId, content: $content, parentCommentId: $parentCommentId, likesCount: $likesCount, isLiked: $isLiked, createdAt: $createdAt, updatedAt: $updatedAt, author: $author, replies: $replies)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.parentCommentId, parentCommentId) ||
                other.parentCommentId == parentCommentId) &&
            (identical(other.likesCount, likesCount) ||
                other.likesCount == likesCount) &&
            (identical(other.isLiked, isLiked) || other.isLiked == isLiked) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.author, author) || other.author == author) &&
            const DeepCollectionEquality().equals(other._replies, _replies));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      postId,
      userId,
      content,
      parentCommentId,
      likesCount,
      isLiked,
      createdAt,
      updatedAt,
      author,
      const DeepCollectionEquality().hash(_replies));

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentImplCopyWith<_$CommentImpl> get copyWith =>
      __$$CommentImplCopyWithImpl<_$CommentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentImplToJson(
      this,
    );
  }
}

abstract class _Comment implements Comment {
  const factory _Comment(
      {required final String id,
      required final String postId,
      required final String userId,
      required final String content,
      final String? parentCommentId,
      final int likesCount,
      final bool isLiked,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final UserProfile? author,
      final List<Comment>? replies}) = _$CommentImpl;

  factory _Comment.fromJson(Map<String, dynamic> json) = _$CommentImpl.fromJson;

  @override
  String get id;
  @override
  String get postId;
  @override
  String get userId;
  @override
  String get content;
  @override
  String? get parentCommentId;
  @override
  int get likesCount;
  @override
  bool get isLiked;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt; // Populated fields
  @override
  UserProfile? get author;
  @override
  List<Comment>? get replies;

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentImplCopyWith<_$CommentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VenueInfo _$VenueInfoFromJson(Map<String, dynamic> json) {
  return _VenueInfo.fromJson(json);
}

/// @nodoc
mixin _$VenueInfo {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get logoUrl => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;

  /// Serializes this VenueInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VenueInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VenueInfoCopyWith<VenueInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VenueInfoCopyWith<$Res> {
  factory $VenueInfoCopyWith(VenueInfo value, $Res Function(VenueInfo) then) =
      _$VenueInfoCopyWithImpl<$Res, VenueInfo>;
  @useResult
  $Res call({String id, String name, String? logoUrl, String? address});
}

/// @nodoc
class _$VenueInfoCopyWithImpl<$Res, $Val extends VenueInfo>
    implements $VenueInfoCopyWith<$Res> {
  _$VenueInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VenueInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? logoUrl = freezed,
    Object? address = freezed,
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
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VenueInfoImplCopyWith<$Res>
    implements $VenueInfoCopyWith<$Res> {
  factory _$$VenueInfoImplCopyWith(
          _$VenueInfoImpl value, $Res Function(_$VenueInfoImpl) then) =
      __$$VenueInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String? logoUrl, String? address});
}

/// @nodoc
class __$$VenueInfoImplCopyWithImpl<$Res>
    extends _$VenueInfoCopyWithImpl<$Res, _$VenueInfoImpl>
    implements _$$VenueInfoImplCopyWith<$Res> {
  __$$VenueInfoImplCopyWithImpl(
      _$VenueInfoImpl _value, $Res Function(_$VenueInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of VenueInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? logoUrl = freezed,
    Object? address = freezed,
  }) {
    return _then(_$VenueInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VenueInfoImpl implements _VenueInfo {
  const _$VenueInfoImpl(
      {required this.id, required this.name, this.logoUrl, this.address});

  factory _$VenueInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$VenueInfoImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? logoUrl;
  @override
  final String? address;

  @override
  String toString() {
    return 'VenueInfo(id: $id, name: $name, logoUrl: $logoUrl, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VenueInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.address, address) || other.address == address));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, logoUrl, address);

  /// Create a copy of VenueInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VenueInfoImplCopyWith<_$VenueInfoImpl> get copyWith =>
      __$$VenueInfoImplCopyWithImpl<_$VenueInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VenueInfoImplToJson(
      this,
    );
  }
}

abstract class _VenueInfo implements VenueInfo {
  const factory _VenueInfo(
      {required final String id,
      required final String name,
      final String? logoUrl,
      final String? address}) = _$VenueInfoImpl;

  factory _VenueInfo.fromJson(Map<String, dynamic> json) =
      _$VenueInfoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get logoUrl;
  @override
  String? get address;

  /// Create a copy of VenueInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VenueInfoImplCopyWith<_$VenueInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Party _$PartyFromJson(Map<String, dynamic> json) {
  return _Party.fromJson(json);
}

/// @nodoc
mixin _$Party {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get organizerId => throw _privateConstructorUsedError;
  List<String> get memberIds => throw _privateConstructorUsedError;
  List<String> get invitedUserIds => throw _privateConstructorUsedError;
  String? get venueId => throw _privateConstructorUsedError;
  String? get eventId => throw _privateConstructorUsedError;
  DateTime? get scheduledFor => throw _privateConstructorUsedError;
  PartyStatus get status => throw _privateConstructorUsedError;
  int get maxMembers => throw _privateConstructorUsedError;
  DateTime get createdAt =>
      throw _privateConstructorUsedError; // Populated fields
  UserProfile? get organizer => throw _privateConstructorUsedError;
  List<UserProfile>? get members => throw _privateConstructorUsedError;
  VenueInfo? get venue => throw _privateConstructorUsedError;

  /// Serializes this Party to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Party
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PartyCopyWith<Party> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PartyCopyWith<$Res> {
  factory $PartyCopyWith(Party value, $Res Function(Party) then) =
      _$PartyCopyWithImpl<$Res, Party>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      String organizerId,
      List<String> memberIds,
      List<String> invitedUserIds,
      String? venueId,
      String? eventId,
      DateTime? scheduledFor,
      PartyStatus status,
      int maxMembers,
      DateTime createdAt,
      UserProfile? organizer,
      List<UserProfile>? members,
      VenueInfo? venue});

  $UserProfileCopyWith<$Res>? get organizer;
  $VenueInfoCopyWith<$Res>? get venue;
}

/// @nodoc
class _$PartyCopyWithImpl<$Res, $Val extends Party>
    implements $PartyCopyWith<$Res> {
  _$PartyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Party
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? organizerId = null,
    Object? memberIds = null,
    Object? invitedUserIds = null,
    Object? venueId = freezed,
    Object? eventId = freezed,
    Object? scheduledFor = freezed,
    Object? status = null,
    Object? maxMembers = null,
    Object? createdAt = null,
    Object? organizer = freezed,
    Object? members = freezed,
    Object? venue = freezed,
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
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      organizerId: null == organizerId
          ? _value.organizerId
          : organizerId // ignore: cast_nullable_to_non_nullable
              as String,
      memberIds: null == memberIds
          ? _value.memberIds
          : memberIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      invitedUserIds: null == invitedUserIds
          ? _value.invitedUserIds
          : invitedUserIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      venueId: freezed == venueId
          ? _value.venueId
          : venueId // ignore: cast_nullable_to_non_nullable
              as String?,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String?,
      scheduledFor: freezed == scheduledFor
          ? _value.scheduledFor
          : scheduledFor // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PartyStatus,
      maxMembers: null == maxMembers
          ? _value.maxMembers
          : maxMembers // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      organizer: freezed == organizer
          ? _value.organizer
          : organizer // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
      members: freezed == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<UserProfile>?,
      venue: freezed == venue
          ? _value.venue
          : venue // ignore: cast_nullable_to_non_nullable
              as VenueInfo?,
    ) as $Val);
  }

  /// Create a copy of Party
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<$Res>? get organizer {
    if (_value.organizer == null) {
      return null;
    }

    return $UserProfileCopyWith<$Res>(_value.organizer!, (value) {
      return _then(_value.copyWith(organizer: value) as $Val);
    });
  }

  /// Create a copy of Party
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VenueInfoCopyWith<$Res>? get venue {
    if (_value.venue == null) {
      return null;
    }

    return $VenueInfoCopyWith<$Res>(_value.venue!, (value) {
      return _then(_value.copyWith(venue: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PartyImplCopyWith<$Res> implements $PartyCopyWith<$Res> {
  factory _$$PartyImplCopyWith(
          _$PartyImpl value, $Res Function(_$PartyImpl) then) =
      __$$PartyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      String organizerId,
      List<String> memberIds,
      List<String> invitedUserIds,
      String? venueId,
      String? eventId,
      DateTime? scheduledFor,
      PartyStatus status,
      int maxMembers,
      DateTime createdAt,
      UserProfile? organizer,
      List<UserProfile>? members,
      VenueInfo? venue});

  @override
  $UserProfileCopyWith<$Res>? get organizer;
  @override
  $VenueInfoCopyWith<$Res>? get venue;
}

/// @nodoc
class __$$PartyImplCopyWithImpl<$Res>
    extends _$PartyCopyWithImpl<$Res, _$PartyImpl>
    implements _$$PartyImplCopyWith<$Res> {
  __$$PartyImplCopyWithImpl(
      _$PartyImpl _value, $Res Function(_$PartyImpl) _then)
      : super(_value, _then);

  /// Create a copy of Party
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? organizerId = null,
    Object? memberIds = null,
    Object? invitedUserIds = null,
    Object? venueId = freezed,
    Object? eventId = freezed,
    Object? scheduledFor = freezed,
    Object? status = null,
    Object? maxMembers = null,
    Object? createdAt = null,
    Object? organizer = freezed,
    Object? members = freezed,
    Object? venue = freezed,
  }) {
    return _then(_$PartyImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      organizerId: null == organizerId
          ? _value.organizerId
          : organizerId // ignore: cast_nullable_to_non_nullable
              as String,
      memberIds: null == memberIds
          ? _value._memberIds
          : memberIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      invitedUserIds: null == invitedUserIds
          ? _value._invitedUserIds
          : invitedUserIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      venueId: freezed == venueId
          ? _value.venueId
          : venueId // ignore: cast_nullable_to_non_nullable
              as String?,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String?,
      scheduledFor: freezed == scheduledFor
          ? _value.scheduledFor
          : scheduledFor // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PartyStatus,
      maxMembers: null == maxMembers
          ? _value.maxMembers
          : maxMembers // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      organizer: freezed == organizer
          ? _value.organizer
          : organizer // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
      members: freezed == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<UserProfile>?,
      venue: freezed == venue
          ? _value.venue
          : venue // ignore: cast_nullable_to_non_nullable
              as VenueInfo?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PartyImpl implements _Party {
  const _$PartyImpl(
      {required this.id,
      required this.name,
      this.description,
      required this.organizerId,
      required final List<String> memberIds,
      final List<String> invitedUserIds = const [],
      this.venueId,
      this.eventId,
      this.scheduledFor,
      this.status = PartyStatus.planning,
      this.maxMembers = 0,
      required this.createdAt,
      this.organizer,
      final List<UserProfile>? members,
      this.venue})
      : _memberIds = memberIds,
        _invitedUserIds = invitedUserIds,
        _members = members;

  factory _$PartyImpl.fromJson(Map<String, dynamic> json) =>
      _$$PartyImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String organizerId;
  final List<String> _memberIds;
  @override
  List<String> get memberIds {
    if (_memberIds is EqualUnmodifiableListView) return _memberIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_memberIds);
  }

  final List<String> _invitedUserIds;
  @override
  @JsonKey()
  List<String> get invitedUserIds {
    if (_invitedUserIds is EqualUnmodifiableListView) return _invitedUserIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_invitedUserIds);
  }

  @override
  final String? venueId;
  @override
  final String? eventId;
  @override
  final DateTime? scheduledFor;
  @override
  @JsonKey()
  final PartyStatus status;
  @override
  @JsonKey()
  final int maxMembers;
  @override
  final DateTime createdAt;
// Populated fields
  @override
  final UserProfile? organizer;
  final List<UserProfile>? _members;
  @override
  List<UserProfile>? get members {
    final value = _members;
    if (value == null) return null;
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final VenueInfo? venue;

  @override
  String toString() {
    return 'Party(id: $id, name: $name, description: $description, organizerId: $organizerId, memberIds: $memberIds, invitedUserIds: $invitedUserIds, venueId: $venueId, eventId: $eventId, scheduledFor: $scheduledFor, status: $status, maxMembers: $maxMembers, createdAt: $createdAt, organizer: $organizer, members: $members, venue: $venue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PartyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.organizerId, organizerId) ||
                other.organizerId == organizerId) &&
            const DeepCollectionEquality()
                .equals(other._memberIds, _memberIds) &&
            const DeepCollectionEquality()
                .equals(other._invitedUserIds, _invitedUserIds) &&
            (identical(other.venueId, venueId) || other.venueId == venueId) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.scheduledFor, scheduledFor) ||
                other.scheduledFor == scheduledFor) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.maxMembers, maxMembers) ||
                other.maxMembers == maxMembers) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.organizer, organizer) ||
                other.organizer == organizer) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            (identical(other.venue, venue) || other.venue == venue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      organizerId,
      const DeepCollectionEquality().hash(_memberIds),
      const DeepCollectionEquality().hash(_invitedUserIds),
      venueId,
      eventId,
      scheduledFor,
      status,
      maxMembers,
      createdAt,
      organizer,
      const DeepCollectionEquality().hash(_members),
      venue);

  /// Create a copy of Party
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PartyImplCopyWith<_$PartyImpl> get copyWith =>
      __$$PartyImplCopyWithImpl<_$PartyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PartyImplToJson(
      this,
    );
  }
}

abstract class _Party implements Party {
  const factory _Party(
      {required final String id,
      required final String name,
      final String? description,
      required final String organizerId,
      required final List<String> memberIds,
      final List<String> invitedUserIds,
      final String? venueId,
      final String? eventId,
      final DateTime? scheduledFor,
      final PartyStatus status,
      final int maxMembers,
      required final DateTime createdAt,
      final UserProfile? organizer,
      final List<UserProfile>? members,
      final VenueInfo? venue}) = _$PartyImpl;

  factory _Party.fromJson(Map<String, dynamic> json) = _$PartyImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  String get organizerId;
  @override
  List<String> get memberIds;
  @override
  List<String> get invitedUserIds;
  @override
  String? get venueId;
  @override
  String? get eventId;
  @override
  DateTime? get scheduledFor;
  @override
  PartyStatus get status;
  @override
  int get maxMembers;
  @override
  DateTime get createdAt; // Populated fields
  @override
  UserProfile? get organizer;
  @override
  List<UserProfile>? get members;
  @override
  VenueInfo? get venue;

  /// Create a copy of Party
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PartyImplCopyWith<_$PartyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PartyInvitation _$PartyInvitationFromJson(Map<String, dynamic> json) {
  return _PartyInvitation.fromJson(json);
}

/// @nodoc
mixin _$PartyInvitation {
  String get id => throw _privateConstructorUsedError;
  String get partyId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get invitedBy => throw _privateConstructorUsedError;
  InvitationStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get respondedAt =>
      throw _privateConstructorUsedError; // Populated fields
  Party? get party => throw _privateConstructorUsedError;
  UserProfile? get inviter => throw _privateConstructorUsedError;

  /// Serializes this PartyInvitation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PartyInvitation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PartyInvitationCopyWith<PartyInvitation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PartyInvitationCopyWith<$Res> {
  factory $PartyInvitationCopyWith(
          PartyInvitation value, $Res Function(PartyInvitation) then) =
      _$PartyInvitationCopyWithImpl<$Res, PartyInvitation>;
  @useResult
  $Res call(
      {String id,
      String partyId,
      String userId,
      String invitedBy,
      InvitationStatus status,
      DateTime createdAt,
      DateTime? respondedAt,
      Party? party,
      UserProfile? inviter});

  $PartyCopyWith<$Res>? get party;
  $UserProfileCopyWith<$Res>? get inviter;
}

/// @nodoc
class _$PartyInvitationCopyWithImpl<$Res, $Val extends PartyInvitation>
    implements $PartyInvitationCopyWith<$Res> {
  _$PartyInvitationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PartyInvitation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? partyId = null,
    Object? userId = null,
    Object? invitedBy = null,
    Object? status = null,
    Object? createdAt = null,
    Object? respondedAt = freezed,
    Object? party = freezed,
    Object? inviter = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      partyId: null == partyId
          ? _value.partyId
          : partyId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      invitedBy: null == invitedBy
          ? _value.invitedBy
          : invitedBy // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as InvitationStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      party: freezed == party
          ? _value.party
          : party // ignore: cast_nullable_to_non_nullable
              as Party?,
      inviter: freezed == inviter
          ? _value.inviter
          : inviter // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
    ) as $Val);
  }

  /// Create a copy of PartyInvitation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PartyCopyWith<$Res>? get party {
    if (_value.party == null) {
      return null;
    }

    return $PartyCopyWith<$Res>(_value.party!, (value) {
      return _then(_value.copyWith(party: value) as $Val);
    });
  }

  /// Create a copy of PartyInvitation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<$Res>? get inviter {
    if (_value.inviter == null) {
      return null;
    }

    return $UserProfileCopyWith<$Res>(_value.inviter!, (value) {
      return _then(_value.copyWith(inviter: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PartyInvitationImplCopyWith<$Res>
    implements $PartyInvitationCopyWith<$Res> {
  factory _$$PartyInvitationImplCopyWith(_$PartyInvitationImpl value,
          $Res Function(_$PartyInvitationImpl) then) =
      __$$PartyInvitationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String partyId,
      String userId,
      String invitedBy,
      InvitationStatus status,
      DateTime createdAt,
      DateTime? respondedAt,
      Party? party,
      UserProfile? inviter});

  @override
  $PartyCopyWith<$Res>? get party;
  @override
  $UserProfileCopyWith<$Res>? get inviter;
}

/// @nodoc
class __$$PartyInvitationImplCopyWithImpl<$Res>
    extends _$PartyInvitationCopyWithImpl<$Res, _$PartyInvitationImpl>
    implements _$$PartyInvitationImplCopyWith<$Res> {
  __$$PartyInvitationImplCopyWithImpl(
      _$PartyInvitationImpl _value, $Res Function(_$PartyInvitationImpl) _then)
      : super(_value, _then);

  /// Create a copy of PartyInvitation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? partyId = null,
    Object? userId = null,
    Object? invitedBy = null,
    Object? status = null,
    Object? createdAt = null,
    Object? respondedAt = freezed,
    Object? party = freezed,
    Object? inviter = freezed,
  }) {
    return _then(_$PartyInvitationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      partyId: null == partyId
          ? _value.partyId
          : partyId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      invitedBy: null == invitedBy
          ? _value.invitedBy
          : invitedBy // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as InvitationStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      party: freezed == party
          ? _value.party
          : party // ignore: cast_nullable_to_non_nullable
              as Party?,
      inviter: freezed == inviter
          ? _value.inviter
          : inviter // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PartyInvitationImpl implements _PartyInvitation {
  const _$PartyInvitationImpl(
      {required this.id,
      required this.partyId,
      required this.userId,
      required this.invitedBy,
      this.status = InvitationStatus.pending,
      required this.createdAt,
      this.respondedAt,
      this.party,
      this.inviter});

  factory _$PartyInvitationImpl.fromJson(Map<String, dynamic> json) =>
      _$$PartyInvitationImplFromJson(json);

  @override
  final String id;
  @override
  final String partyId;
  @override
  final String userId;
  @override
  final String invitedBy;
  @override
  @JsonKey()
  final InvitationStatus status;
  @override
  final DateTime createdAt;
  @override
  final DateTime? respondedAt;
// Populated fields
  @override
  final Party? party;
  @override
  final UserProfile? inviter;

  @override
  String toString() {
    return 'PartyInvitation(id: $id, partyId: $partyId, userId: $userId, invitedBy: $invitedBy, status: $status, createdAt: $createdAt, respondedAt: $respondedAt, party: $party, inviter: $inviter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PartyInvitationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.partyId, partyId) || other.partyId == partyId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.invitedBy, invitedBy) ||
                other.invitedBy == invitedBy) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.respondedAt, respondedAt) ||
                other.respondedAt == respondedAt) &&
            (identical(other.party, party) || other.party == party) &&
            (identical(other.inviter, inviter) || other.inviter == inviter));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, partyId, userId, invitedBy,
      status, createdAt, respondedAt, party, inviter);

  /// Create a copy of PartyInvitation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PartyInvitationImplCopyWith<_$PartyInvitationImpl> get copyWith =>
      __$$PartyInvitationImplCopyWithImpl<_$PartyInvitationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PartyInvitationImplToJson(
      this,
    );
  }
}

abstract class _PartyInvitation implements PartyInvitation {
  const factory _PartyInvitation(
      {required final String id,
      required final String partyId,
      required final String userId,
      required final String invitedBy,
      final InvitationStatus status,
      required final DateTime createdAt,
      final DateTime? respondedAt,
      final Party? party,
      final UserProfile? inviter}) = _$PartyInvitationImpl;

  factory _PartyInvitation.fromJson(Map<String, dynamic> json) =
      _$PartyInvitationImpl.fromJson;

  @override
  String get id;
  @override
  String get partyId;
  @override
  String get userId;
  @override
  String get invitedBy;
  @override
  InvitationStatus get status;
  @override
  DateTime get createdAt;
  @override
  DateTime? get respondedAt; // Populated fields
  @override
  Party? get party;
  @override
  UserProfile? get inviter;

  /// Create a copy of PartyInvitation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PartyInvitationImplCopyWith<_$PartyInvitationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PhotoAlbum _$PhotoAlbumFromJson(Map<String, dynamic> json) {
  return _PhotoAlbum.fromJson(json);
}

/// @nodoc
mixin _$PhotoAlbum {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  AlbumVisibility get visibility => throw _privateConstructorUsedError;
  String? get coverPhotoUrl => throw _privateConstructorUsedError;
  int get photoCount => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // Populated fields
  UserProfile? get owner => throw _privateConstructorUsedError;
  List<Photo>? get photos => throw _privateConstructorUsedError;

  /// Serializes this PhotoAlbum to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PhotoAlbum
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PhotoAlbumCopyWith<PhotoAlbum> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhotoAlbumCopyWith<$Res> {
  factory $PhotoAlbumCopyWith(
          PhotoAlbum value, $Res Function(PhotoAlbum) then) =
      _$PhotoAlbumCopyWithImpl<$Res, PhotoAlbum>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String name,
      String? description,
      AlbumVisibility visibility,
      String? coverPhotoUrl,
      int photoCount,
      DateTime createdAt,
      DateTime? updatedAt,
      UserProfile? owner,
      List<Photo>? photos});

  $UserProfileCopyWith<$Res>? get owner;
}

/// @nodoc
class _$PhotoAlbumCopyWithImpl<$Res, $Val extends PhotoAlbum>
    implements $PhotoAlbumCopyWith<$Res> {
  _$PhotoAlbumCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PhotoAlbum
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? description = freezed,
    Object? visibility = null,
    Object? coverPhotoUrl = freezed,
    Object? photoCount = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? owner = freezed,
    Object? photos = freezed,
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
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as AlbumVisibility,
      coverPhotoUrl: freezed == coverPhotoUrl
          ? _value.coverPhotoUrl
          : coverPhotoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      photoCount: null == photoCount
          ? _value.photoCount
          : photoCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      owner: freezed == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
      photos: freezed == photos
          ? _value.photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<Photo>?,
    ) as $Val);
  }

  /// Create a copy of PhotoAlbum
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<$Res>? get owner {
    if (_value.owner == null) {
      return null;
    }

    return $UserProfileCopyWith<$Res>(_value.owner!, (value) {
      return _then(_value.copyWith(owner: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PhotoAlbumImplCopyWith<$Res>
    implements $PhotoAlbumCopyWith<$Res> {
  factory _$$PhotoAlbumImplCopyWith(
          _$PhotoAlbumImpl value, $Res Function(_$PhotoAlbumImpl) then) =
      __$$PhotoAlbumImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String name,
      String? description,
      AlbumVisibility visibility,
      String? coverPhotoUrl,
      int photoCount,
      DateTime createdAt,
      DateTime? updatedAt,
      UserProfile? owner,
      List<Photo>? photos});

  @override
  $UserProfileCopyWith<$Res>? get owner;
}

/// @nodoc
class __$$PhotoAlbumImplCopyWithImpl<$Res>
    extends _$PhotoAlbumCopyWithImpl<$Res, _$PhotoAlbumImpl>
    implements _$$PhotoAlbumImplCopyWith<$Res> {
  __$$PhotoAlbumImplCopyWithImpl(
      _$PhotoAlbumImpl _value, $Res Function(_$PhotoAlbumImpl) _then)
      : super(_value, _then);

  /// Create a copy of PhotoAlbum
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? description = freezed,
    Object? visibility = null,
    Object? coverPhotoUrl = freezed,
    Object? photoCount = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? owner = freezed,
    Object? photos = freezed,
  }) {
    return _then(_$PhotoAlbumImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as AlbumVisibility,
      coverPhotoUrl: freezed == coverPhotoUrl
          ? _value.coverPhotoUrl
          : coverPhotoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      photoCount: null == photoCount
          ? _value.photoCount
          : photoCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      owner: freezed == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
      photos: freezed == photos
          ? _value._photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<Photo>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PhotoAlbumImpl implements _PhotoAlbum {
  const _$PhotoAlbumImpl(
      {required this.id,
      required this.userId,
      required this.name,
      this.description,
      this.visibility = AlbumVisibility.friends,
      this.coverPhotoUrl,
      this.photoCount = 0,
      required this.createdAt,
      this.updatedAt,
      this.owner,
      final List<Photo>? photos})
      : _photos = photos;

  factory _$PhotoAlbumImpl.fromJson(Map<String, dynamic> json) =>
      _$$PhotoAlbumImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey()
  final AlbumVisibility visibility;
  @override
  final String? coverPhotoUrl;
  @override
  @JsonKey()
  final int photoCount;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
// Populated fields
  @override
  final UserProfile? owner;
  final List<Photo>? _photos;
  @override
  List<Photo>? get photos {
    final value = _photos;
    if (value == null) return null;
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'PhotoAlbum(id: $id, userId: $userId, name: $name, description: $description, visibility: $visibility, coverPhotoUrl: $coverPhotoUrl, photoCount: $photoCount, createdAt: $createdAt, updatedAt: $updatedAt, owner: $owner, photos: $photos)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhotoAlbumImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            (identical(other.coverPhotoUrl, coverPhotoUrl) ||
                other.coverPhotoUrl == coverPhotoUrl) &&
            (identical(other.photoCount, photoCount) ||
                other.photoCount == photoCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            const DeepCollectionEquality().equals(other._photos, _photos));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      name,
      description,
      visibility,
      coverPhotoUrl,
      photoCount,
      createdAt,
      updatedAt,
      owner,
      const DeepCollectionEquality().hash(_photos));

  /// Create a copy of PhotoAlbum
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PhotoAlbumImplCopyWith<_$PhotoAlbumImpl> get copyWith =>
      __$$PhotoAlbumImplCopyWithImpl<_$PhotoAlbumImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PhotoAlbumImplToJson(
      this,
    );
  }
}

abstract class _PhotoAlbum implements PhotoAlbum {
  const factory _PhotoAlbum(
      {required final String id,
      required final String userId,
      required final String name,
      final String? description,
      final AlbumVisibility visibility,
      final String? coverPhotoUrl,
      final int photoCount,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final UserProfile? owner,
      final List<Photo>? photos}) = _$PhotoAlbumImpl;

  factory _PhotoAlbum.fromJson(Map<String, dynamic> json) =
      _$PhotoAlbumImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get name;
  @override
  String? get description;
  @override
  AlbumVisibility get visibility;
  @override
  String? get coverPhotoUrl;
  @override
  int get photoCount;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt; // Populated fields
  @override
  UserProfile? get owner;
  @override
  List<Photo>? get photos;

  /// Create a copy of PhotoAlbum
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhotoAlbumImplCopyWith<_$PhotoAlbumImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Photo _$PhotoFromJson(Map<String, dynamic> json) {
  return _Photo.fromJson(json);
}

/// @nodoc
mixin _$Photo {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get albumId => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  String? get caption => throw _privateConstructorUsedError;
  List<String> get taggedUserIds => throw _privateConstructorUsedError;
  String? get venueId => throw _privateConstructorUsedError;
  String? get eventId => throw _privateConstructorUsedError;
  int get likesCount => throw _privateConstructorUsedError;
  int get commentsCount => throw _privateConstructorUsedError;
  bool get isLiked => throw _privateConstructorUsedError;
  DateTime get createdAt =>
      throw _privateConstructorUsedError; // Populated fields
  UserProfile? get owner => throw _privateConstructorUsedError;
  List<UserProfile>? get taggedUsers => throw _privateConstructorUsedError;
  VenueInfo? get venue => throw _privateConstructorUsedError;

  /// Serializes this Photo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Photo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PhotoCopyWith<Photo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhotoCopyWith<$Res> {
  factory $PhotoCopyWith(Photo value, $Res Function(Photo) then) =
      _$PhotoCopyWithImpl<$Res, Photo>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String? albumId,
      String url,
      String? thumbnailUrl,
      String? caption,
      List<String> taggedUserIds,
      String? venueId,
      String? eventId,
      int likesCount,
      int commentsCount,
      bool isLiked,
      DateTime createdAt,
      UserProfile? owner,
      List<UserProfile>? taggedUsers,
      VenueInfo? venue});

  $UserProfileCopyWith<$Res>? get owner;
  $VenueInfoCopyWith<$Res>? get venue;
}

/// @nodoc
class _$PhotoCopyWithImpl<$Res, $Val extends Photo>
    implements $PhotoCopyWith<$Res> {
  _$PhotoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Photo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? albumId = freezed,
    Object? url = null,
    Object? thumbnailUrl = freezed,
    Object? caption = freezed,
    Object? taggedUserIds = null,
    Object? venueId = freezed,
    Object? eventId = freezed,
    Object? likesCount = null,
    Object? commentsCount = null,
    Object? isLiked = null,
    Object? createdAt = null,
    Object? owner = freezed,
    Object? taggedUsers = freezed,
    Object? venue = freezed,
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
      albumId: freezed == albumId
          ? _value.albumId
          : albumId // ignore: cast_nullable_to_non_nullable
              as String?,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      caption: freezed == caption
          ? _value.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String?,
      taggedUserIds: null == taggedUserIds
          ? _value.taggedUserIds
          : taggedUserIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      venueId: freezed == venueId
          ? _value.venueId
          : venueId // ignore: cast_nullable_to_non_nullable
              as String?,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String?,
      likesCount: null == likesCount
          ? _value.likesCount
          : likesCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentsCount: null == commentsCount
          ? _value.commentsCount
          : commentsCount // ignore: cast_nullable_to_non_nullable
              as int,
      isLiked: null == isLiked
          ? _value.isLiked
          : isLiked // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      owner: freezed == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
      taggedUsers: freezed == taggedUsers
          ? _value.taggedUsers
          : taggedUsers // ignore: cast_nullable_to_non_nullable
              as List<UserProfile>?,
      venue: freezed == venue
          ? _value.venue
          : venue // ignore: cast_nullable_to_non_nullable
              as VenueInfo?,
    ) as $Val);
  }

  /// Create a copy of Photo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<$Res>? get owner {
    if (_value.owner == null) {
      return null;
    }

    return $UserProfileCopyWith<$Res>(_value.owner!, (value) {
      return _then(_value.copyWith(owner: value) as $Val);
    });
  }

  /// Create a copy of Photo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VenueInfoCopyWith<$Res>? get venue {
    if (_value.venue == null) {
      return null;
    }

    return $VenueInfoCopyWith<$Res>(_value.venue!, (value) {
      return _then(_value.copyWith(venue: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PhotoImplCopyWith<$Res> implements $PhotoCopyWith<$Res> {
  factory _$$PhotoImplCopyWith(
          _$PhotoImpl value, $Res Function(_$PhotoImpl) then) =
      __$$PhotoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String? albumId,
      String url,
      String? thumbnailUrl,
      String? caption,
      List<String> taggedUserIds,
      String? venueId,
      String? eventId,
      int likesCount,
      int commentsCount,
      bool isLiked,
      DateTime createdAt,
      UserProfile? owner,
      List<UserProfile>? taggedUsers,
      VenueInfo? venue});

  @override
  $UserProfileCopyWith<$Res>? get owner;
  @override
  $VenueInfoCopyWith<$Res>? get venue;
}

/// @nodoc
class __$$PhotoImplCopyWithImpl<$Res>
    extends _$PhotoCopyWithImpl<$Res, _$PhotoImpl>
    implements _$$PhotoImplCopyWith<$Res> {
  __$$PhotoImplCopyWithImpl(
      _$PhotoImpl _value, $Res Function(_$PhotoImpl) _then)
      : super(_value, _then);

  /// Create a copy of Photo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? albumId = freezed,
    Object? url = null,
    Object? thumbnailUrl = freezed,
    Object? caption = freezed,
    Object? taggedUserIds = null,
    Object? venueId = freezed,
    Object? eventId = freezed,
    Object? likesCount = null,
    Object? commentsCount = null,
    Object? isLiked = null,
    Object? createdAt = null,
    Object? owner = freezed,
    Object? taggedUsers = freezed,
    Object? venue = freezed,
  }) {
    return _then(_$PhotoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      albumId: freezed == albumId
          ? _value.albumId
          : albumId // ignore: cast_nullable_to_non_nullable
              as String?,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      caption: freezed == caption
          ? _value.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String?,
      taggedUserIds: null == taggedUserIds
          ? _value._taggedUserIds
          : taggedUserIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      venueId: freezed == venueId
          ? _value.venueId
          : venueId // ignore: cast_nullable_to_non_nullable
              as String?,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String?,
      likesCount: null == likesCount
          ? _value.likesCount
          : likesCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentsCount: null == commentsCount
          ? _value.commentsCount
          : commentsCount // ignore: cast_nullable_to_non_nullable
              as int,
      isLiked: null == isLiked
          ? _value.isLiked
          : isLiked // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      owner: freezed == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
      taggedUsers: freezed == taggedUsers
          ? _value._taggedUsers
          : taggedUsers // ignore: cast_nullable_to_non_nullable
              as List<UserProfile>?,
      venue: freezed == venue
          ? _value.venue
          : venue // ignore: cast_nullable_to_non_nullable
              as VenueInfo?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PhotoImpl implements _Photo {
  const _$PhotoImpl(
      {required this.id,
      required this.userId,
      this.albumId,
      required this.url,
      this.thumbnailUrl,
      this.caption,
      final List<String> taggedUserIds = const [],
      this.venueId,
      this.eventId,
      this.likesCount = 0,
      this.commentsCount = 0,
      this.isLiked = false,
      required this.createdAt,
      this.owner,
      final List<UserProfile>? taggedUsers,
      this.venue})
      : _taggedUserIds = taggedUserIds,
        _taggedUsers = taggedUsers;

  factory _$PhotoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PhotoImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String? albumId;
  @override
  final String url;
  @override
  final String? thumbnailUrl;
  @override
  final String? caption;
  final List<String> _taggedUserIds;
  @override
  @JsonKey()
  List<String> get taggedUserIds {
    if (_taggedUserIds is EqualUnmodifiableListView) return _taggedUserIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_taggedUserIds);
  }

  @override
  final String? venueId;
  @override
  final String? eventId;
  @override
  @JsonKey()
  final int likesCount;
  @override
  @JsonKey()
  final int commentsCount;
  @override
  @JsonKey()
  final bool isLiked;
  @override
  final DateTime createdAt;
// Populated fields
  @override
  final UserProfile? owner;
  final List<UserProfile>? _taggedUsers;
  @override
  List<UserProfile>? get taggedUsers {
    final value = _taggedUsers;
    if (value == null) return null;
    if (_taggedUsers is EqualUnmodifiableListView) return _taggedUsers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final VenueInfo? venue;

  @override
  String toString() {
    return 'Photo(id: $id, userId: $userId, albumId: $albumId, url: $url, thumbnailUrl: $thumbnailUrl, caption: $caption, taggedUserIds: $taggedUserIds, venueId: $venueId, eventId: $eventId, likesCount: $likesCount, commentsCount: $commentsCount, isLiked: $isLiked, createdAt: $createdAt, owner: $owner, taggedUsers: $taggedUsers, venue: $venue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhotoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.albumId, albumId) || other.albumId == albumId) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            const DeepCollectionEquality()
                .equals(other._taggedUserIds, _taggedUserIds) &&
            (identical(other.venueId, venueId) || other.venueId == venueId) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.likesCount, likesCount) ||
                other.likesCount == likesCount) &&
            (identical(other.commentsCount, commentsCount) ||
                other.commentsCount == commentsCount) &&
            (identical(other.isLiked, isLiked) || other.isLiked == isLiked) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            const DeepCollectionEquality()
                .equals(other._taggedUsers, _taggedUsers) &&
            (identical(other.venue, venue) || other.venue == venue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      albumId,
      url,
      thumbnailUrl,
      caption,
      const DeepCollectionEquality().hash(_taggedUserIds),
      venueId,
      eventId,
      likesCount,
      commentsCount,
      isLiked,
      createdAt,
      owner,
      const DeepCollectionEquality().hash(_taggedUsers),
      venue);

  /// Create a copy of Photo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PhotoImplCopyWith<_$PhotoImpl> get copyWith =>
      __$$PhotoImplCopyWithImpl<_$PhotoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PhotoImplToJson(
      this,
    );
  }
}

abstract class _Photo implements Photo {
  const factory _Photo(
      {required final String id,
      required final String userId,
      final String? albumId,
      required final String url,
      final String? thumbnailUrl,
      final String? caption,
      final List<String> taggedUserIds,
      final String? venueId,
      final String? eventId,
      final int likesCount,
      final int commentsCount,
      final bool isLiked,
      required final DateTime createdAt,
      final UserProfile? owner,
      final List<UserProfile>? taggedUsers,
      final VenueInfo? venue}) = _$PhotoImpl;

  factory _Photo.fromJson(Map<String, dynamic> json) = _$PhotoImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String? get albumId;
  @override
  String get url;
  @override
  String? get thumbnailUrl;
  @override
  String? get caption;
  @override
  List<String> get taggedUserIds;
  @override
  String? get venueId;
  @override
  String? get eventId;
  @override
  int get likesCount;
  @override
  int get commentsCount;
  @override
  bool get isLiked;
  @override
  DateTime get createdAt; // Populated fields
  @override
  UserProfile? get owner;
  @override
  List<UserProfile>? get taggedUsers;
  @override
  VenueInfo? get venue;

  /// Create a copy of Photo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhotoImplCopyWith<_$PhotoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Share _$ShareFromJson(Map<String, dynamic> json) {
  return _Share.fromJson(json);
}

/// @nodoc
mixin _$Share {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  ShareType get type => throw _privateConstructorUsedError;
  String get itemId => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  List<String> get sharedWith => throw _privateConstructorUsedError;
  DateTime get createdAt =>
      throw _privateConstructorUsedError; // Populated fields
  Map<String, dynamic>? get itemData => throw _privateConstructorUsedError;

  /// Serializes this Share to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Share
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShareCopyWith<Share> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShareCopyWith<$Res> {
  factory $ShareCopyWith(Share value, $Res Function(Share) then) =
      _$ShareCopyWithImpl<$Res, Share>;
  @useResult
  $Res call(
      {String id,
      String userId,
      ShareType type,
      String itemId,
      String? message,
      List<String> sharedWith,
      DateTime createdAt,
      Map<String, dynamic>? itemData});
}

/// @nodoc
class _$ShareCopyWithImpl<$Res, $Val extends Share>
    implements $ShareCopyWith<$Res> {
  _$ShareCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Share
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? itemId = null,
    Object? message = freezed,
    Object? sharedWith = null,
    Object? createdAt = null,
    Object? itemData = freezed,
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
              as ShareType,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      sharedWith: null == sharedWith
          ? _value.sharedWith
          : sharedWith // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      itemData: freezed == itemData
          ? _value.itemData
          : itemData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShareImplCopyWith<$Res> implements $ShareCopyWith<$Res> {
  factory _$$ShareImplCopyWith(
          _$ShareImpl value, $Res Function(_$ShareImpl) then) =
      __$$ShareImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      ShareType type,
      String itemId,
      String? message,
      List<String> sharedWith,
      DateTime createdAt,
      Map<String, dynamic>? itemData});
}

/// @nodoc
class __$$ShareImplCopyWithImpl<$Res>
    extends _$ShareCopyWithImpl<$Res, _$ShareImpl>
    implements _$$ShareImplCopyWith<$Res> {
  __$$ShareImplCopyWithImpl(
      _$ShareImpl _value, $Res Function(_$ShareImpl) _then)
      : super(_value, _then);

  /// Create a copy of Share
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? itemId = null,
    Object? message = freezed,
    Object? sharedWith = null,
    Object? createdAt = null,
    Object? itemData = freezed,
  }) {
    return _then(_$ShareImpl(
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
              as ShareType,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      sharedWith: null == sharedWith
          ? _value._sharedWith
          : sharedWith // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      itemData: freezed == itemData
          ? _value._itemData
          : itemData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShareImpl implements _Share {
  const _$ShareImpl(
      {required this.id,
      required this.userId,
      required this.type,
      required this.itemId,
      this.message,
      final List<String> sharedWith = const [],
      required this.createdAt,
      final Map<String, dynamic>? itemData})
      : _sharedWith = sharedWith,
        _itemData = itemData;

  factory _$ShareImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShareImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final ShareType type;
  @override
  final String itemId;
  @override
  final String? message;
  final List<String> _sharedWith;
  @override
  @JsonKey()
  List<String> get sharedWith {
    if (_sharedWith is EqualUnmodifiableListView) return _sharedWith;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sharedWith);
  }

  @override
  final DateTime createdAt;
// Populated fields
  final Map<String, dynamic>? _itemData;
// Populated fields
  @override
  Map<String, dynamic>? get itemData {
    final value = _itemData;
    if (value == null) return null;
    if (_itemData is EqualUnmodifiableMapView) return _itemData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Share(id: $id, userId: $userId, type: $type, itemId: $itemId, message: $message, sharedWith: $sharedWith, createdAt: $createdAt, itemData: $itemData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShareImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality()
                .equals(other._sharedWith, _sharedWith) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._itemData, _itemData));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      type,
      itemId,
      message,
      const DeepCollectionEquality().hash(_sharedWith),
      createdAt,
      const DeepCollectionEquality().hash(_itemData));

  /// Create a copy of Share
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShareImplCopyWith<_$ShareImpl> get copyWith =>
      __$$ShareImplCopyWithImpl<_$ShareImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShareImplToJson(
      this,
    );
  }
}

abstract class _Share implements Share {
  const factory _Share(
      {required final String id,
      required final String userId,
      required final ShareType type,
      required final String itemId,
      final String? message,
      final List<String> sharedWith,
      required final DateTime createdAt,
      final Map<String, dynamic>? itemData}) = _$ShareImpl;

  factory _Share.fromJson(Map<String, dynamic> json) = _$ShareImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  ShareType get type;
  @override
  String get itemId;
  @override
  String? get message;
  @override
  List<String> get sharedWith;
  @override
  DateTime get createdAt; // Populated fields
  @override
  Map<String, dynamic>? get itemData;

  /// Create a copy of Share
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShareImplCopyWith<_$ShareImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
