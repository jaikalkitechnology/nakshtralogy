import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/kundli_names.dart';
import 'kundli_ui.dart';

/// Redesigned SUMMARY tab of the Complete Birth Chart.
///
/// [chart] is the /chart response (planets, birth details). [complete] is the
/// prefetched /analysis/complete bundle (shadbala, dosh/yoga, life_areas, …);
/// it may be null until the prefetch lands — the highlights fill in when it
/// arrives. No calculation happens here; everything is read from the API.
class SummaryTabWidget extends StatelessWidget {
  final Map<String, dynamic> chart;
  final Map<String, dynamic>? complete;
  const SummaryTabWidget({super.key, required this.chart, this.complete});

  Map<String, dynamic> get _planets =>
      (chart['planets'] as Map? ?? {}).cast<String, dynamic>();

  Map<String, dynamic>? _p(String name) =>
      (_planets[name] as Map?)?.cast<String, dynamic>();

  int _idx(Map<String, dynamic>? m) => (m?['sign_idx'] as num?)?.toInt() ?? 0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return ListView(padding: const EdgeInsets.fromLTRB(16, 14, 16, 90), children: [
      KFadeIn(child: _birthCard(context, l)),
      const SizedBox(height: 18),
      KFadeIn(delayMs: 70, child: _heroCard(context, l)),
      const SizedBox(height: 20),
      KFadeIn(delayMs: 140, child: KSectionHeader(icon: Icons.insights, title: l.sumHighlights, color: KColors.purple)),
      KFadeIn(delayMs: 160, child: _highlights(context, l)),
      const SizedBox(height: 20),
      KFadeIn(delayMs: 220, child: KSectionHeader(icon: Icons.auto_graph, title: l.sumQuickInsights, color: KColors.blue)),
      KFadeIn(delayMs: 240, child: _quickInsights(context, l)),
    ]);
  }

  // ── Section 1: Birth Details ─────────────────────────────────────────
  Widget _birthCard(BuildContext context, AppLocalizations l) {
    final rows = <List<String>>[
      [l.name, chart['name']?.toString() ?? '—'],
      [l.dob, chart['dob']?.toString() ?? '—'],
      [l.tob, chart['tob']?.toString() ?? '—'],
      [l.place, chart['place']?.toString() ?? '—'],
      [l.sumTimezone, 'IST (UTC +5:30)'],
      [l.sumAyanamsa, 'Lahiri'],
      [l.sumCalendarType, 'Vedic / Sidereal'],
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.badge_outlined, color: AppColors.gold, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(l.birthDetails,
              style: const TextStyle(color: AppColors.gold, fontSize: 14.5, fontWeight: FontWeight.w800))),
          _iconBtn(Icons.copy_rounded, () => _copy(context, l, rows)),
        ]),
        const SizedBox(height: 12),
        ...rows.map((r) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(width: 96, child: Text(r[0], style: const TextStyle(color: AppColors.smoke, fontSize: 12))),
                Expanded(child: Text(r[1], style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w600))),
              ]),
            )),
      ]),
    );
  }

  Widget _iconBtn(IconData ic, VoidCallback onTap) => Material(
        color: AppColors.gold.withOpacity(0.12),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(padding: const EdgeInsets.all(7), child: Icon(ic, size: 16, color: AppColors.gold)),
        ),
      );

  void _copy(BuildContext context, AppLocalizations l, List<List<String>> rows) {
    final text = rows.map((r) => '${r[0]}: ${r[1]}').join('\n');
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.sumCopied), duration: const Duration(seconds: 2)));
  }

  // ── Section 2: Hero — Your Astrology Snapshot ────────────────────────
  Widget _heroCard(BuildContext context, AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    final lagna = _p('Lagna');
    final moon = _p('Moon');
    final sun = _p('Sun');
    final moonIdx = _idx(moon);
    final lagnaIdx = _idx(lagna);

    String signOf(Map<String, dynamic>? m) =>
        (m?['sign_full_local'] ?? m?['sign_full'] ?? '—').toString();

    final elementTok = kElementToken(moonIdx);
    final modalityTok = kModalityToken(moonIdx);
    final dirTok = kDirectionToken(lagnaIdx);
    final dasha = _currentDasha(loc);

    final chips = <List<String>>[
      [l.kundliAscendantLagna, signOf(lagna)],
      [l.kundliMoonSignRashi, signOf(moon)],
      [l.kundliSunSign, signOf(sun)],
      if (dasha[0] != null) [l.sumMahadasha, dasha[0]!],
      if (dasha[1] != null) [l.sumAntardasha, dasha[1]!],
      [l.sumNakshatra, (moon?['nakshatra_local'] ?? moon?['nakshatra'] ?? '—').toString()],
      [l.sumElement, kElementLabel(elementTok, l)],
      [l.sumModality, kModalityLabel(modalityTok, l)],
      [l.sumLuckyDirection, kDirectionLabel(dirTok, l)],
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFF2A2358), Color(0xFF1A1642)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withOpacity(0.3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('✨', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(child: Text(l.sumSnapshotTitle,
              style: const TextStyle(color: AppColors.goldBright, fontSize: 16.5, fontWeight: FontWeight.w800))),
        ]),
        const SizedBox(height: 16),
        Wrap(spacing: 10, runSpacing: 10, children: chips.map((c) => _snapChip(c[0], c[1])).toList()),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.18),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.lavender.withOpacity(0.25)),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(padding: EdgeInsets.only(top: 1, right: 8), child: Text('🔮', style: TextStyle(fontSize: 15))),
            Expanded(child: Text(kElementNatureLine(elementTok, l),
                style: const TextStyle(color: AppColors.parchment, fontSize: 13, height: 1.5, fontStyle: FontStyle.italic))),
          ]),
        ),
      ]),
    );
  }

  Widget _snapChip(String label, String value) {
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gold.withOpacity(0.15)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label.toUpperCase(), style: const TextStyle(color: AppColors.smoke, fontSize: 9, letterSpacing: 0.5, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 3),
        Text(value, style: const TextStyle(color: AppColors.ivory, fontSize: 13.5, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
      ]),
    );
  }

  /// Best-effort current Mahadasha / Antardasha planet names from the
  /// prefetched vimshottari tree (date-in-range). Returns [md, ad], nullable.
  List<String?> _currentDasha(Locale loc) {
    try {
      final vim = (complete?['vimshottari'] as Map?)?.cast<String, dynamic>();
      final dashas = (vim?['dashas'] as List?) ?? const [];
      final now = DateTime.now();
      String? md, ad;
      for (final d in dashas) {
        final m = (d as Map).cast<String, dynamic>();
        final s = _parseDate(m['start']?.toString());
        final e = _parseDate(m['end']?.toString());
        if (s != null && e != null && !now.isBefore(s) && now.isBefore(e)) {
          md = KundliNames.planet(m['planet']?.toString() ?? '', loc);
          for (final sub in (m['sub'] as List?) ?? const []) {
            final sm = (sub as Map).cast<String, dynamic>();
            final ss = _parseDate(sm['start']?.toString());
            final se = _parseDate(sm['end']?.toString());
            if (ss != null && se != null && !now.isBefore(ss) && now.isBefore(se)) {
              ad = KundliNames.planet(sm['planet']?.toString() ?? '', loc);
              break;
            }
          }
          break;
        }
      }
      return [md, ad];
    } catch (_) {
      return [null, null];
    }
  }

  DateTime? _parseDate(String? s) {
    if (s == null || s.isEmpty) return null;
    // try DD/MM/YYYY then YYYY-MM-DD
    final slash = s.split('/');
    if (slash.length == 3) {
      final d = int.tryParse(slash[0]), m = int.tryParse(slash[1]), y = int.tryParse(slash[2]);
      if (d != null && m != null && y != null) return DateTime(y, m, d);
    }
    return DateTime.tryParse(s);
  }

  // ── Section 3: Important Highlights ──────────────────────────────────
  Widget _highlights(BuildContext context, AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    // strongest / weakest planet from shadbala
    String? strongP, weakP;
    num strongV = -1, weakV = 1e9;
    final sb = ((complete?['shadbala'] as Map?)?['planets'] as Map?)?.cast<String, dynamic>();
    if (sb != null) {
      sb.forEach((p, v) {
        final s = ((v as Map)['score_100'] as num?)?.toDouble() ?? 0;
        if (s > strongV) { strongV = s; strongP = p; }
        if (s < weakV) { weakV = s; weakP = p; }
      });
    }
    // yoga / dosha counts
    final yogaN = ((complete?['yoga_analysis'] as Map?)?['active'] as num?)?.toInt();
    final doshN = ((complete?['dosh_analysis'] as Map?)?['active'] as num?)?.toInt();
    // planet-state counts (from chart)
    int retro = 0, combust = 0, exalt = 0, debil = 0, varg = 0;
    _planets.forEach((name, v) {
      if (name == 'Lagna') return;
      final m = (v as Map);
      if (m['vakri'] == true) retro++;
      if (m['combust'] == true) combust++;
      if (m['vargottam'] == true) varg++;
      final dg = (m['dignity'] ?? '').toString().toLowerCase();
      if (dg.contains('exalt')) exalt++;
      if (dg.contains('debil')) debil++;
    });

    return Column(children: [
      Row(children: [
        Expanded(child: _bigStat(l.sumStrongPlanet,
            strongP == null ? '—' : KundliNames.planet(strongP!, loc),
            strongP == null ? null : strongV, KColors.green, Icons.trending_up)),
        const SizedBox(width: 10),
        Expanded(child: _bigStat(l.sumWeakPlanet,
            weakP == null ? '—' : KundliNames.planet(weakP!, loc),
            weakP == null ? null : weakV, KColors.orange, Icons.trending_down)),
      ]),
      const SizedBox(height: 10),
      Wrap(spacing: 10, runSpacing: 10, children: [
        _miniStat(l.sumYogas, yogaN?.toString() ?? '—', KColors.purple, 'auto_awesome'),
        _miniStat(l.sumDoshas, doshN?.toString() ?? '—', KColors.red, 'warning'),
        _miniStat(l.sumRetrograde, '$retro', KColors.blue, 'retro', term: 'retrograde'),
        _miniStat(l.sumCombust, '$combust', KColors.orange, 'combust', term: 'combust'),
        _miniStat(l.sumExalted, '$exalt', KColors.gold, 'exalt', term: 'exalted'),
        _miniStat(l.sumDebilitated, '$debil', KColors.red, 'debil', term: 'debilitated'),
        _miniStat(l.sumVargottama, '$varg', KColors.green, 'varg', term: 'vargottama'),
      ]),
    ]);
  }

  Widget _bigStat(String label, String value, num? score, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withOpacity(0.18), color.withOpacity(0.06)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Icon(icon, color: color, size: 15), const SizedBox(width: 6),
          Expanded(child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis))]),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(color: AppColors.ivory, fontSize: 17, fontWeight: FontWeight.w800)),
        if (score != null) ...[
          const SizedBox(height: 4),
          Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)),
        ],
      ]),
    );
  }

  Widget _miniStat(String label, String value, Color color, String icon, {String? term}) {
    final content = Column(mainAxisSize: MainAxisSize.min, children: [
      Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w800, height: 1.0)),
      const SizedBox(height: 3),
      Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w600), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
    ]);
    return Container(
      width: 88,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: term == null
          ? content
          : Builder(builder: (ctx) {
              final l = AppLocalizations.of(ctx)!;
              return Tooltip(
                message: kGlossary(term, l),
                triggerMode: TooltipTriggerMode.tap,
                showDuration: const Duration(seconds: 4),
                preferBelow: false,
                decoration: BoxDecoration(color: AppColors.twilight, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.gold.withOpacity(0.4))),
                textStyle: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.4),
                child: content,
              );
            }),
    );
  }

  // ── Section 4: Quick Insights (life areas) ───────────────────────────
  Widget _quickInsights(BuildContext context, AppLocalizations l) {
    final areas = (complete?['life_areas'] as Map?)?.cast<String, dynamic>();
    final defs = <List<dynamic>>[
      ['Career', l.careerWord, Icons.work_outline],
      ['Wealth', l.avFinance, Icons.savings_outlined],
      ['Marriage', l.lifeAreaMarriage, Icons.favorite_outline],
      ['Health', l.lifeHealth, Icons.health_and_safety_outlined],
      ['Spirituality', l.sumSpirituality, Icons.self_improvement],
    ];
    if (areas == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
        child: const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold)),
      );
    }
    return Column(children: defs.map((d) {
      final data = (areas[d[0]] as Map?)?.cast<String, dynamic>();
      final score = (data?['score'] as num?)?.toDouble() ?? 0;
      final stars = (score / 20).ceil().clamp(1, 5);
      final color = KColors.forScore(score);
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
        child: Row(children: [
          Container(
            width: 40, height: 40, alignment: Alignment.center,
            decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(11)),
            child: Icon(d[2] as IconData, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(d[1] as String, style: const TextStyle(color: AppColors.ivory, fontSize: 13.5, fontWeight: FontWeight.w700)),
              const Spacer(),
              KStars(filled: stars, size: 14, color: color),
            ]),
            const SizedBox(height: 4),
            Text(_areaLine(l, score), style: const TextStyle(color: AppColors.smoke, fontSize: 11.5, height: 1.35)),
          ])),
        ]),
      );
    }).toList());
  }

  String _areaLine(AppLocalizations l, num score) {
    if (score >= 70) return l.sumGradePhraseExcellent;
    if (score >= 55) return l.sumGradePhraseGood;
    if (score >= 40) return l.sumGradePhraseAverage;
    return l.sumGradePhraseWeak;
  }
}
