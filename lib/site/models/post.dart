import '../read.dart';
import 'social_profile.dart';

enum PostKind { post, reel, story }

/// Who can see a post. Members Only is the author's own list of members who also follow the author.
enum PostAudience { public, followers, members }

PostAudience? _audience(Object? v) => switch (v) {
      'public' => PostAudience.public,
      'followers' => PostAudience.followers,
      'members' => PostAudience.members,
      _ => null,
    };

/// One photo or video of a post. [path] is where it lives in the private media bucket: it is shown through a signed address the app asks storage for.
class PostMedia {
  const PostMedia({required this.id, required this.position, required this.isVideo, required this.path, this.posterPath, this.width, this.height, this.durationMs});

  final String id;
  final int position;
  final bool isVideo;
  final String path;
  final String? posterPath;
  final int? width;
  final int? height;
  final int? durationMs;

  /// Width over height, when both are known and sensible (a feed picture is cropped to something between a tall and a wide frame).
  double? get aspect => width != null && height != null && width! > 0 && height! > 0 ? width! / height! : null;
}

enum TagKind { profile, event, venue }

/// Something a post is tagged with: a person or business, an event or a venue.
class PostTag {
  const PostTag({required this.kind, required this.id, required this.name, this.handle});

  final TagKind kind;
  final String id;
  final String name;

  /// For a profile: its username.
  final String? handle;
}

class SocialPost {
  const SocialPost({
    required this.id,
    required this.kind,
    required this.author,
    required this.audience,
    required this.createdAt,
    this.caption,
    this.commentsEnabled = true,
    this.expiresAt,
    this.media = const [],
    this.tags = const [],
    this.likes = 0,
    this.comments = 0,
    this.liked = false,
    this.saved = false,
    this.isMine = false,
    this.seen = false,
    this.savedAt,
  });

  final String id;
  final PostKind kind;
  final SocialProfile author;
  final PostAudience audience;
  final DateTime createdAt;
  final String? caption;
  final bool commentsEnabled;

  /// A story stops showing 24 hours after it was posted.
  final DateTime? expiresAt;
  final List<PostMedia> media;
  final List<PostTag> tags;
  final int likes;
  final int comments;
  final bool liked;
  final bool saved;
  final bool isMine;

  /// For a story: the person has watched it.
  final bool seen;

  /// In the saved list: when the person saved it (the list is paged by this).
  final DateTime? savedAt;

  bool get isMembersOnly => audience == PostAudience.members;
}

PostMedia? parsePostMedia(Object? json) {
  if (json is! Map) return null;
  final id = readText(json['id']);
  final path = readText(json['path']);
  final type = json['type'];
  if (id == null || path == null || (type != 'image' && type != 'video')) return null;
  return PostMedia(
    id: id,
    position: readInt(json['position']) ?? 0,
    isVideo: type == 'video',
    path: path,
    posterPath: readText(json['poster_path']),
    width: readInt(json['width']),
    height: readInt(json['height']),
    durationMs: readInt(json['duration_ms']),
  );
}

PostTag? parsePostTag(Object? json) {
  if (json is! Map) return null;
  final id = readText(json['id']);
  if (id == null) return null;
  switch (json['kind']) {
    case 'profile':
      final p = parseSocialProfile(json['profile']);
      return p == null ? null : PostTag(kind: TagKind.profile, id: id, name: p.displayName, handle: p.handle);
    case 'event':
      final n = readText(json['name']);
      return n == null ? null : PostTag(kind: TagKind.event, id: id, name: n);
    case 'venue':
      final n = readText(json['name']);
      return n == null ? null : PostTag(kind: TagKind.venue, id: id, name: n);
  }
  return null;
}

