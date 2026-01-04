import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../providers/messaging_provider.dart';

class NewDirectMessageScreen extends ConsumerStatefulWidget {
  const NewDirectMessageScreen({super.key});

  @override
  ConsumerState<NewDirectMessageScreen> createState() => _NewDirectMessageScreenState();
}

class _NewDirectMessageScreenState extends ConsumerState<NewDirectMessageScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isCreating = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _createDirectConversation(String userId) async {
    if (_isCreating) return;

    setState(() => _isCreating = true);

    try {
      final conversation = await ref
          .read(conversationsNotifierProvider.notifier)
          .createDirectConversation(userId);

      if (mounted) {
        // Navigate to the chat screen
        context.go('/messaging/chat/${conversation.id}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create conversation: $e')),
        );
        setState(() => _isCreating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final usersAsync = _searchQuery.isNotEmpty
        ? ref.watch(searchUsersProvider(_searchQuery))
        : null;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(Ionicons.close),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'New Message',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
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
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search by name or email...',
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

          // Search Results
          Expanded(
            child: _searchQuery.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Ionicons.search_outline,
                          size: 80,
                          color: theme.colorScheme.primary.withValues(alpha: 0.3),
                        ),
                        const Gap(16),
                        Text(
                          'Search for users',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        const Gap(8),
                        Text(
                          'Enter a name or email to find users',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  )
                : usersAsync == null
                    ? const SizedBox.shrink()
                    : usersAsync.when(
                        loading: () => Center(
                          child: LoadingAnimationWidget.staggeredDotsWave(
                            color: theme.colorScheme.primary,
                            size: 50,
                          ),
                        ),
                        error: (error, stack) => Center(
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
                                'Failed to search users',
                                style: theme.textTheme.titleLarge,
                              ),
                            ],
                          ),
                        ),
                        data: (users) {
                          if (users.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Ionicons.sad_outline,
                                    size: 80,
                                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                                  ),
                                  const Gap(16),
                                  Text(
                                    'No users found',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                    ),
                                  ),
                                  const Gap(8),
                                  Text(
                                    'Try a different search term',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final user = users[index];
                              final userId = user['id'] as String;
                              final email = user['email'] as String;
                              final fullName = user['full_name'] as String?;
                              final avatarUrl = user['avatar_url'] as String?;

                              return _UserTile(
                                userId: userId,
                                name: fullName ?? email,
                                email: email,
                                avatarUrl: avatarUrl,
                                isCreating: _isCreating,
                                onTap: () => _createDirectConversation(userId),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  final String userId;
  final String name;
  final String email;
  final String? avatarUrl;
  final bool isCreating;
  final VoidCallback onTap;

  const _UserTile({
    required this.userId,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.isCreating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: isCreating ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                image: avatarUrl != null
                    ? DecorationImage(
                        image: NetworkImage(avatarUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: avatarUrl == null
                  ? Icon(
                      Ionicons.person,
                      color: theme.colorScheme.primary,
                      size: 24,
                    )
                  : null,
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(2),
                  Text(
                    email,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isCreating)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: theme.colorScheme.primary,
                ),
              )
            else
              Icon(
                Ionicons.chatbubble_outline,
                color: theme.colorScheme.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
