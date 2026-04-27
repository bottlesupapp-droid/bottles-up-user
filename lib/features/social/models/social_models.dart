import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_models.freezed.dart';
part 'social_models.g.dart';

// Friend System Models
enum FriendshipStatus {
  pending,
  accepted,
  blocked,
  rejected,
}

@freezed
class Friendship with _$Friendship {
  const factory Friendship({
    required String id,
    required String userId,
    required String friendId,
    required FriendshipStatus status,
    required DateTime createdAt,
    DateTime? acceptedAt,
    DateTime? blockedAt,
    // Populated fields
    UserProfile? friend,
  }) = _Friendship;

  factory Friendship.fromJson(Map<String, dynamic> json) => _$FriendshipFromJson(json);

  factory Friendship.fromSupabase(Map<String, dynamic> data) => Friendship(
        id: data['id'] as String,
        userId: data['user_id'] as String,
        friendId: data['friend_id'] as String,
        status: FriendshipStatus.values.firstWhere(
          (e) => e.name == data['status'],
          orElse: () => FriendshipStatus.pending,
        ),
        createdAt: DateTime.parse(data['created_at'] as String),
        acceptedAt: data['accepted_at'] != null ? DateTime.parse(data['accepted_at'] as String) : null,
        blockedAt: data['blocked_at'] != null ? DateTime.parse(data['blocked_at'] as String) : null,
        friend: data['friend'] != null ? UserProfile.fromSupabase(data['friend'] as Map<String, dynamic>) : null,
      );
}

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String email,
    String? fullName,
    String? avatarUrl,
    String? bio,
    String? location,
    @Default(0) int friendsCount,
    @Default(0) int postsCount,
    @Default(false) bool isOnline,
    DateTime? lastSeen,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);

  factory UserProfile.fromSupabase(Map<String, dynamic> data) => UserProfile(
        id: data['id'] as String,
        email: data['email'] as String,
        fullName: data['full_name'] as String?,
        avatarUrl: data['avatar_url'] as String?,
        bio: data['bio'] as String?,
        location: data['location'] as String?,
        friendsCount: data['friends_count'] as int? ?? 0,
        postsCount: data['posts_count'] as int? ?? 0,
        isOnline: data['is_online'] as bool? ?? false,
        lastSeen: data['last_seen'] != null ? DateTime.parse(data['last_seen'] as String) : null,
      );
}

// Messaging Models
enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}

