import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import '../models/event_share.dart';
import '../models/event.dart';

class EventShareService {
  static final EventShareService _instance = EventShareService._internal();
  factory EventShareService() => _instance;
  EventShareService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  static const String _baseDeepLinkUrl = 'https://bottlesup.app/events';

  // Generate unique share token
  String _generateShareToken() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    return List.generate(12, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  // Create shareable link for event
  Future<EventShare> createShareLink({
    required String eventId,
    SharePlatform? platform,
    String? referralCode,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      final shareToken = _generateShareToken();
      final shareUrl = '$_baseDeepLinkUrl/$eventId?token=$shareToken';

      final shareData = {
        'event_id': eventId,
        'share_token': shareToken,
        'share_url': shareUrl,
        'shared_by': currentUser?.id,
        'shared_by_name': currentUser?.userMetadata?['full_name'],
        'platform': platform?.name,
        'referral_code': referralCode,
        'metadata': metadata,
        'click_count': 0,
        'signup_count': 0,
      };

      final response = await _supabase
          .from('event_shares')
          .insert(shareData)
          .select()
          .single();

      return EventShare.fromSupabase(response);
    } catch (e) {
      throw Exception('Failed to create share link: $e');
    }
  }

  // Get existing share link or create new one
  Future<EventShare> getOrCreateShareLink({
    required String eventId,
    SharePlatform? platform,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;

      // Try to find existing share for this user and platform
      if (currentUser != null) {
        final existing = await _supabase
            .from('event_shares')
            .select()
            .eq('event_id', eventId)
            .eq('shared_by', currentUser.id)
            .eq('platform', platform?.name ?? 'link')
            .maybeSingle();

        if (existing != null) {
          return EventShare.fromSupabase(existing);
        }
      }

      // Create new share link
      return await createShareLink(
        eventId: eventId,
        platform: platform,
      );
    } catch (e) {
      throw Exception('Failed to get share link: $e');
    }
  }

  // Track share click
  Future<void> trackShareClick(String shareToken) async {
    try {
      await _supabase.rpc('increment_share_click', params: {
        'share_token': shareToken,
      });
    } catch (e) {
      // Silently fail for analytics
    }
  }

  // Track signup from share
  Future<void> trackShareSignup(String shareToken) async {
    try {
      await _supabase.rpc('increment_share_signup', params: {
        'share_token': shareToken,
      });
    } catch (e) {
      // Silently fail for analytics
    }
  }

  // Generate share content from event
  ShareContent generateShareContent(Event event, String shareUrl) {
    return ShareContent(
      title: event.name,
      description: event.description,
      url: shareUrl,
      imageUrl: event.images?.isNotEmpty == true ? event.images!.first : event.clubImageUrl,
      hashtags: ['BottlesUp', event.name.replaceAll(' ', '')],
      via: 'BottlesUpApp',
    );
  }

  // Share to specific platform
  Future<void> shareToPlatform({
    required Event event,
    required SharePlatform platform,
  }) async {
    try {
      final eventShare = await getOrCreateShareLink(
        eventId: event.id,
        platform: platform,
      );

      final content = generateShareContent(event, eventShare.shareUrl);

      switch (platform) {
        case SharePlatform.link:
          // Copy to clipboard and use Share dialog
          await Share.share(
            content.getShareText(platform),
            subject: content.title,
          );
          break;

        case SharePlatform.whatsapp:
          final whatsappUrl = Uri.parse(
            'https://wa.me/?text=${Uri.encodeComponent(content.getShareText(platform))}',
          );
          await _launchUrl(whatsappUrl);
          break;

        case SharePlatform.facebook:
          final facebookUrl = Uri.parse(
            'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(content.url)}',
          );
          await _launchUrl(facebookUrl);
          break;

        case SharePlatform.twitter:
          final twitterUrl = Uri.parse(
            'https://twitter.com/intent/tweet?text=${Uri.encodeComponent(content.getShareText(platform))}',
          );
          await _launchUrl(twitterUrl);
          break;

        case SharePlatform.instagram:
          // Instagram doesn't support direct sharing via URL
          // Copy content and open Instagram
          await Share.share(
            content.getShareText(platform),
            subject: content.title,
          );
          break;

        case SharePlatform.sms:
          final smsUrl = Uri.parse(
            'sms:?body=${Uri.encodeComponent(content.getShareText(platform))}',
          );
          await _launchUrl(smsUrl);
          break;

        case SharePlatform.email:
          final emailUrl = Uri.parse(
            'mailto:?subject=${Uri.encodeComponent(content.getEmailSubject())}&body=${Uri.encodeComponent(content.getShareText(platform))}',
          );
          await _launchUrl(emailUrl);
          break;

        default:
          await Share.share(
            content.getShareText(platform),
            subject: content.title,
          );
      }
    } catch (e) {
      throw Exception('Failed to share: $e');
    }
  }

  Future<void> _launchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  // Get share analytics for event
  Future<ShareAnalytics> getShareAnalytics(String eventId) async {
    try {
      final shares = await _supabase
          .from('event_shares')
          .select()
          .eq('event_id', eventId);

      final shareList = (shares as List)
          .map((data) => EventShare.fromSupabase(data))
          .toList();

      // Calculate totals
      int totalShares = shareList.length;
      int totalClicks = shareList.fold(0, (sum, s) => sum + s.clickCount);
      int totalSignups = shareList.fold(0, (sum, s) => sum + s.signupCount);

      // Group by platform
      final sharesByPlatform = <SharePlatform, int>{};
      final clicksByPlatform = <SharePlatform, int>{};

      for (final share in shareList) {
        final platform = share.platform ?? SharePlatform.link;
        sharesByPlatform[platform] = (sharesByPlatform[platform] ?? 0) + 1;
        clicksByPlatform[platform] =
            (clicksByPlatform[platform] ?? 0) + share.clickCount;
      }

      // Get top sharers
      final sharerMap = <String, TopSharer>{};
      for (final share in shareList.where((s) => s.sharedBy != null)) {
        final userId = share.sharedBy!;
        if (sharerMap.containsKey(userId)) {
          final current = sharerMap[userId]!;
          sharerMap[userId] = current.copyWith(
            shareCount: current.shareCount + 1,
            clickCount: current.clickCount + share.clickCount,
            signupCount: current.signupCount + share.signupCount,
          );
        } else {
          sharerMap[userId] = TopSharer(
            userId: userId,
            userName: share.sharedByName ?? 'Unknown',
            shareCount: 1,
            clickCount: share.clickCount,
            signupCount: share.signupCount,
          );
        }
      }

      final topSharers = sharerMap.values.toList()
        ..sort((a, b) => b.shareCount.compareTo(a.shareCount));

      return ShareAnalytics(
        eventId: eventId,
        totalShares: totalShares,
        totalClicks: totalClicks,
        totalSignups: totalSignups,
        sharesByPlatform: sharesByPlatform,
        clicksByPlatform: clicksByPlatform,
        topSharers: topSharers.take(10).toList(),
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to get analytics: $e');
    }
  }

  // Get all shares for an event
  Future<List<EventShare>> getEventShares(String eventId) async {
    try {
      final response = await _supabase
          .from('event_shares')
          .select()
          .eq('event_id', eventId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((data) => EventShare.fromSupabase(data))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Generate QR code data for event
  String generateQRData(String eventId, {String? shareToken}) {
    if (shareToken != null) {
      return '$_baseDeepLinkUrl/$eventId?token=$shareToken';
    }
    return '$_baseDeepLinkUrl/$eventId';
  }

  // Handle deep link
  Future<String?> handleDeepLink(Uri deepLink) async {
    try {
      // Extract event ID from path
      final segments = deepLink.pathSegments;
      if (segments.isEmpty) return null;

      final eventId = segments.last;
      final shareToken = deepLink.queryParameters['token'];

      // Track click if share token exists
      if (shareToken != null) {
        await trackShareClick(shareToken);
      }

      return eventId;
    } catch (e) {
      return null;
    }
  }
}
