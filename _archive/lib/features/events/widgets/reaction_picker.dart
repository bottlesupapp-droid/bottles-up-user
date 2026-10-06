import 'package:flutter/material.dart';
import '../models/chat_reaction.dart';

class ReactionPicker extends StatelessWidget {
  final Function(String emoji) onEmojiSelected;
  final bool showEventEmojis;

  const ReactionPicker({
    super.key,
    required this.onEmojiSelected,
    this.showEventEmojis = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showEventEmojis) ...[
            Text(
              'Event Reactions',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: EmojiPresets.event.map((emoji) {
                return _EmojiButton(
                  emoji: emoji,
                  onTap: () => onEmojiSelected(emoji),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
          ],
          Text(
            'Popular',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: EmojiPresets.popular.map((emoji) {
              return _EmojiButton(
                emoji: emoji,
                onTap: () => onEmojiSelected(emoji),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _EmojiButton extends StatelessWidget {
  final String emoji;
  final VoidCallback onTap;

  const _EmojiButton({
    required this.emoji,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
