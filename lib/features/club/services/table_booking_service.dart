import 'package:supabase_flutter/supabase_flutter.dart';
import '../../home/models/club.dart';
import '../models/table_booking.dart';

class TableBookingService {
  static final TableBookingService _instance = TableBookingService._internal();
  factory TableBookingService() => _instance;
  TableBookingService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get club details with booking constraints
  Future<Club?> getClubWithBookingDetails(String clubId) async {
    try {
      final response = await _supabase
          .from('clubs')
          .select('*, club_hours(*)')
          .eq('id', clubId)
          .single();

      return Club.fromSupabase(response);
    } catch (e) {
      throw Exception('Failed to fetch club details: $e');
    }
  }

  /// Get available time slots for a specific date
  Future<List<String>> getAvailableTimeSlots({
    required String clubId,
    required DateTime date,
    required int guestCount,
  }) async {
    try {
      // Get club hours for the day
      final dayOfWeek = date.weekday % 7; // Convert to 0-6 (Sunday = 0)

      final hoursResponse = await _supabase
          .from('club_hours')
          .select('open_time, close_time, is_closed')
          .eq('club_id', clubId)
          .eq('day_of_week', dayOfWeek)
          .maybeSingle();

      if (hoursResponse == null || hoursResponse['is_closed'] == true) {
        return [];
      }

      // Get club settings
      final clubResponse = await _supabase
          .from('clubs')
          .select('time_slot_duration_minutes, advance_booking_hours')
          .eq('id', clubId)
          .single();

      final slotDuration = clubResponse['time_slot_duration_minutes'] ?? 30;
      final advanceHours = clubResponse['advance_booking_hours'] ?? 2;

      // Parse operating hours
      final openTime = DateTime.parse('2000-01-01 ${hoursResponse['open_time']}');
      var closeTime = DateTime.parse('2000-01-01 ${hoursResponse['close_time']}');

      // Handle midnight crossing (e.g., 21:00 to 04:00)
      if (closeTime.isBefore(openTime) || closeTime.isAtSameMomentAs(openTime)) {
        closeTime = closeTime.add(const Duration(days: 1));
      }

      // Generate all possible time slots
      final List<String> allSlots = [];
      DateTime currentSlot = openTime;

      while (currentSlot.isBefore(closeTime)) {
        final timeString = '${currentSlot.hour.toString().padLeft(2, '0')}:${currentSlot.minute.toString().padLeft(2, '0')}';
        allSlots.add(timeString);
        currentSlot = currentSlot.add(Duration(minutes: slotDuration));
      }

      // Filter out past slots for today
      final now = DateTime.now();
      final minimumBookingTime = now.add(Duration(hours: advanceHours));

      List<String> availableSlots = allSlots;

      if (date.year == now.year && date.month == now.month && date.day == now.day) {
        availableSlots = allSlots.where((slot) {
          final slotTime = DateTime(
            date.year,
            date.month,
            date.day,
            int.parse(slot.split(':')[0]),
            int.parse(slot.split(':')[1]),
          );
          return slotTime.isAfter(minimumBookingTime);
        }).toList();
      }

      // Get existing bookings for the date
      final bookingsResponse = await _supabase
          .from('table_bookings')
          .select('start_time, table_id')
          .eq('booking_date', date.toIso8601String().split('T')[0])
          .eq('status', 'confirmed');

      // Get available tables
      final tablesResponse = await _supabase
          .from('club_tables')
          .select('id, capacity')
          .eq('club_id', clubId)
          .eq('is_active', true)
          .gte('capacity', guestCount);

      final availableTables = (tablesResponse).map((t) => t['id']).toSet();
      final bookedSlots = <String>{};

      for (final booking in bookingsResponse) {
        if (availableTables.contains(booking['table_id'])) {
          bookedSlots.add(booking['start_time']);
        }
      }

      // Remove fully booked slots
      availableSlots.removeWhere((slot) => bookedSlots.contains(slot));

      return availableSlots;
    } catch (e) {
      throw Exception('Failed to get available time slots: $e');
    }
  }

