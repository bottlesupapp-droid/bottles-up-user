import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../site/providers/site_providers.dart';
import '../../../site/rules/post_rules.dart';
import '../../../site/site_error.dart';

/// Asks the person to read and accept the community rules, once, before they post or comment. Answers true when they have accepted (now or before).
/// The text is a DRAFT until BottlesUp's own is put in the CMS (see `draftCommunityRules`); the website remembers who accepted which version.
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

  Future<void> _accept() async {
    setState(() {
      _busy = true;
      _problem = null;
    });
    try {
      await ref.read(postsServiceProvider).acceptRules();
      ref.invalidate(rulesAcceptedProvider);
      if (mounted) Navigator.of(context).pop(true);
    } on SiteException catch (e) {
      if (mounted) setState(() => _problem = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Community rules'),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(draftCommunityRules, key: Key('rules-text')),
          if (_problem != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_problem!, key: const Key('rules-problem'), style: TextStyle(color: Theme.of(context).colorScheme.error))),
        ]),
      ),
      actions: [
        TextButton(key: const Key('rules-decline'), onPressed: _busy ? null : () => Navigator.of(context).pop(false), child: const Text('Not now')),
        FilledButton(key: const Key('rules-accept'), onPressed: _busy ? null : _accept, child: Text(_busy ? 'Saving...' : 'I agree')),
      ],
    );
  }
}
