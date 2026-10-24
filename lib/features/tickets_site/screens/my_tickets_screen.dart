import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/ticket_order.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/site_error.dart';
import '../../../site/when.dart';

/// My tickets (a tab): the tickets bought with this account's e-mail, on the website or in this app. Upcoming first, then past and refunded. Tapping one shows the QR code.
class MyTicketsScreen extends ConsumerWidget {
  const MyTicketsScreen({super.key, this.scrollController, this.onOpen, DateTime? now}) : _now = now;

  final ScrollController? scrollController;
  final void Function(BuildContext context, TicketOrder order)? onOpen;
  final DateTime? _now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(myTicketOrdersProvider);
    final theme = Theme.of(context);
    final now = _now ?? DateTime.now();
    return SafeArea(
      bottom: false,
      child: orders.when(
        skipLoadingOnRefresh: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => LoadFailed(message: error is SiteException ? error.message : loadFailedMessage('your tickets'), onRetry: () => ref.invalidate(myTicketOrdersProvider)),
        data: (all) {
          final upcoming = [for (final o in all) if (o.isPaid && !o.isPast(now) && !o.isUsed) o];
          final past = [for (final o in all) if (o.isPaid && (o.isPast(now) || o.isUsed)) o];
          final refunded = [for (final o in all) if (o.isRefunded) o];
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(myTicketOrdersProvider);
              await ref.read(myTicketOrdersProvider.future).catchError((_) => <TicketOrder>[]);
            },
            child: ListView(
              key: const Key('my-tickets'),
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              children: [
                Text('My tickets', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                if (all.isEmpty)
                  const SizedBox(height: 420, child: EmptyState(icon: Icons.confirmation_number_outlined, title: 'No tickets yet', text: 'Tickets you buy appear here, with the QR code to show at the door.'))
                else ...[
                  if (upcoming.isEmpty) Padding(padding: const EdgeInsets.only(bottom: 12), child: Text('No upcoming tickets.', key: const Key('no-upcoming'), style: theme.textTheme.bodyMedium)),
                  for (final o in upcoming) _OrderCard(order: o, now: now, onTap: () => _open(context, o)),
                  if (past.isNotEmpty) ...[
                    const _Heading('Past'),
                    for (final o in past) _OrderCard(order: o, now: now, onTap: () => _open(context, o)),
                  ],
                  if (refunded.isNotEmpty) ...[
                    const _Heading('Refunded'),
                    for (final o in refunded) _OrderCard(order: o, now: now, onTap: () => _open(context, o)),
                  ],
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  void _open(BuildContext context, TicketOrder o) => (onOpen ?? (c, order) => c.push('/tickets/${order.id}'))(context, o);
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(top: 12, bottom: 8), child: Text(text, style: Theme.of(context).textTheme.titleMedium));
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order, required this.now, required this.onTap});

  final TicketOrder order;
  final DateTime now;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chip = order.isRefunded ? 'Refunded' : (order.isUsed ? 'Used' : (order.isPast(now) ? 'Ended' : null));
    return Card(
      key: Key('order-${order.id}'),
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              NetworkPicture(url: order.coverImageUrl, height: 64, width: 64),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.eventTitle, key: Key('order-title-${order.id}'), style: theme.textTheme.titleMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                    if (order.eventStart != null) Text(formatWhen(order.eventStart!), key: Key('order-when-${order.id}'), style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.primary)),
                    Text('${order.quantity} × ${order.tierName ?? 'Ticket'}${order.venueName == null ? '' : ' · ${order.venueName}'}', key: Key('order-line-${order.id}'), style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              if (chip != null) Chip(key: Key('order-chip-${order.id}'), label: Text(chip), visualDensity: VisualDensity.compact) else const Icon(Icons.qr_code_2),
            ],
          ),
        ),
      ),
    );
  }
}
