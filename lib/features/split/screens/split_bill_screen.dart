import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/social_profile.dart';
import '../../../site/money.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/split_rules.dart';
import '../../../site/services/split_service.dart';
import '../../../site/site_error.dart';
import '../../../site/when.dart';
import '../../social/widgets/profile_widgets.dart';

/// Ask friends to pay their share of what is still owed at the club: choose who, equal or your own amounts, and until when. Nothing is charged to you; each friend pays their own share on
/// Stripe's page. The website checks it all again (it is your booking, the friends can be asked, the shares fit within what is left).
class SplitBillScreen extends ConsumerStatefulWidget {
  const SplitBillScreen({super.key, required this.bookingId, this.now});

  final String bookingId;

  /// The time the screen counts from. The phone's clock unless a test says otherwise.
  final DateTime? now;

  @override
  ConsumerState<SplitBillScreen> createState() => _SplitBillScreenState();
}

class _SplitBillScreenState extends ConsumerState<SplitBillScreen> {
  final _search = TextEditingController();
  Timer? _debounce;
  String _query = '';
  final List<SocialProfile> _chosen = [];
  final Map<String, TextEditingController> _amounts = {};
  bool _equal = true;
  String? _deadlineLabel;
  bool _busy = false;
  String? _problem;

  DateTime get _now => widget.now ?? clock.now();

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    for (final c in _amounts.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _typed(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) setState(() => _query = v.trim());
    });
  }

  void _toggle(SocialProfile p) {
    setState(() {
      _problem = null;
      if (_chosen.any((x) => x.id == p.id)) {
        _chosen.removeWhere((x) => x.id == p.id);
        _amounts.remove(p.id)?.dispose();
      } else if (_chosen.length < maxSplitFriends) {
        _chosen.add(p);
        _amounts[p.id] = TextEditingController();
      } else {
        _problem = 'A split can have up to $maxSplitFriends friends.';
      }
    });
  }

  /// What each chosen friend is asked for, in order; null for a custom amount that is not an amount yet.
  List<int?> _shares(int balance) {
    if (_equal) {
      final each = equalShares(balanceCents: balance, friends: _chosen.length);
      return [for (var i = 0; i < _chosen.length; i++) each.isEmpty ? null : each[i]];
    }
    return [for (final p in _chosen) parseAmountCents(_amounts[p.id]?.text ?? '')];
  }

  Future<void> _send(String bookingId, int balance, DateTime? arrival) async {
    if (_busy) return;
    // The choice is kept by its name, not its time: "In 2 hours" means two hours from the moment of sending.
    final picked = [for (final o in deadlineOptions(now: _now, arrival: arrival)) if (o.label == _deadlineLabel) o.at];
    final deadline = picked.isEmpty ? null : picked.first;
    final shares = _shares(balance);
    if (shares.any((s) => s == null)) return setState(() => _problem = 'Type an amount for every friend, like 25 or 25.50.');
    final amounts = [for (final s in shares) s!];
    final wrong = checkShares(amounts: amounts, balanceCents: balance);
    if (wrong != null) return setState(() => _problem = wrong);
    if (deadline == null) return setState(() => _problem = 'Choose when they have to pay by.');
    setState(() {
      _busy = true;
      _problem = null;
    });
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(splitServiceProvider).create(
            bookingId: bookingId,
            shares: [for (var i = 0; i < _chosen.length; i++) ShareAsk(payer: _chosen[i].id, amountCents: amounts[i])],
            deadline: deadline,
          );
      ref.invalidate(splitForBookingProvider(bookingId));
      ref.invalidate(tableBookingProvider(bookingId));
      messenger.showSnackBar(SnackBar(content: Text(_chosen.length == 1 ? 'Your request was sent to ${_chosen.first.displayName}.' : 'Your requests were sent to ${_chosen.length} friends.')));
      if (mounted && context.canPop()) context.pop();
    } on SiteException catch (e) {
      if (mounted) setState(() => _problem = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ActorGate(
      title: 'Split the bill',
      builder: (context, actor) {
        final booking = ref.watch(tableBookingProvider(widget.bookingId));
        return Scaffold(
          appBar: AppBar(title: const Text('Split the bill')),
          body: booking.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => LoadFailed(message: e is SiteException ? e.message : loadFailedMessage('this booking'), onRetry: () => ref.invalidate(tableBookingProvider(widget.bookingId))),
            data: (b) {
              if (b == null || !b.isPaid) {
                return const EmptyState(icon: Icons.table_restaurant_outlined, title: 'This booking cannot be split', text: 'Only a confirmed booking can be split.');
              }
              final balance = b.dueAtClubCents;
              if (b.isOver(_now) || balance < minShareCents) {
                return EmptyState(icon: Icons.table_restaurant_outlined, title: 'Nothing to split', text: b.isOver(_now) ? 'This booking has ended.' : 'The rest of this table is paid.');
              }
              return _form(actor, b.arrival, balance, b.currency, b.id);
            },
          ),
        );
      },
    );
  }

  Widget _form(SocialProfile actor, DateTime? arrival, int balance, String currency, String bookingId) {
    final theme = Theme.of(context);
    String money(int c) => formatMoney(c, currency: currency);
    final options = deadlineOptions(now: _now, arrival: arrival);
    final results = _query.length < 2 ? null : ref.watch(profileSearchProvider(SearchKey(actor: actor.id, query: _query)));
    final shares = _shares(balance);
    final sum = shares.fold<int>(0, (s, a) => s + (a ?? 0));
    final mine = balance - sum;
    return ListView(
      key: const Key('split-form'),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
      children: [
        Text('Still owed at the club: ${money(balance)}', key: const Key('split-form-balance'), style: theme.textTheme.titleMedium),
        const SizedBox(height: 4),
        Text('Choose the friends who will pay a share. You pay the rest at the club.', style: theme.textTheme.bodySmall),
        const SizedBox(height: 12),
        TextField(key: const Key('split-person-search'), controller: _search, onChanged: _typed, decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search friends by name or username')),
        if (results == null)
          const Padding(padding: EdgeInsets.all(12), child: Text('Type at least 2 letters.'))
        else
          ...results.when(
            loading: () => const [Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator()))],
            error: (e, _) => [Padding(padding: const EdgeInsets.all(12), child: Text(e is SiteException ? e.message : loadFailedMessage('the results')))],
            data: (list) {
              final people = [for (final p in list) if (!p.isBusiness && !p.isMine) p];
              if (people.isEmpty) return const [Padding(padding: EdgeInsets.all(12), child: Text('No one found.', key: Key('split-no-people')))];
              return [
                for (final p in people)
                  CheckboxListTile(
                    key: Key('split-pick-${p.handle}'),
                    value: _chosen.any((x) => x.id == p.id),
                    onChanged: (_) => _toggle(p),
                    secondary: ProfileAvatar(profile: p),
                    title: Text(p.displayName),
                    subtitle: Text('@${p.handle}'),
                  ),
              ];
            },
          ),
        if (_chosen.isNotEmpty) ...[
          const Divider(height: 28),
          SegmentedButton<bool>(
            key: const Key('split-mode'),
            segments: const [ButtonSegment(value: true, label: Text('Equal')), ButtonSegment(value: false, label: Text('My own amounts'))],
            selected: {_equal},
            onSelectionChanged: (s) => setState(() {
              _equal = s.first;
              _problem = null;
            }),
          ),
          const SizedBox(height: 10),
          for (var i = 0; i < _chosen.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(children: [
                Expanded(child: Text(_chosen[i].displayName, key: Key('split-chosen-${_chosen[i].handle}'))),
                if (_equal)
                  Text(shares[i] == null ? '' : money(shares[i]!), key: Key('split-amount-${_chosen[i].handle}'))
                else
                  SizedBox(
                    width: 110,
                    child: TextField(
                      key: Key('split-amount-input-${_chosen[i].handle}'),
                      controller: _amounts[_chosen[i].id],
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (_) => setState(() => _problem = null),
                      decoration: const InputDecoration(prefixText: '\$ ', hintText: '0.00', isDense: true),
                    ),
                  ),
                IconButton(key: Key('split-remove-${_chosen[i].handle}'), tooltip: 'Remove', icon: const Icon(Icons.close), onPressed: () => _toggle(_chosen[i])),
              ]),
            ),
          const SizedBox(height: 8),
          Text('You still pay ${money(mine < 0 ? 0 : mine)} at the club.', key: const Key('split-mine'), style: theme.textTheme.titleSmall),
          const SizedBox(height: 16),
          Text('They have to pay by', style: theme.textTheme.titleSmall),
          const SizedBox(height: 6),
          if (options.isEmpty)
            const Text('It is too late to set a deadline for this booking.', key: Key('split-no-deadline'))
          else
            Wrap(spacing: 8, children: [
              for (final o in options)
                ChoiceChip(key: Key('split-deadline-${o.label}'), label: Text('${o.label} · ${formatWhen(o.at)}'), selected: _deadlineLabel == o.label, onSelected: (_) => setState(() {
                      _deadlineLabel = o.label;
                      _problem = null;
                    })),
            ]),
          const SizedBox(height: 8),
          Text('A friend who has not paid by then simply lapses: you pay the rest at the club. If you cancel, or the venue cancels the booking, anyone who paid is paid back in full.', style: theme.textTheme.bodySmall),
        ],
        if (_problem != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(_problem!, key: const Key('split-problem'), style: TextStyle(color: theme.colorScheme.error))),
        const SizedBox(height: 16),
        FilledButton(key: const Key('split-send'), onPressed: _busy ? null : () => _send(bookingId, balance, arrival), child: Text(_busy ? 'Sending...' : 'Send requests')),
      ],
    );
  }
}
