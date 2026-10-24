import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/site_event.dart';
import '../../../site/money.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/ticket_rules.dart';
import '../../../site/site_config.dart';
import '../../../site/site_error.dart';
import '../../../site/when.dart';

/// One event: the picture, when and where, what it is, who plays, what to know, and the ticket types with what is left. Choosing one opens the purchase. Reads the website's published
/// event and its ticket types, so it always shows what the website shows.
class EventPageScreen extends ConsumerStatefulWidget {
  const EventPageScreen({super.key, required this.eventId, this.onBuy, this.share});

  final String eventId;

  /// Where "Get tickets" goes. The app opens the purchase; tests give their own.
  final void Function(BuildContext context, SiteEvent event, TicketTier tier)? onBuy;

  /// Shares the event's web address. Replaced in tests.
  final Future<void> Function(String text)? share;

  @override
  ConsumerState<EventPageScreen> createState() => _EventPageScreenState();
}

class _EventPageScreenState extends ConsumerState<EventPageScreen> {
  String? _tierId;

  void _buy(SiteEvent e, TicketTier t) {
    final go = widget.onBuy ?? (c, ev, tier) => c.push('/events/${ev.id}/tickets/${tier.id}');
    go(context, e, t);
  }

  Future<void> _share(SiteEvent e) async {
    final text = '${e.title} · ${formatWhen(e.start)}\n${eventPageUri(e.id)}';
    await (widget.share ?? (t) => Share.share(t))(text);
  }

  @override
  Widget build(BuildContext context) {
    final event = ref.watch(eventProvider(widget.eventId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event'),
        actions: [
          if (event.valueOrNull != null) IconButton(key: const Key('event-share'), icon: const Icon(Icons.ios_share), onPressed: () => _share(event.value!)),
        ],
      ),
      body: event.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => LoadFailed(
          message: error is SiteException ? error.message : loadFailedMessage('this event'),
          onRetry: () => ref.invalidate(eventProvider(widget.eventId)),
        ),
        data: (e) {
          if (e == null) {
            return const EmptyState(
              icon: Icons.event_busy_outlined,
              title: 'This event is no longer available',
              text: 'It may have been taken down. See what else is on.',
            );
          }
          return _body(e);
        },
      ),
    );
  }

  Widget _body(SiteEvent e) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final over = e.isOver(now);
    TicketTier? chosen;
    for (final t in e.tiers) {
      if (t.id == _tierId) chosen = t;
    }
    final block = chosen == null ? null : tierBlock(chosen, unlocked: true);
    return Column(
      children: [
        Expanded(
          child: ListView(
            key: const Key('event-page'),
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              NetworkPicture(url: e.picture, height: 220, width: double.infinity, radius: 0),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (e.category != null) Padding(padding: const EdgeInsets.only(bottom: 6), child: Text(e.category!.toUpperCase(), style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.primary, letterSpacing: 1.2))),
                    Text(e.title, key: const Key('event-title'), style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 12),
                    _Fact(icon: Icons.calendar_today_outlined, text: formatWhen(e.start), keyName: 'event-when'),
                    if (e.venueName.isNotEmpty) _Fact(icon: Icons.place_outlined, text: [e.venueName, if (e.address != null) e.address!].join(' · '), keyName: 'event-where'),
                    if (e.organizerName != null) _Fact(icon: Icons.verified_outlined, text: 'By ${e.organizerName}${e.organizerVerified ? ' (verified)' : ''}', keyName: 'event-by'),
                    if (over)
                      Container(
                        key: const Key('event-over'),
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(10)),
                        child: const Text('This event has ended.'),
                      ),
                    if (e.description.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(e.description, key: const Key('event-description'), style: theme.textTheme.bodyLarge),
                    ],
                    if (e.lineup.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text('Line-up', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 6),
                      for (final a in e.lineup) Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text(a, key: Key('lineup-$a'))),
                    ],
                    if (e.goodToKnow.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text('Good to know', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 6),
                      for (final g in e.goodToKnow) Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('•  '), Expanded(child: Text(g))])),
                    ],
                    const SizedBox(height: 24),
                    Text('Tickets', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    if (e.tiers.isEmpty)
                      Text('Tickets for this event are not on sale yet.', key: const Key('no-tickets'), style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant))
                    else
                      for (final t in e.tiers)
                        _TierTile(
                          tier: t,
                          selected: t.id == _tierId,
                          disabled: over || t.soldOut,
                          onTap: () => setState(() => _tierId = t.id),
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!over && e.tiers.isNotEmpty)
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  key: const Key('get-tickets'),
                  onPressed: chosen == null || block == TierBlock.soldOut ? null : () => _buy(e, chosen!),
                  child: Text(chosen == null ? 'Choose a ticket' : 'Get tickets · ${formatPrice(chosen.priceCents, currency: chosen.currency)}'),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.text, required this.keyName});

  final IconData icon;
  final String text;
  final String keyName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(child: Text(text, key: Key(keyName))),
        ],
      ),
    );
  }
}

class _TierTile extends StatelessWidget {
  const _TierTile({required this.tier, required this.selected, required this.disabled, required this.onTap});

  final TicketTier tier;
  final bool selected;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scarce = scarcityLabel(tier);
    final notes = <String>[
      if (tier.requiresAccessCode) 'Needs an access code',
      if (tier.isNonTransferable) 'Stays with the buyer: you get a code by email to show at the door',
    ];
    return Card(
      key: Key('tier-${tier.id}'),
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: selected ? theme.colorScheme.primary : Colors.transparent, width: 2)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: disabled ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tier.name, style: theme.textTheme.titleMedium?.copyWith(color: tier.soldOut ? theme.disabledColor : null)),
                    if (scarce != null) Text(scarce, key: Key('tier-scarcity-${tier.id}'), style: theme.textTheme.bodySmall?.copyWith(color: tier.soldOut ? theme.disabledColor : theme.colorScheme.primary)),
                    for (final n in notes) Padding(padding: const EdgeInsets.only(top: 2), child: Text(n, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant))),
                  ],
                ),
              ),
              Text(formatPrice(tier.priceCents, currency: tier.currency), key: Key('tier-price-${tier.id}'), style: theme.textTheme.titleMedium),
              if (selected) const Padding(padding: EdgeInsets.only(left: 8), child: Icon(Icons.check_circle, key: Key('tier-selected'))),
            ],
          ),
        ),
      ),
    );
  }
}
