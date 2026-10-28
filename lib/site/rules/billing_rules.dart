import '../models/billing.dart';
import '../money.dart';
import '../when.dart';

/// The limits the website enforces on a tip (`tip_begin`). The smallest and the largest tip are set in the CMS and the app is not told them, so it only checks what can never be
/// right; the website's own sentence ("A tip is from 2.00 to 500.00.") is what the person reads for anything else.
const int maxTipMessageLength = 200;
const int maxTipCents = 1000000;

/// The amounts offered as buttons.
const List<int> tipChoices = [500, 1000, 2000, 5000];

/// The sentence for what is wrong with a tip, or null when it can be sent.
String? checkTip({required int? cents, String? message}) {
  if (cents == null || cents <= 0) return 'Choose an amount.';
  if (cents > maxTipCents) return 'The most a tip can be is ${formatMoney(maxTipCents)}.';
  if ((message?.trim().length ?? 0) > maxTipMessageLength) return 'Keep the message to $maxTipMessageLength characters.';
  return null;
}

/// A referral code is eight capitals and digits.
const int referralCodeLength = 8;

final RegExp _codeShape = RegExp(r'^[A-Z0-9]{8}$');

/// What a person typed as a code, tidied the way the website reads it: spaces and dashes out, capitals.
String normalizeReferralCode(String text) => text.replaceAll(RegExp(r'[\s-]'), '').toUpperCase();

/// The sentence for a code that cannot be right, or null.
String? checkReferralCode(String text) => _codeShape.hasMatch(normalizeReferralCode(text)) ? null : 'A code has $referralCodeLength letters and numbers.';

/// "5%", "2.5%", "12.34%" for a commission held in basis points (hundredths of a percent).
String percentText(int bps) {
  final whole = bps ~/ 100;
  final rest = bps % 100;
  if (rest == 0) return '$whole%';
  final fraction = rest.toString().padLeft(2, '0').replaceFirst(RegExp(r'0$'), '');
  return '$whole.$fraction%';
}

/// What to tell the owner about when their subscription renews or ends.
String subscriptionLine(Subscription s) {
  final end = s.currentPeriodEnd;
  final day = end == null ? null : formatDay(end);
  if (s.isCancelled) return day == null ? 'This subscription has ended.' : 'This subscription ended on $day.';
  if (s.isPastDue) return 'The last payment did not go through. Update your card to keep the lower commission.';
  if (s.cancelAtPeriodEnd) return day == null ? 'It will end at the end of this period.' : 'It will not renew: it ends on $day.';
  return day == null ? 'It renews by itself.' : 'It renews on $day.';
}

/// The price in words: "$29.99 a month".
String planPriceText(BillingPlans plans, SubPlan plan) => '${formatMoney(plans.priceCents(plan), currency: plans.currency)} ${plan == SubPlan.monthly ? 'a month' : 'a year'}';
