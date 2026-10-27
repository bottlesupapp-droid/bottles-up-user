import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';
import '../support/pump_social.dart';

Map<String, dynamic> member(String handle, {bool following = true}) => {...profileRow(id: 'id-$handle', handle: handle, name: handle.toUpperCase()), 'added_at': '2099-10-24T22:00:00Z', 'still_following': following};

void main() {
  late FakeWebsite site;

  setUp(() => site = FakeWebsite());

  const on = {'social': true, 'members_only': true};

  group('the Members Only list', () {
    testWidgets('lists the members, says how many, and flags one who stopped following', (tester) async {
      site.rpcs['members_list'] = (_) => ok([member('bob'), member('sam', following: false)]);
      await openSocial(tester, site, '/me/members', features: on);
      expect(find.byKey(const Key('profile-bob')), findsOneWidget);
      expect(find.byKey(const Key('profile-sam')), findsOneWidget);
      expect(find.textContaining('2 of 2000 members'), findsOneWidget);
      expect(find.byKey(const Key('not-following')), findsOneWidget);
      expect(site.forRpc('members_list').single.body, {'p_actor': 'me', 'p_limit': 200, 'p_before': null});
    });

    testWidgets('an empty list says so', (tester) async {
      site.rpcs['members_list'] = (_) => ok(<Object>[]);
      await openSocial(tester, site, '/me/members', features: on);
      expect(find.byKey(const Key('no-members')), findsOneWidget);
    });

    testWidgets('removing someone asks the website and reads the list again', (tester) async {
      var list = [member('bob'), member('sam')];
      site.rpcs['members_list'] = (_) => ok(list);
      site.rpcs['members_set'] = (b) {
        list = [for (final m in list) if (m['id'] != b['p_member']) m];
        return ok({'members': list.length, 'is_member': false});
      };
      await openSocial(tester, site, '/me/members', features: on);
      await tester.tap(find.byKey(const Key('remove-member-bob')));
      await tester.pumpAndSettle();
      expect(site.forRpc('members_set').single.body, {'p_actor': 'me', 'p_member': 'id-bob', 'p_in': false});
      expect(find.byKey(const Key('profile-bob')), findsNothing);
      expect(find.byKey(const Key('profile-sam')), findsOneWidget);
    });

    testWidgets('adding picks from the people who follow you, and marks those already members', (tester) async {
      var list = [member('bob')];
      site.rpcs['members_list'] = (_) => ok(list);
      site.rpcs['follow_list'] = (_) => ok([profileRow(id: 'id-bob', handle: 'bob', name: 'BOB'), profileRow(id: 'id-cy', handle: 'cy', name: 'CY')]);
      site.rpcs['members_set'] = (b) {
        list = [...list, member('cy')];
        return ok({'members': 2, 'is_member': true});
      };
      await openSocial(tester, site, '/me/members', features: on);
      await tester.tap(find.byKey(const Key('add-member')));
      await tester.pumpAndSettle();
      expect(site.forRpc('follow_list').single.body, {'p_actor': 'me', 'p_profile': 'me', 'p_kind': 'followers', 'p_limit': 50, 'p_before': null});
      expect(find.byKey(const Key('already-member')), findsOneWidget);
      expect(find.byKey(const Key('pick-member-bob')), findsNothing);
      await tester.tap(find.byKey(const Key('pick-member-cy')));
      await tester.pumpAndSettle();
      expect(site.forRpc('members_set').single.body, {'p_actor': 'me', 'p_member': 'id-cy', 'p_in': true});
      expect(find.byKey(const Key('profile-cy')), findsOneWidget);
    });

    testWidgets('the website\'s refusal is shown', (tester) async {
      site.rpcs['members_list'] = (_) => ok(<Object>[]);
      site.rpcs['follow_list'] = (_) => ok([profileRow(id: 'id-cy', handle: 'cy', name: 'CY')]);
      site.rpcs['members_set'] = (_) => raised('Your Members Only list is full (2000 people).');
      await openSocial(tester, site, '/me/members', features: on);
      await tester.tap(find.byKey(const Key('add-member')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('pick-member-cy')));
      await tester.pumpAndSettle();
      expect(find.text('Your Members Only list is full (2000 people).'), findsOneWidget);
    });

    testWidgets('nobody follows you yet: the picker says so', (tester) async {
      site.rpcs['members_list'] = (_) => ok(<Object>[]);
      site.rpcs['follow_list'] = (_) => ok(<Object>[]);
      await openSocial(tester, site, '/me/members', features: on);
      await tester.tap(find.byKey(const Key('add-member')));
      await tester.pumpAndSettle();
      expect(find.text('Nobody follows you yet.'), findsOneWidget);
    });

    testWidgets('a failed load offers to try again', (tester) async {
      var fail = true;
      site.rpcs['members_list'] = (_) => fail ? (status: 500, body: {'message': 'boom'}) : ok([member('bob')]);
      await openSocial(tester, site, '/me/members', features: on);
      expect(find.byKey(const Key('load-failed-retry')), findsOneWidget);
      fail = false;
      await tester.tap(find.byKey(const Key('load-failed-retry')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('profile-bob')), findsOneWidget);
    });

    testWidgets('while Members Only is off there is nothing to manage', (tester) async {
      await openSocial(tester, site, '/me/members', features: const {'social': true, 'members_only': false});
      expect(find.text('Members Only is not open yet.'), findsOneWidget);
      expect(site.forRpc('members_list'), isEmpty);
    });
  });

  group('saved posts', () {
    Map<String, dynamic> saved(String id, String at) => {...postRow(id: id, caption: 'saved $id', saved: true), 'saved_at': at};

    testWidgets('lists them, newest save first', (tester) async {
      site.rpcs['saved_posts'] = (_) => ok([saved('p1', '2099-10-24T22:00:02Z'), saved('p2', '2099-10-24T22:00:01Z')]);
      await openSocial(tester, site, '/me/saved');
      expect(find.byKey(const Key('caption-p1')), findsOneWidget);
      expect(find.byKey(const Key('caption-p2')), findsOneWidget);
      expect(site.forRpc('saved_posts').single.body, {'p_actor': 'me', 'p_limit': 30, 'p_before': null});
    });

    testWidgets('nothing saved says so', (tester) async {
      site.rpcs['saved_posts'] = (_) => ok(<Object>[]);
      await openSocial(tester, site, '/me/saved');
      expect(find.text('Nothing saved yet'), findsOneWidget);
    });

    testWidgets('a full page offers more, and the next page starts after the last save', (tester) async {
      var calls = 0;
      site.rpcs['saved_posts'] = (_) {
        calls++;
        return ok(calls == 1 ? [for (var i = 0; i < 30; i++) saved('p$i', '2099-10-24T22:00:${(59 - i).toString().padLeft(2, '0')}Z')] : [saved('late', '2099-10-24T21:00:00Z')]);
      };
      await openSocial(tester, site, '/me/saved', settle: false);
      await settleCalls(tester);
      await tester.scrollUntilVisible(find.byKey(const Key('saved-more')), 800, scrollable: find.byType(Scrollable).first);
      await tester.tap(find.byKey(const Key('saved-more')));
      await settleCalls(tester);
      expect(site.forRpc('saved_posts').last.body['p_before'], '2099-10-24T22:00:30.000Z');
    });

    testWidgets('a failed load offers to try again', (tester) async {
      site.rpcs['saved_posts'] = (_) => (status: 500, body: {'message': 'boom'});
      await openSocial(tester, site, '/me/saved');
      expect(find.byKey(const Key('load-failed-retry')), findsOneWidget);
    });
  });

  group('a profile\'s grid', () {
    Map<String, dynamic> grid(int n, {String kind = 'post'}) => {
          'total': n,
          'items': [
            for (var i = 0; i < n; i++)
              postRow(id: '$kind$i', kind: kind, caption: 'c$i', media: [kind == 'reel' ? mediaRow(id: 'm$kind$i', type: 'video', path: 'a1/$kind$i.mp4', durationMs: 9000) : mediaRow(id: 'm$kind$i', path: 'a1/$kind$i.jpg')], audience: i == 0 ? 'members' : 'public'),
          ],
        };

    testWidgets('shows the count and a tile for each post; a tile opens the post', (tester) async {
      site.rpcs['profile_get'] = (_) => ok(profileRow(id: 'a1', handle: 'ann', name: 'Ann Lee'));
      site.rpcs['profile_posts'] = (_) => ok(grid(3));
      site.rpcs['post_get'] = (_) => ok(postRow(id: 'post1'));
      site.rpcs['comment_list'] = (_) => ok(<Object>[]);
      final router = await openSocial(tester, site, '/u/ann');
      expect(find.byKey(const Key('grid-total')), findsOneWidget);
      expect(tester.widget<Text>(find.byKey(const Key('grid-total'))).data, '3 posts');
      expect(find.byKey(const Key('grid-post0')), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget, reason: 'the Members Only post is marked');
      expect(site.forRpc('profile_posts').single.body, {'p_actor': 'me', 'p_profile': 'a1', 'p_kind': null, 'p_limit': 30, 'p_before': null, 'p_before_id': null});
      await tester.tap(find.byKey(const Key('grid-post1')));
      await tester.pumpAndSettle();
      expect(router.routerDelegate.currentConfiguration.last.matchedLocation, '/post/post1');
    });

    testWidgets('Photos and Reels narrow the grid, and a reel shows a play badge', (tester) async {
      site.rpcs['profile_get'] = (_) => ok(profileRow(id: 'a1', handle: 'ann', name: 'Ann Lee'));
      site.rpcs['profile_posts'] = (b) => ok(b['p_kind'] == 'reel' ? grid(2, kind: 'reel') : grid(3));
      await openSocial(tester, site, '/u/ann');
      await tester.tap(find.descendant(of: find.byKey(const Key('grid-kind')), matching: find.text('Reels')));
      await tester.pumpAndSettle();
      expect(site.forRpc('profile_posts').last.body['p_kind'], 'reel');
      expect(find.byKey(const Key('grid-reel0')), findsOneWidget);
      expect(find.byIcon(Icons.play_circle_outline), findsWidgets);
      expect(tester.widget<Text>(find.byKey(const Key('grid-total'))).data, '2 posts');
    });

    testWidgets('a full page offers more, and the next page starts after the last post', (tester) async {
      site.rpcs['profile_get'] = (_) => ok(profileRow(id: 'a1', handle: 'ann', name: 'Ann Lee'));
      var calls = 0;
      site.rpcs['profile_posts'] = (_) {
        calls++;
        return ok(calls == 1
            ? {
                'total': 31,
                'items': [for (var i = 0; i < 30; i++) postRow(id: 'g$i', createdAt: '2099-10-24T22:00:${(59 - i).toString().padLeft(2, '0')}Z', media: [mediaRow(id: 'mg$i', path: 'a1/g$i.jpg')])],
              }
            : {'total': 31, 'items': [postRow(id: 'late', createdAt: '2099-10-24T20:00:00Z', media: [mediaRow(id: 'mlate', path: 'a1/late.jpg')])]});
      };
      await openSocial(tester, site, '/u/ann', settle: false);
      await settleCalls(tester);
      await tester.ensureVisible(find.byKey(const Key('grid-more')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('grid-more')));
      await settleCalls(tester);
      expect(site.forRpc('profile_posts').last.body['p_before_id'], 'g29');
      expect(site.forRpc('profile_posts').last.body['p_before'], '2099-10-24T22:00:30.000Z');
    });

    testWidgets('no posts says so', (tester) async {
      site.rpcs['profile_get'] = (_) => ok(profileRow(id: 'a1', handle: 'ann', name: 'Ann Lee'));
      await openSocial(tester, site, '/u/ann');
      expect(find.byKey(const Key('grid-empty')), findsOneWidget);
    });

    testWidgets('a private profile the viewer does not follow shows no grid and asks nothing', (tester) async {
      site.rpcs['profile_get'] = (_) => ok(profileRow(id: 'a1', handle: 'ann', name: 'Ann Lee', privacy: 'private', canSee: false));
      await openSocial(tester, site, '/u/ann');
      expect(find.byKey(const Key('profile-grid')), findsNothing);
      expect(find.byKey(const Key('private-notice')), findsOneWidget);
      expect(site.forRpc('profile_posts'), isEmpty);
    });

    testWidgets('a profile you blocked shows no grid', (tester) async {
      site.rpcs['profile_get'] = (_) => ok(profileRow(id: 'a1', handle: 'ann', name: 'Ann Lee', blocked: true));
      await openSocial(tester, site, '/u/ann');
      expect(find.byKey(const Key('profile-grid')), findsNothing);
    });

    testWidgets('a failure to read the posts is said under the header, not hidden', (tester) async {
      site.rpcs['profile_get'] = (_) => ok(profileRow(id: 'a1', handle: 'ann', name: 'Ann Lee'));
      site.rpcs['profile_posts'] = (_) => raised('Follow this profile to see its posts.');
      await openSocial(tester, site, '/u/ann');
      expect(find.text('Follow this profile to see its posts.'), findsOneWidget);
    });
  });
}
