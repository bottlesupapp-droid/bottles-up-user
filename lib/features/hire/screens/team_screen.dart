import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/hire.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/hire_rules.dart';
import '../../../site/rules/hiring_rules.dart';
import '../../../site/site_error.dart';
import '../../social/widgets/profile_widgets.dart';
import '../widgets/team_sheets.dart';

/// The team of a professional's profile: who has been let in, what each may do, who is still being asked. The owner invites, changes a role or takes access away (it ends at once);
/// a member sees the team and can leave. Only a professional's own profile has a team here: a venue or an event group is run by its business's own roles in BottlesUp Business.
class TeamScreen extends ConsumerStatefulWidget {
  const TeamScreen({super.key});

  @override
  ConsumerState<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends ConsumerState<TeamScreen> {
  bool _busy = false;

  void _say(String text) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));

  Future<void> _run(String actor, Future<void> Function() action, {String? done}) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
      if (done != null && mounted) _say(done);
      ref.invalidate(teamProvider(actor));
    } on SiteException catch (e) {
      if (mounted) _say(e.message);
      ref.invalidate(teamProvider(actor));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _invite(String actor) async {
    final r = await showInviteSheet(context);
    if (r == null || !mounted) return;
    await _run(actor, () => ref.read(hireServiceProvider).invite(actor: actor, handle: r.handle, role: r.pick.role, permissions: r.pick.permissions), done: 'The invitation was sent.');
  }

  Future<void> _change(String actor, TeamMember m) async {
    final r = await showRoleSheet(context, member: m);
    if (r == null || !mounted) return;
    await _run(actor, () => ref.read(hireServiceProvider).setRole(actor: actor, team: m.id, role: r.pick.role, permissions: r.pick.permissions), done: 'Their role was changed.');
  }

  Future<void> _revoke(String actor, TeamMember m) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(m.isActive ? 'Take away ${m.person?.name ?? 'their'} access?' : 'Take back the invitation?'),
        content: Text(m.isActive ? 'They stop being able to act as this profile at once.' : 'They will not be able to accept it.'),
        actions: [
          TextButton(key: const Key('revoke-keep'), onPressed: () => Navigator.pop(c, false), child: const Text('Keep it')),
          FilledButton(key: const Key('revoke-confirm'), onPressed: () => Navigator.pop(c, true), child: Text(m.isActive ? 'Take it away' : 'Take it back')),
        ],
      ),
    );
    if (yes != true || !mounted) return;
    await _run(actor, () => ref.read(hireServiceProvider).revoke(actor: actor, team: m.id), done: m.isActive ? 'Their access is gone.' : 'The invitation was taken back.');
  }

  Future<void> _leave(String actor, TeamMember m) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Leave this team?'),
        content: const Text('You stop being able to act as this profile at once. The owner can invite you again.'),
        actions: [
          TextButton(key: const Key('leave-keep'), onPressed: () => Navigator.pop(c, false), child: const Text('Stay')),
          FilledButton(key: const Key('leave-confirm'), onPressed: () => Navigator.pop(c, true), child: const Text('Leave')),
        ],
      ),
    );
    if (yes != true || !mounted) return;
    await _run(actor, () async {
      await ref.read(hireServiceProvider).leave(m.id);
      ref.invalidate(myProfilesProvider);
      ref.read(selectedProfileIdProvider.notifier).state = null;
      if (mounted && context.canPop()) context.pop();
    }, done: 'You left the team.');
  }

  void _chat(TeamInfo t) {
    if (t.chat == null || t.chatProfile == null) return;
    ref.read(selectedProfileIdProvider.notifier).state = t.chatProfile;
    context.push('/inbox/${t.chat}');
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Team';
    if (!ref.watch(teamsOnProvider)) {
      return Scaffold(appBar: AppBar(title: const Text(title)), body: const EmptyState(icon: Icons.hourglass_empty, title: 'Coming soon', text: 'Teams are not open yet.'));
    }
    return ActorGate(
      title: title,
      builder: (context, actor) {
        if (!isProfessional(actor)) {
          return Scaffold(
            appBar: AppBar(title: const Text(title)),
            body: const EmptyState(icon: Icons.groups_outlined, title: 'Switch to a professional profile', text: 'A team belongs to a professional profile (a DJ, a photographer...): switch to yours from the Profile tab. A venue or event group is run from BottlesUp Business.'),
          );
        }
        final team = ref.watch(teamProvider(actor.id));
        final me = ref.watch(myProfilesProvider).valueOrNull?.where((p) => !p.isBusiness).firstOrNull;
        return Scaffold(
          appBar: AppBar(title: Text('Team of ${actor.displayName}')),
          floatingActionButton: team.valueOrNull?.canManage == true && (team.requireValue.members.length < maxTeamSize)
              ? FloatingActionButton.extended(key: const Key('team-invite'), onPressed: _busy ? null : () => _invite(actor.id), icon: const Icon(Icons.person_add_alt_1_outlined), label: const Text('Invite someone'))
              : null,
          body: team.when(
            skipLoadingOnRefresh: true,
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('the team'), onRetry: () => ref.invalidate(teamProvider(actor.id))),
            data: (t) => RefreshIndicator(
              onRefresh: () async => ref.invalidate(teamProvider(actor.id)),
              child: ListView(key: const Key('team-list'), physics: const AlwaysScrollableScrollPhysics(), padding: const EdgeInsets.fromLTRB(0, 8, 0, 96), children: [
                ListTile(key: const Key('team-owner'), leading: const CircleAvatar(child: Icon(Icons.star_outline)), title: Text(t.owner?.name ?? 'The owner'), subtitle: const Text('Owner: can do everything')),
                if (t.members.isEmpty) const Padding(padding: EdgeInsets.fromLTRB(16, 16, 16, 8), child: Text('No one else has access yet. Invite a manager or a booking agent and they will be asked to accept.', key: Key('team-empty'))),
                for (final m in t.members)
                  ListTile(
                    key: Key('member-${m.id}'),
                    leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                    title: Text(m.person?.name ?? 'A person'),
                    subtitle: Text('${m.role.label}${m.role == TeamRole.custom ? ': ${m.permissions.map((p) => teamPermissionLabels[p] ?? p).join(', ')}' : ' · ${m.role.summary}'}${m.isActive ? '' : ' · waiting for an answer'}'),
                    trailing: t.canManage
                        ? PopupMenuButton<String>(
                            key: Key('member-menu-${m.id}'),
                            onSelected: (v) => v == 'role' ? _change(actor.id, m) : _revoke(actor.id, m),
                            itemBuilder: (_) => [
                              const PopupMenuItem(value: 'role', child: Text('Change the role')),
                              PopupMenuItem(value: 'revoke', child: Text(m.isActive ? 'Take away access' : 'Take back the invitation')),
                            ],
                          )
                        : (m.isActive && me != null && m.person?.handle == me.handle ? TextButton(key: Key('member-leave-${m.id}'), onPressed: _busy ? null : () => _leave(actor.id, m), child: const Text('Leave')) : null),
                  ),
                if (t.chat != null) Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 0), child: OutlinedButton.icon(key: const Key('team-chat'), onPressed: () => _chat(t), icon: const Icon(Icons.chat_bubble_outline), label: const Text('Team chat'))),
                const Padding(padding: EdgeInsets.fromLTRB(16, 16, 16, 0), child: Text('Everyone uses their own login. Every invitation and every change is logged.', key: Key('team-note'))),
              ]),
            ),
          ),
        );
      },
    );
  }
}
