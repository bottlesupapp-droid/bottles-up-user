import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/checkout.dart';
import '../../../site/models/site_event.dart';
import '../../../site/money.dart';
import '../../../site/providers/site_providers.dart';
import '../../../site/rules/ticket_rules.dart';
import '../../../site/site_error.dart';
import '../../../site/when.dart';

/// What was being paid for.
enum PaymentKind { tickets, table }

/// What the payment screen needs to follow a payment that was started: for tickets, the event and ticket type (so the order can be found if the website did not say which payment it
/// was); for a table, the venue.
class PaymentWaitArgs {
  const PaymentWaitArgs({required String this.eventId, required String this.tierId, required String eventTitle, required this.start, required this.startedAt})
      : kind = PaymentKind.tickets,
        title = eventTitle,
        backPath = '/events/$eventId';

  const PaymentWaitArgs.table({required String venueId, required String venueName, required this.start, required this.startedAt})
      : kind = PaymentKind.table,
        eventId = null,
        tierId = null,
        title = 'your table at $venueName',
        backPath = '/venues/$venueId';

  final PaymentKind kind;
  final String? eventId;
  final String? tierId;

  /// What to call it: the event, or "your table at Club A".
  final String title;

  /// Where "back" goes: the event or the venue.
  final String backPath;
  final CheckoutStart start;
  final DateTime startedAt;
}

/// Buying tickets for one ticket type: how many, who it is for, a promo code, an access code if the type needs one, and what it comes to. Nothing is decided here: the website works out
/// the price, the discount and whether the tickets are still there when the order is made, and takes the payment on Stripe's page.
class TicketPurchaseScreen extends ConsumerStatefulWidget {
  const TicketPurchaseScreen({super.key, required this.eventId, required this.tierId, this.onStarted});

  final String eventId;
  final String tierId;

  /// Where to go once the payment page is opened. The app shows the waiting screen; tests give their own.
  final void Function(BuildContext context, PaymentWaitArgs args)? onStarted;

  @override
  ConsumerState<TicketPurchaseScreen> createState() => _TicketPurchaseScreenState();
}

