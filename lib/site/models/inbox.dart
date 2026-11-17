import '../read.dart';
import 'post.dart';
import 'social_profile.dart';

enum ConversationKind { direct, group, booking }

/// The last message of a conversation, for its row in the inbox.
class LastMessage {
  const LastMessage({required this.kind, required this.createdAt, required this.sender, this.body, this.removed = false, this.isMine = false});

  final String kind;
  final String? body;
  final bool removed;
  final DateTime createdAt;
  final SocialProfile sender;
  final bool isMine;
}

/// One row of the inbox.
class Conversation {
  const Conversation({
    required this.id,
    required this.kind,
    required this.lastMessageAt,
    required this.others,
    this.title,
    this.bookingId,
    this.muted = false,
    this.isRequest = false,
    this.memberCount = 2,
    this.unread = 0,
    this.last,
  });

  final String id;
  final ConversationKind kind;
  final String? title;
  final String? bookingId;
  final bool muted;

  /// You have not accepted it yet.
  final bool isRequest;
  final int memberCount;
  final DateTime lastMessageAt;

  /// Up to three of the other people in it.
  final List<SocialProfile> others;
  final int unread;
  final LastMessage? last;

  /// What to call it: a group's name, or the other person's.
  String get displayTitle => title ?? (others.isEmpty ? 'Conversation' : others.first.displayName);
}

Conversation? parseConversation(Object? json) {
  if (json is! Map) return null;
  final id = readText(json['id']);
  final kind = switch (json['kind']) {
    'direct' => ConversationKind.direct,
    'group' => ConversationKind.group,
    'booking' => ConversationKind.booking,
    _ => null,
  };
  final at = readText(json['last_message_at']);
  final when = at == null ? null : DateTime.tryParse(at)?.toLocal();
  if (id == null || kind == null || when == null) return null;
  LastMessage? last;
  final l = json['last'];
  if (l is Map) {
    final sender = parseSocialProfile(l['sender']);
    final created = readText(l['created_at']);
    final lc = created == null ? null : DateTime.tryParse(created)?.toLocal();
    if (sender != null && lc != null) last = LastMessage(kind: readText(l['kind']) ?? 'text', body: readText(l['body']), removed: l['removed'] == true, createdAt: lc, sender: sender, isMine: l['is_mine'] == true);
  }
  return Conversation(
    id: id,
    kind: kind,
    title: readText(json['title']),
    bookingId: readText(json['booking_id']),
    muted: json['muted'] == true,
    isRequest: json['status'] == 'request',
    memberCount: readInt(json['member_count']) ?? 2,
    lastMessageAt: when,
    others: parseSocialProfiles(json['others']),
    unread: readInt(json['unread']) ?? 0,
    last: last,
  );
}

List<Conversation> parseConversations(Object? json) => json is List ? [for (final r in json) if (parseConversation(r) case final c?) c] : const [];

/// What a message carries besides words: a post, an event, a venue or a booking, as the reader may see it.
class MessageRef {
  const MessageRef({required this.kind, required this.available, this.post, this.id, this.title, this.subtitle, this.when});

  final String kind;
  final bool available;
  final SocialPost? post;
  final String? id;
  final String? title;
  final String? subtitle;
  final String? when;
}

MessageRef? parseMessageRef(String kind, Object? json) {
  if (json is! Map) return null;
  if (json['available'] != true) return MessageRef(kind: kind, available: false);
  switch (kind) {
    case 'post':
      final post = parseSocialPost(json['post']);
      return post == null ? MessageRef(kind: kind, available: false) : MessageRef(kind: kind, available: true, post: post, id: post.id);
    case 'event':
      return MessageRef(kind: kind, available: true, id: readText(json['id']), title: readText(json['title']), subtitle: readText(json['venue_name']), when: readText(json['starts_at']));
    case 'venue':
      return MessageRef(kind: kind, available: true, id: readText(json['id']), title: readText(json['name']), subtitle: readText(json['address']));
    case 'booking':
      final table = readText(json['table']);
      final guests = readInt(json['guests']);
      return MessageRef(
        kind: kind,
        available: true,
        id: readText(json['id']),
        title: readText(json['venue']),
        subtitle: [if (table != null) table, if (guests != null) '$guests ${guests == 1 ? 'guest' : 'guests'}'].join(' · '),
        when: readText(json['night']),
      );
  }
  return null;
}

