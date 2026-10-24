import 'package:supabase_flutter/supabase_flutter.dart';

class CurrencyService {
  static final CurrencyService _instance = CurrencyService._internal();
  factory CurrencyService() => _instance;
  CurrencyService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Supported currencies
  static const Map<String, String> supportedCurrencies = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'CAD': 'C\$',
    'AUD': 'A\$',
    'JPY': '¥',
    'CNY': '¥',
    'INR': '₹',
    'MXN': 'Mex\$',
    'BRL': 'R\$',
  };

  // Get exchange rates (cached)
  Future<Map<String, double>> getExchangeRates({
    String baseCurrency = 'USD',
  }) async {
    try {
      // Check cache first
      final cached = await _getCachedRates(baseCurrency);
      if (cached != null) return cached;

      // Fetch from database (rates updated daily via scheduled function)
      final response = await _supabase
          .from('exchange_rates')
          .select('to_currency, rate')
          .eq('from_currency', baseCurrency)
          .gte('updated_at', DateTime.now().subtract(const Duration(hours: 24)).toIso8601String());

      final rates = <String, double>{baseCurrency: 1.0};
      for (final item in response as List) {
        rates[item['to_currency'] as String] = (item['rate'] as num).toDouble();
      }

      // Cache for 1 hour
      await _cacheRates(baseCurrency, rates);

      return rates;
    } catch (e) {
      // Fallback to cached rates even if expired
      final cached = await _getCachedRates(baseCurrency, ignoreExpiry: true);
      if (cached != null) return cached;

      throw Exception('Failed to get exchange rates: $e');
    }
  }

  // Convert amount between currencies
  Future<double> convertAmount({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
  }) async {
    if (fromCurrency == toCurrency) return amount;

    try {
      final rates = await getExchangeRates(baseCurrency: fromCurrency);
      final rate = rates[toCurrency];

      if (rate == null) {
        throw Exception('Exchange rate not found for $toCurrency');
      }

      return amount * rate;
    } catch (e) {
      throw Exception('Failed to convert currency: $e');
    }
  }

  // Format amount with currency symbol
  String formatAmount({
    required double amount,
    required String currency,
    int decimalPlaces = 2,
  }) {
    final symbol = supportedCurrencies[currency] ?? currency;
    final formatted = amount.toStringAsFixed(decimalPlaces);

    // Format with thousands separator
    final parts = formatted.split('.');
    final intPart = parts[0];
    final decPart = parts.length > 1 ? parts[1] : '00';

    final formattedInt = intPart.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );

    // Symbol position varies by currency
    if (['EUR', 'BRL'].contains(currency)) {
      return '$formattedInt.$decPart $symbol';
    }

    return '$symbol$formattedInt.$decPart';
  }

  // Get user's preferred currency
  Future<String> getUserCurrency() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return 'USD';

      final response = await _supabase
          .from('users')
          .select('preferred_currency')
          .eq('id', currentUser.id)
          .single();

      return response['preferred_currency'] as String? ?? 'USD';
    } catch (e) {
      return 'USD';
    }
  }

  // Set user's preferred currency
  Future<void> setUserCurrency(String currency) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase
          .from('users')
          .update({'preferred_currency': currency})
          .eq('id', currentUser.id);

      // Clear cached rates when changing currency
      await _clearCachedRates();
    } catch (e) {
      throw Exception('Failed to set user currency: $e');
    }
  }

  // Get venue's native currency
  Future<String> getVenueCurrency(String venueId) async {
    try {
      final response = await _supabase
          .from('venues')
          .select('currency')
          .eq('id', venueId)
          .single();

      return response['currency'] as String? ?? 'USD';
    } catch (e) {
      return 'USD';
    }
  }

  // Convert price display for venue
  Future<Map<String, dynamic>> convertVenuePrice({
    required double price,
    required String venueId,
  }) async {
    try {
      final venueCurrency = await getVenueCurrency(venueId);
      final userCurrency = await getUserCurrency();

      if (venueCurrency == userCurrency) {
        return {
          'original_amount': price,
          'original_currency': venueCurrency,
          'converted_amount': price,
          'converted_currency': userCurrency,
          'needs_conversion': false,
        };
      }

      final converted = await convertAmount(
        amount: price,
        fromCurrency: venueCurrency,
        toCurrency: userCurrency,
      );

      return {
        'original_amount': price,
        'original_currency': venueCurrency,
        'converted_amount': converted,
        'converted_currency': userCurrency,
        'needs_conversion': true,
      };
    } catch (e) {
      throw Exception('Failed to convert venue price: $e');
    }
  }

  // Cache helpers
  Future<void> _cacheRates(String baseCurrency, Map<String, double> rates) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase.from('currency_cache').upsert({
        'user_id': currentUser.id,
        'base_currency': baseCurrency,
        'rates': rates,
        'cached_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Cache failure is not critical
    }
  }

  Future<Map<String, double>?> _getCachedRates(
    String baseCurrency, {
    bool ignoreExpiry = false,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return null;

      final response = await _supabase
          .from('currency_cache')
          .select('rates, cached_at')
          .eq('user_id', currentUser.id)
          .eq('base_currency', baseCurrency)
          .maybeSingle();

      if (response == null) return null;

      // Check if cache is expired (1 hour)
      if (!ignoreExpiry) {
        final cachedAt = DateTime.parse(response['cached_at'] as String);
        if (DateTime.now().difference(cachedAt).inHours >= 1) {
          return null;
        }
      }

      final rates = response['rates'] as Map;
      return rates.map((key, value) => MapEntry(
        key as String,
        (value as num).toDouble(),
      ));
    } catch (e) {
      return null;
    }
  }

  Future<void> _clearCachedRates() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase
          .from('currency_cache')
          .delete()
          .eq('user_id', currentUser.id);
    } catch (e) {
      // Cache clear failure is not critical
    }
  }

  // Get live exchange rate (force refresh)
  Future<double> getLiveExchangeRate({
    required String fromCurrency,
    required String toCurrency,
  }) async {
    try {
      // Clear cache to force refresh
      await _clearCachedRates();

      final rates = await getExchangeRates(baseCurrency: fromCurrency);
      return rates[toCurrency] ?? 1.0;
    } catch (e) {
      throw Exception('Failed to get live exchange rate: $e');
    }
  }

  // Format price with both currencies (e.g., "$100 USD (~€92 EUR)")
  Future<String> formatDualCurrency({
    required double amount,
    required String originalCurrency,
    required String displayCurrency,
  }) async {
    if (originalCurrency == displayCurrency) {
      return formatAmount(amount: amount, currency: originalCurrency);
    }

    try {
      final converted = await convertAmount(
        amount: amount,
        fromCurrency: originalCurrency,
        toCurrency: displayCurrency,
      );

      final originalFormatted = formatAmount(
        amount: amount,
        currency: originalCurrency,
      );
      final convertedFormatted = formatAmount(
        amount: converted,
        currency: displayCurrency,
      );

      return '$originalFormatted (~$convertedFormatted)';
    } catch (e) {
      return formatAmount(amount: amount, currency: originalCurrency);
    }
  }
}
