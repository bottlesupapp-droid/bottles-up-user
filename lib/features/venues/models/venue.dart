import 'package:freezed_annotation/freezed_annotation.dart';

part 'venue.freezed.dart';
part 'venue.g.dart';

@freezed
class Venue with _$Venue {
  const factory Venue({
    required String id,
    required String name,
    required String description,
    required String address,
    required String city,
    required String state,
    required String zipCode,
    required double latitude,
    required double longitude,
    String? imageUrl,
    List<String>? images,
    required int capacity,
    required double pricePerHour,
    required String contactEmail,
    required String contactPhone,
    String? website,
    @Default([]) List<String> amenities,
    @Default([]) List<String> venueTypes,
    @Default(0.0) double averageRating,
    @Default(0) int reviewCount,
    @Default(true) bool isActive,
    @Default(false) bool isVerified,
    String? managerId,
    Map<String, dynamic>? availability,
    Map<String, dynamic>? pricing,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Venue;

  factory Venue.fromJson(Map<String, dynamic> json) => _$VenueFromJson(json);

  factory Venue.fromSupabase(Map<String, dynamic> data) {
    return Venue(
      id: data['id'] as String,
      name: data['name'] as String,
      description: data['description'] as String? ?? '',
      address: data['address'] as String,
      city: data['city'] as String,
      state: data['state'] as String,
      zipCode: data['zip_code'] as String,
      latitude: (data['latitude'] as num).toDouble(),
      longitude: (data['longitude'] as num).toDouble(),
      imageUrl: data['image_url'] as String?,
      images: data['images'] != null ? List<String>.from(data['images']) : null,
      capacity: data['capacity'] as int,
      pricePerHour: (data['price_per_hour'] as num).toDouble(),
      contactEmail: data['contact_email'] as String,
      contactPhone: data['contact_phone'] as String,
      website: data['website'] as String?,
      amenities: data['amenities'] != null ? List<String>.from(data['amenities']) : [],
      venueTypes: data['venue_types'] != null ? List<String>.from(data['venue_types']) : [],
      averageRating: (data['average_rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: data['review_count'] as int? ?? 0,
      isActive: data['is_active'] as bool? ?? true,
      isVerified: data['is_verified'] as bool? ?? false,
      managerId: data['manager_id'] as String?,
      availability: data['availability'] as Map<String, dynamic>?,
      pricing: data['pricing'] as Map<String, dynamic>?,
      createdAt: data['created_at'] != null ? DateTime.parse(data['created_at'] as String) : null,
      updatedAt: data['updated_at'] != null ? DateTime.parse(data['updated_at'] as String) : null,
    );
  }
}

@freezed
class VenueInquiry with _$VenueInquiry {
  const factory VenueInquiry({
    required String id,
    required String venueId,
    required String organizerId,
    required String eventName,
    required DateTime eventDate,
    required String startTime,
    required String endTime,
    required int expectedGuests,
    required String message,
    @Default('pending') String status,
    String? venueResponse,
    DateTime? responseDate,
    double? quotedPrice,
    Map<String, dynamic>? additionalDetails,
    DateTime? createdAt,
    DateTime? updatedAt,

    // Joined data
    String? venueName,
    String? venueImageUrl,
    String? organizerName,
    String? organizerEmail,
  }) = _VenueInquiry;

  factory VenueInquiry.fromJson(Map<String, dynamic> json) => _$VenueInquiryFromJson(json);

  factory VenueInquiry.fromSupabase(Map<String, dynamic> data) {
    return VenueInquiry(
      id: data['id'] as String,
      venueId: data['venue_id'] as String,
      organizerId: data['organizer_id'] as String,
      eventName: data['event_name'] as String,
      eventDate: DateTime.parse(data['event_date'] as String),
      startTime: data['start_time'] as String,
      endTime: data['end_time'] as String,
      expectedGuests: data['expected_guests'] as int,
      message: data['message'] as String,
      status: data['status'] as String? ?? 'pending',
      venueResponse: data['venue_response'] as String?,
      responseDate: data['response_date'] != null ? DateTime.parse(data['response_date'] as String) : null,
      quotedPrice: (data['quoted_price'] as num?)?.toDouble(),
      additionalDetails: data['additional_details'] as Map<String, dynamic>?,
      createdAt: data['created_at'] != null ? DateTime.parse(data['created_at'] as String) : null,
      updatedAt: data['updated_at'] != null ? DateTime.parse(data['updated_at'] as String) : null,
      venueName: data['venue_name'] as String?,
      venueImageUrl: data['venue_image_url'] as String?,
      organizerName: data['organizer_name'] as String?,
      organizerEmail: data['organizer_email'] as String?,
    );
  }
}

@freezed
class VenueRating with _$VenueRating {
  const factory VenueRating({
    required String id,
    required String venueId,
    required String userId,
    required double rating,
    required String review,
    List<String>? images,
    @Default(0) int helpfulCount,
    DateTime? createdAt,
    DateTime? updatedAt,

    // Joined data
    String? userName,
    String? userAvatar,
  }) = _VenueRating;

  factory VenueRating.fromJson(Map<String, dynamic> json) => _$VenueRatingFromJson(json);

  factory VenueRating.fromSupabase(Map<String, dynamic> data) {
    return VenueRating(
      id: data['id'] as String,
      venueId: data['venue_id'] as String,
      userId: data['user_id'] as String,
      rating: (data['rating'] as num).toDouble(),
      review: data['review'] as String,
      images: data['images'] != null ? List<String>.from(data['images']) : null,
      helpfulCount: data['helpful_count'] as int? ?? 0,
      createdAt: data['created_at'] != null ? DateTime.parse(data['created_at'] as String) : null,
      updatedAt: data['updated_at'] != null ? DateTime.parse(data['updated_at'] as String) : null,
      userName: data['user_name'] as String?,
      userAvatar: data['user_avatar'] as String?,
    );
  }
}

@freezed
class VenueComparison with _$VenueComparison {
  const factory VenueComparison({
    required String id,
    required String userId,
    required List<String> venueIds,
    String? name,
    Map<String, dynamic>? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _VenueComparison;

  factory VenueComparison.fromJson(Map<String, dynamic> json) => _$VenueComparisonFromJson(json);

  factory VenueComparison.fromSupabase(Map<String, dynamic> data) {
    return VenueComparison(
      id: data['id'] as String,
      userId: data['user_id'] as String,
      venueIds: List<String>.from(data['venue_ids']),
      name: data['name'] as String?,
      notes: data['notes'] as Map<String, dynamic>?,
      createdAt: data['created_at'] != null ? DateTime.parse(data['created_at'] as String) : null,
      updatedAt: data['updated_at'] != null ? DateTime.parse(data['updated_at'] as String) : null,
    );
  }
}

extension VenueInquiryX on VenueInquiry {
  String get statusDisplay {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'accepted':
        return 'Accepted';
      case 'rejected':
        return 'Rejected';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  bool get isPending => status == 'pending';
  bool get isAccepted => status == 'accepted';
  bool get isRejected => status == 'rejected';
}
