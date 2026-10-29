import 'dart:async';

import 'package:bottles_up_user/features/profile/screens/complete_profile_screen.dart';
import 'package:bottles_up_user/routing/profile_gate.dart';
import 'package:bottles_up_user/site/providers/site_providers.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';

void main() {
  late FakeWebsite site;
  late ProfileGate gate;
  late StreamController<Object?> authEvents;
  final today = DateTime(2026, 10, 29, 12);

  setUp(() async {
    site = FakeWebsite();
    await site.signIn(id: 'u1', email: 'dana@example.com', metadata: {'name': 'Dana Lee'});
    authEvents = StreamController<Object?>.broadcast();
    gate = ProfileGate(currentUserId: () => 'u1', authChanges: authEvents.stream, isComplete: () async => false);
  });

  tearDown(() async {
    gate.dispose();
    await authEvents.close();
  });

  Map<String, dynamic> row({String? email = 'dana@example.com', String? phone, String? dob}) => {'name': 'Dana Lee', 'email': email, 'phone_number': phone, 'date_of_birth': dob};

  Future<GoRouter> open(WidgetTester tester, {String? redirect, Size size = const Size(800, 2200), String initial = '/complete-profile'}) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      initialLocation: initial,
      routes: [
        GoRoute(path: '/complete-profile', builder: (_, __) => CompleteProfileScreen(redirectTo: redirect)),
        GoRoute(path: '/home', builder: (_, __) => const Scaffold(body: Text('HOME', key: Key('home')))),
        GoRoute(path: '/events/:id', builder: (_, s) => Scaffold(body: Text('EVENT ${s.pathParameters['id']}', key: const Key('event')))),
      ],
    );
    await tester.pumpWidget(ProviderScope(
      overrides: [
        siteClientProvider.overrideWithValue(site.client),
        profileGateProvider.overrideWith((ref) => gate),
      ],
      child: MaterialApp.router(routerConfig: router),
    ));
    await settleCalls(tester);
    return router;
  }

  Future<void> tapKey(WidgetTester tester, String key) async {
    await tester.ensureVisible(find.byKey(Key(key)));
    await tester.tap(find.byKey(Key(key)));
    await settleCalls(tester);
  }

  /// Opens the calendar, picks [year] from the list of years, and confirms (the month and day stay as the calendar proposed them). The list opens on the year already chosen, or
  /// 25 years back from the fixed day ([from], 2001) when there is none: a year before that is found by scrolling up.
  Future<void> pickYear(WidgetTester tester, int year, {int from = 2001}) async {
    await tapKey(tester, 'dob-field');
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('$year'), year < from ? -100 : 100, scrollable: find.byType(Scrollable).last);
    await tester.ensureVisible(find.text('$year'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('$year'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
  }

  String text(WidgetTester tester, String key) => tester.widget<Text>(find.byKey(Key(key))).data!;
  String fieldText(WidgetTester tester, String key) => tester.widget<TextFormField>(find.byKey(Key(key))).controller!.text;

  testWidgets('asks for the three details, with the e-mail of the sign-in already filled in and locked', (tester) async {
    site.tables['profiles'] = [row()];
    await withClock(Clock.fixed(today), () => open(tester));
    expect(text(tester, 'cp-title'), 'Complete your profile');
    expect(fieldText(tester, 'cp-email'), 'dana@example.com');
    expect(tester.widget<TextFormField>(find.byKey(const Key('cp-email'))).enabled, isTrue);
    expect(find.text('From your sign-in'), findsOneWidget);
    expect(fieldText(tester, 'cp-phone'), '');
    expect(find.byKey(const Key('dob-age')), findsNothing);
    expect(find.byKey(const Key('cp-sign-out')), findsOneWidget);
  });

  testWidgets('nothing is saved while something is missing, and each missing thing says so', (tester) async {
    site.tables['profiles'] = [row()];
    await withClock(Clock.fixed(today), () => open(tester));
    await tapKey(tester, 'cp-save');
    expect(find.text('Enter your phone number'), findsOneWidget);
    expect(find.text('Choose your date of birth'), findsOneWidget);
    expect(site.forTable('profiles').where((r) => r.method != 'GET'), isEmpty);
    expect(find.byKey(const Key('home')), findsNothing);
  });

  testWidgets('a phone number that cannot be one is refused', (tester) async {
    site.tables['profiles'] = [row()];
    await withClock(Clock.fixed(today), () => open(tester));
    await tester.enterText(find.byKey(const Key('cp-phone')), '12345');
    await tapKey(tester, 'cp-save');
    expect(find.text('That phone number is too short'), findsOneWidget);
  });

  testWidgets('shows the age the date of birth makes, and refuses anyone under 18', (tester) async {
    site.tables['profiles'] = [row()];
    await withClock(Clock.fixed(today), () async {
      await open(tester);
      await pickYear(tester, 2012);
      expect(text(tester, 'dob-value'), 'Oct 29, 2012');
      expect(find.text('You must be 18 or older to use BottlesUp'), findsOneWidget); // said as soon as the day is chosen
      await tester.enterText(find.byKey(const Key('cp-phone')), '416 555 0100');
      await tapKey(tester, 'cp-save');
      expect(find.text('You must be 18 or older to use BottlesUp'), findsOneWidget);
      expect(site.forTable('profiles').where((r) => r.method != 'GET'), isEmpty);
      expect(find.byKey(const Key('home')), findsNothing);

      await pickYear(tester, 1995, from: 2012);
      expect(text(tester, 'dob-value'), 'Oct 29, 1995');
      expect(text(tester, 'dob-age'), 'Age: 31');
      expect(find.text('You must be 18 or older to use BottlesUp'), findsNothing); // and gone once a good day is chosen
    });
  });

  testWidgets('saves the details, marks the profile complete and goes to the home screen', (tester) async {
    site.tables['profiles'] = [row()];
    await withClock(Clock.fixed(today), () async {
      await open(tester);
      await tester.enterText(find.byKey(const Key('cp-phone')), '(416) 555-0100');
      await pickYear(tester, 1995);
      await tapKey(tester, 'cp-save');
      final write = site.forTable('profiles').singleWhere((r) => r.method == 'PATCH');
      expect(write.body, {'phone_number': '+14165550100', 'date_of_birth': '1995-10-29', 'age': 31});
      expect(find.byKey(const Key('home')), findsOneWidget);
      expect(gate.state, ProfileGateState.complete);
    });
  });

  testWidgets('goes on to the screen the person was heading for, if it is one of ours', (tester) async {
    site.tables['profiles'] = [row()];
    await withClock(Clock.fixed(today), () async {
      await open(tester, redirect: '/events/e1');
      await tester.enterText(find.byKey(const Key('cp-phone')), '4165550100');
      await pickYear(tester, 1995);
      await tapKey(tester, 'cp-save');
      expect(text(tester, 'event'), 'EVENT e1');
    });
  });

  testWidgets('does not go to an address outside the app', (tester) async {
    site.tables['profiles'] = [row()];
    await withClock(Clock.fixed(today), () async {
      await open(tester, redirect: 'https://evil.example/');
      await tester.enterText(find.byKey(const Key('cp-phone')), '4165550100');
      await pickYear(tester, 1995);
      await tapKey(tester, 'cp-save');
      expect(find.byKey(const Key('home')), findsOneWidget);
    });
  });

  testWidgets('a profile that has most of it already shows what is there, and asks only for the rest', (tester) async {
    site.tables['profiles'] = [row(phone: '+447700900123')];
    await withClock(Clock.fixed(today), () => open(tester));
    expect(fieldText(tester, 'cp-phone'), '7700900123');
    expect(find.text('GB +44'), findsOneWidget);
    expect(find.text('Choose your date of birth'), findsNothing);
    await tapKey(tester, 'cp-save');
    expect(find.text('Choose your date of birth'), findsOneWidget);
    expect(find.text('Enter your phone number'), findsNothing);
  });

  testWidgets('a profile that is already complete goes straight on without showing the form', (tester) async {
    site.tables['profiles'] = [row(phone: '+14165550100', dob: '1990-06-15')];
    await withClock(Clock.fixed(today), () => open(tester));
    expect(find.byKey(const Key('home')), findsOneWidget);
    expect(find.byKey(const Key('cp-title')), findsNothing);
    expect(gate.state, ProfileGateState.complete);
    expect(site.forTable('profiles').where((r) => r.method != 'GET'), isEmpty);
  });

  testWidgets('a phone sign-up has no e-mail: it is asked for, must look like one, and is saved with the rest', (tester) async {
    await site.signIn(id: 'u2', email: null);
    site.tables['profiles'] = [];
    await withClock(Clock.fixed(today), () async {
      await open(tester);
      expect(fieldText(tester, 'cp-email'), '');
      expect(find.text('From your sign-in'), findsNothing);
      await tester.enterText(find.byKey(const Key('cp-email')), 'not an address');
      await tester.enterText(find.byKey(const Key('cp-phone')), '4165550100');
      await pickYear(tester, 1995);
      await tapKey(tester, 'cp-save');
      expect(find.text('Enter a valid e-mail address'), findsOneWidget);
      expect(site.forTable('profiles').where((r) => r.method != 'GET'), isEmpty);

      await tester.enterText(find.byKey(const Key('cp-email')), 'sam@example.com');
      await tapKey(tester, 'cp-save');
      final write = site.forTable('profiles').singleWhere((r) => r.method == 'POST').body as Map;
      expect((write['id'], write['email'], write['name'], write['phone_number'], write['date_of_birth']), ('u2', 'sam@example.com', 'sam', '+14165550100', '1995-10-29'));
      expect(find.byKey(const Key('home')), findsOneWidget);
    });
  });

  testWidgets('an e-mail another account has says so, keeps the form, and lets the person change it', (tester) async {
    await site.signIn(id: 'u3', email: null);
    site.tables['profiles'] = [row(email: '')];
    site.tableErrors['PATCH profiles'] = (status: 409, body: {'code': '23505', 'message': 'duplicate key value violates unique constraint "profiles_email_key"'});
    await withClock(Clock.fixed(today), () async {
      await open(tester);
      await tester.enterText(find.byKey(const Key('cp-email')), 'taken@example.com');
      await tester.enterText(find.byKey(const Key('cp-phone')), '4165550100');
      await pickYear(tester, 1995);
      await tapKey(tester, 'cp-save');
      expect(text(tester, 'cp-error'), startsWith('Another BottlesUp account already uses that e-mail address.'));
      expect(find.byKey(const Key('home')), findsNothing);
      expect(gate.state, isNot(ProfileGateState.complete));
      expect(fieldText(tester, 'cp-phone'), '4165550100');
    });
  });

  testWidgets('the database refusing the date for age says the person must be old enough', (tester) async {
    site.tables['profiles'] = [row()];
    site.tableErrors['PATCH profiles'] = (status: 400, body: {'code': '23514', 'message': 'new row for relation "profiles" violates check constraint "profiles_age_check"'});
    await withClock(Clock.fixed(today), () async {
      await open(tester);
      await tester.enterText(find.byKey(const Key('cp-phone')), '4165550100');
      await pickYear(tester, 1995);
      await tapKey(tester, 'cp-save');
      expect(text(tester, 'cp-error'), 'You must be 18 or older to use BottlesUp.');
      expect(find.byKey(const Key('home')), findsNothing);
    });
  });

  testWidgets('the back button does not leave the form', (tester) async {
    site.tables['profiles'] = [row()];
    final router = await withClock(Clock.fixed(today), () => open(tester, initial: '/home'));
    unawaited(router.push('/complete-profile'));
    await settleCalls(tester);
    expect(find.byKey(const Key('cp-title')), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('cp-title')), findsOneWidget);
    expect(find.byKey(const Key('home')), findsNothing);
  });

  testWidgets('a save that fails for any other reason says so and keeps everything typed', (tester) async {
    site.tables['profiles'] = [row()];
    site.tableErrors['PATCH profiles'] = (status: 500, body: {'message': 'boom'});
    await withClock(Clock.fixed(today), () async {
      await open(tester);
      await tester.enterText(find.byKey(const Key('cp-phone')), '4165550100');
      await pickYear(tester, 1995);
      await tapKey(tester, 'cp-save');
      expect(text(tester, 'cp-error'), 'We could not save your details. Check your connection and try again.');
      expect(find.byKey(const Key('home')), findsNothing);
      expect(fieldText(tester, 'cp-phone'), '4165550100');
      // and the person can try again
      site.tableErrors.clear();
      await tapKey(tester, 'cp-save');
      expect(find.byKey(const Key('home')), findsOneWidget);
    });
  });

  testWidgets('fits a small phone with nothing cut off, and the whole form can be scrolled to', (tester) async {
    site.tables['profiles'] = [row()];
    await withClock(Clock.fixed(today), () => open(tester, size: const Size(320, 568)));
    expect(tester.takeException(), isNull); // a layout overflow would be reported here
    for (final k in ['cp-email', 'cp-phone', 'dob-field', 'cp-save', 'cp-sign-out']) {
      await tester.ensureVisible(find.byKey(Key(k)));
      expect(tester.getRect(find.byKey(Key(k))).right, lessThanOrEqualTo(320), reason: k);
    }
  });

  testWidgets('when the profile cannot be read there is a way to try again, and to sign out', (tester) async {
    site.failTables.add('profiles');
    await withClock(Clock.fixed(today), () => open(tester));
    expect(text(tester, 'cp-load-error'), 'We could not load your profile. Check your connection and try again.');
    expect(find.byKey(const Key('cp-sign-out')), findsOneWidget);
    expect(find.byKey(const Key('cp-save')), findsNothing);
    site.failTables.clear();
    site.tables['profiles'] = [row()];
    await tapKey(tester, 'cp-retry');
    expect(find.byKey(const Key('cp-title')), findsOneWidget);
  });
}
