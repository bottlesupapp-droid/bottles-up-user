import 'package:bottles_up_user/site/models/hiring.dart';
import 'package:bottles_up_user/site/models/social_profile.dart';
import 'package:bottles_up_user/site/rules/hiring_rules.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';

void main() {
  final today = DateTime(2099, 10, 25, 15, 30);

  group('the smallest deposit', () {
    test('is a tenth, rounded up', () {
      expect(minDepositCents(100000), 10000);
      expect(minDepositCents(100005), 10001);
      expect(minDepositCents(1000), 100);
      expect(minDepositCents(1001), 101);
    });
  });

  group('checking a request', () {
    String? check({DateTime? date, String message = 'A birthday night', int? guests, int? budget}) => checkRequest(date: date ?? DateTime(2099, 11, 8), message: message, today: today, guests: guests, budgetCents: budget);

    test('a good one passes', () {
      expect(check(), isNull);
      expect(check(guests: 100000, budget: 0), isNull);
      expect(check(budget: 50000000), isNull);
    });

    test('the date is between tomorrow and two years away', () {
      const said = 'Choose a date between tomorrow and two years from now.';
      expect(check(date: DateTime(2099, 10, 25)), said);
      expect(check(date: DateTime(2099, 10, 24)), said);
      expect(checkRequest(date: null, message: 'abc', today: today), said);
      expect(check(date: DateTime(2099, 10, 26)), isNull);
      expect(check(date: DateTime(2101, 10, 25)), isNull);
      expect(check(date: DateTime(2101, 10, 26)), said);
    });

    test('the message is 3 to 1000 characters once trimmed', () {
      const said = 'Tell them about the job in 3 to 1000 characters.';
      expect(check(message: 'ab'), said);
      expect(check(message: '  ab  '), said);
      expect(check(message: 'abc'), isNull);
      expect(check(message: 'm' * 1000), isNull);
      expect(check(message: 'm' * 1001), said);
    });

    test('guests and budget have limits', () {
      expect(check(guests: 0), 'Choose a number of guests between 1 and 100,000.');
      expect(check(guests: 100001), 'Choose a number of guests between 1 and 100,000.');
      expect(check(budget: -1), 'Choose a budget between 0 and 500,000.00.');
      expect(check(budget: 50000001), 'Choose a budget between 0 and 500,000.00.');
    });
  });

  group('checking a quote', () {
    final job = DateTime(2099, 11, 8);
    String? check({int? total = 100000, int? deposit = 30000, DateTime? due, String scope = 'Four hours of music', int? days = 5, bool dueGiven = true}) => checkQuote(
          totalCents: total,
          depositCents: deposit,
          balanceDueBy: dueGiven ? (due ?? DateTime(2099, 11, 1)) : null,
          scope: scope,
          validDays: days,
          eventDate: job,
          today: today,
        );

    test('a good one passes', () {
      expect(check(), isNull);
      expect(check(deposit: 100000, dueGiven: false), isNull);
    });

    test('the total is 10.00 to 50,000.00', () {
      const said = 'Choose a total between 10.00 and 50,000.00.';
      expect(check(total: null), said);
      expect(check(total: 999, deposit: 100), said);
      expect(check(total: 5000001, deposit: 500001), said);
      expect(check(total: 1000, deposit: 100), isNull);
      expect(check(total: 5000000, deposit: 500000), isNull);
    });

    test('the deposit is a tenth to the whole', () {
      expect(check(deposit: null), contains('at least a tenth of the total (\$1,000.00'.replaceFirst('\$1,000.00', '\$100.00')));
      expect(check(deposit: 9999), contains('at least a tenth'));
      expect(check(deposit: 10000), isNull);
      expect(check(deposit: 100001), contains('no more than the total'));
      expect(check(total: 100005, deposit: 10000), contains('(\$100.01)'));
      expect(check(total: 100005, deposit: 10001), isNull);
    });

    test('a balance has a date before the job and not in the past', () {
      const said = 'The balance must be due before the date of the job.';
      expect(check(dueGiven: false), said);
      expect(check(due: DateTime(2099, 10, 24)), said);
      expect(check(due: DateTime(2099, 11, 8)), said);
      expect(check(due: DateTime(2099, 11, 9)), said);
      expect(check(due: DateTime(2099, 10, 25)), isNull);
      expect(check(due: DateTime(2099, 11, 7)), isNull);
    });

    test('the scope is 10 to 1500 characters', () {
      const said = 'Say what is included in 10 to 1500 characters.';
      expect(check(scope: '123456789'), said);
      expect(check(scope: '1234567890'), isNull);
      expect(check(scope: 's' * 1500), isNull);
      expect(check(scope: 's' * 1501), said);
      expect(check(scope: '   short   '), said);
    });

    test('a quote is open for 1 to 14 days', () {
      const said = 'A quote can stay open for 1 to 14 days.';
      expect(check(days: null), said);
      expect(check(days: 0), said);
      expect(check(days: 15), said);
      expect(check(days: 1), isNull);
      expect(check(days: 14), isNull);
    });
  });

  group('a dispute\'s reason', () {
    test('is 10 to 1000 characters', () {
      const said = 'Say what went wrong in 10 to 1000 characters.';
      expect(checkReason('123456789'), said);
      expect(checkReason('   123456789   '), said);
      expect(checkReason('1234567890'), isNull);
      expect(checkReason('r' * 1000), isNull);
      expect(checkReason('r' * 1001), said);
    });
  });

  group('what cancelling means', () {
    ProBooking b({int paid = 100000, int deposit = 30000, String date = '2099-11-08', int free = 7}) => parseProBooking(proBookingRow(paid: paid, deposit: deposit, date: date, freeDays: free))!;

    test('nothing paid, nothing charged', () {
      expect(cancelPolicyText(b(paid: 0), asProvider: false, today: today), 'Nothing has been paid, so nothing is charged.');
      expect(cancelPolicyText(b(paid: 0), asProvider: true, today: today), 'Nothing has been paid, so nothing is charged.');
    });

    test('the professional pays everything back', () {
      expect(cancelPolicyText(b(date: '2099-10-26'), asProvider: true, today: today), 'Everything the customer paid (\$1,000.00) is paid back to them.');
    });

    test('the customer cancelling early is paid back, late loses the deposit', () {
      expect(cancelPolicyText(b(date: '2099-11-01'), asProvider: false, today: today), 'Everything you paid (\$1,000.00) is paid back to you.');
      final late = cancelPolicyText(b(date: '2099-10-31'), asProvider: false, today: today);
      expect(late, contains('less than 7 days away'));
      expect(late, contains('\$300.00 (the deposit, at least 30% of the price) is kept'));
      expect(late, contains('\$700.00 is paid back'));
    });

    test('the free days are the booking\'s own', () {
      expect(cancelPolicyText(b(date: '2099-10-31', free: 5), asProvider: false, today: today), contains('paid back to you'));
      expect(cancelPolicyText(b(date: '2099-10-28', free: 5), asProvider: false, today: today), contains('less than 5 days away'));
    });
  });

  group('the day of the job', () {
    ProBooking b(String date) => parseProBooking(proBookingRow(date: date))!;

    test('has come on the day and after, not before', () {
      expect(jobDayHasCome(b('2099-10-26'), today), isFalse);
      expect(jobDayHasCome(b('2099-10-25'), today), isTrue);
      expect(jobDayHasCome(b('2099-10-24'), today), isTrue);
    });

    test('a dispute is open from the day until seven days after', () {
      expect(canDispute(b('2099-10-26'), today), isFalse);
      expect(canDispute(b('2099-10-25'), today), isTrue);
      expect(canDispute(b('2099-10-18'), today), isTrue);
      expect(canDispute(b('2099-10-17'), today), isFalse);
    });
  });

  group('checking a service', () {
    test('a name of 3 to 80 characters once trimmed', () {
      const said = 'Give the service a name of 3 to 80 characters.';
      expect(checkService(title: 'ab'), said);
      expect(checkService(title: '  ab  '), said);
      expect(checkService(title: 'abc'), isNull);
      expect(checkService(title: 'a' * 80), isNull);
      expect(checkService(title: 'a' * 81), said);
    });

    test('the description, the price note and the price have limits', () {
      expect(checkService(title: 'abc', description: 'd' * 1000), isNull);
      expect(checkService(title: 'abc', description: 'd' * 1001), 'Keep the description to 1000 characters.');
      expect(checkService(title: 'abc', priceNote: 'n' * 80), isNull);
      expect(checkService(title: 'abc', priceNote: 'n' * 81), 'Keep the price note to 80 characters.');
      expect(checkService(title: 'abc', fromCents: 0), isNull);
      expect(checkService(title: 'abc', fromCents: 5000000), isNull);
      expect(checkService(title: 'abc', fromCents: 5000001), 'Choose a price between 0 and 50,000.00.');
      expect(checkService(title: 'abc', fromCents: -1), 'Choose a price between 0 and 50,000.00.');
    });

    test('twenty services is the most a profile lists', () {
      expect(maxServices, 20);
    });
  });

  group('who can be hired', () {
    SocialProfile profile({String kind = 'business', String? category = 'dj', String status = 'active'}) => parseSocialProfile(profileRow(id: 'x', kind: kind, handle: 'x', name: 'X', category: category, status: status))!;

    test('a business profile that is not a venue or an event group', () {
      for (final c in ['dj', 'mc', 'artist', 'instrumentalist', 'photographer', 'videographer', 'influencer', 'promoter', 'other']) {
        expect(isProfessional(profile(category: c)), isTrue, reason: c);
      }
      expect(isProfessional(profile(category: 'venue')), isFalse);
      expect(isProfessional(profile(category: 'event_group')), isFalse);
      expect(isProfessional(profile(category: null)), isFalse);
      expect(isProfessional(profile(kind: 'personal', category: null)), isFalse);
      expect(isProfessional(profile(kind: 'personal')), isFalse);
      expect(isProfessional(profile(status: 'suspended')), isFalse);
    });
  });
}
