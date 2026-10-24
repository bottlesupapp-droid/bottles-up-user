import '../when.dart';

int? _int(Object? v) => v is num ? v.toInt() : int.tryParse('$v');
String? _text(Object? v) {
  final s = v is String ? v.trim() : null;
  return s == null || s.isEmpty ? null : s;
}

/// What the website said about a promo code the person typed (`validate-promo-code`). The website works the discount out again when the order is made: this is only a preview.
class PromoCheck {
  const PromoCheck({required this.valid, required this.message, this.discountCents = 0});

  final bool valid;
  final String message;
  final int discountCents;
}

PromoCheck parsePromoCheck(Map<String, dynamic> row) {
  final valid = row['valid'] == true;
  final discount = _int(row['discountCents'] ?? row['discount_cents']) ?? 0;
  final message = _text(row['message']) ?? (valid ? 'Promo code applied.' : 'That promo code did not work.');
  return PromoCheck(valid: valid && discount >= 0, message: message, discountCents: valid && discount > 0 ? discount : 0);
}

/// What the website said about an access code for a ticket type (`validate-tier-access-code`).
class AccessCheck {
  const AccessCheck({required this.valid, required this.message});

  final bool valid;
  final String message;
}

AccessCheck parseAccessCheck(Map<String, dynamic> row) {
  final valid = row['valid'] == true;
  return AccessCheck(valid: valid, message: _text(row['message']) ?? (valid ? 'Code accepted.' : 'That code did not work.'));
}

/// The page where the person pays (Stripe's own page, made by the website) and what identifies the payment afterwards.
class CheckoutStart {
  const CheckoutStart({required this.url, this.sessionId, this.orderId});

  final Uri url;

  /// The Stripe checkout session id: the website's status check is asked with it. The website's answer may not carry it; then it is read from [url].
  final String? sessionId;
  final String? orderId;
}

final RegExp _sessionInUrl = RegExp(r'cs_(?:live|test)_[A-Za-z0-9]+');

/// The session id out of a Stripe checkout address (`https://checkout.stripe.com/c/pay/cs_test_...#...`), or null.
String? sessionIdFromCheckoutUrl(String url) => _sessionInUrl.firstMatch(url)?.group(0);

/// The answer of `site-create-checkout-session` / `create-table-booking-checkout`: `{url}` and, when the website sends them, `session_id` and `order_id` / `booking_id`.
/// Null when there is no usable https address to pay at.
CheckoutStart? parseCheckoutStart(Map<String, dynamic> row) {
  final raw = _text(row['url']);
  final uri = raw == null ? null : Uri.tryParse(raw);
  if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) return null;
  return CheckoutStart(
    url: uri,
    sessionId: _text(row['session_id']) ?? sessionIdFromCheckoutUrl(raw!),
    orderId: _text(row['order_id']) ?? _text(row['booking_id']),
  );
}

/// Where a payment stands, from the website's `site-booking-status`.
enum PaymentState { paid, waiting, failed, notFound }

class PaidTicket {
  const PaidTicket({
    required this.ticketCode,
    required this.quantity,
    required this.tierName,
    required this.eventTitle,
    required this.venueName,
    required this.startDate,
    required this.customerEmail,
    this.discountCents = 0,
  });

  final String ticketCode;
  final int quantity;
  final String tierName;
  final String eventTitle;
  final String venueName;
  final DateTime? startDate;
  final String customerEmail;
  final int discountCents;
}

class PaymentStatus {
  const PaymentStatus(this.state, {this.ticket});

  final PaymentState state;
  final PaidTicket? ticket;
}

/// The answer of `site-booking-status` for an order of tickets. `paid` carries the ticket; `pending` (or anything not yet paid) means keep waiting; `failed` and `not_found` are final.
PaymentStatus parsePaymentStatus(Map<String, dynamic> row) {
  final status = row['status'];
  if (status == 'paid') {
    final t = row['ticket'];
    if (t is Map) {
      final code = _text(t['ticketCode']);
      if (code != null) {
        return PaymentStatus(
          PaymentState.paid,
          ticket: PaidTicket(
            ticketCode: code,
            quantity: _int(t['quantity']) ?? 1,
            tierName: _text(t['tierName']) ?? '',
            eventTitle: _text(t['eventTitle']) ?? 'Your event',
            venueName: _text(t['venueName']) ?? '',
            startDate: parseWhen(t['startDate']),
            customerEmail: _text(t['customerEmail']) ?? '',
            discountCents: _int(t['discountCents']) ?? 0,
          ),
        );
      }
    }
    // Paid but the ticket is not ready yet: keep waiting rather than show an empty ticket.
    return const PaymentStatus(PaymentState.waiting);
  }
  if (status == 'failed' || status == 'cancelled') return const PaymentStatus(PaymentState.failed);
  if (status == 'not_found') return const PaymentStatus(PaymentState.notFound);
  return const PaymentStatus(PaymentState.waiting);
}
