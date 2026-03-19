// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TableBookingImpl _$$TableBookingImplFromJson(Map<String, dynamic> json) =>
    _$TableBookingImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      tableId: json['tableId'] as String,
      guestCount: (json['guestCount'] as num).toInt(),
      bookingDate: DateTime.parse(json['bookingDate'] as String),
      timeSlot: json['timeSlot'] as String,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      specialRequests: json['specialRequests'] as String?,
      contactPhone: json['contactPhone'] as String?,
      contactEmail: json['contactEmail'] as String?,
      confirmationCode: json['confirmationCode'] as String?,
      status: json['status'] as String? ?? 'pending',
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      tableName: json['tableName'] as String?,
      clubId: json['clubId'] as String?,
      clubName: json['clubName'] as String?,
    );

Map<String, dynamic> _$$TableBookingImplToJson(_$TableBookingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'tableId': instance.tableId,
      'guestCount': instance.guestCount,
      'bookingDate': instance.bookingDate.toIso8601String(),
      'timeSlot': instance.timeSlot,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'totalPrice': instance.totalPrice,
      'specialRequests': instance.specialRequests,
      'contactPhone': instance.contactPhone,
      'contactEmail': instance.contactEmail,
      'confirmationCode': instance.confirmationCode,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'tableName': instance.tableName,
      'clubId': instance.clubId,
      'clubName': instance.clubName,
    };

_$ClubTableImpl _$$ClubTableImplFromJson(Map<String, dynamic> json) =>
    _$ClubTableImpl(
      id: json['id'] as String,
      clubId: json['clubId'] as String,
      name: json['name'] as String,
      capacity: (json['capacity'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      locationDescription: json['locationDescription'] as String?,
      minimumSpend: (json['minimumSpend'] as num?)?.toDouble(),
      isVip: json['isVip'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
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
      'locationDescription': instance.locationDescription,
      'minimumSpend': instance.minimumSpend,
      'isVip': instance.isVip,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$ClubHoursImpl _$$ClubHoursImplFromJson(Map<String, dynamic> json) =>
    _$ClubHoursImpl(
      id: json['id'] as String,
      clubId: json['clubId'] as String,
      dayOfWeek: (json['dayOfWeek'] as num).toInt(),
      openTime: json['openTime'] as String?,
      closeTime: json['closeTime'] as String?,
      isClosed: json['isClosed'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ClubHoursImplToJson(_$ClubHoursImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clubId': instance.clubId,
      'dayOfWeek': instance.dayOfWeek,
      'openTime': instance.openTime,
      'closeTime': instance.closeTime,
      'isClosed': instance.isClosed,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
