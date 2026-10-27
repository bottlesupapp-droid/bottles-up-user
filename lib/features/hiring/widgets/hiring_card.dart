import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../site/models/hiring.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/hiring_rules.dart';
import 'hiring_widgets.dart';

/// On Home: a quote waiting for the person's answer, and, on a professional profile, requests waiting for a quote. Nothing when there is none or hiring is not open.
class HiringCard extends ConsumerWidget {
  const HiringCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actor = ref.watch(actorProfileProvider);
    final mine = ref.watch(myProRequestsProvider).valueOrNull ?? const <ProRequest>[];
    final quotes = [for (final r in mine) if (r.hasOpenQuote) r];
    final asked = actor != null && isProfessional(actor) ? (ref.watch(proRequestsForProvider(actor.id)).valueOrNull ?? const <ProRequest>[]) : const <ProRequest>[];
    final waiting = [for (final r in asked) if (r.status == RequestStatus.requested) r];
    if (quotes.isEmpty && waiting.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    Widget tile(Key key, IconData icon, String title, String detail, String path) => Card(
          key: key,
          child: ListTile(
            leading: CircleAvatar(backgroundColor: theme.colorScheme.primaryContainer, child: Icon(icon)),
            title: Text(title, style: theme.textTheme.titleSmall),
            subtitle: Text(detail),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(path),
          ),
        );
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(children: [
        if (quotes.isNotEmpty)
          tile(
            const Key('quotes-to-answer'),
            Icons.request_quote_outlined,
            quotes.length == 1 ? '${quotes.first.provider?.displayName ?? 'A professional'} sent you a quote' : '${quotes.length} quotes are waiting for your answer',
            quotes.length == 1 ? '${cents(quotes.first.quote!.totalCents)} · tap to answer' : 'Tap to see them',
            quotes.length == 1 ? '/hiring/${quotes.first.id}' : '/me/hiring',
          ),
        if (waiting.isNotEmpty)
          tile(
            const Key('requests-to-quote'),
            Icons.work_outline,
            waiting.length == 1 ? '${waiting.first.customer?.name ?? 'A customer'} asked for a quote' : '${waiting.length} people asked for a quote',
            'Tap to answer',
            waiting.length == 1 ? '/hiring/${waiting.first.id}' : '/me/pro-requests',
          ),
      ]),
    );
  }
}
