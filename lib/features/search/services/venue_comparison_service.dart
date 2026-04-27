import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/venue_comparison.dart';

class VenueComparisonService {
  static final VenueComparisonService _instance = VenueComparisonService._internal();
  factory VenueComparisonService() => _instance;
  VenueComparisonService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Compare multiple venues
  Future<VenueComparison> compareVenues(List<String> venueIds) async {
    try {
      if (venueIds.isEmpty || venueIds.length > 5) {
        throw Exception('Can compare between 1 and 5 venues');
      }

      final response = await _supabase.rpc('compare_venues', params: {
        'venue_ids_param': venueIds,
      });

      final venuesData = response['venues'] as List;
      final venues = venuesData
          .map((v) => ComparisonVenue.fromSupabase(v as Map<String, dynamic>))
          .toList();

      return VenueComparison(
        venues: venues,
        features: ComparisonCategories.all,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to compare venues: $e');
    }
  }

  // Get feature value for venue
  dynamic getFeatureValue(ComparisonVenue venue, String featureId) {
    switch (featureId) {
      case 'avg_price':
        return venue.averagePrice;
      case 'bottle_min':
        return venue.features['bottle_minimum'];
      case 'cover_charge':
        return venue.features['cover_charge'];
      case 'vip_section':
        return venue.features['has_vip'] ?? false;
      case 'outdoor_seating':
        return venue.features['has_outdoor'] ?? false;
      case 'parking':
        return venue.features['has_parking'] ?? false;
      case 'music_type':
        return venue.musicGenres;
      case 'dress_code':
        return venue.dressCode;
      case 'capacity':
        return venue.capacity;
      case 'overall_rating':
        return venue.rating;
      case 'service_rating':
        return venue.features['service_rating'];
      case 'atmosphere_rating':
        return venue.features['atmosphere_rating'];
      default:
        return venue.features[featureId];
    }
  }

  // Find best venue for specific feature
  ComparisonVenue? getBestForFeature(
    List<ComparisonVenue> venues,
    String featureId,
  ) {
    if (venues.isEmpty) return null;

    ComparisonVenue? best;
    dynamic bestValue;

    for (final venue in venues) {
      final value = getFeatureValue(venue, featureId);

      if (value == null) continue;

      if (best == null) {
        best = venue;
        bestValue = value;
        continue;
      }

      // For ratings, higher is better
      if (featureId.contains('rating')) {
        if ((value as double) > (bestValue as double)) {
          best = venue;
          bestValue = value;
        }
      }
      // For prices, lower is better
      else if (featureId.contains('price') || featureId.contains('charge')) {
        if ((value as num) < (bestValue as num)) {
          best = venue;
          bestValue = value;
        }
      }
      // For booleans, true is better
      else if (value is bool) {
        if (value && !(bestValue as bool)) {
          best = venue;
          bestValue = value;
        }
      }
    }

    return best;
  }

  // Generate comparison score
  Map<String, double> generateComparisonScores(
    List<ComparisonVenue> venues, {
    List<String>? priorityFeatures,
  }) {
    final scores = <String, double>{};

    for (final venue in venues) {
      double score = 0;
      int featureCount = 0;

      for (final feature in ComparisonCategories.all) {
        final value = getFeatureValue(venue, feature.id);
        if (value == null) continue;

        featureCount++;
        final importance = feature.importance ?? 5;
        double featureScore = 0;

        switch (feature.type) {
          case FeatureType.rating:
            featureScore = (value as double) / 5.0 * importance;
            break;
          case FeatureType.boolean:
            featureScore = (value as bool) ? importance.toDouble() : 0;
            break;
          case FeatureType.price:
            // Inverse score for price (lower is better)
            final price = value as num;
            featureScore = price > 0 ? (1000 / price) * importance : 0;
            break;
          case FeatureType.list:
            final list = value as List;
            featureScore = list.isNotEmpty ? importance.toDouble() : 0;
            break;
          case FeatureType.text:
            featureScore = (value as String).isNotEmpty ? importance.toDouble() : 0;
            break;
        }

        // Double weight for priority features
        if (priorityFeatures?.contains(feature.id) ?? false) {
          featureScore *= 2;
        }

        score += featureScore;
      }

      scores[venue.id] = featureCount > 0 ? score / featureCount : 0;
    }

    return scores;
  }

  // Save comparison for later
  Future<String> saveComparison(List<String> venueIds) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.from('saved_comparisons').insert({
        'user_id': currentUser.id,
        'venue_ids': venueIds,
      }).select().single();

      return response['id'] as String;
    } catch (e) {
      throw Exception('Failed to save comparison: $e');
    }
  }

  // Get saved comparisons
  Future<List<Map<String, dynamic>>> getSavedComparisons() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _supabase
          .from('saved_comparisons')
          .select()
          .eq('user_id', currentUser.id)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      return [];
    }
  }

  // Export comparison to shareable format
  Map<String, dynamic> exportComparison(VenueComparison comparison) {
    return {
      'venues': comparison.venues.map((v) => v.toJson()).toList(),
      'features': comparison.features.map((f) => f.toJson()).toList(),
      'created_at': comparison.createdAt.toIso8601String(),
      'version': '1.0',
    };
  }
}
