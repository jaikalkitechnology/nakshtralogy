import 'package:flutter/material.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/app_theme.dart';

/// ════════════════════════════════════════════════════════════════════
///  Shared UI foundation for the Complete Birth Chart redesign
///  (Summary / Planets / Kundli). Presentation helpers only — no astrology
///  calculation happens here; every value is passed in from the API.
/// ════════════════════════════════════════════════════════════════════

/// Common color system (Common UX spec).
class KColors {
  static const Color green = Color(0xFF4FB477); // Strong
  static const Color blue = Color(0xFF5B9BD5); // Good
  static const Color yellow = Color(0xFFE3B23C); // Average
  static const Color orange = Color(0xFFE0883C); // Weak
  static const Color red = Color(0xFFD95555); // Needs Attention
  static const Color purple = Color(0xFF9B7FE0); // Special Yoga
  static const Color gold = AppColors.gold; // Exalted

  /// Map a 0–100 strength (shadbala score_100) to a color.
  static Color forScore(num s) {
    if (s >= 80) return green;
    if (s >= 60) return blue;
    if (s >= 40) return yellow;
    if (s >= 25) return orange;
    return red;
  }

  /// Foreground that reads on top of a band color.
  static Color on(Color c) =>
      (c == yellow || c == gold) ? AppColors.midnight : Colors.white;
}

/// 0–100 strength → localized label (Very Strong … Needs Attention).
String kStrengthLabel(num s, AppLocalizations l) {
  if (s >= 80) return l.sumVeryStrong;
  if (s >= 60) return l.sumStrong;
  if (s >= 40) return l.sumAverage;
  if (s >= 25) return l.sumWeak;
  return l.sumNeedsAttention;
}

/// 0–100 strength → 1..5 stars.
int kStars(num s) => (s / 20).ceil().clamp(1, 5);

// ── sign-derived attributes (deterministic, standard Vedic mapping) ──────
const List<String> _kSignLords = [
  'Mars', 'Venus', 'Mercury', 'Moon', 'Sun', 'Mercury',
  'Venus', 'Mars', 'Jupiter', 'Saturn', 'Saturn', 'Jupiter'
];

/// element token: fire | earth | air | water
String kElementToken(int signIdx) =>
    const ['fire', 'earth', 'air', 'water'][signIdx % 4];

/// modality token: movable | fixed | dual
String kModalityToken(int signIdx) =>
    const ['movable', 'fixed', 'dual'][signIdx % 3];

/// lucky-direction token from the sign's ruling planet (its dik).
String kDirectionToken(int signIdx) {
  const dirs = {
    'Sun': 'east', 'Moon': 'nw', 'Mars': 'south', 'Mercury': 'north',
    'Jupiter': 'ne', 'Venus': 'se', 'Saturn': 'west',
  };
  return dirs[_kSignLords[signIdx]] ?? 'east';
}

String kElementLabel(String t, AppLocalizations l) {
  switch (t) {
    case 'fire': return l.sumFire;
    case 'earth': return l.sumEarth;
    case 'air': return l.sumAir;
    default: return l.sumWater;
  }
}

String kModalityLabel(String t, AppLocalizations l) {
  switch (t) {
    case 'movable': return l.sumMovable;
    case 'fixed': return l.sumFixed;
    default: return l.sumDual;
  }
}

String kDirectionLabel(String t, AppLocalizations l) {
  switch (t) {
    case 'east': return l.sumDirEast;
    case 'west': return l.sumDirWest;
    case 'north': return l.sumDirNorth;
    case 'south': return l.sumDirSouth;
    case 'ne': return l.sumDirNE;
    case 'nw': return l.sumDirNW;
    case 'se': return l.sumDirSE;
    default: return l.sumDirSW;
  }
}

String kElementNatureLine(String t, AppLocalizations l) {
  switch (t) {
    case 'fire': return l.sumNatureFire;
    case 'earth': return l.sumNatureEarth;
    case 'air': return l.sumNatureAir;
    default: return l.sumNatureWater;
  }
}

