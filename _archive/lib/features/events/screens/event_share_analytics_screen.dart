import 'package:flutter/material.dart';
import '../models/event.dart';
import '../models/event_share.dart';
import '../services/event_share_service.dart';

class EventShareAnalyticsScreen extends StatefulWidget {
  final Event event;

  const EventShareAnalyticsScreen({
    super.key,
    required this.event,
  });

  @override
  State<EventShareAnalyticsScreen> createState() =>
      _EventShareAnalyticsScreenState();
}

class _EventShareAnalyticsScreenState extends State<EventShareAnalyticsScreen> {
  final _shareService = EventShareService();
  ShareAnalytics? _analytics;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    try {
      final analytics =
          await _shareService.getShareAnalytics(widget.event.id);
      setState(() {
        _analytics = analytics;
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
        title: const Text('Share Analytics'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _analytics == null
              ? const Center(child: Text('No analytics available'))
              : RefreshIndicator(
                  onRefresh: _loadAnalytics,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Overview Cards
                      Row(
                        children: [
                          Expanded(
                            child: _MetricCard(
                              title: 'Total Shares',
                              value: _analytics!.totalShares.toString(),
                              icon: Icons.share,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _MetricCard(
                              title: 'Total Clicks',
                              value: _analytics!.totalClicks.toString(),
                              icon: Icons.touch_app,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _MetricCard(
                              title: 'Signups',
                              value: _analytics!.totalSignups.toString(),
                              icon: Icons.person_add,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _MetricCard(
                              title: 'Click Rate',
                              value: _analytics!.totalShares > 0
                                  ? '${(_analytics!.totalClicks / _analytics!.totalShares).toStringAsFixed(1)}x'
                                  : '0x',
                              icon: Icons.trending_up,
                              color: Colors.purple,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Platform Breakdown
                      if (_analytics!.sharesByPlatform.isNotEmpty) ...[
                        Text(
                          'Shares by Platform',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: _analytics!.sharesByPlatform.entries
                                  .map((entry) => _PlatformRow(
                                        platform: entry.key,
                                        shares: entry.value,
                                        clicks: _analytics!
                                                .clicksByPlatform[entry.key] ??
                                            0,
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Top Sharers
                      if (_analytics!.topSharers.isNotEmpty) ...[
                        Text(
                          'Top Sharers',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Card(
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _analytics!.topSharers.length,
                            separatorBuilder: (context, index) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final sharer = _analytics!.topSharers[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: sharer.userAvatar != null
                                      ? NetworkImage(sharer.userAvatar!)
                                      : null,
                                  child: sharer.userAvatar == null
                                      ? Text('${index + 1}')
                                      : null,
                                ),
                                title: Text(sharer.userName),
                                subtitle: Text(
                                  '${sharer.shareCount} shares • ${sharer.clickCount} clicks',
                                ),
                                trailing: sharer.signupCount > 0
                                    ? Chip(
                                        label: Text(
                                          '${sharer.signupCount} signups',
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                        visualDensity: VisualDensity.compact,
                                      )
                                    : null,
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
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
                Icon(icon, color: color, size: 20),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlatformRow extends StatelessWidget {
  final SharePlatform platform;
  final int shares;
  final int clicks;

  const _PlatformRow({
    required this.platform,
    required this.shares,
    required this.clicks,
  });

  IconData _getPlatformIcon() {
    switch (platform) {
      case SharePlatform.whatsapp:
        return Icons.whatshot;
      case SharePlatform.facebook:
        return Icons.facebook;
      case SharePlatform.twitter:
        return Icons.flutter_dash;
      case SharePlatform.instagram:
        return Icons.camera_alt;
      case SharePlatform.sms:
        return Icons.message;
      case SharePlatform.email:
        return Icons.email;
      case SharePlatform.qrCode:
        return Icons.qr_code;
      default:
        return Icons.link;
    }
  }

  String _getPlatformName() {
    switch (platform) {
      case SharePlatform.whatsapp:
        return 'WhatsApp';
      case SharePlatform.facebook:
        return 'Facebook';
      case SharePlatform.twitter:
        return 'Twitter';
      case SharePlatform.instagram:
        return 'Instagram';
      case SharePlatform.sms:
        return 'SMS';
      case SharePlatform.email:
        return 'Email';
      case SharePlatform.qrCode:
        return 'QR Code';
      case SharePlatform.link:
        return 'Direct Link';
      default:
        return 'Other';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(_getPlatformIcon(), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _getPlatformName(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(
            '$shares shares',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(width: 16),
          Text(
            '$clicks clicks',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
