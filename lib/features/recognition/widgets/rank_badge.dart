import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../site/models/recognition.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/recognition_rules.dart';

/// The small check beside a name. Its colour is the rank (a plain blue for Verified); tapping it says what it means. It never comes from payment: the words in the sheet say so.
class RankBadge extends ConsumerWidget {
  const RankBadge({super.key, this.rank, this.size = 16});

  /// The key of the rank the profile holds (`verified`, `elite`...). Null when it has none: nothing is shown.
  final String? rank;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = rank;
    if (key == null) return const SizedBox.shrink();
    final levels = ref.watch(rankLevelsProvider).valueOrNull ?? const <RankLevel>[];
    final level = levelFor(key, levels);
    final colour = level == null ? Theme.of(context).colorScheme.primary : Color(level.colour);
    return InkResponse(
      key: const Key('verified-tick'),
      onTap: level == null ? null : () => showRankSheet(context, level: level, all: levels.isEmpty ? proposedRanks : levels),
      radius: size,
      child: Icon(Icons.verified, key: Key('rank-$key'), size: size, color: colour, semanticLabel: level?.name ?? 'Verified'),
    );
  }
}

/// What a rank means, and what the others are.
Future<void> showRankSheet(BuildContext context, {required RankLevel level, required List<RankLevel> all}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(Icons.verified, color: Color(level.colour), size: 28),
            const SizedBox(width: 8),
            Text(level.name, key: const Key('rank-sheet-name'), style: Theme.of(context).textTheme.titleLarge),
          ]),
          const SizedBox(height: 8),
          Text(rankExplanation(level), key: const Key('rank-sheet-text')),
          const SizedBox(height: 16),
          Text('All the ranks', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 4),
          for (final l in all)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(children: [
                Icon(Icons.verified, color: Color(l.colour), size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(l.isVerified ? '${l.name}: identity checked' : '${l.name}: ${followersText(l.minFollowers)} followers', style: l.key == level.key ? const TextStyle(fontWeight: FontWeight.w800) : null)),
              ]),
            ),
        ]),
      ),
    ),
  );
}
