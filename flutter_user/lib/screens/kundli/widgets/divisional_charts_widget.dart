import 'package:flutter/material.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/kundli_names.dart';
import 'north_indian_chart.dart';
import 'kundli_ui.dart';

/// Redesigned Divisional Charts (D1–D60) — grouped categories, importance
/// badges, goal-based + chart-driven smart recommendations, search,
/// beginner/advanced modes and a richer chart detail screen.
///
/// Presentation only. [divisionalsMap] (sign per planet per varga) and
/// [planetsMap] (D1 data) come from the chart; [complete] is the prefetched
/// /analysis/complete bundle used only to rank recommendations. No astrology
/// calculation is changed.
class DivisionalChartsWidget extends StatefulWidget {
  final String chartId;
  final Map<String, dynamic> divisionalsMap;
  final Map<String, dynamic> planetsMap;
  final Map<String, dynamic>? complete;

  const DivisionalChartsWidget({
    super.key,
    required this.chartId,
    required this.divisionalsMap,
    this.planetsMap = const {},
    this.complete,
  });

  @override
  State<DivisionalChartsWidget> createState() => _DivisionalChartsWidgetState();
}

class _DivisionalChartsWidgetState extends State<DivisionalChartsWidget> {
  bool _advanced = false;
  String _query = '';
  String? _goal;

