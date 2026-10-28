import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/billing.dart';
import '../../../site/models/features.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/money.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/billing_rules.dart';
import '../../../site/rules/hiring_rules.dart';
import '../../../site/site_error.dart';
import '../../social/widgets/profile_widgets.dart';

enum _Phase { choosing, waiting, done }

/// The subscription of a professional's own profile: what it costs, what it changes (a lower commission on every booking while it is paid for), a way to pay on Stripe's page, and a way
/// to change the card or cancel on Stripe's page. The screen says the subscription is live only when the website says so.
class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key, this.interval = const Duration(seconds: 3), this.giveUpAfter = const Duration(minutes: 5)});

  final Duration interval;
  final Duration giveUpAfter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const title = 'Subscription';
    if (!ref.watch(featureOnProvider(Feature.subscriptions))) {
      return Scaffold(appBar: AppBar(title: const Text(title)), body: const EmptyState(icon: Icons.hourglass_empty, title: 'Coming soon', text: 'Subscriptions are not open yet.'));
    }
    return ActorGate(
      title: title,
      builder: (context, actor) {
        if (!isProfessional(actor)) {
          return Scaffold(
            appBar: AppBar(title: const Text(title)),
            body: const EmptyState(icon: Icons.workspace_premium_outlined, title: 'Switch to a professional profile', text: 'A subscription belongs to a professional profile (a DJ, a photographer...): switch to yours from the Profile tab.'),
          );
        }
        final access = ref.watch(profileAccessProvider(actor.id));
        return access.when(
          loading: () => Scaffold(appBar: AppBar(title: const Text(title)), body: const Center(child: CircularProgressIndicator())),
          error: (e, _) => Scaffold(
            appBar: AppBar(title: const Text(title)),
            body: LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('your role'), onRetry: () => ref.invalidate(profileAccessProvider(actor.id))),
          ),
          data: (a) {
            if (!a.owner) {
              return Scaffold(
                appBar: AppBar(title: const Text(title)),
                body: const EmptyState(icon: Icons.lock_outline, title: 'Only the owner', text: 'The owner of this profile manages its subscription.'),
              );
            }
            return _SubscriptionBody(actor: actor, interval: interval, giveUpAfter: giveUpAfter);
          },
        );
      },
    );
  }
}

class _SubscriptionBody extends ConsumerStatefulWidget {
  const _SubscriptionBody({required this.actor, required this.interval, required this.giveUpAfter});

  final SocialProfile actor;
  final Duration interval;
  final Duration giveUpAfter;

  @override
  ConsumerState<_SubscriptionBody> createState() => _SubscriptionBodyState();
}

