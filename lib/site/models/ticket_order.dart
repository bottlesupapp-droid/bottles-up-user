import '../when.dart';

int? _int(Object? v) => v is num ? v.toInt() : int.tryParse('$v');
String? _text(Object? v) {
  final s = v is String ? v.trim() : null;
  return s == null || s.isEmpty ? null : s;
}

/// What an order of tickets is, as the website stores it (`site_orders.status`).
enum OrderStatus {
  pending('pending'),
  paid('paid'),
  failed('failed'),
  refunded('refunded');

  const OrderStatus(this.db);

  final String db;

  static OrderStatus? fromDb(Object? v) {
    for (final s in values) {
      if (s.db == v) return s;
    }
    return null;
  }
}

/// One order of tickets the signed-in person made (`site_orders`, which the database shows a person only when its e-mail is theirs).
class TicketOrder {
  const TicketOrder({
    required this.id,
    required this.status,
    required this.quantity,
    required this.amountCents,
    required this.currency,
    required this.createdAt,
    required this.eventTitle,
    this.eventId,
    this.venueName,
    this.address,
    this.eventStart,
    this.eventEnd,
    this.coverImageUrl,
    this.tierName,
    this.ticketCode,
    this.checkedInAt,
    this.isNonTransferable = false,
    this.discountCents = 0,
  });

  final String id;
  final OrderStatus status;
  final int quantity;
  final int amountCents;
  final String currency;
  final DateTime createdAt;
  final String eventTitle;
  final String? eventId;
  final String? venueName;
  final String? address;
  final DateTime? eventStart;
  final DateTime? eventEnd;
  final String? coverImageUrl;
  final String? tierName;

  /// The code on the QR (`BU-XXXXXXXX`); null until the order is paid.
  final String? ticketCode;
  final DateTime? checkedInAt;
  final bool isNonTransferable;
  final int discountCents;

  bool get isPaid => status == OrderStatus.paid && ticketCode != null;
  bool get isRefunded => status == OrderStatus.refunded;
  bool get isUsed => checkedInAt != null;

  /// The event is over (its end, or 12 hours after its start when it has none). An order whose event is unknown is not "over".
  bool isPast(DateTime now) {
    final s = eventStart;
    if (s == null) return false;
    final over = eventEnd ?? s.add(const Duration(hours: 12));
    return !over.isAfter(now);
  }

  /// A guest ticket someone can show: paid, with a code.
  bool get hasTicket => isPaid;
}

/// An order row with its event and tier embedded (`site_events`, `site_ticket_tiers`). Null when it has no id, a known status, or a quantity.
TicketOrder? parseTicketOrder(Map<String, dynamic> row) {
  final id = _text(row['id']);
  final status = OrderStatus.fromDb(row['status']);
  final quantity = _int(row['quantity']);
  final created = parseWhen(row['created_at']);
  if (id == null || status == null || quantity == null || quantity < 1 || created == null) return null;
  final event = row['site_events'] is Map ? Map<String, dynamic>.from(row['site_events'] as Map) : const <String, dynamic>{};
  final tier = row['site_ticket_tiers'] is Map ? Map<String, dynamic>.from(row['site_ticket_tiers'] as Map) : const <String, dynamic>{};
  return TicketOrder(
    id: id,
    status: status,
    quantity: quantity,
    amountCents: _int(row['amount_total_cents']) ?? 0,
    currency: _text(row['currency']) ?? 'cad',
    createdAt: created,
    eventTitle: _text(event['title']) ?? 'Event',
    eventId: _text(event['id']),
    venueName: _text(event['venue_name']),
    address: _text(event['address']),
    eventStart: parseWhen(event['start_date']),
    eventEnd: parseWhen(event['end_date']),
    coverImageUrl: _text(event['cover_image_url']),
    tierName: _text(tier['name']),
    ticketCode: _text(row['ticket_code']),
    checkedInAt: parseWhen(row['checked_in_at']),
    isNonTransferable: row['is_non_transferable'] == true,
    discountCents: _int(row['discount_cents']) ?? 0,
  );
}