  /// Check if booking is valid
  Future<bool> validateBooking({
    required String clubId,
    required DateTime date,
    required String timeSlot,
    required int guestCount,
  }) async {
    try {
      // Check club capacity limits
      final clubResponse = await _supabase
          .from('clubs')
          .select('max_guests_per_booking')
          .eq('id', clubId)
          .single();

      final maxGuests = clubResponse['max_guests_per_booking'] ?? 20;
      if (guestCount > maxGuests) {
        return false;
      }

      // Check if time slot is available
      final availableSlots = await getAvailableTimeSlots(
        clubId: clubId,
        date: date,
        guestCount: guestCount,
      );

      return availableSlots.contains(timeSlot);
    } catch (e) {
      return false;
    }
  }

  /// Get available tables for booking
  Future<List<Map<String, dynamic>>> getAvailableTables({
    required String clubId,
    required DateTime date,
    required String timeSlot,
    required int guestCount,
  }) async {
    try {
      // Get all tables that can accommodate the guest count
      final tablesResponse = await _supabase
          .from('club_tables')
          .select('*')
          .eq('club_id', clubId)
          .eq('is_active', true)
          .gte('capacity', guestCount)
          .order('capacity', ascending: true);

      // Get existing bookings for the time slot
      final bookingsResponse = await _supabase
          .from('table_bookings')
          .select('table_id')
          .eq('booking_date', date.toIso8601String().split('T')[0])
          .eq('start_time', timeSlot)
          .eq('status', 'confirmed');

      final bookedTableIds = (bookingsResponse).map((b) => b['table_id']).toSet();

      // Filter out booked tables
      final availableTables = (tablesResponse)
          .where((table) => !bookedTableIds.contains(table['id']))
          .toList();

      return availableTables;
    } catch (e) {
      throw Exception('Failed to get available tables: $e');
    }
  }

  /// Create a new table booking
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
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Parse time slot to get start and end times
      final startTimeParts = timeSlot.split(':');
      final startTime = '${startTimeParts[0]}:${startTimeParts[1]}:00';

      // Assume 2-hour booking duration (can be customized)
      final startDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(startTimeParts[0]),
        int.parse(startTimeParts[1]),
      );
      final endDateTime = startDateTime.add(const Duration(hours: 2));
      final endTime = '${endDateTime.hour.toString().padLeft(2, '0')}:${endDateTime.minute.toString().padLeft(2, '0')}:00';

      // Get table details for pricing
      final tableResponse = await _supabase
          .from('club_tables')
          .select('price, minimum_spend')
          .eq('id', tableId)
          .single();

      final totalPrice = tableResponse['price'] ?? 0;

      // Generate confirmation code
      final confirmationCode = 'BUP${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

      final bookingData = {
        'user_id': user.id,
        'table_id': tableId,
        'guest_count': guestCount,
        'booking_date': date.toIso8601String().split('T')[0],
        'time_slot': timeSlot,
        'start_time': startTime,
        'end_time': endTime,
        'total_price': totalPrice,
        'special_requests': specialRequests,
        'contact_phone': contactPhone,
        'contact_email': contactEmail,
        'confirmation_code': confirmationCode,
        'status': 'pending',
      };

      final response = await _supabase
          .from('table_bookings')
          .insert(bookingData)
          .select()
          .single();

      return TableBooking.fromSupabase(response);
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  /// Get user's bookings
  Future<List<TableBooking>> getUserBookings() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase
          .from('table_bookings')
          .select('*, club_tables(name, club_id), clubs(name)')
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      return (response)
          .map((booking) => TableBooking.fromSupabase(booking))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user bookings: $e');
    }
  }

  /// Cancel a booking
  Future<void> cancelBooking(String bookingId) async {
    try {
      await _supabase
          .from('table_bookings')
          .update({'status': 'cancelled'})
          .eq('id', bookingId);
    } catch (e) {
      throw Exception('Failed to cancel booking: $e');
    }
  }
}