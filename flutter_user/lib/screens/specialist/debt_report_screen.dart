import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../l10n/gen/app_localizations.dart';
import 'engine_report_base.dart';
import 'report_components.dart';

class DebtReportScreen extends EngineReportBase {
  const DebtReportScreen({super.key, required super.chartId, required super.chartName, super.preloadedData})
      : super(engineKey: 'debt_recovery', engineLabel: 'Debt & Recovery');
  @override
  State<DebtReportScreen> createState() => _S();
}

class _S extends EngineReportBaseState<DebtReportScreen> {
  @override
  List<Widget> buildSections(Map<String, dynamic> d) {
    final l = AppLocalizations.of(context)!;
    return [
      heroScores(l.debtScoresHeader, [
        [n(d, 'current_debt_load_score'), l.debtCurrentLoadStat],
        [n(d, 'debt_recovery_capacity_score'), l.debtRecoveryCapacityStat],
      ], [
        [n(d, 'debt_intensity_now'), l.debtIntensityStat], [n(d, 'recent_defaults_risk'), l.debtDefaultRiskStat],
      ]),
      styleRows(l.debtProfileTitle, [
        [l.debtKarmaLabel, d['debt_karma_signature']], [l.debtPersonalityLabel, d['debt_personality']],
        [l.debtPhaseLabel, d['active_debt_phase']], [l.debtPrimaryCategoryLabel, d['primary_debt_category']],
      ]),
      if (d['karaka_strength_table'] is Map) ...[
        ReportHeader(l.debtWord, l.karakasSuffix, '9 PLANETS'),
        karakaTable((d['karaka_strength_table'] as Map).cast<String, dynamic>()),
      ],
      yogaLedger(l.debtYogasTitle, (d['active_debt_creating_yogas'] as List?) ?? [],
        (d['active_debt_clearing_yogas'] as List?) ?? [],
        creatingLabel: l.debtCreatingLabel, clearingLabel: l.debtClearingLabel),
      // Debt categories heat
      if (d['debt_category_scores'] is Map) _debtCategories(d),
      yearlyTrend(l.yearlyDebtTitle, (d['yearly_debt_trend'] as List?) ?? [], scoreKey: 'debt_pressure'),
      periodCards(l.debtRepaymentTitle, (d['good_repayment_periods'] as List?) ?? [],
        l.debtDangerPeriodsTitle, (d['dangerous_borrowing_periods'] as List?) ?? []),
      // Debt-free window
      if (d['debt_free_window'] is Map) _debtFreeWindow(d),
      statTiles([
        [n(d, 'default_probability_pct'), l.debtDefaultPctStat], [n(d, 'bankruptcy_risk_pct'), l.debtBankruptcyPctStat],
        [n(d, 'chronic_debt_probability'), l.debtChronicPctStat], [n(d, 'psychological_resilience_score'), l.debtResilienceStat],
      ]),
      const SizedBox(height: 10),
      // Core blocker
      if (d['core_debt_blocker'] is Map) _blocker(d),
      risks((d['major_debt_risks'] as List?) ?? []),
      remedies((d['astrological_remedies'] as List?) ?? []),
      verdictCard(d['recovery_verdict']?.toString() ?? '',
        d['recommended_strategy']?.toString(),
        subtitle: l.debtRecoveryTimelineSubtitle(n(d, 'recovery_probability_pct').toStringAsFixed(0), d['timeline_to_debt_free_years']?.toString() ?? '?')),
    ];
  }

  Widget _debtCategories(Map d) {
    final l = AppLocalizations.of(context)!;
    final cats = (d['debt_category_scores'] as Map).cast<String, dynamic>();
    final sorted = cats.entries.where((e) => e.value is num).toList()..sort((a, b) => (b.value as num).compareTo(a.value as num));
    return Column(children: [
      ReportHeader(l.debtWord, l.categoriesSuffix, '${sorted.length} TYPES'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(14)),
        child: Column(children: sorted.take(11).map((e) {
          final v = (e.value as num).toDouble();
          final c = v >= 60 ? AppColors.error : v >= 45 ? AppColors.warning : AppColors.success;
          return Padding(padding: const EdgeInsets.only(bottom: 5), child: Row(children: [
            SizedBox(width: 90, child: Text(titleCase(e.key), style: const TextStyle(color: AppColors.ivory, fontSize: 9))),
            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(value: v / 100, minHeight: 4, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
            const SizedBox(width: 6),
            SizedBox(width: 26, child: Text(v.toStringAsFixed(0), textAlign: TextAlign.right, style: TextStyle(color: c, fontSize: 9, fontWeight: FontWeight.w700, fontFamily: 'monospace'))),
          ]));
        }).toList())),
    ]);
  }

  Widget _debtFreeWindow(Map d) {
    final l = AppLocalizations.of(context)!;
    final w = (d['debt_free_window'] as Map).cast<String, dynamic>();
    return Container(margin: const EdgeInsets.fromLTRB(16, 8, 16, 8), padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.success.withOpacity(0.12), AppColors.success.withOpacity(0.04)]),
        borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.success.withOpacity(0.3))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l.debtFreeWindowLabel, style: const TextStyle(color: AppColors.success, fontSize: 9, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Text(l.debtFreeYear(w['year']?.toString() ?? ''), style: const TextStyle(color: AppColors.ivory, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'serif')),
        Text(l.dashaLabel(w['dasha'] ?? ''), style: const TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w600)),
        if (w['note'] != null) Text(w['note'].toString(), style: const TextStyle(color: AppColors.lavender, fontSize: 10, fontStyle: FontStyle.italic)),
      ]));
  }

  Widget _blocker(Map d) {
    final l = AppLocalizations.of(context)!;
    final b = (d['core_debt_blocker'] as Map).cast<String, dynamic>();
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
          Text('✓ ${b['remedy_direction']}', style: const TextStyle(color: AppColors.success, fontSize: 10))],
      ]));
  }
}
