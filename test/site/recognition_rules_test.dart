import 'package:bottles_up_user/site/models/recognition.dart';
import 'package:bottles_up_user/site/rules/recognition_rules.dart';
import 'package:flutter_test/flutter_test.dart';

PlaqueAddress address({String recipient = 'Ann Lee', String line1 = '1 King St', String? line2, String city = 'Toronto', String? region, String postal = 'M5V 1A1', String country = 'Canada', String? phone}) =>
    PlaqueAddress(recipient: recipient, line1: line1, line2: line2, city: city, region: region, postal: postal, country: country, phone: phone);

void main() {
  group('a note sent with a request to be verified', () {
    test('is up to five hundred characters, counted without the spaces round it', () {
      expect(checkVerificationNote(null), isNull);
      expect(checkVerificationNote('x' * 500), isNull);
      expect(checkVerificationNote('  ${'x' * 500}  '), isNull);
      expect(checkVerificationNote('x' * 501), 'Keep it to 500 characters.');
      expect(maxVerificationNoteLength, 500);
    });
  });

  group('a delivery address', () {
    test('needs a name, a street, a city, a postal code and a country', () {
      expect(checkPlaqueAddress(address()), isNull);
      expect(checkPlaqueAddress(address(recipient: 'A')), 'Write the name for the parcel (2 to 80 characters).');
      expect(checkPlaqueAddress(address(line1: '12')), 'Write the street address (3 to 120 characters).');
      expect(checkPlaqueAddress(address(city: 'T')), 'Write the city (2 to 80 characters).');
      expect(checkPlaqueAddress(address(postal: 'M')), 'Write the postal code (2 to 20 characters).');
      expect(checkPlaqueAddress(address(country: 'C')), 'Write the country (2 to 60 characters).');
    });

    test('has limits on the lengths, counted without the spaces round them', () {
      expect(checkPlaqueAddress(address(recipient: 'An', line1: 'Abc', city: 'To', postal: 'M5', country: 'Ca')), isNull);
      expect(checkPlaqueAddress(address(recipient: 'n' * 80, line1: 'l' * 120, line2: 'm' * 120, city: 'c' * 80, region: 'r' * 80, postal: 'p' * 20, country: 'k' * 60, phone: '1' * 30)), isNull);
      expect(checkPlaqueAddress(address(recipient: 'n' * 81)), 'Write the name for the parcel (2 to 80 characters).');
      expect(checkPlaqueAddress(address(line1: 'l' * 121)), 'Write the street address (3 to 120 characters).');
      expect(checkPlaqueAddress(address(line2: 'm' * 121)), 'Keep the second address line to 120 characters.');
      expect(checkPlaqueAddress(address(city: 'c' * 81)), 'Write the city (2 to 80 characters).');
      expect(checkPlaqueAddress(address(region: 'r' * 81)), 'Keep the province or state to 80 characters.');
      expect(checkPlaqueAddress(address(postal: 'p' * 21)), 'Write the postal code (2 to 20 characters).');
      expect(checkPlaqueAddress(address(country: 'k' * 61)), 'Write the country (2 to 60 characters).');
      expect(checkPlaqueAddress(address(phone: '1' * 31)), 'Keep the phone number to 30 characters.');
      expect(checkPlaqueAddress(address(recipient: '  A  ')), 'Write the name for the parcel (2 to 80 characters).');
    });
  });

  group('followers in words', () {
    test('with commas', () {
      expect(followersText(0), '0');
      expect(followersText(999), '999');
      expect(followersText(1000), '1,000');
      expect(followersText(100000), '100,000');
      expect(followersText(100000000), '100,000,000');
    });

    test('in a few characters', () {
      expect(shortFollowers(100000), '100K');
      expect(shortFollowers(1000000), '1M');
      expect(shortFollowers(50000000), '50M');
      expect(shortFollowers(100000000), '100M');
      expect(shortFollowers(1500000), '1,500,000');
      expect(shortFollowers(1500), '1,500');
      expect(shortFollowers(999), '999');
      expect(shortFollowers(1000), '1K');
    });
  });

  group('what a badge means', () {
    final byKey = {for (final l in proposedRanks) l.key: l};
    test('the first is about who the profile is', () {
      expect(rankExplanation(byKey['verified']!), 'BottlesUp checked that this profile belongs to who it says it does.');
    });

    test('the others say how many genuine followers, and that it is earned', () {
      expect(rankExplanation(byKey['elite']!), 'Verified, and 100K genuine followers. BottlesUp looks at the followers before it awards this rank. Ranks are earned, never bought.');
      expect(rankExplanation(byKey['icon']!), startsWith('Verified, and 1M genuine followers.'));
    });
  });

  group('finding a level', () {
    test('by its key in the website\'s list, or in the client\'s plan', () {
      const custom = [RankLevel(key: 'elite', name: 'Rising', minFollowers: 5, colour: 0xFF000000)];
      expect(levelFor('elite', custom)!.name, 'Rising');
      expect(levelFor('icon', custom)!.name, 'Icon');
      expect(levelFor('elite', const [])!.name, 'Elite');
      expect(levelFor('nope', const []), isNull);
      expect(levelFor(null, custom), isNull);
    });
  });

  group('progress', () {
    test('goes from nothing to everything and never past it', () {
      expect(progressTowards(0, 100), 0);
      expect(progressTowards(25, 100), 0.25);
      expect(progressTowards(100, 100), 1);
      expect(progressTowards(150, 100), 1);
      expect(progressTowards(-5, 100), 0);
      expect(progressTowards(5, 0), 1);
    });
  });
}
