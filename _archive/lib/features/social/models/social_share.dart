import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_share.freezed.dart';
part 'social_share.g.dart';

enum SharePlatform {
  instagram,
  facebook,
  twitter,
  whatsapp,
  snapchat,
  messages,
  copy,
  more,
}

enum ShareContentType {
  venue,
  event,
  booking,
  review,
  achievement,
  invitation,
}

@freezed
class ShareContent with _$ShareContent {
  const factory ShareContent({
    required String id,
    required ShareContentType type,
    required String title,
    required String description,
    String? imageUrl,
    String? deepLink,
    Map<String, dynamic>? metadata,
    required DateTime createdAt,
  }) = _ShareContent;

  factory ShareContent.fromJson(Map<String, dynamic> json) =>
      _$ShareContentFromJson(json);

  factory ShareContent.venue({
    required String venueId,
    required String venueName,
    required String description,
    String? imageUrl,
  }) {
    return ShareContent(
      id: venueId,
      type: ShareContentType.venue,
      title: venueName,
      description: description,
      imageUrl: imageUrl,
      deepLink: 'bottlesup://venue/$venueId',
      createdAt: DateTime.now(),
    );
  }

  factory ShareContent.event({
    required String eventId,
    required String eventName,
    required String description,
    String? imageUrl,
  }) {
    return ShareContent(
      id: eventId,
      type: ShareContentType.event,
      title: eventName,
      description: description,
      imageUrl: imageUrl,
      deepLink: 'bottlesup://event/$eventId',
      createdAt: DateTime.now(),
    );
  }

  factory ShareContent.achievement({
    required String achievementId,
    required String title,
    required String description,
    String? imageUrl,
  }) {
    return ShareContent(
      id: achievementId,
      type: ShareContentType.achievement,
      title: title,
      description: description,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
    );
  }
}

@freezed
class ShareAnalytics with _$ShareAnalytics {
  const factory ShareAnalytics({
    required String contentId,
    required ShareContentType contentType,
    required Map<SharePlatform, int> sharesByPlatform,
    required int totalShares,
    required int clickThroughs,
    required int conversions,
    required DateTime firstSharedAt,
    DateTime? lastSharedAt,
  }) = _ShareAnalytics;

  factory ShareAnalytics.fromJson(Map<String, dynamic> json) =>
      _$ShareAnalyticsFromJson(json);

  factory ShareAnalytics.fromSupabase(Map<String, dynamic> data) {
    final sharesByPlatform = <SharePlatform, int>{};
    final platformData = data['shares_by_platform'] as Map<String, dynamic>?;

    if (platformData != null) {
      for (final entry in platformData.entries) {
        final platform = SharePlatform.values.firstWhere(
          (e) => e.name == entry.key,
          orElse: () => SharePlatform.more,
        );
        sharesByPlatform[platform] = entry.value as int;
      }
    }

    return ShareAnalytics(
      contentId: data['content_id'] as String,
      contentType: ShareContentType.values.firstWhere(
        (e) => e.name == data['content_type'],
        orElse: () => ShareContentType.venue,
      ),
      sharesByPlatform: sharesByPlatform,
      totalShares: data['total_shares'] as int? ?? 0,
      clickThroughs: data['click_throughs'] as int? ?? 0,
      conversions: data['conversions'] as int? ?? 0,
      firstSharedAt: DateTime.parse(data['first_shared_at'] as String),
      lastSharedAt: data['last_shared_at'] != null
          ? DateTime.parse(data['last_shared_at'] as String)
          : null,
    );
  }
}

@freezed
class SocialPost with _$SocialPost {
  const factory SocialPost({
    required String id,
    required String userId,
    required String userName,
    String? userAvatar,
    required ShareContent content,
    String? caption,
    @Default([]) List<String> hashtags,
    @Default(0) int likes,
    @Default(0) int comments,
    @Default(0) int shares,
    @Default(false) bool isLikedByUser,
    required DateTime createdAt,
  }) = _SocialPost;

  factory SocialPost.fromJson(Map<String, dynamic> json) =>
      _$SocialPostFromJson(json);

  factory SocialPost.fromSupabase(Map<String, dynamic> data) {
    return SocialPost(
      id: data['id'] as String,
      userId: data['user_id'] as String,
      userName: data['user_name'] as String,
      userAvatar: data['user_avatar'] as String?,
      content: ShareContent.fromJson(data['content'] as Map<String, dynamic>),
      caption: data['caption'] as String?,
      hashtags: data['hashtags'] != null
          ? List<String>.from(data['hashtags'] as List)
          : [],
      likes: data['likes'] as int? ?? 0,
      comments: data['comments'] as int? ?? 0,
      shares: data['shares'] as int? ?? 0,
      isLikedByUser: data['is_liked_by_user'] as bool? ?? false,
      createdAt: DateTime.parse(data['created_at'] as String),
    );
  }
}
