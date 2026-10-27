import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/post.dart';
import '../models/social_profile.dart';
import '../read.dart';
import '../rules/post_rules.dart';
import '../site_error.dart';

/// A file that is in the media bucket and ready to go in a post.
class UploadedMedia {
  const UploadedMedia({required this.path, required this.type, this.durationMs, this.width, this.height});

  final String path;
  final String type;
  final int? durationMs;
  final int? width;
  final int? height;

  Map<String, dynamic> toJson() => {
        'path': path,
        'type': type.startsWith('video/') ? 'video' : 'image',
        if (durationMs != null) 'duration_ms': durationMs,
        if (width != null) 'width': width,
        if (height != null) 'height': height,
      };
}

/// What a post is tagged with, for the website: a kind ('profile', 'event' or 'venue') and the id.
class TagRef {
  const TagRef(this.kind, this.id);

  final TagKind kind;
  final String id;

  Map<String, dynamic> toJson() => {'kind': kind.name, 'id': id};
}

/// Posts, reels, stories, comments, likes, saves, Members Only and the media bucket, through the website's `post_*`, `feed_*`, `story_*`, `comment_*` and `members_*` functions.
/// Every function that does something is told which profile it is done AS; the website checks, each time, that the person may act as it and may see what they ask for.
class PostsService {
  PostsService(this._db, {DateTime Function()? now}) : _now = now ?? DateTime.now;

  final SupabaseClient _db;
  final DateTime Function() _now;

  /// Signed addresses already asked for, so scrolling back does not ask again. A signed address is good for an hour; one is reused for 40 minutes.
  final Map<String, ({String url, DateTime until})> _signed = {};

  Future<Object?> _rpc(String name, Map<String, dynamic> params, String generic) async {
    try {
      return await _db.rpc(name, params: params);
    } catch (error) {
      throw siteExceptionFromRpc(error, generic: generic);
    }
  }

  SocialPost _one(Object? json) {
    final p = parseSocialPost(json);
    if (p == null) throw const SiteException('We could not read that post. Try again in a moment.');
    return p;
  }

  static String _iso(DateTime? t) => t?.toUtc().toIso8601String() ?? '';

  // ---- the community rules

  Future<bool> rulesAccepted() async {
    final r = await _rpc('rules_status', const {}, loadFailedMessage('the community rules'));
    return r is Map && r['accepted'] == true;
  }

  /// Accepts [version] of the rules, the one the person has just read. The website refuses a version that is no longer the current one.
  Future<void> acceptRules(int version) async {
    await _rpc('rules_accept', {'p_version': version}, actionFailedMessage);
  }

  // ---- files

  /// Puts one file in the media bucket, in the folder of [profileId], and answers what the website needs to attach it to a post. A photo goes up from memory, a video from the file.
  Future<UploadedMedia> upload(String profileId, PickedMedia media) async {
    final problem = mediaProblem(media);
    if (problem != null) throw SiteException(problem);
    final ext = extensionForType(media.type);
    if (ext == null) throw const SiteException('That kind of file is not supported.');
    final path = mediaPathFor(profileId, ext);
    final options = FileOptions(contentType: media.type, cacheControl: '3600', upsert: false);
    try {
      final bucket = _db.storage.from('social-media');
      if (media.isVideo) {
        await bucket.upload(path, File(media.path), fileOptions: options);
      } else {
        final Uint8List bytes = await File(media.path).readAsBytes();
        await bucket.uploadBinary(path, bytes, fileOptions: options);
      }
    } catch (error) {
      logProblem('upload ${media.type}', error);
      throw const SiteException('We could not upload that. Check your connection and try again.');
    }
    return UploadedMedia(path: path, type: media.type, durationMs: media.durationMs, width: media.width, height: media.height);
  }

