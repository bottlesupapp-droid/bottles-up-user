// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bottle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BottleImpl _$$BottleImplFromJson(Map<String, dynamic> json) => _$BottleImpl(
      id: json['id'] as String,
      clubId: json['clubId'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      subcategory: json['subcategory'] as String?,
      brand: json['brand'] as String?,
      price: (json['price'] as num).toDouble(),
      volumeMl: (json['volumeMl'] as num?)?.toInt(),
      alcoholContent: (json['alcoholContent'] as num?)?.toDouble(),
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      isAvailable: json['isAvailable'] as bool? ?? true,
      isFeatured: json['isFeatured'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$BottleImplToJson(_$BottleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clubId': instance.clubId,
      'name': instance.name,
      'category': instance.category,
      'subcategory': instance.subcategory,
      'brand': instance.brand,
      'price': instance.price,
      'volumeMl': instance.volumeMl,
      'alcoholContent': instance.alcoholContent,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'isAvailable': instance.isAvailable,
      'isFeatured': instance.isFeatured,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
