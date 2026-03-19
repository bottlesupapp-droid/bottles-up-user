import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/venue.dart';
import 'venue_service.dart';

class VenueComparisonService {
  static final VenueComparisonService _instance = VenueComparisonService._internal();
  factory VenueComparisonService() => _instance;
  VenueComparisonService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Create a venue comparison
  Future<VenueComparison> createComparison({
    required List<String> venueIds,
    String? name,
    Map<String, dynamic>? notes,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final data = {
      'user_id': userId,
      'venue_ids': venueIds,
      'name': name ?? 'Comparison ${DateTime.now().toString()}',
      'notes': notes,
    };

    final response = await _supabase
        .from('venue_comparisons')
        .insert(data)
        .select()
        .single();

    return VenueComparison.fromSupabase(response);
  }

  /// Get all user comparisons
  Future<List<VenueComparison>> getUserComparisons() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('venue_comparisons')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((item) => VenueComparison.fromSupabase(item)).toList();
  }

  /// Delete a comparison
  Future<void> deleteComparison(String comparisonId) async {
    await _supabase
        .from('venue_comparisons')
        .delete()
        .eq('id', comparisonId);
  }

  /// Update comparison notes
  Future<void> updateComparisonNotes({
    required String comparisonId,
    required Map<String, dynamic> notes,
  }) async {
    await _supabase
        .from('venue_comparisons')
        .update({'notes': notes})
        .eq('id', comparisonId);
  }

  /// Compare venues (get detailed comparison data)
  Future<Map<String, dynamic>> compareVenues(List<String> venueIds) async {
    final venues = await Future.wait(
      venueIds.map((id) => VenueService().getVenueById(id))
    );

    // Calculate comparison metrics
    final comparison = {
      'venues': venues,
      'price_comparison': _comparePrices(venues),
      'capacity_comparison': _compareCapacity(venues),
      'rating_comparison': _compareRatings(venues),
      'amenities_comparison': _compareAmenities(venues),
    };

    return comparison;
  }

  Map<String, dynamic> _comparePrices(List<Venue> venues) {
    final prices = venues.map((v) => v.pricePerHour).toList();
    return {
      'lowest': prices.reduce((a, b) => a < b ? a : b),
      'highest': prices.reduce((a, b) => a > b ? a : b),
      'average': prices.reduce((a, b) => a + b) / prices.length,
    };
  }

  Map<String, dynamic> _compareCapacity(List<Venue> venues) {
    final capacities = venues.map((v) => v.capacity).toList();
    return {
      'smallest': capacities.reduce((a, b) => a < b ? a : b),
      'largest': capacities.reduce((a, b) => a > b ? a : b),
      'average': capacities.reduce((a, b) => a + b) / capacities.length,
    };
  }

  Map<String, dynamic> _compareRatings(List<Venue> venues) {
    final ratings = venues.map((v) => v.averageRating).toList();
    return {
      'lowest': ratings.reduce((a, b) => a < b ? a : b),
      'highest': ratings.reduce((a, b) => a > b ? a : b),
      'average': ratings.reduce((a, b) => a + b) / ratings.length,
    };
  }

  Map<String, List<String>> _compareAmenities(List<Venue> venues) {
    final allAmenities = <String>{};
    for (final venue in venues) {
      allAmenities.addAll(venue.amenities);
    }

    final comparison = <String, List<String>>{};
    for (final amenity in allAmenities) {
      comparison[amenity] = venues
          .where((v) => v.amenities.contains(amenity))
          .map((v) => v.id)
          .toList();
    }

    return comparison;
  }
}
