import 'package:flutter/material.dart';
import '../models/venue_follow.dart';
import '../services/venue_follow_service.dart';

class FollowedVenuesScreen extends StatefulWidget {
  const FollowedVenuesScreen({super.key});

  @override
  State<FollowedVenuesScreen> createState() => _FollowedVenuesScreenState();
}

class _FollowedVenuesScreenState extends State<FollowedVenuesScreen>
    with SingleTickerProviderStateMixin {
  final _followService = VenueFollowService();
  late TabController _tabController;

  List<VenueFollow> _followedVenues = [];
  List<FollowedVenueUpdate> _updates = [];
  int _unreadCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final venues = await _followService.getUserFollowedVenues();
      final updates = await _followService.getFollowedVenueUpdates();
      final unreadCount = await _followService.getUnreadUpdatesCount();

      setState(() {
        _followedVenues = venues;
        _updates = updates;
        _unreadCount = unreadCount;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Followed Venues'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            const Tab(text: 'Venues'),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Updates'),
                  if (_unreadCount > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _unreadCount > 99 ? '99+' : _unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildVenuesList(),
                  _buildUpdatesList(),
                ],
              ),
            ),
    );
  }

  Widget _buildVenuesList() {
    if (_followedVenues.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No followed venues',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Follow venues to get updates about their events',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _followedVenues.length,
      itemBuilder: (context, index) {
        final venue = _followedVenues[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: venue.clubImageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      venue.clubImageUrl!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholder(),
                    ),
                  )
                : _buildPlaceholder(),
            title: Text(
              venue.clubName ?? 'Unknown Venue',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (venue.clubLocation != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          venue.clubLocation!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      venue.notificationsEnabled
                          ? Icons.notifications_active
                          : Icons.notifications_off,
                      size: 14,
                      color: venue.notificationsEnabled
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      venue.notificationsEnabled
                          ? 'Notifications on'
                          : 'Notifications off',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(
                        venue.notificationsEnabled
                            ? Icons.notifications_off
                            : Icons.notifications_active,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        venue.notificationsEnabled
                            ? 'Turn off notifications'
                            : 'Turn on notifications',
                      ),
                    ],
                  ),
                  onTap: () => _toggleNotifications(venue),
                ),
                PopupMenuItem(
                  child: const Row(
                    children: [
                      Icon(Icons.heart_broken, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Unfollow'),
                    ],
                  ),
                  onTap: () => _unfollowVenue(venue.clubId),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUpdatesList() {
    if (_updates.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No updates yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _updates.length,
      itemBuilder: (context, index) {
        final update = _updates[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: update.isRead ? null : Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
          child: InkWell(
            onTap: () => _markAsRead(update),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _getUpdateIcon(update.updateType),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          update.clubName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        _formatTimeAgo(update.createdAt),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    update.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    update.message,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                  if (update.eventName != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.event, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            update.eventName!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.nightlife, color: Colors.grey),
    );
  }

  Widget _getUpdateIcon(UpdateType type) {
    IconData icon;
    Color color;

    switch (type) {
      case UpdateType.newEvent:
        icon = Icons.event_available;
        color = Colors.green;
        break;
      case UpdateType.eventUpdate:
        icon = Icons.update;
        color = Colors.blue;
        break;
      case UpdateType.specialOffer:
        icon = Icons.local_offer;
        color = Colors.orange;
        break;
      case UpdateType.announcement:
        icon = Icons.campaign;
        color = Colors.purple;
        break;
      case UpdateType.general:
      default:
        icon = Icons.info;
        color = Colors.grey;
    }

    return Icon(icon, size: 16, color: color);
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  Future<void> _toggleNotifications(VenueFollow venue) async {
    try {
      await _followService.updateNotificationPreferences(
        clubId: venue.clubId,
        enabled: !venue.notificationsEnabled,
      );
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              venue.notificationsEnabled
                  ? 'Notifications turned off'
                  : 'Notifications turned on',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _unfollowVenue(String clubId) async {
    try {
      await _followService.unfollowVenue(clubId);
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unfollowed venue')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _markAsRead(FollowedVenueUpdate update) async {
    if (update.isRead) return;

    await _followService.markUpdateAsRead(update.id);
    setState(() {
      _unreadCount = (_unreadCount - 1).clamp(0, 999);
    });
  }
}
