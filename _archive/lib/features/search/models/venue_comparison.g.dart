// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_comparison.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VenueComparisonImpl _$$VenueComparisonImplFromJson(
        Map<String, dynamic> json) =>
    _$VenueComparisonImpl(
      venues: (json['venues'] as List<dynamic>)
          .map((e) => ComparisonVenue.fromJson(e as Map<String, dynamic>))
          .toList(),
      features: (json['features'] as List<dynamic>)
          .map((e) => ComparisonFeature.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$VenueComparisonImplToJson(
        _$VenueComparisonImpl instance) =>
    <String, dynamic>{
      'venues': instance.venues,
      'features': instance.features,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$ComparisonVenueImpl _$$ComparisonVenueImplFromJson(
        Map<String, dynamic> json) =>
    _$ComparisonVenueImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      address: json['address'] as String,
      features: json['features'] as Map<String, dynamic>,
      averagePrice: (json['averagePrice'] as num?)?.toDouble(),
      capacity: (json['capacity'] as num?)?.toInt(),
      amenities: (json['amenities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      musicGenres: (json['musicGenres'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      dressCode: json['dressCode'] as String?,
      hours: (json['hours'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$$ComparisonVenueImplToJson(
        _$ComparisonVenueImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'address': instance.address,
      'features': instance.features,
      'averagePrice': instance.averagePrice,
      'capacity': instance.capacity,
      'amenities': instance.amenities,
      'musicGenres': instance.musicGenres,
      'dressCode': instance.dressCode,
      'hours': instance.hours,
    };

_$ComparisonFeatureImpl _$$ComparisonFeatureImplFromJson(
        Map<String, dynamic> json) =>
    _$ComparisonFeatureImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      type: $enumDecode(_$FeatureTypeEnumMap, json['type']),
      icon: json['icon'] as String?,
      importance: (json['importance'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ComparisonFeatureImplToJson(
        _$ComparisonFeatureImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'type': _$FeatureTypeEnumMap[instance.type]!,
      'icon': instance.icon,
      'importance': instance.importance,
    };

const _$FeatureTypeEnumMap = {
  FeatureType.boolean: 'boolean',
  FeatureType.rating: 'rating',
  FeatureType.price: 'price',
  FeatureType.text: 'text',
  FeatureType.list: 'list',
};
