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

/// Which events to show by when they happen.
enum DateFilter { any, tonight, weekend }

/// The night an instant belongs to: before 06:00 it is still the night before (the website's rule for a night out), as a calendar day.
DateTime nightOfInstant(DateTime t) {
  final shifted = t.subtract(const Duration(hours: 6));
  return DateTime(shifted.year, shifted.month, shifted.day);
}

/// Tonight: the event is on now, or starts in tonight's night.
bool happensTonight(SiteEvent e, DateTime now) => e.isLive(now) || nightOfInstant(e.start) == nightOfInstant(now);

/// This weekend: the event's night is a Friday, Saturday or Sunday night of the weekend that is on now or coming (Monday to Thursday looks ahead to the next Friday).
bool happensThisWeekend(SiteEvent e, DateTime now) {
  final tonight = nightOfInstant(now);
  final fromFriday = tonight.weekday >= DateTime.friday ? tonight.weekday - DateTime.friday : -(DateTime.friday - tonight.weekday);
  final friday = DateTime(tonight.year, tonight.month, tonight.day - fromFriday);
  final sunday = DateTime(friday.year, friday.month, friday.day + 2);
  final night = nightOfInstant(e.start);
  return !night.isBefore(friday) && !night.isAfter(sunday);
}

List<SiteEvent> filterEventsByDate(List<SiteEvent> events, DateFilter filter, DateTime now) => switch (filter) {
      DateFilter.any => events,
      DateFilter.tonight => [for (final e in events) if (happensTonight(e, now)) e],
      DateFilter.weekend => [for (final e in events) if (happensThisWeekend(e, now)) e],
    };

/// Which events to show by what the cheapest ticket costs. Prices are in the event's own currency (all CAD today).
enum PriceFilter { any, free, under30 }

/// Events whose cheapest ticket on sale is in the range. An event with nothing on sale has no price and is left out of "Free" and "Under $30".
List<SiteEvent> filterEventsByPrice(List<SiteEvent> events, PriceFilter filter) => switch (filter) {
      PriceFilter.any => events,
      PriceFilter.free => [for (final e in events) if (e.fromPriceCents == 0) e],
      PriceFilter.under30 => [for (final e in events) if (e.fromPriceCents != null && e.fromPriceCents! <= 3000) e],
    };

/// Events with something left to buy (an event with no tickets on sale yet stays: they may come).
List<SiteEvent> onlyAvailableEvents(List<SiteEvent> events) => [for (final e in events) if (!e.soldOut) e];

/// The items of a "hot" list that are in [all], in the hot order. A hot id the app did not load (an unpublished one, a finished one) is skipped.
List<T> inHotOrder<T>(List<T> all, String Function(T) idOf, List<String> hotIds) {
  final byId = {for (final x in all) idOf(x): x};
  return [for (final id in hotIds) if (byId[id] case final x?) x];
}