// ── planet static attributes (fixed Vedic constants — presentation only) ─
const Map<String, List<String>> _kOwnSigns = {
  'Sun': ['Le'], 'Moon': ['Cn'], 'Mars': ['Ar', 'Sc'], 'Mercury': ['Ge', 'Vi'],
  'Jupiter': ['Sg', 'Pi'], 'Venus': ['Ta', 'Li'], 'Saturn': ['Cp', 'Aq'],
};
const Set<String> _kBenefics = {'Jupiter', 'Venus', 'Mercury', 'Moon'};
const Map<String, String> _kPlanetElement = {
  'Sun': 'fire', 'Moon': 'water', 'Mars': 'fire', 'Mercury': 'earth',
  'Jupiter': 'ether', 'Venus': 'water', 'Saturn': 'air', 'Rahu': 'air', 'Ketu': 'fire',
};
const Map<String, String> _kPlanetGender = {
  'Sun': 'male', 'Moon': 'female', 'Mars': 'male', 'Mercury': 'neutral',
  'Jupiter': 'male', 'Venus': 'female', 'Saturn': 'neutral', 'Rahu': 'neutral', 'Ketu': 'neutral',
};
// naisargika (permanent) friendships
const Map<String, Set<String>> _kFriends = {
  'Sun': {'Moon', 'Mars', 'Jupiter'}, 'Moon': {'Sun', 'Mercury'},
  'Mars': {'Sun', 'Moon', 'Jupiter'}, 'Mercury': {'Sun', 'Venus'},
  'Jupiter': {'Sun', 'Moon', 'Mars'}, 'Venus': {'Mercury', 'Saturn'},
  'Saturn': {'Mercury', 'Venus'},
};
const Map<String, Set<String>> _kEnemies = {
  'Sun': {'Venus', 'Saturn'}, 'Moon': {}, 'Mars': {'Mercury'},
  'Mercury': {'Moon'}, 'Jupiter': {'Mercury', 'Venus'},
  'Venus': {'Sun', 'Moon'}, 'Saturn': {'Sun', 'Moon', 'Mars'},
};

String kOrdinal(int n) {
  if (n >= 11 && n <= 13) return '${n}th';
  switch (n % 10) {
    case 1: return '${n}st';
    case 2: return '${n}nd';
    case 3: return '${n}rd';
    default: return '${n}th';
  }
}

bool kIsBenefic(String planet) => _kBenefics.contains(planet);
List<String> kOwnSigns(String planet) => _kOwnSigns[planet] ?? const [];
String kNatureLabel(String planet, AppLocalizations l) => kIsBenefic(planet) ? l.plBenefic : l.plMalefic;
String kPlanetElementLabel(String planet, AppLocalizations l) =>
    kElementLabel2(_kPlanetElement[planet] ?? 'fire', l);
String kGenderLabel(String planet, AppLocalizations l) {
  switch (_kPlanetGender[planet]) {
    case 'male': return l.plMale;
    case 'female': return l.plFemale;
    default: return l.plNeutralGender;
  }
}

String kElementLabel2(String t, AppLocalizations l) => t == 'ether' ? l.sumEther : kElementLabel(t, l);

/// Sign relationship of a planet in its occupied sign.
/// Prefers the backend dignity (own/exalted/debilitated); otherwise derives
/// friend/enemy/neutral from the sign-lord's natural relationship.
/// Returns: exalted | debilitated | own | friend | enemy | neutral
String kSignRelation(String planet, int signIdx, String dignity) {
  final d = dignity.toLowerCase();
  if (d.contains('uch') || d.contains('exalt')) return 'exalted';
  if (d.contains('neech') || d.contains('debil')) return 'debilitated';
  if (d.contains('swa') || d.contains('own')) return 'own';
  final lord = _kSignLords[signIdx];
  if (lord == planet) return 'own';
  if ((_kFriends[planet] ?? const {}).contains(lord)) return 'friend';
  if ((_kEnemies[planet] ?? const {}).contains(lord)) return 'enemy';
  return 'neutral';
}

