import 'package:bottles_up_user/features/profile/widgets/date_of_birth_field.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final today = DateTime(2026, 10, 29, 14, 30);

  Future<List<({DateTime initial, DateTime first, DateTime last})>> pump(WidgetTester tester, {DateTime? initialValue, DateTime? picks, bool enabled = true}) async {
    final asked = <({DateTime initial, DateTime first, DateTime last})>[];
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Form(
          child: DateOfBirthField(
            initialValue: initialValue,
            enabled: enabled,
            picker: (context, initial, first, last) async {
              asked.add((initial: initial, first: first, last: last));
              return picks;
            },
          ),
        ),
      ),
    ));
    return asked;
  }

  testWidgets('offers every day from 1900 up to today and no later, opening 25 years back', (tester) async {
    await withClock(Clock.fixed(today), () async {
      final asked = await pump(tester, picks: DateTime(1990, 6, 15, 9, 0));
      await tester.tap(find.byKey(const Key('dob-field')));
      await tester.pump();
      expect(asked, hasLength(1));
      expect(asked.single.first, DateTime(1900));
      expect(asked.single.last, DateTime(2026, 10, 29));
      expect(asked.single.initial, DateTime(2001, 10, 29));
    });
  });

  testWidgets('shows the day chosen without its time, and the age it makes', (tester) async {
    await withClock(Clock.fixed(today), () async {
      await pump(tester, picks: DateTime(1990, 6, 15, 9, 0));
      expect(find.byKey(const Key('dob-age')), findsNothing);
      await tester.tap(find.byKey(const Key('dob-field')));
      await tester.pump();
      expect(tester.widget<Text>(find.byKey(const Key('dob-value'))).data, 'Jun 15, 1990');
      expect(tester.widget<Text>(find.byKey(const Key('dob-age'))).data, 'Age: 36');
    });
  });

  testWidgets('reopens on the day already chosen, and cancelling keeps it', (tester) async {
    await withClock(Clock.fixed(today), () async {
      final asked = await pump(tester, initialValue: DateTime(1985, 3, 2), picks: null);
      await tester.tap(find.byKey(const Key('dob-field')));
      await tester.pump();
      expect(asked.single.initial, DateTime(1985, 3, 2));
      expect(tester.widget<Text>(find.byKey(const Key('dob-value'))).data, 'Mar 2, 1985');
    });
  });

  testWidgets('does not open while disabled (a save is under way)', (tester) async {
    await withClock(Clock.fixed(today), () async {
      final asked = await pump(tester, enabled: false, picks: DateTime(1990, 6, 15));
      await tester.tap(find.byKey(const Key('dob-field')));
      await tester.pump();
      expect(asked, isEmpty);
    });
  });
}
