import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/features.dart';
import '../../../site/models/inbox.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/site_error.dart';
import '../widgets/message_widgets.dart';
import '../widgets/profile_widgets.dart';

const int _page = 30;

/// The inbox: your conversations, newest first, and the requests from people you do not follow. A small bell opens notifications. It refreshes by itself while it is open.
class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key, this.refreshEvery = const Duration(seconds: 15)});

  final Duration refreshEvery;

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  final List<Conversation> _items = [];
  bool _requests = false;
  bool _loading = true;
  bool _more = false;
  bool _started = false;
  String? _error;
  String? _forActor;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _load(SocialProfile actor, {bool next = false, bool quiet = false}) async {
    if (!quiet) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    try {
      final page = await ref.read(inboxServiceProvider).inbox(actor: actor.id, requests: _requests, limit: _page, after: next && _items.isNotEmpty ? _items.last : null);
      if (!mounted) return;
      setState(() {
        if (!next) _items.clear();
        _items.addAll(page);
        _more = page.length >= _page;
        _error = null;
      });
      ref.invalidate(inboxCountsProvider(actor.id));
    } on SiteException catch (e) {
      if (mounted && !quiet) setState(() => _error = e.message);
    } finally {
      if (mounted && !quiet) setState(() => _loading = false);
    }
  }

  void _open(SocialProfile actor, Conversation c) async {
    await context.push('/inbox/${c.id}');
    if (mounted) _load(actor, quiet: true);
  }

  @override
  Widget build(BuildContext context) {
    return ActorGate(
      title: 'Messages',
      builder: (context, actor) {
        if (!ref.watch(featureOnProvider(Feature.inbox))) {
          return Scaffold(appBar: AppBar(title: const Text('Messages')), body: const EmptyState(icon: Icons.hourglass_empty, title: 'Coming soon', text: 'Messages are not open yet.'));
        }
        if (!_started || _forActor != actor.id) {
          _started = true;
          _forActor = actor.id;
          _timer?.cancel();
          _timer = Timer.periodic(widget.refreshEvery, (_) {
            // As a tab it stays alive behind the other pages: it only looks for news while it is in front.
            if (mounted && TickerMode.valuesOf(context).enabled) _load(actor, quiet: true);
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _load(actor);
          });
        }
        final counts = ref.watch(inboxCountsProvider(actor.id)).valueOrNull ?? const InboxCounts();
        final unreadNotifications = ref.watch(unreadNotificationsProvider(actor.id)).valueOrNull ?? 0;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Messages'),
            actions: [
              IconButton(
                key: const Key('open-notifications'),
                tooltip: 'Notifications',
                icon: Badge(isLabelVisible: unreadNotifications > 0, label: Text('$unreadNotifications', key: const Key('notifications-badge')), child: const Icon(Icons.notifications_none)),
                onPressed: () => context.push('/notifications'),
              ),
              IconButton(key: const Key('new-message'), tooltip: 'New message', icon: const Icon(Icons.edit_outlined), onPressed: () async {
                await context.push('/inbox/new');
                if (mounted) _load(actor, quiet: true);
              }),
            ],
          ),
          body: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: SegmentedButton<bool>(
                key: const Key('inbox-box'),
                showSelectedIcon: false,
                segments: [
                  const ButtonSegment(value: false, label: Text('Messages')),
                  ButtonSegment(value: true, label: Text(counts.requests > 0 ? 'Requests (${counts.requests})' : 'Requests')),
                ],
                selected: {_requests},
                onSelectionChanged: (s) {
                  setState(() {
                    _requests = s.first;
                    _items.clear();
                  });
                  _load(actor);
                },
              ),
            ),
            Expanded(child: _body(actor)),
          ]),
        );
      },
    );
  }

  Widget _body(SocialProfile actor) {
    if (_error != null && _items.isEmpty) return LoadFailed(message: _error!, onRetry: () => _load(actor));
    if (_loading && _items.isEmpty) return const Center(child: CircularProgressIndicator());
    if (_items.isEmpty) return InboxEmpty(requests: _requests);
    return RefreshIndicator(
      onRefresh: () => _load(actor, quiet: true),
      child: ListView(key: const Key('inbox-list'), physics: const AlwaysScrollableScrollPhysics(), padding: const EdgeInsets.only(bottom: 96), children: [
        for (final c in _items) ConversationTile(conversation: c, onTap: () => _open(actor, c)),
        if (_more) Padding(padding: const EdgeInsets.all(16), child: OutlinedButton(key: const Key('inbox-more'), onPressed: _loading ? null : () => _load(actor, next: true), child: const Text('Show more'))),
      ]),
    );
  }
}
