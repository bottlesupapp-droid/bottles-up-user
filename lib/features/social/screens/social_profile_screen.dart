import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/safety.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/profile_rules.dart';
import '../../../site/site_error.dart';
import '../../../site/models/features.dart';
import '../../billing/widgets/tip_button.dart';
import '../../hire/widgets/hire_section.dart';
import '../../hiring/widgets/pro_services_section.dart';
import '../../recognition/widgets/awards_section.dart';
import '../widgets/profile_grid.dart';
import '../widgets/report_sheet.dart';
import '../widgets/profile_widgets.dart';
import '../widgets/switcher_sheet.dart';

/// A profile page: who it is, how many follow it, and what the person can do (follow, edit, block). A private profile shows its header and counts and keeps the rest for the people
/// it has approved.
class SocialProfileScreen extends ConsumerWidget {
  const SocialProfileScreen({super.key, required this.handle});

  final String handle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ActorGate(
      title: '@$handle',
      builder: (context, actor) {
        final key = ProfileKey(actor: actor.id, handle: handle);
        final profile = ref.watch(socialProfileProvider(key));
        return profile.when(
          loading: () => Scaffold(appBar: AppBar(title: Text('@$handle')), body: const Center(child: CircularProgressIndicator())),
          error: (e, _) => Scaffold(
            appBar: AppBar(title: Text('@$handle')),
            body: e is SiteException && e.message.contains('isn\'t available')
                ? const EmptyState(icon: Icons.person_off_outlined, title: 'This profile isn\'t available', text: 'It may have been removed, or the username may have changed.')
                : LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('that profile'), onRetry: () => ref.invalidate(socialProfileProvider(key))),
          ),
          data: (p) => _ProfileView(actor: actor, profile: p, profileKey: key),
        );
      },
    );
  }
}

class _ProfileView extends ConsumerWidget {
  const _ProfileView({required this.actor, required this.profile, required this.profileKey});

  final SocialProfile actor;
  final SocialProfile profile;
  final ProfileKey profileKey;

  Future<void> _setBlocked(BuildContext context, WidgetRef ref, bool blocked) async {
    final messenger = ScaffoldMessenger.of(context);
    if (blocked) {
      final sure = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text('Block @${profile.handle}?'),
          content: const Text('You will no longer see each other, on any profile, and any follows between you end. They are not told.'),
          actions: [
            TextButton(onPressed: () => c.pop(false), child: const Text('Cancel')),
            FilledButton(key: const Key('confirm-block'), onPressed: () => c.pop(true), child: const Text('Block')),
          ],
        ),
      );
      if (sure != true) return;
    }
    try {
      await ref.read(socialProfilesServiceProvider).setBlocked(actor: actor.id, target: profile.id, blocked: blocked);
      ref.invalidate(socialProfileProvider);
      ref.invalidate(blockedProfilesProvider);
      ref.invalidate(peopleProvider);
      if (blocked && context.mounted && context.canPop()) context.pop();
    } on SiteException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final p = profile;
    final canOpenPeople = p.canSeeContent || p.isMine;
    final many = (ref.watch(myProfilesProvider).valueOrNull?.length ?? 0) > 1;
    return Scaffold(
      appBar: AppBar(
        title: Text('@${p.handle}'),
        actions: [
          if (p.isMine && many) IconButton(key: const Key('switch-profile'), tooltip: 'Switch profile', icon: const Icon(Icons.swap_horiz), onPressed: () => showProfileSwitcher(context)),
          if (!p.isMine)
            PopupMenuButton<String>(
              key: const Key('profile-menu'),
              onSelected: (v) {
                if (v == 'report') {
                  showReportSheet(context, actor: actor, kind: ReportKind.profile, target: p.id, alsoBlock: p.blockedByMe ? null : p);
                } else {
                  _setBlocked(context, ref, v == 'block');
                }
              },
              itemBuilder: (_) => [
                if (p.blockedByMe) const PopupMenuItem(value: 'unblock', child: Text('Unblock')) else const PopupMenuItem(value: 'block', child: Text('Block')),
                const PopupMenuItem(value: 'report', child: Text('Report')),
              ],
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(socialProfileProvider(profileKey));
          await ref.read(socialProfileProvider(profileKey).future).catchError((_) => p);
        },
        child: ListView(
          key: const Key('social-profile'),
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          children: [
            if (p.suspended)
              Container(
                key: const Key('suspended-banner'),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: theme.colorScheme.errorContainer, borderRadius: BorderRadius.circular(12)),
                child: Text('This profile is suspended and is hidden from other people. Contact BottlesUp support.', style: TextStyle(color: theme.colorScheme.onErrorContainer)),
              ),
            if (p.coverUrl != null) Padding(padding: const EdgeInsets.only(bottom: 12), child: NetworkPicture(url: p.coverUrl, height: 130, width: double.infinity)),
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              ProfileAvatar(profile: p, size: 84),
              const SizedBox(width: 16),
              Expanded(
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  _Count(label: 'Followers', value: p.followers, onTap: canOpenPeople ? () => context.push('/profiles/${p.id}/followers') : null),
                  _Count(label: 'Following', value: p.following, onTap: canOpenPeople ? () => context.push('/profiles/${p.id}/following') : null),
                ]),
              ),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Flexible(child: Text(p.displayName, key: const Key('profile-name'), style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800))),
              if (p.verified) ...[const SizedBox(width: 6), VerifiedTick(size: 20, rank: p.rank)],
              if (p.isPrivate) ...[const SizedBox(width: 6), Icon(Icons.lock_outline, size: 18, color: theme.colorScheme.onSurfaceVariant, semanticLabel: 'Private')],
            ]),
            const SizedBox(height: 2),
            Text(
              p.isBusiness ? '${categoryLabel(p.category)}${p.city == null ? '' : ' · ${p.city}'}' : (p.city ?? ''),
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            if (p.followsMe && !p.isMine) Padding(padding: const EdgeInsets.only(top: 4), child: Text('Follows you', key: const Key('follows-you'), style: theme.textTheme.bodySmall)),
            if (p.bio != null) Padding(padding: const EdgeInsets.only(top: 10), child: Text(p.bio!, key: const Key('profile-bio'))),
            if (p.links.isNotEmpty) _Links(links: p.links),
            AwardsSection(actor: actor, profile: p),
            const SizedBox(height: 16),
            _Actions(actor: actor, profile: p, onUnblock: () => _setBlocked(context, ref, false)),
            ProServicesSection(profile: p),
            HireSection(profile: p),
            TipSection(profile: p),
            const SizedBox(height: 16),
            if ((p.canSeeContent || p.isMine) && !p.blockedByMe) ProfileGrid(key: ValueKey('grid-${p.id}-${actor.id}'), actor: actor, profile: p),
            if (!p.canSeeContent && !p.isMine)
              Container(
                key: const Key('private-notice'),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(border: Border.all(color: theme.colorScheme.outlineVariant), borderRadius: BorderRadius.circular(16)),
                child: Column(children: [
                  const Icon(Icons.lock_outline, size: 32),
                  const SizedBox(height: 8),
                  Text('This account is private', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text('Follow to see their posts and who they follow.', textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
                ]),
              ),
          ],
        ),
      ),
    );
  }
}

