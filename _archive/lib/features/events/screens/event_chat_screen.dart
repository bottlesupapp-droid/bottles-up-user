import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../providers/event_chat_provider.dart';

class EventChatScreen extends ConsumerStatefulWidget {
  final String eventId;
  final String eventName;

  const EventChatScreen({
    super.key,
    required this.eventId,
    required this.eventName,
  });

  @override
  ConsumerState<EventChatScreen> createState() => _EventChatScreenState();
}

class _EventChatScreenState extends ConsumerState<EventChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(eventChatMessagesProvider(widget.eventId));
    final pinnedAsync = ref.watch(pinnedMessagesProvider(widget.eventId));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.eventName),
            const Text(
              'Event Chat',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.push_pin),
            onPressed: () => _showPinnedMessages(context, pinnedAsync),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return const Center(
                    child: Text('No messages yet. Start the conversation!'),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return _MessageBubble(
                      message: message,
                      onPin: () => _pinMessage(message),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),

          // Message Input
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    await ref.read(eventChatMessagesProvider(widget.eventId).notifier).sendMessage(
          eventId: widget.eventId,
          message: _messageController.text.trim(),
        );

    _messageController.clear();
  }

  void _pinMessage(dynamic message) async {
    await ref
        .read(eventChatMessagesProvider(widget.eventId).notifier)
        .togglePinMessage(message.id, !message.isPinned);
  }

  void _showPinnedMessages(BuildContext context, AsyncValue pinnedAsync) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pinned Messages',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Gap(16),
            Expanded(
              child: pinnedAsync.when(
                data: (messages) {
                  if (messages.isEmpty) {
                    return const Center(child: Text('No pinned messages'));
                  }
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return _MessageBubble(message: message, onPin: null);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const Center(child: Text('Error loading pinned messages')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final dynamic message;
  final VoidCallback? onPin;

  const _MessageBubble({
    required this.message,
    this.onPin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          if (message.userAvatar != null)
            CircleAvatar(
              backgroundImage: NetworkImage(message.userAvatar!),
              radius: 16,
            )
          else
            const CircleAvatar(
              radius: 16,
              child: Icon(Icons.person, size: 16),
            ),
          const Gap(12),

          // Message Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      message.userName ?? 'Anonymous',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Gap(8),
                    if (message.createdAt != null)
                      Text(
                        timeago.format(message.createdAt!),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    if (message.isPinned) ...[
                      const Gap(8),
                      const Icon(Icons.push_pin, size: 14, color: Colors.amber),
                    ],
                  ],
                ),
                const Gap(4),
                Text(message.message),
              ],
            ),
          ),

          // Actions
          if (onPin != null)
            PopupMenuButton(
              icon: const Icon(Icons.more_vert, size: 18),
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: onPin,
                  child: Row(
                    children: [
                      Icon(message.isPinned ? Icons.push_pin_outlined : Icons.push_pin),
                      const Gap(8),
                      Text(message.isPinned ? 'Unpin' : 'Pin'),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
