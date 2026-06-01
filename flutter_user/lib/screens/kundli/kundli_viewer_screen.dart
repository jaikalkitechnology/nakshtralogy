import 'package:flutter/material.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import 'paywall.dart';
import 'widgets/planet_positions_widget.dart';
import 'widgets/north_indian_chart.dart';
import 'widgets/divisional_charts_widget.dart';
import 'widgets/dasha_tree_widget.dart';
import 'widgets/dosh_widget.dart';
import 'widgets/yoga_widget.dart';
import 'widgets/shadbala_widget.dart';
import 'widgets/ashtakavarga_widget.dart';
import 'widgets/aspects_widget.dart';
import 'widgets/life_areas_widget.dart';
import 'widgets/bhava_widget.dart';
import 'widgets/chakra_health_widget.dart';
import 'widgets/dasha_activation_widget.dart';
import 'widgets/gochar_widget.dart';
import 'widgets/career_widget.dart';
import 'widgets/character_widget.dart';

/// User-side kundli viewer with per-tab paywall.
/// Fetches only the lightweight chart on open; each tab paywall-gates its
/// content via [PaywallService]. Free sections pass through automatically;
/// paid sections prompt a purchase dialog that debits the wallet.
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

  static const _sectionCount = 18;

  // [label, icon, section-key used by paywall]
  static List<List<Object>> _sections(AppLocalizations l) => <List<Object>>[
    [l.summary, Icons.dashboard, 'summary'],
    [l.planets, Icons.public, 'planets'],
    [l.kundli, Icons.grid_on, 'kundli'],
    [l.divisions, Icons.apps, 'divisions'],
    [l.vimshottari, Icons.timeline, 'vimshottari'],
    [l.moola, Icons.schedule, 'moola'],
    [l.gochar, Icons.wb_sunny, 'gochar'],
    [l.dosh, Icons.warning, 'dosh'],
    [l.yoga, Icons.auto_awesome, 'yoga'],
    [l.shadbala, Icons.bar_chart, 'shadbala'],
    [l.ashtakavarga, Icons.table_chart, 'ashtakavarga'],
    [l.aspects, Icons.hub, 'aspects'],
    [l.lifeAreas, Icons.work, 'life_areas'],
    [l.bhava, Icons.home, 'bhava'],
    [l.chakras, Icons.radio_button_checked, 'chakra'],
    [l.dashaActive, Icons.flash_on, 'dasha_activation'],
    ['Career', Icons.business_center, 'career'],
    ['Character', Icons.person_search, 'character'],
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
    final sections = _sections(l);
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
          tabs: sections.map((s) => Tab(
            icon: Icon(s[1] as IconData, size: 16),
            text: s[0] as String,
          )).toList(),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _error != null
              ? _errorView(l)
              : _chart == null
                  ? const SizedBox.shrink()
                  : TabBarView(
                      controller: _tabs,
                      children: [
                        _PaidTab(chartId: widget.chartId, section: 'summary',
                            builder: (_) => _SummaryTab(chart: _chart!)),
                        _PaidTab(chartId: widget.chartId, section: 'planets',
                            builder: (_) => PlanetPositionsWidget(planetsMap: _planetsMap())),
                        _PaidTab(chartId: widget.chartId, section: 'kundli',
                            builder: (_) => _KundliTab(chart: _chart!)),
                        _PaidTab(chartId: widget.chartId, section: 'divisions',
                            builder: (_) => DivisionalChartsWidget(chartId: widget.chartId, divisionalsMap: _divisionalsMap())),
                        _PaidTab(chartId: widget.chartId, section: 'vimshottari',
                            builder: (_) => DashaTreeWidget(chartId: widget.chartId, type: 'vimshottari')),
                        _PaidTab(chartId: widget.chartId, section: 'moola',
                            builder: (_) => DashaTreeWidget(chartId: widget.chartId, type: 'moola')),
                        _PaidTab(chartId: widget.chartId, section: 'gochar',
                            builder: (_) => GocharWidget(chartId: widget.chartId)),
                        _PaidTab(chartId: widget.chartId, section: 'dosh',
                            builder: (_) => DoshWidget(chartId: widget.chartId, initial: _complete?['dosh_analysis'])),
                        _PaidTab(chartId: widget.chartId, section: 'yoga',
                            builder: (_) => YogaWidget(chartId: widget.chartId, initial: _complete?['yoga_analysis'])),
                        _PaidTab(chartId: widget.chartId, section: 'shadbala',
                            builder: (_) => ShadbalaWidget(chartId: widget.chartId, initial: _complete?['shadbala'])),
                        _PaidTab(chartId: widget.chartId, section: 'ashtakavarga',
                            builder: (_) => AshtakavargaWidget(chartId: widget.chartId)),
                        _PaidTab(chartId: widget.chartId, section: 'aspects',
                            builder: (_) => AspectsWidget(chartId: widget.chartId)),
                        _PaidTab(chartId: widget.chartId, section: 'life_areas',
                            builder: (_) => LifeAreasWidget(chartId: widget.chartId, initial: _complete?['life_areas'])),
                        _PaidTab(chartId: widget.chartId, section: 'bhava',
                            builder: (_) => BhavaWidget(chartId: widget.chartId, initial: _complete?['bhava_strength'])),
                        _PaidTab(chartId: widget.chartId, section: 'chakra',
                            builder: (_) => ChakraHealthWidget(chartId: widget.chartId, initial: _complete?['chakra_health'])),
                        _PaidTab(chartId: widget.chartId, section: 'dasha_activation',
                            builder: (_) => DashaActivationWidget(chartId: widget.chartId)),
                        _PaidTab(chartId: widget.chartId, section: 'career',
                            builder: (_) => CareerWidget(chartId: widget.chartId)),
                        _PaidTab(chartId: widget.chartId, section: 'character',
                            builder: (_) => CharacterWidget(chartId: widget.chartId)),
                      ],
                    ),
    );
  }

  Map<String, dynamic> _planetsMap() =>
      ((_chart?['planets'] as Map?) ?? {}).cast<String, dynamic>();

  Map<String, dynamic> _divisionalsMap() =>
      ((_chart?['divisionals'] as Map?) ?? {}).cast<String, dynamic>();

  Widget _errorView(AppLocalizations l) => Center(child: Padding(
    padding: const EdgeInsets.all(24),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.error_outline, color: AppColors.error, size: 48),
      const SizedBox(height: 12),
      Text(_error!, style: const TextStyle(color: AppColors.textSecondary), textAlign: TextAlign.center),
      const SizedBox(height: 16),
      ElevatedButton(onPressed: _load, child: Text(l.retry)),
    ]),
  ));
}


