import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
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
    return [
      heroScores('🔮 PAST LIFE SCORES', [
        [n(d, 'past_life_signature_strength_score'), 'SIGNATURE\nSTRENGTH'],
        [n(d, 'past_life_carryforward_intensity_score'), 'CARRY-\nFORWARD'],
        [n(d, 'past_life_mastery_preservation_score'), 'MASTERY\nPRESERVED'],
      ], [
        [n(d, 'past_life_unfinished_business_score'), 'UNFINISHED'],
        [n(d, 'total_karmic_debt_score'), 'KARMIC DEBT'],
      ]),
      // Ketu = Past mastery
      _ketuAxis(d),
      // Rahu = Future growth
      _rahuAxis(d),
      // Past life profile
      styleRows('Past Life Profile', [
        ['THEME', d['primary_past_life_theme']], ['PROFESSION', d['primary_past_life_profession']],
        ['SOCIAL STANDING', d['past_life_social_standing']], ['REGION', d['likely_past_life_region_signature']],
        ['SPIRITUAL LEVEL', d['past_life_spiritual_level']], ['GENDER', d['past_life_gender_tendency']],
        ['WEALTH LEVEL', d['past_life_wealth_level']], ['FAMILY ROLE', d['past_life_family_role']],
      ]),
      chipsList('★ SKILLS CARRIED FORWARD', (d['skills_carried_forward'] as List?) ?? [], AppColors.success),
      chipsList('● NATURAL ATTRACTIONS', (d['natural_attractions_list'] as List?) ?? [], AppColors.aurora),
      chipsList('⚠ UNEXPLAINED FEARS', (d['unexplained_fears_list'] as List?) ?? [], AppColors.error),
      chipsList('→ MAGNETIC PULLS', (d['magnetic_pulls_list'] as List?) ?? [], AppColors.cosmicPink),
      // Karmic debts
      statTiles([
        [n(d, 'relationship_karmic_debt_score'), 'RELATIONSHIP'], [n(d, 'financial_karmic_debt_score'), 'FINANCIAL'],
        [n(d, 'service_karmic_debt_score'), 'SERVICE'], [n(d, 'dharmic_karmic_debt_score'), 'DHARMIC'],
      ]),
      const SizedBox(height: 10),
      // Influence on this life
      statTiles([
        [n(d, 'past_life_influence_on_relationships_score'), 'ON RELATIONS'], [n(d, 'past_life_influence_on_career_score'), 'ON CAREER'],
        [n(d, 'past_life_influence_on_health_score'), 'ON HEALTH'], [n(d, 'past_life_influence_on_spirituality_score'), 'ON SPIRITUAL'],
      ]),
      const SizedBox(height: 10),
      // Resolution
      styleRows('Karmic Resolution', [
        ['PRIMARY PATH', d['primary_resolution_pathway']], ['SECONDARY PATH', d['secondary_resolution_pathway']],
        ['CLEARING PROGRESS', '${n(d, 'karma_clearing_progress_score').toStringAsFixed(0)}%'],
        ['REMAINING WORK', '${n(d, 'remaining_karmic_work_intensity_score').toStringAsFixed(0)}%'],
        ['DEBT TIMELINE', d['karmic_debt_settlement_timeline']],
      ]),
      // Memory access
      statTiles([
        [n(d, 'past_life_memory_access_score'), 'MEMORY ACCESS'], [n(d, 'dream_past_life_visitation_score'), 'DREAM VISITS'],
        [n(d, 'deja_vu_frequency_score'), 'DEJA VU'], [d['regression_receptivity_score'] ?? 0, 'REGRESSION FIT'],
      ]),
      const SizedBox(height: 10),
      if ((d['active_past_life_surface_windows'] as List?)?.isNotEmpty == true)
        TimingWindowCard(title: 'Past Life Activation', icon: '↻', color: AppColors.cosmicPink,
          items: d['active_past_life_surface_windows'] as List),
      remedies((d['astrological_remedies'] as List?) ?? []),
      verdictCard(d['overall_past_life_verdict']?.toString() ?? '',
        d['recommended_past_life_integration_strategy']?.toString(),
        subtitle: 'Maturity: ${n(d, 'past_life_maturity_score').toStringAsFixed(0)} · Status: ${d['current_life_relationship_to_past_life'] ?? ""}'),
    ];
  }

  Widget _ketuAxis(Map d) {
    final mastery = d['past_life_mastery_domain']?.toString() ?? '';
    final skills = (d['skills_carried_forward'] as List?) ?? [];
    return Column(children: [
      ReportHeader('Ketu', 'Past Mastery', 'H${d['ketu_house'] ?? "?"}'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.lavender.withOpacity(0.12), const Color(0xFF4A3B8C).withOpacity(0.15)]),
          borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.lavender.withOpacity(0.3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('KETU · WHAT YOU MASTERED', style: TextStyle(color: AppColors.lavender, fontSize: 8, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          if (mastery.isNotEmpty) Text(mastery, style: const TextStyle(color: AppColors.ivory, fontSize: 12, fontWeight: FontWeight.w600, height: 1.4)),
          if (skills.isNotEmpty) ...[const SizedBox(height: 6),
            Wrap(spacing: 6, runSpacing: 4, children: skills.take(5).map((s) => InfoChip(s.toString(), AppColors.lavender)).toList())],
        ])),
    ]);
  }

  Widget _rahuAxis(Map d) {
    final unfinished = d['past_life_unfinished_domain']?.toString() ?? '';
    final desires = (d['past_life_unmet_desires'] as List?) ?? [];
    final shadow = d['rahu_shadow_pattern']?.toString() ?? '';
    return Column(children: [
      ReportHeader('Rahu', 'Future Growth', 'H${d['rahu_house'] ?? "?"}'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.cosmicPink.withOpacity(0.12), const Color(0xFF4A3B8C).withOpacity(0.15)]),
          borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.cosmicPink.withOpacity(0.3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('RAHU · WHAT PULLS YOU FORWARD', style: TextStyle(color: AppColors.cosmicPink, fontSize: 8, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          if (unfinished.isNotEmpty) Text(unfinished, style: const TextStyle(color: AppColors.ivory, fontSize: 12, fontWeight: FontWeight.w600, height: 1.4)),
          if (desires.isNotEmpty) ...[const SizedBox(height: 6),
            Wrap(spacing: 6, runSpacing: 4, children: desires.take(5).map((s) => InfoChip(s.toString(), AppColors.cosmicPink)).toList())],
          if (shadow.isNotEmpty) ...[const SizedBox(height: 8),
            Text('⚠ Shadow: $shadow', style: const TextStyle(color: AppColors.warning, fontSize: 9, fontStyle: FontStyle.italic))],
        ])),
    ]);
  }
}
