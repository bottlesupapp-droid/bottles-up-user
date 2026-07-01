import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bottles_up_user/features/bookings/models/user_booking.dart';

/// Fetches all bookings for the current user from:
/// - events_bookings (simple ticket purchases)
/// - event_rsvps (guestlist RSVPs)
/// - event_table_bookings (event table reservations)
/// - table_bookings (club table reservations)
final userBookingsProvider = FutureProvider.autoDispose<List<UserBooking>>((ref) async {
  final supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser;
  if (user == null) return [];

  List<UserBooking> eventBookings = [];
  List<UserBooking> rsvpBookings = [];
  List<UserBooking> tableBookings = [];
  List<UserBooking> clubTableBookings = [];

  // ── events_bookings (ticket purchases) ──────────────────────────────────
  try {
    // Join events only — skip the nested clubs join to avoid FK resolution
    // errors if the relationship isn't declared in the DB schema.
    final rows = await supabase
        .from('events_bookings')
        .select('id, user_id, event_id, ticket_quantity, total_amount, status, '
            'confirmation_code, qr_code, payment_status, created_at, '
            'events(name, event_date, start_time, images, club_id, '
            'clubs(name, images))')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    eventBookings = (rows as List<dynamic>)
        .map((b) => UserBooking.fromEventBooking(b as Map<String, dynamic>))
        .toList();
  } catch (e) {
    // Retry without the clubs join in case the FK isn't wired in Supabase
    try {
      final rows = await supabase
          .from('events_bookings')
          .select('id, user_id, event_id, ticket_quantity, total_amount, status, '
              'confirmation_code, qr_code, payment_status, created_at, '
              'events(name, event_date, start_time, images)')
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      eventBookings = (rows as List<dynamic>)
          .map((b) => UserBooking.fromEventBooking(b as Map<String, dynamic>))
          .toList();
    } catch (e2) {
      debugPrint('❌ events_bookings fetch failed: $e2');
    }
  }

  // ── event_rsvps (guestlist) ─────────────────────────────────────────────
  try {
    final rows = await supabase
        .from('event_rsvps')
        .select('id, user_id, event_id, rsvp_type, status, '
            'verification_code, qr_code_data, created_at, '
            'events(name, event_date, start_time, images, clubs(name, images))')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    rsvpBookings = (rows as List<dynamic>)
        .map((b) => UserBooking.fromRSVP(b as Map<String, dynamic>))
        .toList();
  } catch (e) {
    try {
      final rows = await supabase
          .from('event_rsvps')
          .select('id, user_id, event_id, rsvp_type, status, '
              'verification_code, qr_code_data, created_at, '
              'events(name, event_date, start_time, images)')
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      rsvpBookings = (rows as List<dynamic>)
          .map((b) => UserBooking.fromRSVP(b as Map<String, dynamic>))
          .toList();
    } catch (e2) {
      debugPrint('❌ event_rsvps fetch failed: $e2');
    }
  }

  // ── event_table_bookings (event table reservations) ─────────────────────
  try {
    final rows = await supabase
        .from('event_table_bookings')
        .select('id, user_id, event_id, guest_count, deposit_amount, status, '
            'payment_status, special_requests, created_at, '
            'events(name, event_date, start_time, images, clubs(name, images))')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    tableBookings = (rows as List<dynamic>)
        .map((b) => UserBooking.fromTableBooking(b as Map<String, dynamic>))
        .toList();
  } catch (e) {
    try {
      final rows = await supabase
          .from('event_table_bookings')
          .select('id, user_id, event_id, guest_count, deposit_amount, status, '
              'payment_status, special_requests, created_at, '
              'events(name, event_date, start_time, images)')
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      tableBookings = (rows as List<dynamic>)
          .map((b) => UserBooking.fromTableBooking(b as Map<String, dynamic>))
          .toList();
    } catch (e2) {
      debugPrint('❌ event_table_bookings fetch failed: $e2');
    }
  }

  // ── table_bookings (club reservations via club detail flow) ─────────────
  try {
    final rows = await supabase
        .from('table_bookings')
        .select('id, user_id, guest_count, total_price, status, '
            'confirmation_code, booking_date, start_time, created_at, '
            'club_tables(name, club_id, clubs(name, images))')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    clubTableBookings = (rows as List<dynamic>)
        .map((b) => UserBooking.fromClubTableBooking(b as Map<String, dynamic>))
        .toList();
  } catch (e) {
    debugPrint('❌ table_bookings fetch failed: $e');
  }

  final all = [...eventBookings, ...rsvpBookings, ...tableBookings, ...clubTableBookings];
  all.sort((a, b) => b.date.compareTo(a.date));
  return all;
});
