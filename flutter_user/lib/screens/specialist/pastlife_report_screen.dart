import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../l10n/gen/app_localizations.dart';
import 'engine_report_base.dart';
import 'report_components.dart';

class PastLifeReportScreen extends EngineReportBase {
  const PastLifeReportScreen({super.key, required super.chartId, required super.chartName, super.preloadedData})
      : super(engineKey: 'past_life', engineLabel: 'Past Life & Karma');
  @override
  State<PastLifeReportScreen> createState() => _S();
}

class _S extends EngineReportBaseState<PastLifeReportScreen> {
  @override
  List<Widget> buildSections(Map<String, dynamic> d) {
    final l = AppLocalizations.of(context)!;
    return [
      heroScores(l.pastlifeScoresHeader, [
        [n(d, 'past_life_signature_strength_score'), l.pastlifeSignatureStrengthStat],
        [n(d, 'past_life_carryforward_intensity_score'), l.pastlifeCarryForwardStat],
        [n(d, 'past_life_mastery_preservation_score'), l.pastlifeMasteryPreservedStat],
      ], [
        [n(d, 'past_life_unfinished_business_score'), l.pastlifeUnfinishedStat],
        [n(d, 'total_karmic_debt_score'), l.pastlifeKarmicDebtStat],
      ]),
      // Ketu = Past mastery
      _ketuAxis(d),
      // Rahu = Future growth
      _rahuAxis(d),
      // Past life profile
      styleRows(l.pastlifeProfileTitle, [
        [l.pastlifeThemeLabel, d['primary_past_life_theme']], [l.pastlifeProfessionLabel, d['primary_past_life_profession']],
        [l.pastlifeSocialStandingLabel, d['past_life_social_standing']], [l.pastlifeRegionLabel, d['likely_past_life_region_signature']],
        [l.pastlifeSpiritualLevelLabel, d['past_life_spiritual_level']], [l.pastlifeGenderLabel, d['past_life_gender_tendency']],
        [l.pastlifeWealthLevelLabel, d['past_life_wealth_level']], [l.pastlifeFamilyRoleLabel, d['past_life_family_role']],
      ]),
      chipsList(l.pastlifeSkillsCarriedTitle, (d['skills_carried_forward'] as List?) ?? [], AppColors.success),
      chipsList(l.pastlifeNaturalAttractionsTitle, (d['natural_attractions_list'] as List?) ?? [], AppColors.aurora),
      chipsList(l.pastlifeUnexplainedFearsTitle, (d['unexplained_fears_list'] as List?) ?? [], AppColors.error),
      chipsList(l.pastlifeMagneticPullsTitle, (d['magnetic_pulls_list'] as List?) ?? [], AppColors.cosmicPink),
      // Karmic debts
      statTiles([
        [n(d, 'relationship_karmic_debt_score'), l.pastlifeRelationshipStat], [n(d, 'financial_karmic_debt_score'), l.pastlifeFinancialStat],
        [n(d, 'service_karmic_debt_score'), l.pastlifeServiceStat], [n(d, 'dharmic_karmic_debt_score'), l.pastlifeDharmicStat],
      ]),
      const SizedBox(height: 10),
      // Influence on this life
      statTiles([
        [n(d, 'past_life_influence_on_relationships_score'), l.pastlifeOnRelationsStat], [n(d, 'past_life_influence_on_career_score'), l.pastlifeOnCareerStat],
        [n(d, 'past_life_influence_on_health_score'), l.pastlifeOnHealthStat], [n(d, 'past_life_influence_on_spirituality_score'), l.pastlifeOnSpiritualStat],
      ]),
      const SizedBox(height: 10),
      // Resolution
      styleRows(l.pastlifeKarmicResolutionTitle, [
        [l.pastlifePrimaryPathLabel, d['primary_resolution_pathway']], [l.pastlifeSecondaryPathLabel, d['secondary_resolution_pathway']],
        [l.pastlifeClearingProgressLabel, '${n(d, 'karma_clearing_progress_score').toStringAsFixed(0)}%'],
        [l.pastlifeRemainingWorkLabel, '${n(d, 'remaining_karmic_work_intensity_score').toStringAsFixed(0)}%'],
        [l.pastlifeDebtTimelineLabel, d['karmic_debt_settlement_timeline']],
      ]),
      // Memory access
      statTiles([
        [n(d, 'past_life_memory_access_score'), l.pastlifeMemoryAccessStat], [n(d, 'dream_past_life_visitation_score'), l.pastlifeDreamVisitsStat],
        [n(d, 'deja_vu_frequency_score'), l.pastlifeDejaVuStat], [d['regression_receptivity_score'] ?? 0, l.pastlifeRegressionFitStat],
      ]),
      const SizedBox(height: 10),
      if ((d['active_past_life_surface_windows'] as List?)?.isNotEmpty == true)
        TimingWindowCard(title: l.pastlifeActivationTitle, icon: '↻', color: AppColors.cosmicPink,
          items: d['active_past_life_surface_windows'] as List),
      remedies((d['astrological_remedies'] as List?) ?? []),
      verdictCard(d['overall_past_life_verdict']?.toString() ?? '',
        d['recommended_past_life_integration_strategy']?.toString(),
        subtitle: l.pastlifeMaturityStatusSubtitle(n(d, 'past_life_maturity_score').toStringAsFixed(0), d['current_life_relationship_to_past_life']?.toString() ?? '')),
    ];
  }

