// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VenueImpl _$$VenueImplFromJson(Map<String, dynamic> json) => _$VenueImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: json['zipCode'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String?,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      capacity: (json['capacity'] as num).toInt(),
      pricePerHour: (json['pricePerHour'] as num).toDouble(),
      contactEmail: json['contactEmail'] as String,
      contactPhone: json['contactPhone'] as String,
      website: json['website'] as String?,
      amenities: (json['amenities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      venueTypes: (json['venueTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      isVerified: json['isVerified'] as bool? ?? false,
      managerId: json['managerId'] as String?,
      availability: json['availability'] as Map<String, dynamic>?,
      pricing: json['pricing'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$VenueImplToJson(_$VenueImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'zipCode': instance.zipCode,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'imageUrl': instance.imageUrl,
      'images': instance.images,
      'capacity': instance.capacity,
      'pricePerHour': instance.pricePerHour,
      'contactEmail': instance.contactEmail,
      'contactPhone': instance.contactPhone,
      'website': instance.website,
      'amenities': instance.amenities,
      'venueTypes': instance.venueTypes,
      'averageRating': instance.averageRating,
      'reviewCount': instance.reviewCount,
      'isActive': instance.isActive,
      'isVerified': instance.isVerified,
      'managerId': instance.managerId,
      'availability': instance.availability,
      'pricing': instance.pricing,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$VenueInquiryImpl _$$VenueInquiryImplFromJson(Map<String, dynamic> json) =>
    _$VenueInquiryImpl(
      id: json['id'] as String,
      venueId: json['venueId'] as String,
      organizerId: json['organizerId'] as String,
      eventName: json['eventName'] as String,
      eventDate: DateTime.parse(json['eventDate'] as String),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      expectedGuests: (json['expectedGuests'] as num).toInt(),
      message: json['message'] as String,
      status: json['status'] as String? ?? 'pending',
      venueResponse: json['venueResponse'] as String?,
      responseDate: json['responseDate'] == null
          ? null
          : DateTime.parse(json['responseDate'] as String),
      quotedPrice: (json['quotedPrice'] as num?)?.toDouble(),
      additionalDetails: json['additionalDetails'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      venueName: json['venueName'] as String?,
      venueImageUrl: json['venueImageUrl'] as String?,
      organizerName: json['organizerName'] as String?,
      organizerEmail: json['organizerEmail'] as String?,
    );

Map<String, dynamic> _$$VenueInquiryImplToJson(_$VenueInquiryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'venueId': instance.venueId,
      'organizerId': instance.organizerId,
      'eventName': instance.eventName,
      'eventDate': instance.eventDate.toIso8601String(),
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'expectedGuests': instance.expectedGuests,
      'message': instance.message,
      'status': instance.status,
      'venueResponse': instance.venueResponse,
      'responseDate': instance.responseDate?.toIso8601String(),
      'quotedPrice': instance.quotedPrice,
      'additionalDetails': instance.additionalDetails,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'venueName': instance.venueName,
      'venueImageUrl': instance.venueImageUrl,
      'organizerName': instance.organizerName,
      'organizerEmail': instance.organizerEmail,
    };

_$VenueRatingImpl _$$VenueRatingImplFromJson(Map<String, dynamic> json) =>
    _$VenueRatingImpl(
      id: json['id'] as String,
      venueId: json['venueId'] as String,
      userId: json['userId'] as String,
      rating: (json['rating'] as num).toDouble(),
      review: json['review'] as String,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      helpfulCount: (json['helpfulCount'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      userName: json['userName'] as String?,
      userAvatar: json['userAvatar'] as String?,
    );

Map<String, dynamic> _$$VenueRatingImplToJson(_$VenueRatingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'venueId': instance.venueId,
      'userId': instance.userId,
      'rating': instance.rating,
      'review': instance.review,
      'images': instance.images,
      'helpfulCount': instance.helpfulCount,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'userName': instance.userName,
      'userAvatar': instance.userAvatar,
    };

_$VenueComparisonImpl _$$VenueComparisonImplFromJson(
        Map<String, dynamic> json) =>
    _$VenueComparisonImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      venueIds:
          (json['venueIds'] as List<dynamic>).map((e) => e as String).toList(),
      name: json['name'] as String?,
      notes: json['notes'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$VenueComparisonImplToJson(
        _$VenueComparisonImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'venueIds': instance.venueIds,
      'name': instance.name,
      'notes': instance.notes,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
