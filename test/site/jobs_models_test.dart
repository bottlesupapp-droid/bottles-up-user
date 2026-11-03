import 'package:bottles_up_user/site/models/jobs.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/recognition_fixtures.dart';

void main() {
  test('every kind of job and every state is found by the website\'s word, and nothing else is', () {
    for (final k in JobKind.values) {
      expect(JobKind.fromWire(k.wire), k);
    }
    expect(JobKind.values.map((k) => k.wire), ['full_time', 'part_time', 'event_shift', 'freelance', 'collaboration', 'ambassador']);
    expect(JobKind.values.map((k) => k.label), ['Full-time', 'Part-time', 'Event shift', 'Freelance gig', 'Paid collaboration', 'Promoter or ambassador']);
    expect(JobKind.fromWire('volunteer'), isNull);
    expect(JobKind.fromWire(null), isNull);
    for (final s in ApplicationState.values) {
      expect(ApplicationState.fromWire(s.wire), s);
    }
    expect(ApplicationState.values.map((s) => s.label), ['Sent', 'Shortlisted', 'Accepted', 'Not this time', 'Taken back']);
    expect(ApplicationState.fromWire('hired'), isNull);
  });

  group('a job', () {
    test('is read in full', () {
      final j = parseJob(jobRow(mine: true, applications: 3, waiting: 2, applied: {'id': 'ap1', 'state': 'shortlisted'}))!;
      expect([j.id, j.title, j.kind, j.compensation, j.location, j.remote, j.schedule, j.requirements, j.status, j.open], ['job1', 'Weekend bartender', JobKind.partTime, '\$20 an hour plus tips', 'Toronto', false, 'Fri and Sat nights', 'Two years behind a bar.', 'open', true]);
      expect([j.deadline, j.createdAt!.toUtc(), j.poster.handle, j.mine, j.applications, j.waiting, j.applied!.state, j.applied!.id], [DateTime(2099, 12, 1), DateTime.utc(2026, 11, 2, 10), 'clubx', true, 3, 2, ApplicationState.shortlisted, 'ap1']);
    });

    test('shows the numbers only to the business', () {
      final j = parseJob(jobRow())!;
      expect([j.mine, j.applications, j.waiting, j.applied], [false, null, null, null]);
    });

    test('says where it is', () {
      expect(parseJob(jobRow())!.where, 'Toronto');
      expect(parseJob(jobRow(location: null, remote: true))!.where, 'Remote');
      expect(parseJob(jobRow(remote: true))!.where, 'Toronto or remote');
    });

    test('says whether it is closed or filled', () {
      expect([parseJob(jobRow())!.isClosed, parseJob(jobRow())!.isFilled], [false, false]);
      expect([parseJob(jobRow(status: 'closed', open: false))!.isClosed, parseJob(jobRow(status: 'closed', open: false))!.isFilled], [true, false]);
      expect([parseJob(jobRow(status: 'filled', open: false))!.isClosed, parseJob(jobRow(status: 'filled', open: false))!.isFilled], [true, true]);
      expect(parseJob(jobRow(open: false))!.open, isFalse);
    });

    test('that cannot be read is dropped', () {
      for (final key in ['id', 'title', 'kind', 'description', 'compensation', 'deadline', 'status', 'poster']) {
        expect(parseJob(jobRow()..remove(key)), isNull, reason: key);
      }
      expect(parseJob(jobRow(kind: 'volunteer')), isNull);
      expect(parseJob(null), isNull);
      expect(parseJobs([jobRow(), 'x', jobRow(id: 'job2')]).map((j) => j.id), ['job1', 'job2']);
      expect(parseJobs(null), isEmpty);
      expect(parseJob(jobRow(applied: {'id': 'ap1', 'state': 'hired'}))!.applied, isNull);
      expect(parseJob(jobRow(applied: {'state': 'sent'}))!.applied, isNull);
    });
  });

  group('an application', () {
    test('is read with the applicant and the job', () {
      final a = parseJobApplication(applicationRow(state: 'accepted', reply: 'Welcome aboard.'))!;
      expect([a.id, a.state, a.message, a.link, a.reply, a.isAnswered, a.applicant.handle, a.job.id, a.job.title, a.job.kind, a.job.open, a.job.poster.handle, a.job.deadline], [
        'ap1', ApplicationState.accepted, 'I have worked many bars in Toronto.', 'https://example.com/me', 'Welcome aboard.', true, 'bob', 'job1', 'Weekend bartender', JobKind.partTime, true, 'clubx', DateTime(2099, 12, 1),
      ]);
      expect(a.createdAt!.toUtc(), DateTime.utc(2026, 11, 3, 10));
    });

    test('is answered only when accepted or turned down', () {
      for (final s in ['sent', 'shortlisted', 'withdrawn']) {
        expect(parseJobApplication(applicationRow(state: s))!.isAnswered, isFalse, reason: s);
      }
      expect(parseJobApplication(applicationRow(state: 'declined'))!.isAnswered, isTrue);
    });

    test('has no link or reply unless it has them', () {
      final a = parseJobApplication(applicationRow(link: null))!;
      expect([a.link, a.reply, a.decidedAt], [null, null, null]);
    });

    test('that cannot be read is dropped', () {
      for (final key in ['id', 'state', 'message', 'applicant', 'job']) {
        expect(parseJobApplication(applicationRow()..remove(key)), isNull, reason: key);
      }
      for (final key in ['id', 'title', 'kind', 'status', 'deadline', 'poster']) {
        final job = {...(applicationRow()['job'] as Map<String, dynamic>)}..remove(key);
        expect(parseJobApplication(applicationRow(job: job)), isNull, reason: 'job.$key');
      }
      expect(parseJobApplication(applicationRow(state: 'hired')), isNull);
      expect(parseJobApplication(null), isNull);
      expect(parseJobApplications([applicationRow(), 'x', applicationRow(id: 'ap2')]).map((a) => a.id), ['ap1', 'ap2']);
      expect(parseJobApplications(null), isEmpty);
    });
  });
}
