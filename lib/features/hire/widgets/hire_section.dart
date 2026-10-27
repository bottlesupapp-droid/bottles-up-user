import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../site/models/features.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/providers/site_providers.dart';
import 'hire_widgets.dart';

/// On a venue's profile: Host your event here. On the venue's own profile it is the way to the requests it has had. Nothing shows for a profile that is not a venue or while hiring a
/// venue is not open.
class HireSection extends ConsumerWidget {
  const HireSection({super.key, required this.profile});

  final SocialProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!isVenueProfile(profile) || profile.blockedByMe || !ref.watch(featureOnProvider(Feature.venueHire))) return const SizedBox.shrink();
    if (profile.isMine) {
      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: OutlinedButton(key: const Key('open-hire-requests'), onPressed: () => context.push('/me/hire-requests'), child: const Text('Hire requests')),
      );
    }
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Card(
        key: const Key('host-here'),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Host your event here', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            const Text('Tell ${'the venue'} about your night. They answer with an offer, and nothing is booked until they confirm.'),
            const SizedBox(height: 8),
            FilledButton(key: const Key('host-here-button'), onPressed: () => context.push('/venues/${profile.id}/host'), child: const Text('Host your event here')),
          ]),
        ),
      ),
    );
  }
}
