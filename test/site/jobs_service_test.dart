import 'package:bottles_up_user/site/models/jobs.dart';
import 'package:bottles_up_user/site/services/jobs_service.dart';
import 'package:bottles_up_user/site/site_error.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/recognition_fixtures.dart';

void main() {
  late FakeWebsite site;
  late JobsService service;

  setUp(() {
    site = FakeWebsite();
    service = JobsService(site.client);
  });

  Matcher sentence(String s) => throwsA(isA<SiteException>().having((e) => e.message, 'message', s));
  Matcher generic() => throwsA(isA<SiteException>());

  final draft = JobDraft(
    title: '  Weekend bartender ',
    kind: JobKind.partTime,
    description: ' We need an experienced bartender for weekends. ',
    requirements: ' Two years behind a bar. ',
    compensation: ' \$20 an hour ',
    location: ' Toronto ',
    remote: false,
    schedule: ' Fri and Sat nights ',
    deadline: DateTime(2026, 12, 5),
  );

  group('listings', () {
    test('a new job is sent trimmed with the day as a date, as the business', () async {
      site.rpcs['job_create'] = (_) => ok(jobRow());
      final j = await service.create(actor: 'p-club', draft: draft);
      expect(j.id, 'job1');
      expect(site.forRpc('job_create').single.body, {
        'p_actor': 'p-club',
        'p_title': 'Weekend bartender',
        'p_kind': 'part_time',
        'p_description': 'We need an experienced bartender for weekends.',
        'p_requirements': 'Two years behind a bar.',
        'p_compensation': '\$20 an hour',
        'p_location': 'Toronto',
        'p_remote': false,
        'p_schedule': 'Fri and Sat nights',
        'p_deadline': '2026-12-05',
      });
    });

    test('what is left blank is not sent', () async {
      site.rpcs['job_create'] = (_) => ok(jobRow());
      await service.create(
        actor: 'p-club',
        draft: JobDraft(title: 'Remote promoter', kind: JobKind.ambassador, description: 'Promote our nights to your followers.', compensation: 'Commission', remote: true, requirements: '  ', location: '', schedule: ' ', deadline: DateTime(2026, 1, 9)),
      );
      final sent = site.forRpc('job_create').single.body;
      expect([sent['p_requirements'], sent['p_location'], sent['p_schedule'], sent['p_remote'], sent['p_kind'], sent['p_deadline']], [null, null, null, true, 'ambassador', '2026-01-09']);
    });

    test('a change names the job, and a close says whether somebody was found', () async {
      site.rpcs['job_update'] = (_) => ok(jobRow());
      site.rpcs['job_close'] = (_) => ok(jobRow(status: 'filled', open: false));
      await service.update(actor: 'p-club', id: 'job1', draft: draft);
      expect(site.forRpc('job_update').single.body['p_job'], 'job1');
      expect(site.forRpc('job_update').single.body['p_actor'], 'p-club');
      await service.close(actor: 'p-club', id: 'job1');
      await service.close(actor: 'p-club', id: 'job1', filled: true);
      expect(site.forRpc('job_close').map((r) => r.body), [
        {'p_actor': 'p-club', 'p_job': 'job1', 'p_filled': false},
        {'p_actor': 'p-club', 'p_job': 'job1', 'p_filled': true},
      ]);
    });

    test('a refusal is its sentence, and an answer that cannot be read is an error', () async {
      site.rpcs['job_create'] = (_) => raised('You have 20 open jobs. Close one first.');
      await expectLater(service.create(actor: 'p', draft: draft), sentence('You have 20 open jobs. Close one first.'));
      site.rpcs['job_create'] = (_) => ok(null);
      await expectLater(service.create(actor: 'p', draft: draft), generic());
      site.rpcs['job_get'] = (_) => ok('nonsense');
      await expectLater(service.job(actor: 'a', id: 'j'), generic());
    });

    test('one job is asked for as the profile the person acts as', () async {
      site.rpcs['job_get'] = (_) => ok(jobRow());
      await service.job(actor: 'me', id: 'job1');
      expect(site.forRpc('job_get').single.body, {'p_actor': 'me', 'p_job': 'job1'});
    });
  });

  group('browsing', () {
    test('asks with the filters, and the page continues after the last job of the one before in UTC', () async {
      site.rpcs['jobs_list'] = (_) => ok([jobRow(), jobRow(id: 'job2')]);
      final jobs = await service.list(actor: 'me', kind: JobKind.freelance, query: '  wedding ', remote: true, before: DateTime.utc(2026, 11, 2, 10), beforeId: 'job9', limit: 5);
      expect(jobs.map((j) => j.id), ['job1', 'job2']);
      expect(site.forRpc('jobs_list').single.body, {'p_actor': 'me', 'p_kind': 'freelance', 'p_query': 'wedding', 'p_remote': true, 'p_before': '2026-11-02T10:00:00.000Z', 'p_before_id': 'job9', 'p_limit': 5});
    });

    test('asks for the first page of twenty with nothing else', () async {
      site.rpcs['jobs_list'] = (_) => ok(<Object>[]);
      await service.list(actor: 'me');
      await service.list(actor: 'me', query: '   ');
      for (final r in site.forRpc('jobs_list')) {
        expect(r.body, {'p_actor': 'me', 'p_kind': null, 'p_query': null, 'p_remote': null, 'p_before': null, 'p_before_id': null, 'p_limit': 20});
      }
    });

    test('the listings of a business are asked for as the business', () async {
      site.rpcs['jobs_mine'] = (_) => ok([jobRow(mine: true)]);
      expect((await service.mine('p-club')).single.mine, isTrue);
      expect(site.forRpc('jobs_mine').single.body, {'p_actor': 'p-club'});
    });
  });

  group('applications', () {
    test('an application is sent trimmed, with the link only if there is one', () async {
      site.rpcs['job_apply'] = (_) => ok(applicationRow());
      await service.apply(actor: 'me', job: 'job1', message: '  I have worked many bars.  ', link: ' https://example.com/me ');
      await service.apply(actor: 'me', job: 'job1', message: 'I have worked many bars.', link: '  ');
      await service.apply(actor: 'me', job: 'job1', message: 'I have worked many bars.');
      final sent = site.forRpc('job_apply');
      expect(sent[0].body, {'p_actor': 'me', 'p_job': 'job1', 'p_message': 'I have worked many bars.', 'p_link': 'https://example.com/me'});
      expect(sent[1].body['p_link'], isNull);
      expect(sent[2].body['p_link'], isNull);
    });

    test('a refusal to apply is its sentence', () async {
      site.rpcs['job_apply'] = (_) => raised('You have already applied.');
      await expectLater(service.apply(actor: 'me', job: 'j', message: 'Hello, I am free.'), sentence('You have already applied.'));
      site.rpcs['job_apply'] = (_) => ok(null);
      await expectLater(service.apply(actor: 'me', job: 'j', message: 'Hello, I am free.'), generic());
    });

    test('the business reads the applications to a job as the business', () async {
      site.rpcs['job_applications'] = (_) => ok([applicationRow(), applicationRow(id: 'ap2')]);
      expect((await service.applications(actor: 'p-club', job: 'job1')).map((a) => a.id), ['ap1', 'ap2']);
      expect(site.forRpc('job_applications').single.body, {'p_actor': 'p-club', 'p_job': 'job1'});
    });

    test('the business answers with a state in the website\'s word and a reply only if there is one', () async {
      site.rpcs['job_application_set'] = (_) => ok(applicationRow(state: 'accepted'));
      await service.answer(actor: 'p-club', application: 'ap1', state: ApplicationState.accepted, reply: '  Welcome aboard.  ');
      await service.answer(actor: 'p-club', application: 'ap1', state: ApplicationState.shortlisted, reply: ' ');
      final sent = site.forRpc('job_application_set');
      expect(sent[0].body, {'p_actor': 'p-club', 'p_application': 'ap1', 'p_state': 'accepted', 'p_reply': 'Welcome aboard.'});
      expect(sent[1].body, {'p_actor': 'p-club', 'p_application': 'ap1', 'p_state': 'shortlisted', 'p_reply': null});
    });

    test('an application is taken back by its id, and my applications are asked for as the profile', () async {
      site.rpcs['job_application_withdraw'] = (_) => ok(applicationRow(state: 'withdrawn'));
      site.rpcs['job_applications_mine'] = (_) => ok([applicationRow()]);
      expect((await service.withdraw(actor: 'me', application: 'ap1')).state, ApplicationState.withdrawn);
      expect(site.forRpc('job_application_withdraw').single.body, {'p_actor': 'me', 'p_application': 'ap1'});
      expect((await service.myApplications('me')).length, 1);
      expect(site.forRpc('job_applications_mine').single.body, {'p_actor': 'me'});
    });
  });
}
