import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/search_filter.dart';

class SearchService {
  static final SearchService _instance = SearchService._internal();
  factory SearchService() => _instance;
  SearchService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Perform comprehensive search
  Future<List<SearchResult>> search({
    required String query,
    SearchFilter? filters,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final params = {
        'search_query': query,
        'categories': filters?.categories,
        'date_start': filters?.dateRange?.start.toIso8601String(),
        'date_end': filters?.dateRange?.end.toIso8601String(),
        'price_min': filters?.priceRange?.min,
        'price_max': filters?.priceRange?.max,
        'max_distance': filters?.maxDistance,
        'neighborhoods': filters?.neighborhoods,
        'amenities': filters?.amenities,
        'has_availability': filters?.hasAvailability,
        'bottle_service': filters?.mustHaveBottleService,
        'verified_only': filters?.verifiedVenuesOnly,
        'sort_by': filters?.sortBy ?? 'relevance',
        'limit_count': limit,
        'offset_count': offset,
      };

      final response = await _supabase.rpc('search_events_and_venues', params: params);

      final results = (response as List)
          .map((item) => SearchResult.fromSupabase(item as Map<String, dynamic>))
          .toList();

      // Save search history
      await _saveSearchHistory(query, filters);

      return results;
    } catch (e) {
      throw Exception('Failed to search: $e');
    }
  }

  // Search events only
  Future<List<SearchResult>> searchEvents({
    required String query,
    SearchFilter? filters,
    int limit = 20,
  }) async {
    try {
      var queryBuilder = _supabase
          .from('events')
          .select('*, venues!inner(name, location, rating)')
          .or('name.ilike.%$query%,description.ilike.%$query%');

      // Apply filters
      if (filters?.categories != null && filters!.categories!.isNotEmpty) {
        queryBuilder = queryBuilder.inFilter('category', filters.categories!);
      }

      if (filters?.dateRange != null) {
        queryBuilder = queryBuilder
            .gte('event_date', filters!.dateRange!.start.toIso8601String())
            .lte('event_date', filters.dateRange!.end.toIso8601String());
      }

      if (filters?.priceRange != null) {
        queryBuilder = queryBuilder
            .gte('min_price', filters!.priceRange!.min)
            .lte('min_price', filters.priceRange!.max);
      }

      if (filters?.hasAvailability == true) {
        queryBuilder = queryBuilder.gt('available_tickets', 0);
      }

      final response = await queryBuilder.limit(limit);

      return (response as List)
          .map((item) => SearchResult(
                id: item['id'] as String,
                type: 'event',
                title: item['name'] as String,
                subtitle: item['venues']?['name'] as String?,
                imageUrl: item['cover_image'] as String?,
                rating: (item['venues']?['rating'] as num?)?.toDouble(),
                price: (item['min_price'] as num?)?.toDouble(),
                location: item['venues']?['location'] as String?,
                eventDate: DateTime.parse(item['event_date'] as String),
                isVerified: item['is_verified'] as bool? ?? false,
                isFeatured: item['is_featured'] as bool? ?? false,
              ))
          .toList();
    } catch (e) {
      throw Exception('Failed to search events: $e');
    }
  }

  // Search venues only
  Future<List<SearchResult>> searchVenues({
    required String query,
    SearchFilter? filters,
    int limit = 20,
  }) async {
    try {
      var queryBuilder = _supabase
          .from('venues')
          .select('*')
          .or('name.ilike.%$query%,description.ilike.%$query%,neighborhood.ilike.%$query%');

      // Apply filters
      if (filters?.neighborhoods != null && filters!.neighborhoods!.isNotEmpty) {
        queryBuilder = queryBuilder.inFilter('neighborhood', filters.neighborhoods!);
      }

      if (filters?.verifiedVenuesOnly == true) {
        queryBuilder = queryBuilder.eq('is_verified', true);
      }

      if (filters?.amenities != null && filters!.amenities!.isNotEmpty) {
        queryBuilder = queryBuilder.contains('amenities', filters.amenities!);
      }

      final response = await queryBuilder.limit(limit);

      return (response as List)
          .map((item) => SearchResult(
                id: item['id'] as String,
                type: 'venue',
                title: item['name'] as String,
                subtitle: item['neighborhood'] as String?,
                imageUrl: item['cover_image'] as String?,
                rating: (item['rating'] as num?)?.toDouble(),
                reviewCount: item['review_count'] as int?,
                location: item['address'] as String?,
                isVerified: item['is_verified'] as bool? ?? false,
              ))
          .toList();
    } catch (e) {
      throw Exception('Failed to search venues: $e');
    }
  }

  // Get search suggestions (autocomplete)
  Future<List<SearchSuggestion>> getSuggestions(String query) async {
    if (query.length < 2) return [];

    try {
      final response = await _supabase.rpc('get_search_suggestions', params: {
        'search_query': query,
        'limit_count': 10,
      });

      return (response as List)
          .map((item) => SearchSuggestion(
                text: item['text'] as String,
                type: item['type'] as String,
                icon: item['icon'] as String?,
                subtitle: item['subtitle'] as String?,
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get trending searches
  Future<List<String>> getTrendingSearches() async {
    try {
      final response = await _supabase.rpc('get_trending_searches', params: {
        'limit_count': 10,
      });

      return (response as List).map((item) => item['query'] as String).toList();
    } catch (e) {
      return [];
    }
  }

  // Get search history for user
  Future<List<SearchHistory>> getSearchHistory({int limit = 20}) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _supabase
          .from('search_history')
          .select()
          .eq('user_id', currentUser.id)
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((item) => SearchHistory.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Clear search history
  Future<void> clearSearchHistory() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase
          .from('search_history')
          .delete()
          .eq('user_id', currentUser.id);
    } catch (e) {
      throw Exception('Failed to clear search history: $e');
    }
  }

  // Save search to history
  Future<void> _saveSearchHistory(String query, SearchFilter? filters) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase.from('search_history').insert({
        'user_id': currentUser.id,
        'query': query,
        'filters': filters?.toJson(),
      });
    } catch (e) {
      // Ignore errors in saving history
    }
  }

  // Get popular categories
  Future<List<String>> getPopularCategories() async {
    try {
      final response = await _supabase.rpc('get_popular_categories', params: {
        'limit_count': 10,
      });

      return (response as List).map((item) => item['category'] as String).toList();
    } catch (e) {
      return [
        'Nightclub',
        'Lounge',
        'Rooftop',
        'Concert',
        'Pool Party',
        'Day Club',
      ];
    }
  }

  // Get nearby results based on location
  Future<List<SearchResult>> searchNearby({
    required double latitude,
    required double longitude,
    double radiusKm = 10,
    int limit = 20,
  }) async {
    try {
      final response = await _supabase.rpc('search_nearby', params: {
        'lat': latitude,
        'lng': longitude,
        'radius_km': radiusKm,
        'limit_count': limit,
      });

      return (response as List)
          .map((item) => SearchResult.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to search nearby: $e');
    }
  }
}
