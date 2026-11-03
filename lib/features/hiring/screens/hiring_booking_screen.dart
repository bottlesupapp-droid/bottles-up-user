import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/hiring.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/hiring_rules.dart';
import '../../../site/site_error.dart';
import '../../../site/when.dart';
import '../widgets/hiring_dialogs.dart';
import '../widgets/hiring_widgets.dart';

enum _Phase { viewing, waiting }

/// One booking of a professional, from either side: what is agreed, what is paid and what is still due, and the steps that are open (pay, cancel, mark done, confirm, dispute).
/// The screen says a payment is in only when the website says so. What may be done is the website's to decide; a button shown here can still be refused, and the refusal is shown as it came.
class HiringBookingScreen extends ConsumerStatefulWidget {
  const HiringBookingScreen({super.key, required this.bookingId, this.interval = const Duration(seconds: 3), this.giveUpAfter = const Duration(minutes: 5), this.onBack});

  final String bookingId;
  final Duration interval;
  final Duration giveUpAfter;

  /// Where "Back" goes. The app goes back; tests give their own.
  final void Function(BuildContext context)? onBack;

  @override
  ConsumerState<HiringBookingScreen> createState() => _HiringBookingScreenState();
}

class _HiringBookingScreenState extends ConsumerState<HiringBookingScreen> with WidgetsBindingObserver {
  _Phase _phase = _Phase.viewing;
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

  void _back() => (widget.onBack ?? (c) => c.canPop() ? c.pop() : c.go('/me/hiring'))(context);

