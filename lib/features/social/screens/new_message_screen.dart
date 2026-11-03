import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../site/models/social_profile.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/site_error.dart';
import '../widgets/profile_widgets.dart';

/// Find someone and start a conversation, or start a group. People are found by username or name; a person who does not follow you receives a request.
class NewMessageScreen extends ConsumerStatefulWidget {
  const NewMessageScreen({super.key, this.group = false});

  /// Pick several people and name the group.
  final bool group;

  @override
  ConsumerState<NewMessageScreen> createState() => _NewMessageScreenState();
}

class _NewMessageScreenState extends ConsumerState<NewMessageScreen> {
  final _search = TextEditingController();
  final _title = TextEditingController();
  Timer? _debounce;
  String _query = '';
  final List<SocialProfile> _chosen = [];
  bool _busy = false;
  String? _problem;

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    _title.dispose();
    super.dispose();
  }

  void _typed(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) setState(() => _query = v.trim());
    });
  }

  Future<void> _direct(SocialProfile actor, SocialProfile other) async {
    setState(() {
      _busy = true;
      _problem = null;
    });
    try {
      final id = await ref.read(inboxServiceProvider).startDirect(actor: actor.id, other: other.id);
      if (mounted) context.pushReplacement('/inbox/$id');
    } on SiteException catch (e) {
      if (mounted) setState(() => _problem = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _createGroup(SocialProfile actor) async {
    if (_title.text.trim().isEmpty) {
      setState(() => _problem = 'Give the group a name.');
      return;
    }
    if (_chosen.isEmpty) {
      setState(() => _problem = 'Choose at least one person to add.');
      return;
    }
    setState(() {
      _busy = true;
      _problem = null;
    });
    try {
      final id = await ref.read(inboxServiceProvider).startGroup(actor: actor.id, title: _title.text, members: [for (final p in _chosen) p.id]);
      if (mounted) context.pushReplacement('/inbox/$id');
    } on SiteException catch (e) {
      if (mounted) setState(() => _problem = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ActorGate(
      title: widget.group ? 'New group' : 'New message',
      builder: (context, actor) {
        final results = _query.length < 2 ? null : ref.watch(profileSearchProvider(SearchKey(actor: actor.id, query: _query)));
        return Scaffold(
          appBar: AppBar(title: Text(widget.group ? 'New group' : 'New message'), actions: [
            if (!widget.group) TextButton(key: const Key('new-group'), onPressed: () => context.pushReplacement('/inbox/new-group'), child: const Text('New group')),
          ]),
          body: ListView(key: const Key('new-message-form'), padding: const EdgeInsets.only(bottom: 96), children: [
            if (widget.group)
              Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 0), child: TextField(key: const Key('group-name'), controller: _title, maxLength: 60, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: 'Group name'))),
            if (_chosen.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(spacing: 6, children: [for (final p in _chosen) InputChip(key: Key('chosen-${p.handle}'), label: Text(p.displayName), onDeleted: () => setState(() => _chosen.remove(p)))]),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextField(key: const Key('person-search'), controller: _search, autofocus: !widget.group, onChanged: _typed, decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search people and businesses')),
            ),
            if (_problem != null) Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(_problem!, key: const Key('new-message-problem'), style: TextStyle(color: Theme.of(context).colorScheme.error))),
            if (results == null)
              const Padding(padding: EdgeInsets.all(24), child: Center(child: Text('Type at least 2 letters.')))
            else
              ...results.when(
                loading: () => const [Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator()))],
                error: (e, _) => [Padding(padding: const EdgeInsets.all(24), child: Text(e is SiteException ? e.message : loadFailedMessage('the results')))],
                data: (list) => list.isEmpty
                    ? const [Padding(padding: EdgeInsets.all(24), child: Center(child: Text('No one found.', key: Key('no-people'))))]
                    : [
                        for (final p in list)
                          widget.group
                              ? CheckboxListTile(
                                  key: Key('pick-${p.handle}'),
                                  value: _chosen.any((x) => x.id == p.id),
                                  onChanged: (_) => setState(() => _chosen.any((x) => x.id == p.id) ? _chosen.removeWhere((x) => x.id == p.id) : _chosen.add(p)),
                                  secondary: ProfileAvatar(profile: p),
                                  title: Text(p.displayName),
                                  subtitle: Text('@${p.handle}'),
                                )
                              : ProfileTile(profile: p, onTap: _busy ? null : () => _direct(actor, p)),
                      ],
              ),
            if (widget.group)
              Padding(padding: const EdgeInsets.all(16), child: FilledButton(key: const Key('create-group'), onPressed: _busy ? null : () => _createGroup(actor), child: Text(_busy ? 'Please wait...' : 'Create group'))),
          ]),
        );
      },
    );
  }
}
