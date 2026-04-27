import 'package:flutter/material.dart';
import '../models/friend.dart';
import '../services/friend_service.dart';

class SocialFeedScreen extends StatefulWidget {
  const SocialFeedScreen({super.key});

  @override
  State<SocialFeedScreen> createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends State<SocialFeedScreen>
    with SingleTickerProviderStateMixin {
  final FriendService _friendService = FriendService();

  late TabController _tabController;
  List<FriendActivity> _activities = [];
  List<Friend> _friends = [];
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
      final activities = await _friendService.getFriendActivities(limit: 50);
      final friends = await _friendService.getFriends(
        status: FriendshipStatus.accepted,
      );

      setState(() {
        _activities = activities;
        _friends = friends;
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
        title: const Text('Social'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Activity Feed'),
            Tab(text: 'Friends'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActivityFeed(),
          _buildFriendsList(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddFriendDialog,
        icon: const Icon(Icons.person_add),
        label: const Text('Add Friend'),
      ),
    );
  }

  Widget _buildActivityFeed() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_activities.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No friend activity yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add friends to see their activities',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _activities.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final activity = _activities[index];
          return _buildActivityCard(activity);
        },
      ),
    );
  }

  Widget _buildActivityCard(FriendActivity activity) {
    final icon = _getActivityIcon(activity.activityType);
    final color = _getActivityColor(activity.activityType);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: activity.friendAvatar != null
                  ? NetworkImage(activity.friendAvatar!)
                  : null,
              child: activity.friendAvatar == null
                  ? Text(activity.friendName[0].toUpperCase())
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          activity.friendName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        _formatTime(activity.activityAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(icon, size: 16, color: color),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          activity.activityDescription,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (activity.activityData != null)
                    _buildActivityData(activity),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityData(FriendActivity activity) {
    final data = activity.activityData!;

    switch (activity.activityType) {
      case 'booking':
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                if (data['venue_image'] != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      data['venue_image'] as String,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['venue_name'] as String? ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (data['event_date'] != null)
                        Text(
                          data['event_date'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      case 'review':
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ...List.generate(
                      5,
                      (index) => Icon(
                        index < (data['rating'] as num? ?? 0)
                            ? Icons.star
                            : Icons.star_border,
                        size: 16,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
                if (data['comment'] != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    data['comment'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildFriendsList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_friends.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_add_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No friends yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _showAddFriendDialog,
              icon: const Icon(Icons.person_add),
              label: const Text('Add Friends'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _friends.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final friend = _friends[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: friend.friendAvatar != null
                  ? NetworkImage(friend.friendAvatar!)
                  : null,
              child: friend.friendAvatar == null
                  ? Text(friend.friendName[0].toUpperCase())
                  : null,
            ),
            title: Text(friend.friendName),
            subtitle: friend.friendEmail != null
                ? Text(friend.friendEmail!)
                : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    friend.isFavorite ? Icons.star : Icons.star_border,
                    color: friend.isFavorite ? Colors.amber : null,
                  ),
                  onPressed: () => _toggleFavorite(friend),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () => _showFriendOptions(friend),
                ),
              ],
            ),
            onTap: () => _viewFriendProfile(friend),
          );
        },
      ),
    );
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'booking':
        return Icons.event;
      case 'review':
        return Icons.rate_review;
      case 'check_in':
        return Icons.location_on;
      case 'achievement':
        return Icons.emoji_events;
      case 'tier_upgrade':
        return Icons.trending_up;
      default:
        return Icons.info;
    }
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'booking':
        return Colors.blue;
      case 'review':
        return Colors.orange;
      case 'check_in':
        return Colors.green;
      case 'achievement':
        return Colors.purple;
      case 'tier_upgrade':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
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

  Future<void> _showAddFriendDialog() async {
    // Navigate to add friend screen
    // For now, show a simple dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Friend'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search Users'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to search screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.contacts),
              title: const Text('Invite Contacts'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to contacts screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.qr_code),
              title: const Text('Scan QR Code'),
              onTap: () {
                Navigator.pop(context);
                // Open QR scanner
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleFavorite(Friend friend) async {
    try {
      await _friendService.toggleFavoriteFriend(
        friend.id,
        !friend.isFavorite,
      );
      _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update favorite: $e')),
        );
      }
    }
  }

  void _showFriendOptions(Friend friend) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('View Profile'),
            onTap: () {
              Navigator.pop(context);
              _viewFriendProfile(friend);
            },
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('Send Message'),
            onTap: () {
              Navigator.pop(context);
              // Open messaging
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_remove, color: Colors.red),
            title: const Text('Remove Friend', style: TextStyle(color: Colors.red)),
            onTap: () async {
              Navigator.pop(context);
              await _confirmRemoveFriend(friend);
            },
          ),
        ],
      ),
    );
  }

  void _viewFriendProfile(Friend friend) {
    // Navigate to friend's profile
    // Navigator.push(...)
  }

  Future<void> _confirmRemoveFriend(Friend friend) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Friend'),
        content: Text('Are you sure you want to remove ${friend.friendName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _friendService.removeFriend(friend.id);
        _loadData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Friend removed')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to remove friend: $e')),
          );
        }
      }
    }
  }
}