  Widget _ketuAxis(Map d) {
    final l = AppLocalizations.of(context)!;
    final mastery = d['past_life_mastery_domain']?.toString() ?? '';
    final skills = (d['skills_carried_forward'] as List?) ?? [];
    return Column(children: [
      ReportHeader(l.pastlifeKetuWord, l.pastlifePastMasterySuffix, 'H${d['ketu_house'] ?? "?"}'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.lavender.withOpacity(0.12), const Color(0xFF4A3B8C).withOpacity(0.15)]),
          borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.lavender.withOpacity(0.3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l.pastlifeKetuMasteredLabel, style: const TextStyle(color: AppColors.lavender, fontSize: 8, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          if (mastery.isNotEmpty) Text(mastery, style: const TextStyle(color: AppColors.ivory, fontSize: 12, fontWeight: FontWeight.w600, height: 1.4)),
          if (skills.isNotEmpty) ...[const SizedBox(height: 6),
            Wrap(spacing: 6, runSpacing: 4, children: skills.take(5).map((s) => InfoChip(s.toString(), AppColors.lavender)).toList())],
        ])),
    ]);
  }

  Widget _rahuAxis(Map d) {
    final l = AppLocalizations.of(context)!;
    final unfinished = d['past_life_unfinished_domain']?.toString() ?? '';
    final desires = (d['past_life_unmet_desires'] as List?) ?? [];
    final shadow = d['rahu_shadow_pattern']?.toString() ?? '';
    return Column(children: [
      ReportHeader(l.pastlifeRahuWord, l.pastlifeFutureGrowthSuffix, 'H${d['rahu_house'] ?? "?"}'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.cosmicPink.withOpacity(0.12), const Color(0xFF4A3B8C).withOpacity(0.15)]),
          borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.cosmicPink.withOpacity(0.3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l.pastlifeRahuPullsLabel, style: const TextStyle(color: AppColors.cosmicPink, fontSize: 8, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          if (unfinished.isNotEmpty) Text(unfinished, style: const TextStyle(color: AppColors.ivory, fontSize: 12, fontWeight: FontWeight.w600, height: 1.4)),
          if (desires.isNotEmpty) ...[const SizedBox(height: 6),
            Wrap(spacing: 6, runSpacing: 4, children: desires.take(5).map((s) => InfoChip(s.toString(), AppColors.cosmicPink)).toList())],
          if (shadow.isNotEmpty) ...[const SizedBox(height: 8),
            Text(l.pastlifeShadowPrefix(shadow), style: const TextStyle(color: AppColors.warning, fontSize: 9, fontStyle: FontStyle.italic))],
        ])),
    ]);
  }
}
