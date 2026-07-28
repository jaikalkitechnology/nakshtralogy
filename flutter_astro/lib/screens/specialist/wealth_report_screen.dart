import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../l10n/gen/app_localizations.dart';
import 'engine_report_base.dart';
import 'report_components.dart';

class WealthReportScreen extends EngineReportBase {
  const WealthReportScreen({super.key, required super.chartId, required super.chartName, super.preloadedData})
      : super(engineKey: 'wealth', engineLabel: 'Wealth & Finance');
  @override
  State<WealthReportScreen> createState() => _S();
}

class _S extends EngineReportBaseState<WealthReportScreen> {
  @override
  List<Widget> buildSections(Map<String, dynamic> d) {
    final l = AppLocalizations.of(context)!;
    return [
      heroScores('💰 ${l.wealthScoresLabel}', [
        [n(d, 'wealth_strength_score'), l.wealthStrengthLabel],
        [n(d, 'accumulation_capacity_score'), l.accumulationLabel],
        [n(d, 'income_flow_score'), l.incomeFlowLabel],
      ], [
        [n(d, 'long_term_sustainability_score'), l.sustainLabel],
        [d['multiple_income_streams_likelihood'] ?? 0, l.multiStreamLabel],
        [n(d, 'wealth_retention_score'), l.retentionLabel],
      ]),
      // Wealth class
      if (d['wealth_class'] != null) _wealthClass(d, l),
      // Karakas
      if (d['karaka_strength_table'] is Map) ...[
        ReportHeader(l.wealthLabel, l.karakasLabel, '7 PLANETS'),
        karakaTable((d['karaka_strength_table'] as Map).cast<String, dynamic>()),
      ],
      // Yogas
      yogaLedger(l.wealthYogasTitle, (d['active_wealth_doshas'] as List?) ?? [], (d['active_wealth_yogas'] as List?) ?? [],
        creatingLabel: l.drainsLabel, clearingLabel: l.boostersLabel),
      // Income sources
      if (d['income_source_scores'] is Map) _incomeSources(d, l),
      // Investment mix
      if (d['recommended_investment_mix'] is List) _investmentMix(d, l),
      // 15-year trend
      yearlyTrend(l.yearlyTrendTitle, (d['yearly_wealth_trend'] as List?) ?? []),
      // Good/bad periods
      periodCards(l.wealthGrowthTitle, (d['good_wealth_periods'] as List?) ?? [],
        l.cashPressureTitle, (d['bad_wealth_periods'] as List?) ?? []),
      // Money personality
      styleRows(l.moneyPersonalityTitle, [
        [l.wealthTypeLabel, d['wealth_type']], [l.riskAppetiteLabel, d['risk_appetite']],
        [l.investmentStyleLabel, d['investment_style']], [l.moneyPersonalityLabel, d['money_personality']],
        [l.spendingLabel, d['spending_tendency']],
      ]),
      // Stat tiles
      statTiles([
        [n(d, 'debt_probability_pct'), l.debtProbLabel], [n(d, 'inheritance_probability_pct'), l.inheritanceProbLabel],
        [n(d, 'sudden_gains_probability_pct'), l.suddenGainsProbLabel], [n(d, 'spouse_wealth_boost_pct'), l.spouseBoostLabel],
      ]),
      const SizedBox(height: 10),
      // Risks
      risks((d['major_wealth_risks'] as List?) ?? []),
      // Core blocker
      if (d['core_wealth_blocker'] is Map) _blocker(d, l),
      // Remedies
      remedies((d['astrological_remedies'] as List?) ?? []),
      // Verdict
      verdictCard(d['final_verdict']?.toString() ?? '', d['recommendation']?.toString(),
        subtitle: l.successProbabilityLabel(n(d, 'success_probability').toStringAsFixed(0))),
    ];
  }

