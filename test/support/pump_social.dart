import 'package:bottles_up_user/routing/app_router.dart';
import 'package:bottles_up_user/site/providers/site_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'fake_website.dart';
import 'pump_site.dart';

/// The person's own profile as `profile_my_profiles` lists it.
Map<String, dynamic> myPersonal({String id = 'me', String handle = 'dana', String name = 'Dana Lee', bool private = false, int followers = 3, int following = 2}) =>
    profileRow(id: id, handle: handle, name: name, privacy: private ? 'private' : 'public', mine: true, followers: followers, following: following, interests: ['music']);

Map<String, dynamic> myBusiness({String id = 'biz', String handle = 'djdana', String name = 'DJ Dana'}) =>
    profileRow(id: id, kind: 'business', handle: handle, name: name, category: 'dj', mine: true);

/// Opens the app's own routes at [location] with social switched on (unless [features] says otherwise) and the person's profiles set to [mine]. Returns the router so a test can read
/// where the app went. Sets up `site_features` and `profile_my_profiles` on [site] unless the test has already.
Future<GoRouter> openSocial(
  WidgetTester tester,
  FakeWebsite site,
  String location, {
  Map<String, bool> features = const {'social': true},
  List<Map<String, dynamic>>? mine,
  List<Uri>? opened,
  List<Override> overrides = const [],
  bool settle = true,
  Widget? home,
}) async {
  site.rpcs.putIfAbsent('site_features', () => (_) => ok(features));
  final profiles = mine ?? [myPersonal()];
  site.rpcs.putIfAbsent('profile_my_profiles', () => (_) => ok(profiles));
  // [home] is a widget shown at '/__home' beside the app's own routes, for a piece of a screen that is not a route.
  final router = GoRouter(
    initialLocation: home == null ? location : '/__home',
    routes: [if (home != null) GoRoute(path: '/__home', builder: (_, __) => Scaffold(body: SingleChildScrollView(child: home))), ...appRoutes],
  );
  tester.view.physicalSize = const Size(800, 2200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(ProviderScope(
    overrides: [
      siteClientProvider.overrideWithValue(site.client),
      accountProvider.overrideWith((ref) async => signedIn),
      urlOpenerProvider.overrideWithValue((uri, {bool inApp = false}) async {
        opened?.add(uri);
        return true;
      }),
      ...overrides,
    ],
    child: MaterialApp.router(routerConfig: router),
  ));
  if (settle) await tester.pumpAndSettle();
  return router;
}
