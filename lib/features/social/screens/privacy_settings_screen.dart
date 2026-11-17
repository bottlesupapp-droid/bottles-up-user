import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/features.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/notification_rules.dart';
import '../../../site/site_error.dart';
import '../widgets/profile_widgets.dart';

/// Privacy and notifications for the profile the person is acting as: whether the account is private, who they have blocked, what they are told about, and where the rules are.
class PrivacySettingsScreen extends ConsumerStatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  ConsumerState<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends ConsumerState<PrivacySettingsScreen> {
  bool _busy = false;

  void _problem(Object e) {
    final text = e is SiteException ? e.message : actionFailedMessage;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _setPrivate(SocialProfile actor, bool value) async {
    setState(() => _busy = true);
    try {
      await ref.read(socialProfilesServiceProvider).savePersonal(isPrivate: value, interests: actor.interests);
      ref.invalidate(myProfilesProvider);
    } catch (e) {
      if (mounted) _problem(e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _setKinds(SocialProfile actor, List<String> kinds, bool value) async {
    try {
      await ref.read(inboxServiceProvider).setNotificationKinds(actor: actor.id, kinds: kinds, enabled: value);
      ref.invalidate(notificationPrefsProvider(actor.id));
    } catch (e) {
      if (mounted) _problem(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ActorGate(
      title: 'Privacy and notifications',
      builder: (context, actor) {
        final prefs = ref.watch(notificationPrefsProvider(actor.id));
        final theme = Theme.of(context);
        return Scaffold(
          appBar: AppBar(title: const Text('Privacy and notifications')),
          body: ListView(key: const Key('settings-list'), padding: const EdgeInsets.only(bottom: 96), children: [
            _Heading('Privacy', theme),
            if (!actor.isBusiness)
              SwitchListTile(
                key: const Key('private-account'),
                value: actor.isPrivate,
                onChanged: _busy ? null : (v) => _setPrivate(actor, v),
                title: const Text('Private account'),
                subtitle: const Text('Only people you approve can see your posts, your followers and who you follow. Anyone can still see your name and picture.'),
              )
            else
              const ListTile(key: Key('business-public'), leading: Icon(Icons.public), title: Text('Business profiles are always public'), subtitle: Text('Anyone can find and follow them.')),
            if (actor.isPrivate && !actor.isBusiness) ListTile(key: const Key('goto-requests'), leading: const Icon(Icons.person_add_alt_outlined), title: const Text('Follow requests'), trailing: const Icon(Icons.chevron_right), onTap: () => context.push('/people/requests')),
            if (ref.watch(featureOnProvider(Feature.membersOnly))) ListTile(key: const Key('goto-members'), leading: const Icon(Icons.star_outline), title: const Text('Members Only list'), subtitle: const Text('Who can see your Members Only posts'), trailing: const Icon(Icons.chevron_right), onTap: () => context.push('/me/members')),
            ListTile(key: const Key('goto-blocked'), leading: const Icon(Icons.block), title: const Text('Blocked profiles'), subtitle: const Text('Blocking someone hides all of their profiles from you, and yours from them.'), trailing: const Icon(Icons.chevron_right), onTap: () => context.push('/people/blocked')),
            ListTile(key: const Key('goto-edit-profile'), leading: const Icon(Icons.edit_outlined), title: const Text('Edit profile'), trailing: const Icon(Icons.chevron_right), onTap: () => context.push('/me/setup')),
            const Divider(),
            _Heading('Notifications for @${actor.handle}', theme),
            prefs.when(
              loading: () => const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator())),
              error: (e, _) => Padding(padding: const EdgeInsets.all(16), child: LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('your notification settings'), onRetry: () => ref.invalidate(notificationPrefsProvider(actor.id)))),
              data: (p) => Column(children: [
                for (final g in notificationGroups)
                  SwitchListTile(
                    key: Key('notify-${g.key}'),
                    value: notificationGroupOn(p, g.kinds),
                    onChanged: (v) => _setKinds(actor, g.kinds, v),
                    title: Text(g.label),
                    subtitle: Text(g.hint),
                  ),
              ]),
            ),
            if (ref.watch(featureOnProvider(Feature.inbox))) const ListTile(key: Key('messages-note'), leading: Icon(Icons.notifications_off_outlined), title: Text('Messages'), subtitle: Text('Mute a single conversation from its details. People you do not follow can only send you a request.')),
            const Divider(),
            _Heading('Safety', theme),
            ListTile(key: const Key('goto-rules'), leading: const Icon(Icons.rule), title: const Text('Community rules'), trailing: const Icon(Icons.chevron_right), onTap: () => context.push('/rules')),
            const ListTile(key: Key('report-help'), leading: Icon(Icons.flag_outlined), title: Text('Reporting'), subtitle: Text('Report a post, story, comment, message, review or profile from its menu. Reports are read by the BottlesUp team.')),
          ]),
        );
      },
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text, this.theme);

  final String text;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 4), child: Text(text, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)));
}
