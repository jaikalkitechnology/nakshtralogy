import 'package:flutter/material.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/kundli_names.dart';
import 'kundli_ui.dart';
import 'north_indian_chart.dart';

/// Redesigned KUNDLI tab — North Indian chart with a Lagna/Moon/Sun/D9/D10
/// toggle, a planet placement table (tap → detail sheet) and per-house cards.
///
/// Presentation only. [chart] = /chart (planets + divisionals); [complete] =
/// prefetched /analysis/complete (shadbala, bhava_strength, aspect_matrix).
class KundliTabWidget extends StatefulWidget {
  final Map<String, dynamic> chart;
  final Map<String, dynamic>? complete;
  const KundliTabWidget({super.key, required this.chart, this.complete});

  @override
  State<KundliTabWidget> createState() => _KundliTabWidgetState();
}

class _KundliTabWidgetState extends State<KundliTabWidget> {
  String _base = 'Lagna';

  static const _signsShort = ['Ar', 'Ta', 'Ge', 'Cn', 'Le', 'Vi', 'Li', 'Sc', 'Sg', 'Cp', 'Aq', 'Pi'];
  static const _planetOrder = ['Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter', 'Venus', 'Saturn', 'Rahu', 'Ketu'];

  Map<String, dynamic> get _planets => (widget.chart['planets'] as Map? ?? {}).cast<String, dynamic>();
  Map<String, dynamic> get _divisionals => (widget.chart['divisionals'] as Map? ?? {}).cast<String, dynamic>();
  Map<String, dynamic>? get _bhava => (widget.complete?['bhava_strength'] as Map?)?.cast<String, dynamic>();
  Map<String, dynamic>? get _shadbala => ((widget.complete?['shadbala'] as Map?)?['planets'] as Map?)?.cast<String, dynamic>();

  int get _lagnaIdx => ((_planets['Lagna'] as Map?)?['sign_idx'] as num?)?.toInt() ?? 0;

  double? _score(String p) => (_shadbala?[p]?['score_100'] as num?)?.toDouble();

  int _divIdx(String planet, int d) {
    final code = ((_divisionals[planet] as Map?)?['D$d'])?.toString();
    final i = code == null ? -1 : _signsShort.indexOf(code);
    return i < 0 ? 0 : i;
  }

  /// Build the 12-house list for the chart, per the selected base.
  List<Map<String, dynamic>> _buildHouses() {
    final isDiv = _base == 'Navamsa' || _base == 'D10';
    final d = _base == 'Navamsa' ? 9 : 10;

    int refSign;
    final byRashi = <int, List<Map<String, dynamic>>>{};
    if (!isDiv) {
      final basePlanet = (_planets[_base] as Map?)?.cast<String, dynamic>();
      refSign = (basePlanet?['sign_idx'] as num?)?.toInt() ?? 0;
      _planets.forEach((name, v) {
        if (name == 'Lagna') return;
        final p = (v as Map).cast<String, dynamic>();
        final si = (p['sign_idx'] as num?)?.toInt() ?? 0;
        byRashi.putIfAbsent(si, () => []).add({
          'planet': (p['planet_local'] ?? name),
          'degree': p['degree'],
          'dignity': p['dignity'],
          'flags': [
            if (p['vakri'] == true) 'R',
            if (p['combust'] == true) 'C',
            if (p['vargottam'] == true) 'V',
          ],
        });
      });
    } else {
      refSign = _divIdx('Lagna', d);
      for (final name in _planetOrder) {
        if (!_divisionals.containsKey(name)) continue;
        final si = _divIdx(name, d);
        final lon = ((_planets[name] as Map?)?['longitude'] as num?)?.toDouble();
        final p = (_planets[name] as Map?)?.cast<String, dynamic>();
        byRashi.putIfAbsent(si, () => []).add({
          'planet': (p?['planet_local'] ?? name),
          if (lon != null) 'degree': ((lon % 30) * d) % 30,
          'flags': [
            if (p?['vakri'] == true) 'R',
            if (p?['combust'] == true) 'C',
            if (p?['vargottam'] == true) 'V',
          ],
        });
      }
    }
    final lagnaRef = isDiv ? refSign : _lagnaIdx;
    return List.generate(12, (h) {
      final ri = (refSign + h) % 12;
      return {
        'house': h + 1,
        'rashi_idx': ri,
        'rashi_short': _signsShort[ri],
        'planets': byRashi[ri] ?? [],
        'is_lagna': ri == lagnaRef,
      };
    });
  }