  static const _charts = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 16, 20, 24, 27, 30, 40, 45, 60];
  static const _planetOrder = ['Lagna', 'Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter', 'Venus', 'Saturn', 'Rahu', 'Ketu'];
  static const _signShortList = ['Ar', 'Ta', 'Ge', 'Cn', 'Le', 'Vi', 'Li', 'Sc', 'Sg', 'Cp', 'Aq', 'Pi'];

  // category + importance metadata (fixed Vedic significance)
  static const Map<int, String> _cat = {
    1: 'ess', 2: 'ess', 7: 'ess', 9: 'ess', 10: 'ess',
    4: 'per', 12: 'per', 16: 'per', 20: 'per',
    24: 'kno', 27: 'kno', 40: 'kno', 45: 'kno',
    30: 'adv', 60: 'adv', 3: 'adv', 5: 'adv', 6: 'adv', 8: 'adv', 11: 'adv',
  };
  static const Map<int, int> _stars = {
    1: 5, 9: 5, 10: 5, 60: 5, 2: 4, 4: 4, 7: 4, 12: 4, 24: 4,
    3: 3, 11: 3, 16: 3, 20: 3, 27: 3, 30: 3, 40: 3, 45: 3, 5: 2, 6: 2, 8: 2,
  };
  static const Map<String, List<int>> _goalCharts = {
    'career': [10, 24, 27, 9], 'wealth': [2, 11, 9], 'marriage': [9, 7, 12],
    'children': [7, 9], 'property': [4, 16], 'spiritual': [20, 60], 'karma': [30, 40, 45, 60],
  };
  static const Map<int, int> _houseChart = {10: 10, 7: 9, 4: 4, 5: 7, 9: 20, 2: 2, 1: 1};
  static const Map<String, List<int>> _planetCharts = {
    'Venus': [9, 16], 'Sun': [10, 24], 'Saturn': [10, 24], 'Jupiter': [9, 24],
    'Moon': [4, 9], 'Mars': [6, 3], 'Mercury': [24, 10], 'Rahu': [30, 60], 'Ketu': [20, 60],
  };
  static const _catOrder = ['ess', 'per', 'kno', 'adv'];

  // ── name / purpose (localized) ──
  List<String> _meta(AppLocalizations l, int d) {
    switch (d) {
      case 1: return [l.divD1Name, l.divD1Desc]; case 2: return [l.divD2Name, l.divD2Desc];
      case 3: return [l.divD3Name, l.divD3Desc]; case 4: return [l.divD4Name, l.divD4Desc];
      case 5: return [l.divD5Name, l.divD5Desc]; case 6: return [l.divD6Name, l.divD6Desc];
      case 7: return [l.divD7Name, l.divD7Desc]; case 8: return [l.divD8Name, l.divD8Desc];
      case 9: return [l.divD9Name, l.divD9Desc]; case 10: return [l.divD10Name, l.divD10Desc];
      case 11: return [l.divD11Name, l.divD11Desc]; case 12: return [l.divD12Name, l.divD12Desc];
      case 16: return [l.divD16Name, l.divD16Desc]; case 20: return [l.divD20Name, l.divD20Desc];
      case 24: return [l.divD24Name, l.divD24Desc]; case 27: return [l.divD27Name, l.divD27Desc];
      case 30: return [l.divD30Name, l.divD30Desc]; case 40: return [l.divD40Name, l.divD40Desc];
      case 45: return [l.divD45Name, l.divD45Desc]; default: return [l.divD60Name, l.divD60Desc];
    }
  }

  Color _badgeColor(int stars) {
    switch (stars) {
      case 5: return KColors.gold;
      case 4: return KColors.green;
      case 3: return KColors.blue;
      case 2: return KColors.yellow;
      default: return AppColors.smoke;
    }
  }

  String _badgeLabel(int stars, AppLocalizations l) {
    switch (stars) {
      case 5: return l.divBadgeHighlyRec;
      case 4: return l.divBadgeRec;
      case 3: return l.divBadgeUseful;
      case 2: return l.divBadgeOptional;
      default: return l.divBadgeAdvOnly;
    }
  }

  String _catTitle(String c, AppLocalizations l) {
    switch (c) {
      case 'ess': return l.divCatEssential;
      case 'per': return l.divCatPersonal;
      case 'kno': return l.divCatKnowledge;
      default: return l.divCatAdvanced;
    }
  }

  String _catEmoji(String c) => c == 'ess' ? '⭐' : c == 'per' ? '📚' : c == 'kno' ? '🎓' : '🕉️';

  // ── recommendations from the complete bundle ──
  /// returns list of {d, reasonKind, reasonArg}
  List<Map<String, dynamic>> _recommendations(AppLocalizations l, Locale loc) {
    final recs = <int, Map<String, dynamic>>{};
    final c = widget.complete;
    if (c == null) return const [];
    // weakest house → chart
    final bhava = (c['bhava_strength'] as Map?)?.cast<String, dynamic>();
    if (bhava != null) {
      int? wh; double ws = 1e9;
      for (int h = 1; h <= 12; h++) {
        final s = ((bhava['H${h.toString().padLeft(2, '0')}'] as Map?)?['score'] as num?)?.toDouble();
        if (s != null && s < ws && _houseChart.containsKey(h)) { ws = s; wh = h; }
      }
      if (wh != null) {
        final d = _houseChart[wh]!;
        recs[d] = {'d': d, 'kind': 'house', 'arg': wh};
      }
    }
    // weakest planet → chart
    final sb = ((c['shadbala'] as Map?)?['planets'] as Map?)?.cast<String, dynamic>();
    if (sb != null) {
      String? wp; double ws = 1e9;
      sb.forEach((p, v) { final s = ((v as Map)['score_100'] as num?)?.toDouble() ?? 0; if (s < ws) { ws = s; wp = p; } });
      if (wp != null && _planetCharts.containsKey(wp)) {
        final d = _planetCharts[wp]!.first;
        recs.putIfAbsent(d, () => {'d': d, 'kind': 'planet', 'arg': wp});
      }
    }
    // current Mahadasha planet → chart
    final md = _currentMd();
    if (md != null && _planetCharts.containsKey(md)) {
      for (final d in _planetCharts[md]!) {
        recs.putIfAbsent(d, () => {'d': d, 'kind': 'dasha', 'arg': md});
      }
    }
    // always ensure the two flagship charts appear
    for (final d in [9, 10]) {
      recs.putIfAbsent(d, () => {'d': d, 'kind': 'flagship', 'arg': null});
    }
    final list = recs.values.toList()..sort((a, b) => (_stars[b['d']] ?? 0).compareTo(_stars[a['d']] ?? 0));
    return list.take(4).toList();
  }

  String? _currentMd() {
    try {
      final dashas = ((widget.complete?['vimshottari'] as Map?)?['dashas'] as List?) ?? const [];
      final now = DateTime.now();
      for (final d in dashas) {
        final m = (d as Map).cast<String, dynamic>();
        final s = _parseDate(m['start']?.toString()), e = _parseDate(m['end']?.toString());
        if (s != null && e != null && !now.isBefore(s) && now.isBefore(e)) return m['planet']?.toString();
      }
    } catch (_) {}
    return null;
  }

  DateTime? _parseDate(String? s) {
    if (s == null || s.isEmpty) return null;
    final p = s.split('/');
    if (p.length == 3) {
      final d = int.tryParse(p[0]), m = int.tryParse(p[1]), y = int.tryParse(p[2]);
      if (d != null && m != null && y != null) return DateTime(y, m, d);
    }
    return DateTime.tryParse(s);
  }

  String _recReason(AppLocalizations l, Locale loc, Map<String, dynamic> r) {
    switch (r['kind']) {
      case 'house': return l.divRecReasonHouse('${kOrdinal(r['arg'] as int)}');
      case 'planet': return l.divRecReasonPlanet(KundliNames.planet(r['arg'].toString(), loc));
      case 'dasha': return l.divRecReasonDasha(KundliNames.planet(r['arg'].toString(), loc));
      default: return l.divAiUse(_meta(l, r['d'] as int)[1]);
    }
  }

  bool _matches(AppLocalizations l, int d) {
    final q = _query.trim().toLowerCase();
    if (_goal != null && !( (_goalCharts[_goal] ?? const []).contains(d))) return false;
    if (q.isEmpty) return true;
    // match goal keyword → charts
    for (final g in _goalCharts.keys) {
      if (g.contains(q) && _goalCharts[g]!.contains(d)) return true;
    }
    final m = _meta(l, d);
    return 'd$d'.contains(q) || m[0].toLowerCase().contains(q) || m[1].toLowerCase().contains(q);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final loc = Localizations.localeOf(context);
    if (widget.divisionalsMap.isEmpty) {
      return Center(child: Text(l.noData, style: const TextStyle(color: AppColors.textSecondary)));
    }
    final recs = _recommendations(l, loc);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: recs.isEmpty ? null : FloatingActionButton.extended(
        backgroundColor: AppColors.gold, foregroundColor: AppColors.midnight,
        icon: const Text('✨', style: TextStyle(fontSize: 15)),
        label: Text(l.divRecommendBest, style: const TextStyle(fontWeight: FontWeight.w800)),
        onPressed: () => _showRecSheet(l, loc, recs),
      ),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 12, 16, 90), children: [
        _controls(l),
        const SizedBox(height: 12),
        KFadeIn(child: _searchField(l)),
        const SizedBox(height: 14),
        KFadeIn(delayMs: 60, child: _hero(l)),
        if (recs.isNotEmpty) ...[
          const SizedBox(height: 18),
          KFadeIn(delayMs: 100, child: KSectionHeader(icon: Icons.target_outlined, title: l.divRecommendedForYou, color: KColors.gold)),
          ...recs.map((r) => KFadeIn(delayMs: 120, child: _recCard(l, loc, r))),
        ],
        const SizedBox(height: 18),
        KFadeIn(delayMs: 140, child: _goalChips(l)),
        const SizedBox(height: 10),
        ..._grouped(l, loc),
      ]),
    );
  }

  Widget _controls(AppLocalizations l) => Row(children: [
        Expanded(child: SegmentedButton<bool>(
          style: ButtonStyle(
            visualDensity: VisualDensity.compact,
            backgroundColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? AppColors.gold : AppColors.nebula),
            foregroundColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? AppColors.midnight : AppColors.smoke),
            side: WidgetStatePropertyAll(BorderSide(color: AppColors.gold.withOpacity(0.3))),
          ),
          segments: [
            ButtonSegment(value: false, label: Text(l.divBeginner), icon: const Icon(Icons.auto_awesome, size: 15)),
            ButtonSegment(value: true, label: Text(l.avAdvanced), icon: const Icon(Icons.tune, size: 15)),
          ],
          selected: {_advanced}, showSelectedIcon: false,
          onSelectionChanged: (s) => setState(() => _advanced = s.first),
        )),
      ]);

  Widget _searchField(AppLocalizations l) => TextField(
        onChanged: (v) => setState(() => _query = v),
        style: const TextStyle(color: AppColors.ivory, fontSize: 14),
        decoration: InputDecoration(
          isDense: true, hintText: l.divSearchHint,
          prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.smoke),
          suffixIcon: _query.isEmpty ? null : IconButton(icon: const Icon(Icons.close, size: 18, color: AppColors.smoke), onPressed: () => setState(() => _query = '')),
        ),
      );

  Widget _hero(AppLocalizations l) {
    final important = [1, 9, 10, 7, 2, 24];
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF2A2358), Color(0xFF1A1642)]),
        borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.gold.withOpacity(0.3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('✨', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(child: Text(l.divSummaryTitle, style: const TextStyle(color: AppColors.goldBright, fontSize: 16.5, fontWeight: FontWeight.w800))),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          Text('${l.divTotalCharts}: ', style: const TextStyle(color: AppColors.smoke, fontSize: 12)),
          Text('${_charts.length}', style: const TextStyle(color: AppColors.ivory, fontSize: 16, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 12),
        Text(l.divMostImportant.toUpperCase(), style: const TextStyle(color: AppColors.smoke, fontSize: 9.5, letterSpacing: 0.5, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Wrap(spacing: 8, runSpacing: 8, children: important.map((d) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.14), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.gold.withOpacity(0.4))),
          child: Text('D$d', style: const TextStyle(color: AppColors.goldBright, fontSize: 12, fontWeight: FontWeight.w800)),
        )).toList()),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.18), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.lavender.withOpacity(0.25))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(padding: EdgeInsets.only(top: 1, right: 8), child: Text('🔮', style: TextStyle(fontSize: 14))),
            Expanded(child: Text(l.divHeroSummary(l.divD9Name, l.divD10Name), style: const TextStyle(color: AppColors.parchment, fontSize: 12.8, height: 1.5))),
          ]),
        ),
      ]),
    );
  }

  Widget _recCard(AppLocalizations l, Locale loc, Map<String, dynamic> r) {
    final d = r['d'] as int;
    final m = _meta(l, d);
    final stars = _stars[d] ?? 3;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _openDetail(l, loc, d),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.gold.withOpacity(0.35))),
        child: Row(children: [
          Container(width: 44, height: 44, alignment: Alignment.center,
              decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.16), borderRadius: BorderRadius.circular(12)),
              child: Text('D$d', style: const TextStyle(color: AppColors.goldBright, fontSize: 14, fontWeight: FontWeight.w800))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Flexible(child: Text(m[0], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w800))),
              const SizedBox(width: 6),
              KStars(filled: stars, size: 11),
            ]),
            const SizedBox(height: 3),
            Text(_recReason(l, loc, r), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.35)),
          ])),
          const Icon(Icons.chevron_right, color: AppColors.smoke, size: 20),
        ]),
      ),
    );
  }

  Widget _goalChips(AppLocalizations l) {
    final goals = [
      ['career', '💼', l.careerWord], ['wealth', '💰', l.avFinance], ['marriage', '❤️', l.lifeAreaMarriage],
      ['children', '👶', l.doshAreaChildren], ['property', '🏠', l.divGoalProperty], ['spiritual', '🧘', l.sumSpirituality],
      ['karma', '⚠️', l.divGoalKarma],
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: goals.map((g) {
        final sel = _goal == g[0];
        return Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(
          label: Text('${g[1]} ${g[2]}'), selected: sel, showCheckmark: false,
          labelStyle: TextStyle(color: sel ? AppColors.midnight : AppColors.smoke, fontWeight: FontWeight.w700, fontSize: 12),
          selectedColor: AppColors.gold, backgroundColor: AppColors.card,
          side: BorderSide(color: AppColors.gold.withOpacity(sel ? 0 : 0.3)),
          onSelected: (v) => setState(() => _goal = v ? g[0] as String : null),
        ));
      }).toList()),
    );
  }

  List<Widget> _grouped(AppLocalizations l, Locale loc) {
    final out = <Widget>[];
    var any = false;
    for (final cat in _catOrder) {
      final ds = _charts.where((d) => _cat[d] == cat && _matches(l, d)).toList()
        ..sort((a, b) => (_stars[b] ?? 0).compareTo(_stars[a] ?? 0));
      if (ds.isEmpty) continue;
      any = true;
      out.add(Padding(padding: const EdgeInsets.only(top: 12, bottom: 4),
          child: Row(children: [
            Text(_catEmoji(cat), style: const TextStyle(fontSize: 15)),
            const SizedBox(width: 8),
            Text(_catTitle(cat, l), style: const TextStyle(color: AppColors.ivory, fontSize: 14.5, fontWeight: FontWeight.w800)),
          ])));
      out.addAll(ds.map((d) => KFadeIn(child: _card(l, loc, d))));
    }
    if (!any) out.add(Padding(padding: const EdgeInsets.all(24), child: Center(child: Text(l.divNoMatch, style: const TextStyle(color: AppColors.textSecondary)))));
    return out;
  }

  Widget _card(AppLocalizations l, Locale loc, int d) {
    final m = _meta(l, d);
    final stars = _stars[d] ?? 3;
    final bColor = _badgeColor(stars);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _openDetail(l, loc, d),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: bColor.withOpacity(0.3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Tooltip(
              message: m[1], triggerMode: TooltipTriggerMode.tap, showDuration: const Duration(seconds: 4), preferBelow: false,
              decoration: BoxDecoration(color: AppColors.twilight, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.gold.withOpacity(0.4))),
              textStyle: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.4),
              child: Container(width: 40, height: 40, alignment: Alignment.center,
                  decoration: BoxDecoration(color: bColor.withOpacity(0.16), borderRadius: BorderRadius.circular(11)),
                  child: Text('D$d', style: TextStyle(color: bColor, fontSize: 13.5, fontWeight: FontWeight.w800))),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(m[0], style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Row(children: [KStars(filled: stars, size: 12, color: bColor)]),
            ])),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: bColor.withOpacity(0.16), borderRadius: BorderRadius.circular(7), border: Border.all(color: bColor.withOpacity(0.4))),
                child: Text(_badgeLabel(stars, l), style: TextStyle(color: bColor, fontSize: 9.5, fontWeight: FontWeight.w700))),
          ]),
          const SizedBox(height: 8),
          Text(l.divAiUse(m[1]), style: const TextStyle(color: AppColors.parchment, fontSize: 11.8, height: 1.4)),
        ]),
      ),
    );
  }

  // ── goal chart list for the chart's life areas ──
  List<String> _lifeAreasFor(int d, AppLocalizations l) {
    final areas = <String>[];
    _goalCharts.forEach((goal, charts) {
      if (charts.contains(d)) {
        final label = goal == 'career' ? l.careerWord : goal == 'wealth' ? l.avFinance : goal == 'marriage' ? l.lifeAreaMarriage
            : goal == 'children' ? l.doshAreaChildren : goal == 'property' ? l.divGoalProperty : goal == 'spiritual' ? l.sumSpirituality : l.divGoalKarma;
        if (!areas.contains(label)) areas.add(label);
      }
    });
    return areas;
  }

  // ── detail screen ──
  void _openDetail(AppLocalizations l, Locale loc, int d) {
    final m = _meta(l, d);
    final dKey = 'D$d';
    final signsByPlanet = <String, String>{};
    for (final p in _planetOrder) {
      final pm = widget.divisionalsMap[p];
      if (pm is Map && pm[dKey] != null) signsByPlanet[p] = pm[dKey].toString();
    }
    final houses = _buildVargaHouses(d, signsByPlanet, loc);
    final areas = _lifeAreasFor(d, l);

    Navigator.push(context, MaterialPageRoute(builder: (_) => Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        Text(m[0], style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
        Text('D$d · ${m[1]}', style: const TextStyle(color: AppColors.primary, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
      ])),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        // hero
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF2A2358), Color(0xFF1A1642)]), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.gold.withOpacity(0.3))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(width: 40, height: 40, alignment: Alignment.center, decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.16), borderRadius: BorderRadius.circular(11)),
                  child: Text('D$d', style: const TextStyle(color: AppColors.goldBright, fontSize: 13, fontWeight: FontWeight.w800))),
              const SizedBox(width: 10),
              Expanded(child: Text(m[0], style: const TextStyle(color: AppColors.ivory, fontSize: 16, fontWeight: FontWeight.w800))),
              KStars(filled: _stars[d] ?? 3, size: 14),
            ]),
            const SizedBox(height: 10),
            Text(l.divWhenToUseLine(m[1]), style: const TextStyle(color: AppColors.parchment, fontSize: 12.5, height: 1.45)),
            if (areas.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(l.divLifeAreas.toUpperCase(), style: const TextStyle(color: AppColors.smoke, fontSize: 9.5, letterSpacing: 0.5, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Wrap(spacing: 6, runSpacing: 6, children: areas.map((a) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.12), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.gold.withOpacity(0.3))),
                child: Text(a, style: const TextStyle(color: AppColors.goldBright, fontSize: 11, fontWeight: FontWeight.w600)),
              )).toList()),
            ],
          ]),
        ),
        const SizedBox(height: 16),
        NorthIndianChartWidget(houses: houses, chartTitle: 'D-$d'),
        const SizedBox(height: 16),
        // AI summary
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.twilight.withOpacity(0.4), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.lavender.withOpacity(0.25))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(padding: EdgeInsets.only(top: 1, right: 8), child: Text('🔮', style: TextStyle(fontSize: 14))),
            Expanded(child: Text(l.divAiUse(m[1]), style: const TextStyle(color: AppColors.parchment, fontSize: 12.5, height: 1.45))),
          ]),
        ),
        // advanced: planet positions table
        if (_advanced) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.planetPositions, style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              ...signsByPlanet.entries.map((e) => Padding(padding: const EdgeInsets.symmetric(vertical: 3), child: Row(children: [
                SizedBox(width: 80, child: Text(KundliNames.planet(e.key, loc), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12))),
                Text(KundliNames.rashiShort(e.value, loc), style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
              ]))),
            ]),
          ),
        ],
      ]),
    )));
  }

  List<Map<String, dynamic>> _buildVargaHouses(int d, Map<String, String> signsByPlanet, Locale loc) {
    final lagnaSignIdx = _signShortList.indexOf(signsByPlanet['Lagna'] ?? 'Ar');
    final base = lagnaSignIdx < 0 ? 0 : lagnaSignIdx;
    final byRashi = <int, List<Map<String, dynamic>>>{};
    signsByPlanet.forEach((planet, sign) {
      if (planet == 'Lagna') return;
      final si = _signShortList.indexOf(sign);
      if (si < 0) return;
      final p = (widget.planetsMap[planet] as Map?)?.cast<String, dynamic>();
      num? vargaDeg;
      final flags = <String>[];
      if (p != null) {
        final lon = (p['longitude'] as num?)?.toDouble();
        if (lon != null) vargaDeg = ((lon % 30) * d) % 30;
        if (p['vakri'] == true) flags.add('R');
        if (p['combust'] == true) flags.add('C');
        if (p['vargottam'] == true) flags.add('V');
      }
      byRashi.putIfAbsent(si, () => []).add({'planet': KundliNames.planet(planet, loc), if (vargaDeg != null) 'degree': vargaDeg, 'flags': flags});
    });
    return List.generate(12, (h) {
      final ri = (base + h) % 12;
      return {'house': h + 1, 'rashi_idx': ri, 'rashi_short': _signShortList[ri], 'planets': byRashi[ri] ?? [], 'is_lagna': h == 0};
    });
  }

  // ── recommendation sheet (FAB) ──
  void _showRecSheet(AppLocalizations l, Locale loc, List<Map<String, dynamic>> recs) {
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6, minChildSize: 0.4, maxChildSize: 0.92, expand: false,
        builder: (bctx, scroll) => Container(
          decoration: const BoxDecoration(color: AppColors.nebula, borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
          child: ListView(controller: scroll, padding: const EdgeInsets.fromLTRB(18, 10, 18, 28), children: [
            Center(child: Container(width: 42, height: 4, decoration: BoxDecoration(color: AppColors.ash, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 14),
            Row(children: [const Text('✨', style: TextStyle(fontSize: 20)), const SizedBox(width: 10),
              Expanded(child: Text(l.divRecommendedForYou, style: const TextStyle(color: AppColors.goldBright, fontSize: 17, fontWeight: FontWeight.w800)))]),
            const SizedBox(height: 8),
            Text(l.divRecSummary(_meta(l, recs.first['d'] as int)[0]), style: const TextStyle(color: AppColors.parchment, fontSize: 13, height: 1.5)),
            const SizedBox(height: 16),
            ...recs.map((r) {
              final d = r['d'] as int;
              return Padding(padding: const EdgeInsets.only(bottom: 10), child: Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.gold.withOpacity(0.3))),
                child: Row(children: [
                  Text('D$d', style: const TextStyle(color: AppColors.goldBright, fontSize: 15, fontWeight: FontWeight.w800)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(_meta(l, d)[0], style: const TextStyle(color: AppColors.ivory, fontSize: 13.5, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(_recReason(l, loc, r), style: const TextStyle(color: AppColors.smoke, fontSize: 11.5, height: 1.3)),
                  ])),
                ]),
              ));
            }),
          ]),
        ),
      ),
    );
  }
}
