import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../../utils/kundli_names.dart';
import '../kundli/widgets/kundli_ui.dart';

/// Wealth & Finance report — premium AI wealth-coach redesign.
///
/// Presentation only. Loads the `wealth` specialist (`runSpecialist('wealth')`)
/// unchanged and re-presents it; every score, karaka, yoga, wealth class,
/// timing window, probability, remedy and confidence value comes straight from
/// the engine.
class WealthReportScreen extends StatefulWidget {
  final String chartId, chartName;
  final Map<String, dynamic>? preloadedData;
  const WealthReportScreen({super.key, required this.chartId, required this.chartName, this.preloadedData});
  @override
  State<WealthReportScreen> createState() => _WealthState();
}

class _WealthState extends State<WealthReportScreen> {
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
      final resp = await _api.runSpecialist('wealth', widget.chartId);
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
          Text(l.wlSubtitle, style: const TextStyle(color: AppColors.gold, fontSize: 10)),
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
    // Sections render directly (no staggered fade wrapper) to avoid the tall
    // hero + lazy-build opacity-0 blank-screen bug.
    const gap = SizedBox(height: 18);
    return [
      _breadcrumb(l),
      const SizedBox(height: 10),
      _snapshot(l),          // 1
      gap, _wealthClass(l),     // 2
      gap, _boosters(l),        // 3
      gap, _incomeSources(l),   // 4
      gap, _investment(l),      // 5
      gap, _moneyPersonality(l),// 6
      gap, _windfalls(l),       // 7
      gap, _moneyPlanets(l),    // 8
      gap, _timeline(l),        // 9
      gap, _debtRisks(l),       // 10
      gap, _strengthen(l),      // 11
      gap, _remedies(l),        // 12
      gap, _reliability(l),     // 13
      gap, _discussAi(l),       // 14
    ];
  }

  Widget _breadcrumb(AppLocalizations l) => Row(children: [
    Text(l.crCrumbHome, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Text(l.crCrumbReports, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Flexible(child: Text(l.wlTitle, style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
  ]);

  // ══════════════════════════════════════════════════════════════════
  //  1 — WEALTH SNAPSHOT
  // ══════════════════════════════════════════════════════════════════
  Widget _snapshot(AppLocalizations l) {
    final overall = _sc('wealth_strength_score');
    final col = _wlColor(overall);
    final verdict = _str('final_verdict');
    final summary = _str('recommendation').isNotEmpty ? _str('recommendation') : _str('plain_statement');
    final gauges = <List<Object>>[
      [l.wlAccumulation, _sc('accumulation_capacity_score')],
      [l.wlIncomeFlow, _sc('income_flow_score')],
      [l.wlRetention, _sc('wealth_retention_score')],
      [l.wlSustainability, _sc('long_term_sustainability_score')],
      [l.wlSavings, _sc('savings_discipline_score')],
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [col.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
        borderRadius: BorderRadius.circular(22), border: Border.all(color: col.withOpacity(0.3)),
      ),
      child: Column(children: [
        Text(l.wlWealthPotential.toUpperCase(), style: const TextStyle(color: AppColors.smoke, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
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
        Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(color: col.withOpacity(0.16), borderRadius: BorderRadius.circular(20)),
          child: Text(verdict.isNotEmpty ? _titleCase(verdict) : _potentialStatus(overall, l), style: TextStyle(color: col, fontSize: 14, fontWeight: FontWeight.w800))),
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
          children: gauges.map((g) => _miniGauge(g[0] as String, g[1] as double)).toList()),
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
    final mp = _str('money_personality').toLowerCase();
    if (mp.contains('sav')) out.add(l.wlChipSaver);
    if (_sc('multiple_income_streams_likelihood') >= 60) out.add(l.wlChipMultiIncome);
    if (_list('active_wealth_yogas').isNotEmpty) out.add(l.wlChipStrongYogas);
    if (_str('debt_severity_band').toLowerCase().contains('low')) out.add(l.wlChipLowDebt);
    if (_sc('inheritance_probability_pct') >= 50) out.add(l.wlChipInheritance);
    if (_str('investment_style').isNotEmpty) out.add(l.wlChipInvestor);
    return out.toSet().take(6).toList();
  }

  Widget _miniGauge(String label, double score) {
    final col = _wlColor(score);
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
  //  2 — WEALTH CLASS
  // ══════════════════════════════════════════════════════════════════
  Widget _wealthClass(AppLocalizations l) {
    final wclass = _str('wealth_class');
    final range = _map('lifetime_wealth_range_inr')['display']?.toString() ?? '';
    if (wclass.isEmpty && range.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.diamond_rounded, title: l.wlWealthClass, color: AppColors.gold),
      Container(padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.gold.withOpacity(0.16), AppColors.card.withOpacity(0.4)]),
          borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.gold.withOpacity(0.3))),
        child: Column(children: [
          const Text('💎', style: TextStyle(fontSize: 32)),
          const SizedBox(height: 8),
          Text(_titleCase(wclass), style: const TextStyle(color: AppColors.ivory, fontSize: 22, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
          if (range.isNotEmpty) ...[const SizedBox(height: 4),
            Text(range, style: const TextStyle(color: AppColors.gold, fontSize: 14, fontWeight: FontWeight.w700))],
        ])),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _iconTile('🏦', l.wlWealthType, _titleCase(_str('wealth_type')))),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('💼', l.wlPrimarySource, _titleCase(_str('primary_income_source')))),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('📅', l.wlPeakAge, _str('peak_net_worth_age'))),
      ]),
    ]);
  }

  Widget _iconTile(String emoji, String label, String value, {Color? color}) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: AppColors.card.withOpacity(0.5), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.06))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(emoji, style: const TextStyle(fontSize: 17)), const SizedBox(height: 6),
      Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontWeight: FontWeight.w600)),
      Text(value.isEmpty ? '—' : value, style: TextStyle(color: color ?? AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w800), maxLines: 2, overflow: TextOverflow.ellipsis),
    ]),
  );

  // ══════════════════════════════════════════════════════════════════
  //  3 — WHAT'S BOOSTING YOUR WEALTH (yogas + doshas)
  // ══════════════════════════════════════════════════════════════════
  Widget _boosters(AppLocalizations l) {
    final yogas = _list('active_wealth_yogas').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final doshas = _list('active_wealth_doshas').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    if (yogas.isEmpty && doshas.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.auto_awesome_rounded, title: l.wlBoosters, subtitle: l.wlBoostersSub, color: AppColors.gold),
      ...yogas.take(8).map((m) {
        final impact = (m['wealth_impact'] is num ? m['wealth_impact'] as num : null)?.toDouble() ?? 0;
        return Container(
          margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: KColors.green.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: KColors.green.withOpacity(0.2))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.auto_awesome_rounded, size: 17, color: KColors.green), const SizedBox(width: 10),
            Expanded(child: Text(_titleCase(m['name']?.toString() ?? ''), style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, fontWeight: FontWeight.w700))),
            if (impact > 0) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: KColors.green.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
              child: Text('+${impact.toStringAsFixed(1)} ${l.wlWealthImpact}', style: const TextStyle(color: KColors.green, fontSize: 10, fontWeight: FontWeight.w800))),
          ]),
        );
      }),
      if (doshas.isNotEmpty) ...[
        const SizedBox(height: 6),
        _catLabel('⚠️', l.wlDrains, KColors.orange),
        ...doshas.take(5).map((m) => Container(
          margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: KColors.orange.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: KColors.orange.withOpacity(0.2))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.trending_down_rounded, size: 17, color: KColors.orange), const SizedBox(width: 10),
            Expanded(child: Text(_cap(m['name']?.toString() ?? m['description']?.toString() ?? ''), style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.4))),
          ]),
        )),
      ],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  4 — INCOME SOURCES
  // ══════════════════════════════════════════════════════════════════
  Widget _incomeSources(AppLocalizations l) {
    final scores = _map('income_source_scores');
    final rows = scores.entries.where((e) => e.value is num).map((e) => [_titleCase(e.key), (e.value is num ? e.value as num : 0).toDouble()]).toList();
    if (rows.isEmpty) return const SizedBox.shrink();
    rows.sort((a, b) => (b[1] is num ? (b[1] as num).toDouble() : 0.0).compareTo(a[1] as double));
    final primary = _str('primary_income_source').toLowerCase();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.account_balance_wallet_rounded, title: l.wlIncomeSources, subtitle: l.wlIncomeSourcesSub, color: KColors.blue),
      ...List.generate(rows.length > 6 ? 6 : rows.length, (i) {
        final r = rows[i];
        final label = r[0] as String;
        final score = r[1] as double;
        final isBest = label.toLowerCase() == primary || i == 0;
        final col = isBest ? KColors.green : _wlColor(score);
        return Container(
          margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: col.withOpacity(isBest ? 0.10 : 0.05), borderRadius: BorderRadius.circular(14), border: Border.all(color: col.withOpacity(isBest ? 0.4 : 0.18))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(label, style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w700))),
              if (isBest) Container(margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(color: KColors.green.withOpacity(0.18), borderRadius: BorderRadius.circular(6)),
                child: Text('⭐ ${l.wlPrimary}', style: const TextStyle(color: KColors.green, fontSize: 8.5, fontWeight: FontWeight.w800))),
              Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: col, fontSize: 15, fontWeight: FontWeight.w800)),
            ]),
            const SizedBox(height: 7),
            ClipRRect(borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(value: (score / 100).clamp(0, 1), minHeight: 6, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(col))),
          ]),
        );
      }),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  5 — INVESTMENT PLAN
  // ══════════════════════════════════════════════════════════════════
  Widget _investment(AppLocalizations l) {
    final mix = _list('recommended_investment_mix').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    if (mix.isEmpty && _str('investment_style').isEmpty) return const SizedBox.shrink();
    final loc = Localizations.localeOf(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.pie_chart_rounded, title: l.wlInvestment, subtitle: l.wlInvestmentSub, color: KColors.purple),
      Row(children: [
        Expanded(child: _iconTile('🎚️', l.wlRiskAppetite, _titleCase(_str('risk_appetite')))),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('📊', l.wlInvestStyle, _titleCase(_str('investment_style')))),
      ]),
      const SizedBox(height: 10),
      ...mix.map((m) {
        final pct = (m['suggested_allocation_pct'] is num ? m['suggested_allocation_pct'] as num : null)?.toDouble() ?? 0;
        final strength = (m['planet_strength'] is num ? m['planet_strength'] as num : null)?.toDouble() ?? 0;
        final driver = KundliNames.planet(m['driven_by']?.toString() ?? '', loc);
        final col = _wlColor(strength);
        return Container(
          margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: AppColors.card.withOpacity(0.4), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.06))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(m['asset_class']?.toString() ?? '', style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, fontWeight: FontWeight.w700))),
              Text('${pct.toStringAsFixed(0)}%', style: TextStyle(color: col, fontSize: 16, fontWeight: FontWeight.w800)),
            ]),
            const SizedBox(height: 6),
            ClipRRect(borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(value: (pct / 100).clamp(0, 1), minHeight: 6, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(col))),
            if (driver.isNotEmpty) ...[const SizedBox(height: 5),
              Text('${l.wlDrivenBy}: 🪐 $driver', style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w600))],
          ]),
        );
      }),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  6 — MONEY PERSONALITY
  // ══════════════════════════════════════════════════════════════════
  Widget _moneyPersonality(AppLocalizations l) {
    final rows = <List<Object>>[
      [l.wlSavingsDiscipline, _sc('savings_discipline_score')],
      [l.wlCharity, _sc('charity_inclination_score')],
      [l.wlLuxury, _sc('luxury_spending_score')],
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.psychology_rounded, title: l.wlMoneyPersonality, color: KColors.purple),
      Row(children: [
        Expanded(child: _iconTile('🧠', l.wlMoneyType, _titleCase(_str('money_personality')))),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('🛍️', l.wlSpending, _titleCase(_str('spending_tendency')))),
      ]),
      const SizedBox(height: 10),
      _card(child: Column(children: rows.map((r) {
        final score = r[1] as double;
        final col = _wlColor(score);
        return Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(r[0] as String, style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, fontWeight: FontWeight.w600))),
            Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: col, fontSize: 13, fontWeight: FontWeight.w800)),
          ]),
          const SizedBox(height: 5),
          ClipRRect(borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(value: (score / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(col))),
        ]));
      }).toList())),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  7 — WINDFALLS & CHANCES
  // ══════════════════════════════════════════════════════════════════
  Widget _windfalls(AppLocalizations l) {
    final gauges = <List<Object>>[
      [l.wlInheritanceChance, _sc('inheritance_probability_pct')],
      [l.wlSuddenGains, _sc('sudden_gains_probability_pct')],
      [l.wlLottery, _sc('lottery_speculation_probability_pct')],
      [l.wlInsurance, _sc('insurance_claim_likelihood_pct')],
    ];
    if (gauges.every((g) => (g[1] is num ? (g[1] as num).toDouble() : 0.0) == 0)) return const SizedBox.shrink();
    final src = _str('windfall_source');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.casino_rounded, title: l.wlWindfalls, subtitle: l.wlWindfallsSub, color: KColors.blue),
      Wrap(alignment: WrapAlignment.spaceBetween, spacing: 10, runSpacing: 12,
        children: gauges.map((g) => SizedBox(width: (MediaQuery.of(context).size.width - 32 - 30) / 4, child: _miniGauge(g[0] as String, g[1] as double))).toList()),
      if (src.isNotEmpty) ...[const SizedBox(height: 12),
        _card(child: Row(children: [const Text('🍀', style: TextStyle(fontSize: 15)), const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.wlWindfallSource, style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w700)),
            Text(_cap(src), style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, fontWeight: FontWeight.w600)),
          ]))]))],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  8 — YOUR MONEY PLANETS
  // ══════════════════════════════════════════════════════════════════
  Widget _moneyPlanets(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    final table = _map('karaka_strength_table');
    final rows = table.entries.where((e) => e.value is num).map((e) => [e.key, (e.value is num ? e.value as num : 0).toDouble()]).toList();
    if (rows.isEmpty) return const SizedBox.shrink();
    rows.sort((a, b) => (b[1] is num ? (b[1] as num).toDouble() : 0.0).compareTo(a[1] as double));
    final primary = _str('primary_wealth_karaka');
    final secondary = _str('secondary_karaka');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.brightness_7_rounded, title: l.wlMoneyPlanets, color: AppColors.gold),
      Row(children: [
        Expanded(child: _planetCard('🪐', l.wlPrimaryKaraka, KundliNames.planet(primary, loc), _wlColor(_scOf(table, primary)))),
        const SizedBox(width: 10),
        Expanded(child: _planetCard('✨', l.wlSecondaryKaraka, KundliNames.planet(secondary, loc), _wlColor(_scOf(table, secondary)))),
      ]),
      const SizedBox(height: 10),
      _card(child: Column(children: rows.take(7).map((r) {
        final planet = KundliNames.planet(r[0] as String, loc);
        final score = r[1] as double;
        final col = _wlColor(score);
        return Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children: [
          SizedBox(width: 76, child: Text(planet, style: const TextStyle(color: AppColors.ivory, fontSize: 12, fontWeight: FontWeight.w600))),
          Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(value: (score / 100).clamp(0, 1), minHeight: 6, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(col)))),
          const SizedBox(width: 8),
          Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: col, fontSize: 11.5, fontWeight: FontWeight.w700)),
        ]));
      }).toList())),
    ]);
  }

  double _scOf(Map<String, dynamic> m, String k) { final v = m[k]; return v is num ? v.toDouble() : 0; }

  Widget _planetCard(String emoji, String label, String planet, Color c) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: c.withOpacity(0.08), borderRadius: BorderRadius.circular(16), border: Border.all(color: c.withOpacity(0.22))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Text(emoji, style: const TextStyle(fontSize: 16)), const SizedBox(width: 6),
        Expanded(child: Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w700)))]),
      const SizedBox(height: 6),
      Text(planet.isEmpty ? '—' : planet, style: TextStyle(color: c, fontSize: 18, fontWeight: FontWeight.w800)),
    ]),
  );

  // ══════════════════════════════════════════════════════════════════
  //  9 — WEALTH TIMELINE
  // ══════════════════════════════════════════════════════════════════
  Widget _timeline(AppLocalizations l) {
    final good = _list('good_wealth_periods').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final sudden = _list('sudden_gain_windows').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final bad = _list('bad_wealth_periods').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final cards = <Widget>[];
    for (final m in good.take(3)) {
      cards.add(_timelineCard(l, l.wlGoodPeriod, m['window']?.toString() ?? '', m['dasha_label']?.toString() ?? '', _cap(m['label']?.toString() ?? ''), KColors.green, m['reason']?.toString() ?? ''));
    }
    for (final m in sudden.take(2)) {
      cards.add(_timelineCard(l, l.wlSuddenGainWindow, m['window']?.toString() ?? '', m['dasha']?.toString() ?? '', _cap(m['type']?.toString() ?? ''), AppColors.gold, ''));
    }
    for (final m in bad.take(1)) {
      cards.add(_timelineCard(l, l.wlToughPeriod, m['window']?.toString() ?? '', m['dasha_label']?.toString() ?? m['dasha']?.toString() ?? '', _cap(m['label']?.toString() ?? ''), KColors.orange, m['reason']?.toString() ?? ''));
    }
    final peaks = _list('wealth_peak_years').map((e) => e.toString()).toList();
    if (cards.isEmpty && peaks.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.timeline_rounded, title: l.wlTimeline, color: AppColors.gold),
      if (peaks.isNotEmpty) Padding(padding: const EdgeInsets.only(bottom: 12),
        child: _card(child: Row(children: [const Text('📈', style: TextStyle(fontSize: 15)), const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.wlPeakYears, style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w700)),
            Text(peaks.join(' · '), style: const TextStyle(color: KColors.green, fontSize: 14, fontWeight: FontWeight.w800)),
          ]))]))),
      ...cards,
    ]);
  }

  Widget _timelineCard(AppLocalizations l, String title, String window, String dasha, String note, Color col, String reason) {
    final loc = Localizations.localeOf(context);
    final planet = dasha.isNotEmpty ? KundliNames.planet(dasha.split('/').first.split(' ').first, loc) : '';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(14, 13, 13, 13),
      decoration: BoxDecoration(color: col.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: col.withOpacity(0.28))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: col, shape: BoxShape.circle, border: Border.all(color: col.withOpacity(0.35), width: 3))),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: TextStyle(color: col, fontSize: 12.5, fontWeight: FontWeight.w800))),
          if (window.isNotEmpty) Flexible(child: Text(window, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w600), textAlign: TextAlign.right)),
        ]),
        if (planet.isNotEmpty) ...[const SizedBox(height: 4),
          Text('🪐 $planet', style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700))],
        if (note.isNotEmpty) ...[const SizedBox(height: 6),
          Text(note, style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.4))],
        if (reason.isNotEmpty) _advanced(l, [reason]),
      ]),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  //  10 — DEBT & MONEY RISKS
  // ══════════════════════════════════════════════════════════════════
  Widget _debtRisks(AppLocalizations l) {
    final rows = <List<Object>>[
      [l.wlDebtChance, _sc('debt_probability_pct')],
      [l.wlLoanBurden, _sc('loan_burden_risk')],
    ];
    final drains = _list('drain_sources').map((e) => e.toString()).where((s) => s.isNotEmpty).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.shield_outlined, title: l.wlDebtRisks, color: KColors.orange),
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
          ]),
        );
      }),
      if (drains.isNotEmpty) Container(
        margin: const EdgeInsets.only(top: 2), padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: KColors.orange.withOpacity(0.05), borderRadius: BorderRadius.circular(14), border: Border.all(color: KColors.orange.withOpacity(0.18))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('🛡️ ${l.wlDrainSources}', style: const TextStyle(color: KColors.orange, fontSize: 11, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          ...drains.map((s) => Padding(padding: const EdgeInsets.only(bottom: 3),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('• ', style: TextStyle(color: AppColors.smoke, fontSize: 12)),
              Expanded(child: Text(_cap(s), style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.35))),
            ]))),
        ])),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  11 — WHAT TO STRENGTHEN
  // ══════════════════════════════════════════════════════════════════
  Widget _strengthen(AppLocalizations l) {
    final b = _map('core_wealth_blocker');
    final blocker = b['primary_blocker']?.toString() ?? '';
    final explain = b['explanation']?.toString() ?? _str('wealth_blockage_reason');
    final fix = b['remedy_direction']?.toString() ?? '';
    if (blocker.isEmpty && explain.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.build_circle_rounded, title: l.wlStrengthen, color: KColors.blue),
      _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (blocker.isNotEmpty) ...[
          Text(l.wlWeakestDriver, style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(_cap(blocker), style: const TextStyle(color: AppColors.ivory, fontSize: 13.5, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
        ],
        if (explain.isNotEmpty) Text(_cap(explain), style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.5)),
        if (fix.isNotEmpty) ...[const SizedBox(height: 10),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('🛠️ ${l.wlHowToFix}: ', style: const TextStyle(color: KColors.green, fontSize: 10.5, fontWeight: FontWeight.w800)),
            Expanded(child: Text(_cap(fix), style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.4))),
          ])],
      ])),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  12 — IMPROVEMENT PLAN (remedies)
  // ══════════════════════════════════════════════════════════════════
  Widget _remedies(AppLocalizations l) {
    final practical = _list('practical_solutions').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final astro = _list('astrological_remedies').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    if (practical.isEmpty && astro.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.spa_rounded, title: l.wlImprovementPlan, color: KColors.green),
      if (practical.isNotEmpty) ...[
        _catLabel('🎯', l.crCatPractical, KColors.blue),
        ...practical.map((m) => _remedyCard(_titleCase(m['category']?.toString() ?? ''), m['advice']?.toString() ?? '', KColors.blue)),
      ],
      if (astro.isNotEmpty) ...[
        const SizedBox(height: 6),
        _catLabel('🕉️', l.crCatPlanetary, KColors.purple),
        ...astro.map((m) => _remedyCard(m['planet']?.toString() ?? '', m['remedy']?.toString() ?? '', KColors.purple)),
      ],
    ]);
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

  // ══════════════════════════════════════════════════════════════════
  //  13 — PREDICTION RELIABILITY
  // ══════════════════════════════════════════════════════════════════
  Widget _reliability(AppLocalizations l) {
    final raw = _sc('confidence_score');
    final pct = raw <= 1 ? raw * 100 : raw;
    final band = pct >= 75 ? l.crReliabilityHigh : pct >= 60 ? l.crReliabilityGood : l.crReliabilityModerate;
    final b = _map('confidence_breakdown');
    double layer(String k) { final v = b[k]; return v is num ? v.toDouble() * 100 : 0; }
    final layers = <List<Object>>[
      [l.wlLayerBirth, layer('d1')],
      [l.wlLayerHora, layer('d2')],
      [l.wlLayerNavamsa, layer('d9')],
      [l.wlLayerDasha, layer('dasha')],
      [l.wlLayerTransit, layer('transit')],
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.verified_user_rounded, title: l.wlReliability, color: KColors.blue),
      _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          KStars(filled: kStars(pct), size: 20, color: AppColors.gold), const Spacer(),
          Text('${pct.toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.gold, fontSize: 22, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 4),
        Text(band, style: const TextStyle(color: KColors.green, fontSize: 13, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        Text(l.crReliabilityExplain, style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.5)),
        _advanced(l, null, customTitle: l.crChartLayers, customChild: Column(children: layers.where((la) => (la[1] is num ? (la[1] as num).toDouble() : 0.0) > 0).map((la) {
          final v = la[1] as double;
          return Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [
            SizedBox(width: 140, child: Text(la[0] as String, style: const TextStyle(color: AppColors.ivory, fontSize: 11.5))),
            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(value: (v / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(_wlColor(v))))),
            const SizedBox(width: 8),
            Text('${v.toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w700)),
          ]));
        }).toList())),
      ])),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  14 — DISCUSS WITH AI
  // ══════════════════════════════════════════════════════════════════
  Widget _discussAi(AppLocalizations l) {
    final topics = <String>[l.wlTopicGrow, l.wlTopicInvest, l.wlTopicDebt, l.wlTopicProperty, l.wlTopicRetire, l.wlTopicPassive, l.wlTopicWindfall, l.wlTopicTiming];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.forum_rounded, title: l.crDiscussAi, color: AppColors.gold),
      ReportAiChatCta(domainKey: 'money_wealth', label: 'Money & Wealth', emoji: '💰'),
      const SizedBox(height: 14),
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
    final q = '$topic — based on my Vedic wealth report for ${widget.chartName}.\n\n${_buildPrompt(_data!)}';
    Clipboard.setData(ClipboardData(text: q));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.crTopicCopied), duration: const Duration(seconds: 2)));
  }

  // ══════════════════════════════════════════════════════════════════
  //  shared widgets / helpers
  // ══════════════════════════════════════════════════════════════════
  Widget _card({required Widget child}) => Container(padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: AppColors.card.withOpacity(0.4), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white.withOpacity(0.06))), child: child);

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

  Color _wlColor(double s) {
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
  String _potentialStatus(double s, AppLocalizations l) {
    if (s >= 75) return l.crStatusStrong;
    if (s >= 60) return l.crStatusGood;
    if (s >= 45) return l.crStatusModerate;
    if (s >= 30) return l.crStatusDeveloping;
    return l.crStatusChallenging;
  }
  String _cap(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
  String _titleCase(String s) => s.replaceAll('_', ' ').replaceAll('-', ' ').split(' ')
    .where((w) => w.isNotEmpty).map((w) => '${w[0].toUpperCase()}${w.substring(1)}').join(' ');

  // ── AI prompt / launch (unchanged behaviour) ──
  String _buildPrompt(Map<String, dynamic> d) {
    final name = widget.chartName;
    final overall = d['wealth_strength_score'] ?? '?';
    final wclass = d['wealth_class'] ?? '';
    final verdict = d['final_verdict'] ?? '';
    final jsonStr = const JsonEncoder.withIndent('  ').convert(d);
    return '''You are a Vedic wealth advisor. Analyze this wealth report for $name and provide actionable insights.

Key highlights:
- Wealth strength: $overall/100
- Wealth class: $wclass
- Verdict: $verdict

Full report data (JSON):
$jsonStr

Please explain the key findings in simple language, highlight the most important money timing windows, and suggest practical next steps.''';
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
