import '../read.dart';

/// What can be reported. [wire] is the name the website uses.
enum ReportKind {
  post('post'),
  comment('comment'),
  profile('profile'),
  message('message'),
  review('review');

  const ReportKind(this.wire);

  final String wire;
}

/// Why something is reported. [wire] is the name the website uses.
enum ReportReason {
  spam('spam'),
  harassment('harassment'),
  hate('hate'),
  sexual('sexual'),
  violence('violence'),
  scam('scam'),
  impersonation('impersonation'),
  selfHarm('self_harm'),
  other('other');

  const ReportReason(this.wire);

  final String wire;
}

/// What the website said to a report: its number, and whether this profile had already sent it.
class ReportReceipt {
  const ReportReceipt({required this.id, required this.already});

  final String id;
  final bool already;
}

ReportReceipt? parseReportReceipt(Object? json) {
  if (json is! Map) return null;
  final id = readText(json['id']);
  if (id == null) return null;
  return ReportReceipt(id: id, already: json['already'] == true);
}

/// The community rules as BottlesUp published them: the version people accept, and the text (null until BottlesUp has written one, when the app shows its own draft).
class CommunityRules {
  const CommunityRules({required this.version, this.body});

  final int version;
  final String? body;
}

CommunityRules parseCommunityRules(Object? json) {
  if (json is! Map) return const CommunityRules(version: 1);
  final version = readInt(json['version']);
  return CommunityRules(version: version != null && version >= 1 ? version : 1, body: readText(json['body']));
}
