import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/safety.dart';
import '../site_error.dart';

/// Reporting, and the community rules, through the website's `report_create` and `rules_current`. The website checks the person may report what they report (only what they can
/// see, never their own), and says in a sentence when not.
class SafetyService {
  SafetyService(this._db);

  final SupabaseClient _db;

  Future<ReportReceipt> report({required String actor, required ReportKind kind, required String target, required ReportReason reason, String? details}) async {
    final Object? answer;
    try {
      answer = await _db.rpc('report_create', params: {
        'p_actor': actor,
        'p_kind': kind.wire,
        'p_target': target,
        'p_reason': reason.wire,
        'p_details': details == null || details.trim().isEmpty ? null : details.trim(),
      });
    } catch (error) {
      throw siteExceptionFromRpc(error, generic: 'Your report was not sent. Check your connection and try again.');
    }
    final receipt = parseReportReceipt(answer);
    if (receipt == null) throw const SiteException('We could not read the answer. Your report may not have been sent: try again in a moment.');
    return receipt;
  }

  /// The rules as published. Anyone may read them, signed in or not.
  Future<CommunityRules> rules() async {
    try {
      return parseCommunityRules(await _db.rpc('rules_current', params: const {}));
    } catch (error) {
      throw siteExceptionFromRpc(error, generic: loadFailedMessage('the community rules'));
    }
  }
}
