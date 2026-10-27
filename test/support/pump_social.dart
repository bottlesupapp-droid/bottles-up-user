import 'package:bottles_up_user/features/social/widgets/post_widgets.dart';
import 'package:bottles_up_user/shared/widgets/site_widgets.dart';
import 'package:bottles_up_user/routing/app_router.dart';
import 'package:bottles_up_user/site/rules/post_rules.dart';
import 'package:bottles_up_user/site/services/media_picker.dart';
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

/// A phone's photo library for tests: what it will hand back, and how many times it was asked.
class FakeMediaPicker implements MediaPicker {
  FakeMediaPicker({this.photosToReturn = const [], this.videoToReturn});

  List<PickedMedia> photosToReturn;
  PickedMedia? videoToReturn;
  int photoAsks = 0;
  int videoAsks = 0;
  int? lastMax;

  @override
  Future<List<PickedMedia>> photos({required int max}) async {
    photoAsks++;
    lastMax = max;
    return photosToReturn.take(max).toList();
  }

  @override
  Future<PickedMedia?> video() async {
    videoAsks++;
    return videoToReturn;
  }
}

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
  site.rpcs.putIfAbsent('story_rail', () => (_) => ok(<Object>[]));
  site.rpcs.putIfAbsent('profile_posts', () => (_) => ok({'total': 0, 'items': <Object>[]}));
  // [home] is a widget shown at '/__home' beside the app's own routes, for a piece of a screen that is not a route.
  // Pictures are shown through a cache on the phone's disk, which a test phone does not have: a plain box stands in, carrying the address.
  NetworkPicture.imageOverride = (url, fit, width, height) => SizedBox(key: ValueKey('img:$url'), width: width, height: height);
  addTearDown(() => NetworkPicture.imageOverride = null);
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
      postVideoBuilderProvider.overrideWithValue((url, {required autoplay, required loop, required showControls}) => Container(key: const Key('video-surface'), color: Colors.black54, child: Text('video autoplay=$autoplay'))),
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
