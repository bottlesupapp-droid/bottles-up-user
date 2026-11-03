import 'package:bottles_up_user/features/split/screens/pay_share_screen.dart';
import 'package:bottles_up_user/features/split/widgets/shares_to_pay_card.dart';
import 'package:bottles_up_user/site/providers/site_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';
import '../support/pump_social.dart';

String textOf(WidgetTester tester, String key) => tester.widget<Text>(find.byKey(Key(key))).data!;

const payUrl = 'https://checkout.stripe.com/c/pay/cs_test_share7#frag';

void main() {
  late FakeWebsite site;
  late List<Uri> opened;
  late int wentBack;
  final on = {'social': true, 'split_payments': true};

  String path(GoRouter r) => r.routerDelegate.currentConfiguration.last.matchedLocation;

  setUp(() {
    site = FakeWebsite();
    opened = [];
    wentBack = 0;
    site.rpcs['split_my_shares'] = (_) => ok([shareRequestRow()]);
    site.functions['create-split-checkout'] = (b) => (status: 200, body: {'url': payUrl, 'session_id': 'cs_test_share7'});
    site.functions['confirm-split-share'] = (b) => (status: 200, body: {'status': 'pending'});
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

  Future<GoRouter> openPay(WidgetTester tester, {bool canOpen = true, Duration giveUpAfter = const Duration(minutes: 5), String id = 'sh1'}) async {
    final router = await openSocial(tester, site, '/', features: on, opened: opened, fullPage: PayShareScreen(shareId: id, interval: const Duration(seconds: 1), giveUpAfter: giveUpAfter, onBack: (c) => wentBack++));
    await settleCalls(tester);
    return router;
  }

  group('paying a share', () {
    testWidgets('says who asked, for which night, how much and until when, and shows nothing about the booking beyond that', (tester) async {
      await openPay(tester);
      expect(textOf(tester, 'share-title'), 'Ann asked you to pay your share');
      expect(textOf(tester, 'share-venue'), 'Club A · Fri, Nov 6 · 10:00 PM');
      expect(textOf(tester, 'share-amount'), '\$50.00');
      expect(textOf(tester, 'share-line'), startsWith('Pay by'));
      expect(find.byKey(const Key('share-pay')), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Pay \$50.00'), findsOneWidget);
    });

    testWidgets('paying opens the payment page in the app, waits, and says it is paid only when the website does', (tester) async {
      var calls = 0;
      site.functions['confirm-split-share'] = (b) => ++calls < 3 ? (status: 200, body: {'status': 'pending'}) : (status: 200, body: {'status': 'paid'});
      await openPay(tester);
      await tap(tester, 'share-pay');
      await settleCalls(tester);
      expect(site.forFunction('create-split-checkout').single.body, {'share_id': 'sh1'});
      expect(site.forFunction('confirm-split-share'), isEmpty);
      await tester.pump();
      expect(opened.single.toString(), payUrl);
      expect(find.byKey(const Key('share-waiting')), findsOneWidget);
      await tick(tester);
      await tick(tester);
      expect(find.byKey(const Key('share-done')), findsNothing);
      await tick(tester);
      expect(site.forFunction('confirm-split-share').first.body, {'share_id': 'sh1'});
      expect(find.byKey(const Key('share-done')), findsOneWidget);
      expect(textOf(tester, 'share-done-text'), contains('\$50.00 towards Ann\'s table at Club A'));
      final asked = site.forFunction('confirm-split-share').length;
      await tick(tester);
      expect(site.forFunction('confirm-split-share').length, asked, reason: 'it stops asking once paid');
      await tap(tester, 'share-done-back');
      expect(wentBack, 1);
    });

    testWidgets('a double tap on Pay opens one payment page', (tester) async {
      await openPay(tester);
      await tester.ensureVisible(find.byKey(const Key('share-pay')));
      await tester.tap(find.byKey(const Key('share-pay')));
      await tester.tap(find.byKey(const Key('share-pay')));
      await tester.pump();
      await settleCalls(tester);
      expect(site.forFunction('create-split-checkout').length, 1);
      expect(opened.length, 1);
    });

    testWidgets('coming back to the app while the payment page is open asks the website at once', (tester) async {
      await openPay(tester);
      await tap(tester, 'share-pay');
      await settleCalls(tester);
      expect(site.forFunction('confirm-split-share'), isEmpty);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await settleCalls(tester);
      expect(site.forFunction('confirm-split-share').length, 1);
    });

    testWidgets('"I have paid" asks straight away', (tester) async {
      site.functions['confirm-split-share'] = (b) => (status: 200, body: {'status': 'paid'});
      await openPay(tester);
      await tap(tester, 'share-pay');
      await settleCalls(tester);
      await tap(tester, 'share-check');
      await settleCalls(tester);
      expect(find.byKey(const Key('share-done')), findsOneWidget);
    });

    testWidgets('if the website cannot be reached it says so in a sentence and keeps trying', (tester) async {
      var up = false;
      site.functions['confirm-split-share'] = (b) => up ? (status: 200, body: {'status': 'paid'}) : (status: 500, body: {'error': 'boom'});
      await openPay(tester);
      await tap(tester, 'share-pay');
      await settleCalls(tester);
      await tick(tester);
      expect(textOf(tester, 'share-hint'), 'We could not check your payment. Check your connection and try again.');
      up = true;
      await tick(tester);
      expect(find.byKey(const Key('share-done')), findsOneWidget);
    });

    testWidgets('after the give-up time it says it has not seen the payment, and Check again resumes', (tester) async {
      await openPay(tester, giveUpAfter: const Duration(seconds: 3));
      await tap(tester, 'share-pay');
      await settleCalls(tester);
      for (var i = 0; i < 4; i++) {
        await tick(tester);
      }
      expect(find.byKey(const Key('share-stalled')), findsOneWidget);
      site.functions['confirm-split-share'] = (b) => (status: 200, body: {'status': 'paid'});
      await tap(tester, 'share-check');
      await settleCalls(tester);
      expect(find.byKey(const Key('share-done')), findsOneWidget);
    });

    testWidgets('the payment page can be opened again, and the person can step back to the request', (tester) async {
      await openPay(tester);
      await tap(tester, 'share-pay');
      await settleCalls(tester);
      await tap(tester, 'share-reopen');
      expect(opened.length, 2);
      await tap(tester, 'share-leave');
      expect(find.byKey(const Key('share-details')), findsOneWidget);
      await tick(tester);
      expect(site.forFunction('confirm-split-share'), isEmpty, reason: 'it stops asking when the person leaves the waiting screen');
    });

    testWidgets('a request that ran out or was cancelled while the page was open is said, not shown as paid', (tester) async {
      site.functions['confirm-split-share'] = (b) => (status: 200, body: {'status': 'expired'});
      await openPay(tester);
      await tap(tester, 'share-pay');
      await settleCalls(tester);
      await tick(tester);
      expect(textOf(tester, 'share-problem'), 'The time to pay this has passed.');
      expect(find.byKey(const Key('share-done')), findsNothing);
    });

    testWidgets('a request that is no longer open says so', (tester) async {
      site.functions['confirm-split-share'] = (b) => (status: 200, body: {'status': 'cancelled'});
      await openPay(tester);
      await tap(tester, 'share-pay');
      await settleCalls(tester);
      await tick(tester);
      expect(textOf(tester, 'share-problem'), 'This request is no longer open.');
    });

    testWidgets('a payment page that will not open is said, and nothing is waited for', (tester) async {
      await openSocial(tester, site, '/', features: on, overrides: [urlOpenerProvider.overrideWithValue((uri, {bool inApp = false}) async => false)], fullPage: PayShareScreen(shareId: 'sh1', interval: const Duration(seconds: 1), onBack: (c) => wentBack++));
      await settleCalls(tester);
      await tap(tester, 'share-pay');
      await settleCalls(tester);
      await settleCalls(tester);
      expect(textOf(tester, 'share-problem'), startsWith('We could not open the payment page.'));
      expect(find.byKey(const Key('share-waiting')), findsNothing);
      expect(site.forFunction('confirm-split-share'), isEmpty);
    });

    testWidgets('the website\'s refusal is shown as it said it, and the request is looked at again', (tester) async {
      site.functions['create-split-checkout'] = (b) => (status: 409, body: {'error': 'The rest of this table has been paid in the meantime, so there is nothing left for you to pay.'});
      await openPay(tester);
      await tap(tester, 'share-pay');
      await settleCalls(tester);
      await settleCalls(tester);
      expect(textOf(tester, 'share-problem'), 'The rest of this table has been paid in the meantime, so there is nothing left for you to pay.');
      expect(opened, isEmpty);
      expect(site.forRpc('split_my_shares').length, greaterThanOrEqualTo(2));
    });

    testWidgets('turning a request down asks first, then tells the website and goes back', (tester) async {
      site.rpcs['split_share_decline'] = (_) => ok({'id': 'sh1', 'state': 'declined'});
      await openPay(tester);
      await tap(tester, 'share-decline');
      await tester.pumpAndSettle();
      await tap(tester, 'share-keep');
      await tester.pumpAndSettle();
      expect(site.forRpc('split_share_decline'), isEmpty);
      await tap(tester, 'share-decline');
      await tester.pumpAndSettle();
      await tap(tester, 'share-decline-confirm');
      await settleCalls(tester);
      await settleCalls(tester);
      expect(site.forRpc('split_share_decline').single.body, {'p_share': 'sh1'});
      expect(wentBack, 1);
    });

    testWidgets('a refusal to turn it down is shown', (tester) async {
      site.rpcs['split_share_decline'] = (_) => raised('This request can no longer be turned down.');
      await openPay(tester);
      await tap(tester, 'share-decline');
      await tester.pumpAndSettle();
      await tap(tester, 'share-decline-confirm');
      await settleCalls(tester);
      await settleCalls(tester);
      expect(textOf(tester, 'share-problem'), 'This request can no longer be turned down.');
      expect(wentBack, 0);
    });

    testWidgets('a request someone else has no business seeing is not found', (tester) async {
      await openPay(tester, id: 'someone-elses');
      expect(find.text('Request not found'), findsOneWidget);
      expect(find.byKey(const Key('share-pay')), findsNothing);
    });

    for (final (state, row, expectText, canPay) in [
      ('paid', shareRequestRow(state: 'paid', paidAt: '2099-11-02T10:00:00Z'), 'You paid on', false),
      ('refunding', shareRequestRow(state: 'refunding'), 'it is being paid back to your card', false),
      ('refunded', shareRequestRow(state: 'refunded'), 'it was paid back to your card', false),
      ('expired', shareRequestRow(state: 'expired'), 'The time to pay this has passed. Ask Ann to send a new request.', false),
      ('cancelled', shareRequestRow(state: 'cancelled'), 'Ann cancelled this, or the booking was cancelled. Nothing is due.', false),
      ('declined', shareRequestRow(state: 'declined'), 'You turned this request down.', false),
      ('pending', shareRequestRow(state: 'pending'), 'Pay by', true),
    ]) {
      testWidgets('a share that is $state is said as it is${canPay ? ' and can still be paid' : ' and cannot be paid'}', (tester) async {
        site.rpcs['split_my_shares'] = (_) => ok([row]);
        await openPay(tester);
        expect(textOf(tester, 'share-line'), contains(expectText));
        expect(find.byKey(const Key('share-pay')), canPay ? findsOneWidget : findsNothing);
        expect(find.byKey(const Key('share-decline')), state == 'expired' ? findsOneWidget : findsNothing);
      });
    }

    testWidgets('a share that has not been paid yet can be turned down', (tester) async {
      await openPay(tester);
      expect(find.byKey(const Key('share-decline')), findsOneWidget);
    });

    testWidgets('a list that cannot be loaded says so and can be tried again', (tester) async {
      var up = false;
      site.rpcs['split_my_shares'] = (_) => up ? ok([shareRequestRow()]) : (status: 500, body: {'message': 'x'});
      await openPay(tester);
      expect(find.textContaining('your requests to pay'), findsOneWidget);
      up = true;
      await tester.tap(find.text('Try again'));
      await settleCalls(tester);
      expect(find.byKey(const Key('share-pay')), findsOneWidget);
    });
  });

  group('the list of shares to pay', () {
    Future<GoRouter> list(WidgetTester tester) async {
      final router = await openSocial(tester, site, '/me/shares', features: on);
      await settleCalls(tester);
      return router;
    }

    testWidgets('puts what is to pay first, with the amount and the deadline, and what is done after', (tester) async {
      site.rpcs['split_my_shares'] = (_) => ok([
            shareRequestRow(id: 'old', state: 'paid', venue: 'Club B', host: 'Zed'),
            shareRequestRow(id: 'new', state: 'unpaid', venue: 'Club A', host: 'Ann', amount: 2500),
          ]);
      await list(tester);
      expect(find.text('To pay'), findsOneWidget);
      expect(find.text('Earlier'), findsOneWidget);
      final first = tester.getTopLeft(find.byKey(const Key('share-new'))).dy;
      final second = tester.getTopLeft(find.byKey(const Key('share-old'))).dy;
      expect(first, lessThan(second));
      expect(find.text('Ann · Club A'), findsOneWidget);
      expect(find.text('\$25.00'), findsOneWidget);
      expect(find.textContaining('Waiting for payment · pay by'), findsOneWidget);
      expect(find.textContaining('Paid'), findsWidgets);
    });

    testWidgets('opening one goes to its page', (tester) async {
      final router = await list(tester);
      await tester.tap(find.byKey(const Key('share-sh1')));
      await settleCalls(tester);
      expect(path(router), '/me/shares/sh1');
    });

    testWidgets('with none it says nothing is to pay', (tester) async {
      site.rpcs['split_my_shares'] = (_) => ok(<Object>[]);
      await list(tester);
      expect(find.text('Nothing to pay'), findsOneWidget);
    });

    testWidgets('a failure says so', (tester) async {
      site.rpcs['split_my_shares'] = (_) => (status: 500, body: {'message': 'x'});
      await list(tester);
      expect(find.textContaining('your requests to pay'), findsOneWidget);
    });
  });

  group('the card on Home', () {
    Future<GoRouter> card(WidgetTester tester) async {
      final router = await openSocial(tester, site, '/', features: on, home: const SharesToPayCard());
      await settleCalls(tester);
      return router;
    }

    testWidgets('one request is said by who asked, where and how much, and opens that request', (tester) async {
      final router = await card(tester);
      expect(textOf(tester, 'shares-to-pay-title'), 'Ann asked you to pay your share');
      expect(textOf(tester, 'shares-to-pay-detail'), 'Club A · \$50.00');
      await tester.tap(find.byKey(const Key('shares-to-pay')));
      await settleCalls(tester);
      expect(path(router), '/me/shares/sh1');
    });

    testWidgets('several are counted and open the list', (tester) async {
      site.rpcs['split_my_shares'] = (_) => ok([shareRequestRow(id: 'a', amount: 3000), shareRequestRow(id: 'b', amount: 2000, state: 'pending')]);
      final router = await card(tester);
      expect(textOf(tester, 'shares-to-pay-title'), '2 friends asked you to pay a share');
      expect(textOf(tester, 'shares-to-pay-detail'), '\$50.00 in all');
      await tester.tap(find.byKey(const Key('shares-to-pay')));
      await settleCalls(tester);
      expect(path(router), '/me/shares');
    });

    testWidgets('nothing when everything is paid, cancelled or turned down, or when there is no request', (tester) async {
      site.rpcs['split_my_shares'] = (_) => ok([shareRequestRow(id: 'a', state: 'paid'), shareRequestRow(id: 'b', state: 'cancelled'), shareRequestRow(id: 'c', state: 'declined'), shareRequestRow(id: 'd', state: 'expired')]);
      await card(tester);
      expect(find.byKey(const Key('shares-to-pay')), findsNothing);
    });

    testWidgets('nothing, and nothing asked, while splitting is switched off', (tester) async {
      await openSocial(tester, site, '/', features: const {'social': true}, home: const SharesToPayCard());
      await settleCalls(tester);
      expect(find.byKey(const Key('shares-to-pay')), findsNothing);
      expect(site.forRpc('split_my_shares'), isEmpty);
    });

    testWidgets('a failure hides the card rather than breaking Home', (tester) async {
      site.rpcs['split_my_shares'] = (_) => (status: 500, body: {'message': 'x'});
      await card(tester);
      expect(find.byKey(const Key('shares-to-pay')), findsNothing);
    });
  });
}
