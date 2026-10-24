/// Money is kept as whole cents everywhere; this only turns it into words.
String formatMoney(int cents, {String currency = 'cad'}) {
  final negative = cents < 0;
  final abs = cents.abs();
  final whole = abs ~/ 100;
  final frac = (abs % 100).toString().padLeft(2, '0');
  final grouped = whole.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
  return '${negative ? '-' : ''}\$$grouped.$frac';
}

/// A price on a ticket or table: "Free" for nothing, otherwise the amount.
String formatPrice(int cents, {String currency = 'cad'}) => cents == 0 ? 'Free' : formatMoney(cents, currency: currency);
