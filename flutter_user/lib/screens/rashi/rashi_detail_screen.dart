import 'package:flutter/material.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../../utils/kundli_names.dart';
import '../kundli/widgets/kundli_ui.dart';
import '../kundli/widgets/north_indian_chart.dart';
import 'rashi_shared.dart';

/// Premium, beginner-friendly detail page for a single zodiac sign.
///
/// Presentation only. Loads `/rashi/{idx}/full` + `/rashi/{idx}/predictions`
/// (both unchanged) and re-presents them; every score, transit, vedha and
/// prediction value comes straight from the engine.
class RashiDetailScreen extends StatefulWidget {
  final int rashiIdx;
  final String? initialName;
  const RashiDetailScreen({super.key, required this.rashiIdx, this.initialName});
  @override
  State<RashiDetailScreen> createState() => _RashiDetailScreenState();
}

class _RashiDetailScreenState extends State<RashiDetailScreen> {
  final _api = ApiService();
  Map<String, dynamic>? _full, _predictions;
  bool _loading = true;
  String? _error;

  static const _signShort = ['Ar','Ta','Ge','Cn','Le','Vi','Li','Sc','Sg','Cp','Aq','Pi'];

  // Life-area order + emoji. Labels localised at runtime.
  static const _areas = [
    ['career', '💼'], ['wealth', '💰'], ['love', '❤️'], ['health', '🌿'],
    ['family', '🏠'], ['mind', '🧠'], ['spiritual', '🧘'],
  ];

