import 'package:bottles_up_user/features/jobs/widgets/apply_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ({String message, String? link})? answer;
  var answered = false;

  setUp(() {
    answer = null;
    answered = false;
  });

  Future<void> openSheet(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            key: const Key('open'),
            onPressed: () async {
              answer = await showApplySheet(context, jobTitle: 'Weekend bartender', asName: 'Bob Ray');
              answered = true;
            },
            child: const Text('open'),
          ),
        ),
      ),
    ));
    await tester.tap(find.byKey(const Key('open')));
    await tester.pumpAndSettle();
  }

  testWidgets('an application without a link answers with no link at all, not an empty one', (tester) async {
    await openSheet(tester);
    await tester.enterText(find.byKey(const Key('apply-message')), '  I have worked many bars in Toronto.  ');
    await tester.enterText(find.byKey(const Key('apply-link')), '   ');
    await tester.tap(find.byKey(const Key('apply-send')));
    await tester.pumpAndSettle();
    expect(answered, isTrue);
    expect(answer, (message: 'I have worked many bars in Toronto.', link: null));
  });

  testWidgets('a link is answered tidied', (tester) async {
    await openSheet(tester);
    await tester.enterText(find.byKey(const Key('apply-message')), 'I have worked many bars in Toronto.');
    await tester.enterText(find.byKey(const Key('apply-link')), ' https://example.com/me ');
    await tester.tap(find.byKey(const Key('apply-send')));
    await tester.pumpAndSettle();
    expect(answer, (message: 'I have worked many bars in Toronto.', link: 'https://example.com/me'));
  });
}
