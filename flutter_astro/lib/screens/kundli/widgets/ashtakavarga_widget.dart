import 'package:flutter/material.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../services/api_service.dart';
import '../../../utils/kundli_names.dart';
import '_section_loader.dart';

/// ════════════════════════════════════════════════════════════════════
///  ASHTAKAVARGA — beginner-friendly redesign
///
///  Presentation only. All bindu/rekha values come straight from the API
///  (`sav`, `sav_total`, `planets_bav`) — no calculation is changed here.
/// ════════════════════════════════════════════════════════════════════

const List<String> _kSignsShort = [
  'Ar', 'Ta', 'Ge', 'Cn', 'Le', 'Vi', 'Li', 'Sc', 'Sg', 'Cp', 'Aq', 'Pi'
];

/// Nominal maximum used only to frame the overall SAV gauge for beginners.
const int _kSavNominalMax = 432;

// ── Strength bands + colour scale (Section 5) ──────────────────────────
enum AvBand { excellent, veryGood, good, average, weak, veryWeak }

class AvScale {
  static const Color cExcellent = Color(0xFF1E8E4A); // dark green
  static const Color cVeryGood = Color(0xFF43B05C); // green
  static const Color cGood = Color(0xFF8BC34A); // light green
  static const Color cAverage = Color(0xFFE3B23C); // yellow
  static const Color cWeak = Color(0xFFE07A3C); // orange
  static const Color cVeryWeak = Color(0xFFD95555); // red

  static Color color(AvBand b) {
    switch (b) {
      case AvBand.excellent: return cExcellent;
      case AvBand.veryGood: return cVeryGood;
      case AvBand.good: return cGood;
      case AvBand.average: return cAverage;
      case AvBand.weak: return cWeak;
      case AvBand.veryWeak: return cVeryWeak;
    }
  }

  /// Readable foreground for text sitting on the band colour.
  static Color onColor(AvBand b) =>
      (b == AvBand.good || b == AvBand.average) ? AppColors.midnight : Colors.white;

  static int stars(AvBand b) {
    switch (b) {
      case AvBand.excellent: return 5;
      case AvBand.veryGood: return 4;
      case AvBand.good: return 4;
      case AvBand.average: return 3;
      case AvBand.weak: return 2;
      case AvBand.veryWeak: return 1;
    }
  }

  static String label(AvBand b, AppLocalizations l) {
    switch (b) {
      case AvBand.excellent: return l.gradeExcellent;
      case AvBand.veryGood: return l.avVeryGood;
      case AvBand.good: return l.gradeGood;
      case AvBand.average: return l.gradeAverage;
      case AvBand.weak: return l.gradeWeak;
      case AvBand.veryWeak: return l.avVeryWeak;
    }
  }

  /// SAV per-sign band (chart average ≈ 28, typical range 19–39).
  static AvBand sav(int v) {
    if (v >= 35) return AvBand.excellent;
    if (v >= 30) return AvBand.veryGood;
    if (v >= 26) return AvBand.average;
    if (v >= 22) return AvBand.weak;
    return AvBand.veryWeak;
  }

  /// BAV per-sign band (0–8, average 4).
  static AvBand bav(int v) {
    if (v >= 7) return AvBand.excellent;
    if (v >= 6) return AvBand.veryGood;
    if (v >= 5) return AvBand.good;
    if (v == 4) return AvBand.average;
    if (v >= 2) return AvBand.weak;
    return AvBand.veryWeak;
  }
}

class AshtakavargaWidget extends StatelessWidget {
  final String chartId;
  final dynamic initial;
  const AshtakavargaWidget({super.key, required this.chartId, this.initial});

