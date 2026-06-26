import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:bottles_up_user/features/bookings/models/user_booking.dart';

class BookingDetailScreen extends StatelessWidget {
  final UserBooking booking;

  const BookingDetailScreen({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  booking.eventImage != null
                      ? Image.network(
                          booking.eventImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildImagePlaceholder(theme),
                        )
                      : _buildImagePlaceholder(theme),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          theme.scaffoldBackgroundColor.withValues(alpha: 0.7),
                          theme.scaffoldBackgroundColor,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status & Type Badges
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getBookingTypeColor(booking.type),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getBookingTypeIcon(booking.type),
                              size: 14,
                              color: Colors.white,
                            ),
                            const Gap(4),
                            Text(
                              booking.type,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(booking.status),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          booking.status.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(16),

                  // Event Name
                  Text(
                    booking.eventName,
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
                          booking.venueName,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(24),

                  // Booking Details Card
                  _buildInfoCard(
                    theme: theme,
                    primaryColor: primaryColor,
                    title: 'Booking Information',
                    children: [
                      _buildInfoRow(
                        theme: theme,
                        icon: Iconsax.calendar_1,
                        label: 'Date',
                        value: booking.formattedDate,
                      ),
                      const Divider(height: 24),
                      _buildInfoRow(
                        theme: theme,
                        icon: Iconsax.clock,
                        label: 'Time',
                        value: booking.formattedTime,
                      ),
                      const Divider(height: 24),
                      _buildInfoRow(
                        theme: theme,
                        icon: Iconsax.card,
                        label: 'Booking ID',
                        value: booking.shortId,
                      ),
                      if (booking.confirmationCode != null) ...[
                        const Divider(height: 24),
                        _buildInfoRow(
                          theme: theme,
                          icon: Iconsax.ticket_star,
                          label: 'Confirmation',
                          value: booking.confirmationCode!,
                        ),
                      ],
                      if (booking.totalAmount != null) ...[
                        const Divider(height: 24),
                        _buildInfoRow(
                          theme: theme,
                          icon: Iconsax.money,
                          label: 'Total Paid',
                          value: '\$${booking.totalAmount!.toStringAsFixed(2)}',
                        ),
                      ],
                      if (booking.details != null) ...[
                        const Divider(height: 24),
                        _buildInfoRow(
                          theme: theme,
                          icon: _getBookingTypeIcon(booking.type),
                          label: 'Details',
                          value: booking.details!,
                        ),
                      ],
                    ],
                  ),
                  const Gap(16),

                  // QR Code Card (if available)
                  if (booking.hasQRCode && booking.qrCode != null) ...[
                    _buildInfoCard(
                      theme: theme,
                      primaryColor: primaryColor,
                      title: 'Your QR Code',
                      subtitle: 'Show this at the venue entrance',
                      children: [
                        const Gap(16),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: QrImageView(
                              data: booking.qrCode!,
                              size: 220,
                              backgroundColor: Colors.white,
                              errorCorrectionLevel: QrErrorCorrectLevel.M,
                            ),
                          ),
                        ),
                        const Gap(16),
                      ],
                    ),
                    const Gap(16),
                  ],

                  // Important Information Card
                  _buildInfoCard(
                    theme: theme,
                    primaryColor: primaryColor,
                    title: 'Important Information',
                    children: [
                      _buildBulletPoint(
                        theme: theme,
                        text: 'Please arrive 15 minutes before the event start time',
                      ),
                      const Gap(12),
                      _buildBulletPoint(
                        theme: theme,
                        text: 'Valid ID is required for entry',
                      ),
                      const Gap(12),
                      _buildBulletPoint(
                        theme: theme,
                        text: 'Dress code: Smart casual',
                      ),
                      const Gap(12),
                      _buildBulletPoint(
                        theme: theme,
                        text: 'No outside food or beverages allowed',
                      ),
                    ],
                  ),
                  const Gap(100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: booking.hasQRCode
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton.icon(
                  onPressed: () => _showQRCodeModal(context, theme, primaryColor),
                  icon: const Icon(Iconsax.scan_barcode),
                  label: const Text('View Full QR Code'),
                  style: FilledButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildImagePlaceholder(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surface,
      child: Icon(
        Iconsax.image,
        size: 64,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
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
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
                style: theme.textTheme.bodyLarge?.copyWith(
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

  Color _getBookingTypeColor(String type) {
    switch (type) {
      case 'Ticket':
        return Colors.blue;
      case 'Table':
        return Colors.purple;
      case 'Guestlist':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getBookingTypeIcon(String type) {
    switch (type) {
      case 'Ticket':
        return Iconsax.ticket;
      case 'Table':
        return Iconsax.cake;
      case 'Guestlist':
        return Iconsax.people;
      default:
        return Iconsax.document_text;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showQRCodeModal(BuildContext context, ThemeData theme, Color primaryColor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Your ${booking.type} QR Code',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(8),
              Text(
                'Show this at the venue entrance',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const Gap(24),
              Container(
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
                  data: booking.qrCode!,
                  size: 250,
                  backgroundColor: Colors.white,
                  errorCorrectionLevel: QrErrorCorrectLevel.M,
                ),
              ),
              const Gap(24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => context.pop(),
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
