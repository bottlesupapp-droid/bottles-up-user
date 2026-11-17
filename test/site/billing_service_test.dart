import 'package:bottles_up_user/site/models/billing.dart';
import 'package:bottles_up_user/site/services/billing_service.dart';
import 'package:bottles_up_user/site/site_error.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/billing_fixtures.dart';
import '../support/fake_website.dart';

void main() {
  late FakeWebsite site;
  late BillingService service;

  setUp(() {
    site = FakeWebsite();
    service = BillingService(site.client);
  });

  Matcher sentence(String s) => throwsA(isA<SiteException>().having((e) => e.message, 'message', s));
  Matcher generic() => throwsA(isA<SiteException>());

  group('subscriptions', () {
    test('the prices are read, an unreadable answer is an error and a refusal is its sentence', () async {
      site.rpcs['sub_plans'] = (_) => ok(plansRow());
      final p = await service.plans();
      expect([p.monthlyCents, p.yearlyCents], [2999, 29900]);
      expect(site.forRpc('sub_plans').single.body, <String, dynamic>{});
      site.rpcs['sub_plans'] = (_) => ok('nonsense');
      await expectLater(service.plans(), sentence('We could not read the prices.'));
      site.rpcs['sub_plans'] = (_) => raised('Subscriptions are not open yet.');
      await expectLater(service.plans(), sentence('Subscriptions are not open yet.'));
    });

    test('the status of a profile is asked for that profile, and no subscription is nothing', () async {
      site.rpcs['sub_status'] = (_) => ok(subscriptionRow(status: 'past_due'));
      final s = await service.status('p-dj');
      expect([s!.status, s.isLive], ['past_due', true]);
      expect(site.forRpc('sub_status').single.body, {'p_profile': 'p-dj'});
      site.rpcs['sub_status'] = (_) => ok(null);
      expect(await service.status('p-dj'), isNull);
      site.rpcs['sub_status'] = (_) => raised('Only the owner of a professional\'s own profile can manage its subscription.');
      await expectLater(service.status('p-dj'), sentence('Only the owner of a professional\'s own profile can manage its subscription.'));
    });

    test('subscribing asks for the page for that profile and plan, and answers where to pay', () async {
      site.functions['create-subscription-checkout'] = (_) => (status: 200, body: {'url': 'https://checkout.stripe.com/c/pay/cs_test_sub1#f', 'session_id': 'cs_test_sub1', 'amount_cents': 2999, 'plan': 'monthly'});
      final start = await service.subscribe(profile: 'p-dj', plan: SubPlan.monthly);
      expect(start.url.host, 'checkout.stripe.com');
      expect(start.sessionId, 'cs_test_sub1');
      expect(site.forFunction('create-subscription-checkout').single.body, {'profile_id': 'p-dj', 'plan': 'monthly'});
      await service.subscribe(profile: 'p-dj', plan: SubPlan.yearly);
      expect(site.forFunction('create-subscription-checkout').last.body['plan'], 'yearly');
    });

    test('a refusal to subscribe is its sentence, and a page that is not a secure address is an error', () async {
      site.functions['create-subscription-checkout'] = (_) => (status: 409, body: {'error': 'This profile already has a subscription.'});
      await expectLater(service.subscribe(profile: 'p', plan: SubPlan.monthly), sentence('This profile already has a subscription.'));
      site.functions['create-subscription-checkout'] = (_) => (status: 200, body: {'url': 'http://checkout.stripe.com/x'});
      await expectLater(service.subscribe(profile: 'p', plan: SubPlan.monthly), sentence('We could not open the payment page. Check your connection and try again.'));
      site.functions['create-subscription-checkout'] = (_) => (status: 200, body: {'session_id': 'cs_test_1'});
      await expectLater(service.subscribe(profile: 'p', plan: SubPlan.monthly), generic());
      site.functions['create-subscription-checkout'] = (_) => (status: 500, body: {'error': 'Internal server error'});
      await expectLater(service.subscribe(profile: 'p', plan: SubPlan.monthly), sentence('We could not open the payment page. Check your connection and try again.'));
    });

    test('the page to manage a subscription is asked for the profile', () async {
      site.functions['create-billing-portal'] = (_) => (status: 200, body: {'url': 'https://billing.stripe.com/p/session/abc'});
      final url = await service.managePage('p-dj');
      expect(url.host, 'billing.stripe.com');
      expect(site.forFunction('create-billing-portal').single.body, {'profile_id': 'p-dj'});
      site.functions['create-billing-portal'] = (_) => (status: 409, body: {'error': 'This profile has no subscription to manage.'});
      await expectLater(service.managePage('p-dj'), sentence('This profile has no subscription to manage.'));
      site.functions['create-billing-portal'] = (_) => (status: 200, body: {'url': 'nope'});
      await expectLater(service.managePage('p-dj'), sentence('We could not open the page to manage your subscription. Check your connection and try again.'));
    });
  });

  group('referrals', () {
    test('the code of a profile is asked for that profile', () async {
      site.rpcs['referral_code'] = (_) => ok({'code': 'ABCD1234'});
      expect(await service.referralCode('p-ann'), 'ABCD1234');
      expect(site.forRpc('referral_code').single.body, {'p_profile': 'p-ann'});
      site.rpcs['referral_code'] = (_) => ok({'code': ''});
      await expectLater(service.referralCode('p-ann'), sentence('We could not read the code.'));
      site.rpcs['referral_code'] = (_) => raised('Referrals are not open yet.');
      await expectLater(service.referralCode('p-ann'), sentence('Referrals are not open yet.'));
    });

    test('who sent the person is asked for, and no code used is nothing', () async {
      site.rpcs['referral_mine'] = (_) => ok({'referrer': profileRow(id: 'p-ann', handle: 'ann', name: 'Ann'), 'claimed_at': '2026-11-02T10:00:00Z'});
      expect((await service.myReferral())!.referrer!.handle, 'ann');
      expect(site.forRpc('referral_mine').single.body, <String, dynamic>{});
      site.rpcs['referral_mine'] = (_) => ok(null);
      expect(await service.myReferral(), isNull);
    });

    test('a code is sent tidied, and the referrer is answered', () async {
      site.rpcs['referral_claim'] = (_) => ok({'claimed': true, 'referrer': profileRow(id: 'p-ann', handle: 'ann', name: 'Ann')});
      final r = await service.claim(' abcd-1234 ');
      expect(r!.handle, 'ann');
      expect(site.forRpc('referral_claim').single.body, {'p_code': 'ABCD1234'});
      site.rpcs['referral_claim'] = (_) => ok({'claimed': true});
      expect(await service.claim('ABCD1234'), isNull);
      site.rpcs['referral_claim'] = (_) => raised('You have already used a code.');
      await expectLater(service.claim('ABCD1234'), sentence('You have already used a code.'));
    });

    test('the numbers of a code are asked for that profile', () async {
      site.rpcs['referral_stats'] = (_) => ok(statsRow());
      final s = await service.referralStats('p-ann');
      expect([s.referred, s.payableCents], [3, 500]);
      expect(site.forRpc('referral_stats').single.body, {'p_profile': 'p-ann'});
      site.rpcs['referral_stats'] = (_) => ok(<String, Object>{});
      await expectLater(service.referralStats('p-ann'), sentence('We could not read the numbers.'));
    });
  });

  group('tips', () {
    test('a tip asks for a page for that profile and amount, with the words trimmed, and answers the tip', () async {
      site.functions['create-tip-checkout'] = (_) => (status: 200, body: {'url': 'https://checkout.stripe.com/c/pay/cs_test_tip1#f', 'session_id': 'cs_test_tip1', 'tip_id': 'tip1', 'amount_cents': 1000});
      final start = await service.startTip(creator: 'p-dj', cents: 1000, message: '  Great set  ');
      expect([start.tipId, start.url.host], ['tip1', 'checkout.stripe.com']);
      expect(site.forFunction('create-tip-checkout').single.body, {'creator_id': 'p-dj', 'amount_cents': 1000, 'message': 'Great set'});
    });

    test('no words are sent when there are none', () async {
      site.functions['create-tip-checkout'] = (_) => (status: 200, body: {'url': 'https://checkout.stripe.com/c/pay/cs_test_tip1#f', 'tip_id': 'tip1'});
      await service.startTip(creator: 'p-dj', cents: 500);
      await service.startTip(creator: 'p-dj', cents: 500, message: '   ');
      for (final r in site.forFunction('create-tip-checkout')) {
        expect(r.body, {'creator_id': 'p-dj', 'amount_cents': 500});
      }
    });

    test('a refused tip is its sentence, and an answer without a page or a tip is an error', () async {
      site.functions['create-tip-checkout'] = (_) => (status: 409, body: {'error': 'A tip is from 2.00 to 500.00.'});
      await expectLater(service.startTip(creator: 'p', cents: 5), sentence('A tip is from 2.00 to 500.00.'));
      site.functions['create-tip-checkout'] = (_) => (status: 200, body: {'url': 'https://checkout.stripe.com/c/pay/cs_test_tip1#f'});
      await expectLater(service.startTip(creator: 'p', cents: 500), sentence('We could not open the payment page. Check your connection and try again.'));
      site.functions['create-tip-checkout'] = (_) => (status: 200, body: {'url': 'https://checkout.stripe.com/c/pay/cs_test_tip1#f', 'tip_id': ''});
      await expectLater(service.startTip(creator: 'p', cents: 500), generic());
      site.functions['create-tip-checkout'] = (_) => (status: 200, body: {'tip_id': 'tip1'});
      await expectLater(service.startTip(creator: 'p', cents: 500), generic());
    });

    test('the state of a tip is asked for that tip', () async {
      site.rpcs['tip_status'] = (_) => ok(tipRow(status: 'paid'));
      expect((await service.tipState('tip1'))!.isPaid, isTrue);
      expect(site.forRpc('tip_status').single.body, {'p_tip': 'tip1'});
      site.rpcs['tip_status'] = (_) => ok(null);
      expect(await service.tipState('tip1'), isNull);
    });
  });

  group('earnings', () {
    test('are asked for the profile and read', () async {
      site.rpcs['earnings_overview'] = (_) => ok(earningsRow());
      final e = await service.earnings('p-dj');
      expect(e.hiring.heldCents, 40000);
      expect(site.forRpc('earnings_overview').single.body, {'p_profile': 'p-dj'});
      site.rpcs['earnings_overview'] = (_) => ok('nonsense');
      await expectLater(service.earnings('p-dj'), sentence('We could not read your earnings.'));
      site.rpcs['earnings_overview'] = (_) => raised('Your role on this profile does not allow this.');
      await expectLater(service.earnings('p-dj'), sentence('Your role on this profile does not allow this.'));
    });
  });
}
