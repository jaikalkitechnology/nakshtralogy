import 'package:flutter/material.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../services/api_service.dart';
import '../../../utils/kundli_names.dart';
import '_section_loader.dart';
import 'kundli_ui.dart';

/// Redesigned SHADBALA screen — strength hero, meter legend, planet ranking
/// and expandable planet cards (6 balas + total/required/excess) with a detail
/// bottom sheet, an info sheet and an "Explain" summary.
///
/// Presentation only. Values come from the API (shadbala). [planets] is
/// optional chart.planets for the state badges (retro/combust/dignity).
class ShadbalaWidget extends StatelessWidget {
  final String chartId;
  final dynamic initial;
  final Map<String, dynamic>? planets;
  const ShadbalaWidget({super.key, required this.chartId, this.initial, this.planets});

  @override
  Widget build(BuildContext context) {
    return SectionLoader(
      initial: initial is Map ? (initial as Map).cast<String, dynamic>() : null,
      loader: () => ApiService().getKundliShadbala(chartId),
      builder: (ctx, data) => _ShadbalaView(data: data, planets: planets),
    );
  }
}

const Color _cLightGreen = Color(0xFF8BC34A);
const List<String> _kBalas = ['sthana_bala', 'dig_bala', 'kala_bala', 'chesta_bala', 'naisargika_bala', 'drik_bala'];

int _sbTier(num s) {
  if (s >= 100) return 5; if (s >= 90) return 4; if (s >= 80) return 3;
  if (s >= 70) return 2; if (s >= 60) return 1; return 0;
}

Color sbColor(num s) {
  switch (_sbTier(s)) {
    case 5: return KColors.purple;
    case 4: return KColors.green;
    case 3: return _cLightGreen;
    case 2: return KColors.blue;
    case 1: return KColors.yellow;
    default: return KColors.orange;
  }
}

String sbLabel(num s, AppLocalizations l) {
  switch (_sbTier(s)) {
    case 5: return l.sbLegendary;
    case 4: return l.gradeExcellent;
    case 3: return l.sumStrong;
    case 2: return l.gradeGood;
    case 1: return l.gradeAverage;
    default: return l.gradeWeak;
  }
}

int sbStars(num s) {
  final t = _sbTier(s);
  if (t >= 4) return 5;
  if (t == 3 || t == 2) return 4;
  if (t == 1) return 3;
  return 2;
}

String balaLabel(String key, AppLocalizations l) {
  switch (key) {
    case 'sthana_bala': return l.sbSthana;
    case 'dig_bala': return l.sbDig;
    case 'kala_bala': return l.sbKala;
    case 'chesta_bala': return l.sbChesta;
    case 'naisargika_bala': return l.sbNaisargika;
    default: return l.sbDrik;
  }
}

String karakatvaOf(String p, AppLocalizations l) {
  switch (p) {
    case 'Sun': return l.aspTraitSun; case 'Moon': return l.aspTraitMoon;
    case 'Mars': return l.aspTraitMars; case 'Mercury': return l.aspTraitMercury;
    case 'Jupiter': return l.aspTraitJupiter; case 'Venus': return l.aspTraitVenus;
    case 'Saturn': return l.aspTraitSaturn; case 'Rahu': return l.aspTraitRahu;
    case 'Ketu': return l.aspTraitKetu; default: return '';
  }
}

// natural life-area karakas (fixed constants — presentation grouping)
const Map<String, List<String>> _kAreaKarakas = {
  'career': ['Sun', 'Saturn', 'Mercury', 'Mars'],
  'marriage': ['Venus', 'Jupiter', 'Moon'],
  'finance': ['Jupiter', 'Venus', 'Mercury'],
  'health': ['Sun', 'Mars', 'Moon'],
};

// ═══════════════════════════════════════════════════════════════════════
class _ShadbalaView extends StatelessWidget {
  final Map<String, dynamic> data;
  final Map<String, dynamic>? planets;
  const _ShadbalaView({required this.data, this.planets});

