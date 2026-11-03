import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/split.dart';
import '../../../site/money.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/site_error.dart';
import '../../../site/when.dart';

enum _Phase { choosing, waiting, done }

/// One request to pay a share of a friend's table: what it is for, how much, until when, and a way to pay on Stripe's page. The screen says it is paid only when the website says so.
class PayShareScreen extends ConsumerStatefulWidget {
  const PayShareScreen({super.key, required this.shareId, this.interval = const Duration(seconds: 3), this.giveUpAfter = const Duration(minutes: 5), this.onBack});

  final String shareId;
  final Duration interval;
  final Duration giveUpAfter;

  /// Where "Back" goes. The app goes back; tests give their own.
  final void Function(BuildContext context)? onBack;

  @override
  ConsumerState<PayShareScreen> createState() => _PayShareScreenState();
}

class _PayShareScreenState extends ConsumerState<PayShareScreen> with WidgetsBindingObserver {
  _Phase _phase = _Phase.choosing;
  bool _busy = false;
  bool _checking = false;
  bool _stalled = false;
  String? _problem;
  String? _hint;
  Uri? _payUrl;
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
    if (state == AppLifecycleState.resumed && _phase == _Phase.waiting) _check();
  }

  void _back() => (widget.onBack ?? (c) => c.pop())(context);

  void _startWaiting() {
    _began = clock.now();
    _stalled = false;
    _hint = null;
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
      final state = await ref.read(splitServiceProvider).paymentStatus(widget.shareId);
      if (!mounted) return;
      switch (state) {
        case SharePayment.paid:
          _timer?.cancel();
          ref.invalidate(myShareRequestsProvider);
          setState(() => _phase = _Phase.done);
        case SharePayment.expired:
        case SharePayment.cancelled:
        case SharePayment.declined:
          _timer?.cancel();
          ref.invalidate(myShareRequestsProvider);
          setState(() {
            _phase = _Phase.choosing;
            _problem = state == SharePayment.expired ? 'The time to pay this has passed.' : 'This request is no longer open.';
          });
        case SharePayment.pending:
        case SharePayment.unpaid:
          setState(() => _hint = null);
      }
    } on SiteException catch (e) {
      if (mounted) setState(() => _hint = e.message);
    } finally {
      _checking = false;
    }
  }

  Future<void> _pay() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _problem = null;
    });
    try {
      final start = await ref.read(splitServiceProvider).startPayment(widget.shareId);
      final opened = await ref.read(urlOpenerProvider)(start.url, inApp: true);
      if (!mounted) return;
      setState(() {
        _busy = false;
        if (opened) {
          _payUrl = start.url;
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
        ref.invalidate(myShareRequestsProvider);
      }
    }
  }

  Future<void> _decline() async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Turn this down?'),
        content: const Text('You will not be asked to pay it again. The host can still send a new request.'),
        actions: [
          TextButton(key: const Key('share-keep'), onPressed: () => Navigator.pop(c, false), child: const Text('Keep it')),
          FilledButton(key: const Key('share-decline-confirm'), onPressed: () => Navigator.pop(c, true), child: const Text('Turn it down')),
        ],
      ),
    );
    if (yes != true || !mounted) return;
    setState(() => _busy = true);
    try {
      await ref.read(splitServiceProvider).decline(widget.shareId);
      ref.invalidate(myShareRequestsProvider);
      if (mounted) _back();
    } on SiteException catch (e) {
      if (mounted) setState(() => _problem = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final requests = ref.watch(myShareRequestsProvider);
    return PopScope(
      canPop: _phase != _Phase.waiting,
      child: Scaffold(
        appBar: AppBar(title: const Text('Pay your share')),
        body: requests.when(
          skipLoadingOnRefresh: true,
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('this request'), onRetry: () => ref.invalidate(myShareRequestsProvider)),
          data: (list) {
            ShareRequest? r;
            for (final x in list) {
              if (x.id == widget.shareId) r = x;
            }
            if (_phase == _Phase.done) return _done(r);
            if (_phase == _Phase.waiting) return _waiting(r);
            if (r == null) return const EmptyState(icon: Icons.receipt_long_outlined, title: 'Request not found', text: 'It may have been cancelled or is no longer yours to pay.');
            return _details(r);
          },
        ),
      ),
    );
  }

  Widget _details(ShareRequest r) {
    final theme = Theme.of(context);
    final money = formatMoney(r.amountCents, currency: r.currency);
    final line = switch (r.state) {
      ShareState.unpaid || ShareState.pending => 'Pay by ${formatWhen(r.deadline)}.',
      ShareState.paid => 'You paid${r.paidAt == null ? '' : ' on ${formatWhen(r.paidAt!)}'}. Stripe e-mailed you a receipt.',
      ShareState.refunding => 'You paid and it is being paid back to your card.',
      ShareState.refunded => 'You paid and it was paid back to your card.',
      ShareState.expired => 'The time to pay this has passed. Ask ${r.host} to send a new request.',
      ShareState.cancelled => '${r.host} cancelled this, or the booking was cancelled. Nothing is due.',
      ShareState.declined => 'You turned this request down.',
    };
    return ListView(
      key: const Key('share-details'),
      padding: const EdgeInsets.all(20),
      children: [
        Text('${r.host} asked you to pay your share', key: const Key('share-title'), style: theme.textTheme.titleLarge),
        const SizedBox(height: 4),
        Text('${r.venue}${r.night.isEmpty ? '' : ' · ${r.night}'}', key: const Key('share-venue'), style: theme.textTheme.titleMedium),
        const SizedBox(height: 16),
        Text(money, key: const Key('share-amount'), style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text(line, key: const Key('share-line')),
        if (r.state.canPay) ...[
          const SizedBox(height: 4),
          Text('You pay on Stripe\'s page. Nothing is added to this amount.', style: theme.textTheme.bodySmall),
        ],
        if (_problem != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(_problem!, key: const Key('share-problem'), style: TextStyle(color: theme.colorScheme.error))),
        const SizedBox(height: 20),
        if (r.state.canPay) FilledButton(key: const Key('share-pay'), onPressed: _busy ? null : _pay, child: Text(_busy ? 'Working...' : 'Pay $money')),
        if (r.state == ShareState.unpaid || r.state == ShareState.expired) TextButton(key: const Key('share-decline'), onPressed: _busy ? null : _decline, child: const Text('Turn this down')),
        TextButton(key: const Key('share-back'), onPressed: _back, child: const Text('Back')),
      ],
    );
  }

  Widget _waiting(ShareRequest? r) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!_stalled) const CircularProgressIndicator(key: Key('share-waiting')) else const Icon(Icons.hourglass_empty, size: 48, key: Key('share-stalled')),
          const SizedBox(height: 20),
          Text(_stalled ? 'We have not seen your payment yet' : 'Waiting for your payment', style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(
            _stalled ? 'If you paid, it will show as paid within a minute or two. If you did not pay, you can open the page again.' : 'Pay on the page that opened. This screen updates by itself as soon as it goes through.',
            key: const Key('share-wait-text'),
            textAlign: TextAlign.center,
          ),
          if (_hint != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(_hint!, key: const Key('share-hint'), style: TextStyle(color: theme.colorScheme.error), textAlign: TextAlign.center)),
          const SizedBox(height: 24),
          FilledButton(key: const Key('share-check'), onPressed: _checking ? null : () {
            setState(() => _stalled = false);
            _check();
          }, child: Text(_stalled ? 'Check again' : 'I have paid')),
          if (_payUrl != null) TextButton(key: const Key('share-reopen'), onPressed: () => ref.read(urlOpenerProvider)(_payUrl!, inApp: true), child: const Text('Open the payment page again')),
          TextButton(key: const Key('share-leave'), onPressed: () {
            _timer?.cancel();
            setState(() => _phase = _Phase.choosing);
          }, child: const Text('Back to the request')),
        ],
      ),
    );
  }

  Widget _done(ShareRequest? r) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, size: 56, color: Colors.green, key: Key('share-done')),
          const SizedBox(height: 12),
          Text('Your share is paid', style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(r == null ? 'Stripe e-mails you a receipt.' : 'You paid ${formatMoney(r.amountCents, currency: r.currency)} towards ${r.host}\'s table at ${r.venue}. Stripe e-mails you a receipt.', key: const Key('share-done-text'), textAlign: TextAlign.center),
          const SizedBox(height: 20),
          FilledButton(key: const Key('share-done-back'), onPressed: _back, child: const Text('Done')),
        ],
      ),
    );
  }
}