  /// Addresses to show private media with. Paths that could not be signed are left out; the picture shows its placeholder.
  Future<Map<String, String>> signedUrls(Iterable<String> paths) async {
    final now = _now();
    final out = <String, String>{};
    final need = <String>[];
    for (final p in paths.toSet()) {
      final hit = _signed[p];
      if (hit != null && hit.until.isAfter(now)) {
        out[p] = hit.url;
      } else {
        need.add(p);
      }
    }
    if (need.isNotEmpty) {
      try {
        final signed = await _db.storage.from('social-media').createSignedUrls(need, 3600);
        for (final s in signed) {
          // The storage client answers '<storage address>null' for a path it could not sign; only a real signed address is kept.
          if (s.signedUrl.startsWith('https://') && s.signedUrl.contains('/object/sign/')) {
            out[s.path] = s.signedUrl;
            _signed[s.path] = (url: s.signedUrl, until: now.add(const Duration(minutes: 40)));
          }
        }
      } catch (error) {
        logProblem('sign media addresses', error);
      }
    }
    return out;
  }

  final Map<String, Completer<String?>> _waiting = {};
  bool _flushScheduled = false;

  /// One address, for a picture on screen. Pictures asked for in the same turn of the event loop (everything a screen builds at once) are signed in ONE request to storage.
  Future<String?> signedUrl(String path) {
    final hit = _signed[path];
    if (hit != null && hit.until.isAfter(_now())) return Future.value(hit.url);
    final c = _waiting.putIfAbsent(path, Completer<String?>.new);
    if (!_flushScheduled) {
      _flushScheduled = true;
      scheduleMicrotask(_flush);
    }
    return c.future;
  }

  Future<void> _flush() async {
    _flushScheduled = false;
    final batch = Map<String, Completer<String?>>.of(_waiting);
    _waiting.clear();
    if (batch.isEmpty) return;
    final urls = await signedUrls(batch.keys);
    for (final e in batch.entries) {
      e.value.complete(urls[e.key]);
    }
  }

  Future<void> _removeFiles(Iterable<String> paths) async {
    final list = paths.toList();
    if (list.isEmpty) return;
    try {
      await _db.storage.from('social-media').remove(list);
    } catch (error) {
      // The files are already detached from any post; a clean-up job finds what is left.
      logProblem('remove deleted post files', error);
    }
  }

  // ---- making, changing, deleting

  Future<SocialPost> create({
    required String actor,
    required PostKind kind,
    required PostAudience audience,
    required List<UploadedMedia> media,
    String? caption,
    List<TagRef> tags = const [],
    bool commentsEnabled = true,
  }) async =>
      _one(await _rpc(
        'post_create',
        {
          'p_actor': actor,
          'p_kind': kind.name,
          'p_caption': caption?.trim(),
          'p_audience': audience.name,
          'p_media': [for (final m in media) m.toJson()],
          'p_tags': [for (final t in tags) t.toJson()],
          'p_comments_enabled': commentsEnabled,
        },
        'We could not post that. Check your connection and try again.',
      ));

  Future<SocialPost> edit({required String actor, required String post, String? caption, required PostAudience audience, required bool commentsEnabled}) async => _one(await _rpc(
        'post_edit',
        {'p_actor': actor, 'p_post': post, 'p_caption': caption?.trim(), 'p_audience': audience.name, 'p_comments_enabled': commentsEnabled},
        'We could not save the changes. Check your connection and try again.',
      ));

  Future<void> delete({required String actor, required String post}) async {
    final paths = await _rpc('post_delete', {'p_actor': actor, 'p_post': post}, 'We could not delete that. Check your connection and try again.');
    await _removeFiles(readTexts(paths));
  }

  Future<SocialPost> post({required String actor, required String id}) async => _one(await _rpc('post_get', {'p_actor': actor, 'p_post': id}, loadFailedMessage('that post')));

  Future<void> untagMe({required String actor, required String post}) async {
    await _rpc('post_untag', {'p_actor': actor, 'p_post': post}, actionFailedMessage);
  }

  // ---- reading

  Future<ProfilePosts> profilePosts({required String actor, required String profile, PostKind? kind, int limit = 30, SocialPost? after}) async => parseProfilePosts(await _rpc(
        'profile_posts',
        {
          'p_actor': actor,
          'p_profile': profile,
          'p_kind': kind?.name,
          'p_limit': limit,
          'p_before': after == null ? null : _iso(after.createdAt),
          'p_before_id': after?.id,
        },
        loadFailedMessage('the posts'),
      ));