  static const _order = ['Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter', 'Venus', 'Saturn'];

  Map<String, dynamic> get _planetsData => (data['planets'] as Map? ?? {}).cast<String, dynamic>();

  List<MapEntry<String, Map<String, dynamic>>> get _ranked {
    final e = _order.where(_planetsData.containsKey)
        .map((p) => MapEntry(p, (_planetsData[p] as Map).cast<String, dynamic>()))
        .toList();
    e.sort((a, b) => ((b.value['score_100'] as num?) ?? 0).compareTo((a.value['score_100'] as num?) ?? 0));
    return e;
  }

  double _score(Map<String, dynamic> m) => (m['score_100'] as num?)?.toDouble() ?? 0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final loc = Localizations.localeOf(context);
    final ranked = _ranked;
    if (ranked.isEmpty) return Center(child: Text(l.noData, style: const TextStyle(color: AppColors.textSecondary)));

    return ListView(padding: const EdgeInsets.fromLTRB(16, 14, 16, 28), children: [
      // controls: explain + info
      Row(children: [
        Expanded(child: Material(
          color: AppColors.gold, borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => _showExplain(context, ranked, l, loc),
            child: Padding(padding: const EdgeInsets.symmetric(vertical: 13),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('✨', style: TextStyle(fontSize: 15)),
                const SizedBox(width: 8),
                Flexible(child: Text(l.sbExplain, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.midnight, fontSize: 13.5, fontWeight: FontWeight.w800))),
              ]))))),
        const SizedBox(width: 10),
        Material(
          color: AppColors.nebula, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: AppColors.gold.withOpacity(0.3))),
          child: IconButton(icon: const Icon(Icons.info_outline, color: AppColors.gold), tooltip: l.sbInfoTitle, onPressed: () => _showInfo(context, l)),
        ),
      ]),
      const SizedBox(height: 14),
      KFadeIn(child: _hero(context, l, loc, ranked)),
      const SizedBox(height: 18),
      KFadeIn(delayMs: 80, child: _meterLegend(l)),
      const SizedBox(height: 18),
      KFadeIn(delayMs: 120, child: KSectionHeader(icon: Icons.emoji_events_rounded, title: l.sbRanking, color: KColors.gold)),
      KFadeIn(delayMs: 140, child: _ranking(l, loc, ranked)),
      const SizedBox(height: 18),
      KFadeIn(delayMs: 180, child: KSectionHeader(icon: Icons.public, title: l.planets, color: KColors.purple)),
      ...List.generate(ranked.length, (i) => KFadeIn(
        delayMs: 200 + i * 30,
        child: _PlanetShadbalaCard(
          planet: ranked[i].key,
          m: ranked[i].value,
          natal: (planets?[ranked[i].key] as Map?)?.cast<String, dynamic>(),
        ),
      )),
    ]);
  }

  // ── Hero ─────────────────────────────────────────────────────────────
  Widget _hero(BuildContext context, AppLocalizations l, Locale loc, List<MapEntry<String, Map<String, dynamic>>> ranked) {
    final strong = ranked.first;
    final weak = ranked.last;
    final avg = ranked.map((e) => _score(e.value)).fold(0.0, (a, b) => a + b) / ranked.length;
    MapEntry<String, Map<String, dynamic>>? topRupa;
    double tr = -1;
    for (final e in ranked) {
      final r = ((e.value['total_virupas'] as num?)?.toDouble() ?? 0) / 60;
      if (r > tr) { tr = r; topRupa = e; }
    }
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF2A2358), Color(0xFF1A1642)]),
        borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.gold.withOpacity(0.3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('⚡', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(child: Text(l.sbSummary, style: const TextStyle(color: AppColors.goldBright, fontSize: 16.5, fontWeight: FontWeight.w800))),
        ]),
        const SizedBox(height: 16),
        Wrap(spacing: 10, runSpacing: 10, children: [
          _tile(l.sumStrongPlanet, KundliNames.planet(strong.key, loc), sbColor(_score(strong.value)), _score(strong.value).toStringAsFixed(0)),
          _tile(l.sumWeakPlanet, KundliNames.planet(weak.key, loc), sbColor(_score(weak.value)), _score(weak.value).toStringAsFixed(0)),
          _tile(l.sbAverageStrength, '${avg.toStringAsFixed(0)}%', sbColor(avg), null),
          _tile(l.sbHighestRupa, topRupa == null ? '—' : KundliNames.planet(topRupa.key, loc), KColors.gold, tr.toStringAsFixed(1)),
        ]),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.18), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.lavender.withOpacity(0.25))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(padding: EdgeInsets.only(top: 1, right: 8), child: Text('🔮', style: TextStyle(fontSize: 15))),
            Expanded(child: Text(
              l.sbHeroSummary(KundliNames.planet(strong.key, loc), karakatvaOf(strong.key, l), KundliNames.planet(weak.key, loc)),
              style: const TextStyle(color: AppColors.parchment, fontSize: 13, height: 1.5))),
          ]),
        ),
      ]),
    );
  }

  Widget _tile(String label, String value, Color color, String? badge) {
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.35))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label.toUpperCase(), style: const TextStyle(color: AppColors.smoke, fontSize: 9, letterSpacing: 0.5, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 3),
        Row(children: [
          Flexible(child: Text(value, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis)),
          if (badge != null) ...[const SizedBox(width: 5), Text(badge, style: const TextStyle(color: AppColors.smoke, fontSize: 11, fontWeight: FontWeight.w700))],
        ]),
      ]),
    );
  }

  // ── Strength meter legend ────────────────────────────────────────────
  Widget _meterLegend(AppLocalizations l) {
    final items = [
      [KColors.purple, l.sbLegendary, '100+'], [KColors.green, l.gradeExcellent, '90+'],
      [_cLightGreen, l.sumStrong, '80+'], [KColors.blue, l.gradeGood, '70+'],
      [KColors.yellow, l.gradeAverage, '60+'], [KColors.orange, l.gradeWeak, '<60'],
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Wrap(spacing: 12, runSpacing: 8, alignment: WrapAlignment.center, children: items.map((it) => Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 11, height: 11, decoration: BoxDecoration(color: it[0] as Color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 5),
        Text('${it[1]} ', style: const TextStyle(color: AppColors.parchment, fontSize: 10.5, fontWeight: FontWeight.w600)),
        Text(it[2] as String, style: const TextStyle(color: AppColors.smoke, fontSize: 9.5)),
      ])).toList()),
    );
  }

  // ── Ranking ───────────────────────────────────────────────────────────
  Widget _ranking(AppLocalizations l, Locale loc, List<MapEntry<String, Map<String, dynamic>>> ranked) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(children: List.generate(ranked.length, (i) {
        final e = ranked[i];
        final s = _score(e.value);
        final color = sbColor(s);
        final medal = i == 0 ? '🥇' : i == 1 ? '🥈' : i == 2 ? '🥉' : '';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(children: [
            SizedBox(width: 30, child: medal.isEmpty
                ? Text('${i + 1}', style: const TextStyle(color: AppColors.smoke, fontSize: 12, fontWeight: FontWeight.w700))
                : Text(medal, style: const TextStyle(fontSize: 15))),
            Text(_symbol(e.key), style: const TextStyle(fontSize: 14, color: AppColors.gold)),
            const SizedBox(width: 8),
            Expanded(child: Text(KundliNames.planet(e.key, loc), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w600))),
            SizedBox(width: 90, child: ClipRRect(borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(value: (s / 130).clamp(0, 1), minHeight: 6, backgroundColor: AppColors.ash.withOpacity(0.4), valueColor: AlwaysStoppedAnimation(color)))),
            const SizedBox(width: 8),
            SizedBox(width: 34, child: Text(s.toStringAsFixed(0), textAlign: TextAlign.right, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w800))),
          ]),
        );
      })),
    );
  }

  // ── Explain sheet ─────────────────────────────────────────────────────
  void _showExplain(BuildContext context, List<MapEntry<String, Map<String, dynamic>>> ranked, AppLocalizations l, Locale loc) {
    final strong = ranked.first, weak = ranked.last;
    final bullets = <String>[
      l.sbHeroSummary(KundliNames.planet(strong.key, loc), karakatvaOf(strong.key, l), KundliNames.planet(weak.key, loc)),
      l.sbCardAi(KundliNames.planet(strong.key, loc), sbLabel(_score(strong.value), l), karakatvaOf(strong.key, l)),
      l.sbCardAi(KundliNames.planet(weak.key, loc), sbLabel(_score(weak.value), l), karakatvaOf(weak.key, l)),
    ];
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.55, minChildSize: 0.4, maxChildSize: 0.9, expand: false,
        builder: (bctx, scroll) => Container(
          decoration: const BoxDecoration(color: AppColors.nebula, borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
          child: ListView(controller: scroll, padding: const EdgeInsets.fromLTRB(18, 10, 18, 28), children: [
            Center(child: Container(width: 42, height: 4, decoration: BoxDecoration(color: AppColors.ash, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 14),
            Row(children: [const Text('✨', style: TextStyle(fontSize: 20)), const SizedBox(width: 10),
              Expanded(child: Text(l.sbExplain, style: const TextStyle(color: AppColors.goldBright, fontSize: 17, fontWeight: FontWeight.w800)))]),
            const SizedBox(height: 6),
            Text(l.sbExplainSubtitle, style: const TextStyle(color: AppColors.smoke, fontSize: 12)),
            const SizedBox(height: 16),
            ...bullets.map((b) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(padding: const EdgeInsets.only(top: 2, right: 10), child: Icon(Icons.auto_awesome, size: 15, color: AppColors.lavender.withOpacity(0.9))),
              Expanded(child: Text(b, style: const TextStyle(color: AppColors.parchment, fontSize: 13.5, height: 1.5))),
            ]))),
          ]),
        ),
      ),
    );
  }

  // ── Info sheet ────────────────────────────────────────────────────────
  void _showInfo(BuildContext context, AppLocalizations l) {
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.65, minChildSize: 0.4, maxChildSize: 0.95, expand: false,
        builder: (bctx, scroll) => Container(
          decoration: const BoxDecoration(color: AppColors.nebula, borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
          child: ListView(controller: scroll, padding: const EdgeInsets.fromLTRB(18, 10, 18, 28), children: [
            Center(child: Container(width: 42, height: 4, decoration: BoxDecoration(color: AppColors.ash, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 14),
            Row(children: [const Icon(Icons.auto_stories, color: AppColors.gold, size: 20), const SizedBox(width: 10),
              Expanded(child: Text(l.sbInfoTitle, style: const TextStyle(color: AppColors.gold, fontSize: 17, fontWeight: FontWeight.w800)))]),
            const SizedBox(height: 16),
            _InfoTile(q: l.sbQWhatIs, a: l.sbBodyWhatIs),
            _InfoTile(q: l.sbQRupas, a: l.sbBodyRupas),
            _InfoTile(q: l.sbQHowCalc, a: l.sbBodyHowCalc),
            _InfoTile(q: l.sbQHowUse, a: l.sbBodyHowUse),
          ]),
        ),
      ),
    );
  }

  String _symbol(String name) {
    const s = {'Sun': '☉', 'Moon': '☾', 'Mars': '♂', 'Mercury': '☿', 'Jupiter': '♃', 'Venus': '♀', 'Saturn': '♄'};
    return s[name] ?? '✦';
  }
}

