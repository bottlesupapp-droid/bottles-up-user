import 'package:freezed_annotation/freezed_annotation.dart';

part 'venue_comparison.freezed.dart';
part 'venue_comparison.g.dart';

@freezed
class VenueComparison with _$VenueComparison {
  const factory VenueComparison({
    required List<ComparisonVenue> venues,
    required List<ComparisonFeature> features,
    required DateTime createdAt,
  }) = _VenueComparison;

  factory VenueComparison.fromJson(Map<String, dynamic> json) =>
      _$VenueComparisonFromJson(json);
}

@freezed
class ComparisonVenue with _$ComparisonVenue {
  const factory ComparisonVenue({
    required String id,
    required String name,
    String? imageUrl,
    required double rating,
    required int reviewCount,
    required String address,
    required Map<String, dynamic> features,
    double? averagePrice,
    int? capacity,
    List<String>? amenities,
    List<String>? musicGenres,
    String? dressCode,
    Map<String, String>? hours,
  }) = _ComparisonVenue;

  factory ComparisonVenue.fromJson(Map<String, dynamic> json) =>
      _$ComparisonVenueFromJson(json);

  factory ComparisonVenue.fromSupabase(Map<String, dynamic> data) {
    return ComparisonVenue(
      id: data['id'] as String,
      name: data['name'] as String,
      imageUrl: data['image_url'] as String?,
      rating: (data['rating'] as num).toDouble(),
      reviewCount: data['review_count'] as int,
      address: data['address'] as String,
      features: Map<String, dynamic>.from(data['features'] as Map),
      averagePrice: (data['average_price'] as num?)?.toDouble(),
      capacity: data['capacity'] as int?,
      amenities: data['amenities'] != null
          ? List<String>.from(data['amenities'] as List)
          : null,
      musicGenres: data['music_genres'] != null
          ? List<String>.from(data['music_genres'] as List)
          : null,
      dressCode: data['dress_code'] as String?,
      hours: data['hours'] != null
          ? Map<String, String>.from(data['hours'] as Map)
          : null,
    );
  }
}

@freezed
class ComparisonFeature with _$ComparisonFeature {
  const factory ComparisonFeature({
    required String id,
    required String name,
    required String category,
    required FeatureType type,
    String? icon,
    int? importance,
  }) = _ComparisonFeature;

  factory ComparisonFeature.fromJson(Map<String, dynamic> json) =>
      _$ComparisonFeatureFromJson(json);
}

enum FeatureType {
  boolean,
  rating,
  price,
  text,
  list,
}

// Predefined comparison categories
class ComparisonCategories {
  static const List<ComparisonFeature> pricing = [
    ComparisonFeature(
      id: 'avg_price',
      name: 'Average Price',
      category: 'Pricing',
      type: FeatureType.price,
      icon: 'attach_money',
      importance: 10,
    ),
    ComparisonFeature(
      id: 'bottle_min',
      name: 'Bottle Minimum',
      category: 'Pricing',
      type: FeatureType.price,
      icon: 'local_bar',
      importance: 9,
    ),
    ComparisonFeature(
      id: 'cover_charge',
      name: 'Cover Charge',
      category: 'Pricing',
      type: FeatureType.price,
      icon: 'paid',
      importance: 8,
    ),
  ];

  static const List<ComparisonFeature> amenities = [
    ComparisonFeature(
      id: 'vip_section',
      name: 'VIP Section',
      category: 'Amenities',
      type: FeatureType.boolean,
      icon: 'stars',
      importance: 7,
    ),
    ComparisonFeature(
      id: 'outdoor_seating',
      name: 'Outdoor Seating',
      category: 'Amenities',
      type: FeatureType.boolean,
      icon: 'deck',
      importance: 6,
    ),
    ComparisonFeature(
      id: 'parking',
      name: 'Parking Available',
      category: 'Amenities',
      type: FeatureType.boolean,
      icon: 'local_parking',
      importance: 5,
    ),
  ];

  static const List<ComparisonFeature> atmosphere = [
    ComparisonFeature(
      id: 'music_type',
      name: 'Music Type',
      category: 'Atmosphere',
      type: FeatureType.list,
      icon: 'music_note',
      importance: 8,
    ),
    ComparisonFeature(
      id: 'dress_code',
      name: 'Dress Code',
      category: 'Atmosphere',
      type: FeatureType.text,
      icon: 'checkroom',
      importance: 6,
    ),
    ComparisonFeature(
      id: 'capacity',
      name: 'Capacity',
      category: 'Atmosphere',
      type: FeatureType.text,
      icon: 'people',
      importance: 5,
    ),
  ];

  static const List<ComparisonFeature> ratings = [
    ComparisonFeature(
      id: 'overall_rating',
      name: 'Overall Rating',
      category: 'Ratings',
      type: FeatureType.rating,
      icon: 'star',
      importance: 10,
    ),
    ComparisonFeature(
      id: 'service_rating',
      name: 'Service',
      category: 'Ratings',
      type: FeatureType.rating,
      icon: 'room_service',
      importance: 7,
    ),
    ComparisonFeature(
      id: 'atmosphere_rating',
      name: 'Atmosphere',
      category: 'Ratings',
      type: FeatureType.rating,
      icon: 'celebration',
      importance: 6,
    ),
  ];

  static List<ComparisonFeature> get all => [
        ...pricing,
        ...amenities,
        ...atmosphere,
        ...ratings,
      ];
}
