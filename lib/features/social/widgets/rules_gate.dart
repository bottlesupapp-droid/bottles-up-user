import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../site/providers/site_providers.dart';
import '../../../site/rules/post_rules.dart';
import '../../../site/site_error.dart';

/// Asks the person to read and accept the community rules before they post, comment or send a message. Answers true when they have accepted (now or before). The text is
/// BottlesUp's, from the CMS, with the app's own draft (`draftCommunityRules`) until BottlesUp publishes one. The website remembers who accepted which version, so a new
/// version asks everyone again.
Future<bool> ensureRulesAccepted(BuildContext context, WidgetRef ref) async {
  bool accepted;
  try {
    accepted = await ref.read(rulesAcceptedProvider.future);
  } catch (_) {
    accepted = false;
  }
  if (accepted) return true;
  if (!context.mounted) return false;
  final ok = await showDialog<bool>(context: context, builder: (_) => const _RulesDialog());
  return ok == true;
}

class _RulesDialog extends ConsumerStatefulWidget {
  const _RulesDialog();

  @override
  ConsumerState<_RulesDialog> createState() => _RulesDialogState();
}

class _RulesDialogState extends ConsumerState<_RulesDialog> {
  bool _busy = false;
  String? _problem;

  Future<void> _accept(int version) async {
    setState(() {
      _busy = true;
      _problem = null;
    });
    try {
      await ref.read(postsServiceProvider).acceptRules(version);
      ref.invalidate(rulesAcceptedProvider);
      if (mounted) Navigator.of(context).pop(true);
    } on SiteException catch (e) {
      // The rules may have been republished while this was open: show the new text.
      ref.invalidate(communityRulesProvider);
      if (mounted) setState(() => _problem = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rules = ref.watch(communityRulesProvider);
    return AlertDialog(
      title: const Text('Community rules'),
      content: SingleChildScrollView(
        child: rules.when(
          loading: () => const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator())),
          error: (e, _) => Text(e is SiteException ? e.message : loadFailedMessage('the community rules'), key: const Key('rules-load-problem')),
          data: (r) => Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(r.body ?? draftCommunityRules, key: const Key('rules-text')),
            if (_problem != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_problem!, key: const Key('rules-problem'), style: TextStyle(color: Theme.of(context).colorScheme.error))),
          ]),
        ),
      ),
      actions: [
        TextButton(key: const Key('rules-decline'), onPressed: _busy ? null : () => Navigator.of(context).pop(false), child: const Text('Not now')),
        if (rules.hasError)
          FilledButton(key: const Key('rules-retry'), onPressed: () => ref.invalidate(communityRulesProvider), child: const Text('Try again'))
        else
          FilledButton(key: const Key('rules-accept'), onPressed: _busy || !rules.hasValue ? null : () => _accept(rules.requireValue.version), child: Text(_busy ? 'Saving...' : 'I agree')),
      ],
    );
  }
}
