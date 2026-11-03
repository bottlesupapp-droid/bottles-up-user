import 'package:flutter/material.dart';

import '../logic/data_collected.dart';

/// What the app collects and why, plainly (the stores ask for it, and a person should be able to read it in the app).
class DataCollectedScreen extends StatelessWidget {
  const DataCollectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('What this app collects')),
      body: ListView(
        key: const Key('data-collected'),
        padding: const EdgeInsets.all(20),
        children: [
          for (final s in dataCollected) ...[
            Text(s.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            for (final l in s.lines) Padding(padding: const EdgeInsets.only(bottom: 6), child: Text(l, style: theme.textTheme.bodyMedium)),
            const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}
