import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketDetailScreen extends StatelessWidget {
  final String ticketId;
  final String eventName;
  final String venueName;
  final String eventDate;
  final String eventTime;
  final int ticketQuantity;
  final String ticketPrice;
  final String totalAmount;
  final String status;
  final String? confirmationCode;

  const TicketDetailScreen({
    super.key,
    required this.ticketId,
    required this.eventName,
    required this.venueName,
    required this.eventDate,
    required this.eventTime,
    required this.ticketQuantity,
    required this.ticketPrice,
    required this.totalAmount,
    required this.status,
    this.confirmationCode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Ticket Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.share),
            onPressed: () {
              // TODO: Implement share ticket
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share ticket feature coming soon')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Badge
            _buildStatusChip(status, theme),
            const Gap(16),

            // Event Name
            Text(
              eventName,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(8),

            // Venue
            Row(
              children: [
                Icon(
                  Iconsax.location,
                  size: 18,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                const Gap(6),
                Expanded(
                  child: Text(
                    venueName,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(24),

            // Ticket Information Card
            _buildInfoCard(
              theme: theme,
              primaryColor: primaryColor,
              title: 'Ticket Information',
              children: [
                _buildInfoRow(
                  theme: theme,
                  icon: Iconsax.calendar_1,
                  label: 'Event Date',
                  value: eventDate,
                ),
                const Divider(height: 24),
                _buildInfoRow(
                  theme: theme,
                  icon: Iconsax.clock,
                  label: 'Event Time',
                  value: eventTime,
                ),
                const Divider(height: 24),
                _buildInfoRow(
                  theme: theme,
                  icon: Iconsax.ticket,
                  label: 'Ticket Quantity',
                  value: ticketQuantity.toString(),
                ),
                const Divider(height: 24),
                _buildInfoRow(
                  theme: theme,
                  icon: Iconsax.dollar_circle,
                  label: 'Ticket Price',
                  value: '\$$ticketPrice',
                ),
                const Divider(height: 24),
                _buildInfoRow(
                  theme: theme,
                  icon: Iconsax.card,
                  label: 'Total Amount',
                  value: '\$$totalAmount',
                  valueStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: primaryColor,
                  ),
                ),
                if (confirmationCode != null) ...[
                  const Divider(height: 24),
                  _buildInfoRow(
                    theme: theme,
                    icon: Iconsax.document_code,
                    label: 'Confirmation Code',
                    value: confirmationCode!,
                  ),
                ],
              ],
            ),
            const Gap(24),

            // QR Code Card
            _buildInfoCard(
              theme: theme,
              primaryColor: primaryColor,
              title: 'Your Entry QR Code',
              subtitle: 'Show this at the venue entrance',
              children: [
                const Gap(16),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: QrImageView(
                      data: confirmationCode ?? ticketId,
                      size: 220,
                      backgroundColor: Colors.white,
                      errorCorrectionLevel: QrErrorCorrectLevel.M,
                    ),
                  ),
                ),
                const Gap(16),
                Center(
                  child: Text(
                    'Ticket ID: ${ticketId.substring(0, 8).toUpperCase()}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(24),

            // Important Information Card
            _buildInfoCard(
              theme: theme,
              primaryColor: primaryColor,
              title: 'Important Information',
              children: [
                _buildBulletPoint(
                  theme: theme,
                  text: 'Please arrive 15-30 minutes before the event start time',
                ),
                const Gap(12),
                _buildBulletPoint(
                  theme: theme,
                  text: 'Valid ID is required for entry (21+ events)',
                ),
                const Gap(12),
                _buildBulletPoint(
                  theme: theme,
                  text: 'Save this QR code or take a screenshot for entry',
                ),
                const Gap(12),
                _buildBulletPoint(
                  theme: theme,
                  text: 'Tickets are non-transferable unless explicitly allowed',
                ),
                const Gap(12),
                _buildBulletPoint(
                  theme: theme,
                  text: 'Check venue website for dress code requirements',
                ),
              ],
            ),
            const Gap(24),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _showFullQRCode(context, theme, primaryColor),
                icon: const Icon(Iconsax.scan_barcode),
                label: const Text('View Full Screen QR Code'),
                style: FilledButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const Gap(12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Implement add to wallet
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Add to wallet feature coming soon')),
                  );
                },
                icon: const Icon(Iconsax.wallet_3),
                label: const Text('Add to Apple/Google Wallet'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const Gap(100),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required ThemeData theme,
    required Color primaryColor,
    required String title,
    String? subtitle,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null) ...[
            const Gap(4),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
          const Gap(16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required ThemeData theme,
    required IconData icon,
    required String label,
    required String value,
    TextStyle? valueStyle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: theme.colorScheme.primary,
          ),
        ),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const Gap(2),
              Text(
                value,
                style: valueStyle ??
                    theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBulletPoint({
    required ThemeData theme,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
        ),
        const Gap(12),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status, ThemeData theme) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'confirmed':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        icon = Iconsax.tick_circle;
        break;
      case 'pending':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        icon = Iconsax.clock;
        break;
      case 'cancelled':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        icon = Iconsax.close_circle;
        break;
      case 'completed':
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        icon = Iconsax.verify;
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade800;
        icon = Iconsax.info_circle;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const Gap(6),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              color: textColor,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showFullQRCode(BuildContext context, ThemeData theme, Color primaryColor) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Scan QR Code',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(8),
              Text(
                'Show this at the venue entrance',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const Gap(24),
              // Full Screen QR Code
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: QrImageView(
                  data: confirmationCode ?? ticketId,
                  size: 280,
                  backgroundColor: Colors.white,
                  errorCorrectionLevel: QrErrorCorrectLevel.H,
                ),
              ),
              const Gap(24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