/// A post as the website sent it; null when it cannot be shown (no author, no media, no time). A post without media would be an empty card.
SocialPost? parseSocialPost(Object? json) {
  if (json is! Map) return null;
  final id = readText(json['id']);
  final author = parseSocialProfile(json['author']);
  final kind = switch (json['kind']) {
    'post' => PostKind.post,
    'reel' => PostKind.reel,
    'story' => PostKind.story,
    _ => null,
  };
  final audience = _audience(json['audience']);
  final created = readText(json['created_at']);
  final createdAt = created == null ? null : DateTime.tryParse(created)?.toLocal();
  if (id == null || author == null || kind == null || audience == null || createdAt == null) return null;
  final media = <PostMedia>[
    if (json['media'] is List)
      for (final m in json['media'] as List)
        if (parsePostMedia(m) case final pm?) pm,
  ]..sort((a, b) => a.position.compareTo(b.position));
  if (media.isEmpty) return null;
  final expires = readText(json['expires_at']);
  return SocialPost(
    id: id,
    kind: kind,
    author: author,
    audience: audience,
    createdAt: createdAt,
    caption: readText(json['caption']),
    commentsEnabled: json['comments_enabled'] != false,
    expiresAt: expires == null ? null : DateTime.tryParse(expires)?.toLocal(),
    media: media,
    tags: [
      if (json['tags'] is List)
        for (final t in json['tags'] as List)
          if (parsePostTag(t) case final pt?) pt,
    ],
    likes: readInt(json['likes']) ?? 0,
    comments: readInt(json['comments']) ?? 0,
    liked: json['liked'] == true,
    saved: json['saved'] == true,
    isMine: json['is_mine'] == true,
    seen: json['seen'] == true,
    savedAt: readText(json['saved_at']) == null ? null : DateTime.tryParse(readText(json['saved_at'])!)?.toLocal(),
  );
}

List<SocialPost> parseSocialPosts(Object? json) => json is List ? [for (final r in json) if (parseSocialPost(r) case final p?) p] : const [];

/// A comment, or a reply to one (replies go one level deep).
class PostComment {
  const PostComment({required this.id, required this.postId, required this.author, required this.body, required this.createdAt, this.replyTo, this.replies = 0, this.isMine = false, this.canDelete = false});

  final String id;
  final String postId;
  final String? replyTo;
  final SocialProfile author;
  final String body;
  final DateTime createdAt;
  final int replies;
  final bool isMine;
  final bool canDelete;
}

PostComment? parsePostComment(Object? json) {
  if (json is! Map) return null;
  final id = readText(json['id']);
  final post = readText(json['post']);
  final author = parseSocialProfile(json['author']);
  final body = readText(json['body']);
  final created = readText(json['created_at']);
  final createdAt = created == null ? null : DateTime.tryParse(created)?.toLocal();
  if (id == null || post == null || author == null || body == null || createdAt == null) return null;
  return PostComment(
    id: id,
    postId: post,
    replyTo: readText(json['reply_to']),
    author: author,
    body: body,
    createdAt: createdAt,
    replies: readInt(json['replies']) ?? 0,
    isMine: json['is_mine'] == true,
    canDelete: json['can_delete'] == true,
  );
}

List<PostComment> parsePostComments(Object? json) => json is List ? [for (final r in json) if (parsePostComment(r) case final c?) c] : const [];

/// One profile in the row of stories.
class StoryRailItem {
  const StoryRailItem({required this.profile, required this.latestAt, required this.unseen, required this.membersOnly, required this.count, required this.isMine});

  final SocialProfile profile;
  final DateTime latestAt;
  final bool unseen;

  /// Any of the stories is for the author's Members Only list: the ring is drawn in the Members Only colour.
  final bool membersOnly;
  final int count;
  final bool isMine;
}

StoryRailItem? parseStoryRailItem(Object? json) {
  if (json is! Map) return null;
  final profile = parseSocialProfile(json['profile']);
  final at = readText(json['latest_at']);
  final latest = at == null ? null : DateTime.tryParse(at)?.toLocal();
  if (profile == null || latest == null) return null;
  return StoryRailItem(
    profile: profile,
    latestAt: latest,
    unseen: json['unseen'] == true,
    membersOnly: json['members_only'] == true,
    count: readInt(json['count']) ?? 1,
    isMine: json['is_mine'] == true,
  );
}

List<StoryRailItem> parseStoryRail(Object? json) => json is List ? [for (final r in json) if (parseStoryRailItem(r) case final i?) i] : const [];

/// A page of a profile's posts and how many there are in all.
class ProfilePosts {
  const ProfilePosts({required this.total, required this.items});

  final int total;
  final List<SocialPost> items;
}

ProfilePosts parseProfilePosts(Object? json) {
  if (json is! Map) return const ProfilePosts(total: 0, items: []);
  final items = parseSocialPosts(json['items']);
  return ProfilePosts(total: readInt(json['total']) ?? items.length, items: items);
}
