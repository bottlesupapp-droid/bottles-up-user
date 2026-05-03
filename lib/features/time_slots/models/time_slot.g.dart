// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_slot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TimeSlotImpl _$$TimeSlotImplFromJson(Map<String, dynamic> json) =>
    _$TimeSlotImpl(
      id: json['id'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      isAvailable: json['isAvailable'] as bool? ?? true,
      price: (json['price'] as num?)?.toDouble(),
      minimumSpend: (json['minimumSpend'] as num?)?.toDouble(),
      availableCapacity: (json['availableCapacity'] as num?)?.toInt(),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$TimeSlotImplToJson(_$TimeSlotImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'isAvailable': instance.isAvailable,
      'price': instance.price,
      'minimumSpend': instance.minimumSpend,
      'availableCapacity': instance.availableCapacity,
      'description': instance.description,
    };

_$TimeSlotAvailabilityImpl _$$TimeSlotAvailabilityImplFromJson(
        Map<String, dynamic> json) =>
    _$TimeSlotAvailabilityImpl(
      venueId: json['venueId'] as String,
      date: DateTime.parse(json['date'] as String),
      slots: (json['slots'] as List<dynamic>)
          .map((e) => TimeSlot.fromJson(e as Map<String, dynamic>))
          .toList(),
      tableId: json['tableId'] as String?,
    );

Map<String, dynamic> _$$TimeSlotAvailabilityImplToJson(
        _$TimeSlotAvailabilityImpl instance) =>
    <String, dynamic>{
      'venueId': instance.venueId,
      'date': instance.date.toIso8601String(),
      'slots': instance.slots,
      'tableId': instance.tableId,
    };

_$BookingTimeSlotImpl _$$BookingTimeSlotImplFromJson(
        Map<String, dynamic> json) =>
    _$BookingTimeSlotImpl(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String,
      timeSlotId: json['timeSlotId'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      isExtended: json['isExtended'] as bool? ?? false,
      extendedUntil: json['extendedUntil'] == null
          ? null
          : DateTime.parse(json['extendedUntil'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$BookingTimeSlotImplToJson(
        _$BookingTimeSlotImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookingId': instance.bookingId,
      'timeSlotId': instance.timeSlotId,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'isExtended': instance.isExtended,
      'extendedUntil': instance.extendedUntil?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
