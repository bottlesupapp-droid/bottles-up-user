import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../site/providers/site_providers.dart';
import '../../../site/site_config.dart';

/// The privacy policy is the website's own page, so there is one text to keep right. This opens it (in the phone's browser) and offers to open it again.
class PrivacyPolicyScreen extends ConsumerStatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  ConsumerState<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends ConsumerState<PrivacyPolicyScreen> {
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _open());
  }

  Future<void> _open() async {
    final ok = await ref.read(urlOpenerProvider)(privacyPolicyUri());
    if (mounted) setState(() => _failed = !ok);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.privacy_tip_outlined, size: 48),
            const SizedBox(height: 12),
            Text('Our privacy policy is on our website.', style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
            if (_failed) Padding(padding: const EdgeInsets.only(top: 8), child: Text('It could not be opened. Check your connection and try again.', key: const Key('privacy-failed'), style: TextStyle(color: theme.colorScheme.error), textAlign: TextAlign.center)),
            const SizedBox(height: 20),
            FilledButton(key: const Key('privacy-open'), onPressed: _open, child: const Text('Open the privacy policy')),
          ],
        ),
      ),
    );
  }
}
