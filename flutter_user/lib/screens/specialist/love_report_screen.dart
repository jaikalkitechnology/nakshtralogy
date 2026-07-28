import 'package:flutter/material.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import 'engine_report_base.dart';
import 'report_components.dart';

class LoveReportScreen extends EngineReportBase {
  const LoveReportScreen({super.key, required super.chartId, required super.chartName, super.preloadedData})
      : super(engineKey: 'love', engineLabel: 'Love & Relationships');
  @override
  State<LoveReportScreen> createState() => _S();
}

class _S extends EngineReportBaseState<LoveReportScreen> {
  @override
  List<Widget> buildSections(Map<String, dynamic> d) {
    final l = AppLocalizations.of(context)!;
    return [
      heroScores('❤️ ${l.loveScoresLabel}', [
        [n(d, 'love_capacity_score'), l.loveCapacityLabel],
        [n(d, 'emotional_availability_score'), l.emotionalAvailabilityLabel],
        [n(d, 'romantic_attraction_score'), l.romanticAttractionLabel],
      ], [
        [n(d, 'commitment_readiness_score'), l.commitmentWord],
        [n(d, 'physical_intimacy_drive_score'), l.intimacyWord],
        [n(d, 'fidelity_capacity_score'), l.fidelityWord],
      ]),
      styleRows(l.loveProfileTitle, [
        [l.loveStyleLabel, d['love_style']], [l.attractionStyleLabel, d['attraction_style']],
        [l.lovePathLabel, d['likely_love_path']], [l.currentPhaseLabel, d['current_relationship_phase']],
        [l.commitmentStyleLabel, d['commitment_style']],
      ]),
      if (d['karaka_strength_table'] is Map) ...[
        ReportHeader(l.loveWord, l.karakasWord, '9 PLANETS'),
        karakaTable((d['karaka_strength_table'] as Map).cast<String, dynamic>()),
      ],
      // Love languages
      _loveLanguages(l, d),
      // Ideal partner
      _idealPartner(l, d),
      // Attraction archetypes
      chipsList('★ ${l.attractedToLabel}', (d['attraction_to_archetypes'] as List?) ?? [], AppColors.cosmicPink),
      chipsList('● ${l.whatPartnerSeesLabel}', (d['what_partner_will_find_attractive_in_self'] as List?) ?? [], AppColors.aurora),
      // Romance history
      styleRows(l.romancePatternTitle, [
        [l.firstLoveAgeLabel, d['first_love_age_band']], [l.relationshipCountLabel, d['estimated_significant_relationships_count']],
        [l.avgDurationLabel, d['average_relationship_duration_tendency']], [l.breakupTriggerLabel, d['most_likely_breakup_trigger']],
        [l.heartbreakRecoveryLabel, d['heartbreak_recovery_time_tendency']],
      ]),
      yearlyTrend(l.loveTrendTitle, (d['yearly_love_trend'] as List?) ?? [], scoreKey: 'love_intensity'),
      // New relationship windows
      if ((d['new_relationship_windows'] as List?)?.isNotEmpty == true)
        TimingWindowCard(title: l.newLoveWindowsTitle, icon: '♡', color: AppColors.cosmicPink,
          items: (d['new_relationship_windows'] as List)),
      // Love blocks
      yogaLedger(l.loveBlocksTitle, (d['active_love_blocks'] as List?) ?? [], [],
        creatingLabel: l.activeBlocksLabel),
      statTiles([
        [n(d, 'love_marriage_probability_pct'), l.loveMarriagePctLabel], [n(d, 'heartbreak_vulnerability_score'), l.heartbreakVulnLabel],
        [n(d, 'self_sabotage_in_love_score'), l.selfSabotageLabel], [n(d, 'emotional_intelligence_score'), l.emotionalIqLabel],
      ]),
      const SizedBox(height: 10),
      risks((d['major_love_risks'] as List?) ?? []),
      remedies((d['astrological_remedies'] as List?) ?? []),
      verdictCard(d['love_life_verdict']?.toString() ?? '', d['next_best_action']?.toString(),
        subtitle: l.fulfillmentPctLabel(n(d, 'love_fulfillment_probability_pct').toStringAsFixed(0))),
    ];
  }

  Widget _loveLanguages(AppLocalizations l, Map d) {
    final given = d['primary_love_language_given']?.toString() ?? '';
    final received = d['primary_love_language_received']?.toString() ?? '';
    if (given.isEmpty && received.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      ReportHeader(l.loveWord, l.languagesWord, '2 KEYS'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(children: [
          Expanded(child: _langCard(l.givesLabel, given, AppColors.cosmicPink)),
          const SizedBox(width: 8),
          Expanded(child: _langCard(l.receivesLabel, received, AppColors.aurora)),
        ])),
      if (d['love_language_compatibility_notes'] != null) Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 4), padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.08),
          borderRadius: const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
          border: const Border(left: BorderSide(color: AppColors.gold, width: 3))),
        child: Text(d['love_language_compatibility_notes'].toString(),
          style: const TextStyle(color: AppColors.ivory, fontSize: 10, height: 1.4, fontStyle: FontStyle.italic))),
    ]);
  }

  Widget _langCard(String tag, String lang, Color c) => Container(padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: c.withOpacity(0.08), borderRadius: BorderRadius.circular(14),
      border: Border.all(color: c.withOpacity(0.3))),
    child: Column(children: [
      Text(tag, style: TextStyle(color: c, fontSize: 8, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
      const SizedBox(height: 4),
      Text(lang, style: TextStyle(color: c, fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'serif')),
    ]));

  Widget _idealPartner(AppLocalizations l, Map d) {
    final traits = (d['astrological_ideal_partner_traits'] as List?) ?? [];
    final dealbreakers = (d['partner_dealbreakers_in_chart'] as List?) ?? [];
    if (traits.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      ReportHeader(l.idealWord, l.partnerWord, '${traits.length + dealbreakers.length} KEYS'),
      chipsList('★ ${l.seekTheseTraitsLabel}', traits, AppColors.success),
      if (dealbreakers.isNotEmpty) chipsList('⚠ ${l.dealbreakersLabel}', dealbreakers, AppColors.error),
    ]);
  }
}
