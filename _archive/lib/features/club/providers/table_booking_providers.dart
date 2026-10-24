import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/table_booking_service.dart';
import '../models/table_booking.dart';
import '../../home/models/club.dart';

part 'table_booking_providers.g.dart';

@riverpod
TableBookingService tableBookingService(TableBookingServiceRef ref) {
  return TableBookingService();
}

@riverpod
class ClubBookingDetails extends _$ClubBookingDetails {
  @override
  Future<Club?> build(String clubId) async {
    final service = ref.read(tableBookingServiceProvider);
    return await service.getClubWithBookingDetails(clubId);
  }
}

@riverpod
class AvailableTimeSlots extends _$AvailableTimeSlots {
  @override
  Future<List<String>> build({
    required String clubId,
    required DateTime date,
    required int guestCount,
  }) async {
    final service = ref.read(tableBookingServiceProvider);
    return await service.getAvailableTimeSlots(
      clubId: clubId,
      date: date,
      guestCount: guestCount,
    );
  }

  /// Refresh time slots when parameters change
  void refresh({
    required String clubId,
    required DateTime date,
    required int guestCount,
  }) {
    // Use invalidate on the specific provider instance instead of self
    ref.invalidate(availableTimeSlotsProvider(
      clubId: clubId,
      date: date,
      guestCount: guestCount,
    ));
  }
}

@riverpod
class AvailableTables extends _$AvailableTables {
  @override
  Future<List<Map<String, dynamic>>> build({
    required String clubId,
    required DateTime date,
    required String timeSlot,
    required int guestCount,
  }) async {
    final service = ref.read(tableBookingServiceProvider);
    return await service.getAvailableTables(
      clubId: clubId,
      date: date,
      timeSlot: timeSlot,
      guestCount: guestCount,
    );
  }
}

@riverpod
class BookingValidator extends _$BookingValidator {
  @override
  Future<bool> build({
    required String clubId,
    required DateTime date,
    required String timeSlot,
    required int guestCount,
  }) async {
    final service = ref.read(tableBookingServiceProvider);
    return await service.validateBooking(
      clubId: clubId,
      date: date,
      timeSlot: timeSlot,
      guestCount: guestCount,
    );
  }
}

@riverpod
class UserBookings extends _$UserBookings {
  @override
  Future<List<TableBooking>> build() async {
    final service = ref.read(tableBookingServiceProvider);
    return await service.getUserBookings();
  }

  /// Refresh user bookings
  void refresh() {
    ref.invalidateSelf();
  }

  /// Cancel a booking
  Future<void> cancelBooking(String bookingId) async {
    final service = ref.read(tableBookingServiceProvider);
    await service.cancelBooking(bookingId);
    refresh();
  }
}

@riverpod
class BookingCreator extends _$BookingCreator {
  @override
  AsyncValue<TableBooking?> build() {
    return const AsyncValue.data(null);
  }

  /// Create a new booking
  Future<TableBooking> createBooking({
    required String clubId,
    required String tableId,
    required DateTime date,
    required String timeSlot,
    required int guestCount,
    String? specialRequests,
    String? contactPhone,
    String? contactEmail,
  }) async {
    state = const AsyncValue.loading();

    try {
      final service = ref.read(tableBookingServiceProvider);
      final booking = await service.createBooking(
        clubId: clubId,
        tableId: tableId,
        date: date,
        timeSlot: timeSlot,
        guestCount: guestCount,
        specialRequests: specialRequests,
        contactPhone: contactPhone,
        contactEmail: contactEmail,
      );

      state = AsyncValue.data(booking);

      // Refresh related providers
      ref.read(userBookingsProvider.notifier).refresh();
      ref.invalidate(availableTimeSlotsProvider(
        clubId: clubId,
        date: date,
        guestCount: guestCount,
      ));

      return booking;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  /// Clear the booking state
  void clear() {
    state = const AsyncValue.data(null);
  }
}