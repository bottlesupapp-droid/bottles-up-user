import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../site/models/split.dart';
import '../../../site/money.dart';
import '../../../site/providers/site_providers.dart';

/// "A friend asked you to pay your share": shown on Home while there is at least one request still open. Nothing when there is none or splitting is not open.
class SharesToPayCard extends ConsumerWidget {
  const SharesToPayCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all = ref.watch(myShareRequestsProvider).valueOrNull ?? const <ShareRequest>[];
    final open = [for (final r in all) if (r.state.canPay) r];
    if (open.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final first = open.first;
    final total = open.fold<int>(0, (s, r) => s + r.amountCents);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Card(
        key: const Key('shares-to-pay'),
        child: ListTile(
          leading: CircleAvatar(backgroundColor: theme.colorScheme.primaryContainer, child: const Icon(Icons.payments_outlined)),
          title: Text(open.length == 1 ? '${first.host} asked you to pay your share' : '${open.length} friends asked you to pay a share', key: const Key('shares-to-pay-title'), style: theme.textTheme.titleSmall),
          subtitle: Text(open.length == 1 ? '${first.venue} · ${formatMoney(first.amountCents, currency: first.currency)}' : '${formatMoney(total, currency: first.currency)} in all', key: const Key('shares-to-pay-detail')),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push(open.length == 1 ? '/me/shares/${first.id}' : '/me/shares'),
        ),
      ),
    );
  }
}
