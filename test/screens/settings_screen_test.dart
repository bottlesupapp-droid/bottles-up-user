import 'package:bottles_up_user/features/profile/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bottles_up_user/site/providers/site_providers.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';

String textOf(WidgetTester tester, String key) => tester.widget<Text>(find.byKey(Key(key))).data!;

void main() {
  late FakeWebsite site;
  late List<Uri> opened;

  setUp(() {
    site = FakeWebsite();
    opened = [];
    site.tables['site_content'] = [
      {'contact_email': 'help@bottlesupapp.com', 'contact_phone': '+1 416 555 0100', 'address': '1 King St W, Toronto', 'social_instagram': 'https://instagram.com/bottlesup'}
    ];
  });

  Future<void> open(WidgetTester tester, {bool canOpen = true}) => pumpSite(tester, const SettingsScreen(), site: site, opened: opened, canOpen: canOpen);

  testWidgets('says who you are signed in as, and how notifications work, without switches for things the app does not have', (tester) async {
    await open(tester);
    expect(textOf(tester, 'settings-account'), 'Signed in as dana@example.com');
    expect(textOf(tester, 'settings-notifications'), startsWith('BottlesUp e-mails your tickets, booking confirmations and updates. Push notifications are not available yet'));
    expect(find.byType(Switch), findsNothing);
    for (final gone in ['Analytics', 'Location Access', 'Dark Mode', 'Currency', 'Clear Cache', 'Promotional Offers', 'Export Data']) {
      expect(find.text(gone), findsNothing, reason: gone);
    }
  });

  testWidgets('shows the contact details the BottlesUp team set, and opens them', (tester) async {
    await open(tester);
    expect(textOf(tester, 'contact-address'), '1 King St W, Toronto');
    for (final k in ['contact-email', 'contact-phone', 'contact-social-instagram']) {
      await tester.ensureVisible(find.byKey(Key(k)));
      await tester.tap(find.byKey(Key(k)));
      await tester.pump();
    }
    expect(opened.map((u) => u.scheme), ['mailto', 'tel', 'https']);
    expect(opened[0].path, 'help@bottlesupapp.com');
    expect(opened[1].toString(), 'tel:+14165550100');
    expect(Uri.decodeComponent(opened[0].query), contains('Account e-mail: dana@example.com'));
  });

  testWidgets('nothing the team did not set is shown, and no address is made up', (tester) async {
    site.tables['site_content'] = [
      {'contact_email': 'help@bottlesupapp.com'}
    ];
    await open(tester);
    expect(find.byKey(const Key('contact-email')), findsOneWidget);
    for (final k in ['contact-phone', 'contact-address', 'contact-social-instagram']) {
      expect(find.byKey(Key(k)), findsNothing, reason: k);
    }
  });

  testWidgets('with nothing set it says contact details are not available, and offers no data request by e-mail', (tester) async {
    site.tables['site_content'] = [];
    await open(tester);
    expect(find.byKey(const Key('contact-none')), findsOneWidget);
    expect(find.byKey(const Key('settings-copy')), findsNothing);
  });

  testWidgets('a copy of your data is asked for in an e-mail to the address the team set, which the person reads and sends', (tester) async {
    await open(tester);
    await tester.ensureVisible(find.byKey(const Key('settings-copy')));
    await tester.tap(find.byKey(const Key('settings-copy')));
    await tester.pump();
    final u = opened.single;
    expect([u.scheme, u.path], ['mailto', 'help@bottlesupapp.com']);
    expect(u.toString(), contains('subject=Copy%20of%20my%20data'));
    expect(Uri.decodeComponent(u.query), contains('Please send me a copy of the personal data BottlesUp holds about me.'));
  });

  testWidgets('if something cannot be opened the person is told', (tester) async {
    await open(tester, canOpen: false);
    await tester.ensureVisible(find.byKey(const Key('contact-email')));
    await tester.tap(find.byKey(const Key('contact-email')));
    await tester.pump();
    expect(find.text('That could not be opened on this phone.'), findsOneWidget);
  });

  testWidgets('if the contact details cannot be loaded there is a sentence and a way to try again', (tester) async {
    site.failTables.add('site_content');
    await open(tester);
    expect(textOf(tester, 'contact-failed'), 'We could not load the contact details. Check your connection and try again.');
    site.failTables.clear();
    await tester.tap(find.byKey(const Key('contact-retry')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('contact-email')), findsOneWidget);
  });

  testWidgets('the data and privacy entries go to their own pages, and deleting the account is pointed to in the profile', (tester) async {
    final router = GoRouter(routes: [
      GoRoute(path: '/', builder: (c, s) => const SettingsScreen()),
      GoRoute(path: '/profile/data', builder: (c, s) => const Scaffold(body: Text('data page', key: Key('data-page')))),
      GoRoute(path: '/profile/privacy-policy', builder: (c, s) => const Scaffold(body: Text('privacy page', key: Key('privacy-page')))),
    ]);
    tester.view.physicalSize = const Size(800, 2200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ProviderScope(overrides: [siteClientProvider.overrideWithValue(site.client), accountProvider.overrideWith((ref) async => signedIn)], child: MaterialApp.router(routerConfig: router)));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('settings-delete-note')), findsOneWidget);
    await tester.tap(find.byKey(const Key('settings-collects')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('data-page')), findsOneWidget);
    router.pop();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('settings-privacy')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('privacy-page')), findsOneWidget);
  });
}
