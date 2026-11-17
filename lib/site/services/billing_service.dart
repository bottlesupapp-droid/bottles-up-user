import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/billing.dart';
import '../models/checkout.dart';
import '../models/social_profile.dart';
import '../rules/billing_rules.dart';
import '../site_error.dart';

String? _blank(String? s) => s == null || s.trim().isEmpty ? null : s.trim();

/// Subscriptions, referral codes, tips and the earnings overview, through the website's functions. Money is never worked out here: the website says what is due and what is paid, and a
/// payment is called paid only when it says so.
class BillingService {
  BillingService(this._db);

  final SupabaseClient _db;

  Future<T> _rpc<T>(String name, Map<String, dynamic> params, T Function(Object? answer) read, String generic) async {
    final Object? answer;
    try {
      answer = await _db.rpc(name, params: params);
    } catch (error) {
      throw siteExceptionFromRpc(error, generic: generic);
    }
    return read(answer);
  }

  Future<Map> _function(String name, Map<String, dynamic> body, String generic) async {
    try {
      final response = await _db.functions.invoke(name, body: body);
      final data = response.data;
      if (data is! Map) throw const FormatException('not an object');
      return data;
    } catch (error) {
      throw siteExceptionFrom(error, generic: generic);
    }
  }

  // ---- subscriptions
  Future<BillingPlans> plans() => _rpc('sub_plans', const {}, (a) => parseBillingPlans(a) ?? (throw const SiteException('We could not read the prices.')), loadFailedMessage('the prices'));

  /// The subscription of a profile the caller owns: the live one, or the latest; null when it never had one.
  Future<Subscription?> status(String profile) => _rpc('sub_status', {'p_profile': profile}, parseSubscription, loadFailedMessage('the subscription'));

  /// Starts a subscription: the payment page to open. Nothing is live until the website hears from Stripe.
  Future<CheckoutStart> subscribe({required String profile, required SubPlan plan}) async {
    final data = await _function('create-subscription-checkout', {'profile_id': profile, 'plan': plan.wire}, 'We could not open the payment page. Check your connection and try again.');
    return _checkout(data);
  }

  /// Stripe's own page to change the card or cancel.
  Future<Uri> managePage(String profile) async {
    final data = await _function('create-billing-portal', {'profile_id': profile}, 'We could not open the page to manage your subscription. Check your connection and try again.');
    final url = parseCheckoutStart({'url': data['url']})?.url;
    if (url == null) throw const SiteException('We could not open the page to manage your subscription. Check your connection and try again.');
    return url;
  }

  CheckoutStart _checkout(Map data) {
    final start = parseCheckoutStart({'url': data['url'], 'session_id': data['session_id']});
    if (start == null) throw const SiteException('We could not open the payment page. Check your connection and try again.');
    return start;
  }

  // ---- referrals
  /// The caller's code for a profile they act as (made the first time).
  Future<String> referralCode(String profile) => _rpc('referral_code', {'p_profile': profile}, (a) => parseReferralCode(a) ?? (throw const SiteException('We could not read the code.')), loadFailedMessage('your code'));

  /// Who sent the caller, or null if they never used a code.
  Future<ReferralClaim?> myReferral() => _rpc('referral_mine', const {}, parseReferralClaim, loadFailedMessage('your referral'));

  /// Uses a code. The website says who it belongs to.
  Future<SocialProfile?> claim(String code) => _rpc(
        'referral_claim',
        {'p_code': normalizeReferralCode(code)},
        (a) => a is Map ? parseSocialProfile(a['referrer']) : null,
        'The code was not used. Check your connection and try again.',
      );

  Future<ReferralStats> referralStats(String profile) => _rpc('referral_stats', {'p_profile': profile}, (a) => parseReferralStats(a) ?? (throw const SiteException('We could not read the numbers.')), loadFailedMessage('your referrals'));

  // ---- tips
  /// Starts a tip: the payment page to open and the tip to ask about afterwards.
  Future<TipStart> startTip({required String creator, required int cents, String? message}) async {
    final data = await _function(
      'create-tip-checkout',
      {'creator_id': creator, 'amount_cents': cents, if (_blank(message) != null) 'message': message!.trim()},
      'We could not open the payment page. Check your connection and try again.',
    );
    final start = _checkout(data);
    final id = data['tip_id'];
    if (id is! String || id.isEmpty) throw const SiteException('We could not open the payment page. Check your connection and try again.');
    return TipStart(url: start.url, tipId: id);
  }

  /// Where a tip stands. Paid only when the website says so.
  Future<TipState?> tipState(String tip) => _rpc('tip_status', {'p_tip': tip}, parseTipState, loadFailedMessage('your tip'));

  // ---- earnings
  Future<Earnings> earnings(String profile) => _rpc('earnings_overview', {'p_profile': profile}, (a) => parseEarnings(a) ?? (throw const SiteException('We could not read your earnings.')), loadFailedMessage('your earnings'));
}
