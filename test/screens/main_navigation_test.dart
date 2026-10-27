import 'dart:async';

import 'package:bottles_up_user/features/main_navigation/screens/main_navigation_screen.dart';
import 'package:bottles_up_user/site/models/features.dart';
import 'package:bottles_up_user/site/providers/site_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';
import '../support/pump_social.dart';

void main() {
  late FakeWebsite site;

  setUp(() {
    site = FakeWebsite();
    site.tables['site_events'] = [];
    site.tables['site_venues'] = [];
    site.tables['site_table_bookings'] = [];
    site.tables['site_orders'] = [];
    site.rpcs['feed_home'] = (_) => ok(<Object>[]);
    site.rpcs['feed_suggested'] = (_) => ok(<Object>[]);
    site.rpcs['dm_unread'] = (_) => ok({'conversations': 0, 'requests': 0});
    site.rpcs['dm_inbox'] = (_) => ok(<Object>[]);
    site.rpcs['notifications_unread'] = (_) => ok(0);
    site.rpcs['explore_hot_events'] = (_) => ok(<Object>[]);
    site.rpcs['explore_hot_venues'] = (_) => ok(<Object>[]);
    site.rpcs['profile_search'] = (_) => ok(<Object>[]);
    site.rpcs['venue_ratings'] = (_) => ok(<Object>[]);
  });

  /// The old profile screen draws a picture from the internet, which a test cannot reach: that is not what is being tested. (Called inside each test: the test binding sets
  /// its own error handler just before the test body.)
  void quietNetworkImages() {
    final original = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.exception is NetworkImageLoadException) return;
      original?.call(details);
    };
    addTearDown(() => FlutterError.onError = original);
  }

  String path(GoRouter r) => r.routerDelegate.currentConfiguration.last.matchedLocation;

  Future<GoRouter> open(WidgetTester tester, {Map<String, bool> features = const {}, List<Map<String, dynamic>>? mine}) {
    quietNetworkImages();
    return openSocial(tester, site, '/', features: features, mine: mine, fullPage: const MainNavigationScreen(), settle: false, overrides: [signedInAuth()]).then((r) async {
        await settleCalls(tester);
        return r;
      });
  }

  group('with social switched off', () {
    testWidgets('the original four tabs, as before', (tester) async {
      await open(tester);
      for (final label in ['Events', 'Tables', 'Bookings', 'Profile']) {
        expect(find.byKey(Key('nav-${label.toLowerCase()}')), findsOneWidget, reason: label);
      }
      expect(find.byKey(const Key('nav-home')), findsNothing);
      expect(find.byKey(const Key('nav-create')), findsNothing);
      expect(find.byKey(const Key('social-pages')), findsNothing);
    });

    testWidgets('a failed read of the switches is the same four tabs', (tester) async {
      site.rpcs['site_features'] = (_) => (status: 500, body: {'message': 'boom'});
      await open(tester);
      expect(find.byKey(const Key('nav-events')), findsOneWidget);
    });
  });

  group('with social switched on', () {
    const on = {'social': true, 'inbox': true};

    testWidgets('Home, Explore, Create, Inbox and Profile', (tester) async {
      await open(tester, features: on);
      for (final label in ['Home', 'Explore', 'Create', 'Inbox', 'Profile']) {
        expect(find.byKey(Key('nav-${label.toLowerCase()}')), findsOneWidget, reason: label);
      }
      expect(find.byKey(const Key('nav-events')), findsNothing);
      expect(find.byKey(const Key('home-feed')), findsOneWidget, reason: 'Home opens first');
    });

    testWidgets('without messages there is no Inbox tab', (tester) async {
      await open(tester, features: const {'social': true});
      expect(find.byKey(const Key('nav-inbox')), findsNothing);
      for (final label in ['Home', 'Explore', 'Create', 'Profile']) {
        expect(find.byKey(Key('nav-${label.toLowerCase()}')), findsOneWidget, reason: label);
      }
    });

    testWidgets('Create is a button: it opens the create page and does not leave the tab', (tester) async {
      final router = await open(tester, features: on);
      await tester.tap(find.byKey(const Key('nav-create')));
      await tester.pumpAndSettle();
      expect(path(router), '/create');
      router.pop();
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('home-feed')), findsOneWidget);
    });

    testWidgets('pages are built when first opened, and kept', (tester) async {
      await open(tester, features: on);
      expect(site.forRpc('dm_inbox'), isEmpty, reason: 'the inbox is not asked for until it is opened');
      await tester.tap(find.byKey(const Key('nav-inbox')));
      await tester.pumpAndSettle();
      expect(site.forRpc('dm_inbox'), hasLength(1));
      expect(find.text('No messages yet'), findsOneWidget);
      await tester.tap(find.byKey(const Key('nav-home')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('nav-inbox')));
      await tester.pumpAndSettle();
      expect(site.forRpc('dm_inbox'), hasLength(1), reason: 'coming back does not start again');
    });

    testWidgets('the Inbox tab counts what is new', (tester) async {
      site.rpcs['dm_unread'] = (_) => ok({'conversations': 2, 'requests': 1});
      await open(tester, features: on);
      expect(tester.widget<Text>(find.byKey(const Key('nav-badge-inbox'))).data, '3');
    });

    testWidgets('no count when nothing is new', (tester) async {
      await open(tester, features: on);
      expect(find.byKey(const Key('nav-badge-inbox')), findsNothing);
    });

    testWidgets('Explore and Profile open', (tester) async {
      await open(tester, features: on);
      await tester.tap(find.byKey(const Key('nav-explore')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('explore-search')), findsOneWidget);
      await tester.tap(find.byKey(const Key('nav-profile')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('social-entry')), findsOneWidget);
    });

    testWidgets('while the switches are loading nothing is drawn, not the wrong layout', (tester) async {
      await openSocial(tester, site, '/', features: on, fullPage: const MainNavigationScreen(), settle: false, overrides: [signedInAuth(), featuresProvider.overrideWith((ref) => Completer<SiteFeatures>().future)]);
      await tester.pump();
      expect(find.byKey(const Key('shell-loading')), findsOneWidget);
      expect(find.byKey(const Key('nav-events')), findsNothing);
      expect(find.byKey(const Key('nav-home')), findsNothing);
    });
  });

  group('the profile tab', () {
    const on = {'social': true, 'inbox': true};

    testWidgets('leads to tickets and bookings as a page of its own', (tester) async {
      final router = await open(tester, features: on);
      await tester.tap(find.byKey(const Key('nav-profile')));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key('open-bookings')));
      await tester.tap(find.byKey(const Key('open-bookings')));
      await tester.pumpAndSettle();
      expect(path(router), '/me/bookings');
      expect(find.text('Tickets and bookings'), findsOneWidget);
      expect(find.byKey(const Key('bookings-segments')), findsOneWidget);
      expect(find.text('Bookings'), findsNothing, reason: 'the page has its own title, not the tab\'s big heading');
    });

    testWidgets('a business profile gets the line between this app and BottlesUp Business, and a way there', (tester) async {
      quietNetworkImages();
      final opened = <Uri>[];
      final router = await openSocial(tester, site, '/', features: on, mine: [myPersonal(), myBusiness()], fullPage: const MainNavigationScreen(), settle: false, opened: opened, overrides: [signedInAuth(), selectedProfileIdProvider.overrideWith((ref) => 'biz')]);
      await settleCalls(tester);
      expect(router, isNotNull);
      await tester.tap(find.byKey(const Key('nav-profile')));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key('business-tools')));
      expect(find.byKey(const Key('business-in-app')), findsOneWidget);
      expect(find.byKey(const Key('business-in-business')), findsOneWidget);
      await tester.tap(find.byKey(const Key('open-business-tools')));
      await tester.pump();
      expect(opened.single.toString(), endsWith('/workspaces'));
    });

    testWidgets('a personal profile does not get it', (tester) async {
      await open(tester, features: on);
      await tester.tap(find.byKey(const Key('nav-profile')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('business-tools')), findsNothing);
    });
  });
}
