import '../read.dart';
import '../when.dart';
import 'social_profile.dart';

/// Where one share of a split bill stands, as the website says it (`split_share_state`). A state this code has not seen is not shown as one it knows: the row is dropped.
enum ShareState {
  unpaid('unpaid', 'Waiting for payment'),
  pending('pending', 'Payment started'),
  paid('paid', 'Paid'),
  refunding('refunding', 'Being paid back'),
  refunded('refunded', 'Paid back'),
  expired('expired', 'Time ran out'),
  cancelled('cancelled', 'Cancelled'),
  declined('declined', 'Turned down');

  const ShareState(this.wire, this.label);

  final String wire;
  final String label;

  static ShareState? fromWire(Object? v) {
    for (final s in values) {
      if (s.wire == v) return s;
    }
    return null;
  }

  /// A friend may start paying it.
  bool get canPay => this == unpaid || this == pending;

  /// The money has been taken (even if it is on its way back).
  bool get taken => this == paid || this == refunding || this == refunded;
}

/// How the whole split stands for the host: `open` (waiting for friends), `complete` (every friend paid), `expired` (the deadline passed with shares unpaid), `cancelled`.
enum SplitState {
  open('open'),
  complete('complete'),
  expired('expired'),
  cancelled('cancelled');

  const SplitState(this.wire);

  final String wire;

  static SplitState? fromWire(Object? v) {
    for (final s in values) {
      if (s.wire == v) return s;
    }
    return null;
  }
}

/// One friend's share, in the host's view of a split.
class SplitShareLine {
  const SplitShareLine({required this.id, required this.amountCents, required this.state, this.payer, this.paidAt});

  final String id;
  final int amountCents;
  final ShareState state;

  /// Null when the friend's account is gone.
  final SocialProfile? payer;
  final DateTime? paidAt;
}

/// A split of the balance still owed at the club on a booking, as the host sees it (`split_for_booking`).
class SplitPlan {
  const SplitPlan({
    required this.id,
    required this.bookingId,
    required this.state,
    required this.deadline,
    required this.currency,
    required this.balanceCents,
    required this.collectedCents,
    required this.outstandingCents,
    required this.shares,
    this.createdAt,
  });

  final String id;
  final String bookingId;
  final SplitState state;
  final DateTime deadline;
  final String currency;

  /// What the booking still owes at the club now (friends' payments already taken off).
  final int balanceCents;

  /// What friends have paid and the booking has been credited with.
  final int collectedCents;

  /// What friends have been asked for and may still pay.
  final int outstandingCents;
  final List<SplitShareLine> shares;
  final DateTime? createdAt;

  bool get isCancelled => state == SplitState.cancelled;

  /// The host may cancel until the website says the booking is over (it refuses then, in words).
  bool get canCancel => state != SplitState.cancelled;

  int get totalAskedCents => shares.fold(0, (sum, s) => sum + s.amountCents);
}

SplitPlan? parseSplitPlan(Object? json) {
  if (json is! Map) return null;
  final id = readText(json['id']);
  final booking = readText(json['booking_id']);
  final state = SplitState.fromWire(json['state']);
  final deadline = parseWhen(json['deadline']);
  if (id == null || booking == null || state == null || deadline == null) return null;
  final shares = <SplitShareLine>[];
  final raw = json['shares'];
  if (raw is List) {
    for (final r in raw) {
      if (r is! Map) continue;
      final sid = readText(r['id']);
      final amount = readInt(r['amount_cents']);
      final s = ShareState.fromWire(r['status']);
      if (sid == null || amount == null || amount <= 0 || s == null) continue;
      shares.add(SplitShareLine(id: sid, amountCents: amount, state: s, payer: parseSocialProfile(r['payer']), paidAt: parseWhen(r['paid_at'])));
    }
  }
  return SplitPlan(
    id: id,
    bookingId: booking,
    state: state,
    deadline: deadline,
    currency: readText(json['currency']) ?? 'cad',
    balanceCents: readInt(json['balance_cents']) ?? 0,
    collectedCents: readInt(json['collected_cents']) ?? 0,
    outstandingCents: readInt(json['outstanding_cents']) ?? 0,
    shares: shares,
    createdAt: parseWhen(json['created_at']),
  );
}

/// A request to pay a share of someone's table, as the friend sees it (`split_my_shares`): only the venue, the night, the host's first name and the friend's own amount.
class ShareRequest {
  const ShareRequest({
    required this.id,
    required this.state,
    required this.amountCents,
    required this.currency,
    required this.deadline,
    required this.host,
    required this.venue,
    this.bookingDate,
    this.startTime,
    this.paidAt,
  });

  final String id;
  final ShareState state;
  final int amountCents;
  final String currency;
  final DateTime deadline;
  final String host;
  final String venue;
  final DateTime? bookingDate;

  /// "22:00" or "22:00:00".
  final String? startTime;
  final DateTime? paidAt;

  /// A line for the night: "Fri, Nov 7 · 10:00 PM" when both are known, otherwise what is.
  String get night {
    final day = bookingDate;
    if (day == null) return '';
    final t = startTime;
    final parts = t?.split(':');
    final h = parts == null ? null : int.tryParse(parts[0]);
    final m = parts == null || parts.length < 2 ? 0 : int.tryParse(parts[1]);
    if (h == null || m == null) return formatDay(day);
    return formatWhen(DateTime(day.year, day.month, day.day, h, m));
  }
}

ShareRequest? parseShareRequest(Object? json) {
  if (json is! Map) return null;
  final id = readText(json['id']);
  final state = ShareState.fromWire(json['state']);
  final amount = readInt(json['amount_cents']);
  final deadline = parseWhen(json['deadline']);
  final venue = readText(json['venue']);
  if (id == null || state == null || amount == null || amount <= 0 || deadline == null || venue == null) return null;
  return ShareRequest(
    id: id,
    state: state,
    amountCents: amount,
    currency: readText(json['currency']) ?? 'cad',
    deadline: deadline,
    host: readText(json['host']) ?? 'A friend',
    venue: venue,
    bookingDate: readDay(json['booking_date']),
    startTime: readText(json['start_time']),
    paidAt: parseWhen(json['paid_at']),
  );
}

List<ShareRequest> parseShareRequests(Object? json) => json is List ? [for (final r in json) if (parseShareRequest(r) case final ShareRequest s) s] : const [];

/// Where a started payment page stands, as `confirm-split-share` says it.
enum SharePayment { paid, pending, unpaid, expired, cancelled, declined }

SharePayment? parseSharePayment(Object? json) {
  final said = json is Map ? json['status'] : null;
  for (final s in SharePayment.values) {
    if (s.name == said) return s;
  }
  return null;
}
