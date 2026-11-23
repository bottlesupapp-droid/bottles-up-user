import 'package:bottles_up_user/site/models/site_event.dart';
import 'package:bottles_up_user/site/rules/ticket_rules.dart';
import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import '../support/fake_website.dart';

/// A ticket type with a sales window (the organizer's start and end of sales; either may be empty).
TicketTier tierWith({String? starts, String? ends, int capacity = 100, int sold = 0, bool code = false}) =>
    parseTicketTier(tierRow(capacity: capacity, sold: sold, code: code, saleStarts: starts, saleEnds: ends))!;

DateTime at(String iso) => DateTime.parse(iso);

void main() {
  group('reading the dates', () {
    test('a ticket type with no dates has none, and is on sale at any time', () {
      final t = tierWith();
      expect(t.saleStartsAt, isNull);
      expect(t.saleEndsAt, isNull);
      expect(t.salesNotOpen(at('2000-01-01T00:00:00Z')), isFalse);
      expect(t.salesClosed(at('2999-01-01T00:00:00Z')), isFalse);
    });

    test('the dates are instants, whatever zone the database wrote them in', () {
      final t = tierWith(starts: '2026-12-05T19:00:00-05:00', ends: '2026-12-10T22:00:00+00:00');
      expect(t.saleStartsAt, DateTime.utc(2026, 12, 6, 0, 0));
      expect(t.saleEndsAt, DateTime.utc(2026, 12, 10, 22, 0));
      expect(t.saleStartsAt!.isUtc, isTrue);
    });

    test('a date that cannot be read is no date (it never locks anybody out)', () {
      final t = tierWith(starts: 'garbage', ends: '');
      expect(t.saleStartsAt, isNull);
      expect(t.saleEndsAt, isNull);
      final u = parseTicketTier({...tierRow(), 'sale_starts_at': 12345, 'sale_ends_at': true})!;
      expect(u.saleStartsAt, isNull);
      expect(u.saleEndsAt, isNull);
    });

    test('rows from before the columns existed (no keys at all) still parse, on sale as always', () {
      final row = tierRow()..remove('sale_starts_at')..remove('sale_ends_at');
      final t = parseTicketTier(row)!;
      expect(t.saleStartsAt, isNull);
      expect(tierBlock(t, unlocked: true), isNull);
    });
  });

  group('the window: the start is included, the end is not', () {
    final t = tierWith(starts: '2026-12-05T19:00:00Z', ends: '2026-12-10T22:00:00Z');

    test('before the start sales have not opened', () {
      expect(t.salesNotOpen(at('2026-12-05T18:59:59Z')), isTrue);
      expect(tierBlock(t, unlocked: true, now: at('2026-12-05T18:59:59Z')), TierBlock.notYetOnSale);
    });

    test('at the very moment sales start the type is on sale', () {
      expect(t.salesNotOpen(at('2026-12-05T19:00:00Z')), isFalse);
      expect(tierBlock(t, unlocked: true, now: at('2026-12-05T19:00:00Z')), isNull);
    });

    test('in between it is on sale, and a moment before the end still', () {
      expect(tierBlock(t, unlocked: true, now: at('2026-12-07T12:00:00Z')), isNull);
      expect(tierBlock(t, unlocked: true, now: at('2026-12-10T21:59:59Z')), isNull);
    });

    test('at the very moment sales end the type is closed, and stays closed', () {
      expect(t.salesClosed(at('2026-12-10T22:00:00Z')), isTrue);
      expect(tierBlock(t, unlocked: true, now: at('2026-12-10T22:00:00Z')), TierBlock.saleEnded);
      expect(tierBlock(t, unlocked: true, now: at('2027-06-01T00:00:00Z')), TierBlock.saleEnded);
    });
  });

  group('what blocks a type, in order', () {
    const closed = '2026-12-01T00:00:00Z';
    final now = at('2026-12-07T12:00:00Z');

    test('the sales window comes before sold out, and sold out before a missing code', () {
      expect(tierBlock(tierWith(ends: closed, sold: 100), unlocked: false, now: now), TierBlock.saleEnded);
      expect(tierBlock(tierWith(starts: '2026-12-20T00:00:00Z', sold: 100), unlocked: false, now: now), TierBlock.notYetOnSale);
      expect(tierBlock(tierWith(sold: 100, code: true), unlocked: false, now: now), TierBlock.soldOut);
      expect(tierBlock(tierWith(code: true), unlocked: false, now: now), TierBlock.needsCode);
      expect(tierBlock(tierWith(ends: closed, code: true), unlocked: true, now: now), TierBlock.saleEnded, reason: 'a code does not reopen a closed sale');
    });

    test('uses the app\'s clock when no moment is given', () {
      final t = tierWith(starts: '2026-12-05T19:00:00Z', ends: '2026-12-10T22:00:00Z');
      withClock(Clock.fixed(at('2026-12-01T00:00:00Z')), () => expect(tierBlock(t, unlocked: true), TierBlock.notYetOnSale));
      withClock(Clock.fixed(at('2026-12-07T00:00:00Z')), () => expect(tierBlock(t, unlocked: true), isNull));
      withClock(Clock.fixed(at('2026-12-11T00:00:00Z')), () => expect(tierBlock(t, unlocked: true), TierBlock.saleEnded));
    });

    test('which blocks stop a purchase: the sale window and sold out, not "needs a code" (the person can fix that on the spot)', () {
      expect(blocksPurchase(TierBlock.notYetOnSale), isTrue);
      expect(blocksPurchase(TierBlock.saleEnded), isTrue);
      expect(blocksPurchase(TierBlock.soldOut), isTrue);
      expect(blocksPurchase(TierBlock.needsCode), isFalse);
      expect(blocksPurchase(null), isFalse);
    });
  });

  group('what the person is told', () {
    final now = at('2026-12-01T00:00:00Z');

    test('nothing for a type that is on sale', () {
      expect(saleLabel(tierWith(), now: now), isNull);
      expect(saleLabel(tierWith(ends: '2026-12-10T22:00:00Z'), now: now), isNull);
    });

    test('"Sales ended" after the end', () {
      expect(saleLabel(tierWith(ends: '2026-11-30T22:00:00Z'), now: now), 'Sales ended');
    });

    test('when sales open, in the phone\'s own time', () {
      final t = tierWith(starts: '2026-12-05T19:00:00Z');
      final expected = DateFormat('MMM d, h:mm a').format(t.saleStartsAt!.toLocal());
      expect(saleLabel(t, now: now), 'On sale from $expected');
      expect(saleLabel(t, now: now), startsWith('On sale from '));
    });

    test('an order for a closed type is refused with a sentence that names it', () {
      final ended = tierWith(ends: '2026-11-30T22:00:00Z');
      final soon = tierWith(starts: '2026-12-05T19:00:00Z');
      String? check(TicketTier t) => validateTicketOrder(tier: t, unlocked: true, quantity: 1, name: 'Dana Door', email: 'dana@example.com', phone: '', now: now);
      expect(check(ended), 'Sales of General have ended.');
      expect(check(soon), 'Sales of General have not opened yet.');
      expect(check(tierWith(ends: '2026-12-10T22:00:00Z')), isNull);
    });
  });
}
