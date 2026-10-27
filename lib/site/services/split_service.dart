import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/checkout.dart';
import '../models/split.dart';
import '../site_error.dart';

/// One friend and the amount they are asked for, to send to `split_create`.
class ShareAsk {
  const ShareAsk({required this.payer, required this.amountCents});

  final String payer;
  final int amountCents;
}

/// Splitting a table's bill, through the website's functions. The website decides who may split (only the person who booked), who may be asked, how much, and who may pay; this
/// service carries the asks and the answers, and turns a refusal into the sentence it came with.
class SplitService {
  SplitService(this._db);

  final SupabaseClient _db;

  Future<SplitPlan> create({required String bookingId, required List<ShareAsk> shares, required DateTime deadline}) async {
    final Object? answer;
    try {
      answer = await _db.rpc('split_create', params: {
        'p_booking': bookingId,
        'p_shares': [for (final s in shares) {'payer': s.payer, 'amount_cents': s.amountCents}],
        'p_deadline': deadline.toUtc().toIso8601String(),
      });
    } catch (error) {
      throw siteExceptionFromRpc(error, generic: 'The requests were not sent. Check your connection and try again.');
    }
    final plan = parseSplitPlan(answer);
    if (plan == null) throw const SiteException('We could not read the answer. The requests may not have been sent: look at your booking before trying again.');
    return plan;
  }

  /// The booking's split: the open one, otherwise the latest; null when it never had one.
  Future<SplitPlan?> forBooking(String bookingId) async {
    final Object? answer;
    try {
      answer = await _db.rpc('split_for_booking', params: {'p_booking': bookingId});
    } catch (error) {
      throw siteExceptionFromRpc(error, generic: loadFailedMessage('the split'));
    }
    if (answer == null) return null;
    final plan = parseSplitPlan(answer);
    if (plan == null) throw const SiteException('We could not read the split.');
    return plan;
  }

  /// Cancels the split; friends who paid are paid back by the website. Answers how many refunds went through and how many are left for later.
  Future<({SplitPlan plan, int refunded, int failed})> cancel(String splitId) async {
    try {
      final response = await _db.functions.invoke('cancel-split', body: {'split_id': splitId});
      final data = response.data;
      if (data is! Map) throw const FormatException('not an object');
      final plan = parseSplitPlan(data['split']);
      if (plan == null) throw const FormatException('no split in the answer');
      return (plan: plan, refunded: (data['refunded'] as num?)?.toInt() ?? 0, failed: (data['failed'] as num?)?.toInt() ?? 0);
    } catch (error) {
      throw siteExceptionFrom(error, generic: 'The split was not cancelled. Check your connection and try again.');
    }
  }

  /// The requests the signed-in person has been asked to pay, newest first.
  Future<List<ShareRequest>> myShares() async {
    try {
      return parseShareRequests(await _db.rpc('split_my_shares', params: const {}));
    } catch (error) {
      throw siteExceptionFromRpc(error, generic: loadFailedMessage('your requests to pay'));
    }
  }

  Future<void> decline(String shareId) async {
    try {
      await _db.rpc('split_share_decline', params: {'p_share': shareId});
    } catch (error) {
      throw siteExceptionFromRpc(error, generic: 'That did not go through. Check your connection and try again.');
    }
  }

  /// Starts paying a share: the payment page to open. The website checks the request is the person's, still open and still payable.
  Future<CheckoutStart> startPayment(String shareId) async {
    try {
      final response = await _db.functions.invoke('create-split-checkout', body: {'share_id': shareId});
      final data = response.data;
      final start = data is Map ? parseCheckoutStart({'url': data['url']}) : null;
      if (start == null) throw const FormatException('no payment page in the answer');
      return CheckoutStart(url: start.url, sessionId: data is Map && data['session_id'] is String ? data['session_id'] as String : start.sessionId);
    } catch (error) {
      throw siteExceptionFrom(error, generic: 'We could not open the payment page. Check your connection and try again.');
    }
  }

  /// Where the payment stands. The website asks Stripe itself if it has not heard yet, so this is safe to ask again and again.
  Future<SharePayment> paymentStatus(String shareId) async {
    try {
      final response = await _db.functions.invoke('confirm-split-share', body: {'share_id': shareId});
      final status = parseSharePayment(response.data);
      if (status == null) throw const FormatException('unexpected answer');
      return status;
    } catch (error) {
      throw siteExceptionFrom(error, generic: 'We could not check your payment. Check your connection and try again.');
    }
  }
}