  Widget _wealthClass(Map d, AppLocalizations l) {
    final cls = d['wealth_class']?.toString() ?? '';
    final range = (d['lifetime_wealth_range_inr'] as Map?)?.cast<String, dynamic>() ?? {};
    final display = range['display']?.toString() ?? '';
    final peak = d['peak_net_worth_age']?.toString() ?? '';
    final primary = d['primary_income_source']?.toString() ?? '';
    return Container(margin: const EdgeInsets.fromLTRB(16, 4, 16, 12), padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.gold.withOpacity(0.15), AppColors.saffron.withOpacity(0.08)]),
        borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.gold.withOpacity(0.4))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l.lifetimeWealthClassLabel, style: const TextStyle(color: AppColors.gold, fontSize: 8, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(titleCase(cls), style: const TextStyle(color: AppColors.ivory, fontSize: 22, fontWeight: FontWeight.w700, fontFamily: 'serif')),
        if (display.isNotEmpty) Text(display, style: const TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Row(children: [
          if (primary.isNotEmpty) Expanded(child: Text(l.primaryLabel(primary), style: const TextStyle(color: AppColors.lavender, fontSize: 10))),
          if (peak.isNotEmpty) Text(l.peakAgeLabel(peak), style: const TextStyle(color: AppColors.smoke, fontSize: 10)),
        ]),
      ]));
  }

  Widget _incomeSources(Map d, AppLocalizations l) {
    final sources = (d['income_source_scores'] as Map).cast<String, dynamic>();
    final sorted = sources.entries.where((e) => e.value is num).toList()..sort((a, b) => (b.value as num).compareTo(a.value as num));
    return Column(children: [
      ReportHeader(l.incomeLabel, l.sourcesLabel, '${sorted.length} TYPES'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(14)),
        child: Column(children: sorted.take(8).toList().asMap().entries.map((e) {
          final v = (e.value.value as num).toDouble();
          final isTop = e.key < 3;
          final c = isTop ? AppColors.gold : AppColors.smoke;
          return Padding(padding: const EdgeInsets.only(bottom: 5), child: Row(children: [
            SizedBox(width: 80, child: Text(titleCase(e.value.key), style: TextStyle(color: isTop ? AppColors.ivory : AppColors.smoke, fontSize: 10, fontWeight: isTop ? FontWeight.w600 : FontWeight.normal))),
            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(value: v / 100, minHeight: 4, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
            const SizedBox(width: 8),
            SizedBox(width: 28, child: Text(v.toStringAsFixed(0), textAlign: TextAlign.right, style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.w700, fontFamily: 'monospace'))),
          ]));
        }).toList())),
    ]);
  }

  Widget _investmentMix(Map d, AppLocalizations l) {
    final mix = (d['recommended_investment_mix'] as List);
    return Column(children: [
      ReportHeader(l.investmentLabel, l.mixLabel, '${mix.length} BUCKETS'),
      ...mix.take(4).map((item) {
        if (item is! Map) return const SizedBox.shrink();
        final m = item.cast<String, dynamic>();
        final pct = (m['suggested_allocation_pct'] as num?)?.toDouble() ?? 0;
        final asset = m['asset_class']?.toString() ?? '';
        final planet = m['driven_by']?.toString() ?? '';
        return Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 6), padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gold.withOpacity(0.15))),
          child: Row(children: [
            SizedBox(width: 40, child: Text('${pct.toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.gold, fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'serif'))),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(asset, style: const TextStyle(color: AppColors.ivory, fontSize: 11, fontWeight: FontWeight.w600)),
              Text(l.drivenByLabel(planet), style: const TextStyle(color: AppColors.smoke, fontSize: 9)),
            ])),
          ]));
      }),
    ]);
  }

  Widget _blocker(Map d, AppLocalizations l) {
    final b = (d['core_wealth_blocker'] as Map).cast<String, dynamic>();
    return Container(margin: const EdgeInsets.fromLTRB(16, 8, 16, 8), padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.08), borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.warning.withOpacity(0.3))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l.coreBlockerLabel, style: const TextStyle(color: AppColors.warning, fontSize: 8, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(b['primary_blocker']?.toString() ?? '', style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w700)),
        if (b['explanation'] != null) ...[const SizedBox(height: 4),
          Text(b['explanation'].toString(), style: const TextStyle(color: AppColors.lavender, fontSize: 10, height: 1.4))],
        if (b['remedy_direction'] != null) ...[const SizedBox(height: 6),
          Text('✓ ${b['remedy_direction']}', style: const TextStyle(color: AppColors.success, fontSize: 10, height: 1.4))],
      ]));
  }
}
