// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventImpl _$$EventImplFromJson(Map<String, dynamic> json) => _$EventImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      categoryId: json['categoryId'] as String,
      clubId: json['clubId'] as String,
      zoneId: json['zoneId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      eventDate: DateTime.parse(json['eventDate'] as String),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      ticketPrice: (json['ticketPrice'] as num).toDouble(),
      maxCapacity: (json['maxCapacity'] as num).toInt(),
      currentBookings: (json['currentBookings'] as num?)?.toInt(),
      rsvpCount: (json['rsvpCount'] as num?)?.toInt(),
      tableBookingCount: (json['tableBookingCount'] as num?)?.toInt(),
      dressCode: json['dressCode'] as String?,
      invitationCode: json['invitationCode'] as String?,
      isPrivate: json['isPrivate'] as bool? ?? false,
      locationHidden: json['locationHidden'] as bool? ?? true,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      tableArrangementImageUrl: json['tableArrangementImageUrl'] as String?,
      status: json['status'] as String? ?? 'upcoming',
      isActive: json['isActive'] as bool? ?? true,
      isFeatured: json['isFeatured'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      categoryName: json['categoryName'] as String?,
      clubName: json['clubName'] as String?,
      clubLocation: json['clubLocation'] as String?,
      clubImageUrl: json['clubImageUrl'] as String?,
      zoneName: json['zoneName'] as String?,
      zoneDescription: json['zoneDescription'] as String?,
    );

Map<String, dynamic> _$$EventImplToJson(_$EventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'categoryId': instance.categoryId,
      'clubId': instance.clubId,
      'zoneId': instance.zoneId,
      'name': instance.name,
      'description': instance.description,
      'eventDate': instance.eventDate.toIso8601String(),
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'ticketPrice': instance.ticketPrice,
      'maxCapacity': instance.maxCapacity,
      'currentBookings': instance.currentBookings,
      'rsvpCount': instance.rsvpCount,
      'tableBookingCount': instance.tableBookingCount,
      'dressCode': instance.dressCode,
      'invitationCode': instance.invitationCode,
      'isPrivate': instance.isPrivate,
      'locationHidden': instance.locationHidden,
      'images': instance.images,
      'tableArrangementImageUrl': instance.tableArrangementImageUrl,
      'status': instance.status,
      'isActive': instance.isActive,
      'isFeatured': instance.isFeatured,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'categoryName': instance.categoryName,
      'clubName': instance.clubName,
      'clubLocation': instance.clubLocation,
      'clubImageUrl': instance.clubImageUrl,
      'zoneName': instance.zoneName,
      'zoneDescription': instance.zoneDescription,
    };
