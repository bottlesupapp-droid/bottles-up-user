import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../site/providers/site_providers.dart';
import '../../../site/site_config.dart';

/// On a business profile: what is done in this app and what is done in BottlesUp Business, with a way to get there. The app does not run a venue; it says so plainly.
class BusinessToolsCard extends ConsumerWidget {
  const BusinessToolsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Card(
      key: const Key('business-tools'),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Running a business?', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          const Text('Here in the app you post and tell stories, answer reviews and message customers.', key: Key('business-in-app')),
          const SizedBox(height: 4),
          const Text('Tables, events, the door, your team and payouts are in BottlesUp Business.', key: Key('business-in-business')),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            key: const Key('open-business-tools'),
            icon: const Icon(Icons.open_in_new, size: 18),
            label: const Text('Open BottlesUp Business'),
            onPressed: () => ref.read(urlOpenerProvider)(businessToolsUri()),
          ),
        ]),
      ),
    );
  }
}
