import '../read.dart';

/// One rank as the website lists it (`rank_levels`): its name, the followers it needs and its colour (an 0xAARRGGBB number). The names, counts and colours are BottlesUp's to change,
/// so the app asks for them instead of keeping its own.
class RankLevel {
  const RankLevel({required this.key, required this.name, required this.minFollowers, required this.colour, this.plaque = false});

  final String key;
  final String name;
  final int minFollowers;
  final int colour;
  final bool plaque;

  bool get isVerified => key == 'verified';
}

/// '#2E9E5B' as 0xFF2E9E5B, or null for anything else.
int? parseColour(Object? v) {
  final s = readText(v);
  if (s == null || !RegExp(r'^#[0-9A-Fa-f]{6}$').hasMatch(s)) return null;
  return 0xFF000000 | int.parse(s.substring(1), radix: 16);
}

RankLevel? parseRankLevel(Object? json) {
  if (json is! Map) return null;
  final key = readText(json['key']);
  final name = readText(json['name']);
  final colour = parseColour(json['colour']);
  final min = readInt(json['min_followers']);
  if (key == null || name == null || colour == null || min == null || min < 0) return null;
  return RankLevel(key: key, name: name, minFollowers: min, colour: colour, plaque: json['plaque'] == true);
}

/// The ranks, lowest first as the website sent them; one that cannot be read is dropped.
List<RankLevel> parseRankLevels(Object? json) => json is List ? [for (final r in json) if (parseRankLevel(r) case final l?) l] : const [];

/// The ranks the app shows until the website has answered, and when it cannot be asked: the ones in the client's plan.
const List<RankLevel> proposedRanks = [
  RankLevel(key: 'verified', name: 'Verified', minFollowers: 0, colour: 0xFF1D9BF0),
  RankLevel(key: 'elite', name: 'Elite', minFollowers: 100000, colour: 0xFF2E9E5B),
  RankLevel(key: 'icon', name: 'Icon', minFollowers: 1000000, colour: 0xFF7E57C2, plaque: true),
  RankLevel(key: 'legend', name: 'Legend', minFollowers: 10000000, colour: 0xFFE67E22, plaque: true),
  RankLevel(key: 'global_icon', name: 'Global Icon', minFollowers: 50000000, colour: 0xFFD4A017, plaque: true),
  RankLevel(key: 'immortal', name: 'BottlesUp Immortal', minFollowers: 100000000, colour: 0xFFC62828, plaque: true),
];

/// A request to be verified, as the owner sees it.
class VerificationRequest {
  const VerificationRequest({required this.id, required this.state, this.note, this.reason, this.createdAt, this.retryOn});

  final String id;

  /// `requested`, `approved`, `rejected` or `revoked`.
  final String state;
  final String? note;
  final String? reason;
  final DateTime? createdAt;

  /// When the person may ask again, after a refusal or a withdrawal.
  final DateTime? retryOn;

  bool get isWaiting => state == 'requested';
  bool get wasTurnedDown => state == 'rejected' || state == 'revoked';
}

/// Where a profile stands on being verified (`verification_status`).
class VerificationInfo {
  const VerificationInfo({required this.verified, this.via, this.orgRun = false, this.request});

  final bool verified;

  /// `business` (the business account is verified) or `review` (BottlesUp approved a request).
  final String? via;

  /// A venue or event group: verified through its business account, never here.
  final bool orgRun;
  final VerificationRequest? request;
}

VerificationInfo? parseVerificationInfo(Object? json) {
  if (json is! Map) return null;
  final r = json['request'];
  VerificationRequest? request;
  if (r is Map) {
    final id = readText(r['id']);
    final state = readText(r['state']);
    if (id != null && state != null) {
      final created = readText(r['created_at']);
      request = VerificationRequest(id: id, state: state, note: readText(r['note']), reason: readText(r['reason']), createdAt: created == null ? null : DateTime.tryParse(created)?.toLocal(), retryOn: readDay(r['retry_on']));
    }
  }
  return VerificationInfo(verified: json['verified'] == true, via: readText(json['via']), orgRun: json['org_run'] == true, request: request);
}

/// A level that is the next step or the one to ask for.
class RankStep {
  const RankStep({required this.key, required this.name, required this.minFollowers, required this.colour});

  final String key;
  final String name;
  final int minFollowers;
  final int colour;
}

RankStep? _step(Object? json) {
  if (json is! Map) return null;
  final key = readText(json['key']);
  final name = readText(json['name']);
  final min = readInt(json['min_followers']);
  final colour = parseColour(json['colour']);
  if (key == null || name == null || min == null || colour == null) return null;
  return RankStep(key: key, name: name, minFollowers: min, colour: colour);
}

