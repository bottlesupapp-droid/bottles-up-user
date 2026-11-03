import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../site/models/hire.dart';
import '../../../site/providers/site_providers.dart';
import 'hire_widgets.dart';

/// On Home: an offer from a venue waiting for the group's answer, or (on a venue profile) requests waiting for an offer and agreements waiting for the venue's confirmation.
class HireCard extends ConsumerWidget {
  const HireCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actor = ref.watch(actorProfileProvider);
    if (actor == null) return const SizedBox.shrink();
    final theme = Theme.of(context);
    if (isOrganizerProfile(actor)) {
      final offers = [for (final h in ref.watch(hiresMineProvider(actor.id)).valueOrNull ?? const <Hire>[]) if (h.hasLiveOffer) h];
      if (offers.isEmpty) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Card(
          key: const Key('offers-to-answer'),
          child: ListTile(
            leading: CircleAvatar(backgroundColor: theme.colorScheme.primaryContainer, child: const Icon(Icons.storefront_outlined)),
            title: Text(offers.length == 1 ? '${offers.first.venue?.displayName ?? 'A venue'} made you an offer' : '${offers.length} venues made you an offer', style: theme.textTheme.titleSmall),
            subtitle: const Text('Tap to answer'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(offers.length == 1 ? '/hires/${offers.first.id}?as=${actor.id}' : '/me/hires'),
          ),
        ),
      );
    }
    if (isVenueProfile(actor)) {
      final waiting = [for (final h in ref.watch(hiresForProvider(actor.id)).valueOrNull ?? const <Hire>[]) if (h.state == HireState.requested || h.state == HireState.agreed) h];
      if (waiting.isEmpty) return const SizedBox.shrink();
      final agreed = waiting.where((h) => h.state == HireState.agreed).length;
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Card(
          key: const Key('hires-waiting'),
          child: ListTile(
            leading: CircleAvatar(backgroundColor: theme.colorScheme.primaryContainer, child: const Icon(Icons.celebration_outlined)),
            title: Text(waiting.length == 1 ? '${waiting.first.organizer?.displayName ?? 'A group'} wants to host a night' : '${waiting.length} groups are waiting for you', style: theme.textTheme.titleSmall),
            subtitle: Text(agreed > 0 ? '$agreed to confirm · tap to answer' : 'Tap to answer'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(waiting.length == 1 ? '/hires/${waiting.first.id}?as=${actor.id}' : '/me/hire-requests'),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
