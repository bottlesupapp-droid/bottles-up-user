// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SearchFilterImpl _$$SearchFilterImplFromJson(Map<String, dynamic> json) =>
    _$SearchFilterImpl(
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      dateRange: json['dateRange'] == null
          ? null
          : DateTimeRange.fromJson(json['dateRange'] as Map<String, dynamic>),
      priceRange: json['priceRange'] == null
          ? null
          : PriceRange.fromJson(json['priceRange'] as Map<String, dynamic>),
      maxDistance: (json['maxDistance'] as num?)?.toDouble(),
      neighborhoods: (json['neighborhoods'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      amenities: (json['amenities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      hasAvailability: json['hasAvailability'] as bool?,
      mustHaveBottleService: json['mustHaveBottleService'] as bool? ?? false,
      verifiedVenuesOnly: json['verifiedVenuesOnly'] as bool? ?? false,
      sortBy: json['sortBy'] as String?,
    );

Map<String, dynamic> _$$SearchFilterImplToJson(_$SearchFilterImpl instance) =>
    <String, dynamic>{
      'categories': instance.categories,
      'dateRange': instance.dateRange,
      'priceRange': instance.priceRange,
      'maxDistance': instance.maxDistance,
      'neighborhoods': instance.neighborhoods,
      'amenities': instance.amenities,
      'hasAvailability': instance.hasAvailability,
      'mustHaveBottleService': instance.mustHaveBottleService,
      'verifiedVenuesOnly': instance.verifiedVenuesOnly,
      'sortBy': instance.sortBy,
    };

_$PriceRangeImpl _$$PriceRangeImplFromJson(Map<String, dynamic> json) =>
    _$PriceRangeImpl(
      min: (json['min'] as num).toDouble(),
      max: (json['max'] as num).toDouble(),
    );

Map<String, dynamic> _$$PriceRangeImplToJson(_$PriceRangeImpl instance) =>
    <String, dynamic>{
      'min': instance.min,
      'max': instance.max,
    };

_$DateTimeRangeImpl _$$DateTimeRangeImplFromJson(Map<String, dynamic> json) =>
    _$DateTimeRangeImpl(
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
    );

Map<String, dynamic> _$$DateTimeRangeImplToJson(_$DateTimeRangeImpl instance) =>
    <String, dynamic>{
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
    };

_$SearchResultImpl _$$SearchResultImplFromJson(Map<String, dynamic> json) =>
    _$SearchResultImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      imageUrl: json['imageUrl'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: (json['reviewCount'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toDouble(),
      location: json['location'] as String?,
      eventDate: json['eventDate'] == null
          ? null
          : DateTime.parse(json['eventDate'] as String),
      isVerified: json['isVerified'] as bool? ?? false,
      isFeatured: json['isFeatured'] as bool? ?? false,
    );

Map<String, dynamic> _$$SearchResultImplToJson(_$SearchResultImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'imageUrl': instance.imageUrl,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'price': instance.price,
      'location': instance.location,
      'eventDate': instance.eventDate?.toIso8601String(),
      'isVerified': instance.isVerified,
      'isFeatured': instance.isFeatured,
    };

_$SearchSuggestionImpl _$$SearchSuggestionImplFromJson(
        Map<String, dynamic> json) =>
    _$SearchSuggestionImpl(
      text: json['text'] as String,
      type: json['type'] as String,
      icon: json['icon'] as String?,
      subtitle: json['subtitle'] as String?,
    );

Map<String, dynamic> _$$SearchSuggestionImplToJson(
        _$SearchSuggestionImpl instance) =>
    <String, dynamic>{
      'text': instance.text,
      'type': instance.type,
      'icon': instance.icon,
      'subtitle': instance.subtitle,
    };

_$SearchHistoryImpl _$$SearchHistoryImplFromJson(Map<String, dynamic> json) =>
    _$SearchHistoryImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      query: json['query'] as String,
      filters: json['filters'] == null
          ? null
          : SearchFilter.fromJson(json['filters'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$SearchHistoryImplToJson(_$SearchHistoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'query': instance.query,
      'filters': instance.filters,
      'createdAt': instance.createdAt.toIso8601String(),
    };
