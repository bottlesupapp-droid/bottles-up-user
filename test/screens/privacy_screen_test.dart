import 'package:bottles_up_user/features/profile/screens/privacy_policy_screen.dart';
import 'package:bottles_up_user/site/site_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';

void main() {
  testWidgets('opens the website\'s privacy policy by itself, and again on request', (tester) async {
    final opened = <Uri>[];
    await pumpSite(tester, const PrivacyPolicyScreen(), site: FakeWebsite(), opened: opened);
    expect(opened, [privacyPolicyUri()]);
    await tester.tap(find.byKey(const Key('privacy-open')));
    await tester.pump();
    expect(opened.length, 2);
    expect(find.byKey(const Key('privacy-failed')), findsNothing);
  });

  testWidgets('if it cannot be opened it says so', (tester) async {
    await pumpSite(tester, const PrivacyPolicyScreen(), site: FakeWebsite(), canOpen: false);
    expect(find.byKey(const Key('privacy-failed')), findsOneWidget);
  });

  test('the address is the website\'s privacy page', () {
    expect(privacyPolicyUri(origin: 'https://www.bottlesupapp.com').toString(), 'https://www.bottlesupapp.com/privacy-policy');
  });
}
