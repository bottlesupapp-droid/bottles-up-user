import '../read.dart';

/// How a venue lets guests pay for the bottles they order with a table (`site_venues.bottle_payment_mode`).
enum BottlePaymentMode {
  payAhead('pay_ahead'),
  payAtClub('pay_at_club'),
  both('both');

  const BottlePaymentMode(this.db);

  final String db;

  static BottlePaymentMode fromDb(Object? v) {
    for (final m in values) {
      if (m.db == v) return m;
    }
    return payAhead;
  }
}

/// What the guest chose, or was given, for the bottles: charged now, or settled at the club.
enum BottlePaymentChoice {
  payAhead('pay_ahead'),
  payAtClub('pay_at_club');

  const BottlePaymentChoice(this.db);

  final String db;
}

/// A table is priced as a flat deposit, or by the hour.
enum PricingMode { flat, hourly }

/// A day and time a venue takes table bookings (`site_venue_time_slots`). [dayOfWeek] is 0 = Sunday ... 6 = Saturday; [startTime] is "22:00:00".
class TimeSlot {
  const TimeSlot({required this.id, required this.venueId, required this.dayOfWeek, required this.startTime, this.label});

  final String id;
  final String venueId;
  final int dayOfWeek;
  final String startTime;
  final String? label;
}

TimeSlot? parseTimeSlot(Map<String, dynamic> row, {String? venueId}) {
  final id = readText(row['id']);
  final day = readInt(row['day_of_week']);
  final start = readText(row['start_time']);
  final venue = readText(row['venue_id']) ?? venueId;
  if (id == null || venue == null || day == null || day < 0 || day > 6 || start == null || !RegExp(r'^\d{1,2}:\d{2}(:\d{2})?$').hasMatch(start)) return null;
  // Always "HH:MM:SS", so times compare as text.
  final parts = start.split(':');
  final normalized = '${parts[0].padLeft(2, '0')}:${parts[1]}:${parts.length > 2 ? parts[2] : '00'}';
  return TimeSlot(id: id, venueId: venue, dayOfWeek: day, startTime: normalized, label: readText(row['label']));
}

/// A floor of a venue with a plan picture (`site_venue_floors`).
class Floor {
  const Floor({required this.id, required this.venueId, required this.label, required this.imageUrl, required this.sortOrder});

  final String id;
  final String venueId;
  final String label;
  final String imageUrl;
  final int sortOrder;
}

Floor? parseFloor(Map<String, dynamic> row) {
  final id = readText(row['id']);
  final venue = readText(row['venue_id']);
  final label = readText(row['label']);
  final image = readText(row['image_url']);
  if (id == null || venue == null || label == null || image == null) return null;
  return Floor(id: id, venueId: venue, label: label, imageUrl: image, sortOrder: readInt(row['sort_order']) ?? 0);
}

/// One bookable table, or kind of table, at a venue (`site_table_types`). [inventoryCount] of them exist. When [floorId] and the position are set it also has a spot on the floor plan
/// ([posX], [posY], [width], [height] are percentages of the plan picture).
class TableType {
  const TableType({
    required this.id,
    required this.venueId,
    required this.name,
    required this.maxGuests,
    required this.minSpendCents,
    required this.depositCents,
    required this.currency,
    required this.inventoryCount,
    required this.pricingMode,
    required this.sortOrder,
    this.description,
    this.minGuests,
    this.imageUrl,
    this.badgeLabel,
    this.isFeatured = false,
    this.floorId,
    this.posX,
    this.posY,
    this.width,
    this.height,
    this.hourlyRateCents,
    this.minHours,
    this.tableView,
    this.privacyLevel,
    this.seatingType,
    this.amenities,
    this.policyNote,
  });

  final String id;
  final String venueId;
  final String name;
  final String? description;
  final int maxGuests;
  final int? minGuests;
  final int minSpendCents;
  final int depositCents;
  final String currency;
  final int inventoryCount;
  final String? imageUrl;
  final String? badgeLabel;
  final bool isFeatured;
  final String? floorId;
  final double? posX;
  final double? posY;
  final double? width;
  final double? height;
  final PricingMode pricingMode;
  final int? hourlyRateCents;
  final int? minHours;
  final String? tableView;
  final String? privacyLevel;
  final String? seatingType;
  final String? amenities;
  final String? policyNote;
  final int sortOrder;

