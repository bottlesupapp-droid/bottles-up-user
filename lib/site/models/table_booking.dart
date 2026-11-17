import '../read.dart';
import '../when.dart';
import 'my_night.dart';

/// What a table booking is, as the website stores it (`site_table_bookings.status`). A booking that was started but never paid is `pending` and is not a booking the person has.
enum BookingStatus {
  pending('pending', 'Awaiting payment'),
  paid('paid', 'Confirmed'),
  failed('failed', 'Payment failed'),
  refunded('refunded', 'Refunded'),
  cancelled('cancelled', 'Cancelled');

  const BookingStatus(this.db, this.label);

  final String db;
  final String label;

  static BookingStatus? fromDb(Object? v) {
    for (final s in values) {
      if (s.db == v) return s;
    }
    return null;
  }
}

/// A bottle on a booking (`site_table_booking_bottles`). [paymentStatus] is `paid` (charged online) or `due_at_venue` (settled at the club).
class BookingBottle {
  const BookingBottle({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unitPriceCents,
    required this.lineTotalCents,
    required this.paymentStatus,
    this.size,
    this.isAddon = false,
    this.cancelled = false,
    this.serviceStatus,
    this.deliveredQuantity = 0,
  });

  final String id;
  final String name;
  final String? size;
  final int quantity;
  final int unitPriceCents;
  final int lineTotalCents;
  final String paymentStatus;
  final bool isAddon;
  final bool cancelled;

  /// Where the venue has got to with it: `awaiting_prep`, `preparing`, `ready`, `picked_up` or `served`. Separate from whether it is paid.
  final String? serviceStatus;
  final int deliveredQuantity;

  /// What a guest reads for [serviceStatus]. A status this code has not seen is not shown as one it knows.
  String? get serviceLabel => switch (serviceStatus) {
        'awaiting_prep' => 'Order received',
        'preparing' => 'Being prepared',
        'ready' => 'Ready',
        'picked_up' => 'On the way',
        'served' => 'Delivered',
        _ => null,
      };

  String get displayName => size == null ? name : '$name ($size)';
  bool get dueAtClub => paymentStatus == 'due_at_venue';
}

BookingBottle? parseBookingBottle(Map<String, dynamic> row) {
  final id = readText(row['id']);
  final name = readText(row['bottle_name']);
  final qty = readInt(row['quantity']);
  if (id == null || name == null || qty == null || qty < 1) return null;
  return BookingBottle(
    id: id,
    name: name,
    size: readText(row['size']),
    quantity: qty,
    unitPriceCents: readInt(row['unit_price_cents']) ?? 0,
    lineTotalCents: readInt(row['line_total_cents']) ?? 0,
    paymentStatus: readText(row['payment_status']) ?? 'paid',
    isAddon: row['is_addon'] == true,
    cancelled: row['cancelled_at'] != null,
    serviceStatus: readText(row['service_status']),
    deliveredQuantity: readInt(row['delivered_quantity']) ?? 0,
  );
}

/// A payment the club recorded for the bottles that the guest has not yet confirmed (`site_table_booking_club_payments` with `customer_confirmation_status = pending`).
class ClubPaymentRequest {
  const ClubPaymentRequest({required this.id, required this.token, required this.billedCents, required this.paidCents, required this.method});

  final String id;

  /// The secret in the confirmation link; the person's own, because the database shows them only their own rows.
  final String token;
  final int billedCents;
  final int paidCents;
  final String method;
}

ClubPaymentRequest? parseClubPayment(Map<String, dynamic> row) {
  final id = readText(row['id']);
  final token = readText(row['confirm_token']);
  if (id == null || token == null) return null;
  return ClubPaymentRequest(id: id, token: token, billedCents: readInt(row['billed_amount_cents']) ?? 0, paidCents: readInt(row['amount_paid_cents']) ?? 0, method: readText(row['payment_method']) ?? '');
}

/// Money returned for a booking (`site_table_booking_refunds`).
class BookingRefund {
  const BookingRefund({required this.type, required this.amountCents, required this.reason, this.recordedAt});

  final String type;
  final int amountCents;
  final String reason;
  final DateTime? recordedAt;
}

BookingRefund? parseBookingRefund(Map<String, dynamic> row) {
  final amount = readInt(row['amount_cents']);
  if (amount == null || amount < 0) return null;
  return BookingRefund(type: readText(row['refund_type']) ?? 'refund', amountCents: amount, reason: readText(row['reason']) ?? '', recordedAt: parseWhen(row['recorded_at']));
}

/// A table booking the signed-in person made (`site_table_bookings`, which the database shows a person only when its e-mail is theirs), with where and when.
class TableBooking {
  const TableBooking({
    required this.id,
    required this.status,
    required this.guestCount,
    required this.bookingDate,
    required this.tableName,
    required this.venueName,
    required this.currency,
    required this.depositCents,
    required this.bottleSubtotalCents,
    required this.taxCents,
    required this.feeCents,
    required this.discountCents,
    required this.totalCents,
    required this.paidCents,
    required this.createdAt,
    this.confirmationCode,
    this.hours,
    this.startTime,
    this.slotLabel,
    this.venueId,
    this.venueAddress,
    this.venuePhone,
    this.bottlePaymentChoice,
    this.checkedInAt,
    this.cancelledAt,
    this.cancellationReason,
    this.bottles = const [],
    this.clubPayments = const [],
    this.refunds = const [],
    this.substitutions = const [],
  });

