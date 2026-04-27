import 'package:freezed_annotation/freezed_annotation.dart';

part 'friend.freezed.dart';
part 'friend.g.dart';

enum FriendshipStatus {
  pending,
  accepted,
  declined,
  blocked,
}

enum InvitationMethod {
  email,
  phone,
  username,
  contact,
  qrCode,
}

@freezed
class Friend with _$Friend {
  const factory Friend({
    required String id,
    required String userId,
    required String friendId,
    required String friendName,
    String? friendAvatar,
    String? friendEmail,
    required FriendshipStatus status,
    required DateTime createdAt,
    DateTime? acceptedAt,
    @Default(false) bool isFavorite,
    Map<String, dynamic>? metadata,
  }) = _Friend;

  factory Friend.fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);

  factory Friend.fromSupabase(Map<String, dynamic> data) {
    return Friend(
      id: data['id'] as String,
      userId: data['user_id'] as String,
      friendId: data['friend_id'] as String,
      friendName: data['friend_name'] as String,
      friendAvatar: data['friend_avatar'] as String?,
      friendEmail: data['friend_email'] as String?,
      status: FriendshipStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => FriendshipStatus.pending,
      ),
      createdAt: DateTime.parse(data['created_at'] as String),
      acceptedAt: data['accepted_at'] != null
          ? DateTime.parse(data['accepted_at'] as String)
          : null,
      isFavorite: data['is_favorite'] as bool? ?? false,
      metadata: data['metadata'] != null
          ? Map<String, dynamic>.from(data['metadata'] as Map)
          : null,
    );
  }
}

@freezed
class FriendInvitation with _$FriendInvitation {
  const factory FriendInvitation({
    required String id,
    required String senderId,
    required String senderName,
    String? senderAvatar,
    String? recipientId,
    String? recipientEmail,
    String? recipientPhone,
    required InvitationMethod method,
    @Default(FriendshipStatus.pending) FriendshipStatus status,
    required DateTime createdAt,
    DateTime? expiresAt,
    String? invitationCode,
    String? message,
  }) = _FriendInvitation;

  factory FriendInvitation.fromJson(Map<String, dynamic> json) =>
      _$FriendInvitationFromJson(json);

  factory FriendInvitation.fromSupabase(Map<String, dynamic> data) {
    return FriendInvitation(
      id: data['id'] as String,
      senderId: data['sender_id'] as String,
      senderName: data['sender_name'] as String,
      senderAvatar: data['sender_avatar'] as String?,
      recipientId: data['recipient_id'] as String?,
      recipientEmail: data['recipient_email'] as String?,
      recipientPhone: data['recipient_phone'] as String?,
      method: InvitationMethod.values.firstWhere(
        (e) => e.name == data['method'],
        orElse: () => InvitationMethod.email,
      ),
      status: FriendshipStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => FriendshipStatus.pending,
      ),
      createdAt: DateTime.parse(data['created_at'] as String),
      expiresAt: data['expires_at'] != null
          ? DateTime.parse(data['expires_at'] as String)
          : null,
      invitationCode: data['invitation_code'] as String?,
      message: data['message'] as String?,
    );
  }
}

@freezed
class ContactSuggestion with _$ContactSuggestion {
  const factory ContactSuggestion({
    required String id,
    required String name,
    String? email,
    String? phone,
    String? avatar,
    @Default(false) bool isAlreadyFriend,
    @Default(false) bool hasAppInstalled,
    @Default(0) int mutualFriends,
    List<String>? mutualFriendNames,
  }) = _ContactSuggestion;

  factory ContactSuggestion.fromJson(Map<String, dynamic> json) =>
      _$ContactSuggestionFromJson(json);

  factory ContactSuggestion.fromSupabase(Map<String, dynamic> data) {
    return ContactSuggestion(
      id: data['id'] as String,
      name: data['name'] as String,
      email: data['email'] as String?,
      phone: data['phone'] as String?,
      avatar: data['avatar'] as String?,
      isAlreadyFriend: data['is_already_friend'] as bool? ?? false,
      hasAppInstalled: data['has_app_installed'] as bool? ?? false,
      mutualFriends: data['mutual_friends'] as int? ?? 0,
      mutualFriendNames: data['mutual_friend_names'] != null
          ? List<String>.from(data['mutual_friend_names'] as List)
          : null,
    );
  }
}

@freezed
class FriendActivity with _$FriendActivity {
  const factory FriendActivity({
    required String id,
    required String friendId,
    required String friendName,
    String? friendAvatar,
    required String activityType,
    required String activityDescription,
    Map<String, dynamic>? activityData,
    required DateTime activityAt,
  }) = _FriendActivity;

  factory FriendActivity.fromJson(Map<String, dynamic> json) =>
      _$FriendActivityFromJson(json);

  factory FriendActivity.fromSupabase(Map<String, dynamic> data) {
    return FriendActivity(
      id: data['id'] as String,
      friendId: data['friend_id'] as String,
      friendName: data['friend_name'] as String,
      friendAvatar: data['friend_avatar'] as String?,
      activityType: data['activity_type'] as String,
      activityDescription: data['activity_description'] as String,
      activityData: data['activity_data'] != null
          ? Map<String, dynamic>.from(data['activity_data'] as Map)
          : null,
      activityAt: DateTime.parse(data['activity_at'] as String),
    );
  }
}
