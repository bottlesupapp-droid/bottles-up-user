import 'package:bottles_up_user/site/models/inbox.dart';
import 'package:bottles_up_user/site/rules/notification_rules.dart';
import 'package:bottles_up_user/site/services/inbox_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/website_files.dart';

/// The app against the website's inbox migration.
void main() {
  group('inbox against the website', skip: websiteIsHere ? null : websiteMissing, () {
    late String sql;
    setUpAll(() => sql = migrationCode('inbox_notifications'));

    test('every function the app calls exists with the parameters the app sends', () async {
      final site = FakeWebsite();
      final service = InboxService(site.client);
      site.rpcs['dm_inbox'] = (_) => ok([convRow()]);
      site.rpcs['dm_conversation'] = (_) => ok(convRow());
      site.rpcs['dm_unread'] = (_) => ok({'conversations': 0, 'requests': 0});
      for (final n in ['dm_start_direct', 'dm_start_group', 'dm_start_booking']) {
        site.rpcs[n] = (_) => ok({'id': 'x'});
      }
      site.rpcs['dm_messages'] = (_) => ok([dmRow()]);
      site.rpcs['dm_send'] = (_) => ok(dmRow());
      for (final n in ['dm_mark_read', 'dm_mute', 'dm_answer_request', 'dm_delete_message', 'dm_group_add', 'dm_group_remove', 'dm_group_rename', 'dm_leave', 'notifications_read']) {
        site.rpcs[n] = (_) => ok({'ok': true});
      }
      site.rpcs['dm_people'] = (_) => ok(<Object>[]);
      site.rpcs['notifications_list'] = (_) => ok([notificationRow()]);
      site.rpcs['notifications_unread'] = (_) => ok(0);
      site.rpcs['notification_prefs'] = (_) => ok({'like': true});
      site.rpcs['notification_prefs_set'] = (_) => ok({'like': false});

      final convs = await service.inbox(actor: 'a');
      await service.inbox(actor: 'a', requests: true, after: convs.last);
      await service.conversation(actor: 'a', id: 'c');
      await service.counts('a');
      await service.startDirect(actor: 'a', other: 'o');
      await service.startGroup(actor: 'a', title: 't', members: ['x']);
      await service.startBooking(actor: 'a', booking: 'b');
      final msgs = await service.messages(actor: 'a', conversation: 'c');
      await service.messages(actor: 'a', conversation: 'c', before: msgs.last);
      await service.send(actor: 'a', conversation: 'c', body: 'x', clientKey: 'k', refKind: 'post', refId: 'p');
      await service.markRead(actor: 'a', conversation: 'c');
      await service.mute(actor: 'a', conversation: 'c', muted: true);
      await service.answerRequest(actor: 'a', conversation: 'c', accept: true);
      await service.deleteMessage(actor: 'a', message: 'm');
      await service.people(actor: 'a', conversation: 'c');
      await service.addToGroup(actor: 'a', conversation: 'c', member: 'm');
      await service.removeFromGroup(actor: 'a', conversation: 'c', member: 'm');
      await service.renameGroup(actor: 'a', conversation: 'c', title: 't');
      await service.leaveGroup(actor: 'a', conversation: 'c');
      final notes = await service.notifications(actor: 'a');
      await service.notifications(actor: 'a', before: notes.last);
      await service.unreadNotifications('a');
      await service.markNotificationsRead('a');
      await service.notificationPrefs('a');
      await service.setNotificationKinds(actor: 'a', kinds: ['like'], enabled: false);

      expect(site.rpcRequests.map((r) => r.name).toSet(), hasLength(22));
      for (final r in site.rpcRequests) {
        final params = sqlFunctionParamInfo(r.name);
        final names = params.map((p) => p.name).toSet();
        expect(names.containsAll(r.body.keys), isTrue, reason: '${r.name}: the app sends ${r.body.keys.toList()} but the function takes $names');
        for (final p in params) {
          if (!p.hasDefault) expect(r.body.keys, contains(p.name), reason: '${r.name} needs ${p.name} and the app does not send it');
        }
      }
    });

    test('the notification kinds the app knows are the website\'s', () {
      final fromCheck = sqlWordsAfter(sql, "kind text not null check (kind in ('follow',");
      expect(fromCheck, {'follow', 'follow_request', 'follow_accepted', 'like', 'comment', 'reply', 'tag', 'review_reply'});
      expect(NotificationKind.values, hasLength(fromCheck.length));
    });

    test('the conversation and message kinds', () {
      expect(sqlWordsAfter(sql, "kind text not null check (kind in ('direct',"), {'direct', 'group', 'booking'});
      expect(sqlWordsAfter(sql.substring(sql.indexOf('create table public.site_dm_messages')), "kind text not null check (kind in ('text',"), {'text', 'post', 'event', 'venue', 'booking'});
    });

    test('the groups of notifications the app switches are made of kinds the website knows, and cover all of them', () {
      final kinds = sqlWordsAfter(sql.substring(sql.indexOf('create table public.site_notification_opt_outs')), 'kind text not null check (kind in');
      final grouped = [for (final g in notificationGroups) ...g.kinds];
      expect(grouped.toSet(), kinds);
      expect(grouped.length, kinds.length, reason: 'no kind is in two groups');
    });

    test('the limits the app says', () {
      expect(sql, contains('char_length(btrim(body)) between 1 and 2000'));
      expect(sql, contains('char_length(btrim(title)) between 1 and 60'));
      expect(sql, contains("'A group can have 50 people at most.'"));
      expect(sql, contains(">= 3 then\n      raise exception 'Wait for them to reply before sending more.'"));
      expect(sql, contains(">= 30 then\n    raise exception 'You are sending messages too fast. Wait a moment.'"));
    });
  });
}
