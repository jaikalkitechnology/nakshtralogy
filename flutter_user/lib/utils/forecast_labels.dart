import 'package:flutter/widgets.dart';

/// Localized display labels for the daily-forecast house domains and the
/// event-probability metrics shown in the house-detail dialog. Keyed by the
/// backend's raw key (metric key like `physical_energy_probability`, or a house
/// domain like `Self/Health`). Falls back to the caller's English label.
///
/// GENERATED from forecast_labels_en.json + agent translations — do not edit.
class ForecastLabels {
  static const _m = <String, Map<String, String>>{
  };

  static String _key(Locale l) =>
      l.scriptCode == 'Latn' ? '${l.languageCode}_${l.scriptCode}' : l.languageCode;

  /// Localized label for [key]; returns [fallback] (usually the title-cased
  /// English) when the locale or key is not mapped.
  static String label(String key, Locale locale, String fallback) =>
      _m[_key(locale)]?[key] ?? fallback;
}
