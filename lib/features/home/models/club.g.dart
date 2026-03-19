// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClubImpl _$$ClubImplFromJson(Map<String, dynamic> json) => _$ClubImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      location: json['location'] as String,
      priceRange: json['priceRange'] as String,
      description: json['description'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      websiteUrl: json['websiteUrl'] as String?,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      categoryId: json['categoryId'] as String?,
      categoryName: json['categoryName'] as String?,
      openingHours: json['openingHours'] as Map<String, dynamic>?,
      dressCode: json['dressCode'] as String?,
      ageRequirement: json['ageRequirement'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      maxGuestsPerBooking: (json['maxGuestsPerBooking'] as num?)?.toInt(),
      advanceBookingHours: (json['advanceBookingHours'] as num?)?.toInt(),
      timeSlotDurationMinutes:
          (json['timeSlotDurationMinutes'] as num?)?.toInt(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      contactNumber: json['contactNumber'] as String?,
    );

Map<String, dynamic> _$$ClubImplToJson(_$ClubImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'rating': instance.rating,
      'location': instance.location,
      'priceRange': instance.priceRange,
      'description': instance.description,
      'phone': instance.phone,
      'email': instance.email,
      'websiteUrl': instance.websiteUrl,
      'reviewCount': instance.reviewCount,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'openingHours': instance.openingHours,
      'dressCode': instance.dressCode,
      'ageRequirement': instance.ageRequirement,
      'isActive': instance.isActive,
      'maxGuestsPerBooking': instance.maxGuestsPerBooking,
      'advanceBookingHours': instance.advanceBookingHours,
      'timeSlotDurationMinutes': instance.timeSlotDurationMinutes,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'contactNumber': instance.contactNumber,
    };