class _TicketPurchaseScreenState extends ConsumerState<TicketPurchaseScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _promo = TextEditingController();
  final _access = TextEditingController();
  int _quantity = 1;
  bool _unlocked = false;
  PromoCheck? _promoCheck;
  bool _filled = false;
  bool _busy = false;
  bool _checkingCode = false;
  String? _problem;
  String? _codeMessage;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _promo.dispose();
    _access.dispose();
    super.dispose();
  }

  TicketTier? _tierOf(SiteEvent e) {
    for (final t in e.tiers) {
      if (t.id == widget.tierId) return t;
    }
    return null;
  }

  int get _discount => _promoCheck?.valid == true ? _promoCheck!.discountCents : 0;

  Future<void> _unlock(TicketTier tier) async {
    if (_checkingCode || _access.text.trim().isEmpty) return;
    setState(() {
      _checkingCode = true;
      _codeMessage = null;
    });
    try {
      final r = await ref.read(ticketCheckoutServiceProvider).checkAccessCode(tierId: tier.id, code: _access.text);
      if (!mounted) return;
      setState(() {
        _unlocked = r.valid;
        _codeMessage = r.message;
        _checkingCode = false;
      });
    } on SiteException catch (e) {
      if (mounted) {
        setState(() {
          _codeMessage = e.message;
          _checkingCode = false;
        });
      }
    }
  }

  Future<void> _applyPromo(SiteEvent event, TicketTier tier) async {
    final code = _promo.text.trim();
    if (code.isEmpty) {
      setState(() => _promoCheck = null);
      return;
    }
    try {
      final r = await ref.read(ticketCheckoutServiceProvider).checkPromo(code: code, subtotalCents: subtotalCents(tier, _quantity), venueId: event.venueId);
      if (mounted) setState(() => _promoCheck = r);
    } on SiteException catch (e) {
      if (mounted) setState(() => _promoCheck = PromoCheck(valid: false, message: e.message));
    }
  }

  void _setQuantity(SiteEvent event, TicketTier tier, int q) {
    setState(() {
      _quantity = q;
      _problem = null;
    });
    // The discount depends on what the order comes to: ask the website again.
    if (_promoCheck != null) _applyPromo(event, tier);
  }

  Future<void> _pay(SiteEvent event, TicketTier tier, Account account) async {
    if (_busy) return;
    final problem = validateTicketOrder(tier: tier, unlocked: _unlocked, quantity: _quantity, name: _name.text, email: account.email, phone: _phone.text);
    setState(() => _problem = problem);
    if (problem != null) return;
    setState(() => _busy = true);
    final startedAt = DateTime.now().subtract(const Duration(seconds: 5));
    try {
      final start = await ref.read(ticketCheckoutServiceProvider).start(
            eventId: event.id,
            tierId: tier.id,
            quantity: _quantity,
            name: _name.text,
            email: account.email,
            phone: _phone.text,
            promoCode: _promoCheck?.valid == true ? _promo.text : null,
            accessCode: tier.requiresAccessCode ? _access.text : null,
          );
      final opened = await ref.read(urlOpenerProvider)(start.url, inApp: true);
      if (!mounted) return;
      setState(() => _busy = false);
      if (!opened) {
        setState(() => _problem = 'We could not open the payment page. Check that your phone can open web pages, then try again.');
        return;
      }
      final args = PaymentWaitArgs(eventId: event.id, tierId: tier.id, eventTitle: event.title, start: start, startedAt: startedAt);
      (widget.onStarted ?? (c, a) => c.pushReplacement('/payment', extra: a))(context, args);
    } on SiteException catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _problem = e.message;
        });
        // What is left may have changed: read the event again.
        ref.invalidate(eventProvider(widget.eventId));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final event = ref.watch(eventProvider(widget.eventId));
    final account = ref.watch(accountProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Your tickets')),
      body: event.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => LoadFailed(message: error is SiteException ? error.message : loadFailedMessage('this event'), onRetry: () => ref.invalidate(eventProvider(widget.eventId))),
        data: (e) {
          final tier = e == null ? null : _tierOf(e);
          if (e == null || tier == null) {
            return const EmptyState(icon: Icons.event_busy_outlined, title: 'These tickets are no longer available', text: 'Go back to the event to see what is on sale.');
          }
          final acc = account.valueOrNull;
          if (account.isLoading) return const Center(child: CircularProgressIndicator());
          if (acc == null) {
            return const EmptyState(icon: Icons.lock_outline, title: 'Sign in to buy tickets', text: 'Your tickets are sent to the email of your account.');
          }
          if (!_filled) {
            _filled = true;
            _name.text = acc.name;
            _phone.text = acc.phone;
          }
          return _form(e, tier, acc);
        },
      ),
    );
  }

  Widget _form(SiteEvent e, TicketTier tier, Account acc) {
    final theme = Theme.of(context);
    final block = tierBlock(tier, unlocked: _unlocked);
    final max = maxQuantityFor(tier);
    final total = totalCents(tier, _quantity, _discount);
    return ListView(
      key: const Key('purchase-form'),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
      children: [
        Text(e.title, key: const Key('purchase-event'), style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text('${formatWhen(e.start)}${e.venueName.isEmpty ? '' : ' · ${e.venueName}'}', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            title: Text(tier.name, key: const Key('purchase-tier')),
            subtitle: scarcityLabel(tier) == null ? null : Text(scarcityLabel(tier)!),
            trailing: Text(formatPrice(tier.priceCents, currency: tier.currency), style: theme.textTheme.titleMedium),
          ),
        ),
        if (tier.isNonTransferable)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text('These tickets stay with you. At the door you show a 6-digit code that we email to ${acc.email}.', key: const Key('purchase-nontransferable'), style: theme.textTheme.bodySmall),
          ),
        if (tier.requiresAccessCode && !_unlocked) ...[
          const SizedBox(height: 16),
          Text('This ticket needs an access code.', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: TextField(key: const Key('access-code'), controller: _access, enabled: !_checkingCode, textCapitalization: TextCapitalization.characters, decoration: const InputDecoration(labelText: 'Access code', border: OutlineInputBorder()))),
              const SizedBox(width: 8),
              FilledButton(key: const Key('unlock'), onPressed: _checkingCode ? null : () => _unlock(tier), child: Text(_checkingCode ? '...' : 'Unlock')),
            ],
          ),
          if (_codeMessage != null) Padding(padding: const EdgeInsets.only(top: 6), child: Text(_codeMessage!, key: const Key('access-message'), style: TextStyle(color: theme.colorScheme.error))),
        ],
        if (tier.requiresAccessCode && _unlocked)
          Padding(padding: const EdgeInsets.only(top: 12), child: Text(_codeMessage ?? 'Code accepted.', key: const Key('access-accepted'), style: TextStyle(color: theme.colorScheme.primary))),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text('How many?'),
            const Spacer(),
            IconButton(key: const Key('qty-minus'), onPressed: _busy || _quantity <= 1 ? null : () => _setQuantity(e, tier, _quantity - 1), icon: const Icon(Icons.remove_circle_outline)),
            Text('$_quantity', key: const Key('qty'), style: theme.textTheme.titleLarge),
            IconButton(key: const Key('qty-plus'), onPressed: _busy || _quantity >= max ? null : () => _setQuantity(e, tier, _quantity + 1), icon: const Icon(Icons.add_circle_outline)),
          ],
        ),
        const SizedBox(height: 8),
        TextField(key: const Key('buyer-name'), controller: _name, enabled: !_busy, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        InputDecorator(
          decoration: const InputDecoration(labelText: 'Send the tickets to', border: OutlineInputBorder()),
          child: Text(acc.email, key: const Key('buyer-email')),
        ),
        const SizedBox(height: 12),
        TextField(key: const Key('buyer-phone'), controller: _phone, enabled: !_busy, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone (optional)', border: OutlineInputBorder())),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: TextField(key: const Key('promo-code'), controller: _promo, enabled: !_busy, textCapitalization: TextCapitalization.characters, decoration: const InputDecoration(labelText: 'Promo code (optional)', border: OutlineInputBorder()))),
            const SizedBox(width: 8),
            OutlinedButton(key: const Key('apply-promo'), onPressed: _busy ? null : () => _applyPromo(e, tier), child: const Text('Apply')),
          ],
        ),
        if (_promoCheck != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(_promoCheck!.message, key: const Key('promo-message'), style: TextStyle(color: _promoCheck!.valid ? theme.colorScheme.primary : theme.colorScheme.error)),
          ),
        const Divider(height: 32),
        _Line(label: orderLine(tier, _quantity), value: '', keyName: 'order-line'),
        if (_discount > 0) _Line(label: 'Promo code', value: '-${formatMoney(_discount, currency: tier.currency)}', keyName: 'order-discount'),
        _Line(label: 'Total', value: formatPrice(total, currency: tier.currency), keyName: 'order-total', bold: true),
        const SizedBox(height: 6),
        Text('You pay on the next page. The website checks the price and the tickets again before you pay.', style: theme.textTheme.bodySmall),
        if (_problem != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(_problem!, key: const Key('purchase-problem'), style: TextStyle(color: theme.colorScheme.error))),
        const SizedBox(height: 16),
        FilledButton(
          key: const Key('pay'),
          onPressed: _busy || block == TierBlock.soldOut ? null : () => _pay(e, tier, acc),
          child: Text(_busy ? 'Opening payment...' : 'Continue to payment'),
        ),
      ],
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.value, required this.keyName, this.bold = false});

  final String label;
  final String value;
  final String keyName;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = bold ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.bodyLarge;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(children: [
        Expanded(child: Text(label, key: Key(keyName), style: style)),
        if (value.isNotEmpty) Text(value, key: Key('$keyName-value'), style: style),
      ]),
    );
  }
}
