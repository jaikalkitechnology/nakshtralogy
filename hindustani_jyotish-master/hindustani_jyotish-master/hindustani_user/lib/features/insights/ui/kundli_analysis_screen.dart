import 'package:flutter/material.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/responsive.dart';
import '../insight_models.dart';
import '../insights_repository.dart';
import 'cosmic_labels.dart';
import 'full_response_view.dart';
import 'kundli_chart.dart';
import 'kundli_dasha_tree.dart';
import 'kundli_divisional_charts.dart';
import 'kundli_section_scaffold.dart';
import 'kundli_section_views.dart';

/// Full-screen tabbed Vedic kundli viewer for a saved/generated chart.
///
/// [chartId] is the `KundliReport` id (the same id My Reports lists and a
/// fresh `/kundli/generate` returns under `report.id`). The `/chart` payload
/// loads first; `/analysis/complete` is prefetched to seed the analysis tabs
/// so they render instantly. Every tab lazy-loads via a [SectionLoader].
/// There is NO Moola tab — Moola is excluded everywhere.
class KundliAnalysisScreen extends StatefulWidget {
  const KundliAnalysisScreen({super.key, required this.chartId, this.subjectName});
  final String chartId;
  final String? subjectName;

  @override
  State<KundliAnalysisScreen> createState() => _KundliAnalysisScreenState();
}

class _KundliAnalysisScreenState extends State<KundliAnalysisScreen>
    with TickerProviderStateMixin {
  static const _tabCount = 12;

  late final TabController _tabs = TabController(length: _tabCount, vsync: this);
  final _repo = getIt<InsightsRepository>();

  Map<String, dynamic>? _chart;
  Map<String, dynamic>? _complete;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final chart = await _repo.kundliChart(widget.chartId);
      if (!mounted) return;
      setState(() {
        _chart = chart;
        _loading = false;
      });
      _prefetchComplete();
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = AppLocalizations.of(context).commonErrorGeneric;
        _loading = false;
      });
    }
  }

  Future<void> _prefetchComplete() async {
    try {
      final data = await _repo.kundliComplete(widget.chartId);
      if (!mounted) return;
      setState(() => _complete = data);
    } catch (_) {
      // Non-fatal: each analysis tab still loads its own section on demand.
    }
  }

  Map<String, dynamic>? _seed(String key) {
    final v = _complete?[key];
    return v is Map ? v.cast<String, dynamic>() : null;
  }

  /// The complete localized analysis for the "Complete Report" viewer — the
  /// full `/analysis/complete` bundle, with the chart section injected. Null
  /// until at least the chart has loaded.
  Map<String, dynamic>? get _completeForViewer {
    final c = _complete, ch = _chart;
    if (c == null && ch == null) return null;
    return {
      if (ch != null) 'chart': ch,
      if (c != null) ...c,
    };
  }

  int? get _moonSign {
    final moon = (_chart?['planets'] as Map?)?['Moon'];
    if (moon is Map) return (moon['sign_idx'] as num?)?.toInt();
    return null;
  }

  List<({String label, IconData icon})> _sections(AppLocalizations l) => [
        (label: l.kunSummary, icon: Icons.dashboard_outlined),
        (label: l.kunPlanets, icon: Icons.public),
        (label: l.kunKundli, icon: Icons.grid_on),
        (label: l.kunDivisions, icon: Icons.apps),
        (label: l.kunVimshottari, icon: Icons.timeline),
        (label: l.kunGochar, icon: Icons.wb_sunny_outlined),
        (label: l.kunDosh, icon: Icons.warning_amber_outlined),
        (label: l.kunYoga, icon: Icons.auto_awesome_outlined),
        (label: l.kunShadbala, icon: Icons.bar_chart),
        (label: l.kunAshtakavarga, icon: Icons.table_chart_outlined),
        (label: l.kunAspects, icon: Icons.hub_outlined),
        (label: l.kunBhava, icon: Icons.home_outlined),
      ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.subjectName ?? '${_chart?['name'] ?? l.kunSummary}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.heading(size: 16)),
            Text(l.kunFullAnalysis,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.label(size: 11, color: AppColors.copperLight)),
          ],
        ),
        actions: [
          if (_completeForViewer != null)
            IconButton(
              tooltip: cosmicUi(
                  'view_full', Localizations.localeOf(context).languageCode),
              onPressed: () => Navigator.of(context).push(
                CosmicFullReportPage.route(
                  widget.subjectName ?? '${_chart?['name'] ?? l.kunFullAnalysis}',
                  _completeForViewer!,
                ),
              ),
              icon: const Icon(Icons.article_outlined),
            ),
          IconButton(
              onPressed: _loading ? null : _load, icon: const Icon(Icons.refresh)),
        ],
        bottom: _chart == null
            ? null
            : TabBar(
                controller: _tabs,
                isScrollable: true,
                labelColor: AppColors.saffron,
                unselectedLabelColor: AppColors.ivoryFaint,
                indicatorColor: AppColors.saffron,
                tabs: [
                  for (final s in _sections(l))
                    Tab(icon: Icon(s.icon, size: 16), text: s.label),
                ],
              ),
      ),
      body: SafeArea(
        child: CenteredMaxWidth(
          maxWidth: Responsive.readableMaxWidth,
          child: _body(l),
        ),
      ),
    );
  }

  Widget _body(AppLocalizations l) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.saffron));
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.error_outline, color: AppColors.danger, size: 48),
            const SizedBox(height: 12),
            Text(_error!,
                textAlign: TextAlign.center,
                style: AppTextStyles.body(color: AppColors.ivoryDim)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _load, child: Text(l.kunRetry)),
          ]),
        ),
      );
    }
    final chart = _chart;
    if (chart == null) return const SizedBox.shrink();
    return TabBarView(
      controller: _tabs,
      children: [
        KundliSummaryView(chart: chart, complete: _complete),
        KundliPlanetsView(chart: chart),
        _KundliTab(chart: chart),
        KundliDivisionalCharts(chart: chart),
        KundliDashaTree(chartId: widget.chartId),
        KundliGocharView(chartId: widget.chartId, moonSign: _moonSign),
        KundliDoshView(chartId: widget.chartId, initial: _seed('dosh_analysis')),
        KundliYogaView(chartId: widget.chartId, initial: _seed('yoga_analysis')),
        KundliShadbalaView(chartId: widget.chartId, initial: _seed('shadbala')),
        KundliAshtakavargaView(
            chartId: widget.chartId, initial: _seed('ashtakavarga')),
        KundliAspectsView(chartId: widget.chartId, initial: _seed('aspect_matrix')),
        KundliBhavaView(chartId: widget.chartId, initial: _seed('bhava_strength')),
      ],
    );
  }
}

