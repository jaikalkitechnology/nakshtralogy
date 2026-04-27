import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'engine_report_base.dart';
import 'report_components.dart';

class LifePathReportScreen extends EngineReportBase {
  const LifePathReportScreen({super.key, required super.chartId, required super.chartName, super.preloadedData})
      : super(engineKey: 'life_path', engineLabel: 'Life Path & Luck');
  @override
  State<LifePathReportScreen> createState() => _S();
}

class _S extends EngineReportBaseState<LifePathReportScreen> {
  @override
  List<Widget> buildSections(Map<String, dynamic> d) {
    return [
      heroScores('🌟 LIFE PATH SCORES', [
        [n(d, 'dharma_clarity_score'), 'DHARMA\nCLARITY'],
        [n(d, 'fortune_baseline_score'), 'FORTUNE\nBASELINE'],
        [n(d, 'life_path_coherence_score'), 'LIFE PATH\nCOHERENCE'],
      ], [
        [n(d, 'karmic_momentum_score'), 'KARMA'], [n(d, 'spiritual_inclination_score'), 'SPIRITUAL'],
        [n(d, 'fame_recognition_potential_score'), 'FAME'],
      ]),
      // Life archetype
      _archetype(d),
      styleRows('Soul Contract', [
        ['ATMAKARAKA', d['atmakaraka_planet']], ['AK FOCUS', d['atmakaraka_focus']],
        ['SOUL PURPOSE', d['soul_purpose_clarity']], ['LIFE CHAPTER', d['current_life_chapter_theme']],
        ['PRIMARY DOMAIN', d['primary_life_purpose_domain']],
      ]),
      // Purpose domains
      statTiles([
        [n(d, 'leadership_path_indicator_score'), 'LEADERSHIP'], [n(d, 'wisdom_teaching_path_score'), 'WISDOM/TEACH'],
        [n(d, 'service_path_indicator_score'), 'SERVICE'], [n(d, 'healing_path_indicator_score'), 'HEALING'],
      ]),
      const SizedBox(height: 10),
      yogaLedger('Fortune Yogas', (d['active_luck_blocks'] as List?) ?? [],
        (d['active_fortune_yogas'] as List?) ?? [],
        creatingLabel: 'LUCK BLOCKS', clearingLabel: 'FORTUNE BOOSTERS'),
      yearlyTrend('Fortune Trend', (d['yearly_fortune_trend'] as List?) ?? [], scoreKey: 'fortune'),
      if ((d['golden_windows'] as List?)?.isNotEmpty == true)
        TimingWindowCard(title: 'Golden Windows ★', icon: '★', color: AppColors.gold, items: d['golden_windows'] as List, isPeak: true),
      if ((d['transformation_windows'] as List?)?.isNotEmpty == true)
        TimingWindowCard(title: 'Transformation', icon: '↻', color: AppColors.cosmicPink, items: d['transformation_windows'] as List),
      // Milestones
      if ((d['major_milestones_expected'] as List?)?.isNotEmpty == true)
        TimingWindowCard(title: 'Life Milestones', icon: '◉', color: AppColors.aurora, items: d['major_milestones_expected'] as List),
      // Destiny vs free will
      _destinyFreeWill(d),
      // Karmic lessons
      styleRows('Karmic Lessons', [
        ['RAHU GROWTH', d['rahu_growth_challenge']], ['KETU SURRENDER', d['ketu_surrender_theme']],
        ['SATURN LESSON', d['saturn_discipline_lesson']], ['LIFE DIFFICULTY', '${n(d, 'overall_life_difficulty_score').toStringAsFixed(0)}/100'],
      ]),
      chipsList('★ SOUL CAME TO EXPERIENCE', (d['what_soul_came_to_experience'] as List?) ?? [], AppColors.aurora),
      chipsList('● BLESSINGS', (d['primary_life_blessings'] as List?) ?? [], AppColors.success),
      remedies((d['astrological_remedies'] as List?) ?? []),
      verdictCard(d['overall_life_path_verdict']?.toString() ?? '', d['destiny_fulfillment_strategy']?.toString(),
        subtitle: 'Fulfillment: ${n(d, 'life_fulfillment_potential_pct').toStringAsFixed(0)}%'),
    ];
  }

  Widget _archetype(Map d) {
    final arch = d['life_path_archetype']?.toString() ?? '';
    if (arch.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      ReportHeader('Life', 'Archetype', '1 KEY'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.gold.withOpacity(0.15), const Color(0xFF4A3B8C).withOpacity(0.15)]),
          borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.gold.withOpacity(0.3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('PRIMARY ARCHETYPE', style: TextStyle(color: AppColors.gold, fontSize: 9, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(titleCase(arch), style: const TextStyle(color: AppColors.ivory, fontSize: 22, fontWeight: FontWeight.w600, fontFamily: 'serif')),
        ])),
    ]);
  }

  Widget _destinyFreeWill(Map d) {
    final destiny = n(d, 'destiny_weight_percentage');
    final freeWill = n(d, 'free_will_leverage_percentage');
    if (destiny == 0 && freeWill == 0) return const SizedBox.shrink();
    return Column(children: [
      ReportHeader('Destiny vs', 'Free Will', '4 KEYS'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(children: [
          Expanded(child: _dualCard('DESTINY', destiny, AppColors.lavender)),
          const SizedBox(width: 8),
          Expanded(child: _dualCard('FREE WILL', freeWill, AppColors.aurora)),
        ])),
      if (d['destiny_vs_free_will_insight'] != null) Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 4), padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.08),
          borderRadius: const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
          border: const Border(left: BorderSide(color: AppColors.gold, width: 3))),
        child: Text(d['destiny_vs_free_will_insight'].toString(),
          style: const TextStyle(color: AppColors.ivory, fontSize: 10, height: 1.4, fontStyle: FontStyle.italic))),
    ]);
  }

  Widget _dualCard(String label, double pct, Color c) => Container(padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: c.withOpacity(0.08), borderRadius: BorderRadius.circular(14),
      border: Border.all(color: c.withOpacity(0.3))),
    child: Column(children: [
      Text(label, style: TextStyle(color: c, fontSize: 8, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
      Text('${pct.toStringAsFixed(0)}%', style: TextStyle(color: c, fontSize: 24, fontWeight: FontWeight.w700, fontFamily: 'serif')),
    ]));
}
