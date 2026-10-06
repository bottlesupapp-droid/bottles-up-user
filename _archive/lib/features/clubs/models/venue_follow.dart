import 'package:freezed_annotation/freezed_annotation.dart';

part 'venue_follow.freezed.dart';
part 'venue_follow.g.dart';

@freezed
class VenueFollow with _$VenueFollow {
  const factory VenueFollow({
    required String id,
    required String userId,
    required String clubId,
    String? userName,
    String? userAvatar,
    String? clubName,
    String? clubLocation,
    String? clubImageUrl,
    @Default(true) bool notificationsEnabled,
    required DateTime createdAt,
  }) = _VenueFollow;

  factory VenueFollow.fromJson(Map<String, dynamic> json) =>
      _$VenueFollowFromJson(json);

  factory VenueFollow.fromSupabase(Map<String, dynamic> data) {
    return VenueFollow(
      id: data['id'] as String,
      userId: data['user_id'] as String,
      clubId: data['club_id'] as String,
      userName: data['user_name'] as String?,
      userAvatar: data['user_avatar'] as String?,
      clubName: data['club_name'] as String?,
      clubLocation: data['club_location'] as String?,
      clubImageUrl: data['club_image_url'] as String?,
      notificationsEnabled: data['notifications_enabled'] as bool? ?? true,
      createdAt: DateTime.parse(data['created_at'] as String),
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'user_id': userId,
      'club_id': clubId,
      'notifications_enabled': notificationsEnabled,
    };
  }
}

@freezed
class VenueFollowStats with _$VenueFollowStats {
  const factory VenueFollowStats({
    required String clubId,
    required int followersCount,
    required int eventsCount,
    required bool isFollowing,
    required DateTime lastUpdated,
  }) = _VenueFollowStats;

  factory VenueFollowStats.fromJson(Map<String, dynamic> json) =>
      _$VenueFollowStatsFromJson(json);
}

@freezed
class FollowedVenueUpdate with _$FollowedVenueUpdate {
  const factory FollowedVenueUpdate({
    required String id,
    required String clubId,
    required String clubName,
    String? clubImageUrl,
    required UpdateType updateType,
    required String title,
    required String message,
    String? eventId,
    String? eventName,
    DateTime? eventDate,
    required DateTime createdAt,
    @Default(false) bool isRead,
  }) = _FollowedVenueUpdate;

  factory FollowedVenueUpdate.fromJson(Map<String, dynamic> json) =>
      _$FollowedVenueUpdateFromJson(json);

  factory FollowedVenueUpdate.fromSupabase(Map<String, dynamic> data) {
    return FollowedVenueUpdate(
      id: data['id'] as String,
      clubId: data['club_id'] as String,
      clubName: data['club_name'] as String,
      clubImageUrl: data['club_image_url'] as String?,
      updateType: UpdateType.values.firstWhere(
        (t) => t.name == data['update_type'],
        orElse: () => UpdateType.general,
      ),
      title: data['title'] as String,
      message: data['message'] as String,
      eventId: data['event_id'] as String?,
      eventName: data['event_name'] as String?,
      eventDate: data['event_date'] != null
          ? DateTime.parse(data['event_date'] as String)
          : null,
      createdAt: DateTime.parse(data['created_at'] as String),
      isRead: data['is_read'] as bool? ?? false,
    );
  }
}

enum UpdateType {
  @JsonValue('new_event')
  newEvent,
  @JsonValue('event_update')
  eventUpdate,
  @JsonValue('special_offer')
  specialOffer,
  @JsonValue('announcement')
  announcement,
  @JsonValue('general')
  general,
}
