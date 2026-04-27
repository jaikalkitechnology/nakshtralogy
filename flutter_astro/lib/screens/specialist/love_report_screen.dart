import 'package:flutter/material.dart';
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
    return [
      heroScores('❤️ LOVE SCORES', [
        [n(d, 'love_capacity_score'), 'LOVE\nCAPACITY'],
        [n(d, 'emotional_availability_score'), 'EMOTIONAL\nAVAILABILITY'],
        [n(d, 'romantic_attraction_score'), 'ROMANTIC\nATTRACTION'],
      ], [
        [n(d, 'commitment_readiness_score'), 'COMMITMENT'],
        [n(d, 'physical_intimacy_drive_score'), 'INTIMACY'],
        [n(d, 'fidelity_capacity_score'), 'FIDELITY'],
      ]),
      styleRows('Love Profile', [
        ['LOVE STYLE', d['love_style']], ['ATTRACTION STYLE', d['attraction_style']],
        ['LOVE PATH', d['likely_love_path']], ['CURRENT PHASE', d['current_relationship_phase']],
        ['COMMITMENT STYLE', d['commitment_style']],
      ]),
      if (d['karaka_strength_table'] is Map) ...[
        ReportHeader('Love', 'Karakas', '9 PLANETS'),
        karakaTable((d['karaka_strength_table'] as Map).cast<String, dynamic>()),
      ],
      // Love languages
      _loveLanguages(d),
      // Ideal partner
      _idealPartner(d),
      // Attraction archetypes
      chipsList('★ ATTRACTED TO', (d['attraction_to_archetypes'] as List?) ?? [], AppColors.cosmicPink),
      chipsList('● WHAT PARTNER SEES', (d['what_partner_will_find_attractive_in_self'] as List?) ?? [], AppColors.aurora),
      // Romance history
      styleRows('Romance Pattern', [
        ['FIRST LOVE AGE', d['first_love_age_band']], ['RELATIONSHIP COUNT', d['estimated_significant_relationships_count']],
        ['AVG DURATION', d['average_relationship_duration_tendency']], ['BREAKUP TRIGGER', d['most_likely_breakup_trigger']],
        ['HEARTBREAK RECOVERY', d['heartbreak_recovery_time_tendency']],
      ]),
      yearlyTrend('Love Trend', (d['yearly_love_trend'] as List?) ?? [], scoreKey: 'love_intensity'),
      // New relationship windows
      if ((d['new_relationship_windows'] as List?)?.isNotEmpty == true)
        TimingWindowCard(title: 'New Love Windows', icon: '♡', color: AppColors.cosmicPink,
          items: (d['new_relationship_windows'] as List)),
      // Love blocks
      yogaLedger('Love Blocks', (d['active_love_blocks'] as List?) ?? [], [],
        creatingLabel: 'ACTIVE BLOCKS'),
      statTiles([
        [n(d, 'love_marriage_probability_pct'), 'LOVE MARRIAGE %'], [n(d, 'heartbreak_vulnerability_score'), 'HEARTBREAK VULN'],
        [n(d, 'self_sabotage_in_love_score'), 'SELF-SABOTAGE'], [n(d, 'emotional_intelligence_score'), 'EMOTIONAL IQ'],
      ]),
      const SizedBox(height: 10),
      risks((d['major_love_risks'] as List?) ?? []),
      remedies((d['astrological_remedies'] as List?) ?? []),
      verdictCard(d['love_life_verdict']?.toString() ?? '', d['next_best_action']?.toString(),
        subtitle: 'Fulfillment: ${n(d, 'love_fulfillment_probability_pct').toStringAsFixed(0)}%'),
    ];
  }

  Widget _loveLanguages(Map d) {
    final given = d['primary_love_language_given']?.toString() ?? '';
    final received = d['primary_love_language_received']?.toString() ?? '';
    if (given.isEmpty && received.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      ReportHeader('Love', 'Languages', '2 KEYS'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(children: [
          Expanded(child: _langCard('GIVES', given, AppColors.cosmicPink)),
          const SizedBox(width: 8),
          Expanded(child: _langCard('RECEIVES', received, AppColors.aurora)),
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

  Widget _idealPartner(Map d) {
    final traits = (d['astrological_ideal_partner_traits'] as List?) ?? [];
    final dealbreakers = (d['partner_dealbreakers_in_chart'] as List?) ?? [];
    if (traits.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      ReportHeader('Ideal', 'Partner', '${traits.length + dealbreakers.length} KEYS'),
      chipsList('★ SEEK THESE TRAITS', traits, AppColors.success),
      if (dealbreakers.isNotEmpty) chipsList('⚠ DEALBREAKERS', dealbreakers, AppColors.error),
    ]);
  }
}
