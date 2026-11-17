import 'package:bottles_up_user/core/startup_problem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('the settings a build is given', () {
    test('there is no problem when both are there', () {
      expect(missingSettingsProblem(supabaseUrl: 'https://x.supabase.co', supabaseAnonKey: 'eyJabc'), isNull);
    });

    test('names what is missing', () {
      expect(missingSettingsProblem(supabaseUrl: '', supabaseAnonKey: 'eyJabc'), 'This copy of the app was built without its settings (SUPABASE_URL).');
      expect(missingSettingsProblem(supabaseUrl: 'https://x.supabase.co', supabaseAnonKey: ''), 'This copy of the app was built without its settings (SUPABASE_ANON_KEY).');
      expect(missingSettingsProblem(supabaseUrl: '', supabaseAnonKey: ''), 'This copy of the app was built without its settings (SUPABASE_URL and SUPABASE_ANON_KEY).');
    });

    test('a value of only spaces is missing', () {
      expect(missingSettingsProblem(supabaseUrl: '   ', supabaseAnonKey: ' '), contains('SUPABASE_URL and SUPABASE_ANON_KEY'));
    });
  });

  testWidgets('the screen says the app could not start, in words, with the reason', (tester) async {
    await tester.pumpWidget(const StartupProblemApp(detail: 'This copy of the app was built without its settings (SUPABASE_URL).'));
    expect(find.byKey(const Key('startup-problem')), findsOneWidget);
    expect(find.text('BottlesUp could not start'), findsOneWidget);
    expect(find.textContaining('install the latest version'), findsOneWidget);
    expect(tester.widget<SelectableText>(find.byKey(const Key('startup-problem-detail'))).data, 'This copy of the app was built without its settings (SUPABASE_URL).');
  });
}
