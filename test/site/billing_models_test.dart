import 'package:bottles_up_user/site/models/billing.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/billing_fixtures.dart';
import '../support/fake_website.dart';

void main() {
  group('plans', () {
    test('a plan is read, and the plans know their prices, saving and effect', () {
      final p = parseBillingPlans(plansRow())!;
      expect([p.currency, p.monthlyCents, p.yearlyCents, p.subscribedBps, p.standardBps], ['cad', 2999, 29900, 0, 500]);
      expect([p.priceCents(SubPlan.monthly), p.priceCents(SubPlan.yearly)], [2999, 29900]);
      expect(p.yearlySavingCents, 2999 * 12 - 29900);
      expect(p.lowersCommission, isTrue);
    });

    test('there is no saving when the yearly plan is not cheaper, and no effect when the commission is the same', () {
      expect(parseBillingPlans(plansRow(monthly: 1000, yearly: 12000))!.yearlySavingCents, 0);
      expect(parseBillingPlans(plansRow(monthly: 1000, yearly: 12001))!.yearlySavingCents, 0);
      expect(parseBillingPlans(plansRow(monthly: 1000, yearly: 11999))!.yearlySavingCents, 1);
      expect(parseBillingPlans(plansRow(subscribedBps: 500))!.lowersCommission, isFalse);
      expect(parseBillingPlans(plansRow(subscribedBps: 499))!.lowersCommission, isTrue);
    });

    test('an unreadable plan is nothing, a missing currency is the website\'s', () {
      expect(parseBillingPlans(null), isNull);
      expect(parseBillingPlans('x'), isNull);
      for (final key in ['monthly_cents', 'yearly_cents', 'subscribed_commission_bps', 'standard_commission_bps']) {
        expect(parseBillingPlans(plansRow()..remove(key)), isNull, reason: key);
      }
      expect(parseBillingPlans(plansRow(monthly: 0)), isNull);
      expect(parseBillingPlans(plansRow(yearly: 0)), isNull);
      expect(parseBillingPlans(plansRow(subscribedBps: -1)), isNull);
      expect(parseBillingPlans(plansRow(standardBps: -1)), isNull);
      expect(parseBillingPlans(plansRow(subscribedBps: 0, standardBps: 0))!.lowersCommission, isFalse);
      expect(parseBillingPlans(plansRow()..['currency'] = '')!.currency, 'cad');
    });

    test('a plan is found by the word the website uses', () {
      expect(SubPlan.fromWire('monthly'), SubPlan.monthly);
      expect(SubPlan.fromWire('yearly'), SubPlan.yearly);
      expect(SubPlan.fromWire('weekly'), isNull);
      expect(SubPlan.fromWire(null), isNull);
      expect([SubPlan.monthly.label, SubPlan.yearly.label], ['Monthly', 'Yearly']);
    });
  });

  group('a subscription', () {
    test('is read with its plan, status, end and whether it will renew', () {
      final s = parseSubscription(subscriptionRow(cancelAtEnd: true))!;
      expect([s.id, s.profile, s.plan, s.status, s.cancelAtPeriodEnd], ['sub1', 'p-dj', SubPlan.yearly, 'active', true]);
      expect(s.currentPeriodEnd!.toUtc(), DateTime.utc(2027, 3, 5, 12));
      expect(parseSubscription(subscriptionRow())!.cancelAtPeriodEnd, isFalse);
      expect(parseSubscription(subscriptionRow(end: null))!.currentPeriodEnd, isNull);
      expect(parseSubscription(subscriptionRow(end: 'soon'))!.currentPeriodEnd, isNull);
    });

    test('is live while active or late, never once cancelled or not paid yet', () {
      bool live(String status) => parseSubscription(subscriptionRow(status: status))!.isLive;
      expect([live('active'), live('past_due'), live('cancelled'), live('incomplete')], [true, true, false, false]);
      expect(parseSubscription(subscriptionRow(status: 'past_due'))!.isPastDue, isTrue);
      expect(parseSubscription(subscriptionRow(status: 'active'))!.isPastDue, isFalse);
      expect(parseSubscription(subscriptionRow(status: 'cancelled'))!.isCancelled, isTrue);
      expect(parseSubscription(subscriptionRow(status: 'active'))!.isCancelled, isFalse);
    });

    test('that cannot be read is nothing', () {
      expect(parseSubscription(null), isNull);
      expect(parseSubscription('x'), isNull);
      for (final key in ['id', 'profile', 'plan', 'status']) {
        expect(parseSubscription(subscriptionRow()..remove(key)), isNull, reason: key);
      }
      expect(parseSubscription(subscriptionRow(plan: 'weekly')), isNull);
    });
  });

  group('referrals', () {
    test('a code is read, and nothing else is a code', () {
      expect(parseReferralCode({'code': 'ABCD1234'}), 'ABCD1234');
      expect(parseReferralCode({'code': '  '}), isNull);
      expect(parseReferralCode({'nope': 1}), isNull);
      expect(parseReferralCode('ABCD1234'), isNull);
      expect(parseReferralCode(null), isNull);
    });

    test('who sent the person is read, and no answer means no code was used', () {
      final c = parseReferralClaim({'referrer': profileRow(id: 'p-ann', handle: 'ann', name: 'Ann'), 'claimed_at': '2026-11-02T10:00:00Z'})!;
      expect([c.referrer!.id, c.claimedAt!.toUtc()], ['p-ann', DateTime.utc(2026, 11, 2, 10)]);
      expect(parseReferralClaim({'referrer': null, 'claimed_at': null})!.referrer, isNull);
      expect(parseReferralClaim({'referrer': null, 'claimed_at': 'x'})!.claimedAt, isNull);
      expect(parseReferralClaim(null), isNull);
    });

    test('the numbers of a code are read, and a missing one makes them unreadable', () {
      final s = parseReferralStats(statsRow())!;
      expect([s.referred, s.credited, s.payableCents, s.paidCents, s.creditCents], [3, 2, 500, 1000, 500]);
      for (final key in ['referred', 'credited', 'payable_cents', 'paid_cents', 'credit_cents']) {
        expect(parseReferralStats(statsRow()..remove(key)), isNull, reason: key);
      }
      expect(parseReferralStats(null), isNull);
    });
  });

  group('earnings', () {
    test('are kept apart by where they came from', () {
      final e = parseEarnings(earningsRow(subscription: subscriptionRow()))!;
      expect([e.hiring.collectedCents, e.hiring.heldCents, e.hiring.earnedCents, e.hiring.withdrawableCents, e.hiring.paidCents, e.hiring.commissionCents], [100000, 40000, 57000, 20000, 37000, 3000]);
      expect([e.tips.collectedCents, e.tips.earnedCents, e.tips.withdrawableCents, e.tips.paidCents, e.tips.count], [3000, 2850, 1850, 1000, 4]);
      expect([e.referrals.earnedCents, e.referrals.withdrawableCents, e.referrals.paidCents, e.referrals.count], [1500, 500, 1000, null]);
      expect(e.subscription!.plan, SubPlan.yearly);
      expect([e.withdrawableCents, e.paidCents, e.heldCents], [20000 + 1850 + 500, 37000 + 1000 + 1000, 40000]);
      expect(e.isEmpty, isFalse);
    });

    test('are empty when nothing has come in, whatever else is said', () {
      final zero = {'collected_cents': 0, 'held_cents': 0, 'earned_cents': 0, 'withdrawable_cents': 0, 'paid_cents': 0};
      final e = parseEarnings(earningsRow(hiring: zero, tips: {...zero, 'count': 0}, referrals: zero))!;
      expect(e.isEmpty, isTrue);
      expect(e.subscription, isNull);
      expect(e.tips.count, 0);
      for (final one in ['collected_cents', 'held_cents', 'earned_cents', 'withdrawable_cents', 'paid_cents']) {
        expect(EarningsPart(collectedCents: one == 'collected_cents' ? 1 : 0, heldCents: one == 'held_cents' ? 1 : 0, earnedCents: one == 'earned_cents' ? 1 : 0, withdrawableCents: one == 'withdrawable_cents' ? 1 : 0, paidCents: one == 'paid_cents' ? 1 : 0).isEmpty, isFalse, reason: one);
      }
      expect(const EarningsPart(commissionCents: 5).isEmpty, isTrue);
    });

    test('are not empty when any one source has something, and empty only when all three have nothing', () {
      const none = EarningsPart();
      const some = EarningsPart(paidCents: 1);
      expect(const Earnings(hiring: none, tips: none, referrals: none).isEmpty, isTrue);
      expect(const Earnings(hiring: some, tips: none, referrals: none).isEmpty, isFalse);
      expect(const Earnings(hiring: none, tips: some, referrals: none).isEmpty, isFalse);
      expect(const Earnings(hiring: none, tips: none, referrals: some).isEmpty, isFalse);
      expect(const Earnings(hiring: none, tips: some, referrals: some).isEmpty, isFalse);
      expect(const Earnings(hiring: some, tips: none, referrals: some).isEmpty, isFalse);
      expect(const Earnings(hiring: some, tips: some, referrals: none).isEmpty, isFalse);
    });

    test('a missing or negative figure is nothing, and a missing section makes them unreadable', () {
      final e = parseEarnings(earningsRow(hiring: {'collected_cents': -5, 'held_cents': 'x'}))!;
      expect([e.hiring.collectedCents, e.hiring.heldCents, e.hiring.earnedCents], [0, 0, 0]);
      for (final key in ['hiring', 'tips', 'referrals']) {
        expect(parseEarnings(earningsRow()..remove(key)), isNull, reason: key);
      }
      expect(parseEarnings(earningsRow()..['tips'] = 'x'), isNull);
      expect(parseEarnings(null), isNull);
    });
  });

  group('a tip', () {
    test('is read with its state and who it is for', () {
      final t = parseTipState(tipRow())!;
      expect([t.id, t.status, t.amountCents, t.currency, t.creator!.handle], ['tip1', 'created', 1000, 'cad', 'djdee']);
      expect([t.isPaid, t.isVoid], [false, false]);
      expect(parseTipState(tipRow(status: 'paid'))!.isPaid, isTrue);
      expect(parseTipState(tipRow(status: 'void'))!.isVoid, isTrue);
      expect(parseTipState(tipRow(status: 'paid'))!.isVoid, isFalse);
      expect(parseTipState(tipRow()..['currency'] = null)!.currency, 'cad');
    });

    test('that cannot be read is nothing', () {
      expect(parseTipState(null), isNull);
      expect(parseTipState('x'), isNull);
      for (final key in ['id', 'status', 'amount_cents']) {
        expect(parseTipState(tipRow()..remove(key)), isNull, reason: key);
      }
      expect(parseTipState(tipRow(amount: 0)), isNull);
      expect(parseTipState(tipRow(amount: 1))!.amountCents, 1);
      expect(parseTipState(tipRow()..['creator'] = null)!.creator, isNull);
    });
  });
}
