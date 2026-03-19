import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/event.dart';

class EventService {
  static final EventService _instance = EventService._internal();
  factory EventService() => _instance;
  EventService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Fetch all active events
  Future<List<Event>> getEvents({
    String? genre,
    String? city,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
    int? limit,
    int? offset,
  }) async {
    try {
      // Build the base query with filters
      var query = _supabase
          .from('events')
          .select('''
            *,
            clubs:club_id (
              id,
              name,
              location,
              image_url
            ),
            categories:category_id (
              id,
              name
            ),
            zones:zone_id (
              id,
              name,
              description
            )
          ''')
          .eq('is_active', true);

      // Apply optional filters
      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.or('name.ilike.%$searchQuery%,description.ilike.%$searchQuery%');
      }

      if (startDate != null) {
        query = query.gte('event_date', startDate.toIso8601String());
      }

      if (endDate != null) {
        query = query.lte('event_date', endDate.toIso8601String());
      }

      // Apply ordering and limits
      final transformedQuery = query
          .order('event_date', ascending: true);

      // Execute query with optional limit/offset
      final response = limit != null
          ? await transformedQuery.limit(limit)
          : await transformedQuery;

      return (response as List)
          .map((eventData) {
            // Flatten the club data
            final Map<String, dynamic> flattenedData = Map.from(eventData);

            if (eventData['clubs'] != null) {
              final clubData = eventData['clubs'];
              flattenedData['club_name'] = clubData['name'];
              flattenedData['club_location'] = clubData['location'];
              flattenedData['club_image_url'] = clubData['image_url'];
            }

            if (eventData['categories'] != null) {
              flattenedData['category_name'] = eventData['categories']['name'];
            }

            if (eventData['zones'] != null) {
              flattenedData['zone_name'] = eventData['zones']['name'];
              flattenedData['zone_description'] = eventData['zones']['description'];
            }

            return Event.fromSupabase(flattenedData);
          })
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch events: $e');
    }
  }

  /// Fetch featured events
  Future<List<Event>> getFeaturedEvents() async {
    try {
      final response = await _supabase
          .from('events')
          .select('''
            *,
            clubs:club_id (
              id,
              name,
              location,
              image_url
            ),
            categories:category_id (
              id,
              name
            )
          ''')
          .eq('is_active', true)
          .eq('is_featured', true)
          .order('event_date', ascending: true)
          .limit(10);

      return (response as List)
          .map((eventData) {
            final Map<String, dynamic> flattenedData = Map.from(eventData);

            if (eventData['clubs'] != null) {
              final clubData = eventData['clubs'];
              flattenedData['club_name'] = clubData['name'];
              flattenedData['club_location'] = clubData['location'];
              flattenedData['club_image_url'] = clubData['image_url'];
            }

            if (eventData['categories'] != null) {
              flattenedData['category_name'] = eventData['categories']['name'];
            }

            return Event.fromSupabase(flattenedData);
          })
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch featured events: $e');
    }
  }

  /// Fetch single event by ID
  Future<Event> getEventById(String eventId) async {
    try {
      final response = await _supabase
          .from('events')
          .select('''
            *,
            clubs:club_id (
              id,
              name,
              location,
              image_url
            ),
            categories:category_id (
              id,
              name
            ),
            zones:zone_id (
              id,
              name,
              description
            )
          ''')
          .eq('id', eventId)
          .single();

      final Map<String, dynamic> flattenedData = Map.from(response);

      if (response['clubs'] != null) {
        final clubData = response['clubs'];
        flattenedData['club_name'] = clubData['name'];
        flattenedData['club_location'] = clubData['location'];
        flattenedData['club_image_url'] = clubData['image_url'];
      }

      if (response['categories'] != null) {
        flattenedData['category_name'] = response['categories']['name'];
      }

      if (response['zones'] != null) {
        flattenedData['zone_name'] = response['zones']['name'];
        flattenedData['zone_description'] = response['zones']['description'];
      }

      return Event.fromSupabase(flattenedData);
    } catch (e) {
      throw Exception('Failed to fetch event: $e');
    }
  }

  /// Fetch upcoming events (after today)
  Future<List<Event>> getUpcomingEvents({int limit = 20}) async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final response = await _supabase
          .from('events')
          .select('''
            *,
            clubs:club_id (
              id,
              name,
              location,
              image_url
            ),
            categories:category_id (
              id,
              name
            )
          ''')
          .eq('is_active', true)
          .gte('event_date', today.toIso8601String())
          .order('event_date', ascending: true)
          .limit(limit);

      return (response as List)
          .map((eventData) {
            final Map<String, dynamic> flattenedData = Map.from(eventData);

            if (eventData['clubs'] != null) {
              final clubData = eventData['clubs'];
              flattenedData['club_name'] = clubData['name'];
              flattenedData['club_location'] = clubData['location'];
              flattenedData['club_image_url'] = clubData['image_url'];
            }

            if (eventData['categories'] != null) {
              flattenedData['category_name'] = eventData['categories']['name'];
            }

            return Event.fromSupabase(flattenedData);
          })
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch upcoming events: $e');
    }
  }
}