  String _baseTitle(AppLocalizations l) {
    switch (_base) {
      case 'Moon': return l.moon;
      case 'Sun': return l.sun;
      case 'Navamsa': return l.kunNavamsa;
      case 'D10': return l.kunD10;
      default: return l.lagna;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return ListView(padding: const EdgeInsets.fromLTRB(16, 14, 16, 90), children: [
      // chart toggle
      _toggle(l),
      const SizedBox(height: 14),
      // chart (animated on toggle change)
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: ScaleTransition(scale: Tween(begin: 0.96, end: 1.0).animate(anim), child: child),
        ),
        child: KeyedSubtree(
          key: ValueKey(_base),
          child: NorthIndianChartWidget(houses: _buildHouses(), chartTitle: _baseTitle(l)),
        ),
      ),
      const SizedBox(height: 22),
      KSectionHeader(icon: Icons.table_rows_rounded, title: l.kunPlacement, color: KColors.blue),
      _placementTable(l),
      const SizedBox(height: 22),
      KSectionHeader(icon: Icons.home_rounded, title: l.kunHousesTitle, color: KColors.purple),
      ..._houseCards(l),
    ]);
  }

  Widget _toggle(AppLocalizations l) {
    final opts = [
      ['Lagna', l.lagna], ['Moon', l.moon], ['Sun', l.sun], ['Navamsa', l.kunNavamsa], ['D10', l.kunD10],
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: opts.map((o) {
        final sel = _base == o[0];
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(o[1]),
            selected: sel,
            showCheckmark: false,
            labelStyle: TextStyle(color: sel ? AppColors.midnight : AppColors.smoke, fontWeight: FontWeight.w700, fontSize: 12.5),
            selectedColor: AppColors.gold,
            backgroundColor: AppColors.card,
            side: BorderSide(color: AppColors.gold.withOpacity(sel ? 0 : 0.3)),
            onSelected: (_) => setState(() => _base = o[0] as String),
          ),
        );
      }).toList()),
    );
  }

  // ── Planet placement table ───────────────────────────────────────────
  Widget _placementTable(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    Widget hcell(String t, int flex) => Expanded(flex: flex, child: Text(t,
        style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w700)));
    return Container(
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
          child: Row(children: [
            hcell(l.kunPlanet, 22), hcell(l.house, 12), hcell(l.sign, 16),
            hcell(l.kunNakshatra, 26), hcell(l.plStrength, 20),
          ]),
        ),
        const Divider(height: 1),
        ..._planetOrder.where((p) => _planets.containsKey(p)).map((name) {
          final p = (_planets[name] as Map).cast<String, dynamic>();
          final si = (p['sign_idx'] as num?)?.toInt() ?? 0;
          final house = (si - _lagnaIdx) % 12 + 1;
          final score = _score(name);
          final stars = score == null ? 0 : kStars(score);
          return InkWell(
            onTap: () => _openPlanetSheet(name, p, house),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(children: [
                Expanded(flex: 22, child: Row(children: [
                  Text(_symbol(name), style: const TextStyle(fontSize: 14, color: AppColors.gold)),
                  const SizedBox(width: 6),
                  Flexible(child: Text((p['planet_local'] ?? name).toString(),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, fontWeight: FontWeight.w600))),
                ])),
                Expanded(flex: 12, child: Text('$house', style: const TextStyle(color: AppColors.parchment, fontSize: 12.5))),
                Expanded(flex: 16, child: Text(KundliNames.rashiShort(_signsShort[si], loc),
                    maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.parchment, fontSize: 12))),
                Expanded(flex: 26, child: Text('${p['nakshatra_local'] ?? p['nakshatra']} · ${p['pada']}',
                    maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11))),
                Expanded(flex: 20, child: score == null
                    ? const Text('—', style: TextStyle(color: AppColors.smoke))
                    : KStars(filled: stars, size: 11, color: KColors.forScore(score))),
              ]),
            ),
          );
        }),
      ]),
    );
  }

  // ── House cards (occupied houses) ────────────────────────────────────
  List<Widget> _houseCards(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    final bhava = _bhava;
    final cards = <Widget>[];
    for (int h = 1; h <= 12; h++) {
      final key = 'H${h.toString().padLeft(2, '0')}';
      final data = (bhava?[key] as Map?)?.cast<String, dynamic>();
      final occupants = ((data?['occupants'] as List?) ?? const []).cast<dynamic>();
      if (occupants.isEmpty) continue; // only occupied houses
      final signIdx = (data?['sign'] != null) ? _signsShort.indexOf(data!['sign'].toString()) : ((_lagnaIdx + h - 1) % 12);
      final score = (data?['score'] as num?)?.toDouble() ?? 0;
      final color = KColors.forScore(score);
      final lord = (data?['lord'] ?? '').toString();
      cards.add(KFadeIn(
        delayMs: (h * 25).clamp(0, 250),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withOpacity(0.3))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                width: 38, height: 38, alignment: Alignment.center,
                decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(11)),
                child: Text('$h', style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: 11),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${kOrdinal(h)} ${l.house} · ${KundliNames.rashiShort(_signsShort[signIdx < 0 ? 0 : signIdx], loc)}',
                    style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w800)),
                if (lord.isNotEmpty)
                  Text('${l.kunLord}: ${KundliNames.planet(lord, loc)}', style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w800)),
                Text(kStrengthLabel(score, l), style: TextStyle(color: color, fontSize: 9.5, fontWeight: FontWeight.w700)),
              ]),
            ]),
            const SizedBox(height: 10),
            Wrap(spacing: 6, runSpacing: 6, children: occupants.map<Widget>((o) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.12), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.gold.withOpacity(0.35))),
              child: Text(KundliNames.planet(o.toString(), loc), style: const TextStyle(color: AppColors.gold, fontSize: 11.5, fontWeight: FontWeight.w600)),
            )).toList()),
            const SizedBox(height: 10),
            // strength bar
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: (score / 100).clamp(0, 1)),
                duration: const Duration(milliseconds: 800), curve: Curves.easeOutCubic,
                builder: (_, v, __) => LinearProgressIndicator(value: v, minHeight: 7, backgroundColor: AppColors.ash.withOpacity(0.4), valueColor: AlwaysStoppedAnimation(color)),
              ),
            ),
            const SizedBox(height: 10),
            // meaning + AI
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(color: AppColors.twilight.withOpacity(0.35), borderRadius: BorderRadius.circular(10)),
              child: Text(
                '${l.kunHouseLine(kOrdinal(h), _houseMeaning(l, h))} '
                '${l.kunHouseOccupied(occupants.map((o) => KundliNames.planet(o.toString(), loc)).join(', '))} '
                '${_scorePhrase(l, score)}',
                style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.45),
              ),
            ),
          ]),
        ),
      ));
    }
    if (cards.isEmpty) {
      cards.add(Padding(padding: const EdgeInsets.all(16), child: Text(l.noData, style: const TextStyle(color: AppColors.textSecondary))));
    }
    return cards;
  }

  String _scorePhrase(AppLocalizations l, num s) {
    if (s >= 70) return l.sumGradePhraseExcellent;
    if (s >= 55) return l.sumGradePhraseGood;
    if (s >= 40) return l.sumGradePhraseAverage;
    return l.sumGradePhraseWeak;
  }

  String _houseMeaning(AppLocalizations l, int h) {
    switch (h) {
      case 1: return l.plHouse1; case 2: return l.plHouse2; case 3: return l.plHouse3;
      case 4: return l.plHouse4; case 5: return l.plHouse5; case 6: return l.plHouse6;
      case 7: return l.plHouse7; case 8: return l.plHouse8; case 9: return l.plHouse9;
      case 10: return l.plHouse10; case 11: return l.plHouse11; default: return l.plHouse12;
    }
  }

  // ── Planet detail sheet ──────────────────────────────────────────────
  void _openPlanetSheet(String name, Map<String, dynamic> p, int house) {
    final l = AppLocalizations.of(context)!;
    final loc = Localizations.localeOf(context);
    final si = (p['sign_idx'] as num?)?.toInt() ?? 0;
    final dignity = (p['dignity'] ?? '').toString();
    final rel = kSignRelation(name, si, dignity);
    final relColor = kRelationColor(rel);
    final score = _score(name);
    final aspects = (widget.complete?['aspect_matrix'] as Map?)?.cast<String, dynamic>();
    final given = ((aspects?['graha_drishti'] as Map?)?[name] as Map?)?.keys.toList() ?? const [];
    final recv = ((aspects?['graha_drishti_received'] as Map?)?[name] as Map?)?.keys.toList() ?? const [];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        decoration: const BoxDecoration(color: AppColors.nebula, borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 28),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 42, height: 4, decoration: BoxDecoration(color: AppColors.ash, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 14),
          Row(children: [
            Container(width: 46, height: 46, alignment: Alignment.center,
                decoration: BoxDecoration(color: relColor.withOpacity(0.16), shape: BoxShape.circle),
                child: Text(_symbol(name), style: const TextStyle(fontSize: 22, color: AppColors.ivory))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text((p['planet_local'] ?? name).toString(), style: const TextStyle(color: AppColors.ivory, fontSize: 18, fontWeight: FontWeight.w800)),
              Text('${p['sign_full_local'] ?? p['sign_full']} · ${l.house} $house · ${(p['degree'] as num?)?.toStringAsFixed(2)}°',
                  style: const TextStyle(color: AppColors.primary, fontSize: 12.5, fontWeight: FontWeight.w600)),
            ])),
            if (rel != 'neutral')
              Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(color: relColor.withOpacity(0.16), borderRadius: BorderRadius.circular(8), border: Border.all(color: relColor.withOpacity(0.5))),
                  child: Text(kRelationLabel(rel, l), style: TextStyle(color: relColor, fontSize: 11, fontWeight: FontWeight.w700))),
          ]),
          const SizedBox(height: 16),
          if (score != null) ...[
            Row(children: [
              Text('${l.plStrength}:  ', style: const TextStyle(color: AppColors.smoke, fontSize: 13)),
              KStars(filled: kStars(score), size: 15, color: KColors.forScore(score)),
              const Spacer(),
              Text('${score.toStringAsFixed(0)}% · ${kStrengthLabel(score, l)}', style: TextStyle(color: KColors.forScore(score), fontSize: 12.5, fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 12),
          ],
          _sheetRow(l.kunNakshatra, '${p['nakshatra_local'] ?? p['nakshatra']} · ${l.kunPada} ${p['pada']}'),
          _sheetRow(l.planetLongitude(''), '${(p['longitude'] as num?)?.toStringAsFixed(2)}°'),
          _sheetRow(l.plAspectsGiven, given.isEmpty ? '—' : given.map((e) => KundliNames.planet(e.toString(), loc)).join(', ')),
          _sheetRow(l.plAspectsReceived, recv.isEmpty ? '—' : recv.map((e) => KundliNames.planet(e.toString(), loc)).join(', ')),
        ]),
      ),
    );
  }

  Widget _sheetRow(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 120, child: Text(k, style: const TextStyle(color: AppColors.smoke, fontSize: 12.5))),
          Expanded(child: Text(v, style: const TextStyle(color: AppColors.parchment, fontSize: 12.5, fontWeight: FontWeight.w600))),
        ]),
      );

  String _symbol(String name) {
    const s = {'Sun': '☉', 'Moon': '☾', 'Mars': '♂', 'Mercury': '☿', 'Jupiter': '♃',
      'Venus': '♀', 'Saturn': '♄', 'Rahu': '☊', 'Ketu': '☋', 'Lagna': '↑'};
    return s[name] ?? '✦';
  }
}

