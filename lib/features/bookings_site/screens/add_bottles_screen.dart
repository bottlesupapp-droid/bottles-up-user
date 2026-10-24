import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/checkout.dart';
import '../../../site/models/venue.dart';
import '../../../site/money.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/table_rules.dart';
import '../../../site/services/booking_actions_service.dart';
import '../../../site/site_error.dart';
import '../../tables/widgets/bottle_widgets.dart';

enum _Phase { choosing, waiting, done }

/// Order more bottles for a booking that is already paid. The venue decides how they are paid (now on Stripe's page, or at the club); the website checks the menu, the stock and the
/// price again. When they are paid now the screen waits for the website to say it went through, and says so only then.
class AddBottlesScreen extends ConsumerStatefulWidget {
  const AddBottlesScreen({super.key, required this.bookingId, this.interval = const Duration(seconds: 3), this.giveUpAfter = const Duration(minutes: 5), this.onBack});

  final String bookingId;
  final Duration interval;
  final Duration giveUpAfter;

  /// Where "Back to my booking" goes. The app goes back; tests give their own.
  final void Function(BuildContext context)? onBack;

  @override
  ConsumerState<AddBottlesScreen> createState() => _AddBottlesScreenState();
}

class _AddBottlesScreenState extends ConsumerState<AddBottlesScreen> with WidgetsBindingObserver {
  final Map<String, int> _cart = {};
  BottlePaymentChoice _choice = BottlePaymentChoice.payAhead;
  bool _choiceSet = false;
  _Phase _phase = _Phase.choosing;
  bool _busy = false;
  String? _problem;
  Uri? _waitingUrl;
  Uri? _payUrl;
  String? _sessionId;
  String? _hint;
  bool _stalled = false;
  bool _checking = false;
  bool _paidNow = false;
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

  int _subtotal(List<Bottle> bottles) => bottles.fold(0, (sum, b) => sum + b.priceCents * (_cart[b.id] ?? 0));

  void _startWaiting(CheckoutStart start) {
    _payUrl = start.url;
    _sessionId = start.sessionId;
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
    final id = _sessionId;
    if (_checking || id == null || _phase != _Phase.waiting) return;
    _checking = true;
    try {
      final state = await ref.read(bookingActionsServiceProvider).addonStatus(id);
      if (!mounted) return;
      if (state == AddonState.paid) {
        _timer?.cancel();
        ref.invalidate(tableBookingProvider(widget.bookingId));
        ref.invalidate(myTableBookingsProvider);
        setState(() {
          _phase = _Phase.done;
          _paidNow = true;
        });
      } else {
        setState(() => _hint = null);
      }
    } on SiteException catch (e) {
      if (mounted) setState(() => _hint = e.message);
    } finally {
      _checking = false;
    }
  }

