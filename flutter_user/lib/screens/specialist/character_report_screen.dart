import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../../utils/kundli_names.dart';
import '../kundli/widgets/kundli_ui.dart';

/// Character Analysis report — premium AI character-coach redesign.
///
/// Presentation only. Loads the `character` specialist
/// (`runSpecialist('character')`) unchanged and re-presents it; every score,
/// karaka, yoga, timing window, remedy and confidence value comes straight
/// from the engine.
class CharacterReportScreen extends StatefulWidget {
  final String chartId, chartName;
  final Map<String, dynamic>? preloadedData;
  const CharacterReportScreen({super.key, required this.chartId, required this.chartName, this.preloadedData});
  @override
  State<CharacterReportScreen> createState() => _CharacterReportState();
}

class _CharacterReportState extends State<CharacterReportScreen> {
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
      final resp = await _api.runSpecialist('character', widget.chartId);
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
  bool _bool(String k) => _data?[k] == true;

  /// practical_solutions / astrological_remedies can be a list of plain
  /// strings OR a list of {category/deity, advice/remedy} maps — normalize.
  List<List<String>> _remedyItems(String key) {
    final out = <List<String>>[];
    for (final item in _list(key)) {
      if (item is Map) {
        final title = (item['category'] ?? item['deity'] ?? '').toString();
        final body = (item['advice'] ?? item['remedy'] ?? '').toString();
        if (body.isNotEmpty) out.add([title, body]);
      } else if (item is String && item.isNotEmpty) {
        out.add(['', item]);
      }
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.ivory), onPressed: () => Navigator.pop(context)),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(widget.chartName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.ivory, fontSize: 15, fontWeight: FontWeight.w700)),
          Text(l.chSubtitle, style: const TextStyle(color: AppColors.gold, fontSize: 10)),
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
    // Sections render directly (no staggered fade wrapper) — a tall hero pushes
    // lower sections past the viewport, and a per-section entrance animation
    // there can stick at opacity 0 and leave the lower report blank.
    const gap = SizedBox(height: 18);
    return [
      _breadcrumb(l),
      const SizedBox(height: 10),
      _snapshot(l),          // 1
      gap, _soulSignature(l),   // 2
      gap, _surfacePersonality(l), // 3
      gap, _mindEmotionsEgo(l), // 4
      gap, _communicationStyle(l), // 5
      gap, _publicPersona(l),   // 6
      gap, _gunaDosha(l),       // 7
      gap, _yogas(l),           // 8
      gap, _strengths(l),       // 9
      gap, _shadow(l),          // 10
      gap, _relationships(l),   // 11
      gap, _ethics(l),          // 12
      gap, _emotionalIntel(l),  // 13
      gap, _verification(l),    // 14
      gap, _timeline(l),        // 15
      gap, _improvementPlan(l), // 16
      gap, _roadmap(l),         // 17
      gap, _reliability(l),     // 18
      gap, _discussAi(l),       // 19
    ];
  }

  Widget _breadcrumb(AppLocalizations l) => Row(children: [
    Text(l.crCrumbHome, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Text(l.crCrumbReports, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Flexible(child: Text(l.chTitle, style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
  ]);

  // ══════════════════════════════════════════════════════════════════
  //  1 — CHARACTER SNAPSHOT
  // ══════════════════════════════════════════════════════════════════
  Widget _snapshot(AppLocalizations l) {
    final overall = _sc('overall_character_strength_score');
    final col = _col(overall);
    final verdict = _str('overall_character_verdict');
    final summary = _str('character_verdict_explanation').isNotEmpty ? _str('character_verdict_explanation') : _str('plain_statement');
    final gauges = <List<Object>>[
      [l.chGaugeIntegrity, _sc('integrity_score')],
      [l.chGaugeResilience, _sc('resilience_score')],
      [l.chGaugeSelfAwareness, _sc('self_awareness_score')],
      [l.chGaugeStability, _sc('emotional_stability_score')],
      [l.chGaugeMoralFabric, _sc('moral_ethical_fabric_score')],
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [col.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
        borderRadius: BorderRadius.circular(22), border: Border.all(color: col.withOpacity(0.3)),
      ),
      child: Column(children: [
        Text(l.chSnapshotHeader.toUpperCase(), style: const TextStyle(color: AppColors.smoke, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
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
        if (verdict.isNotEmpty) Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(color: col.withOpacity(0.16), borderRadius: BorderRadius.circular(20)),
          child: Text(_titleCase(verdict), style: TextStyle(color: col, fontSize: 14, fontWeight: FontWeight.w800))),
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
    if (_bool('raja_yoga_present')) out.add(l.chChipRajaYoga);
    if (_sc('integrity_score') >= 70) out.add(l.chChipHighIntegrity);
    if (_sc('resilience_score') >= 70) out.add(l.chChipResilient);
    if (_sc('dharma_orientation_score') >= 70) out.add(l.chChipDharmic);
    if (_sc('empathy_capacity_score') >= 60) out.add(l.chChipEmpathetic);
    if (_sc('loyalty_capacity_score') >= 60) out.add(l.chChipLoyal);
    if (_map('core_character_theme')['is_gift'] == true) out.add(l.chChipGiftedCharacter);
    return out.toSet().take(6).toList();
  }

  Widget _miniGauge(String label, double score) {
    final col = _col(score);
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
  //  2 — YOUR SOUL SIGNATURE (Atmakaraka)
  // ══════════════════════════════════════════════════════════════════
  Widget _soulSignature(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    final soul = KundliNames.planet(_str('atmakaraka_planet'), loc);
    if (soul.isEmpty) return const SizedBox.shrink();
    final integration = _sc('soul_character_integration_score');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.self_improvement_rounded, title: l.chSoulTitle, color: KColors.purple),
      Container(padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [KColors.purple.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
          borderRadius: BorderRadius.circular(18), border: Border.all(color: KColors.purple.withOpacity(0.3))),
        child: Column(children: [
          Text('🕉️ $soul', style: const TextStyle(color: AppColors.ivory, fontSize: 20, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
          if (_str('atmakaraka_soul_character_archetype').isNotEmpty) ...[const SizedBox(height: 8),
            Text(_cap(_str('atmakaraka_soul_character_archetype')), style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.5), textAlign: TextAlign.center)],
        ])),
      const SizedBox(height: 10),
      _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(l.chSoulIntegration, style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w800))),
          Text('${integration.toStringAsFixed(0)}%', style: TextStyle(color: _col(integration), fontSize: 18, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 8),
        ClipRRect(borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(value: (integration / 100).clamp(0, 1), minHeight: 7, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(_col(integration)))),
        if (_str('soul_character_integration_strategy').isNotEmpty) ...[const SizedBox(height: 10),
          Text(_cap(_str('soul_character_integration_strategy')), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))],
      ])),
      if (_str('amatyakaraka_supporting_character_theme').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 10),
        child: _iconTile('💼', l.chAmatyakarakaTheme, _cap(_str('amatyakaraka_supporting_character_theme')))),
      _advanced(l, [
        '${l.chAtmakarakaDignity}: ${_str('atmakaraka_dignity')} · ${_sc('atmakaraka_degrees').toStringAsFixed(1)}°',
        '${l.chAtmakarakaHouse}: ${_sc('atmakaraka_house').toStringAsFixed(0)} · Nakshatra: ${_str('atmakaraka_nakshatra')} (${_str('atmakaraka_nakshatra_deity')})',
        'D9/D12/D30/D60: ${_str('atmakaraka_d9_dignity')} / ${_str('atmakaraka_d12_dignity')} / ${_str('atmakaraka_d30_dignity')} / ${_str('atmakaraka_d60_dignity')}',
      ]),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  3 — SURFACE PERSONALITY & CONSTITUTION
  // ══════════════════════════════════════════════════════════════════
  Widget _surfacePersonality(AppLocalizations l) {
    if (_str('lagna_sign_name').isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.face_rounded, title: l.chSurfaceTitle, color: KColors.blue),
      Row(children: [
        Expanded(child: _iconTile('🔯', l.chLagnaSign, _str('lagna_sign_name'))),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('🧬', l.chConstitution, _titleCase(_str('primary_character_constitution')))),
      ]),
      const SizedBox(height: 10),
      if (_str('surface_personality_signature').isNotEmpty)
        _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l.chSurfaceSignature, style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(_cap(_str('surface_personality_signature')), style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.45)),
          if (_str('physical_constitution_signature').isNotEmpty) ...[const SizedBox(height: 10),
            Text(l.chPhysicalConstitution, style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(_cap(_str('physical_constitution_signature')), style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.45))],
        ])),
      _advanced(l, [
        'Nakshatra: ${_str('lagna_nakshatra')} (${_str('lagna_nakshatra_deity')})',
        '${l.chLagnaLord}: ${KundliNames.planet(_str('lagna_lord_planet'), Localizations.localeOf(context))} · ${l.crHouseLabel} ${_sc('lagna_lord_house').toStringAsFixed(0)} · ${_str('lagna_lord_dignity')}',
        if (_list('lagna_occupants').isNotEmpty) '${l.chLagnaOccupants}: ${_list('lagna_occupants').map((e) => KundliNames.planet(e.toString(), Localizations.localeOf(context))).join(', ')}',
      ]),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  4 — MIND, EMOTIONS & EGO (Moon + Sun)
  // ══════════════════════════════════════════════════════════════════
  Widget _mindEmotionsEgo(AppLocalizations l) {
    final moods = _list('mood_patterns').map((e) => e.toString())
        .where((s) => !s.toLowerCase().contains('standard mood-baseline')).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.mood_rounded, title: l.chMindEmotionsTitle, color: KColors.blue),
      if (_str('emotional_nature_signature').isNotEmpty) styleRow(l.chEmotionalNature, _str('emotional_nature_signature')),
      Row(children: [
        Expanded(child: _statTile(l.chMentalStability, _sc('mental_stability_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.chSelfConfidence, _sc('healthy_self_confidence_score'))),
      ]),
      const SizedBox(height: 10),
      if (_str('ego_nature_signature').isNotEmpty) styleRow(l.chEgoNature, _str('ego_nature_signature')),
      Row(children: [
        Expanded(child: _statTile(l.chAuthorityRelationship, _sc('authority_relationship_score'))),
        const SizedBox(width: 10),
        Expanded(child: _riskTile(l.chPrideTendency, _sc('pride_tendency_score'))),
      ]),
      if (moods.isNotEmpty) ...[const SizedBox(height: 10), _chipBlock('🌤️', l.chMoodPatterns, moods, KColors.purple)],
      _advanced(l, [
        if (_bool('kemadruma_yoga_present')) l.chKemadrumaPresent,
        if (_str('sunapha_anapha_durudhara_yoga_signature').isNotEmpty) _str('sunapha_anapha_durudhara_yoga_signature'),
        '${l.chFatherImprint}: ${_sc('father_imprint_quality_score').toStringAsFixed(0)}',
      ]),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  5 — COMMUNICATION & INTELLECT STYLE (Mercury)
  // ══════════════════════════════════════════════════════════════════
  Widget _communicationStyle(AppLocalizations l) {
    if (_str('intellect_style_signature').isEmpty && _str('communication_style').isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.record_voice_over_rounded, title: l.chCommunicationTitle, color: KColors.green),
      Row(children: [
        Expanded(child: _iconTile('🧠', l.chIntellectStyle, _titleCase(_str('intellect_style_signature')))),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('🗣️', l.chCommStyle, _titleCase(_str('communication_style')))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _iconTile('⚖️', l.chDecisionStyle, _titleCase(_str('decision_making_signature')))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.chDiscrimination, _sc('discrimination_capacity_score'))),
      ]),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  6 — PUBLIC PERSONA VS TRUE SELF (Arudha Lagna)
  // ══════════════════════════════════════════════════════════════════
  Widget _publicPersona(AppLocalizations l) {
    if (_str('public_persona_signature').isEmpty) return const SizedBox.shrink();
    final gap = _sc('persona_authenticity_gap_score');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.theater_comedy_rounded, title: l.chPersonaTitle, color: KColors.orange),
      _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(_cap(_str('public_persona_signature')), style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.45)),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: Text(l.chAuthenticityGap, style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w700))),
          Text('${gap.toStringAsFixed(0)}%', style: TextStyle(color: _riskColor(gap), fontSize: 15, fontWeight: FontWeight.w800)),
        ]),
        if (_str('persona_vs_true_self_signature').isNotEmpty) ...[const SizedBox(height: 4),
          Text(_titleCase(_str('persona_vs_true_self_signature')), style: TextStyle(color: _riskColor(gap), fontSize: 11.5, fontWeight: FontWeight.w600))],
      ])),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  7 — GUNA & DOSHA PROFILE
  // ══════════════════════════════════════════════════════════════════
  Widget _gunaDosha(AppLocalizations l) {
    final sattva = _sc('sattva_score'), rajas = _sc('rajas_score'), tamas = _sc('tamas_score');
    if (sattva == 0 && rajas == 0 && tamas == 0) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.spa_rounded, title: l.chGunaTitle, subtitle: l.chGunaSubtitle, color: KColors.purple),
      _card(child: Column(children: [
        _gunaBar(l.chSattva, sattva, KColors.green),
        _gunaBar(l.chRajas, rajas, AppColors.gold),
        _gunaBar(l.chTamas, tamas, KColors.red),
        if (_str('dominant_guna').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6),
          child: _pill('${l.chDominantGuna}: ${_titleCase(_str('dominant_guna'))}', KColors.purple)),
      ])),
      const SizedBox(height: 10),
      _card(child: Column(children: [
        _gunaBar(l.chPitta, _sc('pitta_score'), KColors.orange),
        _gunaBar(l.chKapha, _sc('kapha_score'), KColors.blue),
        _gunaBar(l.chVata, _sc('vata_score'), KColors.yellow),
        if (_str('dominant_dosha').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6),
          child: _pill('${l.chDominantDosha}: ${_titleCase(_str('dominant_dosha'))}', KColors.blue)),
      ])),
      if (_str('dosha_guna_character_signature').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 10),
        child: Text(_cap(_str('dosha_guna_character_signature')), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))),
      _advanced(l, [
        '${l.chRahuRestlessness}: ${_sc('rahu_restlessness_score').toStringAsFixed(0)}',
        '${l.chKetuDetachment}: ${_sc('ketu_detachment_score').toStringAsFixed(0)}',
      ]),
    ]);
  }

  Widget _gunaBar(String label, double v, Color c) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [
    SizedBox(width: 62, child: Text(label, style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w700))),
    Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3),
      child: LinearProgressIndicator(value: (v / 100).clamp(0, 1), minHeight: 6, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
    const SizedBox(width: 8),
    SizedBox(width: 34, child: Text(v.toStringAsFixed(0), textAlign: TextAlign.right, style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w800))),
  ]));

  // ══════════════════════════════════════════════════════════════════
  //  8 — CHARACTER YOGAS
  // ══════════════════════════════════════════════════════════════════
  Widget _yogas(AppLocalizations l) {
    final gifts = _list('character_gift_yogas').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final tests = _list('character_test_yogas').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    if (gifts.isEmpty && tests.isEmpty && !_bool('raja_yoga_present')) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.auto_awesome_rounded, title: l.chYogasTitle, color: AppColors.gold),
      if (_bool('raja_yoga_present')) Padding(padding: const EdgeInsets.only(bottom: 10),
        child: _statTile(l.chRajaYogaStrength, _sc('raja_yoga_strength_score'))),
      if (gifts.isNotEmpty) ...[
        _catLabel('🎁', l.chGiftYogas, KColors.green),
        ...gifts.map((m) => _yogaRow(m['name']?.toString() ?? '', (m['score'] is num ? m['score'] as num : null)?.toDouble() ?? 0, KColors.green)),
        const SizedBox(height: 6),
      ],
      if (tests.isNotEmpty) ...[
        _catLabel('⚡', l.chTestYogas, KColors.orange),
        ...tests.map((m) => _yogaRow(m['name']?.toString() ?? '', (m['score'] is num ? m['score'] as num : null)?.toDouble() ?? 0, KColors.orange)),
      ],
      if (_str('classical_character_signature').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6),
        child: Text(_cap(_str('classical_character_signature')), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))),
    ]);
  }

  Widget _yogaRow(String name, double score, Color c) => Container(
    margin: const EdgeInsets.only(bottom: 7), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
    decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(12), border: Border.all(color: c.withOpacity(0.2))),
    child: Row(children: [
      Expanded(child: Text(name, style: const TextStyle(color: AppColors.ivory, fontSize: 12, fontWeight: FontWeight.w700))),
      Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: c, fontSize: 12.5, fontWeight: FontWeight.w800)),
    ]),
  );

  // ══════════════════════════════════════════════════════════════════
  //  9 — STRENGTHS & TALENTS
  // ══════════════════════════════════════════════════════════════════
  Widget _strengths(AppLocalizations l) {
    final top = _list('top_character_strengths').map((e) => e.toString()).toSet().toList();
    final virtues = _list('signature_virtues').map((e) => e.toString()).toList();
    final talents = _list('natural_talents').map((e) => e.toString()).toList();
    final soft = _list('soft_skill_strengths').map((e) => e.toString()).toList();
    final hidden = _list('hidden_strengths_to_develop').map((e) => e.toString()).toList();
    if (top.isEmpty && virtues.isEmpty && talents.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.star_rounded, title: l.chStrengthsTitle, color: KColors.green),
      if (top.isNotEmpty) ...top.take(5).map((s) => Container(
        margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: KColors.green.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: KColors.green.withOpacity(0.2))),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.check_circle_rounded, size: 17, color: KColors.green), const SizedBox(width: 10),
          Expanded(child: Text(_cap(s), style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, height: 1.4))),
        ]),
      )),
      if (virtues.isNotEmpty) _chipBlock('💎', l.chSignatureVirtues, virtues, KColors.gold),
      if (talents.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('🎨', l.chNaturalTalents, talents, KColors.blue)],
      if (soft.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('🤝', l.chSoftSkills, soft, KColors.purple)],
      if (hidden.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('🌱', l.chHiddenStrengths, hidden, KColors.green)],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  10 — SHADOW & GROWTH AREAS
  // ══════════════════════════════════════════════════════════════════
  Widget _shadow(AppLocalizations l) {
    final shadows = _list('primary_shadow_patterns').map((e) => e.toString()).toList();
    final blindSpots = _list('character_blind_spots').map((e) => e.toString()).toList();
    final wounds = _list('emotional_wounds_signature').map((e) => e.toString())
        .where((s) => !s.toLowerCase().contains('standard emotional-residue')).toList();
    final priorities = _list('shadow_work_priorities').map((e) => e.toString()).toList();
    final moralTests = _list('moral_tests_signature').map((e) => e.toString()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.nightlight_round, title: l.chShadowTitle, subtitle: l.chShadowSubtitle, color: KColors.orange),
      if (shadows.isNotEmpty) _chipBlock('🌗', l.chShadowPatterns, shadows, KColors.orange),
      if (blindSpots.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('👀', l.chBlindSpots, blindSpots, KColors.red)],
      if (wounds.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('💔', l.chEmotionalWounds, wounds, KColors.blue)],
      if (priorities.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('🎯', l.chShadowWorkPriorities, priorities, KColors.purple)],
      if (moralTests.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('⚖️', l.chMoralTests, moralTests, KColors.gold)],
      if (_str('d30_primary_shadow_chart_signature').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6),
        child: Text(_cap(_str('d30_primary_shadow_chart_signature')), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  11 — RELATIONSHIPS & SOCIAL STYLE
  // ══════════════════════════════════════════════════════════════════
  Widget _relationships(AppLocalizations l) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.groups_rounded, title: l.chRelationshipsTitle, color: KColors.blue),
      Row(children: [
        Expanded(child: _statTile(l.chWarmth, _sc('interpersonal_warmth_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.chEmpathy, _sc('empathy_capacity_score'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.chLoyalty, _sc('loyalty_capacity_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.chBoundaries, _sc('boundary_setting_capacity_score'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.chSocialConfidence, _sc('social_confidence_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.chTrustGiving, _sc('trust_giving_baseline_score'))),
      ]),
      const SizedBox(height: 10),
      Wrap(spacing: 8, runSpacing: 8, children: [
        if (_str('conflict_engagement_style').isNotEmpty) _pill('${l.chConflictStyle}: ${_titleCase(_str('conflict_engagement_style'))}', KColors.orange),
        if (_str('social_energy_orientation').isNotEmpty) _pill(_titleCase(_str('social_energy_orientation')), KColors.blue),
        if (_str('group_vs_one_on_one_preference').isNotEmpty) _pill(_titleCase(_str('group_vs_one_on_one_preference')), KColors.purple),
        if (_str('leadership_vs_followership_natural_mode').isNotEmpty) _pill(_titleCase(_str('leadership_vs_followership_natural_mode')), KColors.gold),
      ]),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  12 — ETHICS & MORAL COMPASS
  // ══════════════════════════════════════════════════════════════════
  Widget _ethics(AppLocalizations l) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.balance_rounded, title: l.chEthicsTitle, color: KColors.gold),
      Row(children: [
        Expanded(child: _statTile(l.chDharmaOrientation, _sc('dharma_orientation_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.chTruthfulness, _sc('truthfulness_baseline_score'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.chCompassion, _sc('compassion_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.chGenerosity, _sc('generosity_score'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.chEthicalConsistency, _sc('ethical_consistency_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.chIntegrityPressure, _sc('integrity_under_pressure_score'))),
      ]),
      const SizedBox(height: 10),
      _statTile(l.chJusticeFairness, _sc('justice_fairness_score')),
      if (_str('ethical_blind_spot_signature').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 10),
        child: Text(_cap(_str('ethical_blind_spot_signature')), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))),
      if (_str('moral_development_trajectory').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8),
        child: _pill('${l.chMoralTrajectory}: ${_titleCase(_str('moral_development_trajectory'))}', KColors.gold)),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  13 — EMOTIONAL INTELLIGENCE
  // ══════════════════════════════════════════════════════════════════
  Widget _emotionalIntel(AppLocalizations l) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.favorite_rounded, title: l.chEiTitle, color: KColors.purple),
      Row(children: [
        Expanded(child: _statTile(l.chEiSelfAwareness, _sc('self_awareness_ei_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.chEiSelfRegulation, _sc('self_regulation_score'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.chEiEmpathy, _sc('empathy_ei_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.chEiSocialSkills, _sc('social_skills_score'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.chMotivation, _sc('motivation_internal_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.chVulnerabilityComfort, _sc('vulnerability_comfort_score'))),
      ]),
      if (_str('overall_ei_signature').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 10),
        child: _pill(_titleCase(_str('overall_ei_signature')), KColors.purple)),
      _advanced(l, [
        '${l.chEmotionalExpression}: ${_sc('emotional_expression_comfort_score').toStringAsFixed(0)}',
        '${l.chEmotionalReceptivity}: ${_sc('emotional_receptivity_score').toStringAsFixed(0)}',
      ]),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  14 — VERIFIED ACROSS CHARTS (D9/D12/D30/D60)
  // ══════════════════════════════════════════════════════════════════
  Widget _verification(AppLocalizations l) {
    final d9 = _map('d9_character_validation');
    final d12 = _map('d12_character_validation');
    final d30 = _map('d30_shadow_validation');
    final d60 = _map('d60_character_validation');
    if (d9.isEmpty && d12.isEmpty && d30.isEmpty && d60.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.verified_rounded, title: l.chVerificationTitle, color: KColors.green),
      if (d9.isNotEmpty) _chartCard(l, l.chD9Label, (d9['d9_dharma_character_alignment_score'] is num ? d9['d9_dharma_character_alignment_score'] as num : null)?.toDouble() ?? 0,
        d9['d9_character_notes']?.toString() ?? '', ['${l.chLagnaLord}: ${d9['d9_lagna_lord_dignity']}', '${l.chAtmakarakaDignity}: ${d9['d9_atmakaraka_dignity']}']),
      if (d12.isNotEmpty) _chartCard(l, l.chD12Label, (d12['paternal_character_inheritance_score'] is num ? d12['paternal_character_inheritance_score'] as num : null)?.toDouble() ?? 0,
        d12['d12_primary_ancestral_signature']?.toString() ?? '', [
          'Sun: ${d12['d12_sun_dignity']} · Moon: ${d12['d12_moon_dignity']} · AK: ${d12['d12_atmakaraka_dignity']}',
          '${l.chMaternalInheritance}: ${d12['maternal_character_inheritance_score']} · ${l.chAncestralKarmaWeight}: ${d12['ancestral_karma_weight_score']}',
        ]),
      if (d30.isNotEmpty) _chartCard(l, l.chD30Label, 100 - ((d30['misfortune_pattern_count'] is num ? d30['misfortune_pattern_count'] as num : null)?.toDouble() ?? 0) * 20,
        d30['d30_primary_shadow_signature']?.toString() ?? '', [
          '${l.chD30Standing}: ${_titleCase(d30['d30_overall_shadow_standing']?.toString() ?? '')}',
          d30['hidden_adversities_signature']?.toString() ?? '',
        ]),
      if (d60.isNotEmpty) _chartCard(l, l.chD60Label, (d60['d60_past_life_personality_capital_score'] is num ? d60['d60_past_life_personality_capital_score'] as num : null)?.toDouble() ?? 0,
        d60['d60_past_life_character_signature']?.toString() ?? '', []),
    ]);
  }

  Widget _chartCard(AppLocalizations l, String title, double score, String explain, List<String> tech) {
    final col = _col(score);
    final status = score >= 60 ? l.crStatusStrongSupport : score >= 40 ? l.crStatusModerateSupport : l.crStatusNeedsImprovement;
    return Container(
      margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: col.withOpacity(0.06), borderRadius: BorderRadius.circular(16), border: Border.all(color: col.withOpacity(0.22))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(title, style: const TextStyle(color: AppColors.ivory, fontSize: 13.5, fontWeight: FontWeight.w800))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(color: col.withOpacity(0.16), borderRadius: BorderRadius.circular(8)),
            child: Text(status, style: TextStyle(color: col, fontSize: 10, fontWeight: FontWeight.w800))),
        ]),
        if (explain.isNotEmpty) ...[const SizedBox(height: 8),
          Text(_cap(explain), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))],
        _advanced(l, tech),
      ]),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  //  15 — CHARACTER TIMELINE
  // ══════════════════════════════════════════════════════════════════
  Widget _timeline(AppLocalizations l) {
    final formation = _list('character_formation_windows').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final maturation = _list('character_maturation_windows').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final legacy = _list('character_legacy_windows').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    if (formation.isEmpty && maturation.isEmpty && legacy.isEmpty && _str('current_character_phase_signature').isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.timeline_rounded, title: l.chTimelineTitle, color: AppColors.gold),
      if (_str('current_character_phase_signature').isNotEmpty)
        _card(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('📍', style: TextStyle(fontSize: 15)), const SizedBox(width: 9),
          Expanded(child: Text(_cap(_str('current_character_phase_signature')), style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.45))),
        ])),
      const SizedBox(height: 10),
      if (formation.isNotEmpty) _timelineCard(l, l.chFormationWindow, formation.first, KColors.blue),
      if (maturation.isNotEmpty) _timelineCard(l, l.chMaturationWindow, maturation.first, KColors.purple),
      if (legacy.isNotEmpty) _timelineCard(l, l.chLegacyWindow, legacy.first, KColors.gold),
      if (_str('peak_character_maturation_age_range').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 4),
        child: _pill('${l.chPeakMaturationAge}: ${_str('peak_character_maturation_age_range')}', KColors.green)),
    ]);
  }

  Widget _timelineCard(AppLocalizations l, String title, Map<String, dynamic> m, Color col) {
    final window = m['window']?.toString() ?? '';
    final ageRange = m['age_range']?.toString() ?? '';
    final dasha = m['dasha']?.toString() ?? '';
    final note = m['note']?.toString() ?? '';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(14, 13, 13, 13),
      decoration: BoxDecoration(color: col.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: col.withOpacity(0.28))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: col, shape: BoxShape.circle, border: Border.all(color: col.withOpacity(0.35), width: 3))),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: TextStyle(color: col, fontSize: 12.5, fontWeight: FontWeight.w800))),
          if (ageRange.isNotEmpty) Text(l.chAgeRangeLabel(ageRange), style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w600)),
        ]),
        if (window.isNotEmpty) ...[const SizedBox(height: 4), Text(window, style: const TextStyle(color: AppColors.smoke, fontSize: 10.5))],
        if (dasha.isNotEmpty) ...[const SizedBox(height: 4),
          Text('🪐 ${l.crViewDasha}: $dasha', style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700))],
        if (note.isNotEmpty) ...[const SizedBox(height: 6),
          Text(_cap(note), style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.4))],
      ]),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  //  16 — IMPROVEMENT PLAN (remedies)
  // ══════════════════════════════════════════════════════════════════
  Widget _improvementPlan(AppLocalizations l) {
    final practical = _remedyItems('practical_solutions');
    final planetary = _remedyItems('astrological_remedies');
    if (practical.isEmpty && planetary.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.healing_rounded, title: l.chImprovementTitle, color: KColors.green),
      if (practical.isNotEmpty) ...[
        _catLabel('🎯', l.crCatPractical, KColors.blue),
        ...practical.map((m) => _remedyCard(_titleCase(m[0]), m[1], KColors.blue)),
      ],
      if (planetary.isNotEmpty) ...[
        const SizedBox(height: 6),
        _catLabel('🕉️', l.crCatPlanetary, KColors.purple),
        ...planetary.map((m) => _remedyCard(_titleCase(m[0]), m[1], KColors.purple)),
      ],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  17 — YOUR CHARACTER ROADMAP
  // ══════════════════════════════════════════════════════════════════
  Widget _roadmap(AppLocalizations l) {
    final theme = _map('core_character_theme');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.rocket_launch_rounded, title: l.chRoadmapTitle, color: KColors.gold),
      if (theme.isNotEmpty) Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [KColors.gold.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
          borderRadius: BorderRadius.circular(18), border: Border.all(color: KColors.gold.withOpacity(0.3))),
        child: Column(children: [
          Text(theme['is_gift'] == true ? '🎁' : '🔑', style: const TextStyle(fontSize: 30)),
          const SizedBox(height: 8),
          Text(theme['primary_theme']?.toString() ?? '', style: const TextStyle(color: AppColors.ivory, fontSize: 18, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
          if (theme['explanation'] != null) ...[const SizedBox(height: 8),
            Text(theme['explanation'].toString(), style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.5), textAlign: TextAlign.center)],
          if (theme['action_direction'] != null) ...[const SizedBox(height: 8),
            Text('✓ ${theme['action_direction']}', style: const TextStyle(color: KColors.green, fontSize: 11.5, fontWeight: FontWeight.w700), textAlign: TextAlign.center)],
        ])),
      const SizedBox(height: 10),
      if (_str('authentic_self_expression_recommendation').isNotEmpty)
        _iconTile('✨', l.chAuthenticExpression, _cap(_str('authentic_self_expression_recommendation'))),
      const SizedBox(height: 10),
      _statTile(l.chRealizationPotential, _sc('character_realization_potential_score')),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  18 — PREDICTION RELIABILITY
  // ══════════════════════════════════════════════════════════════════
  Widget _reliability(AppLocalizations l) {
    final raw = _sc('confidence_score');
    final pct = raw <= 1 ? raw * 100 : raw;
    final band = pct >= 75 ? l.crReliabilityHigh : pct >= 60 ? l.crReliabilityGood : l.crReliabilityModerate;
    final b = _map('confidence_breakdown');
    double layer(String k) { final v = b[k]; return v is Map ? ((v['strength'] is num ? v['strength'] as num : null)?.toDouble() ?? 0) : 0; }
    final layers = <List<Object>>[
      [l.chLayerAtmakaraka, layer('atmakaraka')],
      [l.chLayerD1, layer('d1_natal')],
      [l.chLayerD9, layer('d9_dharma')],
      [l.chLayerD30, layer('d30_shadow')],
      [l.chLayerLagnaMoon, layer('lagna_moon')],
      [l.chLayerArudha, layer('arudha_lagna')],
    ];
    final plain = _str('plain_statement');
    final disclaimer = _str('character_disclaimer').isNotEmpty ? _str('character_disclaimer') : '';
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.verified_user_rounded, title: l.crReliability, color: KColors.blue),
      _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          KStars(filled: kStars(pct), size: 20, color: AppColors.gold), const Spacer(),
          Text('${pct.toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.gold, fontSize: 22, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 4),
        Text(band, style: const TextStyle(color: KColors.green, fontSize: 13, fontWeight: FontWeight.w800)),
        if (plain.isNotEmpty) ...[const SizedBox(height: 10),
          Text(_cap(plain), style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.5))],
        _advanced(l, null, customTitle: l.crChartLayers, customChild: Column(children: layers.where((la) => (la[1] is num ? (la[1] as num).toDouble() : 0.0) > 0).map((la) {
          final v = la[1] as double;
          return Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [
            SizedBox(width: 130, child: Text(la[0] as String, style: const TextStyle(color: AppColors.ivory, fontSize: 11.5))),
            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(value: (v / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(_col(v))))),
            const SizedBox(width: 8),
            Text('${v.toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w700)),
          ]));
        }).toList())),
      ])),
      if (disclaimer.isNotEmpty) ...[const SizedBox(height: 10),
        Text(disclaimer, style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, height: 1.4, fontStyle: FontStyle.italic))],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  19 — DISCUSS WITH AI
  // ══════════════════════════════════════════════════════════════════
  Widget _discussAi(AppLocalizations l) {
    final topics = <String>[l.chTopicStrengths, l.chTopicShadow, l.chTopicSoul, l.chTopicRelationships, l.chTopicEthics, l.chTopicGuna, l.chTopicGrowth, l.chTopicTiming];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.forum_rounded, title: l.crDiscussAi, color: AppColors.gold),
      ReportPdfButton(path: 'report/character/${widget.chartId}', filename: 'report-${widget.chartName}'),
      const SizedBox(height: 10),
      ReportAiChatCta(domainKey: 'life_path_luck', label: 'Life Path & Luck', emoji: '🌟'),
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
        Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.ivory, fontSize: 11, fontWeight: FontWeight.w700)),
        Text(AppLocalizations.of(context)!.openLink, style: const TextStyle(color: AppColors.smoke, fontSize: 7, letterSpacing: 1)),
      ])))));

  void _copyTopic(String topic) {
    final q = '$topic — based on my Vedic character analysis report for ${widget.chartName}.\n\n${_buildPrompt(_data!)}';
    Clipboard.setData(ClipboardData(text: q));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.crTopicCopied), duration: const Duration(seconds: 2)));
  }

  // ══════════════════════════════════════════════════════════════════
  //  shared widgets / helpers
  // ══════════════════════════════════════════════════════════════════
  Widget _card({required Widget child}) => Container(padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: AppColors.card.withOpacity(0.4), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white.withOpacity(0.06))), child: child);

  Widget _pill(String t, Color c) => Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: c.withOpacity(0.25))),
    child: Text(t, style: TextStyle(color: c, fontSize: 10.5, fontWeight: FontWeight.w600)));

  Widget _chipBlock(String emoji, String title, List<String> items, Color c) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(padding: const EdgeInsets.only(bottom: 4), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Text(emoji, style: const TextStyle(fontSize: 13)), const SizedBox(width: 6),
        Text(title, style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w800))]),
      const SizedBox(height: 7),
      Wrap(spacing: 6, runSpacing: 6, children: items.take(8).map((e) => _pill(_cap(e), c)).toList()),
    ]));
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

  Widget styleRow(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(padding: const EdgeInsets.only(bottom: 8), child: Container(padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.card.withOpacity(0.4), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.06))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(_cap(value), style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.4)),
      ])));
  }

  Widget _iconTile(String emoji, String label, String value, {Color? color}) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: AppColors.card.withOpacity(0.5), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.06))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(emoji, style: const TextStyle(fontSize: 17)), const SizedBox(height: 6),
      Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontWeight: FontWeight.w600)),
      Text(value, style: TextStyle(color: color ?? AppColors.ivory, fontSize: 12.5, fontWeight: FontWeight.w800), maxLines: 3, overflow: TextOverflow.ellipsis),
    ]),
  );

  Widget _statTile(String label, double score) {
    final c = _col(score);
    return Container(padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: c.withOpacity(0.2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: c, fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        ClipRRect(borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(value: (score / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c))),
      ]));
  }

  Widget _riskTile(String label, double score) {
    final c = _riskColor(score);
    return Container(padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: c.withOpacity(0.2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: c, fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        ClipRRect(borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(value: (score / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c))),
      ]));
  }

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

  Color _col(double s) {
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
  String _cap(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
  String _titleCase(String s) => s.replaceAll('_', ' ').replaceAll('-', ' ').split(' ')
    .where((w) => w.isNotEmpty).map((w) => '${w[0].toUpperCase()}${w.substring(1)}').join(' ');

  // ── AI prompt / launch (unchanged behaviour) ──
  String _buildPrompt(Map<String, dynamic> d) {
    final name = widget.chartName;
    final overall = d['overall_character_strength_score'] ?? '?';
    final verdict = d['overall_character_verdict'] ?? '';
    final constitution = d['primary_character_constitution'] ?? '';
    final jsonStr = const JsonEncoder.withIndent('  ').convert(d);
    return '''You are a Vedic character and self-development advisor. Analyze this character analysis report for $name and provide actionable insights.

Key highlights:
- Overall character strength: $overall/100
- Character verdict: $verdict
- Constitution: $constitution

Full report data (JSON):
$jsonStr

Please explain the key findings in simple language, celebrate the strengths, and suggest practical next steps for shadow-work and growth.''';
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.copiedOpening(ai)), duration: const Duration(seconds: 3)));
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
