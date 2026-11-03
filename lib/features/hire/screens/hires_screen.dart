import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/features.dart';
import '../../../site/models/hire.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/site_error.dart';
import '../../social/widgets/profile_widgets.dart';
import '../widgets/hire_widgets.dart';

/// The hires a group has asked venues for, or (as a venue) the requests it has had. What needs an answer comes first.
class HiresScreen extends ConsumerWidget {
  const HiresScreen({super.key, this.asVenue = false});

  final bool asVenue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = asVenue ? 'Hire requests' : 'My hires';
    if (!ref.watch(featureOnProvider(Feature.venueHire))) {
      return Scaffold(appBar: AppBar(title: Text(title)), body: const EmptyState(icon: Icons.hourglass_empty, title: 'Coming soon', text: 'Hosting events at venues is not open yet.'));
    }
    return ActorGate(
      title: title,
      builder: (context, actor) {
        final fits = asVenue ? isVenueProfile(actor) : isOrganizerProfile(actor);
        if (!fits) {
          return Scaffold(
            appBar: AppBar(title: Text(title)),
            body: EmptyState(
              icon: asVenue ? Icons.storefront_outlined : Icons.celebration_outlined,
              title: asVenue ? 'Switch to your venue profile' : 'Switch to your event group',
              text: asVenue ? 'Hire requests go to a venue\'s profile: switch to it from the Profile tab.' : 'Hosting an event is asked by an event group or a promoter: switch to yours from the Profile tab.',
            ),
          );
        }
        final data = asVenue ? ref.watch(hiresForProvider(actor.id)) : ref.watch(hiresMineProvider(actor.id));
        void reload() => ref.invalidate(asVenue ? hiresForProvider(actor.id) : hiresMineProvider(actor.id));
        return Scaffold(
          appBar: AppBar(title: Text(title)),
          body: data.when(
            skipLoadingOnRefresh: true,
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('the hires'), onRetry: reload),
            data: (list) {
              if (list.isEmpty) {
                return EmptyState(
                  icon: asVenue ? Icons.storefront_outlined : Icons.celebration_outlined,
                  title: asVenue ? 'No requests yet' : 'You have not asked a venue yet',
                  text: asVenue ? 'When a group asks to host an event here, it shows here.' : 'Open a venue\'s profile and choose Host your event here.',
                );
              }
              bool needsAnswer(Hire h) => asVenue ? (h.state == HireState.requested || h.state == HireState.agreed || h.state == HireState.offerExpired) : h.hasLiveOffer;
              final first = [for (final h in list) if (needsAnswer(h)) h];
              final rest = [for (final h in list) if (!needsAnswer(h)) h];
              Widget tile(Hire h) => HireTile(hire: h, onTap: () => context.push('/hires/${h.id}?as=${actor.id}'));
              return RefreshIndicator(
                onRefresh: () async => reload(),
                child: ListView(key: const Key('hires-list'), physics: const AlwaysScrollableScrollPhysics(), padding: const EdgeInsets.only(bottom: 40), children: [
                  if (first.isNotEmpty) Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 4), child: Text(asVenue ? 'Waiting for you' : 'Offers to answer', style: Theme.of(context).textTheme.titleSmall)),
                  for (final h in first) tile(h),
                  if (rest.isNotEmpty && first.isNotEmpty) Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 4), child: Text('Everything else', style: Theme.of(context).textTheme.titleSmall)),
                  for (final h in rest) tile(h),
                ]),
              );
            },
          ),
        );
      },
    );
  }
}
