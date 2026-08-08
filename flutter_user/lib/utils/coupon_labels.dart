import 'package:flutter/widgets.dart';

/// Locale-keyed labels for the coupon UI (paywall coupon field, astrologer
/// coupon banner, statuses). English base now; per-locale translations are
/// merged in Phase 6 (same pattern as HomeLabels / MenuLabels). English is the
/// guaranteed fallback so nothing ever blanks.
class CouponLabels {
  static const _en = <String, String>{
    'haveCoupon': 'Have a coupon?',
    'enterCode': 'Enter code',
    'apply': 'Apply',
    'applied': 'Coupon applied',
    'remove': 'Remove',
    'unlockFree': 'Unlock free',
    'youSave': 'You save',
    'firstTimeOffer': 'First-time offer',
    'alreadyUsed': 'You have already used this offer',
    'reason_invalid': 'Invalid coupon code',
    'reason_expired': 'This coupon has expired',
    'reason_unavailable': 'This coupon is not available right now',
    'reason_already_used': "You've already used this coupon",
    'reason_not_first_time': 'This offer is for first-time users only',
    'reason_not_applicable': 'This coupon does not apply here',
    'reason_min_order': 'Order value is too low for this coupon',
    'reason_network': "Couldn't check the coupon — please try again",
  };

  static const _m = <String, Map<String, String>>{
    // COUPON_LABELS_TRANSLATIONS — merged from language agents (Phase 6).
  };

  static String _key(Locale l) =>
      l.scriptCode == 'Latn' ? '${l.languageCode}_${l.scriptCode}' : l.languageCode;

  static String of(BuildContext context, String key) {
    final code = _key(Localizations.localeOf(context));
    return _m[code]?[key] ?? _en[key] ?? key;
  }
}
