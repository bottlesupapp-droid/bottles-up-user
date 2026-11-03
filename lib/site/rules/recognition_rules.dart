import '../models/recognition.dart';

/// The limits the website enforces on a plaque's delivery address and on the words that go with a request to be verified.
const int maxVerificationNoteLength = 500;

int _len(String? s) => s?.trim().length ?? 0;

/// The sentence for what is wrong with a note sent with a request to be verified, or null.
String? checkVerificationNote(String? note) => _len(note) > maxVerificationNoteLength ? 'Keep it to $maxVerificationNoteLength characters.' : null;

/// The sentence for what is wrong with a delivery address, or null. The website checks the same lengths.
String? checkPlaqueAddress(PlaqueAddress a) {
  if (_len(a.recipient) < 2 || _len(a.recipient) > 80) return 'Write the name for the parcel (2 to 80 characters).';
  if (_len(a.line1) < 3 || _len(a.line1) > 120) return 'Write the street address (3 to 120 characters).';
  if (_len(a.line2) > 120) return 'Keep the second address line to 120 characters.';
  if (_len(a.city) < 2 || _len(a.city) > 80) return 'Write the city (2 to 80 characters).';
  if (_len(a.region) > 80) return 'Keep the province or state to 80 characters.';
  if (_len(a.postal) < 2 || _len(a.postal) > 20) return 'Write the postal code (2 to 20 characters).';
  if (_len(a.country) < 2 || _len(a.country) > 60) return 'Write the country (2 to 60 characters).';
  if (_len(a.phone) > 30) return 'Keep the phone number to 30 characters.';
  return null;
}

/// "1,000,000" for a count of followers.
String followersText(int n) => n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');

/// "100K", "1M", "50M": a count of followers in a few characters.
String shortFollowers(int n) {
  if (n >= 1000000 && n % 1000000 == 0) return '${n ~/ 1000000}M';
  if (n >= 1000 && n % 1000 == 0 && n < 1000000) return '${n ~/ 1000}K';
  return followersText(n);
}

/// What a badge means, in words, for the sheet that opens when it is tapped.
String rankExplanation(RankLevel level) => level.isVerified
    ? 'BottlesUp checked that this profile belongs to who it says it does.'
    : 'Verified, and ${shortFollowers(level.minFollowers)} genuine followers. BottlesUp looks at the followers before it awards this rank. Ranks are earned, never bought.';

/// The level with this key, from the list the website gave or, failing that, the one in the client's plan.
RankLevel? levelFor(String? key, List<RankLevel> levels) {
  if (key == null) return null;
  for (final l in levels.isEmpty ? proposedRanks : levels) {
    if (l.key == key) return l;
  }
  for (final l in proposedRanks) {
    if (l.key == key) return l;
  }
  return null;
}

/// How far [followers] is towards [needed], from 0 to 1.
double progressTowards(int followers, int needed) {
  if (needed <= 0) return 1;
  final p = followers / needed;
  return p < 0 ? 0 : (p > 1 ? 1 : p);
}
