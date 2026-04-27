import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'engine_report_base.dart';
import 'report_components.dart';

class CharacterReportScreen extends EngineReportBase {
  const CharacterReportScreen({super.key, required super.chartId, required super.chartName, super.preloadedData})
      : super(engineKey: 'character', engineLabel: 'Character Analysis');
  @override
  State<CharacterReportScreen> createState() => _S();
}

class _S extends EngineReportBaseState<CharacterReportScreen> {
  @override
  List<Widget> buildSections(Map<String, dynamic> d) {
    return [
      heroScores('🔍 CHARACTER SCORES', [
        [n(d, 'overall_character_strength_score'), 'CHARACTER\nSTRENGTH'],
        [n(d, 'integrity_score'), 'INTEGRITY'],
        [n(d, 'resilience_score'), 'RESILIENCE'],
      ], [
        [n(d, 'self_awareness_score'), 'AWARENESS'], [n(d, 'emotional_stability_score'), 'STABILITY'],
        [n(d, 'moral_ethical_fabric_score'), 'ETHICS'],
      ]),
      // Atmakaraka
      _atmakaraka(d),
      // Lagna surface
      styleRows('Surface Personality', [
        ['LAGNA', d['lagna_sign_name']], ['CONSTITUTION', d['primary_character_constitution']],
        ['NAKSHATRA', d['lagna_nakshatra']], ['DEITY', d['lagna_nakshatra_deity']],
      ]),
      if (d['surface_personality_signature'] != null) Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 8), padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.06), borderRadius: BorderRadius.circular(8),
          border: const Border(left: BorderSide(color: AppColors.gold, width: 3))),
        child: Text(d['surface_personality_signature'].toString(),
          style: const TextStyle(color: AppColors.ivory, fontSize: 10, height: 1.4, fontStyle: FontStyle.italic))),
      // Moon (Manas)
      styleRows('Moon Manas', [
        ['SIGN', d['moon_sign_name']], ['NAKSHATRA', d['moon_nakshatra']],
        ['DEITY', d['moon_nakshatra_deity']], ['HOUSE', '${d['moon_house'] ?? "?"}H'],
      ]),
      // Guna profile
      _gunaProfile(d),
      // Interpersonal
      statTiles([
        [n(d, 'interpersonal_warmth_score'), 'WARMTH'], [n(d, 'empathy_capacity_score'), 'EMPATHY'],
        [n(d, 'loyalty_capacity_score'), 'LOYALTY'], [n(d, 'boundary_setting_capacity_score'), 'BOUNDARIES'],
      ]),
      const SizedBox(height: 10),
      // Ethics
      statTiles([
        [n(d, 'dharma_orientation_score'), 'DHARMA'], [n(d, 'truthfulness_baseline_score'), 'TRUTH'],
        [n(d, 'compassion_score'), 'COMPASSION'], [n(d, 'generosity_score'), 'GENEROSITY'],
      ]),
      const SizedBox(height: 10),
      // Strengths & shadow
      chipsList('★ SIGNATURE VIRTUES', (d['signature_virtues'] as List?) ?? [], AppColors.success),
      chipsList('● NATURAL TALENTS', (d['natural_talents'] as List?) ?? [], AppColors.aurora),
      chipsList('⚠ SHADOW PATTERNS', (d['primary_shadow_patterns'] as List?) ?? [], AppColors.warning),
      // Character yogas
      if ((d['character_gift_yogas'] as List?)?.isNotEmpty == true)
        yogaLedger('Character Yogas', (d['character_test_yogas'] as List?) ?? [],
          (d['character_gift_yogas'] as List?) ?? [],
          creatingLabel: 'TESTS', clearingLabel: 'GIFTS'),
      // EI
      statTiles([
        [n(d, 'self_awareness_ei_score'), 'SELF-AWARE EI'], [n(d, 'self_regulation_score'), 'SELF-REGULATE'],
        [n(d, 'empathy_ei_score'), 'EMPATHY EI'], [n(d, 'social_skills_score'), 'SOCIAL SKILLS'],
      ]),
      const SizedBox(height: 10),
      remedies((d['astrological_remedies'] is List ? d['astrological_remedies'] : []) as List),
      // Core theme
      if (d['core_character_theme'] is Map) _coreTheme(d),
      verdictCard(d['overall_character_verdict']?.toString() ?? '', d['authentic_self_expression_recommendation']?.toString(),
        subtitle: 'Realization: ${n(d, 'character_realization_potential_score').toStringAsFixed(0)}%'),
    ];
  }

  Widget _atmakaraka(Map d) {
    final planet = d['atmakaraka_planet']?.toString() ?? '';
    final desc = d['atmakaraka_soul_character_archetype']?.toString() ?? '';
    if (planet.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      ReportHeader('Atmakaraka', 'Soul Signature', 'CORE'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.cosmicPink.withOpacity(0.15), const Color(0xFF4A3B8C).withOpacity(0.15)]),
          borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.cosmicPink.withOpacity(0.3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('ATMAKARAKA', style: TextStyle(color: AppColors.cosmicPink, fontSize: 9, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(planet, style: const TextStyle(color: AppColors.ivory, fontSize: 22, fontWeight: FontWeight.w700, fontFamily: 'serif')),
          Text('${n(d, 'atmakaraka_degrees').toStringAsFixed(1)}°', style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontFamily: 'monospace')),
          if (desc.isNotEmpty) ...[const SizedBox(height: 6),
            Text(desc, style: const TextStyle(color: AppColors.lavender, fontSize: 10, height: 1.4, fontStyle: FontStyle.italic))],
        ])),
    ]);
  }

  Widget _gunaProfile(Map d) {
    final sattva = n(d, 'sattva_score'); final rajas = n(d, 'rajas_score'); final tamas = n(d, 'tamas_score');
    final dominant = d['dominant_guna']?.toString() ?? '';
    return Column(children: [
      ReportHeader('Guna', 'Profile', '3 GUNAS'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(14)),
        child: Column(children: [
          _gunaBar('Sattva', sattva, AppColors.success),
          _gunaBar('Rajas', rajas, AppColors.gold),
          _gunaBar('Tamas', tamas, AppColors.error),
          if (dominant.isNotEmpty) ...[const SizedBox(height: 6),
            Text('Dominant: ${titleCase(dominant)}', style: const TextStyle(color: AppColors.ivory, fontSize: 11, fontWeight: FontWeight.w600))],
        ])),
    ]);
  }

  Widget _gunaBar(String label, double v, Color c) => Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(children: [
    SizedBox(width: 50, child: Text(label, style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.w600))),
    Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(2),
      child: LinearProgressIndicator(value: v / 100, minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
    const SizedBox(width: 8),
    Text(v.toStringAsFixed(1), style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
  ]));

  Widget _coreTheme(Map d) {
    final theme = (d['core_character_theme'] as Map).cast<String, dynamic>();
    final isGift = theme['is_gift'] == true;
    final c = isGift ? AppColors.success : AppColors.gold;
    return Container(margin: const EdgeInsets.fromLTRB(16, 8, 16, 8), padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: c.withOpacity(0.08), borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.withOpacity(0.3))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(isGift ? '✦ CORE GIFT' : '● CORE THEME', style: TextStyle(color: c, fontSize: 8, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(theme['primary_theme']?.toString() ?? '', style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'serif')),
        if (theme['action_direction'] != null) ...[const SizedBox(height: 6),
          Text('→ ${theme['action_direction']}', style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.w600))],
      ]));
  }
}
