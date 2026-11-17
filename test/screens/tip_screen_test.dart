import 'package:bottles_up_user/features/billing/screens/tip_screen.dart';
import 'package:bottles_up_user/site/providers/site_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/billing_fixtures.dart';
import '../support/fake_website.dart';
import '../support/pump_site.dart';
import '../support/pump_social.dart';

String textOf(WidgetTester tester, String key) => tester.widget<Text>(find.byKey(Key(key))).data!;

const payUrl = 'https://checkout.stripe.com/c/pay/cs_test_tip1#frag';

void main() {
  late FakeWebsite site;
  late List<Uri> opened;
  final on = {'social': true, 'creator_earnings': true};
  Map<String, dynamic> dj({bool mine = false, String kind = 'business'}) => profileRow(id: 'p-dj', kind: kind, handle: 'djdee', name: 'DJ Dee', category: kind == 'business' ? 'dj' : null, mine: mine);

  setUp(() {
    site = FakeWebsite();
    opened = [];
    site.rpcs['rules_status'] = (_) => ok({'version': 1, 'accepted': true});
    site.rpcs['profile_get'] = (_) => ok(dj());
    site.rpcs['tip_status'] = (_) => ok(tipRow());
    site.functions['create-tip-checkout'] = (b) => (status: 200, body: {'url': payUrl, 'session_id': 'cs_test_tip1', 'tip_id': 'tip1', 'amount_cents': b['amount_cents']});
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

  Future<void> openIt(WidgetTester tester, {Map<String, bool>? features, Duration giveUpAfter = const Duration(minutes: 5), List<Override> overrides = const []}) async {
    await openSocial(tester, site, '/', features: features ?? on, opened: opened, overrides: overrides, fullPage: TipScreen(profileId: 'p-dj', interval: const Duration(seconds: 1), giveUpAfter: giveUpAfter));
    await settleCalls(tester);
  }

  testWidgets('says it is not open yet while tips are off', (tester) async {
    await openIt(tester, features: {'social': true});
    expect(find.text('Tips are not open yet.'), findsOneWidget);
  });

  testWidgets('offers four amounts with ten dollars chosen, and the profile\'s name', (tester) async {
    await openIt(tester);
    expect(find.text('Tip DJ Dee'), findsOneWidget);
    expect([for (final c in [500, 1000, 2000, 5000]) find.byKey(Key('tip-$c')).evaluate().length], [1, 1, 1, 1]);
    expect(tester.widget<ChoiceChip>(find.byKey(const Key('tip-1000'))).selected, isTrue);
    expect(tester.widget<ChoiceChip>(find.byKey(const Key('tip-500'))).selected, isFalse);
    expect(find.widgetWithText(FilledButton, 'Send \$10.00'), findsOneWidget);
    expect(site.forRpc('profile_get').single.body, {'p_actor': 'me', 'p_handle': null, 'p_id': 'p-dj'});
  });

  testWidgets('sends the amount chosen, opens the payment page in the app, waits, and says it is sent only when the website does', (tester) async {
    var calls = 0;
    site.rpcs['tip_status'] = (_) => ++calls < 2 ? ok(tipRow(amount: 2000)) : ok(tipRow(status: 'paid', amount: 2000));
    await openIt(tester);
    await tap(tester, 'tip-2000');
    expect(find.widgetWithText(FilledButton, 'Send \$20.00'), findsOneWidget);
    await tap(tester, 'tip-send');
    await settleCalls(tester);
    expect(site.forFunction('create-tip-checkout').single.body, {'creator_id': 'p-dj', 'amount_cents': 2000});
    expect(opened.single.toString(), payUrl);
    expect(find.byKey(const Key('tip-waiting')), findsOneWidget);
    await tick(tester);
    expect(find.byKey(const Key('tip-done')), findsNothing);
    await tick(tester);
    expect(find.byKey(const Key('tip-done')), findsOneWidget);
    expect(find.text('Your \$20.00 tip is on its way to DJ Dee.'), findsOneWidget);
    expect(site.forRpc('tip_status').first.body, {'p_tip': 'tip1'});
    final asked = site.forRpc('tip_status').length;
    await tick(tester);
    expect(site.forRpc('tip_status').length, asked, reason: 'it stops asking once paid');
  });

  testWidgets('another amount typed in wins over the buttons, and the words are trimmed and sent', (tester) async {
    await openIt(tester);
    await tester.enterText(find.byKey(const Key('tip-custom')), '7.5');
    await tester.pump();
    expect(find.widgetWithText(FilledButton, 'Send \$7.50'), findsOneWidget);
    expect(tester.widget<ChoiceChip>(find.byKey(const Key('tip-1000'))).selected, isFalse);
    await tester.enterText(find.byKey(const Key('tip-message')), '  Great set  ');
    await tap(tester, 'tip-send');
    await settleCalls(tester);
    expect(site.forFunction('create-tip-checkout').single.body, {'creator_id': 'p-dj', 'amount_cents': 750, 'message': 'Great set'});
  });

  testWidgets('choosing a button again clears the typed amount', (tester) async {
    await openIt(tester);
    await tester.enterText(find.byKey(const Key('tip-custom')), '7.5');
    await tester.pump();
    await tap(tester, 'tip-500');
    expect(tester.widget<TextField>(find.byKey(const Key('tip-custom'))).controller!.text, '');
    expect(find.widgetWithText(FilledButton, 'Send \$5.00'), findsOneWidget);
  });

  testWidgets('says what is wrong with an amount before anything is sent', (tester) async {
    await openIt(tester);
    await tester.enterText(find.byKey(const Key('tip-custom')), 'lots');
    await tap(tester, 'tip-send');
    expect(textOf(tester, 'tip-problem'), 'Type the amount like 7 or 7.50.');
    await tester.enterText(find.byKey(const Key('tip-custom')), '0');
    await tap(tester, 'tip-send');
    expect(textOf(tester, 'tip-problem'), 'Choose an amount.');
    expect(site.forFunction('create-tip-checkout'), isEmpty);
  });

  testWidgets('a refusal is shown as it came and nothing is waited for', (tester) async {
    site.functions['create-tip-checkout'] = (b) => (status: 409, body: {'error': 'A tip is from 2.00 to 500.00.'});
    await openIt(tester);
    await tester.enterText(find.byKey(const Key('tip-custom')), '1');
    await tap(tester, 'tip-send');
    await settleCalls(tester);
    expect(textOf(tester, 'tip-problem'), 'A tip is from 2.00 to 500.00.');
    expect(find.byKey(const Key('tip-waiting')), findsNothing);
    expect(opened, isEmpty);
  });

  testWidgets('a payment that was voided says so and goes back to the amounts', (tester) async {
    site.rpcs['tip_status'] = (_) => ok(tipRow(status: 'void'));
    await openIt(tester);
    await tap(tester, 'tip-send');
    await settleCalls(tester);
    await tick(tester);
    expect(textOf(tester, 'tip-problem'), 'That payment did not go through. You were not charged.');
    expect(find.byKey(const Key('tip-send')), findsOneWidget);
    expect(find.byKey(const Key('tip-done')), findsNothing);
  });

  testWidgets('a payment page that will not open is said, and nothing is waited for', (tester) async {
    await openIt(tester, overrides: [urlOpenerProvider.overrideWithValue((uri, {bool inApp = false}) async => false)]);
    await tap(tester, 'tip-send');
    await settleCalls(tester);
    expect(textOf(tester, 'tip-problem'), startsWith('We could not open the payment page.'));
    expect(find.byKey(const Key('tip-waiting')), findsNothing);
  });

  testWidgets('a double tap on Send opens one payment page', (tester) async {
    await openIt(tester);
    await tester.ensureVisible(find.byKey(const Key('tip-send')));
    await tester.tap(find.byKey(const Key('tip-send')));
    await tester.tap(find.byKey(const Key('tip-send')));
    await tester.pump();
    await settleCalls(tester);
    expect(site.forFunction('create-tip-checkout').length, 1);
    expect(opened.length, 1);
  });

  testWidgets('nobody who has not accepted the community rules sends anything', (tester) async {
    site.rpcs['rules_status'] = (_) => ok({'version': 1, 'accepted': false});
    await openIt(tester);
    await tap(tester, 'tip-send');
    await settleCalls(tester);
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(site.forFunction('create-tip-checkout'), isEmpty);
  });

  testWidgets('coming back to the app while the payment page is open asks the website at once', (tester) async {
    await openIt(tester);
    await tap(tester, 'tip-send');
    await settleCalls(tester);
    final before = site.forRpc('tip_status').length;
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await settleCalls(tester);
    expect(site.forRpc('tip_status').length, before + 1);
  });

  testWidgets('after the give-up time it says it has not heard, and Check now resumes', (tester) async {
    await openIt(tester, giveUpAfter: const Duration(seconds: 3));
    await tap(tester, 'tip-send');
    await settleCalls(tester);
    for (var i = 0; i < 4; i++) {
      await tick(tester);
    }
    expect(find.text('We have not heard from Stripe yet'), findsOneWidget);
    site.rpcs['tip_status'] = (_) => ok(tipRow(status: 'paid'));
    await tap(tester, 'tip-check');
    await settleCalls(tester);
    expect(find.byKey(const Key('tip-done')), findsOneWidget);
  });

  testWidgets('stepping back to the amounts stops the asking', (tester) async {
    await openIt(tester);
    await tap(tester, 'tip-send');
    await settleCalls(tester);
    await tap(tester, 'tip-back');
    final before = site.forRpc('tip_status').length;
    await tick(tester);
    await tick(tester);
    expect(site.forRpc('tip_status').length, before);
    expect(find.byKey(const Key('tip-send')), findsOneWidget);
  });

  testWidgets('your own profile and a person\'s profile cannot be tipped', (tester) async {
    site.rpcs['profile_get'] = (_) => ok(dj(mine: true));
    await openIt(tester);
    expect(find.text('This profile cannot be tipped'), findsOneWidget);
    expect(find.byKey(const Key('tip-send')), findsNothing);
    await tester.pumpWidget(const SizedBox());
    site.rpcs['profile_get'] = (_) => ok(dj(kind: 'personal'));
    await openIt(tester);
    expect(find.text('This profile cannot be tipped'), findsOneWidget);
  });

  testWidgets('says why the profile cannot be read, and reads it again', (tester) async {
    var fail = true;
    site.rpcs['profile_get'] = (_) => fail ? raised('This profile is not available.') : ok(dj());
    await openIt(tester);
    expect(find.text('This profile is not available.'), findsOneWidget);
    fail = false;
    await tester.tap(find.byKey(const Key('load-failed-retry')));
    await settleCalls(tester);
    expect(find.byKey(const Key('tip-send')), findsOneWidget);
  });
}
