import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/hiring.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/site_error.dart';
import '../../../site/when.dart';
import '../widgets/hiring_dialogs.dart';
import '../widgets/hiring_widgets.dart';
import '../widgets/quote_sheet.dart';

/// One request to hire a professional, from either side. The customer reads the quote and accepts or turns it down; the professional sends, changes or withdraws a quote, or declines.
/// What each may do is the website's to say: the buttons shown here are the ones that can work, and a refusal is shown as the website said it.
class HiringRequestScreen extends ConsumerStatefulWidget {
  const HiringRequestScreen({super.key, required this.requestId});

  final String requestId;

  @override
  ConsumerState<HiringRequestScreen> createState() => _HiringRequestScreenState();
}

class _HiringRequestScreenState extends ConsumerState<HiringRequestScreen> {
  bool _busy = false;

  void _say(String text) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));

  void _refresh(ProRequest r) {
    ref.invalidate(proRequestProvider(widget.requestId));
    ref.invalidate(myProRequestsProvider);
    final actor = r.provider?.id;
    if (actor != null) ref.invalidate(proRequestsForProvider(actor));
  }

  Future<void> _act(ProRequest r, Future<Object?> Function() action, {String? done}) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final result = await action();
      if (done != null && mounted) _say(done);
      _refresh(r);
      if (result is ProBooking && mounted) context.pushReplacement('/hiring/bookings/${result.id}');
    } on SiteException catch (e) {
      if (mounted) _say(e.message);
      _refresh(r);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _accept(ProRequest r) async {
    final q = r.quote!;
    final yes = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Accept this quote?'),
        content: Text(
          'You will have 24 hours to pay the deposit of ${cents(q.depositCents)}${q.balanceCents > 0 ? ', then ${cents(q.balanceCents)} by ${dayText(q.balanceDueBy!)}' : ''}. '
          'BottlesUp holds your money until the job is done. ${q.balanceCents > 0 ? 'If you cancel less than 7 days before, the deposit is not paid back.' : ''}',
        ),
        actions: [
          TextButton(key: const Key('accept-keep'), onPressed: () => Navigator.pop(c, false), child: const Text('Not yet')),
          FilledButton(key: const Key('accept-confirm'), onPressed: () => Navigator.pop(c, true), child: const Text('Accept')),
        ],
      ),
    );
    if (yes != true || !mounted) return;
    await _act(r, () => ref.read(hiringServiceProvider).acceptQuote(r.id));
  }

  Future<void> _decline(ProRequest r) async {
    final note = await showTextDialog(
      context,
      title: 'Decline this request?',
      label: 'A note for the customer (optional)',
      confirmText: 'Decline',
      keepText: 'Keep it',
      fieldKey: const Key('decline-note'),
      confirmKey: const Key('decline-confirm'),
      keepKey: const Key('decline-keep'),
    );
    if (note == null || !mounted) return;
    await _act(r, () => ref.read(hiringServiceProvider).declineRequest(actor: r.provider!.id, request: r.id, note: note), done: 'The request is declined.');
  }

  Future<void> _quote(ProRequest r) async {
    final updated = await showQuoteSheet(context, request: r);
    if (updated == null || !mounted) return;
    _refresh(r);
    _say('Your quote was sent.');
  }

  @override
  Widget build(BuildContext context) {
    final request = ref.watch(proRequestProvider(widget.requestId));
    return Scaffold(
      appBar: AppBar(title: const Text('Request')),
      body: request.when(
        skipLoadingOnRefresh: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('this request'), onRetry: () => ref.invalidate(proRequestProvider(widget.requestId))),
        data: _body,
      ),
    );
  }

  Widget _body(ProRequest r) {
    final theme = Theme.of(context);
    final provider = r.isProviderView;
    final q = r.quote;
    final booking = r.booking;
    final who = provider ? (r.customer?.name ?? 'A customer') : (r.provider?.displayName ?? 'A professional');
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(proRequestProvider(widget.requestId));
        await ref.read(proRequestProvider(widget.requestId).future).catchError((_) => r);
      },
      child: ListView(key: const Key('request-detail'), physics: const AlwaysScrollableScrollPhysics(), padding: const EdgeInsets.fromLTRB(16, 16, 16, 40), children: [
        Text(provider ? 'Request from $who' : 'Your request to $who', key: const Key('request-title'), style: theme.textTheme.titleLarge),
        const SizedBox(height: 6),
        RequestChip(request: r),
        const SizedBox(height: 12),
        InfoLine('Day', dayText(r.eventDate)),
        if (r.serviceTitle != null) InfoLine('Service', r.serviceTitle!),
        if (r.timeNote != null) InfoLine('Time', r.timeNote!),
        if (r.location != null) InfoLine('Place', r.location!),
        if (r.guests != null) InfoLine('Guests', '${r.guests}'),
        if (r.budgetCents != null) InfoLine('Budget', cents(r.budgetCents!)),
        const SizedBox(height: 8),
        Text(r.message, key: const Key('request-message-text')),
        if (r.declineNote != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text('Note: ${r.declineNote}', key: const Key('request-decline-note'), style: theme.textTheme.bodySmall)),
        if (q != null) ...[
          const Divider(height: 28),
          Text(q.status == QuoteStatus.accepted ? 'The accepted quote' : 'The quote', style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          InfoLine('Total', cents(q.totalCents), bold: true),
          InfoLine('Deposit', cents(q.depositCents)),
          if (q.balanceCents > 0) InfoLine('Balance', '${cents(q.balanceCents)} by ${dayText(q.balanceDueBy!)}'),
          const SizedBox(height: 4),
          Text(q.scope, key: const Key('quote-scope-text')),
          const SizedBox(height: 4),
          Text(
            q.status == QuoteStatus.expired ? 'This quote has expired.' : (q.isOpen ? 'Open until ${formatWhen(q.validUntil)}.' : ''),
            key: const Key('quote-validity'),
            style: theme.textTheme.bodySmall,
          ),
        ],
        const SizedBox(height: 16),
        if (booking != null) FilledButton(key: const Key('request-open-booking'), onPressed: () => context.push('/hiring/bookings/${booking.id}'), child: const Text('Open the booking')),
        if (!provider && r.hasOpenQuote) ...[
          FilledButton(key: const Key('request-accept'), onPressed: _busy ? null : () => _accept(r), child: const Text('Accept this quote')),
          TextButton(key: const Key('request-decline-quote'), onPressed: _busy ? null : () => _act(r, () => ref.read(hiringServiceProvider).declineQuote(r.id), done: 'You turned the quote down.'), child: const Text('Turn it down')),
        ],
        if (!provider && r.status.isOpen) TextButton(key: const Key('request-withdraw'), onPressed: _busy ? null : () => _act(r, () => ref.read(hiringServiceProvider).withdrawRequest(r.id), done: 'Your request was withdrawn.'), child: const Text('Withdraw my request')),
        if (provider && r.status.isOpen) ...[
          FilledButton(key: const Key('request-quote'), onPressed: _busy ? null : () => _quote(r), child: Text(r.status == RequestStatus.quoted ? 'Change the quote' : 'Send a quote')),
          if (r.status == RequestStatus.quoted) TextButton(key: const Key('request-withdraw-quote'), onPressed: _busy ? null : () => _act(r, () => ref.read(hiringServiceProvider).withdrawQuote(actor: r.provider!.id, request: r.id), done: 'The quote was withdrawn.'), child: const Text('Withdraw the quote')),
          TextButton(key: const Key('request-decline'), onPressed: _busy ? null : () => _decline(r), child: const Text('Decline')),
        ],
        if (!provider && r.provider != null) TextButton(key: const Key('request-view-profile'), onPressed: () => context.push('/u/${r.provider!.handle}'), child: Text('View ${r.provider!.displayName}')),
        const SizedBox(height: 4),
        Text('Created ${formatWhen(r.createdAt)}. Today is ${formatDay(clock.now())}.', style: theme.textTheme.bodySmall),
      ]),
    );
  }
}
