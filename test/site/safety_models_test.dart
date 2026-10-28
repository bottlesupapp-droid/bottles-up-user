import 'package:bottles_up_user/site/models/safety.dart';
import 'package:bottles_up_user/site/rules/safety_rules.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every kind and reason has the name the website uses', () {
    expect([for (final k in ReportKind.values) k.wire], ['post', 'comment', 'profile', 'message', 'review', 'job']);
    expect([for (final r in ReportReason.values) r.wire], ['spam', 'harassment', 'hate', 'sexual', 'violence', 'scam', 'impersonation', 'self_harm', 'other']);
  });

  test('every reason is offered once, with words and a hint', () {
    expect([for (final r in reportReasons) r.reason], ReportReason.values);
    for (final r in reportReasons) {
      expect(r.label.trim(), isNotEmpty);
      expect(r.hint.trim(), isNotEmpty);
    }
  });

  test('a receipt is read, or it is nothing', () {
    expect(parseReportReceipt({'id': 'r1', 'already': false})!.already, isFalse);
    expect(parseReportReceipt({'id': 'r1', 'already': true})!.already, isTrue);
    expect(parseReportReceipt({'already': true}), isNull);
    expect(parseReportReceipt('x'), isNull);
    expect(parseReportReceipt(null), isNull);
  });

  test('what is said after a report', () {
    expect(reportThanks(const ReportReceipt(id: 'a', already: false)), contains('Thanks'));
    expect(reportThanks(const ReportReceipt(id: 'a', already: true)), contains('already reported'));
    expect(reportKindLabel(ReportKind.message), 'message');
  });

  test('the rules: a version of at least 1, and a text or none', () {
    final r = parseCommunityRules({'version': 3, 'body': '  Be kind  '});
    expect(r.version, 3);
    expect(r.body, 'Be kind');
    expect(parseCommunityRules({'version': 1, 'body': null}).body, isNull);
    expect(parseCommunityRules({'version': 0}).version, 1);
    expect(parseCommunityRules({'version': 'x'}).version, 1);
    expect(parseCommunityRules(null).version, 1);
    expect(parseCommunityRules({'version': 2, 'body': '   '}).body, isNull);
  });
}
