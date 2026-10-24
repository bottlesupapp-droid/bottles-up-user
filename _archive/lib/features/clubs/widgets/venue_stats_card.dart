import 'package:flutter/material.dart';
import '../models/venue_follow.dart';
import '../services/venue_follow_service.dart';

class VenueStatsCard extends StatefulWidget {
  final String clubId;
  final bool compact;

  const VenueStatsCard({
    super.key,
    required this.clubId,
    this.compact = false,
  });

  @override
  State<VenueStatsCard> createState() => _VenueStatsCardState();
}

class _VenueStatsCardState extends State<VenueStatsCard> {
  final _followService = VenueFollowService();
  VenueFollowStats? _stats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final stats = await _followService.getVenueStats(widget.clubId);
      setState(() {
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_stats == null) {
      return const SizedBox.shrink();
    }

    if (widget.compact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.people, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            _formatCount(_stats!.followersCount),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 12),
          Icon(Icons.event, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            _formatCount(_stats!.eventsCount),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _StatColumn(
              icon: Icons.people,
              label: 'Followers',
              value: _formatCount(_stats!.followersCount),
              color: Theme.of(context).colorScheme.primary,
            ),
            Container(
              width: 1,
              height: 40,
              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
            ),
            _StatColumn(
              icon: Icons.event,
              label: 'Events',
              value: _formatCount(_stats!.eventsCount),
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}

class _StatColumn extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatColumn({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }
}
