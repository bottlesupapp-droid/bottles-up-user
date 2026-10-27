import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../site/models/features.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/hiring_rules.dart';
import '../../../site/site_error.dart';
import '../../hire/widgets/hire_widgets.dart';
import 'business_tools_card.dart';
import 'my_night_card.dart';
import 'profile_widgets.dart';
import 'switcher_sheet.dart';

/// The way into the social side from the Profile tab: set up a profile, or open the one the person is acting as. Nothing shows until BottlesUp switches social on.
class SocialEntryCard extends ConsumerWidget {
  const SocialEntryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(featureOnProvider(Feature.social))) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final profiles = ref.watch(myProfilesProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: profiles.when(
        loading: () => const SizedBox(height: 72, child: Center(child: CircularProgressIndicator())),
        error: (e, _) => Card(
          child: ListTile(
            key: const Key('social-entry-error'),
            title: Text(e is SiteException ? e.message : loadFailedMessage('your profile')),
            trailing: TextButton(onPressed: () => ref.invalidate(myProfilesProvider), child: const Text('Try again')),
          ),
        ),
        data: (list) {
          final actor = ref.watch(actorProfileProvider);
          if (actor == null) {
            return Card(
              key: const Key('social-entry'),
              child: ListTile(
                key: const Key('setup-prompt'),
                leading: const Icon(Icons.person_add_alt_1_outlined),
                title: const Text('Set up your profile'),
                subtitle: const Text('Pick a username, find people and be found.'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/me/setup'),
              ),
            );
          }
          final card = Card(
            key: const Key('social-entry'),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  ProfileAvatar(profile: actor, size: 52),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Flexible(child: Text(actor.displayName, key: const Key('entry-name'), maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800))),
                        if (actor.verified) ...[const SizedBox(width: 4), const VerifiedTick()],
                      ]),
                      Text('@${actor.handle}${actor.isBusiness ? ' (business)' : ''}', style: theme.textTheme.bodySmall),
                    ]),
                  ),
                ]),
                const SizedBox(height: 8),
                Wrap(spacing: 8, children: [
                  if (ref.watch(featureOnProvider(Feature.inbox)))
                    OutlinedButton(
                      key: const Key('open-inbox'),
                      onPressed: () => context.push('/inbox'),
                      child: Badge(isLabelVisible: (ref.watch(inboxCountsProvider(actor.id)).valueOrNull?.badge ?? 0) > 0, label: Text('${ref.watch(inboxCountsProvider(actor.id)).valueOrNull?.badge ?? 0}'), child: const Text('Messages')),
                    ),
                  OutlinedButton(key: const Key('open-bookings'), onPressed: () => context.push('/me/bookings'), child: const Text('Tickets & bookings')),
                  OutlinedButton(key: const Key('open-explore'), onPressed: () => context.push('/explore'), child: const Text('Explore')),
                  FilledButton(key: const Key('open-feed'), onPressed: () => context.push('/feed'), child: const Text('Home feed')),
                  FilledButton.tonal(key: const Key('view-profile'), onPressed: () => context.push('/u/${actor.handle}'), child: const Text('View profile')),
                  OutlinedButton(key: const Key('open-create-post'), onPressed: () => context.push('/create'), child: const Text('Create')),
                  OutlinedButton(key: const Key('find-people'), onPressed: () => context.push('/people'), child: const Text('Find people')),
                  if (list.length > 1) OutlinedButton(key: const Key('open-switcher'), onPressed: () => showProfileSwitcher(context), child: const Text('Switch')),
                ]),
                const Divider(height: 24),
                Wrap(spacing: 16, children: [
                  if (actor.isPrivate) TextButton(key: const Key('open-requests'), onPressed: () => context.push('/people/requests'), child: const Text('Follow requests')),
                  TextButton(key: const Key('open-saved'), onPressed: () => context.push('/me/saved'), child: const Text('Saved posts')),
                  if (ref.watch(featureOnProvider(Feature.marketplace))) TextButton(key: const Key('open-hiring'), onPressed: () => context.push('/me/hiring'), child: const Text('Professionals I asked')),
                  if (ref.watch(teamsOnProvider) && isProfessional(actor)) TextButton(key: const Key('open-team'), onPressed: () => context.push('/me/team'), child: const Text('Team')),
                  if (ref.watch(featureOnProvider(Feature.venueHire)) && isOrganizerProfile(actor)) TextButton(key: const Key('open-hires'), onPressed: () => context.push('/me/hires'), child: const Text('My hires')),
                  if (ref.watch(featureOnProvider(Feature.venueHire)) && isVenueProfile(actor)) TextButton(key: const Key('open-hire-requests-link'), onPressed: () => context.push('/me/hire-requests'), child: const Text('Hire requests')),
                  if (ref.watch(featureOnProvider(Feature.marketplace)) && isProfessional(actor)) ...[
                    TextButton(key: const Key('open-pro-requests'), onPressed: () => context.push('/me/pro-requests'), child: const Text('Requests for me')),
                    TextButton(key: const Key('open-services'), onPressed: () => context.push('/me/services'), child: const Text('My services')),
                  ],
                  if (ref.watch(featureOnProvider(Feature.membersOnly))) TextButton(key: const Key('open-members'), onPressed: () => context.push('/me/members'), child: const Text('Members Only')),
                  TextButton(key: const Key('open-settings'), onPressed: () => context.push('/me/settings'), child: const Text('Privacy and notifications')),
                  TextButton(key: const Key('open-blocked'), onPressed: () => context.push('/people/blocked'), child: const Text('Blocked profiles')),
                  TextButton(key: const Key('open-rules'), onPressed: () => context.push('/rules'), child: const Text('Community rules')),
                  if (list.length == 1) TextButton(key: const Key('open-new-business'), onPressed: () => context.push('/me/business/new'), child: const Text('Create a business profile')),
                ]),
              ]),
            ),
          );
          return Column(children: [
            const MyNightCard(),
            card,
            if (actor.isBusiness) const Padding(padding: EdgeInsets.only(top: 12), child: BusinessToolsCard()),
          ]);
        },
      ),
    );
  }
}
