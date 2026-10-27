import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/features.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/post_rules.dart';
import '../../../site/site_error.dart';
import '../widgets/post_widgets.dart';
import '../widgets/profile_widgets.dart';

/// The Members Only list: people you chose, who also follow you, and who can see your Members Only posts and stories. Taking someone off ends their access at once; nobody is told
/// either way.
class MembersScreen extends ConsumerStatefulWidget {
  const MembersScreen({super.key});

  @override
  ConsumerState<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends ConsumerState<MembersScreen> {
  List<SocialProfile>? _members;
  String? _error;
  bool _started = false;
  String? _forActor;

  Future<void> _load(SocialProfile actor) async {
    setState(() => _error = null);
    try {
      final list = await ref.read(postsServiceProvider).members(actor: actor.id, limit: 200);
      if (mounted) setState(() => _members = list);
    } on SiteException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  Future<void> _set(SocialProfile actor, SocialProfile who, bool isMember) async {
    try {
      await ref.read(postsServiceProvider).setMember(actor: actor.id, member: who.id, isMember: isMember);
      await _load(actor);
    } on SiteException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _add(SocialProfile actor) async {
    final chosen = await showModalBottomSheet<SocialProfile>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _FollowerPicker(actor: actor, members: {for (final m in _members ?? const <SocialProfile>[]) m.id}),
    );
    if (chosen != null) await _set(actor, chosen, true);
  }

  @override
  Widget build(BuildContext context) {
    return ActorGate(
      title: 'Members Only',
      builder: (context, actor) {
        if (!ref.watch(featureOnProvider(Feature.membersOnly))) {
          return Scaffold(appBar: AppBar(title: const Text('Members Only')), body: const EmptyState(icon: Icons.hourglass_empty, title: 'Coming soon', text: 'Members Only is not open yet.'));
        }
        if (!_started || _forActor != actor.id) {
          _started = true;
          _forActor = actor.id;
          _members = null;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _load(actor);
          });
        }
        final members = _members;
        return Scaffold(
          appBar: AppBar(title: const Text('Members Only')),
          floatingActionButton: FloatingActionButton.extended(key: const Key('add-member'), onPressed: () => _add(actor), icon: const Icon(Icons.person_add_alt_1), label: const Text('Add from followers')),
          body: _error != null && members == null
              ? LoadFailed(message: _error!, onRetry: () => _load(actor))
              : members == null
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(key: const Key('members-list'), padding: const EdgeInsets.only(bottom: 96), children: [
                      Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: membersOnlyColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                        child: Text('${members.length} of $maxMembers members. Members see your Members Only posts and stories, marked with an orange ring. They are never told they were added or removed.', key: const Key('members-explainer')),
                      ),
                      if (members.isEmpty) const Padding(padding: EdgeInsets.all(24), child: Center(child: Text('No members yet. Add people who follow you.', key: Key('no-members')))),
                      for (final m in members)
                        ProfileTile(
                          profile: m,
                          onTap: () => context.push('/u/${m.handle}'),
                          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                            if (!m.stillFollowing) const Tooltip(message: 'Does not follow you any more, so sees nothing', child: Icon(Icons.warning_amber_rounded, key: Key('not-following'), size: 20)),
                            IconButton(key: Key('remove-member-${m.handle}'), tooltip: 'Remove', icon: const Icon(Icons.remove_circle_outline), onPressed: () => _set(actor, m, false)),
                          ]),
                        ),
                    ]),
        );
      },
    );
  }
}

class _FollowerPicker extends ConsumerStatefulWidget {
  const _FollowerPicker({required this.actor, required this.members});

  final SocialProfile actor;
  final Set<String> members;

  @override
  ConsumerState<_FollowerPicker> createState() => _FollowerPickerState();
}

class _FollowerPickerState extends ConsumerState<_FollowerPicker> {
  List<SocialProfile>? _followers;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final list = await ref.read(socialProfilesServiceProvider).people(actor: widget.actor.id, profile: widget.actor.id, followers: true, limit: 50);
      if (mounted) setState(() => _followers = list);
    } on SiteException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final f = _followers;
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: _error != null
            ? LoadFailed(message: _error!, onRetry: _load)
            : f == null
                ? const Center(child: CircularProgressIndicator())
                : ListView(key: const Key('follower-picker'), children: [
                    const Padding(padding: EdgeInsets.fromLTRB(16, 0, 16, 8), child: Text('Your followers', style: TextStyle(fontWeight: FontWeight.w800))),
                    if (f.isEmpty) const Padding(padding: EdgeInsets.all(24), child: Text('Nobody follows you yet.')),
                    for (final p in f)
                      ProfileTile(
                        profile: p,
                        trailing: widget.members.contains(p.id)
                            ? const Text('Member', key: Key('already-member'))
                            : FilledButton(key: Key('pick-member-${p.handle}'), style: const ButtonStyle(visualDensity: VisualDensity.compact), onPressed: () => Navigator.of(context).pop(p), child: const Text('Add')),
                      ),
                  ]),
      ),
    );
  }
}
