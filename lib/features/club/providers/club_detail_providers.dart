import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/bottle.dart';
import '../models/club_amenity.dart';
import '../models/club_hours.dart';
import '../models/club_table.dart';

part 'club_detail_providers.g.dart';

final supabaseClient = Supabase.instance.client;

// Provider for fetching club tables
@riverpod
class ClubTables extends _$ClubTables {
  @override
  Future<List<ClubTable>> build(String clubId) async {
    final response = await supabaseClient
        .from('club_tables')
        .select('*')
        .eq('club_id', clubId)
        .eq('is_active', true)
        .order('is_vip', ascending: false) // VIP tables first
        .order('capacity', ascending: true);

    if (response.isEmpty) return [];

    return response.map((data) => ClubTable.fromSupabase(data)).toList();
  }
}

// Provider for fetching available tables based on date and time
@riverpod
class AvailableClubTables extends _$AvailableClubTables {
  @override
  Future<List<ClubTable>> build({
    required String clubId,
    required DateTime date,
    required String timeSlot,
    required int guestCount,
  }) async {
    // First get all club tables
    final allTables = await ref.watch(clubTablesProvider(clubId).future);

    // Filter tables that can accommodate the guest count
    final suitableTables =
        allTables.where((table) => table.capacity >= guestCount).toList();

    // Check for existing bookings that conflict
    final dateStr = date.toIso8601String().split('T')[0];

    final bookings = await supabaseClient
        .from('table_bookings')
        .select('table_id')
        .eq('booking_date', dateStr)
        .eq('time_slot', timeSlot)
        .inFilter('status', ['pending', 'confirmed']);

    final bookedTableIds = bookings.map((b) => b['table_id'] as String).toSet();

    // Return only available tables
    return suitableTables
        .where((table) => !bookedTableIds.contains(table.id))
        .toList();
  }
}

// Provider for fetching bottle packages
@riverpod
class ClubBottles extends _$ClubBottles {
  @override
  Future<List<Bottle>> build(String clubId) async {
    final response = await supabaseClient
        .from('bottles')
        .select('*')
        .eq('club_id', clubId)
        .eq('is_available', true)
        .order('is_featured', ascending: false) // Featured bottles first
        .order('category', ascending: true)
        .order('price', ascending: true);

    if (response.isEmpty) return [];

    return response.map((data) => Bottle.fromSupabase(data)).toList();
  }
}

// Provider for fetching featured bottles only
@riverpod
class FeaturedClubBottles extends _$FeaturedClubBottles {
  @override
  Future<List<Bottle>> build(String clubId) async {
    final response = await supabaseClient
        .from('bottles')
        .select('*')
        .eq('club_id', clubId)
        .eq('is_available', true)
        .eq('is_featured', true)
        .order('price', ascending: true);

    if (response.isEmpty) return [];

    return response.map((data) => Bottle.fromSupabase(data)).toList();
  }
}

// Provider for fetching club amenities
@riverpod
class ClubAmenities extends _$ClubAmenities {
  @override
  Future<List<ClubAmenity>> build(String clubId) async {
    final response = await supabaseClient
        .from('club_amenities')
        .select('*')
        .eq('club_id', clubId)
        .order('created_at', ascending: true);

    if (response.isEmpty) return [];

    return response.map((data) => ClubAmenity.fromSupabase(data)).toList();
  }
}

// Provider for fetching club hours
@riverpod
class ClubHoursData extends _$ClubHoursData {
  @override
  Future<List<ClubHours>> build(String clubId) async {
    final response = await supabaseClient
        .from('club_hours')
        .select('*')
        .eq('club_id', clubId)
        .order('day_of_week', ascending: true);

    if (response.isEmpty) return [];

    return response.map((data) => ClubHours.fromSupabase(data)).toList();
  }
}

