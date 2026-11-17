import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/checkout.dart';
import '../models/hiring.dart';
import '../site_error.dart';

String _day(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// Hiring professionals, through the website's functions. The website decides who may do what, what is paid and what is kept; this service carries the asks and the answers and turns
/// a refusal into the sentence it came with.
class HiringService {
  HiringService(this._db);

  final SupabaseClient _db;

  Future<T> _rpc<T>(String name, Map<String, dynamic> params, T Function(Object? answer) read, String generic) async {
    final Object? answer;
    try {
      answer = await _db.rpc(name, params: params);
    } catch (error) {
      throw siteExceptionFromRpc(error, generic: generic);
    }
    return read(answer);
  }

  // ---- the professional's services and days
  Future<List<ProService>> services(String profile) => _rpc('pro_services_of', {'p_profile': profile}, parseProServices, loadFailedMessage('the services'));

  Future<ProService> saveService({required String actor, String? id, required String title, String? description, int? fromCents, String? priceNote, bool active = true}) => _rpc(
        'pro_service_save',
        {'p_actor': actor, 'p_id': id, 'p_title': title.trim(), 'p_description': _blank(description), 'p_from_cents': fromCents, 'p_note': _blank(priceNote), 'p_active': active},
        (a) => parseProService(a) ?? (throw const SiteException('We could not read the answer. Your service may not have been saved.')),
        'The service was not saved. Check your connection and try again.',
      );

  Future<void> removeService({required String actor, required String id}) => _rpc('pro_service_remove', {'p_actor': actor, 'p_id': id}, (_) {}, 'The service was not removed. Check your connection and try again.');

  Future<List<DateTime>> busyDays(String profile, {required DateTime from, int days = 120}) => _rpc(
        'pro_busy_days',
        {'p_profile': profile, 'p_from': _day(from), 'p_days': days},
        (a) => a is List ? [for (final d in a) if (d is String && d.length >= 10 && DateTime.tryParse(d.substring(0, 10)) != null) DateTime.parse(d.substring(0, 10))] : const <DateTime>[],
        loadFailedMessage('the days'),
      );

  Future<void> setBusy({required String actor, required DateTime day, required bool busy}) => _rpc('pro_busy_set', {'p_actor': actor, 'p_day': _day(day), 'p_busy': busy}, (_) {}, 'That did not go through. Check your connection and try again.');

  // ---- requests and quotes
  ProRequest _request(Object? a) => parseProRequest(a) ?? (throw const SiteException('We could not read the answer. Look at your requests before trying again.'));

  Future<ProRequest> createRequest({required String provider, String? service, required DateTime date, String? timeNote, String? location, int? guests, required String message, int? budgetCents}) => _rpc(
        'pro_request_create',
        {'p_provider': provider, 'p_service': service, 'p_event_date': _day(date), 'p_time_note': _blank(timeNote), 'p_location': _blank(location), 'p_guests': guests, 'p_message': message.trim(), 'p_budget_cents': budgetCents},
        _request,
        'Your request was not sent. Check your connection and try again.',
      );

  Future<List<ProRequest>> myRequests() => _rpc('pro_requests_mine', const {}, parseProRequests, loadFailedMessage('your requests'));

  Future<List<ProRequest>> requestsFor(String actor) => _rpc('pro_requests_for', {'p_actor': actor}, parseProRequests, loadFailedMessage('the requests'));

  Future<ProRequest> request(String id) => _rpc('pro_request_get', {'p_request': id}, _request, loadFailedMessage('this request'));

  Future<ProRequest> sendQuote({required String actor, required String request, required int total, required int deposit, DateTime? balanceDueBy, required String scope, required int validDays}) => _rpc(
        'pro_quote_send',
        {'p_actor': actor, 'p_request': request, 'p_total_cents': total, 'p_deposit_cents': deposit, 'p_balance_due_by': balanceDueBy == null ? null : _day(balanceDueBy), 'p_scope': scope.trim(), 'p_valid_days': validDays},
        _request,
        'The quote was not sent. Check your connection and try again.',
      );

  Future<ProRequest> withdrawQuote({required String actor, required String request}) => _rpc('pro_quote_withdraw', {'p_actor': actor, 'p_request': request}, _request, actionFailedMessage);

  Future<ProRequest> declineRequest({required String actor, required String request, String? note}) => _rpc('pro_request_decline', {'p_actor': actor, 'p_request': request, 'p_note': _blank(note)}, _request, actionFailedMessage);

  Future<ProRequest> withdrawRequest(String request) => _rpc('pro_request_withdraw', {'p_request': request}, _request, actionFailedMessage);

  Future<ProRequest> declineQuote(String request) => _rpc('pro_quote_decline', {'p_request': request}, _request, actionFailedMessage);

  /// Accepts the live quote: a booking that must be paid within 24 hours.
  Future<ProBooking> acceptQuote(String request) => _rpc('pro_quote_accept', {'p_request': request}, (a) => parseProBooking(a) ?? (throw const SiteException('We could not read the answer. Look at your requests before trying again.')), 'The quote was not accepted. Check your connection and try again.');

  // ---- bookings
  ProBooking _booking(Object? a) => parseProBooking(a) ?? (throw const SiteException('We could not read the answer. Look at your booking before trying again.'));

  Future<ProBooking> booking(String id) => _rpc('pro_booking_get', {'p_booking': id}, _booking, loadFailedMessage('this booking'));

  Future<ProBooking> markDone({required String actor, required String booking}) => _rpc('pro_booking_done', {'p_actor': actor, 'p_booking': booking}, _booking, actionFailedMessage);

  Future<ProBooking> confirm(String booking) => _rpc('pro_booking_confirm', {'p_booking': booking}, _booking, actionFailedMessage);

  Future<ProBooking> openDispute({required String booking, required String reason}) => _rpc('pro_dispute_open', {'p_booking': booking, 'p_reason': reason.trim()}, _booking, 'The dispute was not opened. Check your connection and try again.');

  /// Cancels the booking; what is due back is paid back by the website. Answers the booking and how many refunds went through and how many are left for later.
  Future<({ProBooking booking, int refunded, int failed})> cancel({required String booking, String? reason}) async {
    try {
      final response = await _db.functions.invoke('cancel-pro-booking', body: {'booking_id': booking, if (_blank(reason) != null) 'reason': reason!.trim()});
      final data = response.data;
      if (data is! Map) throw const FormatException('not an object');
      final b = parseProBooking(data['booking']);
      if (b == null) throw const FormatException('no booking in the answer');
      return (booking: b, refunded: (data['refunded'] as num?)?.toInt() ?? 0, failed: (data['failed'] as num?)?.toInt() ?? 0);
    } catch (error) {
      throw siteExceptionFrom(error, generic: 'The booking was not cancelled. Check your connection and try again.');
    }
  }

  // ---- paying
  /// Starts paying the deposit (or the balance): the payment page to open. The website works out what is due now.
  Future<CheckoutStart> startPayment(String booking) async {
    try {
      final response = await _db.functions.invoke('create-pro-checkout', body: {'booking_id': booking});
      final data = response.data;
      final start = data is Map ? parseCheckoutStart({'url': data['url']}) : null;
      if (start == null) throw const FormatException('no payment page in the answer');
      return CheckoutStart(url: start.url, sessionId: data is Map && data['session_id'] is String ? data['session_id'] as String : start.sessionId);
    } catch (error) {
      throw siteExceptionFrom(error, generic: 'We could not open the payment page. Check your connection and try again.');
    }
  }

  /// Where the payment stands. The website asks Stripe itself if it has not heard yet, so this is safe to ask again and again.
  Future<({ProPayment status, ProBooking? booking})> paymentStatus(String booking) async {
    try {
      final response = await _db.functions.invoke('confirm-pro-payment', body: {'booking_id': booking});
      final read = parseProPayment(response.data);
      if (read == null) throw const FormatException('unexpected answer');
      return read;
    } catch (error) {
      throw siteExceptionFrom(error, generic: 'We could not check your payment. Check your connection and try again.');
    }
  }
}

String? _blank(String? s) => s == null || s.trim().isEmpty ? null : s.trim();
