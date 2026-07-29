import 'package:flutter/material.dart';
import '../../l10n/gen/app_localizations.dart';
import '../kundli/widgets/kundli_ui.dart';

/// Shared presentation helpers for the Rashi screens.
///
/// These convert the engine's raw gochar score (roughly -8..+8) into a
/// friendly 0–100 "energy" for display and map it to colours / status
/// labels. No calculation is changed — this is a display transform only.
class RashiUi {
  RashiUi._();

  /// Raw gochar score (~ -8..+8) → positive 0–100 energy. Never negative.
  static double energy(double raw) => (((raw + 8) / 16) * 100).clamp(0, 100);

  static Color energyColor(double e) {
    if (e >= 80) return KColors.green;
    if (e >= 65) return KColors.blue;
    if (e >= 50) return KColors.yellow;
    if (e >= 38) return KColors.orange;
    return KColors.red;
  }

  static String energyStatus(double e, AppLocalizations l) {
    if (e >= 80) return l.gradeExcellent;
    if (e >= 65) return l.gradeGood;
    if (e >= 50) return l.fdStatusAverage;
    if (e >= 38) return l.rzCaution;
    if (e >= 25) return l.rzWeak;
    return l.doshCritical;
  }

  /// 0–100 life-area score → colour (predictions scores are already 0–100).
  static Color areaColor(double s) {
    if (s >= 75) return KColors.green;
    if (s >= 60) return KColors.blue;
    if (s >= 45) return KColors.yellow;
    if (s >= 30) return KColors.orange;
    return KColors.red;
  }

  /// Sign name is already localised by the backend; pass through safely.
  static String signName(String? v, AppLocalizations l) => (v == null || v.isEmpty) ? '—' : v;

  /// Planet → its natural significations (karaka), localised.
  static String karaka(String planet, AppLocalizations l) {
    switch (planet.toLowerCase()) {
      case 'sun': return l.rzKarakaSun;
      case 'moon': return l.rzKarakaMoon;
      case 'mars': return l.rzKarakaMars;
      case 'mercury': return l.rzKarakaMercury;
      case 'jupiter': return l.rzKarakaJupiter;
      case 'venus': return l.rzKarakaVenus;
      case 'saturn': return l.rzKarakaSaturn;
      case 'rahu': return l.rzKarakaRahu;
      case 'ketu': return l.rzKarakaKetu;
      default: return l.rzKarakaSun;
    }
  }
}
