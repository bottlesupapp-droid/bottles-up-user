import '../models/table_booking.dart';
import '../models/ticket_order.dart';

enum NextUpKind { table, tickets }

/// The one thing coming up soonest that the person has paid for: a table or tickets.
class NextUp {
  const NextUp({required this.kind, required this.id, required this.title, required this.detail, required this.when});

  final NextUpKind kind;

  /// The booking's or the order's id.
  final String id;
  final String title;
  final String detail;
  final DateTime when;
}

/// The soonest paid, not-yet-over table booking or ticket order, or null when there is none. A table wins a tie. A ticket whose event has no start time is left out (there is
/// nothing to say about when).
NextUp? nextUp({required List<TableBooking> bookings, required List<TicketOrder> orders, required DateTime now}) {
  final candidates = <NextUp>[];
  for (final b in bookings) {
    if (!b.isPaid || b.isOver(now)) continue;
    candidates.add(NextUp(
      kind: NextUpKind.table,
      id: b.id,
      title: b.venueName,
      detail: '${b.tableName} · ${b.guestCount} ${b.guestCount == 1 ? 'guest' : 'guests'}',
      when: b.arrival ?? b.bookingDate,
    ));
  }
  for (final o in orders) {
    final start = o.eventStart;
    if (start == null || !o.isPaid || o.isPast(now) || o.isUsed) continue;
    candidates.add(NextUp(
      kind: NextUpKind.tickets,
      id: o.id,
      title: o.eventTitle,
      detail: '${o.quantity} ${o.quantity == 1 ? 'ticket' : 'tickets'}${o.venueName == null ? '' : ' · ${o.venueName}'}',
      when: start,
    ));
  }
  if (candidates.isEmpty) return null;
  candidates.sort((a, b) {
    final c = a.when.compareTo(b.when);
    return c != 0 ? c : (a.kind == b.kind ? 0 : (a.kind == NextUpKind.table ? -1 : 1));
  });
  return candidates.first;
}
