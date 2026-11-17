import 'package:bottles_up_user/features/auth/models/country.dart';

/// The youngest age at which someone may use BottlesUp. The database enforces the same number (profiles_age_check), so a profile under it can never be saved.
const minimumAge = 18;

/// The part of a date that counts: no time of day.
DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Whole years from [dateOfBirth] to [today]. The age goes up on the birthday itself (a 29 February birthday on 1 March in a year with no 29th), which is how the database counts it.
int ageOn(DateTime dateOfBirth, DateTime today) {
  var years = today.year - dateOfBirth.year;
  if (today.month < dateOfBirth.month || (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) years--;
  return years;
}

/// What is wrong with a date of birth, in words for the person; null when it is fine.
String? dateOfBirthProblem(DateTime? dateOfBirth, DateTime today) {
  if (dateOfBirth == null) return 'Choose your date of birth';
  final dob = dateOnly(dateOfBirth);
  if (dob.isAfter(dateOnly(today))) return 'Your date of birth cannot be in the future';
  if (dob.year < 1900) return 'Please check the year of your date of birth';
  if (ageOn(dob, today) < minimumAge) return 'You must be $minimumAge or older to use BottlesUp';
  return null;
}

final _emailShape = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

String? emailProblem(String? value) {
  final v = value?.trim() ?? '';
  if (v.isEmpty) return 'Enter your e-mail address';
  if (!_emailShape.hasMatch(v)) return 'Enter a valid e-mail address';
  return null;
}

/// Only the digits of what was typed ("(416) 555-0100" and "416 555 0100" are the same number).
String digitsOf(String? value) => (value ?? '').replaceAll(RegExp(r'\D'), '');

/// A phone number is checked for being plausible, not for being real: 7 to 15 digits (the longest an international number can be).
String? phoneProblem(String? value) {
  final digits = digitsOf(value);
  if (digits.isEmpty) return 'Enter your phone number';
  if (digits.length < 7) return 'That phone number is too short';
  if (digits.length > 15) return 'That phone number is too long';
  return null;
}

/// The number as it is stored: the country's dialling code, then the digits typed (the same shape the sign-up form has always written).
String phoneFor(Country country, String typed) => '${country.phoneCode}${digitsOf(typed)}';

/// A stored number split back into a country and the rest, for the form. A number with a "+" takes the longest dialling code that fits; one without is read in [fallback]'s country.
({Country country, String national}) splitPhone(String? stored, List<Country> countries, Country fallback) {
  final text = (stored ?? '').trim();
  if (!text.startsWith('+')) return (country: fallback, national: digitsOf(text));
  final digits = digitsOf(text);
  Country? best;
  for (final c in countries) {
    final code = digitsOf(c.phoneCode);
    if (digits.startsWith(code) && (best == null || code.length > digitsOf(best.phoneCode).length)) best = c;
  }
  if (best == null) return (country: fallback, national: digits);
  // "+1" is both Canada and the United States: keep the fallback when it fits, so a Canadian stays Canadian.
  final chosen = best.phoneCode == fallback.phoneCode ? fallback : best;
  return (country: chosen, national: digits.substring(digitsOf(best.phoneCode).length));
}

const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

String formatDate(DateTime d) => '${_months[d.month - 1]} ${d.day}, ${d.year}';

/// The date as the database takes it (a plain date, no time zone).
String dateToIso(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

DateTime? dateFromIso(Object? value) {
  if (value is! String || value.length < 10) return null;
  final parts = value.substring(0, 10).split('-');
  if (parts.length != 3) return null;
  final y = int.tryParse(parts[0]), m = int.tryParse(parts[1]), d = int.tryParse(parts[2]);
  if (y == null || m == null || d == null) return null;
  return DateTime(y, m, d);
}

/// What the app knows about a customer's profile: the saved row, and the e-mail the sign-in itself gave.
class ProfileDetails {
  const ProfileDetails({this.exists = false, this.name, this.email, this.phone, this.dateOfBirth, this.sessionEmail, this.sessionName});

  /// Whether a row in `profiles` exists at all (many accounts, made by Apple, Google or a phone number, have none).
  final bool exists;
  final String? name;
  final String? email;
  final String? phone;
  final DateTime? dateOfBirth;

  /// The e-mail and name the sign-in gave (Apple's may be a private relay address; a phone sign-up has none).
  final String? sessionEmail;
  final String? sessionName;

  /// The e-mail to use: the profile's, else the sign-in's. Null when there is none.
  String? get knownEmail {
    for (final candidate in [email, sessionEmail]) {
      final v = candidate?.trim();
      if (v != null && v.isNotEmpty) return v;
    }
    return null;
  }
}

/// What is still missing before a profile counts as complete: an e-mail, a phone number, and a date of birth that makes the person old enough.
class ProfileGaps {
  const ProfileGaps({required this.email, required this.phone, required this.dateOfBirth});

  final bool email;
  final bool phone;
  final bool dateOfBirth;

  bool get complete => !email && !phone && !dateOfBirth;
}

ProfileGaps profileGaps(ProfileDetails details, DateTime today) => ProfileGaps(
      email: emailProblem(details.knownEmail) != null,
      phone: phoneProblem(details.phone) != null,
      dateOfBirth: dateOfBirthProblem(details.dateOfBirth, today) != null,
    );
