import 'package:flutter/material.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/site_event.dart';
import '../../../site/rules/event_rules.dart';
import '../../../site/when.dart';

/// One event in the list: the picture, when and where, and what tickets cost.
class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event, required this.onTap, DateTime? now}) : _now = now;

  final SiteEvent event;
  final VoidCallback onTap;
  final DateTime? _now;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final live = event.isLive(_now ?? DateTime.now());
    return Card(
      key: Key('event-${event.id}'),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                NetworkPicture(url: event.picture, height: 170, width: double.infinity, radius: 0),
                if (live)
                  Positioned(
                    left: 12,
                    top: 12,
                    child: Container(
                      key: const Key('event-live'),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: theme.colorScheme.primary, borderRadius: BorderRadius.circular(20)),
                      child: const Text('Happening now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title, key: Key('event-title-${event.id}'), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text(formatWhen(event.start), key: Key('event-when-${event.id}'), style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.primary)),
                  if (event.venueName.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 2), child: Text(event.venueName, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant))),
                  const SizedBox(height: 10),
                  Text(priceLabelFor(event), key: Key('event-price-${event.id}'), style: theme.textTheme.titleSmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