  void _say(String text) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));

  void _refresh([ProBooking? b]) {
    ref.invalidate(proBookingProvider(widget.bookingId));
    ref.invalidate(myProRequestsProvider);
    if (b != null) {
      ref.invalidate(proRequestProvider(b.requestId));
      final actor = b.provider?.id;
      if (actor != null) ref.invalidate(proRequestsForProvider(actor));
    }
  }

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
      final state = await ref.read(hiringServiceProvider).paymentStatus(widget.bookingId);
      if (!mounted) return;
      switch (state.status) {
        case ProPayment.paid:
          _timer?.cancel();
          _refresh(state.booking);
          setState(() => _phase = _Phase.viewing);
          _say('Your payment is in.');
        case ProPayment.none:
          _timer?.cancel();
          _refresh(state.booking);
          setState(() {
            _phase = _Phase.viewing;
            _problem = 'No payment is open for this booking any more.';
          });
        case ProPayment.pending:
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
      final start = await ref.read(hiringServiceProvider).startPayment(widget.bookingId);
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
        _refresh();
      }
    }
  }

  Future<void> _run(ProBooking b, Future<String?> Function() action) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _problem = null;
    });
    try {
      final done = await action();
      if (done != null && mounted) _say(done);
      _refresh(b);
    } on SiteException catch (e) {
      if (mounted) setState(() => _problem = e.message);
      _refresh(b);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _cancel(ProBooking b) async {
    final why = await showTextDialog(
      context,
      title: 'Cancel this booking?',
      intro: cancelPolicyText(b, asProvider: b.isProviderView, today: clock.now()),
      introKey: const Key('cancel-policy'),
      label: 'Why? (optional)',
      confirmText: 'Cancel it',
      keepText: 'Keep the booking',
      fieldKey: const Key('cancel-reason'),
      confirmKey: const Key('cancel-confirm'),
      keepKey: const Key('cancel-keep'),
    );
    if (why == null || !mounted) return;
    await _run(b, () async {
      final r = await ref.read(hiringServiceProvider).cancel(booking: b.id, reason: why);
      return r.failed > 0 ? 'The booking is cancelled. A payment could not be paid back yet: it is tried again automatically.' : (r.refunded > 0 ? 'The booking is cancelled and the money is on its way back to the card.' : 'The booking is cancelled.');
    });
  }

  Future<void> _dispute(ProBooking b) async {
    final text = await showTextDialog(
      context,
      title: 'Something went wrong',
      intro: 'BottlesUp keeps the payment while it looks into this and decides who gets what.',
      label: 'What went wrong?',
      confirmText: 'Open a dispute',
      keepText: 'Not now',
      fieldKey: const Key('dispute-reason'),
      confirmKey: const Key('dispute-send'),
      keepKey: const Key('dispute-keep'),
      maxLength: maxReasonLength,
      minLines: 3,
      maxLines: 6,
      check: checkReason,
    );
    if (text == null || !mounted) return;
    await _run(b, () async {
      await ref.read(hiringServiceProvider).openDispute(booking: b.id, reason: text);
      return 'Your dispute is open. BottlesUp will look at it.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final booking = ref.watch(proBookingProvider(widget.bookingId));
    return PopScope(
      canPop: _phase != _Phase.waiting,
      child: Scaffold(
        appBar: AppBar(title: const Text('Booking')),
        body: booking.when(
          skipLoadingOnRefresh: true,
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('this booking'), onRetry: () => ref.invalidate(proBookingProvider(widget.bookingId))),
          data: (b) => _phase == _Phase.waiting ? _waiting(b) : _details(b),
        ),
      ),
    );
  }

  Widget _details(ProBooking b) {
    final theme = Theme.of(context);
    final provider = b.isProviderView;
    final who = provider ? (b.customer?.name ?? 'A customer') : (b.provider?.displayName ?? 'A professional');
    final today = clock.now();
    final state = b.state;
    final dueNow = state == BookingState.awaitingDeposit ? (b.depositCents >= b.totalCents ? b.totalCents : b.depositCents) : b.owedCents;
    final canPay = !provider && (state == BookingState.awaitingDeposit || (state == BookingState.confirmed && b.owedCents > 0));
    final canCancel = !state.isClosed && state != BookingState.disputed && (state == BookingState.awaitingDeposit || !jobDayHasCome(b, today));
    final canMarkDone = provider && state == BookingState.paid && jobDayHasCome(b, today);
    final canConfirm = !provider && state == BookingState.done;
    final canOpenDispute = !provider && (state == BookingState.confirmed || state == BookingState.paid || state == BookingState.done) && canDispute(b, today);
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(proBookingProvider(widget.bookingId));
        await ref.read(proBookingProvider(widget.bookingId).future).catchError((_) => b);
      },
      child: ListView(key: const Key('booking-details'), physics: const AlwaysScrollableScrollPhysics(), padding: const EdgeInsets.fromLTRB(16, 16, 16, 40), children: [
        Text(b.title, key: const Key('booking-title'), style: theme.textTheme.titleLarge),
        Text(provider ? 'For $who' : 'With $who', key: const Key('booking-who')),
        const SizedBox(height: 8),
        Chip(key: const Key('booking-state'), label: Text(state.label), visualDensity: VisualDensity.compact),
        const SizedBox(height: 12),
        InfoLine('Day', dayText(b.eventDate)),
        InfoLine('Total', cents(b.totalCents, currency: b.currency), bold: true),
        InfoLine('Deposit', cents(b.depositCents, currency: b.currency)),
        if (b.totalCents > b.depositCents && b.balanceDueBy != null) InfoLine('Balance due by', dayText(b.balanceDueBy!)),
        InfoLine('Paid so far', cents(b.paidCents, currency: b.currency)),
        if (b.owedCents > 0 && !state.isClosed) InfoLine('Still to pay', cents(b.owedCents, currency: b.currency)),
        if (provider && b.netCents != null) ...[
          const Divider(height: 24),
          InfoLine('You will be paid', cents(b.netCents!, currency: b.currency), bold: true),
          if (b.commissionBps != null) InfoLine('BottlesUp keeps', '${(b.commissionBps! / 100).toStringAsFixed(b.commissionBps! % 100 == 0 ? 0 : 1)}%'),
          const SizedBox(height: 4),
          Text('You are paid after the customer confirms the job, or by itself a few days after you mark it done.', style: theme.textTheme.bodySmall),
        ],
        const SizedBox(height: 12),
        _status(b),
        if (b.dispute != null) ...[
          const Divider(height: 24),
          Text('Dispute', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(b.dispute!.reason, key: const Key('dispute-text')),
          const SizedBox(height: 4),
          Text(b.dispute!.open ? 'BottlesUp is looking at it.' : b.dispute!.outcomeText, key: const Key('dispute-outcome'), style: theme.textTheme.bodySmall),
        ],
        if (_problem != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(_problem!, key: const Key('booking-problem'), style: TextStyle(color: theme.colorScheme.error))),
        const SizedBox(height: 16),
        if (canPay) FilledButton(key: const Key('booking-pay'), onPressed: _busy ? null : _pay, child: Text(_busy ? 'Working...' : (state == BookingState.awaitingDeposit ? (b.depositCents >= b.totalCents ? 'Pay ${cents(dueNow, currency: b.currency)}' : 'Pay the deposit of ${cents(dueNow, currency: b.currency)}') : 'Pay the balance of ${cents(dueNow, currency: b.currency)}'))),
        if (canMarkDone) FilledButton(key: const Key('booking-done'), onPressed: _busy ? null : () => _run(b, () async {
              await ref.read(hiringServiceProvider).markDone(actor: b.provider!.id, booking: b.id);
              return 'Marked as done. The customer is asked to confirm.';
            }), child: const Text('Mark the job as done')),
        if (canConfirm) FilledButton(key: const Key('booking-confirm'), onPressed: _busy ? null : () => _run(b, () async {
              await ref.read(hiringServiceProvider).confirm(b.id);
              return 'Thank you. The professional will be paid.';
            }), child: const Text('Confirm the job went well')),
        if (canOpenDispute) OutlinedButton(key: const Key('booking-dispute'), onPressed: _busy ? null : () => _dispute(b), child: const Text('Something went wrong')),
        if (canCancel) TextButton(key: const Key('booking-cancel'), onPressed: _busy ? null : () => _cancel(b), child: const Text('Cancel the booking')),
        TextButton(key: const Key('booking-request'), onPressed: () => context.push('/hiring/${b.requestId}'), child: const Text('See the request and quote')),
        if (!provider && b.provider != null) TextButton(key: const Key('booking-profile'), onPressed: () => context.push('/u/${b.provider!.handle}'), child: Text('View ${b.provider!.displayName}')),
        TextButton(key: const Key('booking-back'), onPressed: _back, child: const Text('Back')),
      ]),
    );
  }

  /// One sentence on what happens next.
  Widget _status(ProBooking b) {
    final provider = b.isProviderView;
    final text = switch (b.state) {
      BookingState.awaitingDeposit => provider ? 'Waiting for the customer to pay the deposit${b.payBy == null ? '' : ' by ${formatWhen(b.payBy!)}'}. The date is not kept for anyone else until they do.' : 'Pay the deposit${b.payBy == null ? '' : ' by ${formatWhen(b.payBy!)}'} to keep the date. BottlesUp holds your money until the job is done.',
      BookingState.expired => 'The deposit was not paid in time, so this booking is closed.',
      BookingState.confirmed => provider ? 'The deposit is paid. The customer pays the balance${b.balanceDueBy == null ? '' : ' by ${dayText(b.balanceDueBy!)}'}.' : 'The date is yours. Pay the balance${b.balanceDueBy == null ? '' : ' by ${dayText(b.balanceDueBy!)}'}, or the booking is cancelled.',
      BookingState.paid => provider ? 'Paid in full. On the day of the job, mark it done.' : 'Paid in full. After the job, confirm it went well, or tell us if it did not.',
      BookingState.done => provider ? 'Marked as done${b.providerDoneAt == null ? '' : ' on ${formatWhen(b.providerDoneAt!)}'}. Waiting for the customer to confirm: if they do not, it completes by itself.' : 'The professional says the job is done. Confirm it went well, or tell us if it did not.',
      BookingState.completed => provider ? 'Completed${b.completedAt == null ? '' : ' on ${formatWhen(b.completedAt!)}'}. Your payment is on its way to you.' : 'Completed. Thank you.',
      BookingState.disputed => 'BottlesUp holds the payment and will decide.',
      BookingState.cancelled => '${b.cancelledBy == 'provider' ? (provider ? 'You' : 'The professional') : (b.cancelledBy == 'client' ? (provider ? 'The customer' : 'You') : 'The booking')} cancelled this.${b.cancelReason == null ? '' : ' "${b.cancelReason}"'}',
    };
    return Text(text, key: const Key('booking-status-text'));
  }

  Widget _waiting(ProBooking b) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!_stalled) const CircularProgressIndicator(key: Key('booking-waiting')) else const Icon(Icons.hourglass_empty, size: 48, key: Key('booking-stalled')),
          const SizedBox(height: 20),
          Text(_stalled ? 'We have not seen your payment yet' : 'Waiting for your payment', style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(
            _stalled ? 'If you paid, it will show as paid within a minute or two. If you did not pay, you can open the page again.' : 'Pay on the page that opened. This screen updates by itself as soon as it goes through.',
            key: const Key('booking-wait-text'),
            textAlign: TextAlign.center,
          ),
          if (_hint != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(_hint!, key: const Key('booking-hint'), style: TextStyle(color: theme.colorScheme.error), textAlign: TextAlign.center)),
          const SizedBox(height: 24),
          FilledButton(key: const Key('booking-check'), onPressed: _checking ? null : () {
            setState(() => _stalled = false);
            _check();
          }, child: Text(_stalled ? 'Check again' : 'I have paid')),
          if (_payUrl != null) TextButton(key: const Key('booking-reopen'), onPressed: () => ref.read(urlOpenerProvider)(_payUrl!, inApp: true), child: const Text('Open the payment page again')),
          TextButton(key: const Key('booking-leave'), onPressed: () {
            _timer?.cancel();
            setState(() => _phase = _Phase.viewing);
          }, child: const Text('Back to the booking')),
        ],
      ),
    );
  }
}