// ═══════════════════════════════════════════════════════════════════
//  PAID TAB WRAPPER
// ═══════════════════════════════════════════════════════════════════

/// Wraps a tab body with a paywall check. On first build it queries
/// [PaywallService.check]; if the user unlocks (or it's free) the builder
/// renders, otherwise a locked view invites them to retry.
class _PaidTab extends StatefulWidget {
  final String chartId;
  final String section;
  final WidgetBuilder builder;
  const _PaidTab({required this.chartId, required this.section, required this.builder});

  @override
  State<_PaidTab> createState() => _PaidTabState();
}

class _PaidTabState extends State<_PaidTab> with AutomaticKeepAliveClientMixin {
  bool _checking = true;
  bool _unlocked = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _run());
  }

  Future<void> _run() async {
    if (PaywallService.instance.isUnlocked(widget.chartId, widget.section)) {
      if (!mounted) return;
      setState(() { _unlocked = true; _checking = false; });
      return;
    }
    final ok = await PaywallService.instance.check(context, widget.chartId, widget.section);
    if (!mounted) return;
    setState(() { _unlocked = ok; _checking = false; });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_checking) return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    if (_unlocked) return widget.builder(context);
    return _LockedView(onUnlock: () {
      setState(() { _checking = true; });
      _run();
    });
  }
}

