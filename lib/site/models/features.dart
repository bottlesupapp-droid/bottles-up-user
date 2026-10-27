/// The names of the switches BottlesUp turns on from the CMS (`site_feature_flags`). A part of the app that is switched off is not shown.
class Feature {
  const Feature._();

  static const social = 'social';
  static const stories = 'stories';
  static const reels = 'reels';
  static const membersOnly = 'members_only';
  static const inbox = 'inbox';
  static const reviews = 'reviews';
  static const splitPayments = 'split_payments';
  static const marketplace = 'marketplace';
  static const venueHire = 'venue_hire';
  static const referrals = 'referrals';
  static const subscriptions = 'subscriptions';
  static const advertising = 'advertising';
  static const creatorEarnings = 'creator_earnings';
  static const ranks = 'ranks';
  static const jobs = 'jobs';

  static const all = [
    social, stories, reels, membersOnly, inbox, reviews, splitPayments, marketplace, venueHire, referrals, subscriptions, advertising, creatorEarnings, ranks, jobs,
  ];
}

/// Which features are on. Anything the website did not say is off: a failed read must never switch a feature on.
class SiteFeatures {
  const SiteFeatures(this._on);

  const SiteFeatures.allOff() : _on = const {};

  /// Reads `{"social": true, ...}`. Only a real `true` counts.
  factory SiteFeatures.parse(Object? json) {
    if (json is! Map) return const SiteFeatures.allOff();
    return SiteFeatures({
      for (final e in json.entries)
        if (e.key is String && e.value == true) e.key as String,
    });
  }

  final Set<String> _on;

  bool isOn(String key) => _on.contains(key);
}
