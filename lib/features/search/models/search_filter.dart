import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_filter.freezed.dart';
part 'search_filter.g.dart';

@freezed
class SearchFilter with _$SearchFilter {
  const factory SearchFilter({
    List<String>? categories,
    DateTimeRange? dateRange,
    PriceRange? priceRange,
    double? maxDistance,
    List<String>? neighborhoods,
    List<String>? amenities,
    bool? hasAvailability,
    @Default(false) bool mustHaveBottleService,
    @Default(false) bool verifiedVenuesOnly,
    String? sortBy,
  }) = _SearchFilter;

  factory SearchFilter.fromJson(Map<String, dynamic> json) =>
      _$SearchFilterFromJson(json);
}

@freezed
class PriceRange with _$PriceRange {
  const factory PriceRange({
    required double min,
    required double max,
  }) = _PriceRange;

  factory PriceRange.fromJson(Map<String, dynamic> json) =>
      _$PriceRangeFromJson(json);
}

@freezed
class DateTimeRange with _$DateTimeRange {
  const factory DateTimeRange({
    required DateTime start,
    required DateTime end,
  }) = _DateTimeRange;

  factory DateTimeRange.fromJson(Map<String, dynamic> json) =>
      _$DateTimeRangeFromJson(json);
}

@freezed
class SearchResult with _$SearchResult {
  const factory SearchResult({
    required String id,
    required String type, // 'event', 'venue', 'promoter'
    required String title,
    String? subtitle,
    String? imageUrl,
    double? rating,
    int? reviewCount,
    double? price,
    String? location,
    DateTime? eventDate,
    @Default(false) bool isVerified,
    @Default(false) bool isFeatured,
  }) = _SearchResult;

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);

  factory SearchResult.fromSupabase(Map<String, dynamic> data) {
    return SearchResult(
      id: data['id'] as String,
      type: data['type'] as String,
      title: data['title'] as String,
      subtitle: data['subtitle'] as String?,
      imageUrl: data['image_url'] as String?,
      rating: (data['rating'] as num?)?.toDouble(),
      reviewCount: data['review_count'] as int?,
      price: (data['price'] as num?)?.toDouble(),
      location: data['location'] as String?,
      eventDate: data['event_date'] != null
          ? DateTime.parse(data['event_date'] as String)
          : null,
      isVerified: data['is_verified'] as bool? ?? false,
      isFeatured: data['is_featured'] as bool? ?? false,
    );
  }
}

@freezed
class SearchSuggestion with _$SearchSuggestion {
  const factory SearchSuggestion({
    required String text,
    required String type, // 'query', 'venue', 'event', 'category'
    String? icon,
    String? subtitle,
  }) = _SearchSuggestion;

  factory SearchSuggestion.fromJson(Map<String, dynamic> json) =>
      _$SearchSuggestionFromJson(json);
}

@freezed
class SearchHistory with _$SearchHistory {
  const factory SearchHistory({
    required String id,
    required String userId,
    required String query,
    SearchFilter? filters,
    required DateTime createdAt,
  }) = _SearchHistory;

  factory SearchHistory.fromJson(Map<String, dynamic> json) =>
      _$SearchHistoryFromJson(json);

  factory SearchHistory.fromSupabase(Map<String, dynamic> data) {
    return SearchHistory(
      id: data['id'] as String,
      userId: data['user_id'] as String,
      query: data['query'] as String,
      filters: data['filters'] != null
          ? SearchFilter.fromJson(data['filters'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(data['created_at'] as String),
    );
  }
}
