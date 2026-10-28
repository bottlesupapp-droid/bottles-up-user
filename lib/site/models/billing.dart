import '../read.dart';
import 'social_profile.dart';

/// How a professional pays for the subscription.
enum SubPlan {
  monthly('monthly', 'Monthly'),
  yearly('yearly', 'Yearly');

  const SubPlan(this.wire, this.label);

  final String wire;
  final String label;

  static SubPlan? fromWire(Object? v) {
    for (final p in values) {
      if (p.wire == v) return p;
    }
    return null;
  }
}

/// What a subscription costs and changes (`sub_plans`). Money is whole cents; the commission is in basis points (500 is 5%).
class BillingPlans {
  const BillingPlans({required this.currency, required this.monthlyCents, required this.yearlyCents, required this.subscribedBps, required this.standardBps});

  final String currency;
  final int monthlyCents;
  final int yearlyCents;
  final int subscribedBps;
  final int standardBps;

  int priceCents(SubPlan plan) => plan == SubPlan.monthly ? monthlyCents : yearlyCents;

  /// What twelve months on the monthly plan cost over the yearly price; 0 when the yearly plan is not cheaper.
  int get yearlySavingCents => monthlyCents * 12 > yearlyCents ? monthlyCents * 12 - yearlyCents : 0;

  /// Whether a subscription lowers the commission at all.
  bool get lowersCommission => subscribedBps < standardBps;
}

BillingPlans? parseBillingPlans(Object? json) {
  if (json is! Map) return null;
  final monthly = readInt(json['monthly_cents']);
  final yearly = readInt(json['yearly_cents']);
  final subscribed = readInt(json['subscribed_commission_bps']);
  final standard = readInt(json['standard_commission_bps']);
  if (monthly == null || yearly == null || subscribed == null || standard == null || monthly <= 0 || yearly <= 0 || subscribed < 0 || standard < 0) return null;
  return BillingPlans(currency: readText(json['currency']) ?? 'cad', monthlyCents: monthly, yearlyCents: yearly, subscribedBps: subscribed, standardBps: standard);
}

/// One subscription of a professional profile (`sub_status`).
class Subscription {
  const Subscription({required this.id, required this.profile, required this.plan, required this.status, this.currentPeriodEnd, this.cancelAtPeriodEnd = false});

  final String id;
  final String profile;
  final SubPlan plan;

  /// `active`, `past_due`, `cancelled` (or `incomplete`, which the website does not show).
  final String status;
  final DateTime? currentPeriodEnd;
  final bool cancelAtPeriodEnd;

  /// The lower commission applies only while it is paid for: active, or late but not yet given up on.
  bool get isLive => status == 'active' || status == 'past_due';
  bool get isPastDue => status == 'past_due';
  bool get isCancelled => status == 'cancelled';
}

Subscription? parseSubscription(Object? json) {
  if (json is! Map) return null;
  final id = readText(json['id']);
  final profile = readText(json['profile']);
  final plan = SubPlan.fromWire(json['plan']);
  final status = readText(json['status']);
  if (id == null || profile == null || plan == null || status == null) return null;
  final end = json['current_period_end'];
  return Subscription(
    id: id,
    profile: profile,
    plan: plan,
    status: status,
    currentPeriodEnd: end is String ? DateTime.tryParse(end)?.toLocal() : null,
    cancelAtPeriodEnd: json['cancel_at_period_end'] == true,
  );
}

/// The person who sent the caller, if the caller used a code (`referral_mine`).
class ReferralClaim {
  const ReferralClaim({required this.referrer, this.claimedAt});

  final SocialProfile? referrer;
  final DateTime? claimedAt;
}

ReferralClaim? parseReferralClaim(Object? json) {
  if (json is! Map) return null;
  final at = json['claimed_at'];
  return ReferralClaim(referrer: parseSocialProfile(json['referrer']), claimedAt: at is String ? DateTime.tryParse(at)?.toLocal() : null);
}

/// How a profile's referral code is doing (`referral_stats`).
class ReferralStats {
  const ReferralStats({required this.referred, required this.credited, required this.payableCents, required this.paidCents, required this.creditCents});

