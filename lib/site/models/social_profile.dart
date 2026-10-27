import '../read.dart';

/// How the signed-in profile stands with another one.
enum FollowState { none, requested, following }

/// One profile as the website shows it to the profile the person is acting as: a person's own, or a business (a venue, an event group, a professional).
class SocialProfile {
  const SocialProfile({
    required this.id,
    required this.isBusiness,
    required this.handle,
    required this.displayName,
    this.category,
    this.bio,
    this.city,
    this.avatarUrl,
    this.coverUrl,
    this.links = const {},
    this.isPrivate = false,
    this.suspended = false,
    this.verified = false,
    this.interests = const [],
    this.followers = 0,
    this.following = 0,
    this.isMine = false,
    this.follow = FollowState.none,
    this.followsMe = false,
    this.blockedByMe = false,
    this.canSeeContent = true,
    this.at,
  });

  final String id;
  final bool isBusiness;
  final String handle;
  final String displayName;
  final String? category;
  final String? bio;
  final String? city;
  final String? avatarUrl;
  final String? coverUrl;

  /// Instagram, TikTok, X, Facebook, YouTube, Spotify and website, by the website's names.
  final Map<String, String> links;
  final bool isPrivate;
  final bool suspended;
  final bool verified;

  /// Only the person's own profile carries these.
  final List<String> interests;
  final int followers;
  final int following;

  /// The signed-in person owns or manages this profile.
  final bool isMine;
  final FollowState follow;
  final bool followsMe;
  final bool blockedByMe;

  /// False for a private profile the viewer does not follow: its header and counts are public, the rest is not.
  final bool canSeeContent;

  /// When the request was made, the follow started or the block was set, in the list the profile came from.
  final DateTime? at;
}

SocialProfile? parseSocialProfile(Object? json) {
  if (json is! Map) return null;
  final id = readText(json['id']);
  final handle = readText(json['handle']);
  final name = readText(json['display_name']) ?? handle;
  final kind = json['kind'];
  if (id == null || handle == null || name == null || (kind != 'personal' && kind != 'business')) return null;
  final relation = json['relation'] is Map ? json['relation'] as Map : const {};
  final links = <String, String>{};
  final rawLinks = json['social_links'];
  if (rawLinks is Map) {
    for (final e in rawLinks.entries) {
      final v = readText(e.value);
      if (e.key is String && v != null) links[e.key as String] = v;
    }
  }
  final at = readText(json['requested_at']) ?? readText(json['followed_at']) ?? readText(json['blocked_at']);
  return SocialProfile(
    id: id,
    isBusiness: kind == 'business',
    handle: handle,
    displayName: name,
    category: readText(json['category']),
    bio: readText(json['bio']),
    city: readText(json['city']),
    avatarUrl: _https(json['avatar_url']),
    coverUrl: _https(json['cover_url']),
    links: links,
    isPrivate: json['privacy'] == 'private',
    suspended: json['status'] == 'suspended',
    verified: json['verified'] == true,
    interests: readTexts(json['interests']),
    followers: readInt(json['followers']) ?? 0,
    following: readInt(json['following']) ?? 0,
    isMine: json['is_mine'] == true,
    follow: switch (relation['follow']) {
      'active' => FollowState.following,
      'pending' => FollowState.requested,
      _ => FollowState.none,
    },
    followsMe: relation['follows_me'] == true,
    blockedByMe: relation['blocked'] == true,
    // Anything but a clear yes hides the content: a private profile must not open because the answer was unreadable.
    canSeeContent: json['can_see_content'] == true,
    at: at == null ? null : DateTime.tryParse(at)?.toLocal(),
  );
}

/// A list of profiles; a row that cannot be read is dropped.
List<SocialProfile> parseSocialProfiles(Object? json) => json is List ? [for (final r in json) if (parseSocialProfile(r) case final p?) p] : const [];

/// A picture is only shown from a secure address.
String? _https(Object? v) {
  final s = readText(v);
  return s != null && s.startsWith('https://') ? s : null;
}