  String _areaLabel(AppLocalizations l, String k) {
    switch (k) {
      case 'career': return l.lifeCareer;
      case 'wealth': return l.lifeWealth;
      case 'love': return l.love;
      case 'health': return l.lifeHealth;
      case 'family': return l.lifeFamily;
      case 'mind': return l.lifeMind;
      case 'ego': return l.lifeEgo;
      case 'aggression': return l.lifeAggression;
      case 'conflict': return l.lifeConflict;
      case 'spiritual': return l.spiritual;
      default: return k;
    }
  }

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final r = await Future.wait([_api.getRashiFull(widget.rashiIdx), _api.getRashiPredictions(widget.rashiIdx)]);
      if (!mounted) return;
      if (r[0]['statusCode'] == 200 && r[0]['status'] == 'success') _full = (r[0]['data'] as Map).cast<String, dynamic>();
      if (r[1]['statusCode'] == 200 && r[1]['status'] == 'success') _predictions = (r[1]['data'] as Map).cast<String, dynamic>();
      setState(() { _loading = false; });
    } catch (e) { if (!mounted) return; setState(() { _error = e.toString(); _loading = false; }); }
  }

  Map<String, dynamic> get _preds =>
      (_predictions?['predictions'] as Map?)?.cast<String, dynamic>() ?? {};
  double _areaScore(String k) => ((_preds[k] as Map?)?['score'] as num?)?.toDouble() ?? 0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final d = _full;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(RashiUi.signName(d?['name']?.toString() ?? widget.initialName, l),
            style: const TextStyle(color: AppColors.ivory, fontSize: 16, fontWeight: FontWeight.w700)),
        actions: [IconButton(onPressed: _load, icon: const Icon(Icons.refresh))],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : _error != null ? _errView(l)
          : d == null ? const SizedBox.shrink()
          : ListView(padding: const EdgeInsets.fromLTRB(16, 10, 16, 36), children: _sections(l, d)),
    );
  }

  List<Widget> _sections(AppLocalizations l, Map<String, dynamic> d) {
    var i = 0;
    Widget f(Widget w) => KFadeIn(delayMs: (i++ * 55).clamp(0, 600), child: w);
    return [
      f(_hero(l, d)),                               // Section 1
      const SizedBox(height: 18),
      if (_predictions != null) f(_influence(l)),   // Section 2
      if (_predictions != null) const SizedBox(height: 18),
      if (_predictions != null) f(_opportunities(l)), // Section 3
      if (_predictions != null) const SizedBox(height: 18),
      if (_predictions != null) f(_avoid(l, d)),    // Section 4
      if (_predictions != null) const SizedBox(height: 18),
      if (_predictions != null) f(_chart(l)),       // Section 5
      if (_predictions != null) const SizedBox(height: 18),
      if (_predictions != null) f(_lifeAreas(l)),   // Section 6
      const SizedBox(height: 18),
      f(_recommendations(l)),                        // Section 8
      const SizedBox(height: 18),
      f(_luckyStrip(l, d)),
      const SizedBox(height: 18),
      f(_tomorrow(l, d)),                            // Section 10
      const SizedBox(height: 18),
      f(_trend(l, l.rzWeeklyTrend, (d['weekly'] as Map?) ?? {})), // Section 11
      const SizedBox(height: 14),
      f(_trend(l, l.rzMonthlyTrend, (d['monthly'] as Map?) ?? {})),
      const SizedBox(height: 18),
      f(_technical(l, d)),                           // Section 9
    ];
  }

  // ══════════════════════════════════════════════════════════════════
  //  SECTION 1 — HERO
  // ══════════════════════════════════════════════════════════════════
  Widget _hero(AppLocalizations l, Map<String, dynamic> d) {
    final loc = Localizations.localeOf(context);
    final today = (d['today'] as Map?)?.cast<String, dynamic>() ?? {};
    final energy = RashiUi.energy((today['score'] as num?)?.toDouble() ?? 0);
    final col = RashiUi.energyColor(energy);
    // strongest / weakest life area for the AI summary
    String strong = '', weak = '';
    double sv = -1, wv = 999;
    for (final a in _areas) {
      final s = _areaScore(a[0]);
      if (s > sv) { sv = s; strong = _areaLabel(l, a[0]); }
      if (s < wv) { wv = s; weak = _areaLabel(l, a[0]); }
    }
    final summary = strong.isEmpty ? '' : l.rzDetailSummary(strong, weak);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [col.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
        borderRadius: BorderRadius.circular(22), border: Border.all(color: col.withOpacity(0.3)),
      ),
      child: Column(children: [
        Row(children: [
          Text(d['emoji']?.toString() ?? '', style: const TextStyle(fontSize: 46)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(RashiUi.signName(d['name']?.toString(), l), style: const TextStyle(color: AppColors.ivory, fontSize: 24, fontWeight: FontWeight.w800)),
            Text('${d['sanskrit'] ?? ''} · ${d['symbol'] ?? ''}', style: const TextStyle(color: AppColors.gold, fontSize: 12.5, fontWeight: FontWeight.w600)),
          ])),
        ]),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: _facet(l.rashiElement, d['element']?.toString() ?? '—')),
          Expanded(child: _facet(l.rashiQuality, d['quality']?.toString() ?? '—')),
          Expanded(child: _facet(l.ruledBy, KundliNames.planet(d['lord']?.toString() ?? '', loc))),
        ]),
        const SizedBox(height: 18),
        // energy ring
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: energy / 100), duration: const Duration(milliseconds: 850), curve: Curves.easeOutCubic,
          builder: (_, v, __) => SizedBox(width: 120, height: 120, child: Stack(alignment: Alignment.center, children: [
            SizedBox(width: 120, height: 120, child: CircularProgressIndicator(value: v, strokeWidth: 10, strokeCap: StrokeCap.round,
              backgroundColor: Colors.white.withOpacity(0.07), valueColor: AlwaysStoppedAnimation(col))),
            Column(mainAxisSize: MainAxisSize.min, children: [
              Text((v * 100).toStringAsFixed(0), style: TextStyle(color: col, fontSize: 34, fontWeight: FontWeight.w800, height: 1)),
              Text('/100', style: TextStyle(color: col.withOpacity(0.6), fontSize: 11, fontWeight: FontWeight.w600)),
            ]),
          ])),
        ),
        const SizedBox(height: 8),
        Text(l.rzTodayEnergy, style: const TextStyle(color: AppColors.smoke, fontSize: 11, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(color: col.withOpacity(0.16), borderRadius: BorderRadius.circular(20)),
          child: Text(RashiUi.energyStatus(energy, l), style: TextStyle(color: col, fontSize: 14, fontWeight: FontWeight.w800))),
        if (summary.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(color: AppColors.midnight.withOpacity(0.35), borderRadius: BorderRadius.circular(14)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('🤖', style: TextStyle(fontSize: 14)), const SizedBox(width: 9),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l.rzAiSummary, style: const TextStyle(color: AppColors.gold, fontSize: 10.5, fontWeight: FontWeight.w800)),
                const SizedBox(height: 3),
                Text(summary, style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, height: 1.5)),
              ])),
            ])),
        ],
      ]),
    );
  }

  Widget _facet(String label, String value) => Column(children: [
    Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 9.5, fontWeight: FontWeight.w600)),
    const SizedBox(height: 3),
    Text(value, style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
  ]);

  // ══════════════════════════════════════════════════════════════════
  //  SECTION 2 — PLANETARY INFLUENCE
  // ══════════════════════════════════════════════════════════════════
  Widget _influence(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    // Aggregate the engine's own per-area factor statements into a per-planet
    // sentiment. Nothing is recomputed — we only summarise existing factors.
    final net = <String, int>{}, count = <String, int>{};
    final rawFactors = <String>[];
    _preds.forEach((_, v) {
      final factors = ((v as Map?)?['factors'] as List?) ?? [];
      for (final fRaw in factors) {
        final fs = fRaw.toString();
        rawFactors.add(fs);
        final planet = fs.split(' ').first;
        final low = fs.toLowerCase();
        final pos = low.contains('favor') || low.contains('favour') || low.contains('active') || low.contains('strong') || low.contains('benefic');
        final neg = low.contains('challeng') || low.contains('weaken') || low.contains('trouble') || low.contains('vedha') || low.contains('debilit') || low.contains('malefic');
        if (!pos && !neg) continue;
        net[planet] = (net[planet] ?? 0) + (pos ? 1 : -1);
        count[planet] = (count[planet] ?? 0) + 1;
      }
    });
    final planets = count.keys.toList()..sort((a, b) => (net[b]!.abs()).compareTo(net[a]!.abs()));
    final top = planets.take(5).toList();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.public_rounded, title: l.rzPlanetaryInfluence, subtitle: l.rzStrongInfluences, color: AppColors.gold),
      if (top.isEmpty)
        _note(l.rzMoodCalm, KColors.blue)
      else _card(child: Column(children: top.map((p) {
        final n = net[p]!, c = count[p]!;
        final ratio = c == 0 ? 0.0 : n / c;
        final stars = (((ratio + 1) / 2) * 4 + 1).round().clamp(1, 5);
        final good = n >= 0;
        final kc = good ? KColors.green : KColors.orange;
        return Padding(padding: const EdgeInsets.symmetric(vertical: 7), child: Row(children: [
          SizedBox(width: 78, child: Text(KundliNames.planet(p, loc), style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w700))),
          KStars(filled: stars, size: 15, color: kc),
          const SizedBox(width: 10),
          Expanded(child: Text(good ? l.rzInfluenceGood(RashiUi.karaka(p, l)) : l.rzInfluenceHard(RashiUi.karaka(p, l)),
            style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis)),
        ]));
      }).toList())),
      if (rawFactors.isNotEmpty) _expandable(l.rzShowTechnical, rawFactors, AppColors.smoke),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  SECTION 3 — OPPORTUNITIES
  // ══════════════════════════════════════════════════════════════════
  Widget _opportunities(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    final cards = <Widget>[];
    for (final a in _areas.take(6)) {
      final m = (_preds[a[0]] as Map?)?.cast<String, dynamic>();
      if (m == null) continue;
      final score = (m['score'] as num?)?.toDouble() ?? 0;
      final col = RashiUi.areaColor(score);
      final desc = m['description']?.toString() ?? '';
      final factors = (m['factors'] as List?)?.map((e) => e.toString()).toList() ?? [];
      cards.add(Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: col.withOpacity(0.07), borderRadius: BorderRadius.circular(16), border: Border.all(color: col.withOpacity(0.22))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(a[1], style: const TextStyle(fontSize: 17)), const SizedBox(width: 7),
            Expanded(child: Text(_areaLabel(l, a[0]), style: const TextStyle(color: AppColors.ivory, fontSize: 13.5, fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis)),
            Text(score.toStringAsFixed(0), style: TextStyle(color: col, fontSize: 18, fontWeight: FontWeight.w800)),
          ]),
          const SizedBox(height: 7),
          ClipRRect(borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(value: (score / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(col))),
          if (desc.isNotEmpty) ...[const SizedBox(height: 8),
            Text(desc, style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.35))],
          if (factors.isNotEmpty) ...[const SizedBox(height: 8),
            Wrap(spacing: 5, runSpacing: 5, children: factors.take(2).map((fx) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(6)),
              child: Text(fx, style: const TextStyle(color: AppColors.smoke, fontSize: 8.5)))).toList())],
        ]),
      ));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.emoji_objects_rounded, title: l.rzOpportunities, color: KColors.green),
      GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 0.92, children: cards),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  SECTION 4 — THINGS TO AVOID
  // ══════════════════════════════════════════════════════════════════
  static const Map<String, String> _avoidKeyByArea = {
    'career': 'decisions', 'wealth': 'invest', 'love': 'arguments',
    'mind': 'overthink', 'spiritual': 'overthink', 'health': 'stress',
    'family': 'arguments', 'conflict': 'arguments', 'ego': 'arguments', 'aggression': 'arguments',
  };
  String _avoidPhrase(String tag, AppLocalizations l) {
    switch (tag) {
      case 'decisions': return l.rzAvoidDecisions;
      case 'invest': return l.rzAvoidInvestments;
      case 'arguments': return l.rzAvoidArguments;
      case 'overthink': return l.rzAvoidOverthink;
      case 'stress': return l.rzAvoidStress;
      default: return l.rzAvoidOverspend;
    }
  }

  Widget _avoid(AppLocalizations l, Map<String, dynamic> d) {
    // Weakest 3 life areas → friendly avoid lines; technical = their factors + vedha flags.
    final ranked = _areas.map((a) => a[0]).toList()..sort((x, y) => _areaScore(x).compareTo(_areaScore(y)));
    final weak = ranked.where((k) => _areaScore(k) < 55).take(3).toList();
    final phrases = <String>{};
    final tech = <String>[];
    for (final k in weak) {
      phrases.add(_avoidPhrase(_avoidKeyByArea[k] ?? 'overspend', l));
      final fx = ((_preds[k] as Map?)?['factors'] as List?) ?? [];
      tech.addAll(fx.map((e) => e.toString()));
    }
    final flags = ((d['today'] as Map?)?['flags'] as List?)?.map((e) => e.toString()).toList() ?? [];
    tech.addAll(flags);
    if (phrases.isEmpty) phrases.add(_avoidPhrase('overthink', l));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.do_not_disturb_on_rounded, title: l.rzAvoidTitle, color: KColors.red),
      _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:
        phrases.map((p) => Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('❌  ', style: TextStyle(fontSize: 13)),
          Expanded(child: Text(p, style: const TextStyle(color: AppColors.ivory, fontSize: 13, height: 1.35))),
        ]))).toList())),
      if (tech.isNotEmpty) _expandable(l.rzTechnicalReason, tech, KColors.red),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  SECTION 5 — PLANETARY CHART (collapsible)
  // ══════════════════════════════════════════════════════════════════
  Widget _chart(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    final chart = (_predictions!['transit_chart'] as Map?)?.cast<String, dynamic>() ?? {};
    final housesData = (chart['houses'] as List?) ?? [];
    if (housesData.isEmpty) return const SizedBox.shrink();
    final houses = housesData.map((h) {
      final m = (h as Map).cast<String, dynamic>();
      final planets = (m['planets'] as List?) ?? [];
      return {
        'house': m['house'],
        'rashi_idx': m['sign_idx'],
        'rashi_short': _signShort[((m['sign_idx'] as num?)?.toInt() ?? 0) % 12],
        'planets': planets.map((p) {
          if (p is Map) return {'planet': KundliNames.planet((p['planet'] ?? '').toString(), loc), if (p['degree'] != null) 'degree': p['degree'], 'flags': (p['flags'] as List?) ?? const []};
          return {'planet': KundliNames.planet(p.toString(), loc), 'flags': const []};
        }).toList(),
        'is_lagna': m['house'] == 1,
      };
    }).toList();
    return _card(child: Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: true, tilePadding: EdgeInsets.zero, childrenPadding: EdgeInsets.zero,
        iconColor: AppColors.gold, collapsedIconColor: AppColors.gold,
        title: Row(children: [
          Container(width: 34, height: 34, alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.grid_view_rounded, color: AppColors.gold, size: 18)),
          const SizedBox(width: 10),
          Expanded(child: Text(l.rzPlanetaryChart, style: const TextStyle(color: AppColors.ivory, fontSize: 15.5, fontWeight: FontWeight.w800))),
        ]),
        children: [
          const SizedBox(height: 8),
          NorthIndianChartWidget(houses: houses, chartTitle: l.gocharTransit),
          const SizedBox(height: 12),
          Container(padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.07), borderRadius: BorderRadius.circular(12)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.lightbulb_outline_rounded, size: 15, color: AppColors.gold), const SizedBox(width: 8),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l.rzWhatChartMeans, style: const TextStyle(color: AppColors.gold, fontSize: 11.5, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(l.rzChartExplain, style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.5)),
              ])),
            ])),
        ],
      ),
    ));
  }

  // ══════════════════════════════════════════════════════════════════
  //  SECTION 6 — LIFE AREAS (circular gauges)
  // ══════════════════════════════════════════════════════════════════
  Widget _lifeAreas(AppLocalizations l) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.donut_large_rounded, title: l.fdLifeAreas, color: KColors.purple),
      GridView.count(crossAxisCount: 3, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.82,
        children: _areas.map((a) {
          final m = (_preds[a[0]] as Map?)?.cast<String, dynamic>();
          if (m == null) return const SizedBox.shrink();
          final score = (m['score'] as num?)?.toDouble() ?? 0;
          return _gauge(a[1], _areaLabel(l, a[0]), score);
        }).toList()),
    ]);
  }

  Widget _gauge(String emoji, String label, double score) {
    final col = RashiUi.areaColor(score);
    return Column(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(width: 66, height: 66, child: Stack(alignment: Alignment.center, children: [
        SizedBox(width: 66, height: 66, child: CircularProgressIndicator(value: (score / 100).clamp(0, 1), strokeWidth: 6, strokeCap: StrokeCap.round,
          backgroundColor: Colors.white.withOpacity(0.07), valueColor: AlwaysStoppedAnimation(col))),
        Column(mainAxisSize: MainAxisSize.min, children: [
          Text(emoji, style: const TextStyle(fontSize: 15)),
          Text(score.toStringAsFixed(0), style: TextStyle(color: col, fontSize: 12, fontWeight: FontWeight.w800)),
        ]),
      ])),
      const SizedBox(height: 6),
      Text(label, style: const TextStyle(color: AppColors.ivory, fontSize: 10.5, fontWeight: FontWeight.w600), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  SECTION 8 — AI RECOMMENDATIONS
  // ══════════════════════════════════════════════════════════════════
  String _doPhrase(String area, AppLocalizations l) {
    switch (area) {
      case 'career': return l.rzDoNetworking;
      case 'mind': return l.rzDoLearning;
      case 'spiritual': return l.rzDoMeditation;
      case 'family': return l.rzDoFamily;
      case 'love': return l.rzDoFamily;
      case 'health': return l.rzDoRest;
      case 'wealth': return l.rzDoNetworking;
      default: return l.rzDoCreative;
    }
  }

  Widget _recommendations(AppLocalizations l) {
    final ranked = _areas.map((a) => a[0]).toList()..sort((x, y) => _areaScore(y).compareTo(_areaScore(x)));
    final strong = ranked.where((k) => _areaScore(k) >= 50).take(4).toList();
    final weak = ranked.reversed.where((k) => _areaScore(k) < 55).take(3).toList();
    final dos = <String>{...strong.map((k) => _doPhrase(k, l))};
    final donts = <String>{...weak.map((k) => _avoidPhrase(_avoidKeyByArea[k] ?? 'overspend', l))};
    if (dos.isEmpty) dos.add(l.rzDoRest);
    if (donts.isEmpty) donts.add(l.rzAvoidStress);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.auto_awesome_rounded, title: l.rzAiRecommendations, color: AppColors.gold),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: _doList('✔', l.fdWhatToDo, dos.toList(), KColors.green)),
        const SizedBox(width: 10),
        Expanded(child: _doList('✖', l.fdAvoid, donts.toList(), KColors.red)),
      ]),
    ]);
  }

  Widget _doList(String mark, String title, List<String> items, Color c) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(color: c.withOpacity(0.07), borderRadius: BorderRadius.circular(16), border: Border.all(color: c.withOpacity(0.22))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: TextStyle(color: c, fontSize: 12.5, fontWeight: FontWeight.w800)),
      const SizedBox(height: 8),
      ...items.map((s) => Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('$mark ', style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w700)),
        Expanded(child: Text(s, style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.35))),
      ]))),
    ]),
  );

  // ── lucky strip ──
  Widget _luckyStrip(AppLocalizations l, Map<String, dynamic> d) {
    final items = <List<String>>[
      ['🎨', l.rashiLuckyColor, d['lucky_color']?.toString() ?? '—'],
      ['📅', l.rashiLuckyDay, d['lucky_day']?.toString() ?? '—'],
      ['🔢', l.rashiLuckyNumber, '${d['lucky_number'] ?? '—'}'],
      ['💎', l.rashiGemstone, d['gem']?.toString() ?? '—'],
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.star_rounded, title: l.rzLuckyToday, color: AppColors.gold),
      Row(children: items.map((it) => Expanded(child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3), padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(color: AppColors.card.withOpacity(0.5), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.06))),
        child: Column(children: [
          Text(it[0], style: const TextStyle(fontSize: 18)), const SizedBox(height: 5),
          Text(it[2], style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, fontWeight: FontWeight.w800), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(it[1], style: const TextStyle(color: AppColors.smoke, fontSize: 8.5), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
        ]),
      ))).toList()),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  SECTION 10 — TOMORROW PREVIEW
  // ══════════════════════════════════════════════════════════════════
  Widget _tomorrow(AppLocalizations l, Map<String, dynamic> d) {
    final days = ((d['weekly'] as Map?)?['days'] as List?) ?? [];
    if (days.length < 2) return const SizedBox.shrink();
    final todayE = RashiUi.energy((days[0] as Map)['score']?.toDouble() ?? 0);
    final tomE = RashiUi.energy(((days[1] as Map)['score'] as num?)?.toDouble() ?? 0);
    final diff = tomE - todayE;
    final (label, line, col) = diff >= 4
        ? (l.rzImproving, l.rzTomorrowUpLine, KColors.green)
        : diff <= -4 ? (l.rzWeaker, l.rzTomorrowDownLine, KColors.orange)
        : (l.rzSteady, l.rzTomorrowFlatLine, KColors.blue);
    return _card(child: Row(children: [
      SizedBox(width: 62, height: 62, child: Stack(alignment: Alignment.center, children: [
        SizedBox(width: 62, height: 62, child: CircularProgressIndicator(value: (tomE / 100).clamp(0, 1), strokeWidth: 6, strokeCap: StrokeCap.round,
          backgroundColor: Colors.white.withOpacity(0.07), valueColor: AlwaysStoppedAnimation(col))),
        Text(tomE.toStringAsFixed(0), style: TextStyle(color: col, fontSize: 15, fontWeight: FontWeight.w800)),
      ])),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l.rzTomorrow, style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w700)),
        Row(children: [
          Text('${l.rzTomorrowEnergy}: ', style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, fontWeight: FontWeight.w600)),
          Text(label, style: TextStyle(color: col, fontSize: 13, fontWeight: FontWeight.w800)),
          Icon(diff >= 4 ? Icons.trending_up_rounded : diff <= -4 ? Icons.trending_down_rounded : Icons.trending_flat_rounded, size: 16, color: col),
        ]),
        const SizedBox(height: 4),
        Text(line, style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4)),
      ])),
    ]));
  }

  // ══════════════════════════════════════════════════════════════════
  //  SECTION 11 — WEEKLY / MONTHLY TREND (positive energy bars)
  // ══════════════════════════════════════════════════════════════════
  Widget _trend(AppLocalizations l, String title, Map trend) {
    final days = ((trend['days'] as List?) ?? []).cast<Map>();
    if (days.isEmpty) return const SizedBox.shrink();
    final energies = days.map((d) => RashiUi.energy((d['score'] as num?)?.toDouble() ?? 0)).toList();
    var bestI = 0, worstI = 0;
    for (var i = 0; i < energies.length; i++) { if (energies[i] > energies[bestI]) bestI = i; if (energies[i] < energies[worstI]) worstI = i; }
    String dm(int i) { final s = days[i]['date']?.toString() ?? ''; return s.length >= 10 ? s.substring(5) : s; }
    return _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        const Icon(Icons.show_chart_rounded, size: 16, color: AppColors.gold), const SizedBox(width: 8),
        Text(title, style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w800)),
      ]),
      const SizedBox(height: 14),
      SizedBox(height: 76, child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: List.generate(energies.length, (i) {
        final e = energies[i];
        final col = RashiUi.energyColor(e);
        return Expanded(child: Padding(padding: EdgeInsets.symmetric(horizontal: energies.length > 10 ? 0.6 : 2),
          child: Tooltip(message: '${dm(i)} · ${e.toStringAsFixed(0)}',
            child: Container(height: (e / 100 * 66).clamp(4, 66),
              decoration: BoxDecoration(color: col, borderRadius: BorderRadius.circular(3))))));
      }))),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _trendPill('⭐', l.rzBestDayWeek, dm(bestI), energies[bestI], KColors.green)),
        const SizedBox(width: 8),
        Expanded(child: _trendPill('⚠️', l.rzHardestDay, dm(worstI), energies[worstI], KColors.orange)),
      ]),
    ]));
  }

  Widget _trendPill(String emoji, String label, String date, double energy, Color c) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(color: c.withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: c.withOpacity(0.2))),
    child: Row(children: [
      Text(emoji, style: const TextStyle(fontSize: 13)), const SizedBox(width: 7),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 9)),
        Text('$date · ${energy.toStringAsFixed(0)}', style: TextStyle(color: c, fontSize: 11.5, fontWeight: FontWeight.w800)),
      ])),
    ]),
  );

  // ══════════════════════════════════════════════════════════════════
  //  SECTION 9 — TECHNICAL ASTROLOGY (collapsed)
  // ══════════════════════════════════════════════════════════════════
  Widget _technical(AppLocalizations l, Map<String, dynamic> d) {
    final today = (d['today'] as Map?)?.cast<String, dynamic>() ?? {};
    final rawScore = (today['score'] as num?)?.toDouble() ?? 0;
    final grade = today['grade']?.toString() ?? '';
    final flags = (today['flags'] as List?)?.map((e) => e.toString()).toList() ?? [];
    return Container(
      decoration: BoxDecoration(color: AppColors.card.withOpacity(0.4), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white.withOpacity(0.06))),
      child: Theme(data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          iconColor: AppColors.smoke, collapsedIconColor: AppColors.smoke,
          title: Row(children: [
            const Icon(Icons.science_rounded, size: 17, color: AppColors.smoke), const SizedBox(width: 8),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.rzTechnical, style: const TextStyle(color: AppColors.ivory, fontSize: 14.5, fontWeight: FontWeight.w800)),
              Text(l.rzAdvancedOnly, style: const TextStyle(color: AppColors.smoke, fontSize: 10)),
            ])),
          ]),
          children: [
            _techRow(l.rzTransitScore, '${rawScore.toStringAsFixed(2)}  ·  $grade'),
            if (flags.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(l.rzVedha, style: const TextStyle(color: AppColors.smoke, fontSize: 11, fontWeight: FontWeight.w800)),
              const SizedBox(height: 5),
              Wrap(spacing: 6, runSpacing: 5, children: flags.map((fx) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.indigo.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
                child: Text(fx, style: const TextStyle(color: AppColors.lavender, fontSize: 10)))).toList()),
            ],
          ],
        )),
    );
  }

  Widget _techRow(String k, String v) => Padding(padding: const EdgeInsets.only(top: 6), child: Row(children: [
    SizedBox(width: 110, child: Text(k, style: const TextStyle(color: AppColors.smoke, fontSize: 11.5))),
    Expanded(child: Text(v, style: const TextStyle(color: AppColors.ivory, fontSize: 12, fontWeight: FontWeight.w600))),
  ]));

  // ── shared small widgets ──
  Widget _card({required Widget child}) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: AppColors.card.withOpacity(0.4), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white.withOpacity(0.06))),
    child: child,
  );

  Widget _note(String text, Color c) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: c.withOpacity(0.2))),
    child: Text(text, style: const TextStyle(color: AppColors.ivory, fontSize: 12.5)),
  );

  Widget _expandable(String title, List<String> items, Color c) => Theme(
    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
    child: ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 4),
      childrenPadding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
      iconColor: c, collapsedIconColor: c,
      title: Text(title, style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w700)),
      children: items.map((s) => Padding(padding: const EdgeInsets.only(bottom: 5), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('•  ', style: TextStyle(color: c, fontSize: 11)),
        Expanded(child: Text(s, style: const TextStyle(color: AppColors.parchment, fontSize: 11, height: 1.35))),
      ]))).toList(),
    ),
  );

  Widget _errView(AppLocalizations l) => Center(child: Padding(padding: const EdgeInsets.all(24),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.error_outline, color: AppColors.error, size: 40), const SizedBox(height: 12),
      Text(_error!, style: const TextStyle(color: AppColors.smoke), textAlign: TextAlign.center),
      const SizedBox(height: 12), ElevatedButton(onPressed: _load, child: Text(l.retry)),
    ])));
}
