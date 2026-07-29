import 'package:flutter/material.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import 'widgets/planet_positions_widget.dart';
import 'widgets/summary_tab_widget.dart';
import 'widgets/north_indian_chart.dart';
import 'widgets/divisional_charts_widget.dart';
import 'widgets/dasha_tree_widget.dart';
import 'widgets/dosh_widget.dart';
import 'widgets/yoga_widget.dart';
import 'widgets/shadbala_widget.dart';
import 'widgets/ashtakavarga_widget.dart';
import 'widgets/aspects_widget.dart';
import 'widgets/bhava_widget.dart';
import 'widgets/gochar_widget.dart';

/// Main kundli viewer — 17 tabs for all Vedic analysis sections.
class KundliViewerScreen extends StatefulWidget {
  final String chartId;
  final String clientName;

  const KundliViewerScreen({super.key, required this.chartId, required this.clientName});

  @override
  State<KundliViewerScreen> createState() => _KundliViewerScreenState();
}

class _KundliViewerScreenState extends State<KundliViewerScreen> with TickerProviderStateMixin {
  final _api = ApiService();
  late final TabController _tabs;
  Map<String, dynamic>? _chart;
  Map<String, dynamic>? _complete;
  bool _loading = true;
  String? _error;

  static const _sectionCount = 13;

  static List<List<Object>> _sections(AppLocalizations l) => [
    [l.summary, Icons.dashboard],
    [l.planets, Icons.public],
    [l.kundli, Icons.grid_on],
    [l.divisions, Icons.apps],
    [l.vimshottari, Icons.timeline],
    [l.moola, Icons.schedule],
    [l.gochar, Icons.wb_sunny],
    [l.dosh, Icons.warning],
    [l.yoga, Icons.auto_awesome],
    [l.shadbala, Icons.bar_chart],
    [l.ashtakavarga, Icons.table_chart],
    [l.aspects, Icons.hub],
    [l.bhava, Icons.home],
  ];

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: _sectionCount, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final resp = await _api.getKundliChart(widget.chartId);
      if (resp['statusCode'] == 200 && resp['status'] == 'success') {
        setState(() {
          _chart = (resp['data'] as Map).cast<String, dynamic>();
          _loading = false;
        });
        _prefetchComplete();
      } else {
        setState(() {
          _error = (resp['detail'] is Map ? (resp['detail'] as Map)['error'] : resp['detail'])?.toString() ?? 'Failed to load';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  Future<void> _prefetchComplete() async {
    try {
      final resp = await _api.getKundliAnalysisComplete(widget.chartId);
      if (!mounted) return;
      if (resp['statusCode'] == 200 && resp['status'] == 'success') {
        setState(() {
          _complete = (resp['data'] as Map).cast<String, dynamic>();
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(widget.clientName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
          Text(l.completeBirthChart, style: const TextStyle(color: AppColors.primary, fontSize: 11)),
        ]),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _load)],
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: _sections(AppLocalizations.of(context)!).map((s) => Tab(
            icon: Icon(s[1] as IconData, size: 16),
            text: s[0] as String,
          )).toList(),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _error != null
              ? _errorView()
              : _chart == null
                  ? const SizedBox.shrink()
                  : TabBarView(
                      controller: _tabs,
                      children: [
                        SummaryTabWidget(chart: _chart!, complete: _complete),
                        PlanetPositionsWidget(planetsMap: _planetsMap()),
                        _KundliTab(chart: _chart!),
                        DivisionalChartsWidget(chartId: widget.chartId, divisionalsMap: _divisionalsMap(), planetsMap: _planetsMap()),
                        DashaTreeWidget(chartId: widget.chartId, type: 'vimshottari'),
                        DashaTreeWidget(chartId: widget.chartId, type: 'moola'),
                        GocharWidget(chartId: widget.chartId, rashiIdx: _moonRashiIdx()),
                        DoshWidget(chartId: widget.chartId, initial: _complete?['dosh_analysis']),
                        YogaWidget(chartId: widget.chartId, initial: _complete?['yoga_analysis']),
                        ShadbalaWidget(chartId: widget.chartId, initial: _complete?['shadbala']),
                        AshtakavargaWidget(chartId: widget.chartId),
                        AspectsWidget(chartId: widget.chartId),
                        BhavaWidget(chartId: widget.chartId, initial: _complete?['bhava_strength']),
                      ],
                    ),
    );
  }

  Map<String, dynamic> _planetsMap() =>
      ((_chart?['planets'] as Map?) ?? {}).cast<String, dynamic>();

  // Native's Moon rashi index (0=Aries…11=Pisces) — drives the Gochar tab.
  int _moonRashiIdx() {
    final moon = ((_chart?['planets'] as Map?)?['Moon'] as Map?)?.cast<String, dynamic>();
    return (moon?['sign_idx'] as num?)?.toInt() ?? 0;
  }

  Map<String, dynamic> _divisionalsMap() =>
      ((_chart?['divisionals'] as Map?) ?? {}).cast<String, dynamic>();

  Widget _errorView() => Center(child: Padding(
    padding: const EdgeInsets.all(24),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.error_outline, color: AppColors.error, size: 48),
      const SizedBox(height: 12),
      Text(_error!, style: const TextStyle(color: AppColors.textSecondary), textAlign: TextAlign.center),
      const SizedBox(height: 16),
      ElevatedButton(onPressed: _load, child: Text(AppLocalizations.of(context)!.retry)),
    ]),
  ));
}




