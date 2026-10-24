import '../read.dart';
import '../when.dart';

/// One guest on a table booking, as the website's `manage-guest-tickets` lists them. The guest gets their own ticket by e-mail; the host never sees the guest's code.
class GuestPass {
  const GuestPass({required this.id, required this.name, required this.email, this.sentAt, this.checkedInAt});

  final String id;
  final String name;
  final String email;

  /// When the ticket e-mail went out; null when it has not (yet).
  final DateTime? sentAt;
  final DateTime? checkedInAt;

  bool get checkedIn => checkedInAt != null;
  bool get sent => sentAt != null;

  String get status => checkedIn ? 'Checked in' : (sent ? 'Ticket sent' : 'Not sent yet');
}

GuestPass? parseGuestPass(Map<String, dynamic> row) {
  final id = readText(row['id']);
  final name = readText(row['guest_name']);
  final email = readText(row['guest_email']);
  if (id == null || name == null || email == null) return null;
  return GuestPass(id: id, name: name, email: email, sentAt: parseWhen(row['ticket_sent_at']), checkedInAt: parseWhen(row['checked_in_at']));
}

/// The guests on a booking and how many more can be added (the table seats [maxGuests], and the host is one of them).
class GuestRoster {
  const GuestRoster({required this.maxGuests, required this.remainingCapacity, required this.guests});

  final int maxGuests;
  final int remainingCapacity;
  final List<GuestPass> guests;

  bool get canAdd => remainingCapacity > 0;
}

GuestRoster? parseGuestRoster(Map<String, dynamic> row) {
  final b = row['booking'];
  if (b is! Map) return null;
  final max = readInt(b['maxGuests']);
  final remaining = readInt(b['remainingCapacity']);
  if (max == null || remaining == null) return null;
  final raw = row['guests'];
  return GuestRoster(
    maxGuests: max,
    remainingCapacity: remaining < 0 ? 0 : remaining,
    guests: [
      if (raw is List)
        for (final g in raw)
          if (g is Map) ...[
            if (parseGuestPass(Map<String, dynamic>.from(g)) case final p?) p,
          ],
    ],
  );
}

/// What the website said after trying to e-mail a new guest their ticket. A guest can be added and the e-mail still fail (they can be sent it again).
class GuestAddResult {
  const GuestAddResult({required this.name, required this.email, required this.sent});

  final String name;
  final String email;
  final bool sent;
}

/// A bottle the club suggests in place of one that is not available (`site_table_booking_bottle_substitutions`, `status = pending`). The guest approves or declines.
class BottleSubstitution {
  const BottleSubstitution({required this.id, required this.lineId, required this.reason, required this.replacementName, required this.priceDiffCents, required this.token, this.replacementSize});

  final String id;

  /// The bottle line it would replace.
  final String lineId;
  final String reason;
  final String replacementName;
  final String? replacementSize;

  /// What the replacement costs more (positive) or less (negative) than the bottle it replaces.
  final int priceDiffCents;

  /// The secret the answer is sent with; the guest's own, because the database shows them only their own rows.
  final String token;

  String get replacementDisplay => replacementSize == null ? replacementName : '$replacementName ($replacementSize)';
}

BottleSubstitution? parseSubstitution(Map<String, dynamic> row) {
  final id = readText(row['id']);
  final line = readText(row['bottle_line_id']);
  final token = readText(row['confirm_token']);
  if (id == null || line == null || token == null || row['status'] != 'pending') return null;
  return BottleSubstitution(
    id: id,
    lineId: line,
    reason: readText(row['reason']) ?? '',
    replacementName: readText(row['replacement_bottle_name']) ?? 'Another bottle',
    replacementSize: readText(row['replacement_size']),
    priceDiffCents: readInt(row['price_diff_cents']) ?? 0,
    token: token,
  );
}
