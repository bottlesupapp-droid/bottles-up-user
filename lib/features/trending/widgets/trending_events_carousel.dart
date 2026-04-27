import 'package:flutter/material.dart';
import '../services/trending_service.dart';

class TrendingEventsCarousel extends StatefulWidget {
  final String? category;
  final Function(String eventId)? onEventTap;

  const TrendingEventsCarousel({
    super.key,
    this.category,
    this.onEventTap,
  });

  @override
  State<TrendingEventsCarousel> createState() => _TrendingEventsCarouselState();
}

class _TrendingEventsCarouselState extends State<TrendingEventsCarousel> {
  final _trendingService = TrendingService();
  List<Map<String, dynamic>> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrendingEvents();
  }

  Future<void> _loadTrendingEvents() async {
    setState(() => _isLoading = true);
    try {
      final events = await _trendingService.getTrendingEvents(
        limit: 10,
        category: widget.category,
      );
      setState(() {
        _events = events;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 250,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_events.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.trending_up, color: Colors.orange),
                  const SizedBox(width: 8),
                  Text(
                    widget.category ?? 'Trending Now',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  // Navigate to trending screen
                },
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _events.length,
            itemBuilder: (context, index) {
              final event = _events[index];
              return _TrendingEventCard(
                event: event,
                onTap: () {
                  _trendingService.trackEventView(event['id'] as String);
                  widget.onEventTap?.call(event['id'] as String);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TrendingEventCard extends StatelessWidget {
  final Map<String, dynamic> event;
  final VoidCallback onTap;

  const _TrendingEventCard({
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: event['cover_image'] != null
                        ? Image.network(
                            event['cover_image'] as String,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.event, size: 40),
                              );
                            },
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.event, size: 40),
                          ),
                  ),
                  // Trending badge
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.trending_up,
                            size: 12,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${event['trending_score'] ?? 0}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Details
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event['name'] as String? ?? 'Event',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (event['venue_name'] != null)
                      Text(
                        event['venue_name'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 4),
                    if (event['event_date'] != null)
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 12, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              _formatDate(event['event_date'] as String),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${months[date.month - 1]} ${date.day}';
    } catch (e) {
      return dateStr;
    }
  }
}

// Hot This Week Widget
class HotThisWeekWidget extends StatefulWidget {
  const HotThisWeekWidget({super.key});

  @override
  State<HotThisWeekWidget> createState() => _HotThisWeekWidgetState();
}

class _HotThisWeekWidgetState extends State<HotThisWeekWidget> {
  final _trendingService = TrendingService();
  List<Map<String, dynamic>> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHotEvents();
  }

  Future<void> _loadHotEvents() async {
    setState(() => _isLoading = true);
    try {
      final events = await _trendingService.getHotThisWeek();
      setState(() {
        _events = events;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_events.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.local_fire_department,
                    color: Colors.red),
              ),
              const SizedBox(width: 12),
              const Text(
                'Hot This Week',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _events.take(5).length,
          itemBuilder: (context, index) {
            final event = _events[index];
            return _HotEventListTile(
              event: event,
              rank: index + 1,
            );
          },
        ),
      ],
    );
  }
}

class _HotEventListTile extends StatelessWidget {
  final Map<String, dynamic> event;
  final int rank;

  const _HotEventListTile({
    required this.event,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: event['cover_image'] != null
                  ? NetworkImage(event['cover_image'] as String)
                  : null,
              child: event['cover_image'] == null
                  ? const Icon(Icons.event)
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '#$rank',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          event['name'] as String? ?? 'Event',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          event['venue_name'] as String? ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Icon(Icons.trending_up, color: Colors.red, size: 20),
            const SizedBox(height: 2),
            Text(
              '${event['booking_count'] ?? 0} bookings',
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
