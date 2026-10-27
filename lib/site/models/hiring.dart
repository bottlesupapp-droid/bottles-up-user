import '../read.dart';
import '../when.dart';
import 'social_profile.dart';

/// Where a request to hire a professional stands (`site_pro_requests.status`).
enum RequestStatus {
  requested('requested', 'Waiting for a quote'),
  quoted('quoted', 'Quote sent'),
  declined('declined', 'Declined'),
  withdrawn('withdrawn', 'Withdrawn'),
  accepted('accepted', 'Accepted');

  const RequestStatus(this.wire, this.label);

  final String wire;
  final String label;

  static RequestStatus? fromWire(Object? v) {
    for (final s in values) {
      if (s.wire == v) return s;
    }
    return null;
  }

  bool get isOpen => this == requested || this == quoted;
}

enum QuoteStatus {
  sent('sent'),
  accepted('accepted'),
  declined('declined'),
  withdrawn('withdrawn'),
  expired('expired');

  const QuoteStatus(this.wire);

  final String wire;

  static QuoteStatus? fromWire(Object? v) {
    for (final s in values) {
      if (s.wire == v) return s;
    }
    return null;
  }
}

/// A booking's progress in one word, as `market_booking_state` says it.
enum BookingState {
  awaitingDeposit('awaiting_deposit', 'Waiting for the deposit'),
  expired('expired', 'Not paid in time'),
  confirmed('confirmed', 'Booked: balance to pay'),
  paid('paid', 'Booked and paid'),
  done('done', 'Done: waiting for confirmation'),
  completed('completed', 'Completed'),
  disputed('disputed', 'In dispute'),
  cancelled('cancelled', 'Cancelled');

  const BookingState(this.wire, this.label);

  final String wire;
  final String label;

  static BookingState? fromWire(Object? v) {
    for (final s in values) {
      if (s.wire == v) return s;
    }
    return null;
  }

  /// Nothing more will happen to it.
  bool get isClosed => this == expired || this == completed || this == cancelled;
}

/// A service a professional offers.
class ProService {
  const ProService({required this.id, required this.title, this.description, this.fromCents, this.priceNote, this.active = true});

  final String id;
  final String title;
  final String? description;
  final int? fromCents;
  final String? priceNote;
  final bool active;
}

ProService? parseProService(Object? json) {
  if (json is! Map) return null;
  final id = readText(json['id']);
  final title = readText(json['title']);
  if (id == null || title == null) return null;
  return ProService(id: id, title: title, description: readText(json['description']), fromCents: readInt(json['from_cents']), priceNote: readText(json['price_note']), active: json['active'] != false);
}

List<ProService> parseProServices(Object? json) => json is List ? [for (final r in json) if (parseProService(r) case final ProService s) s] : const [];

/// What the professional quoted.
class ProQuote {
  const ProQuote({required this.id, required this.totalCents, required this.depositCents, required this.scope, required this.validUntil, required this.status, this.balanceDueBy});

  final String id;
  final int totalCents;
  final int depositCents;
  final DateTime? balanceDueBy;
  final String scope;
  final DateTime validUntil;
  final QuoteStatus status;

  int get balanceCents => totalCents - depositCents;
  bool get isOpen => status == QuoteStatus.sent;
}

ProQuote? parseProQuote(Object? json) {
  if (json is! Map) return null;
  final id = readText(json['id']);
  final total = readInt(json['total_cents']);
  final deposit = readInt(json['deposit_cents']);
  final scope = readText(json['scope']);
  final valid = parseWhen(json['valid_until']);
  final status = QuoteStatus.fromWire(json['status']);
  if (id == null || total == null || total <= 0 || deposit == null || deposit <= 0 || deposit > total || scope == null || valid == null || status == null) return null;
  return ProQuote(id: id, totalCents: total, depositCents: deposit, balanceDueBy: readDay(json['balance_due_by']), scope: scope, validUntil: valid, status: status);
}

/// The person on the other side of a booking or request, for the professional to see: a name and a username.
class Customer {
  const Customer({required this.name, this.handle});

  final String name;
  final String? handle;
}

Customer? parseCustomer(Object? json) {
  if (json is! Map) return null;
  final name = readText(json['name']);
  return name == null ? null : Customer(name: name, handle: readText(json['handle']));
}

/// A dispute on a booking.
class ProDispute {
  const ProDispute({required this.id, required this.open, required this.reason, this.outcome});

  final String id;
  final bool open;
  final String reason;

  /// `release`, `refund_part` or `refund_full` once BottlesUp has decided.
  final String? outcome;

  String get outcomeText => switch (outcome) {
        'release' => 'BottlesUp decided in the professional\'s favour.',
        'refund_part' => 'BottlesUp decided part of the payment goes back to the customer.',
        'refund_full' => 'BottlesUp decided everything goes back to the customer.',
        _ => 'BottlesUp is looking at it.',
      };
}

class ProBooking {
  const ProBooking({
    required this.id,
    required this.requestId,
    required this.state,
    required this.title,
    required this.eventDate,
    required this.currency,
    required this.totalCents,
    required this.depositCents,
    required this.paidCents,
    required this.owedCents,
    required this.freeCancelDays,
    this.balanceDueBy,
    this.payBy,
    this.providerDoneAt,
    this.completedAt,
    this.cancelledBy,
    this.cancelReason,
    this.provider,
    this.customer,
    this.netCents,
    this.commissionBps,
    this.dispute,
  });

