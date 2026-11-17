import 'package:bottles_up_user/site/models/split.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';

void main() {
  group('a share\'s state', () {
    test('every word the website uses is known, with a label', () {
      for (final w in ['unpaid', 'pending', 'paid', 'refunding', 'refunded', 'expired', 'cancelled', 'declined']) {
        final s = ShareState.fromWire(w);
        expect(s, isNotNull, reason: w);
        expect(s!.wire, w);
        expect(s.label, isNotEmpty);
      }
    });

    test('a word it has not seen is not one it knows', () {
      for (final w in ['bogus', '', null, 5, 'PAID']) {
        expect(ShareState.fromWire(w), isNull, reason: '$w');
      }
    });

    test('only an unpaid or started share can be paid; the money is taken once it is paid, being paid back or paid back', () {
      expect([for (final s in ShareState.values) if (s.canPay) s], [ShareState.unpaid, ShareState.pending]);
      expect([for (final s in ShareState.values) if (s.taken) s], [ShareState.paid, ShareState.refunding, ShareState.refunded]);
    });
  });

  group('the host\'s plan', () {
    test('is read with its shares, in order', () {
      final plan = parseSplitPlan(splitPlanRow(collected: 3000, outstanding: 5000, shares: [shareLineRow(id: 'a', status: 'paid', paidAt: '2099-11-02T10:00:00Z'), shareLineRow(id: 'b', amount: 7000, payer: profileRow(id: 'p-cy', handle: 'cy', name: 'Cy Rus'))]))!;
      expect(plan.id, 'sp1');
      expect(plan.bookingId, 'bk1');
      expect(plan.state, SplitState.open);
      expect(plan.deadline.toUtc(), DateTime.utc(2099, 11, 5, 22));
      expect(plan.currency, 'cad');
      expect(plan.balanceCents, 20000);
      expect(plan.collectedCents, 3000);
      expect(plan.outstandingCents, 5000);
      expect([for (final s in plan.shares) s.id], ['a', 'b']);
      expect(plan.shares.first.state, ShareState.paid);
      expect(plan.shares.first.paidAt!.toUtc(), DateTime.utc(2099, 11, 2, 10));
      expect(plan.shares.last.payer!.displayName, 'Cy Rus');
      expect(plan.totalAskedCents, 12000);
      expect(plan.canCancel, isTrue);
      expect(plan.isCancelled, isFalse);
    });

    test('a cancelled plan cannot be cancelled again', () {
      final plan = parseSplitPlan(splitPlanRow(state: 'cancelled'))!;
      expect(plan.isCancelled, isTrue);
      expect(plan.canCancel, isFalse);
    });

    test('every state the website gives is known', () {
      for (final s in ['open', 'complete', 'expired', 'cancelled']) {
        expect(parseSplitPlan(splitPlanRow(state: s))!.state.wire, s);
      }
      expect(parseSplitPlan(splitPlanRow(state: 'bogus')), isNull);
    });

    test('a share it cannot read is dropped, the others stay', () {
      final row = splitPlanRow();
      row['shares'] = <Object>[
        shareLineRow(id: 'ok'),
        {'id': 'no-amount', 'status': 'unpaid'},
        shareLineRow(id: 'zero', amount: 0),
        shareLineRow(id: 'odd', status: 'bogus'),
        {'amount_cents': 100, 'status': 'unpaid'},
        'not a map',
      ];
      final plan = parseSplitPlan(row)!;
      expect([for (final s in plan.shares) s.id], ['ok']);
    });

    test('a friend whose account is gone is a share with nobody on it', () {
      final plan = parseSplitPlan(splitPlanRow(shares: [shareLineRow(id: 'gone', payer: const <String, dynamic>{})]))!;
      expect(plan.shares.single.payer, isNull);
    });

    test('without an id, a booking, a known state or a deadline it is nothing', () {
      for (final key in ['id', 'booking_id', 'deadline']) {
        final row = splitPlanRow()..remove(key);
        expect(parseSplitPlan(row), isNull, reason: key);
      }
      expect(parseSplitPlan(null), isNull);
      expect(parseSplitPlan('x'), isNull);
      expect(parseSplitPlan(<Object>[]), isNull);
    });

    test('missing numbers are nothing owed rather than a crash', () {
      final row = splitPlanRow()..remove('balance_cents')..remove('collected_cents')..remove('outstanding_cents')..remove('currency')..remove('shares')..remove('created_at');
      final plan = parseSplitPlan(row)!;
      expect([plan.balanceCents, plan.collectedCents, plan.outstandingCents, plan.currency, plan.shares.length, plan.createdAt], [0, 0, 0, 'cad', 0, null]);
    });
  });

  group('a friend\'s request', () {
    test('is read: only the venue, the night, the host\'s first name and the amount', () {
      final r = parseShareRequest(shareRequestRow(paidAt: '2099-11-02T10:00:00Z', state: 'paid'))!;
      expect([r.id, r.state, r.amountCents, r.currency, r.host, r.venue], ['sh1', ShareState.paid, 5000, 'cad', 'Ann', 'Club A']);
      expect(r.deadline.toUtc(), DateTime.utc(2099, 11, 5, 22));
      expect(r.paidAt!.toUtc(), DateTime.utc(2099, 11, 2, 10));
      expect(r.bookingDate, DateTime(2099, 11, 6));
    });

    test('the night is the day and the time together, or the day alone, or nothing', () {
      expect(parseShareRequest(shareRequestRow(time: '22:00'))!.night, 'Fri, Nov 6 · 10:00 PM');
      expect(parseShareRequest(shareRequestRow(time: '22:00:00'))!.night, 'Fri, Nov 6 · 10:00 PM');
      expect(parseShareRequest(shareRequestRow(time: 'late'))!.night, 'Fri, Nov 6');
      expect(parseShareRequest(shareRequestRow()..['start_time'] = null)!.night, 'Fri, Nov 6');
      expect(parseShareRequest(shareRequestRow()..['booking_date'] = null)!.night, '');
    });

    test('a missing host is "A friend"', () {
      expect(parseShareRequest(shareRequestRow()..['host'] = null)!.host, 'A friend');
    });

    test('a row without what it needs is dropped from the list, the rest stay', () {
      final list = parseShareRequests([
        shareRequestRow(id: 'a'),
        shareRequestRow(id: 'b', state: 'bogus'),
        shareRequestRow(id: 'c', amount: 0),
        shareRequestRow(id: 'd')..remove('venue'),
        shareRequestRow(id: 'e')..remove('deadline'),
        'x',
        shareRequestRow(id: 'f'),
      ]);
      expect([for (final r in list) r.id], ['a', 'f']);
      expect(parseShareRequests(null), isEmpty);
      expect(parseShareRequests({'a': 1}), isEmpty);
    });
  });

  group('how a started payment stands', () {
    test('each word the website says is read', () {
      for (final s in SharePayment.values) {
        expect(parseSharePayment({'status': s.name}), s);
      }
    });

    test('anything else is nothing', () {
      for (final j in [null, 'paid', <String, dynamic>{}, {'status': 'bogus'}, {'status': 5}]) {
        expect(parseSharePayment(j), isNull, reason: '$j');
      }
    });
  });
}
