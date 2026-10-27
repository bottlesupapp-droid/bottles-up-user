import 'package:bottles_up_user/site/models/inbox.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';

void main() {
  group('conversations', () {
    test('a direct one is called after the other person', () {
      final c = parseConversation(convRow(unread: 3, muted: true))!;
      expect(c.kind, ConversationKind.direct);
      expect(c.displayTitle, 'Bob Ray');
      expect(c.unread, 3);
      expect(c.muted, isTrue);
      expect(c.isRequest, isFalse);
      expect(c.last!.body, 'See you there');
      expect(c.last!.isMine, isFalse);
    });

    test('a group has its own name; a request is marked', () {
      final g = parseConversation(convRow(kind: 'group', title: 'Friday crew', members: 5))!;
      expect(g.displayTitle, 'Friday crew');
      expect(g.memberCount, 5);
      expect(parseConversation(convRow(status: 'request'))!.isRequest, isTrue);
    });

    test('a conversation that does not say how many are in it is a pair; the last message can be a removed one', () {
      final c = parseConversation(convRow()..remove('member_count'))!;
      expect(c.memberCount, 2);
      final r = parseConversation(convRow(last: {'kind': 'text', 'body': null, 'removed': true, 'created_at': '2099-10-24T23:00:00Z', 'sender': profileRow(id: 'u-bob', handle: 'bob'), 'is_mine': true}))!;
      expect(r.last!.removed, isTrue);
      expect(r.last!.isMine, isTrue);
      expect(parseConversation(convRow())!.last!.removed, isFalse);
    });

    test('one with no title and nobody else still has a name', () {
      expect(parseConversation(convRow(others: const []))!.displayTitle, 'Conversation');
    });

    test('without an id, a kind or a time it is dropped; a last message that cannot be read is left off', () {
      expect(parseConversation(convRow()..remove('id')), isNull);
      expect(parseConversation(convRow(kind: 'channel')), isNull);
      expect(parseConversation(convRow(lastAt: 'soon')), isNull);
      expect(parseConversation('x'), isNull);
      final c = parseConversation({...convRow(), 'last': {'kind': 'text', 'body': 'x'}})!;
      expect(c.last, isNull);
      expect([for (final c in parseConversations([convRow(id: 'a'), 1, convRow(id: 'b')])) c.id], ['a', 'b']);
    });
  });

  group('messages', () {
    test('a text message and a removed one', () {
      final m = parseDmMessage(dmRow(mine: true))!;
      expect(m.body, 'Hello');
      expect(m.isMine, isTrue);
      expect(m.ref, isNull);
      final r = parseDmMessage(dmRow(body: null, removed: true))!;
      expect(r.removed, isTrue);
      expect(r.body, isNull);
    });

    test('a shared post, event, venue and booking', () {
      final post = parseDmMessage(dmRow(kind: 'post', body: 'look', ref: {'available': true, 'post': postRow(id: 'p1')}))!;
      expect(post.ref!.post!.id, 'p1');
      expect(post.ref!.available, isTrue);
      final ev = parseDmMessage(dmRow(kind: 'event', body: null, ref: {'available': true, 'id': 'e1', 'title': 'Friday Night', 'venue_name': 'Club A', 'starts_at': '2099-10-25T22:00:00Z'}))!;
      expect(ev.ref!.title, 'Friday Night');
      expect(ev.ref!.subtitle, 'Club A');
      final venue = parseDmMessage(dmRow(kind: 'venue', body: null, ref: {'available': true, 'id': 'v1', 'name': 'Club A', 'address': '1 King St W'}))!;
      expect(venue.ref!.title, 'Club A');
      final booking = parseDmMessage(dmRow(kind: 'booking', body: null, ref: {'available': true, 'id': 'b1', 'venue': 'Club A', 'night': '2099-10-25', 'table': 'Booth 1', 'guests': 4, 'status': 'paid'}))!;
      expect(booking.ref!.subtitle, 'Booth 1 · 4 guests');
      expect(booking.ref!.when, '2099-10-25');
    });

    test('a share the reader may not see is marked unavailable and carries nothing', () {
      final m = parseDmMessage(dmRow(kind: 'post', body: null, ref: {'available': false}))!;
      expect(m.ref!.available, isFalse);
      expect(m.ref!.post, isNull);
      expect(parseDmMessage(dmRow(kind: 'post', body: null, ref: {'available': true, 'post': {'junk': 1}}))!.ref!.available, isFalse, reason: 'a post that cannot be read is unavailable');
    });

    test('a share marked unavailable carries nothing, whatever else came with it', () {
      final m = parseDmMessage(dmRow(kind: 'event', body: null, ref: {'available': false, 'id': 'e1', 'title': 'Secret party', 'venue_name': 'Club A'}))!;
      expect(m.ref!.available, isFalse);
      expect(m.ref!.title, isNull);
      expect(m.ref!.id, isNull);
      expect(m.ref!.subtitle, isNull);
    });

    test('one booking guest is singular', () {
      final b = parseDmMessage(dmRow(kind: 'booking', body: null, ref: {'available': true, 'id': 'b1', 'venue': 'Club A', 'guests': 1}))!;
      expect(b.ref!.subtitle, '1 guest');
    });

    test('without an id, a sender, a kind or a time it is dropped', () {
      expect(parseDmMessage(dmRow()..remove('id')), isNull);
      expect(parseDmMessage(dmRow()..remove('sender')), isNull);
      expect(parseDmMessage({...dmRow(), 'created_at': 'x'}), isNull);
      expect([for (final m in parseDmMessages([dmRow(id: 'a'), 'x', dmRow(id: 'b')])) m.id], ['a', 'b']);
    });
  });

  test('people in a conversation', () {
    final people = parseDmPeople([
      {...profileRow(id: 'a', handle: 'ann'), 'role': 'admin', 'status': 'active'},
      {...profileRow(id: 'b', handle: 'bob'), 'role': 'member', 'status': 'request'},
      'junk',
    ]);
    expect(people, hasLength(2));
    expect(people[0].isAdmin, isTrue);
    expect(people[1].pending, isTrue);
  });

  test('the badge', () {
    final c = parseInboxCounts({'conversations': 2, 'requests': 3});
    expect(c.badge, 5);
    expect(parseInboxCounts(null).badge, 0);
    expect(parseInboxCounts({'conversations': 'many'}).conversations, 0);
  });

  group('notifications', () {
    test('every kind is read', () {
      const kinds = {
        'follow': NotificationKind.follow,
        'follow_request': NotificationKind.followRequest,
        'follow_accepted': NotificationKind.followAccepted,
        'like': NotificationKind.like,
        'comment': NotificationKind.comment,
        'reply': NotificationKind.reply,
        'tag': NotificationKind.tag,
        'review_reply': NotificationKind.reviewReply,
      };
      for (final e in kinds.entries) {
        expect(parseNotification(notificationRow(kind: e.key))!.kind, e.value, reason: e.key);
      }
    });

    test('with its post, words and follow-back', () {
      final n = parseNotification(notificationRow(kind: 'comment', post: postRow(id: 'p1'), commentBody: 'Great!', read: true, followsBack: true))!;
      expect(n.post!.id, 'p1');
      expect(n.commentBody, 'Great!');
      expect(n.read, isTrue);
      expect(n.followsBack, isTrue);
    });

    test('an unknown kind or a missing actor is dropped', () {
      expect(parseNotification(notificationRow(kind: 'poke')), isNull);
      expect(parseNotification(notificationRow()..remove('actor')), isNull);
      expect(parseNotification({...notificationRow(), 'created_at': 'x'}), isNull);
      expect([for (final n in parseNotifications([notificationRow(id: 'a'), 1, notificationRow(id: 'b')])) n.id], ['a', 'b']);
    });
  });
}
