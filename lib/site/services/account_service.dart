import 'package:supabase_flutter/supabase_flutter.dart';

import '../site_error.dart';

/// The signed-in person's own account. Deleting goes through the website's `delete-account` function: it works out who is asking from the session (never from anything the app sends),
/// and removes the sign-in and everything that hangs off it. Their orders stay on record, with no name attached.
class AccountService {
  AccountService(this._db);

  final SupabaseClient _db;

  Future<void> deleteAccount() async {
    try {
      final response = await _db.functions.invoke('delete-account');
      final data = response.data;
      if (data is! Map || data['success'] != true) throw const FormatException('unexpected answer');
    } catch (error) {
      throw siteExceptionFrom(error, generic: 'We could not delete your account. Check your connection and try again.');
    }
    // The sign-in no longer exists on the server, so this only clears what the phone kept.
    try {
      await _db.auth.signOut(scope: SignOutScope.local);
    } catch (error) {
      logProblem('clear the session after deleting the account', error);
    }
  }
}
