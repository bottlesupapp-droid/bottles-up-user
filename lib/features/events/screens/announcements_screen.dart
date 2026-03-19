import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import '../providers/announcement_provider.dart';

class AnnouncementsScreen extends ConsumerWidget {
  final String eventId;
  final String eventName;
  final bool isHost;

  const AnnouncementsScreen({
    super.key,
    required this.eventId,
    required this.eventName,
    this.isHost = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementsAsync = ref.watch(eventAnnouncementsProvider(eventId));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(eventName),
            const Text(
              'Announcements',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      body: announcementsAsync.when(
        data: (announcements) {
          if (announcements.isEmpty) {
            return const Center(
              child: Text('No announcements yet'),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(eventAnnouncementsProvider(eventId));
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: announcements.length,
              itemBuilder: (context, index) {
                final announcement = announcements[index];
                return _AnnouncementCard(
                  announcement: announcement,
                  isHost: isHost,
                  onEdit: () => _showAnnouncementDialog(context, ref, announcement: announcement),
                  onDelete: () => _deleteAnnouncement(context, ref, announcement.id),
                  onTogglePin: () => _togglePin(ref, announcement.id, !announcement.isPinned),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
      floatingActionButton: isHost
          ? FloatingActionButton.extended(
              onPressed: () => _showAnnouncementDialog(context, ref),
              icon: const Icon(Icons.campaign),
              label: const Text('New Announcement'),
            )
          : null,
    );
  }

  void _showAnnouncementDialog(BuildContext context, WidgetRef ref, {dynamic announcement}) {
    final titleController = TextEditingController(text: announcement?.title ?? '');
    final messageController = TextEditingController(text: announcement?.message ?? '');
    final linkController = TextEditingController(text: announcement?.link ?? '');
    bool isPinned = announcement?.isPinned ?? false;
    int priority = announcement?.priority ?? 0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(announcement == null ? 'New Announcement' : 'Edit Announcement'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'Important Update',
                    ),
                  ),
                  const Gap(16),
                  TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      labelText: 'Message',
                      hintText: 'Share details with attendees...',
                      alignLabelWithHint: true,
                    ),
                    maxLines: 4,
                  ),
                  const Gap(16),
                  TextField(
                    controller: linkController,
                    decoration: const InputDecoration(
                      labelText: 'Link (optional)',
                      hintText: 'https://...',
                    ),
                  ),
                  const Gap(16),
                  SwitchListTile(
                    title: const Text('Pin announcement'),
                    subtitle: const Text('Show at the top'),
                    value: isPinned,
                    onChanged: (value) => setState(() => isPinned = value),
                  ),
                  if (isPinned)
                    Slider(
                      value: priority.toDouble(),
                      min: 0,
                      max: 10,
                      divisions: 10,
                      label: 'Priority: $priority',
                      onChanged: (value) => setState(() => priority = value.toInt()),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (titleController.text.isEmpty || messageController.text.isEmpty) {
                    return;
                  }

                  if (announcement == null) {
                    await ref.read(eventAnnouncementsProvider(eventId).notifier).createAnnouncement(
                          eventId: eventId,
                          title: titleController.text,
                          message: messageController.text,
                          isPinned: isPinned,
                          priority: priority,
                          link: linkController.text.isEmpty ? null : linkController.text,
                        );
                  } else {
                    await ref.read(eventAnnouncementsProvider(eventId).notifier).updateAnnouncement(
                          announcementId: announcement.id,
                          title: titleController.text,
                          message: messageController.text,
                          isPinned: isPinned,
                          priority: priority,
                        );
                  }

                  if (context.mounted) Navigator.pop(context);
                },
                child: Text(announcement == null ? 'Create' : 'Update'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _deleteAnnouncement(BuildContext context, WidgetRef ref, String announcementId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Announcement'),
        content: const Text('Are you sure you want to delete this announcement?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(eventAnnouncementsProvider(eventId).notifier).deleteAnnouncement(announcementId);
              if (context.mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _togglePin(WidgetRef ref, String announcementId, bool isPinned) async {
    await ref.read(eventAnnouncementsProvider(eventId).notifier).togglePin(announcementId, isPinned);
  }
}

class _AnnouncementCard extends StatelessWidget {
  final dynamic announcement;
  final bool isHost;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTogglePin;

  const _AnnouncementCard({
    required this.announcement,
    required this.isHost,
    this.onEdit,
    this.onDelete,
    this.onTogglePin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ListTile(
            leading: CircleAvatar(
              backgroundImage: announcement.hostAvatar != null
                  ? NetworkImage(announcement.hostAvatar!)
                  : null,
              child: announcement.hostAvatar == null
                  ? const Icon(Icons.person)
                  : null,
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    announcement.hostName ?? 'Host',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                if (announcement.isPinned)
                  const Icon(Icons.push_pin, size: 16, color: Colors.amber),
              ],
            ),
            subtitle: announcement.createdAt != null
                ? Text(timeago.format(announcement.createdAt!))
                : null,
            trailing: isHost
                ? PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: onEdit,
                        child: const Row(
                          children: [
                            Icon(Icons.edit),
                            Gap(8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: onTogglePin,
                        child: Row(
                          children: [
                            Icon(announcement.isPinned ? Icons.push_pin_outlined : Icons.push_pin),
                            const Gap(8),
                            Text(announcement.isPinned ? 'Unpin' : 'Pin'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: onDelete,
                        child: const Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            Gap(8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  )
                : null,
          ),

          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  announcement.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Gap(8),
                Text(announcement.message),
                if (announcement.link != null) ...[
                  const Gap(12),
                  InkWell(
                    onTap: () => _launchUrl(announcement.link!),
                    child: Row(
                      children: [
                        const Icon(Icons.link, size: 16),
                        const Gap(4),
                        Expanded(
                          child: Text(
                            announcement.link!,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              decoration: TextDecoration.underline,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
