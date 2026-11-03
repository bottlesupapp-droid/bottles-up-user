import 'package:flutter/material.dart';

import '../../../shared/widgets/site_widgets.dart';
import '../../../site/models/venue.dart';
import '../../../site/money.dart';

/// One bottle on the menu with a counter.
class BottleTile extends StatelessWidget {
  const BottleTile({super.key, required this.bottle, required this.showImage, required this.quantity, required this.onChanged});

  final Bottle bottle;
  final bool showImage;
  final int quantity;
  final void Function(int quantity) onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      key: Key('bottle-${bottle.id}'),
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            if (showImage && bottle.imageUrl != null) NetworkPicture(url: bottle.imageUrl, height: 56, width: 56, radius: 8) else Container(height: 56, width: 56, decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.wine_bar_outlined)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bottle.displayName, key: Key('bottle-name-${bottle.id}'), style: theme.textTheme.titleSmall),
                  if (bottle.description != null) Text(bottle.description!, style: theme.textTheme.bodySmall),
                  Text(formatMoney(bottle.priceCents, currency: bottle.currency), key: Key('bottle-price-${bottle.id}'), style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
            IconButton(key: Key('bottle-minus-${bottle.id}'), onPressed: quantity <= 0 ? null : () => onChanged(quantity - 1), icon: const Icon(Icons.remove_circle_outline)),
            Text('$quantity', key: Key('bottle-qty-${bottle.id}')),
            IconButton(key: Key('bottle-plus-${bottle.id}'), onPressed: quantity >= 99 ? null : () => onChanged(quantity + 1), icon: const Icon(Icons.add_circle_outline)),
          ],
        ),
      ),
    );
  }
}

/// How the bottles are paid for, as the venue allows: a note when the venue decides, two choices when the guest does.
class BottlePaymentChoiceTiles extends StatelessWidget {
  const BottlePaymentChoiceTiles({super.key, required this.mode, required this.choice, required this.onChanged});

  final BottlePaymentMode mode;
  final BottlePaymentChoice choice;
  final void Function(BottlePaymentChoice choice) onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (mode == BottlePaymentMode.payAtClub) {
      return Text('At this venue bottles are paid at the club.', key: const Key('bottles-at-club'), style: theme.textTheme.bodyMedium);
    }
    if (mode == BottlePaymentMode.payAhead) {
      return Text('Bottles are charged now.', key: const Key('bottles-ahead'), style: theme.textTheme.bodyMedium);
    }
    Widget option(String key, String title, String text, BottlePaymentChoice value) => Expanded(
          child: InkWell(
            key: Key(key),
            onTap: () => onChanged(value),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(border: Border.all(color: choice == value ? theme.colorScheme.primary : theme.dividerColor, width: choice == value ? 2 : 1), borderRadius: BorderRadius.circular(10)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: theme.textTheme.titleSmall), Text(text, style: theme.textTheme.bodySmall)]),
            ),
          ),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('How do you want to pay for your bottles?', style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        Row(children: [option('pay-ahead', 'Pay now', 'Bottles charged online today.', BottlePaymentChoice.payAhead), const SizedBox(width: 8), option('pay-at-club', 'Pay at the club', 'Only the table is charged now.', BottlePaymentChoice.payAtClub)]),
      ],
    );
  }
}
