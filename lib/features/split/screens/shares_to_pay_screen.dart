import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/split.dart';
import '../../../site/money.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/site_error.dart';
import '../../../site/when.dart';

/// Every request the person has had to pay a share of a friend's table: the ones to pay first, then the rest.
class SharesToPayScreen extends ConsumerWidget {
  const SharesToPayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(myShareRequestsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Shares to pay')),
      body: requests.when(
        skipLoadingOnRefresh: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('your requests to pay'), onRetry: () => ref.invalidate(myShareRequestsProvider)),
        data: (list) {
          if (list.isEmpty) return const EmptyState(icon: Icons.receipt_long_outlined, title: 'Nothing to pay', text: 'When a friend asks you to pay your share of their table, it shows here.');
          final toPay = [for (final r in list) if (r.state.canPay) r];
          final rest = [for (final r in list) if (!r.state.canPay) r];
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(myShareRequestsProvider);
              await ref.read(myShareRequestsProvider.future).catchError((_) => const <ShareRequest>[]);
            },
            child: ListView(key: const Key('shares-list'), physics: const AlwaysScrollableScrollPhysics(), padding: const EdgeInsets.only(bottom: 40), children: [
              if (toPay.isNotEmpty) const _Heading('To pay'),
              for (final r in toPay) _Row(request: r),
              if (rest.isNotEmpty) const _Heading('Earlier'),
              for (final r in rest) _Row(request: r),
            ]),
          );
        },
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 4), child: Text(text, style: Theme.of(context).textTheme.titleSmall));
}

class _Row extends StatelessWidget {
  const _Row({required this.request});

  final ShareRequest request;

  @override
  Widget build(BuildContext context) {
    final r = request;
    return ListTile(
      key: Key('share-${r.id}'),
      leading: const CircleAvatar(child: Icon(Icons.table_restaurant_outlined)),
      title: Text('${r.host} · ${r.venue}'),
      subtitle: Text('${r.night.isEmpty ? '' : '${r.night}\n'}${r.state.label}${r.state.canPay ? ' · pay by ${formatWhen(r.deadline)}' : ''}'),
      isThreeLine: r.night.isNotEmpty,
      trailing: Text(formatMoney(r.amountCents, currency: r.currency), style: Theme.of(context).textTheme.titleMedium),
      onTap: () => context.push('/me/shares/${r.id}'),
    );
  }
}
