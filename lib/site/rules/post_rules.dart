import 'dart:math';

import '../models/post.dart';

/// The limits the website enforces (a test reads its migration and compares). The app checks them first only to say so before a long upload.
const int maxCaptionLength = 2200;
const int maxCommentLength = 1000;
const int maxPhotosPerPost = 10;
const int maxImageBytes = 10 * 1024 * 1024;
const int maxVideoBytes = 100 * 1024 * 1024;
const int maxVideoMillis = 60000;
const int maxTagsPerPost = 10;
const int maxMembers = 2000;

const List<String> allowedImageTypes = ['image/jpeg', 'image/png', 'image/webp'];
const List<String> allowedVideoTypes = ['video/mp4', 'video/quicktime'];

String? captionProblem(String? caption) {
  if ((caption ?? '').trim().length > maxCaptionLength) return 'The caption can be $maxCaptionLength characters at most.';
  return null;
}

String? commentProblem(String body) {
  final t = body.trim();
  if (t.isEmpty) return 'Write something first.';
  if (t.length > maxCommentLength) return 'A comment can be $maxCommentLength characters at most.';
  return null;
}

String audienceLabel(PostAudience a) => switch (a) {
      PostAudience.public => 'Public',
      PostAudience.followers => 'Followers',
      PostAudience.members => 'Members Only',
    };

String audienceHint(PostAudience a) => switch (a) {
      PostAudience.public => 'Anyone who can see your profile.',
      PostAudience.followers => 'Only people who follow you.',
      PostAudience.members => 'Only the members you chose, who also follow you.',
    };

String kindLabel(PostKind k) => switch (k) {
      PostKind.post => 'Post',
      PostKind.reel => 'Reel',
      PostKind.story => 'Story',
    };

/// "now", "5m", "3h", "2d", "3w", then a date: how long ago something was posted.
String timeAgo(DateTime then, DateTime now) {
  final d = now.difference(then);
  if (d.inSeconds < 60) return 'now';
  if (d.inMinutes < 60) return '${d.inMinutes}m';
  if (d.inHours < 24) return '${d.inHours}h';
  if (d.inDays < 7) return '${d.inDays}d';
  if (d.inDays < 60) return '${d.inDays ~/ 7}w';
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${months[then.month - 1]} ${then.day}${then.year == now.year ? '' : ', ${then.year}'}';
}

/// The file ending for a picture or video type the bucket takes, or null for anything else.
String? extensionForType(String mime) => switch (mime.toLowerCase()) {
      'image/jpeg' || 'image/jpg' => 'jpg',
      'image/png' => 'png',
      'image/webp' => 'webp',
      'video/mp4' => 'mp4',
      'video/quicktime' => 'mov',
      _ => null,
    };

/// The type of a file from its name, for pickers that do not say.
String? typeForName(String name) {
  final dot = name.lastIndexOf('.');
  if (dot < 0) return null;
  return switch (name.substring(dot + 1).toLowerCase()) {
    'jpg' || 'jpeg' => 'image/jpeg',
    'png' => 'image/png',
    'webp' => 'image/webp',
    'mp4' => 'video/mp4',
    'mov' => 'video/quicktime',
    _ => null,
  };
}

/// Where a new file goes in the media bucket: the folder of the profile posting, then a random name. Lower case, as the website's path check wants.
String mediaPathFor(String profileId, String extension, {Random? random}) {
  final r = random ?? Random.secure();
  final name = List.generate(32, (_) => r.nextInt(16).toRadixString(16)).join();
  return '${profileId.toLowerCase()}/$name.$extension';
}

/// A photo or video chosen on the phone, ready to upload.
class PickedMedia {
  const PickedMedia({required this.path, required this.type, required this.bytes, this.durationMs, this.width, this.height});

  final String path;
  final String type;
  final int bytes;
  final int? durationMs;
  final int? width;
  final int? height;

  bool get isVideo => type.startsWith('video/');
}

/// Why a chosen file cannot be posted, or null when it can.
String? mediaProblem(PickedMedia m) {
  if (m.isVideo) {
    if (!allowedVideoTypes.contains(m.type)) return 'That kind of video is not supported. Use an MP4 or a QuickTime movie.';
    if (m.bytes > maxVideoBytes) return 'A video can be 100 MB at most.';
    if (m.durationMs == null || m.durationMs! < 1) return 'We could not read how long that video is.';
    if (m.durationMs! > maxVideoMillis) return 'A video can be up to 60 seconds.';
    return null;
  }
  if (!allowedImageTypes.contains(m.type)) return 'That kind of photo is not supported. Use a JPEG, PNG or WebP.';
  if (m.bytes > maxImageBytes) return 'A photo can be 10 MB at most.';
  return null;
}

/// The fallback community rules shown until BottlesUp puts its own in the CMS. DRAFT: the client and their lawyer replace this; the app never decides what the rules are.
const String draftCommunityRules = '''Be kind. No hate, harassment, threats or bullying.
Post only what is yours or what you have permission to share. No nudity, no sexual content and nothing that shows violence or illegal drugs.
No spam, scams, fake accounts or pretending to be someone else.
Do not share other people's private details or photos without asking.
You can report any post, comment or profile, and block anyone. BottlesUp may remove content or suspend accounts that break these rules.''';