class _Count extends StatelessWidget {
  const _Count({required this.label, required this.value, this.onTap});

  final String label;
  final int value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      key: Key('count-${label.toLowerCase()}'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(children: [
          Text(formatCount(value), key: Key('count-${label.toLowerCase()}-value'), style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          Text(label, style: theme.textTheme.bodySmall),
        ]),
      ),
    );
  }
}

class _Links extends ConsumerWidget {
  const _Links({required this.links});

  final Map<String, String> links;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final open = ref.read(urlOpenerProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(spacing: 8, runSpacing: 0, children: [
        for (final k in socialLinkKinds)
          if (links[k.key] case final value?)
            if (socialLinkUri(k.key, value) case final uri?)
              ActionChip(key: Key('link-${k.key}'), label: Text(k.label), onPressed: () => open(uri))
            else
              Chip(key: Key('link-${k.key}'), label: Text('${k.label}: $value')),
      ]),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({required this.actor, required this.profile, required this.onUnblock});

  final SocialProfile actor;
  final SocialProfile profile;
  final VoidCallback onUnblock;

  @override
  Widget build(BuildContext context) {
    if (profile.isMine) {
      return Row(children: [
        Expanded(
          child: OutlinedButton(
            key: const Key('edit-profile'),
            onPressed: () => context.push(profile.isBusiness ? '/me/business/${profile.id}/edit' : '/me/setup'),
            child: const Text('Edit profile'),
          ),
        ),
      ]);
    }
    if (profile.blockedByMe) {
      return Row(children: [Expanded(child: OutlinedButton(key: const Key('unblock'), onPressed: onUnblock, child: const Text('Unblock')))]);
    }
    return Consumer(builder: (context, ref, _) {
      final canMessage = ref.watch(featureOnProvider(Feature.inbox));
      return Row(children: [
        Expanded(child: FollowButton(actor: actor, profile: profile)),
        if (canMessage) ...[
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              key: const Key('message-button'),
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                final router = GoRouter.of(context);
                try {
                  final id = await ref.read(inboxServiceProvider).startDirect(actor: actor.id, other: profile.id);
                  router.push('/inbox/$id');
                } on SiteException catch (e) {
                  messenger.showSnackBar(SnackBar(content: Text(e.message)));
                }
              },
              child: const Text('Message'),
            ),
          ),
        ],
      ]);
    });
  }
}
