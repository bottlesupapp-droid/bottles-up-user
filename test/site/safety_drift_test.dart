import 'package:bottles_up_user/site/models/safety.dart';
import 'package:bottles_up_user/site/services/safety_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';
import '../support/website_files.dart';

/// The app against the website's safety migration.
void main() {
  group('safety against the website', skip: websiteIsHere ? null : websiteMissing, () {
    late String sql;
    setUpAll(() => sql = migrationCode('safety_moderation'));

    test('the functions the app calls exist, with the parameters the app sends', () async {
      final site = FakeWebsite();
      final service = SafetyService(site.client);
      site.rpcs['report_create'] = (_) => ok({'id': 'r', 'already': false});
      site.rpcs['rules_current'] = (_) => ok({'version': 1, 'body': null});
      await service.report(actor: 'a', kind: ReportKind.post, target: 't', reason: ReportReason.spam, details: 'x');
      await service.rules();
      for (final r in site.rpcRequests) {
        final params = sqlFunctionParamInfo(r.name);
        final names = params.map((p) => p.name).toSet();
        expect(names.containsAll(r.body.keys), isTrue, reason: '${r.name}: the app sends ${r.body.keys.toList()} but the function takes $names');
        for (final p in params) {
          if (!p.hasDefault) expect(r.body.keys, contains(p.name), reason: '${r.name} needs ${p.name} and the app does not send it');
        }
      }
    });

    test('the kinds and reasons the app offers are exactly the ones the website accepts', () {
      expect(sqlWordsAfter(sql, "kind text not null check (kind in"), {for (final k in ReportKind.values) k.wire});
      expect(sqlWordsAfter(sql, "reason text not null check (reason in"), {for (final r in ReportReason.values) r.wire});
    });

    test('the limits the app says', () {
      expect(sql, contains('char_length(btrim(details)) between 1 and 500'));
      expect(sql, contains("raise exception 'Keep it to 500 characters.'"));
      expect(sql, contains(">= 20 then\n    raise exception 'You have sent a lot of reports today. Our team is looking at them.'"));
    });

    test('rules are read by anyone, so a guest can read them before signing up', () {
      final all = allMigrations();
      expect(all, contains('grant execute on function public.rules_current() to anon, authenticated, service_role;'));
    });
  });
}
