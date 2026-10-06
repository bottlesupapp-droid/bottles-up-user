import 'package:supabase_flutter/supabase_flutter.dart';

class TrendingService {
  static final TrendingService _instance = TrendingService._internal();
  factory TrendingService() => _instance;
  TrendingService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Get trending events
  Future<List<Map<String, dynamic>>> getTrendingEvents({
    int limit = 10,
    String? category,
  }) async {
    try {
      final params = {
        'limit_count': limit,
        if (category != null) 'category_filter': category,
      };

      final response = await _supabase.rpc('get_trending_events', params: params);

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      throw Exception('Failed to get trending events: $e');
    }
  }

  // Get trending venues
  Future<List<Map<String, dynamic>>> getTrendingVenues({int limit = 10}) async {
    try {
      final response = await _supabase.rpc('get_trending_venues', params: {
        'limit_count': limit,
      });

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      throw Exception('Failed to get trending venues: $e');
    }
  }

  // Get hot this week
  Future<List<Map<String, dynamic>>> getHotThisWeek() async {
    try {
      final response = await _supabase.rpc('get_hot_this_week');

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      return [];
    }
  }

  // Get personalized recommendations
  Future<List<Map<String, dynamic>>> getPersonalizedRecommendations({
    int limit = 10,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _supabase.rpc('get_personalized_recommendations', params: {
        'user_id_param': currentUser.id,
        'limit_count': limit,
      });

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      return [];
    }
  }

  // Get events near you
  Future<List<Map<String, dynamic>>> getEventsNearYou({
    required double latitude,
    required double longitude,
    double radiusKm = 10,
    int limit = 20,
  }) async {
    try {
      final response = await _supabase.rpc('get_events_near_location', params: {
        'lat': latitude,
        'lng': longitude,
        'radius_km': radiusKm,
        'limit_count': limit,
      });

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      return [];
    }
  }

  // Track event view for trending algorithm
  Future<void> trackEventView(String eventId) async {
    try {
      final currentUser = _supabase.auth.currentUser;

      await _supabase.from('event_views').insert({
        'event_id': eventId,
        'user_id': currentUser?.id,
        'viewed_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Silently fail
    }
  }

  // Track event share
  Future<void> trackEventShare(String eventId, String platform) async {
    try {
      await _supabase.from('event_shares').insert({
        'event_id': eventId,
        'platform': platform,
        'shared_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Silently fail
    }
  }

  // Get trending by category
  Future<Map<String, List<Map<String, dynamic>>>> getTrendingByCategory() async {
    try {
      final categories = ['Nightclub', 'Lounge', 'Rooftop', 'Pool Party', 'Concert'];
      final Map<String, List<Map<String, dynamic>>> result = {};

      for (final category in categories) {
        final events = await getTrendingEvents(limit: 5, category: category);
        result[category] = events;
      }

      return result;
    } catch (e) {
      return {};
    }
  }
}