  final String id;
  final BookingStatus status;

  /// The code on the QR; null until the booking is paid.
  final String? confirmationCode;
  final int guestCount;
  final int? hours;

  /// The day the guests arrive (an after-midnight time is the day after the night they picked).
  final DateTime bookingDate;

  /// "22:00:00"; null when the time cannot be read.
  final String? startTime;
  final String? slotLabel;
  final String tableName;
  final String? venueId;
  final String venueName;
  final String? venueAddress;
  final String? venuePhone;
  final String currency;
  final int depositCents;
  final int bottleSubtotalCents;
  final int taxCents;
  final int feeCents;
  final int discountCents;
  final int totalCents;
  final int paidCents;
  final String? bottlePaymentChoice;
  final DateTime? checkedInAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;
  final DateTime createdAt;
  final List<BookingBottle> bottles;
  final List<ClubPaymentRequest> clubPayments;
  final List<BookingRefund> refunds;

  /// Bottle replacements the club suggested that the guest has not answered yet.
  final List<BottleSubstitution> substitutions;

  bool get isPaid => status == BookingStatus.paid;
  bool get isCancelled => status == BookingStatus.cancelled;
  bool get isRefunded => status == BookingStatus.refunded;
  bool get isCheckedIn => checkedInAt != null;

  /// What the guests still pay at the club: the total less what was paid online, never below nothing. Nothing is owed on a booking that is cancelled or refunded.
  int get dueAtClubCents => isPaid ? (totalCents - paidCents < 0 ? 0 : totalCents - paidCents) : 0;

  /// When the guests arrive, on the phone's clock, or null when the time of arrival is not known.
  DateTime? get arrival {
    final t = startTime;
    if (t == null) return null;
    final parts = t.split(':');
    final h = int.tryParse(parts[0]), m = parts.length > 1 ? int.tryParse(parts[1]) : 0;
    if (h == null || m == null) return null;
    return DateTime(bookingDate.year, bookingDate.month, bookingDate.day, h, m);
  }

  /// The booking is over: twelve hours after the arrival (the website's rule for when a night has ended), or the end of the arrival day when the time is not known.
  bool isOver(DateTime now) {
    final a = arrival;
    final end = a == null ? DateTime(bookingDate.year, bookingDate.month, bookingDate.day + 1) : a.add(const Duration(hours: 12));
    return !end.isAfter(now);
  }
}

/// A booking row with its table, venue and time embedded (`site_table_types`, `site_venues`, `site_venue_time_slots`) and, for the detail page, its bottles, club payments and
/// refunds. Null when it has no id, a known status, a booking day, or a guest count.
TableBooking? parseTableBooking(Map<String, dynamic> row, {List<BookingBottle> bottles = const [], List<ClubPaymentRequest> clubPayments = const [], List<BookingRefund> refunds = const [], List<BottleSubstitution> substitutions = const []}) {
  final id = readText(row['id']);
  final status = BookingStatus.fromDb(row['status']);
  final day = readDay(row['booking_date']);
  final guests = readInt(row['guest_count']);
  final created = parseWhen(row['created_at']);
  if (id == null || status == null || day == null || guests == null || guests < 1 || created == null) return null;
  Map<String, dynamic> one(String key) => row[key] is Map ? Map<String, dynamic>.from(row[key] as Map) : const <String, dynamic>{};
  final table = one('site_table_types');
  final venue = one('site_venues');
  final slot = one('site_venue_time_slots');
  return TableBooking(
    id: id,
    status: status,
    confirmationCode: readText(row['confirmation_code']),
    guestCount: guests,
    hours: readInt(row['hours']),
    bookingDate: day,
    startTime: readText(slot['start_time']),
    slotLabel: readText(slot['label']),
    tableName: readText(table['name']) ?? 'VIP table',
    venueId: readText(row['venue_id']),
    venueName: readText(venue['name']) ?? 'Venue',
    venueAddress: readText(venue['address']),
    venuePhone: readText(venue['phone']),
    currency: readText(row['currency']) ?? 'cad',
    depositCents: readInt(row['deposit_cents']) ?? 0,
    bottleSubtotalCents: readInt(row['bottle_subtotal_cents']) ?? 0,
    taxCents: readInt(row['tax_cents']) ?? 0,
    feeCents: readInt(row['bottlesup_fee_cents']) ?? 0,
    discountCents: readInt(row['discount_cents']) ?? 0,
    totalCents: readInt(row['amount_total_cents']) ?? 0,
    paidCents: readInt(row['amount_paid_cents']) ?? 0,
    bottlePaymentChoice: readText(row['bottle_payment_choice']),
    checkedInAt: parseWhen(row['checked_in_at']),
    cancelledAt: parseWhen(row['cancelled_at']),
    cancellationReason: readText(row['cancellation_reason']),
    createdAt: created,
    bottles: bottles,
    clubPayments: clubPayments,
    refunds: refunds,
    substitutions: substitutions,
  );
}
