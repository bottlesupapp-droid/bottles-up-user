import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../models/event.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final bool isFeatured;
  final VoidCallback? onTap;

  const EventCard({
    super.key,
    required this.event,
    this.isFeatured = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    if (isFeatured) {
      return _buildFeaturedCard(theme, primaryColor);
    }
    return _buildStandardCard(theme, primaryColor);
  }

  Widget _buildFeaturedCard(ThemeData theme, Color primaryColor) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Background Image
              Container(
                height: 320,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(event.primaryImageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Gradient Overlay
              Container(
                height: 320,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.9),
                    ],
                    stops: const [0.3, 1.0],
                  ),
                ),
              ),

              // Featured Badge
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Iconsax.star_1, size: 14, color: Colors.white),
                      const Gap(4),
                      Text(
                        'FEATURED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Genre Tag
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: primaryColor, width: 1),
                        ),
                        child: Text(
                          event.categoryName ?? 'Event',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Gap(8),

                      // Event Name
                      Text(
                        event.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Gap(8),

                      // Venue & Location
                      Row(
                        children: [
                          Icon(Iconsax.location, size: 16, color: Colors.white70),
                          const Gap(4),
                          Expanded(
                            child: Text(
                              '${event.clubName} • ${event.clubLocation}',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
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
                          Icon(Iconsax.calendar_1, size: 16, color: Colors.white70),
                          const Gap(4),
                          Text(
                            '${event.formattedDate} • ${event.formattedTime}',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const Gap(12),

                      // Price & Availability
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'From ',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                event.formattedPrice,
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: event.isAvailable
                                  ? Colors.green.withValues(alpha: 0.2)
                                  : Colors.red.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: event.isAvailable ? Colors.green : Colors.red,
                              ),
                            ),
                            child: Text(
                              event.isAvailable
                                  ? '${event.maxCapacity - event.currentBookings!} spots left'
                                  : 'Sold Out',
                              style: TextStyle(
                                color: event.isAvailable ? Colors.green : Colors.red,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStandardCard(ThemeData theme, Color primaryColor) {
    return GestureDetector(
      onTap: onTap,
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
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(event.primaryImageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Genre Tag
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        event.categoryName ?? 'Event',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  // Verified Badge (if featured)
                  if (event.isFeatured)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Name
                  Text(
                    event.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(8),

                  // Venue & Location
                  Row(
                    children: [
                      Icon(Iconsax.location, size: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                      const Gap(4),
                      Expanded(
                        child: Text(
                          '${event.clubName}',
                          style: theme.textTheme.bodySmall?.copyWith(
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
                      Icon(Iconsax.calendar_1, size: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                      const Gap(4),
                      Text(
                        event.formattedDate,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const Gap(8),
                      Icon(Iconsax.clock, size: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                      const Gap(4),
                      Text(
                        event.formattedTime.split(' - ')[0],
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                  const Gap(12),

                  // Price & Book Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Starting from',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          Text(
                            event.formattedPrice,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      FilledButton(
                        onPressed: event.isAvailable ? onTap : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          event.isAvailable ? 'Book Now' : 'Sold Out',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),

                  // Dress Code
                  if (event.dressCode != null) ...[
                    const Gap(12),
                    Row(
                      children: [
                        Icon(Iconsax.tag, size: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                        const Gap(4),
                        Text(
                          'Dress Code: ${event.dressCode}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