  final String id;
  final String requestId;
  final BookingState state;
  final String title;
  final DateTime eventDate;
  final String currency;
  final int totalCents;
  final int depositCents;
  final int paidCents;
  final int owedCents;
  final int freeCancelDays;
  final DateTime? balanceDueBy;
  final DateTime? payBy;
  final DateTime? providerDoneAt;
  final DateTime? completedAt;
  final String? cancelledBy;
  final String? cancelReason;
  final SocialProfile? provider;

  /// Only the professional's view carries the customer, what they will be paid and the commission.
  final Customer? customer;
  final int? netCents;
  final int? commissionBps;
  final ProDispute? dispute;

  bool get isProviderView => netCents != null;

  /// What a late cancellation by the customer keeps for the professional: the deposit, at least 30% of the price, never more than was paid.
  int get keptIfLateCents {
    final floor = totalCents * 30 ~/ 100;
    final keep = depositCents > floor ? depositCents : floor;
    return paidCents < keep ? paidCents : keep;
  }
}

ProBooking? parseProBooking(Object? json) {
  if (json is! Map) return null;
  final id = readText(json['id']);
  final request = readText(json['request_id']);
  final state = BookingState.fromWire(json['state']);
  final day = readDay(json['event_date']);
  final total = readInt(json['total_cents']);
  final deposit = readInt(json['deposit_cents']);
  if (id == null || request == null || state == null || day == null || total == null || total <= 0 || deposit == null || deposit <= 0) return null;
  final d = json['dispute'];
  ProDispute? dispute;
  if (d is Map && readText(d['id']) != null) {
    dispute = ProDispute(id: readText(d['id'])!, open: d['status'] != 'resolved', reason: readText(d['reason']) ?? '', outcome: readText(d['outcome']));
  }
  return ProBooking(
    id: id,
    requestId: request,
    state: state,
    title: readText(json['title']) ?? 'Booking',
    eventDate: day,
    currency: readText(json['currency']) ?? 'cad',
    totalCents: total,
    depositCents: deposit,
    paidCents: readInt(json['paid_cents']) ?? 0,
    owedCents: readInt(json['owed_cents']) ?? total,
    freeCancelDays: readInt(json['free_cancel_days']) ?? 7,
    balanceDueBy: readDay(json['balance_due_by']),
    payBy: parseWhen(json['pay_by']),
    providerDoneAt: parseWhen(json['provider_done_at']),
    completedAt: parseWhen(json['completed_at']),
    cancelledBy: readText(json['cancelled_by']),
    cancelReason: readText(json['cancel_reason']),
    provider: parseSocialProfile(json['provider']),
    customer: parseCustomer(json['client']),
    netCents: readInt(json['net_cents']),
    commissionBps: readInt(json['commission_bps']),
    dispute: dispute,
  );
}

/// A request to hire a professional, with its live quote and its booking when there are any.
class ProRequest {
  const ProRequest({
    required this.id,
    required this.status,
    required this.eventDate,
    required this.message,
    required this.createdAt,
    this.timeNote,
    this.location,
    this.guests,
    this.budgetCents,
    this.declineNote,
    this.serviceTitle,
    this.provider,
    this.customer,
    this.quote,
    this.booking,
  });

  final String id;
  final RequestStatus status;
  final DateTime eventDate;
  final String message;
  final DateTime createdAt;
  final String? timeNote;
  final String? location;
  final int? guests;
  final int? budgetCents;
  final String? declineNote;
  final String? serviceTitle;
  final SocialProfile? provider;

  /// Only the professional's view names the customer.
  final Customer? customer;
  final ProQuote? quote;
  final ProBooking? booking;

  bool get isProviderView => customer != null;

  /// There is a quote the customer can still accept.
  bool get hasOpenQuote => status == RequestStatus.quoted && quote != null && quote!.isOpen;
}

ProRequest? parseProRequest(Object? json) {
  if (json is! Map) return null;
  final id = readText(json['id']);
  final status = RequestStatus.fromWire(json['status']);
  final day = readDay(json['event_date']);
  final message = readText(json['message']);
  final created = parseWhen(json['created_at']);
  if (id == null || status == null || day == null || message == null || created == null) return null;
  final service = json['service'];
  return ProRequest(
    id: id,
    status: status,
    eventDate: day,
    message: message,
    createdAt: created,
    timeNote: readText(json['time_note']),
    location: readText(json['location']),
    guests: readInt(json['guests']),
    budgetCents: readInt(json['budget_cents']),
    declineNote: readText(json['decline_note']),
    serviceTitle: service is Map ? readText(service['title']) : null,
    provider: parseSocialProfile(json['provider']),
    customer: parseCustomer(json['client']),
    quote: parseProQuote(json['quote']),
    booking: parseProBooking(json['booking']),
  );
}

List<ProRequest> parseProRequests(Object? json) => json is List ? [for (final r in json) if (parseProRequest(r) case final ProRequest q) q] : const [];

/// Where the payment of a booking stands, as `confirm-pro-payment` says it.
enum ProPayment { paid, pending, none }

({ProPayment status, ProBooking? booking})? parseProPayment(Object? json) {
  if (json is! Map) return null;
  for (final s in ProPayment.values) {
    if (s.name == json['status']) return (status: s, booking: parseProBooking(json['booking']));
  }
  return null;
}
