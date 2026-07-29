import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../services/api_service.dart';
import '../../../utils/kundli_names.dart';
import 'north_indian_chart.dart';
import 'kundli_ui.dart';

/// Gochar (transit) — premium AI-style transit dashboard.
///
/// Presentation only. Data comes from /rashi/{idx}/full (today/weekly/monthly
/// scores, meta, strengths) and /rashi/{idx}/predictions (life-area scores +
/// transit chart). Actions / remedies / plan text is composed on the client
/// from those values — no astrology calculation is changed.
class GocharWidget extends StatefulWidget {
  final String chartId;
  final int rashiIdx;
  const GocharWidget({super.key, required this.chartId, this.rashiIdx = 0});

  @override
  State<GocharWidget> createState() => _GocharWidgetState();
}

class _GocharWidgetState extends State<GocharWidget> {
  final _api = ApiService();
  Map<String, dynamic>? _full;
  Map<String, dynamic>? _predictions;
  bool _loading = true;
  String? _error;
  String _filter = 'all';

  static const _signShortList = ['Ar', 'Ta', 'Ge', 'Cn', 'Le', 'Vi', 'Li', 'Sc', 'Sg', 'Cp', 'Aq', 'Pi'];

  // life-area order + emoji + filter group
  static const _areaMeta = [
    {'key': 'career', 'emoji': '💼', 'grp': 'career'},
    {'key': 'wealth', 'emoji': '💰', 'grp': 'finance'},
    {'key': 'love', 'emoji': '❤️', 'grp': 'love'},
    {'key': 'health', 'emoji': '🏥', 'grp': 'health'},
    {'key': 'family', 'emoji': '👨‍👩‍👧', 'grp': 'family'},
    {'key': 'mind', 'emoji': '🧠', 'grp': 'all'},
    {'key': 'spiritual', 'emoji': '✨', 'grp': 'spiritual'},
  ];

  String _areaLabel(AppLocalizations l, String key) {
    switch (key) {
      case 'career': return l.lifeCareer;
      case 'health': return l.lifeHealth;
      case 'love': return l.love;
      case 'wealth': return l.lifeWealth;
      case 'family': return l.lifeFamily;
      case 'mind': return l.lifeMind;
      case 'spiritual': return l.spiritual;
      default: return key;
    }
  }

