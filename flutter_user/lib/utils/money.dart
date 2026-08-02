import 'package:intl/intl.dart';
import '../services/app_mode.dart';

/// Money — currency + locale aware formatting for user-visible prices.
///
/// Never hardcode ₹ / $ in a widget: format through here so international
/// sessions show USD and Indian sessions show ₹, both with correct grouping.
/// Display-only — the backend ledger + amounts are unchanged.
class Money {
  /// Symbol for a currency code.
  static String symbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'INR':
        return '₹';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      default:
        return currency.toUpperCase() + ' ';
    }
  }

  /// Format an amount in an explicit currency. `decimals` null → 0 for INR,
  /// 2 for USD (store tiers like $4.99). Locale drives digit grouping.
  static String format(num amount, {String currency = 'INR', int? decimals, String? locale}) {
    final cur = currency.toUpperCase();
    final dp = decimals ?? (cur == 'USD' ? 2 : 0);
    final sym = symbol(cur);
    try {
      final f = NumberFormat.currency(
        locale: locale,
        symbol: sym,
        decimalDigits: dp,
      );
      return f.format(amount);
    } catch (_) {
      return '$sym${amount.toStringAsFixed(dp)}';
    }
  }

  /// Format in the current session currency (USD international, ₹ India).
  static String session(num amount, {int? decimals, String? locale}) {
    return format(amount, currency: AppMode.instance.currency, decimals: decimals, locale: locale);
  }

  /// Current session currency code.
  static String get sessionCurrency => AppMode.instance.currency;
}
