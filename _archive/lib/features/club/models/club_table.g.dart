// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club_table.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClubTableImpl _$$ClubTableImplFromJson(Map<String, dynamic> json) =>
    _$ClubTableImpl(
      id: json['id'] as String,
      clubId: json['clubId'] as String,
      name: json['name'] as String,
      capacity: (json['capacity'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      isVip: json['isVip'] as bool? ?? false,
      locationDescription: json['locationDescription'] as String?,
      minimumSpend: (json['minimumSpend'] as num?)?.toDouble(),
      isActive: json['isActive'] as bool? ?? true,
      imageUrl: json['imageUrl'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ClubTableImplToJson(_$ClubTableImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clubId': instance.clubId,
      'name': instance.name,
      'capacity': instance.capacity,
      'price': instance.price,
      'isVip': instance.isVip,
      'locationDescription': instance.locationDescription,
      'minimumSpend': instance.minimumSpend,
      'isActive': instance.isActive,
      'imageUrl': instance.imageUrl,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
