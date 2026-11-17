import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/features.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/profile_rules.dart';
import '../../../site/site_error.dart';
import '../../recognition/widgets/rank_badge.dart';

/// A round picture, or the person's initials when there is none.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, required this.profile, this.size = 44});

  final SocialProfile profile;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final url = profile.avatarUrl;
    final fallback = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: theme.colorScheme.primaryContainer, shape: BoxShape.circle),
      child: Text(initialsOf(profile.displayName), style: TextStyle(fontSize: size * 0.36, fontWeight: FontWeight.w800, color: theme.colorScheme.onPrimaryContainer)),
    );
    if (url == null) return fallback;
    return SizedBox(width: size, height: size, child: ClipOval(child: NetworkPicture(url: url, width: size, height: size, radius: size / 2)));
  }
}

/// The small tick beside a name that BottlesUp has verified.
class VerifiedTick extends StatelessWidget {
  const VerifiedTick({super.key, this.size = 16, this.rank});

  final double size;

  /// The rank the profile holds (`elite`...). A plain Verified tick when it is not said.
  final String? rank;

  @override
  Widget build(BuildContext context) => RankBadge(rank: rank ?? 'verified', size: size);
}

/// One profile in a list: picture, name with its tick, username (and what kind of business it is), and whatever goes at the end.
class ProfileTile extends StatelessWidget {
  const ProfileTile({super.key, required this.profile, this.onTap, this.trailing});

  final SocialProfile profile;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      key: Key('profile-${profile.handle}'),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: ProfileAvatar(profile: profile),
      title: Row(children: [
        Flexible(child: Text(profile.displayName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700))),
        if (profile.verified) ...[const SizedBox(width: 4), VerifiedTick(rank: profile.rank)],
        if (profile.isPrivate) ...[const SizedBox(width: 4), Icon(Icons.lock_outline, size: 14, color: theme.colorScheme.onSurfaceVariant, semanticLabel: 'Private')],
      ]),
      subtitle: Text(
        profile.isBusiness ? '@${profile.handle} · ${categoryLabel(profile.category)}' : '@${profile.handle}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: trailing,
    );
  }
}

/// Follow, Requested or Following, for the profile the person is acting as. The website decides what following means (a private profile makes it a request), so the button shows what
/// the website answered.
class FollowButton extends ConsumerStatefulWidget {
  const FollowButton({super.key, required this.actor, required this.profile, this.compact = false, this.onChanged});

  final SocialProfile actor;
  final SocialProfile profile;
  final bool compact;
  final ValueChanged<SocialProfile>? onChanged;

  @override
  ConsumerState<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends ConsumerState<FollowButton> {
  bool _busy = false;
  FollowState? _now;

  FollowState get _state => _now ?? widget.profile.follow;

  Future<void> _set(bool follow) async {
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final updated = await ref.read(socialProfilesServiceProvider).setFollow(actor: widget.actor.id, target: widget.profile.id, follow: follow);
      if (!mounted) return;
      setState(() => _now = updated.follow);
      ref.invalidate(socialProfileProvider);
      ref.invalidate(peopleProvider);
      widget.onChanged?.call(updated);
    } on SiteException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void didUpdateWidget(FollowButton old) {
    super.didUpdateWidget(old);
    if (old.profile.id != widget.profile.id || old.profile.follow != widget.profile.follow) _now = null;
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.compact ? const ButtonStyle(visualDensity: VisualDensity.compact) : null;
    final (label, filled, follow) = switch (_state) {
      FollowState.following => ('Following', false, false),
      FollowState.requested => ('Requested', false, false),
      FollowState.none => (widget.profile.followsMe ? 'Follow back' : 'Follow', true, true),
    };
    final onPressed = _busy ? null : () => _set(follow);
    return filled
        ? FilledButton(key: const Key('follow-button'), style: style, onPressed: onPressed, child: Text(label))
        : OutlinedButton(key: const Key('follow-button'), style: style, onPressed: onPressed, child: Text(label));
  }
}

/// Shows [builder] with the profile the person is acting as. While the profiles load it shows a spinner, if they cannot be read it offers to try again, and a person who has not
/// set up their profile yet is asked to. Everything is off until BottlesUp switches social on.
class ActorGate extends ConsumerWidget {
  const ActorGate({super.key, required this.title, required this.builder});

  final String title;
  final Widget Function(BuildContext context, SocialProfile actor) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final on = ref.watch(featureOnProvider(Feature.social));
    if (!on) return Scaffold(appBar: AppBar(title: Text(title)), body: const EmptyState(icon: Icons.hourglass_empty, title: 'Coming soon', text: 'Profiles are not open yet.'));
    final profiles = ref.watch(myProfilesProvider);
    return profiles.when(
      loading: () => Scaffold(appBar: AppBar(title: Text(title)), body: const Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: Text(title)),
        body: LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('your profile'), onRetry: () => ref.invalidate(myProfilesProvider)),
      ),
      data: (_) {
        final actor = ref.watch(actorProfileProvider);
        if (actor == null) {
          return Scaffold(
            appBar: AppBar(title: Text(title)),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.person_add_alt_1_outlined, size: 40),
                  const SizedBox(height: 12),
                  Text('Set up your profile first', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton(key: const Key('open-setup'), onPressed: () => context.push('/me/setup'), child: const Text('Set up my profile')),
                ]),
              ),
            ),
          );
        }
        return builder(context, actor);
      },
    );
  }
}
