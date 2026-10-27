import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../site/providers/site_providers.dart';
import '../../../site/rules/night_rules.dart';
import '../../../site/when.dart';

/// "Your next night": the soonest table or tickets the person has paid for, one tap from its page (the guests, the bottles, the QR). Nothing when there is none.
class MyNightCard extends ConsumerWidget {
  const MyNightCard({super.key, this.now});

  final DateTime? now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(myTableBookingsProvider).valueOrNull ?? const [];
    final orders = ref.watch(myTicketOrdersProvider).valueOrNull ?? const [];
    final next = nextUp(bookings: bookings, orders: orders, now: now ?? DateTime.now());
    if (next == null) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final isTable = next.kind == NextUpKind.table;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Card(
        key: const Key('my-night'),
        child: ListTile(
          leading: CircleAvatar(backgroundColor: theme.colorScheme.primaryContainer, child: Icon(isTable ? Icons.table_restaurant_outlined : Icons.confirmation_number_outlined)),
          title: Text('Your next night', style: theme.textTheme.labelMedium),
          subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(next.title, key: const Key('my-night-title'), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            Text('${formatWhen(next.when)} · ${next.detail}', key: const Key('my-night-detail')),
          ]),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push(isTable ? '/bookings/${next.id}' : '/tickets/${next.id}'),
        ),
      ),
    );
  }
}
