import 'package:flutter/widgets.dart';

/// Locale-keyed labels for the NakshtralogyPlus subscription UI (profile card +
/// plans screen). English base is the guaranteed fallback; per-locale maps are
/// filled by the localization pass. "NakshtralogyPlus" stays as the brand name
/// across languages.
class PlusLabels {
  static const _en = <String, String>{
    'plus': 'NakshtralogyPlus',
    'tagline': 'All-access membership',
    'subtitle': 'Unlock every report, kundli & forecast',
    'memberUntil': 'Plus member · active until',
    'daysLeft': 'days left',
    'notMember': 'Get all-access to every product',
    'choosePlan': 'Choose your plan',
    'benefitsTitle': "What's included",
    'b1': 'All reports & analyses — free',
    'b2': 'All divisional charts & dashas',
    'b3': 'Daily forecast & moola dasha',
    'b4': 'Unlimited birth charts',
    'b5': 'AI astro readings',
    'excluded': 'Live astrologer chat, call & video are charged separately',
    'perDay': '/day',
    'days': 'days',
    'subscribe': 'Subscribe',
    'subscribing': 'Activating…',
    'renew': 'Extend membership',
    'haveCoupon': 'Have a coupon code?',
    'enterCode': 'Enter code',
    'apply': 'Apply',
    'remove': 'Remove',
    'applied': 'Coupon applied',
    'free': 'FREE',
    'youPay': 'You pay',
    'lowBalance': 'Low balance — add money to subscribe',
    'addMoney': 'Add money',
    'activated': 'NakshtralogyPlus is now active!',
    'off': 'OFF',
    'bestValue': 'BEST VALUE',
    'currentPlan': 'Active plan',
  };

  static const _m = <String, Map<String, String>>{};

  static String _key(Locale l) =>
      l.scriptCode == 'Latn' ? '${l.languageCode}_${l.scriptCode}' : l.languageCode;

  static String of(BuildContext context, String key) {
    final code = _key(Localizations.localeOf(context));
    return _m[code]?[key] ?? _en[key] ?? key;
  }
}
