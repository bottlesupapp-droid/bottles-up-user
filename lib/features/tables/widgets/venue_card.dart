import 'package:flutter/material.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/review.dart';
import '../../../site/models/venue.dart';
import '../../social/widgets/reviews_widgets.dart';
import '../../../site/money.dart';

/// One venue in the Tables list: the picture, where it is, and how many tables there are and from what price.
class VenueCard extends StatelessWidget {
  const VenueCard({super.key, required this.venue, required this.onTap, this.rating});

  final Venue venue;
  final VoidCallback onTap;

  /// The average and count of reviews, when the venue has any (and reviews are on).
  final VenueRating? rating;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final from = venue.fromCents;
    final tables = venue.tables.length;
    return Card(
      key: Key('venue-${venue.id}'),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                NetworkPicture(url: venue.picture, height: 170, width: double.infinity, radius: 0),
                if (venue.hasFloorPlan)
                  Positioned(
                    left: 12,
                    top: 12,
                    child: Container(
                      key: Key('venue-plan-${venue.id}'),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.65), borderRadius: BorderRadius.circular(20)),
                      child: const Text('Floor plan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(child: Text(venue.name, key: Key('venue-name-${venue.id}'), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700))),
                    if (rating != null) RatingBadge(rating: rating!),
                  ]),
                  if (venue.address != null) Padding(padding: const EdgeInsets.only(top: 2), child: Text(venue.address!, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant))),
                  const SizedBox(height: 10),
                  Text(
                    !venue.isBookable
                        ? 'Booking times coming soon'
                        : '${tables == 1 ? '1 table' : '$tables tables'}${from == null ? '' : ' · From ${formatMoney(from)}'}',
                    key: Key('venue-summary-${venue.id}'),
                    style: theme.textTheme.titleSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
