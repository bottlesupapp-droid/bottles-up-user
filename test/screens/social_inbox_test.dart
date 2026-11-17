import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';
import '../support/pump_social.dart';

void main() {
  late FakeWebsite site;

  setUp(() => site = FakeWebsite());

  const on = {'social': true, 'inbox': true};

  Future<GoRouter> open(WidgetTester tester, {Map<String, bool> features = on, String at = '/inbox', List<Map<String, dynamic>>? mine, bool settle = true}) {
    site.rpcs.putIfAbsent('dm_unread', () => (_) => ok({'conversations': 0, 'requests': 0}));
    site.rpcs.putIfAbsent('notifications_unread', () => (_) => ok(0));
    return openSocial(tester, site, at, features: features, mine: mine, settle: settle);
  }

  String path(GoRouter r) => r.routerDelegate.currentConfiguration.last.matchedLocation;

  group('the inbox', () {
    testWidgets('lists conversations with the person, the last words and what is new', (tester) async {
      site.rpcs['dm_inbox'] = (_) => ok([
            convRow(id: 'c1', unread: 2),
            convRow(id: 'c2', others: [profileRow(id: 'u-sam', handle: 'sam', name: 'Sam Park')], last: {
              'kind': 'text', 'body': 'On my way', 'removed': false, 'created_at': '2099-10-24T22:00:00Z', 'sender': profileRow(id: 'me', handle: 'dana'), 'is_mine': true,
            }),
          ]);
      await open(tester);
      expect(find.byKey(const Key('conversation-c1')), findsOneWidget);
      expect(find.descendant(of: find.byKey(const Key('conversation-c1')), matching: find.text('Bob Ray')), findsOneWidget);
      expect(find.descendant(of: find.byKey(const Key('conversation-c1')), matching: find.text('See you there')), findsOneWidget);
      expect(find.descendant(of: find.byKey(const Key('unread-c1')), matching: find.text('2')), findsOneWidget);
      expect(find.byKey(const Key('unread-c2')), findsNothing);
      expect(find.text('You: On my way'), findsOneWidget);
      expect(site.forRpc('dm_inbox').single.body, {'p_actor': 'me', 'p_box': 'main', 'p_limit': 30, 'p_before': null, 'p_before_id': null});
    });

    testWidgets('says what a shared thing or a removed message was, and who in a group', (tester) async {
      Map<String, dynamic> last(String kind, {bool removed = false, bool mine = false}) => {
            'kind': kind, 'body': null, 'removed': removed, 'created_at': '2099-10-24T22:00:00Z', 'sender': profileRow(id: 'u-bob', handle: 'bob', name: 'Bob Ray'), 'is_mine': mine,
          };
      site.rpcs['dm_inbox'] = (_) => ok([
            convRow(id: 'a', last: last('post')),
            convRow(id: 'b', last: last('event', mine: true)),
            convRow(id: 'c', last: last('venue')),
            convRow(id: 'd', last: last('booking')),
            convRow(id: 'e', kind: 'group', title: 'Crew', last: last('text', removed: true)),
          ]);
      await open(tester);
      expect(find.text('Shared a post'), findsOneWidget);
      expect(find.text('You: Shared an event'), findsOneWidget);
      expect(find.text('Shared a venue'), findsOneWidget);
      expect(find.text('Booking'), findsOneWidget);
      expect(find.text('Bob Ray: Message removed'), findsOneWidget);
    });

    testWidgets('a muted conversation and a booking conversation are marked', (tester) async {
      site.rpcs['dm_inbox'] = (_) => ok([convRow(id: 'm', muted: true), convRow(id: 'b', kind: 'booking', title: 'Club A, Fri 6 Nov', bookingId: 'bk1')]);
      await open(tester);
      expect(find.byIcon(Icons.notifications_off_outlined), findsOneWidget);
      expect(find.byIcon(Icons.confirmation_number_outlined), findsOneWidget);
    });

    testWidgets('nothing yet says so', (tester) async {
      site.rpcs['dm_inbox'] = (_) => ok(<Object>[]);
      await open(tester);
      expect(find.text('No messages yet'), findsOneWidget);
    });

    testWidgets('requests are in their own box, counted on the tab', (tester) async {
      site.rpcs['dm_unread'] = (_) => ok({'conversations': 0, 'requests': 2});
      site.rpcs['dm_inbox'] = (b) => ok(b['p_box'] == 'requests' ? [convRow(id: 'r1', status: 'request')] : <Object>[]);
      await open(tester);
      expect(find.text('Requests (2)'), findsOneWidget);
      await tester.tap(find.text('Requests (2)'));
      await tester.pumpAndSettle();
      expect(site.forRpc('dm_inbox').last.body['p_box'], 'requests');
      expect(find.byKey(const Key('conversation-r1')), findsOneWidget);
      await tester.tap(find.text('Messages').first);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('conversation-r1')), findsNothing);
      expect(find.text('No messages yet'), findsOneWidget);
    });

    testWidgets('no requests says so', (tester) async {
      site.rpcs['dm_inbox'] = (_) => ok(<Object>[]);
      await open(tester);
      await tester.tap(find.text('Requests'));
      await tester.pumpAndSettle();
      expect(find.text('No requests'), findsOneWidget);
    });

    testWidgets('a conversation opens on tap', (tester) async {
      site.rpcs['dm_inbox'] = (_) => ok([convRow(id: 'c1')]);
      site.rpcs['dm_conversation'] = (_) => ok(convRow(id: 'c1'));
      site.rpcs['dm_messages'] = (_) => ok(<Object>[]);
      site.rpcs['rules_status'] = (_) => ok({'version': 1, 'accepted': true});
      final router = await open(tester);
      await tester.tap(find.byKey(const Key('conversation-c1')));
      await tester.pumpAndSettle();
      expect(path(router), '/inbox/c1');
      expect(find.byKey(const Key('no-messages')), findsOneWidget);
      router.pop();
      await tester.pumpAndSettle();
      expect(site.forRpc('dm_inbox'), hasLength(2), reason: 'coming back looks again, so what was just read is no longer new');
    });

    testWidgets('a full page offers more, paged from the last one', (tester) async {
      site.rpcs['dm_inbox'] = (b) => ok(b['p_before'] == null ? [for (var i = 0; i < 30; i++) convRow(id: 'c$i', lastAt: '2099-10-24T23:${(59 - i).toString().padLeft(2, '0')}:00.5Z')] : [convRow(id: 'older')]);
      await open(tester, settle: false);
      await settleCalls(tester);
      await tester.drag(find.byKey(const Key('inbox-list')), const Offset(0, -3000));
      await tester.pump();
      await tester.tap(find.byKey(const Key('inbox-more')));
      await settleCalls(tester);
      expect(site.forRpc('dm_inbox').last.body, containsPair('p_before_id', 'c29'));
      expect(site.forRpc('dm_inbox').last.body['p_before'], isNotNull);
      expect(find.byKey(const Key('inbox-more')), findsNothing, reason: 'a short page is the last');
      await tester.drag(find.byKey(const Key('inbox-list')), const Offset(0, -3000));
      await tester.pump();
      expect(find.byKey(const Key('conversation-older')), findsOneWidget);
      await tester.drag(find.byKey(const Key('inbox-list')), const Offset(0, 6000));
      await tester.pump();
      expect(find.byKey(const Key('conversation-c0')), findsOneWidget, reason: 'the first page stays');
    });

    testWidgets('it looks for new messages by itself', (tester) async {
      var rows = [convRow(id: 'c1')];
      site.rpcs['dm_inbox'] = (_) => ok(rows);
      await open(tester);
      expect(find.byKey(const Key('conversation-c2')), findsNothing);
      rows = [convRow(id: 'c2', unread: 1), convRow(id: 'c1')];
      await tester.pump(const Duration(seconds: 16));
      await settleCalls(tester);
      expect(find.byKey(const Key('conversation-c2')), findsOneWidget);
      expect(find.byKey(const Key('conversation-c1')), findsOneWidget, reason: 'a refresh replaces the list, it does not add to it');
      expect(site.forRpc('dm_inbox'), hasLength(2));
      expect(site.forRpc('dm_unread').length, greaterThan(2), reason: 'the badge is read again after each look');
    });

    testWidgets('a failed load offers to try again; a quiet refresh that fails changes nothing', (tester) async {
      var fail = true;
      site.rpcs['dm_inbox'] = (_) => fail ? raised('Messages are busy.') : ok([convRow(id: 'c1')]);
      await open(tester);
      expect(find.text('Messages are busy.'), findsOneWidget);
      fail = false;
      await tester.tap(find.byKey(const Key('load-failed-retry')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('conversation-c1')), findsOneWidget);
      fail = true;
      await tester.pump(const Duration(seconds: 16));
      await settleCalls(tester);
      expect(find.byKey(const Key('conversation-c1')), findsOneWidget, reason: 'the list stays when a refresh fails');
      expect(find.text('Messages are busy.'), findsNothing);
    });

    testWidgets('messages switched off says coming soon and asks nothing', (tester) async {
      await open(tester, features: const {'social': true});
      expect(find.text('Coming soon'), findsOneWidget);
      expect(site.forRpc('dm_inbox'), isEmpty);
    });

    testWidgets('the bell shows no count when nothing is new', (tester) async {
      site.rpcs['dm_inbox'] = (_) => ok(<Object>[]);
      await open(tester);
      expect(find.byKey(const Key('open-notifications')), findsOneWidget);
      expect(find.byKey(const Key('notifications-badge')), findsNothing);
    });

    testWidgets('the bell opens notifications and counts what is new; the pencil starts a message', (tester) async {
      site.rpcs['dm_inbox'] = (_) => ok(<Object>[]);
      site.rpcs['notifications_unread'] = (_) => ok(4);
      site.rpcs['notifications_list'] = (_) => ok(<Object>[]);
      site.rpcs['profile_search'] = (_) => ok(<Object>[]);
      final router = await open(tester);
      expect(tester.widget<Text>(find.byKey(const Key('notifications-badge'))).data, '4');
      await tester.tap(find.byKey(const Key('open-notifications')));
      await tester.pumpAndSettle();
      expect(path(router), '/notifications');
      router.pop();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('new-message')));
      await tester.pumpAndSettle();
      expect(path(router), '/inbox/new');
    });
  });

  group('notifications', () {
    testWidgets('say who did what, newest first, and mark everything read', (tester) async {
      site.rpcs['notifications_list'] = (_) => ok([
            notificationRow(id: 'n1', kind: 'follow'),
            notificationRow(id: 'n2', kind: 'like', post: postRow(id: 'p1'), actor: profileRow(id: 'u-sam', handle: 'sam', name: 'Sam Park')),
            notificationRow(id: 'n3', kind: 'comment', commentBody: 'Great night!', post: postRow(id: 'p1')),
            notificationRow(id: 'n4', kind: 'reply', commentBody: 'Agreed'),
            notificationRow(id: 'n5', kind: 'tag', post: postRow(id: 'p2')),
            notificationRow(id: 'n6', kind: 'follow_request'),
            notificationRow(id: 'n7', kind: 'follow_accepted'),
            notificationRow(id: 'n8', kind: 'review_reply'),
          ]);
      site.rpcs['notifications_read'] = (_) => ok({'unread': 0});
      await open(tester, at: '/notifications');
      String sentence(String id) => tester.widget<Text>(find.descendant(of: find.byKey(Key('notification-$id')), matching: find.byWidgetPredicate((w) => w is Text && w.textSpan != null))).textSpan!.toPlainText();
      expect(sentence('n1'), 'Bob Ray started following you.');
      expect(sentence('n2'), 'Sam Park liked your post.');
      expect(sentence('n3'), 'Bob Ray commented: Great night!');
      expect(sentence('n4'), 'Bob Ray replied to your comment: Agreed');
      expect(sentence('n5'), 'Bob Ray tagged you in a post.');
      expect(sentence('n6'), 'Bob Ray asked to follow you.');
      expect(sentence('n7'), 'Bob Ray accepted your request to follow.');
      expect(sentence('n8'), 'Bob Ray replied to your review.');
      expect(site.forRpc('notifications_list').single.body, {'p_actor': 'me', 'p_limit': 30, 'p_before': null, 'p_before_id': null});
      expect(site.forRpc('notifications_read').single.body, {'p_actor': 'me'});
    });

    testWidgets('nothing new asks nothing to be marked', (tester) async {
      site.rpcs['notifications_list'] = (_) => ok([notificationRow(id: 'n1', read: true)]);
      site.rpcs['notifications_read'] = (_) => ok({'unread': 0});
      await open(tester, at: '/notifications');
      expect(find.byKey(const Key('notification-n1')), findsOneWidget);
      expect(site.forRpc('notifications_read'), isEmpty);
    });

    testWidgets('empty says so', (tester) async {
      site.rpcs['notifications_list'] = (_) => ok(<Object>[]);
      await open(tester, at: '/notifications');
      expect(find.text('Nothing yet'), findsOneWidget);
    });

    testWidgets('tapping goes to the post, the requests or the person', (tester) async {
      site.rpcs['notifications_list'] = (_) => ok([
            notificationRow(id: 'n1', kind: 'like', post: postRow(id: 'p1')),
            notificationRow(id: 'n2', kind: 'follow_request', actor: profileRow(id: 'u-sam', handle: 'sam', name: 'Sam Park')),
            notificationRow(id: 'n3', kind: 'follow', actor: profileRow(id: 'u-ann', handle: 'ann', name: 'Ann Lee')),
            notificationRow(id: 'n4', kind: 'comment', commentBody: 'x', actor: profileRow(id: 'u-zed', handle: 'zed', name: 'Zed')),
          ]);
      site.rpcs['notifications_read'] = (_) => ok({'unread': 0});
      site.rpcs['post_get'] = (_) => ok(postRow(id: 'p1'));
      site.rpcs['comment_list'] = (_) => ok(<Object>[]);
      site.rpcs['profile_get'] = (b) => ok(profileRow(id: 'x', handle: (b['p_handle'] as String?) ?? 'x'));
      site.rpcs['follow_requests'] = (_) => ok(<Object>[]);
      final router = await open(tester, at: '/notifications');
      Future<void> tapAndBack(String id) async {
        await tester.tap(find.byKey(Key('notification-$id')));
        await tester.pumpAndSettle();
      }

      await tapAndBack('n1');
      expect(path(router), '/post/p1');
      router.pop();
      await tester.pumpAndSettle();
      await tapAndBack('n2');
      expect(path(router), '/people/requests');
      router.pop();
      await tester.pumpAndSettle();
      await tapAndBack('n3');
      expect(path(router), '/u/ann');
      router.pop();
      await tester.pumpAndSettle();
      await tapAndBack('n4');
      expect(path(router), '/u/zed', reason: 'a comment on a post that is gone still opens the person');
    });

    testWidgets('a failed load offers to try again; a full page offers more', (tester) async {
      var fail = true;
      site.rpcs['notifications_read'] = (_) => ok({'unread': 0});
      site.rpcs['notifications_list'] = (b) => fail
          ? raised('Notifications are busy.')
          : ok(b['p_before'] == null ? [for (var i = 0; i < 30; i++) notificationRow(id: 'n$i', createdAt: '2099-10-24T22:${(59 - i).toString().padLeft(2, '0')}:00.5Z')] : [notificationRow(id: 'old')]);
      await open(tester, at: '/notifications');
      expect(find.text('Notifications are busy.'), findsOneWidget);
      fail = false;
      await tester.tap(find.byKey(const Key('load-failed-retry')));
      await settleCalls(tester);
      await tester.drag(find.byKey(const Key('notifications-list')), const Offset(0, -3000));
      await tester.pump();
      await tester.tap(find.byKey(const Key('notifications-more')));
      await settleCalls(tester);
      expect(site.forRpc('notifications_list').last.body, containsPair('p_before_id', 'n29'));
      expect(site.forRpc('notifications_read'), hasLength(1), reason: 'marked read once, on the first page');
      await tester.drag(find.byKey(const Key('notifications-list')), const Offset(0, -3000));
      await tester.pump();
      expect(find.byKey(const Key('notification-old')), findsOneWidget);
    });
  });
}
