import 'package:bottles_up_user/site/models/hire.dart';
import 'package:bottles_up_user/site/rules/hire_rules.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/hire_fixtures.dart';

void main() {
  final today = DateTime(2099, 10, 25, 15, 30);

  group('checking a request to a venue', () {
    String? check({DateTime? date, String type = 'Themed night', String? hours, int? attendance, String? space, String? equipment, String? staffing, int? budget, String? notes}) =>
        checkHireRequest(date: date ?? DateTime(2099, 11, 8), eventType: type, today: today, hours: hours, attendance: attendance, space: space, equipment: equipment, staffing: staffing, budgetCents: budget, notes: notes);

    test('a good one passes, with every extra at its limit', () {
      expect(check(), isNull);
      expect(check(hours: 'h' * 60, attendance: 100000, space: 's' * 160, equipment: 'e' * 300, staffing: 'f' * 300, budget: 100000000, notes: 'n' * 1000), isNull);
      expect(check(attendance: 1, budget: 0), isNull);
    });

    test('the date is between tomorrow and two years away', () {
      const said = 'Choose a date between tomorrow and two years from now.';
      expect(check(date: DateTime(2099, 10, 25)), said);
      expect(check(date: DateTime(2099, 10, 24)), said);
      expect(checkHireRequest(date: null, eventType: 'abc', today: today), said);
      expect(check(date: DateTime(2099, 10, 26)), isNull);
      expect(check(date: DateTime(2101, 10, 25)), isNull);
      expect(check(date: DateTime(2101, 10, 26)), said);
    });

    test('the kind of event is 2 to 80 characters once trimmed', () {
      const said = 'Say what kind of event it is in 2 to 80 characters.';
      expect(check(type: 'x'), said);
      expect(check(type: '  x  '), said);
      expect(check(type: 'xy'), isNull);
      expect(check(type: 'x' * 80), isNull);
      expect(check(type: 'x' * 81), said);
    });

    test('every extra has its own limit and its own sentence', () {
      expect(check(hours: 'h' * 61), 'Keep the hours to 60 characters.');
      expect(check(attendance: 0), 'Choose an expected attendance between 1 and 100,000.');
      expect(check(attendance: 100001), 'Choose an expected attendance between 1 and 100,000.');
      expect(check(space: 's' * 161), 'Keep the space to 160 characters.');
      expect(check(equipment: 'e' * 301), 'Keep the equipment to 300 characters.');
      expect(check(staffing: 'f' * 301), 'Keep the staffing to 300 characters.');
      expect(check(budget: -1), 'Choose a budget between 0 and 1,000,000.00.');
      expect(check(budget: 100000001), 'Choose a budget between 0 and 1,000,000.00.');
      expect(check(notes: 'n' * 1001), 'Keep the special requests to 1000 characters.');
    });
  });

  group('checking an offer', () {
    String? check({int? rental = 450000, int? deposit = 100000, int? sales = 300000, int? bar = 2000, HireControl? control = HireControl.shared, int? days = 7, String? staffing, String? equipment, String? cancellation, String? notes}) => checkOffer(
          rentalCents: rental,
          depositCents: deposit,
          minSalesCents: sales,
          barShareBps: bar,
          control: control,
          validDays: days,
          staffing: staffing,
          equipment: equipment,
          cancellation: cancellation,
          notes: notes,
        );

    test('a good one passes, at its limits', () {
      expect(check(), isNull);
      expect(check(rental: 0, deposit: 0, sales: 0, bar: 0, days: 1), isNull);
      expect(check(rental: 100000000, deposit: 100000000, sales: 100000000, bar: 10000, days: 14, staffing: 's' * 300, equipment: 'e' * 300, cancellation: 'c' * 600, notes: 'n' * 1000), isNull);
    });

    test('the money has limits', () {
      expect(check(rental: null), 'Choose a rental cost between 0 and 1,000,000.00.');
      expect(check(rental: -1), 'Choose a rental cost between 0 and 1,000,000.00.');
      expect(check(rental: 100000001, deposit: 0), 'Choose a rental cost between 0 and 1,000,000.00.');
      expect(check(deposit: null), 'The deposit cannot be more than the rental cost.');
      expect(check(deposit: -1), 'The deposit cannot be more than the rental cost.');
      expect(check(deposit: 450001), 'The deposit cannot be more than the rental cost.');
      expect(check(sales: null), 'Choose a minimum sales figure between 0 and 1,000,000.00.');
      expect(check(sales: -1), 'Choose a minimum sales figure between 0 and 1,000,000.00.');
      expect(check(sales: 100000001), 'Choose a minimum sales figure between 0 and 1,000,000.00.');
    });

    test('the bar share is 0 to 100 percent', () {
      expect(check(bar: null), 'Choose a bar share between 0% and 100%.');
      expect(check(bar: -1), 'Choose a bar share between 0% and 100%.');
      expect(check(bar: 10001), 'Choose a bar share between 0% and 100%.');
    });

    test('somebody controls the sales, and the offer stays open for 1 to 14 days', () {
      expect(check(control: null), 'Say who controls tickets and tables.');
      expect(check(days: null), 'An offer can stay open for 1 to 14 days.');
      expect(check(days: 0), 'An offer can stay open for 1 to 14 days.');
      expect(check(days: 15), 'An offer can stay open for 1 to 14 days.');
    });

    test('the words have limits', () {
      expect(check(staffing: 's' * 301), 'Keep the staffing to 300 characters.');
      expect(check(equipment: 'e' * 301), 'Keep the equipment to 300 characters.');
      expect(check(cancellation: 'c' * 601), 'Keep the cancellation terms to 600 characters.');
      expect(check(notes: 'n' * 1001), 'Keep the notes to 1000 characters.');
    });
  });

  group('a bar share typed as a percentage', () {
    test('is read in basis points', () {
      expect(parseBarShareBps('20'), 2000);
      expect(parseBarShareBps(' 20% '), 2000);
      expect(parseBarShareBps('12.5'), 1250);
      expect(parseBarShareBps('7,5'), 750);
      expect(parseBarShareBps('0'), 0);
      expect(parseBarShareBps('100'), 10000);
      expect(parseBarShareBps('0.01'), 1);
      expect(parseBarShareBps('0.29'), 29, reason: '0.29 * 100 is 28.999999999999996: the percentage is rounded, not cut');
      expect(parseBarShareBps('4.35'), 435);
    });

    test('is nothing when it is not a share', () {
      expect(parseBarShareBps(''), isNull);
      expect(parseBarShareBps('   '), isNull);
      expect(parseBarShareBps('lots'), isNull);
      expect(parseBarShareBps('-1'), isNull);
      expect(parseBarShareBps('100.01'), isNull);
      expect(parseBarShareBps('101'), isNull);
      expect(parseBarShareBps('NaN'), isNull);
    });
  });

  group('checking a task or a schedule item', () {
    String? check({bool schedule = false, String title = 'Send the lineup', String? at, DateTime? due}) => checkHireItem(schedule: schedule, title: title, today: today, atTime: at, dueOn: due);

    test('a title of 2 to 120 characters', () {
      const said = 'Give it a title of 2 to 120 characters.';
      expect(check(title: 'x'), said);
      expect(check(title: '  x  '), said);
      expect(check(title: 'xy'), isNull);
      expect(check(title: 'x' * 120), isNull);
      expect(check(title: 'x' * 121), said);
    });

    test('a schedule item has a time of day, "HH:MM"', () {
      expect(check(schedule: true, title: 'Doors open'), 'Say what time it is.');
      expect(check(schedule: true, title: 'Doors open', at: '9pm'), 'Say what time it is.');
      expect(check(schedule: true, title: 'Doors open', at: '24:00'), 'Say what time it is.');
      expect(check(schedule: true, title: 'Doors open', at: '21:60'), 'Say what time it is.');
      expect(check(schedule: true, title: 'Doors open', at: '21:00'), isNull);
      expect(check(schedule: true, title: 'Doors open', at: '00:00'), isNull);
      expect(check(schedule: true, title: 'Doors open', at: '23:59'), isNull);
      expect(check(schedule: true, title: 'Doors open', at: '09:30'), isNull);
    });

    test('a task may have a due day, from today to two years away', () {
      const said = 'Choose a due date from today to two years from now.';
      expect(check(due: DateTime(2099, 10, 24)), said);
      expect(check(due: DateTime(2099, 10, 25)), isNull);
      expect(check(due: DateTime(2101, 10, 25)), isNull);
      expect(check(due: DateTime(2101, 10, 26)), said);
      expect(check(), isNull);
    });

    test('a schedule item has no due day to check', () {
      expect(check(schedule: true, title: 'Doors open', at: '21:00', due: DateTime(2000)), isNull);
    });
  });

  group('what can still be done to a hire', () {
    Hire hire(String state, {String date = '2099-11-08'}) => parseHire(hireRow(state: state, date: date), HireSide.organizer)!;

    test('an agreed or confirmed hire can be cancelled before its day', () {
      expect(canCancelHire(hire('agreed'), today), isTrue);
      expect(canCancelHire(hire('confirmed'), today), isTrue);
      expect(canCancelHire(hire('agreed', date: '2099-10-26'), today), isTrue);
      expect(canCancelHire(hire('agreed', date: '2099-10-25'), today), isFalse);
      expect(canCancelHire(hire('confirmed', date: '2099-10-24'), today), isFalse);
      for (final s in ['requested', 'offered', 'offer_expired', 'declined', 'withdrawn', 'cancelled', 'lapsed', 'completed']) {
        expect(canCancelHire(hire(s), today), isFalse, reason: s);
      }
    });

    test('a hire that is not agreed yet can be answered or withdrawn', () {
      expect([for (final s in HireState.values) if (isHireOpen(hire(s.wire))) s.wire], ['requested', 'offered', 'offer_expired']);
    });
  });

  group('times of day', () {
    test('are said in twelve hours', () {
      expect(timeText('00:00'), '12:00 AM');
      expect(timeText('09:05'), '9:05 AM');
      expect(timeText('11:59'), '11:59 AM');
      expect(timeText('12:00'), '12:00 PM');
      expect(timeText('13:30'), '1:30 PM');
      expect(timeText('21:00'), '9:00 PM');
      expect(timeText('23:59'), '11:59 PM');
      expect(timeText('nonsense'), 'nonsense');
      expect(timeText('xx:30'), 'xx:30');
    });

    test('are written as two digits', () {
      expect(hhmm(9, 5), '09:05');
      expect(hhmm(21, 0), '21:00');
      expect(hhmm(0, 0), '00:00');
    });
  });
}
