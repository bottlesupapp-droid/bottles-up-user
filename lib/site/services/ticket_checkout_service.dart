import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/checkout.dart';
import '../site_error.dart';

/// Buying tickets through the website's own functions, so the price, the capacity, the promo and access codes and the payment are all decided and re-checked by the website:
/// `validate-promo-code`, `validate-tier-access-code`, `site-create-checkout-session` and `site-booking-status`. Payment happens on Stripe's page, which the website makes.
class TicketCheckoutService {
  TicketCheckoutService(this._db);

  final SupabaseClient _db;

  Future<Map<String, dynamic>> _call(String name, Map<String, dynamic> body) async {
    final response = await _db.functions.invoke(name, body: body);
    final data = response.data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw const FormatException('the website answered with something that is not an object');
  }

  /// Previews a promo code for tickets (or, with [appliesTo] `tables`, for a table booking) at a venue, for a subtotal. The website re-checks it when the order is made.
  Future<PromoCheck> checkPromo({required String code, required int subtotalCents, String? venueId, String appliesTo = 'tickets'}) async {
    try {
      return parsePromoCheck(await _call('validate-promo-code', {
        'code': code.trim(),
        'applies_to': appliesTo,
        if (venueId != null) 'venue_id': venueId,
        'subtotal_cents': subtotalCents,
      }));
    } catch (error) {
      throw siteExceptionFrom(error, generic: 'We could not check that code. Check your connection and try again.');
    }
  }

  /// Checks an access code for a ticket type that needs one.
  Future<AccessCheck> checkAccessCode({required String tierId, required String code}) async {
    try {
      return parseAccessCheck(await _call('validate-tier-access-code', {'tier_id': tierId, 'code': code.trim()}));
    } catch (error) {
      throw siteExceptionFrom(error, generic: 'We could not check that code. Check your connection and try again.');
    }
  }

  /// Makes the order and the page to pay on. A refusal from the website (sold out, event not on sale, a code that does not work) comes back as its own sentence.
  Future<CheckoutStart> start({
    required String eventId,
    required String tierId,
    required int quantity,
    required String name,
    required String email,
    String? phone,
    String? promoCode,
    String? accessCode,
  }) async {
    try {
      final answer = await _call('site-create-checkout-session', {
        'event_id': eventId,
        'tier_id': tierId,
        'quantity': quantity,
        'customer_name': name.trim(),
        'customer_email': email.trim(),
        if (phone != null && phone.trim().isNotEmpty) 'customer_phone': phone.trim(),
        if (promoCode != null && promoCode.trim().isNotEmpty) 'promo_code': promoCode.trim(),
        if (accessCode != null && accessCode.trim().isNotEmpty) 'access_code': accessCode.trim(),
      });
      final start = parseCheckoutStart(answer);
      if (start == null) {
        logProblem('start checkout', 'no payment address in the answer: $answer');
        throw const SiteException(actionFailedMessage);
      }
      return start;
    } catch (error) {
      throw siteExceptionFrom(error, generic: 'We could not start your payment. Check your connection and try again.');
    }
  }

  /// Where a payment stands. The website asks Stripe itself when its own record does not say paid yet, so this is safe to ask again and again.
  Future<PaymentStatus> status(String sessionId) async {
    try {
      return parsePaymentStatus(await _call('site-booking-status', {'session_id': sessionId}));
    } catch (error) {
      throw siteExceptionFrom(error, generic: 'We could not check your payment. Check your connection and try again.');
    }
  }
}
