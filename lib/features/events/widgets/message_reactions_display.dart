import 'package:flutter/material.dart';
import '../models/chat_reaction.dart';

class MessageReactionsDisplay extends StatelessWidget {
  final MessageReactionSummary summary;
  final Function(String emoji) onReactionTap;
  final Set<String> userReactedEmojis;

  const MessageReactionsDisplay({
    super.key,
    required this.summary,
    required this.onReactionTap,
    this.userReactedEmojis = const {},
  });

  @override
  Widget build(BuildContext context) {
    if (summary.totalReactions == 0) {
      return const SizedBox.shrink();
    }

    final sortedEmojis = summary.emojiCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: sortedEmojis.map((entry) {
        final emoji = entry.key;
        final count = entry.value;
        final users = summary.usersByEmoji[emoji] ?? [];
        final isUserReacted = userReactedEmojis.contains(emoji);

        return _ReactionChip(
          emoji: emoji,
          count: count,
          users: users,
          isUserReacted: isUserReacted,
          onTap: () => onReactionTap(emoji),
        );
      }).toList(),
    );
  }
}

class _ReactionChip extends StatelessWidget {
  final String emoji;
  final int count;
  final List<String> users;
  final bool isUserReacted;
  final VoidCallback onTap;

  const _ReactionChip({
    required this.emoji,
    required this.count,
    required this.users,
    required this.isUserReacted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: _buildTooltipMessage(),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isUserReacted
                ? Theme.of(context).colorScheme.primaryContainer
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            border: Border.all(
              color: isUserReacted
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 4),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isUserReacted
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _buildTooltipMessage() {
    if (users.isEmpty) return emoji;

    final displayUsers = users.take(3).join(', ');
    final remaining = users.length - 3;

    if (remaining > 0) {
      return '$displayUsers and $remaining ${remaining == 1 ? 'other' : 'others'} reacted with $emoji';
    }

    return '$displayUsers reacted with $emoji';
  }
}
