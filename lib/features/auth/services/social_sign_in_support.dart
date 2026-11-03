import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// A random value for one Apple sign-in. Apple puts its hash inside the token it hands back and Supabase checks the plain value against that hash, so a token taken from somewhere else
/// cannot be used to sign in here.
String newNonce([Random? random, int length = 32]) {
  const alphabet = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._';
  final r = random ?? Random.secure();
  return List.generate(length, (_) => alphabet[r.nextInt(alphabet.length)]).join();
}

String sha256Hex(String input) => sha256.convert(utf8.encode(input)).toString();

/// Whether a failed sign-in is only the person closing the Google or Apple sheet. That is not an error to show.
bool isSignInCancelled(Object error) {
  final text = error.toString().toLowerCase();
  return text.contains('cancelled') || text.contains('canceled');
}

/// The name Apple gives, only the first time a person uses it with an app (later sign-ins carry none). Null when it gave none.
String? appleFullName(String? given, String? family) {
  final name = [given, family].whereType<String>().map((s) => s.trim()).where((s) => s.isNotEmpty).join(' ');
  return name.isEmpty ? null : name;
}

/// The name for a new `profiles` row: what the sign-in gave, else the part of the e-mail before the @, else "User".
String profileNameFor({String? fullName, String? name, String? email}) {
  for (final candidate in [fullName, name]) {
    if (candidate != null && candidate.trim().isNotEmpty) return candidate.trim();
  }
  final local = email?.split('@').first.trim();
  return local == null || local.isEmpty ? 'User' : local;
}