// ═══════════════════════════════════════════════════════════════════════
//  Expandable planet shadbala card
// ═══════════════════════════════════════════════════════════════════════
class _PlanetShadbalaCard extends StatefulWidget {
  final String planet;
  final Map<String, dynamic> m;
  final Map<String, dynamic>? natal;
  const _PlanetShadbalaCard({required this.planet, required this.m, this.natal});

  @override
  State<_PlanetShadbalaCard> createState() => _PlanetShadbalaCardState();
}

class _PlanetShadbalaCardState extends State<_PlanetShadbalaCard> {
  bool _open = false;

  double get _score => (widget.m['score_100'] as num?)?.toDouble() ?? 0;
  double get _rupa => ((widget.m['total_virupas'] as num?)?.toDouble() ?? 0) / 60;

  String _symbol(String name) {
    const s = {'Sun': '☉', 'Moon': '☾', 'Mars': '♂', 'Mercury': '☿', 'Jupiter': '♃', 'Venus': '♀', 'Saturn': '♄'};
    return s[name] ?? '✦';
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final loc = Localizations.localeOf(context);
    final color = sbColor(_score);
    final badges = <Widget>[];
    final n = widget.natal;
    if (n != null) {
      if (n['vakri'] == true) badges.add(_badge(l.sumRetrograde, KColors.blue));
      if (n['combust'] == true) badges.add(_badge(l.sumCombust, KColors.orange));
      if (n['vargottam'] == true) badges.add(_badge(l.sumVargottama, KColors.purple));
      final rel = kSignRelation(widget.planet, (n['sign_idx'] as num?)?.toInt() ?? 0, (n['dignity'] ?? '').toString());
      if (rel == 'own') badges.add(_badge(l.plOwnSign, KColors.green));
      else if (rel == 'exalted') badges.add(_badge(l.sumExalted, KColors.gold));
      else if (rel == 'debilitated') badges.add(_badge(l.sumDebilitated, KColors.red));
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withOpacity(0.35))),
      child: Column(children: [
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => setState(() => _open = !_open),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(children: [
              Row(children: [
                Container(width: 44, height: 44, alignment: Alignment.center,
                    decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
                    child: Text(_symbol(widget.planet), style: const TextStyle(fontSize: 20, color: AppColors.ivory))),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(KundliNames.planet(widget.planet, loc), style: const TextStyle(color: AppColors.ivory, fontSize: 15.5, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text('${l.sbRupa}: ${_rupa.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.primary, fontSize: 11.5, fontWeight: FontWeight.w600)),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(_score.toStringAsFixed(0), style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w800)),
                  Text(sbLabel(_score, l), style: TextStyle(color: color, fontSize: 9.5, fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(width: 6),
                AnimatedRotation(turns: _open ? 0.5 : 0, duration: const Duration(milliseconds: 240), child: Icon(Icons.expand_more, color: color)),
              ]),
              const SizedBox(height: 10),
              Row(children: [Expanded(child: KStars(filled: sbStars(_score), size: 15, color: color))]),
              const SizedBox(height: 8),
              ClipRRect(borderRadius: BorderRadius.circular(6),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: (_score / 100).clamp(0, 1)),
                    duration: const Duration(milliseconds: 800), curve: Curves.easeOutCubic,
                    builder: (_, v, __) => LinearProgressIndicator(value: v, minHeight: 7, backgroundColor: AppColors.ash.withOpacity(0.4), valueColor: AlwaysStoppedAnimation(color)))),
              if (badges.isNotEmpty) ...[
                const SizedBox(height: 10),
                Align(alignment: Alignment.centerLeft, child: Wrap(spacing: 6, runSpacing: 6, children: badges)),
              ],
            ]),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity, height: 0),
          secondChild: _expanded(l, loc, color),
          crossFadeState: _open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 260), sizeCurve: Curves.easeInOut,
        ),
      ]),
    );
  }

  Widget _badge(String label, Color c) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(color: c.withOpacity(0.16), borderRadius: BorderRadius.circular(7), border: Border.all(color: c.withOpacity(0.5))),
        child: Text(label, style: TextStyle(color: c, fontSize: 10.5, fontWeight: FontWeight.w700)),
      );

  Widget _expanded(AppLocalizations l, Locale loc, Color color) {
    final total = (widget.m['total_virupas'] as num?)?.toDouble() ?? 0;
    final req = (widget.m['min_required'] as num?)?.toDouble() ?? 0;
    final diff = (total - req) / 60;
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Divider(height: 1),
        const SizedBox(height: 12),
        ..._kBalas.map((k) {
          final v = ((widget.m[k] as num?)?.toDouble() ?? 0) / 60;
          const maxR = 6.0;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(children: [
              SizedBox(width: 116, child: Text(balaLabel(k, l), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5))),
              Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(value: (v / maxR).clamp(0, 1), minHeight: 8, backgroundColor: AppColors.ash.withOpacity(0.4),
                      valueColor: AlwaysStoppedAnimation(v < 0 ? KColors.red : AppColors.gold)))),
              const SizedBox(width: 8),
              SizedBox(width: 42, child: Text(v.toStringAsFixed(2), textAlign: TextAlign.right, style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, fontWeight: FontWeight.w700))),
            ]),
          );
        }),
        const SizedBox(height: 8),
        const Divider(height: 1),
        const SizedBox(height: 8),
        _kv(l.sbTotalShadbala, '${(total / 60).toStringAsFixed(2)} ${l.sbRupa}', AppColors.ivory),
        _kv(l.sbRequired, '${(req / 60).toStringAsFixed(2)} ${l.sbRupa}', AppColors.smoke),
        _kv(diff >= 0 ? l.sbExcess : l.sbDeficit, '${diff.abs().toStringAsFixed(2)} ${l.sbRupa}', diff >= 0 ? KColors.green : KColors.orange),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(color: AppColors.twilight.withOpacity(0.4), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.lavender.withOpacity(0.25))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(padding: EdgeInsets.only(top: 1, right: 8), child: Text('🔮', style: TextStyle(fontSize: 13))),
            Expanded(child: Text(l.sbCardAi(KundliNames.planet(widget.planet, loc), sbLabel(_score, l), karakatvaOf(widget.planet, l)),
                style: const TextStyle(color: AppColors.parchment, fontSize: 12.3, height: 1.45))),
          ]),
        ),
        const SizedBox(height: 8),
        Align(alignment: Alignment.centerRight, child: TextButton.icon(
          onPressed: () => _showDetail(l, loc),
          icon: const Icon(Icons.arrow_forward, size: 15, color: AppColors.gold),
          label: Text(l.sbPlanetDetails, style: const TextStyle(color: AppColors.gold, fontSize: 12.5, fontWeight: FontWeight.w700)),
        )),
      ]),
    );
  }

  Widget _kv(String k, String v, Color c) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(children: [
          Expanded(child: Text(k, style: const TextStyle(color: AppColors.smoke, fontSize: 12.5))),
          Text(v, style: TextStyle(color: c, fontSize: 12.5, fontWeight: FontWeight.w800)),
        ]),
      );

  // ── Planet detail bottom sheet ────────────────────────────────────────
  void _showDetail(AppLocalizations l, Locale loc) {
    final p = widget.planet;
    final name = KundliNames.planet(p, loc);
    final karak = karakatvaOf(p, l);
    String topBala = _kBalas.first, lowBala = _kBalas.first;
    double tv = -1e9, lv = 1e9;
    for (final k in _kBalas) {
      final v = (widget.m[k] as num?)?.toDouble() ?? 0;
      if (v > tv) { tv = v; topBala = k; }
      if (v < lv) { lv = v; lowBala = k; }
    }
    final strong = _score >= 90;
    final areas = <List<String>>[];
    _kAreaKarakas.forEach((area, karakas) {
      if (karakas.contains(p)) {
        final label = area == 'career' ? l.careerWord : area == 'marriage' ? l.lifeAreaMarriage : area == 'finance' ? l.avFinance : l.lifeHealth;
        areas.add([label, sbLabel(_score, l)]);
      }
    });

    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.72, minChildSize: 0.4, maxChildSize: 0.95, expand: false,
        builder: (bctx, scroll) => Container(
          decoration: const BoxDecoration(color: AppColors.nebula, borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
          child: ListView(controller: scroll, padding: const EdgeInsets.fromLTRB(18, 10, 18, 28), children: [
            Center(child: Container(width: 42, height: 4, decoration: BoxDecoration(color: AppColors.ash, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 14),
            Row(children: [
              Container(width: 46, height: 46, alignment: Alignment.center, decoration: BoxDecoration(color: sbColor(_score).withOpacity(0.16), shape: BoxShape.circle),
                  child: Text(_symbol(p), style: const TextStyle(fontSize: 22, color: AppColors.ivory))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(name, style: const TextStyle(color: AppColors.ivory, fontSize: 18, fontWeight: FontWeight.w800)),
                Text('${_score.toStringAsFixed(0)} · ${sbLabel(_score, l)} · ${_rupa.toStringAsFixed(2)} ${l.sbRupa}', style: TextStyle(color: sbColor(_score), fontSize: 12.5, fontWeight: FontWeight.w700)),
              ])),
            ]),
            const SizedBox(height: 16),
            _detailBlock(l.sbWhyStrong, l.sbWhyLine(balaLabel(topBala, l), (tv / 60).toStringAsFixed(2))),
            _detailBlock(l.sbWhyWeak, l.sbWeakLine(balaLabel(lowBala, l))),
            _detailBlock(l.sbDuringMahadasha, l.sbMahadashaLine(name, karak)),
            _detailBlock(l.sbEffects, strong ? l.sbEffectStrong(karak) : l.sbEffectWeak(karak)),
            if (areas.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(l.sbLifeAreas, style: const TextStyle(color: AppColors.gold, fontSize: 12.5, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8, children: areas.map((a) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                decoration: BoxDecoration(color: sbColor(_score).withOpacity(0.14), borderRadius: BorderRadius.circular(20), border: Border.all(color: sbColor(_score).withOpacity(0.4))),
                child: Text('${a[0]}: ${a[1]}', style: TextStyle(color: sbColor(_score), fontSize: 11.5, fontWeight: FontWeight.w600)),
              )).toList()),
              const SizedBox(height: 12),
            ],
            _detailBlock(l.bhRemedies, strong ? l.sbRemedyStrong : l.sbRemedyWeak(name)),
          ]),
        ),
      ),
    );
  }

  Widget _detailBlock(String title, String body) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: AppColors.gold, fontSize: 12.5, fontWeight: FontWeight.w800)),
          const SizedBox(height: 3),
          Text(body, style: const TextStyle(color: AppColors.parchment, fontSize: 12.5, height: 1.45)),
        ]),
      );
}

// ── info Q&A tile ────────────────────────────────────────────────────────
class _InfoTile extends StatefulWidget {
  final String q;
  final String a;
  const _InfoTile({required this.q, required this.a});
  @override
  State<_InfoTile> createState() => _InfoTileState();
}

class _InfoTileState extends State<_InfoTile> {
  bool _open = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: AppColors.twilight.withOpacity(0.3), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(children: [
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => setState(() => _open = !_open),
          child: Padding(padding: const EdgeInsets.all(13), child: Row(children: [
            Expanded(child: Text(widget.q, style: const TextStyle(color: AppColors.ivory, fontSize: 13.5, fontWeight: FontWeight.w700))),
            AnimatedRotation(turns: _open ? 0.5 : 0, duration: const Duration(milliseconds: 220), child: const Icon(Icons.expand_more, color: AppColors.gold, size: 20)),
          ])),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity, height: 0),
          secondChild: Padding(padding: const EdgeInsets.fromLTRB(13, 0, 13, 13),
              child: Align(alignment: Alignment.centerLeft, child: Text(widget.a, style: const TextStyle(color: AppColors.parchment, fontSize: 12.5, height: 1.5)))),
          crossFadeState: _open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 240),
        ),
      ]),
    );
  }
}
