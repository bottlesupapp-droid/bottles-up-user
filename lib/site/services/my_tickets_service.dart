import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/ticket_order.dart';
import '../site_error.dart';

/// The signed-in person's tickets (`site_orders`). The database shows a person only the orders made with their own verified e-mail address, so nothing here filters by person.
class MyTicketsService {
  MyTicketsService(this._db);

  final SupabaseClient _db;

  static const String _columns = 'id, status, quantity, amount_total_cents, currency, discount_cents, ticket_code, checked_in_at, created_at, is_non_transferable, '
      'site_ticket_tiers(name), site_events(id, title, venue_name, address, start_date, end_date, cover_image_url)';

  /// Every order that is paid or was refunded, newest first. Orders that were never paid (a checkout left half way) are not tickets and are left out.
  Future<List<TicketOrder>> orders() async {
    try {
      final rows = await _db.from('site_orders').select(_columns).inFilter('status', ['paid', 'refunded']).order('created_at', ascending: false);
      return [
        for (final r in rows)
          if (parseTicketOrder(Map<String, dynamic>.from(r)) case final o?) o,
      ];
    } catch (error) {
      logProblem('load tickets', error);
      throw SiteException(loadFailedMessage('your tickets'));
    }
  }

  /// The newest order the person made for a ticket type since [since], with where it stands: for when a payment was started and the website did not say which payment it was.
  Future<TicketOrder?> latestFor({required String eventId, required String tierId, required DateTime since}) async {
    try {
      final rows = await _db
          .from('site_orders')
          .select(_columns)
          .eq('event_id', eventId)
          .eq('tier_id', tierId)
          .gte('created_at', since.toUtc().toIso8601String())
          .order('created_at', ascending: false)
          .limit(1);
      if (rows.isEmpty) return null;
      return parseTicketOrder(Map<String, dynamic>.from(rows.first));
    } catch (error) {
      logProblem('look up the order', error);
      throw const SiteException('We could not check your payment. Check your connection and try again.');
    }
  }

  /// Sends the 6-digit entry code for a ticket that stays with its buyer to the e-mail address on the order. Returns where it was sent (partly hidden) and how long it lasts.
  Future<EntryCodeSent> requestEntryCode(String orderId) async {
    try {
      final response = await _db.functions.invoke('request-ticket-otp', body: {'order_id': orderId});
      final data = response.data;
      if (data is Map && data['success'] == true) {
        final secs = data['expires_in_seconds'];
        return EntryCodeSent(
          emailPreview: data['email_preview'] is String ? data['email_preview'] as String : 'your email',
          expiresIn: Duration(seconds: secs is num ? secs.toInt() : 300),
        );
      }
      throw const FormatException('unexpected answer');
    } catch (error) {
      throw siteExceptionFrom(error, generic: 'We could not send your entry code. Check your connection and try again.');
    }
  }
}

class EntryCodeSent {
  const EntryCodeSent({required this.emailPreview, required this.expiresIn});

  final String emailPreview;
  final Duration expiresIn;
}
