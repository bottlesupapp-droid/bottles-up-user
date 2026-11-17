import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';
import '../support/pump_social.dart';

void main() {
  late FakeWebsite site;
  late bool rulesAccepted;
  late Map<String, dynamic> head;
  late List<Map<String, dynamic>> messages;

  setUp(() {
    site = FakeWebsite();
    rulesAccepted = true;
    head = convRow(id: 'c1');
    messages = [];
    site.rpcs['dm_conversation'] = (_) => ok(head);
    site.rpcs['dm_messages'] = (_) => ok(messages);
    site.rpcs['dm_mark_read'] = (_) => ok({'read': true});
    site.rpcs['dm_unread'] = (_) => ok({'conversations': 0, 'requests': 0});
    site.rpcs['notifications_unread'] = (_) => ok(0);
    site.rpcs['dm_inbox'] = (_) => ok(<Object>[]);
    site.rpcs['rules_status'] = (_) => ok({'version': 1, 'accepted': rulesAccepted});
    site.rpcs['rules_accept'] = (_) {
      rulesAccepted = true;
      return ok({'version': 1, 'accepted': true});
    };
  });

  const on = {'social': true, 'inbox': true};

  Future<GoRouter> open(WidgetTester tester, {String at = '/inbox/c1', bool settle = true}) => openSocial(tester, site, at, features: on, settle: settle);

  String path(GoRouter r) => r.routerDelegate.currentConfiguration.last.matchedLocation;
  Finder field() => find.byKey(const Key('message-field'));
  String typed(WidgetTester tester) => tester.widget<TextField>(field()).controller!.text;

  group('reading', () {
    testWidgets('shows the person\'s name, the messages with mine on the right, and marks them read', (tester) async {
      messages = [dmRow(id: 'm2', body: 'Cool, see you', mine: true), dmRow(id: 'm1', body: 'Hello there')];
      await open(tester);
      expect(tester.widget<Text>(find.byKey(const Key('conversation-title'))).data, 'Bob Ray');
      expect(find.descendant(of: find.byKey(const Key('message-m1')), matching: find.text('Bob Ray')), findsNothing, reason: 'in a one-to-one the name is in the title, not on each message');
      expect(find.byKey(const Key('body-m1')), findsOneWidget);
      expect(find.byKey(const Key('body-m2')), findsOneWidget);
      expect(tester.getTopRight(find.byKey(const Key('message-m2'))).dx, greaterThan(tester.getTopRight(find.byKey(const Key('message-m1'))).dx));
      expect(tester.getBottomLeft(find.byKey(const Key('message-m1'))).dy, lessThan(tester.getBottomLeft(find.byKey(const Key('message-m2'))).dy), reason: 'newest at the bottom');
      expect(site.forRpc('dm_conversation').single.body, {'p_actor': 'me', 'p_conversation': 'c1'});
      expect(site.forRpc('dm_messages').single.body, {'p_actor': 'me', 'p_conversation': 'c1', 'p_limit': 30, 'p_before': null, 'p_before_id': null});
      expect(site.forRpc('dm_mark_read').single.body, {'p_actor': 'me', 'p_conversation': 'c1'});
    });

    testWidgets('an empty conversation says hello; nothing is marked read', (tester) async {
      await open(tester);
      expect(find.byKey(const Key('no-messages')), findsOneWidget);
      expect(site.forRpc('dm_mark_read'), isEmpty);
    });

    testWidgets('in a group other people\'s messages say who sent them', (tester) async {
      head = convRow(id: 'c1', kind: 'group', title: 'Friday crew', members: 3);
      messages = [dmRow(id: 'm2', body: 'Mine', mine: true), dmRow(id: 'm1', body: 'Theirs', sender: profileRow(id: 'u-sam', handle: 'sam', name: 'Sam Park'))];
      await open(tester);
      expect(tester.widget<Text>(find.byKey(const Key('conversation-title'))).data, 'Friday crew');
      expect(find.descendant(of: find.byKey(const Key('message-m1')), matching: find.text('Sam Park')), findsOneWidget);
      expect(find.descendant(of: find.byKey(const Key('message-m2')), matching: find.text('Dana Lee')), findsNothing);
    });

    testWidgets('a removed message says so and keeps no words', (tester) async {
      messages = [dmRow(id: 'm1', body: null, removed: true)];
      await open(tester);
      expect(find.byKey(const Key('removed-m1')), findsOneWidget);
      expect(find.byKey(const Key('body-m1')), findsNothing);
    });

    testWidgets('a conversation that is not available says why and offers to try again', (tester) async {
      site.rpcs['dm_conversation'] = (_) => raised('This conversation isn\'t available.');
      site.rpcs['dm_messages'] = (_) => raised('This conversation isn\'t available.');
      await open(tester);
      expect(find.text('This conversation isn\'t available.'), findsOneWidget);
      expect(find.byKey(const Key('load-failed-retry')), findsOneWidget);
      await tester.pump(const Duration(seconds: 12));
      await settleCalls(tester);
      expect(site.forRpc('dm_messages'), hasLength(1), reason: 'it does not keep asking about a conversation that is not there');
    });

    testWidgets('earlier messages are fetched from the oldest one, page after page', (tester) async {
      String at(String hour, int i) => '2099-10-24T$hour:${(59 - i).toString().padLeft(2, '0')}:00.5Z';
      messages = [for (var i = 0; i < 30; i++) dmRow(id: 'm$i', body: 'msg $i', createdAt: at('22', i))];
      site.rpcs['dm_messages'] = (b) {
        final before = b['p_before_id'];
        if (before == null) return ok(messages);
        if (before == 'm29') return ok([for (var i = 0; i < 30; i++) dmRow(id: 'o$i', body: 'old $i', createdAt: at('21', i))]);
        return ok([dmRow(id: 'oldest', body: 'long ago', createdAt: '2099-10-24T20:00:00Z')]);
      };
      await open(tester, settle: false);
      await settleCalls(tester);
      Future<void> top() async {
        await tester.drag(find.byKey(const Key('message-list')), const Offset(0, 9000));
        await tester.pump();
      }

      await top();
      await tester.tap(find.byKey(const Key('earlier')));
      await settleCalls(tester);
      expect(site.forRpc('dm_messages').last.body, containsPair('p_before_id', 'm29'));
      expect(site.forRpc('dm_messages').last.body['p_before'], isNotNull);
      await top();
      expect(find.byKey(const Key('earlier')), findsOneWidget, reason: 'a full page may be followed by another');
      await tester.tap(find.byKey(const Key('earlier')));
      await settleCalls(tester);
      expect(site.forRpc('dm_messages').last.body, containsPair('p_before_id', 'o29'));
      await top();
      expect(find.byKey(const Key('body-oldest')), findsOneWidget);
      expect(find.byKey(const Key('earlier')), findsNothing, reason: 'a short page is the last');
    });

    testWidgets('looks for new messages every few seconds without repeating or losing any, and sees one taken back', (tester) async {
      messages = [dmRow(id: 'm1', body: 'First'), ];
      await open(tester);
      expect(site.forRpc('dm_messages'), hasLength(1));
      messages = [dmRow(id: 'm2', body: 'Second'), dmRow(id: 'm1', body: null, removed: true)];
      await tester.pump(const Duration(seconds: 6));
      await settleCalls(tester);
      expect(site.forRpc('dm_messages'), hasLength(2));
      expect(find.byKey(const Key('body-m2')), findsOneWidget);
      expect(find.byKey(const Key('message-m2')), findsOneWidget);
      expect(find.byKey(const Key('removed-m1')), findsOneWidget, reason: 'the first message is shown as removed in place');
      expect(find.byKey(const Key('message-m1')), findsOneWidget);
    });

    testWidgets('a failed refresh leaves what is shown alone', (tester) async {
      messages = [dmRow(id: 'm1', body: 'First')];
      await open(tester);
      site.rpcs['dm_messages'] = (_) => raised('Busy.');
      await tester.pump(const Duration(seconds: 6));
      await settleCalls(tester);
      expect(find.byKey(const Key('body-m1')), findsOneWidget);
      expect(find.text('Busy.'), findsNothing);
    });
  });

  group('sending', () {
    testWidgets('a message goes with a key, appears at the bottom and clears the box', (tester) async {
      site.rpcs['dm_send'] = (b) => ok(dmRow(id: 'new1', body: b['p_body'] as String, mine: true));
      await open(tester);
      await tester.enterText(field(), '  On my way  ');
      await tester.tap(find.byKey(const Key('send-message')));
      await tester.pumpAndSettle();
      final sent = site.forRpc('dm_send').single.body;
      expect(sent['p_actor'], 'me');
      expect(sent['p_conversation'], 'c1');
      expect(sent['p_body'], 'On my way');
      expect(sent['p_client_key'], matches(RegExp(r'^[0-9a-f]{24}$')));
      expect(find.byKey(const Key('body-new1')), findsOneWidget);
      expect(typed(tester), '');
      expect(find.byKey(const Key('no-messages')), findsNothing);
    });

    testWidgets('nothing typed sends nothing', (tester) async {
      await open(tester);
      await tester.enterText(field(), '   ');
      await tester.tap(find.byKey(const Key('send-message')));
      await tester.pumpAndSettle();
      expect(site.forRpc('dm_send'), isEmpty);
    });

    testWidgets('a refusal is shown, the words stay, and trying again uses the same key', (tester) async {
      var refuse = true;
      site.rpcs['dm_send'] = (b) => refuse ? raised('Wait for them to reply before sending more.') : ok(dmRow(id: 'new1', body: b['p_body'] as String, mine: true));
      await open(tester);
      await tester.enterText(field(), 'Hello?');
      await tester.tap(find.byKey(const Key('send-message')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('send-problem')), findsOneWidget);
      expect(find.text('Wait for them to reply before sending more.'), findsOneWidget);
      expect(typed(tester), 'Hello?');
      refuse = false;
      await tester.tap(find.byKey(const Key('send-message')));
      await tester.pumpAndSettle();
      final calls = site.forRpc('dm_send');
      expect(calls, hasLength(2));
      expect(calls[1].body['p_client_key'], calls[0].body['p_client_key'], reason: 'a retry is the same message to the website');
      expect(find.byKey(const Key('send-problem')), findsNothing);
      await tester.enterText(field(), 'Next');
      await tester.tap(find.byKey(const Key('send-message')));
      await tester.pumpAndSettle();
      expect(site.forRpc('dm_send')[2].body['p_client_key'], isNot(calls[0].body['p_client_key']), reason: 'a new message has a new key');
    });

    testWidgets('the community rules come first, once', (tester) async {
      rulesAccepted = false;
      site.rpcs['dm_send'] = (b) => ok(dmRow(id: 'new1', body: b['p_body'] as String, mine: true));
      await open(tester);
      await tester.enterText(field(), 'Hi');
      await tester.tap(find.byKey(const Key('send-message')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('rules-text')), findsOneWidget);
      expect(site.forRpc('dm_send'), isEmpty);
      await tester.tap(find.byKey(const Key('rules-decline')));
      await tester.pumpAndSettle();
      expect(site.forRpc('dm_send'), isEmpty);
      expect(typed(tester), 'Hi');
      await tester.tap(find.byKey(const Key('send-message')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('rules-accept')));
      await tester.pumpAndSettle();
      expect(site.forRpc('dm_send'), hasLength(1));
      expect(site.forRpc('rules_accept'), hasLength(1));
    });
  });

  group('removing a message', () {
    testWidgets('long-press your own to remove it; the list is read again', (tester) async {
      messages = [dmRow(id: 'm1', body: 'Oops', mine: true)];
      site.rpcs['dm_delete_message'] = (_) {
        messages = [dmRow(id: 'm1', body: null, removed: true, mine: true)];
        return ok({'removed': true});
      };
      await open(tester);
      await tester.longPress(find.byKey(const Key('message-m1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('remove-message')));
      await tester.pumpAndSettle();
      expect(site.forRpc('dm_delete_message').single.body, {'p_actor': 'me', 'p_message': 'm1'});
      expect(find.byKey(const Key('removed-m1')), findsOneWidget);
    });

    testWidgets('backing out of the sheet removes nothing', (tester) async {
      messages = [dmRow(id: 'm1', body: 'Keep', mine: true)];
      await open(tester);
      await tester.longPress(find.byKey(const Key('message-m1')));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(400, 100));
      await tester.pumpAndSettle();
      expect(site.forRpc('dm_delete_message'), isEmpty);
      expect(find.byKey(const Key('body-m1')), findsOneWidget);
    });

    testWidgets('someone else\'s message and one already removed have nothing to remove', (tester) async {
      messages = [dmRow(id: 'm2', body: null, removed: true, mine: true), dmRow(id: 'm1', body: 'Theirs')];
      await open(tester);
      await tester.longPress(find.byKey(const Key('message-m1')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('remove-message')), findsNothing);
      await tester.longPress(find.byKey(const Key('message-m2')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('remove-message')), findsNothing);
    });

    testWidgets('a refusal is shown', (tester) async {
      messages = [dmRow(id: 'm1', body: 'Oops', mine: true)];
      site.rpcs['dm_delete_message'] = (_) => raised('You can only remove your own messages.');
      await open(tester);
      await tester.longPress(find.byKey(const Key('message-m1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('remove-message')));
      await tester.pumpAndSettle();
      expect(find.text('You can only remove your own messages.'), findsOneWidget);
    });
  });

  group('a request', () {
    setUp(() => head = convRow(id: 'c1', status: 'request'));

    testWidgets('can be accepted or declined, and says they will not be told', (tester) async {
      await open(tester);
      expect(find.byKey(const Key('request-bar')), findsOneWidget);
      expect(find.textContaining('They will not be told'), findsOneWidget);
    });

    testWidgets('accepting moves it to the messages and the bar goes', (tester) async {
      site.rpcs['dm_answer_request'] = (_) {
        head = convRow(id: 'c1');
        return ok({'accepted': true});
      };
      await open(tester);
      await tester.tap(find.byKey(const Key('accept-request')));
      await tester.pumpAndSettle();
      expect(site.forRpc('dm_answer_request').single.body, {'p_actor': 'me', 'p_conversation': 'c1', 'p_accept': true});
      expect(find.byKey(const Key('request-bar')), findsNothing);
    });

    testWidgets('declining sends the person back to the inbox', (tester) async {
      site.rpcs['dm_answer_request'] = (_) => ok({'accepted': false});
      final router = await open(tester);
      await tester.tap(find.byKey(const Key('decline-request')));
      await tester.pumpAndSettle();
      expect(site.forRpc('dm_answer_request').single.body['p_accept'], false);
      expect(path(router), '/inbox');
    });

    testWidgets('replying to it accepts it, so the head is read again', (tester) async {
      site.rpcs['dm_send'] = (b) {
        head = convRow(id: 'c1');
        return ok(dmRow(id: 'new1', body: b['p_body'] as String, mine: true));
      };
      await open(tester);
      await tester.enterText(field(), 'Hi!');
      await tester.tap(find.byKey(const Key('send-message')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('request-bar')), findsNothing);
      expect(site.forRpc('dm_conversation'), hasLength(2));
    });

    testWidgets('a refusal when answering is shown', (tester) async {
      site.rpcs['dm_answer_request'] = (_) => raised('This request has already been answered.');
      await open(tester);
      await tester.tap(find.byKey(const Key('accept-request')));
      await tester.pumpAndSettle();
      expect(find.text('This request has already been answered.'), findsOneWidget);
    });
  });

  group('shared things', () {
    testWidgets('a post, an event, a venue and a booking show a card; the post and event open', (tester) async {
      messages = [
        dmRow(id: 'm4', kind: 'booking', body: null, ref: {'available': true, 'id': 'b1', 'venue': 'Club A', 'night': '2099-10-25', 'table': 'Booth 1', 'guests': 4}),
        dmRow(id: 'm3', kind: 'venue', body: null, ref: {'available': true, 'id': 'v1', 'name': 'Club A', 'address': '1 King St W'}),
        dmRow(id: 'm2', kind: 'event', body: 'Come!', ref: {'available': true, 'id': 'e1', 'title': 'Friday Night', 'venue_name': 'Club A', 'starts_at': '2099-10-25T22:00:00Z'}),
        dmRow(id: 'm1', kind: 'post', body: null, ref: {'available': true, 'post': postRow(id: 'p1', caption: 'Look at this')}),
      ];
      site.rpcs['post_get'] = (_) => ok(postRow(id: 'p1', caption: 'Look at this'));
      site.rpcs['comment_list'] = (_) => ok(<Object>[]);
      final router = await open(tester);
      expect(find.byKey(const Key('ref-booking-m4')), findsOneWidget);
      expect(find.byKey(const Key('ref-venue-m3')), findsOneWidget);
      expect(find.byKey(const Key('ref-event-m2')), findsOneWidget);
      expect(find.text('Friday Night'), findsOneWidget);
      expect(find.text('Come!'), findsOneWidget, reason: 'the note beside a share is shown');
      await tester.tap(find.byKey(const Key('ref-post-m1')));
      await tester.pumpAndSettle();
      expect(path(router), '/post/p1');
    });

    testWidgets('something you may not see is said so and cannot be opened', (tester) async {
      messages = [dmRow(id: 'm1', kind: 'post', body: null, ref: {'available': false})];
      await open(tester);
      expect(find.byKey(const Key('ref-unavailable-m1')), findsOneWidget);
      expect(find.text('This is not available to you'), findsOneWidget);
      expect(find.byKey(const Key('ref-post-m1')), findsNothing);
    });
  });

  group('the details button', () {
    testWidgets('opens the details of a direct or group conversation', (tester) async {
      site.rpcs['dm_people'] = (_) => ok([{...profileRow(id: 'me', handle: 'dana'), 'role': 'member', 'status': 'active'}]);
      final router = await open(tester);
      await tester.tap(find.byKey(const Key('conversation-info')));
      await tester.pumpAndSettle();
      expect(path(router), '/inbox/c1/info');
    });

    testWidgets('a booking conversation has none', (tester) async {
      head = convRow(id: 'c1', kind: 'booking', title: 'Club A', bookingId: 'bk1');
      await open(tester);
      expect(find.byKey(const Key('conversation-info')), findsNothing);
    });
  });
}
