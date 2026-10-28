import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../site/models/features.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/providers/site_providers.dart';

/// "Send a tip" on a business profile that is not the person's own. Nothing shows while tips are off, for a person's profile, for the person's own business, or for a profile they blocked.
class TipSection extends ConsumerWidget {
  const TipSection({super.key, required this.profile});

  final SocialProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!profile.isBusiness || profile.isMine || profile.blockedByMe || profile.suspended || !ref.watch(featureOnProvider(Feature.creatorEarnings))) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton.icon(key: const Key('send-tip'), onPressed: () => context.push('/tip/${profile.id}'), icon: const Icon(Icons.volunteer_activism_outlined), label: const Text('Send a tip')),
      ),
    );
  }
}
