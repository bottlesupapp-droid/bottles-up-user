import 'package:bottles_up_user/site/models/jobs.dart';
import 'package:bottles_up_user/site/rules/jobs_rules.dart';
import 'package:bottles_up_user/site/when.dart';
import 'package:flutter_test/flutter_test.dart';

final today = DateTime(2026, 11, 2, 15);

String? check({
  String? title = 'Weekend bartender',
  JobKind? kind = JobKind.partTime,
  String? description = 'We need an experienced bartender for weekends.',
  String? requirements,
  String? compensation = '\$20 an hour',
  String? location = 'Toronto',
  bool remote = false,
  String? schedule,
  DateTime? deadline,
}) =>
    checkJob(title: title, kind: kind, description: description, requirements: requirements, compensation: compensation, location: location, remote: remote, schedule: schedule, deadline: deadline ?? DateTime(2026, 12, 1), today: today);

void main() {
  group('a listing', () {
    test('that is fine', () {
      expect(check(), isNull);
    });

    test('needs a title of five to a hundred and twenty characters', () {
      expect(check(title: 'Barb'), 'Write a title of 5 to 120 characters.');
      expect(check(title: null), 'Write a title of 5 to 120 characters.');
      expect(check(title: '  Barb  '), 'Write a title of 5 to 120 characters.');
      expect(check(title: 'Barbs'), isNull);
      expect(check(title: 't' * 120), isNull);
      expect(check(title: 't' * 121), 'Write a title of 5 to 120 characters.');
    });

    test('needs a kind', () {
      expect(check(kind: null), 'Choose what kind of job it is.');
    });

    test('needs a description of twenty to four thousand characters', () {
      expect(check(description: 'd' * 19), 'Describe the job in 20 to 4000 characters.');
      expect(check(description: null), 'Describe the job in 20 to 4000 characters.');
      expect(check(description: 'd' * 20), isNull);
      expect(check(description: 'd' * 4000), isNull);
      expect(check(description: 'd' * 4001), 'Describe the job in 20 to 4000 characters.');
    });

    test('keeps the requirements to two thousand characters', () {
      expect(check(requirements: 'r' * 2000), isNull);
      expect(check(requirements: 'r' * 2001), 'Keep the requirements to 2000 characters.');
      expect(check(requirements: null), isNull);
    });

    test('says what it pays, in two to two hundred characters', () {
      expect(check(compensation: '\$'), 'Say what it pays (2 to 200 characters).');
      expect(check(compensation: null), 'Say what it pays (2 to 200 characters).');
      expect(check(compensation: '10'), isNull);
      expect(check(compensation: 'c' * 200), isNull);
      expect(check(compensation: 'c' * 201), 'Say what it pays (2 to 200 characters).');
    });

    test('says where it is, or that it can be done remotely', () {
      expect(check(location: null), 'Say where it is, or that it can be done remotely.');
      expect(check(location: '   '), 'Say where it is, or that it can be done remotely.');
      expect(check(location: null, remote: true), isNull);
      expect(check(location: 'l' * 120), isNull);
      expect(check(location: 'l' * 121), 'Keep the location to 120 characters.');
      expect(check(location: 'l' * 121, remote: true), 'Keep the location to 120 characters.');
    });

    test('keeps the schedule to two hundred characters', () {
      expect(check(schedule: 's' * 200), isNull);
      expect(check(schedule: 's' * 201), 'Keep the schedule to 200 characters.');
    });

    test('gives a last day from today to a year away', () {
      const wrong = 'Choose a last day to apply, from today to a year away.';
      expect(check(deadline: DateTime(2026, 11, 2)), isNull);
      expect(check(deadline: DateTime(2026, 11, 1)), wrong);
      expect(check(deadline: DateTime(2027, 11, 2)), isNull);
      expect(check(deadline: DateTime(2027, 11, 3)), wrong);
      expect(checkJob(title: 'Weekend bartender', kind: JobKind.partTime, description: 'We need an experienced bartender for weekends.', compensation: '\$20', location: 'Toronto', remote: false, deadline: null, today: today), wrong);
    });

    test('is checked in the order a person fills it in', () {
      expect(check(title: 'x', kind: null, description: 'x'), 'Write a title of 5 to 120 characters.');
      expect(check(kind: null, description: 'x'), 'Choose what kind of job it is.');
      expect(check(description: 'x', compensation: ''), 'Describe the job in 20 to 4000 characters.');
      expect(check(compensation: '', location: null), 'Say what it pays (2 to 200 characters).');
      expect(check(location: null, deadline: DateTime(2020)), 'Say where it is, or that it can be done remotely.');
    });
  });

  group('an application', () {
    test('needs a message of twenty to two thousand characters', () {
      expect(checkApplication(message: 'm' * 19), 'Write a message of 20 to 2000 characters.');
      expect(checkApplication(message: null), 'Write a message of 20 to 2000 characters.');
      expect(checkApplication(message: 'm' * 20), isNull);
      expect(checkApplication(message: 'm' * 2000), isNull);
      expect(checkApplication(message: 'm' * 2001), 'Write a message of 20 to 2000 characters.');
      expect(checkApplication(message: '  ${'m' * 19}  '), 'Write a message of 20 to 2000 characters.');
    });

    test('may carry a secure link of up to three hundred characters', () {
      const wrong = 'A link must start with https:// and be up to 300 characters.';
      const m = 'I have worked many bars in Toronto.';
      expect(checkApplication(message: m), isNull);
      expect(checkApplication(message: m, link: ''), isNull);
      expect(checkApplication(message: m, link: '   '), isNull);
      expect(checkApplication(message: m, link: 'https://example.com/me'), isNull);
      expect(checkApplication(message: m, link: ' https://example.com/me '), isNull);
      expect(checkApplication(message: m, link: 'http://example.com/me'), wrong);
      expect(checkApplication(message: m, link: 'https://example.com/my work'), wrong);
      expect(checkApplication(message: m, link: 'https://'), wrong);
      expect(checkApplication(message: m, link: 'example.com'), wrong);
      expect(checkApplication(message: m, link: 'https://example.com/${'x' * 280}'), isNull);
      expect(checkApplication(message: m, link: 'https://example.com/${'x' * 281}'), wrong);
    });
  });

  test('a reply is up to a thousand characters', () {
    expect(checkReply(null), isNull);
    expect(checkReply('r' * 1000), isNull);
    expect(checkReply('r' * 1001), 'Keep the reply to 1000 characters.');
  });

  group('how long is left', () {
    final now = DateTime(2026, 11, 2, 23, 30);
    test('in words', () {
      expect(deadlineText(DateTime(2026, 11, 1), now), 'Closed');
      expect(deadlineText(DateTime(2026, 11, 2), now), 'Last day today');
      expect(deadlineText(DateTime(2026, 11, 3), now), '1 day left');
      expect(deadlineText(DateTime(2026, 11, 7), now), '5 days left');
      expect(deadlineText(DateTime(2026, 11, 2, 1), DateTime(2026, 11, 2, 23)), 'Last day today');
    });

    test('and the day to apply by', () {
      expect(applyByText(DateTime(2026, 11, 6)), 'Apply by ${formatDay(DateTime(2026, 11, 6))}');
    });
  });
}