  // planet → compact remedy (proper-noun constants; mantras Sanskrit/universal)
  static const Map<String, Map<String, String>> _rem = {
    'Sun': {'m': 'Om Sūryāya Namaḥ', 'g': 'Ruby', 'd': 'Wheat, jaggery'},
    'Moon': {'m': 'Om Chandrāya Namaḥ', 'g': 'Pearl', 'd': 'Rice, milk'},
    'Mars': {'m': 'Om Maṅgalāya Namaḥ', 'g': 'Red Coral', 'd': 'Red lentils'},
    'Mercury': {'m': 'Om Budhāya Namaḥ', 'g': 'Emerald', 'd': 'Green gram'},
    'Jupiter': {'m': 'Om Gurave Namaḥ', 'g': 'Yellow Sapphire', 'd': 'Turmeric, gram'},
    'Venus': {'m': 'Om Śukrāya Namaḥ', 'g': 'Diamond', 'd': 'White cloth, sugar'},
    'Saturn': {'m': 'Om Śanaiścarāya Namaḥ', 'g': 'Blue Sapphire', 'd': 'Black sesame, oil'},
    'Rahu': {'m': 'Om Rāhave Namaḥ', 'g': 'Hessonite', 'd': 'Mustard, blanket'},
    'Ketu': {'m': 'Om Ketave Namaḥ', 'g': "Cat's Eye", 'd': 'Multi-grain'},
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final results = await Future.wait([
        _api.getRashiFull(widget.rashiIdx),
        _api.getRashiPredictions(widget.rashiIdx),
      ]);
      if (!mounted) return;
      if (results[0]['statusCode'] == 200 && results[0]['status'] == 'success') _full = (results[0]['data'] as Map).cast<String, dynamic>();
      if (results[1]['statusCode'] == 200 && results[1]['status'] == 'success') _predictions = (results[1]['data'] as Map).cast<String, dynamic>();
      setState(() => _loading = false);
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  // ── score helpers ──
  Map<String, dynamic> get _preds => (_predictions?['predictions'] as Map? ?? {}).cast<String, dynamic>();
  double _areaScore(String k) => ((_preds[k] as Map?)?['score'] as num?)?.toDouble() ?? 0;

  double get _overallPct {
    // prefer average of life-area scores (0-100); fall back to today score (-8..8)
    final a = _areaMeta.map((m) => _areaScore(m['key']!)).where((s) => s > 0).toList();
    if (a.isNotEmpty) return a.reduce((x, y) => x + y) / a.length;
    final t = ((_full?['today'] as Map?)?['score'] as num?)?.toDouble() ?? 0;
    return ((t + 8) / 16 * 100).clamp(0, 100);
  }

  Color _gradeColor(num pct) {
    if (pct >= 75) return KColors.green;
    if (pct >= 58) return const Color(0xFF8BC34A);
    if (pct >= 42) return KColors.yellow;
    if (pct >= 25) return KColors.orange;
    return KColors.red;
  }

  String _gradeLabel(num pct, AppLocalizations l) {
    if (pct >= 75) return l.gradeExcellent;
    if (pct >= 58) return l.gradeGood;
    if (pct >= 42) return l.gochNeutral;
    if (pct >= 25) return l.gochChallenging;
    return l.doshCritical;
  }

  Color _areaColor(num s) {
    if (s >= 75) return KColors.green;
    if (s >= 60) return KColors.blue;
    if (s >= 45) return KColors.yellow;
    if (s >= 30) return KColors.orange;
    return KColors.red;
  }

  List<MapEntry<String, double>> get _areasSorted {
    final e = _areaMeta.map((m) => MapEntry(m['key']!, _areaScore(m['key']!))).where((x) => x.value > 0).toList();
    e.sort((a, b) => b.value.compareTo(a.value));
    return e;
  }

  String? _areaPlanet(String area) {
    final f = ((_preds[area] as Map?)?['factors'] as List?) ?? const [];
    for (final s in f) {
      for (final p in _rem.keys) {
        if (s.toString().contains(p)) return p;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator(color: AppColors.gold));
    if (_error != null) return _errView();
    if (_full == null) return const SizedBox.shrink();
    final l = AppLocalizations.of(context)!;
    final loc = Localizations.localeOf(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.gold, foregroundColor: AppColors.midnight,
        icon: const Text('✨', style: TextStyle(fontSize: 15)),
        label: Text(l.gochExplain, style: const TextStyle(fontWeight: FontWeight.w800)),
        onPressed: () => _showExplain(l, loc),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(padding: const EdgeInsets.fromLTRB(16, 14, 16, 90), children: [
          KFadeIn(child: _hero(l)),
          const SizedBox(height: 16),
          KFadeIn(delayMs: 60, child: _filters(l)),
          const SizedBox(height: 14),
          KFadeIn(delayMs: 100, child: _snapshots(l)),
          const SizedBox(height: 18),
          KFadeIn(delayMs: 140, child: _favorability(l)),
          const SizedBox(height: 18),
          KFadeIn(delayMs: 160, child: KSectionHeader(icon: Icons.notifications_active_outlined, title: l.gochAlerts, color: KColors.orange)),
          ..._alerts(l),
          const SizedBox(height: 8),
          KFadeIn(delayMs: 180, child: _aiFocus(l)),
          const SizedBox(height: 18),
          KFadeIn(delayMs: 200, child: KSectionHeader(icon: Icons.dashboard_customize_outlined, title: l.gochLifeScores, color: KColors.blue)),
          ..._lifeScores(l, loc),
          const SizedBox(height: 8),
          KFadeIn(child: _dosDonts(l)),
          const SizedBox(height: 18),
          KFadeIn(child: _transitChartCard(l)),
          const SizedBox(height: 14),
          KFadeIn(child: _activeTransits(l, loc)),
          const SizedBox(height: 18),
          KFadeIn(child: _dailyPlan(l)),
          const SizedBox(height: 18),
          KFadeIn(child: _trendCard(l.thisWeek, (_full!['weekly'] as Map?) ?? {})),
          const SizedBox(height: 14),
          KFadeIn(child: _trendCard(l.thisMonth, (_full!['monthly'] as Map?) ?? {})),
          const SizedBox(height: 18),
          KFadeIn(child: _smartReco(l)),
        ]),
      ),
    );
  }

  // ── 1. HERO ──
  Widget _hero(AppLocalizations l) {
    final pct = _overallPct;
    final color = _gradeColor(pct);
    final sorted = _areasSorted;
    final top = sorted.take(2).toList();
    final low = sorted.reversed.take(2).toList();
    final theme = sorted.isEmpty ? '' :
        (sorted.first.value >= 55 ? l.gochThemeGrowth(_areaLabel(l, sorted.first.key)) : l.gochThemeChallenge(_areaLabel(l, sorted.last.key)));

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF2A2358), Color(0xFF14112E)]),
        borderRadius: BorderRadius.circular(22), border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l.gochToday, style: const TextStyle(color: AppColors.goldBright, fontSize: 15, fontWeight: FontWeight.w800)),
        const SizedBox(height: 14),
        Row(children: [
          _Gauge(value: pct / 100, color: color, label: pct.toStringAsFixed(0)),
          const SizedBox(width: 18),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.gochOverallScore.toUpperCase(), style: const TextStyle(color: AppColors.smoke, fontSize: 9.5, letterSpacing: 0.5, fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(_gradeLabel(pct, l), style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            if (theme.isNotEmpty) Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.14), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.gold.withOpacity(0.4))),
              child: Text('🎯 $theme', style: const TextStyle(color: AppColors.goldBright, fontSize: 11.5, fontWeight: FontWeight.w700)),
            ),
          ])),
        ]),
        const SizedBox(height: 16),
        if (top.isNotEmpty) ...[
          Text(l.gochTopPositive, style: const TextStyle(color: KColors.green, fontSize: 11.5, fontWeight: FontWeight.w800)),
          const SizedBox(height: 5),
          ...top.where((e) => e.value >= 50).map((e) => _influence('✅', l.gochPosLine(_areaLabel(l, e.key)), KColors.green)),
          const SizedBox(height: 10),
        ],
        if (low.isNotEmpty) ...[
          Text(l.gochTopChallenges, style: const TextStyle(color: KColors.orange, fontSize: 11.5, fontWeight: FontWeight.w800)),
          const SizedBox(height: 5),
          ...low.where((e) => e.value < 55).map((e) => _influence('⚠️', l.gochChalLine(_areaLabel(l, e.key)), KColors.orange)),
        ],
      ]),
    );
  }

  Widget _influence(String icon, String text, Color c) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('$icon ', style: const TextStyle(fontSize: 12)),
          Expanded(child: Text(text, style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.35))),
        ]),
      );

  // ── 16. quick filters ──
  Widget _filters(AppLocalizations l) {
    final f = [
      ['all', l.gochFilterAll], ['career', l.lifeCareer], ['love', l.love], ['health', l.lifeHealth],
      ['finance', l.avFinance], ['family', l.lifeFamily], ['spiritual', l.spiritual],
    ];
    return SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: f.map((g) {
      final sel = _filter == g[0];
      return Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(
        label: Text(g[1]), selected: sel, showCheckmark: false,
        labelStyle: TextStyle(color: sel ? AppColors.midnight : AppColors.smoke, fontWeight: FontWeight.w700, fontSize: 12),
        selectedColor: AppColors.gold, backgroundColor: AppColors.card, side: BorderSide(color: AppColors.gold.withOpacity(sel ? 0 : 0.3)),
        onSelected: (_) => setState(() => _filter = g[0] as String),
      ));
    }).toList()));
  }

  bool _passFilter(String grp) => _filter == 'all' || _filter == grp || (grp == 'all');

  // ── 2. today snapshots ──
  Widget _snapshots(AppLocalizations l) {
    final items = _areaMeta.where((m) => _passFilter(m['grp']!)).toList();
    return SizedBox(
      height: 96,
      child: ListView(scrollDirection: Axis.horizontal, children: items.map((m) {
        final s = _areaScore(m['key']!);
        final c = _areaColor(s);
        return Container(
          width: 96, margin: const EdgeInsets.only(right: 10), padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: c.withOpacity(0.35))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(m['emoji']!, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(_areaLabel(l, m['key']!), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.parchment, fontSize: 11, fontWeight: FontWeight.w600)),
            const Spacer(),
            Text(s.toStringAsFixed(0), style: TextStyle(color: c, fontSize: 18, fontWeight: FontWeight.w800)),
          ]),
        );
      }).toList()),
    );
  }

  // ── 15. favorability meter ──
  Widget _favorability(AppLocalizations l) {
    final today = _overallPct;
    final week = (((_full?['weekly'] as Map?)?['avg'] as num?)?.toDouble() ?? 0);
    final month = (((_full?['monthly'] as Map?)?['avg'] as num?)?.toDouble() ?? 0);
    // weekly/monthly avg are on the -8..8 scale → convert to pct
    double pct(double v) => ((v + 8) / 16 * 100).clamp(0, 100);
    final rows = [
      [l.thisWeek, pct(week)], [l.thisMonth, pct(month)],
    ];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l.gochFavorability, style: const TextStyle(color: AppColors.gold, fontSize: 13, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        _favRow(l.gochFilterAll == 'All' ? 'Today' : l.gochToday, today),
        ...rows.map((r) => _favRow(r[0] as String, r[1] as double)),
      ]),
    );
  }

  Widget _favRow(String label, double pct) {
    final c = _gradeColor(pct);
    return Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children: [
      SizedBox(width: 88, child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.parchment, fontSize: 12))),
      Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(5),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: (pct / 100).clamp(0, 1)), duration: const Duration(milliseconds: 800), curve: Curves.easeOutCubic,
            builder: (_, v, __) => LinearProgressIndicator(value: v, minHeight: 8, backgroundColor: AppColors.ash.withOpacity(0.4), valueColor: AlwaysStoppedAnimation(c))))),
      const SizedBox(width: 8),
      SizedBox(width: 30, child: Text(pct.toStringAsFixed(0), textAlign: TextAlign.right, style: TextStyle(color: c, fontSize: 12.5, fontWeight: FontWeight.w800))),
    ]));
  }

  // ── 14. transit alerts ──
  List<Widget> _alerts(AppLocalizations l) {
    final sorted = _areasSorted;
    final out = <Widget>[];
    for (final e in sorted.reversed.take(2)) {
      if (e.value < 40) out.add(_alertCard('🔴', l.gochAlertCritical, l.gochChalLine(_areaLabel(l, e.key)), KColors.red));
      else if (e.value < 55) out.add(_alertCard('🟠', l.gochAlertWarning, l.gochChalLine(_areaLabel(l, e.key)), KColors.orange));
    }
    for (final e in sorted.take(1)) {
      if (e.value >= 60) out.add(_alertCard('🟢', l.gochAlertOpportunity, l.gochPosLine(_areaLabel(l, e.key)), KColors.green));
    }
    if (out.isEmpty) out.add(_alertCard('🟢', l.gochAlertOpportunity, l.gochPosLine(_areaLabel(l, sorted.isEmpty ? 'career' : sorted.first.key)), KColors.green));
    return out.map((w) => KFadeIn(child: w)).toList();
  }

  Widget _alertCard(String dot, String title, String body, Color c) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: c.withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: c.withOpacity(0.35))),
        child: Row(children: [
          Text(dot, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 8),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w800)),
            Text(body, style: const TextStyle(color: AppColors.parchment, fontSize: 11.5)),
          ])),
        ]),
      );

  // ── 13. AI focus + 7. actions ──
  Widget _aiFocus(AppLocalizations l) {
    final sorted = _areasSorted;
    final a1 = sorted.isEmpty ? '' : _areaLabel(l, sorted.first.key);
    final a2 = sorted.isEmpty ? '' : _areaLabel(l, sorted.last.key);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.twilight.withOpacity(0.4), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.lavender.withOpacity(0.3))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [const Text('✨', style: TextStyle(fontSize: 16)), const SizedBox(width: 8),
          Expanded(child: Text(l.gochAiFocus, style: const TextStyle(color: AppColors.lavender, fontSize: 14, fontWeight: FontWeight.w800)))]),
        const SizedBox(height: 8),
        Text(l.gochAiFocusLine(a1, a2), style: const TextStyle(color: AppColors.parchment, fontSize: 12.8, height: 1.5)),
      ]),
    );
  }

  // ── 8. dos & don'ts ──
  Widget _dosDonts(AppLocalizations l) {
    final good = _overallPct >= 55;
    final dos = [l.gochDoWork, l.gochDoMeditate, good ? l.gochDoStart : l.gochDoFinish];
    final donts = [l.gochDontArgue, l.gochDontImpulsive, l.gochDontOverspend];
    Widget col(String title, List<String> items, Color c, IconData ic) => Expanded(child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: c.withOpacity(0.07), borderRadius: BorderRadius.circular(14), border: Border.all(color: c.withOpacity(0.3))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Icon(ic, color: c, size: 15), const SizedBox(width: 5), Text(title, style: TextStyle(color: c, fontSize: 12.5, fontWeight: FontWeight.w800))]),
            const SizedBox(height: 8),
            ...items.map((x) => Padding(padding: const EdgeInsets.only(bottom: 5), child: Text('• $x', style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.3)))),
          ]),
        ));
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      col(l.gochDo, dos, KColors.green, Icons.check_circle_outline),
      const SizedBox(width: 10),
      col(l.gochDont, donts, KColors.red, Icons.cancel_outlined),
    ]);
  }

  // ── 6/11. life-area scores dashboard ──
  List<Widget> _lifeScores(AppLocalizations l, Locale loc) {
    return _areaMeta.where((m) => _passFilter(m['grp']!)).map((m) {
      final data = (_preds[m['key']] as Map?)?.cast<String, dynamic>();
      if (data == null) return const SizedBox.shrink();
      return KFadeIn(child: _LifeAreaCard(
        label: _areaLabel(l, m['key']!), emoji: m['emoji']!, data: data, color: _areaColor((data['score'] as num?)?.toDouble() ?? 0),
        planet: _areaPlanet(m['key']!), rem: _rem, loc: loc,
      ));
    }).toList();
  }

  // ── 3+4. transit chart + current transits ──
  Widget _transitChartCard(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    final chart = (_predictions?['transit_chart'] as Map?)?.cast<String, dynamic>() ?? {};
    final housesData = (chart['houses'] as List?) ?? [];
    if (housesData.isEmpty) return const SizedBox.shrink();
    final houses = housesData.map((h) {
      final m = (h as Map).cast<String, dynamic>();
      final planets = (m['planets'] as List?) ?? [];
      return {
        'house': m['house'], 'rashi_idx': m['sign_idx'],
        'rashi_short': _signShortList[(m['sign_idx'] as num).toInt() % 12],
        'planets': planets.map((p) {
          if (p is Map) return {'planet': KundliNames.planet((p['planet'] ?? '').toString(), loc), if (p['degree'] != null) 'degree': p['degree'], 'flags': (p['flags'] as List?) ?? const []};
          return {'planet': KundliNames.planet(p.toString(), loc), 'flags': const []};
        }).toList(),
        'is_lagna': m['house'] == 1,
      };
    }).toList();
    return _Collapsible(
      title: l.gocharTodaysTransitChart, icon: Icons.grid_view_rounded,
      child: Padding(padding: const EdgeInsets.all(14), child: NorthIndianChartWidget(houses: houses, chartTitle: l.gocharTransit)),
    );
  }

  Widget _activeTransits(AppLocalizations l, Locale loc) {
    final chart = (_predictions?['transit_chart'] as Map?)?.cast<String, dynamic>() ?? {};
    final housesData = (chart['houses'] as List?) ?? [];
    // flatten planets with their house
    final rows = <Map<String, dynamic>>[];
    for (final h in housesData) {
      final m = (h as Map).cast<String, dynamic>();
      final house = (m['house'] as num?)?.toInt() ?? 0;
      for (final p in (m['planets'] as List? ?? [])) {
        final name = p is Map ? (p['planet'] ?? '').toString() : p.toString();
        final flags = p is Map ? ((p['flags'] as List?) ?? const []) : const [];
        final deg = p is Map ? p['degree'] : null;
        rows.add({'planet': name, 'house': house, 'flags': flags, 'degree': deg, 'sign': _signShortList[((m['sign_idx'] as num?)?.toInt() ?? 0) % 12]});
      }
    }
    if (rows.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.timeline, title: l.gochCurrentTransits, color: KColors.purple),
      ...rows.map((r) => _transitRow(l, loc, r)),
    ]);
  }

  Widget _transitRow(AppLocalizations l, Locale loc, Map<String, dynamic> r) {
    final flags = (r['flags'] as List).cast<dynamic>();
    final retro = flags.contains('R');
    final combust = flags.contains('C');
    return Container(
      margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Row(children: [
        Container(width: 40, height: 40, alignment: Alignment.center, decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.15), shape: BoxShape.circle),
            child: Text(_glyph(r['planet'] as String), style: const TextStyle(fontSize: 17, color: AppColors.gold))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(KundliNames.planet(r['planet'] as String, loc), style: const TextStyle(color: AppColors.ivory, fontSize: 13.5, fontWeight: FontWeight.w700)),
          Text('${KundliNames.rashiShort(r['sign'] as String, loc)} · ${kOrdinal(r['house'] as int)} ${l.house}${r['degree'] != null ? ' · ${(r['degree'] as num).toInt()}°' : ''}',
              style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
        ])),
        if (retro) _flag('R', KColors.blue),
        if (combust) _flag('C', KColors.orange),
      ]),
    );
  }

  Widget _flag(String s, Color c) => Container(margin: const EdgeInsets.only(left: 4), padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: c.withOpacity(0.18), borderRadius: BorderRadius.circular(5)), child: Text(s, style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.w800)));

  // ── 19. daily plan ──
  Widget _dailyPlan(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    final color = (_full?['lucky_color'] ?? '—').toString();
    final number = (_full?['lucky_number'] ?? '—').toString();
    final dir = kDirectionLabel(kDirectionToken(widget.rashiIdx), l);
    final periods = [
      [l.gochMorning, '🌅', l.gochDoWork], [l.gochAfternoon, '☀️', l.gochDoFinish],
      [l.gochEvening, '🌆', l.gochDoMeditate], [l.gochNight, '🌙', l.gochDontImpulsive],
    ];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [const Icon(Icons.schedule, color: AppColors.gold, size: 16), const SizedBox(width: 8),
          Text(l.gochDailyPlan, style: const TextStyle(color: AppColors.gold, fontSize: 13, fontWeight: FontWeight.w800))]),
        const SizedBox(height: 12),
        ...periods.map((p) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [
          Text(p[1], style: const TextStyle(fontSize: 15)),
          const SizedBox(width: 8),
          SizedBox(width: 78, child: Text(p[0], style: const TextStyle(color: AppColors.parchment, fontSize: 12, fontWeight: FontWeight.w700))),
          Expanded(child: Text(p[2], style: const TextStyle(color: AppColors.smoke, fontSize: 11.5))),
        ]))),
        const Divider(height: 20),
        Wrap(spacing: 10, runSpacing: 8, children: [
          _luck(l.rashiLuckyColor, color), _luck(l.sumLuckyDirection, dir), _luck(l.rashiLuckyNumber, number),
        ]),
      ]),
    );
  }

  Widget _luck(String k, String v) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.1), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.gold.withOpacity(0.25))),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text('$k: ', style: const TextStyle(color: AppColors.smoke, fontSize: 10.5)),
          Text(v, style: const TextStyle(color: AppColors.goldBright, fontSize: 11.5, fontWeight: FontWeight.w700)),
        ]),
      );

  // ── 18. smart recommendations ──
  Widget _smartReco(AppLocalizations l) {
    final sorted = _areasSorted;
    final recs = <List<String>>[];
    for (final e in sorted.reversed.take(3)) {
      switch (e.key) {
        case 'career': recs.add([l.gochChalLine(l.lifeCareer), 'D10 · ${l.divD10Name}']); break;
        case 'love': recs.add([l.gochChalLine(l.love), 'D9 · ${l.divD9Name}']); break;
        case 'wealth': recs.add([l.gochChalLine(l.lifeWealth), 'D2 · ${l.divD2Name}']); break;
        case 'family': recs.add([l.gochChalLine(l.lifeFamily), 'D12 · ${l.divD12Name}']); break;
        case 'spiritual': recs.add([l.gochChalLine(l.spiritual), 'D20 · ${l.divD20Name}']); break;
        default: break;
      }
    }
    if (recs.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.travel_explore, title: l.gochSmartReco, color: KColors.gold),
      ...recs.map((r) => Container(
        margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.gold.withOpacity(0.25))),
        child: Row(children: [
          Expanded(child: Text(r[0], style: const TextStyle(color: AppColors.parchment, fontSize: 12))),
          const Icon(Icons.arrow_forward, size: 14, color: AppColors.gold),
          const SizedBox(width: 6),
          Text(r[1], style: const TextStyle(color: AppColors.goldBright, fontSize: 11.5, fontWeight: FontWeight.w700)),
        ]),
      )),
    ]);
  }

  // ── 17. explain sheet ──
  void _showExplain(AppLocalizations l, Locale loc) {
    final pct = _overallPct;
    final sorted = _areasSorted;
    final bullets = <String>[
      l.gochAiFocusLine(sorted.isEmpty ? '' : _areaLabel(l, sorted.first.key), sorted.isEmpty ? '' : _areaLabel(l, sorted.last.key)),
      '${_gradeLabel(pct, l)} · ${pct.toStringAsFixed(0)}/100',
      if (sorted.isNotEmpty) l.gochPosLine(_areaLabel(l, sorted.first.key)),
      if (sorted.isNotEmpty) l.gochChalLine(_areaLabel(l, sorted.last.key)),
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
              Expanded(child: Text(l.gochExplain, style: const TextStyle(color: AppColors.goldBright, fontSize: 17, fontWeight: FontWeight.w800)))]),
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

  // ── week/month trend (interactive) ──
  Widget _trendCard(String title, Map trendMap) {
    final l = AppLocalizations.of(context)!;
    final days = ((trendMap['days'] as List?) ?? []).cast<Map>();
    if (days.isEmpty) return const SizedBox.shrink();
    final scores = days.map((d) => (d['score'] as num).toDouble()).toList();
    final maxS = scores.reduce(math.max), minS = scores.reduce(math.min);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [const Icon(Icons.show_chart, color: AppColors.gold, size: 16), const SizedBox(width: 6),
          Text(title, style: const TextStyle(color: AppColors.gold, fontSize: 13, fontWeight: FontWeight.w800))]),
        const SizedBox(height: 12),
        SizedBox(height: 76, child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: days.map((day) {
          final s = (day['score'] as num).toDouble();
          final range = (maxS - minS).abs() < 0.01 ? 1.0 : (maxS - minS);
          final h = ((s - minS) / range).clamp(0.06, 1.0) * 64;
          final c = _gradeColor(((s + 8) / 16 * 100));
          return Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 1.5), child: Tooltip(
            message: '${day['date']}: ${s.toStringAsFixed(1)}', triggerMode: TooltipTriggerMode.tap,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: h), duration: const Duration(milliseconds: 700), curve: Curves.easeOutCubic,
              builder: (_, v, __) => Container(height: v, decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(3))),
            ),
          )));
        }).toList())),
        const SizedBox(height: 6),
        Row(children: [
          Text('${l.best} ${maxS.toStringAsFixed(1)}', style: const TextStyle(color: KColors.green, fontSize: 10)),
          const Spacer(),
          Text('${l.worst} ${minS.toStringAsFixed(1)}', style: const TextStyle(color: KColors.red, fontSize: 10)),
        ]),
      ]),
    );
  }

  String _glyph(String p) {
    const s = {'Sun': '☉', 'Moon': '☾', 'Mars': '♂', 'Mercury': '☿', 'Jupiter': '♃', 'Venus': '♀', 'Saturn': '♄', 'Rahu': '☊', 'Ketu': '☋'};
    return s[p] ?? '✦';
  }

  Widget _errView() => Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.error_outline, color: AppColors.error, size: 40),
        const SizedBox(height: 12),
        Text(_error!, style: const TextStyle(color: AppColors.smoke), textAlign: TextAlign.center),
        const SizedBox(height: 12),
        ElevatedButton(onPressed: _load, child: Text(AppLocalizations.of(context)?.retry ?? 'Retry')),
      ])));
}

