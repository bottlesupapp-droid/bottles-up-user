import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../site/models/my_night.dart';
import '../../../site/models/table_booking.dart';
import '../../../site/money.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/site_error.dart';

/// Bottles on the booking: how many there are, replacements the club suggested that wait for an answer, and a way to order more.
class OrdersSection extends ConsumerStatefulWidget {
  const OrdersSection({super.key, required this.booking, required this.canOrder, required this.onAddBottles});

  final TableBooking booking;

  /// Whether more can be ordered (the booking is paid and not over).
  final bool canOrder;
  final VoidCallback onAddBottles;

  @override
  ConsumerState<OrdersSection> createState() => _OrdersSectionState();
}

class _OrdersSectionState extends ConsumerState<OrdersSection> {
  final Set<String> _busy = {};

  void _say(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  Future<void> _answer(BottleSubstitution s, bool approve) async {
    if (_busy.contains(s.id)) return;
    setState(() => _busy.add(s.id));
    try {
      await ref.read(bookingActionsServiceProvider).answerSubstitution(token: s.token, approve: approve);
      if (mounted) _say(approve ? 'Replacement approved.' : 'Replacement declined.');
    } on SiteException catch (e) {
      if (mounted) _say(e.message);
    } finally {
      if (mounted) setState(() => _busy.remove(s.id));
      ref.invalidate(tableBookingProvider(widget.booking.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final b = widget.booking;
    final live = [for (final l in b.bottles) if (!l.cancelled) l];
    final count = live.fold<int>(0, (sum, l) => sum + l.quantity);
    final atClub = live.where((l) => l.dueAtClub).fold<int>(0, (sum, l) => sum + l.quantity);
    String money(int c) => formatMoney(c, currency: b.currency);
    String name(String lineId) {
      for (final l in b.bottles) {
        if (l.id == lineId) return l.displayName;
      }
      return 'A bottle';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          count == 0 ? 'No bottles ordered yet.' : '$count ${count == 1 ? 'bottle' : 'bottles'} ordered${atClub > 0 ? ' ($atClub to pay at the club)' : ''}.',
          key: const Key('orders-summary'),
          style: theme.textTheme.bodyMedium,
        ),
        for (final l in live)
          Padding(
            key: Key('bottle-line-${l.id}'),
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Expanded(child: Text('${l.displayName} × ${l.quantity}')),
                // Payment and service are two different things: paid or not, and where the venue has got to with it.
                Chip(key: Key('bottle-pay-${l.id}'), label: Text(l.dueAtClub ? 'Pay at the club' : 'Paid'), visualDensity: VisualDensity.compact),
                if (l.serviceLabel != null) ...[
                  const SizedBox(width: 6),
                  Chip(key: Key('bottle-service-${l.id}'), label: Text(l.serviceLabel!), visualDensity: VisualDensity.compact),
                ],
              ],
            ),
          ),
        for (final s in b.substitutions)
          Card(
            key: Key('sub-${s.id}'),
            color: theme.colorScheme.primaryContainer,
            margin: const EdgeInsets.only(top: 10),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${name(s.lineId)} is not available${s.reason.isEmpty ? '' : ' (${s.reason})'}. The club suggests ${s.replacementDisplay}'
                    '${s.priceDiffCents == 0 ? ', at the same price' : (s.priceDiffCents > 0 ? ', ${money(s.priceDiffCents)} more' : ', ${money(-s.priceDiffCents)} less')}.',
                    key: Key('sub-text-${s.id}'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      FilledButton(key: Key('sub-approve-${s.id}'), onPressed: _busy.contains(s.id) ? null : () => _answer(s, true), child: const Text('Approve')),
                      const SizedBox(width: 8),
                      OutlinedButton(key: Key('sub-decline-${s.id}'), onPressed: _busy.contains(s.id) ? null : () => _answer(s, false), child: const Text('Decline')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        if (widget.canOrder)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: OutlinedButton.icon(key: const Key('add-bottles'), onPressed: widget.onAddBottles, icon: const Icon(Icons.wine_bar_outlined), label: const Text('Order more bottles')),
          ),
      ],
    );
  }
}
