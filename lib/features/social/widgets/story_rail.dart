import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../site/models/features.dart';
import '../../../site/models/post.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/providers/site_providers.dart';
import 'post_widgets.dart';
import 'profile_widgets.dart';

/// The row of stories at the top of the home feed: your own first, then the profiles you follow that have a story up. The ring is grey once you have watched everything,
/// BottlesUp orange for a Members Only story, and blue for a new one. Nothing shows while stories are switched off.
class StoryRail extends ConsumerWidget {
  const StoryRail({super.key, required this.actor});

  final SocialProfile actor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(featureOnProvider(Feature.stories))) return const SizedBox.shrink();
    final rail = ref.watch(storyRailProvider(actor.id)).valueOrNull ?? const <StoryRailItem>[];
    StoryRailItem? mine;
    for (final i in rail) {
      if (i.isMine) mine = i;
    }
    return SizedBox(
      key: const Key('story-rail'),
      height: 104,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        children: [
          _Bubble(
            key: const Key('your-story'),
            profile: actor,
            label: 'Your story',
            ring: mine == null ? null : Colors.grey,
            plus: true,
            onTap: () => mine == null ? context.push('/create?kind=story') : context.push('/stories/${actor.handle}'),
          ),
          for (final i in rail)
            if (!i.isMine)
              _Bubble(
                key: Key('story-${i.profile.handle}'),
                profile: i.profile,
                label: i.profile.displayName,
                ring: i.membersOnly ? membersOnlyColor : (i.unseen ? Colors.blueAccent : Colors.grey),
                onTap: () => context.push('/stories/${i.profile.handle}'),
              ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({super.key, required this.profile, required this.label, required this.onTap, this.ring, this.plus = false});

  final SocialProfile profile;
  final String label;
  final Color? ring;
  final bool plus;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: SizedBox(
        width: 76,
        child: Column(children: [
          Stack(children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(shape: BoxShape.circle, border: ring == null ? null : Border.all(color: ring!, width: 2.5)),
              child: ProfileAvatar(profile: profile, size: 56),
            ),
            if (plus)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle), child: const Icon(Icons.add, size: 18, color: Colors.white)),
              ),
          ]),
          const SizedBox(height: 4),
          Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall),
        ]),
      ),
    );
  }
}
