// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FriendshipImpl _$$FriendshipImplFromJson(Map<String, dynamic> json) =>
    _$FriendshipImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      friendId: json['friendId'] as String,
      status: $enumDecode(_$FriendshipStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      acceptedAt: json['acceptedAt'] == null
          ? null
          : DateTime.parse(json['acceptedAt'] as String),
      blockedAt: json['blockedAt'] == null
          ? null
          : DateTime.parse(json['blockedAt'] as String),
      friend: json['friend'] == null
          ? null
          : UserProfile.fromJson(json['friend'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$FriendshipImplToJson(_$FriendshipImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'friendId': instance.friendId,
      'status': _$FriendshipStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'acceptedAt': instance.acceptedAt?.toIso8601String(),
      'blockedAt': instance.blockedAt?.toIso8601String(),
      'friend': instance.friend,
    };

const _$FriendshipStatusEnumMap = {
  FriendshipStatus.pending: 'pending',
  FriendshipStatus.accepted: 'accepted',
  FriendshipStatus.blocked: 'blocked',
  FriendshipStatus.rejected: 'rejected',
};

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      friendsCount: (json['friendsCount'] as num?)?.toInt() ?? 0,
      postsCount: (json['postsCount'] as num?)?.toInt() ?? 0,
      isOnline: json['isOnline'] as bool? ?? false,
      lastSeen: json['lastSeen'] == null
          ? null
          : DateTime.parse(json['lastSeen'] as String),
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'fullName': instance.fullName,
      'avatarUrl': instance.avatarUrl,
      'bio': instance.bio,
      'location': instance.location,
      'friendsCount': instance.friendsCount,
      'postsCount': instance.postsCount,
      'isOnline': instance.isOnline,
      'lastSeen': instance.lastSeen?.toIso8601String(),
    };

_$ConversationImpl _$$ConversationImplFromJson(Map<String, dynamic> json) =>
    _$ConversationImpl(
      id: json['id'] as String,
      type: $enumDecode(_$ConversationTypeEnumMap, json['type']),
      participantIds: (json['participantIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      name: json['name'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      lastMessageAt: json['lastMessageAt'] == null
          ? null
          : DateTime.parse(json['lastMessageAt'] as String),
      lastMessage: json['lastMessage'] as String?,
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      participants: (json['participants'] as List<dynamic>?)
          ?.map((e) => UserProfile.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastMessageObj: json['lastMessageObj'] == null
          ? null
          : Message.fromJson(json['lastMessageObj'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ConversationImplToJson(_$ConversationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$ConversationTypeEnumMap[instance.type]!,
      'participantIds': instance.participantIds,
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
      'lastMessageAt': instance.lastMessageAt?.toIso8601String(),
      'lastMessage': instance.lastMessage,
      'unreadCount': instance.unreadCount,
      'participants': instance.participants,
      'lastMessageObj': instance.lastMessageObj,
    };

const _$ConversationTypeEnumMap = {
  ConversationType.direct: 'direct',
  ConversationType.group: 'group',
};

_$MessageImpl _$$MessageImplFromJson(Map<String, dynamic> json) =>
    _$MessageImpl(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      content: json['content'] as String,
      messageType: json['messageType'] as String? ?? 'text',
      status: $enumDecodeNullable(_$MessageStatusEnumMap, json['status']) ??
          MessageStatus.sent,
      sentAt: DateTime.parse(json['sentAt'] as String),
      readAt: json['readAt'] == null
          ? null
          : DateTime.parse(json['readAt'] as String),
      isEdited: json['isEdited'] as bool? ?? false,
      editedAt: json['editedAt'] == null
          ? null
          : DateTime.parse(json['editedAt'] as String),
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      metadata: json['metadata'] as Map<String, dynamic>?,
      sender: json['sender'] == null
          ? null
          : UserProfile.fromJson(json['sender'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$MessageImplToJson(_$MessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'senderId': instance.senderId,
      'content': instance.content,
      'messageType': instance.messageType,
      'status': _$MessageStatusEnumMap[instance.status]!,
      'sentAt': instance.sentAt.toIso8601String(),
      'readAt': instance.readAt?.toIso8601String(),
      'isEdited': instance.isEdited,
      'editedAt': instance.editedAt?.toIso8601String(),
      'attachments': instance.attachments,
      'metadata': instance.metadata,
      'sender': instance.sender,
    };

const _$MessageStatusEnumMap = {
  MessageStatus.sending: 'sending',
  MessageStatus.sent: 'sent',
  MessageStatus.delivered: 'delivered',
  MessageStatus.read: 'read',
  MessageStatus.failed: 'failed',
};

_$PostImpl _$$PostImplFromJson(Map<String, dynamic> json) => _$PostImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$PostTypeEnumMap, json['type']),
      content: json['content'] as String,
      visibility:
          $enumDecodeNullable(_$PostVisibilityEnumMap, json['visibility']) ??
              PostVisibility.friends,
      mediaUrls: (json['mediaUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      taggedUserIds: (json['taggedUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      venueId: json['venueId'] as String?,
      eventId: json['eventId'] as String?,
      reviewId: json['reviewId'] as String?,
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
      commentsCount: (json['commentsCount'] as num?)?.toInt() ?? 0,
      sharesCount: (json['sharesCount'] as num?)?.toInt() ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      author: json['author'] == null
          ? null
          : UserProfile.fromJson(json['author'] as Map<String, dynamic>),
      taggedUsers: (json['taggedUsers'] as List<dynamic>?)
          ?.map((e) => UserProfile.fromJson(e as Map<String, dynamic>))
          .toList(),
      venue: json['venue'] == null
          ? null
          : VenueInfo.fromJson(json['venue'] as Map<String, dynamic>),
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PostImplToJson(_$PostImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': _$PostTypeEnumMap[instance.type]!,
      'content': instance.content,
      'visibility': _$PostVisibilityEnumMap[instance.visibility]!,
      'mediaUrls': instance.mediaUrls,
      'taggedUserIds': instance.taggedUserIds,
      'venueId': instance.venueId,
      'eventId': instance.eventId,
      'reviewId': instance.reviewId,
      'likesCount': instance.likesCount,
      'commentsCount': instance.commentsCount,
      'sharesCount': instance.sharesCount,
      'isLiked': instance.isLiked,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'author': instance.author,
      'taggedUsers': instance.taggedUsers,
      'venue': instance.venue,
      'comments': instance.comments,
    };

const _$PostTypeEnumMap = {
  PostType.text: 'text',
  PostType.image: 'image',
  PostType.video: 'video',
  PostType.checkIn: 'checkIn',
  PostType.review: 'review',
  PostType.event: 'event',
};

const _$PostVisibilityEnumMap = {
  PostVisibility.public: 'public',
  PostVisibility.friends: 'friends',
  PostVisibility.private: 'private',
};

_$CommentImpl _$$CommentImplFromJson(Map<String, dynamic> json) =>
    _$CommentImpl(
      id: json['id'] as String,
      postId: json['postId'] as String,
      userId: json['userId'] as String,
      content: json['content'] as String,
      parentCommentId: json['parentCommentId'] as String?,
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      author: json['author'] == null
          ? null
          : UserProfile.fromJson(json['author'] as Map<String, dynamic>),
      replies: (json['replies'] as List<dynamic>?)
          ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CommentImplToJson(_$CommentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'postId': instance.postId,
      'userId': instance.userId,
      'content': instance.content,
      'parentCommentId': instance.parentCommentId,
      'likesCount': instance.likesCount,
      'isLiked': instance.isLiked,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'author': instance.author,
      'replies': instance.replies,
    };

_$VenueInfoImpl _$$VenueInfoImplFromJson(Map<String, dynamic> json) =>
    _$VenueInfoImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String?,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$$VenueInfoImplToJson(_$VenueInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'logoUrl': instance.logoUrl,
      'address': instance.address,
    };

_$PartyImpl _$$PartyImplFromJson(Map<String, dynamic> json) => _$PartyImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      organizerId: json['organizerId'] as String,
      memberIds:
          (json['memberIds'] as List<dynamic>).map((e) => e as String).toList(),
      invitedUserIds: (json['invitedUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      venueId: json['venueId'] as String?,
      eventId: json['eventId'] as String?,
      scheduledFor: json['scheduledFor'] == null
          ? null
          : DateTime.parse(json['scheduledFor'] as String),
      status: $enumDecodeNullable(_$PartyStatusEnumMap, json['status']) ??
          PartyStatus.planning,
      maxMembers: (json['maxMembers'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      organizer: json['organizer'] == null
          ? null
          : UserProfile.fromJson(json['organizer'] as Map<String, dynamic>),
      members: (json['members'] as List<dynamic>?)
          ?.map((e) => UserProfile.fromJson(e as Map<String, dynamic>))
          .toList(),
      venue: json['venue'] == null
          ? null
          : VenueInfo.fromJson(json['venue'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PartyImplToJson(_$PartyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'organizerId': instance.organizerId,
      'memberIds': instance.memberIds,
      'invitedUserIds': instance.invitedUserIds,
      'venueId': instance.venueId,
      'eventId': instance.eventId,
      'scheduledFor': instance.scheduledFor?.toIso8601String(),
      'status': _$PartyStatusEnumMap[instance.status]!,
      'maxMembers': instance.maxMembers,
      'createdAt': instance.createdAt.toIso8601String(),
      'organizer': instance.organizer,
      'members': instance.members,
      'venue': instance.venue,
    };

const _$PartyStatusEnumMap = {
  PartyStatus.planning: 'planning',
  PartyStatus.confirmed: 'confirmed',
  PartyStatus.active: 'active',
  PartyStatus.completed: 'completed',
  PartyStatus.cancelled: 'cancelled',
};

_$PartyInvitationImpl _$$PartyInvitationImplFromJson(
        Map<String, dynamic> json) =>
    _$PartyInvitationImpl(
      id: json['id'] as String,
      partyId: json['partyId'] as String,
      userId: json['userId'] as String,
      invitedBy: json['invitedBy'] as String,
      status: $enumDecodeNullable(_$InvitationStatusEnumMap, json['status']) ??
          InvitationStatus.pending,
      createdAt: DateTime.parse(json['createdAt'] as String),
      respondedAt: json['respondedAt'] == null
          ? null
          : DateTime.parse(json['respondedAt'] as String),
      party: json['party'] == null
          ? null
          : Party.fromJson(json['party'] as Map<String, dynamic>),
      inviter: json['inviter'] == null
          ? null
          : UserProfile.fromJson(json['inviter'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PartyInvitationImplToJson(
        _$PartyInvitationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'partyId': instance.partyId,
      'userId': instance.userId,
      'invitedBy': instance.invitedBy,
      'status': _$InvitationStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'respondedAt': instance.respondedAt?.toIso8601String(),
      'party': instance.party,
      'inviter': instance.inviter,
    };

const _$InvitationStatusEnumMap = {
  InvitationStatus.pending: 'pending',
  InvitationStatus.accepted: 'accepted',
  InvitationStatus.declined: 'declined',
};

_$PhotoAlbumImpl _$$PhotoAlbumImplFromJson(Map<String, dynamic> json) =>
    _$PhotoAlbumImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      visibility:
          $enumDecodeNullable(_$AlbumVisibilityEnumMap, json['visibility']) ??
              AlbumVisibility.friends,
      coverPhotoUrl: json['coverPhotoUrl'] as String?,
      photoCount: (json['photoCount'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      owner: json['owner'] == null
          ? null
          : UserProfile.fromJson(json['owner'] as Map<String, dynamic>),
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => Photo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PhotoAlbumImplToJson(_$PhotoAlbumImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'description': instance.description,
      'visibility': _$AlbumVisibilityEnumMap[instance.visibility]!,
      'coverPhotoUrl': instance.coverPhotoUrl,
      'photoCount': instance.photoCount,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'owner': instance.owner,
      'photos': instance.photos,
    };

const _$AlbumVisibilityEnumMap = {
  AlbumVisibility.public: 'public',
  AlbumVisibility.friends: 'friends',
  AlbumVisibility.private: 'private',
};

_$PhotoImpl _$$PhotoImplFromJson(Map<String, dynamic> json) => _$PhotoImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      albumId: json['albumId'] as String?,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      caption: json['caption'] as String?,
      taggedUserIds: (json['taggedUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      venueId: json['venueId'] as String?,
      eventId: json['eventId'] as String?,
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
      commentsCount: (json['commentsCount'] as num?)?.toInt() ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      owner: json['owner'] == null
          ? null
          : UserProfile.fromJson(json['owner'] as Map<String, dynamic>),
      taggedUsers: (json['taggedUsers'] as List<dynamic>?)
          ?.map((e) => UserProfile.fromJson(e as Map<String, dynamic>))
          .toList(),
      venue: json['venue'] == null
          ? null
          : VenueInfo.fromJson(json['venue'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PhotoImplToJson(_$PhotoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'albumId': instance.albumId,
      'url': instance.url,
      'thumbnailUrl': instance.thumbnailUrl,
      'caption': instance.caption,
      'taggedUserIds': instance.taggedUserIds,
      'venueId': instance.venueId,
      'eventId': instance.eventId,
      'likesCount': instance.likesCount,
      'commentsCount': instance.commentsCount,
      'isLiked': instance.isLiked,
      'createdAt': instance.createdAt.toIso8601String(),
      'owner': instance.owner,
      'taggedUsers': instance.taggedUsers,
      'venue': instance.venue,
    };

_$ShareImpl _$$ShareImplFromJson(Map<String, dynamic> json) => _$ShareImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$ShareTypeEnumMap, json['type']),
      itemId: json['itemId'] as String,
      message: json['message'] as String?,
      sharedWith: (json['sharedWith'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      itemData: json['itemData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ShareImplToJson(_$ShareImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': _$ShareTypeEnumMap[instance.type]!,
      'itemId': instance.itemId,
      'message': instance.message,
      'sharedWith': instance.sharedWith,
      'createdAt': instance.createdAt.toIso8601String(),
      'itemData': instance.itemData,
    };

const _$ShareTypeEnumMap = {
  ShareType.venue: 'venue',
  ShareType.event: 'event',
  ShareType.post: 'post',
  ShareType.photo: 'photo',
  ShareType.album: 'album',
};
