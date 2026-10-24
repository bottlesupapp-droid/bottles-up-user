import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/checkout.dart';
import '../models/venue.dart';
import '../site_error.dart';

/// Booking a table through the website's `create-table-booking-checkout`: the website re-reads the table, the time, the window, what is left, the bottles and their prices, applies the
/// promo code and the venue's tax, takes the table for ten minutes, and makes the page to pay on. Where a payment stands afterwards is `TicketCheckoutService.status`, the same for tickets
/// and tables.
class TableCheckoutService {
  TableCheckoutService(this._db);

  final SupabaseClient _db;

  /// [night] is "yyyy-MM-dd", the night the guest picked. [bottles] maps a bottle id to how many.
  Future<CheckoutStart> start({
    required String venueId,
    required String tableId,
    required String slotId,
    required String night,
    required int guests,
    int? hours,
    required String name,
    required String email,
    String? phone,
    Map<String, int> bottles = const {},
    String? promoCode,
    required BottlePaymentChoice bottlePayment,
  }) async {
    try {
      final response = await _db.functions.invoke('create-table-booking-checkout', body: {
        'venue_id': venueId,
        'table_type_id': tableId,
        'time_slot_id': slotId,
        'booking_date': night,
        'guest_count': guests,
        if (hours != null) 'hours': hours,
        'customer_name': name.trim(),
        'customer_email': email.trim(),
        if (phone != null && phone.trim().isNotEmpty) 'customer_phone': phone.trim(),
        'bottles': [
          for (final e in bottles.entries)
            if (e.value > 0) {'bottle_id': e.key, 'quantity': e.value},
        ],
        if (promoCode != null && promoCode.trim().isNotEmpty) 'promo_code': promoCode.trim(),
        'bottle_payment_choice': bottlePayment.db,
      });
      final data = response.data;
      final start = data is Map ? parseCheckoutStart(Map<String, dynamic>.from(data)) : null;
      if (start == null) {
        logProblem('start table checkout', 'no payment address in the answer: $data');
        throw const SiteException(actionFailedMessage);
      }
      return start;
    } catch (error) {
      throw siteExceptionFrom(error, generic: 'We could not start your booking. Check your connection and try again.');
    }
  }
}
