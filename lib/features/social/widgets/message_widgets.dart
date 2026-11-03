import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/inbox.dart';
import '../../../site/rules/post_rules.dart';
import 'post_widgets.dart';
import 'profile_widgets.dart';

/// One row of the inbox: who, what was said last, and how many are new.
class ConversationTile extends StatelessWidget {
  const ConversationTile({super.key, required this.conversation, required this.onTap, this.now});

  final Conversation conversation;
  final VoidCallback onTap;
  final DateTime? now;

  String _preview(Conversation c) {
    final l = c.last;
    if (l == null) return 'No messages yet';
    final who = l.isMine ? 'You: ' : (c.kind == ConversationKind.group ? '${l.sender.displayName}: ' : '');
    if (l.removed) return '${who}Message removed';
    return switch (l.kind) {
      'post' => '${who}Shared a post',
      'event' => '${who}Shared an event',
      'venue' => '${who}Shared a venue',
      'booking' => '${who}Booking',
      _ => '$who${l.body ?? ''}',
    };
  }

  @override
  Widget build(BuildContext context) {
    final c = conversation;
    final theme = Theme.of(context);
    final first = c.others.isEmpty ? null : c.others.first;
    return ListTile(
      key: Key('conversation-${c.id}'),
      onTap: onTap,
      leading: c.kind == ConversationKind.group
          ? CircleAvatar(backgroundColor: theme.colorScheme.primaryContainer, child: const Icon(Icons.groups_2_outlined))
          : first == null
              ? const CircleAvatar(child: Icon(Icons.person_outline))
              : ProfileAvatar(profile: first),
      title: Row(children: [
        Flexible(child: Text(c.displayTitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: c.unread > 0 ? FontWeight.w800 : FontWeight.w600))),
        if (c.kind == ConversationKind.booking) const Padding(padding: EdgeInsets.only(left: 6), child: Icon(Icons.confirmation_number_outlined, size: 14)),
        if (c.muted) const Padding(padding: EdgeInsets.only(left: 6), child: Icon(Icons.notifications_off_outlined, size: 14)),
      ]),
      subtitle: Text(_preview(c), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: c.unread > 0 ? FontWeight.w700 : FontWeight.normal)),
      trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(timeAgo(c.lastMessageAt, now ?? DateTime.now()), style: theme.textTheme.bodySmall),
        if (c.unread > 0)
          Container(
            key: Key('unread-${c.id}'),
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(color: theme.colorScheme.primary, borderRadius: BorderRadius.circular(10)),
            child: Text('${c.unread}', style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 12, fontWeight: FontWeight.w700)),
          ),
      ]),
    );
  }
}

/// A message in a conversation: a bubble of words, a removed message, or a shared post, event, venue or booking.
class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message, required this.showSender, this.onLongPress, this.now});

  final DmMessage message;

  /// In a group, other people's messages say who sent them.
  final bool showSender;
  final VoidCallback? onLongPress;
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final m = message;
    final theme = Theme.of(context);
    final mine = m.isMine;
    final color = mine ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest;
    final textColor = mine ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface;
    Widget content;
    if (m.removed) {
      content = Text('Message removed', key: Key('removed-${m.id}'), style: TextStyle(fontStyle: FontStyle.italic, color: textColor.withValues(alpha: 0.7)));
    } else {
      content = Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        if (m.ref != null) _RefCard(message: m),
        if (m.body != null) Padding(padding: EdgeInsets.only(top: m.ref != null ? 6 : 0), child: Text(m.body!, key: Key('body-${m.id}'), style: TextStyle(color: textColor))),
      ]);
    }
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: onLongPress,
        child: Container(
          key: Key('message-${m.id}'),
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
          margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            if (showSender && !mine) Text(m.sender.displayName, style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w800, color: textColor)),
            content,
            Padding(padding: const EdgeInsets.only(top: 2), child: Text(timeAgo(m.createdAt, now ?? DateTime.now()), style: theme.textTheme.labelSmall?.copyWith(color: textColor.withValues(alpha: 0.6)))),
          ]),
        ),
      ),
    );
  }
}

class _RefCard extends StatelessWidget {
  const _RefCard({required this.message});

  final DmMessage message;

  @override
  Widget build(BuildContext context) {
    final r = message.ref!;
    final theme = Theme.of(context);
    if (!r.available) {
      return Container(
        key: Key('ref-unavailable-${message.id}'),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: theme.colorScheme.surface.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(10)),
        child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.visibility_off_outlined, size: 16), SizedBox(width: 6), Flexible(child: Text('This is not available to you'))]),
      );
    }
    final post = r.post;
    final (icon, title, sub, onTap) = switch (r.kind) {
      'post' => (Icons.photo_outlined, '@${post!.author.handle}', post.caption ?? kindLabel(post.kind), () => context.push('/post/${post.id}')),
      'event' => (Icons.event_outlined, r.title ?? 'Event', r.subtitle ?? '', () => context.push('/events/${r.id}')),
      'venue' => (Icons.place_outlined, r.title ?? 'Venue', r.subtitle ?? '', () => context.push('/venues/${r.id}')),
      _ => (Icons.confirmation_number_outlined, r.title ?? 'Booking', [if (r.when != null) r.when!, if ((r.subtitle ?? '').isNotEmpty) r.subtitle!].join(' · '), null),
    };
    return InkWell(
      key: Key('ref-${r.kind}-${message.id}'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(10)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (post != null && post.media.isNotEmpty) SizedBox(width: 44, height: 44, child: MediaItemView(media: post.media.first)) else Icon(icon),
          const SizedBox(width: 10),
          Flexible(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w700, color: theme.colorScheme.onSurface)),
            if (sub.isNotEmpty) Text(sub, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
          ])),
        ]),
      ),
    );
  }
}

/// "No messages" and the like, said once.
class InboxEmpty extends StatelessWidget {
  const InboxEmpty({super.key, required this.requests});

  final bool requests;

  @override
  Widget build(BuildContext context) => EmptyState(
        icon: requests ? Icons.mark_email_unread_outlined : Icons.chat_bubble_outline,
        title: requests ? 'No requests' : 'No messages yet',
        text: requests ? 'Messages from people you do not follow wait here until you answer.' : 'Start a conversation with someone you follow, or message a venue about your booking.',
      );
}
