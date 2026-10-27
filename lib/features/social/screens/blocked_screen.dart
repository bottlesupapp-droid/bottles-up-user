import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/site_error.dart';
import '../widgets/profile_widgets.dart';

/// The profiles the person has blocked, with a way to unblock each. Unblocking does not bring back any follow that was removed.
class BlockedScreen extends ConsumerWidget {
  const BlockedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ActorGate(
      title: 'Blocked profiles',
      builder: (context, actor) {
        final blocked = ref.watch(blockedProfilesProvider(actor.id));
        return Scaffold(
          appBar: AppBar(title: const Text('Blocked profiles')),
          body: blocked.when(
            skipLoadingOnRefresh: true,
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('the blocked profiles'), onRetry: () => ref.invalidate(blockedProfilesProvider(actor.id))),
            data: (list) => list.isEmpty
                ? const EmptyState(icon: Icons.block, title: 'Nobody blocked', text: 'Profiles you block will show here. They are never told.')
                : ListView(key: const Key('blocked-list'), padding: const EdgeInsets.only(bottom: 96), children: [
                    for (final p in list)
                      ProfileTile(
                        profile: p,
                        trailing: OutlinedButton(
                          key: Key('unblock-${p.handle}'),
                          style: const ButtonStyle(visualDensity: VisualDensity.compact),
                          onPressed: () async {
                            final messenger = ScaffoldMessenger.of(context);
                            try {
                              await ref.read(socialProfilesServiceProvider).setBlocked(actor: actor.id, target: p.id, blocked: false);
                              ref.invalidate(blockedProfilesProvider(actor.id));
                              ref.invalidate(socialProfileProvider);
                            } on SiteException catch (e) {
                              messenger.showSnackBar(SnackBar(content: Text(e.message)));
                            }
                          },
                          child: const Text('Unblock'),
                        ),
                      ),
                  ]),
          ),
        );
      },
    );
  }
}