// ═══════════════════════════════════════════════════════════════════════
//  ✨ Explain My Chart — client-generated beginner summary (Common UX)
// ═══════════════════════════════════════════════════════════════════════
void showExplainMyChart(BuildContext context, Map<String, dynamic> chart, Map<String, dynamic>? complete) {
  final l = AppLocalizations.of(context)!;
  final loc = Localizations.localeOf(context);
  final planets = (chart['planets'] as Map? ?? {}).cast<String, dynamic>();
  Map<String, dynamic>? pget(String n) => (planets[n] as Map?)?.cast<String, dynamic>();
  String sign(String n) => (pget(n)?['sign_full_local'] ?? pget(n)?['sign_full'] ?? '—').toString();
  final moonIdx = (pget('Moon')?['sign_idx'] as num?)?.toInt() ?? 0;

  // strongest / weakest planet
  String? strongP, weakP;
  num sv = -1, wv = 1e9;
  final sb = ((complete?['shadbala'] as Map?)?['planets'] as Map?)?.cast<String, dynamic>();
  sb?.forEach((p, v) {
    final s = ((v as Map)['score_100'] as num?)?.toDouble() ?? 0;
    if (s > sv) { sv = s; strongP = p; }
    if (s < wv) { wv = s; weakP = p; }
  });

  final bullets = <String>[
    l.kunExplainAsc(sign('Lagna')),
    l.kunExplainMoon(sign('Moon')),
    kElementNatureLine(kElementToken(moonIdx), l),
    if (strongP != null) l.kunExplainStrong(KundliNames.planet(strongP!, loc)),
    if (weakP != null && weakP != strongP) l.kunExplainWeak(KundliNames.planet(weakP!, loc)),
  ];

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.6, minChildSize: 0.4, maxChildSize: 0.9, expand: false,
      builder: (bctx, scroll) => Container(
        decoration: const BoxDecoration(color: AppColors.nebula, borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
        child: ListView(controller: scroll, padding: const EdgeInsets.fromLTRB(18, 10, 18, 28), children: [
          Center(child: Container(width: 42, height: 4, decoration: BoxDecoration(color: AppColors.ash, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 14),
          Row(children: [
            const Text('✨', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Expanded(child: Text(l.kunExplain, style: const TextStyle(color: AppColors.goldBright, fontSize: 18, fontWeight: FontWeight.w800))),
          ]),
          const SizedBox(height: 6),
          Text(l.kunExplainSubtitle, style: const TextStyle(color: AppColors.smoke, fontSize: 12)),
          const SizedBox(height: 16),
          ...bullets.map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(padding: const EdgeInsets.only(top: 2, right: 10), child: Icon(Icons.auto_awesome, size: 15, color: AppColors.lavender.withOpacity(0.9))),
                  Expanded(child: Text(b, style: const TextStyle(color: AppColors.parchment, fontSize: 13.5, height: 1.5))),
                ]),
              )),
        ]),
      ),
    ),
  );
}
