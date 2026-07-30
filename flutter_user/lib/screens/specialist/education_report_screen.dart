import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../../utils/kundli_names.dart';
import '../kundli/widgets/kundli_ui.dart';

/// Education & Learning report — premium AI education-coach redesign.
///
/// Presentation only. Loads the `education` specialist
/// (`runSpecialist('education')`) unchanged and re-presents it; every score,
/// Jaimini karaka, house, divisional, timing, remedy and confidence value
/// comes straight from the engine.
class EducationReportScreen extends StatefulWidget {
  final String chartId, chartName;
  final Map<String, dynamic>? preloadedData;
  const EducationReportScreen({super.key, required this.chartId, required this.chartName, this.preloadedData});
  @override
  State<EducationReportScreen> createState() => _EducationState();
}

class _EducationState extends State<EducationReportScreen> {
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
      final resp = await _api.runSpecialist('education', widget.chartId);
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

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.ivory), onPressed: () => Navigator.pop(context)),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(widget.chartName, style: const TextStyle(color: AppColors.ivory, fontSize: 15, fontWeight: FontWeight.w700)),
          Text(l.edSubtitle, style: const TextStyle(color: AppColors.gold, fontSize: 10)),
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
      _snapshot(l),           // 1
      gap, _learningStyle(l),    // 2
      gap, _foundation(l),       // 3
      gap, _studyPlanets(l),     // 4
      gap, _yogas(l),            // 5
      gap, _verification(l),     // 6
      gap, _subjects(l),         // 7
      gap, _degrees(l),          // 8
      gap, _timeline(l),         // 9
      gap, _preferences(l),      // 10
      gap, _strengthsChallenges(l), // 11
      gap, _careerLink(l),       // 12
      gap, _improvementPlan(l),  // 13
      gap, _reliability(l),      // 14
      gap, _discussAi(l),        // 15
    ];
  }

  Widget _breadcrumb(AppLocalizations l) => Row(children: [
    Text(l.crCrumbHome, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Text(l.crCrumbReports, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Flexible(child: Text(l.edTitle, style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
  ]);

  // ══════════════════════════════════════════════════════════════════
  //  1 — EDUCATION SNAPSHOT
  // ══════════════════════════════════════════════════════════════════
  Widget _snapshot(AppLocalizations l) {
    final overall = _sc('overall_education_strength_score');
    final col = _col(overall);
    final theme = _map('core_education_theme');
    final summary = _str('education_verdict_explanation').isNotEmpty ? _str('education_verdict_explanation') : (theme['explanation']?.toString() ?? '');
    final gauges = <List<Object>>[
      [l.edOverallStrength, overall],
      [l.edAcademicSuccess, _sc('academic_success_potential_score')],
      [l.edLearningCapacity, _sc('learning_capacity_score')],
      [l.edIntellect, _sc('intellectual_strength_score')],
      [l.edMemory, _sc('memory_retention_score')],
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [col.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
        borderRadius: BorderRadius.circular(22), border: Border.all(color: col.withOpacity(0.3)),
      ),
      child: Column(children: [
        Text(l.edSnapshotHeader.toUpperCase(), style: const TextStyle(color: AppColors.smoke, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
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
        Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(color: col.withOpacity(0.16), borderRadius: BorderRadius.circular(20)),
          child: Text(_statusLabel(overall, l), style: TextStyle(color: col, fontSize: 14, fontWeight: FontWeight.w800))),
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
    if (_data?['saraswati_yoga_present'] == true) out.add(l.edChipSaraswati);
    if (_data?['gaja_kesari_yoga_present'] == true) out.add(l.edChipGajaKesari);
    if (_data?['budha_aditya_yoga_present'] == true) out.add(l.edChipBudhaAditya);
    if (_sc('research_capacity_score') >= 60) out.add(l.edChipResearch);
    if (_sc('scholarship_award_likelihood_score') >= 60) out.add(l.edChipScholarship);
    if (_sc('doctorate_likelihood_score') >= 55) out.add(l.edChipDoctorate);
    if (_sc('foreign_education_likelihood_score') >= 55) out.add(l.edChipForeign);
    out.add(l.edChipLifelong);
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
  //  2 — YOUR LEARNING STYLE + SOUL/SUBJECT DIRECTION
  // ══════════════════════════════════════════════════════════════════
  Widget _learningStyle(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    final archetype = _titleCase(_str('intellectual_archetype'));
    final signature = _titleCase(_str('learning_style_signature'));
    final modality = _str('visual_vs_auditory_vs_kinesthetic');
    final soul = _str('atmakaraka_planet');
    final subject = _str('amatyakaraka_planet');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.psychology_alt_rounded, title: l.edLearningStyleTitle, color: KColors.purple),
      Container(padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [KColors.purple.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
          borderRadius: BorderRadius.circular(18), border: Border.all(color: KColors.purple.withOpacity(0.3))),
        child: Column(children: [
          const Text('🎓', style: TextStyle(fontSize: 32)),
          const SizedBox(height: 8),
          Text(archetype.isNotEmpty ? archetype : signature, style: const TextStyle(color: AppColors.ivory, fontSize: 19, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
          if (signature.isNotEmpty && archetype.isNotEmpty) ...[const SizedBox(height: 4),
            Text(signature, style: const TextStyle(color: AppColors.parchment, fontSize: 11.5), textAlign: TextAlign.center)],
          if (modality.isNotEmpty) ...[const SizedBox(height: 10),
            Wrap(alignment: WrapAlignment.center, spacing: 6, runSpacing: 6,
              children: modality.split('-').where((m) => m.isNotEmpty).take(3).toList().asMap().entries.map((e) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: e.key == 0 ? KColors.green.withOpacity(0.16) : Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(20), border: Border.all(color: e.key == 0 ? KColors.green.withOpacity(0.4) : Colors.white12)),
                child: Text(e.key == 0 ? '★ ${_titleCase(e.value)}' : _titleCase(e.value),
                  style: TextStyle(color: e.key == 0 ? KColors.green : AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w700)))).toList())],
        ])),
      const SizedBox(height: 10),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: _planetCard('🕉️', l.edSoulPlanet, KundliNames.planet(soul, loc), l.edSoulHint, KColors.purple)),
        const SizedBox(width: 10),
        Expanded(child: _planetCard('📖', l.edSubjectPlanet, KundliNames.planet(subject, loc), _cap(_str('amatyakaraka_subject_direction')), KColors.blue)),
      ]),
      _advanced(l, [
        '${l.edTechAtmakaraka}: ${KundliNames.planet(soul, loc)} · ${_sc('atmakaraka_degrees').toStringAsFixed(1)}°',
        '${l.edTechAmatyakaraka}: ${KundliNames.planet(subject, loc)} · ${l.crDignity}: ${_str('amatyakaraka_dignity')}',
        'D9 ${l.crDignity}: ${_str('amatyakaraka_d9_dignity')} · D24 ${l.crDignity}: ${_str('amatyakaraka_d24_dignity')}',
        '${l.edSubjectKarakaStrength}: ${_sc('subject_karaka_strength_score').toStringAsFixed(0)}%',
      ]),
    ]);
  }

  Widget _planetCard(String emoji, String label, String planet, String meaning, Color c) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: c.withOpacity(0.08), borderRadius: BorderRadius.circular(16), border: Border.all(color: c.withOpacity(0.22))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Text(emoji, style: const TextStyle(fontSize: 16)), const SizedBox(width: 6),
        Expanded(child: Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w700)))]),
      const SizedBox(height: 6),
      Text(planet, style: TextStyle(color: c, fontSize: 18, fontWeight: FontWeight.w800)),
      const SizedBox(height: 4),
      Text(meaning, style: const TextStyle(color: AppColors.parchment, fontSize: 11, height: 1.35), maxLines: 4, overflow: TextOverflow.ellipsis),
    ]),
  );

  // ══════════════════════════════════════════════════════════════════
  //  3 — EDUCATION FOUNDATION (4th / 5th / 9th houses)
  // ══════════════════════════════════════════════════════════════════
  Widget _foundation(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.foundation_rounded, title: l.edFoundationTitle, color: KColors.blue),
      Row(children: [
        Expanded(child: _houseCard(l.edHouse4, _str('fourth_house_sign_name'), KundliNames.planet(_str('fourth_lord_planet'), loc), _sc('primary_education_quality_score'), false)),
        const SizedBox(width: 8),
        Expanded(child: _houseCard(l.edHouse5, _str('fifth_house_sign_name'), KundliNames.planet(_str('fifth_lord_planet'), loc), _sc('intelligence_strength_score'), true)),
        const SizedBox(width: 8),
        Expanded(child: _houseCard(l.edHouse9, _str('ninth_house_sign_name'), KundliNames.planet(_str('ninth_lord_planet'), loc), _sc('higher_learning_strength_score'), false)),
      ]),
      _advanced(l, [
        '4L ${l.crDignity}: ${_str('fourth_lord_dignity')} · D24: ${_str('fourth_lord_d24_dignity')}',
        '5L ${l.crDignity}: ${_str('fifth_lord_dignity')} · D24: ${_str('fifth_lord_d24_dignity')}',
        '9L ${l.crDignity}: ${_str('ninth_lord_dignity')} · D24: ${_str('ninth_lord_d24_dignity')}',
        '${l.edPurvaPunya}: ${_cap(_str('purva_punya_signature'))}',
      ]),
    ]);
  }

  Widget _houseCard(String label, String sign, String lord, double score, bool featured) {
    final c = featured ? AppColors.gold : _col(score);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: featured ? LinearGradient(colors: [AppColors.gold.withOpacity(0.16), AppColors.card.withOpacity(0.3)]) : null,
        color: featured ? null : AppColors.card.withOpacity(0.5),
        borderRadius: BorderRadius.circular(14), border: Border.all(color: c.withOpacity(0.3))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text(sign, style: const TextStyle(color: AppColors.ivory, fontSize: 13.5, fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
        Text(lord, style: const TextStyle(color: AppColors.parchment, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 6),
        Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: c, fontSize: 15, fontWeight: FontWeight.w800)),
      ]),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  //  4 — MERCURY & JUPITER (STUDY PLANETS)
  // ══════════════════════════════════════════════════════════════════
  Widget _studyPlanets(AppLocalizations l) {
    final mc = _map('mercury_condition'), jc = _map('jupiter_condition');
    if (mc.isEmpty && jc.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.auto_stories_rounded, title: l.edStudyPlanetsTitle, color: KColors.gold),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: _studyPlanetCard('☿', 'Mercury', mc, _sc('mercury_strength_score'), KColors.blue)),
        const SizedBox(width: 10),
        Expanded(child: _studyPlanetCard('♃', 'Jupiter', jc, _sc('jupiter_strength_score'), AppColors.gold)),
      ]),
    ]);
  }

  Widget _studyPlanetCard(String symbol, String name, Map<String, dynamic> c, double strength, Color col) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(color: col.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: col.withOpacity(0.22))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Text(symbol, style: TextStyle(color: col, fontSize: 16)), const SizedBox(width: 6),
        Text(name, style: TextStyle(color: col, fontSize: 13, fontWeight: FontWeight.w800))]),
      const SizedBox(height: 6),
      Text(c['sign_name']?.toString() ?? '—', style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, fontWeight: FontWeight.w700)),
      Text('${c['house'] ?? '?'}H · ${c['nakshatra'] ?? ''}', style: const TextStyle(color: AppColors.parchment, fontSize: 10.5)),
      const SizedBox(height: 6),
      ClipRRect(borderRadius: BorderRadius.circular(3),
        child: LinearProgressIndicator(value: (strength / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(col))),
      const SizedBox(height: 4),
      Text('${strength.toStringAsFixed(0)}%', style: TextStyle(color: col, fontSize: 11, fontWeight: FontWeight.w700)),
    ]),
  );

  // ══════════════════════════════════════════════════════════════════
  //  5 — EDUCATION YOGAS
  // ══════════════════════════════════════════════════════════════════
  Widget _yogas(AppLocalizations l) {
    final rows = <List<Object>>[
      [l.edYogaBudhaAditya, _data?['budha_aditya_yoga_present'] == true],
      [l.edYogaGajaKesari, _data?['gaja_kesari_yoga_present'] == true],
      [l.edYogaSaraswati, _data?['saraswati_yoga_present'] == true],
    ];
    final anyPresent = rows.any((r) => r[1] as bool);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.auto_awesome_rounded, title: l.edYogasTitle, color: KColors.purple),
      Row(children: rows.map((r) {
        final present = r[1] as bool;
        final c = present ? KColors.green : AppColors.smoke;
        return Expanded(child: Container(margin: const EdgeInsets.symmetric(horizontal: 3), padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: c.withOpacity(present ? 0.10 : 0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: c.withOpacity(present ? 0.35 : 0.15))),
          child: Column(children: [
            Text(r[0] as String, style: TextStyle(color: c, fontSize: 10.5, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(present ? '✓ ${l.edYogaPresent}' : '— ${l.edYogaAbsent}', style: TextStyle(color: c, fontSize: 9.5, fontWeight: FontWeight.w700)),
          ])));
      }).toList()),
      if (!anyPresent) Padding(padding: const EdgeInsets.only(top: 8),
        child: Text(l.edYogaNoneNote, style: const TextStyle(color: AppColors.parchment, fontSize: 11, height: 1.4, fontStyle: FontStyle.italic))),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  6 — VERIFICATION ACROSS CHARTS
  // ══════════════════════════════════════════════════════════════════
  Widget _verification(AppLocalizations l) {
    final d24 = _map('d24_validation'), d4 = _map('d4_validation'), d9 = _map('d9_validation'), d60 = _map('d60_validation');
    final standing = (d24['d24_overall_education_standing']?.toString() ?? '').toLowerCase();
    final d24Score = standing.contains('strong') ? 75.0 : standing.contains('moderate') ? 50.0 : standing.contains('struggl') ? 30.0 : 45.0;
    final d4Score = (d4['d4_formal_education_strength_score'] as num?)?.toDouble() ?? 0;
    final d9Score = (d9['d9_dharmic_learning_score'] as num?)?.toDouble() ?? 0;
    final d60Score = (d60['d60_past_life_learning_capital_score'] as num?)?.toDouble() ?? 0;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.verified_rounded, title: l.edVerificationTitle, color: KColors.green),
      _chartCard(l, l.edD24Learning, d24Score, d24['d24_primary_education_signature']?.toString() ?? '',
        ['D24 4L: ${d24['d24_4_lord_dignity']}', 'D24 5L: ${d24['d24_5_lord_dignity']} · 9L: ${d24['d24_9_lord_dignity']}', 'D24 AmK: ${d24['d24_amatyakaraka_dignity']}']),
      _chartCard(l, l.edD4Formal, d4Score, d4['d4_formal_education_signature']?.toString() ?? '',
        ['D4 4L: ${d4['d4_4_lord_dignity']}', 'D4 Mercury: ${d4['d4_mercury_dignity']} · Jupiter: ${d4['d4_jupiter_dignity']}']),
      _chartCard(l, l.edD9Dharma, d9Score, d9['d9_learning_dharma_signature']?.toString() ?? '',
        ['D9 9L: ${d9['d9_9_lord_dignity']}', 'D9 Jupiter: ${d9['d9_jupiter_dignity']}']),
      _chartCard(l, l.edD60Karma, d60Score, d60['d60_learning_past_life_signature']?.toString() ?? '',
        ['D60 Mercury: ${d60['d60_mercury_dignity']}', 'D60 Jupiter: ${d60['d60_jupiter_dignity']}']),
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
  //  7 — BEST SUBJECTS FOR YOU
  // ══════════════════════════════════════════════════════════════════
  Widget _subjects(AppLocalizations l) {
    final ranking = _list('subject_affinity_ranking').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    if (ranking.isEmpty) return const SizedBox.shrink();
    final lowAffinity = _list('low_affinity_subject_categories').map((e) => _titleCase(e.toString().split(' (').first)).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.menu_book_rounded, title: l.edSubjectsTitle, subtitle: l.edSubjectsSubtitle, color: KColors.blue),
      _card(child: Column(children: ranking.take(12).toList().asMap().entries.map((e) {
        final i = e.key;
        final item = e.value;
        final name = _titleCase(item['subject']?.toString() ?? '');
        final score = (item['score'] as num?)?.toDouble() ?? 0;
        final isTop = i < 3;
        final c = isTop ? AppColors.gold : _col(score);
        return Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(children: [
          SizedBox(width: 22, child: Text('${i + 1}', style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w800))),
          Expanded(child: Text(name, style: TextStyle(color: isTop ? AppColors.ivory : AppColors.parchment, fontSize: 12, fontWeight: isTop ? FontWeight.w700 : FontWeight.w500))),
          SizedBox(width: 60, child: ClipRRect(borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(value: (score / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
          const SizedBox(width: 8),
          SizedBox(width: 30, child: Text(score.toStringAsFixed(0), textAlign: TextAlign.right, style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w700))),
        ]));
      }).toList())),
      if (lowAffinity.isNotEmpty) ...[const SizedBox(height: 10), _chipBlock('🔻', l.edLowAffinity, lowAffinity, AppColors.smoke)],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  8 — DEGREE & LEVEL LIKELIHOOD
  // ══════════════════════════════════════════════════════════════════
  Widget _degrees(AppLocalizations l) {
    final rows = <List<Object>>[
      [l.edDegreeFormal, _sc('formal_degree_likelihood_score')],
      [l.edDegreePostgrad, _sc('postgraduate_likelihood_score')],
      [l.edDegreeDoctorate, _sc('doctorate_likelihood_score')],
      [l.edDegreeForeign, _sc('foreign_education_likelihood_score')],
    ];
    final expected = _titleCase(_str('expected_education_level'));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.school_rounded, title: l.edDegreesTitle, color: AppColors.gold),
      if (expected.isNotEmpty) Padding(padding: const EdgeInsets.only(bottom: 10),
        child: _pill('${l.edExpectedLevel}: $expected', AppColors.gold)),
      Wrap(spacing: 10, runSpacing: 10, children: rows.map((r) {
        final score = r[1] as double;
        final c = _col(score);
        return SizedBox(width: 150, child: Container(padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.card.withOpacity(0.5), borderRadius: BorderRadius.circular(14), border: Border.all(color: c.withOpacity(0.22))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(r[0] as String, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: c, fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            ClipRRect(borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(value: (score / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c))),
          ])));
      }).toList()),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  9 — STUDY TIMELINE
  // ══════════════════════════════════════════════════════════════════
  Widget _timeline(AppLocalizations l) {
    final early = _list('early_schooling_windows').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final higher = _list('higher_education_windows').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final postgrad = _list('postgrad_research_windows').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final phase = _str('current_education_phase_signature');
    final peakAge = _str('peak_learning_age_range');
    if (early.isEmpty && higher.isEmpty && postgrad.isEmpty && phase.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.timeline_rounded, title: l.edTimelineTitle, color: AppColors.gold),
      if (phase.isNotEmpty) Padding(padding: const EdgeInsets.only(bottom: 10),
        child: _card(child: Text(_cap(phase), style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.4)))),
      if (early.isNotEmpty) _timelineCard(l, l.edEarlySchooling, early.first, KColors.blue),
      if (higher.isNotEmpty) _timelineCard(l, l.edHigherEducation, higher.first, KColors.green),
      if (postgrad.isNotEmpty) _timelineCard(l, l.edPostgradResearch, postgrad.first, KColors.purple),
      if (peakAge.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 4),
        child: _pill('${l.edPeakLearningAge}: $peakAge', AppColors.gold)),
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
          if (ageRange.isNotEmpty) Text(ageRange, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w600)),
        ]),
        if (window.isNotEmpty) ...[const SizedBox(height: 4),
          Text(window, style: const TextStyle(color: AppColors.smoke, fontSize: 10.5))],
        if (dasha.isNotEmpty) ...[const SizedBox(height: 4),
          Text('🪐 ${l.crViewDasha}: $dasha', style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700))],
        if (note.isNotEmpty) ...[const SizedBox(height: 6),
          Text(_cap(note), style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.4))],
      ]),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  //  10 — LEARNING PREFERENCES & SUPPORT
  // ══════════════════════════════════════════════════════════════════
  Widget _preferences(AppLocalizations l) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.tune_rounded, title: l.edPreferencesTitle, color: KColors.blue),
      Wrap(spacing: 8, runSpacing: 8, children: [
        if (_str('collaborative_vs_solo_study_preference').isNotEmpty) _pill('${l.edPrefStudyMode}: ${_titleCase(_str('collaborative_vs_solo_study_preference'))}', KColors.blue),
        if (_str('morning_vs_evening_learner').isNotEmpty) _pill('${l.edPrefTiming}: ${_titleCase(_str('morning_vs_evening_learner'))}', KColors.purple),
        if (_str('ideal_study_environment').isNotEmpty) _pill('${l.edPrefEnvironment}: ${_titleCase(_str('ideal_study_environment'))}', KColors.green),
        if (_str('study_location_signature').isNotEmpty) _pill('${l.edPrefLocation}: ${_titleCase(_str('study_location_signature'))}', AppColors.gold),
        if (_str('foreign_study_signature').isNotEmpty) _pill('${l.edPrefForeign}: ${_titleCase(_str('foreign_study_signature'))}', KColors.orange),
      ]),
      const SizedBox(height: 10),
      _card(child: Column(children: [
        _prefRow(l.edGuruRelationship, _sc('teacher_guru_relationship_score')),
        _prefRow(l.edMentorAvailability, _sc('mentor_availability_score')),
        _prefRow(l.edPeerLearning, _sc('peer_learning_score')),
        _prefRow(l.edAuthorityDeference, _sc('authority_deference_score')),
      ])),
    ]);
  }

  Widget _prefRow(String label, double score) {
    final c = _col(score);
    return Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children: [
      Expanded(flex: 3, child: Text(label, style: const TextStyle(color: AppColors.ivory, fontSize: 11.5))),
      const SizedBox(width: 8),
      Expanded(flex: 2, child: ClipRRect(borderRadius: BorderRadius.circular(3),
        child: LinearProgressIndicator(value: (score / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
      const SizedBox(width: 8),
      SizedBox(width: 30, child: Text(score.toStringAsFixed(0), textAlign: TextAlign.right, style: TextStyle(color: c, fontSize: 10.5, fontWeight: FontWeight.w700))),
    ]));
  }

  // ══════════════════════════════════════════════════════════════════
  //  11 — STRENGTHS & CHALLENGES
  // ══════════════════════════════════════════════════════════════════
  Widget _strengthsChallenges(AppLocalizations l) {
    final gifts = _list('cognitive_gifts').map((e) => e.toString()).toList();
    final abilities = _list('natural_learning_abilities').map((e) => e.toString()).toList();
    final hidden = _list('hidden_intellectual_capacities').map((e) => e.toString()).toList();
    final challenges = _list('learning_challenges').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.emoji_objects_rounded, title: l.edStrengthsTitle, color: KColors.green),
      _chipBlock('✨', l.edCognitiveGifts, gifts, KColors.green),
      _chipBlock('🌟', l.edNaturalAbilities, abilities, KColors.blue),
      _chipBlock('🔮', l.edHiddenCapacities, hidden, KColors.purple),
      const SizedBox(height: 6),
      Row(children: [
        Expanded(child: _riskTile(l.edConcentration, _sc('concentration_difficulty_score'))),
        const SizedBox(width: 10),
        Expanded(child: _riskTile(l.edBreakRisk, _sc('education_break_risk_score'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.edDisciplineConsistency, _sc('discipline_consistency_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.edScholarshipLikelihood, _sc('scholarship_award_likelihood_score'))),
      ]),
      if (_str('examination_performance_signature').isNotEmpty) ...[const SizedBox(height: 10),
        Text(_cap(_str('examination_performance_signature')), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))],
      ...challenges.map((c) {
        final sev = c['severity']?.toString().toLowerCase() ?? '';
        final col = sev == 'high' ? KColors.red : sev == 'moderate' ? KColors.orange : KColors.green;
        final desc = c['description']?.toString() ?? '';
        final mitigation = c['mitigation']?.toString() ?? '';
        if (desc.isEmpty) return const SizedBox.shrink();
        return Container(margin: const EdgeInsets.only(top: 8), padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: col.withOpacity(0.05), borderRadius: BorderRadius.circular(13), border: Border.all(color: col.withOpacity(0.18))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_cap(desc), style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.4)),
            if (mitigation.isNotEmpty) ...[const SizedBox(height: 5),
              Text('🛡️ $mitigation', style: const TextStyle(color: AppColors.parchment, fontSize: 11, height: 1.35))],
          ]));
      }),
    ]);
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

  // ══════════════════════════════════════════════════════════════════
  //  12 — EDUCATION → CAREER PATH
  // ══════════════════════════════════════════════════════════════════
  Widget _careerLink(AppLocalizations l) {
    final rows = <List<String>>[
      ['🎯', l.edDirectionRec, _cap(_str('primary_education_direction_recommendation'))],
      ['🧭', l.edIntegrationStrategy, _cap(_str('learning_path_integration_strategy'))],
      ['🔗', l.edCareerLinkage, _cap(_str('education_to_career_linkage_signature'))],
      ['💼', l.edAlignedSubjects, _list('recommended_career_aligned_subjects').map((e) => _titleCase(e.toString().split(' (').first)).join(' · ')],
    ];
    final utility = _sc('degree_utility_for_career_score');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.alt_route_rounded, title: l.edCareerLinkTitle, color: KColors.purple),
      _card(child: Column(children: rows.where((r) => r[2].isNotEmpty).map((r) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(r[0], style: const TextStyle(fontSize: 15)), const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(r[1], style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(r[2], style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.4)),
          ])),
        ]),
      )).toList())),
      if (utility > 0) Padding(padding: const EdgeInsets.only(top: 10),
        child: _pill('${l.edDegreeUtility}: ${utility.toStringAsFixed(0)}%', _col(utility))),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  13 — IMPROVEMENT PLAN (remedies)
  // ══════════════════════════════════════════════════════════════════
  Widget _improvementPlan(AppLocalizations l) {
    final practical = _list('practical_solutions').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final planetary = _list('astrological_remedies').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.self_improvement_rounded, title: l.edImprovementTitle, color: KColors.green),
      if (practical.isNotEmpty) ...[
        _catLabel('🎯', l.crCatPractical, KColors.blue),
        ...practical.map((m) => _remedyCard(_titleCase(m['category']?.toString() ?? ''), m['advice']?.toString() ?? '', KColors.blue)),
      ],
      if (planetary.isNotEmpty) ...[
        const SizedBox(height: 6),
        _catLabel('🕉️', l.crCatPlanetary, KColors.purple),
        ...planetary.map((m) => _remedyCard(m['deity']?.toString() ?? '', m['remedy']?.toString() ?? '', KColors.purple)),
      ],
    ]);
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

  // ══════════════════════════════════════════════════════════════════
  //  14 — RELIABILITY
  // ══════════════════════════════════════════════════════════════════
  Widget _reliability(AppLocalizations l) {
    final raw = _sc('confidence_score');
    final pct = raw <= 1 ? raw * 100 : raw;
    final band = pct >= 75 ? l.crReliabilityHigh : pct >= 60 ? l.crReliabilityGood : l.crReliabilityModerate;
    final b = _map('confidence_breakdown');
    double layer(String k) { final v = b[k]; return v is num ? v.toDouble() * 100 : 0; }
    final layers = <List<Object>>[
      [l.edLayerD1, layer('d1')],
      [l.edLayerD4, layer('d4')],
      [l.edLayerD9, layer('d9')],
      [l.edLayerD24, layer('d24')],
      [l.edLayerD60, layer('d60')],
      [l.edLayerAmk, layer('amk')],
      [l.edLayerMj, layer('mj')],
      [l.edLayerDasha, layer('dasha')],
    ];
    final plain = _str('plain_statement');
    final disclaimer = _str('education_disclaimer').isNotEmpty ? _str('education_disclaimer') : _str('disclaimer');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.verified_user_rounded, title: l.edReliabilityTitle, color: KColors.blue),
      _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          KStars(filled: kStars(pct), size: 20, color: AppColors.gold), const Spacer(),
          Text('${pct.toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.gold, fontSize: 22, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 4),
        Text(band, style: const TextStyle(color: KColors.green, fontSize: 13, fontWeight: FontWeight.w800)),
        if (plain.isNotEmpty) ...[const SizedBox(height: 10),
          Text(_cap(plain), style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.5))],
        _advanced(l, null, customTitle: l.crChartLayers, customChild: Column(children: layers.where((la) => (la[1] as double) > 0).map((la) {
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
  //  15 — DISCUSS WITH AI
  // ══════════════════════════════════════════════════════════════════
  Widget _discussAi(AppLocalizations l) {
    final topics = <String>[l.edTopicSubjects, l.edTopicDegree, l.edTopicAbroad, l.edTopicExam, l.edTopicHabits, l.edTopicCareerLink, l.edTopicTiming, l.edTopicScholarship];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.forum_rounded, title: l.crDiscussAi, color: AppColors.gold),
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
        Text(name, style: const TextStyle(color: AppColors.ivory, fontSize: 11, fontWeight: FontWeight.w700)),
        const Text('OPEN ↗', style: TextStyle(color: AppColors.smoke, fontSize: 7, letterSpacing: 1)),
      ])))));

  void _copyTopic(String topic) {
    final q = '$topic — based on my Vedic education report for ${widget.chartName}.\n\n${_buildPrompt(_data!)}';
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
    return Padding(padding: const EdgeInsets.only(bottom: 10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Text(emoji, style: const TextStyle(fontSize: 13)), const SizedBox(width: 6),
        Text(title, style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w800))]),
      const SizedBox(height: 7),
      Wrap(spacing: 6, runSpacing: 6, children: items.take(8).map((e) => _pill(_cap(e), c)).toList()),
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
  String _statusLabel(double s, AppLocalizations l) {
    if (s >= 75) return l.edStatusExcellent;
    if (s >= 60) return l.edStatusStrong;
    if (s >= 45) return l.edStatusModerate;
    if (s >= 30) return l.edStatusDeveloping;
    return l.edStatusChallenging;
  }
  String _cap(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
  String _titleCase(String s) => s.replaceAll('_', ' ').replaceAll('-', ' ').split(' ')
    .where((w) => w.isNotEmpty).map((w) => '${w[0].toUpperCase()}${w.substring(1)}').join(' ');

  // ── AI prompt / launch (unchanged behaviour) ──
  String _buildPrompt(Map<String, dynamic> d) {
    final name = widget.chartName;
    final overall = d['overall_education_strength_score'] ?? '?';
    final archetype = d['intellectual_archetype'] ?? '';
    final verdict = d['overall_education_verdict'] ?? '';
    final jsonStr = const JsonEncoder.withIndent('  ').convert(d);
    return '''You are a Vedic education advisor. Analyze this education report for $name and provide actionable study insights.

Key highlights:
- Overall education strength: $overall/100
- Intellectual archetype: $archetype
- Education verdict: $verdict

Full report data (JSON):
$jsonStr

Please explain the key findings in simple language, highlight the best subjects and study timing windows, and suggest practical next steps.''';
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Report copied! Opening $ai — paste to discuss.'), duration: const Duration(seconds: 3)));
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
