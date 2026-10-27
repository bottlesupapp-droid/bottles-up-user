import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/inbox.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/site_error.dart';
import '../widgets/profile_widgets.dart';

/// The people in a conversation. In a group an admin can rename it, add and remove people; anyone can mute it or leave.
class GroupInfoScreen extends ConsumerStatefulWidget {
  const GroupInfoScreen({super.key, required this.conversationId});

  final String conversationId;

  @override
  ConsumerState<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends ConsumerState<GroupInfoScreen> {
  Conversation? _conversation;
  List<DmPerson>? _people;
  String? _error;
  bool _started = false;
  String? _forActor;

  Future<void> _load(SocialProfile actor) async {
    try {
      final service = ref.read(inboxServiceProvider);
      final c = await service.conversation(actor: actor.id, id: widget.conversationId);
      final p = await service.people(actor: actor.id, conversation: widget.conversationId);
      if (mounted) {
        setState(() {
          _conversation = c;
          _people = p;
          _error = null;
        });
      }
    } on SiteException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  /// Runs [action], then reads the screen again. Answers false (after saying why) when the website refused.
  Future<bool> _do(SocialProfile actor, Future<void> Function() action, {bool reload = true}) async {
    try {
      await action();
      if (reload) await _load(actor);
      return true;
    } on SiteException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      return false;
    }
  }

  Future<void> _rename(SocialProfile actor) async {
    final title = await showDialog<String>(context: context, builder: (_) => _RenameDialog(current: _conversation?.title ?? ''));
    if (title == null || !mounted) return;
    await _do(actor, () => ref.read(inboxServiceProvider).renameGroup(actor: actor.id, conversation: widget.conversationId, title: title));
  }

  Future<void> _add(SocialProfile actor) async {
    final picked = await showModalBottomSheet<SocialProfile>(context: context, isScrollControlled: true, showDragHandle: true, builder: (_) => _AddSheet(actor: actor));
    if (picked == null || !mounted) return;
    await _do(actor, () => ref.read(inboxServiceProvider).addToGroup(actor: actor.id, conversation: widget.conversationId, member: picked.id));
  }

  @override
  Widget build(BuildContext context) {
    return ActorGate(
      title: 'Details',
      builder: (context, actor) {
        if (!_started || _forActor != actor.id) {
          _started = true;
          _forActor = actor.id;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _load(actor);
          });
        }
        final c = _conversation;
        final people = _people;
        final isGroup = c?.kind == ConversationKind.group;
        final iAmAdmin = people?.any((p) => p.profile.id == actor.id && p.isAdmin) ?? false;
        return Scaffold(
          appBar: AppBar(title: Text(isGroup ? 'Group details' : 'Details')),
          body: _error != null && people == null
              ? LoadFailed(message: _error!, onRetry: () => _load(actor))
              : people == null || c == null
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(key: const Key('group-info'), children: [
                      if (isGroup)
                        ListTile(
                          key: const Key('group-title'),
                          title: Text(c.title ?? ''),
                          subtitle: Text('${people.length} people'),
                          trailing: iAmAdmin ? IconButton(key: const Key('rename-group'), tooltip: 'Rename', icon: const Icon(Icons.edit_outlined), onPressed: () => _rename(actor)) : null,
                        ),
                      SwitchListTile(
                        key: const Key('mute-switch'),
                        value: c.muted,
                        title: const Text('Mute notifications'),
                        onChanged: (v) => _do(actor, () => ref.read(inboxServiceProvider).mute(actor: actor.id, conversation: widget.conversationId, muted: v)),
                      ),
                      if (isGroup && iAmAdmin) ListTile(key: const Key('add-person'), leading: const Icon(Icons.person_add_alt_1), title: const Text('Add people'), onTap: () => _add(actor)),
                      const Divider(),
                      for (final p in people)
                        ProfileTile(
                          profile: p.profile,
                          onTap: () => context.push('/u/${p.profile.handle}'),
                          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                            if (p.isAdmin) const Padding(padding: EdgeInsets.only(right: 6), child: Chip(key: Key('admin-chip'), label: Text('Admin'), visualDensity: VisualDensity.compact)),
                            if (p.pending) const Padding(padding: EdgeInsets.only(right: 6), child: Text('Invited', key: Key('invited'))),
                            if (isGroup && iAmAdmin && p.profile.id != actor.id)
                              IconButton(key: Key('remove-${p.profile.handle}'), tooltip: 'Remove', icon: const Icon(Icons.remove_circle_outline), onPressed: () => _do(actor, () => ref.read(inboxServiceProvider).removeFromGroup(actor: actor.id, conversation: widget.conversationId, member: p.profile.id))),
                          ]),
                        ),
                      if (isGroup)
                        ListTile(
                          key: const Key('leave-group'),
                          leading: Icon(Icons.exit_to_app, color: Theme.of(context).colorScheme.error),
                          title: Text('Leave group', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                          onTap: () async {
                            final navigator = GoRouter.of(context);
                            final left = await _do(actor, () => ref.read(inboxServiceProvider).leaveGroup(actor: actor.id, conversation: widget.conversationId), reload: false);
                            if (left && mounted) navigator.go('/inbox');
                          },
                        ),
                    ]),
        );
      },
    );
  }
}

/// Owns its text box, so the box lives as long as the dialog's closing animation.
class _RenameDialog extends StatefulWidget {
  const _RenameDialog({required this.current});

  final String current;

  @override
  State<_RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<_RenameDialog> {
  late final TextEditingController _controller = TextEditingController(text: widget.current);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rename the group'),
      content: TextField(key: const Key('rename-field'), controller: _controller, maxLength: 60, autofocus: true),
      actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')), FilledButton(key: const Key('rename-save'), onPressed: () => Navigator.of(context).pop(_controller.text), child: const Text('Save'))],
    );
  }
}

class _AddSheet extends ConsumerStatefulWidget {
  const _AddSheet({required this.actor});

  final SocialProfile actor;

  @override
  ConsumerState<_AddSheet> createState() => _AddSheetState();
}

class _AddSheetState extends ConsumerState<_AddSheet> {
  final _search = TextEditingController();
  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = _query.length < 2 ? null : ref.watch(profileSearchProvider(SearchKey(actor: widget.actor.id, query: _query)));
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              key: const Key('add-search'),
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
          Expanded(
            child: results == null
                ? const Center(child: Text('Type at least 2 letters.'))
                : results.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (_, __) => const Center(child: Text('We could not search just now.')),
                    data: (list) => ListView(children: [for (final p in list) ProfileTile(profile: p, onTap: () => Navigator.of(context).pop(p))]),
                  ),
          ),
        ]),
      ),
    );
  }
}
