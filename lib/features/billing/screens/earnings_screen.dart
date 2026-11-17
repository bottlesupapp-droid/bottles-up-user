import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/billing.dart';
import '../../../site/models/features.dart';
import '../../../site/money.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/billing_rules.dart';
import '../../../site/rules/hiring_rules.dart';
import '../../../site/site_error.dart';
import '../../social/widgets/profile_widgets.dart';

/// What a profile has earned, kept apart by where it came from: jobs, tips and referrals. For each: what customers paid, what BottlesUp still holds, what is earned after the commission,
/// what is ready to be paid and what has been paid. Only a person whose role includes money matters sees it. BottlesUp pays by transfer and records it; nothing here moves money.
class EarningsScreen extends ConsumerWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const title = 'Earnings';
    if (!ref.watch(earningsOnProvider)) {
      return Scaffold(appBar: AppBar(title: const Text(title)), body: const EmptyState(icon: Icons.hourglass_empty, title: 'Coming soon', text: 'Earnings are not open yet.'));
    }
    return ActorGate(
      title: title,
      builder: (context, actor) {
        final access = ref.watch(profileAccessProvider(actor.id));
        return access.when(
          loading: () => Scaffold(appBar: AppBar(title: const Text(title)), body: const Center(child: CircularProgressIndicator())),
          error: (e, _) => Scaffold(
            appBar: AppBar(title: const Text(title)),
            body: LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('your role'), onRetry: () => ref.invalidate(profileAccessProvider(actor.id))),
          ),
          data: (a) {
            if (!a.can('finance')) {
              return Scaffold(appBar: AppBar(title: const Text(title)), body: const EmptyState(icon: Icons.lock_outline, title: 'Not part of your role', text: 'Ask the owner of this profile if you need to see its earnings.'));
            }
            final earnings = ref.watch(earningsProvider(actor.id));
            return Scaffold(
              appBar: AppBar(title: Text('Earnings of ${actor.displayName}')),
              body: earnings.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('your earnings'), onRetry: () => ref.invalidate(earningsProvider(actor.id))),
                data: (e) => RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(earningsProvider(actor.id));
                    await ref.read(earningsProvider(actor.id).future);
                  },
                  child: ListView(padding: const EdgeInsets.all(16), children: [
                    _Summary(e),
                    const SizedBox(height: 12),
                    if (isProfessional(actor) && ref.watch(featureOnProvider(Feature.marketplace))) ..._jobs(context, e.hiring),
                    if (actor.isBusiness && ref.watch(featureOnProvider(Feature.creatorEarnings))) ..._tips(context, e.tips),
                    if (ref.watch(featureOnProvider(Feature.referrals))) ..._referrals(context, e.referrals),
                    if (ref.watch(featureOnProvider(Feature.subscriptions)) && isProfessional(actor)) _SubscriptionTile(e.subscription),
                    const SizedBox(height: 12),
                    Text('BottlesUp pays what is ready by transfer and marks it as paid here. Nothing on this page moves money.', key: const Key('earnings-note'), style: Theme.of(context).textTheme.bodySmall),
                  ]),
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<Widget> _jobs(BuildContext context, EarningsPart p) => [
        _Section(
          key: const Key('earnings-jobs'),
          title: 'Jobs',
          rows: [
            _Line('Paid by customers', p.collectedCents),
            _Line('BottlesUp is holding', p.heldCents, hint: 'until the job is done and confirmed'),
            _Line('Earned after BottlesUp\'s share', p.earnedCents),
            _Line('Ready to be paid', p.withdrawableCents),
            _Line('Paid to you', p.paidCents),
          ],
        ),
      ];

  List<Widget> _tips(BuildContext context, EarningsPart p) => [
        _Section(
          key: const Key('earnings-tips'),
          title: p.count == null ? 'Tips' : 'Tips (${p.count})',
          rows: [
            _Line('Tipped', p.collectedCents),
            _Line('Yours after BottlesUp\'s share', p.earnedCents),
            _Line('Ready to be paid', p.withdrawableCents),
            _Line('Paid to you', p.paidCents),
          ],
        ),
      ];

  List<Widget> _referrals(BuildContext context, EarningsPart p) => [
        _Section(
          key: const Key('earnings-referrals'),
          title: 'Referrals',
          rows: [
            _Line('Earned', p.earnedCents),
            _Line('Ready to be paid', p.withdrawableCents),
            _Line('Paid to you', p.paidCents),
          ],
          action: TextButton(key: const Key('earnings-open-referrals'), onPressed: () => context.push('/me/referrals'), child: const Text('Your code')),
        ),
      ];
}

class _Summary extends StatelessWidget {
  const _Summary(this.earnings);

  final Earnings earnings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      key: const Key('earnings-summary'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Ready to be paid', style: theme.textTheme.bodyMedium),
          Text(formatMoney(earnings.withdrawableCents), key: const Key('earnings-ready'), style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('Paid to you so far: ${formatMoney(earnings.paidCents)}', key: const Key('earnings-paid')),
          if (earnings.heldCents > 0) Text('BottlesUp is holding ${formatMoney(earnings.heldCents)} for jobs not finished yet.', key: const Key('earnings-held')),
          if (earnings.isEmpty) ...[
            const SizedBox(height: 8),
            const Text('Nothing yet. Jobs, tips and referrals will show here.', key: Key('earnings-empty')),
          ],
        ]),
      ),
    );
  }
}

class _Line {
  const _Line(this.label, this.cents, {this.hint});

  final String label;
  final int cents;
  final String? hint;
}

class _Section extends StatelessWidget {
  const _Section({super.key, required this.title, required this.rows, this.action});

  final String title;
  final List<_Line> rows;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Expanded(child: Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800))), if (action != null) action!]),
          const SizedBox(height: 4),
          for (final r in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(r.label), if (r.hint != null) Text(r.hint!, style: theme.textTheme.bodySmall)])),
                Text(formatMoney(r.cents), style: theme.textTheme.bodyLarge),
              ]),
            ),
        ]),
      ),
    );
  }
}

class _SubscriptionTile extends StatelessWidget {
  const _SubscriptionTile(this.subscription);

  final Subscription? subscription;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          key: const Key('earnings-open-subscription'),
          leading: const Icon(Icons.workspace_premium_outlined),
          title: const Text('Subscription'),
          subtitle: Text(subscription == null ? 'Pay less commission on every booking.' : '${subscription!.plan.label} plan. ${subscriptionLine(subscription!)}'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/me/subscription'),
        ),
      );
}
