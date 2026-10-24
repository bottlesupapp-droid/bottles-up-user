import '../when.dart';

int? _int(Object? v) => v is num ? v.toInt() : int.tryParse('$v');
String? _text(Object? v) {
  final s = v is String ? v.trim() : null;
  return s == null || s.isEmpty ? null : s;
}

List<String> _texts(Object? v) => v is List ? [for (final x in v) if (x is String && x.trim().isNotEmpty) x.trim()] : const [];

/// One kind of ticket for an event (`site_ticket_tiers`).
class TicketTier {
  const TicketTier({
    required this.id,
    required this.eventId,
    required this.name,
    required this.priceCents,
    required this.currency,
    required this.capacity,
    required this.soldCount,
    required this.requiresAccessCode,
    required this.isNonTransferable,
  });

  final String id;
  final String eventId;
  final String name;
  final int priceCents;
  final String currency;
  final int capacity;
  final int soldCount;

  /// The buyer needs a code to unlock this one (checked again by the website at payment).
  final bool requiresAccessCode;

  /// The ticket stays with the buyer: at the door they give a 6-digit code sent to their email.
  final bool isNonTransferable;

  int get available => capacity - soldCount < 0 ? 0 : capacity - soldCount;
  bool get soldOut => available <= 0;
  bool get isFree => priceCents == 0;
}

/// A ticket type, or null when the row cannot be trusted (no id, no name, no price).
TicketTier? parseTicketTier(Map<String, dynamic> row, {String? eventId}) {
  final id = _text(row['id']);
  final name = _text(row['name']);
  final price = _int(row['price_cents']);
  final event = _text(row['event_id']) ?? eventId;
  if (id == null || name == null || price == null || price < 0 || event == null) return null;
  return TicketTier(
    id: id,
    eventId: event,
    name: name,
    priceCents: price,
    currency: _text(row['currency']) ?? 'cad',
    capacity: _int(row['capacity']) ?? 0,
    soldCount: _int(row['sold_count']) ?? 0,
    requiresAccessCode: row['requires_access_code'] == true,
    isNonTransferable: row['is_non_transferable'] == true,
  );
}

/// A published event (`site_events`) with its ticket types.
class SiteEvent {
  const SiteEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.venueName,
    required this.start,
    this.end,
    this.address,
    this.coverImageUrl,
    this.bannerImageUrl,
    this.gallery = const [],
    this.category,
    this.slug,
    this.venueId,
    this.lineup = const [],
    this.goodToKnow = const [],
    this.organizerName,
    this.organizerBio,
    this.organizerVerified = false,
    this.tiers = const [],
  });

  final String id;
  final String title;
  final String description;
  final String venueName;
  final DateTime start;
  final DateTime? end;
  final String? address;
  final String? coverImageUrl;
  final String? bannerImageUrl;
  final List<String> gallery;
  final String? category;
  final String? slug;
  final String? venueId;

  /// Names of the acts, in the order the organizer gave them.
  final List<String> lineup;
  final List<String> goodToKnow;
  final String? organizerName;
  final String? organizerBio;
  final bool organizerVerified;
  final List<TicketTier> tiers;

  /// The picture to show first: the banner, else the cover, else the first gallery picture.
  String? get picture => bannerImageUrl ?? coverImageUrl ?? (gallery.isEmpty ? null : gallery.first);

  /// When the event is over: its end, or 12 hours after it starts when it has none (the same rule the door uses).
  DateTime get over => end ?? start.add(const Duration(hours: 12));
  bool isOver(DateTime now) => !over.isAfter(now);
  bool isLive(DateTime now) => !start.isAfter(now) && over.isAfter(now);

  /// The cheapest price among the ticket types people can buy now, or null when there are none.
  int? get fromPriceCents {
    final open = tiers.where((t) => !t.soldOut && !t.requiresAccessCode).toList();
    final pool = open.isEmpty ? tiers.where((t) => !t.soldOut).toList() : open;
    if (pool.isEmpty) return null;
    return pool.map((t) => t.priceCents).reduce((a, b) => a < b ? a : b);
  }

  /// True when there is nothing left to buy.
  bool get soldOut => tiers.isNotEmpty && tiers.every((t) => t.soldOut);
}

/// An event row, with its tiers under [tiersKey]. Null when it has no id, title or readable start.
SiteEvent? parseSiteEvent(Map<String, dynamic> row, {String tiersKey = 'tiers'}) {
  final id = _text(row['id']);
  final title = _text(row['title']);
  final start = parseWhen(row['start_date']);
  if (id == null || title == null || start == null) return null;
  final tiersRaw = row[tiersKey];
  final tiers = <TicketTier>[
    if (tiersRaw is List)
      for (final t in tiersRaw)
        if (t is Map) ...[
          if (parseTicketTier(Map<String, dynamic>.from(t), eventId: id) case final tier?) tier,
        ],
  ]..sort((a, b) => a.priceCents.compareTo(b.priceCents));
  final lineupRaw = row['lineup'];
  final lineup = <String>[
    if (lineupRaw is List)
      for (final a in lineupRaw)
        if (a is String && a.trim().isNotEmpty)
          a.trim()
        else if (a is Map && _text(a['name']) != null)
          _text(a['name'])!,
  ];
  return SiteEvent(
    id: id,
    title: title,
    description: _text(row['description']) ?? '',
    venueName: _text(row['venue_name']) ?? '',
    start: start,
    end: parseWhen(row['end_date']),
    address: _text(row['address']),
    coverImageUrl: _text(row['cover_image_url']),
    bannerImageUrl: _text(row['banner_image_url']),
    gallery: _texts(row['gallery']),
    category: _text(row['category']),
    slug: _text(row['slug']),
    venueId: _text(row['venue_id']),
    lineup: lineup,
    goodToKnow: _texts(row['good_to_know']),
    organizerName: _text(row['organizer_name']),
    organizerBio: _text(row['organizer_bio']),
    organizerVerified: row['organizer_verified'] == true,
    tiers: tiers,
  );
}
