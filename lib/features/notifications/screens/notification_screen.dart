import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:intl/intl.dart';
import '../models/notification.dart';
import '../providers/notification_provider.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationListProvider);
    final unreadCount = ref.watch(unreadNotificationCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (unreadCount.value != null && unreadCount.value! > 0)
            TextButton(
              onPressed: () => ref.read(notificationListProvider.notifier).markAllAsRead(),
              child: Text(
                'Mark All Read',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 14,
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Iconsax.setting_2),
            onPressed: () {
              // TODO: Open notification settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notification settings coming soon'),
                ),
              );
            },
          ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => Center(
          child: LoadingAnimationWidget.inkDrop(
            color: Theme.of(context).colorScheme.primary,
            size: 40,
          ),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Iconsax.warning_2,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const Gap(16),
              Text(
                'Failed to load notifications',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Gap(8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(16),
              ElevatedButton(
                onPressed: () => ref.read(notificationListProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.notification,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
                  const Gap(16),
                  Text(
                    'No notifications yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Gap(8),
                  Text(
                    'You\'ll see booking confirmations, event reminders, and special offers here.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(notificationListProvider.notifier).refresh(),
            child: _buildNotificationsList(context, ref, notifications),
          );
        },
      ),
    );
  }

  Widget _buildNotificationsList(
    BuildContext context,
    WidgetRef ref,
    List<AppNotification> notifications,
  ) {
    // Group notifications by date
    final grouped = <String, List<AppNotification>>{};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (final notification in notifications) {
      final notificationDate = DateTime(
        notification.createdAt.year,
        notification.createdAt.month,
        notification.createdAt.day,
      );

      String groupKey;
      if (notificationDate == today) {
        groupKey = 'Today';
      } else if (notificationDate == yesterday) {
        groupKey = 'Yesterday';
      } else {
        groupKey = DateFormat('MMM d, yyyy').format(notificationDate);
      }

      grouped.putIfAbsent(groupKey, () => []);
      grouped[groupKey]!.add(notification);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: grouped.length * 2, // Groups + headers
      itemBuilder: (context, index) {
        if (index.isEven) {
          // Header
          final groupIndex = index ~/ 2;
          final groupKey = grouped.keys.elementAt(groupIndex);
          return Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 12),
            child: Text(
              groupKey,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          // Notifications for this group
          final groupIndex = index ~/ 2;
          final groupKey = grouped.keys.elementAt(groupIndex);
          final groupNotifications = grouped[groupKey]!;
          
          return Column(
            children: groupNotifications
                .map((notification) => _buildNotificationTile(context, ref, notification))
                .toList(),
          );
        }
      },
    );
  }

  Widget _buildNotificationTile(
    BuildContext context,
    WidgetRef ref,
    AppNotification notification,
  ) {
    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Iconsax.trash,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        ref.read(notificationListProvider.notifier).deleteNotification(notification.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Notification deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () => ref.read(notificationListProvider.notifier).refresh(),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: !notification.isRead 
              ? Theme.of(context).colorScheme.primary.withOpacity(0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: ListTile(
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getNotificationColor(notification.type).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getNotificationIcon(notification.type),
              color: _getNotificationColor(notification.type),
              size: 24,
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  notification.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (!notification.isRead)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(4),
              Text(
                notification.message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const Gap(4),
              Row(
                children: [
                  Text(
                    _formatTime(notification.createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  if (notification.priority == NotificationPriority.high ||
                      notification.priority == NotificationPriority.urgent) ...[
                    const Gap(8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: notification.priority == NotificationPriority.urgent
                            ? Colors.red.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        notification.priority.displayName.toUpperCase(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: notification.priority == NotificationPriority.urgent
                              ? Colors.red
                              : Colors.orange,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          onTap: () {
            // Mark as read when tapped
            if (!notification.isRead) {
              ref.read(notificationListProvider.notifier).markAsRead(notification.id);
            }

            // Handle notification action
            if (notification.actionUrl != null) {
              // Navigate to the specified URL
              // context.push(notification.actionUrl!);
            }
          },
        ),
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.bookingConfirmed:
        return Iconsax.tick_circle;
      case NotificationType.bookingCancelled:
        return Iconsax.close_circle;
      case NotificationType.eventReminder:
        return Iconsax.calendar;
      case NotificationType.paymentSuccess:
        return Iconsax.card_tick;
      case NotificationType.paymentFailed:
        return Iconsax.card_remove;
      case NotificationType.clubOffer:
        return Iconsax.percentage_circle;
      case NotificationType.systemAnnouncement:
        return Iconsax.volume_high;
      case NotificationType.welcome:
        return Iconsax.emoji_happy;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.bookingConfirmed:
        return Colors.green;
      case NotificationType.bookingCancelled:
        return Colors.red;
      case NotificationType.eventReminder:
        return Colors.blue;
      case NotificationType.paymentSuccess:
        return Colors.green;
      case NotificationType.paymentFailed:
        return Colors.red;
      case NotificationType.clubOffer:
        return Colors.purple;
      case NotificationType.systemAnnouncement:
        return Colors.orange;
      case NotificationType.welcome:
        return Colors.amber;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else {
      return DateFormat('MMM d').format(dateTime);
    }
  }
} 