// Provider for getting available time slots for a specific date
@riverpod
class AvailableTimeSlots extends _$AvailableTimeSlots {
  @override
  Future<List<String>> build({
    required String clubId,
    required DateTime date,
    required int guestCount,
  }) async {
    // Get club hours for the day of week
    final dayOfWeek = date.weekday % 7; // Convert to 0-6 format
    final clubHours = await ref.watch(clubHoursDataProvider(clubId).future);

    final dayHours =
        clubHours.where((h) => h.dayOfWeek == dayOfWeek).firstOrNull;

    if (dayHours == null ||
        dayHours.isClosed ||
        dayHours.openTime == null ||
        dayHours.closeTime == null) {
      return [];
    }

    // Generate time slots (30-minute intervals by default)
    final slots = <String>[];

    // Parse open and close times
    final openTimeParts = dayHours.openTime!.split(':');
    final closeTimeParts = dayHours.closeTime!.split(':');

    int openHour = int.parse(openTimeParts[0]);
    int openMinute = int.parse(openTimeParts[1]);
    int closeHour = int.parse(closeTimeParts[0]);
    int closeMinute = int.parse(closeTimeParts[1]);

    // Handle overnight hours (e.g., 21:00 - 04:00)
    if (closeHour < openHour) {
      closeHour += 24;
    }

    int currentHour = openHour;
    int currentMinute = openMinute;

    while (currentHour < closeHour ||
        (currentHour == closeHour && currentMinute < closeMinute)) {
      // Format time slot
      final displayHour = currentHour % 24;
      final period = displayHour >= 12 ? 'PM' : 'AM';
      final hourDisplay = displayHour == 0
          ? 12
          : (displayHour > 12 ? displayHour - 12 : displayHour);
      final timeSlot =
          '${hourDisplay.toString().padLeft(2, '0')}:${currentMinute.toString().padLeft(2, '0')} $period';

      slots.add(timeSlot);

      // Add 30 minutes
      currentMinute += 30;
      if (currentMinute >= 60) {
        currentMinute = 0;
        currentHour++;
      }
    }

    // Filter out slots that are already fully booked or in the past
    final now = DateTime.now();
    final dateStr = date.toIso8601String().split('T')[0];
    final isToday = dateStr == now.toIso8601String().split('T')[0];

    final availableSlots = <String>[];

    for (final slot in slots) {
      // Skip past time slots if it's today
      if (isToday) {
        final slotHour = _parseSlotHour(slot);
        final slotMinute = _parseSlotMinute(slot);
        final slotDateTime =
            DateTime(date.year, date.month, date.day, slotHour, slotMinute);

        if (slotDateTime.isBefore(now.add(const Duration(hours: 2)))) {
          continue; // Skip slots that are too soon (2-hour advance booking)
        }
      }

      // Check if there are available tables for this time slot
      final availableTables = await ref.watch(availableClubTablesProvider(
        clubId: clubId,
        date: date,
        timeSlot: slot,
        guestCount: guestCount,
      ).future);

      if (availableTables.isNotEmpty) {
        availableSlots.add(slot);
      }
    }

    return availableSlots;
  }

  int _parseSlotHour(String slot) {
    final parts = slot.split(':');
    final hour = int.parse(parts[0]);
    final isPM = slot.contains('PM');

    if (isPM && hour != 12) {
      return hour + 12;
    } else if (!isPM && hour == 12) {
      return 0;
    }
    return hour;
  }

  int _parseSlotMinute(String slot) {
    final parts = slot.split(':');
    final minutePart = parts[1].split(' ')[0];
    return int.parse(minutePart);
  }
}

// Provider for validating booking availability
@riverpod
class BookingValidator extends _$BookingValidator {
  @override
  Future<bool> build({
    required String clubId,
    required DateTime date,
    required String timeSlot,
    required int guestCount,
    String? tableId,
  }) async {
    // Check if the club is open at this time
    final timeSlots = await ref.watch(availableTimeSlotsProvider(
      clubId: clubId,
      date: date,
      guestCount: guestCount,
    ).future);

    if (!timeSlots.contains(timeSlot)) {
      return false;
    }

    // If specific table is requested, check its availability
    if (tableId != null) {
      final availableTables = await ref.watch(availableClubTablesProvider(
        clubId: clubId,
        date: date,
        timeSlot: timeSlot,
        guestCount: guestCount,
      ).future);

      return availableTables.any((table) => table.id == tableId);
    }

    // Otherwise, just check if any tables are available
    final availableTables = await ref.watch(availableClubTablesProvider(
      clubId: clubId,
      date: date,
      timeSlot: timeSlot,
      guestCount: guestCount,
    ).future);

    return availableTables.isNotEmpty;
  }
}
