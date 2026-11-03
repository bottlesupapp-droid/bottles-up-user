import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/checkout.dart';
import '../models/venue.dart';
import '../site_error.dart';

/// An order of bottles that is waiting for its payment: the website will not take another until that one is paid or has expired. [url] is the page to pay it on.
class AddonPaymentPending extends SiteException {
  const AddonPaymentPending(super.message, this.url);

  final Uri url;
}

/// What the website did with an order of extra bottles: [payAtClub] was recorded and is paid at the club; [payAhead] needs paying now on [start].
class AddBottlesResult {
  const AddBottlesResult.atClub() : mode = BottlePaymentChoice.payAtClub, start = null;
  const AddBottlesResult.ahead(CheckoutStart this.start) : mode = BottlePaymentChoice.payAhead;

  final BottlePaymentChoice mode;
  final CheckoutStart? start;
}

enum AddonState { paid, pending, notFound }

/// Things a guest does to a booking after paying, through the website's own functions: order more bottles, answer a bottle replacement, confirm or report a payment the club recorded,
/// and ask for a refund. Each answer is the website's; the app never decides who may do what.
class BookingActionsService {
  BookingActionsService(this._db);

  final SupabaseClient _db;

  Future<Map<String, dynamic>> _call(String name, Map<String, dynamic> body) async {
    final response = await _db.functions.invoke(name, body: body);
    final data = response.data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw const FormatException('the website answered with something that is not an object');
  }

  /// Orders extra bottles for a paid booking. [bottles] maps a bottle id to how many; [choice] only counts when the venue lets the guest choose.
  Future<AddBottlesResult> addBottles({required String bookingId, required Map<String, int> bottles, required BottlePaymentChoice choice}) async {
    try {
      final data = await _call('add-table-booking-bottles', {
        'booking_id': bookingId,
        'bottles': [
          for (final e in bottles.entries)
            if (e.value > 0) {'bottle_id': e.key, 'quantity': e.value},
        ],
        if (choice == BottlePaymentChoice.payAtClub) 'bottle_payment_choice': 'pay_at_club',
      });
      if (data['success'] != true) throw const FormatException('unexpected answer');
      if (data['mode'] == 'due_at_venue') return const AddBottlesResult.atClub();
      final start = parseCheckoutStart({'url': data['url']});
      if (start == null) throw const FormatException('no payment page in the answer');
      return AddBottlesResult.ahead(start);
    } on FunctionException catch (error) {
      final details = error.details;
      final pending = details is Map ? details['pending_checkout_url'] : null;
      final url = pending is String ? Uri.tryParse(pending) : null;
      if (error.status == 409 && url != null && url.scheme == 'https') {
        throw AddonPaymentPending('You already have an order waiting on payment. Finish it, or wait a little for it to expire, before adding more.', url);
      }
      throw siteExceptionFrom(error, generic: 'We could not order those bottles. Check your connection and try again.');
    } catch (error) {
      throw siteExceptionFrom(error, generic: 'We could not order those bottles. Check your connection and try again.');
    }
  }

  /// Where the payment of an extra order stands. The website asks Stripe itself if it has not heard yet, so this is safe to ask again and again.
  Future<AddonState> addonStatus(String sessionId) async {
    try {
      final data = await _call('confirm-bottle-addon', {'session_id': sessionId});
      return switch (data['status']) {
        'paid' => AddonState.paid,
        'not_found' => AddonState.notFound,
        _ => AddonState.pending,
      };
    } catch (error) {
      throw siteExceptionFrom(error, generic: 'We could not check your payment. Check your connection and try again.');
    }
  }

  /// Answers a replacement the club suggested. A replacement already answered is not an error the guest can fix: they are told so.
  Future<void> answerSubstitution({required String token, required bool approve}) async {
    try {
      final data = await _call('respond-bottle-substitution', {'token': token, 'action': approve ? 'approve' : 'decline'});
      if (data['error'] == 'already_responded') throw const SiteException('You already answered this one.');
      if (data['success'] != true) throw const FormatException('unexpected answer');
    } catch (error) {
      throw siteExceptionFrom(error, generic: 'We could not send your answer. Check your connection and try again.');
    }
  }

  /// Confirms a payment the club recorded for the bottles, or reports a problem with it ([reason] is needed then).
  Future<void> answerClubPayment({required String token, required bool confirm, String? reason}) async {
    try {
      final data = await _call('respond-club-payment', {'token': token, 'action': confirm ? 'confirm' : 'dispute', if (!confirm) 'reason': (reason ?? '').trim()});
      if (data['error'] == 'already_responded') throw const SiteException('You already answered this one.');
      if (data['success'] != true) throw const FormatException('unexpected answer');
    } catch (error) {
      throw siteExceptionFrom(error, generic: 'We could not send your answer. Check your connection and try again.');
    }
  }

  /// Asks the venue for a refund on a paid booking. Nothing is refunded by asking: the venue looks at the request against its own refund policy. Answers the sentence to show.
  Future<String> requestRefund({required String code, required String email, required String reason}) async {
    try {
      final data = await _db.rpc('guest_request_refund', params: {'p_code': code.trim(), 'p_email': email.trim(), 'p_reason': reason.trim()});
      return data is String && data.trim().isNotEmpty ? data : 'Your request has been sent to the venue.';
    } on PostgrestException catch (error) {
      // The database raises its own sentence for what the guest can fix ("you have already asked for a refund on this booking").
      final said = error.message.trim();
      if (error.code == 'P0001' && said.isNotEmpty && said.length <= 200) throw SiteException(said[0].toUpperCase() + said.substring(1) + (said.endsWith('.') ? '' : '.'));
      logProblem('request refund', error);
      throw const SiteException('Your request could not be sent just now. Try again in a moment.');
    } catch (error) {
      logProblem('request refund', error);
      throw const SiteException('Your request could not be sent just now. Try again in a moment.');
    }
  }
}
