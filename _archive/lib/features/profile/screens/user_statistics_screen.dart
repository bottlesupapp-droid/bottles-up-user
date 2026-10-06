import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/user_activity.dart';
import '../services/activity_tracker_service.dart';

class UserStatisticsScreen extends StatefulWidget {
  const UserStatisticsScreen({super.key});

  @override
  State<UserStatisticsScreen> createState() => _UserStatisticsScreenState();
}

class _UserStatisticsScreenState extends State<UserStatisticsScreen> {
  final UserStatisticsService _statisticsService = UserStatisticsService();
  final ActivityTrackerService _activityService = ActivityTrackerService();

  UserStatistics? _statistics;
  ActivityStats? _activityStats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() => _isLoading = true);

    try {
      final stats = await _statisticsService.getUserStatistics();
      final activityStats = await _activityService.getActivityStats();

      setState(() {
        _statistics = stats;
        _activityStats = activityStats;
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
        title: const Text('My Statistics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStatistics,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStatistics,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOverviewSection(),
                    const SizedBox(height: 24),
                    _buildActivitySection(),
                    const SizedBox(height: 24),
                    _buildSpendingSection(),
                    const SizedBox(height: 24),
                    _buildFavoritesSection(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildOverviewSection() {
    if (_statistics == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overview',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _buildStatCard(
              'Total Bookings',
              '${_statistics!.totalBookings}',
              Icons.event,
              Colors.blue,
            ),
            _buildStatCard(
              'Reviews',
              '${_statistics!.totalReviews}',
              Icons.rate_review,
              Colors.orange,
            ),
            _buildStatCard(
              'Check-ins',
              '${_statistics!.totalCheckIns}',
              Icons.location_on,
              Colors.green,
            ),
            _buildStatCard(
              'Friends',
              '${_statistics!.totalFriends}',
              Icons.people,
              Colors.purple,
            ),
            _buildStatCard(
              'Points',
              '${_statistics!.totalPointsEarned}',
              Icons.stars,
              Colors.amber,
            ),
            _buildStatCard(
              'Rewards',
              '${_statistics!.totalRewardsRedeemed}',
              Icons.card_giftcard,
              Colors.red,
            ),
          ],
        ),
        if (_statistics!.averageRating > 0) ...[
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 32),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Average Rating Given',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${_statistics!.averageRating.toStringAsFixed(1)} / 5.0',
                        style: const TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitySection() {
    if (_activityStats == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Activity',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildActivityStat(
                      'Current Streak',
                      '${_activityStats!.currentStreak} days',
                      Icons.local_fire_department,
                      Colors.orange,
                    ),
                    _buildActivityStat(
                      'Longest Streak',
                      '${_activityStats!.longestStreak} days',
                      Icons.emoji_events,
                      Colors.amber,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (_activityStats!.activitiesByMonth.isNotEmpty)
                  _buildActivityChart(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityStat(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityChart() {
    final sortedMonths = _activityStats!.activitiesByMonth.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    final spots = sortedMonths
        .asMap()
        .entries
        .map((entry) => FlSpot(
              entry.key.toDouble(),
              entry.value.value.toDouble(),
            ))
        .toList();

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= sortedMonths.length) {
                    return const Text('');
                  }
                  final month = sortedMonths[value.toInt()].key;
                  return Text(
                    month.substring(5, 7),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Theme.of(context).colorScheme.primary,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpendingSection() {
    if (_statistics == null || _statistics!.totalSpent == 0) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Spending',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Spent',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '\$${_statistics!.totalSpent.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (_statistics!.spendingByMonth != null &&
                    _statistics!.spendingByMonth!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildSpendingChart(),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpendingChart() {
    final sortedMonths = _statistics!.spendingByMonth!.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    final barGroups = sortedMonths
        .asMap()
        .entries
        .map((entry) => BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value.value,
                  color: Theme.of(context).colorScheme.primary,
                  width: 16,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
              ],
            ))
        .toList();

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= sortedMonths.length) {
                    return const Text('');
                  }
                  final month = sortedMonths[value.toInt()].key;
                  return Text(
                    month.substring(5, 7),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: barGroups,
        ),
      ),
    );
  }

  Widget _buildFavoritesSection() {
    if (_statistics == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Favorites',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        if (_statistics!.favoriteVenue != null)
          Card(
            child: ListTile(
              leading: const Icon(Icons.favorite, color: Colors.red),
              title: const Text('Favorite Venue'),
              subtitle: Text(_statistics!.favoriteVenue!),
            ),
          ),
        if (_statistics!.favoriteCategory != null)
          Card(
            child: ListTile(
              leading: const Icon(Icons.category, color: Colors.blue),
              title: const Text('Favorite Category'),
              subtitle: Text(_statistics!.favoriteCategory!),
            ),
          ),
        if (_statistics!.topVenues != null &&
            _statistics!.topVenues!.isNotEmpty) ...[
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Top Venues',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(
                    _statistics!.topVenues!.length.clamp(0, 5),
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            child: Text('${index + 1}'),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(_statistics!.topVenues![index]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
