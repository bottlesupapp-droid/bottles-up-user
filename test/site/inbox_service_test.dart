import 'package:bottles_up_user/site/services/inbox_service.dart';
import 'package:bottles_up_user/site/site_error.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';

void main() {
  late FakeWebsite site;
  late InboxService service;

  setUp(() {
    site = FakeWebsite();
    service = InboxService(site.client);
  });

  Matcher sentence(String s) => throwsA(isA<SiteException>().having((e) => e.message, 'message', s));

  test('the inbox, in two boxes, paged to the microsecond', () async {
    site.rpcs['dm_inbox'] = (_) => ok([convRow(id: 'a', lastAt: '2099-10-24T23:00:00.123456Z')]);
    final first = await service.inbox(actor: 'me');
    expect(site.forRpc('dm_inbox').single.body, {'p_actor': 'me', 'p_box': 'main', 'p_limit': 30, 'p_before': null, 'p_before_id': null});
    await service.inbox(actor: 'me', requests: true, after: first.last);
    expect(site.forRpc('dm_inbox').last.body, containsPair('p_box', 'requests'));
    expect(site.forRpc('dm_inbox').last.body, containsPair('p_before', '2099-10-24T23:00:00.123456Z'));
    expect(site.forRpc('dm_inbox').last.body, containsPair('p_before_id', 'a'));
  });

  test('one conversation', () async {
    site.rpcs['dm_conversation'] = (_) => ok(convRow(id: 'c9', kind: 'group', title: 'Crew'));
    expect((await service.conversation(actor: 'me', id: 'c9')).displayTitle, 'Crew');
    site.rpcs['dm_conversation'] = (_) => raised('This conversation isn\'t available.');
    await expectLater(service.conversation(actor: 'me', id: 'c9'), sentence('This conversation isn\'t available.'));
    site.rpcs['dm_conversation'] = (_) => ok({'junk': true});
    await expectLater(service.conversation(actor: 'me', id: 'c9'), throwsA(isA<SiteException>()));
  });

  test('the badge is a quiet read', () async {
    site.rpcs['dm_unread'] = (_) => ok({'conversations': 2, 'requests': 1});
    expect((await service.counts('me')).badge, 3);
    site.networkDown = true;
    expect((await service.counts('me')).badge, 0);
    expect(await service.unreadNotifications('me'), 0);
  });

  test('starting a direct, group and booking conversation answers the id', () async {
    site.rpcs['dm_start_direct'] = (_) => ok({'id': 'd1'});
    site.rpcs['dm_start_group'] = (_) => ok({'id': 'g1'});
    site.rpcs['dm_start_booking'] = (_) => ok({'id': 'b1'});
    expect(await service.startDirect(actor: 'me', other: 'o'), 'd1');
    expect(await service.startGroup(actor: 'me', title: '  Crew ', members: ['a', 'b']), 'g1');
    expect(await service.startBooking(actor: 'me', booking: 'bk'), 'b1');
    expect(site.forRpc('dm_start_group').single.body, {'p_actor': 'me', 'p_title': 'Crew', 'p_members': ['a', 'b']});
    expect(site.forRpc('dm_start_booking').single.body, {'p_actor': 'me', 'p_booking': 'bk'});
    site.rpcs['dm_start_direct'] = (_) => ok({'oops': 1});
    await expectLater(service.startDirect(actor: 'me', other: 'o'), throwsA(isA<SiteException>()));
  });

  test('the website\'s refusals are shown', () async {
    site.rpcs['dm_start_direct'] = (_) => raised('Messages are not open yet.');
    await expectLater(service.startDirect(actor: 'me', other: 'o'), sentence('Messages are not open yet.'));
    site.rpcs['dm_start_booking'] = (_) => raised('You can only message about a booking you made.');
    await expectLater(service.startBooking(actor: 'me', booking: 'x'), sentence('You can only message about a booking you made.'));
  });

  test('messages are paged by time and id', () async {
    site.rpcs['dm_messages'] = (_) => ok([dmRow(id: 'm1', createdAt: '2099-10-24T23:00:00.5Z')]);
    final first = await service.messages(actor: 'me', conversation: 'c1');
    expect(site.forRpc('dm_messages').single.body, {'p_actor': 'me', 'p_conversation': 'c1', 'p_limit': 30, 'p_before': null, 'p_before_id': null});
    await service.messages(actor: 'me', conversation: 'c1', before: first.last);
    expect(site.forRpc('dm_messages').last.body['p_before_id'], 'm1');
  });

  test('sending a message, a share, with a key', () async {
    site.rpcs['dm_send'] = (_) => ok(dmRow(id: 'new', mine: true));
    final m = await service.send(actor: 'me', conversation: 'c1', body: '  Hi  ', clientKey: 'k1');
    expect(m.id, 'new');
    expect(site.forRpc('dm_send').single.body, {'p_actor': 'me', 'p_conversation': 'c1', 'p_body': 'Hi', 'p_client_key': 'k1', 'p_ref_kind': null, 'p_ref_id': null});
    await service.send(actor: 'me', conversation: 'c1', refKind: 'post', refId: 'p1');
    expect(site.forRpc('dm_send').last.body, containsPair('p_ref_kind', 'post'));
    expect(site.forRpc('dm_send').last.body, containsPair('p_ref_id', 'p1'));
  });

  test('a refused send says why; one with an unreadable answer is an error', () async {
    site.rpcs['dm_send'] = (_) => raised('Wait for them to reply before sending more.');
    await expectLater(service.send(actor: 'me', conversation: 'c1', body: 'x'), sentence('Wait for them to reply before sending more.'));
    site.rpcs['dm_send'] = (_) => ok({'junk': 1});
    await expectLater(service.send(actor: 'me', conversation: 'c1', body: 'x'), throwsA(isA<SiteException>()));
  });

  test('reading, muting, answering a request and removing a message', () async {
    site.rpcs['dm_mark_read'] = (_) => ok({'read': true});
    site.rpcs['dm_mute'] = (_) => ok({'muted': true});
    site.rpcs['dm_answer_request'] = (_) => ok({'accepted': true});
    site.rpcs['dm_delete_message'] = (_) => ok({'removed': true});
    await service.markRead(actor: 'me', conversation: 'c1');
    await service.mute(actor: 'me', conversation: 'c1', muted: true);
    await service.answerRequest(actor: 'me', conversation: 'c1', accept: false);
    await service.deleteMessage(actor: 'me', message: 'm1');
    expect(site.forRpc('dm_mute').single.body, {'p_actor': 'me', 'p_conversation': 'c1', 'p_muted': true});
    expect(site.forRpc('dm_answer_request').single.body, {'p_actor': 'me', 'p_conversation': 'c1', 'p_accept': false});
    expect(site.forRpc('dm_delete_message').single.body, {'p_actor': 'me', 'p_message': 'm1'});
    site.networkDown = true;
    await service.markRead(actor: 'me', conversation: 'c1'); // quiet
  });

  test('groups', () async {
    site.rpcs['dm_people'] = (_) => ok([{...profileRow(id: 'a', handle: 'ann'), 'role': 'admin', 'status': 'active'}]);
    for (final n in ['dm_group_add', 'dm_group_remove', 'dm_group_rename', 'dm_leave']) {
      site.rpcs[n] = (_) => ok({'ok': true});
    }
    expect((await service.people(actor: 'me', conversation: 'g1')).single.isAdmin, isTrue);
    await service.addToGroup(actor: 'me', conversation: 'g1', member: 'x');
    await service.removeFromGroup(actor: 'me', conversation: 'g1', member: 'x');
    await service.renameGroup(actor: 'me', conversation: 'g1', title: ' New ');
    await service.leaveGroup(actor: 'me', conversation: 'g1');
    expect(site.forRpc('dm_group_add').single.body, {'p_actor': 'me', 'p_conversation': 'g1', 'p_member': 'x'});
    expect(site.forRpc('dm_group_rename').single.body['p_title'], 'New');
    expect(site.forRpc('dm_leave').single.body, {'p_actor': 'me', 'p_conversation': 'g1'});
  });

  test('which notifications are wanted: read, and switched on or off for some kinds', () async {
    site.rpcs['notification_prefs'] = (_) => ok({'like': false, 'comment': true, 'junk': 'x'});
    expect(await service.notificationPrefs('me'), {'like': false, 'comment': true});
    expect(site.forRpc('notification_prefs').single.body, {'p_actor': 'me'});
    site.rpcs['notification_prefs_set'] = (_) => ok({'like': true});
    expect(await service.setNotificationKinds(actor: 'me', kinds: ['like', 'comment'], enabled: true), {'like': true});
    expect(site.forRpc('notification_prefs_set').single.body, {'p_actor': 'me', 'p_kinds': ['like', 'comment'], 'p_enabled': true});
    site.rpcs['notification_prefs_set'] = (_) => raised('Choose what to change.');
    await expectLater(service.setNotificationKinds(actor: 'me', kinds: const [], enabled: false), sentence('Choose what to change.'));
    site.rpcs['notification_prefs'] = (_) => ok(null);
    expect(await service.notificationPrefs('me'), isEmpty);
  });

  test('notifications', () async {
    site.rpcs['notifications_list'] = (_) => ok([notificationRow(id: 'a', createdAt: '2099-10-24T23:00:00.5Z')]);
    site.rpcs['notifications_unread'] = (_) => ok(4);
    site.rpcs['notifications_read'] = (_) => ok({'unread': 0});
    final list = await service.notifications(actor: 'me');
    await service.notifications(actor: 'me', before: list.last);
    expect(site.forRpc('notifications_list').last.body, containsPair('p_before_id', 'a'));
    expect(await service.unreadNotifications('me'), 4);
    await service.markNotificationsRead('me');
    expect(site.forRpc('notifications_read').single.body, {'p_actor': 'me'});
  });
}
