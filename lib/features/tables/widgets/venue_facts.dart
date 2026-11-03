import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../site/models/venue.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/profile_rules.dart';

IconData _iconFor(String key) => switch (key) {
      'parking' => Icons.local_parking,
      'valet' => Icons.directions_car_outlined,
      'coat_check' => Icons.checkroom_outlined,
      'wifi' => Icons.wifi,
      'accessible' => Icons.accessible,
      'outdoor' => Icons.deck_outlined,
      'vip_area' => Icons.workspace_premium_outlined,
      'food' => Icons.restaurant_outlined,
      'smoking_area' => Icons.smoking_rooms_outlined,
      'private_rooms' => Icons.meeting_room_outlined,
      'live_music' => Icons.mic_external_on_outlined,
      'dance_floor' => Icons.nightlife_outlined,
      'bottle_service' => Icons.wine_bar_outlined,
      _ => Icons.check_circle_outline,
    };

/// What the venue says about itself beyond the basics: the features it has, parking, the age rule and ID, last entry, kitchen hours and a menu. Shows only what is set, and nothing
/// at all when the venue has set none of it. Parking is the venue's own note: nothing here claims a space is free right now.
class VenueFactsSection extends ConsumerWidget {
  const VenueFactsSection({super.key, required this.venue});

  final Venue venue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final rows = <(String, IconData, String)>[
      if (venue.minAge != null) ('venue-age', Icons.badge_outlined, '${venue.minAge}+${venue.idRequired ? ' · ID required' : ''}')
      else if (venue.idRequired) ('venue-age', Icons.badge_outlined, 'ID required'),
      if (venue.lastEntry != null) ('venue-last-entry', Icons.door_front_door_outlined, 'Last entry ${venue.lastEntry}'),
      if (venue.parkingInfo != null) ('venue-parking', Icons.local_parking, venue.parkingInfo!),
      if (venue.kitchenHours != null) ('venue-kitchen', Icons.restaurant_outlined, 'Kitchen: ${venue.kitchenHours}'),
    ];
    if (venue.amenities.isEmpty && rows.isEmpty && venue.menuUrl == null) return const SizedBox.shrink();
    final menu = venue.menuUrl;
    return Padding(
      key: const Key('venue-facts'),
      padding: const EdgeInsets.only(top: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (venue.amenities.isNotEmpty)
          Wrap(spacing: 6, runSpacing: 0, children: [
            for (final a in venue.amenities) Chip(key: Key('amenity-$a'), visualDensity: VisualDensity.compact, avatar: Icon(_iconFor(a), size: 16), label: Text(venueAmenityLabels[a] ?? a)),
          ]),
        for (final (key, icon, text) in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, size: 18, color: theme.colorScheme.primary), const SizedBox(width: 10), Expanded(child: Text(text, key: Key(key)))]),
          ),
        if (menu != null)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(key: const Key('venue-menu'), onPressed: () => ref.read(urlOpenerProvider)(Uri.parse(menu)), icon: const Icon(Icons.menu_book_outlined), label: const Text('See the menu')),
          ),
      ]),
    );
  }
}
