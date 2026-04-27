import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_slot.freezed.dart';
part 'time_slot.g.dart';

@freezed
class TimeSlot with _$TimeSlot {
  const factory TimeSlot({
    required String id,
    required DateTime startTime,
    required DateTime endTime,
    @Default(true) bool isAvailable,
    double? price,
    double? minimumSpend,
    int? availableCapacity,
    String? description,
  }) = _TimeSlot;

  factory TimeSlot.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotFromJson(json);

  factory TimeSlot.fromSupabase(Map<String, dynamic> data) {
    return TimeSlot(
      id: data['id'] as String,
      startTime: DateTime.parse(data['start_time'] as String),
      endTime: DateTime.parse(data['end_time'] as String),
      isAvailable: data['is_available'] as bool? ?? true,
      price: (data['price'] as num?)?.toDouble(),
      minimumSpend: (data['minimum_spend'] as num?)?.toDouble(),
      availableCapacity: data['available_capacity'] as int?,
      description: data['description'] as String?,
    );
  }
}

@freezed
class TimeSlotAvailability with _$TimeSlotAvailability {
  const factory TimeSlotAvailability({
    required String venueId,
    required DateTime date,
    required List<TimeSlot> slots,
    String? tableId,
  }) = _TimeSlotAvailability;

  factory TimeSlotAvailability.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotAvailabilityFromJson(json);
}

@freezed
class BookingTimeSlot with _$BookingTimeSlot {
  const factory BookingTimeSlot({
    required String id,
    required String bookingId,
    required String timeSlotId,
    required DateTime startTime,
    required DateTime endTime,
    @Default(false) bool isExtended,
    DateTime? extendedUntil,
    required DateTime createdAt,
  }) = _BookingTimeSlot;

  factory BookingTimeSlot.fromJson(Map<String, dynamic> json) =>
      _$BookingTimeSlotFromJson(json);

  factory BookingTimeSlot.fromSupabase(Map<String, dynamic> data) {
    return BookingTimeSlot(
      id: data['id'] as String,
      bookingId: data['booking_id'] as String,
      timeSlotId: data['time_slot_id'] as String,
      startTime: DateTime.parse(data['start_time'] as String),
      endTime: DateTime.parse(data['end_time'] as String),
      isExtended: data['is_extended'] as bool? ?? false,
      extendedUntil: data['extended_until'] != null
          ? DateTime.parse(data['extended_until'] as String)
          : null,
      createdAt: DateTime.parse(data['created_at'] as String),
    );
  }
}
