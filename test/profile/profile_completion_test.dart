import 'package:bottles_up_user/features/auth/models/country.dart';
import 'package:bottles_up_user/features/profile/logic/profile_completion.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('age', () {
    test('goes up on the birthday itself, not the day before', () {
      final dob = DateTime(2000, 6, 15);
      expect(ageOn(dob, DateTime(2026, 6, 14)), 25);
      expect(ageOn(dob, DateTime(2026, 6, 15)), 26);
      expect(ageOn(dob, DateTime(2026, 6, 16)), 26);
    });

    test('is right across a year end and for a December birthday', () {
      expect(ageOn(DateTime(2000, 12, 31), DateTime(2026, 12, 30)), 25);
      expect(ageOn(DateTime(2000, 12, 31), DateTime(2026, 12, 31)), 26);
      expect(ageOn(DateTime(2000, 1, 1), DateTime(2026, 1, 1)), 26);
      expect(ageOn(DateTime(2000, 1, 1), DateTime(2025, 12, 31)), 25);
    });

    test('a 29 February birthday counts on 1 March in a year without a 29th, like the database', () {
      final dob = DateTime(2000, 2, 29);
      expect(ageOn(dob, DateTime(2025, 2, 28)), 24);
      expect(ageOn(dob, DateTime(2025, 3, 1)), 25);
      expect(ageOn(dob, DateTime(2028, 2, 28)), 27);
      expect(ageOn(dob, DateTime(2028, 2, 29)), 28);
    });
  });

  group('date of birth', () {
    final today = DateTime(2026, 10, 29, 14, 30);

    test('nothing chosen yet', () {
      expect(dateOfBirthProblem(null, today), 'Choose your date of birth');
    });

    test('exactly 18 today is allowed; one day short is not', () {
      expect(dateOfBirthProblem(DateTime(2008, 10, 29), today), isNull);
      expect(dateOfBirthProblem(DateTime(2008, 10, 30), today), 'You must be 18 or older to use BottlesUp');
    });

    test('the time of day makes no difference', () {
      expect(dateOfBirthProblem(DateTime(2008, 10, 29, 23, 59), DateTime(2026, 10, 29, 0, 1)), isNull);
    });

    test('children, the future and impossible years are refused, with different words', () {
      expect(dateOfBirthProblem(DateTime(2015, 1, 1), today), 'You must be 18 or older to use BottlesUp');
      expect(dateOfBirthProblem(DateTime(2027, 1, 1), today), 'Your date of birth cannot be in the future');
      expect(dateOfBirthProblem(DateTime(1899, 12, 31), today), 'Please check the year of your date of birth');
      expect(dateOfBirthProblem(DateTime(1900, 1, 1), today), isNull);
    });
  });

  group('e-mail', () {
    test('accepts ordinary addresses, with spaces round them', () {
      expect(emailProblem('dana@example.com'), isNull);
      expect(emailProblem('  dana.lee+club@mail.example.co.uk '), isNull);
      expect(emailProblem('abc123@privaterelay.appleid.com'), isNull);
    });

    test('refuses empty, no @, no dot after it, two @, spaces inside', () {
      expect(emailProblem(null), 'Enter your e-mail address');
      expect(emailProblem('   '), 'Enter your e-mail address');
      for (final bad in ['dana', 'dana@', '@example.com', 'dana@example', 'dana@@example.com', 'da na@example.com', 'dana@exa mple.com']) {
        expect(emailProblem(bad), 'Enter a valid e-mail address', reason: bad);
      }
    });
  });

  group('phone number', () {
    test('7 to 15 digits, however they are written', () {
      expect(phoneProblem('416 555 0100'), isNull);
      expect(phoneProblem('(416) 555-0100'), isNull);
      expect(phoneProblem('+1 416-555-0100'), isNull);
      expect(phoneProblem('5550100'), isNull);
      expect(phoneProblem('123456789012345'), isNull);
    });

    test('empty, too short and too long are told apart', () {
      expect(phoneProblem(''), 'Enter your phone number');
      expect(phoneProblem(null), 'Enter your phone number');
      expect(phoneProblem('abc'), 'Enter your phone number');
      expect(phoneProblem('555-01'), 'That phone number is too short');
      expect(phoneProblem('555012'), 'That phone number is too short'); // 6 digits: the last one refused
      expect(phoneProblem('5550123'), isNull); // 7 digits: the first one allowed
      expect(phoneProblem('1234567890123456'), 'That phone number is too long');
    });

    test('is stored as the dialling code then the digits only', () {
      const canada = Country(name: 'Canada', code: 'CA', phoneCode: '+1');
      expect(phoneFor(canada, '(416) 555-0100'), '+14165550100');
      expect(phoneFor(supportedCountries.firstWhere((c) => c.code == 'GB'), '07700 900123'), '+4407700900123');
    });

    test('a stored number is split back for the form', () {
      final fallback = supportedCountries.first; // Canada
      expect(splitPhone('+14165550100', supportedCountries, fallback), (country: fallback, national: '4165550100'));
      final gb = supportedCountries.firstWhere((c) => c.code == 'GB');
      expect(splitPhone('+447700900123', supportedCountries, fallback), (country: gb, national: '7700900123'));
      final inCountry = supportedCountries.firstWhere((c) => c.code == 'IN');
      expect(splitPhone('+919876543210', supportedCountries, fallback), (country: inCountry, national: '9876543210'));
    });

    test('the default country is kept for a number that fits it, even when it is not the first in the list', () {
      final us = supportedCountries.firstWhere((c) => c.code == 'US');
      expect(splitPhone('+14165550100', supportedCountries, us), (country: us, national: '4165550100'));
    });

    test('the longest dialling code that fits wins, not the first', () {
      const canada = Country(name: 'Canada', code: 'CA', phoneCode: '+1');
      const bahamas = Country(name: 'Bahamas', code: 'BS', phoneCode: '+1242');
      const list = [canada, bahamas];
      expect(splitPhone('+12425550100', list, canada), (country: bahamas, national: '5550100'));
      expect(splitPhone('+14165550100', list, canada), (country: canada, national: '4165550100'));
      expect(splitPhone('+12425550100', const [bahamas, canada], canada), (country: bahamas, national: '5550100'));
    });

    test('digits that look like a dialling code are not read as one when there is no +', () {
      final fallback = supportedCountries.first;
      expect(splitPhone('14165550100', supportedCountries, fallback), (country: fallback, national: '14165550100'));
      expect(splitPhone('447700900123', supportedCountries, fallback), (country: fallback, national: '447700900123'));
    });

    test('a number with no + is read in the default country, and one with an unknown code keeps all its digits', () {
      final fallback = supportedCountries.first;
      expect(splitPhone('416-555-0100', supportedCountries, fallback), (country: fallback, national: '4165550100'));
      expect(splitPhone(null, supportedCountries, fallback), (country: fallback, national: ''));
      expect(splitPhone('+99912345678', supportedCountries, fallback), (country: fallback, national: '99912345678'));
    });
  });

  group('the date as the database takes it', () {
    test('writes and reads a plain date', () {
      expect(dateToIso(DateTime(1990, 6, 5)), '1990-06-05');
      expect(dateFromIso('1990-06-05'), DateTime(1990, 6, 5));
      expect(dateFromIso('1990-06-05T00:00:00+00:00'), DateTime(1990, 6, 5));
    });

    test('anything else is no date', () {
      for (final bad in [null, '', 'soon', 42, '1990-06', '19900605xx', 'aaaa-bb-cc']) {
        expect(dateFromIso(bad), isNull, reason: '$bad');
      }
    });

    test('is shown with the month in words', () {
      expect(formatDate(DateTime(1990, 6, 5)), 'Jun 5, 1990');
    });
  });

  group('what is missing from a profile', () {
    final today = DateTime(2026, 10, 29);
    final grown = DateTime(1990, 6, 15);

    test('a full profile is complete', () {
      final d = ProfileDetails(exists: true, email: 'a@b.co', phone: '+14165550100', dateOfBirth: grown);
      expect(profileGaps(d, today).complete, isTrue);
    });

    test('nothing at all (no row): everything but the sign-in e-mail is missing', () {
      final g = profileGaps(const ProfileDetails(sessionEmail: 'a@b.co'), today);
      expect((g.email, g.phone, g.dateOfBirth), (false, true, true));
      expect(g.complete, isFalse);
    });

    test('a phone sign-up has no e-mail anywhere', () {
      final g = profileGaps(ProfileDetails(exists: true, phone: '+14165550100', dateOfBirth: grown), today);
      expect((g.email, g.phone, g.dateOfBirth), (true, false, false));
    });

    test('the e-mail of the sign-in stands in for a blank one on the profile', () {
      final d = ProfileDetails(exists: true, email: '  ', sessionEmail: 'relay@privaterelay.appleid.com', phone: '+14165550100', dateOfBirth: grown);
      expect(d.knownEmail, 'relay@privaterelay.appleid.com');
      expect(profileGaps(d, today).complete, isTrue);
    });

    test('the profile\'s own e-mail wins over the sign-in\'s', () {
      expect(const ProfileDetails(email: 'mine@b.co', sessionEmail: 'other@b.co').knownEmail, 'mine@b.co');
    });

    test('an old profile with a phone and an age but no date of birth is incomplete', () {
      final g = profileGaps(const ProfileDetails(exists: true, email: 'a@b.co', phone: '416-555-0100'), today);
      expect((g.email, g.phone, g.dateOfBirth), (false, false, true));
    });

    test('a nonsense phone number counts as missing', () {
      expect(profileGaps(ProfileDetails(exists: true, email: 'a@b.co', phone: '123', dateOfBirth: grown), today).phone, isTrue);
    });

    test('a date of birth that makes the person under 18 counts as missing', () {
      expect(profileGaps(ProfileDetails(exists: true, email: 'a@b.co', phone: '+14165550100', dateOfBirth: DateTime(2015, 1, 1)), today).dateOfBirth, isTrue);
    });
  });
}