  bool get isHourly => pricingMode == PricingMode.hourly;

  /// Fewest hours that can be booked (hourly tables).
  int get minimumHours => (minHours ?? 1) < 1 ? 1 : (minHours ?? 1);

  /// True when the table has a spot on a floor plan.
  bool get hasSpot => floorId != null && posX != null && posY != null && width != null && height != null;

  /// What to put first when listing: the amount that is charged for one booking of the smallest size.
  int get fromCents => isHourly ? (hourlyRateCents ?? 0) * minimumHours : depositCents;
}

double? _percent(Object? v) {
  final n = v is num ? v.toDouble() : double.tryParse('$v');
  return n == null || n.isNaN ? null : n;
}

/// A table type, or null when the row cannot be trusted (no id, name or guest limit; an hourly table with no rate).
TableType? parseTableType(Map<String, dynamic> row, {String? venueId}) {
  final id = readText(row['id']);
  final name = readText(row['name']);
  final max = readInt(row['max_guests']);
  final venue = readText(row['venue_id']) ?? venueId;
  if (id == null || name == null || venue == null || max == null || max < 1) return null;
  final mode = row['pricing_mode'] == 'hourly' ? PricingMode.hourly : PricingMode.flat;
  final rate = readInt(row['hourly_rate_cents']);
  if (mode == PricingMode.hourly && (rate == null || rate < 1)) return null;
  return TableType(
    id: id,
    venueId: venue,
    name: name,
    description: readText(row['description']),
    maxGuests: max,
    minGuests: readInt(row['min_guests']),
    minSpendCents: readInt(row['min_spend_cents']) ?? 0,
    depositCents: readInt(row['deposit_cents']) ?? 0,
    currency: readText(row['currency']) ?? 'cad',
    inventoryCount: readInt(row['inventory_count']) ?? 1,
    imageUrl: readText(row['image_url']),
    badgeLabel: readText(row['badge_label']),
    isFeatured: row['is_featured'] == true,
    floorId: readText(row['floor_id']),
    posX: _percent(row['pos_x']),
    posY: _percent(row['pos_y']),
    width: _percent(row['width']),
    height: _percent(row['height']),
    pricingMode: mode,
    hourlyRateCents: rate,
    minHours: readInt(row['min_hours']),
    tableView: readText(row['table_view']),
    privacyLevel: readText(row['privacy_level']),
    seatingType: readText(row['seating_type']),
    amenities: readText(row['amenities']),
    policyNote: readText(row['policy_note']),
    sortOrder: readInt(row['sort_order']) ?? 0,
  );
}

/// A bottle a guest can order with a table (`site_bottles`). The website only shows bottles that are available and not sold out; so does the app.
class Bottle {
  const Bottle({required this.id, required this.venueId, required this.name, required this.priceCents, required this.currency, required this.sortOrder, this.size, this.description, this.imageUrl, this.category});

  final String id;
  final String venueId;
  final String name;
  final String? size;
  final String? description;
  final int priceCents;
  final String currency;
  final String? imageUrl;
  final String? category;
  final int sortOrder;

  String get displayName => size == null ? name : '$name ($size)';
}

Bottle? parseBottle(Map<String, dynamic> row, {String? venueId}) {
  final id = readText(row['id']);
  final name = readText(row['name']);
  final price = readInt(row['price_cents']);
  final venue = readText(row['venue_id']) ?? venueId;
  if (id == null || name == null || venue == null || price == null || price < 0) return null;
  if (row['is_available'] == false || row['is_sold_out'] == true) return null;
  return Bottle(
    id: id,
    venueId: venue,
    name: name,
    size: readText(row['size']),
    description: readText(row['description']),
    priceCents: price,
    currency: readText(row['currency']) ?? 'cad',
    imageUrl: readText(row['image_url']),
    category: readText(row['category']),
    sortOrder: readInt(row['sort_order']) ?? 0,
  );
}

