import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../models/event.dart';
import '../providers/event_provider.dart';

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
    // Mock DJ lineup data - in production, this should come from the database
    final djLineup = [
      {'name': 'DJ Snake', 'genre': 'EDM', 'time': '10:00 PM - 12:00 AM', 'isHeadliner': true},
      {'name': 'Diplo', 'genre': 'Hip-Hop/Electronic', 'time': '12:00 AM - 2:00 AM', 'isHeadliner': true},
      {'name': 'Local Artists', 'genre': 'House', 'time': '8:00 PM - 10:00 PM', 'isHeadliner': false},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DJ Lineup',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(8),
          Text(
            'Experience the best DJs in the city',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const Gap(20),

          ...djLineup.map((dj) => _buildDJCard(theme, primaryColor, dj)),
        ],
      ),
    );
  }

  Widget _buildDJCard(ThemeData theme, Color primaryColor, Map<String, dynamic> dj) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: dj['isHeadliner']
              ? primaryColor.withValues(alpha: 0.5)
              : theme.colorScheme.outline.withValues(alpha: 0.2),
          width: dj['isHeadliner'] ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Iconsax.music_dashboard, color: primaryColor, size: 30),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        dj['name'],
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (dj['isHeadliner'])
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'HEADLINER',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                const Gap(4),
                Text(
                  dj['genre'],
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const Gap(8),
                Row(
                  children: [
                    Icon(Iconsax.clock, size: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                    const Gap(4),
                    Text(
                      dj['time'],
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackagesTab(ThemeData theme, Color primaryColor, Event event) {
    // Mock packages - in production, this should come from the database
    final packages = [
      {
        'name': 'General Admission',
        'price': event.ticketPrice,
        'features': ['Entry to the event', 'Access to main floor', 'Standard drinks'],
        'type': 'ticket',
      },
      {
        'name': 'VIP Table Package',
        'price': event.ticketPrice * 5,
        'features': ['Reserved table for 4-6 people', '1 Premium bottle', 'VIP entrance', 'Dedicated server'],
        'type': 'table',
      },
      {
        'name': 'Guestlist RSVP',
        'price': 0.0,
        'features': ['Free entry before 11 PM', 'Access to main floor', 'RSVP required'],
        'type': 'guestlist',
        'condition': 'Free before 11 PM',
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Options',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(8),
          Text(
            'Choose the perfect package for your night',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const Gap(20),

          ...packages.map((package) => _buildPackageCard(theme, primaryColor, package)),
        ],
      ),
    );
  }

  Widget _buildPackageCard(ThemeData theme, Color primaryColor, Map<String, dynamic> package) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        package['name'],
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        package['price'] == 0.0 ? 'FREE' : '\$${package['price'].toStringAsFixed(0)}',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                if (package['condition'] != null) ...[
                  const Gap(8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green, width: 1),
                    ),
                    child: Text(
                      package['condition'],
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const Gap(16),
                ...((package['features'] as List).map((feature) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(Iconsax.tick_circle, size: 18, color: primaryColor),
                        const Gap(8),
                        Expanded(
                          child: Text(
                            feature,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  );
                })),
              ],
            ),
          ),
          Divider(height: 1, color: theme.colorScheme.outline.withValues(alpha: 0.2)),
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  // Navigate to booking screen based on type
                  _handleBooking(package['type']);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  package['type'] == 'guestlist' ? 'RSVP Now' : 'Book Now',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
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

  void _handleBooking(String type) {
    // TODO: Navigate to appropriate booking screen based on type
    // For now, show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening $type booking...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
