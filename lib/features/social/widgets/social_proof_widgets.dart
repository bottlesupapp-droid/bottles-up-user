import 'package:flutter/material.dart';

// Widget showing who from your friends visited this venue
class FriendsVisitedWidget extends StatelessWidget {
  final List<Map<String, dynamic>> friendsWhoVisited;
  final int totalVisits;

  const FriendsVisitedWidget({
    super.key,
    required this.friendsWhoVisited,
    this.totalVisits = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (friendsWhoVisited.isEmpty) return const SizedBox.shrink();

    final displayFriends = friendsWhoVisited.take(3).toList();
    final remainingCount = friendsWhoVisited.length - displayFriends.length;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          // Avatar stack
          SizedBox(
            width: 60,
            height: 32,
            child: Stack(
              children: [
                for (int i = 0; i < displayFriends.length && i < 3; i++)
                  Positioned(
                    left: i * 20.0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 16,
                        backgroundImage: displayFriends[i]['avatar'] != null
                            ? NetworkImage(displayFriends[i]['avatar'] as String)
                            : null,
                        child: displayFriends[i]['avatar'] == null
                            ? Text(
                                displayFriends[i]['name']![0].toUpperCase(),
                                style: const TextStyle(fontSize: 12),
                              )
                            : null,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getFriendsText(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                if (totalVisits > 0)
                  Text(
                    '$totalVisits total visits',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
          Icon(Icons.people, color: Colors.blue.shade700, size: 20),
        ],
      ),
    );
  }

  String _getFriendsText() {
    if (friendsWhoVisited.isEmpty) return '';

    final names = friendsWhoVisited.map((f) => f['name'] as String).toList();

    if (names.length == 1) {
      return '${names[0]} visited here';
    } else if (names.length == 2) {
      return '${names[0]} and ${names[1]} visited here';
    } else if (names.length == 3) {
      return '${names[0]}, ${names[1]} and ${names[2]} visited here';
    } else {
      final remainingCount = names.length - 2;
      return '${names[0]}, ${names[1]} and $remainingCount others visited here';
    }
  }
}

// Widget showing trending/popular indicator
class TrendingIndicatorWidget extends StatelessWidget {
  final int bookingsLast24h;
  final double trendingScore;

  const TrendingIndicatorWidget({
    super.key,
    required this.bookingsLast24h,
    required this.trendingScore,
  });

  @override
  Widget build(BuildContext context) {
    if (bookingsLast24h < 10) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade400, Colors.red.shade400],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_fire_department, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            'Trending',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '$bookingsLast24h bookings today',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget showing recent activity count
class RecentActivityWidget extends StatelessWidget {
  final int viewsLast24h;
  final int bookingsLast7d;

  const RecentActivityWidget({
    super.key,
    this.viewsLast24h = 0,
    this.bookingsLast7d = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (viewsLast24h > 0) ...[
          Icon(Icons.visibility, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            '$viewsLast24h views today',
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        ],
        if (viewsLast24h > 0 && bookingsLast7d > 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('•', style: TextStyle(color: Colors.grey[600])),
          ),
        if (bookingsLast7d > 0) ...[
          Icon(Icons.event_available, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            '$bookingsLast7d bookings this week',
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        ],
      ],
    );
  }
}

// Widget showing user testimonials/reviews
class TestimonialWidget extends StatelessWidget {
  final String userName;
  final String? userAvatar;
  final double rating;
  final String review;
  final DateTime reviewDate;
  final bool isVerified;

  const TestimonialWidget({
    super.key,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.review,
    required this.reviewDate,
    this.isVerified = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      userAvatar != null ? NetworkImage(userAvatar!) : null,
                  child: userAvatar == null
                      ? Text(userName[0].toUpperCase())
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (isVerified) ...[
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.verified,
                              size: 16,
                              color: Colors.blue,
                            ),
                          ],
                        ],
                      ),
                      Row(
                        children: [
                          ...List.generate(
                            5,
                            (index) => Icon(
                              index < rating ? Icons.star : Icons.star_border,
                              size: 14,
                              color: Colors.amber,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatDate(reviewDate),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              review,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) return 'Today';
    if (difference.inDays == 1) return 'Yesterday';
    if (difference.inDays < 7) return '${difference.inDays} days ago';
    if (difference.inDays < 30) return '${(difference.inDays / 7).floor()} weeks ago';
    if (difference.inDays < 365) return '${(difference.inDays / 30).floor()} months ago';
    return '${(difference.inDays / 365).floor()} years ago';
  }
}

// Widget showing live booking notifications
class LiveBookingWidget extends StatefulWidget {
  final Stream<Map<String, dynamic>>? bookingStream;

  const LiveBookingWidget({
    super.key,
    this.bookingStream,
  });

  @override
  State<LiveBookingWidget> createState() => _LiveBookingWidgetState();
}

class _LiveBookingWidgetState extends State<LiveBookingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  Map<String, dynamic>? _latestBooking;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    widget.bookingStream?.listen((booking) {
      setState(() => _latestBooking = booking);
      _controller.forward().then((_) {
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) {
            _controller.reverse();
          }
        });
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_latestBooking == null) return const SizedBox.shrink();

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${_latestBooking!['userName']} just booked a table',
                style: const TextStyle(fontSize: 13),
              ),
            ),
            Text(
              'Just now',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget showing popularity badge
class PopularityBadgeWidget extends StatelessWidget {
  final int popularityRank;
  final String category;

  const PopularityBadgeWidget({
    super.key,
    required this.popularityRank,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    if (popularityRank > 10) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getBadgeColor(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getBadgeIcon(), color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(
            '#$popularityRank in $category',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getBadgeColor() {
    if (popularityRank == 1) return Colors.amber;
    if (popularityRank <= 3) return Colors.orange;
    if (popularityRank <= 5) return Colors.deepOrange;
    return Colors.red;
  }

  IconData _getBadgeIcon() {
    if (popularityRank == 1) return Icons.emoji_events;
    if (popularityRank <= 3) return Icons.star;
    return Icons.trending_up;
  }
}

// Widget showing social media presence
class SocialMediaStatsWidget extends StatelessWidget {
  final int instagramFollowers;
  final int facebookLikes;
  final int totalCheckIns;

  const SocialMediaStatsWidget({
    super.key,
    this.instagramFollowers = 0,
    this.facebookLikes = 0,
    this.totalCheckIns = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        if (instagramFollowers > 0)
          _buildStat(
            icon: Icons.camera_alt,
            label: '${_formatNumber(instagramFollowers)} followers',
            color: const Color(0xFFE4405F),
          ),
        if (facebookLikes > 0)
          _buildStat(
            icon: Icons.thumb_up,
            label: '${_formatNumber(facebookLikes)} likes',
            color: const Color(0xFF1877F2),
          ),
        if (totalCheckIns > 0)
          _buildStat(
            icon: Icons.location_on,
            label: '${_formatNumber(totalCheckIns)} check-ins',
            color: Colors.green,
          ),
      ],
    );
  }

  Widget _buildStat({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
        ),
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
