import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../l10n/gen/app_localizations.dart';
import 'engine_report_base.dart';
import 'report_components.dart';

class LegalReportScreen extends EngineReportBase {
  const LegalReportScreen({super.key, required super.chartId, required super.chartName, super.preloadedData})
      : super(engineKey: 'legal', engineLabel: 'Legal & Disputes');
  @override
  State<LegalReportScreen> createState() => _S();
}

class _S extends EngineReportBaseState<LegalReportScreen> {
  @override
  List<Widget> buildSections(Map<String, dynamic> d) {
    final l = AppLocalizations.of(context)!;
    return [
      heroScores('⚖️ ${l.legalScoresLabel}', [
        [n(d, 'legal_issue_vulnerability_score'), l.legalVulnerabilityLabel],
        [n(d, 'victory_potential_score'), l.victoryPotentialLabel],
      ], [
        [n(d, 'conflict_attraction_score'), l.conflictLabel], [n(d, 'dispute_resolution_capacity_score'), l.resolutionLabel],
      ]),
      styleRows(l.legalProfileTitle, [
        [l.karmaTypeLabel, d['legal_karma_type']], [l.conflictStyleLabel, d['conflict_approach_style']],
        [l.strategyLabel, d['optimal_legal_strategy']], [l.caseDurationLabel, d['case_duration_tendency']],
        [l.currentStatusLabel, d['current_legal_status_phase']],
      ]),
      if (d['karaka_legal_table'] is Map) ...[
        ReportHeader(l.legalLabel, l.karakasLabel, '9 PLANETS'),
        karakaTable(Map.fromEntries((d['karaka_legal_table'] as Map).entries.map((e) =>
          MapEntry(e.key.toString(), (e.value is Map ? (e.value as Map)['strength'] : e.value) ?? 0)))),
      ],
      yogaLedger(l.legalYogasTitle, (d['active_dispute_yogas'] as List?) ?? [],
        (d['active_protective_legal_yogas'] as List?) ?? [],
        creatingLabel: l.disputePressureLabel, clearingLabel: l.legalProtectionLabel),
      // Victory analysis
      _victoryAnalysis(d, l),
      // Dispute categories
      if (d['dispute_category_susceptibility_scores'] is Map) _disputeCategories(d, l),
      yearlyTrend(l.legalStressTitle, (d['yearly_legal_stress_trend'] as List?) ?? [], scoreKey: 'stress'),
      // Enemy analysis
      statTiles([
        [n(d, 'visible_enemies_tendency_score'), l.visibleEnemiesLabel], [n(d, 'hidden_enemies_tendency_score'), l.hiddenEnemiesLabel],
        [n(d, 'criminal_matter_involvement_risk_score'), l.criminalRiskLabel], [n(d, 'false_accusation_vulnerability_score'), l.falseAccusationLabel],
      ]),
      const SizedBox(height: 10),
      styleRows(l.contractKarmaTitle, [
        [l.documentationLabel, '${n(d, 'documentation_discipline_score').toStringAsFixed(0)}/100'],
        [l.finePrintAwareLabel, '${n(d, 'fine_print_awareness_score').toStringAsFixed(0)}/100'],
        [l.negotiationSkillLabel, '${n(d, 'negotiation_skill_score').toStringAsFixed(0)}/100'],
        [l.signatureCautionLabel, d['signature_caution_level']],
      ]),
      risks((d['major_legal_risks'] as List?) ?? []),
      remedies((d['astrological_remedies'] as List?) ?? []),
      verdictCard(d['overall_legal_karma_verdict']?.toString() ?? '', d['recommended_legal_lifestyle_strategy']?.toString(),
        subtitle: l.resilienceColonLabel(n(d, 'legal_resilience_score').toStringAsFixed(0))),
    ];
  }

  Widget _victoryAnalysis(Map d, AppLocalizations l) {
    final plaintiff = n(d, 'victory_probability_if_plaintiff_pct');
    final defendant = n(d, 'victory_probability_if_defendant_pct');
    return Column(children: [
      ReportHeader(l.victoryLabel, l.pairwiseSuffix, '2 SCENARIOS'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(children: [
          Expanded(child: _victoryCard(l.asPlaintiffLabel, plaintiff, AppColors.aurora, l)),
          const SizedBox(width: 8),
          Expanded(child: _victoryCard(l.asDefendantLabel, defendant, AppColors.gold, l)),
        ])),
    ]);
  }

  Widget _victoryCard(String label, double pct, Color c, AppLocalizations l) => Container(padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: c.withOpacity(0.08), borderRadius: BorderRadius.circular(14),
      border: Border.all(color: c.withOpacity(0.3))),
    child: Column(children: [
      Text(label, style: TextStyle(color: c, fontSize: 8, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      Text('${pct.toStringAsFixed(0)}%', style: TextStyle(color: c, fontSize: 24, fontWeight: FontWeight.w700, fontFamily: 'serif')),
      Text(l.winProbabilityLabel, style: const TextStyle(color: AppColors.smoke, fontSize: 7, fontFamily: 'monospace')),
    ]));

  Widget _disputeCategories(Map d, AppLocalizations l) {
    final cats = (d['dispute_category_susceptibility_scores'] as Map).cast<String, dynamic>();
    final sorted = cats.entries.where((e) => e.value is num).toList()..sort((a, b) => (b.value as num).compareTo(a.value as num));
    return Column(children: [
      ReportHeader(l.disputeLabel, l.categoriesLabel, '${sorted.length} TYPES'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(14)),
        child: Column(children: sorted.take(12).map((e) {
          final v = (e.value as num).toDouble();
          final c = v >= 30 ? AppColors.error : v >= 20 ? AppColors.warning : AppColors.success;
          return Padding(padding: const EdgeInsets.only(bottom: 4), child: Row(children: [
            SizedBox(width: 70, child: Text(titleCase(e.key), style: const TextStyle(color: AppColors.ivory, fontSize: 9))),
            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(value: v / 100, minHeight: 4, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
            const SizedBox(width: 6),
            SizedBox(width: 24, child: Text(v.toStringAsFixed(0), textAlign: TextAlign.right, style: TextStyle(color: c, fontSize: 9, fontWeight: FontWeight.w700, fontFamily: 'monospace'))),
          ]));
        }).toList())),
    ]);
  }
}
