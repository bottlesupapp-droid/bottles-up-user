// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FavoriteImpl _$$FavoriteImplFromJson(Map<String, dynamic> json) =>
    _$FavoriteImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$FavoriteTypeEnumMap, json['type']),
      itemId: json['itemId'] as String,
      itemName: json['itemName'] as String?,
      itemImage: json['itemImage'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$FavoriteImplToJson(_$FavoriteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': _$FavoriteTypeEnumMap[instance.type]!,
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemImage': instance.itemImage,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$FavoriteTypeEnumMap = {
  FavoriteType.event: 'event',
  FavoriteType.venue: 'venue',
  FavoriteType.promoter: 'promoter',
};
