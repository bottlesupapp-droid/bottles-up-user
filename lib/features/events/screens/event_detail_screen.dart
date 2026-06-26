import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/event.dart';
import '../providers/event_provider.dart';
import '../../payment/screens/payment_screen.dart';
import '../../../core/models/payment_models.dart';
import '../services/event_booking_service.dart';

class EventDetailScreen extends ConsumerStatefulWidget {
  final String eventId;

  const EventDetailScreen({
    super.key,
    required this.eventId,
  });

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CarouselSliderController _carouselController = CarouselSliderController();
  int _currentCarouselIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final eventAsync = ref.watch(eventByIdProvider(widget.eventId));

    return Scaffold(
      body: eventAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
                const Gap(16),
                Text(
                  'Error loading event',
                  style: theme.textTheme.titleLarge,
                ),
                const Gap(8),
                Text(
                  error.toString(),
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const Gap(24),
                FilledButton.icon(
                  onPressed: () => ref.invalidate(eventByIdProvider(widget.eventId)),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (event) => _buildEventDetail(context, theme, primaryColor, event),
      ),
    );
  }

  Widget _buildEventDetail(BuildContext context, ThemeData theme, Color primaryColor, Event event) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
        // App Bar with Image Carousel
        SliverAppBar(
          expandedHeight: 400,
          pinned: true,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                // Share functionality
              },
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Iconsax.share, color: Colors.white),
              ),
            ),
            IconButton(
              onPressed: () {
                // Favorite functionality
              },
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Iconsax.heart, color: Colors.white),
              ),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Image Carousel
                if (event.images != null && event.images!.isNotEmpty)
                  CarouselSlider(
                    carouselController: _carouselController,
                    options: CarouselOptions(
                      height: double.infinity,
                      viewportFraction: 1.0,
                      enableInfiniteScroll: event.images!.length > 1,
                      autoPlay: event.images!.length > 1,
                      autoPlayInterval: const Duration(seconds: 5),
                      onPageChanged: (index, reason) {
                        setState(() => _currentCarouselIndex = index);
                      },
                    ),
                    items: event.images!.map((imageUrl) {
                      return Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: const Center(
                              child: Icon(Icons.broken_image, size: 64),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  )
                else
                  Image.network(
                    event.primaryImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: const Center(
                          child: Icon(Icons.event, size: 64),
                        ),
                      );
                    },
                  ),

                // Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),

                // Badges - Featured & Verified
                Positioned(
                  top: 60,
                  right: 16,
                  child: Column(
                    children: [
                      if (event.isFeatured)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.verified, size: 20, color: Colors.white),
                        ),
                    ],
                  ),
                ),

                // Carousel Indicators
                if (event.images != null && event.images!.length > 1)
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: event.images!.asMap().entries.map((entry) {
                        return Container(
                          width: _currentCarouselIndex == entry.key ? 24 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: _currentCarouselIndex == entry.key
                                ? primaryColor
                                : Colors.white.withValues(alpha: 0.5),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Content
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Title & Quick Info
              Container(
                padding: const EdgeInsets.all(20),
                color: theme.scaffoldBackgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Genre Tag
                    if (event.categoryName != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          event.categoryName!,
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    const Gap(12),

                    // Event Name
                    Text(
                      event.name,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(8),

                    // Venue with Verified Badge
                    Row(
                      children: [
                        Icon(Iconsax.location, size: 18, color: primaryColor),
                        const Gap(6),
                        Expanded(
                          child: Text(
                            event.venueDisplay,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                        if (event.isFeatured)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blue, width: 1),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.verified, size: 14, color: Colors.blue),
                                const Gap(4),
                                Text(
                                  'Verified',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const Gap(16),

                    // Quick Info Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickInfoCard(
                            theme,
                            primaryColor,
                            Iconsax.calendar_1,
                            'Date',
                            event.formattedDate,
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: _buildQuickInfoCard(
                            theme,
                            primaryColor,
                            Iconsax.clock,
                            'Time',
                            event.formattedTime,
                          ),
                        ),
                      ],
                    ),
                    const Gap(12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickInfoCard(
                            theme,
                            primaryColor,
                            Iconsax.ticket,
                            'From',
                            event.formattedPrice,
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: _buildQuickInfoCard(
                            theme,
                            primaryColor,
                            Iconsax.people,
                            'Spots Left',
                            '${event.maxCapacity - (event.currentBookings ?? 0)}',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Tabs
              Container(
                color: theme.scaffoldBackgroundColor,
                child: TabBar(
                  controller: _tabController,
                  labelColor: primaryColor,
                  unselectedLabelColor: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  indicatorColor: primaryColor,
                  tabs: const [
                    Tab(text: 'Details'),
                    Tab(text: 'Lineup'),
                    Tab(text: 'Packages'),
                  ],
                ),
              ),

              // Tab Content
              SizedBox(
                height: 600,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildDetailsTab(theme, primaryColor, event),
                    _buildLineupTab(theme, primaryColor, event),
                    _buildPackagesTab(theme, primaryColor, event),
                  ],
                ),
              ),

              const Gap(100), // Space for bottom buttons
            ],
          ),
        ),
      ],
      ),
      bottomNavigationBar: _buildBottomButtons(context, theme, primaryColor, event),
    );
  }

  Widget _buildQuickInfoCard(ThemeData theme, Color primaryColor, IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: primaryColor),
              const Gap(6),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          const Gap(4),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsTab(ThemeData theme, Color primaryColor, Event event) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          Text(
            'About This Event',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(12),
          Text(
            event.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.6,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
          const Gap(24),

          // Event Highlights
          Text(
            'Event Highlights',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(12),
          _buildHighlightItem(theme, Iconsax.music, 'Live DJ Performance'),
          _buildHighlightItem(theme, Iconsax.cup, 'Premium Bottle Service'),
          _buildHighlightItem(theme, Iconsax.ticket_2, 'Exclusive VIP Access'),
          _buildHighlightItem(theme, Iconsax.security_safe, 'Safe & Secure Venue'),
          const Gap(24),

          // Dress Code
          if (event.dressCode != null) ...[
            Text(
              'Dress Code',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(Iconsax.tag, color: primaryColor),
                  const Gap(12),
                  Expanded(
                    child: Text(
                      event.dressCode!,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(24),
          ],

          // Age Restriction
          Text(
            'Age Restriction',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(Iconsax.user, color: primaryColor),
                const Gap(12),
                Text(
                  '21+ Only',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineupTab(ThemeData theme, Color primaryColor, Event event) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.music_dashboard, size: 64, color: theme.colorScheme.onSurface.withValues(alpha: 0.2)),
            const Gap(16),
            Text(
              'Lineup Coming Soon',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Gap(8),
            Text(
              'The artist lineup for this event has not been announced yet.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackagesTab(ThemeData theme, Color primaryColor, Event event) {
    final options = <Map<String, dynamic>>[
      if (event.ticketPrice > 0)
        {'label': 'General Admission', 'price': event.ticketPrice, 'type': 'ticket'},
      {'label': 'Table Booking', 'price': null, 'type': 'table'},
      {'label': 'Guestlist RSVP', 'price': 0.0, 'type': 'guestlist'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Booking Options', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const Gap(8),
          Text(
            'Choose how you want to experience this event',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
          ),
          const Gap(20),
          ...options.map((opt) => _buildPackageCard(theme, primaryColor, opt)),
        ],
      ),
    );
  }

  Widget _buildPackageCard(ThemeData theme, Color primaryColor, Map<String, dynamic> package) {
    final price = package['price'] as double?;
    final type = package['type'] as String;
    final priceLabel = price == null ? 'Deposit req.' : (price == 0.0 ? 'FREE' : '\$${price.toStringAsFixed(0)}');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(package['label'], style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(priceLabel, style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: theme.colorScheme.outline.withValues(alpha: 0.2)),
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => _handleBooking(type),
                style: FilledButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  type == 'guestlist' ? 'RSVP Now' : 'Book Now',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightItem(ThemeData theme, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const Gap(12),
          Text(
            text,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context, ThemeData theme, Color primaryColor, Event event) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  // Navigate to guestlist RSVP
                  _handleBooking('guestlist');
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'RSVP',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const Gap(12),
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: () {
                  // Navigate to ticket booking
                  _handleBooking('ticket');
                },
                style: FilledButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Buy Tickets - ${event.formattedPrice}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleBooking(String type) async {
    final eventAsync = ref.read(eventByIdProvider(widget.eventId));
    final event = eventAsync.valueOrNull;

    if (event == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Event information not available'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final supabase = Supabase.instance.client;

    // Navigate to in-app payment screen (not browser checkout)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          amount: event.ticketPrice,
          currency: 'USD',
          description: 'Event Ticket - ${event.name}',
          paymentType: PaymentType.eventTicket,
          metadata: {
            'event_id': event.id,
            'event_name': event.name,
            'event_date': event.eventDate.toIso8601String(),
            'event_time': '${event.startTime} - ${event.endTime}',
            'club_name': event.clubName ?? 'Unknown',
            'ticket_quantity': 1,
          },
          onPaymentSuccess: () async {
            // Create event booking after successful payment
            try {
              final user = supabase.auth.currentUser;
              if (user == null) {
                throw Exception('User not authenticated');
              }

              // Generate confirmation code
              final confirmationCode = 'BU${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

              debugPrint('📝 [TICKET-1] Creating event ticket booking');
              debugPrint('📝 [TICKET-2] User: ${user.id}, Event: ${event.id}');

              // Create booking record with QR code
              final bookingData = {
                'user_id': user.id,
                'event_id': event.id,
                'ticket_quantity': 1,
                'ticket_price': event.ticketPrice,
                'total_amount': event.ticketPrice,
                'status': 'confirmed',
                'confirmation_code': confirmationCode,
                'payment_status': 'paid',
                'qr_code': confirmationCode,
              };

              debugPrint('📝 [TICKET-DEBUG] Inserting: $bookingData');

              final response = await supabase
                  .from('events_bookings')
                  .insert(bookingData)
                  .select('id, confirmation_code')
                  .single();

              debugPrint('✅ [TICKET-3] Booking created: ${response['id']}');
              debugPrint('🎫 [TICKET-4] Confirmation: $confirmationCode');

              // Show success message
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('🎫 Ticket purchased! Check "My Bookings" tab'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 4),
                  ),
                );
              }
            } catch (e, stackTrace) {
              debugPrint('❌ [TICKET-ERROR] Failed to create booking: $e');
              debugPrint('❌ [TICKET-STACK] $stackTrace');
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Payment succeeded but booking failed.\nPlease contact support.'),
                    backgroundColor: Colors.orange,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 5),
                  ),
                );
              }
            }
          },
          onPaymentFailed: () {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payment failed. Please try again.'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          clubName: event.clubName ?? 'Event Venue',
          date: event.formattedDate,
          timeSlot: '${event.startTime} - ${event.endTime}',
        ),
      ),
    );
  }
}
