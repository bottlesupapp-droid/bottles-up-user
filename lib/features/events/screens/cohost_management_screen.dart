import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event_cohost.dart';
import '../providers/cohost_provider.dart';
import '../widgets/cohost_invite_dialog.dart';
import '../widgets/host_badge.dart';

class CohostManagementScreen extends ConsumerWidget {
  final String eventId;
  final String eventName;

  const CohostManagementScreen({
    super.key,
    required this.eventId,
    required this.eventName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cohostsAsync = ref.watch(eventCohostsProvider(eventId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Co-Hosts'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showInviteDialog(context),
        icon: const Icon(Icons.person_add),
        label: const Text('Invite Co-Host'),
      ),
      body: cohostsAsync.when(
        data: (cohosts) {
          if (cohosts.isEmpty) {
            return _buildEmptyState(context);
          }

          final pending = cohosts.where((c) => c.status == CohostStatus.pending).toList();
          final accepted = cohosts.where((c) => c.status == CohostStatus.accepted).toList();
          final declined = cohosts.where((c) => c.status == CohostStatus.declined).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (accepted.isNotEmpty) ...[
                  _SectionHeader(
                    title: 'Active Co-Hosts',
                    count: accepted.length,
                    icon: Icons.check_circle,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 12),
                  ...accepted.map((cohost) => _CohostCard(
                        cohost: cohost,
                        eventId: eventId,
                      )),
                  const SizedBox(height: 24),
                ],
                if (pending.isNotEmpty) ...[
                  _SectionHeader(
                    title: 'Pending Invitations',
                    count: pending.length,
                    icon: Icons.pending,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 12),
                  ...pending.map((cohost) => _CohostCard(
                        cohost: cohost,
                        eventId: eventId,
                      )),
                  const SizedBox(height: 24),
                ],
                if (declined.isNotEmpty) ...[
                  _SectionHeader(
                    title: 'Declined',
                    count: declined.length,
                    icon: Icons.cancel,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 12),
                  ...declined.map((cohost) => _CohostCard(
                        cohost: cohost,
                        eventId: eventId,
                      )),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading co-hosts: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(eventCohostsProvider(eventId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'No Co-Hosts Yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Invite co-hosts to help manage your event',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => _showInviteDialog(context),
              icon: const Icon(Icons.person_add),
              label: const Text('Invite Co-Host'),
            ),
          ],
        ),
      ),
    );
  }

  void _showInviteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CohostInviteDialog(
        eventId: eventId,
        eventName: eventName,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  const _SectionHeader({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _CohostCard extends ConsumerWidget {
  final EventCohost cohost;
  final String eventId;

  const _CohostCard({
    required this.cohost,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: cohost.userAvatar != null
                      ? NetworkImage(cohost.userAvatar!)
                      : null,
                  child: cohost.userAvatar == null
                      ? Text(
                          cohost.userName[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              cohost.userName,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          HostBadge(isPrimary: cohost.isPrimaryHost),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getStatusText(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: _getStatusColor(),
                            ),
                      ),
                    ],
                  ),
                ),
                if (cohost.status == CohostStatus.accepted)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) => _handleMenuAction(context, ref, value),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'permissions',
                        child: Row(
                          children: [
                            Icon(Icons.settings),
                            SizedBox(width: 8),
                            Text('Edit Permissions'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'remove',
                        child: Row(
                          children: [
                            Icon(Icons.person_remove, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Remove', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            if (cohost.permissions.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: cohost.permissions.map((permission) {
                  return Chip(
                    label: Text(
                      _formatPermission(permission),
                      style: const TextStyle(fontSize: 11),
                    ),
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
            ],
            if (cohost.notes != null && cohost.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.note, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        cohost.notes!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getStatusText() {
    switch (cohost.status) {
      case CohostStatus.pending:
        return 'Invitation pending';
      case CohostStatus.accepted:
        return 'Accepted ${_formatDate(cohost.respondedAt)}';
      case CohostStatus.declined:
        return 'Declined ${_formatDate(cohost.respondedAt)}';
      case CohostStatus.removed:
        return 'Removed';
    }
  }

  Color _getStatusColor() {
    switch (cohost.status) {
      case CohostStatus.pending:
        return Colors.orange;
      case CohostStatus.accepted:
        return Colors.green;
      case CohostStatus.declined:
        return Colors.red;
      case CohostStatus.removed:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }

  String _formatPermission(CohostPermission permission) {
    switch (permission) {
      case CohostPermission.editEvent:
        return 'Edit Event';
      case CohostPermission.manageGuestList:
        return 'Manage Guests';
      case CohostPermission.sendAnnouncements:
        return 'Announcements';
      case CohostPermission.moderateChat:
        return 'Moderate Chat';
      case CohostPermission.managePoll:
        return 'Manage Polls';
      case CohostPermission.inviteCohost:
        return 'Invite Co-hosts';
      case CohostPermission.viewAnalytics:
        return 'View Analytics';
    }
  }

  Future<void> _handleMenuAction(
    BuildContext context,
    WidgetRef ref,
    String action,
  ) async {
    switch (action) {
      case 'permissions':
        // TODO: Show permissions editor dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission editor coming soon')),
        );
        break;
      case 'remove':
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Remove Co-Host'),
            content: Text(
              'Are you sure you want to remove ${cohost.userName} as a co-host?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Remove'),
              ),
            ],
          ),
        );

        if (confirmed == true && context.mounted) {
          try {
            await ref
                .read(eventCohostsProvider(eventId).notifier)
                .removeCohost(cohost.id);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Co-host removed')),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $e')),
              );
            }
          }
        }
        break;
    }
  }
}
