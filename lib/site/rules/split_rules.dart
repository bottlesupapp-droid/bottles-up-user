import '../money.dart';

/// The limits the website enforces on a split bill (`split_create`). The app checks the same things first so a person is told before they send, but the website has the last word.
const int minShareCents = 500;
const int maxShareCents = 500000;
const int maxSplitFriends = 20;

/// What each friend pays when the balance is shared equally between the host and [friends] friends: the balance divided by one more than the friends, rounded down to the cent. The host's
/// own part, and any cents left over, stay owed at the club, so a friend is never asked for more than their fair share.
List<int> equalShares({required int balanceCents, required int friends}) {
  if (friends < 1 || balanceCents <= 0) return const [];
  final each = balanceCents ~/ (friends + 1);
  return List<int>.filled(friends, each);
}

/// The sentence for what is wrong with these amounts, or null when they can be sent. [amounts] are in the order the friends were chosen.
String? checkShares({required List<int> amounts, required int balanceCents}) {
  if (amounts.isEmpty) return 'Choose at least one friend.';
  if (amounts.length > maxSplitFriends) return 'A split can have up to $maxSplitFriends friends.';
  if (amounts.any((a) => a < minShareCents)) return 'The smallest share is ${formatMoney(minShareCents)}.';
  if (amounts.any((a) => a > maxShareCents)) return 'The largest share is ${formatMoney(maxShareCents)}.';
  final total = amounts.fold<int>(0, (sum, a) => sum + a);
  if (total > balanceCents) return 'The shares add up to more than what is left to pay (${formatMoney(balanceCents)}).';
  return null;
}

/// Parses what a person typed into an amount box ("25", "25.5", "25.50", "$25.50") as whole cents, or null when it is not an amount.
int? parseAmountCents(String text) {
  final t = text.trim().replaceAll(RegExp(r'^\$'), '').replaceAll(',', '');
  final m = RegExp(r'^(\d{1,7})(?:\.(\d{1,2}))?$').firstMatch(t);
  if (m == null) return null;
  final dollars = int.parse(m.group(1)!);
  final cents = m.group(2) == null ? 0 : int.parse(m.group(2)!.padRight(2, '0'));
  return dollars * 100 + cents;
}

/// A choice of deadline offered to the host.
class DeadlineOption {
  const DeadlineOption(this.label, this.at);

  final String label;
  final DateTime at;
}

/// The deadlines a host may pick: at least an hour from now, no more than 14 days away, and not after the booking is over (twelve hours after arrival), the website's own limits. Without a
/// known arrival only the two near ones are offered. Earliest first; a choice that falls outside the limits is left out.
List<DeadlineOption> deadlineOptions({required DateTime now, DateTime? arrival}) {
  final earliest = now.add(const Duration(hours: 1, minutes: 1));
  var latest = now.add(const Duration(days: 14)).subtract(const Duration(minutes: 1));
  if (arrival != null) {
    final over = arrival.add(const Duration(hours: 12)).subtract(const Duration(minutes: 1));
    if (over.isBefore(latest)) latest = over;
  }
  final all = <DeadlineOption>[
    DeadlineOption('In 2 hours', now.add(const Duration(hours: 2))),
    DeadlineOption('In 24 hours', now.add(const Duration(hours: 24))),
    if (arrival != null) DeadlineOption('6 hours before you arrive', arrival.subtract(const Duration(hours: 6))),
    if (arrival != null) DeadlineOption('When you arrive', arrival),
  ];
  final seen = <DateTime>{};
  final out = [
    for (final o in all)
      if (!o.at.isBefore(earliest) && !o.at.isAfter(latest) && seen.add(o.at)) o,
  ]..sort((a, b) => a.at.compareTo(b.at));
  return out;
}