  Future<List<SocialPost>> feed({required String actor, int limit = 20, SocialPost? after}) async => parseSocialPosts(await _rpc(
        'feed_home',
        {'p_actor': actor, 'p_limit': limit, 'p_before': after == null ? null : _iso(after.createdAt), 'p_before_id': after?.id},
        loadFailedMessage('your feed'),
      ));

  Future<List<SocialPost>> suggested({required String actor, int limit = 10}) async =>
      parseSocialPosts(await _rpc('feed_suggested', {'p_actor': actor, 'p_limit': limit}, loadFailedMessage('the suggestions')));

  Future<List<SocialPost>> reels({required String actor, int limit = 10, SocialPost? after}) async => parseSocialPosts(await _rpc(
        'feed_reels',
        {'p_actor': actor, 'p_limit': limit, 'p_before': after == null ? null : _iso(after.createdAt), 'p_before_id': after?.id},
        loadFailedMessage('the reels'),
      ));

  Future<List<StoryRailItem>> storyRail(String actor) async => parseStoryRail(await _rpc('story_rail', {'p_actor': actor}, loadFailedMessage('the stories')));

  Future<List<SocialPost>> storiesOf({required String actor, required String profile}) async =>
      parseSocialPosts(await _rpc('stories_of', {'p_actor': actor, 'p_profile': profile}, loadFailedMessage('the stories')));

  Future<void> storySeen({required String actor, required String story}) async {
    try {
      await _db.rpc('story_seen', params: {'p_actor': actor, 'p_story': story});
    } catch (error) {
      // Watching is not worth interrupting for; the ring just stays colourful.
      logProblem('mark a story as watched', error);
    }
  }

  // ---- likes and saves

  /// Answers the number of likes now.
  Future<int> like({required String actor, required String post, required bool liked}) async {
    final r = await _rpc('post_like', {'p_actor': actor, 'p_post': post, 'p_liked': liked}, actionFailedMessage);
    return r is Map ? readInt(r['likes']) ?? 0 : 0;
  }

  Future<void> save({required String actor, required String post, required bool saved}) async {
    await _rpc('post_save', {'p_actor': actor, 'p_post': post, 'p_saved': saved}, actionFailedMessage);
  }

  Future<List<SocialPost>> savedPosts({required String actor, int limit = 30, DateTime? before}) async => parseSocialPosts(await _rpc(
        'saved_posts',
        {'p_actor': actor, 'p_limit': limit, 'p_before': before == null ? null : _iso(before)},
        loadFailedMessage('your saved posts'),
      ));

  // ---- comments

  Future<PostComment> addComment({required String actor, required String post, required String body, String? replyTo}) async {
    final c = parsePostComment(await _rpc('comment_add', {'p_actor': actor, 'p_post': post, 'p_body': body.trim(), 'p_reply_to': replyTo}, 'We could not post your comment. Check your connection and try again.'));
    if (c == null) throw const SiteException('We could not read that comment. Try again in a moment.');
    return c;
  }

  Future<List<PostComment>> comments({required String actor, required String post, String? parent, int limit = 30, DateTime? after}) async => parsePostComments(await _rpc(
        'comment_list',
        {'p_actor': actor, 'p_post': post, 'p_parent': parent, 'p_limit': limit, 'p_after': after == null ? null : _iso(after)},
        loadFailedMessage('the comments'),
      ));

  Future<void> deleteComment({required String actor, required String comment}) async {
    await _rpc('comment_delete', {'p_actor': actor, 'p_comment': comment}, actionFailedMessage);
  }

  // ---- Members Only

  Future<List<SocialProfile>> members({required String actor, int limit = 100, DateTime? before}) async => parseSocialProfiles(await _rpc(
        'members_list',
        {'p_actor': actor, 'p_limit': limit, 'p_before': before == null ? null : _iso(before)},
        loadFailedMessage('your Members Only list'),
      ));

  Future<void> setMember({required String actor, required String member, required bool isMember}) async {
    await _rpc('members_set', {'p_actor': actor, 'p_member': member, 'p_in': isMember}, actionFailedMessage);
  }
}
