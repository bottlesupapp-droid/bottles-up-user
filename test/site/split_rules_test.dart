import 'package:bottles_up_user/site/rules/split_rules.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('sharing equally', () {
    test('the balance is divided between the friends and the host, rounded down to the cent', () {
      expect(equalShares(balanceCents: 20000, friends: 3), [5000, 5000, 5000]);
      expect(equalShares(balanceCents: 20000, friends: 1), [10000]);
      expect(equalShares(balanceCents: 20001, friends: 3), [5000, 5000, 5000]);
      expect(equalShares(balanceCents: 10000, friends: 2), [3333, 3333]);
    });

    test('the host\'s part and the odd cents are never asked of a friend', () {
      for (final balance in [9999, 10000, 12345, 77777]) {
        for (final friends in [1, 2, 3, 7, 19]) {
          final shares = equalShares(balanceCents: balance, friends: friends);
          final asked = shares.fold<int>(0, (s, a) => s + a);
          expect(asked, lessThanOrEqualTo(balance - balance ~/ (friends + 1)), reason: '$balance / $friends');
          expect(shares.length, friends);
        }
      }
    });

    test('no friends or nothing to share is nothing', () {
      expect(equalShares(balanceCents: 20000, friends: 0), isEmpty);
      expect(equalShares(balanceCents: 0, friends: 3), isEmpty);
      expect(equalShares(balanceCents: -5, friends: 3), isEmpty);
    });
  });

  group('checking the amounts', () {
    test('good amounts pass, up to the cent of what is left', () {
      expect(checkShares(amounts: [5000, 5000], balanceCents: 10000), isNull);
      expect(checkShares(amounts: [500], balanceCents: 500), isNull);
      expect(checkShares(amounts: [for (var i = 0; i < 20; i++) 500], balanceCents: 10000), isNull);
    });

    test('nobody chosen', () {
      expect(checkShares(amounts: [], balanceCents: 10000), 'Choose at least one friend.');
    });

    test('more than twenty friends', () {
      expect(checkShares(amounts: [for (var i = 0; i < 21; i++) 500], balanceCents: 100000), 'A split can have up to 20 friends.');
    });

    test('under five dollars, over five thousand', () {
      expect(checkShares(amounts: [499], balanceCents: 10000), 'The smallest share is \$5.00.');
      expect(checkShares(amounts: [5000, 100], balanceCents: 10000), 'The smallest share is \$5.00.');
      expect(checkShares(amounts: [500001], balanceCents: 900000), 'The largest share is \$5,000.00.');
      expect(checkShares(amounts: [500000], balanceCents: 900000), isNull);
    });

    test('adding up to more than what is left says what is left', () {
      expect(checkShares(amounts: [5000, 5001], balanceCents: 10000), 'The shares add up to more than what is left to pay (\$100.00).');
    });
  });

  group('what a person types', () {
    test('whole dollars, dollars and cents, with or without a dollar sign or thousands comma', () {
      expect(parseAmountCents('25'), 2500);
      expect(parseAmountCents('25.5'), 2550);
      expect(parseAmountCents('25.50'), 2550);
      expect(parseAmountCents('\$25.05'), 2505);
      expect(parseAmountCents(' 1,250 '), 125000);
      expect(parseAmountCents('0.99'), 99);
      expect(parseAmountCents('0'), 0);
    });

    test('anything else is not an amount', () {
      for (final t in ['', ' ', 'abc', '12.345', '-5', '1e3', '5.', '.5', '25 dollars', '12345678', '1.2.3']) {
        expect(parseAmountCents(t), isNull, reason: t);
      }
    });
  });

  group('the deadlines offered', () {
    final now = DateTime(2099, 11, 1, 12);
    final arrival = DateTime(2099, 11, 6, 22);

    test('two hours, a day, six hours before arrival and arrival itself, earliest first', () {
      final o = deadlineOptions(now: now, arrival: arrival);
      expect([for (final x in o) x.label], ['In 2 hours', 'In 24 hours', '6 hours before you arrive', 'When you arrive']);
      expect(o.first.at, now.add(const Duration(hours: 2)));
      expect(o.last.at, arrival);
      for (var i = 1; i < o.length; i++) {
        expect(o[i].at.isAfter(o[i - 1].at), isTrue);
      }
    });

    test('each choice is at the time it says', () {
      final o = {for (final x in deadlineOptions(now: now, arrival: arrival)) x.label: x.at};
      expect(o['In 2 hours'], now.add(const Duration(hours: 2)));
      expect(o['In 24 hours'], now.add(const Duration(hours: 24)));
      expect(o['6 hours before you arrive'], arrival.subtract(const Duration(hours: 6)));
      expect(o['When you arrive'], arrival);
    });

    test('without a known arrival only the near ones', () {
      expect([for (final x in deadlineOptions(now: now)) x.label], ['In 2 hours', 'In 24 hours']);
    });

    test('nothing sooner than an hour, nothing later than 14 days or after the booking is over', () {
      // arrival in 90 minutes: "6 hours before" is in the past, "when you arrive" is fine, and so is 2 hours; 24 hours is after the night is over (12 hours after arrival)
      final soon = deadlineOptions(now: now, arrival: now.add(const Duration(minutes: 90)));
      expect([for (final x in soon) x.label], ['When you arrive', 'In 2 hours']);
      // arrival 40 days away: only what is within 14 days
      final far = deadlineOptions(now: now, arrival: now.add(const Duration(days: 40)));
      expect([for (final x in far) x.label], ['In 2 hours', 'In 24 hours']);
      // a booking that began 10 hours ago is over in 2 hours less a minute, so even "in 2 hours" is too late: nothing
      expect(deadlineOptions(now: now, arrival: now.subtract(const Duration(hours: 10))), isEmpty);
      // ...and one that began 9 hours 30 minutes ago leaves room for "in 2 hours" only
      expect([for (final x in deadlineOptions(now: now, arrival: now.subtract(const Duration(hours: 9, minutes: 30)))) x.label], ['In 2 hours']);
      // a booking that began 11 hours 30 minutes ago leaves less than an hour: nothing
      expect(deadlineOptions(now: now, arrival: now.subtract(const Duration(hours: 11, minutes: 30))), isEmpty);
    });

    test('nothing is offered more than 14 days away', () {
      final o = deadlineOptions(now: now, arrival: now.add(const Duration(days: 14, hours: 1)));
      expect([for (final x in o) x.label], ['In 2 hours', 'In 24 hours', '6 hours before you arrive']);
      expect(o.last.at.isBefore(now.add(const Duration(days: 14))), isTrue);
    });

    test('two choices that fall on the same instant are offered once', () {
      final o = deadlineOptions(now: now, arrival: now.add(const Duration(hours: 2)));
      expect({for (final x in o) x.at}.length, o.length);
    });

    test('the website\'s limits are kept to the minute', () {
      // exactly an hour is refused by the website ("at least an hour from now" is measured at its own moment), so it is not offered
      expect(deadlineOptions(now: now, arrival: now.add(const Duration(hours: 1))).where((o) => o.label == 'When you arrive'), isEmpty);
      expect(deadlineOptions(now: now, arrival: now.add(const Duration(hours: 1, minutes: 2))).where((o) => o.label == 'When you arrive'), isNotEmpty);
    });
  });
}
