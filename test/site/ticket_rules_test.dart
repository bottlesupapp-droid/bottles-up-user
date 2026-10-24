import 'package:bottles_up_user/site/models/site_event.dart';
import 'package:bottles_up_user/site/rules/ticket_rules.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';

TicketTier tier({int price = 5000, int capacity = 100, int sold = 20, bool code = false, String name = 'General'}) => parseTicketTier(tierRow(price: price, capacity: capacity, sold: sold, code: code, name: name))!;

String? check({TicketTier? t, bool unlocked = false, int quantity = 1, String name = 'Dana Door', String email = 'dana@example.com', String phone = ''}) =>
    validateTicketOrder(tier: t ?? tier(), unlocked: unlocked, quantity: quantity, name: name, email: email, phone: phone);

void main() {
  group('what blocks a ticket type', () {
    test('sold out beats everything, then a missing code', () {
      expect(tierBlock(tier(sold: 100), unlocked: true), TierBlock.soldOut);
      expect(tierBlock(tier(code: true), unlocked: false), TierBlock.needsCode);
      expect(tierBlock(tier(code: true), unlocked: true), isNull);
      expect(tierBlock(tier(), unlocked: false), isNull);
      expect(tierBlock(tier(code: true, sold: 100), unlocked: false), TierBlock.soldOut);
    });
  });

  group('how many', () {
    test('is what is left, and never more than one order allows', () {
      expect(maxQuantityFor(tier(capacity: 100, sold: 0)), maxTicketsPerOrder);
      expect(maxQuantityFor(tier(capacity: 100, sold: 0)), 10);
      expect(maxQuantityFor(tier(capacity: 10, sold: 7)), 3);
      expect(maxQuantityFor(tier(capacity: 10, sold: 10)), 0);
    });

    test('scarcity is said when it is getting low', () {
      expect(scarcityLabel(tier(capacity: 100, sold: 0)), isNull);
      expect(scarcityLabel(tier(capacity: 100, sold: 90)), 'Only 10 left');
      expect(scarcityLabel(tier(capacity: 100, sold: 99)), 'Only 1 left');
      expect(scarcityLabel(tier(capacity: 100, sold: 100)), 'Sold out');
      expect(scarcityLabel(tier(capacity: 100, sold: 89)), isNull);
    });
  });

  group('what it costs', () {
    test('is the price times the number, less a discount, never below nothing', () {
      final t = tier(price: 5000);
      expect(subtotalCents(t, 3), 15000);
      expect(totalCents(t, 3, 500), 14500);
      expect(totalCents(t, 1, 99999), 0);
      expect(orderLine(t, 2), '2 × General · \$100.00');
      expect(orderLine(tier(price: 0, name: 'Free Entry'), 2), '2 × Free Entry · Free');
    });
  });

  group('checking an order before it is sent', () {
    test('a good order has nothing wrong', () {
      expect(check(), isNull);
      expect(check(quantity: 10, phone: '+1 555 0100'), isNull);
      expect(check(t: tier(code: true), unlocked: true), isNull);
    });

    test('no ticket type, sold out and locked ones say so', () {
      expect(validateTicketOrder(tier: null, unlocked: false, quantity: 1, name: 'Dana', email: 'a@b.co', phone: ''), 'Choose a ticket type.');
      expect(check(t: tier(sold: 100, name: 'VIP')), 'VIP is sold out.');
      expect(check(t: tier(code: true, name: 'Invited')), 'Enter the access code for Invited.');
    });

    test('the number is between one and what is left', () {
      expect(check(quantity: 0), 'Choose between 1 and 10 tickets.');
      expect(check(quantity: 11), 'Choose between 1 and 10 tickets.');
      expect(check(t: tier(capacity: 10, sold: 7), quantity: 4), 'Choose between 1 and 3 tickets.');
      expect(check(t: tier(capacity: 10, sold: 9), quantity: 2), 'Only 1 ticket is left.');
    });

    test('a name is needed, and not one letter, and not a novel', () {
      expect(check(name: ''), 'Enter your name (at least 2 letters).');
      expect(check(name: ' X '), 'Enter your name (at least 2 letters).');
      expect(check(name: 'A' * 121), 'That name is too long.');
      expect(check(name: 'A' * 120), isNull);
    });

    test('the account\'s e-mail must be a real address (it is where the tickets go)', () {
      for (final bad in ['', 'nope', 'a@b', 'a b@c.com', '@c.com']) {
        expect(check(email: bad), 'Your account needs a valid email address to send the tickets to.', reason: bad);
      }
    });

    test('a phone number is optional and not endless', () {
      expect(check(phone: ''), isNull);
      expect(check(phone: '1' * 40), isNull);
      expect(check(phone: '1' * 41), 'That phone number is too long.');
    });

    test('the first problem is the one given, in the order the form is read', () {
      expect(validateTicketOrder(tier: null, unlocked: false, quantity: 0, name: '', email: '', phone: ''), 'Choose a ticket type.');
      expect(check(quantity: 0, name: ''), 'Choose between 1 and 10 tickets.');
      expect(check(name: '', email: 'bad'), 'Enter your name (at least 2 letters).');
    });
  });
}
