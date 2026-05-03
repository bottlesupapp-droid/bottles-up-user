import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:share_plus/share_plus.dart' as share_plus;
import '../models/social_models.dart';

class ShareService {
  static final ShareService _instance = ShareService._internal();
  factory ShareService() => _instance;
  ShareService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Share venue
  Future<Share> shareVenue({
    required String venueId,
    String? message,
    List<String>? sharedWith,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Get venue details
      final venue = await _supabase
          .from('venues')
          .select('id, name, address, logo_url')
          .eq('id', venueId)
          .single();

      final response = await _supabase.from('shares').insert({
        'user_id': currentUser.id,
        'type': ShareType.venue.name,
        'item_id': venueId,
        'message': message,
        'shared_with': sharedWith ?? [],
        'item_data': venue,
      }).select().single();

      return Share.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to share venue: $e');
    }
  }

  // Share event
  Future<Share> shareEvent({
    required String eventId,
    String? message,
    List<String>? sharedWith,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Get event details
      final event = await _supabase
          .from('events')
          .select('id, name, description, event_date, cover_image')
          .eq('id', eventId)
          .single();

      final response = await _supabase.from('shares').insert({
        'user_id': currentUser.id,
        'type': ShareType.event.name,
        'item_id': eventId,
        'message': message,
        'shared_with': sharedWith ?? [],
        'item_data': event,
      }).select().single();

      return Share.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to share event: $e');
    }
  }

  // Share post
  Future<Share> sharePost({
    required String postId,
    String? message,
    List<String>? sharedWith,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.from('shares').insert({
        'user_id': currentUser.id,
        'type': ShareType.post.name,
        'item_id': postId,
        'message': message,
        'shared_with': sharedWith ?? [],
      }).select().single();

      // Increment post shares count
      await _supabase.rpc('increment_post_shares', params: {
        'post_id_param': postId,
      });

      return Share.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to share post: $e');
    }
  }

  // Share photo
  Future<Share> sharePhoto({
    required String photoId,
    String? message,
    List<String>? sharedWith,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.from('shares').insert({
        'user_id': currentUser.id,
        'type': ShareType.photo.name,
        'item_id': photoId,
        'message': message,
        'shared_with': sharedWith ?? [],
      }).select().single();

      return Share.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to share photo: $e');
    }
  }

  // Share album
  Future<Share> shareAlbum({
    required String albumId,
    String? message,
    List<String>? sharedWith,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.from('shares').insert({
        'user_id': currentUser.id,
        'type': ShareType.album.name,
        'item_id': albumId,
        'message': message,
        'shared_with': sharedWith ?? [],
      }).select().single();

      return Share.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to share album: $e');
    }
  }

  // Get user shares
  Future<List<Share>> getUserShares({
    ShareType? type,
    int limit = 50,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      var query = _supabase
          .from('shares')
          .select()
          .eq('user_id', currentUser.id);

      if (type != null) {
        query = query.eq('type', type.name);
      }

      final response = await query
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((item) => Share.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Share via system share dialog
  Future<void> shareViaSystem({
    required String title,
    required String text,
    String? url,
  }) async {
    try {
      if (url != null) {
        await share_plus.Share.share(
          '$text\n\n$url',
          subject: title,
        );
      } else {
        await share_plus.Share.share(
          text,
          subject: title,
        );
      }
    } catch (e) {
      throw Exception('Failed to share: $e');
    }
  }

  // Generate shareable deep link for venue
  Future<String> generateVenueShareLink(String venueId) async {
    try {
      // This would integrate with Firebase Dynamic Links or similar
      const baseUrl = 'https://bottlesup.app';
      return '$baseUrl/venue/$venueId';
    } catch (e) {
      throw Exception('Failed to generate share link: $e');
    }
  }

  // Generate shareable deep link for event
  Future<String> generateEventShareLink(String eventId) async {
    try {
      const baseUrl = 'https://bottlesup.app';
      return '$baseUrl/event/$eventId';
    } catch (e) {
      throw Exception('Failed to generate share link: $e');
    }
  }

  // Generate shareable deep link for post
  Future<String> generatePostShareLink(String postId) async {
    try {
      const baseUrl = 'https://bottlesup.app';
      return '$baseUrl/post/$postId';
    } catch (e) {
      throw Exception('Failed to generate share link: $e');
    }
  }

  // Share venue to social media
  Future<void> shareVenueToSocialMedia({
    required String venueId,
    required String venueName,
    String? venueAddress,
  }) async {
    try {
      final link = await generateVenueShareLink(venueId);
      final text = 'Check out $venueName${venueAddress != null ? " at $venueAddress" : ""}!';

      await shareViaSystem(
        title: 'Share Venue',
        text: text,
        url: link,
      );
    } catch (e) {
      throw Exception('Failed to share venue: $e');
    }
  }

  // Share event to social media
  Future<void> shareEventToSocialMedia({
    required String eventId,
    required String eventName,
    DateTime? eventDate,
  }) async {
    try {
      final link = await generateEventShareLink(eventId);
      final dateText = eventDate != null
          ? ' on ${eventDate.day}/${eventDate.month}/${eventDate.year}'
          : '';
      final text = 'Join me at $eventName$dateText!';

      await shareViaSystem(
        title: 'Share Event',
        text: text,
        url: link,
      );
    } catch (e) {
      throw Exception('Failed to share event: $e');
    }
  }

  // Get shares received by user
  Future<List<Share>> getReceivedShares({
    ShareType? type,
    int limit = 50,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      var query = _supabase
          .from('shares')
          .select()
          .contains('shared_with', [currentUser.id]);

      if (type != null) {
        query = query.eq('type', type.name);
      }

      final response = await query
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((item) => Share.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Track share analytics
  Future<void> trackShare({
    required ShareType type,
    required String itemId,
    required String platform,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase.from('share_analytics').insert({
        'user_id': currentUser.id,
        'share_type': type.name,
        'item_id': itemId,
        'platform': platform,
        'shared_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Non-critical error
    }
  }
}
