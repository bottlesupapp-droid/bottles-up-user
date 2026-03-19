// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventFilterImpl _$$EventFilterImplFromJson(Map<String, dynamic> json) =>
    _$EventFilterImpl(
      genre: json['genre'] as String? ?? null,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      location: json['location'] as String? ?? null,
    );

Map<String, dynamic> _$$EventFilterImplToJson(_$EventFilterImpl instance) =>
    <String, dynamic>{
      'genre': instance.genre,
      'date': instance.date?.toIso8601String(),
      'location': instance.location,
    };
