import 'dart:math';

import 'package:bottles_up_user/features/auth/services/social_sign_in_support.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('nonce', () {
    test('is 32 characters from the safe alphabet by default', () {
      final nonce = newNonce();
      expect(nonce.length, 32);
      expect(RegExp(r'^[0-9A-Za-z\-._]+$').hasMatch(nonce), isTrue);
    });

    test('has the length asked for', () {
      expect(newNonce(Random(1), 8).length, 8);
      expect(newNonce(Random(1), 64).length, 64);
    });

    test('is different each time and follows the random source it is given', () {
      expect(newNonce(), isNot(newNonce()));
      expect(newNonce(Random(7)), newNonce(Random(7)));
      expect(newNonce(Random(7)), isNot(newNonce(Random(8))));
    });

    test('uses the whole alphabet, not a few letters', () {
      final seen = <String>{};
      final random = Random(3);
      for (var i = 0; i < 200; i++) {
        seen.addAll(newNonce(random).split(''));
      }
      expect(seen.length, 65);
    });
  });

  group('sha256Hex', () {
    test('matches the published test values', () {
      expect(sha256Hex('abc'), 'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad');
      expect(sha256Hex(''), 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855');
    });

    test('is 64 lower-case hex characters', () {
      expect(RegExp(r'^[0-9a-f]{64}$').hasMatch(sha256Hex(newNonce())), isTrue);
    });
  });

  group('isSignInCancelled', () {
    test('recognises both spellings in the sentences the sign-ins throw', () {
      expect(isSignInCancelled('Google sign-in was cancelled'), isTrue);
      expect(isSignInCancelled('Apple Sign In was cancelled'), isTrue);
      expect(isSignInCancelled(Exception('The user canceled the request')), isTrue);
      expect(isSignInCancelled('CANCELLED'), isTrue);
    });

    test('does not hide real failures', () {
      expect(isSignInCancelled('Network error. Please check your internet connection.'), isFalse);
      expect(isSignInCancelled('Apple Sign In failed. Please try again.'), isFalse);
      expect(isSignInCancelled(''), isFalse);
    });
  });

  group('appleFullName', () {
    test('joins the given and family name', () {
      expect(appleFullName('Dana', 'Lee'), 'Dana Lee');
    });

    test('keeps whichever one there is', () {
      expect(appleFullName('Dana', null), 'Dana');
      expect(appleFullName(null, 'Lee'), 'Lee');
      expect(appleFullName('  Dana ', ' '), 'Dana');
    });

    test('is null when Apple gave no name (every sign-in after the first)', () {
      expect(appleFullName(null, null), isNull);
      expect(appleFullName('', '  '), isNull);
    });
  });

  group('profileNameFor', () {
    test('prefers the full name, then the name', () {
      expect(profileNameFor(fullName: 'Dana Lee', name: 'dana', email: 'd@x.com'), 'Dana Lee');
      expect(profileNameFor(name: 'Dana', email: 'd@x.com'), 'Dana');
      expect(profileNameFor(fullName: '  ', name: 'Dana'), 'Dana');
    });

    test('falls back to the part of the e-mail before the @', () {
      expect(profileNameFor(email: 'dana.lee@example.com'), 'dana.lee');
    });

    test('ends at "User" when there is nothing', () {
      expect(profileNameFor(), 'User');
      expect(profileNameFor(email: ''), 'User');
      expect(profileNameFor(email: '@example.com'), 'User');
    });

    test('trims the name it uses', () {
      expect(profileNameFor(fullName: '  Dana Lee  '), 'Dana Lee');
    });
  });
}
