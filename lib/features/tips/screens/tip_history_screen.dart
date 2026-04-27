import 'package:flutter/material.dart';
import '../models/tip_record.dart';
import '../services/tip_service.dart';

class TipHistoryScreen extends StatefulWidget {
  const TipHistoryScreen({super.key});

  @override
  State<TipHistoryScreen> createState() => _TipHistoryScreenState();
}

class _TipHistoryScreenState extends State<TipHistoryScreen> {
  final _tipService = TipService();
  List<TipRecord> _tips = [];
  TipStatistics? _statistics;
  bool _isLoading = true;
  String _selectedFilter = 'all'; // all, this_month, last_month, this_year

  @override
  void initState() {
    super.initState();
    _loadTipHistory();
  }

  Future<void> _loadTipHistory() async {
    setState(() => _isLoading = true);
    try {
      DateTime? startDate;
      DateTime? endDate;

      switch (_selectedFilter) {
        case 'this_month':
          startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
          endDate = DateTime.now();
          break;
        case 'last_month':
          final lastMonth = DateTime.now().month - 1;
          final year = lastMonth < 1 ? DateTime.now().year - 1 : DateTime.now().year;
          final month = lastMonth < 1 ? 12 : lastMonth;
          startDate = DateTime(year, month, 1);
          endDate = DateTime(year, month + 1, 0);
          break;
        case 'this_year':
          startDate = DateTime(DateTime.now().year, 1, 1);
          endDate = DateTime.now();
          break;
      }

      final tips = await _tipService.getTipHistory(
        startDate: startDate,
        endDate: endDate,
      );

      final stats = await _tipService.getTipStatistics(
        startDate: startDate,
        endDate: endDate,
      );

      setState(() {
        _tips = tips;
        _statistics = stats;
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
        title: const Text('Tip History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.insights),
            onPressed: _showInsights,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadTipHistory,
              child: CustomScrollView(
                slivers: [
                  if (_statistics != null) _buildStatisticsSection(),
                  _buildFilterChips(),
                  _buildTipsList(),
                ],
              ),
            ),
    );
  }

  Widget _buildStatisticsSection() {
    return SliverToBoxAdapter(
      child: Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Tipping Stats',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Total Tipped',
                      value: '\$${_statistics!.totalTipped.toStringAsFixed(2)}',
                      icon: Icons.attach_money,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Avg Amount',
                      value: '\$${_statistics!.averageTipAmount.toStringAsFixed(2)}',
                      icon: Icons.analytics,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Avg Percentage',
                      value: '${_statistics!.averageTipPercentage.toStringAsFixed(1)}%',
                      icon: Icons.percent,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Total Tips',
                      value: '${_statistics!.totalTips}',
                      icon: Icons.receipt,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
              if (_statistics!.mostTippedVenue != null) ...[
                const Divider(height: 24),
                Row(
                  children: [
                    const Icon(Icons.store, size: 20, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Most Tipped Venue',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            _statistics!.mostTippedVenue!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Wrap(
          spacing: 8,
          children: [
            FilterChip(
              label: const Text('All Time'),
              selected: _selectedFilter == 'all',
              onSelected: (selected) {
                setState(() => _selectedFilter = 'all');
                _loadTipHistory();
              },
            ),
            FilterChip(
              label: const Text('This Month'),
              selected: _selectedFilter == 'this_month',
              onSelected: (selected) {
                setState(() => _selectedFilter = 'this_month');
                _loadTipHistory();
              },
            ),
            FilterChip(
              label: const Text('Last Month'),
              selected: _selectedFilter == 'last_month',
              onSelected: (selected) {
                setState(() => _selectedFilter = 'last_month');
                _loadTipHistory();
              },
            ),
            FilterChip(
              label: const Text('This Year'),
              selected: _selectedFilter == 'this_year',
              onSelected: (selected) {
                setState(() => _selectedFilter = 'this_year');
                _loadTipHistory();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipsList() {
    if (_tips.isEmpty) {
      return const SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.receipt_long, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No tips yet',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                'Your tip history will appear here',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    // Group tips by date
    final groupedTips = <String, List<TipRecord>>{};
    for (final tip in _tips) {
      final dateKey = _formatDateKey(tip.createdAt);
      if (!groupedTips.containsKey(dateKey)) {
        groupedTips[dateKey] = [];
      }
      groupedTips[dateKey]!.add(tip);
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final dateKey = groupedTips.keys.elementAt(index);
            final tipsForDate = groupedTips[dateKey]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    dateKey,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                ...tipsForDate.map((tip) => _TipCard(tip: tip)),
                const SizedBox(height: 16),
              ],
            );
          },
          childCount: groupedTips.length,
        ),
      ),
    );
  }

  String _formatDateKey(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tipDate = DateTime(date.year, date.month, date.day);

    if (tipDate == today) {
      return 'Today';
    } else if (tipDate == yesterday) {
      return 'Yesterday';
    } else {
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
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
  }

  Future<void> _showInsights() async {
    try {
      final insights = await _tipService.getTipInsights();

      if (!mounted) return;

      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.insights, color: Colors.orange),
                    const SizedBox(width: 12),
                    const Text(
                      'Your Tipping Insights',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _InsightRow(
                  icon: Icons.trending_up,
                  label: 'Tipper Level',
                  value: insights['tipper_level']?.toString().toUpperCase() ?? 'N/A',
                  color: _getTipperLevelColor(insights['tipper_level'] as String?),
                ),
                const SizedBox(height: 16),
                _InsightRow(
                  icon: Icons.percent,
                  label: 'Your Typical Tip',
                  value: '${insights['typical_tip_percentage']?.toStringAsFixed(1) ?? '0'}%',
                  color: Colors.blue,
                ),
                const SizedBox(height: 16),
                _InsightRow(
                  icon: Icons.attach_money,
                  label: 'Lifetime Tips',
                  value: '\$${insights['total_tipped']?.toStringAsFixed(2) ?? '0.00'}',
                  color: Colors.green,
                ),
                if (insights['favorite_venue'] != null) ...[
                  const SizedBox(height: 16),
                  _InsightRow(
                    icon: Icons.favorite,
                    label: 'Favorite Venue',
                    value: insights['favorite_venue'] as String,
                    color: Colors.red,
                  ),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load insights: $e')),
        );
      }
    }
  }

  Color _getTipperLevelColor(String? level) {
    switch (level?.toLowerCase()) {
      case 'generous':
        return Colors.green;
      case 'standard':
        return Colors.blue;
      case 'conservative':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final TipRecord tip;

  const _TipCard({required this.tip});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          child: Icon(
            Icons.attach_money,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(
          tip.venueName ?? 'Unknown Venue',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Bill: \$${tip.billAmount.toStringAsFixed(2)}'),
            if (tip.staffName != null)
              Text(
                'Server: ${tip.staffName}',
                style: const TextStyle(fontSize: 12),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${tip.tipAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            if (tip.tipPercentage != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${tip.tipPercentage!.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InsightRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
