import '../models/site_event.dart';
import '../money.dart';

/// The most tickets in one order (the website refuses more).
const int maxTicketsPerOrder = 10;
const int nameMin = 2;
const int nameMax = 120;
const int phoneMax = 40;
const int emailMax = 254;

final RegExp _emailShape = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

/// Why a ticket type cannot be bought right now, or null when it can.
enum TierBlock { soldOut, needsCode }

/// What stops a person buying this ticket type: sold out, or locked until a code is entered. [unlocked] is true once the website accepted the code.
TierBlock? tierBlock(TicketTier tier, {required bool unlocked}) {
  if (tier.soldOut) return TierBlock.soldOut;
  if (tier.requiresAccessCode && !unlocked) return TierBlock.needsCode;
  return null;
}

/// The most the person can ask for: what is left, and never more than one order allows.
int maxQuantityFor(TicketTier tier) => tier.available < maxTicketsPerOrder ? tier.available : maxTicketsPerOrder;

/// "Only 3 left" when it is getting low (10 or fewer), "Sold out" when none, otherwise nothing.
String? scarcityLabel(TicketTier tier) {
  if (tier.soldOut) return 'Sold out';
  if (tier.available <= 10) return 'Only ${tier.available} left';
  return null;
}

/// What the order comes to before any promo code.
int subtotalCents(TicketTier tier, int quantity) => tier.priceCents * quantity;

/// What the order comes to with a promo discount (never below nothing).
int totalCents(TicketTier tier, int quantity, int discountCents) {
  final t = subtotalCents(tier, quantity) - discountCents;
  return t < 0 ? 0 : t;
}

/// The line to show for the order: "2 × General · $100.00".
String orderLine(TicketTier tier, int quantity) => '$quantity × ${tier.name} · ${formatPrice(subtotalCents(tier, quantity), currency: tier.currency)}';

/// The first thing wrong with a ticket order about to be sent, as a sentence, or null when it can go ahead. The website checks all of this again.
String? validateTicketOrder({
  required TicketTier? tier,
  required bool unlocked,
  required int quantity,
  required String name,
  required String email,
  required String phone,
}) {
  if (tier == null) return 'Choose a ticket type.';
  switch (tierBlock(tier, unlocked: unlocked)) {
    case TierBlock.soldOut:
      return '${tier.name} is sold out.';
    case TierBlock.needsCode:
      return 'Enter the access code for ${tier.name}.';
    case null:
      break;
  }
  final max = maxQuantityFor(tier);
  if (quantity < 1 || quantity > max) return max == 1 ? 'Only 1 ticket is left.' : 'Choose between 1 and $max tickets.';
  final n = name.trim();
  if (n.length < nameMin) return 'Enter your name (at least $nameMin letters).';
  if (n.length > nameMax) return 'That name is too long.';
  final e = email.trim();
  if (e.isEmpty || e.length > emailMax || !_emailShape.hasMatch(e)) return 'Your account needs a valid email address to send the tickets to.';
  if (phone.trim().length > phoneMax) return 'That phone number is too long.';
  return null;
}
