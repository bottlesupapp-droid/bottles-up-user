import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_share.freezed.dart';
part 'event_share.g.dart';

enum SharePlatform {
  @JsonValue('link')
  link,
  @JsonValue('facebook')
  facebook,
  @JsonValue('twitter')
  twitter,
  @JsonValue('instagram')
  instagram,
  @JsonValue('whatsapp')
  whatsapp,
  @JsonValue('sms')
  sms,
  @JsonValue('email')
  email,
  @JsonValue('qr_code')
  qrCode,
  @JsonValue('other')
  other,
}

@freezed
class EventShare with _$EventShare {
  const factory EventShare({
    required String id,
    required String eventId,
    required String shareToken,
    required String shareUrl,
    String? sharedBy,
    String? sharedByName,
    SharePlatform? platform,
    @Default(0) int clickCount,
    @Default(0) int signupCount,
    String? referralCode,
    Map<String, dynamic>? metadata,
    required DateTime createdAt,
    DateTime? lastClickedAt,
  }) = _EventShare;

  factory EventShare.fromJson(Map<String, dynamic> json) =>
      _$EventShareFromJson(json);

  factory EventShare.fromSupabase(Map<String, dynamic> data) {
    return EventShare(
      id: data['id'] as String,
      eventId: data['event_id'] as String,
      shareToken: data['share_token'] as String,
      shareUrl: data['share_url'] as String,
      sharedBy: data['shared_by'] as String?,
      sharedByName: data['shared_by_name'] as String?,
      platform: data['platform'] != null
          ? SharePlatform.values.firstWhere(
              (p) => p.name == data['platform'],
              orElse: () => SharePlatform.other,
            )
          : null,
      clickCount: data['click_count'] as int? ?? 0,
      signupCount: data['signup_count'] as int? ?? 0,
      referralCode: data['referral_code'] as String?,
      metadata: data['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(data['created_at'] as String),
      lastClickedAt: data['last_clicked_at'] != null
          ? DateTime.parse(data['last_clicked_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'event_id': eventId,
      'share_token': shareToken,
      'share_url': shareUrl,
      'shared_by': sharedBy,
      'shared_by_name': sharedByName,
      'platform': platform?.name,
      'referral_code': referralCode,
      'metadata': metadata,
    };
  }
}

@freezed
class ShareAnalytics with _$ShareAnalytics {
  const factory ShareAnalytics({
    required String eventId,
    required int totalShares,
    required int totalClicks,
    required int totalSignups,
    required Map<SharePlatform, int> sharesByPlatform,
    required Map<SharePlatform, int> clicksByPlatform,
    required List<TopSharer> topSharers,
    required DateTime lastUpdated,
  }) = _ShareAnalytics;

  factory ShareAnalytics.fromJson(Map<String, dynamic> json) =>
      _$ShareAnalyticsFromJson(json);
}

@freezed
class TopSharer with _$TopSharer {
  const factory TopSharer({
    required String userId,
    required String userName,
    String? userAvatar,
    required int shareCount,
    required int clickCount,
    required int signupCount,
  }) = _TopSharer;

  factory TopSharer.fromJson(Map<String, dynamic> json) =>
      _$TopSharerFromJson(json);
}

@freezed
class ShareContent with _$ShareContent {
  const factory ShareContent({
    required String title,
    required String description,
    required String url,
    String? imageUrl,
    List<String>? hashtags,
    String? via,
  }) = _ShareContent;

  factory ShareContent.fromJson(Map<String, dynamic> json) =>
      _$ShareContentFromJson(json);

  // Generate platform-specific content
  String getShareText(SharePlatform platform) {
    switch (platform) {
      case SharePlatform.twitter:
        final hashtagText = hashtags?.map((h) => '#$h').join(' ') ?? '';
        final viaText = via != null ? ' via @$via' : '';
        return '$title\n\n$description\n\n$hashtagText$viaText\n\n$url';

      case SharePlatform.facebook:
      case SharePlatform.instagram:
        return '$title\n\n$description\n\n$url';

      case SharePlatform.whatsapp:
      case SharePlatform.sms:
        return '$title\n\n$description\n\nJoin here: $url';

      case SharePlatform.email:
        return description;

      default:
        return '$title\n\n$description\n\n$url';
    }
  }

  String getEmailSubject() {
    return 'Check out this event: $title';
  }
}