// ═══════════════════════════════════════════════════════════════════════
class _LifeAreaCard extends StatefulWidget {
  final String label, emoji;
  final Map<String, dynamic> data;
  final Color color;
  final String? planet;
  final Map<String, Map<String, String>> rem;
  final Locale loc;
  const _LifeAreaCard({required this.label, required this.emoji, required this.data, required this.color, this.planet, required this.rem, required this.loc});
  @override
  State<_LifeAreaCard> createState() => _LifeAreaCardState();
}

class _LifeAreaCardState extends State<_LifeAreaCard> {
  bool _open = false;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final score = (widget.data['score'] as num?)?.toDouble() ?? 0;
    final grade = widget.data['grade']?.toString() ?? '';
    final desc = widget.data['description']?.toString() ?? '';
    final factors = (widget.data['factors'] as List?)?.cast<String>() ?? const [];
    final c = widget.color;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: c.withOpacity(0.3))),
      child: Column(children: [
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => setState(() => _open = !_open),
          child: Padding(padding: const EdgeInsets.all(13), child: Column(children: [
            Row(children: [
              Text(widget.emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Expanded(child: Text(widget.label, style: const TextStyle(color: AppColors.ivory, fontSize: 13.5, fontWeight: FontWeight.w700))),
              Text(grade, style: TextStyle(color: c, fontSize: 10.5, fontWeight: FontWeight.w700)),
              const SizedBox(width: 8),
              Text(score.toStringAsFixed(0), style: TextStyle(color: c, fontSize: 17, fontWeight: FontWeight.w800)),
              AnimatedRotation(turns: _open ? 0.5 : 0, duration: const Duration(milliseconds: 220), child: Icon(Icons.expand_more, color: c, size: 20)),
            ]),
            const SizedBox(height: 8),
            ClipRRect(borderRadius: BorderRadius.circular(4), child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: (score / 100).clamp(0, 1)), duration: const Duration(milliseconds: 800), curve: Curves.easeOutCubic,
              builder: (_, v, __) => LinearProgressIndicator(value: v, minHeight: 6, backgroundColor: AppColors.ash.withOpacity(0.4), valueColor: AlwaysStoppedAnimation(c)))),
          ])),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity, height: 0),
          secondChild: Padding(padding: const EdgeInsets.fromLTRB(13, 0, 13, 13), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (desc.isNotEmpty) Text(desc, style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.4)),
            if (factors.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(l.gochWhy, style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              ...factors.map((f) => Padding(padding: const EdgeInsets.only(bottom: 2), child: Text('• $f', style: const TextStyle(color: AppColors.smoke, fontSize: 11)))),
            ],
            if (score < 50 && widget.planet != null && widget.rem[widget.planet] != null) ...[
              const SizedBox(height: 10),
              Text(l.bhRemedies, style: const TextStyle(color: KColors.green, fontSize: 11, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              _remRow(l.remMantra, widget.rem[widget.planet]!['m']!),
              _remRow(l.remGemstone, widget.rem[widget.planet]!['g']!),
              _remRow(l.remDonation, widget.rem[widget.planet]!['d']!),
            ],
          ])),
          crossFadeState: _open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 240),
        ),
      ]),
    );
  }

  Widget _remRow(String k, String v) => Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 80, child: Text(k, style: const TextStyle(color: KColors.green, fontSize: 11, fontWeight: FontWeight.w600))),
        Expanded(child: Text(v, style: const TextStyle(color: AppColors.parchment, fontSize: 11.5))),
      ]));
}

