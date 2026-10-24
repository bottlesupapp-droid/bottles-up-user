import 'package:bottles_up_user/site/providers/site_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_website.dart';

/// A signed-in customer for the screens that need one (the screens read the e-mail, name and phone from it).
const Account signedIn = Account(email: 'dana@example.com', name: 'Dana Lee', phone: '416-555-0100');

/// Shows [child] on a phone-sized screen, with the app talking to [site] and (unless [account] is null) [signedIn] signed in. [opened] collects the addresses the app tried to open
/// outside itself; [canOpen] says whether opening works.
Future<void> pumpSite(
  WidgetTester tester,
  Widget child, {
  required FakeWebsite site,
  Account? account = signedIn,
  List<Uri>? opened,
  bool canOpen = true,
  bool settle = true,
}) async {
  tester.view.physicalSize = const Size(800, 2200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(ProviderScope(
    overrides: [
      siteClientProvider.overrideWithValue(site.client),
      accountProvider.overrideWith((ref) async => account),
      urlOpenerProvider.overrideWithValue((uri, {bool inApp = false}) async {
        opened?.add(uri);
        return canOpen;
      }),
    ],
    child: MaterialApp(home: child),
  ));
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
}

/// Lets calls to the pretend website's functions finish (they need a little real time: the client hands the JSON to another isolate) and the screen rebuild, without waiting for
/// animations that never end (a spinner).
Future<void> settleCalls(WidgetTester tester) async {
  for (var i = 0; i < 4; i++) {
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 30)));
    await tester.pump(const Duration(milliseconds: 50));
  }
}
