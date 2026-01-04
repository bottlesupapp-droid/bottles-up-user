import 'package:supabase_flutter/supabase_flutter.dart';
import '../../events/models/event.dart';

class HomeEventsService {
  static final HomeEventsService _instance = HomeEventsService._internal();
  factory HomeEventsService() => _instance;
  HomeEventsService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Fetch upcoming events for home screen
  Future<List<Event>> getUpcomingEvents({
    int limit = 10,
    String? genre,
    DateTime? date,
    String? location,
  }) async {
    try {
      var query = _supabase
          .from('events')
          .select('''
            *,
            categories:category_id(name),
            clubs:club_id(name, location, image_url),
            zones:zone_id(name, description)
          ''')
          .eq('is_active', true)
          .inFilter('status', ['published', 'upcoming', 'live']);

      // Apply date filter
      if (date != null) {
        final dateStr = date.toIso8601String().split('T')[0];
        query = query.eq('event_date', dateStr);
      } else {
        query = query.gte('event_date', DateTime.now().toIso8601String().split('T')[0]);
      }

      // Apply location filter
      if (location != null && location.isNotEmpty) {
        query = query.ilike('clubs.location', '%$location%');
      }

      // Note: Genre filter is not applied as the events table doesn't have a genre column
      // The genre parameter is kept for future use if the column is added

      final response = await query
          .order('event_date', ascending: true)
          .order('start_time', ascending: true)
          .limit(limit);

      return response.map<Event>((data) => Event.fromSupabase(_mapJoinedData(data))).toList();
    } catch (e) {
      throw Exception('Failed to fetch upcoming events: $e');
    }
  }

  /// Fetch featured events for home screen
  Future<List<Event>> getFeaturedEvents({int limit = 5}) async {
    try {
      final response = await _supabase
          .from('events')
          .select('''
            *,
            categories:category_id(name),
            clubs:club_id(name, location, image_url),
            zones:zone_id(name, description)
          ''')
          .eq('is_active', true)
          .eq('is_featured', true)
          .inFilter('status', ['published', 'upcoming', 'live'])
          .gte('event_date', DateTime.now().toIso8601String().split('T')[0])
          .order('event_date', ascending: true)
          .limit(limit);

      return response.map<Event>((data) => Event.fromSupabase(_mapJoinedData(data))).toList();
    } catch (e) {
      throw Exception('Failed to fetch featured events: $e');
    }
  }

  /// Fetch events happening today
  Future<List<Event>> getTodaysEvents() async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];

      final response = await _supabase
          .from('events')
          .select('''
            *,
            categories:category_id(name),
            clubs:club_id(name, location, image_url),
            zones:zone_id(name, description)
          ''')
          .eq('is_active', true)
          .eq('event_date', today)
          .inFilter('status', ['published', 'upcoming', 'live', 'ongoing'])
          .order('start_time', ascending: true);

      return response.map<Event>((data) => Event.fromSupabase(_mapJoinedData(data))).toList();
    } catch (e) {
      throw Exception('Failed to fetch today\'s events: $e');
    }
  }

  /// Fetch live events (currently happening)
  Future<List<Event>> getLiveEvents() async {
    try {
      final response = await _supabase
          .from('events')
          .select('''
            *,
            categories:category_id(name),
            clubs:club_id(name, location, image_url),
            zones:zone_id(name, description)
          ''')
          .eq('is_active', true)
          .inFilter('status', ['live', 'ongoing'])
          .order('start_time', ascending: true);

      return response.map<Event>((data) => Event.fromSupabase(_mapJoinedData(data))).toList();
    } catch (e) {
      throw Exception('Failed to fetch live events: $e');
    }
  }

  /// Helper method to map joined data for Event.fromSupabase
  Map<String, dynamic> _mapJoinedData(Map<String, dynamic> data) {
    final mappedData = Map<String, dynamic>.from(data);

    // Map category data
    if (data['categories'] != null && data['categories'] is Map) {
      mappedData['category_name'] = data['categories']['name'];
    }

    // Map club data
    if (data['clubs'] != null && data['clubs'] is Map) {
      mappedData['club_name'] = data['clubs']['name'];
      mappedData['club_location'] = data['clubs']['location'];
      mappedData['club_image_url'] = data['clubs']['image_url'];
    }

    // Map zone data
    if (data['zones'] != null && data['zones'] is Map) {
      mappedData['zone_name'] = data['zones']['name'];
      mappedData['zone_description'] = data['zones']['description'];
    }

    // Remove the nested objects to avoid conflicts
    mappedData.remove('categories');
    mappedData.remove('clubs');
    mappedData.remove('zones');

    return mappedData;
  }

  /// Search events by name or venue
  Future<List<Event>> searchEvents(String query, {int limit = 20}) async {
    try {
      final response = await _supabase
          .from('events')
          .select('''
            *,
            categories:category_id(name),
            clubs:club_id(name, location, image_url),
            zones:zone_id(name, description)
          ''')
          .eq('is_active', true)
          .inFilter('status', ['published', 'upcoming', 'live'])
          .gte('event_date', DateTime.now().toIso8601String().split('T')[0])
          .or('name.ilike.%$query%,description.ilike.%$query%')
          .order('event_date', ascending: true)
          .limit(limit);

      return response.map<Event>((data) => Event.fromSupabase(_mapJoinedData(data))).toList();
    } catch (e) {
      throw Exception('Failed to search events: $e');
    }
  }

  /// Get events by category
  Future<List<Event>> getEventsByCategory(String categoryId, {int limit = 20}) async {
    try {
      final response = await _supabase
          .from('events')
          .select('''
            *,
            categories:category_id(name),
            clubs:club_id(name, location, image_url),
            zones:zone_id(name, description)
          ''')
          .eq('is_active', true)
          .eq('category_id', categoryId)
          .inFilter('status', ['published', 'upcoming', 'live'])
          .gte('event_date', DateTime.now().toIso8601String().split('T')[0])
          .order('event_date', ascending: true)
          .limit(limit);

      return response.map<Event>((data) => Event.fromSupabase(_mapJoinedData(data))).toList();
    } catch (e) {
      throw Exception('Failed to fetch events by category: $e');
    }
  }
}