/// Where a profile stands on ranks (`rank_status`).
class RankStatus {
  const RankStatus({
    required this.verified,
    required this.followers,
    this.rank,
    this.next,
    this.target,
    this.canRequest = false,
    this.pendingLevel,
    this.rejectedReason,
    this.rejectedRetryOn,
  });

  final bool verified;
  final int followers;

  /// The key of the rank held (`verified` when there is only the tick), or null.
  final String? rank;

  /// The step above the rank held, whether reached or not.
  final RankStep? next;

  /// The level that could be asked for now.
  final RankStep? target;
  final bool canRequest;
  final String? pendingLevel;
  final String? rejectedReason;
  final DateTime? rejectedRetryOn;

  bool get isWaiting => pendingLevel != null;
}

RankStatus? parseRankStatus(Object? json) {
  if (json is! Map) return null;
  final followers = readInt(json['followers']);
  if (followers == null) return null;
  final pending = json['pending'];
  final rejected = json['rejected'];
  return RankStatus(
    verified: json['verified'] == true,
    followers: followers,
    rank: readText(json['rank']),
    next: _step(json['next']),
    target: _step(json['target']),
    canRequest: json['can_request'] == true,
    pendingLevel: pending is Map ? readText(pending['level']) : null,
    rejectedReason: rejected is Map ? readText(rejected['reason']) : null,
    rejectedRetryOn: rejected is Map ? readDay(rejected['retry_on']) : null,
  );
}

/// A rank a profile holds, listed on its page (`awards_of`).
class Award {
  const Award({required this.id, required this.level, required this.name, required this.colour, this.awardedAt, this.plaque = false});

  final String id;
  final String level;
  final String name;
  final int colour;
  final DateTime? awardedAt;

  /// This rank comes with a plaque.
  final bool plaque;
}

List<Award> parseAwards(Object? json) {
  if (json is! List) return const [];
  final out = <Award>[];
  for (final r in json) {
    if (r is! Map) continue;
    final id = readText(r['id']);
    final level = readText(r['level']);
    final name = readText(r['name']);
    final colour = parseColour(r['colour']);
    if (id == null || level == null || name == null || colour == null) continue;
    final at = readText(r['awarded_at']);
    out.add(Award(id: id, level: level, name: name, colour: colour, awardedAt: at == null ? null : DateTime.tryParse(at)?.toLocal(), plaque: r['plaque'] == true));
  }
  return out;
}

/// The delivery address for a plaque, as the person types it.
class PlaqueAddress {
  const PlaqueAddress({required this.recipient, required this.line1, this.line2, required this.city, this.region, required this.postal, required this.country, this.phone});

  final String recipient;
  final String line1;
  final String? line2;
  final String city;
  final String? region;
  final String postal;
  final String country;
  final String? phone;
}

/// A plaque asked for (`plaques_mine`): where it stands, and the tracking once it is posted. The address is removed some time after it arrives.
class Plaque {
  const Plaque({
    required this.id,
    required this.award,
    required this.level,
    required this.levelName,
    required this.state,
    this.address = const [],
    this.carrier,
    this.tracking,
    this.addressRemoved = false,
  });

  final String id;
  final String award;
  final String level;
  final String levelName;

  /// `requested`, `shipped`, `delivered` or `cancelled`.
  final String state;

  /// The lines of the address as it was given, in the order of a parcel; empty once removed.
  final List<String> address;
  final String? carrier;
  final String? tracking;
  final bool addressRemoved;

  bool get isOpen => state == 'requested';
  bool get isOnItsWay => state == 'shipped';
  bool get isDelivered => state == 'delivered';
  bool get isCancelled => state == 'cancelled';
}

Plaque? parsePlaque(Object? json) {
  if (json is! Map) return null;
  final id = readText(json['id']);
  final award = readText(json['award']);
  final level = readText(json['level']);
  final state = readText(json['state']);
  if (id == null || award == null || level == null || state == null) return null;
  final place = [readText(json['city']), readText(json['region'])].whereType<String>().join(', ');
  final post = [place, readText(json['postal']) ?? ''].where((x) => x.isNotEmpty).join(' ');
  return Plaque(
    id: id,
    award: award,
    level: level,
    levelName: readText(json['level_name']) ?? level,
    state: state,
    address: [readText(json['recipient']), readText(json['line1']), readText(json['line2']), post.isEmpty ? null : post, readText(json['country'])].whereType<String>().toList(),
    carrier: readText(json['carrier']),
    tracking: readText(json['tracking']),
    addressRemoved: json['address_removed'] == true,
  );
}

List<Plaque> parsePlaques(Object? json) => json is List ? [for (final r in json) if (parsePlaque(r) case final p?) p] : const [];
