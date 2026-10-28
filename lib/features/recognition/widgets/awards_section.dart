import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../site/models/features.dart';
import '../../../site/models/recognition.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/providers/site_providers.dart';

/// The ranks a profile holds, on its page: one chip each, the highest first. Nothing shows when ranks are off or there are none.
class AwardsSection extends ConsumerWidget {
  const AwardsSection({super.key, required this.actor, required this.profile});

  final SocialProfile actor;
  final SocialProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(featureOnProvider(Feature.ranks)) || !profile.verified || profile.blockedByMe) return const SizedBox.shrink();
    final awards = ref.watch(awardsProvider((actor: actor.id, profile: profile.id))).valueOrNull ?? const <Award>[];
    if (awards.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(key: const Key('awards-section'), crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Awards', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 4),
        Wrap(spacing: 8, runSpacing: 4, children: [
          for (final a in awards)
            Chip(
              key: Key('award-${a.level}'),
              avatar: Icon(Icons.verified, color: Color(a.colour), size: 18),
              label: Text(a.name),
              visualDensity: VisualDensity.compact,
            ),
        ]),
      ]),
    );
  }
}
