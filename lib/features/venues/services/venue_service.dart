import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/venue.dart';

class VenueService {
  static final VenueService _instance = VenueService._internal();
  factory VenueService() => _instance;
  VenueService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get all active venues
  Future<List<Venue>> getVenues({
    String? city,
    int? minCapacity,
    double? maxPrice,
    List<String>? amenities,
  }) async {
    var query = _supabase
        .from('venues')
        .select()
        .eq('is_active', true);

    if (city != null) {
      query = query.eq('city', city);
    }

    if (minCapacity != null) {
      query = query.gte('capacity', minCapacity);
    }

    if (maxPrice != null) {
      query = query.lte('price_per_hour', maxPrice);
    }

    final response = await query.order('average_rating', ascending: false);

    return (response as List).map((item) => Venue.fromSupabase(item)).toList();
  }

  /// Get venue by ID
  Future<Venue> getVenueById(String venueId) async {
    final response = await _supabase
        .from('venues')
        .select()
        .eq('id', venueId)
        .single();

    return Venue.fromSupabase(response);
  }

  /// Search venues
  Future<List<Venue>> searchVenues(String query) async {
    final response = await _supabase
        .from('venues')
        .select()
        .or('name.ilike.%$query%,city.ilike.%$query%,description.ilike.%$query%')
        .eq('is_active', true)
        .order('average_rating', ascending: false);

    return (response as List).map((item) => Venue.fromSupabase(item)).toList();
  }

  /// Get venue ratings
  Future<List<VenueRating>> getVenueRatings(String venueId) async {
    final response = await _supabase
        .from('venue_ratings')
        .select('''
          *,
          users!inner(full_name, avatar_url)
        ''')
        .eq('venue_id', venueId)
        .order('created_at', ascending: false);

    return (response as List).map((item) {
      final user = item['users'] as Map<String, dynamic>?;
      return VenueRating.fromSupabase({
        ...item,
        'user_name': user?['full_name'],
        'user_avatar': user?['avatar_url'],
      });
    }).toList();
  }

  /// Submit venue rating
  Future<VenueRating> submitRating({
    required String venueId,
    required double rating,
    required String review,
    List<String>? images,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final data = {
      'venue_id': venueId,
      'user_id': userId,
      'rating': rating,
      'review': review,
      'images': images,
    };

    final response = await _supabase
        .from('venue_ratings')
        .insert(data)
        .select()
        .single();

    return VenueRating.fromSupabase(response);
  }
}
