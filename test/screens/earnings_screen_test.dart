import 'package:bottles_up_user/site/providers/site_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../support/billing_fixtures.dart';
import '../support/fake_website.dart';
import '../support/pump_site.dart';
import '../support/pump_social.dart';

String textOf(WidgetTester tester, String key) => tester.widget<Text>(find.byKey(Key(key))).data!;

void main() {
  late FakeWebsite site;
  final all = {'social': true, 'marketplace': true, 'creator_earnings': true, 'referrals': true, 'subscriptions': true};
  final asDj = [selectedProfileIdProvider.overrideWith((ref) => 'biz')];

  String path(GoRouter r) => r.routerDelegate.currentConfiguration.last.matchedLocation;

  setUp(() {
    site = FakeWebsite();
    site.rpcs['rules_status'] = (_) => ok({'version': 1, 'accepted': true});
    site.rpcs['team_my_access'] = (_) => ok({'owner': true, 'permissions': <String>[]});
    site.rpcs['earnings_overview'] = (_) => ok(earningsRow());
  });

  Future<GoRouter> openIt(WidgetTester tester, {Map<String, bool>? features, List<Map<String, dynamic>>? mine, bool asBusiness = true}) async {
    final router = await openSocial(tester, site, '/me/earnings', features: features ?? all, mine: mine ?? [myPersonal(), myBusiness()], overrides: asBusiness ? asDj : const []);
    await settleCalls(tester);
    return router;
  }

  testWidgets('says it is not open yet when nothing that earns is switched on', (tester) async {
    await openIt(tester, features: {'social': true});
    expect(find.text('Earnings are not open yet.'), findsOneWidget);
    expect(site.forRpc('earnings_overview'), isEmpty);
  });

  testWidgets('opens with any one of hiring, tips or referrals on', (tester) async {
    for (final f in ['marketplace', 'creator_earnings', 'referrals']) {
      await openIt(tester, features: {'social': true, f: true});
      expect(find.byKey(const Key('earnings-summary')), findsOneWidget, reason: f);
      await tester.pumpWidget(const SizedBox());
      site.rpcs.remove('site_features');
    }
  });

  testWidgets('a role without money matters is told so, and nothing is asked', (tester) async {
    site.rpcs['team_my_access'] = (_) => ok({'owner': false, 'permissions': ['bookings']});
    await openIt(tester);
    expect(find.text('Not part of your role'), findsOneWidget);
    expect(site.forRpc('earnings_overview'), isEmpty);
  });

  testWidgets('a team member whose role has finance sees them', (tester) async {
    site.rpcs['team_my_access'] = (_) => ok({'owner': false, 'permissions': ['finance']});
    await openIt(tester);
    expect(find.byKey(const Key('earnings-summary')), findsOneWidget);
    expect(site.forRpc('earnings_overview').single.body, {'p_profile': 'biz'});
  });

  testWidgets('keeps ready, held and paid apart, and adds up what is ready to be paid and what was paid', (tester) async {
    await openIt(tester);
    expect(textOf(tester, 'earnings-ready'), '\$223.50');
    expect(textOf(tester, 'earnings-paid'), 'Paid to you so far: \$390.00');
    expect(textOf(tester, 'earnings-held'), 'BottlesUp is holding \$400.00 for jobs not finished yet.');
    expect(find.byKey(const Key('earnings-empty')), findsNothing);
    expect(find.text('Nothing on this page moves money.', findRichText: true), findsNothing);
    expect(textOf(tester, 'earnings-note'), 'BottlesUp pays what is ready by transfer and marks it as paid here. Nothing on this page moves money.');
  });

  testWidgets('shows each source on its own: jobs, tips and referrals', (tester) async {
    await openIt(tester);
    final jobs = find.byKey(const Key('earnings-jobs'));
    expect(find.descendant(of: jobs, matching: find.text('\$1,000.00')), findsOneWidget);
    expect(find.descendant(of: jobs, matching: find.text('\$400.00')), findsOneWidget);
    expect(find.descendant(of: jobs, matching: find.text('\$570.00')), findsOneWidget);
    expect(find.descendant(of: jobs, matching: find.text('\$200.00')), findsOneWidget);
    expect(find.descendant(of: jobs, matching: find.text('\$370.00')), findsOneWidget);
    final tips = find.byKey(const Key('earnings-tips'));
    expect(find.descendant(of: tips, matching: find.text('Tips (4)')), findsOneWidget);
    expect(find.descendant(of: tips, matching: find.text('\$30.00')), findsOneWidget);
    expect(find.descendant(of: tips, matching: find.text('\$28.50')), findsOneWidget);
    expect(find.descendant(of: tips, matching: find.text('\$18.50')), findsOneWidget);
    final refs = find.byKey(const Key('earnings-referrals'));
    expect(find.descendant(of: refs, matching: find.text('\$15.00')), findsOneWidget);
    expect(find.descendant(of: refs, matching: find.text('\$5.00')), findsOneWidget);
    expect(find.descendant(of: refs, matching: find.text('\$10.00')), findsOneWidget);
  });

  testWidgets('leaves out a source that is switched off, or that does not apply to the profile', (tester) async {
    await openIt(tester, features: {'social': true, 'creator_earnings': true});
    expect(find.byKey(const Key('earnings-jobs')), findsNothing);
    expect(find.byKey(const Key('earnings-tips')), findsOneWidget);
    expect(find.byKey(const Key('earnings-referrals')), findsNothing);
    expect(find.byKey(const Key('earnings-open-subscription')), findsNothing);
    await tester.pumpWidget(const SizedBox());
    site.rpcs.remove('site_features');
    site.rpcs['profile_my_profiles'] = (_) => ok([myPersonal()]);
    await openIt(tester, mine: [myPersonal()], asBusiness: false);
    expect(find.byKey(const Key('earnings-jobs')), findsNothing, reason: 'a person is not a professional');
    expect(find.byKey(const Key('earnings-tips')), findsNothing, reason: 'tips go to a business profile');
    expect(find.byKey(const Key('earnings-referrals')), findsOneWidget);
  });

  testWidgets('a profile with no money yet says so kindly', (tester) async {
    const zero = {'collected_cents': 0, 'held_cents': 0, 'earned_cents': 0, 'withdrawable_cents': 0, 'paid_cents': 0};
    site.rpcs['earnings_overview'] = (_) => ok(earningsRow(hiring: zero, tips: {...zero, 'count': 0}, referrals: zero));
    await openIt(tester);
    expect(textOf(tester, 'earnings-ready'), '\$0.00');
    expect(find.byKey(const Key('earnings-empty')), findsOneWidget);
    expect(find.byKey(const Key('earnings-held')), findsNothing);
  });

  testWidgets('the subscription row says what the plan is, or invites one', (tester) async {
    await openIt(tester);
    expect(find.text('Pay less commission on every booking.'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    site.rpcs['earnings_overview'] = (_) => ok(earningsRow(subscription: subscriptionRow(plan: 'monthly')));
    await openIt(tester);
    expect(find.textContaining('Monthly plan. It renews on'), findsOneWidget);
  });

  testWidgets('leads to the subscription and to referrals', (tester) async {
    site.rpcs['sub_plans'] = (_) => ok(plansRow());
    site.rpcs['sub_status'] = (_) => ok(null);
    site.rpcs['referral_code'] = (_) => ok({'code': 'ABCD1234'});
    site.rpcs['referral_stats'] = (_) => ok(statsRow());
    site.rpcs['referral_mine'] = (_) => ok(null);
    final router = await openIt(tester);
    await tester.ensureVisible(find.byKey(const Key('earnings-open-subscription')));
    await tester.tap(find.byKey(const Key('earnings-open-subscription')));
    await tester.pumpAndSettle();
    expect(path(router), '/me/subscription');
    router.pop();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('earnings-open-referrals')));
    await tester.tap(find.byKey(const Key('earnings-open-referrals')));
    await tester.pumpAndSettle();
    expect(path(router), '/me/referrals');
  });

  testWidgets('says why the figures cannot be read, and reads them again', (tester) async {
    var fail = true;
    site.rpcs['earnings_overview'] = (_) => fail ? raised('Your role on this profile does not allow this.') : ok(earningsRow());
    await openIt(tester);
    expect(find.text('Your role on this profile does not allow this.'), findsOneWidget);
    fail = false;
    await tester.tap(find.byKey(const Key('load-failed-retry')));
    await settleCalls(tester);
    expect(find.byKey(const Key('earnings-summary')), findsOneWidget);
  });
}
