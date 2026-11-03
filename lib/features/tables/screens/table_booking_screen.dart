import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/checkout.dart';
import '../../../site/models/venue.dart';
import '../../../site/money.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/read.dart';
import '../../../site/rules/table_rules.dart';
import '../../../site/site_error.dart';
import '../../tickets_site/screens/ticket_purchase_screen.dart' show PaymentWaitArgs;
import '../widgets/bottle_widgets.dart';

enum _Step { table, bottles, review }

/// Booking one table: your table (guests, hours, who it is for), bottles (optional), then review and pay. The date and time were chosen on the venue page and arrive in the address.
/// Nothing is decided here: the website works out the price, the tax, the promo code and whether the table is still free when the booking is made, holds the table for ten minutes
/// and takes the payment on Stripe's page.
class TableBookingScreen extends ConsumerStatefulWidget {
  const TableBookingScreen({super.key, required this.venueId, required this.tableId, required this.dateKey, required this.slotId, this.onStarted, DateTime? now}) : _now = now;

  final String venueId;
  final String tableId;

  /// The night picked, "yyyy-MM-dd".
  final String? dateKey;
  final String? slotId;

  /// Where to go once the payment page is opened. The app shows the waiting screen; tests give their own.
  final void Function(BuildContext context, PaymentWaitArgs args)? onStarted;
  final DateTime? _now;

  @override
  ConsumerState<TableBookingScreen> createState() => _TableBookingScreenState();
}

