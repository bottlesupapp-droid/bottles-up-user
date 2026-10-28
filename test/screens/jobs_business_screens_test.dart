import 'package:bottles_up_user/features/hiring/widgets/hiring_widgets.dart';
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
  late List<Uri> opened;
  final on = {'social': true, 'jobs': true};
  final today = DateTime.now();
  String iso(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  final soon = DateTime(today.year, today.month, today.day + 30);
  final asClub = [selectedProfileIdProvider.overrideWith((ref) => 'p-club')];
  final club = {...profileRow(id: 'p-club', kind: 'business', handle: 'clubx', name: 'Club X', category: 'venue'), 'is_mine': true};

  String path(GoRouter r) => r.routerDelegate.currentConfiguration.last.matchedLocation;

  setUp(() {
    site = FakeWebsite();
    opened = [];
    site.rpcs['rules_status'] = (_) => ok({'version': 1, 'accepted': true});
    site.rpcs['profile_my_profiles'] = (_) => ok([myPersonal(), club]);
    site.rpcs['jobs_mine'] = (_) => ok([jobRow(mine: true, applications: 3, waiting: 2), jobRow(id: 'job2', title: 'Door staff', status: 'filled', open: false, mine: true, applications: 1, waiting: 0)]);
  });

  Future<void> tap(WidgetTester tester, String key) async {
    await tester.ensureVisible(find.byKey(Key(key)));
    await tester.tap(find.byKey(Key(key)));
    await tester.pump();
  }

  Future<void> type(WidgetTester tester, String key, String text) async {
    await tester.ensureVisible(find.byKey(Key(key)));
    await tester.enterText(find.byKey(Key(key)), text);
    await tester.pump();
  }

  Future<GoRouter> open(WidgetTester tester, String location, {Map<String, bool>? features, List<Override> overrides = const []}) async {
    final router = await openSocial(tester, site, location, features: features ?? on, opened: opened, overrides: overrides);
    await settleCalls(tester);
    return router;
  }

  group('my jobs', () {
    testWidgets('says it is not open yet while jobs are off', (tester) async {
      await open(tester, '/me/jobs', features: {'social': true}, overrides: asClub);
      expect(find.text('Jobs are not open yet.'), findsOneWidget);
    });

    testWidgets('a personal profile is asked to switch to a business one', (tester) async {
      await open(tester, '/me/jobs');
      expect(find.text('Switch to a business profile'), findsOneWidget);
      expect(find.byKey(const Key('post-job')), findsNothing);
      expect(site.forRpc('jobs_mine'), isEmpty);
    });

    testWidgets('lists the listings with how many applied and how many wait, and opens one', (tester) async {
      final router = await open(tester, '/me/jobs', overrides: asClub);
      expect(site.forRpc('jobs_mine').single.body, {'p_actor': 'p-club'});
      expect(textOf(tester, 'job-counts-job1'), '3 applications · 2 waiting');
      expect(textOf(tester, 'job-counts-job2'), '1 application');
      expect(textOf(tester, 'job-deadline-job2'), 'Filled');
      site.rpcs['job_get'] = (_) => ok(jobRow(mine: true, applications: 3, waiting: 2));
      await tap(tester, 'job-job1');
      await tester.pumpAndSettle();
      expect(path(router), '/jobs/job1');
    });

    testWidgets('has an empty state and a way to post, and says why it cannot load', (tester) async {
      site.rpcs['jobs_mine'] = (_) => ok(<Object>[]);
      final router = await open(tester, '/me/jobs', overrides: asClub);
      expect(find.text('No jobs yet'), findsOneWidget);
      await tap(tester, 'post-job');
      await tester.pumpAndSettle();
      expect(path(router), '/me/jobs/new');
      await tester.pumpWidget(const SizedBox());
      var fail = true;
      site.rpcs['jobs_mine'] = (_) => fail ? raised('Your role on this profile does not allow this.') : ok([jobRow(mine: true)]);
      await open(tester, '/me/jobs', overrides: asClub);
      expect(find.text('Your role on this profile does not allow this.'), findsOneWidget);
      fail = false;
      await tester.tap(find.byKey(const Key('load-failed-retry')));
      await settleCalls(tester);
      expect(find.byKey(const Key('job-job1')), findsOneWidget);
    });
  });

  group('posting a job', () {
    List<Override> picking(DateTime? day) => [...asClub, dayPickerProvider.overrideWithValue((context, {required first, required last, required initial}) async => day)];

    Future<void> fillAll(WidgetTester tester) async {
      await type(tester, 'job-title-field', '  Weekend bartender ');
      await tap(tester, 'job-kind-field');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Part-time').last);
      await tester.pumpAndSettle();
      await type(tester, 'job-description-field', 'We need an experienced bartender for weekends.');
      await type(tester, 'job-requirements-field', ' Two years behind a bar. ');
      await type(tester, 'job-compensation-field', '\$20 an hour plus tips');
      await type(tester, 'job-location-field', ' Toronto ');
      await type(tester, 'job-schedule-field', ' Fri and Sat nights ');
      await tap(tester, 'job-deadline-field');
      await settleCalls(tester);
    }

    testWidgets('sends everything as the business, then opens the job', (tester) async {
      site.rpcs['job_create'] = (_) => ok(jobRow(mine: true));
      site.rpcs['job_get'] = (_) => ok(jobRow(mine: true, applications: 0, waiting: 0));
      final router = await open(tester, '/me/jobs/new?as=p-club', overrides: picking(soon));
      await fillAll(tester);
      await tap(tester, 'job-save');
      await settleCalls(tester);
      await tester.pumpAndSettle();
      expect(site.forRpc('job_create').single.body, {
        'p_actor': 'p-club',
        'p_title': 'Weekend bartender',
        'p_kind': 'part_time',
        'p_description': 'We need an experienced bartender for weekends.',
        'p_requirements': 'Two years behind a bar.',
        'p_compensation': '\$20 an hour plus tips',
        'p_location': 'Toronto',
        'p_remote': false,
        'p_schedule': 'Fri and Sat nights',
        'p_deadline': iso(soon),
      });
      expect(path(router), '/jobs/job1');
      expect(router.canPop(), isFalse, reason: 'the form is replaced by the job');
    });

    testWidgets('leaves out what was not filled in, and a remote job needs no place', (tester) async {
      site.rpcs['job_create'] = (_) => ok(jobRow(mine: true));
      site.rpcs['job_get'] = (_) => ok(jobRow(mine: true));
      await open(tester, '/me/jobs/new?as=p-club', overrides: picking(soon));
      await type(tester, 'job-title-field', 'Remote promoter');
      await tap(tester, 'job-kind-field');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Promoter or ambassador').last);
      await tester.pumpAndSettle();
      await type(tester, 'job-description-field', 'Promote our nights to your followers.');
      await type(tester, 'job-compensation-field', 'Commission on tickets');
      await tap(tester, 'job-remote-field');
      await tap(tester, 'job-deadline-field');
      await settleCalls(tester);
      await tap(tester, 'job-save');
      await settleCalls(tester);
      final sent = site.forRpc('job_create').single.body;
      expect([sent['p_requirements'], sent['p_location'], sent['p_schedule'], sent['p_remote'], sent['p_kind']], [null, null, null, true, 'ambassador']);
    });

    testWidgets('says what is missing before anything is sent', (tester) async {
      await open(tester, '/me/jobs/new?as=p-club', overrides: picking(soon));
      await tap(tester, 'job-save');
      expect(textOf(tester, 'job-problem'), 'Write a title of 5 to 120 characters.');
      await type(tester, 'job-title-field', 'Weekend bartender');
      await tap(tester, 'job-save');
      expect(textOf(tester, 'job-problem'), 'Choose what kind of job it is.');
      await tap(tester, 'job-kind-field');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Freelance gig').last);
      await tester.pumpAndSettle();
      await tap(tester, 'job-save');
      expect(textOf(tester, 'job-problem'), 'Describe the job in 20 to 4000 characters.');
      await type(tester, 'job-description-field', 'We need an experienced bartender for weekends.');
      await tap(tester, 'job-save');
      expect(textOf(tester, 'job-problem'), 'Say what it pays (2 to 200 characters).');
      await type(tester, 'job-compensation-field', '\$20');
      await tap(tester, 'job-save');
      expect(textOf(tester, 'job-problem'), 'Say where it is, or that it can be done remotely.');
      await type(tester, 'job-location-field', 'Toronto');
      await tap(tester, 'job-save');
      expect(textOf(tester, 'job-problem'), 'Choose a last day to apply, from today to a year away.');
      expect(site.forRpc('job_create'), isEmpty);
    });

    testWidgets('offers days from today to a year away', (tester) async {
      final log = <({DateTime first, DateTime last, DateTime initial})>[];
      await open(tester, '/me/jobs/new?as=p-club', overrides: [
        ...asClub,
        dayPickerProvider.overrideWithValue((context, {required first, required last, required initial}) async {
          log.add((first: first, last: last, initial: initial));
          return null;
        }),
      ]);
      await tap(tester, 'job-deadline-field');
      await settleCalls(tester);
      final d = DateTime.now();
      expect(log.single.first, DateTime(d.year, d.month, d.day));
      expect(log.single.last, DateTime(d.year, d.month, d.day + 365));
      expect(log.single.initial, DateTime(d.year, d.month, d.day + 30));
      expect(find.text('Last day to apply'), findsOneWidget, reason: 'nothing was chosen');
    });

    testWidgets('a refusal is shown as it came and the form stays', (tester) async {
      site.rpcs['job_create'] = (_) => raised('You have posted a lot of jobs today. Try again tomorrow.');
      await open(tester, '/me/jobs/new?as=p-club', overrides: picking(soon));
      await fillAll(tester);
      await tap(tester, 'job-save');
      await settleCalls(tester);
      expect(textOf(tester, 'job-problem'), 'You have posted a lot of jobs today. Try again tomorrow.');
      expect(find.byKey(const Key('job-form')), findsOneWidget);
    });

    testWidgets('a double tap on Post sends one job', (tester) async {
      site.rpcs['job_create'] = (_) => ok(jobRow(mine: true));
      site.rpcs['job_get'] = (_) => ok(jobRow(mine: true));
      await open(tester, '/me/jobs/new?as=p-club', overrides: picking(soon));
      await fillAll(tester);
      await tester.ensureVisible(find.byKey(const Key('job-save')));
      await tester.tap(find.byKey(const Key('job-save')));
      await tester.tap(find.byKey(const Key('job-save')));
      await settleCalls(tester);
      expect(site.forRpc('job_create').length, 1);
    });

    testWidgets('nobody who has not accepted the community rules posts', (tester) async {
      site.rpcs['rules_status'] = (_) => ok({'version': 1, 'accepted': false});
      await open(tester, '/me/jobs/new?as=p-club', overrides: picking(soon));
      await fillAll(tester);
      await tap(tester, 'job-save');
      await settleCalls(tester);
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(site.forRpc('job_create'), isEmpty);
    });

    testWidgets('changing a job starts from what it says and sends it as the business, without asking about the rules again', (tester) async {
      site.rpcs['rules_status'] = (_) => ok({'version': 1, 'accepted': false});
      site.rpcs['job_get'] = (_) => ok(jobRow(mine: true, applications: 0, waiting: 0, deadline: iso(soon)));
      site.rpcs['job_update'] = (_) => ok(jobRow(mine: true));
      await open(tester, '/me/jobs/job1/edit?as=p-club', overrides: picking(soon));
      expect(site.forRpc('job_get').first.body, {'p_actor': 'p-club', 'p_job': 'job1'});
      expect(tester.widget<TextField>(find.byKey(const Key('job-title-field'))).controller!.text, 'Weekend bartender');
      expect(tester.widget<TextField>(find.byKey(const Key('job-location-field'))).controller!.text, 'Toronto');
      expect(tester.widget<TextField>(find.byKey(const Key('job-compensation-field'))).controller!.text, '\$20 an hour plus tips');
      expect(find.text('Save the changes'), findsOneWidget);
      await type(tester, 'job-title-field', 'Weekend head bartender');
      await tap(tester, 'job-save');
      await settleCalls(tester);
      final sent = site.forRpc('job_update').single.body;
      expect([sent['p_actor'], sent['p_job'], sent['p_title'], sent['p_kind'], sent['p_deadline']], ['p-club', 'job1', 'Weekend head bartender', 'part_time', iso(soon)]);
      expect(site.forRpc('job_create'), isEmpty);
    });

    testWidgets('says it is not open yet while jobs are off, and why a job cannot be read', (tester) async {
      await open(tester, '/me/jobs/new?as=p-club', features: {'social': true}, overrides: asClub);
      expect(find.text('Jobs are not open yet.'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      site.rpcs.remove('site_features');
      site.rpcs['job_get'] = (_) => raised('This job is not available.');
      await open(tester, '/me/jobs/job1/edit?as=p-club', overrides: asClub);
      expect(find.text('This job is not available.'), findsOneWidget);
    });
  });

  group('the applications to a job', () {
    final applications = [
      applicationRow(),
      applicationRow(id: 'ap2', state: 'shortlisted', link: null),
      applicationRow(id: 'ap3', state: 'accepted', reply: 'Welcome aboard.', link: null),
      applicationRow(id: 'ap4', state: 'declined', link: null),
    ];

    setUp(() => site.rpcs['job_applications'] = (_) => ok(applications));

    testWidgets('lists who applied, what they wrote and where each stands', (tester) async {
      await open(tester, '/me/jobs/job1/applications?as=p-club');
      expect(site.forRpc('job_applications').single.body, {'p_actor': 'p-club', 'p_job': 'job1'});
      expect(textOf(tester, 'application-message-ap1'), 'I have worked many bars in Toronto.');
      expect(find.descendant(of: find.byKey(const Key('application-ap1')), matching: find.text('Bob Ray  @bob')), findsOneWidget);
      expect(find.descendant(of: find.byKey(const Key('application-ap1')), matching: find.byKey(const Key('application-sent'))), findsOneWidget);
      expect(find.descendant(of: find.byKey(const Key('application-ap3')), matching: find.text('Your reply: Welcome aboard.')), findsOneWidget);
    });

    testWidgets('offers only the answers that make sense for where each application stands', (tester) async {
      await open(tester, '/me/jobs/job1/applications?as=p-club');
      List<int> buttons(String id) => [for (final k in ['shortlist', 'accept', 'decline']) find.byKey(Key('$k-$id')).evaluate().length];
      expect(buttons('ap1'), [1, 1, 1]);
      expect(buttons('ap2'), [0, 1, 1], reason: 'already shortlisted');
      expect(buttons('ap3'), [0, 0, 1], reason: 'already accepted');
      expect(buttons('ap4'), [0, 1, 0], reason: 'already turned down');
    });

    testWidgets('shortlisting asks nothing and sends no reply', (tester) async {
      site.rpcs['job_application_set'] = (_) => ok(applicationRow(state: 'shortlisted'));
      await open(tester, '/me/jobs/job1/applications?as=p-club');
      await tap(tester, 'shortlist-ap1');
      await settleCalls(tester);
      expect(site.forRpc('job_application_set').single.body, {'p_actor': 'p-club', 'p_application': 'ap1', 'p_state': 'shortlisted', 'p_reply': null});
      expect(site.forRpc('job_applications').length, greaterThanOrEqualTo(2), reason: 'the list is read again');
    });

    testWidgets('accepting asks for an optional reply and sends it, trimmed', (tester) async {
      site.rpcs['job_application_set'] = (_) => ok(applicationRow(state: 'accepted'));
      await open(tester, '/me/jobs/job1/applications?as=p-club');
      await tap(tester, 'accept-ap1');
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('reply-intro')), findsOneWidget);
      expect(find.text('Accept Bob Ray?'), findsOneWidget);
      await tester.enterText(find.byKey(const Key('reply-field')), '  Welcome aboard.  ');
      await tap(tester, 'reply-confirm');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(site.forRpc('job_application_set').single.body, {'p_actor': 'p-club', 'p_application': 'ap1', 'p_state': 'accepted', 'p_reply': 'Welcome aboard.'});
    });

    testWidgets('turning down can be done with no reply, or cancelled', (tester) async {
      site.rpcs['job_application_set'] = (_) => ok(applicationRow(state: 'declined'));
      await open(tester, '/me/jobs/job1/applications?as=p-club');
      await tap(tester, 'decline-ap1');
      await tester.pumpAndSettle();
      expect(find.text('Turn down Bob Ray?'), findsOneWidget);
      await tap(tester, 'reply-keep');
      await tester.pumpAndSettle();
      expect(site.forRpc('job_application_set'), isEmpty);
      await tap(tester, 'decline-ap1');
      await tester.pumpAndSettle();
      await tap(tester, 'reply-confirm');
      await tester.pumpAndSettle();
      await settleCalls(tester);
      expect(site.forRpc('job_application_set').single.body['p_reply'], isNull);
      expect(site.forRpc('job_application_set').single.body['p_state'], 'declined');
    });

    testWidgets('a refusal is shown as it came', (tester) async {
      site.rpcs['job_application_set'] = (_) => raised('The applicant has taken this application back.');
      await open(tester, '/me/jobs/job1/applications?as=p-club');
      await tap(tester, 'shortlist-ap1');
      await settleCalls(tester);
      expect(find.text('The applicant has taken this application back.'), findsOneWidget);
    });

    testWidgets('a link opens in the app, and the applicant\'s profile opens', (tester) async {
      final router = await open(tester, '/me/jobs/job1/applications?as=p-club');
      await tap(tester, 'application-link-ap1');
      await tester.pump();
      expect(opened.single.toString(), 'https://example.com/me');
      await tester.tap(find.descendant(of: find.byKey(const Key('application-ap1')), matching: find.text('Bob Ray  @bob')));
      await tester.pumpAndSettle();
      expect(path(router), '/u/bob');
    });

    testWidgets('says plainly when nobody has applied, and why it cannot load', (tester) async {
      site.rpcs['job_applications'] = (_) => ok(<Object>[]);
      await open(tester, '/me/jobs/job1/applications?as=p-club');
      expect(find.text('No applications yet'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      var fail = true;
      site.rpcs['job_applications'] = (_) => fail ? raised('This job is not available.') : ok(applications);
      await open(tester, '/me/jobs/job1/applications?as=p-club');
      expect(find.text('This job is not available.'), findsOneWidget);
      fail = false;
      await tester.tap(find.byKey(const Key('load-failed-retry')));
      await settleCalls(tester);
      expect(find.byKey(const Key('application-ap1')), findsOneWidget);
    });

    testWidgets('says it is not open yet while jobs are off', (tester) async {
      await open(tester, '/me/jobs/job1/applications?as=p-club', features: {'social': true});
      expect(find.text('Jobs are not open yet.'), findsOneWidget);
    });
  });

  group('my applications', () {
    testWidgets('lists the jobs applied for, where each stands and the reply', (tester) async {
      site.rpcs['job_applications_mine'] = (_) => ok([applicationRow(state: 'accepted', reply: 'Welcome aboard.'), applicationRow(id: 'ap2', state: 'sent')]);
      final router = await open(tester, '/me/applications');
      expect(site.forRpc('job_applications_mine').single.body, {'p_actor': 'me'});
      expect(find.descendant(of: find.byKey(const Key('my-application-ap1')), matching: find.text('Weekend bartender')), findsOneWidget);
      expect(find.descendant(of: find.byKey(const Key('my-application-ap1')), matching: find.byKey(const Key('application-accepted'))), findsOneWidget);
      expect(textOf(tester, 'my-application-reply-ap1'), 'Reply: Welcome aboard.');
      expect(find.byKey(const Key('my-application-reply-ap2')), findsNothing);
      site.rpcs['job_get'] = (_) => ok(jobRow());
      await tap(tester, 'my-application-ap1');
      await tester.pumpAndSettle();
      expect(path(router), '/jobs/job1');
    });

    testWidgets('has an empty state, says why it cannot load, and says it is not open yet', (tester) async {
      site.rpcs['job_applications_mine'] = (_) => ok(<Object>[]);
      await open(tester, '/me/applications');
      expect(find.text('No applications yet'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      var fail = true;
      site.rpcs['job_applications_mine'] = (_) => fail ? raised('Jobs are not open yet.') : ok([applicationRow()]);
      await open(tester, '/me/applications');
      expect(find.text('Jobs are not open yet.'), findsOneWidget);
      fail = false;
      await tester.tap(find.byKey(const Key('load-failed-retry')));
      await settleCalls(tester);
      expect(find.byKey(const Key('my-application-ap1')), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      site.rpcs.remove('site_features');
      await open(tester, '/me/applications', features: {'social': true});
      expect(find.text('Jobs are not open yet.'), findsOneWidget);
    });
  });
}
