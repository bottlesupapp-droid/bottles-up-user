import 'package:bottles_up_user/features/auth/services/social_sign_in_support.dart';
import 'package:bottles_up_user/features/profile/logic/profile_completion.dart';
import 'package:clock/clock.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Another account already uses that e-mail address (the e-mail on a profile is unique).
class EmailTakenException implements Exception {
  const EmailTakenException();
}

/// The database refused the date of birth because it makes the person younger than the minimum age (its rule on profiles.age). The app checks first, so this is only seen when the
/// two disagree about the day (the database counts in UTC, the phone in local time, on a 18th birthday).
class UnderAgeException implements Exception {
  const UnderAgeException();
}

/// Reads and completes the signed-in customer's row in `profiles`: e-mail, phone number and date of birth.
class ProfileCompletionService {
  ProfileCompletionService(this._db);

  final SupabaseClient _db;

  User _user() {
    final user = _db.auth.currentUser;
    if (user == null) throw StateError('Not signed in');
    return user;
  }

  Future<ProfileDetails> load() async {
    final user = _user();
    final row = await _db.from('profiles').select('name, email, phone_number, date_of_birth').eq('id', user.id).maybeSingle();
    final meta = user.userMetadata;
    return ProfileDetails(
      exists: row != null,
      name: row?['name'] as String?,
      email: row?['email'] as String?,
      phone: row?['phone_number'] as String?,
      dateOfBirth: dateFromIso(row?['date_of_birth']),
      sessionEmail: user.email,
      sessionName: (meta?['full_name'] ?? meta?['name']) as String?,
    );
  }

  /// Saves the three details. A person who has a row keeps everything else on it (name, picture); one who has none gets a row made, as the sign-in itself would have. The e-mail is written
  /// only when the row has none: an e-mail that came with the sign-in is never replaced from here.
  Future<void> save({required String email, required String phone, required DateTime dateOfBirth}) async {
    final user = _user();
    final current = await load();
    final wanted = current.knownEmail ?? email.trim();
    final values = <String, dynamic>{
      'phone_number': phone,
      'date_of_birth': dateToIso(dateOfBirth),
      // The database works the age out from the date; sending it too keeps the row right even where that trigger is not in place yet.
      'age': ageOn(dateOfBirth, clock.now()),
    };
    try {
      if (current.exists) {
        if ((current.email ?? '').trim().isEmpty) values['email'] = wanted;
        final saved = await _db.from('profiles').update(values).eq('id', user.id).select('id');
        if (saved.isEmpty) throw StateError('The profile could not be updated');
      } else {
        await _db.from('profiles').insert({
          ...values,
          'id': user.id,
          'email': wanted,
          'name': profileNameFor(fullName: current.sessionName, email: wanted),
        });
      }
    } on PostgrestException catch (e) {
      if (e.code == '23505') throw const EmailTakenException();
      if (e.code == '23514' && e.message.contains('profiles_age_check')) throw const UnderAgeException();
      rethrow;
    }
  }
}