Color kRelationColor(String rel) {
  switch (rel) {
    case 'exalted': return KColors.gold;
    case 'own': return KColors.green;
    case 'friend': return KColors.blue;
    case 'enemy': return KColors.orange;
    case 'debilitated': return KColors.red;
    default: return AppColors.smoke;
  }
}

String kRelationLabel(String rel, AppLocalizations l) {
  switch (rel) {
    case 'exalted': return l.sumExalted;
    case 'debilitated': return l.sumDebilitated;
    case 'own': return l.plOwnSign;
    case 'friend': return l.plFriend;
    case 'enemy': return l.plEnemy;
    default: return l.plNeutral;
  }
}

// ── glossary (Common UX: tooltip on every technical word) ────────────────
String kGlossary(String term, AppLocalizations l) {
  switch (term) {
    case 'combust': return l.kDefCombust;
    case 'retrograde': return l.kDefRetrograde;
    case 'nakshatra': return l.kDefNakshatra;
    case 'vargottama': return l.kDefVargottama;
    case 'ownsign': return l.kDefOwnSign;
    case 'exalted': return l.kDefExalted;
    case 'debilitated': return l.kDefDebilitated;
    case 'mooltrikona': return l.kDefMooltrikona;
    case 'ascendant': return l.kDefAscendant;
    case 'mahadasha': return l.kDefMahadasha;
    case 'antardasha': return l.kDefAntardasha;
    case 'pada': return l.kDefPada;
    default: return '';
  }
}

// ═══════════════════════════════════════════════════════════════════════
//  Reusable widgets
// ═══════════════════════════════════════════════════════════════════════

/// A section header with an accent icon, title and optional subtitle.
class KSectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color color;
  const KSectionHeader({super.key, required this.icon, required this.title, this.subtitle, this.color = AppColors.gold});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 12),
      child: Row(children: [
        Container(
          width: 34, height: 34, alignment: Alignment.center,
          decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: AppColors.ivory, fontSize: 15.5, fontWeight: FontWeight.w800)),
          if (subtitle != null) Text(subtitle!, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
        ])),
      ]),
    );
  }
}

/// 5-star strength row.
class KStars extends StatelessWidget {
  final int filled;
  final double size;
  final Color color;
  const KStars({super.key, required this.filled, this.size = 14, this.color = AppColors.gold});
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: List.generate(5, (i) =>
      Icon(i < filled ? Icons.star_rounded : Icons.star_outline_rounded, size: size, color: color)));
}

/// A technical term shown with a dotted underline that reveals a plain-language
/// tooltip on tap/long-press (Common UX: tooltip on every technical word).
class KTerm extends StatelessWidget {
  final String label;
  final String term; // glossary key
  final TextStyle? style;
  const KTerm({super.key, required this.label, required this.term, this.style});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final def = kGlossary(term, l);
    final base = style ?? const TextStyle(color: AppColors.parchment, fontSize: 12.5, fontWeight: FontWeight.w600);
    if (def.isEmpty) return Text(label, style: base);
    return Tooltip(
      message: def,
      triggerMode: TooltipTriggerMode.tap,
      showDuration: const Duration(seconds: 4),
      preferBelow: false,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(color: AppColors.twilight, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.gold.withOpacity(0.4))),
      textStyle: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.4),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.smoke, width: 0.8, style: BorderStyle.solid)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(label, style: base),
          const SizedBox(width: 2),
          Icon(Icons.help_outline, size: (base.fontSize ?? 12) - 1, color: AppColors.smoke),
        ]),
      ),
    );
  }
}

/// Staggered fade + rise-in wrapper.
class KFadeIn extends StatefulWidget {
  final Widget child;
  final int delayMs;
  const KFadeIn({super.key, required this.child, this.delayMs = 0});
  @override
  State<KFadeIn> createState() => _KFadeInState();
}

class _KFadeInState extends State<KFadeIn> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 420));
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.delayMs), () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, child) {
        final t = Curves.easeOutCubic.transform(_c.value);
        return Opacity(opacity: _c.value, child: Transform.translate(offset: Offset(0, (1 - t) * 16), child: child));
      },
      child: widget.child,
    );
  }
}
