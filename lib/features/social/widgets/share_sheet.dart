import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../site/models/inbox.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/site_error.dart';
import 'message_widgets.dart';
import 'profile_widgets.dart';
import 'rules_gate.dart';

/// Send a post (or an event or a venue) to someone in a message: pick a recent conversation, or search for a person. Answers true when it was sent.
Future<bool> showShareSheet(BuildContext context, {required SocialProfile actor, required String refKind, required String refId}) async {
  final sent = await showModalBottomSheet<bool>(context: context, isScrollControlled: true, showDragHandle: true, builder: (_) => _ShareSheet(actor: actor, refKind: refKind, refId: refId));
  return sent == true;
}

class _ShareSheet extends ConsumerStatefulWidget {
  const _ShareSheet({required this.actor, required this.refKind, required this.refId});

  final SocialProfile actor;
  final String refKind;
  final String refId;

  @override
  ConsumerState<_ShareSheet> createState() => _ShareSheetState();
}

class _ShareSheetState extends ConsumerState<_ShareSheet> {
  final _search = TextEditingController();
  final _note = TextEditingController();
  Timer? _debounce;
  String _query = '';
  List<Conversation>? _recent;
  bool _busy = false;
  String? _problem;

  @override
  void initState() {
    super.initState();
    ref.read(inboxServiceProvider).inbox(actor: widget.actor.id, limit: 10).then((l) {
      if (mounted) setState(() => _recent = l);
    }).catchError((Object _) {
      if (mounted) setState(() => _recent = const []);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _sendTo(Future<String> Function() conversation) async {
    if (!await ensureRulesAccepted(context, ref)) return;
    setState(() {
      _busy = true;
      _problem = null;
    });
    try {
      final id = await conversation();
      await ref.read(inboxServiceProvider).send(actor: widget.actor.id, conversation: id, body: _note.text.trim().isEmpty ? null : _note.text, refKind: widget.refKind, refId: widget.refId);
      ref.invalidate(inboxCountsProvider(widget.actor.id));
      if (mounted) Navigator.of(context).pop(true);
    } on SiteException catch (e) {
      if (mounted) setState(() => _problem = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final results = _query.length < 2 ? null : ref.watch(profileSearchProvider(SearchKey(actor: widget.actor.id, query: _query)));
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
              child: TextField(
                key: const Key('share-search'),
                controller: _search,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search people'),
                onChanged: (v) {
                  _debounce?.cancel();
                  _debounce = Timer(const Duration(milliseconds: 350), () {
                    if (mounted) setState(() => _query = v.trim());
                  });
                },
              ),
            ),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: TextField(key: const Key('share-note'), controller: _note, maxLength: 500, decoration: const InputDecoration(hintText: 'Add a note (optional)', counterText: ''))),
            if (_problem != null) Padding(padding: const EdgeInsets.all(8), child: Text(_problem!, key: const Key('share-problem'), style: TextStyle(color: Theme.of(context).colorScheme.error))),
            Expanded(
              child: results != null
                  ? results.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (_, __) => const Center(child: Text('We could not search just now.')),
                      data: (list) => ListView(children: [
                        for (final p in list) ProfileTile(profile: p, trailing: const Text('Send'), onTap: _busy ? null : () => _sendTo(() => ref.read(inboxServiceProvider).startDirect(actor: widget.actor.id, other: p.id))),
                      ]),
                    )
                  : _recent == null
                      ? const Center(child: CircularProgressIndicator())
                      : ListView(key: const Key('share-recent'), children: [
                          for (final c in _recent!) ConversationTile(conversation: c, onTap: _busy ? () {} : () => _sendTo(() async => c.id)),
                          if (_recent!.isEmpty) const Padding(padding: EdgeInsets.all(24), child: Center(child: Text('Search for someone to send it to.'))),
                        ]),
            ),
          ]),
        ),
      ),
    );
  }
}
