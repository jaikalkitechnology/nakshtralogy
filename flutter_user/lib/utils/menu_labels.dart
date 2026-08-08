import 'package:flutter/widgets.dart';

/// Locale-keyed labels for the Profile menu tabs (Change Password, Customer
/// Support) and the About & Legal section. Mirrors [HomeLabels]: a per-locale
/// map with an English base that every locale falls back to, so these strings
/// render in the user's chosen language (Indian + international) without adding
/// new gen-l10n ARB keys.
///
/// Per-locale translations are merged in below (`_m`). English (`_en`) is the
/// canonical fallback; a missing locale or key resolves to English, never a
/// blank. Keys:
///   changePassword, changePasswordSub, customerSupport, customerSupportSub,
///   aboutLegal, privacyPolicy, termsConditions, refundPolicy, couldNotOpen.
class MenuLabels {
  static const _en = <String, String>{
    'changePassword': 'Change Password',
    'changePasswordSub': 'Update your password via email OTP',
    'customerSupport': 'Customer Support',
    'customerSupportSub': 'FAQ & raise a ticket',
    'aboutLegal': 'About & Legal',
    'privacyPolicy': 'Privacy Policy',
    'termsConditions': 'Terms & Conditions',
    'refundPolicy': 'Refund Policy',
    'couldNotOpen': 'Could not open the link',
  };

  // Per-locale overrides. Keyed by the same code scheme as HomeLabels
  // (languageCode, or languageCode_Latn for romanized scripts like Hinglish).
  static const _m = <String, Map<String, String>>{
    // MENU_LABELS_TRANSLATIONS — merged from language agents.
  };

  static String _key(Locale l) =>
      l.scriptCode == 'Latn' ? '${l.languageCode}_${l.scriptCode}' : l.languageCode;

  /// Localized menu string for [key] in the current locale (English fallback).
  static String of(BuildContext context, String key) {
    final code = _key(Localizations.localeOf(context));
    return _m[code]?[key] ?? _en[key] ?? key;
  }
}
