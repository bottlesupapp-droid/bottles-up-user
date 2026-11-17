import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../site/models/hire.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/site_error.dart';

/// On Home: invitations to join somebody's team, with Accept and Decline. Nothing when there is none or teams are not open.
class TeamInvitationsCard extends ConsumerStatefulWidget {
  const TeamInvitationsCard({super.key});

  @override
  ConsumerState<TeamInvitationsCard> createState() => _TeamInvitationsCardState();
}

class _TeamInvitationsCardState extends ConsumerState<TeamInvitationsCard> {
  final Set<String> _busy = {};

  Future<void> _answer(TeamInvitation i, bool accept) async {
    if (_busy.contains(i.id)) return;
    setState(() => _busy.add(i.id));
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(hireServiceProvider).answerInvitation(team: i.id, accept: accept);
      ref.invalidate(teamInvitationsProvider);
      // A team the person joined adds a profile they can act as.
      if (accept) ref.invalidate(myProfilesProvider);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(accept ? 'You joined the team of ${i.profile.displayName}.' : 'You turned the invitation down.')));
    } on SiteException catch (e) {
      ref.invalidate(teamInvitationsProvider);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _busy.remove(i.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = ref.watch(teamInvitationsProvider).valueOrNull ?? const <TeamInvitation>[];
    if (list.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(children: [
        for (final i in list)
          Card(
            key: Key('team-invitation-${i.id}'),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${i.profile.displayName} asked you to join their team', style: theme.textTheme.titleSmall),
                const SizedBox(height: 2),
                Text('As ${i.role.label}: ${i.role == TeamRole.custom ? i.permissions.map((p) => teamPermissionLabels[p] ?? p).join(', ') : i.role.summary}.'),
                const SizedBox(height: 8),
                Row(children: [
                  FilledButton(key: Key('team-accept-${i.id}'), onPressed: _busy.contains(i.id) ? null : () => _answer(i, true), child: const Text('Accept')),
                  const SizedBox(width: 8),
                  TextButton(key: Key('team-decline-${i.id}'), onPressed: _busy.contains(i.id) ? null : () => _answer(i, false), child: const Text('Decline')),
                ]),
              ]),
            ),
          ),
      ]),
    );
  }
}
