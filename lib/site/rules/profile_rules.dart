/// The kinds of business profile, in the order the app offers them. `venue` is made by the venue's own business in BottlesUp Business, not here.
const List<({String key, String label})> profileCategories = [
  (key: 'dj', label: 'DJ'),
  (key: 'mc', label: 'MC'),
  (key: 'artist', label: 'Artist'),
  (key: 'instrumentalist', label: 'Instrumentalist'),
  (key: 'photographer', label: 'Photographer'),
  (key: 'videographer', label: 'Videographer'),
  (key: 'influencer', label: 'Influencer'),
  (key: 'promoter', label: 'Promoter'),
  (key: 'event_group', label: 'Event group'),
  (key: 'venue', label: 'Venue'),
  (key: 'other', label: 'Something else'),
];

/// What a category is called on a profile.
String categoryLabel(String? key) {
  for (final c in profileCategories) {
    if (c.key == key) return c.label;
  }
  return 'Profile';
}

/// The categories a person can start from the customer app. A venue's profile belongs to the venue's business, so it is made there.
List<({String key, String label})> get startableCategories => [for (final c in profileCategories) if (c.key != 'venue') c];

final RegExp _handleShape = RegExp(r'^[a-z0-9._]{3,30}$');

/// Names nobody may take. The same list as the website's `handle_reserved` (a test reads the migration and compares).
const Set<String> reservedHandles = {
  'admin', 'administrator', 'support', 'help', 'staff', 'bottlesup', 'bottles.up', 'bottles_up', 'bottlesupapp', 'official', 'root', 'system',
  'moderator', 'security', 'safety', 'team', 'press', 'billing', 'payments', 'payouts', 'null', 'undefined', 'api', 'www', 'explore', 'create',
  'inbox', 'home', 'settings', 'privacy', 'terms', 'venues', 'events', 'tickets', 'tables', 'jobs', 'awards', 'verified', 'about', 'contact', 'login',
  'logout', 'signup', 'search',
};

/// What is wrong with a username as typed, or null when it can be asked of the website. The website decides whether it is free.
String? usernameProblem(String typed) {
  final v = typed.trim().toLowerCase();
  if (v.isEmpty) return 'Choose a username.';
  if (v.length < 3) return 'A username needs at least 3 characters.';
  if (v.length > 30) return 'A username can be 30 characters at most.';
  if (!_handleShape.hasMatch(v)) return 'Use only letters, numbers, dots and underscores.';
  if (reservedHandles.contains(v)) return 'That username is not available.';
  return null;
}

/// Interests as the website keeps them: trimmed, lower case, no repeats, 2 to 30 characters each, ten at most. Returns null with a sentence in [problem] when one is wrong.
({List<String> interests, String? problem}) cleanInterests(Iterable<String> typed) {
  final out = <String>[];
  for (final raw in typed) {
    final v = raw.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
    if (v.isEmpty) continue;
    if (v.length < 2 || v.length > 30) return (interests: const [], problem: 'An interest must be 2 to 30 characters.');
    if (!out.contains(v)) out.add(v);
  }
  if (out.length > 10) return (interests: const [], problem: 'Choose up to 10 interests.');
  return (interests: out, problem: null);
}

/// 1,234 as "1.2K", 1,500,000 as "1.5M": the way a follower count is shown on a profile.
String formatCount(int n) {
  if (n < 1000) return '$n';
  String short(double v, String unit) {
    final s = v.toStringAsFixed(1);
    return '${s.endsWith('.0') ? s.substring(0, s.length - 2) : s}$unit';
  }

  if (n < 1000000) {
    // 999,999 must not read "1000K".
    final v = n / 1000;
    return v >= 999.95 ? '1M' : short(v, 'K');
  }
  if (n < 1000000000) {
    final v = n / 1000000;
    return v >= 999.95 ? '1B' : short(v, 'M');
  }
  return short(n / 1000000000, 'B');
}

/// The links a profile can carry, in the order the app lists them. The same seven as the website allows.
const List<({String key, String label, String hint})> socialLinkKinds = [
  (key: 'instagram', label: 'Instagram', hint: 'username'),
  (key: 'tiktok', label: 'TikTok', hint: 'username'),
  (key: 'x', label: 'X', hint: 'username'),
  (key: 'facebook', label: 'Facebook', hint: 'page or username'),
  (key: 'youtube', label: 'YouTube', hint: 'channel name'),
  (key: 'spotify', label: 'Spotify', hint: 'link to your page'),
  (key: 'website', label: 'Website', hint: 'https://'),
];

String socialLinkLabel(String key) {
  for (final k in socialLinkKinds) {
    if (k.key == key) return k.label;
  }
  return key;
}

final RegExp _plainName = RegExp(r'^[A-Za-z0-9._-]{1,100}$');

/// The address a link opens, or null when it cannot be opened safely. Only secure (https) addresses open; a bare username becomes that network's page.
Uri? socialLinkUri(String key, String value) {
  final v = value.trim();
  if (v.isEmpty) return null;
  if (v.contains(RegExp(r'^[a-z][a-z0-9+.-]*:', caseSensitive: false))) {
    final u = Uri.tryParse(v);
    return u != null && u.scheme == 'https' && u.host.isNotEmpty ? u : null;
  }
  if (key == 'website') {
    if (v.contains(' ') || !v.contains('.')) return null;
    final u = Uri.tryParse('https://$v');
    return u != null && u.host.contains('.') ? u : null;
  }
  final name = v.startsWith('@') ? v.substring(1) : v;
  if (!_plainName.hasMatch(name)) return null;
  return switch (key) {
    'instagram' => Uri.https('instagram.com', '/$name'),
    'tiktok' => Uri.https('www.tiktok.com', '/@$name'),
    'x' => Uri.https('x.com', '/$name'),
    'facebook' => Uri.https('facebook.com', '/$name'),
    'youtube' => Uri.https('youtube.com', '/@$name'),
    _ => null,
  };
}

/// Initials for a picture-less avatar: the first letter of the first two words.
String initialsOf(String name) {
  final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
  if (words.isEmpty) return '?';
  final letters = [for (final w in words.take(2)) String.fromCharCode(w.runes.first).toUpperCase()];
  return letters.join();
}

/// The features a venue can list, and what each is called.
const Map<String, String> venueAmenityLabels = {
  'parking': 'Parking',
  'valet': 'Valet',
  'coat_check': 'Coat check',
  'wifi': 'Wi-Fi',
  'accessible': 'Wheelchair accessible',
  'outdoor': 'Outdoor area',
  'vip_area': 'VIP area',
  'food': 'Food',
  'smoking_area': 'Smoking area',
  'private_rooms': 'Private rooms',
  'live_music': 'Live music',
  'dance_floor': 'Dance floor',
  'bottle_service': 'Bottle service',
};
