import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/table_booking.dart';
import '../site_error.dart';

/// The signed-in person's table bookings (`site_table_bookings`) and what hangs off them. The database shows a person only the bookings made with their own e-mail address (and the
/// bottle lines, club payments and refunds of those bookings), so nothing here filters by person. Nothing here changes anything.
class MyBookingsService {
  MyBookingsService(this._db);

  final SupabaseClient _db;

  static const String _columns = 'id, status, confirmation_code, guest_count, hours, booking_date, venue_id, deposit_cents, bottle_subtotal_cents, tax_cents, bottlesup_fee_cents, discount_cents, '
      'amount_total_cents, amount_paid_cents, currency, bottle_payment_choice, checked_in_at, cancelled_at, cancellation_reason, created_at, '
      'site_table_types(name), site_venues(name, address), site_venue_time_slots(start_time, label)';

  /// Every booking that is paid, was cancelled or was refunded, newest first. Bookings never paid (a checkout left half way) are not bookings the person has and are left out.
  Future<List<TableBooking>> bookings() async {
    try {
      final rows = await _db.from('site_table_bookings').select(_columns).inFilter('status', ['paid', 'refunded', 'cancelled']).order('created_at', ascending: false);
      return [
        for (final r in rows)
          if (parseTableBooking(Map<String, dynamic>.from(r)) case final b?) b,
      ];
    } catch (error) {
      logProblem('load table bookings', error);
      throw SiteException(loadFailedMessage('your bookings'));
    }
  }

  /// One booking with its bottles, the club payments waiting for the guest's confirmation and the refunds recorded; null when it is not there (or is not theirs).
  Future<TableBooking?> booking(String id) async {
    try {
      final row = await _db.from('site_table_bookings').select(_columns).eq('id', id).maybeSingle();
      if (row == null) return null;
      final results = await Future.wait<List<Map<String, dynamic>>>([
        _db.from('site_table_booking_bottles').select('id, bottle_name, size, quantity, unit_price_cents, line_total_cents, payment_status, is_addon, cancelled_at, created_at').eq('booking_id', id).neq('payment_status', 'pending_payment').order('created_at', ascending: true),
        _db.from('site_table_booking_club_payments').select('id, confirm_token, billed_amount_cents, amount_paid_cents, payment_method').eq('booking_id', id).eq('customer_confirmation_status', 'pending'),
        _db.from('site_table_booking_refunds').select('refund_type, amount_cents, reason, recorded_at').eq('booking_id', id).order('recorded_at', ascending: true),
      ]);
      return parseTableBooking(
        Map<String, dynamic>.from(row),
        bottles: [for (final r in results[0]) if (parseBookingBottle(r) case final b?) b],
        clubPayments: [for (final r in results[1]) if (parseClubPayment(r) case final p?) p],
        refunds: [for (final r in results[2]) if (parseBookingRefund(r) case final x?) x],
      );
    } catch (error) {
      logProblem('load table booking', error);
      throw SiteException(loadFailedMessage('this booking'));
    }
  }
}
