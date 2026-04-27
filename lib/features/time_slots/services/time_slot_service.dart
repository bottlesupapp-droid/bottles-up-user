import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/time_slot.dart';

class TimeSlotService {
  static final TimeSlotService _instance = TimeSlotService._internal();
  factory TimeSlotService() => _instance;
  TimeSlotService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Get available time slots for a venue on a specific date
  Future<List<TimeSlot>> getAvailableSlots({
    required String venueId,
    required DateTime date,
    String? tableId,
  }) async {
    try {
      final dateStr = date.toIso8601String().split('T')[0];

      final response = await _supabase.rpc('get_available_time_slots', params: {
        'venue_id_param': venueId,
        'date_param': dateStr,
        'table_id_param': tableId,
      });

      return (response as List)
          .map((item) => TimeSlot.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get available slots: $e');
    }
  }

  // Get time slot availability for multiple days
  Future<Map<DateTime, List<TimeSlot>>> getWeeklyAvailability({
    required String venueId,
    required DateTime startDate,
    int days = 7,
  }) async {
    try {
      final Map<DateTime, List<TimeSlot>> availability = {};

      for (int i = 0; i < days; i++) {
        final date = startDate.add(Duration(days: i));
        final slots = await getAvailableSlots(
          venueId: venueId,
          date: date,
        );
        availability[date] = slots;
      }

      return availability;
    } catch (e) {
      throw Exception('Failed to get weekly availability: $e');
    }
  }

  // Reserve a time slot
  Future<BookingTimeSlot> reserveTimeSlot({
    required String bookingId,
    required String timeSlotId,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Get time slot details
      final slot = await _supabase
          .from('time_slots')
          .select()
          .eq('id', timeSlotId)
          .single();

      // Check availability
      if (slot['is_available'] == false) {
        throw Exception('Time slot is no longer available');
      }

      // Create booking time slot
      final response = await _supabase.from('booking_time_slots').insert({
        'booking_id': bookingId,
        'time_slot_id': timeSlotId,
        'start_time': slot['start_time'],
        'end_time': slot['end_time'],
      }).select().single();

      // Mark slot as unavailable
      await _supabase
          .from('time_slots')
          .update({'is_available': false})
          .eq('id', timeSlotId);

      return BookingTimeSlot.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to reserve time slot: $e');
    }
  }

  // Extend booking time slot
  Future<void> extendTimeSlot({
    required String bookingTimeSlotId,
    required DateTime extendedUntil,
  }) async {
    try {
      await _supabase
          .from('booking_time_slots')
          .update({
            'is_extended': true,
            'extended_until': extendedUntil.toIso8601String(),
          })
          .eq('id', bookingTimeSlotId);
    } catch (e) {
      throw Exception('Failed to extend time slot: $e');
    }
  }

  // Cancel time slot reservation
  Future<void> cancelTimeSlotReservation(String bookingTimeSlotId) async {
    try {
      // Get booking time slot
      final bookingSlot = await _supabase
          .from('booking_time_slots')
          .select()
          .eq('id', bookingTimeSlotId)
          .single();

      // Delete booking time slot
      await _supabase
          .from('booking_time_slots')
          .delete()
          .eq('id', bookingTimeSlotId);

      // Make time slot available again
      await _supabase
          .from('time_slots')
          .update({'is_available': true})
          .eq('id', bookingSlot['time_slot_id']);
    } catch (e) {
      throw Exception('Failed to cancel time slot: $e');
    }
  }

  // Get popular time slots
  Future<List<TimeSlot>> getPopularTimeSlots({
    required String venueId,
    int limit = 5,
  }) async {
    try {
      final response = await _supabase.rpc('get_popular_time_slots', params: {
        'venue_id_param': venueId,
        'limit_count': limit,
      });

      return (response as List)
          .map((item) => TimeSlot.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Check if time slot is still available
  Future<bool> isSlotAvailable(String timeSlotId) async {
    try {
      final response = await _supabase
          .from('time_slots')
          .select('is_available')
          .eq('id', timeSlotId)
          .single();

      return response['is_available'] as bool? ?? false;
    } catch (e) {
      return false;
    }
  }

  // Get next available slot
  Future<TimeSlot?> getNextAvailableSlot({
    required String venueId,
    DateTime? afterTime,
  }) async {
    try {
      final after = afterTime ?? DateTime.now();
      final dateStr = after.toIso8601String();

      final response = await _supabase
          .from('time_slots')
          .select()
          .eq('venue_id', venueId)
          .eq('is_available', true)
          .gte('start_time', dateStr)
          .order('start_time')
          .limit(1)
          .maybeSingle();

      if (response == null) return null;

      return TimeSlot.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  // Get prime time slots (evenings/weekends)
  Future<List<TimeSlot>> getPrimeTimeSlots({
    required String venueId,
    required DateTime date,
  }) async {
    try {
      final slots = await getAvailableSlots(
        venueId: venueId,
        date: date,
      );

      // Filter for prime time (after 6 PM or weekends)
      return slots.where((slot) {
        final hour = slot.startTime.hour;
        final isWeekend = slot.startTime.weekday >= 6;
        final isPrimeTime = hour >= 18 || isWeekend;
        return isPrimeTime;
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
