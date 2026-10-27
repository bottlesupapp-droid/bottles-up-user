import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/inbox.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/site_error.dart';
import '../widgets/message_widgets.dart';
import '../widgets/profile_widgets.dart';
import '../widgets/rules_gate.dart';

const int _page = 30;

/// One conversation: the messages (newest at the bottom), a box to write in, and for a request the choice to accept or decline. While it is open it looks for new messages every few
/// seconds. A message that did not go stays in the box with the reason.
class ConversationScreen extends ConsumerStatefulWidget {
  const ConversationScreen({super.key, required this.conversationId, this.pollEvery = const Duration(seconds: 5)});

  final String conversationId;
  final Duration pollEvery;

  @override
  ConsumerState<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  final List<DmMessage> _messages = []; // newest first
  final _input = TextEditingController();
  Conversation? _conversation;
  Timer? _poll;
  bool _loading = true;
  bool _more = false;
  bool _sending = false;
  bool _started = false;
  String? _error;
  String? _problem;
  String? _forActor;
  String _key = _newKey();

  static String _newKey() => List.generate(24, (_) => Random.secure().nextInt(16).toRadixString(16)).join();

  @override
  void dispose() {
    _poll?.cancel();
    _input.dispose();
    super.dispose();
  }

  Future<void> _loadHead(SocialProfile actor) async {
    try {
      final c = await ref.read(inboxServiceProvider).conversation(actor: actor.id, id: widget.conversationId);
      if (mounted) setState(() => _conversation = c);
    } on SiteException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  Future<void> _load(SocialProfile actor, {bool older = false, bool quiet = false}) async {
    if (!quiet) setState(() => _loading = true);
    try {
      final page = await ref.read(inboxServiceProvider).messages(actor: actor.id, conversation: widget.conversationId, limit: _page, before: older && _messages.isNotEmpty ? _messages.last : null);
      if (!mounted) return;
      setState(() {
        if (older) {
          _messages.addAll(page);
          _more = page.length >= _page;
        } else if (_messages.isEmpty) {
          _messages.addAll(page);
          _more = page.length >= _page;
        } else {
          // Polling: put in only what is newer than what we have.
          final have = {for (final m in _messages) m.id};
          final fresh = [for (final m in page) if (!have.contains(m.id)) m];
          _messages.insertAll(0, fresh);
          // A message taken back or an answer to a share changes in place.
          for (final m in page) {
            final i = _messages.indexWhere((x) => x.id == m.id);
            if (i >= 0) _messages[i] = m;
          }
        }
        _error = null;
      });
      if (!older && _messages.isNotEmpty) {
        unawaited(ref.read(inboxServiceProvider).markRead(actor: actor.id, conversation: widget.conversationId).then((_) => ref.invalidate(inboxCountsProvider(actor.id))));
      }
    } on SiteException catch (e) {
      if (mounted && !quiet) setState(() => _error = e.message);
    } finally {
      if (mounted && !quiet) setState(() => _loading = false);
    }
  }

  Future<void> _send(SocialProfile actor) async {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    if (!await ensureRulesAccepted(context, ref)) return;
    setState(() {
      _sending = true;
      _problem = null;
    });
    try {
      final m = await ref.read(inboxServiceProvider).send(actor: actor.id, conversation: widget.conversationId, body: text, clientKey: _key);
      if (!mounted) return;
      setState(() {
        if (!_messages.any((x) => x.id == m.id)) _messages.insert(0, m);
        _input.clear();
        _key = _newKey();
        // Replying to a request accepts it.
        if (_conversation?.isRequest ?? false) _loadHead(actor);
      });
    } on SiteException catch (e) {
      if (mounted) setState(() => _problem = e.message);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _answer(SocialProfile actor, bool accept) async {
    try {
      await ref.read(inboxServiceProvider).answerRequest(actor: actor.id, conversation: widget.conversationId, accept: accept);
      ref.invalidate(inboxCountsProvider(actor.id));
      if (!mounted) return;
      if (accept) {
        _loadHead(actor);
      } else {
        context.canPop() ? context.pop() : context.go('/inbox');
      }
    } on SiteException catch (e) {
      if (mounted) setState(() => _problem = e.message);
    }
  }

  Future<void> _remove(SocialProfile actor, DmMessage m) async {
    final sure = await showModalBottomSheet<bool>(
      context: context,
      builder: (c) => SafeArea(child: ListTile(key: const Key('remove-message'), leading: const Icon(Icons.delete_outline), title: const Text('Remove this message'), onTap: () => c.pop(true))),
    );
    if (sure != true) return;
    try {
      await ref.read(inboxServiceProvider).deleteMessage(actor: actor.id, message: m.id);
      await _load(actor, quiet: true);
    } on SiteException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ActorGate(
      title: 'Messages',
      builder: (context, actor) {
        if (!_started || _forActor != actor.id) {
          _started = true;
          _forActor = actor.id;
          _poll?.cancel();
          _poll = Timer.periodic(widget.pollEvery, (_) {
            if (mounted && _error == null) _load(actor, quiet: true);
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _loadHead(actor);
            _load(actor);
          });
        }
        final c = _conversation;
        final isGroup = c?.kind == ConversationKind.group;
        return Scaffold(
          appBar: AppBar(
            title: Text(c?.displayTitle ?? 'Messages', key: const Key('conversation-title')),
            actions: [
              if (c != null && (isGroup || c.kind == ConversationKind.direct))
                IconButton(
                  key: const Key('conversation-info'),
                  tooltip: 'Details',
                  icon: const Icon(Icons.info_outline),
                  onPressed: () async {
                    await context.push('/inbox/${widget.conversationId}/info');
                    if (mounted) _loadHead(actor);
                  },
                ),
            ],
          ),
          body: Column(children: [
            Expanded(child: _list(actor, isGroup)),
            if (c != null && c.isRequest)
              Container(
                key: const Key('request-bar'),
                padding: const EdgeInsets.all(12),
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Column(children: [
                  const Text('This person does not follow you. Accept to move it to your messages, or decline to hide it. They will not be told.', textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(child: OutlinedButton(key: const Key('decline-request'), onPressed: () => _answer(actor, false), child: const Text('Decline'))),
                    const SizedBox(width: 8),
                    Expanded(child: FilledButton(key: const Key('accept-request'), onPressed: () => _answer(actor, true), child: const Text('Accept'))),
                  ]),
                ]),
              ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 8, 8),
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  if (_problem != null) Padding(padding: const EdgeInsets.only(bottom: 4), child: Text(_problem!, key: const Key('send-problem'), style: TextStyle(color: Theme.of(context).colorScheme.error))),
                  Row(children: [
                    Expanded(child: TextField(key: const Key('message-field'), controller: _input, minLines: 1, maxLines: 5, maxLength: 2000, textCapitalization: TextCapitalization.sentences, decoration: const InputDecoration(hintText: 'Message', counterText: ''))),
                    IconButton(key: const Key('send-message'), tooltip: 'Send', onPressed: _sending ? null : () => _send(actor), icon: const Icon(Icons.send)),
                  ]),
                ]),
              ),
            ),
          ]),
        );
      },
    );
  }

  Widget _list(SocialProfile actor, bool isGroup) {
    if (_error != null && _messages.isEmpty) {
      return LoadFailed(
        message: _error!,
        onRetry: () {
          setState(() => _error = null);
          _loadHead(actor);
          _load(actor);
        },
      );
    }
    if (_loading && _messages.isEmpty) return const Center(child: CircularProgressIndicator());
    if (_messages.isEmpty) return const Center(child: Text('Say hello.', key: Key('no-messages')));
    return ListView(
      key: const Key('message-list'),
      reverse: true,
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        for (final m in _messages) MessageBubble(message: m, showSender: isGroup, onLongPress: m.isMine && !m.removed ? () => _remove(actor, m) : null),
        if (_more) Padding(padding: const EdgeInsets.all(8), child: Center(child: TextButton(key: const Key('earlier'), onPressed: _loading ? null : () => _load(actor, older: true), child: const Text('Earlier messages')))),
      ],
    );
  }
}
