// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club_amenity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClubAmenityImpl _$$ClubAmenityImplFromJson(Map<String, dynamic> json) =>
    _$ClubAmenityImpl(
      id: json['id'] as String,
      clubId: json['clubId'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ClubAmenityImplToJson(_$ClubAmenityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clubId': instance.clubId,
      'name': instance.name,
      'icon': instance.icon,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
