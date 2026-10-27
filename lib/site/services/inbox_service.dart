import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/inbox.dart';
import '../site_error.dart';

/// Conversations, messages and notifications, through the website's `dm_*` and `notifications_*` functions. Every call is made AS a profile; the website checks, each time, that the
/// person may act as it and may be in the conversation, and says in a sentence when not.
class InboxService {
  InboxService(this._db);

  final SupabaseClient _db;

  Future<Object?> _rpc(String name, Map<String, dynamic> params, String generic) async {
    try {
      return await _db.rpc(name, params: params);
    } catch (error) {
      throw siteExceptionFromRpc(error, generic: generic);
    }
  }

  static String? _iso(DateTime? t) => t?.toUtc().toIso8601String();

  Future<List<Conversation>> inbox({required String actor, bool requests = false, int limit = 30, Conversation? after}) async => parseConversations(await _rpc(
        'dm_inbox',
        {'p_actor': actor, 'p_box': requests ? 'requests' : 'main', 'p_limit': limit, 'p_before': _iso(after?.lastMessageAt), 'p_before_id': after?.id},
        loadFailedMessage('your messages'),
      ));

  /// One conversation the profile is in, for the top of its screen.
  Future<Conversation> conversation({required String actor, required String id}) async {
    final c = parseConversation(await _rpc('dm_conversation', {'p_actor': actor, 'p_conversation': id}, loadFailedMessage('that conversation')));
    if (c == null) throw const SiteException('We could not read that conversation. Try again in a moment.');
    return c;
  }

  /// A quiet read: the badge on the Inbox tab is not worth an error.
  Future<InboxCounts> counts(String actor) async {
    try {
      return parseInboxCounts(await _db.rpc('dm_unread', params: {'p_actor': actor}));
    } catch (error) {
      logProblem('read the inbox badge', error);
      return const InboxCounts();
    }
  }

  Future<String> startDirect({required String actor, required String other}) async => _id(await _rpc('dm_start_direct', {'p_actor': actor, 'p_other': other}, 'We could not start that conversation. Check your connection and try again.'));

  Future<String> startGroup({required String actor, required String title, required List<String> members}) async =>
      _id(await _rpc('dm_start_group', {'p_actor': actor, 'p_title': title.trim(), 'p_members': members}, 'We could not make the group. Check your connection and try again.'));

  Future<String> startBooking({required String actor, required String booking}) async =>
      _id(await _rpc('dm_start_booking', {'p_actor': actor, 'p_booking': booking}, 'We could not open the conversation. Check your connection and try again.'));

  String _id(Object? json) {
    final id = json is Map ? json['id'] : null;
    if (id is! String || id.isEmpty) throw const SiteException('We could not open the conversation. Try again in a moment.');
    return id;
  }

  /// A page of messages, newest first.
  Future<List<DmMessage>> messages({required String actor, required String conversation, int limit = 30, DmMessage? before}) async => parseDmMessages(await _rpc(
        'dm_messages',
        {'p_actor': actor, 'p_conversation': conversation, 'p_limit': limit, 'p_before': _iso(before?.createdAt), 'p_before_id': before?.id},
        loadFailedMessage('the messages'),
      ));

  /// Sends a message. [clientKey] makes a retry the same message. For a share, [refKind] is 'post', 'event', 'venue' or 'booking' and [body] an optional note.
  Future<DmMessage> send({required String actor, required String conversation, String? body, String? clientKey, String? refKind, String? refId}) async {
    final m = parseDmMessage(await _rpc(
      'dm_send',
      {'p_actor': actor, 'p_conversation': conversation, 'p_body': body?.trim(), 'p_client_key': clientKey, 'p_ref_kind': refKind, 'p_ref_id': refId},
      'Your message was not sent. Check your connection and try again.',
    ));
    if (m == null) throw const SiteException('We could not read the reply. Try again in a moment.');
    return m;
  }

  Future<void> markRead({required String actor, required String conversation}) async {
    try {
      await _db.rpc('dm_mark_read', params: {'p_actor': actor, 'p_conversation': conversation});
    } catch (error) {
      logProblem('mark a conversation read', error);
    }
  }

  Future<void> mute({required String actor, required String conversation, required bool muted}) async {
    await _rpc('dm_mute', {'p_actor': actor, 'p_conversation': conversation, 'p_muted': muted}, actionFailedMessage);
  }

  Future<void> answerRequest({required String actor, required String conversation, required bool accept}) async {
    await _rpc('dm_answer_request', {'p_actor': actor, 'p_conversation': conversation, 'p_accept': accept}, actionFailedMessage);
  }

  Future<void> deleteMessage({required String actor, required String message}) async {
    await _rpc('dm_delete_message', {'p_actor': actor, 'p_message': message}, actionFailedMessage);
  }

  Future<List<DmPerson>> people({required String actor, required String conversation}) async =>
      parseDmPeople(await _rpc('dm_people', {'p_actor': actor, 'p_conversation': conversation}, loadFailedMessage('the people in it')));

  Future<void> addToGroup({required String actor, required String conversation, required String member}) async {
    await _rpc('dm_group_add', {'p_actor': actor, 'p_conversation': conversation, 'p_member': member}, actionFailedMessage);
  }

  Future<void> removeFromGroup({required String actor, required String conversation, required String member}) async {
    await _rpc('dm_group_remove', {'p_actor': actor, 'p_conversation': conversation, 'p_member': member}, actionFailedMessage);
  }

  Future<void> renameGroup({required String actor, required String conversation, required String title}) async {
    await _rpc('dm_group_rename', {'p_actor': actor, 'p_conversation': conversation, 'p_title': title.trim()}, actionFailedMessage);
  }

  Future<void> leaveGroup({required String actor, required String conversation}) async {
    await _rpc('dm_leave', {'p_actor': actor, 'p_conversation': conversation}, actionFailedMessage);
  }

  // ---- notifications

  Future<List<AppNotification>> notifications({required String actor, int limit = 30, AppNotification? before}) async => parseNotifications(await _rpc(
        'notifications_list',
        {'p_actor': actor, 'p_limit': limit, 'p_before': _iso(before?.createdAt), 'p_before_id': before?.id},
        loadFailedMessage('your notifications'),
      ));

  Future<int> unreadNotifications(String actor) async {
    try {
      final r = await _db.rpc('notifications_unread', params: {'p_actor': actor});
      return r is num ? r.toInt() : 0;
    } catch (error) {
      logProblem('read the notification badge', error);
      return 0;
    }
  }

  Future<void> markNotificationsRead(String actor) async {
    try {
      await _db.rpc('notifications_read', params: {'p_actor': actor});
    } catch (error) {
      logProblem('mark notifications read', error);
    }
  }
}