  Future<void> _order(Venue venue, List<Bottle> bottles) async {
    if (_busy || _subtotal(bottles) == 0) return;
    setState(() {
      _busy = true;
      _problem = null;
      _waitingUrl = null;
    });
    try {
      final result = await ref.read(bookingActionsServiceProvider).addBottles(bookingId: widget.bookingId, bottles: {for (final b in bottles) if ((_cart[b.id] ?? 0) > 0) b.id: _cart[b.id]!}, choice: effectiveChoice(venue.bottlePaymentMode, _choice));
      if (!mounted) return;
      if (result.mode == BottlePaymentChoice.payAtClub) {
        ref.invalidate(tableBookingProvider(widget.bookingId));
        ref.invalidate(myTableBookingsProvider);
        setState(() {
          _busy = false;
          _phase = _Phase.done;
          _paidNow = false;
        });
        return;
      }
      final opened = await ref.read(urlOpenerProvider)(result.start!.url, inApp: true);
      if (!mounted) return;
      setState(() {
        _busy = false;
        if (opened) {
          _startWaiting(result.start!);
        } else {
          _problem = 'We could not open the payment page. Check that your phone can open web pages, then try again.';
        }
      });
    } on AddonPaymentPending catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _problem = e.message;
          _waitingUrl = e.url;
        });
      }
    } on SiteException catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _problem = e.message;
        });
      }
    }
  }

  Future<void> _resume(Uri url) async {
    final opened = await ref.read(urlOpenerProvider)(url, inApp: true);
    if (!mounted) return;
    setState(() {
      if (opened) {
        _problem = null;
        _waitingUrl = null;
        _startWaiting(CheckoutStart(url: url, sessionId: sessionIdFromCheckoutUrl(url.toString())));
      } else {
        _problem = 'We could not open the payment page. Check that your phone can open web pages, then try again.';
      }
    });
  }

  void _back() => (widget.onBack ?? (c) => c.pop())(context);

  @override
  Widget build(BuildContext context) {
    final booking = ref.watch(tableBookingProvider(widget.bookingId));
    return PopScope(
      canPop: _phase != _Phase.waiting,
      child: Scaffold(
        appBar: AppBar(title: const Text('Order more bottles')),
        body: booking.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => LoadFailed(message: error is SiteException ? error.message : loadFailedMessage('this booking'), onRetry: () => ref.invalidate(tableBookingProvider(widget.bookingId))),
          data: (b) {
            if (_phase == _Phase.done) return _done();
            if (_phase == _Phase.waiting) return _waiting();
            if (b == null || !b.isPaid || b.venueId == null) {
              return const EmptyState(icon: Icons.wine_bar_outlined, title: 'Bottles cannot be added here', text: 'Only a confirmed booking can order more bottles.');
            }
            return _choose(b.venueId!);
          },
        ),
      ),
    );
  }

  Widget _choose(String venueId) {
    final theme = Theme.of(context);
    final venue = ref.watch(venueProvider(venueId));
    final bottles = ref.watch(venueBottlesProvider(venueId));
    final fee = ref.watch(siteFeeProvider);
    final v = venue.valueOrNull;
    if (venue.hasError || bottles.hasError) {
      final e = venue.error ?? bottles.error;
      return LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('the bottle menu'), onRetry: () {
        ref.invalidate(venueProvider(venueId));
        ref.invalidate(venueBottlesProvider(venueId));
      });
    }
    if (v == null || bottles.isLoading) return const Center(child: CircularProgressIndicator());
    final list = bottles.value ?? const <Bottle>[];
    if (!_choiceSet) {
      _choiceSet = true;
      _choice = v.bottlePaymentMode == BottlePaymentMode.payAtClub ? BottlePaymentChoice.payAtClub : BottlePaymentChoice.payAhead;
    }
    if (list.isEmpty) return const EmptyState(icon: Icons.wine_bar_outlined, title: 'No bottle menu yet', text: 'This venue has not put its bottles on the menu.');
    final subtotal = _subtotal(list);
    final choice = effectiveChoice(v.bottlePaymentMode, _choice);
    final quote = quoteTable(tableCents: 0, bottleSubtotalCents: subtotal, choice: choice, depositIsCredit: false, taxRateBps: v.taxRateBps, feeBps: fee.valueOrNull);
    final atClub = choice == BottlePaymentChoice.payAtClub;
    String money(int c) => formatMoney(c);
    return ListView(
      key: const Key('add-bottles-form'),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
      children: [
        for (final b in list) BottleTile(bottle: b, showImage: v.showBottleImages, quantity: _cart[b.id] ?? 0, onChanged: (n) => setState(() => n <= 0 ? _cart.remove(b.id) : _cart[b.id] = n)),
        if (subtotal > 0) ...[
          const Divider(height: 24),
          BottlePaymentChoiceTiles(mode: v.bottlePaymentMode, choice: _choice, onChanged: (c) => setState(() => _choice = c)),
          const SizedBox(height: 12),
          Row(children: [const Expanded(child: Text('Bottles')), Text(money(subtotal), key: const Key('addon-subtotal'))]),
          if (!atClub && quote.taxCents > 0) Row(children: [const Expanded(child: Text('Tax')), Text(money(quote.taxCents), key: const Key('addon-tax'))]),
          if (!atClub && quote.feeCents > 0) Row(children: [const Expanded(child: Text('BottlesUp fee')), Text(money(quote.feeCents), key: const Key('addon-fee'))]),
          const SizedBox(height: 4),
          Row(children: [Expanded(child: Text(atClub ? 'To pay at the club' : 'Total due now', style: theme.textTheme.titleSmall)), Text(money(atClub ? subtotal : quote.totalNowCents), key: const Key('addon-total'), style: theme.textTheme.titleMedium)]),
          const SizedBox(height: 6),
          Text(atClub ? 'You pay for these at the club. The venue is told now.' : 'You pay on the next page. The website checks the menu, the stock and the price again before you pay.', key: const Key('addon-explained'), style: theme.textTheme.bodySmall),
        ],
        if (_problem != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(_problem!, key: const Key('addon-problem'), style: TextStyle(color: theme.colorScheme.error))),
        if (_waitingUrl != null) Padding(padding: const EdgeInsets.only(top: 8), child: OutlinedButton(key: const Key('addon-resume'), onPressed: () => _resume(_waitingUrl!), child: const Text('Open the payment page'))),
        const SizedBox(height: 16),
        FilledButton(key: const Key('add-confirm'), onPressed: _busy || subtotal == 0 ? null : () => _order(v, list), child: Text(_busy ? 'Working...' : (atClub ? 'Order bottles' : 'Continue to payment'))),
      ],
    );
  }

  Widget _waiting() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!_stalled) const CircularProgressIndicator(key: Key('addon-waiting')) else const Icon(Icons.hourglass_empty, size: 48, key: Key('addon-stalled')),
          const SizedBox(height: 20),
          Text(_stalled ? 'We have not seen your payment yet' : 'Waiting for your payment', style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(
            _sessionId == null
                ? 'Pay on the page that opened. We cannot follow this payment automatically: when you have paid, go back to your booking.'
                : (_stalled ? 'If you paid, your bottles will show on your booking within a minute or two. If you did not pay, you can try again.' : 'Pay for your bottles on the page that opened. This screen updates by itself as soon as it goes through.'),
            key: const Key('addon-wait-text'),
            textAlign: TextAlign.center,
          ),
          if (_hint != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(_hint!, key: const Key('addon-hint'), style: TextStyle(color: theme.colorScheme.error), textAlign: TextAlign.center)),
          const SizedBox(height: 24),
          if (_sessionId != null) FilledButton(key: const Key('addon-check'), onPressed: _checking ? null : () {
            setState(() => _stalled = false);
            _check();
          }, child: Text(_stalled ? 'Check again' : 'I have paid')),
          if (_payUrl != null) TextButton(key: const Key('addon-reopen'), onPressed: () => ref.read(urlOpenerProvider)(_payUrl!, inApp: true), child: const Text('Open the payment page again')),
          TextButton(key: const Key('addon-leave'), onPressed: _back, child: const Text('Back to my booking')),
        ],
      ),
    );
  }

  Widget _done() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, size: 56, color: Colors.green, key: Key('addon-done')),
          const SizedBox(height: 12),
          Text(_paidNow ? 'Your bottles are paid and added' : 'Your bottles are ordered', style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(_paidNow ? 'They are on your booking.' : 'You pay for them at the club. They are on your booking.', key: const Key('addon-done-text'), textAlign: TextAlign.center),
          const SizedBox(height: 20),
          FilledButton(key: const Key('addon-back'), onPressed: _back, child: const Text('Back to my booking')),
        ],
      ),
    );
  }
}
