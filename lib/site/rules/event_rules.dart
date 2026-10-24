import '../models/site_event.dart';
import '../money.dart';

/// The categories the events have, once each, in the order they first appear.
List<String> categoriesOf(List<SiteEvent> events) {
  final seen = <String>[];
  for (final e in events) {
    final c = e.category;
    if (c != null && !seen.contains(c)) seen.add(c);
  }
  return seen;
}

/// The events that match what the person typed (in the title, venue, address, category or an act's name) and the category they chose.
List<SiteEvent> filterEvents(List<SiteEvent> events, {String query = '', String? category}) {
  final q = query.trim().toLowerCase();
  return [
    for (final e in events)
      if ((category == null || e.category == category) &&
          (q.isEmpty ||
              e.title.toLowerCase().contains(q) ||
              e.venueName.toLowerCase().contains(q) ||
              (e.address ?? '').toLowerCase().contains(q) ||
              (e.category ?? '').toLowerCase().contains(q) ||
              e.lineup.any((a) => a.toLowerCase().contains(q))))
        e,
  ];
}

/// What to say about tickets on an event card: "Sold out", "From $50.00", "Free", or "Tickets coming soon" when none are on sale yet.
String priceLabelFor(SiteEvent e) {
  if (e.tiers.isEmpty) return 'Tickets coming soon';
  if (e.soldOut) return 'Sold out';
  final from = e.fromPriceCents;
  if (from == null) return 'Sold out';
  if (from == 0) return 'Free';
  return 'From ${formatMoney(from, currency: e.tiers.first.currency)}';
}