/// A venue that takes table bookings (`site_venues`), with its table types and booking times when they were read with it.
class Venue {
  const Venue({
    required this.id,
    required this.name,
    required this.taxRateBps,
    required this.bottlePaymentMode,
    required this.depositIsCredit,
    required this.showBottleImages,
    this.slug,
    this.description,
    this.address,
    this.coverImageUrl,
    this.gallery = const [],
    this.category,
    this.phone,
    this.websiteUrl,
    this.hoursNote,
    this.dressCode,
    this.capacity,
    this.musicGenres,
    this.bookingStart,
    this.bookingEnd,
    this.tables = const [],
    this.slots = const [],
  });

  final String id;
  final String name;
  final String? slug;
  final String? description;
  final String? address;
  final String? coverImageUrl;
  final List<String> gallery;
  final String? category;
  final String? phone;
  final String? websiteUrl;
  final String? hoursNote;
  final String? dressCode;
  final int? capacity;
  final String? musicGenres;
  final int taxRateBps;
  final BottlePaymentMode bottlePaymentMode;
  final bool depositIsCredit;
  final bool showBottleImages;

  /// The first and last night bookings are taken for, when the venue set a window.
  final DateTime? bookingStart;
  final DateTime? bookingEnd;
  final List<TableType> tables;
  final List<TimeSlot> slots;

  /// The picture to show first.
  String? get picture => coverImageUrl ?? (gallery.isEmpty ? null : gallery.first);

  bool get hasFloorPlan => tables.any((t) => t.hasSpot);

  /// The cheapest amount charged for a booking here, or null when no table has a price.
  int? get fromCents {
    final prices = [for (final t in tables) if (t.fromCents > 0) t.fromCents];
    return prices.isEmpty ? null : prices.reduce((a, b) => a < b ? a : b);
  }

  /// A venue can take a booking only if it has a table and a time to book it at.
  bool get isBookable => tables.isNotEmpty && slots.isNotEmpty;
}

/// A venue, with `site_table_types` and `site_venue_time_slots` read under their own names. Null when it has no id or name.
Venue? parseVenue(Map<String, dynamic> row) {
  final id = readText(row['id']);
  final name = readText(row['name']);
  if (id == null || name == null) return null;
  List<T> many<T>(String key, T? Function(Map<String, dynamic>) parse) {
    final raw = row[key];
    return [
      if (raw is List)
        for (final r in raw)
          if (r is Map) ...[
            if (parse(Map<String, dynamic>.from(r)) case final item?) item,
          ],
    ];
  }

  final tables = many<TableType>('site_table_types', (r) => parseTableType(r, venueId: id))..sort((a, b) => a.sortOrder != b.sortOrder ? a.sortOrder.compareTo(b.sortOrder) : a.name.compareTo(b.name));
  final slots = many<TimeSlot>('site_venue_time_slots', (r) => parseTimeSlot(r, venueId: id))..sort((a, b) => a.dayOfWeek != b.dayOfWeek ? a.dayOfWeek.compareTo(b.dayOfWeek) : a.startTime.compareTo(b.startTime));
  return Venue(
    id: id,
    name: name,
    slug: readText(row['slug']),
    description: readText(row['description']),
    address: readText(row['address']),
    coverImageUrl: readText(row['cover_image_url']),
    gallery: readTexts(row['gallery']),
    category: readText(row['category']),
    phone: readText(row['phone']),
    websiteUrl: readText(row['website_url']),
    hoursNote: readText(row['hours_note']),
    dressCode: readText(row['dress_code']),
    capacity: readInt(row['capacity']),
    musicGenres: readText(row['music_genres']),
    taxRateBps: readInt(row['tax_rate_bps']) ?? 0,
    bottlePaymentMode: BottlePaymentMode.fromDb(row['bottle_payment_mode']),
    depositIsCredit: row['deposit_is_credit'] == true,
    showBottleImages: row['show_bottle_images'] != false,
    bookingStart: readDay(row['booking_start_date']),
    bookingEnd: readDay(row['booking_end_date']),
    tables: tables,
    slots: slots,
  );
}

/// The venue's cancellation and refund terms in plain sentences (`public_venue_refund_policy`).
class RefundPolicy {
  const RefundPolicy({required this.hasPolicy, required this.lines});

  final bool hasPolicy;
  final List<String> lines;
}
