import 'package:bottles_up_user/site/models/safety.dart';
import 'package:bottles_up_user/site/services/safety_service.dart';
import 'package:bottles_up_user/site/site_error.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_website.dart';

void main() {
  late FakeWebsite site;
  late SafetyService service;

  setUp(() {
    site = FakeWebsite();
    service = SafetyService(site.client);
  });

  Matcher sentence(String s) => throwsA(isA<SiteException>().having((e) => e.message, 'message', s));

  test('a report goes with who made it, what it is about, why and the words', () async {
    site.rpcs['report_create'] = (_) => ok({'id': 'r1', 'already': false});
    final receipt = await service.report(actor: 'me', kind: ReportKind.comment, target: 'c1', reason: ReportReason.selfHarm, details: '  worried  ');
    expect(receipt.id, 'r1');
    expect(receipt.already, isFalse);
    expect(site.forRpc('report_create').single.body, {'p_actor': 'me', 'p_kind': 'comment', 'p_target': 'c1', 'p_reason': 'self_harm', 'p_details': 'worried'});
  });

  test('no words, or only spaces, are sent as nothing', () async {
    site.rpcs['report_create'] = (_) => ok({'id': 'r1', 'already': true});
    final receipt = await service.report(actor: 'me', kind: ReportKind.post, target: 'p1', reason: ReportReason.spam, details: '   ');
    expect(receipt.already, isTrue);
    await service.report(actor: 'me', kind: ReportKind.post, target: 'p1', reason: ReportReason.spam);
    expect(site.forRpc('report_create').map((c) => c.body['p_details']), [null, null]);
  });

  test('the website\'s refusals are shown', () async {
    site.rpcs['report_create'] = (_) => raised('You can\'t report your own profile or what you wrote.');
    await expectLater(service.report(actor: 'me', kind: ReportKind.profile, target: 'me', reason: ReportReason.spam), sentence('You can\'t report your own profile or what you wrote.'));
    site.rpcs['report_create'] = (_) => raised('You have sent a lot of reports today. Our team is looking at them.');
    await expectLater(service.report(actor: 'me', kind: ReportKind.post, target: 'p', reason: ReportReason.spam), sentence('You have sent a lot of reports today. Our team is looking at them.'));
  });

  test('an answer it cannot read is an error, not a pretend success', () async {
    site.rpcs['report_create'] = (_) => ok({'oops': 1});
    await expectLater(service.report(actor: 'me', kind: ReportKind.post, target: 'p', reason: ReportReason.spam), throwsA(isA<SiteException>()));
  });

  test('a dropped connection says the report may not have been sent', () async {
    site.networkDown = true;
    await expectLater(service.report(actor: 'me', kind: ReportKind.post, target: 'p', reason: ReportReason.spam), throwsA(isA<SiteException>().having((e) => e.message, 'message', contains('not sent'))));
  });

  test('the rules are read; a failure says so', () async {
    site.rpcs['rules_current'] = (_) => ok({'version': 4, 'body': 'Be kind to each other.'});
    final r = await service.rules();
    expect(r.version, 4);
    expect(r.body, 'Be kind to each other.');
    expect(site.forRpc('rules_current').single.body, isEmpty);
    site.networkDown = true;
    await expectLater(service.rules(), throwsA(isA<SiteException>()));
  });
}
