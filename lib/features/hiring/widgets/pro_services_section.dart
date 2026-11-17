import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../site/models/features.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/hiring_rules.dart';
import 'hiring_widgets.dart';

/// On a professional's profile: what they offer and how to ask them for a job. On the professional's own profile it is the way to their services and the requests they have had.
/// Nothing shows for a profile that cannot be hired or while hiring is not open.
class ProServicesSection extends ConsumerWidget {
  const ProServicesSection({super.key, required this.profile});

  final SocialProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!isProfessional(profile) || profile.blockedByMe || !ref.watch(featureOnProvider(Feature.marketplace))) return const SizedBox.shrink();
    final theme = Theme.of(context);
    if (profile.isMine) {
      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Wrap(spacing: 8, children: [
          OutlinedButton(key: const Key('manage-services'), onPressed: () => context.push('/me/services'), child: const Text('My services and days')),
          OutlinedButton(key: const Key('open-pro-requests'), onPressed: () => context.push('/me/pro-requests'), child: const Text('Requests for me')),
        ]),
      );
    }
    final services = ref.watch(proServicesProvider(profile.id)).valueOrNull ?? const [];
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Card(
        key: const Key('pro-services'),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Hire ${profile.displayName}', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            if (services.isEmpty) const Text('Tell them what you need and they will send you a quote.', key: Key('pro-services-none')),
            for (final s in services)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: Text(s.title, key: Key('pro-service-${s.id}'))),
                  if (s.fromCents != null) Text('from ${cents(s.fromCents!)}${s.priceNote == null ? '' : ' ${s.priceNote}'}', style: theme.textTheme.bodySmall),
                ]),
              ),
            const SizedBox(height: 8),
            FilledButton(key: const Key('request-pro'), onPressed: () => context.push('/pros/${profile.id}/request'), child: const Text('Ask for a quote')),
          ]),
        ),
      ),
    );
  }
}
