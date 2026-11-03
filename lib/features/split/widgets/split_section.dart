import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../site/models/split.dart';
import '../../../site/models/table_booking.dart';
import '../../../site/money.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/split_rules.dart';
import '../../../site/site_error.dart';
import '../../../site/when.dart';

/// "Split the bill" on a booking: ask friends to pay their share of what is still owed at the club, and see who has. Only the person who booked sees it (the website refuses anyone else).
class SplitSection extends ConsumerStatefulWidget {
  const SplitSection({super.key, required this.booking, required this.canStart});

  final TableBooking booking;

  /// The booking is on, not over, and something is left to pay.
  final bool canStart;

  @override
  ConsumerState<SplitSection> createState() => _SplitSectionState();
}

class _SplitSectionState extends ConsumerState<SplitSection> {
  bool _busy = false;

  Future<void> _cancel(SplitPlan plan) async {
    final money = formatMoney(plan.collectedCents, currency: plan.currency);
    final yes = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Cancel this split?'),
        content: Text(plan.collectedCents > 0 ? 'Friends who have already paid ($money) are paid back in full. To split again you will make a new one.' : 'Nobody has paid yet. Your friends are told it is cancelled. To split again you will make a new one.'),
        actions: [
          TextButton(key: const Key('split-keep'), onPressed: () => Navigator.pop(c, false), child: const Text('Keep it')),
          FilledButton(key: const Key('split-cancel-confirm'), onPressed: () => Navigator.pop(c, true), child: const Text('Cancel the split')),
        ],
      ),
    );
    if (yes != true || !mounted) return;
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final result = await ref.read(splitServiceProvider).cancel(plan.id);
      messenger.showSnackBar(SnackBar(
        content: Text(plan.collectedCents <= 0
            ? 'Split cancelled.'
            : (result.failed > 0 ? 'Split cancelled. Some refunds are on their way: they can take a little while.' : 'Split cancelled. Your friends have been paid back.')),
      ));
    } on SiteException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      ref.invalidate(splitForBookingProvider(widget.booking.id));
      ref.invalidate(tableBookingProvider(widget.booking.id));
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final plan = ref.watch(splitForBookingProvider(widget.booking.id));
    final b = widget.booking;
    return plan.when(
      skipLoadingOnRefresh: true,
      loading: () => const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: LinearProgressIndicator(key: Key('split-loading'))),
      error: (e, _) => Row(children: [
        Expanded(child: Text(e is SiteException ? e.message : loadFailedMessage('the split'), key: const Key('split-error'))),
        TextButton(key: const Key('split-retry'), onPressed: () => ref.invalidate(splitForBookingProvider(b.id)), child: const Text('Try again')),
      ]),
      data: (p) {
        if (p == null || p.isCancelled) return _Start(booking: b, canStart: widget.canStart, wasCancelled: p != null);
        return _Plan(plan: p, busy: _busy, onCancel: () => _cancel(p), onRefresh: () => ref.invalidate(splitForBookingProvider(b.id)));
      },
    );
  }
}

class _Start extends StatelessWidget {
  const _Start({required this.booking, required this.canStart, required this.wasCancelled});

  final TableBooking booking;
  final bool canStart;
  final bool wasCancelled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final due = booking.dueAtClubCents;
    final reason = booking.isOver(clock.now())
        ? 'This booking has ended.'
        : (due < minShareCents ? 'There is nothing left to split: the rest is paid.' : null);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (wasCancelled) Padding(padding: const EdgeInsets.only(bottom: 6), child: Text('Your last split was cancelled.', key: const Key('split-was-cancelled'), style: theme.textTheme.bodySmall)),
          Text(
            due > 0 ? 'Ask your friends to pay their share of the ${formatMoney(due, currency: booking.currency)} still owed at the club. They pay on Stripe\'s page; you pay your own part at the club as usual.' : 'Nothing is left to pay at the club.',
            key: const Key('split-explained'),
          ),
          const SizedBox(height: 10),
          FilledButton.tonal(key: const Key('split-start'), onPressed: canStart ? () => context.push('/bookings/${booking.id}/split') : null, child: const Text('Split the bill')),
          if (!canStart && reason != null) Padding(padding: const EdgeInsets.only(top: 6), child: Text(reason, key: const Key('split-cannot'), style: theme.textTheme.bodySmall)),
        ]),
      ),
    );
  }
}

class _Plan extends StatelessWidget {
  const _Plan({required this.plan, required this.busy, required this.onCancel, required this.onRefresh});

  final SplitPlan plan;
  final bool busy;
  final VoidCallback onCancel;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String money(int c) => formatMoney(c, currency: plan.currency);
    final title = switch (plan.state) {
      SplitState.open => 'Waiting for your friends',
      SplitState.complete => 'Everyone has paid',
      SplitState.expired => 'The time to pay has passed',
      SplitState.cancelled => 'Cancelled',
    };
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(title, key: const Key('split-title'), style: theme.textTheme.titleSmall)),
            IconButton(key: const Key('split-refresh'), tooltip: 'Refresh', icon: const Icon(Icons.refresh), onPressed: onRefresh),
          ]),
          Text('Friends have paid ${money(plan.collectedCents)} of the ${money(plan.totalAskedCents)} you asked for.', key: const Key('split-summary')),
          Text(plan.state == SplitState.open ? 'They can pay until ${formatWhen(plan.deadline)}.' : 'The deadline was ${formatWhen(plan.deadline)}.', key: const Key('split-deadline'), style: theme.textTheme.bodySmall),
          const Divider(height: 20),
          for (final s in plan.shares)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(children: [
                Expanded(child: Text(s.payer?.displayName ?? 'A friend', key: Key('split-share-${s.id}'))),
                Text(money(s.amountCents)),
                const SizedBox(width: 10),
                Chip(key: Key('split-share-state-${s.id}'), label: Text(s.state.label), visualDensity: VisualDensity.compact),
              ]),
            ),
          const Divider(height: 20),
          Text('Still to pay at the club: ${money(plan.balanceCents)}', key: const Key('split-balance'), style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          OutlinedButton(key: const Key('split-cancel'), onPressed: busy || !plan.canCancel ? null : onCancel, child: Text(busy ? 'Working...' : 'Cancel the split')),
        ]),
      ),
    );
  }
}
