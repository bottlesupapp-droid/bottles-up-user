import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/my_night.dart';
import '../site_error.dart';

/// The guests on a table booking, through the website's `manage-guest-tickets`: it lists them, adds guests (each gets their own ticket by e-mail, up to what the table seats) and sends
/// a ticket again. Whoever holds the booking's confirmation code can act on it, so the app sends the code of the booking the person is looking at.
class GuestPassesService {
  GuestPassesService(this._db);

  final SupabaseClient _db;

  Future<Map<String, dynamic>> _call(String code, Map<String, dynamic> body) async {
    final response = await _db.functions.invoke('manage-guest-tickets', body: {'confirmation_code': code, ...body});
    final data = response.data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw const FormatException('the website answered with something that is not an object');
  }

  Future<GuestRoster> roster(String code) async {
    try {
      final roster = parseGuestRoster(await _call(code, {'action': 'list'}));
      if (roster == null) throw const FormatException('no guest list in the answer');
      return roster;
    } catch (error) {
      throw siteExceptionFrom(error, generic: loadFailedMessage('the guest list'));
    }
  }

  /// Adds guests (a name and an e-mail each) and says, for each, whether their ticket e-mail went out.
  Future<List<GuestAddResult>> add(String code, List<({String name, String email})> guests) async {
    try {
      final data = await _call(code, {
        'action': 'add',
        'guests': [
          for (final g in guests) {'name': g.name.trim(), 'email': g.email.trim()},
        ],
      });
      final results = data['results'];
      if (data['success'] != true || results is! List) throw const FormatException('unexpected answer');
      return [
        for (final r in results)
          if (r is Map) GuestAddResult(name: '${r['guest_name'] ?? ''}', email: '${r['guest_email'] ?? ''}', sent: r['sent'] == true),
      ];
    } catch (error) {
      throw siteExceptionFrom(error, generic: 'We could not add your guests. Check your connection and try again.');
    }
  }

  Future<void> resend(String code, String guestId) async {
    try {
      final data = await _call(code, {'action': 'resend', 'guest_id': guestId});
      if (data['success'] != true) throw const FormatException('unexpected answer');
    } catch (error) {
      throw siteExceptionFrom(error, generic: 'We could not send that ticket again. Check your connection and try again.');
    }
  }
}