// ═══════════════════════════════════════════════════════════════════════
class _Collapsible extends StatefulWidget {
  final String title;
  final IconData icon;
  final Widget child;
  const _Collapsible({required this.title, required this.icon, required this.child});
  @override
  State<_Collapsible> createState() => _CollapsibleState();
}

class _CollapsibleState extends State<_Collapsible> {
  bool _open = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(children: [
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => setState(() => _open = !_open),
          child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [
            Icon(widget.icon, color: AppColors.gold, size: 18), const SizedBox(width: 8),
            Expanded(child: Text(widget.title, style: const TextStyle(color: AppColors.gold, fontSize: 13, fontWeight: FontWeight.w800))),
            AnimatedRotation(turns: _open ? 0.5 : 0, duration: const Duration(milliseconds: 220), child: const Icon(Icons.expand_more, color: AppColors.gold)),
          ])),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity, height: 0),
          secondChild: widget.child,
          crossFadeState: _open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 240), sizeCurve: Curves.easeInOut,
        ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
//  Animated circular score gauge
// ═══════════════════════════════════════════════════════════════════════
class _Gauge extends StatelessWidget {
  final double value; // 0..1
  final Color color;
  final String label;
  const _Gauge({required this.value, required this.color, required this.label});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88, height: 88,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: value.clamp(0, 1)),
        duration: const Duration(milliseconds: 1100), curve: Curves.easeOutCubic,
        builder: (_, v, __) => CustomPaint(
          painter: _GaugePainter(v, color),
          child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(label, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.w800)),
            const Text('/100', style: TextStyle(color: AppColors.smoke, fontSize: 9)),
          ])),
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double v;
  final Color color;
  _GaugePainter(this.v, this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 5;
    final bg = Paint()..color = AppColors.ash.withOpacity(0.4)..style = PaintingStyle.stroke..strokeWidth = 7..strokeCap = StrokeCap.round;
    final fg = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 7..strokeCap = StrokeCap.round;
    const start = -math.pi / 2 - math.pi * 0.75;
    const sweep = math.pi * 1.5;
    canvas.drawArc(Rect.fromCircle(center: c, radius: r), start, sweep, false, bg);
    canvas.drawArc(Rect.fromCircle(center: c, radius: r), start, sweep * v, false, fg);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter old) => old.v != v || old.color != color;
}
