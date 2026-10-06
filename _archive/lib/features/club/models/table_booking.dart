import 'package:freezed_annotation/freezed_annotation.dart';

part 'table_booking.freezed.dart';
part 'table_booking.g.dart';

@freezed
class TableBooking with _$TableBooking {
  const factory TableBooking({
    required String id,
    required String userId,
    required String tableId,
    required int guestCount,
    required DateTime bookingDate,
    required String timeSlot,
    String? startTime,
    String? endTime,
    required double totalPrice,
    String? specialRequests,
    String? contactPhone,
    String? contactEmail,
    String? confirmationCode,
    @Default('pending') String status,
    DateTime? createdAt,
    DateTime? updatedAt,
    // Related data
    String? tableName,
    String? clubId,
    String? clubName,
  }) = _TableBooking;

  factory TableBooking.fromJson(Map<String, dynamic> json) => _$TableBookingFromJson(json);

  factory TableBooking.fromSupabase(Map<String, dynamic> data) {
    return TableBooking(
      id: data['id'],
      userId: data['user_id'],
      tableId: data['table_id'],
      guestCount: data['guest_count'],
      bookingDate: DateTime.parse(data['booking_date']),
      timeSlot: data['time_slot'],
      startTime: data['start_time'],
      endTime: data['end_time'],
      totalPrice: (data['total_price'] ?? 0).toDouble(),
      specialRequests: data['special_requests'],
      contactPhone: data['contact_phone'],
      contactEmail: data['contact_email'],
      confirmationCode: data['confirmation_code'],
      status: data['status'] ?? 'pending',
      createdAt: data['created_at'] != null ? DateTime.parse(data['created_at']) : null,
      updatedAt: data['updated_at'] != null ? DateTime.parse(data['updated_at']) : null,
      // Related data
      tableName: data['club_tables']?['name'],
      clubId: data['club_tables']?['club_id'] ?? data['clubs']?['id'],
      clubName: data['club_tables']?['clubs']?['name'] ?? data['clubs']?['name'],
    );
  }
}

@freezed
class ClubTable with _$ClubTable {
  const factory ClubTable({
    required String id,
    required String clubId,
    required String name,
    required int capacity,
    required double price,
    String? locationDescription,
    double? minimumSpend,
    @Default(false) bool isVip,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ClubTable;

  factory ClubTable.fromJson(Map<String, dynamic> json) => _$ClubTableFromJson(json);

  factory ClubTable.fromSupabase(Map<String, dynamic> data) {
    return ClubTable(
      id: data['id'],
      clubId: data['club_id'],
      name: data['name'],
      capacity: data['capacity'],
      price: (data['price'] ?? 0).toDouble(),
      locationDescription: data['location_description'],
      minimumSpend: data['minimum_spend']?.toDouble(),
      isVip: data['is_vip'] ?? false,
      isActive: data['is_active'] ?? true,
      createdAt: data['created_at'] != null ? DateTime.parse(data['created_at']) : null,
      updatedAt: data['updated_at'] != null ? DateTime.parse(data['updated_at']) : null,
    );
  }
}

@freezed
class ClubHours with _$ClubHours {
  const factory ClubHours({
    required String id,
    required String clubId,
    required int dayOfWeek,
    String? openTime,
    String? closeTime,
    @Default(false) bool isClosed,
    DateTime? createdAt,
  }) = _ClubHours;

  factory ClubHours.fromJson(Map<String, dynamic> json) => _$ClubHoursFromJson(json);

  factory ClubHours.fromSupabase(Map<String, dynamic> data) {
    return ClubHours(
      id: data['id'],
      clubId: data['club_id'],
      dayOfWeek: data['day_of_week'],
      openTime: data['open_time'],
      closeTime: data['close_time'],
      isClosed: data['is_closed'] ?? false,
      createdAt: data['created_at'] != null ? DateTime.parse(data['created_at']) : null,
    );
  }
}