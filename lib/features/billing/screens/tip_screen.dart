import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/features.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/money.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/billing_rules.dart';
import '../../../site/rules/split_rules.dart';
import '../../../site/site_error.dart';
import '../../social/widgets/profile_widgets.dart';
import '../../social/widgets/rules_gate.dart';

enum _Phase { choosing, waiting, done }

/// Tip a business profile (a DJ, a photographer, a venue...): pick an amount, add a few words, pay on Stripe's page. The screen says the tip was sent only when the website says Stripe
/// has taken the payment. BottlesUp keeps a share (set in the CMS); the rest is the profile's.
class TipScreen extends ConsumerStatefulWidget {
  const TipScreen({super.key, required this.profileId, this.interval = const Duration(seconds: 3), this.giveUpAfter = const Duration(minutes: 5)});

  final String profileId;
  final Duration interval;
  final Duration giveUpAfter;

  @override
  ConsumerState<TipScreen> createState() => _TipScreenState();
}

class _TipScreenState extends ConsumerState<TipScreen> with WidgetsBindingObserver {
  final _custom = TextEditingController();
  final _message = TextEditingController();
  _Phase _phase = _Phase.choosing;
  int? _choice = tipChoices[1];
  bool _busy = false;
  bool _checking = false;
  bool _stalled = false;
  String? _problem;
  String? _tipId;
  int _sentCents = 0;
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
    _custom.dispose();
    _message.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _phase == _Phase.waiting) _check();
  }

  /// The amount in cents: what was typed in the box if anything, otherwise the button chosen.
  int? get _cents => _custom.text.trim().isNotEmpty ? parseAmountCents(_custom.text) : _choice;

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
    final tip = _tipId;
    if (tip == null || _checking || _phase != _Phase.waiting) return;
    _checking = true;
    try {
      final state = await ref.read(billingServiceProvider).tipState(tip);
      if (!mounted) return;
      if (state != null && state.isPaid) {
        _timer?.cancel();
        setState(() => _phase = _Phase.done);
      } else if (state != null && state.isVoid) {
        _timer?.cancel();
        setState(() {
          _phase = _Phase.choosing;
          _problem = 'That payment did not go through. You were not charged.';
        });
      }
    } on SiteException {
      // Try again at the next tick.
    } finally {
      _checking = false;
    }
  }

  Future<void> _send(SocialProfile creator) async {
    if (_busy) return;
    final cents = _cents;
    if (_custom.text.trim().isNotEmpty && cents == null) return setState(() => _problem = 'Type the amount like 7 or 7.50.');
    final wrong = checkTip(cents: cents, message: _message.text);
    if (wrong != null) return setState(() => _problem = wrong);
    // Busy from here on, so a second tap while the rules are being checked sends nothing.
    setState(() {
      _busy = true;
      _problem = null;
    });
    try {
      if (!await ensureRulesAccepted(context, ref)) return;
      final start = await ref.read(billingServiceProvider).startTip(creator: creator.id, cents: cents!, message: _message.text);
      final opened = await ref.read(urlOpenerProvider)(start.url, inApp: true);
      if (!mounted) return;
      setState(() {
        if (opened) {
          _tipId = start.tipId;
          _sentCents = cents;
          _startWaiting();
        } else {
          _problem = 'We could not open the payment page. Check that your phone can open web pages, then try again.';
        }
      });
    } on SiteException catch (e) {
      if (mounted) setState(() => _problem = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Send a tip';
    if (!ref.watch(featureOnProvider(Feature.creatorEarnings))) {
      return Scaffold(appBar: AppBar(title: const Text(title)), body: const EmptyState(icon: Icons.hourglass_empty, title: 'Coming soon', text: 'Tips are not open yet.'));
    }
    return ActorGate(
      title: title,
      builder: (context, actor) {
        final profile = ref.watch(socialProfileProvider(ProfileKey(actor: actor.id, id: widget.profileId)));
        return Scaffold(
          appBar: AppBar(title: const Text(title)),
          body: profile.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('that profile'), onRetry: () => ref.invalidate(socialProfileProvider(ProfileKey(actor: actor.id, id: widget.profileId)))),
            data: (p) {
              if (!p.isBusiness || p.isMine) {
                return const EmptyState(icon: Icons.volunteer_activism_outlined, title: 'This profile cannot be tipped', text: 'You can tip a business profile that is not your own.');
              }
              return ListView(padding: const EdgeInsets.all(16), children: [switch (_phase) {
                _Phase.choosing => _choosing(context, p),
                _Phase.waiting => _waiting(context, p),
                _Phase.done => _done(context, p),
              }]);
            },
          ),
        );
      },
    );
  }

  Widget _choosing(BuildContext context, SocialProfile p) {
    final theme = Theme.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(children: [
        ProfileAvatar(profile: p, size: 48),
        const SizedBox(width: 12),
        Expanded(child: Text('Tip ${p.displayName}', style: theme.textTheme.titleLarge)),
      ]),
      const SizedBox(height: 4),
      const Text('A thank you for a great night or a great job. The money goes to their profile, less a small share that BottlesUp keeps.'),
      const SizedBox(height: 12),
      Wrap(spacing: 8, children: [
        for (final c in tipChoices)
          ChoiceChip(
            key: Key('tip-$c'),
            label: Text(formatMoney(c)),
            selected: _custom.text.trim().isEmpty && _choice == c,
            onSelected: _busy ? null : (_) => setState(() {
              _choice = c;
              _custom.clear();
              _problem = null;
            }),
          ),
      ]),
      const SizedBox(height: 8),
      TextField(
        key: const Key('tip-custom'),
        controller: _custom,
        enabled: !_busy,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(labelText: 'Or another amount', prefixText: '\$ '),
        onChanged: (_) => setState(() => _problem = null),
      ),
      const SizedBox(height: 8),
      TextField(
        key: const Key('tip-message'),
        controller: _message,
        enabled: !_busy,
        minLines: 1,
        maxLines: 3,
        maxLength: maxTipMessageLength,
        decoration: const InputDecoration(labelText: 'A few words (optional)'),
      ),
      if (_problem != null) Padding(padding: const EdgeInsets.only(top: 4), child: Text(_problem!, key: const Key('tip-problem'), style: TextStyle(color: theme.colorScheme.error))),
      const SizedBox(height: 12),
      FilledButton(key: const Key('tip-send'), onPressed: _busy ? null : () => _send(p), child: Text(_busy ? 'Opening...' : (_cents == null || _cents! <= 0 ? 'Send tip' : 'Send ${formatMoney(_cents!)}'))),
      const SizedBox(height: 8),
      const Text('You pay on Stripe\'s page. A tip cannot be taken back once it is sent.'),
    ]);
  }

  Widget _waiting(BuildContext context, SocialProfile p) {
    final theme = Theme.of(context);
    return Card(
      key: const Key('tip-waiting'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (!_stalled) const Center(child: CircularProgressIndicator()),
          const SizedBox(height: 12),
          Text(_stalled ? 'We have not heard from Stripe yet' : 'Waiting for Stripe to confirm your payment', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(_stalled ? 'If you paid, it can take a few minutes. Check again: nothing is charged twice.' : 'Finish paying on the page that opened. This page updates by itself.'),
          const SizedBox(height: 12),
          Wrap(spacing: 8, children: [
            FilledButton(key: const Key('tip-check'), onPressed: _checking ? null : _check, child: const Text('Check now')),
            TextButton(
              key: const Key('tip-back'),
              onPressed: () {
                _timer?.cancel();
                setState(() => _phase = _Phase.choosing);
              },
              child: const Text('Back'),
            ),
          ]),
        ]),
      ),
    );
  }

  Widget _done(BuildContext context, SocialProfile p) {
    final theme = Theme.of(context);
    return Card(
      key: const Key('tip-done'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.favorite_border, size: 40),
          const SizedBox(height: 8),
          Text('Thank you', style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text('Your ${formatMoney(_sentCents)} tip is on its way to ${p.displayName}.'),
          const SizedBox(height: 12),
          FilledButton(key: const Key('tip-finish'), onPressed: () => context.canPop() ? context.pop() : context.go('/'), child: const Text('Done')),
        ]),
      ),
    );
  }
}