@freezed
class Conversation with _$Conversation {
  const factory Conversation({
    required String id,
    required ConversationType type,
    required List<String> participantIds,
    String? name,
    String? avatarUrl,
    DateTime? lastMessageAt,
    String? lastMessage,
    @Default(0) int unreadCount,
    // Populated fields
    List<UserProfile>? participants,
    Message? lastMessageObj,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) => _$ConversationFromJson(json);

  factory Conversation.fromSupabase(Map<String, dynamic> data) => Conversation(
        id: data['id'] as String,
        type: ConversationType.values.firstWhere(
          (e) => e.name == data['type'],
          orElse: () => ConversationType.direct,
        ),
        participantIds: List<String>.from(data['participant_ids'] as List? ?? []),
        name: data['name'] as String?,
        avatarUrl: data['avatar_url'] as String?,
        lastMessageAt: data['last_message_at'] != null ? DateTime.parse(data['last_message_at'] as String) : null,
        lastMessage: data['last_message'] as String?,
        unreadCount: data['unread_count'] as int? ?? 0,
      );
}

enum ConversationType {
  direct,
  group,
}

@freezed
class Message with _$Message {
  const factory Message({
    required String id,
    required String conversationId,
    required String senderId,
    required String content,
    @Default('text') String messageType,
    @Default(MessageStatus.sent) MessageStatus status,
    required DateTime sentAt,
    DateTime? readAt,
    @Default(false) bool isEdited,
    DateTime? editedAt,
    @Default([]) List<String> attachments,
    Map<String, dynamic>? metadata,
    // Populated fields
    UserProfile? sender,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  factory Message.fromSupabase(Map<String, dynamic> data) => Message(
        id: data['id'] as String,
        conversationId: data['conversation_id'] as String,
        senderId: data['sender_id'] as String,
        content: data['content'] as String,
        messageType: data['message_type'] as String? ?? 'text',
        status: MessageStatus.values.firstWhere(
          (e) => e.name == data['status'],
          orElse: () => MessageStatus.sent,
        ),
        sentAt: DateTime.parse(data['sent_at'] as String),
        readAt: data['read_at'] != null ? DateTime.parse(data['read_at'] as String) : null,
        isEdited: data['is_edited'] as bool? ?? false,
        editedAt: data['edited_at'] != null ? DateTime.parse(data['edited_at'] as String) : null,
        attachments: List<String>.from(data['attachments'] as List? ?? []),
        metadata: data['metadata'] as Map<String, dynamic>?,
      );
}

// Social Feed Models
enum PostType {
  text,
  image,
  video,
  checkIn,
  review,
  event,
}

enum PostVisibility {
  public,
  friends,
  private,
}

@freezed
class Post with _$Post {
  const factory Post({
    required String id,
    required String userId,
    required PostType type,
    required String content,
    @Default(PostVisibility.friends) PostVisibility visibility,
    @Default([]) List<String> mediaUrls,
    @Default([]) List<String> taggedUserIds,
    String? venueId,
    String? eventId,
    String? reviewId,
    @Default(0) int likesCount,
    @Default(0) int commentsCount,
    @Default(0) int sharesCount,
    @Default(false) bool isLiked,
    required DateTime createdAt,
    DateTime? updatedAt,
    // Populated fields
    UserProfile? author,
    List<UserProfile>? taggedUsers,
    VenueInfo? venue,
    List<Comment>? comments,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  factory Post.fromSupabase(Map<String, dynamic> data) => Post(
        id: data['id'] as String,
        userId: data['user_id'] as String,
        type: PostType.values.firstWhere(
          (e) => e.name == data['type'],
          orElse: () => PostType.text,
        ),
        content: data['content'] as String,
        visibility: PostVisibility.values.firstWhere(
          (e) => e.name == data['visibility'],
          orElse: () => PostVisibility.friends,
        ),
        mediaUrls: List<String>.from(data['media_urls'] as List? ?? []),
        taggedUserIds: List<String>.from(data['tagged_user_ids'] as List? ?? []),
        venueId: data['venue_id'] as String?,
        eventId: data['event_id'] as String?,
        reviewId: data['review_id'] as String?,
        likesCount: data['likes_count'] as int? ?? 0,
        commentsCount: data['comments_count'] as int? ?? 0,
        sharesCount: data['shares_count'] as int? ?? 0,
        isLiked: data['is_liked'] as bool? ?? false,
        createdAt: DateTime.parse(data['created_at'] as String),
        updatedAt: data['updated_at'] != null ? DateTime.parse(data['updated_at'] as String) : null,
      );
}

@freezed
class Comment with _$Comment {
  const factory Comment({
    required String id,
    required String postId,
    required String userId,
    required String content,
    String? parentCommentId,
    @Default(0) int likesCount,
    @Default(false) bool isLiked,
    required DateTime createdAt,
    DateTime? updatedAt,
    // Populated fields
    UserProfile? author,
    List<Comment>? replies,
  }) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);

  factory Comment.fromSupabase(Map<String, dynamic> data) => Comment(
        id: data['id'] as String,
        postId: data['post_id'] as String,
        userId: data['user_id'] as String,
        content: data['content'] as String,
        parentCommentId: data['parent_comment_id'] as String?,
        likesCount: data['likes_count'] as int? ?? 0,
        isLiked: data['is_liked'] as bool? ?? false,
        createdAt: DateTime.parse(data['created_at'] as String),
        updatedAt: data['updated_at'] != null ? DateTime.parse(data['updated_at'] as String) : null,
      );
}

@freezed
class VenueInfo with _$VenueInfo {
  const factory VenueInfo({
    required String id,
    required String name,
    String? logoUrl,
    String? address,
  }) = _VenueInfo;

  factory VenueInfo.fromJson(Map<String, dynamic> json) => _$VenueInfoFromJson(json);

  factory VenueInfo.fromSupabase(Map<String, dynamic> data) => VenueInfo(
        id: data['id'] as String,
        name: data['name'] as String,
        logoUrl: data['logo_url'] as String?,
        address: data['address'] as String?,
      );
}

// Group/Party Models
@freezed
class Party with _$Party {
  const factory Party({
    required String id,
    required String name,
    String? description,
    required String organizerId,
    required List<String> memberIds,
    @Default([]) List<String> invitedUserIds,
    String? venueId,
    String? eventId,
    DateTime? scheduledFor,
    @Default(PartyStatus.planning) PartyStatus status,
    @Default(0) int maxMembers,
    required DateTime createdAt,
    // Populated fields
    UserProfile? organizer,
    List<UserProfile>? members,
    VenueInfo? venue,
  }) = _Party;

  factory Party.fromJson(Map<String, dynamic> json) => _$PartyFromJson(json);

  factory Party.fromSupabase(Map<String, dynamic> data) => Party(
        id: data['id'] as String,
        name: data['name'] as String,
        description: data['description'] as String?,
        organizerId: data['organizer_id'] as String,
        memberIds: List<String>.from(data['member_ids'] as List? ?? []),
        invitedUserIds: List<String>.from(data['invited_user_ids'] as List? ?? []),
        venueId: data['venue_id'] as String?,
        eventId: data['event_id'] as String?,
        scheduledFor: data['scheduled_for'] != null ? DateTime.parse(data['scheduled_for'] as String) : null,
        status: PartyStatus.values.firstWhere(
          (e) => e.name == data['status'],
          orElse: () => PartyStatus.planning,
        ),
        maxMembers: data['max_members'] as int? ?? 0,
        createdAt: DateTime.parse(data['created_at'] as String),
      );
}

enum PartyStatus {
  planning,
  confirmed,
  active,
  completed,
  cancelled,
}

@freezed
class PartyInvitation with _$PartyInvitation {
  const factory PartyInvitation({
    required String id,
    required String partyId,
    required String userId,
    required String invitedBy,
    @Default(InvitationStatus.pending) InvitationStatus status,
    required DateTime createdAt,
    DateTime? respondedAt,
    // Populated fields
    Party? party,
    UserProfile? inviter,
  }) = _PartyInvitation;

  factory PartyInvitation.fromJson(Map<String, dynamic> json) => _$PartyInvitationFromJson(json);

  factory PartyInvitation.fromSupabase(Map<String, dynamic> data) => PartyInvitation(
        id: data['id'] as String,
        partyId: data['party_id'] as String,
        userId: data['user_id'] as String,
        invitedBy: data['invited_by'] as String,
        status: InvitationStatus.values.firstWhere(
          (e) => e.name == data['status'],
          orElse: () => InvitationStatus.pending,
        ),
        createdAt: DateTime.parse(data['created_at'] as String),
        respondedAt: data['responded_at'] != null ? DateTime.parse(data['responded_at'] as String) : null,
      );
}

enum InvitationStatus {
  pending,
  accepted,
  declined,
}

// Photo Sharing Models
@freezed
class PhotoAlbum with _$PhotoAlbum {
  const factory PhotoAlbum({
    required String id,
    required String userId,
    required String name,
    String? description,
    @Default(AlbumVisibility.friends) AlbumVisibility visibility,
    String? coverPhotoUrl,
    @Default(0) int photoCount,
    required DateTime createdAt,
    DateTime? updatedAt,
    // Populated fields
    UserProfile? owner,
    List<Photo>? photos,
  }) = _PhotoAlbum;

  factory PhotoAlbum.fromJson(Map<String, dynamic> json) => _$PhotoAlbumFromJson(json);

  factory PhotoAlbum.fromSupabase(Map<String, dynamic> data) => PhotoAlbum(
        id: data['id'] as String,
        userId: data['user_id'] as String,
        name: data['name'] as String,
        description: data['description'] as String?,
        visibility: AlbumVisibility.values.firstWhere(
          (e) => e.name == data['visibility'],
          orElse: () => AlbumVisibility.friends,
        ),
        coverPhotoUrl: data['cover_photo_url'] as String?,
        photoCount: data['photo_count'] as int? ?? 0,
        createdAt: DateTime.parse(data['created_at'] as String),
        updatedAt: data['updated_at'] != null ? DateTime.parse(data['updated_at'] as String) : null,
      );
}

enum AlbumVisibility {
  public,
  friends,
  private,
}

@freezed
class Photo with _$Photo {
  const factory Photo({
    required String id,
    required String userId,
    String? albumId,
    required String url,
    String? thumbnailUrl,
    String? caption,
    @Default([]) List<String> taggedUserIds,
    String? venueId,
    String? eventId,
    @Default(0) int likesCount,
    @Default(0) int commentsCount,
    @Default(false) bool isLiked,
    required DateTime createdAt,
    // Populated fields
    UserProfile? owner,
    List<UserProfile>? taggedUsers,
    VenueInfo? venue,
  }) = _Photo;

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);

  factory Photo.fromSupabase(Map<String, dynamic> data) => Photo(
        id: data['id'] as String,
        userId: data['user_id'] as String,
        albumId: data['album_id'] as String?,
        url: data['url'] as String,
        thumbnailUrl: data['thumbnail_url'] as String?,
        caption: data['caption'] as String?,
        taggedUserIds: List<String>.from(data['tagged_user_ids'] as List? ?? []),
        venueId: data['venue_id'] as String?,
        eventId: data['event_id'] as String?,
        likesCount: data['likes_count'] as int? ?? 0,
        commentsCount: data['comments_count'] as int? ?? 0,
        isLiked: data['is_liked'] as bool? ?? false,
        createdAt: DateTime.parse(data['created_at'] as String),
      );
}

// Share Models
@freezed
class Share with _$Share {
  const factory Share({
    required String id,
    required String userId,
    required ShareType type,
    required String itemId,
    String? message,
    @Default([]) List<String> sharedWith,
    required DateTime createdAt,
    // Populated fields
    Map<String, dynamic>? itemData,
  }) = _Share;

  factory Share.fromJson(Map<String, dynamic> json) => _$ShareFromJson(json);

  factory Share.fromSupabase(Map<String, dynamic> data) => Share(
        id: data['id'] as String,
        userId: data['user_id'] as String,
        type: ShareType.values.firstWhere(
          (e) => e.name == data['type'],
          orElse: () => ShareType.venue,
        ),
        itemId: data['item_id'] as String,
        message: data['message'] as String?,
        sharedWith: List<String>.from(data['shared_with'] as List? ?? []),
        createdAt: DateTime.parse(data['created_at'] as String),
        itemData: data['item_data'] as Map<String, dynamic>?,
      );
}

enum ShareType {
  venue,
  event,
  post,
  photo,
  album,
}
