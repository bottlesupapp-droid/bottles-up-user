import 'package:flutter/material.dart';
import '../models/social_share.dart';
import '../services/social_share_service.dart';

class ExperienceSharingScreen extends StatefulWidget {
  final ShareContent content;

  const ExperienceSharingScreen({
    super.key,
    required this.content,
  });

  @override
  State<ExperienceSharingScreen> createState() =>
      _ExperienceSharingScreenState();
}

class _ExperienceSharingScreenState extends State<ExperienceSharingScreen> {
  final SocialShareService _shareService = SocialShareService();
  final TextEditingController _messageController = TextEditingController();

  bool _isSharing = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Experience'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPreviewCard(),
            const SizedBox(height: 24),
            _buildCustomMessageSection(),
            const SizedBox(height: 24),
            _buildSharePlatforms(),
            const SizedBox(height: 24),
            _buildQuickShareButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewCard() {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Preview header
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Row(
              children: [
                Icon(
                  _getContentIcon(),
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Share Preview',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content preview
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'You',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Just now',
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
                const SizedBox(height: 16),
                Text(
                  _messageController.text.isEmpty
                      ? _shareService.generateShareMessage(widget.content)
                      : _messageController.text,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 12),
                Text(
                  _getTypeLabel(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomMessageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Customize Message',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _messageController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Add a personal message...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
          ),
          onChanged: (value) => setState(() {}),
        ),
        const SizedBox(height: 8),
        Text(
          'Tip: Add hashtags to increase visibility',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSharePlatforms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Share to',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildPlatformButton(
              platform: SharePlatform.instagram,
              icon: Icons.camera_alt,
              label: 'Instagram',
              color: const Color(0xFFE4405F),
            ),
            _buildPlatformButton(
              platform: SharePlatform.facebook,
              icon: Icons.facebook,
              label: 'Facebook',
              color: const Color(0xFF1877F2),
            ),
            _buildPlatformButton(
              platform: SharePlatform.twitter,
              icon: Icons.message,
              label: 'Twitter',
              color: const Color(0xFF1DA1F2),
            ),
            _buildPlatformButton(
              platform: SharePlatform.whatsapp,
              icon: Icons.phone,
              label: 'WhatsApp',
              color: const Color(0xFF25D366),
            ),
            _buildPlatformButton(
              platform: SharePlatform.snapchat,
              icon: Icons.camera,
              label: 'Snapchat',
              color: const Color(0xFFFFFC00),
            ),
            _buildPlatformButton(
              platform: SharePlatform.messages,
              icon: Icons.sms,
              label: 'Messages',
              color: Colors.green,
            ),
            _buildPlatformButton(
              platform: SharePlatform.copy,
              icon: Icons.copy,
              label: 'Copy Link',
              color: Colors.grey,
            ),
            _buildPlatformButton(
              platform: SharePlatform.more,
              icon: Icons.more_horiz,
              label: 'More',
              color: Colors.blueGrey,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlatformButton({
    required SharePlatform platform,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return InkWell(
      onTap: () => _shareToplatform(platform),
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickShareButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: _isSharing ? null : () => _shareToplatform(SharePlatform.more),
          icon: _isSharing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.share),
          label: Text(_isSharing ? 'Sharing...' : 'Share Now'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () async {
            await _shareService.awardSharePoints(
              contentId: 'temp_id',
              contentType: ShareContentType.venue,
            );
            if (mounted) {
              Navigator.pop(context);
            }
          },
          icon: const Icon(Icons.close),
          label: const Text('Cancel'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }

  Future<void> _shareToplatform(SharePlatform platform) async {
    setState(() => _isSharing = true);

    try {
      await _shareService.shareContent(
        content: widget.content,
        platform: platform,
        customMessage: _messageController.text.isNotEmpty
            ? _messageController.text
            : null,
      );

      // Award points for sharing
      await _shareService.awardSharePoints(
        contentId: 'temp_id',
        contentType: widget.content.type,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Experience shared successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to share: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }

  IconData _getContentIcon() {
    switch (widget.content.type) {
      case ShareContentType.venue:
        return Icons.location_on;
      case ShareContentType.event:
        return Icons.event;
      case ShareContentType.booking:
        return Icons.book_online;
      case ShareContentType.review:
        return Icons.rate_review;
      case ShareContentType.achievement:
        return Icons.emoji_events;
      case ShareContentType.invitation:
        return Icons.person_add;
    }
  }

  String _getTypeLabel() {
    switch (widget.content.type) {
      case ShareContentType.venue:
        return 'Venue';
      case ShareContentType.event:
        return 'Event';
      case ShareContentType.booking:
        return 'Booking';
      case ShareContentType.review:
        return 'Review';
      case ShareContentType.achievement:
        return 'Achievement';
      case ShareContentType.invitation:
        return 'Invitation';
    }
  }
}