class DmMessage {
  const DmMessage({required this.id, required this.conversationId, required this.kind, required this.createdAt, required this.sender, this.body, this.removed = false, this.isMine = false, this.ref});

  final String id;
  final String conversationId;
  final String kind;
  final String? body;
  final bool removed;
  final DateTime createdAt;
  final SocialProfile sender;
  final bool isMine;
  final MessageRef? ref;
}

DmMessage? parseDmMessage(Object? json) {
  if (json is! Map) return null;
  final id = readText(json['id']);
  final conv = readText(json['conversation']);
  final sender = parseSocialProfile(json['sender']);
  final kind = readText(json['kind']);
  final at = readText(json['created_at']);
  final when = at == null ? null : DateTime.tryParse(at)?.toLocal();
  if (id == null || conv == null || sender == null || kind == null || when == null) return null;
  return DmMessage(
    id: id,
    conversationId: conv,
    kind: kind,
    body: readText(json['body']),
    removed: json['removed'] == true,
    createdAt: when,
    sender: sender,
    isMine: json['is_mine'] == true,
    ref: kind == 'text' ? null : parseMessageRef(kind, json['ref']),
  );
}

List<DmMessage> parseDmMessages(Object? json) => json is List ? [for (final r in json) if (parseDmMessage(r) case final m?) m] : const [];

/// A member of a conversation, with their role and whether they have accepted.
class DmPerson {
  const DmPerson({required this.profile, required this.isAdmin, required this.pending});

  final SocialProfile profile;
  final bool isAdmin;
  final bool pending;
}

List<DmPerson> parseDmPeople(Object? json) => json is List
    ? [
        for (final r in json)
          if (parseSocialProfile(r) case final p?) DmPerson(profile: p, isAdmin: (r as Map)['role'] == 'admin', pending: r['status'] == 'request'),
      ]
    : const [];

/// How many conversations have something new and how many requests are waiting.
class InboxCounts {
  const InboxCounts({this.conversations = 0, this.requests = 0});

  final int conversations;
  final int requests;

  int get badge => conversations + requests;
}

InboxCounts parseInboxCounts(Object? json) => json is Map ? InboxCounts(conversations: readInt(json['conversations']) ?? 0, requests: readInt(json['requests']) ?? 0) : const InboxCounts();

enum NotificationKind { follow, followRequest, followAccepted, like, comment, reply, tag, reviewReply }

class AppNotification {
  const AppNotification({required this.id, required this.kind, required this.createdAt, required this.actor, this.read = false, this.post, this.commentBody, this.followsBack = false});

  final String id;
  final NotificationKind kind;
  final DateTime createdAt;
  final SocialProfile actor;
  final bool read;
  final SocialPost? post;
  final String? commentBody;
  final bool followsBack;
}

AppNotification? parseNotification(Object? json) {
  if (json is! Map) return null;
  final id = readText(json['id']);
  final actor = parseSocialProfile(json['actor']);
  final at = readText(json['created_at']);
  final when = at == null ? null : DateTime.tryParse(at)?.toLocal();
  final kind = switch (json['kind']) {
    'follow' => NotificationKind.follow,
    'follow_request' => NotificationKind.followRequest,
    'follow_accepted' => NotificationKind.followAccepted,
    'like' => NotificationKind.like,
    'comment' => NotificationKind.comment,
    'reply' => NotificationKind.reply,
    'tag' => NotificationKind.tag,
    'review_reply' => NotificationKind.reviewReply,
    _ => null,
  };
  if (id == null || actor == null || when == null || kind == null) return null;
  return AppNotification(id: id, kind: kind, createdAt: when, actor: actor, read: json['read'] == true, post: parseSocialPost(json['post']), commentBody: readText(json['comment_body']), followsBack: json['follows_back'] == true);
}

List<AppNotification> parseNotifications(Object? json) => json is List ? [for (final r in json) if (parseNotification(r) case final n?) n] : const [];