class _TableBookingScreenState extends ConsumerState<TableBookingScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _promo = TextEditingController();
  _Step _step = _Step.table;
  int _guests = 2;
  int _hours = 1;
  bool _filled = false;
  final Map<String, int> _cart = {};
  BottlePaymentChoice _choice = BottlePaymentChoice.payAhead;
  PromoCheck? _promoCheck;
  String _appliedCode = '';
  bool _applyingPromo = false;
  bool _busy = false;
  String? _problem;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _promo.dispose();
    super.dispose();
  }

  DateTime get _today => widget._now ?? DateTime.now();

  TableType? _table(Venue v) {
    for (final t in v.tables) {
      if (t.id == widget.tableId) return t;
    }
    return null;
  }

  TimeSlot? _slot(Venue v) {
    for (final s in v.slots) {
      if (s.id == widget.slotId) return s;
    }
    return null;
  }

  void _go(_Step step) => setState(() {
        _step = step;
        _problem = null;
        // The discount depends on what the order comes to, so it is asked for again on the last step.
        if (step != _Step.review) {
          _promoCheck = null;
          _appliedCode = '';
        }
      });

  int _bottleSubtotal(List<Bottle> bottles) {
    var sum = 0;
    for (final b in bottles) {
      sum += b.priceCents * (_cart[b.id] ?? 0);
    }
    return sum;
  }

  TableQuote _quote(Venue v, TableType t, List<Bottle> bottles, int? feeBps) {
    final subtotal = _bottleSubtotal(bottles);
    return quoteTable(
      tableCents: tableAmountCents(t, _hours),
      bottleSubtotalCents: subtotal,
      choice: subtotal == 0 ? BottlePaymentChoice.payAhead : effectiveChoice(v.bottlePaymentMode, _choice),
      depositIsCredit: v.depositIsCredit,
      taxRateBps: v.taxRateBps,
      feeBps: feeBps,
      discountCents: _promoCheck?.valid == true ? _promoCheck!.discountCents : 0,
    );
  }

  String? _checkDetails(Venue v, TableType t, DateTime? night, TimeSlot? slot, Account account) => validateTableBooking(
        venue: v,
        table: t,
        night: night,
        slot: slot,
        guests: _guests,
        hours: _hours,
        name: _name.text,
        email: account.email,
        phone: _phone.text,
        today: _today,
      );

  Future<void> _applyPromo(Venue v, TableQuote quote) async {
    final code = _promo.text.trim();
    if (code.isEmpty || _applyingPromo) return;
    setState(() => _applyingPromo = true);
    try {
      final r = await ref.read(ticketCheckoutServiceProvider).checkPromo(code: code, subtotalCents: quote.beforeTaxCents, venueId: v.id, appliesTo: 'tables');
      if (mounted) {
        setState(() {
          _promoCheck = r;
          _appliedCode = r.valid ? code.toUpperCase() : '';
          _applyingPromo = false;
        });
      }
    } on SiteException catch (e) {
      if (mounted) {
        setState(() {
          _promoCheck = PromoCheck(valid: false, message: e.message);
          _appliedCode = '';
          _applyingPromo = false;
        });
      }
    }
  }

  Future<void> _pay(Venue v, TableType t, DateTime night, TimeSlot slot, Account account, List<Bottle> bottles) async {
    if (_busy) return;
    final problem = _checkDetails(v, t, night, slot, account);
    setState(() => _problem = problem);
    if (problem != null) {
      setState(() => _step = _Step.table);
      return;
    }
    setState(() => _busy = true);
    final startedAt = DateTime.now().subtract(const Duration(seconds: 5));
    try {
      final subtotal = _bottleSubtotal(bottles);
      final start = await ref.read(tableCheckoutServiceProvider).start(
            venueId: v.id,
            tableId: t.id,
            slotId: slot.id,
            night: dayKey(night),
            guests: _guests,
            hours: t.isHourly ? _hours : null,
            name: _name.text,
            email: account.email,
            phone: _phone.text,
            bottles: {for (final b in bottles) if ((_cart[b.id] ?? 0) > 0) b.id: _cart[b.id]!},
            promoCode: _promoCheck?.valid == true ? _appliedCode : null,
            bottlePayment: subtotal == 0 ? BottlePaymentChoice.payAhead : effectiveChoice(v.bottlePaymentMode, _choice),
          );
      final opened = await ref.read(urlOpenerProvider)(start.url, inApp: true);
      if (!mounted) return;
      setState(() => _busy = false);
      if (!opened) {
        setState(() => _problem = 'We could not open the payment page. Check that your phone can open web pages, then try again.');
        return;
      }
      final args = PaymentWaitArgs.table(venueId: v.id, venueName: v.name, start: start, startedAt: startedAt);
      (widget.onStarted ?? (c, a) => c.pushReplacement('/payment', extra: a))(context, args);
    } on SiteException catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _problem = e.message;
        });
        // What is free may have changed: read it again.
        ref.invalidate(unavailableTablesProvider);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final venue = ref.watch(venueProvider(widget.venueId));
    final account = ref.watch(accountProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Book a table')),
      body: venue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => LoadFailed(message: error is SiteException ? error.message : loadFailedMessage('this venue'), onRetry: () => ref.invalidate(venueProvider(widget.venueId))),
        data: (v) {
          final table = v == null ? null : _table(v);
          if (v == null || table == null) {
            return const EmptyState(icon: Icons.table_restaurant_outlined, title: 'This table is no longer available', text: 'Go back to the venue to see what is free.');
          }
          final night = readDay(widget.dateKey);
          final slot = _slot(v);
          if (night == null || slot == null || slot.dayOfWeek != weekdayIndex(night)) {
            return const EmptyState(icon: Icons.event_busy_outlined, title: 'Choose a date and time first', text: 'Go back to the venue and pick when you are coming.');
          }
          if (account.isLoading) return const Center(child: CircularProgressIndicator());
          final acc = account.valueOrNull;
          if (acc == null) {
            return const EmptyState(icon: Icons.lock_outline, title: 'Sign in to book a table', text: 'Your confirmation is sent to the email of your account.');
          }
          if (!_filled) {
            _filled = true;
            _name.text = acc.name;
            _phone.text = acc.phone;
            _guests = defaultGuests(table);
            _hours = table.minimumHours;
            _choice = v.bottlePaymentMode == BottlePaymentMode.payAtClub ? BottlePaymentChoice.payAtClub : BottlePaymentChoice.payAhead;
          }
          return switch (_step) {
            _Step.table => _tableStep(v, table, night, slot, acc),
            _Step.bottles => _bottlesStep(v, table, night, slot, acc),
            _Step.review => _reviewStep(v, table, night, slot, acc),
          };
        },
      ),
    );
  }

  Widget _steps(ThemeData theme) {
    Widget label(String text, bool on, String key) => Text(text, key: Key(key), style: TextStyle(fontWeight: on ? FontWeight.w700 : FontWeight.w400, color: on ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant, fontSize: 12));
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          label('1. Table', _step == _Step.table, 'step-table'),
          const Text('  ›  '),
          label('2. Bottles', _step == _Step.bottles, 'step-bottles'),
          const Text('  ›  '),
          label('3. Review & pay', _step == _Step.review, 'step-review'),
        ],
      ),
    );
  }

  Widget _stepper(String keyBase, String label, int value, int min, int max, void Function(int) set) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        IconButton(key: Key('$keyBase-minus'), onPressed: value <= min || _busy ? null : () => set(value - 1), icon: const Icon(Icons.remove_circle_outline)),
        Text('$value', key: Key(keyBase), style: Theme.of(context).textTheme.titleLarge),
        IconButton(key: Key('$keyBase-plus'), onPressed: value >= max || _busy ? null : () => set(value + 1), icon: const Icon(Icons.add_circle_outline)),
      ],
    );
  }

  Widget _summary(Venue v, TableType t, DateTime night, TimeSlot slot) {
    final theme = Theme.of(context);
    final arrival = arrivalDate(night, slot);
    final note = arrivalNote(night, slot);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.name, key: const Key('booking-table'), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            Text(v.name, key: const Key('booking-venue')),
            const SizedBox(height: 6),
            Text('${DateFormat('EEE, MMM d').format(arrival)} · ${slotLabel(slot)}', key: const Key('booking-when'), style: TextStyle(color: theme.colorScheme.primary)),
            if (note != null) Padding(padding: const EdgeInsets.only(top: 4), child: Text(note, key: const Key('booking-arrival-note'), style: theme.textTheme.bodySmall)),
            const SizedBox(height: 4),
            Text('Up to ${t.maxGuests} guests · ${tablePriceLabel(t)}', style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  Widget _tableStep(Venue v, TableType t, DateTime night, TimeSlot slot, Account acc) {
    final theme = Theme.of(context);
    return ListView(
      key: const Key('booking-table-step'),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
      children: [
        _steps(theme),
        _summary(v, t, night, slot),
        const SizedBox(height: 12),
        _stepper('guests', 'Guests', _guests, 1, t.maxGuests, (n) => setState(() {
              _guests = n;
              _problem = null;
            })),
        if (t.isHourly) _stepper('hours', 'Hours (at least ${t.minimumHours})', _hours, t.minimumHours, maxHoursFor(t), (n) => setState(() {
              _hours = n;
              _problem = null;
            })),
        const SizedBox(height: 8),
        TextField(key: const Key('buyer-name'), controller: _name, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        InputDecorator(decoration: const InputDecoration(labelText: 'Send the confirmation to', border: OutlineInputBorder()), child: Text(acc.email, key: const Key('buyer-email'))),
        const SizedBox(height: 12),
        TextField(key: const Key('buyer-phone'), controller: _phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone (optional)', border: OutlineInputBorder())),
        const Divider(height: 28),
        Row(children: [
          Expanded(child: Text(t.isHourly ? 'Table total ($_hours hr)' : 'Deposit', style: theme.textTheme.titleSmall)),
          Text(formatMoney(tableAmountCents(t, _hours), currency: t.currency), key: const Key('table-amount'), style: theme.textTheme.titleMedium),
        ]),
        if (_problem != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(_problem!, key: const Key('booking-problem'), style: TextStyle(color: theme.colorScheme.error))),
        const SizedBox(height: 16),
        FilledButton(
          key: const Key('to-bottles'),
          onPressed: () {
            final problem = _checkDetails(v, t, night, slot, acc);
            if (problem != null) {
              setState(() => _problem = problem);
              return;
            }
            _go(_Step.bottles);
          },
          child: const Text('Continue'),
        ),
      ],
    );
  }

  Widget _bottlesStep(Venue v, TableType t, DateTime night, TimeSlot slot, Account acc) {
    final theme = Theme.of(context);
    final bottles = ref.watch(venueBottlesProvider(v.id));
    return ListView(
      key: const Key('booking-bottles-step'),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
      children: [
        _steps(theme),
        Text('Pre-order bottles for your table (optional)', style: theme.textTheme.titleMedium),
        const SizedBox(height: 10),
        bottles.when(
          loading: () => const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator())),
          error: (error, _) => LoadFailed(message: error is SiteException ? error.message : loadFailedMessage('the bottle menu'), onRetry: () => ref.invalidate(venueBottlesProvider(v.id))),
          data: (list) {
            if (list.isEmpty) return const Padding(padding: EdgeInsets.symmetric(vertical: 24), child: Center(child: Text('No bottle menu available for this venue yet.', key: Key('no-bottles'))));
            final subtotal = _bottleSubtotal(list);
            return Column(
              children: [
                for (final b in list) BottleTile(bottle: b, showImage: v.showBottleImages, quantity: _cart[b.id] ?? 0, onChanged: (n) => setState(() => n <= 0 ? _cart.remove(b.id) : _cart[b.id] = n)),
                if (subtotal > 0) ...[
                  const Divider(height: 24),
                  Row(children: [Expanded(child: Text('Bottles', style: theme.textTheme.titleSmall)), Text(formatMoney(subtotal, currency: t.currency), key: const Key('bottle-subtotal'), style: theme.textTheme.titleMedium)]),
                  const SizedBox(height: 12),
                  BottlePaymentChoiceTiles(mode: v.bottlePaymentMode, choice: _choice, onChanged: (c) => setState(() => _choice = c)),
                ],
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            OutlinedButton(key: const Key('back'), onPressed: () => _go(_Step.table), child: const Text('Back')),
            const SizedBox(width: 12),
            Expanded(child: FilledButton(key: const Key('to-review'), onPressed: () => _go(_Step.review), child: const Text('Review order'))),
          ],
        ),
      ],
    );
  }

  Widget _reviewStep(Venue v, TableType t, DateTime night, TimeSlot slot, Account acc) {
    final theme = Theme.of(context);
    final bottlesAsync = ref.watch(venueBottlesProvider(v.id));
    final bottles = bottlesAsync.valueOrNull ?? const <Bottle>[];
    final fee = ref.watch(siteFeeProvider);
    final policy = ref.watch(venueRefundPolicyProvider(v.id)).valueOrNull;
    final quote = _quote(v, t, bottles, fee.valueOrNull);
    final atClub = quote.bottleSubtotalCents > 0 && effectiveChoice(v.bottlePaymentMode, _choice) == BottlePaymentChoice.payAtClub;
    String money(int c) => formatMoney(c, currency: t.currency);
    Widget line(String label, String value, String key, {bool bold = false}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(children: [Expanded(child: Text(label, key: Key(key), style: bold ? theme.textTheme.titleSmall : null)), Text(value, key: Key('$key-value'), style: bold ? theme.textTheme.titleMedium : null)]),
        );
    return ListView(
      key: const Key('booking-review-step'),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
      children: [
        _steps(theme),
        _summary(v, t, night, slot),
        if (!t.isHourly && t.minSpendCents > 0)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(border: Border.all(color: theme.dividerColor), borderRadius: BorderRadius.circular(10)),
              child: Text(
                v.depositIsCredit
                    ? 'This table has a minimum spend of ${money(t.minSpendCents)}. Your ${money(t.depositCents)} deposit counts toward it, so ${money((t.minSpendCents - t.depositCents) < 0 ? 0 : t.minSpendCents - t.depositCents)} is left to spend at the venue.'
                    : 'This table has a minimum spend of ${money(t.minSpendCents)}, spent at the venue. Your ${money(t.depositCents)} deposit does not count toward it.',
                key: const Key('min-spend-note'),
                style: theme.textTheme.bodySmall,
              ),
            ),
          ),
        if (t.includedAdmissions != null && t.includedAdmissions! > 0) Padding(padding: const EdgeInsets.only(top: 8), child: Text('Includes ${t.includedAdmissions} entry ${t.includedAdmissions == 1 ? 'pass' : 'passes'}. Your table seating ${t.maxGuests} does not mean ${t.maxGuests} passes.', key: const Key('passes-note'), style: theme.textTheme.bodySmall)),
        const SizedBox(height: 14),
        if (policy != null)
          Container(
            key: const Key('refund-policy'),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(border: Border.all(color: theme.dividerColor), borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cancellations and refunds', style: theme.textTheme.titleSmall),
                const SizedBox(height: 4),
                for (final l in policy.lines) Padding(padding: const EdgeInsets.symmetric(vertical: 1), child: Text('•  $l', style: theme.textTheme.bodySmall)),
              ],
            ),
          ),
        const SizedBox(height: 14),
        Text('Promo code', style: theme.textTheme.titleSmall),
        const SizedBox(height: 6),
        if (_promoCheck?.valid == true)
          Row(children: [
            Expanded(child: Text('$_appliedCode applied', key: const Key('promo-applied'), style: TextStyle(color: theme.colorScheme.primary))),
            IconButton(key: const Key('remove-promo'), icon: const Icon(Icons.close), onPressed: () => setState(() {
                  _promoCheck = null;
                  _appliedCode = '';
                })),
          ])
        else
          Row(children: [
            Expanded(child: TextField(key: const Key('promo-code'), controller: _promo, enabled: !_busy, textCapitalization: TextCapitalization.characters, decoration: const InputDecoration(hintText: 'Enter code', border: OutlineInputBorder()))),
            const SizedBox(width: 8),
            OutlinedButton(key: const Key('apply-promo'), onPressed: _busy || _applyingPromo ? null : () => _applyPromo(v, quote), child: Text(_applyingPromo ? '...' : 'Apply')),
          ]),
        if (_promoCheck != null && !_promoCheck!.valid) Padding(padding: const EdgeInsets.only(top: 6), child: Text(_promoCheck!.message, key: const Key('promo-message'), style: TextStyle(color: theme.colorScheme.error))),
        const Divider(height: 28),
        line(t.isHourly ? 'Table ($_hours hr)' : 'Table deposit', money(quote.tableCents), 'line-table'),
        for (final b in bottles)
          if ((_cart[b.id] ?? 0) > 0) line('${b.displayName} × ${_cart[b.id]}${atClub ? ' · pay at the club' : ''}', money(b.priceCents * _cart[b.id]!), 'line-bottle-${b.id}'),
        if (quote.discountCents > 0) line('Promo ($_appliedCode)', '-${money(quote.discountCents)}', 'line-discount'),
        if (quote.taxCents > 0) line('Tax', money(quote.taxCents), 'line-tax'),
        if (quote.feeCents > 0) line('BottlesUp fee', money(quote.feeCents), 'line-fee'),
        const Divider(),
        line('Total due today', money(quote.totalNowCents), 'line-total', bold: true),
        if (quote.dueAtVenueCents > 0) line('To pay at the club', money(quote.dueAtVenueCents), 'due-at-club'),
        const SizedBox(height: 6),
        Text(
          quote.feeKnown || fee.isLoading ? 'You pay on the next page. The website checks the price and that the table is still free again before you pay, and holds the table for 10 minutes while you do.' : 'You pay on the next page. A BottlesUp fee may be added there. The website checks the price and that the table is still free again before you pay.',
          key: const Key('booking-explained'),
          style: theme.textTheme.bodySmall,
        ),
        if (_problem != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(_problem!, key: const Key('booking-problem'), style: TextStyle(color: theme.colorScheme.error))),
        const SizedBox(height: 16),
        Row(
          children: [
            OutlinedButton(key: const Key('back'), onPressed: _busy ? null : () => _go(_Step.bottles), child: const Text('Back')),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                key: const Key('pay'),
                onPressed: _busy || fee.isLoading ? null : () => _pay(v, t, night, slot, acc, bottles),
                child: Text(_busy ? 'Opening payment...' : 'Continue to payment'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