class _LockedView extends StatelessWidget {
  final VoidCallback onUnlock;
  const _LockedView({required this.onUnlock});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Center(child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.lock_outline, size: 56, color: AppColors.primary),
        const SizedBox(height: 16),
        Text(l.premiumSection, style: const TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text(l.unlockReading,
            textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: onUnlock,
          icon: const Icon(Icons.lock_open, size: 16),
          label: Text(l.unlock),
        ),
      ]),
    ));
  }
}


// ═══════════════════════════════════════════════════════════════════
//  SUMMARY TAB
// ═══════════════════════════════════════════════════════════════════

class _SummaryTab extends StatelessWidget {
  final Map<String, dynamic> chart;
  const _SummaryTab({required this.chart});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final planets = (chart['planets'] as Map? ?? {}).cast<String, dynamic>();
    final lagna = (planets['Lagna'] as Map?)?.cast<String, dynamic>();
    final moon = (planets['Moon'] as Map?)?.cast<String, dynamic>();
    final sun = (planets['Sun'] as Map?)?.cast<String, dynamic>();

    return ListView(padding: const EdgeInsets.all(16), children: [
      _birthCard(chart, l),
      const SizedBox(height: 12),
      if (lagna != null) _planetSummaryCard('Ascendant (Lagna)', lagna, AppColors.primary, Icons.wb_twilight),
      if (moon != null) _planetSummaryCard('Moon Sign (Rashi)', moon, AppColors.accent, Icons.nightlight_round),
      if (sun != null) _planetSummaryCard('Sun Sign', sun, Colors.orange, Icons.brightness_7),
      const SizedBox(height: 16),
      Text('Engine: ${chart['engine'] ?? '-'}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
    ]);
  }

  Widget _birthCard(Map<String, dynamic> chart, AppLocalizations l) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.info_outline, color: AppColors.primary, size: 18),
          const SizedBox(width: 8),
          Text(l.birthDetails, style: const TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 10),
        _row('Name', chart['name']?.toString() ?? ''),
        _row('DOB', chart['dob']?.toString() ?? ''),
        _row('TOB', chart['tob']?.toString() ?? ''),
        _row('Place', chart['place']?.toString() ?? ''),
      ]),
    );
  }

  Widget _planetSummaryCard(String title, Map<String, dynamic> m, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withOpacity(0.15), color.withOpacity(0.05)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Icon(icon, color: color, size: 20), const SizedBox(width: 8),
          Text(title, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700))]),
        const SizedBox(height: 10),
        Text('${m['sign_full']} (${m['sign']})',
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text('Degree: ${m['degree']}°  •  Nakshatra: ${m['nakshatra']} (${m['pada']})',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        Text('Nakshatra Lord: ${m['nak_lord']}  •  Dignity: ${m['dignity']}',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ]),
    );
  }

  Widget _row(String l, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(children: [
      SizedBox(width: 80, child: Text(l, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12))),
      Expanded(child: Text(v, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w500))),
    ]),
  );
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
    final basePlanet = (planets[_base] as Map?)?.cast<String, dynamic>();
    final baseSignIdx = (basePlanet?['sign_idx'] as num?)?.toInt() ?? 0;

    final byRashi = <int, List<Map<String, dynamic>>>{};
    planets.forEach((name, planetData) {
      if (name == 'Lagna') return;
      final p = (planetData as Map).cast<String, dynamic>();
      final si = (p['sign_idx'] as num?)?.toInt() ?? 0;
      byRashi.putIfAbsent(si, () => []).add({
        'planet': name,
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
          ButtonSegment(value: 'Lagna', label: Text('Lagna')),
          ButtonSegment(value: 'Moon', label: Text('Moon')),
          ButtonSegment(value: 'Sun', label: Text('Sun')),
        ],
        selected: {_base},
        onSelectionChanged: (s) => setState(() => _base = s.first),
      ),
      const SizedBox(height: 12),
      Text('$_base Chart — ${basePlanet?['sign_full'] ?? ''}',
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
