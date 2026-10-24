import '../read.dart';
import '../when.dart';

int? _int(Object? v) => readInt(v);
String? _text(Object? v) => readText(v);
DateTime? _day(Object? v) => readDay(v);

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

/// A paid table booking, from the `booking` the website's `site-booking-status` sends: the confirmation code (the QR the door scans), when, where, and what was paid and what is left
/// for the club.
class PaidBooking {
  const PaidBooking({
    required this.confirmationCode,
    required this.guestCount,
    required this.tableName,
    required this.venueName,
    required this.bookingDate,
    required this.startTime,
    required this.currency,
    required this.depositCents,
    required this.bottleSubtotalCents,
    required this.taxCents,
    required this.feeCents,
    required this.discountCents,
    required this.totalCents,
    required this.paidNowCents,
    required this.dueAtVenueCents,
    required this.customerEmail,
    this.bottles = const [],
  });

  final String confirmationCode;
  final int guestCount;
  final String tableName;
  final String venueName;

  /// The day the guests arrive.
  final DateTime? bookingDate;

  /// "22:00:00".
  final String startTime;
  final String currency;
  final int depositCents;
  final int bottleSubtotalCents;
  final int taxCents;
  final int feeCents;
  final int discountCents;
  final int totalCents;
  final int paidNowCents;
  final int dueAtVenueCents;
  final String customerEmail;
  final List<PaidBottle> bottles;
}

class PaidBottle {
  const PaidBottle({required this.name, required this.size, required this.quantity, required this.lineTotalCents, required this.paymentStatus});

  final String name;
  final String? size;
  final int quantity;
  final int lineTotalCents;
  final String? paymentStatus;
}

class PaymentStatus {
  const PaymentStatus(this.state, {this.ticket, this.booking});

  final PaymentState state;
  final PaidTicket? ticket;
  final PaidBooking? booking;
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
    final b = row['booking'];
    if (b is Map) {
      final code = _text(b['confirmationCode']);
      if (code != null) {
        final bottles = <PaidBottle>[
          if (b['bottles'] is List)
            for (final x in b['bottles'] as List)
              if (x is Map && _text(x['name']) != null)
                PaidBottle(
                  name: _text(x['name'])!,
                  size: _text(x['size']),
                  quantity: _int(x['quantity']) ?? 1,
                  lineTotalCents: _int(x['lineTotalCents']) ?? 0,
                  paymentStatus: _text(x['paymentStatus']),
                ),
        ];
        return PaymentStatus(
          PaymentState.paid,
          booking: PaidBooking(
            confirmationCode: code,
            guestCount: _int(b['guestCount']) ?? 1,
            tableName: _text(b['tableTypeName']) ?? 'Table',
            venueName: _text(b['venueName']) ?? '',
            bookingDate: _day(b['bookingDate']),
            startTime: _text(b['startTime']) ?? '',
            currency: _text(b['currency']) ?? 'cad',
            depositCents: _int(b['depositCents']) ?? 0,
            bottleSubtotalCents: _int(b['bottleSubtotalCents']) ?? 0,
            taxCents: _int(b['taxCents']) ?? 0,
            feeCents: _int(b['bottlesupFeeCents']) ?? 0,
            discountCents: _int(b['discountCents']) ?? 0,
            totalCents: _int(b['totalCents']) ?? 0,
            paidNowCents: _int(b['paidNowCents']) ?? 0,
            dueAtVenueCents: _int(b['dueAtVenueCents']) ?? 0,
            customerEmail: _text(b['customerEmail']) ?? '',
            bottles: bottles,
          ),
        );
      }
    }
    // Paid but the ticket or confirmation is not ready yet: keep waiting rather than show an empty one.
    return const PaymentStatus(PaymentState.waiting);
  }
  if (status == 'failed' || status == 'cancelled') return const PaymentStatus(PaymentState.failed);
  if (status == 'not_found') return const PaymentStatus(PaymentState.notFound);
  return const PaymentStatus(PaymentState.waiting);
}
