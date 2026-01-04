import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/conversation.dart';
import '../providers/messaging_provider.dart';

class ConversationsScreen extends ConsumerStatefulWidget {
  final ScrollController scrollController;

  const ConversationsScreen({
    super.key,
    required this.scrollController,
  });

  @override
  ConsumerState<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends ConsumerState<ConversationsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showNewMessageOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Gap(24),
            _buildOptionTile(
              context,
              icon: Ionicons.person_add_outline,
              title: 'New Direct Message',
              subtitle: 'Start a conversation with someone',
              onTap: () {
                context.pop();
                context.push('/messaging/new-direct');
              },
            ),
            const Gap(12),
            _buildOptionTile(
              context,
              icon: Ionicons.people_outline,
              title: 'Create Group',
              subtitle: 'Start a group conversation',
              onTap: () {
                context.pop();
                context.push('/messaging/new-group');
              },
            ),
            Gap(MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const Gap(4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                  ),
                ],
              ),
            ),
            Icon(
              Ionicons.chevron_forward,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final conversationsAsync = ref.watch(conversationsNotifierProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        controller: widget.scrollController,
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            snap: true,
            elevation: 0,
            backgroundColor: theme.scaffoldBackgroundColor,
            title: Text(
              'Messages',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                onPressed: _showNewMessageOptions,
                icon: const Icon(Ionicons.create_outline),
                tooltip: 'New Message',
              ),
            ],
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search conversations...',
                    prefixIcon: Icon(Ionicons.search_outline, color: theme.colorScheme.primary),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Conversations List
          conversationsAsync.when(
            loading: () => SliverFillRemaining(
              child: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: theme.colorScheme.primary,
                  size: 50,
                ),
              ),
            ),
            error: (error, stack) => SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Ionicons.alert_circle_outline,
                      size: 64,
                      color: theme.colorScheme.error,
                    ),
                    const Gap(16),
                    Text(
                      'Failed to load conversations',
                      style: theme.textTheme.titleLarge,
                    ),
                    const Gap(8),
                    Text(
                      error.toString(),
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const Gap(24),
                    FilledButton.icon(
                      onPressed: () => ref.invalidate(conversationsNotifierProvider),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
            data: (conversations) {
              // Filter conversations by search query
              var filteredConversations = conversations;
              if (_searchQuery.isNotEmpty) {
                filteredConversations = conversations.where((conv) {
                  final name = _getConversationName(conv).toLowerCase();
                  return name.contains(_searchQuery.toLowerCase());
                }).toList();
              }

              if (filteredConversations.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Ionicons.chatbubbles_outline,
                          size: 80,
                          color: theme.colorScheme.primary.withValues(alpha: 0.3),
                        ),
                        const Gap(16),
                        Text(
                          _searchQuery.isEmpty ? 'No conversations yet' : 'No conversations found',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        const Gap(8),
                        Text(
                          _searchQuery.isEmpty
                              ? 'Start a conversation by tapping the + button'
                              : 'Try a different search term',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                        if (_searchQuery.isEmpty) ...[
                          const Gap(24),
                          FilledButton.icon(
                            onPressed: _showNewMessageOptions,
                            icon: const Icon(Ionicons.add),
                            label: const Text('New Message'),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final conversation = filteredConversations[index];
                    return _ConversationTile(
                      conversation: conversation,
                      onTap: () {
                        context.push('/messaging/chat/${conversation.id}');
                      },
                    );
                  },
                  childCount: filteredConversations.length,
                ),
              );
            },
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: Gap(100)),
        ],
      ),
    );
  }

  String _getConversationName(Conversation conversation) {
    if (conversation.type == ConversationType.group) {
      return conversation.name ?? 'Group Chat';
    }

    // For direct messages, get the other participant's name
    final otherParticipant = conversation.participants?.firstWhere(
      (p) => p.userId != ref.read(messagingServiceProvider).currentUserId,
      orElse: () => conversation.participants!.first,
    );

    return otherParticipant?.userName ?? otherParticipant?.userEmail ?? 'Unknown';
  }
}

class _ConversationTile extends ConsumerWidget {
  final Conversation conversation;
  final VoidCallback onTap;

  const _ConversationTile({
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentUserId = ref.watch(messagingServiceProvider).currentUserId;

    // Get conversation display info
    String title;
    String? subtitle;
    String? avatarUrl;

    if (conversation.type == ConversationType.group) {
      title = conversation.name ?? 'Group Chat';
      subtitle = conversation.lastMessageContent;
      avatarUrl = conversation.imageUrl;
    } else {
      // Direct message - get other participant
      final otherParticipant = conversation.participants?.firstWhere(
        (p) => p.userId != currentUserId,
        orElse: () => conversation.participants!.first,
      );

      title = otherParticipant?.userName ?? otherParticipant?.userEmail ?? 'Unknown';
      subtitle = conversation.lastMessageContent;
      avatarUrl = otherParticipant?.userAvatarUrl;
    }

    // Check if there's an unread message
    final hasUnread = conversation.unreadCount != null && conversation.unreadCount! > 0;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.1),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                image: avatarUrl != null
                    ? DecorationImage(
                        image: NetworkImage(avatarUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: avatarUrl == null
                  ? Icon(
                      conversation.type == ConversationType.group
                          ? Ionicons.people
                          : Ionicons.person,
                      color: theme.colorScheme.primary,
                      size: 28,
                    )
                  : null,
            ),
            const Gap(12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: hasUnread ? FontWeight.bold : FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Gap(8),
                      Text(
                        timeago.format(conversation.lastMessageAt, locale: 'en_short'),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const Gap(4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          subtitle ?? 'No messages yet',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: hasUnread ? 0.9 : 0.6,
                            ),
                            fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasUnread) ...[
                        const Gap(8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            conversation.unreadCount.toString(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
