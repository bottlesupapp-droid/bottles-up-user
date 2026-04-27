import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/event.dart';
import '../models/event_share.dart';
import '../services/event_share_service.dart';

class EventShareSheet extends StatefulWidget {
  final Event event;

  const EventShareSheet({
    super.key,
    required this.event,
  });

  @override
  State<EventShareSheet> createState() => _EventShareSheetState();
}

class _EventShareSheetState extends State<EventShareSheet> {
  final _shareService = EventShareService();
  EventShare? _shareLink;
  bool _isLoading = true;
  bool _showQR = false;

  @override
  void initState() {
    super.initState();
    _loadShareLink();
  }

  Future<void> _loadShareLink() async {
    try {
      final shareLink = await _shareService.getOrCreateShareLink(
        eventId: widget.event.id,
      );
      setState(() {
        _shareLink = shareLink;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _shareToPlatform(SharePlatform platform) async {
    try {
      await _shareService.shareToPlatform(
        event: widget.event,
        platform: platform,
      );
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Shared successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to share: $e')),
        );
      }
    }
  }

  Future<void> _copyLink() async {
    if (_shareLink == null) return;

    await Clipboard.setData(ClipboardData(text: _shareLink!.shareUrl));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link copied to clipboard!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.share,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Text(
                'Share Event',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 24),

          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_shareLink != null) ...[
            // QR Code Toggle
            Center(
              child: TextButton.icon(
                onPressed: () => setState(() => _showQR = !_showQR),
                icon: Icon(_showQR ? Icons.grid_view : Icons.qr_code),
                label: Text(_showQR ? 'Show Share Options' : 'Show QR Code'),
              ),
            ),
            const SizedBox(height: 16),

            if (_showQR) ...[
              // QR Code Display
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      QrImageView(
                        data: _shareService.generateQRData(
                          widget.event.id,
                          shareToken: _shareLink!.shareToken,
                        ),
                        version: QrVersions.auto,
                        size: 200,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Scan to join event',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.black87,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ] else ...[
              // Copy Link Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Event Link',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _shareLink!.shareUrl,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton.filled(
                      onPressed: _copyLink,
                      icon: const Icon(Icons.copy, size: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Share Options
              Text(
                'Share via',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),

              // Social Media Grid
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _ShareOptionCard(
                    icon: Icons.whatshot,
                    label: 'WhatsApp',
                    color: const Color(0xFF25D366),
                    onTap: () => _shareToPlatform(SharePlatform.whatsapp),
                  ),
                  _ShareOptionCard(
                    icon: Icons.facebook,
                    label: 'Facebook',
                    color: const Color(0xFF1877F2),
                    onTap: () => _shareToPlatform(SharePlatform.facebook),
                  ),
                  _ShareOptionCard(
                    icon: Icons.flutter_dash,
                    label: 'Twitter',
                    color: const Color(0xFF1DA1F2),
                    onTap: () => _shareToPlatform(SharePlatform.twitter),
                  ),
                  _ShareOptionCard(
                    icon: Icons.camera_alt,
                    label: 'Instagram',
                    color: const Color(0xFFE4405F),
                    onTap: () => _shareToPlatform(SharePlatform.instagram),
                  ),
                  _ShareOptionCard(
                    icon: Icons.message,
                    label: 'SMS',
                    color: Colors.green,
                    onTap: () => _shareToPlatform(SharePlatform.sms),
                  ),
                  _ShareOptionCard(
                    icon: Icons.email,
                    label: 'Email',
                    color: Colors.orange,
                    onTap: () => _shareToPlatform(SharePlatform.email),
                  ),
                  _ShareOptionCard(
                    icon: Icons.more_horiz,
                    label: 'More',
                    color: Colors.grey,
                    onTap: () => _shareToPlatform(SharePlatform.link),
                  ),
                ],
              ),
            ],

            // Stats (if available)
            if (_shareLink!.clickCount > 0) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatItem(
                    icon: Icons.visibility,
                    label: 'Clicks',
                    value: _shareLink!.clickCount.toString(),
                  ),
                  if (_shareLink!.signupCount > 0)
                    _StatItem(
                      icon: Icons.person_add,
                      label: 'Signups',
                      value: _shareLink!.signupCount.toString(),
                    ),
                ],
              ),
            ],
          ],

          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}

class _ShareOptionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ShareOptionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
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
