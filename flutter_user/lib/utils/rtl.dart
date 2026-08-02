import 'package:flutter/material.dart';
import '../services/app_mode.dart';

/// RTL helpers for Arabic (and any future RTL locale).
///
/// Text direction is applied automatically by MaterialApp: the app sets
/// `locale` and uses `AppLocalizations.localizationsDelegates`, which include
/// GlobalWidgetsLocalizations — so a `Locale('ar')` root gets
/// `TextDirection.rtl` and the whole tree mirrors (Row order, text alignment,
/// EdgeInsetsDirectional, AppBar BackButton, etc.).
///
/// Use these helpers where a widget needs to branch on direction explicitly
/// (e.g. a manually-placed directional icon that does not auto-mirror).
class Rtl {
  /// True when the current context renders right-to-left.
  static bool of(BuildContext context) =>
      Directionality.of(context) == TextDirection.rtl;

  /// True when the selected locale/language code is RTL.
  static bool isRtlLocale(Locale locale) =>
      AppMode.instance.isRtlCode(locale.languageCode);

  /// A back-navigation icon that points the correct way for the text
  /// direction (← in LTR, → in RTL). Use instead of a bare Icons.arrow_back,
  /// which does not auto-mirror.
  static IconData backIcon(BuildContext context) =>
      of(context) ? Icons.arrow_forward : Icons.arrow_back;
}
