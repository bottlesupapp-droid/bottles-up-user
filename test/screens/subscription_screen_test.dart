import 'package:bottles_up_user/features/billing/screens/subscription_screen.dart';
import 'package:bottles_up_user/site/providers/site_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/billing_fixtures.dart';
import '../support/fake_website.dart';
import '../support/pump_site.dart';
import '../support/pump_social.dart';

String textOf(WidgetTester tester, String key) => tester.widget<Text>(find.byKey(Key(key))).data!;

const payUrl = 'https://checkout.stripe.com/c/pay/cs_test_sub1#frag';
const portalUrl = 'https://billing.stripe.com/p/session/abc';

void main() {
  late FakeWebsite site;
  late List<Uri> opened;
  final on = {'social': true, 'subscriptions': true};
  final asDj = [selectedProfileIdProvider.overrideWith((ref) => 'biz')];

  setUp(() {
    site = FakeWebsite();
    opened = [];
    site.rpcs['rules_status'] = (_) => ok({'version': 1, 'accepted': true});
    site.rpcs['sub_plans'] = (_) => ok(plansRow());
    site.rpcs['sub_status'] = (_) => ok(null);
    site.rpcs['team_my_access'] = (_) => ok({'owner': true, 'permissions': <String>[]});
    site.functions['create-subscription-checkout'] = (b) => (status: 200, body: {'url': payUrl, 'session_id': 'cs_test_sub1', 'amount_cents': 29900, 'plan': b['plan']});
    site.functions['create-billing-portal'] = (b) => (status: 200, body: {'url': portalUrl});
  });

  Future<void> tap(WidgetTester tester, String key) async {
    await tester.ensureVisible(find.byKey(Key(key)));
    await tester.tap(find.byKey(Key(key)));
    await tester.pump();
  }

  Future<void> tick(WidgetTester tester) async {
    await tester.pump(const Duration(seconds: 1));
    await settleCalls(tester);
  }

  Future<void> openIt(WidgetTester tester, {Map<String, bool>? features, List<Map<String, dynamic>>? mine, List<Override> overrides = const [], Duration giveUpAfter = const Duration(minutes: 5)}) async {
    await openSocial(tester, site, '/', features: features ?? on, mine: mine ?? [myPersonal(), myBusiness()], opened: opened, overrides: [...asDj, ...overrides], fullPage: SubscriptionScreen(interval: const Duration(seconds: 1), giveUpAfter: giveUpAfter));
    await settleCalls(tester);
  }

  group('the plans', () {
    testWidgets('says it is not open yet while subscriptions are off', (tester) async {
      await openIt(tester, features: {'social': true});
      expect(find.text('Subscriptions are not open yet.'), findsOneWidget);
      expect(site.forRpc('sub_plans'), isEmpty);
    });

    testWidgets('a personal profile is asked to switch to a professional one', (tester) async {
      await openIt(tester, overrides: [selectedProfileIdProvider.overrideWith((ref) => null)]);
      expect(find.text('Switch to a professional profile'), findsOneWidget);
      expect(find.byKey(const Key('subscribe')), findsNothing);
    });

    testWidgets('a team member who does not own the profile is told only the owner manages it', (tester) async {
      site.rpcs['team_my_access'] = (_) => ok({'owner': false, 'permissions': ['bookings']});
      await openIt(tester);
      expect(find.text('Only the owner'), findsOneWidget);
      expect(find.byKey(const Key('subscribe')), findsNothing);
    });

    testWidgets('shows both plans with their prices, what yearly saves, and what a subscription changes', (tester) async {
      await openIt(tester);
      expect(find.text('Keep more of every booking'), findsOneWidget);
      expect(find.text('With a subscription BottlesUp takes 0% of each booking you do, instead of 5%.'), findsOneWidget);
      expect(find.descendant(of: find.byKey(const Key('plan-monthly')), matching: find.text('\$29.99 a month')), findsOneWidget);
      expect(find.descendant(of: find.byKey(const Key('plan-yearly')), matching: find.text('\$299.00 a year (saves \$60.88)')), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Subscribe, \$299.00 a year'), findsOneWidget);
      expect(find.textContaining('It renews by itself until you cancel'), findsOneWidget);
      expect(site.forRpc('sub_status').first.body, {'p_profile': 'biz'});
    });

    testWidgets('a subscription that changes nothing does not promise a lower commission', (tester) async {
      site.rpcs['sub_plans'] = (_) => ok(plansRow(subscribedBps: 500));
      await openIt(tester);
      expect(find.text('Subscribe'), findsOneWidget);
      expect(find.text('A subscription for your professional profile.'), findsOneWidget);
      expect(find.textContaining('instead of'), findsNothing);
    });

    testWidgets('says why the prices cannot be read, and reads them again', (tester) async {
      var fail = true;
      site.rpcs['sub_plans'] = (_) => fail ? raised('Subscriptions are not open yet.') : ok(plansRow());
      await openIt(tester);
      expect(find.text('Subscriptions are not open yet.'), findsOneWidget);
      fail = false;
      await tester.tap(find.byKey(const Key('load-failed-retry')));
      await settleCalls(tester);
      expect(find.byKey(const Key('subscribe')), findsOneWidget);
    });
  });

  group('subscribing', () {
    testWidgets('opens the payment page in the app for the plan chosen, waits, and says it is live only when the website does', (tester) async {
      var calls = 0;
      site.rpcs['sub_status'] = (_) => ++calls < 4 ? ok(null) : ok(subscriptionRow(plan: 'monthly'));
      await openIt(tester);
      await tap(tester, 'plan-monthly');
      expect(find.widgetWithText(FilledButton, 'Subscribe, \$29.99 a month'), findsOneWidget);
      await tap(tester, 'subscribe');
      await settleCalls(tester);
      expect(site.forFunction('create-subscription-checkout').single.body, {'profile_id': 'biz', 'plan': 'monthly'});
      expect(opened.single.toString(), payUrl);
      expect(find.byKey(const Key('subscription-waiting')), findsOneWidget);
      await tick(tester);
      await tick(tester);
      expect(find.byKey(const Key('subscription-done')), findsNothing);
      await tick(tester);
      expect(find.byKey(const Key('subscription-done')), findsOneWidget);
      expect(find.text('Your commission is now 0% on every booking.'), findsOneWidget);
      final asked = site.forRpc('sub_status').length;
      await tick(tester);
      expect(site.forRpc('sub_status').length, asked, reason: 'it stops asking once live');
      site.rpcs['sub_status'] = (_) => ok(subscriptionRow(plan: 'monthly'));
      await tap(tester, 'subscription-continue');
      await settleCalls(tester);
      expect(find.byKey(const Key('subscription-card')), findsOneWidget);
    });

    testWidgets('the yearly plan is the one chosen to begin with', (tester) async {
      await openIt(tester);
      await tap(tester, 'subscribe');
      await settleCalls(tester);
      expect(site.forFunction('create-subscription-checkout').single.body['plan'], 'yearly');
    });

    testWidgets('a payment that is only started is not a subscription', (tester) async {
      site.rpcs['sub_status'] = (_) => ok(subscriptionRow(status: 'incomplete'));
      await openIt(tester);
      await tap(tester, 'subscribe');
      await settleCalls(tester);
      await tick(tester);
      await tick(tester);
      expect(find.byKey(const Key('subscription-done')), findsNothing);
      expect(find.byKey(const Key('subscription-waiting')), findsOneWidget);
    });

    testWidgets('a refusal is shown as it came and nothing is waited for', (tester) async {
      site.functions['create-subscription-checkout'] = (b) => (status: 409, body: {'error': 'This profile already has a subscription.'});
      await openIt(tester);
      await tap(tester, 'subscribe');
      await settleCalls(tester);
      expect(textOf(tester, 'subscription-problem'), 'This profile already has a subscription.');
      expect(find.byKey(const Key('subscription-waiting')), findsNothing);
      expect(opened, isEmpty);
    });

    testWidgets('a payment page that will not open is said, and nothing is waited for', (tester) async {
      await openIt(tester, overrides: [urlOpenerProvider.overrideWithValue((uri, {bool inApp = false}) async => false)]);
      await tap(tester, 'subscribe');
      await settleCalls(tester);
      expect(textOf(tester, 'subscription-problem'), startsWith('We could not open the payment page.'));
      expect(find.byKey(const Key('subscription-waiting')), findsNothing);
    });

    testWidgets('a double tap on Subscribe opens one payment page', (tester) async {
      await openIt(tester);
      await tester.ensureVisible(find.byKey(const Key('subscribe')));
      await tester.tap(find.byKey(const Key('subscribe')));
      await tester.tap(find.byKey(const Key('subscribe')));
      await tester.pump();
      await settleCalls(tester);
      expect(site.forFunction('create-subscription-checkout').length, 1);
      expect(opened.length, 1);
    });

    testWidgets('coming back to the app while the payment page is open asks the website at once', (tester) async {
      await openIt(tester);
      await tap(tester, 'subscribe');
      await settleCalls(tester);
      final before = site.forRpc('sub_status').length;
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await settleCalls(tester);
      expect(site.forRpc('sub_status').length, before + 1);
    });

    testWidgets('after the give-up time it says it has not heard, and Check now resumes', (tester) async {
      await openIt(tester, giveUpAfter: const Duration(seconds: 3));
      await tap(tester, 'subscribe');
      await settleCalls(tester);
      for (var i = 0; i < 4; i++) {
        await tick(tester);
      }
      expect(find.text('We have not heard from Stripe yet'), findsOneWidget);
      site.rpcs['sub_status'] = (_) => ok(subscriptionRow());
      await tap(tester, 'subscription-check');
      await settleCalls(tester);
      expect(find.byKey(const Key('subscription-done')), findsOneWidget);
    });

    testWidgets('stepping back to the plans stops the asking', (tester) async {
      await openIt(tester);
      await tap(tester, 'subscribe');
      await settleCalls(tester);
      await tap(tester, 'subscription-back');
      await settleCalls(tester);
      final before = site.forRpc('sub_status').length;
      await tick(tester);
      await tick(tester);
      expect(site.forRpc('sub_status').length, before);
      expect(find.byKey(const Key('subscribe')), findsOneWidget);
    });
  });

  group('a subscription that is live', () {
    testWidgets('shows the plan, the price, when it renews and what it does to the commission', (tester) async {
      site.rpcs['sub_status'] = (_) => ok(subscriptionRow());
      await openIt(tester);
      expect(textOf(tester, 'subscription-plan'), 'Yearly plan');
      expect(find.text('\$299.00 a year'), findsOneWidget);
      expect(textOf(tester, 'subscription-line'), startsWith('It renews on '));
      expect(textOf(tester, 'subscription-commission'), 'Commission on your bookings: 0% instead of 5%.');
      expect(find.byKey(const Key('subscribe')), findsNothing);
    });

    testWidgets('says when it will end, and when the last payment failed', (tester) async {
      site.rpcs['sub_status'] = (_) => ok(subscriptionRow(cancelAtEnd: true));
      await openIt(tester);
      expect(textOf(tester, 'subscription-line'), startsWith('It will not renew: it ends on '));
      await tester.pumpWidget(const SizedBox());
      site.rpcs['sub_status'] = (_) => ok(subscriptionRow(status: 'past_due'));
      await openIt(tester);
      expect(textOf(tester, 'subscription-line'), 'The last payment did not go through. Update your card to keep the lower commission.');
    });

    testWidgets('Change card or cancel opens Stripe\'s page in the app, and the status is read again when the person comes back', (tester) async {
      site.rpcs['sub_status'] = (_) => ok(subscriptionRow());
      await openIt(tester);
      await tap(tester, 'manage-subscription');
      await settleCalls(tester);
      expect(site.forFunction('create-billing-portal').single.body, {'profile_id': 'biz'});
      expect(opened.single.toString(), portalUrl);
      final before = site.forRpc('sub_status').length;
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await settleCalls(tester);
      expect(site.forRpc('sub_status').length, before + 1);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await settleCalls(tester);
      expect(site.forRpc('sub_status').length, before + 1, reason: 'only once per visit to that page');
    });

    testWidgets('a refusal to open the page is said, and a page that will not open is said', (tester) async {
      site.rpcs['sub_status'] = (_) => ok(subscriptionRow());
      site.functions['create-billing-portal'] = (b) => (status: 409, body: {'error': 'This profile has no subscription to manage.'});
      await openIt(tester);
      await tap(tester, 'manage-subscription');
      await settleCalls(tester);
      expect(textOf(tester, 'subscription-problem'), 'This profile has no subscription to manage.');
      await tester.pumpWidget(const SizedBox());
      site.functions['create-billing-portal'] = (b) => (status: 200, body: {'url': portalUrl});
      await openIt(tester, overrides: [urlOpenerProvider.overrideWithValue((uri, {bool inApp = false}) async => false)]);
      await tap(tester, 'manage-subscription');
      await settleCalls(tester);
      expect(textOf(tester, 'subscription-problem'), startsWith('We could not open the page.'));
    });

    testWidgets('one that has ended says so and offers the plans again', (tester) async {
      site.rpcs['sub_status'] = (_) => ok(subscriptionRow(status: 'cancelled'));
      await openIt(tester);
      expect(textOf(tester, 'subscription-ended'), startsWith('This subscription ended on '));
      expect(find.byKey(const Key('subscribe')), findsOneWidget);
      expect(find.byKey(const Key('subscription-card')), findsNothing);
    });
  });
}
