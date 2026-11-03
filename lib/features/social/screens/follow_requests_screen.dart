import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/site_error.dart';
import '../widgets/profile_widgets.dart';

/// People waiting for the owner of a private profile to let them follow.
class FollowRequestsScreen extends ConsumerWidget {
  const FollowRequestsScreen({super.key});

  Future<void> _answer(BuildContext context, WidgetRef ref, SocialProfile actor, SocialProfile other, String action) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(socialProfilesServiceProvider).respond(actor: actor.id, other: other.id, action: action);
      ref.invalidate(followRequestsProvider(actor.id));
      ref.invalidate(socialProfileProvider);
      ref.invalidate(peopleProvider);
    } on SiteException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
      ref.invalidate(followRequestsProvider(actor.id));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ActorGate(
      title: 'Follow requests',
      builder: (context, actor) {
        final requests = ref.watch(followRequestsProvider(actor.id));
        return Scaffold(
          appBar: AppBar(title: const Text('Follow requests')),
          body: requests.when(
            skipLoadingOnRefresh: true,
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('the requests'), onRetry: () => ref.invalidate(followRequestsProvider(actor.id))),
            data: (list) => list.isEmpty
                ? const EmptyState(icon: Icons.person_add_alt_outlined, title: 'No requests', text: 'When someone asks to follow you they will show here.')
                : ListView(key: const Key('requests-list'), padding: const EdgeInsets.only(bottom: 96), children: [
                    for (final p in list)
                      ProfileTile(
                        profile: p,
                        onTap: () => context.push('/u/${p.handle}'),
                        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                          FilledButton(key: Key('accept-${p.handle}'), style: const ButtonStyle(visualDensity: VisualDensity.compact), onPressed: () => _answer(context, ref, actor, p, 'accept'), child: const Text('Accept')),
                          const SizedBox(width: 6),
                          OutlinedButton(key: Key('decline-${p.handle}'), style: const ButtonStyle(visualDensity: VisualDensity.compact), onPressed: () => _answer(context, ref, actor, p, 'decline'), child: const Text('Decline')),
                        ]),
                      ),
                  ]),
          ),
        );
      },
    );
  }
}
