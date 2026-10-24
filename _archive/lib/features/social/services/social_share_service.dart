import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/social_share.dart';

class SocialShareService {
  static final SocialShareService _instance = SocialShareService._internal();
  factory SocialShareService() => _instance;
  SocialShareService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Share content to platform
  Future<void> shareContent({
    required ShareContent content,
    required SharePlatform platform,
    String? customMessage,
  }) async {
    final message = customMessage ?? _generateShareMessage(content);
    final shareUrl = content.deepLink ?? '';

    try {
      switch (platform) {
        case SharePlatform.instagram:
        case SharePlatform.facebook:
        case SharePlatform.twitter:
        case SharePlatform.whatsapp:
        case SharePlatform.snapchat:
        case SharePlatform.messages:
          await Share.share(
            '$message\n\n$shareUrl',
            subject: content.title,
          );
          break;
        case SharePlatform.copy:
          await Share.share(shareUrl);
          break;
        case SharePlatform.more:
          await Share.share(
            '$message\n\n$shareUrl',
            subject: content.title,
          );
          break;
      }

      // Track share
      await _trackShare(content, platform);
    } catch (e) {
      throw Exception('Failed to share content: $e');
    }
  }

  // Share with image
  Future<void> shareWithImage({
    required ShareContent content,
    required String imagePath,
    String? customMessage,
  }) async {
    final message = customMessage ?? _generateShareMessage(content);
    final shareUrl = content.deepLink ?? '';

    try {
      await Share.shareXFiles(
        [XFile(imagePath)],
        text: '$message\n\n$shareUrl',
        subject: content.title,
      );

      await _trackShare(content, SharePlatform.more);
    } catch (e) {
      throw Exception('Failed to share with image: $e');
    }
  }

  // Generate share message
  String _generateShareMessage(ShareContent content) {
    switch (content.type) {
      case ShareContentType.venue:
        return 'Check out ${content.title} on BottlesUp! ${content.description}';
      case ShareContentType.event:
        return 'Join me at ${content.title}! ${content.description}';
      case ShareContentType.booking:
        return 'I just booked ${content.title} on BottlesUp!';
      case ShareContentType.review:
        return 'My review of ${content.title}: ${content.description}';
      case ShareContentType.achievement:
        return 'I just unlocked ${content.title} on BottlesUp! 🎉';
      case ShareContentType.invitation:
        return 'Join me on BottlesUp! ${content.description}';
    }
  }

  // Track share event
  Future<void> _trackShare(ShareContent content, SharePlatform platform) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase.from('share_events').insert({
        'user_id': currentUser.id,
        'content_id': content.id,
        'content_type': content.type.name,
        'platform': platform.name,
        'shared_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Non-critical error
    }
  }

  // Get share analytics
  Future<ShareAnalytics?> getShareAnalytics({
    required String contentId,
    required ShareContentType contentType,
  }) async {
    try {
      final response = await _supabase.rpc('get_share_analytics', params: {
        'content_id_param': contentId,
        'content_type_param': contentType.name,
      });

      if (response == null) return null;

      return ShareAnalytics.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  // Get user's share history
  Future<List<Map<String, dynamic>>> getShareHistory({
    int limit = 50,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _supabase
          .from('share_events')
          .select()
          .eq('user_id', currentUser.id)
          .order('shared_at', ascending: false)
          .limit(limit);

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      return [];
    }
  }

  // Get trending shared content
  Future<List<ShareContent>> getTrendingShares({
    Duration timeWindow = const Duration(days: 7),
    int limit = 10,
  }) async {
    try {
      final startDate = DateTime.now().subtract(timeWindow);

      final response = await _supabase.rpc('get_trending_shares', params: {
        'start_date_param': startDate.toIso8601String(),
        'limit_param': limit,
      });

      return (response as List)
          .map((item) => ShareContent.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Create shareable deep link
  Future<String> createDeepLink({
    required ShareContentType type,
    required String id,
    Map<String, String>? parameters,
  }) async {
    try {
      final response = await _supabase.rpc('create_deep_link', params: {
        'content_type_param': type.name,
        'content_id_param': id,
        'parameters_param': parameters,
      });

      return response as String? ?? 'bottlesup://$type/$id';
    } catch (e) {
      return 'bottlesup://$type/$id';
    }
  }

  // Track deep link click
  Future<void> trackDeepLinkClick({
    required String deepLink,
    String? referrerId,
  }) async {
    try {
      await _supabase.from('deep_link_clicks').insert({
        'deep_link': deepLink,
        'referrer_id': referrerId,
        'clicked_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Non-critical error
    }
  }

  // Get share suggestions
  Future<List<String>> getShareSuggestions({
    required ShareContentType type,
  }) async {
    try {
      final response = await _supabase.rpc('get_share_suggestions', params: {
        'content_type_param': type.name,
      });

      return List<String>.from(response as List? ?? []);
    } catch (e) {
      return _getDefaultSuggestions(type);
    }
  }

  List<String> _getDefaultSuggestions(ShareContentType type) {
    switch (type) {
      case ShareContentType.venue:
        return [
          'Share this amazing venue with friends!',
          'Check out this spot on BottlesUp',
          'Found the perfect place for tonight',
        ];
      case ShareContentType.event:
        return [
          'Join me at this event!',
          'You have to see this event',
          'Let\'s go together!',
        ];
      case ShareContentType.achievement:
        return [
          'Level up! 🎉',
          'New achievement unlocked',
          'Check out my progress',
        ];
      default:
        return ['Check this out on BottlesUp!'];
    }
  }

  // Award points for sharing
  Future<void> awardSharePoints({
    required String contentId,
    required ShareContentType contentType,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase.rpc('award_share_points', params: {
        'user_id_param': currentUser.id,
        'content_id_param': contentId,
        'content_type_param': contentType.name,
      });
    } catch (e) {
      // Non-critical error
    }
  }
}
