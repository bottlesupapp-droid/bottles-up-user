import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../../home/models/club.dart';
import '../models/club_table.dart';
import '../models/club_hours.dart';
import '../models/bottle.dart';
import '../providers/club_detail_providers.dart';
import '../../payment/screens/payment_screen.dart';
import '../../../core/models/payment_models.dart';

class ClubDetailScreen extends ConsumerStatefulWidget {
  final Club club;

  const ClubDetailScreen({
    super.key,
    required this.club,
  });

  @override
  ConsumerState<ClubDetailScreen> createState() => _ClubDetailScreenState();
}

class _ClubDetailScreenState extends ConsumerState<ClubDetailScreen> {
  // Booking selection state
  DateTime selectedDate = DateTime.now();
  String? selectedTimeSlot;
  int guestCount = 4;
  String? selectedTableId;
  List<String> selectedBottleIds = [];

  // UI state
  bool _showAvailableTables = false;

  // Date selection helpers
  List<DateTime> get _availableDates {
    final List<DateTime> dates = [];
    for (int i = 0; i < 7; i++) {
      dates.add(DateTime.now().add(Duration(days: i)));
    }
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          // Main content
          CustomScrollView(
            slivers: [
              // Hero section with image
              _buildHeroSection(theme, primaryColor),

              // Club location and rating
              _buildClubInfo(theme, primaryColor),

              // Action buttons
              _buildActionButtons(theme, primaryColor),

              // Club description and details
              _buildClubDetails(theme, primaryColor),

              // Date and Guest Count Selection
              _buildDateGuestSelection(theme, primaryColor),

              // Time Slot Selection
              _buildTimeSlotSelection(theme, primaryColor),

              // Available Tables (only shown after time selection)
              if (_showAvailableTables) _buildAvailableTablesSection(theme, primaryColor),

              // Bottle Packages
              if (_showAvailableTables) _buildBottlePackagesSection(theme, primaryColor),

              // Bottom padding for fixed footer
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),

          // Bottom booking footer
          if (_showAvailableTables) _buildBottomBookingFooter(theme, primaryColor),
        ],
      ),
    );
  }

  Widget _buildHeroSection(ThemeData theme, Color primaryColor) {
    return SliverAppBar(
      expandedHeight: 224,
      pinned: true,
      backgroundColor: Colors.transparent,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Club Details',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Hero image
            Image.network(
              widget.club.imageUrl,
              fit: BoxFit.cover,
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClubInfo(ThemeData theme, Color primaryColor) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.club.name,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const Gap(8),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  widget.club.location,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                Text(
                  ' · ',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: Colors.yellow.shade600,
                    ),
                    const Gap(4),
                    Text(
                      widget.club.rating.toStringAsFixed(1),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                Text(
                  ' · ',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified,
                        size: 12,
                        color: Colors.blue.shade600,
                      ),
                      const Gap(4),
                      Text(
                        'Verified',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.blue.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme, Color primaryColor) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: _buildActionButton(
                theme,
                Icons.phone,
                'Call',
                _makePhoneCall,
              ),
            ),
            const Gap(12),
            Expanded(
              child: _buildActionButton(
                theme,
                Icons.directions,
                'Directions',
                _openDirections,
              ),
            ),
            const Gap(12),
            Expanded(
              child: _buildActionButton(
                theme,
                Icons.share,
                'Share',
                _shareClub,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      ThemeData theme, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.onSurface.withOpacity(0.1),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: theme.colorScheme.onSurface,
              size: 20,
            ),
            const Gap(4),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClubDetails(ThemeData theme, Color primaryColor) {
    final amenitiesAsync = ref.watch(clubAmenitiesProvider(widget.club.id));
    final hoursAsync = ref.watch(clubHoursDataProvider(widget.club.id));

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Club Info',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(16),
            Text(
              widget.club.description ?? 'No description available.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const Gap(16),
            // Dynamic amenities
            amenitiesAsync.when(
              data: (amenities) {
                if (amenities.isEmpty) {
                  return const SizedBox();
                }
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: amenities.map((amenity) =>
                    _buildTag(theme, primaryColor, amenity.name)).toList(),
                );
              },
              loading: () => const SizedBox(
                height: 32,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stack) => const SizedBox(),
            ),
            const Gap(24),
            // Club details with dynamic hours
            hoursAsync.when(
              data: (hours) => Column(
                children: [
                  _buildDetailRow(theme, 'Opening Hours', _formatOpeningHours(hours)),
                  const Gap(16),
                  _buildDetailRow(theme, 'Age Requirement', widget.club.ageRequirement ?? '21+ only'),
                  const Gap(16),
                  _buildDetailRow(theme, 'Dress Code', widget.club.dressCode ?? 'Smart casual required'),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Column(
                children: [
                  _buildDetailRow(theme, 'Opening Hours', 'Hours not available'),
                  const Gap(16),
                  _buildDetailRow(theme, 'Age Requirement', widget.club.ageRequirement ?? '21+ only'),
                  const Gap(16),
                  _buildDetailRow(theme, 'Dress Code', widget.club.dressCode ?? 'Smart casual required'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(ThemeData theme, Color primaryColor, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          color: primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDetailRow(ThemeData theme, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateGuestSelection(ThemeData theme, Color primaryColor) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Date & Guests',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(16),

            // Guest Count Selection
            Row(
              children: [
                Text(
                  'Guests: ',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  onPressed: guestCount > 1 ? () {
                    setState(() {
                      guestCount--;
                      selectedTimeSlot = null;
                      _showAvailableTables = false;
                    });
                  } : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text(
                  guestCount.toString(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      guestCount++;
                      selectedTimeSlot = null;
                      _showAvailableTables = false;
                    });
                  },
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),

            const Gap(16),

            // Date Selection
            Text(
              'Date',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const Gap(8),
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _availableDates.length,
                itemBuilder: (context, index) {
                  final date = _availableDates[index];
                  final isSelected = _isSameDay(date, selectedDate);
                  final isToday = _isSameDay(date, DateTime.now());

                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDate = date;
                          selectedTimeSlot = null;
                          _showAvailableTables = false;
                        });
                      },
                      child: Container(
                        width: 104,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? primaryColor
                              : theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: isSelected
                                ? primaryColor
                                : theme.colorScheme.onSurface.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isToday ? 'Today' : _getWeekdayName(date),
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected
                                    ? Colors.white
                                    : theme.colorScheme.onSurface.withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Gap(4),
                            Text(
                              '${date.day} ${_getMonthName(date)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: isSelected
                                    ? Colors.white
                                    : theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotSelection(ThemeData theme, Color primaryColor) {
    final timeSlotsAsync = ref.watch(availableTimeSlotsProvider(
      clubId: widget.club.id,
      date: selectedDate,
      guestCount: guestCount,
    ));

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Time Slots',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(16),
            timeSlotsAsync.when(
              data: (timeSlots) {
                if (timeSlots.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.onSurface.withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.schedule_outlined,
                          size: 48,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                        const Gap(12),
                        Text(
                          'No available time slots',
                          style: TextStyle(
                            fontSize: 16,
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          'Try selecting a different date or reducing guest count',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: timeSlots.map((timeSlot) {
                    final isSelected = timeSlot == selectedTimeSlot;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTimeSlot = timeSlot;
                          _showAvailableTables = true;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? primaryColor
                              : theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? primaryColor
                                : theme.colorScheme.onSurface.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          timeSlot,
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected
                                ? Colors.white
                                : theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stack) => Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Error loading time slots: $error',
                  style: TextStyle(
                    color: theme.colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableTablesSection(ThemeData theme, Color primaryColor) {
    if (selectedTimeSlot == null) return const SliverToBoxAdapter(child: SizedBox());

    final availableTablesAsync = ref.watch(availableClubTablesProvider(
      clubId: widget.club.id,
      date: selectedDate,
      timeSlot: selectedTimeSlot!,
      guestCount: guestCount,
    ));

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Tables',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(16),
            availableTablesAsync.when(
              data: (tables) {
                if (tables.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.onSurface.withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.table_restaurant_outlined,
                          size: 48,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                        const Gap(12),
                        Text(
                          'No available tables',
                          style: TextStyle(
                            fontSize: 16,
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          'Try selecting a different time slot or reducing guest count',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: tables.map((table) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildTableCard(theme, primaryColor, table),
                  )).toList(),
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stack) => Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Error loading tables: $error',
                  style: TextStyle(
                    color: theme.colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableCard(ThemeData theme, Color primaryColor, ClubTable table) {
    final isSelected = selectedTableId == table.id;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTableId = isSelected ? null : table.id;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? primaryColor
                : theme.colorScheme.onSurface.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Table image
            Container(
              width: 120,
              height: 100,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: table.imageUrl != null && table.imageUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                      child: Image.network(
                        table.imageUrl!,
                        width: 120,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            table.isVip ? Icons.star : Icons.table_restaurant,
                            color: primaryColor,
                            size: 32,
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: primaryColor,
                            ),
                          );
                        },
                      ),
                    )
                  : Icon(
                      table.isVip ? Icons.star : Icons.table_restaurant,
                      color: primaryColor,
                      size: 32,
                    ),
            ),

            // Table details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          table.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (table.isVip) ...[
                          const Gap(8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'VIP',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const Gap(4),
                    Text(
                      'Capacity: ${table.capacity} guests',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    if (table.minimumSpend != null) ...[
                      const Gap(4),
                      Text(
                        'Min. Spend: \$${table.minimumSpend!.toStringAsFixed(0)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                    const Gap(12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? primaryColor
                            : primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isSelected ? 'Selected' : 'Select Table',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isSelected ? Colors.white : primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottlePackagesSection(ThemeData theme, Color primaryColor) {
    final bottlesAsync = ref.watch(featuredClubBottlesProvider(widget.club.id));

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Bottle Packages',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Gap(16),
          bottlesAsync.when(
            data: (bottles) {
              if (bottles.isEmpty) {
                return const SizedBox();
              }

              return SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: bottles.length,
                  itemBuilder: (context, index) {
                    final bottle = bottles[index];
                    final isSelected = selectedBottleIds.contains(bottle.id);

                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedBottleIds.remove(bottle.id);
                            } else {
                              selectedBottleIds.add(bottle.id);
                            }
                          });
                        },
                        child: Container(
                          width: 160,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? primaryColor
                                  : theme.colorScheme.onSurface.withOpacity(0.1),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Bottle image placeholder
                              Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.1),
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.local_bar,
                                    color: primaryColor,
                                    size: 32,
                                  ),
                                ),
                              ),

                              // Bottle details
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      bottle.name,
                                      style: theme.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Gap(4),
                                    Text(
                                      bottle.formattedPrice,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => const SizedBox(
              height: 220,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => Container(
              height: 100,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Error loading bottles: $error',
                  style: TextStyle(
                    color: theme.colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBookingFooter(ThemeData theme, Color primaryColor) {
    final hasSelections = selectedTableId != null;
    final bottleCount = selectedBottleIds.length;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.9),
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.onSurface.withOpacity(0.1),
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Selection summary
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasSelections ? 'Table Selected' : 'Select a table',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        bottleCount > 0
                            ? '$bottleCount Bottle${bottleCount > 1 ? 's' : ''} added'
                            : 'No bottles selected',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(12),
                // Continue button
                ElevatedButton(
                  onPressed: hasSelections
                      ? () {
                          final selectedTable = _getSelectedTable();
                          if (selectedTable == null) return;

                          final selectedBottles = _getSelectedBottles();
                          final bookingAmount = _calculateBookingAmount();

                          // Generate a booking ID (in real app, this would come from the backend)
                          final bookingId = 'BK_${DateTime.now().millisecondsSinceEpoch}';

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentScreen(
                                amount: bookingAmount,
                                currency: 'USD',
                                description: 'Table Booking at ${widget.club.name}',
                                paymentType: PaymentType.tableBooking,
                                bookingId: bookingId,
                                metadata: {
                                  'club_id': widget.club.id,
                                  'table_id': selectedTable.id,
                                  'date': selectedDate.toIso8601String().split('T')[0],
                                  'time_slot': selectedTimeSlot,
                                  'guest_count': guestCount.toString(),
                                  'selected_bottles': selectedBottleIds.join(','),
                                },
                                // Booking details for display
                                clubName: widget.club.name,
                                date: selectedDate.toIso8601String().split('T')[0],
                                timeSlot: selectedTimeSlot,
                                tableName: selectedTable.name,
                                guestCount: guestCount,
                                // Pass actual table and bottles data
                                selectedTable: selectedTable,
                                selectedBottles: selectedBottles,
                                onPaymentSuccess: () {
                                  // Navigate back to home or show success
                                  Navigator.of(context).popUntil((route) => route.isFirst);
                                },
                                onPaymentFailed: () {
                                  // Show error message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Payment failed. Please try again.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to get selected table details
  ClubTable? _getSelectedTable() {
    if (selectedTableId == null) return null;

    final availableTablesAsync = ref.read(availableClubTablesProvider(
      clubId: widget.club.id,
      date: selectedDate,
      timeSlot: selectedTimeSlot!,
      guestCount: guestCount,
    ));

    return availableTablesAsync.when(
      data: (tables) => tables.where((table) => table.id == selectedTableId).firstOrNull,
      loading: () => null,
      error: (error, stack) => null,
    );
  }

  // Helper method to get selected bottles
  List<Bottle> _getSelectedBottles() {
    if (selectedBottleIds.isEmpty) return [];

    final bottlesAsync = ref.read(featuredClubBottlesProvider(widget.club.id));

    return bottlesAsync.when(
      data: (bottles) => bottles.where((bottle) => selectedBottleIds.contains(bottle.id)).toList(),
      loading: () => [],
      error: (error, stack) => [],
    );
  }

  // Helper method to calculate booking amount
  double _calculateBookingAmount() {
    final selectedTable = _getSelectedTable();
    if (selectedTable == null) return 0.0;

    // Base table price
    double amount = selectedTable.price;

    // Add minimum spend if applicable
    if (selectedTable.minimumSpend != null) {
      amount = selectedTable.minimumSpend!;
    }

    return amount;
  }

  // Action button handlers
  Future<void> _makePhoneCall() async {
    if (widget.club.contactNumber != null && widget.club.contactNumber!.isNotEmpty) {
      final Uri phoneUri = Uri(scheme: 'tel', path: widget.club.contactNumber);
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not make phone call')),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Phone number not available')),
        );
      }
    }
  }

  Future<void> _openDirections() async {
    if (widget.club.latitude != null && widget.club.longitude != null) {
      final String googleMapsUrl = 'https://www.google.com/maps/dir/?api=1&destination=${widget.club.latitude},${widget.club.longitude}';
      final String appleMapsUrl = 'http://maps.apple.com/?daddr=${widget.club.latitude},${widget.club.longitude}';

      // Try Google Maps first, then Apple Maps
      final Uri googleUri = Uri.parse(googleMapsUrl);
      final Uri appleUri = Uri.parse(appleMapsUrl);

      if (await canLaunchUrl(googleUri)) {
        await launchUrl(googleUri, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(appleUri)) {
        await launchUrl(appleUri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open maps')),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location not available')),
        );
      }
    }
  }

  Future<void> _shareClub() async {
    try {
      final String shareText = '''Check out ${widget.club.name}!

Location: ${widget.club.location}
Rating: ${widget.club.rating.toStringAsFixed(1)} ⭐
Price Range: ${widget.club.priceRange}

${widget.club.description ?? ''}

Shared via Bottles Up''';

      await Share.share(shareText, subject: 'Check out ${widget.club.name}');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not share club details')),
        );
      }
    }
  }

  // Helper method to format opening hours
  String _formatOpeningHours(List<ClubHours> hours) {
    if (hours.isEmpty) return 'Hours not available';

    // Group consecutive days with same hours
    final Map<String, List<int>> hoursGroups = {};

    for (final hour in hours) {
      final timeStr = hour.formattedHours;
      if (!hoursGroups.containsKey(timeStr)) {
        hoursGroups[timeStr] = [];
      }
      hoursGroups[timeStr]!.add(hour.dayOfWeek);
    }

    final List<String> formattedHours = [];

    for (final entry in hoursGroups.entries) {
      final timeStr = entry.key;
      final days = entry.value..sort();

      if (days.isEmpty) continue;

      // Group consecutive days
      final List<String> dayGroups = [];
      int start = days[0];
      int end = days[0];

      for (int i = 1; i < days.length; i++) {
        if (days[i] == end + 1) {
          end = days[i];
        } else {
          // Add current group
          if (start == end) {
            dayGroups.add(_getDayName(start));
          } else if (end == start + 1) {
            dayGroups.add('${_getDayName(start)}, ${_getDayName(end)}');
          } else {
            dayGroups.add('${_getDayName(start)} - ${_getDayName(end)}');
          }
          start = days[i];
          end = days[i];
        }
      }

      // Add final group
      if (start == end) {
        dayGroups.add(_getDayName(start));
      } else if (end == start + 1) {
        dayGroups.add('${_getDayName(start)}, ${_getDayName(end)}');
      } else {
        dayGroups.add('${_getDayName(start)} - ${_getDayName(end)}');
      }

      formattedHours.add('${dayGroups.join(', ')}: $timeStr');
    }

    return formattedHours.join('\n');
  }

  String _getDayName(int dayOfWeek) {
    switch (dayOfWeek) {
      case 0: return 'Sun';
      case 1: return 'Mon';
      case 2: return 'Tue';
      case 3: return 'Wed';
      case 4: return 'Thu';
      case 5: return 'Fri';
      case 6: return 'Sat';
      default: return 'Unknown';
    }
  }

  // Helper methods
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  String _getWeekdayName(DateTime date) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[date.weekday - 1];
  }

  String _getMonthName(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[date.month - 1];
  }
}