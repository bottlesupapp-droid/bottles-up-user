import 'package:bottles_up_user/site/providers/site_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../support/fake_website.dart';
import '../support/pump_site.dart';
import '../support/pump_social.dart';
import '../support/recognition_fixtures.dart';

String textOf(WidgetTester tester, String key) => tester.widget<Text>(find.byKey(Key(key))).data!;

void main() {
  late FakeWebsite site;
  final on = {'social': true, 'jobs': true};
  final today = DateTime.now();
  String iso(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  final fiveDays = iso(DateTime(today.year, today.month, today.day + 5));
  final asClub = [selectedProfileIdProvider.overrideWith((ref) => 'p-club')];
  final club = {...profileRow(id: 'p-club', kind: 'business', handle: 'clubx', name: 'Club X', category: 'venue'), 'is_mine': true};

  String path(GoRouter r) => r.routerDelegate.currentConfiguration.last.matchedLocation;

  setUp(() {
    site = FakeWebsite();
    site.rpcs['rules_status'] = (_) => ok({'version': 1, 'accepted': true});
    site.rpcs['jobs_list'] = (_) => ok([jobRow(deadline: fiveDays), jobRow(id: 'job2', title: 'Wedding photographer', kind: 'freelance', remote: true, location: null, deadline: fiveDays)]);
    site.rpcs['job_get'] = (_) => ok(jobRow(deadline: fiveDays));
    site.rpcs['job_applications_mine'] = (_) => ok(<Object>[]);
  });

  Future<void> tap(WidgetTester tester, String key) async {
    await tester.ensureVisible(find.byKey(Key(key)));
    await tester.tap(find.byKey(Key(key)));
    await tester.pump();
  }

  Future<GoRouter> open(WidgetTester tester, String location, {Map<String, bool>? features, List<Map<String, dynamic>>? mine, List<Override> overrides = const []}) async {
    final router = await openSocial(tester, site, location, features: features ?? on, mine: mine, overrides: overrides);
    await settleCalls(tester);
    return router;
  }

  group('Opportunities', () {
    testWidgets('says it is not open yet while jobs are off', (tester) async {
      await open(tester, '/jobs', features: {'social': true});
      expect(find.text('Jobs are not open yet.'), findsOneWidget);
      expect(site.forRpc('jobs_list'), isEmpty);
    });

    testWidgets('lists the jobs with what they are, where, what they pay and how long is left', (tester) async {
      await open(tester, '/jobs');
      expect(site.forRpc('jobs_list').single.body, {'p_actor': 'me', 'p_kind': null, 'p_query': null, 'p_remote': null, 'p_before': null, 'p_before_id': null, 'p_limit': 20});
      final card = find.byKey(const Key('job-job1'));
      expect(find.descendant(of: card, matching: find.text('Weekend bartender')), findsOneWidget);
      expect(find.descendant(of: card, matching: find.text('Club X')), findsOneWidget);
      expect(find.descendant(of: card, matching: find.text('Part-time')), findsOneWidget);
      expect(find.descendant(of: card, matching: find.text('Toronto')), findsOneWidget);
      expect(find.descendant(of: card, matching: find.text('\$20 an hour plus tips')), findsOneWidget);
      expect(textOf(tester, 'job-deadline-job1'), '5 days left');
      expect(find.descendant(of: find.byKey(const Key('job-job2')), matching: find.text('Remote')), findsOneWidget);
    });

    testWidgets('a job already applied for shows where the application stands', (tester) async {
      site.rpcs['jobs_list'] = (_) => ok([jobRow(deadline: fiveDays, applied: {'id': 'ap1', 'state': 'shortlisted'})]);
      await open(tester, '/jobs');
      expect(find.descendant(of: find.byKey(const Key('job-job1')), matching: find.byKey(const Key('application-shortlisted'))), findsOneWidget);
    });

    testWidgets('filters by kind and by remote, and searches by words', (tester) async {
      await open(tester, '/jobs');
      await tap(tester, 'kind-freelance');
      await settleCalls(tester);
      expect(site.forRpc('jobs_list').last.body['p_kind'], 'freelance');
      await tap(tester, 'kind-remote');
      await settleCalls(tester);
      expect(site.forRpc('jobs_list').last.body, containsPair('p_remote', true));
      await tap(tester, 'kind-all');
      await settleCalls(tester);
      expect(site.forRpc('jobs_list').last.body['p_kind'], isNull);
      expect(site.forRpc('jobs_list').last.body['p_remote'], true, reason: 'remote is its own filter');
      await tap(tester, 'kind-remote');
      await settleCalls(tester);
      expect(site.forRpc('jobs_list').last.body['p_remote'], isNull);
      await tester.enterText(find.byKey(const Key('jobs-search')), '  bartender ');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await settleCalls(tester);
      expect(site.forRpc('jobs_list').last.body['p_query'], 'bartender');
      await tap(tester, 'jobs-search-clear');
      await settleCalls(tester);
      expect(site.forRpc('jobs_list').last.body['p_query'], isNull);
    });

    testWidgets('a job that is no longer open says Filled or Closed instead of the days left, and the list shows no counts', (tester) async {
      site.rpcs['jobs_list'] = (_) => ok([
            jobRow(deadline: fiveDays, applications: 4, waiting: 1),
            jobRow(id: 'job2', title: 'Door staff', status: 'filled', open: false, deadline: fiveDays),
            jobRow(id: 'job3', title: 'Cloakroom', status: 'closed', open: false, deadline: fiveDays),
          ]);
      await open(tester, '/jobs');
      expect(textOf(tester, 'job-deadline-job1'), '5 days left');
      expect(textOf(tester, 'job-deadline-job2'), 'Filled');
      expect(textOf(tester, 'job-deadline-job3'), 'Closed');
      expect(find.byKey(const Key('job-counts-job1')), findsNothing, reason: 'counts belong to the business\'s own list');
    });

    testWidgets('a job opens its page', (tester) async {
      final router = await open(tester, '/jobs');
      await tap(tester, 'job-job1');
      await tester.pumpAndSettle();
      expect(path(router), '/jobs/job1');
    });

    testWidgets('has plain empty states', (tester) async {
      site.rpcs['jobs_list'] = (_) => ok(<Object>[]);
      await open(tester, '/jobs');
      expect(find.text('No business has posted a job yet. Check again soon.'), findsOneWidget);
      await tap(tester, 'kind-freelance');
      await settleCalls(tester);
      expect(find.text('Nothing matches. Try other words or take a filter off.'), findsOneWidget);
    });

    testWidgets('shows more when the page was full, and stops when it is not', (tester) async {
      site.rpcs['jobs_list'] = (b) => b['p_before'] == null
          ? ok([for (var i = 0; i < 20; i++) jobRow(id: 'j$i', title: 'Job $i', deadline: fiveDays)])
          : ok([jobRow(id: 'j20', title: 'Job 20', deadline: fiveDays)]);
      // Twenty jobs are a big answer: the phone reads it on another thread, which a test lets finish with settleCalls.
      await openSocial(tester, site, '/jobs', features: on, settle: false);
      await settleCalls(tester);
      await tester.pumpAndSettle();
      await tester.dragUntilVisible(find.byKey(const Key('jobs-more')), find.byType(ListView), const Offset(0, -400));
      expect(find.byKey(const Key('jobs-more')), findsOneWidget);
      await tap(tester, 'jobs-more');
      await settleCalls(tester);
      final second = site.forRpc('jobs_list').last.body;
      expect([second['p_before'], second['p_before_id']], ['2026-11-02T10:00:00.000Z', 'j19']);
      await tester.dragUntilVisible(find.byKey(const Key('job-j20')), find.byType(ListView).last, const Offset(0, -300));
      expect(find.byKey(const Key('job-j20')), findsOneWidget);
      await tester.drag(find.byType(ListView).last, const Offset(0, -3000));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('jobs-more')), findsNothing, reason: 'a short page is the last');
    });

    testWidgets('a list that is not a full page has no Show more', (tester) async {
      await open(tester, '/jobs');
      await tester.drag(find.byType(ListView).last, const Offset(0, -3000));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('jobs-more')), findsNothing);
    });

    Future<void> openFullPage(WidgetTester tester) async {
      site.rpcs['jobs_list'] = (b) => b['p_before'] == null
          ? ok([for (var i = 0; i < 20; i++) jobRow(id: 'j$i', title: 'Job $i', kind: 'freelance', remote: true, deadline: fiveDays)])
          : ok([jobRow(id: 'j20', title: 'Job 20', deadline: fiveDays)]);
      // Twenty jobs are a big answer: the phone reads it on another thread, which a test lets finish with settleCalls.
      await openSocial(tester, site, '/jobs', features: on, settle: false);
      await settleCalls(tester);
      await tester.pumpAndSettle();
    }

    testWidgets('Show more keeps the filters of the list it continues', (tester) async {
      await openFullPage(tester);
      await tap(tester, 'kind-freelance');
      await settleCalls(tester);
      await tester.pumpAndSettle();
      await tap(tester, 'kind-remote');
      await settleCalls(tester);
      await tester.pumpAndSettle();
      await tester.dragUntilVisible(find.byKey(const Key('jobs-more')), find.byType(ListView), const Offset(0, -400));
      await tap(tester, 'jobs-more');
      await settleCalls(tester);
      final second = site.forRpc('jobs_list').last.body;
      expect(second['p_before_id'], 'j19');
      expect(second['p_kind'], 'freelance');
      expect(second['p_remote'], true);
    });

    testWidgets('a double tap on Show more asks for one more page', (tester) async {
      await openFullPage(tester);
      await tester.dragUntilVisible(find.byKey(const Key('jobs-more')), find.byType(ListView), const Offset(0, -400));
      await tester.tap(find.byKey(const Key('jobs-more')));
      await tester.tap(find.byKey(const Key('jobs-more')));
      await settleCalls(tester);
      expect(site.forRpc('jobs_list').where((c) => c.body['p_before'] != null).length, 1);
    });

    testWidgets('a page that cannot be loaded says why, and tries again', (tester) async {
      var fail = true;
      site.rpcs['jobs_list'] = (_) => fail ? raised('Jobs are not open yet.') : ok([jobRow(deadline: fiveDays)]);
      await open(tester, '/jobs');
      expect(find.text('Jobs are not open yet.'), findsOneWidget);
      fail = false;
      await tester.tap(find.byKey(const Key('load-failed-retry')));
      await settleCalls(tester);
      expect(find.byKey(const Key('job-job1')), findsOneWidget);
    });

    testWidgets('leads to my applications, and a business also to its jobs', (tester) async {
      final router = await open(tester, '/jobs');
      expect(find.byKey(const Key('open-my-jobs')), findsNothing);
      await tap(tester, 'open-my-applications');
      await tester.pumpAndSettle();
      expect(path(router), '/me/applications');
      await tester.pumpWidget(const SizedBox());
      site.rpcs['profile_my_profiles'] = (_) => ok([myPersonal(), club]);
      final r2 = await open(tester, '/jobs', overrides: asClub);
      await tap(tester, 'open-my-jobs');
      await tester.pumpAndSettle();
      expect(path(r2), '/me/jobs');
    });
  });

  group('a job', () {
    testWidgets('shows the business, the title, the pay, the schedule, how long is left and the words', (tester) async {
      await open(tester, '/jobs/job1');
      expect(site.forRpc('job_get').single.body, {'p_actor': 'me', 'p_job': 'job1'});
      expect(textOf(tester, 'job-title'), 'Weekend bartender');
      expect(textOf(tester, 'job-pay'), '\$20 an hour plus tips');
      expect(textOf(tester, 'job-schedule'), 'Fri and Sat nights');
      expect(textOf(tester, 'job-deadline'), contains('(5 days left)'));
      expect(textOf(tester, 'job-description'), 'We need an experienced bartender for weekends.');
      expect(textOf(tester, 'job-requirements'), 'Two years behind a bar.');
      expect(find.text('Club X'), findsOneWidget);
      expect(find.text('Applying is free.'), findsOneWidget);
    });

    testWidgets('the business opens its page', (tester) async {
      final router = await open(tester, '/jobs/job1');
      await tap(tester, 'job-poster');
      await tester.pumpAndSettle();
      expect(path(router), '/u/clubx');
    });

    testWidgets('applying sends the message and the link, says so, and reads the job again to show the application', (tester) async {
      site.rpcs['job_apply'] = (_) => ok(applicationRow());
      await open(tester, '/jobs/job1');
      await tap(tester, 'apply');
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('apply-intro')), findsOneWidget);
      await tester.enterText(find.byKey(const Key('apply-message')), '  I have worked many bars in Toronto.  ');
      await tester.enterText(find.byKey(const Key('apply-link')), ' https://example.com/me ');
      site.rpcs['job_get'] = (_) => ok(jobRow(deadline: fiveDays, applied: {'id': 'ap1', 'state': 'sent'}));
      await tap(tester, 'apply-send');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(site.forRpc('job_apply').single.body, {'p_actor': 'me', 'p_job': 'job1', 'p_message': 'I have worked many bars in Toronto.', 'p_link': 'https://example.com/me'});
      expect(find.text('Your application was sent.'), findsOneWidget);
      expect(find.byKey(const Key('my-application')), findsOneWidget);
      expect(find.byKey(const Key('application-sent')), findsOneWidget);
      expect(find.byKey(const Key('apply')), findsNothing);
    });

    testWidgets('says what is wrong with an application before sending it', (tester) async {
      await open(tester, '/jobs/job1');
      await tap(tester, 'apply');
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('apply-message')), 'Hi');
      await tap(tester, 'apply-send');
      expect(textOf(tester, 'apply-problem'), 'Write a message of 20 to 2000 characters.');
      await tester.enterText(find.byKey(const Key('apply-message')), 'I have worked many bars in Toronto.');
      await tester.enterText(find.byKey(const Key('apply-link')), 'http://example.com');
      await tap(tester, 'apply-send');
      expect(textOf(tester, 'apply-problem'), 'A link must start with https:// and be up to 300 characters.');
      expect(site.forRpc('job_apply'), isEmpty);
    });

    testWidgets('a refusal is shown as it came', (tester) async {
      site.rpcs['job_apply'] = (_) => raised('You have already applied.');
      await open(tester, '/jobs/job1');
      await tap(tester, 'apply');
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('apply-message')), 'I have worked many bars in Toronto.');
      await tap(tester, 'apply-send');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(find.text('You have already applied.'), findsOneWidget);
    });

    testWidgets('nobody who has not accepted the community rules applies', (tester) async {
      site.rpcs['rules_status'] = (_) => ok({'version': 1, 'accepted': false});
      await open(tester, '/jobs/job1');
      await tap(tester, 'apply');
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('apply-message')), 'I have worked many bars in Toronto.');
      await tap(tester, 'apply-send');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(site.forRpc('job_apply'), isEmpty);
    });

    testWidgets('an application can be taken back after a question', (tester) async {
      site.rpcs['job_get'] = (_) => ok(jobRow(deadline: fiveDays, applied: {'id': 'ap1', 'state': 'shortlisted'}));
      site.rpcs['job_application_withdraw'] = (_) => ok(applicationRow(state: 'withdrawn'));
      await open(tester, '/jobs/job1');
      expect(find.byKey(const Key('application-shortlisted')), findsOneWidget);
      await tap(tester, 'withdraw-application');
      await tester.pumpAndSettle();
      await tap(tester, 'withdraw-keep');
      await tester.pumpAndSettle();
      expect(site.forRpc('job_application_withdraw'), isEmpty);
      await tap(tester, 'withdraw-application');
      await tester.pumpAndSettle();
      await tap(tester, 'withdraw-confirm');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(site.forRpc('job_application_withdraw').single.body, {'p_actor': 'me', 'p_application': 'ap1'});
      expect(find.text('Your application was taken back.'), findsOneWidget);
    });

    testWidgets('after an application was taken back it can be sent again', (tester) async {
      site.rpcs['job_get'] = (_) => ok(jobRow(deadline: fiveDays, applied: {'id': 'ap1', 'state': 'withdrawn'}));
      await open(tester, '/jobs/job1');
      expect(find.widgetWithText(FilledButton, 'Apply again'), findsOneWidget);
      expect(find.byKey(const Key('my-application')), findsNothing);
    });

    testWidgets('a job that is closed or filled takes no application', (tester) async {
      site.rpcs['job_get'] = (_) => ok(jobRow(deadline: fiveDays, status: 'closed', open: false));
      await open(tester, '/jobs/job1');
      expect(textOf(tester, 'job-closed'), 'This job is not taking applications.');
      expect(textOf(tester, 'job-deadline'), 'Closed');
      expect(find.byKey(const Key('apply')), findsNothing);
      await tester.pumpWidget(const SizedBox());
      site.rpcs['job_get'] = (_) => ok(jobRow(deadline: fiveDays, status: 'filled', open: false));
      await open(tester, '/jobs/job1');
      expect(textOf(tester, 'job-closed'), 'This job has been filled.');
      expect(textOf(tester, 'job-deadline'), 'Filled');
    });

    testWidgets('a job whose last day has passed is not open', (tester) async {
      site.rpcs['job_get'] = (_) => ok(jobRow(deadline: iso(DateTime(today.year, today.month, today.day - 1)), open: false));
      await open(tester, '/jobs/job1');
      expect(textOf(tester, 'job-deadline'), 'The last day has passed');
    });

    testWidgets('a job can be reported', (tester) async {
      site.rpcs['report_create'] = (_) => ok({'id': 'r1', 'already': false});
      await open(tester, '/jobs/job1');
      await tap(tester, 'job-menu');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('job-report')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('report-sheet')), findsOneWidget);
      await tap(tester, 'reason-scam');
      await tap(tester, 'report-send');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(site.forRpc('report_create').single.body, containsPair('p_kind', 'job'));
      expect(site.forRpc('report_create').single.body, containsPair('p_target', 'job1'));
    });

    testWidgets('says why it cannot be opened, and tries again', (tester) async {
      var fail = true;
      site.rpcs['job_get'] = (_) => fail ? raised('This job is not available.') : ok(jobRow(deadline: fiveDays));
      await open(tester, '/jobs/job1');
      expect(find.text('This job is not available.'), findsOneWidget);
      fail = false;
      await tester.tap(find.byKey(const Key('load-failed-retry')));
      await settleCalls(tester);
      expect(find.byKey(const Key('job-title')), findsOneWidget);
    });

    group('as the business', () {
      setUp(() => site.rpcs['profile_my_profiles'] = (_) => ok([myPersonal(), club]));

      testWidgets('sees how many applied and how many wait, can change or close it, and cannot report it', (tester) async {
        site.rpcs['job_get'] = (_) => ok(jobRow(deadline: fiveDays, mine: true, applications: 3, waiting: 2));
        await open(tester, '/jobs/job1', overrides: asClub);
        expect(find.widgetWithText(FilledButton, 'Applications (3, 2 waiting)'), findsOneWidget);
        expect(find.byKey(const Key('edit-job')), findsOneWidget);
        expect(find.byKey(const Key('close-job')), findsOneWidget);
        expect(find.byKey(const Key('apply')), findsNothing);
        expect(find.byKey(const Key('job-menu')), findsNothing);
      });

      testWidgets('a closed job can still be looked at but not changed', (tester) async {
        site.rpcs['job_get'] = (_) => ok(jobRow(deadline: fiveDays, mine: true, applications: 1, waiting: 0, status: 'closed', open: false));
        await open(tester, '/jobs/job1', overrides: asClub);
        expect(find.widgetWithText(FilledButton, 'Applications (1)'), findsOneWidget);
        expect(find.byKey(const Key('edit-job')), findsNothing);
        expect(find.byKey(const Key('close-job')), findsNothing);
      });

      testWidgets('leads to the applications and to the form, as the business', (tester) async {
        site.rpcs['job_get'] = (_) => ok(jobRow(deadline: fiveDays, mine: true, applications: 3, waiting: 2));
        site.rpcs['job_applications'] = (_) => ok(<Object>[]);
        final router = await open(tester, '/jobs/job1', overrides: asClub);
        await tap(tester, 'see-applications');
        await tester.pumpAndSettle();
        expect(router.routerDelegate.currentConfiguration.last.matchedLocation, '/me/jobs/job1/applications');
        expect(site.forRpc('job_applications').single.body, {'p_actor': 'p-club', 'p_job': 'job1'});
      });

      testWidgets('a team member who is not the business itself closes it as the business', (tester) async {
        site.rpcs['job_get'] = (_) => ok(jobRow(deadline: fiveDays, mine: true, applications: 3, waiting: 2));
        site.rpcs['job_close'] = (_) => ok(jobRow(status: 'closed', open: false));
        await open(tester, '/jobs/job1');
        await tap(tester, 'close-job');
        await tester.pumpAndSettle();
        await tap(tester, 'close-plain');
        await tester.pumpAndSettle();
        await settleCalls(tester);
        expect(site.forRpc('job_close').single.body, {'p_actor': 'p-club', 'p_job': 'job1', 'p_filled': false});
      });

      testWidgets('closing asks whether somebody was found, and sends it as the business', (tester) async {
        site.rpcs['job_get'] = (_) => ok(jobRow(deadline: fiveDays, mine: true, applications: 3, waiting: 2));
        site.rpcs['job_close'] = (_) => ok(jobRow(status: 'filled', open: false));
        await open(tester, '/jobs/job1', overrides: asClub);
        await tap(tester, 'close-job');
        await tester.pumpAndSettle();
        await tap(tester, 'close-keep');
        await tester.pumpAndSettle();
        expect(site.forRpc('job_close'), isEmpty);
        await tap(tester, 'close-job');
        await tester.pumpAndSettle();
        await tap(tester, 'close-filled');
        await tester.pumpAndSettle();
        await settleCalls(tester);
        expect(site.forRpc('job_close').single.body, {'p_actor': 'p-club', 'p_job': 'job1', 'p_filled': true});
        expect(find.text('The job is closed.'), findsOneWidget);
        await tap(tester, 'close-job');
        await tester.pumpAndSettle();
        await tap(tester, 'close-plain');
        await tester.pumpAndSettle();
        await settleCalls(tester);
        expect(site.forRpc('job_close').last.body['p_filled'], false);
      });
    });
  });
}