  final int referred;
  final int credited;
  final int payableCents;
  final int paidCents;

  /// What one credit is worth now.
  final int creditCents;
}

ReferralStats? parseReferralStats(Object? json) {
  if (json is! Map) return null;
  final referred = readInt(json['referred']);
  final credited = readInt(json['credited']);
  final payable = readInt(json['payable_cents']);
  final paid = readInt(json['paid_cents']);
  final credit = readInt(json['credit_cents']);
  if (referred == null || credited == null || payable == null || paid == null || credit == null) return null;
  return ReferralStats(referred: referred, credited: credited, payableCents: payable, paidCents: paid, creditCents: credit);
}

/// The code for a profile (`referral_code`): eight capitals and digits.
String? parseReferralCode(Object? json) => json is Map ? readText(json['code']) : null;

/// Money from one source, kept apart: what came in, what BottlesUp still holds, what is earned, what can be withdrawn and what has been paid out.
class EarningsPart {
  const EarningsPart({this.collectedCents = 0, this.heldCents = 0, this.earnedCents = 0, this.withdrawableCents = 0, this.paidCents = 0, this.commissionCents = 0, this.count});

  final int collectedCents;
  final int heldCents;
  final int earnedCents;
  final int withdrawableCents;
  final int paidCents;
  final int commissionCents;

  /// Only for tips: how many.
  final int? count;

  bool get isEmpty => collectedCents == 0 && heldCents == 0 && earnedCents == 0 && withdrawableCents == 0 && paidCents == 0;
}

class Earnings {
  const Earnings({required this.hiring, required this.tips, required this.referrals, this.subscription});

  final EarningsPart hiring;
  final EarningsPart tips;
  final EarningsPart referrals;
  final Subscription? subscription;

  int get withdrawableCents => hiring.withdrawableCents + tips.withdrawableCents + referrals.withdrawableCents;
  int get paidCents => hiring.paidCents + tips.paidCents + referrals.paidCents;
  int get heldCents => hiring.heldCents;
  bool get isEmpty => hiring.isEmpty && tips.isEmpty && referrals.isEmpty;
}

EarningsPart _part(Object? json) {
  if (json is! Map) return const EarningsPart();
  int n(String key) {
    final v = readInt(json[key]);
    return v == null || v < 0 ? 0 : v;
  }

  return EarningsPart(
    collectedCents: n('collected_cents'),
    heldCents: n('held_cents'),
    earnedCents: n('earned_cents'),
    withdrawableCents: n('withdrawable_cents'),
    paidCents: n('paid_cents'),
    commissionCents: n('commission_cents'),
    count: json.containsKey('count') ? n('count') : null,
  );
}

Earnings? parseEarnings(Object? json) {
  if (json is! Map) return null;
  if (json['hiring'] is! Map || json['tips'] is! Map || json['referrals'] is! Map) return null;
  return Earnings(hiring: _part(json['hiring']), tips: _part(json['tips']), referrals: _part(json['referrals']), subscription: parseSubscription(json['subscription']));
}

/// How a tip stands (`tip_status`).
class TipState {
  const TipState({required this.id, required this.status, required this.amountCents, required this.currency, this.creator});

  final String id;

  /// `created` (Stripe has not said yet), `paid` or `void`.
  final String status;
  final int amountCents;
  final String currency;
  final SocialProfile? creator;

  bool get isPaid => status == 'paid';
  bool get isVoid => status == 'void';
}

TipState? parseTipState(Object? json) {
  if (json is! Map) return null;
  final id = readText(json['id']);
  final status = readText(json['status']);
  final amount = readInt(json['amount_cents']);
  if (id == null || status == null || amount == null || amount <= 0) return null;
  return TipState(id: id, status: status, amountCents: amount, currency: readText(json['currency']) ?? 'cad', creator: parseSocialProfile(json['creator']));
}

/// What the website gave back for a tip's payment page.
class TipStart {
  const TipStart({required this.url, required this.tipId});

  final Uri url;
  final String tipId;
}