/// The main Rashi (D1) chart tab: big North-Indian diagram + lagna details.
class _KundliTab extends StatelessWidget {
  const _KundliTab({required this.chart});
  final Map<String, dynamic> chart;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final k = KundliResult.fromData(chart);
    final lagnaIdx = k.lagna?.signIdx;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      children: [
        if (lagnaIdx != null && k.planets.isNotEmpty) ...[
          KundliSectionCard(
            title: l.kundliChartTitle,
            icon: Icons.grid_on,
            subtitle: l.kundliRetroLegend,
            child: KundliChart(lagnaSignIdx: lagnaIdx, planets: k.planets),
          ),
        ] else
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(l.kunNoData,
                  style: AppTextStyles.body(color: AppColors.ivoryFaint)),
            ),
          ),
        if (k.lagna != null)
          KundliSectionCard(
            title: l.kundliLagnaLabel,
            icon: Icons.explore_outlined,
            child: Text(
              [
                k.lagna!.signFull ?? k.lagna!.sign,
                if (k.lagna!.degree != null) '${k.lagna!.degree!.toStringAsFixed(2)}°',
                if (k.lagna!.nakshatra != null)
                  '${k.lagna!.nakshatra}${k.lagna!.pada != null ? ' · ${l.colPada} ${k.lagna!.pada}' : ''}',
              ].whereType<String>().join('  ·  '),
              style: AppTextStyles.body(size: 14, color: AppColors.ivoryDim),
            ),
          ),
      ],
    );
  }
}
