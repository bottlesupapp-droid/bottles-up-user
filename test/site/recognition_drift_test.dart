import 'package:bottles_up_user/site/models/features.dart';
import 'package:bottles_up_user/site/models/jobs.dart';
import 'package:bottles_up_user/site/models/recognition.dart';
import 'package:bottles_up_user/site/services/jobs_service.dart';
import 'package:bottles_up_user/site/services/recognition_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/recognition_fixtures.dart';
import '../support/website_files.dart';

/// The app against the website's verification, ranks, plaques and jobs migration.
void main() {
  group('recognition and jobs against the website', skip: websiteIsHere ? null : websiteMissing, () {
    late String sql;
    setUpAll(() {
      sql = migrationCode('recognition_jobs');
    });

    String bodyOf(String fn) {
      final start = sql.indexOf('function public.$fn(');
      expect(start, greaterThanOrEqualTo(0), reason: fn);
      final end = sql.indexOf('\ncreate function', start + 10);
      return sql.substring(start, end == -1 ? sql.length : end);
    }

    test('the functions the app calls exist, with the parameters the app sends', () async {
      final site = FakeWebsite();
      final r = RecognitionService(site.client);
      final j = JobsService(site.client);
      site.rpcs['rank_levels'] = (_) => ok([levelRow()]);
      site.rpcs['verification_status'] = (_) => ok(verificationRow());
      site.rpcs['verification_request'] = (_) => ok(verificationRow());
      site.rpcs['rank_status'] = (_) => ok(rankStatusRow());
      site.rpcs['rank_request'] = (_) => ok(rankStatusRow());
      site.rpcs['awards_of'] = (_) => ok([awardRow()]);
      site.rpcs['plaques_mine'] = (_) => ok([plaqueRow()]);
      site.rpcs['plaque_claim'] = (_) => ok(plaqueRow());
      site.rpcs['plaque_cancel'] = (_) => ok(plaqueRow(state: 'cancelled', removed: true));
      for (final f in ['job_create', 'job_update', 'job_close', 'job_get']) {
        site.rpcs[f] = (_) => ok(jobRow());
      }
      site.rpcs['jobs_list'] = (_) => ok([jobRow()]);
      site.rpcs['jobs_mine'] = (_) => ok([jobRow()]);
      for (final f in ['job_apply', 'job_application_set', 'job_application_withdraw']) {
        site.rpcs[f] = (_) => ok(applicationRow());
      }
      site.rpcs['job_applications'] = (_) => ok([applicationRow()]);
      site.rpcs['job_applications_mine'] = (_) => ok([applicationRow()]);

      await r.levels();
      await r.verification('p');
      await r.requestVerification(profile: 'p', note: 'n');
      await r.rankStatus('p');
      await r.requestRank('p');
      await r.awards(actor: 'a', profile: 'p');
      await r.plaques('p');
      await r.claimPlaque(award: 'aw', address: const PlaqueAddress(recipient: 'Ann', line1: '1 King', city: 'Toronto', postal: 'M5V', country: 'Canada', line2: 'x', region: 'ON', phone: '1'));
      await r.cancelPlaque('pq');
      final draft = JobDraft(title: 'Weekend bartender', kind: JobKind.partTime, description: 'We need a bartender.', compensation: '\$20', deadline: DateTime(2099, 1, 1), requirements: 'r', location: 'Toronto', schedule: 's');
      await j.create(actor: 'a', draft: draft);
      await j.update(actor: 'a', id: 'j', draft: draft);
      await j.close(actor: 'a', id: 'j', filled: true);
      await j.job(actor: 'a', id: 'j');
      await j.list(actor: 'a', kind: JobKind.freelance, query: 'q', remote: true, before: DateTime(2099, 1, 1), beforeId: 'b', limit: 5);
      await j.mine('a');
      await j.apply(actor: 'a', job: 'j', message: 'Hello, I am free.', link: 'https://x.example');
      await j.applications(actor: 'a', job: 'j');
      await j.answer(actor: 'a', application: 'ap', state: ApplicationState.accepted, reply: 'ok');
      await j.withdraw(actor: 'a', application: 'ap');
      await j.myApplications('a');
      expect(site.rpcRequests.length, 20);
      for (final req in site.rpcRequests) {
        final params = sqlFunctionParamInfo(req.name);
        final names = params.map((p) => p.name).toSet();
        expect(names.containsAll(req.body.keys), isTrue, reason: '${req.name}: the app sends ${req.body.keys.toList()} but the function takes $names');
        for (final p in params) {
          if (!p.hasDefault) expect(req.body.keys, contains(p.name), reason: '${req.name} needs ${p.name} and the app does not send it');
        }
      }
    });

    test('a person can call what a person calls, and the helpers are not for them', () {
      final people = RegExp(r'grant execute on function([\s\S]*?)to authenticated;', caseSensitive: false).allMatches(sql).map((m) => m.group(1)!).join('\n');
      for (final f in [
        'rank_levels', 'verification_status', 'verification_request', 'rank_status', 'rank_request', 'awards_of', 'plaques_mine', 'plaque_claim', 'plaque_cancel', 'job_create', 'job_update', 'job_close',
        'job_get', 'jobs_list', 'jobs_mine', 'job_apply', 'job_applications', 'job_application_set', 'job_application_withdraw', 'job_applications_mine',
      ]) {
        expect(people, contains('public.$f('), reason: f);
      }
      for (final f in ['recognition_require', 'profile_followers', 'rank_target', 'plaque_json', 'plaque_addresses_wipe', 'job_visible', 'job_json', 'job_application_json', 'job_check']) {
        expect(people, isNot(contains('public.$f(')), reason: '$f is internal');
      }
    });

    test('the switches the app looks at are the ones the website checks', () {
      for (final f in ['verification_status', 'verification_request', 'rank_status', 'rank_request', 'plaques_mine', 'plaque_claim', 'plaque_cancel']) {
        expect(bodyOf(f), contains("recognition_require('${Feature.ranks}')"), reason: f);
      }
      for (final f in ['job_create', 'job_update', 'job_close', 'job_get', 'jobs_list', 'jobs_mine', 'job_apply', 'job_applications', 'job_application_set', 'job_application_withdraw', 'job_applications_mine']) {
        expect(bodyOf(f), contains("recognition_require('${Feature.jobs}')"), reason: f);
      }
    });

    test('the kinds of job, the states of an application and of a plaque are the website\'s', () {
      expect(sqlWordsAfter(sql, "kind text not null check (kind in ('full_time'"), {for (final k in JobKind.values) k.wire});
      expect(sqlWordsAfter(sql, "state text not null default 'sent' check (state in"), {for (final s in ApplicationState.values) s.wire});
      expect(sqlWordsAfter(sql, "state text not null default 'requested' check (state in ('requested', 'shipped'"), {'requested', 'shipped', 'delivered', 'cancelled'});
      expect(sqlWordsAfter(sql, "status text not null default 'open' check (status in"), {'open', 'closed', 'filled', 'removed'});
    });

    test('the ranks the app proposes are the ones the website starts with', () {
      for (final l in proposedRanks) {
        expect(sql, contains("('${l.key}', '${l.name}', ${l.minFollowers}, "), reason: l.key);
        expect(sql, contains("'#${l.colour.toRadixString(16).substring(2).toUpperCase()}'"), reason: '${l.key} colour');
      }
    });

    test('the fields the app reads are the ones the website writes', () {
      final fields = <String, List<String>>{
        'rank_levels': ['key', 'name', 'min_followers', 'colour', 'plaque'],
        'verification_status': ['verified', 'via', 'org_run', 'request', 'id', 'state', 'note', 'reason', 'created_at', 'retry_on'],
        'rank_status': ['verified', 'rank', 'followers', 'next', 'target', 'can_request', 'pending', 'rejected', 'level', 'reason', 'retry_on', 'key', 'name', 'min_followers', 'colour'],
        'awards_of': ['id', 'level', 'name', 'colour', 'awarded_at', 'plaque'],
        'plaque_json': ['id', 'award', 'level', 'level_name', 'state', 'recipient', 'line1', 'line2', 'city', 'region', 'postal', 'country', 'phone', 'carrier', 'tracking', 'address_removed'],
        'job_json': ['id', 'title', 'kind', 'description', 'requirements', 'compensation', 'location', 'remote', 'schedule', 'deadline', 'status', 'created_at', 'open', 'poster', 'mine', 'applications', 'waiting', 'applied'],
        'job_application_json': ['id', 'state', 'message', 'link', 'reply', 'created_at', 'decided_at', 'applicant', 'job', 'title', 'kind', 'status', 'deadline', 'open', 'poster'],
      };
      fields.forEach((fn, keys) {
        final body = bodyOf(fn);
        for (final k in keys) {
          expect(body, contains("'$k'"), reason: '$fn.$k');
        }
      });
    });

    test('the profile carries its rank next to its tick', () {
      final profiles = migrationCode('social_profiles');
      final posts = migrationCode('social_posts');
      expect(profiles, contains("'rank', public.profile_badge(p.id) -> 'rank'"));
      expect(posts, contains("'rank', public.profile_badge(p.id) -> 'rank'"));
    });

    test('a job can be reported', () {
      final safety = migrationCode('safety_moderation');
      expect(safety, contains("'review', 'job'"));
    });
  });
}
