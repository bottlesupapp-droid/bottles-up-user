import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';
import '../support/pump_social.dart';

Map<String, dynamic> person(int i, {String follow = 'none', String? at}) =>
    profileRow(id: 'p$i', handle: 'person$i', name: 'Person $i', follow: follow, extra: {'followed_at': at ?? '2099-01-${(30 - i % 28).toString().padLeft(2, '0')}T10:00:00Z'});

void main() {
  late FakeWebsite site;

  setUp(() => site = FakeWebsite());

  group('followers and following', () {
    testWidgets('lists the people with a button for each and opens a profile', (tester) async {
      site.rpcs['follow_list'] = (_) => ok([person(1), person(2, follow: 'active'), profileRow(id: 'me', handle: 'dana', mine: true)]);
      site.rpcs['profile_get'] = (_) => ok(profileRow(id: 'p1', handle: 'person1', name: 'Person 1'));
      final router = await openSocial(tester, site, '/profiles/target/followers');
      expect(find.text('Followers'), findsOneWidget);
      expect(find.byKey(const Key('profile-person1')), findsOneWidget);
      expect(find.byKey(const Key('profile-person2')), findsOneWidget);
      // Your own row has no button.
      expect(find.byKey(const Key('follow-button')), findsNWidgets(2));
      expect(site.forRpc('follow_list').single.body, {'p_actor': 'me', 'p_profile': 'target', 'p_kind': 'followers', 'p_limit': 30, 'p_before': null});
      await tester.tap(find.byKey(const Key('profile-person1')));
      await tester.pumpAndSettle();
      expect(router.routerDelegate.currentConfiguration.last.matchedLocation, '/u/person1');
    });

    testWidgets('the following list asks for following', (tester) async {
      site.rpcs['follow_list'] = (_) => ok([person(1)]);
      await openSocial(tester, site, '/profiles/target/following');
      expect(find.text('Following'), findsOneWidget);
      expect(site.forRpc('follow_list').single.body['p_kind'], 'following');
    });

    testWidgets('a full page offers more, and the next page starts after the last person seen', (tester) async {
      final first = [for (var i = 1; i <= 30; i++) person(i, at: '2099-01-02T10:00:${(60 - i).toString().padLeft(2, '0')}Z')];
      var calls = 0;
      site.rpcs['follow_list'] = (b) {
        calls++;
        return ok(calls == 1 ? first : [person(31)]);
      };
      // A big answer is decoded on another isolate, so it needs a little real time (settleCalls).
      await openSocial(tester, site, '/profiles/target/followers', settle: false);
      await settleCalls(tester);
      await tester.scrollUntilVisible(find.byKey(const Key('show-more')), 400, scrollable: find.byType(Scrollable).first);
      expect(find.byKey(const Key('show-more')), findsOneWidget);
      await tester.tap(find.byKey(const Key('show-more')));
      await settleCalls(tester);
      // The last of the first page was written at 10:00:30 (i = 30).
      expect(site.forRpc('follow_list').last.body['p_before'], '2099-01-02T10:00:30.000Z');
      expect(find.byKey(const Key('show-more')), findsNothing);
      await tester.scrollUntilVisible(find.byKey(const Key('profile-person31')), 300, scrollable: find.byType(Scrollable).first);
      expect(find.byKey(const Key('profile-person31')), findsOneWidget);
    });

    testWidgets('no people says so', (tester) async {
      site.rpcs['follow_list'] = (_) => ok(<Object>[]);
      await openSocial(tester, site, '/profiles/target/followers');
      expect(find.text('No followers yet'), findsOneWidget);
    });

    testWidgets('a private profile\'s people show the website\'s sentence', (tester) async {
      site.rpcs['follow_list'] = (_) => raised('Follow this profile to see its people.');
      await openSocial(tester, site, '/profiles/target/followers');
      expect(find.text('Follow this profile to see its people.'), findsOneWidget);
    });
  });

  group('follow requests', () {
    testWidgets('accepting one answers the website and refreshes the list', (tester) async {
      var list = [person(1), person(2)];
      site.rpcs['follow_requests'] = (_) => ok(list);
      site.rpcs['follow_respond'] = (b) {
        list = [for (final p in list) if (p['id'] != b['p_other']) p];
        return ok({'followers': 4, 'requests': list.length});
      };
      await openSocial(tester, site, '/people/requests', mine: [myPersonal(private: true)]);
      expect(find.byKey(const Key('profile-person1')), findsOneWidget);
      await tester.tap(find.byKey(const Key('accept-person1')));
      await tester.pumpAndSettle();
      expect(site.forRpc('follow_respond').single.body, {'p_actor': 'me', 'p_other': 'p1', 'p_action': 'accept'});
      expect(find.byKey(const Key('profile-person1')), findsNothing);
      expect(find.byKey(const Key('profile-person2')), findsOneWidget);
    });

    testWidgets('declining sends decline', (tester) async {
      site.rpcs['follow_requests'] = (_) => ok([person(1)]);
      site.rpcs['follow_respond'] = (_) => ok({'followers': 0, 'requests': 0});
      await openSocial(tester, site, '/people/requests', mine: [myPersonal(private: true)]);
      await tester.tap(find.byKey(const Key('decline-person1')));
      await tester.pumpAndSettle();
      expect(site.forRpc('follow_respond').single.body['p_action'], 'decline');
    });

    testWidgets('a request that is already gone is reported and the list is read again', (tester) async {
      site.rpcs['follow_requests'] = (_) => ok([person(1)]);
      site.rpcs['follow_respond'] = (_) => raised('There is no request from this profile.');
      await openSocial(tester, site, '/people/requests', mine: [myPersonal(private: true)]);
      await tester.tap(find.byKey(const Key('accept-person1')));
      await tester.pumpAndSettle();
      expect(find.text('There is no request from this profile.'), findsOneWidget);
      expect(site.forRpc('follow_requests'), hasLength(2));
    });

    testWidgets('no requests says so', (tester) async {
      site.rpcs['follow_requests'] = (_) => ok(<Object>[]);
      await openSocial(tester, site, '/people/requests', mine: [myPersonal(private: true)]);
      expect(find.text('No requests'), findsOneWidget);
    });
  });

  group('blocked profiles', () {
    testWidgets('lists them and unblocks one', (tester) async {
      var list = [profileRow(id: 'x1', handle: 'blocked1', name: 'Blocked One', blocked: true), profileRow(id: 'x2', handle: 'blocked2', name: 'Blocked Two', blocked: true)];
      site.rpcs['block_list'] = (_) => ok(list);
      site.rpcs['block_set'] = (b) {
        list = [for (final p in list) if (p['id'] != b['p_target']) p];
        return ok({'blocked': false});
      };
      await openSocial(tester, site, '/people/blocked');
      expect(find.byKey(const Key('profile-blocked1')), findsOneWidget);
      await tester.tap(find.byKey(const Key('unblock-blocked1')));
      await tester.pumpAndSettle();
      expect(site.forRpc('block_set').single.body, {'p_actor': 'me', 'p_target': 'x1', 'p_blocked': false});
      expect(find.byKey(const Key('profile-blocked1')), findsNothing);
      expect(find.byKey(const Key('profile-blocked2')), findsOneWidget);
    });

    testWidgets('nobody blocked says so', (tester) async {
      site.rpcs['block_list'] = (_) => ok(<Object>[]);
      await openSocial(tester, site, '/people/blocked');
      expect(find.text('Nobody blocked'), findsOneWidget);
    });
  });

  group('search', () {
    testWidgets('waits for two letters and for the typing to pause', (tester) async {
      site.rpcs['profile_search'] = (b) => ok([person(1)]);
      await openSocial(tester, site, '/people');
      expect(find.text('Search BottlesUp'), findsOneWidget);
      await tester.enterText(find.byKey(const Key('people-search-field')), 'a');
      await tester.pump(const Duration(milliseconds: 500));
      expect(site.forRpc('profile_search'), isEmpty);
      await tester.enterText(find.byKey(const Key('people-search-field')), 'an');
      await tester.enterText(find.byKey(const Key('people-search-field')), 'ann');
      await tester.pump(const Duration(milliseconds: 100));
      expect(site.forRpc('profile_search'), isEmpty);
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      // One search for the word, not one per letter.
      expect(site.forRpc('profile_search').single.body, {'p_actor': 'me', 'p_query': 'ann', 'p_limit': 20});
      expect(find.byKey(const Key('profile-person1')), findsOneWidget);
    });

    testWidgets('a follow button works from the results', (tester) async {
      site.rpcs['profile_search'] = (_) => ok([person(1)]);
      site.rpcs['follow_set'] = (_) => ok(person(1, follow: 'active'));
      await openSocial(tester, site, '/people');
      await tester.enterText(find.byKey(const Key('people-search-field')), 'per');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('follow-button')));
      await tester.pumpAndSettle();
      expect(site.forRpc('follow_set').single.body, {'p_actor': 'me', 'p_target': 'p1', 'p_follow': true});
      expect(find.descendant(of: find.byKey(const Key('follow-button')), matching: find.text('Following')), findsOneWidget);
    });

    testWidgets('no match says so', (tester) async {
      site.rpcs['profile_search'] = (_) => ok(<Object>[]);
      await openSocial(tester, site, '/people');
      await tester.enterText(find.byKey(const Key('people-search-field')), 'zzz');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(find.text('No one found'), findsOneWidget);
    });

    testWidgets('a failure offers to try again', (tester) async {
      site.rpcs['profile_search'] = (_) => (status: 500, body: {'message': 'boom'});
      await openSocial(tester, site, '/people');
      await tester.enterText(find.byKey(const Key('people-search-field')), 'ann');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('load-failed-retry')), findsOneWidget);
    });
  });
}
