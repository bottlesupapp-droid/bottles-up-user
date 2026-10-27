import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/post_rules.dart';
import '../../../site/site_error.dart';

/// The community rules, to read at any time. Open to everyone; nothing here asks for an answer.
class CommunityRulesScreen extends ConsumerWidget {
  const CommunityRulesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rules = ref.watch(communityRulesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Community rules')),
      body: rules.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('the community rules'), onRetry: () => ref.invalidate(communityRulesProvider)),
        data: (r) => ListView(key: const Key('rules-page'), padding: const EdgeInsets.all(16), children: [
          Text(r.body ?? draftCommunityRules, key: const Key('rules-text')),
          const SizedBox(height: 16),
          Text('You can report any post, story, comment, message, review or profile from its menu, and block anyone from their profile. Reports are read by the BottlesUp team.', style: Theme.of(context).textTheme.bodySmall),
        ]),
      ),
    );
  }
}
