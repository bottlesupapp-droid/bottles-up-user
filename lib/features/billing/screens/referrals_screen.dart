import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/features.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/money.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/billing_rules.dart';
import '../../../site/site_error.dart';
import '../../social/widgets/profile_widgets.dart';

/// Referrals: the code of the profile the person is acting as (to share), what it has earned, and a box to use somebody else's code. A code can be used once and never your own; the
/// website pays the person who sent you only when you make your first purchase.
class ReferralsScreen extends ConsumerStatefulWidget {
  const ReferralsScreen({super.key, this.share});

  /// How a message is shared. The phone's share sheet; tests give their own.
  final Future<void> Function(String text)? share;

  @override
  ConsumerState<ReferralsScreen> createState() => _ReferralsScreenState();
}

class _ReferralsScreenState extends ConsumerState<ReferralsScreen> {
  final _code = TextEditingController();
  bool _busy = false;
  String? _problem;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  void _say(String text) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));

  Future<void> _copy(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (mounted) _say('Code copied.');
  }

  Future<void> _share(String code) => (widget.share ?? (t) => Share.share(t))('Join me on BottlesUp and use my code $code when you sign up.');

  Future<void> _claim() async {
    if (_busy) return;
    final wrong = checkReferralCode(_code.text);
    if (wrong != null) return setState(() => _problem = wrong);
    setState(() {
      _busy = true;
      _problem = null;
    });
    try {
      final referrer = await ref.read(billingServiceProvider).claim(_code.text);
      ref.invalidate(referralClaimProvider);
      if (mounted) {
        _code.clear();
        _say(referrer == null ? 'The code was used.' : 'Thank you. ${referrer.displayName} sent you.');
      }
    } on SiteException catch (e) {
      if (mounted) setState(() => _problem = e.message);
      ref.invalidate(referralClaimProvider);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Referrals';
    if (!ref.watch(featureOnProvider(Feature.referrals))) {
      return Scaffold(appBar: AppBar(title: const Text(title)), body: const EmptyState(icon: Icons.hourglass_empty, title: 'Coming soon', text: 'Referrals are not open yet.'));
    }
    return ActorGate(
      title: title,
      builder: (context, actor) => Scaffold(
        appBar: AppBar(title: const Text(title)),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          _yourCode(context, actor),
          const SizedBox(height: 16),
          _useCode(context),
        ]),
      ),
    );
  }

  Widget _yourCode(BuildContext context, SocialProfile actor) {
    final theme = Theme.of(context);
    final code = ref.watch(referralCodeProvider(actor.id));
    final stats = ref.watch(referralStatsProvider(actor.id)).valueOrNull;
    return Card(
      key: const Key('referral-code-card'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: code.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Column(children: [
            Text(e is SiteException ? e.message : loadFailedMessage('your code'), key: const Key('referral-code-error')),
            TextButton(key: const Key('referral-code-retry'), onPressed: () => ref.invalidate(referralCodeProvider(actor.id)), child: const Text('Try again')),
          ]),
          data: (c) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Your code${actor.isBusiness ? ' for ${actor.displayName}' : ''}', style: theme.textTheme.bodyMedium),
            SelectableText(c, key: const Key('referral-code'), style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800, letterSpacing: 2)),
            const SizedBox(height: 8),
            Text(stats == null || stats.creditCents <= 0 ? 'Friends who use your code and make their first purchase earn you a credit.' : 'When a friend uses your code and makes their first purchase, you earn ${formatMoney(stats.creditCents)}.'),
            const SizedBox(height: 12),
            Wrap(spacing: 8, children: [
              FilledButton.icon(key: const Key('referral-share'), onPressed: () => _share(c), icon: const Icon(Icons.ios_share), label: const Text('Share')),
              OutlinedButton.icon(key: const Key('referral-copy'), onPressed: () => _copy(c), icon: const Icon(Icons.copy), label: const Text('Copy')),
            ]),
            if (stats != null) ...[
              const Divider(height: 24),
              _stat('People who used it', '${stats.referred}', const Key('referral-referred')),
              _stat('First purchases credited', '${stats.credited}', const Key('referral-credited')),
              _stat('Ready to be paid', formatMoney(stats.payableCents), const Key('referral-payable')),
              _stat('Paid to you', formatMoney(stats.paidCents), const Key('referral-paid')),
            ],
          ]),
        ),
      ),
    );
  }

  Widget _stat(String label, String value, Key key) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(children: [Expanded(child: Text(label)), Text(value, key: key)]),
      );

  Widget _useCode(BuildContext context) {
    final claim = ref.watch(referralClaimProvider);
    return claim.when(
      loading: () => const SizedBox.shrink(),
      error: (e, _) => Card(
        child: ListTile(
          key: const Key('referral-claim-error'),
          title: Text(e is SiteException ? e.message : loadFailedMessage('your referral')),
          trailing: TextButton(onPressed: () => ref.invalidate(referralClaimProvider), child: const Text('Try again')),
        ),
      ),
      data: (c) {
        if (c != null) {
          return Card(
            key: const Key('referral-used'),
            child: ListTile(leading: const Icon(Icons.check_circle_outline), title: Text(c.referrer == null ? 'You used a code.' : 'You used the code of ${c.referrer!.displayName}.')),
          );
        }
        return Card(
          key: const Key('referral-claim-card'),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Did a friend send you?', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              const Text('Type their code. You can use one code, once, and not your own.'),
              const SizedBox(height: 8),
              TextField(
                key: const Key('referral-input'),
                controller: _code,
                textCapitalization: TextCapitalization.characters,
                autocorrect: false,
                enabled: !_busy,
                decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'Code', errorText: _problem),
                onChanged: (_) => setState(() => _problem = null),
              ),
              const SizedBox(height: 8),
              FilledButton(key: const Key('referral-use'), onPressed: _busy ? null : _claim, child: Text(_busy ? 'Checking...' : 'Use this code')),
            ]),
          ),
        );
      },
    );
  }
}
