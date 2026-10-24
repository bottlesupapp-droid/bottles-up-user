import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../site/models/checkout.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/site_error.dart';
import '../../../site/when.dart';
import '../../main_navigation/providers/nav_index_provider.dart';
import '../widgets/ticket_qr.dart';
import 'ticket_purchase_screen.dart';

/// After the payment page was opened: waits for the website to say the payment went through, then shows the ticket. The payment itself is on Stripe's page; this screen only asks the
/// website how it went (and asks again when the person comes back to the app), and never says "paid" until the website has issued the ticket.
class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key, required this.args, this.interval = const Duration(seconds: 3), this.giveUpAfter = const Duration(minutes: 5), this.onViewTickets, this.onBackToEvent});

  final PaymentWaitArgs args;
  final Duration interval;
  final Duration giveUpAfter;
  final void Function(BuildContext context)? onViewTickets;
  final void Function(BuildContext context)? onBackToEvent;

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

enum _Phase { waiting, paid, failed, stalled }

class _PaymentScreenState extends ConsumerState<PaymentScreen> with WidgetsBindingObserver {
  Timer? _timer;
  _Phase _phase = _Phase.waiting;
  PaidTicket? _ticket;
  String? _hint;
  bool _checking = false;
  late final DateTime _began;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _began = clock.now();
    _timer = Timer.periodic(widget.interval, (_) => _tick());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Coming back from the payment page: look straight away.
    if (state == AppLifecycleState.resumed && _phase == _Phase.waiting) _check();
  }

  void _tick() {
    if (_phase != _Phase.waiting) return;
    if (clock.now().difference(_began) >= widget.giveUpAfter) {
      setState(() => _phase = _Phase.stalled);
      return;
    }
    _check();
  }

  /// Asks the website once. Safe to call at any time and as often as wanted.
  Future<void> _check() async {
    if (_checking || _phase == _Phase.paid || _phase == _Phase.failed) return;
    _checking = true;
    try {
      final a = widget.args;
      PaymentStatus status;
      final sessionId = a.start.sessionId;
      if (sessionId != null) {
        status = await ref.read(ticketCheckoutServiceProvider).status(sessionId);
      } else {
        // The website did not say which payment it was: look for the order this person made just now.
        final order = await ref.read(myTicketsServiceProvider).latestFor(eventId: a.eventId, tierId: a.tierId, since: a.startedAt);
        if (order != null && order.isPaid) {
          status = PaymentStatus(
            PaymentState.paid,
            ticket: PaidTicket(
              ticketCode: order.ticketCode!,
              quantity: order.quantity,
              tierName: order.tierName ?? '',
              eventTitle: order.eventTitle,
              venueName: order.venueName ?? '',
              startDate: order.eventStart,
              customerEmail: '',
              discountCents: order.discountCents,
            ),
          );
        } else if (order != null && order.status.db == 'failed') {
          status = const PaymentStatus(PaymentState.failed);
        } else {
          status = const PaymentStatus(PaymentState.waiting);
        }
      }
      if (!mounted) return;
      switch (status.state) {
        case PaymentState.paid:
          _timer?.cancel();
          ref.invalidate(myTicketOrdersProvider);
          setState(() {
            _phase = _Phase.paid;
            _ticket = status.ticket;
            _hint = null;
          });
        case PaymentState.failed:
        case PaymentState.notFound:
          // "not found" right after starting can be a moment of delay; only a clear "failed" ends the wait. Not found is kept as waiting until we give up.
          if (status.state == PaymentState.failed) {
            _timer?.cancel();
            setState(() => _phase = _Phase.failed);
          }
        case PaymentState.waiting:
          setState(() => _hint = null);
      }
    } on SiteException catch (e) {
      if (mounted) setState(() => _hint = e.message);
    } finally {
      _checking = false;
    }
  }

  Future<void> _again() async {
    setState(() => _phase = _Phase.waiting);
    await ref.read(urlOpenerProvider)(widget.args.start.url, inApp: true);
  }

  void _viewTickets() {
    final go = widget.onViewTickets ??
        (c) {
          ref.read(mainNavIndexProvider.notifier).state = 1;
          c.go('/home');
        };
    go(context);
  }

  void _back() => (widget.onBackToEvent ?? (c) => c.go('/events/${widget.args.eventId}'))(context);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: _phase != _Phase.paid,
      child: Scaffold(
        appBar: AppBar(title: const Text('Payment'), automaticallyImplyLeading: _phase != _Phase.paid),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: switch (_phase) {
            _Phase.waiting => _waiting(theme),
            _Phase.paid => _paid(theme),
            _Phase.failed => _failed(theme),
            _Phase.stalled => _stalled(theme),
          },
        ),
      ),
    );
  }

  Widget _waiting(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(key: Key('payment-waiting')),
        const SizedBox(height: 20),
        Text('Waiting for your payment', style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text('Pay for ${widget.args.eventTitle} on the page that opened. This screen updates by itself as soon as it goes through.', key: const Key('payment-explained'), textAlign: TextAlign.center),
        if (_hint != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(_hint!, key: const Key('payment-hint'), style: TextStyle(color: theme.colorScheme.error), textAlign: TextAlign.center)),
        const SizedBox(height: 24),
        FilledButton(key: const Key('payment-check'), onPressed: _checking ? null : _check, child: const Text('I have paid')),
        TextButton(key: const Key('payment-reopen'), onPressed: _again, child: const Text('Open the payment page again')),
        TextButton(key: const Key('payment-cancel'), onPressed: _back, child: const Text('Cancel')),
      ],
    );
  }

  Widget _paid(ThemeData theme) {
    final t = _ticket!;
    return SingleChildScrollView(
      child: Column(
        children: [
          const Icon(Icons.check_circle, size: 56, color: Colors.green, key: Key('payment-done')),
          const SizedBox(height: 12),
          Text('You are going!', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(t.eventTitle, key: const Key('paid-event'), style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
          if (t.startDate != null) Text(formatWhen(t.startDate!), key: const Key('paid-when')),
          if (t.venueName.isNotEmpty) Text(t.venueName),
          const SizedBox(height: 20),
          TicketQr(code: t.ticketCode),
          const SizedBox(height: 12),
          Text('${t.quantity} × ${t.tierName}', key: const Key('paid-line')),
          if (t.customerEmail.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6), child: Text('We also sent it to ${t.customerEmail}.', style: theme.textTheme.bodySmall)),
          const SizedBox(height: 20),
          FilledButton(key: const Key('view-tickets'), onPressed: _viewTickets, child: const Text('View my tickets')),
        ],
      ),
    );
  }

  Widget _failed(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 48, key: Key('payment-failed')),
        const SizedBox(height: 12),
        Text('That payment did not go through', style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
        const SizedBox(height: 6),
        const Text('You have not been charged for tickets. You can try again.', textAlign: TextAlign.center),
        const SizedBox(height: 20),
        FilledButton(key: const Key('payment-retry'), onPressed: _back, child: const Text('Back to the event')),
      ],
    );
  }

  Widget _stalled(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.hourglass_empty, size: 48),
        const SizedBox(height: 12),
        Text('We have not seen your payment yet', key: const Key('payment-stalled'), style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
        const SizedBox(height: 6),
        const Text('If you paid, your tickets will appear in My tickets within a minute or two, and we will email them. If you did not pay, you can try again.', textAlign: TextAlign.center),
        const SizedBox(height: 20),
        FilledButton(key: const Key('payment-check-again'), onPressed: () {
          setState(() => _phase = _Phase.waiting);
          _check();
        }, child: const Text('Check again')),
        TextButton(key: const Key('payment-my-tickets'), onPressed: _viewTickets, child: const Text('Go to My tickets')),
        TextButton(key: const Key('payment-back'), onPressed: _back, child: const Text('Back to the event')),
      ],
    );
  }
}
