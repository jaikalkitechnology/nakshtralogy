import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../../utils/kundli_names.dart';
import '../kundli/widgets/kundli_ui.dart';

/// Debt & Recovery report — premium AI debt-coach redesign.
///
/// Presentation only. Loads the `debt_recovery` specialist
/// (`runSpecialist('debt_recovery')`) unchanged and re-presents it; every
/// score, karaka, yoga, timing window, remedy and confidence value comes
/// straight from the engine.
class DebtReportScreen extends StatefulWidget {
  final String chartId, chartName;
  final Map<String, dynamic>? preloadedData;
  const DebtReportScreen({super.key, required this.chartId, required this.chartName, this.preloadedData});
  @override
  State<DebtReportScreen> createState() => _DebtReportState();
}

class _DebtReportState extends State<DebtReportScreen> {
  final _api = ApiService();
  Map<String, dynamic>? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.preloadedData != null) { _data = widget.preloadedData; _loading = false; }
    else _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final resp = await _api.runSpecialist('debt_recovery', widget.chartId);
      if (!mounted) return;
      if (resp['statusCode'] == 200 && resp['status'] == 'success') {
        setState(() { _data = (resp['data'] as Map).cast<String, dynamic>(); _loading = false; });
      } else {
        setState(() { _error = resp['detail']?.toString() ?? 'Analysis failed'; _loading = false; });
      }
    } catch (e) { if (!mounted) return; setState(() { _error = e.toString(); _loading = false; }); }
  }

  // ── typed accessors (type-checked, never throw on unexpected shapes) ──
  double _sc(String k) { final v = _data?[k]; return v is num ? v.toDouble() : 0; }
  String _str(String k) { final v = _data?[k]; return (v == null || v is List || v is Map) ? '' : v.toString(); }
  List _list(String k) { final v = _data?[k]; return v is List ? v : const []; }
  Map<String, dynamic> _map(String k) { final v = _data?[k]; return v is Map ? v.cast<String, dynamic>() : {}; }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.ivory), onPressed: () => Navigator.pop(context)),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(widget.chartName, style: const TextStyle(color: AppColors.ivory, fontSize: 15, fontWeight: FontWeight.w700)),
          Text(l.dbSubtitle, style: const TextStyle(color: AppColors.gold, fontSize: 10)),
        ]),
        actions: [IconButton(icon: const Icon(Icons.refresh, color: AppColors.ivory, size: 18), onPressed: _load)],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : _error != null ? _errView(l)
          : _data == null ? const SizedBox.shrink()
          : ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 40), children: _sections(l)),
    );
  }

  List<Widget> _sections(AppLocalizations l) {
    // Sections render directly (no staggered fade wrapper) — a tall hero pushes
    // lower sections past the viewport, and a per-section entrance animation
    // there can stick at opacity 0 and leave the lower report blank.
    const gap = SizedBox(height: 18);
    return [
      _breadcrumb(l),
      const SizedBox(height: 10),
      _snapshot(l),          // 1
      gap, _profile(l),         // 2
      gap, _karakaTable(l),     // 3
      gap, _verification(l),    // 4
      gap, _yogas(l),           // 5
      gap, _categories(l),      // 6
      gap, _timeline(l),        // 7
      gap, _borrowing(l),       // 8
      gap, _riskWatch(l),       // 9
      gap, _crisisPrep(l),      // 10
      gap, _family(l),          // 11
      gap, _psychology(l),      // 12
      gap, _improvementPlan(l), // 13
      gap, _roadmap(l),         // 14
      gap, _reliability(l),     // 15
      gap, _discussAi(l),       // 16
    ];
  }

  Widget _breadcrumb(AppLocalizations l) => Row(children: [
    Text(l.crCrumbHome, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Text(l.crCrumbReports, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Flexible(child: Text(l.dbTitle, style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
  ]);

  // ══════════════════════════════════════════════════════════════════
  //  1 — DEBT RECOVERY SNAPSHOT
  // ══════════════════════════════════════════════════════════════════
  Widget _snapshot(AppLocalizations l) {
    final capacity = _sc('debt_recovery_capacity_score');
    final probability = _sc('recovery_probability_pct');
    final freedomNow = (100 - _sc('current_debt_load_score')).clamp(0, 100).toDouble();
    final dtiHealth = _sc('debt_to_income_health_score');
    final resilience = _sc('psychological_resilience_score');
    final overall = ((capacity + probability + freedomNow + dtiHealth + resilience) / 5).clamp(0, 100).toDouble();
    final col = _debtColor(overall);
    final verdict = _str('recovery_verdict');
    final years = _str('timeline_to_debt_free_years');
    final phase = _titleCase(_str('active_debt_phase'));
    final personality = _titleCase(_str('debt_personality'));
    final summary = phase.isNotEmpty && personality.isNotEmpty
        ? l.dbHeroSummary(phase, personality, probability.toStringAsFixed(0), years.isNotEmpty ? years : '?')
        : _str('plain_statement');
    final gauges = <List<Object>>[
      [l.dbGaugeCapacity, capacity],
      [l.dbGaugeProbability, probability],
      [l.dbGaugeFreedomNow, freedomNow],
      [l.dbGaugeDti, dtiHealth],
      [l.dbGaugeResilience, resilience],
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [col.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
        borderRadius: BorderRadius.circular(22), border: Border.all(color: col.withOpacity(0.3)),
      ),
      child: Column(children: [
        Text(l.dbSnapshotHeader.toUpperCase(), style: const TextStyle(color: AppColors.smoke, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
        const SizedBox(height: 14),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: overall / 100), duration: const Duration(milliseconds: 900), curve: Curves.easeOutCubic,
          builder: (_, v, __) => SizedBox(width: 140, height: 140, child: Stack(alignment: Alignment.center, children: [
            SizedBox(width: 140, height: 140, child: CircularProgressIndicator(value: v, strokeWidth: 12, strokeCap: StrokeCap.round,
              backgroundColor: Colors.white.withOpacity(0.07), valueColor: AlwaysStoppedAnimation(col))),
            Column(mainAxisSize: MainAxisSize.min, children: [
              Text((v * 100).toStringAsFixed(0), style: TextStyle(color: col, fontSize: 44, fontWeight: FontWeight.w800, height: 1)),
              Text('/100', style: TextStyle(color: col.withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.w600)),
            ]),
          ])),
        ),
        const SizedBox(height: 10),
        if (verdict.isNotEmpty) Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(color: col.withOpacity(0.16), borderRadius: BorderRadius.circular(20)),
          child: Text(verdict, style: TextStyle(color: col, fontSize: 14, fontWeight: FontWeight.w800))),
        if (summary.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(color: AppColors.midnight.withOpacity(0.35), borderRadius: BorderRadius.circular(14)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('🤖', style: TextStyle(fontSize: 14)), const SizedBox(width: 9),
              Expanded(child: Text(_cap(summary), style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, height: 1.5))),
            ])),
        ],
        const SizedBox(height: 18),
        Wrap(alignment: WrapAlignment.center, spacing: 14, runSpacing: 14,
          children: gauges.map((g) => _miniGauge(g[0] as String, g[1] is num ? (g[0] as String, g[1] as num).toDouble() : 0.0)).toList()),
        const SizedBox(height: 16),
        Wrap(alignment: WrapAlignment.center, spacing: 8, runSpacing: 8, children: _snapshotChips(l).map((t) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
          decoration: BoxDecoration(color: KColors.green.withOpacity(0.10), borderRadius: BorderRadius.circular(20), border: Border.all(color: KColors.green.withOpacity(0.28))),
          child: Text('✓ $t', style: const TextStyle(color: KColors.green, fontSize: 11.5, fontWeight: FontWeight.w700)),
        )).toList()),
      ]),
    );
  }

  List<String> _snapshotChips(AppLocalizations l) {
    final out = <String>[];
    if (_str('debt_karma_signature').toLowerCase() == 'clean') out.add(l.dbChipCleanKarma);
    if (_sc('debt_recovery_capacity_score') >= 70) out.add(l.dbChipStrongRecovery);
    if (_str('dti_category').toLowerCase() == 'healthy') out.add(l.dbChipHealthyDti);
    if (_sc('psychological_resilience_score') >= 60) out.add(l.dbChipResilient);
    if (_sc('cycle_break_feasibility') >= 60) out.add(l.dbChipCycleBreakable);
    if (_sc('chronic_debt_probability') < 40) out.add(l.dbChipLowReindebt);
    if (_sc('negotiation_success_probability') >= 60) out.add(l.dbChipGoodNegotiator);
    return out.toSet().take(6).toList();
  }

  Widget _miniGauge(String label, double score) {
    final col = _debtColor(score);
    return SizedBox(width: 92, child: Column(children: [
      SizedBox(width: 62, height: 62, child: Stack(alignment: Alignment.center, children: [
        SizedBox(width: 62, height: 62, child: CircularProgressIndicator(value: (score / 100).clamp(0, 1), strokeWidth: 6, strokeCap: StrokeCap.round,
          backgroundColor: Colors.white.withOpacity(0.07), valueColor: AlwaysStoppedAnimation(col))),
        Text(score.toStringAsFixed(0), style: TextStyle(color: col, fontSize: 15, fontWeight: FontWeight.w800)),
      ])),
      const SizedBox(height: 6),
      Text(label, style: const TextStyle(color: AppColors.parchment, fontSize: 10, fontWeight: FontWeight.w600), textAlign: TextAlign.center, maxLines: 2),
    ]));
  }

  // ══════════════════════════════════════════════════════════════════
  //  2 — YOUR DEBT PROFILE
  // ══════════════════════════════════════════════════════════════════
  Widget _profile(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    final personality = _titleCase(_str('debt_personality'));
    if (personality.isEmpty) return const SizedBox.shrink();
    final karaka = KundliNames.planet(_str('primary_debt_karaka'), loc);
    final protector = KundliNames.planet(_str('creditor_protection_planet'), loc);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.account_balance_wallet_rounded, title: l.dbProfileTitle, color: AppColors.gold),
      Container(padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.gold.withOpacity(0.14), AppColors.card.withOpacity(0.4)]),
          borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.gold.withOpacity(0.28))),
        child: Column(children: [
          Text(personality, style: const TextStyle(color: AppColors.gold, fontSize: 19, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Wrap(alignment: WrapAlignment.center, spacing: 6, runSpacing: 6, children: [
            if (_str('debt_karma_signature').isNotEmpty) _pill(_titleCase(_str('debt_karma_signature')), KColors.green),
            if (_str('active_debt_phase').isNotEmpty) _pill('${l.dbPhaseLabel}: ${_titleCase(_str('active_debt_phase'))}', KColors.blue),
            if (_str('primary_debt_category').isNotEmpty) _pill('${l.dbPrimaryCategoryLabel}: ${_titleCase(_str('primary_debt_category'))}', KColors.orange),
          ]),
        ])),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _iconTile('🪐', l.dbKarakaLabel, karaka)),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('🛡️', l.dbProtectorLabel, protector)),
      ]),
      _advanced(l, [
        if (_list('secondary_debt_categories').isNotEmpty) '${l.dbSecondaryCategories}: ${_list('secondary_debt_categories').map((e) => _titleCase(e.toString())).join(', ')}',
        '${l.dbUnsecuredRatio}: ${(_sc('unsecured_vs_secured_ratio') * 100).toStringAsFixed(0)}%',
      ]),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  3 — YOUR DEBT PLANETS (karaka strength table)
  // ══════════════════════════════════════════════════════════════════
  Widget _karakaTable(AppLocalizations l) {
    final map = _map('karaka_strength_table');
    if (map.isEmpty) return const SizedBox.shrink();
    final loc = Localizations.localeOf(context);
    final sorted = map.entries.where((e) => e.value is num).toList()..sort((a, b) => (b.value is num ? b.value as num : 0).compareTo(a.value is num ? a.value as num : 0));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.insights_rounded, title: l.dbKarakaTitle, subtitle: l.dbKarakaSubtitle, color: KColors.purple),
      _card(child: Column(children: sorted.map((e) {
        final v = (e.value is num ? e.value as num : 0).toDouble();
        final c = _debtColor(v);
        return Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(children: [
          SizedBox(width: 80, child: Text(KundliNames.planet(e.key, loc), style: TextStyle(color: c, fontSize: 11.5, fontWeight: FontWeight.w700))),
          Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(value: (v / 100).clamp(0, 1), minHeight: 6, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
          const SizedBox(width: 8),
          SizedBox(width: 30, child: Text(v.toStringAsFixed(0), textAlign: TextAlign.right, style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w800))),
        ]));
      }).toList())),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  4 — VERIFIED ACROSS CHARTS (D6)
  // ══════════════════════════════════════════════════════════════════
  Widget _verification(AppLocalizations l) {
    final d6 = _map('d6_validation');
    if (d6.isEmpty) return const SizedBox.shrink();
    final score = (d6['d6_score'] is num ? d6['d6_score'] as num : null)?.toDouble() ?? 0;
    final reasons = (d6['reasons'] is List) ? (d6['reasons'] as List).map((e) => e.toString()).toList() : <String>[];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.verified_rounded, title: l.dbVerificationTitle, color: KColors.green),
      _chartCard(l, l.dbD6Label, score, d6['label']?.toString() ?? '', [
        '${l.dbD6LordDignity}: ${d6['d6_6_lord_dignity'] ?? ''}',
        '${l.dbD6Severity}: ${_titleCase(d6['debt_karma_severity']?.toString() ?? '')}',
        '${l.dbD6Multiplier}: ${(d6['d6_debt_multiplier'] is num ? d6['d6_debt_multiplier'] as num : null)?.toStringAsFixed(2) ?? ''}',
        ...reasons,
      ]),
    ]);
  }

  Widget _chartCard(AppLocalizations l, String title, double score, String explain, List<String> tech) {
    final col = _debtColor(score);
    final status = score >= 60 ? l.crStatusStrongSupport : score >= 40 ? l.crStatusModerateSupport : l.crStatusNeedsImprovement;
    return Container(
      margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: col.withOpacity(0.06), borderRadius: BorderRadius.circular(16), border: Border.all(color: col.withOpacity(0.22))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(title, style: const TextStyle(color: AppColors.ivory, fontSize: 13.5, fontWeight: FontWeight.w800))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(color: col.withOpacity(0.16), borderRadius: BorderRadius.circular(8)),
            child: Text(status, style: TextStyle(color: col, fontSize: 10, fontWeight: FontWeight.w800))),
        ]),
        if (explain.isNotEmpty) ...[const SizedBox(height: 8),
          Text(_cap(explain), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))],
        _advanced(l, tech),
      ]),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  //  5 — DEBT YOGAS & PROTECTIONS
  // ══════════════════════════════════════════════════════════════════
  Widget _yogas(AppLocalizations l) {
    final creating = _list('active_debt_creating_yogas').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final clearing = _list('active_debt_clearing_yogas').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    if (creating.isEmpty && clearing.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.auto_awesome_rounded, title: l.dbYogasTitle, color: AppColors.gold),
      Row(children: [
        Expanded(child: _statTile(l.dbPressureNow, _sc('total_debt_pressure_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.dbRecoveryBoost, _sc('total_recovery_boost'))),
      ]),
      const SizedBox(height: 10),
      if (clearing.isNotEmpty) ...[
        _catLabel('🛡️', l.dbClearingLabel, KColors.green),
        ...clearing.take(6).map((m) => _yogaRow(m['name']?.toString() ?? '', (m['score'] is num ? m['score'] as num : null)?.toDouble() ?? 0, KColors.green)),
        const SizedBox(height: 6),
      ],
      if (creating.isNotEmpty) ...[
        _catLabel('⚠️', l.dbCreatingLabel, KColors.orange),
        ...creating.take(6).map((m) => _yogaRow(m['name']?.toString() ?? '', (m['score'] is num ? m['score'] as num : null)?.toDouble() ?? 0, KColors.orange)),
      ],
    ]);
  }

  Widget _yogaRow(String name, double score, Color c) => Container(
    margin: const EdgeInsets.only(bottom: 7), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
    decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(12), border: Border.all(color: c.withOpacity(0.2))),
    child: Row(children: [
      Expanded(child: Text(name, style: const TextStyle(color: AppColors.ivory, fontSize: 12, fontWeight: FontWeight.w700))),
      Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: c, fontSize: 12.5, fontWeight: FontWeight.w800)),
    ]),
  );

  // ══════════════════════════════════════════════════════════════════
  //  6 — DEBT CATEGORIES WATCH
  // ══════════════════════════════════════════════════════════════════
  Widget _categories(AppLocalizations l) {
    final cats = _map('debt_category_scores');
    if (cats.isEmpty) return const SizedBox.shrink();
    final sorted = cats.entries.where((e) => e.value is num).toList()..sort((a, b) => (b.value is num ? b.value as num : 0).compareTo(a.value is num ? a.value as num : 0));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.category_rounded, title: l.dbCategoriesTitle, subtitle: l.dbCategoriesSubtitle, color: KColors.orange),
      _card(child: Column(children: sorted.take(11).map((e) {
        final v = (e.value is num ? e.value as num : 0).toDouble();
        final c = _riskColor(v);
        return Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children: [
          SizedBox(width: 108, child: Text(_titleCase(e.key), style: const TextStyle(color: AppColors.ivory, fontSize: 10.5))),
          Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(value: (v / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
          const SizedBox(width: 6),
          SizedBox(width: 30, child: Text(v.toStringAsFixed(0), textAlign: TextAlign.right, style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.w700))),
        ]));
      }).toList())),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  7 — DEBT-FREE TIMELINE
  // ══════════════════════════════════════════════════════════════════
  Widget _timeline(AppLocalizations l) {
    final trend = _list('yearly_debt_trend').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final window = _map('debt_free_window');
    final peakYears = _list('debt_peak_years').map((e) => e.toString()).toList();
    final clearanceYears = _list('debt_clearance_years').map((e) => e.toString()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.timeline_rounded, title: l.dbTimelineTitle, color: AppColors.gold),
      if (window.isNotEmpty) _freeWindowCard(l, window),
      if (_str('estimated_full_clearance_age').isNotEmpty) Padding(padding: const EdgeInsets.only(bottom: 10),
        child: _pill('${l.dbClearanceEstimate}: ${_str('estimated_full_clearance_age')}', KColors.blue)),
      if (peakYears.isNotEmpty) _chipBlock('⚠️', l.dbPeakYears, peakYears, KColors.orange),
      if (clearanceYears.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('🎉', l.dbClearanceYears, clearanceYears, KColors.green)],
      if (trend.isNotEmpty) ...[const SizedBox(height: 10), _trendChart(trend)],
    ]);
  }

  Widget _freeWindowCard(AppLocalizations l, Map<String, dynamic> w) => Container(
    margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [KColors.green.withOpacity(0.12), KColors.green.withOpacity(0.04)]),
      borderRadius: BorderRadius.circular(16), border: Border.all(color: KColors.green.withOpacity(0.3))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(l.dbFreeWindowLabel, style: const TextStyle(color: KColors.green, fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.w700)),
      const SizedBox(height: 6),
      Text(w['year']?.toString() ?? '', style: const TextStyle(color: AppColors.ivory, fontSize: 18, fontWeight: FontWeight.w800)),
      if (w['dasha'] != null) Text(l.dashaLabel(w['dasha'].toString()), style: const TextStyle(color: KColors.green, fontSize: 11, fontWeight: FontWeight.w600)),
      if (w['note'] != null) Text(w['note'].toString(), style: const TextStyle(color: AppColors.lavender, fontSize: 10.5, fontStyle: FontStyle.italic)),
    ]),
  );

  Widget _trendChart(List<Map<String, dynamic>> trend) {
    return _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: trend.take(12).map((y) {
      final year = y['year']?.toString() ?? '';
      final pressure = (y['debt_pressure'] is num ? y['debt_pressure'] as num : null)?.toDouble() ?? 0;
      final peak = y['is_debt_peak_year'] == true;
      final clearance = y['is_clearance_year'] == true;
      final c = clearance ? KColors.green : peak ? KColors.red : _riskColor(pressure);
      return Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [
        SizedBox(width: 40, child: Text(year, style: const TextStyle(color: AppColors.ivory, fontSize: 11, fontWeight: FontWeight.w700))),
        Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(value: (pressure / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
        const SizedBox(width: 8),
        SizedBox(width: 30, child: Text(pressure.toStringAsFixed(0), textAlign: TextAlign.right, style: TextStyle(color: c, fontSize: 10.5, fontWeight: FontWeight.w700))),
      ]));
    }).toList()));
  }

  // ══════════════════════════════════════════════════════════════════
  //  8 — SMART BORROWING GUIDE
  // ══════════════════════════════════════════════════════════════════
  Widget _borrowing(AppLocalizations l) {
    final avoid = _list('avoid_loan_types').map((e) => e.toString()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.request_quote_rounded, title: l.dbBorrowTitle, color: KColors.blue),
      Row(children: [
        Expanded(child: _iconTile('✅', l.dbLoanSuitability, _titleCase(_str('loan_taking_suitability')))),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('🏦', l.dbBestLoanType, _titleCase(_str('best_loan_type_if_needed')))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.dbLeverageCeiling, _sc('leverage_ceiling_pct'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.dbNegotiationSuccess, _sc('negotiation_success_probability'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _riskTile(l.dbCreditorAggression, _sc('creditor_aggression_score'))),
        const SizedBox(width: 10),
        Expanded(child: _riskTile(l.dbLegalEscalation, _sc('legal_escalation_risk'))),
      ]),
      if (_str('recommended_negotiation_approach').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 10),
        child: _pill('${l.dbNegotiationApproach}: ${_titleCase(_str('recommended_negotiation_approach'))}', KColors.purple)),
      if (avoid.isNotEmpty) ...[const SizedBox(height: 10), _chipBlock('🚫', l.dbAvoidLoanTypes, avoid, KColors.red)],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  9 — RISK & VULNERABILITY WATCH
  // ══════════════════════════════════════════════════════════════════
  Widget _riskWatch(AppLocalizations l) {
    final rows = <List<Object>>[
      [l.dbRiskDefault, _sc('default_probability_pct'), l.dbRiskDefaultExp, l.dbRiskDefaultFix],
      [l.dbRiskBankruptcy, _sc('bankruptcy_risk_pct'), l.dbRiskBankruptcyExp, l.dbRiskBankruptcyFix],
      [l.dbRiskAssetSeizure, _sc('asset_seizure_risk_pct'), l.dbRiskAssetSeizureExp, l.dbRiskAssetSeizureFix],
      [l.dbRiskChronic, _sc('chronic_debt_probability'), l.dbRiskChronicExp, l.dbRiskChronicFix],
    ];
    final hidden = _list('hidden_debt_signals').map((e) => e.toString())
        .where((s) => !s.toLowerCase().contains('no strong')).toList();
    final majorRisks = _list('major_debt_risks').whereType<Map>().map((e) => e['description']?.toString() ?? '').where((s) => s.isNotEmpty).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.shield_outlined, title: l.dbRiskTitle, color: KColors.orange),
      ...rows.map((r) {
        final score = r[1] as double;
        final col = _riskColor(score);
        return Container(
          margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: col.withOpacity(0.05), borderRadius: BorderRadius.circular(14), border: Border.all(color: col.withOpacity(0.18))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(r[0] as String, style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w700))),
              Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: col, fontSize: 14, fontWeight: FontWeight.w800)),
            ]),
            const SizedBox(height: 6),
            ClipRRect(borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(value: (score / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(col))),
            const SizedBox(height: 8),
            Text(r[2] as String, style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.35)),
            const SizedBox(height: 6),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('🛡️ ${l.crPrevention}: ', style: const TextStyle(color: KColors.green, fontSize: 10.5, fontWeight: FontWeight.w800)),
              Expanded(child: Text(r[3] as String, style: const TextStyle(color: AppColors.ivory, fontSize: 11, height: 1.35))),
            ]),
          ]),
        );
      }),
      if (_str('re_indebtedness_trigger').isNotEmpty || _sc('cycle_break_feasibility') > 0) Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 8),
        child: Row(children: [
          if (_str('re_indebtedness_trigger').isNotEmpty) Expanded(child: _iconTile('🔁', l.dbReindebtTrigger, _titleCase(_str('re_indebtedness_trigger')))),
          if (_str('re_indebtedness_trigger').isNotEmpty) const SizedBox(width: 10),
          Expanded(child: _statTile(l.dbCycleBreakFeasibility, _sc('cycle_break_feasibility'))),
        ])),
      if (majorRisks.isNotEmpty) _chipBlock('⚠️', l.dbMajorRisks, majorRisks, KColors.red),
      if (hidden.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('👀', l.dbHiddenSignals, hidden, KColors.orange)],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  10 — CRISIS PREPAREDNESS
  // ══════════════════════════════════════════════════════════════════
  Widget _crisisPrep(AppLocalizations l) {
    final warnings = _list('pre_crisis_warning_signs').map((e) => e.toString()).toList();
    final actions = _list('crisis_mitigation_actions').map((e) => e.toString()).toList();
    if (warnings.isEmpty && actions.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.report_problem_rounded, title: l.dbCrisisTitle, subtitle: l.dbCrisisSubtitle, color: KColors.red),
      if (warnings.isNotEmpty) ...[
        _catLabel('⚠️', l.dbWarningSigns, KColors.orange),
        ...warnings.map((s) => Container(
          margin: const EdgeInsets.only(bottom: 7), padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(color: KColors.orange.withOpacity(0.06), borderRadius: BorderRadius.circular(12), border: Border.all(color: KColors.orange.withOpacity(0.2))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.circle, size: 6, color: KColors.orange), const SizedBox(width: 9),
            Expanded(child: Text(_cap(s), style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.4))),
          ]),
        )),
        const SizedBox(height: 6),
      ],
      if (actions.isNotEmpty) ...[
        _catLabel('🎯', l.dbMitigationActions, KColors.green),
        ...actions.map((s) => Container(
          margin: const EdgeInsets.only(bottom: 7), padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(color: KColors.green.withOpacity(0.06), borderRadius: BorderRadius.circular(12), border: Border.all(color: KColors.green.withOpacity(0.2))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.check_circle_rounded, size: 15, color: KColors.green), const SizedBox(width: 9),
            Expanded(child: Text(_cap(s), style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.4))),
          ]),
        )),
      ],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  11 — FAMILY & ANCESTRAL DEBT
  // ══════════════════════════════════════════════════════════════════
  Widget _family(AppLocalizations l) {
    final blocker = _map('core_debt_blocker');
    final ancestral = _str('ancestral_karma_signature');
    if (blocker.isEmpty && ancestral.isEmpty && _sc('inherited_debt_probability') == 0) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.family_restroom_rounded, title: l.dbFamilyTitle, color: KColors.purple),
      Row(children: [
        Expanded(child: _riskTile(l.dbInheritedDebtProb, _sc('inherited_debt_probability'))),
        const SizedBox(width: 10),
        Expanded(child: _riskTile(l.dbFamilyDrag, _sc('family_debt_drag_pct'))),
      ]),
      if (_str('inherited_debt_source').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 10),
        child: _pill('${l.dbInheritedSource}: ${_titleCase(_str('inherited_debt_source'))}', KColors.purple)),
      if (ancestral.isNotEmpty) ...[const SizedBox(height: 10),
        _card(child: Text(_cap(ancestral), style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.45)))],
      if (blocker.isNotEmpty) ...[const SizedBox(height: 10), _blockerCard(l, blocker)],
    ]);
  }

  Widget _blockerCard(AppLocalizations l, Map<String, dynamic> b) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: KColors.orange.withOpacity(0.08), borderRadius: BorderRadius.circular(16),
      border: Border.all(color: KColors.orange.withOpacity(0.3))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(l.dbCoreBlockerLabel, style: const TextStyle(color: KColors.orange, fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.w700)),
      const SizedBox(height: 6),
      Text(b['primary_blocker']?.toString() ?? '', style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w800)),
      if (b['explanation'] != null) ...[const SizedBox(height: 6),
        Text(b['explanation'].toString(), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))],
      if (b['remedy_direction'] != null) ...[const SizedBox(height: 8),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('✓ ', style: TextStyle(color: KColors.green, fontWeight: FontWeight.w800)),
          Expanded(child: Text(b['remedy_direction'].toString(), style: const TextStyle(color: KColors.green, fontSize: 11.5, height: 1.4))),
        ])],
    ]),
  );

  // ══════════════════════════════════════════════════════════════════
  //  12 — YOUR MONEY PSYCHOLOGY
  // ══════════════════════════════════════════════════════════════════
  Widget _psychology(AppLocalizations l) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.psychology_rounded, title: l.dbPsychologyTitle, color: KColors.blue),
      Row(children: [
        Expanded(child: _statTile(l.dbResilience, _sc('psychological_resilience_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.dbDiscipline, _sc('discipline_under_pressure_score'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.dbSocialSupport, _sc('social_support_for_recovery'))),
        const SizedBox(width: 10),
        Expanded(child: _riskTile(l.dbDepressionRisk, _sc('depression_risk_under_financial_pressure'))),
      ]),
      if (_str('stress_tolerance_under_debt').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 10),
        child: _pill('${l.dbStressTolerance}: ${_titleCase(_str('stress_tolerance_under_debt'))}', KColors.blue)),
      if (_str('behavioral_root_cause').isNotEmpty) ...[const SizedBox(height: 10),
        _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l.dbRootCause, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(_cap(_str('behavioral_root_cause')), style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.4)),
        ]))],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  13 — IMPROVEMENT PLAN (remedies)
  // ══════════════════════════════════════════════════════════════════
  Widget _improvementPlan(AppLocalizations l) {
    final practical = _list('practical_solutions').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final planetary = _list('astrological_remedies').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.spa_rounded, title: l.dbImprovementTitle, color: KColors.green),
      if (practical.isNotEmpty) ...[
        _catLabel('🎯', l.crCatPractical, KColors.blue),
        ...practical.map((m) => _remedyCard(_titleCase(m['category']?.toString() ?? ''), m['advice']?.toString() ?? '', KColors.blue)),
      ],
      if (planetary.isNotEmpty) ...[
        const SizedBox(height: 6),
        _catLabel('🕉️', l.crCatPlanetary, KColors.purple),
        ...planetary.map((m) => _remedyCard(m['planet']?.toString() ?? '', m['remedy']?.toString() ?? '', KColors.purple)),
      ],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  14 — YOUR DEBT-FREE ROADMAP
  // ══════════════════════════════════════════════════════════════════
  Widget _roadmap(AppLocalizations l) {
    final verdict = _str('recovery_verdict');
    final strategy = _str('recommended_strategy');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.emoji_events_rounded, title: l.dbRoadmapTitle, color: KColors.gold),
      if (verdict.isNotEmpty) Container(padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [KColors.gold.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
          borderRadius: BorderRadius.circular(18), border: Border.all(color: KColors.gold.withOpacity(0.3))),
        child: Column(children: [
          const Text('🏆', style: TextStyle(fontSize: 34)),
          const SizedBox(height: 8),
          Text(verdict, style: const TextStyle(color: AppColors.ivory, fontSize: 20, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
          if (strategy.isNotEmpty) ...[const SizedBox(height: 8),
            Text(_cap(strategy), style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.5), textAlign: TextAlign.center)],
        ])),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.dbRecoveryProbability, _sc('recovery_probability_pct'))),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('⏳', l.dbClearanceTimeline, '${_str('timeline_to_debt_free_years')} ${l.dbYears}')),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.dbDtiHealth, _sc('debt_to_income_health_score'))),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('📊', l.dbDtiCategory, _titleCase(_str('dti_category')))),
      ]),
      _advanced(l, [
        '${l.dbBreakEvenMonths}: ${_sc('months_to_break_even_estimate').toStringAsFixed(0)}',
        '${l.dbIncomeAcceleration}: ${_sc('income_acceleration_requirement_pct').toStringAsFixed(0)}%',
      ]),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  15 — PREDICTION RELIABILITY
  // ══════════════════════════════════════════════════════════════════
  Widget _reliability(AppLocalizations l) {
    final raw = _sc('confidence_score');
    final pct = raw <= 1 ? raw * 100 : raw;
    final band = pct >= 75 ? l.crReliabilityHigh : pct >= 60 ? l.crReliabilityGood : l.crReliabilityModerate;
    final b = _map('confidence_breakdown');
    double layer(String k) { final v = b[k]; return v is num ? v.toDouble() * 100 : 0; }
    final layers = <List<Object>>[
      [l.dbLayerD1, layer('d1')],
      [l.dbLayerD6, layer('d6')],
      [l.dbLayerD9, layer('d9')],
      [l.dbLayerDasha, layer('dasha')],
      [l.dbLayerTransit, layer('transit')],
    ];
    final plain = _str('plain_statement');
    final disclaimer = _str('disclaimer');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.verified_user_rounded, title: l.crReliability, color: KColors.blue),
      _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          KStars(filled: kStars(pct), size: 20, color: AppColors.gold), const Spacer(),
          Text('${pct.toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.gold, fontSize: 22, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 4),
        Text(band, style: const TextStyle(color: KColors.green, fontSize: 13, fontWeight: FontWeight.w800)),
        if (plain.isNotEmpty) ...[const SizedBox(height: 10),
          Text(_cap(plain), style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.5))],
        _advanced(l, null, customTitle: l.crChartLayers, customChild: Column(children: layers.where((la) => (la[1] is num ? (la[1] as num).toDouble() : 0.0) > 0).map((la) {
          final v = la[1] as double;
          return Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [
            SizedBox(width: 130, child: Text(la[0] as String, style: const TextStyle(color: AppColors.ivory, fontSize: 11.5))),
            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(value: (v / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(_debtColor(v))))),
            const SizedBox(width: 8),
            Text('${v.toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w700)),
          ]));
        }).toList())),
      ])),
      if (disclaimer.isNotEmpty) ...[const SizedBox(height: 10),
        Text(disclaimer, style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, height: 1.4, fontStyle: FontStyle.italic))],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  16 — DISCUSS WITH AI
  // ══════════════════════════════════════════════════════════════════
  Widget _discussAi(AppLocalizations l) {
    final topics = <String>[l.dbTopicRecovery, l.dbTopicNegotiate, l.dbTopicBorrowing, l.dbTopicCrisis, l.dbTopicAncestral, l.dbTopicTimeline, l.dbTopicPsychology, l.dbTopicCategories];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.forum_rounded, title: l.crDiscussAi, color: AppColors.gold),
      Row(children: [
        _aiBtn('ChatGPT', '🤖', () => _launchAi(_data!, 'chatgpt')),
        _aiBtn('Claude', '✳️', () => _launchAi(_data!, 'claude')),
        _aiBtn('Gemini', '💎', () => _launchAi(_data!, 'gemini')),
      ]),
      const SizedBox(height: 14),
      Text(l.crAskAbout, style: const TextStyle(color: AppColors.smoke, fontSize: 11.5, fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 8, children: topics.map((t) => GestureDetector(
        onTap: () => _copyTopic(t),
        child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(color: AppColors.card.withOpacity(0.5), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.gold.withOpacity(0.25))),
          child: Text(t, style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, fontWeight: FontWeight.w600))),
      )).toList()),
    ]);
  }

  Widget _aiBtn(String name, String emoji, VoidCallback onTap) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4),
    child: GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(color: AppColors.card.withOpacity(0.5), borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.gold.withOpacity(0.2))),
      child: Column(children: [Text(emoji, style: const TextStyle(fontSize: 20)), const SizedBox(height: 5),
        Text(name, style: const TextStyle(color: AppColors.ivory, fontSize: 11, fontWeight: FontWeight.w700)),
        const Text('OPEN ↗', style: TextStyle(color: AppColors.smoke, fontSize: 7, letterSpacing: 1)),
      ])))));

  void _copyTopic(String topic) {
    final q = '$topic — based on my Vedic debt & recovery report for ${widget.chartName}.\n\n${_buildPrompt(_data!)}';
    Clipboard.setData(ClipboardData(text: q));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.crTopicCopied), duration: const Duration(seconds: 2)));
  }

  // ══════════════════════════════════════════════════════════════════
  //  shared widgets / helpers
  // ══════════════════════════════════════════════════════════════════
  Widget _card({required Widget child}) => Container(padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: AppColors.card.withOpacity(0.4), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white.withOpacity(0.06))), child: child);

  Widget _pill(String t, Color c) => Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: c.withOpacity(0.25))),
    child: Text(t, style: TextStyle(color: c, fontSize: 10.5, fontWeight: FontWeight.w600)));

  Widget _chipBlock(String emoji, String title, List<String> items, Color c) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(padding: const EdgeInsets.only(bottom: 4), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Text(emoji, style: const TextStyle(fontSize: 13)), const SizedBox(width: 6),
        Text(title, style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w800))]),
      const SizedBox(height: 7),
      Wrap(spacing: 6, runSpacing: 6, children: items.take(8).map((e) => _pill(_cap(e), c)).toList()),
    ]));
  }

  Widget _catLabel(String emoji, String t, Color c) => Padding(padding: const EdgeInsets.only(bottom: 8, top: 2),
    child: Row(children: [Text(emoji, style: const TextStyle(fontSize: 13)), const SizedBox(width: 6),
      Text(t, style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w800))]));

  Widget _remedyCard(String title, String body, Color c) => Container(
    margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: c.withOpacity(0.2))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (title.isNotEmpty) Text(title, style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w800)),
      if (title.isNotEmpty) const SizedBox(height: 4),
      Text(_cap(body), style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.45)),
    ]),
  );

  Widget _iconTile(String emoji, String label, String value, {Color? color}) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: AppColors.card.withOpacity(0.5), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.06))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(emoji, style: const TextStyle(fontSize: 17)), const SizedBox(height: 6),
      Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontWeight: FontWeight.w600)),
      Text(value, style: TextStyle(color: color ?? AppColors.ivory, fontSize: 12.5, fontWeight: FontWeight.w800), maxLines: 2, overflow: TextOverflow.ellipsis),
    ]),
  );

  Widget _statTile(String label, double score) {
    final c = _debtColor(score);
    return Container(padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: c.withOpacity(0.2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: c, fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        ClipRRect(borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(value: (score / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c))),
      ]));
  }

  Widget _riskTile(String label, double score) {
    final c = _riskColor(score);
    return Container(padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: c.withOpacity(0.2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: c, fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        ClipRRect(borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(value: (score / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c))),
      ]));
  }

  Widget _advanced(AppLocalizations l, List<String>? lines, {String? customTitle, Widget? customChild}) {
    final valid = lines?.where((s) => s.trim().isNotEmpty).toList() ?? const [];
    if (customChild == null && valid.isEmpty) return const SizedBox.shrink();
    return Theme(data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero, childrenPadding: const EdgeInsets.only(bottom: 8),
        iconColor: AppColors.smoke, collapsedIconColor: AppColors.smoke,
        title: Text(customTitle ?? l.fdAdvancedDetails, style: const TextStyle(color: AppColors.smoke, fontSize: 11.5, fontWeight: FontWeight.w700)),
        children: customChild != null ? [customChild] : valid.map((s) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('• ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
            Expanded(child: Text(s, style: const TextStyle(color: AppColors.parchment, fontSize: 11, height: 1.35))),
          ]),
        )).toList(),
      ),
    );
  }

  Color _debtColor(double s) {
    if (s >= 75) return KColors.green;
    if (s >= 60) return KColors.blue;
    if (s >= 45) return KColors.yellow;
    if (s >= 30) return KColors.orange;
    return KColors.red;
  }
  Color _riskColor(double s) {
    if (s >= 65) return KColors.red;
    if (s >= 45) return KColors.orange;
    if (s >= 30) return KColors.yellow;
    return KColors.green;
  }
  String _cap(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
  String _titleCase(String s) => s.replaceAll('_', ' ').replaceAll('-', ' ').split(' ')
    .where((w) => w.isNotEmpty).map((w) => '${w[0].toUpperCase()}${w.substring(1)}').join(' ');

  // ── AI prompt / launch (unchanged behaviour) ──
  String _buildPrompt(Map<String, dynamic> d) {
    final name = widget.chartName;
    final capacity = d['debt_recovery_capacity_score'] ?? '?';
    final verdict = d['recovery_verdict'] ?? '';
    final personality = d['debt_personality'] ?? '';
    final jsonStr = const JsonEncoder.withIndent('  ').convert(d);
    return '''You are a Vedic debt & financial-recovery advisor. Analyze this debt report for $name and provide actionable insights.

Key highlights:
- Debt recovery capacity: $capacity/100
- Recovery verdict: $verdict
- Debt personality: $personality

Full report data (JSON):
$jsonStr

Please explain the key findings in simple language, highlight the most important timing windows, and suggest practical next steps toward becoming debt-free.''';
  }

  Future<void> _launchAi(Map<String, dynamic> d, String ai) async {
    final prompt = _buildPrompt(d);
    await Clipboard.setData(ClipboardData(text: prompt));
    String url;
    switch (ai) {
      case 'chatgpt': url = 'https://chat.openai.com/'; break;
      case 'claude': url = 'https://claude.ai/new'; break;
      case 'gemini': url = 'https://gemini.google.com/app'; break;
      default: return;
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Report copied! Opening $ai — paste to discuss.'), duration: const Duration(seconds: 3)));
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Widget _errView(AppLocalizations l) => Center(child: Padding(padding: const EdgeInsets.all(24),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.error_outline, color: AppColors.error, size: 44), const SizedBox(height: 12),
      Text(_error!, style: const TextStyle(color: AppColors.smoke), textAlign: TextAlign.center),
      const SizedBox(height: 16), ElevatedButton(onPressed: _load, child: Text(l.retry)),
    ])));
}
