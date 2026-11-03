import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../site/models/site_contact.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/site_error.dart';

/// Help and settings, with nothing in it that does not do anything: who you are signed in as, how notifications work, how to reach BottlesUp (as the team has set it in the CMS), and your
/// data. There are no switches for things the app does not have (push, analytics, location, themes, currencies).
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _open(BuildContext context, WidgetRef ref, Uri uri) async {
    final ok = await ref.read(urlOpenerProvider)(uri);
    if (!ok && context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('That could not be opened on this phone.')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final contact = ref.watch(siteContactProvider);
    final email = ref.watch(accountProvider).valueOrNull?.email;
    Widget heading(String text, String key) => Padding(padding: const EdgeInsets.fromLTRB(0, 22, 0, 6), child: Text(text, key: Key(key), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)));
    return Scaffold(
      appBar: AppBar(title: const Text('Help and settings')),
      body: ListView(
        key: const Key('settings'),
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
        children: [
          heading('Your account', 'settings-account-heading'),
          Text(email == null ? 'You are signed in.' : 'Signed in as $email', key: const Key('settings-account')),
          heading('Notifications', 'settings-notifications-heading'),
          Text('BottlesUp e-mails your tickets, booking confirmations and updates. Push notifications are not available yet, so there is nothing to switch on or off.', key: const Key('settings-notifications'), style: theme.textTheme.bodyMedium),
          heading('Contact BottlesUp', 'settings-contact-heading'),
          contact.when(
            loading: () => const Padding(padding: EdgeInsets.all(12), child: Center(child: CircularProgressIndicator())),
            error: (error, _) => Row(
              children: [
                Expanded(child: Text(error is SiteException ? error.message : loadFailedMessage('the contact details'), key: const Key('contact-failed'), style: TextStyle(color: theme.colorScheme.error))),
                TextButton(key: const Key('contact-retry'), onPressed: () => ref.invalidate(siteContactProvider), child: const Text('Try again')),
              ],
            ),
            data: (c) {
              if (c.isEmpty) return Text('Contact details are not available right now.', key: const Key('contact-none'), style: theme.textTheme.bodyMedium);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (c.address != null) Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(c.address!, key: const Key('contact-address'))),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (c.hasEmail) OutlinedButton.icon(key: const Key('contact-email'), onPressed: () => _open(context, ref, supportMailto(c.email!, subject: 'BottlesUp help', message: '', from: email)), icon: const Icon(Icons.mail_outline), label: Text(c.email!)),
                      if (c.hasPhone) OutlinedButton.icon(key: const Key('contact-phone'), onPressed: () => _open(context, ref, telUri(c.phone!)!), icon: const Icon(Icons.phone_outlined), label: Text(c.phone!)),
                      for (final s in c.socials) OutlinedButton(key: Key('contact-social-${s.name.toLowerCase()}'), onPressed: () => _open(context, ref, s.url), child: Text(s.name)),
                    ],
                  ),
                ],
              );
            },
          ),
          heading('Your data', 'settings-data-heading'),
          ListTile(key: const Key('settings-collects'), contentPadding: EdgeInsets.zero, title: const Text('What this app collects'), trailing: const Icon(Icons.arrow_forward_ios, size: 18), onTap: () => context.push('/profile/data')),
          ListTile(key: const Key('settings-privacy'), contentPadding: EdgeInsets.zero, title: const Text('Privacy policy'), trailing: const Icon(Icons.arrow_forward_ios, size: 18), onTap: () => context.push('/profile/privacy-policy')),
          if (contact.valueOrNull?.hasEmail == true)
            ListTile(
              key: const Key('settings-copy'),
              contentPadding: EdgeInsets.zero,
              title: const Text('Ask for a copy of your data'),
              subtitle: const Text('Opens an e-mail to BottlesUp that you read and send yourself.'),
              trailing: const Icon(Icons.mail_outline),
              onTap: () => _open(context, ref, supportMailto(contact.value!.email!, subject: 'Copy of my data', message: 'Please send me a copy of the personal data BottlesUp holds about me.', from: email)),
            ),
          Padding(padding: const EdgeInsets.only(top: 12), child: Text('To delete your account, use Delete account in your profile.', key: const Key('settings-delete-note'), style: theme.textTheme.bodySmall)),
        ],
      ),
    );
  }
}
