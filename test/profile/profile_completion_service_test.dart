import 'package:bottles_up_user/site/services/profile_completion_service.dart';
import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';

void main() {
  late FakeWebsite site;
  late ProfileCompletionService service;
  final today = DateTime(2026, 10, 29, 12);

  setUp(() async {
    site = FakeWebsite();
    await site.signIn(id: 'u1', email: 'dana@example.com', metadata: {'name': 'Dana Lee'});
    service = ProfileCompletionService(site.client);
  });

  Map<String, dynamic> row({String? email = 'dana@example.com', String? phone, String? dob}) =>
      {'name': 'Dana Lee', 'email': email, 'phone_number': phone, 'date_of_birth': dob};

  group('reading the profile', () {
    test('asks for this person\'s row only, and only the columns it needs', () async {
      site.tables['profiles'] = [row(phone: '+14165550100', dob: '1990-06-15')];
      final d = await service.load();
      final r = site.forTable('profiles').single;
      expect(r.method, 'GET');
      expect(r.query['id'], 'eq.u1');
      expect(r.query['select'], 'name,email,phone_number,date_of_birth');
      expect((d.exists, d.email, d.phone, d.dateOfBirth, d.sessionEmail, d.sessionName), (true, 'dana@example.com', '+14165550100', DateTime(1990, 6, 15), 'dana@example.com', 'Dana Lee'));
    });

    test('a person with no row at all is a person with nothing saved, not an error', () async {
      final d = await service.load();
      expect((d.exists, d.phone, d.dateOfBirth), (false, null, null));
      expect(d.knownEmail, 'dana@example.com');
    });

    test('a phone sign-up has no sign-in e-mail', () async {
      await site.signIn(id: 'u2', email: null);
      expect((await service.load()).knownEmail, isNull);
    });

    test('a failed read is an error (never read as "nothing saved", which would let someone through or wrongly ask again)', () async {
      site.failTables.add('profiles');
      await expectLater(service.load(), throwsA(anything));
    });
  });

  group('saving', () {
    test('a person with a row: only the three details change (name and picture are left alone), the age follows the date, the e-mail is not touched', () async {
      site.tables['profiles'] = [row()];
      await withClock(Clock.fixed(today), () => service.save(email: 'ignored@example.com', phone: '+14165550100', dateOfBirth: DateTime(2000, 10, 30)));
      final w = site.forTable('profiles').where((r) => r.method == 'PATCH').single;
      expect(w.query['id'], 'eq.u1');
      expect(w.body, {'phone_number': '+14165550100', 'date_of_birth': '2000-10-30', 'age': 25});
      expect(site.forTable('profiles').where((r) => r.method == 'POST'), isEmpty);
    });

    test('the age is counted on the day (turning 26 today)', () async {
      site.tables['profiles'] = [row()];
      await withClock(Clock.fixed(today), () => service.save(email: 'x@y.co', phone: '+14165550100', dateOfBirth: DateTime(2000, 10, 29)));
      expect((site.forTable('profiles').singleWhere((r) => r.method == 'PATCH').body as Map)['age'], 26);
    });

    test('a person whose row has no e-mail gets the one typed (or their sign-in\'s)', () async {
      await site.signIn(id: 'u3', email: null);
      site.tables['profiles'] = [row(email: '')];
      await service.save(email: ' typed@example.com ', phone: '+14165550100', dateOfBirth: DateTime(1990, 6, 15));
      expect((site.forTable('profiles').singleWhere((r) => r.method == 'PATCH').body as Map)['email'], 'typed@example.com');
    });

    test('a person with NO row gets one made, with the name the sign-in gave and the e-mail from the sign-in', () async {
      await withClock(Clock.fixed(today), () => service.save(email: 'ignored@example.com', phone: '+14165550100', dateOfBirth: DateTime(1990, 6, 15)));
      final w = site.forTable('profiles').singleWhere((r) => r.method == 'POST');
      expect(w.body, {'id': 'u1', 'name': 'Dana Lee', 'email': 'dana@example.com', 'phone_number': '+14165550100', 'date_of_birth': '1990-06-15', 'age': 36});
    });

    test('a phone sign-up with no row and no name: the row gets the typed e-mail and a name made from it', () async {
      await site.signIn(id: 'u4', email: null);
      await service.save(email: 'sam@example.com', phone: '+14165550100', dateOfBirth: DateTime(1990, 6, 15));
      final w = site.forTable('profiles').singleWhere((r) => r.method == 'POST').body as Map;
      expect(w['email'], 'sam@example.com');
      expect(w['name'], 'sam');
      expect(w['id'], 'u4');
    });

    test('an e-mail another account already has is reported in words the screen can use', () async {
      await site.signIn(id: 'u5', email: null);
      site.tables['profiles'] = [row(email: '')];
      site.tableErrors['PATCH profiles'] = (status: 409, body: {'code': '23505', 'message': 'duplicate key value violates unique constraint "profiles_email_key"'});
      await expectLater(service.save(email: 'taken@example.com', phone: '+14165550100', dateOfBirth: DateTime(1990, 6, 15)), throwsA(isA<EmailTakenException>()));
    });

    test('a date that makes the person too young (the database\'s age rule) is reported as such', () async {
      site.tables['profiles'] = [row()];
      site.tableErrors['PATCH profiles'] = (status: 400, body: {'code': '23514', 'message': 'new row for relation "profiles" violates check constraint "profiles_age_check"'});
      await expectLater(service.save(email: 'x@y.co', phone: '+14165550100', dateOfBirth: DateTime(2008, 10, 29)), throwsA(isA<UnderAgeException>()));
    });

    test('another rule being broken is not mistaken for the age rule', () async {
      site.tables['profiles'] = [row()];
      site.tableErrors['PATCH profiles'] = (status: 400, body: {'code': '23514', 'message': 'new row for relation "profiles" violates check constraint "profiles_date_of_birth_range"'});
      await expectLater(service.save(email: 'x@y.co', phone: '+14165550100', dateOfBirth: DateTime(1990, 6, 15)), throwsA(allOf(isNot(isA<UnderAgeException>()), isNot(isA<EmailTakenException>()))));
    });

    test('any other refusal is passed on as it is (a database that has not got the new column, a lost connection)', () async {
      site.tables['profiles'] = [row()];
      site.tableErrors['PATCH profiles'] = (status: 400, body: {'code': 'PGRST204', 'message': 'Could not find the \'date_of_birth\' column of \'profiles\' in the schema cache'});
      await expectLater(service.save(email: 'x@y.co', phone: '+14165550100', dateOfBirth: DateTime(1990, 6, 15)), throwsA(isNot(isA<EmailTakenException>())));
    });

    test('an update that changed no row (the database refused it quietly) is an error, not a success', () async {
      site.tables['profiles'] = [row()];
      site.tableErrors['PATCH profiles'] = (status: 200, body: <Object>[]);
      await expectLater(service.save(email: 'x@y.co', phone: '+14165550100', dateOfBirth: DateTime(1990, 6, 15)), throwsA(isA<StateError>()));
    });
  });
}
