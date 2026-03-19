import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/venue.dart';
import '../services/venue_service.dart';
import '../services/venue_inquiry_service.dart';
import '../services/venue_comparison_service.dart';

part 'venue_provider.g.dart';

// Venue List Provider
@riverpod
class VenueList extends _$VenueList {
  @override
  Future<List<Venue>> build({
    String? city,
    int? minCapacity,
    double? maxPrice,
    List<String>? amenities,
  }) async {
    return VenueService().getVenues(
      city: city,
      minCapacity: minCapacity,
      maxPrice: maxPrice,
      amenities: amenities,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}

// Single Venue Provider
@riverpod
class VenueDetail extends _$VenueDetail {
  @override
  Future<Venue> build(String venueId) async {
    return VenueService().getVenueById(venueId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => VenueService().getVenueById(venueId));
  }
}

// Venue Search Provider
@riverpod
class VenueSearch extends _$VenueSearch {
  @override
  Future<List<Venue>> build(String query) async {
    if (query.isEmpty) return [];
    return VenueService().searchVenues(query);
  }
}

// Venue Ratings Provider
@riverpod
class VenueRatings extends _$VenueRatings {
  @override
  Future<List<VenueRating>> build(String venueId) async {
    return VenueService().getVenueRatings(venueId);
  }

  Future<void> submitRating({
    required String venueId,
    required double rating,
    required String review,
    List<String>? images,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await VenueService().submitRating(
        venueId: venueId,
        rating: rating,
        review: review,
        images: images,
      );
      return VenueService().getVenueRatings(venueId);
    });
  }
}

// Venue Inquiries Provider
@riverpod
class VenueInquiries extends _$VenueInquiries {
  @override
  Future<List<VenueInquiry>> build() async {
    return VenueInquiryService().getOrganizerInquiries();
  }

  Future<void> submitInquiry({
    required String venueId,
    required String eventName,
    required DateTime eventDate,
    required String startTime,
    required String endTime,
    required int expectedGuests,
    required String message,
    Map<String, dynamic>? additionalDetails,
  }) async {
    await VenueInquiryService().submitInquiry(
      venueId: venueId,
      eventName: eventName,
      eventDate: eventDate,
      startTime: startTime,
      endTime: endTime,
      expectedGuests: expectedGuests,
      message: message,
      additionalDetails: additionalDetails,
    );
    ref.invalidateSelf();
  }

  Future<void> cancelInquiry(String inquiryId) async {
    await VenueInquiryService().cancelInquiry(inquiryId);
    ref.invalidateSelf();
  }
}

// Venue Comparisons Provider
@riverpod
class VenueComparisons extends _$VenueComparisons {
  @override
  Future<List<VenueComparison>> build() async {
    return VenueComparisonService().getUserComparisons();
  }

  Future<void> createComparison({
    required List<String> venueIds,
    String? name,
    Map<String, dynamic>? notes,
  }) async {
    await VenueComparisonService().createComparison(
      venueIds: venueIds,
      name: name,
      notes: notes,
    );
    ref.invalidateSelf();
  }

  Future<void> deleteComparison(String comparisonId) async {
    await VenueComparisonService().deleteComparison(comparisonId);
    ref.invalidateSelf();
  }
}

// Venue Comparison Detail Provider
@riverpod
class VenueComparisonDetail extends _$VenueComparisonDetail {
  @override
  Future<Map<String, dynamic>> build(List<String> venueIds) async {
    return VenueComparisonService().compareVenues(venueIds);
  }
}
