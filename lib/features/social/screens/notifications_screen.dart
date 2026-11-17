import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/inbox.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/post_rules.dart';
import '../../../site/site_error.dart';
import '../widgets/post_widgets.dart';
import '../widgets/profile_widgets.dart';

const int _page = 30;

/// What happened that involves you: people who followed or asked to, liked or commented, tagged you, or answered your review. Opening the list marks everything read.
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key, this.now});

  final DateTime? now;

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  final List<AppNotification> _items = [];
  bool _loading = true;
  bool _more = false;
  bool _started = false;
  String? _error;
  String? _forActor;

  Future<void> _load(SocialProfile actor, {bool next = false}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final service = ref.read(inboxServiceProvider);
      final page = await service.notifications(actor: actor.id, limit: _page, before: next && _items.isNotEmpty ? _items.last : null);
      if (!mounted) return;
      setState(() {
        if (!next) _items.clear();
        _items.addAll(page);
        _more = page.length >= _page;
      });
      if (!next && page.any((n) => !n.read)) {
        await service.markNotificationsRead(actor.id);
        ref.invalidate(unreadNotificationsProvider(actor.id));
      }
    } on SiteException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _text(AppNotification n) => switch (n.kind) {
        NotificationKind.follow => 'started following you.',
        NotificationKind.followRequest => 'asked to follow you.',
        NotificationKind.followAccepted => 'accepted your request to follow.',
        NotificationKind.like => 'liked your post.',
        NotificationKind.comment => 'commented: ${n.commentBody ?? ''}',
        NotificationKind.reply => 'replied to your comment: ${n.commentBody ?? ''}',
        NotificationKind.tag => 'tagged you in a post.',
        NotificationKind.reviewReply => 'replied to your review.',
      };

  void _open(AppNotification n) {
    switch (n.kind) {
      case NotificationKind.like || NotificationKind.comment || NotificationKind.reply || NotificationKind.tag:
        if (n.post != null) {
          context.push('/post/${n.post!.id}');
          return;
        }
        context.push('/u/${n.actor.handle}');
      case NotificationKind.followRequest:
        context.push('/people/requests');
      default:
        context.push('/u/${n.actor.handle}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ActorGate(
      title: 'Notifications',
      builder: (context, actor) {
        if (!_started || _forActor != actor.id) {
          _started = true;
          _forActor = actor.id;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _load(actor);
          });
        }
        final now = widget.now ?? DateTime.now();
        return Scaffold(
          appBar: AppBar(title: const Text('Notifications')),
          body: _error != null && _items.isEmpty
              ? LoadFailed(message: _error!, onRetry: () => _load(actor))
              : _loading && _items.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _items.isEmpty
                      ? const EmptyState(icon: Icons.notifications_none, title: 'Nothing yet', text: 'When people follow you, like or comment on your posts, you will see it here.')
                      : RefreshIndicator(
                          onRefresh: () => _load(actor),
                          child: ListView(key: const Key('notifications-list'), physics: const AlwaysScrollableScrollPhysics(), padding: const EdgeInsets.only(bottom: 96), children: [
                            for (final n in _items)
                              ListTile(
                                key: Key('notification-${n.id}'),
                                tileColor: n.read ? null : Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.25),
                                leading: ProfileAvatar(profile: n.actor),
                                title: Text.rich(TextSpan(children: [TextSpan(text: n.actor.displayName, style: const TextStyle(fontWeight: FontWeight.w800)), TextSpan(text: ' ${_text(n)}')])),
                                subtitle: Text(timeAgo(n.createdAt, now)),
                                trailing: n.post != null && n.post!.media.isNotEmpty && !n.post!.media.first.isVideo ? SizedBox(width: 44, height: 44, child: MediaItemView(media: n.post!.media.first)) : null,
                                onTap: () => _open(n),
                              ),
                            if (_more) Padding(padding: const EdgeInsets.all(16), child: OutlinedButton(key: const Key('notifications-more'), onPressed: _loading ? null : () => _load(actor, next: true), child: const Text('Show more'))),
                          ]),
                        ),
        );
      },
    );
  }
}
