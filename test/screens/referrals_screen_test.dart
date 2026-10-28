import 'package:bottles_up_user/features/billing/screens/referrals_screen.dart';
import 'package:bottles_up_user/site/providers/site_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/billing_fixtures.dart';
import '../support/fake_website.dart';
import '../support/pump_site.dart';
import '../support/pump_social.dart';

String textOf(WidgetTester tester, String key) => tester.widget<Text>(find.byKey(Key(key))).data!;
String codeOf(WidgetTester tester) => tester.widget<SelectableText>(find.byKey(const Key('referral-code'))).data!;

void main() {
  late FakeWebsite site;
  late List<String> shared;
  final on = {'social': true, 'referrals': true};

  setUp(() {
    site = FakeWebsite();
    shared = [];
    site.rpcs['rules_status'] = (_) => ok({'version': 1, 'accepted': true});
    site.rpcs['referral_code'] = (_) => ok({'code': 'ABCD1234'});
    site.rpcs['referral_stats'] = (_) => ok(statsRow());
    site.rpcs['referral_mine'] = (_) => ok(null);
    site.rpcs['referral_claim'] = (b) => ok({'claimed': true, 'referrer': profileRow(id: 'p-ann', handle: 'ann', name: 'Ann Lee')});
  });

  Future<void> tap(WidgetTester tester, String key) async {
    await tester.ensureVisible(find.byKey(Key(key)));
    await tester.tap(find.byKey(Key(key)));
    await tester.pump();
  }

  Future<void> openIt(WidgetTester tester, {Map<String, bool>? features}) async {
    await openSocial(tester, site, '/', features: features ?? on, fullPage: ReferralsScreen(share: (t) async => shared.add(t)));
    await settleCalls(tester);
  }

  testWidgets('says it is not open yet while referrals are off', (tester) async {
    await openIt(tester, features: {'social': true});
    expect(find.text('Referrals are not open yet.'), findsOneWidget);
    expect(site.forRpc('referral_code'), isEmpty);
  });

  testWidgets('shows the code of the profile, what a friend\'s first purchase earns, and how it is doing', (tester) async {
    await openIt(tester);
    expect(codeOf(tester), 'ABCD1234');
    expect(site.forRpc('referral_code').single.body, {'p_profile': 'me'});
    expect(find.text('When a friend uses your code and makes their first purchase, you earn \$5.00.'), findsOneWidget);
    expect(textOf(tester, 'referral-referred'), '3');
    expect(textOf(tester, 'referral-credited'), '2');
    expect(textOf(tester, 'referral-payable'), '\$5.00');
    expect(textOf(tester, 'referral-paid'), '\$10.00');
  });

  testWidgets('the code is still shown when the numbers are not for this role', (tester) async {
    site.rpcs['referral_stats'] = (_) => raised('Your role on this profile does not allow this.');
    await openIt(tester);
    expect(codeOf(tester), 'ABCD1234');
    expect(find.byKey(const Key('referral-referred')), findsNothing);
    expect(find.text('Friends who use your code and make their first purchase earn you a credit.'), findsOneWidget);
  });

  testWidgets('a code worth nothing is not promised as money', (tester) async {
    site.rpcs['referral_stats'] = (_) => ok(statsRow(credit: 0));
    await openIt(tester);
    expect(find.text('Friends who use your code and make their first purchase earn you a credit.'), findsOneWidget);
    expect(find.textContaining('you earn'), findsNothing);
    expect(textOf(tester, 'referral-referred'), '3');
  });

  testWidgets('sharing hands the phone a sentence with the code in it', (tester) async {
    await openIt(tester);
    await tap(tester, 'referral-share');
    expect(shared.single, 'Join me on BottlesUp and use my code ABCD1234 when you sign up.');
  });

  testWidgets('copying puts the code on the clipboard and says so', (tester) async {
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'Clipboard.setData') copied = (call.arguments as Map)['text'] as String?;
      return null;
    });
    addTearDown(() => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, null));
    await openIt(tester);
    await tap(tester, 'referral-copy');
    await tester.pump();
    expect(copied, 'ABCD1234');
    expect(find.text('Code copied.'), findsOneWidget);
  });

  testWidgets('a business profile\'s code says whose it is', (tester) async {
    site.rpcs['profile_my_profiles'] = (_) => ok([myPersonal(), myBusiness()]);
    await openSocial(tester, site, '/', features: on, overrides: [selectedProfileIdProvider.overrideWith((ref) => 'biz')], fullPage: ReferralsScreen(share: (t) async => shared.add(t)));
    await settleCalls(tester);
    expect(find.text('Your code for DJ Dana'), findsOneWidget);
    expect(site.forRpc('referral_code').single.body, {'p_profile': 'biz'});
  });

  testWidgets('says why the code cannot be read, and reads it again', (tester) async {
    var fail = true;
    site.rpcs['referral_code'] = (_) => fail ? raised('Referrals are not open yet.') : ok({'code': 'ABCD1234'});
    await openIt(tester);
    expect(textOf(tester, 'referral-code-error'), 'Referrals are not open yet.');
    fail = false;
    await tap(tester, 'referral-code-retry');
    await settleCalls(tester);
    expect(codeOf(tester), 'ABCD1234');
  });

  group('using a friend\'s code', () {
    testWidgets('sends the code tidied, says who sent the person, and the box goes once a code is used', (tester) async {
      await openIt(tester);
      await tester.enterText(find.byKey(const Key('referral-input')), ' abcd-5678 ');
      await tap(tester, 'referral-use');
      await settleCalls(tester);
      expect(site.forRpc('referral_claim').single.body, {'p_code': 'ABCD5678'});
      expect(find.text('Thank you. Ann Lee sent you.'), findsOneWidget);
      site.rpcs['referral_mine'] = (_) => ok({'referrer': profileRow(id: 'p-ann', handle: 'ann', name: 'Ann Lee'), 'claimed_at': '2026-11-02T10:00:00Z'});
      await tester.pumpWidget(const SizedBox());
      await openIt(tester);
      expect(find.byKey(const Key('referral-used')), findsOneWidget);
      expect(find.text('You used the code of Ann Lee.'), findsOneWidget);
      expect(find.byKey(const Key('referral-input')), findsNothing);
    });

    testWidgets('the box goes at once when the code is used, without leaving the screen', (tester) async {
      await openIt(tester);
      expect(find.byKey(const Key('referral-input')), findsOneWidget);
      site.rpcs['referral_mine'] = (_) => ok({'referrer': profileRow(id: 'p-ann', handle: 'ann', name: 'Ann Lee'), 'claimed_at': '2026-11-02T10:00:00Z'});
      await tester.enterText(find.byKey(const Key('referral-input')), 'ABCD5678');
      await tap(tester, 'referral-use');
      await settleCalls(tester);
      expect(find.byKey(const Key('referral-input')), findsNothing);
      expect(find.text('You used the code of Ann Lee.'), findsOneWidget);
    });

    testWidgets('says what is wrong with a code before sending it', (tester) async {
      await openIt(tester);
      await tester.enterText(find.byKey(const Key('referral-input')), 'ABC');
      await tap(tester, 'referral-use');
      await tester.pump();
      expect(find.text('A code has 8 letters and numbers.'), findsOneWidget);
      expect(site.forRpc('referral_claim'), isEmpty);
      await tester.enterText(find.byKey(const Key('referral-input')), 'ABCD1234');
      await tester.pump();
      expect(find.text('A code has 8 letters and numbers.'), findsNothing, reason: 'typing again clears it');
    });

    testWidgets('a refusal is shown as it came', (tester) async {
      site.rpcs['referral_claim'] = (_) => raised('You cannot use your own code.');
      await openIt(tester);
      await tester.enterText(find.byKey(const Key('referral-input')), 'ABCD1234');
      await tap(tester, 'referral-use');
      await settleCalls(tester);
      expect(find.text('You cannot use your own code.'), findsOneWidget);
    });

    testWidgets('a double tap on Use this code sends it once', (tester) async {
      await openIt(tester);
      await tester.enterText(find.byKey(const Key('referral-input')), 'ABCD1234');
      await tester.ensureVisible(find.byKey(const Key('referral-use')));
      await tester.tap(find.byKey(const Key('referral-use')));
      await tester.tap(find.byKey(const Key('referral-use')));
      await settleCalls(tester);
      expect(site.forRpc('referral_claim').length, 1);
    });

    testWidgets('says why it cannot tell whether a code was used, and tries again', (tester) async {
      var fail = true;
      site.rpcs['referral_mine'] = (_) => fail ? raised('Referrals are not open yet.') : ok(null);
      await openIt(tester);
      expect(find.byKey(const Key('referral-claim-error')), findsOneWidget);
      fail = false;
      await tester.tap(find.descendant(of: find.byKey(const Key('referral-claim-error')), matching: find.text('Try again')));
      await settleCalls(tester);
      expect(find.byKey(const Key('referral-input')), findsOneWidget);
    });
  });
}
