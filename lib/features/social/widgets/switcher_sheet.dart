import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../site/providers/site_providers.dart';
import 'profile_widgets.dart';

/// Choose which of the person's profiles they are acting as: their own, or a business they own or manage.
Future<void> showProfileSwitcher(BuildContext context) => showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => const _Switcher(),
    );

class _Switcher extends ConsumerWidget {
  const _Switcher();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profiles = ref.watch(myProfilesProvider).valueOrNull ?? const [];
    final actor = ref.watch(actorProfileProvider);
    return SafeArea(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 8), child: Align(alignment: Alignment.centerLeft, child: Text('Switch profile', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)))),
        for (final p in profiles)
          ProfileTile(
            profile: p,
            trailing: p.suspended
                ? const Text('Suspended')
                : p.id == actor?.id
                    ? const Icon(Icons.check_circle, key: Key('switcher-current'))
                    : null,
            onTap: p.suspended
                ? null
                : () {
                    ref.read(selectedProfileIdProvider.notifier).state = p.id;
                    Navigator.of(context).pop();
                  },
          ),
        const Divider(),
        ListTile(
          key: const Key('switcher-new-business'),
          leading: const Icon(Icons.add_business_outlined),
          title: const Text('Create a business profile'),
          subtitle: const Text('A DJ, a photographer, an event group...'),
          onTap: () {
            Navigator.of(context).pop();
            context.push('/me/business/new');
          },
        ),
      ]),
    );
  }
}