  @override
  Widget build(BuildContext context) {
    return SectionLoader(
      initial: initial is Map ? (initial as Map).cast<String, dynamic>() : null,
      loader: () => ApiService().getKundliAshtakavarga(chartId),
      builder: (ctx, data) => _AshtakavargaView(data: data),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
//  MAIN VIEW
// ═══════════════════════════════════════════════════════════════════════
class _AshtakavargaView extends StatefulWidget {
  final Map<String, dynamic> data;
  const _AshtakavargaView({required this.data});

  @override
  State<_AshtakavargaView> createState() => _AshtakavargaViewState();
}

class _AshtakavargaViewState extends State<_AshtakavargaView> {
  bool _advanced = false;
  bool _grid = true;

  static const List<String> _planetOrder = [
    'Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter', 'Venus', 'Saturn'
  ];

  Map<String, int> get _sav {
    final raw = (widget.data['sav'] as Map? ?? {}).cast<String, dynamic>();
    return {for (final s in _kSignsShort) s: (raw[s] as num?)?.toInt() ?? 0};
  }

  int get _savTotal => (widget.data['sav_total'] as num?)?.toInt() ??
      _sav.values.fold(0, (a, b) => a + b);

  double get _avg => _savTotal / 12.0;

  Map<String, dynamic> get _planetsBav =>
      (widget.data['planets_bav'] as Map? ?? {}).cast<String, dynamic>();

  Map<String, int> _bavOf(String planet) {
    final d = (_planetsBav[planet] as Map? ?? {}).cast<String, dynamic>();
    final raw = (d['bav_per_sign'] as Map? ?? {}).cast<String, dynamic>();
    return {for (final s in _kSignsShort) s: (raw[s] as num?)?.toInt() ?? 0};
  }

  /// signs sorted by SAV descending → [(code, value)]
  List<MapEntry<String, int>> get _savSorted {
    final e = _sav.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return e;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      children: [
        _controls(l),
        const SizedBox(height: 12),
        _FadeIn(delayMs: 0, child: _LegendBar(l: l)),
        const SizedBox(height: 12),
        _FadeIn(delayMs: 60, child: _summaryCard(l)),
        _FadeIn(delayMs: 120, child: _aiInsightsCard(l)),
        _FadeIn(delayMs: 180, child: _savCard(l)),
        ..._buildPlanetCards(l),
      ],
    );
  }

  // ── Top controls: Simple/Advanced (Section 8) + Info (Section 7) ──────
  Widget _controls(AppLocalizations l) {
    return Row(
      children: [
        Expanded(
          child: SegmentedButton<bool>(
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              backgroundColor: WidgetStateProperty.resolveWith((s) =>
                  s.contains(WidgetState.selected) ? AppColors.gold : AppColors.nebula),
              foregroundColor: WidgetStateProperty.resolveWith((s) =>
                  s.contains(WidgetState.selected) ? AppColors.midnight : AppColors.smoke),
              side: WidgetStatePropertyAll(BorderSide(color: AppColors.gold.withOpacity(0.3))),
            ),
            segments: [
              ButtonSegment(value: false, label: Text(l.avSimple), icon: const Icon(Icons.auto_awesome, size: 16)),
              ButtonSegment(value: true, label: Text(l.avAdvanced), icon: const Icon(Icons.tune, size: 16)),
            ],
            selected: {_advanced},
            showSelectedIcon: false,
            onSelectionChanged: (s) => setState(() => _advanced = s.first),
          ),
        ),
        const SizedBox(width: 10),
        Material(
          color: AppColors.nebula,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: AppColors.gold.withOpacity(0.3))),
          child: IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.gold),
            tooltip: l.avInfoTitle,
            onPressed: () => _openInfo(l),
          ),
        ),
      ],
    );
  }

  // ── Section 1: Summary card ──────────────────────────────────────────
  Widget _summaryCard(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    final sorted = _savSorted;
    final top = sorted.take(3).toList();
    final bottom = sorted.reversed.take(3).toList();
    final overallBand = _overallBand();
    final medals = ['🥇', '🥈', '🥉'];

    String nm(String code) => KundliNames.rashiShort(code, loc);

    return _card(
      accent: AppColors.gold,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('✨', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(child: Text(l.avSummaryTitle,
              style: const TextStyle(color: AppColors.gold, fontSize: 16, fontWeight: FontWeight.w800))),
        ]),
        const SizedBox(height: 16),
        // Overall score gauge
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(l.avOverallScore,
              style: const TextStyle(color: AppColors.smoke, fontSize: 12, fontWeight: FontWeight.w600)),
          const Spacer(),
          Hero(
            tag: 'av-overall',
            child: Material(
              color: Colors.transparent,
              child: RichText(text: TextSpan(children: [
                TextSpan(text: '$_savTotal',
                    style: const TextStyle(color: AppColors.ivory, fontSize: 26, fontWeight: FontWeight.w800)),
                TextSpan(text: '  / $_kSavNominalMax',
                    style: TextStyle(color: AppColors.smoke, fontSize: 14, fontWeight: FontWeight.w600)),
              ])),
            ),
          ),
        ]),
        const SizedBox(height: 8),
        _animBar(_savTotal / _kSavNominalMax, AvScale.color(overallBand)),
        const SizedBox(height: 10),
        Row(children: [
          Text('${l.avOverallRating}:  ',
              style: const TextStyle(color: AppColors.smoke, fontSize: 12)),
          _bandPill(overallBand, l),
        ]),
        const SizedBox(height: 18),
        // Strongest
        Text(l.avStrongestSigns,
            style: const TextStyle(color: AvScale.cVeryGood, fontSize: 12.5, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        ...List.generate(top.length, (i) => _rankRow(
              leading: medals[i],
              name: nm(top[i].key),
              value: top[i].value,
              band: AvScale.sav(top[i].value),
              l: l,
            )),
        const SizedBox(height: 14),
        // Weakest
        Text(l.avWeakestSigns,
            style: const TextStyle(color: AvScale.cWeak, fontSize: 12.5, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        ...bottom.map((e) => _rankRow(
              leading: '⚠',
              name: nm(e.key),
              value: e.value,
              band: AvScale.sav(e.value),
              l: l,
            )),
        const SizedBox(height: 14),
        // AI explanation
        _aiNote(l.avSummaryInsight(nm(top[0].key), nm(top[1].key), nm(top[2].key), nm(bottom[0].key))),
      ]),
    );
  }

  Widget _rankRow({
    required String leading,
    required String name,
    required int value,
    required AvBand band,
    required AppLocalizations l,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(children: [
        SizedBox(width: 24, child: Text(leading, style: const TextStyle(fontSize: 14))),
        Expanded(child: Text(name,
            style: const TextStyle(color: AppColors.ivory, fontSize: 13.5, fontWeight: FontWeight.w600))),
        _starRow(AvScale.stars(band), size: 12),
        const SizedBox(width: 8),
        if (_advanced)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
                color: AvScale.color(band).withOpacity(0.18),
                borderRadius: BorderRadius.circular(8)),
            child: Text('$value',
                style: TextStyle(color: AvScale.color(band), fontSize: 12.5, fontWeight: FontWeight.w800)),
          ),
      ]),
    );
  }

  AvBand _overallBand() {
    final r = _savTotal / _kSavNominalMax;
    if (r >= 0.82) return AvBand.excellent;
    if (r >= 0.74) return AvBand.veryGood;
    if (r >= 0.66) return AvBand.average;
    if (r >= 0.56) return AvBand.weak;
    return AvBand.veryWeak;
  }

  // ── Section 6: AI Insights (max 5 bullets) ───────────────────────────
  Widget _aiInsightsCard(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    final sorted = _savSorted;
    String nm(String c) => KundliNames.rashiShort(c, loc);

    // best / weakest planet by total rekha
    String? bestP, weakP;
    int bestV = -1, weakV = 1 << 30;
    for (final p in _planetOrder) {
      final d = (_planetsBav[p] as Map? ?? {}).cast<String, dynamic>();
      final t = (d['total_rekha'] as num?)?.toInt() ?? 0;
      if (t > bestV) { bestV = t; bestP = p; }
      if (t < weakV) { weakV = t; weakP = p; }
    }

    final bullets = <String>[
      l.avInsightStrong(nm(sorted[0].key), nm(sorted[1].key)),
      l.avInsightWeak(nm(sorted.last.key)),
      if (bestP != null) l.avInsightBestPlanet(KundliNames.planet(bestP, loc)),
      if (weakP != null && weakP != bestP) l.avInsightWeakPlanet(KundliNames.planet(weakP, loc)),
      l.avInsightAverage(_avg.toStringAsFixed(0)),
    ].take(5).toList();

    return _card(
      accent: AppColors.lavender,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('✨', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(child: Text(l.avWhatDoesThisMean,
              style: const TextStyle(color: AppColors.lavender, fontSize: 14.5, fontWeight: FontWeight.w800))),
        ]),
        const SizedBox(height: 12),
        ...bullets.map((b) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2, right: 8),
                  child: Icon(Icons.auto_awesome, size: 13, color: AppColors.lavender.withOpacity(0.9)),
                ),
                Expanded(child: Text(b,
                    style: const TextStyle(color: AppColors.parchment, fontSize: 12.8, height: 1.45))),
              ]),
            )),
      ]),
    );
  }

  // ── Section 2: Sarva Ashtakavarga (grid / list) ──────────────────────
  Widget _savCard(AppLocalizations l) {
    return _card(
      accent: AppColors.gold,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.grid_view_rounded, color: AppColors.gold, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(l.sarvaAshtakavarga,
              style: const TextStyle(color: AppColors.gold, fontSize: 15, fontWeight: FontWeight.w800))),
          // grid/list toggle
          _viewToggle(l),
        ]),
        const SizedBox(height: 4),
        Text(l.savSubtitle(_savTotal.toString(), _avg.toStringAsFixed(1)),
            style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
        const SizedBox(height: 14),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _grid ? _savGrid(l) : _savList(l),
        ),
      ]),
    );
  }

  Widget _viewToggle(AppLocalizations l) {
    Widget btn(bool grid, IconData ic, String tip) {
      final sel = _grid == grid;
      return InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => setState(() => _grid = grid),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: sel ? AppColors.gold.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(ic, size: 17, color: sel ? AppColors.gold : AppColors.smoke),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.cosmicVoid.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        btn(true, Icons.grid_view_rounded, l.avGrid),
        btn(false, Icons.view_list_rounded, l.avList),
      ]),
    );
  }

  Widget _savGrid(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    return Wrap(
      key: const ValueKey('grid'),
      spacing: 8,
      runSpacing: 8,
      children: _kSignsShort.map((code) {
        final v = _sav[code]!;
        final band = AvScale.sav(v);
        final c = AvScale.color(band);
        final fg = AvScale.onColor(band);
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _openSignSheet(code),
          child: Hero(
            tag: 'av-sign-$code',
            child: Material(
            color: Colors.transparent,
            child: Container(
            width: 74,
            padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 6),
            decoration: BoxDecoration(
              color: c,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: c.withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 3))],
            ),
            child: Column(children: [
              Text(KundliNames.rashiShort(code, loc),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w700)),
              const SizedBox(height: 3),
              if (_advanced)
                Text('$v', style: TextStyle(color: fg, fontSize: 20, fontWeight: FontWeight.w800, height: 1.0))
              else
                _starRow(AvScale.stars(band), size: 11, color: fg),
              const SizedBox(height: 2),
              _starOrLabel(band, l, fg),
            ]),
          ),
          ),
          ),
        );
      }).toList(),
    );
  }

  Widget _starOrLabel(AvBand band, AppLocalizations l, Color fg) {
    // In advanced mode show stars under the number; in simple mode show band label.
    if (_advanced) return _starRow(AvScale.stars(band), size: 9, color: fg);
    return Text(AvScale.label(band, l),
        maxLines: 1, overflow: TextOverflow.ellipsis,
        style: TextStyle(color: fg, fontSize: 8.5, fontWeight: FontWeight.w700));
  }

  Widget _savList(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    // sorted strong → weak for readability
    return Column(key: const ValueKey('list'), children: _savSorted.map((e) {
      final code = e.key;
      final v = e.value;
      final band = AvScale.sav(v);
      final c = AvScale.color(band);
      return InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _openSignSheet(code),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(children: [
            Container(width: 6, height: 34, decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(3))),
            const SizedBox(width: 10),
            Expanded(
              flex: 4,
              child: Text(KundliNames.rashiShort(code, loc),
                  style: const TextStyle(color: AppColors.ivory, fontSize: 13.5, fontWeight: FontWeight.w600)),
            ),
            if (_advanced)
              Container(
                width: 40,
                alignment: Alignment.center,
                child: Text('$v', style: TextStyle(color: c, fontSize: 15, fontWeight: FontWeight.w800)),
              ),
            Expanded(flex: 3, child: Center(child: _starRow(AvScale.stars(band), size: 13))),
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.centerRight,
                child: _bandPill(band, l, small: true),
              ),
            ),
          ]),
        ),
      );
    }).toList());
  }

  // ── Section 3: Planet BAV expandable cards ───────────────────────────
  List<Widget> _buildPlanetCards(AppLocalizations l) {
    final cards = <Widget>[];
    var i = 0;
    for (final p in _planetOrder) {
      if (!_planetsBav.containsKey(p)) continue;
      final d = (_planetsBav[p] as Map).cast<String, dynamic>();
      cards.add(_FadeIn(
        delayMs: 240 + i * 40,
        child: _PlanetBavCard(
          planet: p,
          data: d,
          bav: _bavOf(p),
          advanced: _advanced,
          onSignTap: _openSignSheet,
        ),
      ));
      i++;
    }
    return cards;
  }

  // ── Section 4: sign detail bottom sheet ──────────────────────────────
  void _openSignSheet(String code) {
    final l = AppLocalizations.of(context)!;
    final loc = Localizations.localeOf(context);
    final sav = _sav[code]!;
    final band = AvScale.sav(sav);
    // per-planet contributions
    final contrib = <String, int>{
      for (final p in _planetOrder) p: _bavOf(p)[code] ?? 0,
    };
    // life-area heuristic (uses only existing BAV values)
    final areas = <List<dynamic>>[
      [l.careerWord, _areaBand(contrib, const ['Sun', 'Saturn', 'Mercury'])],
      [l.avFinance, _areaBand(contrib, const ['Jupiter', 'Venus', 'Mercury'])],
      [l.lifeAreaMarriage, _areaBand(contrib, const ['Venus', 'Jupiter', 'Moon'])],
      [l.lifeHealth, _areaBand(contrib, const ['Sun', 'Mars', 'Moon'])],
      [l.educationWord, _areaBand(contrib, const ['Mercury', 'Jupiter'])],
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.68,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        expand: false,
        builder: (bctx, scroll) => Container(
          decoration: const BoxDecoration(
            color: AppColors.nebula,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          ),
          child: ListView(controller: scroll, padding: const EdgeInsets.fromLTRB(18, 10, 18, 28), children: [
            Center(child: Container(width: 42, height: 4, decoration: BoxDecoration(color: AppColors.ash, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Row(children: [
              Hero(
                tag: 'av-sign-$code',
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 54, height: 54,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: AvScale.color(band), borderRadius: BorderRadius.circular(14)),
                    child: Text('$sav', style: TextStyle(color: AvScale.onColor(band), fontSize: 22, fontWeight: FontWeight.w800)),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(KundliNames.rashiShort(code, loc),
                    style: const TextStyle(color: AppColors.ivory, fontSize: 19, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Row(children: [
                  Text('${l.avTotalSav}: ',
                      style: const TextStyle(color: AppColors.smoke, fontSize: 12)),
                  Text('$sav', style: TextStyle(color: AvScale.color(band), fontSize: 13, fontWeight: FontWeight.w800)),
                  const SizedBox(width: 8),
                  _bandPill(band, l, small: true),
                ]),
              ])),
            ]),
            const SizedBox(height: 20),
            _sheetHeading(l.avPlanetContributions),
            const SizedBox(height: 10),
            ...contrib.entries.map((e) => _contribRow(KundliNames.planet(e.key, loc), e.value)),
            const SizedBox(height: 20),
            _sheetHeading(l.avMeaning),
            const SizedBox(height: 10),
            ...areas.map((a) => _areaRow(a[0] as String, a[1] as AvBand, l)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AvScale.color(band).withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AvScale.color(band).withOpacity(0.4)),
              ),
              child: Row(children: [
                Text('${l.avOverallStrength}:  ',
                    style: const TextStyle(color: AppColors.parchment, fontSize: 13, fontWeight: FontWeight.w600)),
                _starRow(AvScale.stars(band), size: 15),
                const Spacer(),
                Text(AvScale.label(band, l),
                    style: TextStyle(color: AvScale.color(band), fontSize: 13.5, fontWeight: FontWeight.w800)),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _contribRow(String planet, int v) {
    final band = AvScale.bav(v);
    final c = AvScale.color(band);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        SizedBox(width: 84, child: Text(planet,
            style: const TextStyle(color: AppColors.parchment, fontSize: 13, fontWeight: FontWeight.w600))),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: (v / 8).clamp(0, 1)),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              builder: (_, val, __) => LinearProgressIndicator(
                value: val, minHeight: 9,
                backgroundColor: AppColors.ash.withOpacity(0.4),
                valueColor: AlwaysStoppedAnimation(c),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(width: 22, child: Text('$v',
            textAlign: TextAlign.right,
            style: TextStyle(color: c, fontSize: 13, fontWeight: FontWeight.w800))),
      ]),
    );
  }

  Widget _areaRow(String area, AvBand band, AppLocalizations l) {
    // area meaning uses a 3-level qualitative label
    final String txt;
    final Color c;
    if (band == AvBand.excellent || band == AvBand.veryGood || band == AvBand.good) {
      txt = l.avStrong; c = AvScale.cVeryGood;
    } else if (band == AvBand.average) {
      txt = l.avModerate; c = AvScale.cAverage;
    } else {
      txt = l.gradeWeak; c = AvScale.cWeak;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Expanded(child: Text(area,
            style: const TextStyle(color: AppColors.parchment, fontSize: 13))),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(color: c.withOpacity(0.18), borderRadius: BorderRadius.circular(20)),
          child: Text(txt, style: TextStyle(color: c, fontSize: 11.5, fontWeight: FontWeight.w700)),
        ),
      ]),
    );
  }

  /// Qualitative band for a life area from its significator planets' bindus.
  AvBand _areaBand(Map<String, int> contrib, List<String> planets) {
    var sum = 0;
    for (final p in planets) { sum += contrib[p] ?? 0; }
    final ratio = sum / (planets.length * 8);
    if (ratio >= 0.62) return AvBand.excellent;
    if (ratio >= 0.50) return AvBand.veryGood;
    if (ratio >= 0.42) return AvBand.average;
    return AvBand.weak;
  }

  Widget _sheetHeading(String t) => Text(t,
      style: const TextStyle(color: AppColors.gold, fontSize: 13.5, fontWeight: FontWeight.w800, letterSpacing: 0.3));

  // ── Section 7: Info sheet ────────────────────────────────────────────
  void _openInfo(AppLocalizations l) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (bctx, scroll) => Container(
          decoration: const BoxDecoration(
            color: AppColors.nebula,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          ),
          child: ListView(controller: scroll, padding: const EdgeInsets.fromLTRB(18, 10, 18, 28), children: [
            Center(child: Container(width: 42, height: 4, decoration: BoxDecoration(color: AppColors.ash, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 14),
            Row(children: [
              const Icon(Icons.auto_stories, color: AppColors.gold, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(l.avInfoTitle,
                  style: const TextStyle(color: AppColors.gold, fontSize: 17, fontWeight: FontWeight.w800))),
            ]),
            const SizedBox(height: 16),
            _InfoTile(q: l.avQWhatIsAv, a: l.avABody),
            _InfoTile(q: l.avQWhatIsSav, a: l.avSavBody),
            _InfoTile(q: l.avQWhatIsBav, a: l.avBavBody),
            _InfoTile(q: l.avQHowToRead, a: l.avHowToReadBody),
            _InfoTile(q: l.avQSavVsBav, a: l.avSavVsBavBody),
          ]),
        ),
      ),
    );
  }

  // ── shared bits ──────────────────────────────────────────────────────
  Widget _card({required Widget child, required Color accent}) => Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accent.withOpacity(0.22)),
        ),
        child: child,
      );

  Widget _aiNote(String text) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.twilight.withOpacity(0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.lavender.withOpacity(0.25)),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Padding(padding: EdgeInsets.only(top: 1, right: 8), child: Text('🔮', style: TextStyle(fontSize: 14))),
          Expanded(child: Text(text,
              style: const TextStyle(color: AppColors.parchment, fontSize: 12.5, height: 1.5))),
        ]),
      );

  Widget _bandPill(AvBand band, AppLocalizations l, {bool small = false}) {
    final c = AvScale.color(band);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: small ? 8 : 10, vertical: small ? 2 : 4),
      decoration: BoxDecoration(color: c.withOpacity(0.18), borderRadius: BorderRadius.circular(20), border: Border.all(color: c.withOpacity(0.5))),
      child: Text(AvScale.label(band, l),
          maxLines: 1, overflow: TextOverflow.ellipsis,
          style: TextStyle(color: c, fontSize: small ? 10.5 : 12, fontWeight: FontWeight.w700)),
    );
  }

  Widget _starRow(int filled, {double size = 13, Color color = AppColors.gold}) {
    return Row(mainAxisSize: MainAxisSize.min, children: List.generate(5, (i) =>
        Icon(i < filled ? Icons.star_rounded : Icons.star_outline_rounded, size: size, color: color)));
  }

  Widget _animBar(double value, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: value.clamp(0, 1)),
        duration: const Duration(milliseconds: 950),
        curve: Curves.easeOutCubic,
        builder: (_, v, __) => LinearProgressIndicator(
          value: v, minHeight: 12,
          backgroundColor: AppColors.ash.withOpacity(0.4),
          valueColor: AlwaysStoppedAnimation(color),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
//  Section 5: colour-scale legend
// ═══════════════════════════════════════════════════════════════════════
class _LegendBar extends StatelessWidget {
  final AppLocalizations l;
  const _LegendBar({required this.l});

  @override
  Widget build(BuildContext context) {
    final items = [
      [AvScale.cExcellent, l.gradeExcellent],
      [AvScale.cVeryGood, l.avVeryGood],
      [AvScale.cGood, l.gradeGood],
      [AvScale.cAverage, l.gradeAverage],
      [AvScale.cWeak, l.gradeWeak],
      [AvScale.cVeryWeak, l.avVeryWeak],
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Wrap(
        spacing: 12, runSpacing: 8, alignment: WrapAlignment.center,
        children: items.map((it) => Row(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: it[0] as Color, borderRadius: BorderRadius.circular(3))),
          const SizedBox(width: 5),
          Text(it[1] as String, style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w600)),
        ])).toList(),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
//  Section 3: expandable planet BAV card
// ═══════════════════════════════════════════════════════════════════════
class _PlanetBavCard extends StatefulWidget {
  final String planet;
  final Map<String, dynamic> data;
  final Map<String, int> bav;
  final bool advanced;
  final void Function(String code) onSignTap;

  const _PlanetBavCard({
    required this.planet,
    required this.data,
    required this.bav,
    required this.advanced,
    required this.onSignTap,
  });

  @override
  State<_PlanetBavCard> createState() => _PlanetBavCardState();
}

class _PlanetBavCardState extends State<_PlanetBavCard> {
  bool _open = false;

  static const List<String> _signs = _kSignsShort;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final loc = Localizations.localeOf(context);
    final total = (widget.data['total_rekha'] as num?)?.toInt() ?? 0;
    final natal = (widget.data['natal_sign_score'] as num?)?.toInt() ?? 0;
    final planetName = KundliNames.planet(widget.planet, loc);

    final sorted = widget.bav.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final best = sorted.take(3).toList();
    final weak = sorted.reversed.where((e) => e.value <= 2).take(3).toList();

    String nm(String c) => KundliNames.rashiShort(c, loc);

    // overall band for a planet total (max ~56); frame against 48 typical
    final overallBand = _planetBand(total);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withOpacity(0.18)),
      ),
      child: Column(children: [
        // header (tap to expand)
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => setState(() => _open = !_open),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Container(
                width: 40, height: 40, alignment: Alignment.center,
                decoration: BoxDecoration(color: AvScale.color(overallBand).withOpacity(0.18), shape: BoxShape.circle),
                child: Text(_glyph(widget.planet), style: const TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l.ashtakavargaBav(planetName),
                    style: const TextStyle(color: AppColors.ivory, fontSize: 14.5, fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Row(children: [
                  Text('${l.avOverallScoreShort}: ',
                      style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
                  Text('$total', style: TextStyle(color: AvScale.color(overallBand), fontSize: 13, fontWeight: FontWeight.w800)),
                  if (widget.advanced) ...[
                    const SizedBox(width: 10),
                    Text('${l.avNatalSignScore}: ',
                        style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
                    Text('$natal', style: const TextStyle(color: AppColors.parchment, fontSize: 12, fontWeight: FontWeight.w700)),
                  ],
                ]),
              ])),
              AnimatedRotation(
                turns: _open ? 0.5 : 0,
                duration: const Duration(milliseconds: 250),
                child: const Icon(Icons.expand_more, color: AppColors.gold),
              ),
            ]),
          ),
        ),
        // body
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity, height: 0),
          secondChild: Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Divider(height: 1),
              const SizedBox(height: 12),
              // best signs
              _miniHeading(l.avBestSigns, AvScale.cVeryGood),
              const SizedBox(height: 6),
              Wrap(spacing: 8, runSpacing: 8, children: best.map((e) =>
                  _signChip(nm(e.key), e.value, AvScale.bav(e.value), () => widget.onSignTap(e.key))).toList()),
              if (weak.isNotEmpty) ...[
                const SizedBox(height: 12),
                _miniHeading(l.avWeakSigns, AvScale.cWeak),
                const SizedBox(height: 6),
                Wrap(spacing: 8, runSpacing: 8, children: weak.map((e) =>
                    _signChip(nm(e.key), e.value, AvScale.bav(e.value), () => widget.onSignTap(e.key))).toList()),
              ],
              // advanced: full per-sign grid with rekhas
              if (widget.advanced) ...[
                const SizedBox(height: 14),
                Wrap(spacing: 6, runSpacing: 6, children: _signs.map((code) {
                  final v = widget.bav[code]!;
                  final band = AvScale.bav(v);
                  final c = AvScale.color(band);
                  final fg = AvScale.onColor(band);
                  return GestureDetector(
                    onTap: () => widget.onSignTap(code),
                    child: Container(
                      width: 48, padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(8)),
                      child: Column(children: [
                        Text(nm(code), maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: fg, fontSize: 9.5, fontWeight: FontWeight.w600)),
                        Text('$v', style: TextStyle(color: fg, fontSize: 14, fontWeight: FontWeight.w800)),
                      ]),
                    ),
                  );
                }).toList()),
              ],
              const SizedBox(height: 14),
              // AI interpretation
              _miniHeading(l.avAiInterpretation, AppColors.lavender),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: AppColors.twilight.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.lavender.withOpacity(0.22)),
                ),
                child: Text(
                  l.avBavInsight(planetName,
                      best.isNotEmpty ? nm(best[0].key) : '',
                      best.length > 1 ? nm(best[1].key) : ''),
                  style: const TextStyle(color: AppColors.parchment, fontSize: 12.3, height: 1.45),
                ),
              ),
            ]),
          ),
          crossFadeState: _open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 260),
          sizeCurve: Curves.easeInOut,
        ),
      ]),
    );
  }

  AvBand _planetBand(int total) {
    // frame planet totals (typical 39–58) into bands
    if (total >= 54) return AvBand.excellent;
    if (total >= 49) return AvBand.veryGood;
    if (total >= 44) return AvBand.average;
    if (total >= 40) return AvBand.weak;
    return AvBand.veryWeak;
  }

  Widget _miniHeading(String t, Color c) => Text(t,
      style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 0.2));

  Widget _signChip(String name, int v, AvBand band, VoidCallback onTap) {
    final c = AvScale.color(band);
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
        decoration: BoxDecoration(
          color: c.withOpacity(0.16),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: c.withOpacity(0.45)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(name, style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, fontWeight: FontWeight.w600)),
          const SizedBox(width: 6),
          Text('($v)', style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w800)),
        ]),
      ),
    );
  }

  String _glyph(String p) {
    switch (p) {
      case 'Sun': return '☀';
      case 'Moon': return '☾';
      case 'Mars': return '♂';
      case 'Mercury': return '☿';
      case 'Jupiter': return '♃';
      case 'Venus': return '♀';
      case 'Saturn': return '♄';
      default: return '★';
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════
//  Info Q&A tile (Section 7)
// ═══════════════════════════════════════════════════════════════════════
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
      decoration: BoxDecoration(
        color: AppColors.twilight.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: [
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => setState(() => _open = !_open),
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Row(children: [
              Expanded(child: Text(widget.q,
                  style: const TextStyle(color: AppColors.ivory, fontSize: 13.5, fontWeight: FontWeight.w700))),
              AnimatedRotation(
                turns: _open ? 0.5 : 0,
                duration: const Duration(milliseconds: 220),
                child: const Icon(Icons.expand_more, color: AppColors.gold, size: 20),
              ),
            ]),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity, height: 0),
          secondChild: Padding(
            padding: const EdgeInsets.fromLTRB(13, 0, 13, 13),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(widget.a,
                  style: const TextStyle(color: AppColors.parchment, fontSize: 12.5, height: 1.5)),
            ),
          ),
          crossFadeState: _open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 240),
        ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
//  Section 9: staggered fade-in wrapper
// ═══════════════════════════════════════════════════════════════════════
class _FadeIn extends StatefulWidget {
  final Widget child;
  final int delayMs;
  const _FadeIn({required this.child, this.delayMs = 0});
  @override
  State<_FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<_FadeIn> with SingleTickerProviderStateMixin {
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
        return Opacity(
          opacity: _c.value,
          child: Transform.translate(offset: Offset(0, (1 - t) * 16), child: child),
        );
      },
      child: widget.child,
    );
  }
}
