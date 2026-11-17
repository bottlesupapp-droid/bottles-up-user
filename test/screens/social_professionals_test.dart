import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';
import '../support/pump_social.dart';

Map<String, dynamic> pro(String handle, String category, {String name = '', int followers = 0}) =>
    profileRow(id: 'id-$handle', kind: 'business', handle: handle, name: name.isEmpty ? handle.toUpperCase() : name, category: category, followers: followers);

void main() {
  late FakeWebsite site;

  setUp(() => site = FakeWebsite());

  Future<void> open(WidgetTester tester) => openSocial(tester, site, '/explore/professionals').then((_) {});

  testWidgets('lists professionals as the website ranks them, with a way to follow', (tester) async {
    site.rpcs['explore_professionals'] = (_) => ok([pro('djann', 'dj'), pro('bobphoto', 'photographer')]);
    await open(tester);
    expect(find.byKey(const Key('profile-djann')), findsOneWidget);
    expect(find.byKey(const Key('profile-bobphoto')), findsOneWidget);
    expect(find.text('@djann · DJ'), findsOneWidget);
    expect(find.byKey(const Key('follow-button')), findsNWidgets(2));
    expect(site.forRpc('explore_professionals').single.body, {'p_actor': 'me', 'p_category': null, 'p_city': null, 'p_query': null, 'p_limit': 20, 'p_offset': 0});
  });

  testWidgets('a category narrows it and a venue is not on offer', (tester) async {
    site.rpcs['explore_professionals'] = (b) => ok(b['p_category'] == 'dj' ? [pro('djann', 'dj')] : [pro('djann', 'dj'), pro('bobphoto', 'photographer')]);
    await open(tester);
    expect(find.byKey(const Key('pro-category-venue')), findsNothing);
    await tester.tap(find.byKey(const Key('pro-category-dj')));
    await tester.pumpAndSettle();
    expect(site.forRpc('explore_professionals').last.body['p_category'], 'dj');
    expect(find.byKey(const Key('profile-bobphoto')), findsNothing);
    await tester.tap(find.byKey(const Key('pro-category-dj')));
    await tester.pumpAndSettle();
    expect(site.forRpc('explore_professionals').last.body['p_category'], isNull);
  });

  testWidgets('the name and the city wait for the typing to pause, then ask once', (tester) async {
    site.rpcs['explore_professionals'] = (_) => ok(<Object>[]);
    await open(tester);
    await tester.enterText(find.byKey(const Key('pro-name')), 'dj');
    await tester.enterText(find.byKey(const Key('pro-city')), 'Toronto');
    await tester.pump(const Duration(milliseconds: 100));
    expect(site.forRpc('explore_professionals'), hasLength(1));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    expect(site.forRpc('explore_professionals'), hasLength(2));
    expect(site.forRpc('explore_professionals').last.body, containsPair('p_query', 'dj'));
    expect(site.forRpc('explore_professionals').last.body, containsPair('p_city', 'Toronto'));
  });

  testWidgets('a full page offers more, and the next page starts where the last ended', (tester) async {
    var calls = 0;
    site.rpcs['explore_professionals'] = (_) {
      calls++;
      return ok(calls == 1 ? [for (var i = 0; i < 20; i++) pro('pro${i.toString().padLeft(2, '0')}', 'dj')] : [pro('late', 'dj')]);
    };
    await openSocial(tester, site, '/explore/professionals', settle: false);
    await settleCalls(tester);
    await tester.scrollUntilVisible(find.byKey(const Key('pro-more')), 600, scrollable: find.byType(Scrollable).first);
    await tester.tap(find.byKey(const Key('pro-more')));
    await settleCalls(tester);
    expect(site.forRpc('explore_professionals').last.body['p_offset'], 20);
  });

  testWidgets('nobody found says so; a failure offers to try again', (tester) async {
    site.rpcs['explore_professionals'] = (_) => ok(<Object>[]);
    await open(tester);
    expect(find.byKey(const Key('pro-empty')), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    site = FakeWebsite();
    site.rpcs['explore_professionals'] = (_) => (status: 500, body: {'message': 'boom'});
    await open(tester);
    expect(find.byKey(const Key('load-failed-retry')), findsOneWidget);
  });

  testWidgets('opens a profile', (tester) async {
    site.rpcs['explore_professionals'] = (_) => ok([pro('djann', 'dj')]);
    site.rpcs['profile_get'] = (_) => ok(pro('djann', 'dj'));
    final router = await openSocial(tester, site, '/explore/professionals');
    await tester.tap(find.byKey(const Key('profile-djann')));
    await tester.pumpAndSettle();
    expect(router.routerDelegate.currentConfiguration.last.matchedLocation, '/u/djann');
  });
}
