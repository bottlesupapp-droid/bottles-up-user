import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:bottles_up_user/features/bookings/screens/booking_detail_screen.dart';

class MyBookingsScreen extends ConsumerStatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  ConsumerState<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class MyBookingsScreenInternal extends ConsumerStatefulWidget {
  final ScrollController scrollController;

  const MyBookingsScreenInternal({
    super.key,
    required this.scrollController,
  });

  @override
  ConsumerState<MyBookingsScreenInternal> createState() =>
      _MyBookingsScreenInternalState();
}

class _MyBookingsScreenState extends ConsumerState<MyBookingsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return MyBookingsScreenInternal(scrollController: _scrollController);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class _MyBookingsScreenInternalState
    extends ConsumerState<MyBookingsScreenInternal> {
  int _selectedTab = 0;

  final List<String> _tabs = ['Upcoming', 'Past'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    // TODO: Replace with actual provider
    final bookings = _getMockBookings();
    final upcomingBookings = bookings.where((b) => b.isUpcoming).toList();
    final pastBookings = bookings.where((b) => !b.isUpcoming).toList();

    final displayBookings = _selectedTab == 0 ? upcomingBookings : pastBookings;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        controller: widget.scrollController,
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            snap: true,
            elevation: 0,
            backgroundColor: theme.scaffoldBackgroundColor,
            title: Text(
              'My Events',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Tab Selector
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: _tabs.asMap().entries.map((entry) {
                    final index = entry.key;
                    final tab = entry.value;
                    final isSelected = index == _selectedTab;

                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTab = index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? primaryColor : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tab,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // Bookings List
          if (displayBookings.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _selectedTab == 0 ? Iconsax.calendar_1 : Iconsax.ticket_2,
                      size: 64,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                    const Gap(16),
                    Text(
                      _selectedTab == 0 ? 'No Upcoming Events' : 'No Past Events',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const Gap(8),
                    Text(
                      _selectedTab == 0
                          ? 'Book an event to see it here'
                          : 'Your past events will appear here',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                    if (_selectedTab == 0) ...[
                      const Gap(24),
                      FilledButton.icon(
                        onPressed: () {
                          // Switch to Discover tab
                          context.go('/home');
                        },
                        icon: const Icon(Iconsax.search_normal_1),
                        label: const Text('Discover Events'),
                        style: FilledButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final booking = displayBookings[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildBookingCard(booking, theme, primaryColor),
                    );
                  },
                  childCount: displayBookings.length,
                ),
              ),
            ),

          // Bottom Padding
          const SliverToBoxAdapter(
            child: Gap(100),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(MockBooking booking, ThemeData theme, Color primaryColor) {
    return GestureDetector(
      onTap: () => _showBookingDetails(booking),
      child: Container(
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
            // Event Image & Type Badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(booking.eventImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // Type Badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
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
                ),
                // Status Badge (if not confirmed)
                if (booking.status != 'confirmed')
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(booking.status),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        booking.status.toUpperCase(),
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

            // Event Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Name
                  Text(
                    booking.eventName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(8),

                  // Venue
                  Row(
                    children: [
                      Icon(Iconsax.location, size: 16, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                      const Gap(4),
                      Expanded(
                        child: Text(
                          booking.venueName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),

                  // Date & Time
                  Row(
                    children: [
                      Icon(Iconsax.calendar_1, size: 16, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                      const Gap(4),
                      Text(
                        booking.formattedDate,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const Gap(12),
                      Icon(Iconsax.clock, size: 16, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                      const Gap(4),
                      Text(
                        booking.formattedTime,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),

                  // Booking Details
                  if (booking.details != null) ...[
                    const Gap(12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: primaryColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _getBookingTypeIcon(booking.type),
                            size: 18,
                            color: primaryColor,
                          ),
                          const Gap(8),
                          Text(
                            booking.details!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const Gap(16),

                  // Action Buttons
                  Row(
                    children: [
                      if (booking.hasQRCode)
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _showQRCode(booking),
                            icon: const Icon(Iconsax.scan_barcode, size: 18),
                            label: const Text('View QR'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: primaryColor,
                              side: BorderSide(color: primaryColor),
                            ),
                          ),
                        ),
                      if (booking.hasQRCode) const Gap(12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => _showBookingDetails(booking),
                          icon: const Icon(Iconsax.document_text_1, size: 18),
                          label: const Text('Details'),
                          style: FilledButton.styleFrom(
                            backgroundColor: primaryColor,
                          ),
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

  void _showQRCode(MockBooking booking) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

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
              // Handle Bar
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

              // QR Code
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

              // Event Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Event',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        Text(
                          booking.eventName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Gap(8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Date',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        Text(
                          booking.formattedDate,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Gap(8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Booking ID',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        Text(
                          booking.id.substring(0, 8).toUpperCase(),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ],
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

  void _showBookingDetails(MockBooking booking) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingDetailScreen(booking: booking),
      ),
    );
  }

  List<MockBooking> _getMockBookings() {
    final now = DateTime.now();
    return [
      MockBooking(
        id: '1',
        eventName: 'EDM Paradise - NYC',
        venueName: 'Marquee NYC',
        eventImage: 'https://images.unsplash.com/photo-1571266028243-d220a9937dad?w=800',
        date: now.add(const Duration(days: 7)),
        time: '22:00',
        type: 'Ticket',
        status: 'confirmed',
        details: '2 General Admission Tickets',
        hasQRCode: true,
        qrCode: 'BOOKING-1-EDM-NYC-2024',
        isUpcoming: true,
      ),
      MockBooking(
        id: '2',
        eventName: 'Hip-Hop Saturday Night',
        venueName: 'LIV Miami',
        eventImage: 'https://images.unsplash.com/photo-1566417713940-fe7c737a9ef2?w=800',
        date: now.add(const Duration(days: 3)),
        time: '21:00',
        type: 'Table',
        status: 'confirmed',
        details: 'VIP Table for 6 + 2 Bottles',
        hasQRCode: true,
        qrCode: 'BOOKING-2-HIP-HOP-MIAMI-2024',
        isUpcoming: true,
      ),
      MockBooking(
        id: '3',
        eventName: 'Afrobeats Night',
        venueName: 'The Shrine',
        eventImage: 'https://images.unsplash.com/photo-1574391884720-bbc3740c59d1?w=800',
        date: now.add(const Duration(days: 1)),
        time: '20:00',
        type: 'Guestlist',
        status: 'confirmed',
        details: 'Free Entry before 11 PM',
        hasQRCode: true,
        qrCode: 'BOOKING-3-AFROBEATS-LA-2024',
        isUpcoming: true,
      ),
    ];
  }
}

// Mock Booking Model
class MockBooking {
  final String id;
  final String eventName;
  final String venueName;
  final String eventImage;
  final DateTime date;
  final String time;
  final String type; // Ticket, Table, Guestlist
  final String status; // confirmed, pending, cancelled
  final String? details;
  final bool hasQRCode;
  final String? qrCode;
  final bool isUpcoming;

  MockBooking({
    required this.id,
    required this.eventName,
    required this.venueName,
    required this.eventImage,
    required this.date,
    required this.time,
    required this.type,
    required this.status,
    this.details,
    required this.hasQRCode,
    this.qrCode,
    required this.isUpcoming,
  });

  String get formattedDate {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String get formattedTime {
    final hour = int.parse(time.split(':')[0]);
    final minute = time.split(':')[1];
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$displayHour:$minute $period';
  }
}