class _SubscriptionBodyState extends ConsumerState<_SubscriptionBody> with WidgetsBindingObserver {
  _Phase _phase = _Phase.choosing;
  SubPlan _plan = SubPlan.yearly;
  bool _busy = false;
  bool _checking = false;
  bool _stalled = false;
  bool _managing = false;
  String? _problem;
  Timer? _timer;
  late DateTime _began;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    if (_phase == _Phase.waiting) _check();
    if (_managing) {
      _managing = false;
      ref.invalidate(subscriptionProvider(widget.actor.id));
    }
  }

  void _startWaiting() {
    _began = clock.now();
    _stalled = false;
    _phase = _Phase.waiting;
    _timer?.cancel();
    _timer = Timer.periodic(widget.interval, (_) => _tick());
  }

  void _tick() {
    if (_phase != _Phase.waiting) return;
    if (clock.now().difference(_began) >= widget.giveUpAfter) {
      _timer?.cancel();
      setState(() => _stalled = true);
      return;
    }
    _check();
  }

  Future<void> _check() async {
    if (_checking || _phase != _Phase.waiting) return;
    _checking = true;
    try {
      final s = await ref.read(billingServiceProvider).status(widget.actor.id);
      if (!mounted) return;
      if (s != null && s.isLive) {
        _timer?.cancel();
        ref.invalidate(subscriptionProvider(widget.actor.id));
        setState(() => _phase = _Phase.done);
      }
    } on SiteException {
      // Try again at the next tick.
    } finally {
      _checking = false;
    }
  }

  Future<void> _subscribe() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _problem = null;
    });
    try {
      final start = await ref.read(billingServiceProvider).subscribe(profile: widget.actor.id, plan: _plan);
      final opened = await ref.read(urlOpenerProvider)(start.url, inApp: true);
      if (!mounted) return;
      setState(() {
        _busy = false;
        if (opened) {
          _startWaiting();
        } else {
          _problem = 'We could not open the payment page. Check that your phone can open web pages, then try again.';
        }
      });
    } on SiteException catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _problem = e.message;
        });
        ref.invalidate(subscriptionProvider(widget.actor.id));
      }
    }
  }

  Future<void> _manage() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _problem = null;
    });
    try {
      final url = await ref.read(billingServiceProvider).managePage(widget.actor.id);
      final opened = await ref.read(urlOpenerProvider)(url, inApp: true);
      if (!mounted) return;
      setState(() {
        _busy = false;
        _managing = opened;
        if (!opened) _problem = 'We could not open the page. Check that your phone can open web pages, then try again.';
      });
    } on SiteException catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _problem = e.message;
        });
      }
    }
  }

  void _backToPlans() {
    _timer?.cancel();
    setState(() {
      _phase = _Phase.choosing;
      _stalled = false;
    });
    ref.invalidate(subscriptionProvider(widget.actor.id));
  }

  @override
  Widget build(BuildContext context) {
    final plans = ref.watch(billingPlansProvider);
    final sub = ref.watch(subscriptionProvider(widget.actor.id));
    return Scaffold(
      appBar: AppBar(title: const Text('Subscription')),
      body: plans.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('the prices'), onRetry: () => ref.invalidate(billingPlansProvider)),
        data: (p) {
          if (p == null) return const EmptyState(icon: Icons.hourglass_empty, title: 'Coming soon', text: 'Subscriptions are not open yet.');
          return sub.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('the subscription'), onRetry: () => ref.invalidate(subscriptionProvider(widget.actor.id))),
            data: (s) => ListView(padding: const EdgeInsets.all(16), children: [_content(context, p, s)]),
          );
        },
      ),
    );
  }

  Widget _content(BuildContext context, BillingPlans plans, Subscription? sub) {
    final theme = Theme.of(context);
    if (_phase == _Phase.done) {
      return Card(
        key: const Key('subscription-done'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.check_circle_outline, size: 40),
            const SizedBox(height: 8),
            Text('You are subscribed', style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(plans.lowersCommission ? 'Your commission is now ${percentText(plans.subscribedBps)} on every booking.' : 'Thank you.'),
            const SizedBox(height: 12),
            FilledButton(key: const Key('subscription-continue'), onPressed: _backToPlans, child: const Text('See my subscription')),
          ]),
        ),
      );
    }
    if (_phase == _Phase.waiting) {
      return Card(
        key: const Key('subscription-waiting'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (!_stalled) const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 12),
            Text(_stalled ? 'We have not heard from Stripe yet' : 'Waiting for Stripe to confirm your payment', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(_stalled ? 'If you paid, it can take a few minutes. Check again, or come back to this page later: nothing is charged twice.' : 'Finish paying on the page that opened. This page updates by itself.'),
            const SizedBox(height: 12),
            Wrap(spacing: 8, children: [
              FilledButton(key: const Key('subscription-check'), onPressed: _checking ? null : _check, child: const Text('Check now')),
              TextButton(key: const Key('subscription-back'), onPressed: _backToPlans, child: const Text('Back to the plans')),
            ]),
          ]),
        ),
      );
    }
    if (sub != null && sub.isLive) return _live(context, plans, sub);
    return _choose(context, plans, sub);
  }

  Widget _live(BuildContext context, BillingPlans plans, Subscription sub) {
    final theme = Theme.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Card(
        key: const Key('subscription-card'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${sub.plan.label} plan', key: const Key('subscription-plan'), style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(planPriceText(plans, sub.plan)),
            const SizedBox(height: 8),
            Text(subscriptionLine(sub), key: const Key('subscription-line')),
            if (plans.lowersCommission) ...[
              const SizedBox(height: 8),
              Text('Commission on your bookings: ${percentText(plans.subscribedBps)} instead of ${percentText(plans.standardBps)}.', key: const Key('subscription-commission')),
            ],
          ]),
        ),
      ),
      const SizedBox(height: 12),
      FilledButton.tonal(key: const Key('manage-subscription'), onPressed: _busy ? null : _manage, child: const Text('Change card or cancel')),
      if (_problem != null) _Problem(_problem!),
      const SizedBox(height: 8),
      const Text('Stripe, our payment partner, runs that page. Cancelling keeps the lower commission until the end of the period you paid for.'),
    ]);
  }

  Widget _choose(BuildContext context, BillingPlans plans, Subscription? sub) {
    final theme = Theme.of(context);
    final ended = sub != null && sub.isCancelled;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(plans.lowersCommission ? 'Keep more of every booking' : 'Subscribe', style: theme.textTheme.titleLarge),
      const SizedBox(height: 4),
      Text(plans.lowersCommission
          ? 'With a subscription BottlesUp takes ${percentText(plans.subscribedBps)} of each booking you do, instead of ${percentText(plans.standardBps)}.'
          : 'A subscription for your professional profile.'),
      if (ended) ...[
        const SizedBox(height: 8),
        Text(subscriptionLine(sub), key: const Key('subscription-ended')),
      ],
      const SizedBox(height: 12),
      for (final plan in SubPlan.values)
        Card(
          key: Key('plan-${plan.wire}'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: _plan == plan ? theme.colorScheme.primary : theme.dividerColor, width: _plan == plan ? 2 : 1)),
          child: ListTile(
            onTap: _busy ? null : () => setState(() => _plan = plan),
            leading: Icon(_plan == plan ? Icons.radio_button_checked : Icons.radio_button_off),
            title: Text(plan.label),
            subtitle: Text(plan == SubPlan.yearly && plans.yearlySavingCents > 0 ? '${planPriceText(plans, plan)} (saves ${formatMoney(plans.yearlySavingCents, currency: plans.currency)})' : planPriceText(plans, plan)),
          ),
        ),
      if (_problem != null) _Problem(_problem!),
      const SizedBox(height: 12),
      FilledButton(key: const Key('subscribe'), onPressed: _busy ? null : _subscribe, child: Text(_busy ? 'Opening...' : 'Subscribe, ${planPriceText(plans, _plan)}')),
      const SizedBox(height: 8),
      const Text('You pay on Stripe\'s page. It renews by itself until you cancel, and you can cancel from this screen at any time.'),
    ]);
  }
}

class _Problem extends StatelessWidget {
  const _Problem(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(text, key: const Key('subscription-problem'), style: TextStyle(color: Theme.of(context).colorScheme.error)),
      );
}