// ═══════════════════════════════════════════════════════════════════
//  KUNDLI TAB (Lagna / Moon / Sun switcher)
// ═══════════════════════════════════════════════════════════════════

class _KundliTab extends StatefulWidget {
  final Map<String, dynamic> chart;
  const _KundliTab({required this.chart});

  @override
  State<_KundliTab> createState() => _KundliTabState();
}

class _KundliTabState extends State<_KundliTab> {
  String _base = 'Lagna';

  @override
  Widget build(BuildContext context) {
    final planets = (widget.chart['planets'] as Map? ?? {}).cast<String, dynamic>();
    // Build houses relative to base planet
    final basePlanet = (planets[_base] as Map?)?.cast<String, dynamic>();
    final baseSignIdx = (basePlanet?['sign_idx'] as num?)?.toInt() ?? 0;

    final byRashi = <int, List<Map<String, dynamic>>>{};
    planets.forEach((name, planetData) {
      if (name == 'Lagna') return;
      final p = (planetData as Map).cast<String, dynamic>();
      final si = (p['sign_idx'] as num?)?.toInt() ?? 0;
      byRashi.putIfAbsent(si, () => []).add({
        'planet': (p['planet_local'] ?? name),
        'sign': p['sign'],
        'degree': p['degree'],
        'dignity': p['dignity'],
        'flags': [
          if (p['vakri'] == true) 'R',
          if (p['combust'] == true) 'C',
          if (p['vargottam'] == true) 'V',
        ],
      });
    });

    final lagnaSignIdx = ((planets['Lagna'] as Map?)?.cast<String, dynamic>()?['sign_idx'] as num?)?.toInt() ?? 0;

    final houses = List.generate(12, (h) {
      final ri = (baseSignIdx + h) % 12;
      return {
        'house': h + 1,
        'rashi_idx': ri,
        'rashi_short': _signShort(ri),
        'rashi': _signFull(ri),
        'planets': byRashi[ri] ?? [],
        'is_lagna': ri == lagnaSignIdx,
      };
    });

    return ListView(padding: const EdgeInsets.all(16), children: [
      SegmentedButton<String>(
        segments: [
          ButtonSegment(value: 'Lagna', label: Text(l.lagna)),
          ButtonSegment(value: 'Moon', label: Text(l.moon)),
          ButtonSegment(value: 'Sun', label: Text(l.sun)),
        ],
        selected: {_base},
        onSelectionChanged: (s) => setState(() => _base = s.first),
      ),
      const SizedBox(height: 12),
      Text('$_base Chart — ${basePlanet?['sign_full_local'] ?? basePlanet?['sign_full'] ?? ''}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w700)),
      const SizedBox(height: 12),
      NorthIndianChartWidget(houses: houses, chartTitle: '$_base Chart'),
    ]);
  }

  static const _signsShort = ['Ar','Ta','Ge','Cn','Le','Vi','Li','Sc','Sg','Cp','Aq','Pi'];
  static const _signsFull = ['Aries','Taurus','Gemini','Cancer','Leo','Virgo','Libra','Scorpio','Sagittarius','Capricorn','Aquarius','Pisces'];
  String _signShort(int i) => _signsShort[i % 12];
  String _signFull(int i) => _signsFull[i % 12];
}
