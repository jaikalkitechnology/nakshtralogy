import 'dart:convert';
import 'package:flutter/material.dart';
import '../../widgets/desktop_center.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../../utils/kundli_names.dart';
import '../kundli/widgets/kundli_ui.dart';

/// Career & Job report — premium AI career-coach redesign.
///
/// Presentation only. Loads the `career` specialist (`runSpecialist('career')`)
/// unchanged and re-presents it; every score, Jaimini karaka, house, divisional,
/// timing, risk, remedy and confidence value comes straight from the engine.
class CareerReportScreen extends StatefulWidget {
  final String chartId, chartName;
  final Map<String, dynamic>? preloadedData;
  const CareerReportScreen({super.key, required this.chartId, required this.chartName, this.preloadedData});
  @override
  State<CareerReportScreen> createState() => _CareerReportState();
}

class _CareerReportState extends State<CareerReportScreen> {
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
      final resp = await _api.runSpecialist('career', widget.chartId);
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
  // A field that may be either a non-empty string or a list of strings.
  String _flex(String k) {
    final v = _data?[k];
    if (v is String) return v;
    if (v is List && v.isNotEmpty) return v.map((e) => e.toString()).join(' · ');
    return '';
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
          Text(l.crSubtitle, style: const TextStyle(color: AppColors.gold, fontSize: 10)),
        ]),
        actions: [IconButton(icon: const Icon(Icons.refresh, color: AppColors.ivory, size: 18), onPressed: _load)],
      ),
      body: DesktopCenter(maxWidth: 1000, child: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : _error != null ? _errView(l)
          : _data == null ? const SizedBox.shrink()
          : ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 40), children: _sections(l))),
    );
  }

  List<Widget> _sections(AppLocalizations l) {
    // NOTE: sections are rendered directly (no staggered fade wrapper). The
    // hero is tall enough that every section below it is lazy-built well past
    // the viewport; a per-section entrance animation there can stay at opacity
    // 0 and leave the lower report blank, so we keep them plainly visible.
    Widget f(Widget w) => w;
    const gap = SizedBox(height: 18);
    return [
      f(_breadcrumb(l)),
      const SizedBox(height: 10),
      f(_snapshot(l)),        // 1
      gap, f(_topInsights(l)),   // 2
      gap, f(_soulCareer(l)),    // 3
      gap, f(_foundation(l)),    // 4
      gap, f(_verification(l)),  // 5
      gap, f(_personality(l)),   // 6
      gap, f(_workStyle(l)),     // 7
      gap, f(_timeline(l)),      // 8
      gap, f(_risks(l)),         // 9
      gap, f(_remedies(l)),      // 10
      gap, f(_actionPlan(l)),    // 11
      gap, f(_roadmap(l)),       // 12
      gap, f(_confidence(l)),    // 13
      gap, f(_discussAi(l)),     // 14
    ];
  }

  Widget _breadcrumb(AppLocalizations l) => Row(children: [
    Text(l.crCrumbHome, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Text(l.crCrumbReports, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Flexible(child: Text(l.crTitle, style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
  ]);

  // ══════════════════════════════════════════════════════════════════
  //  1 — CAREER SNAPSHOT
  // ══════════════════════════════════════════════════════════════════
  Widget _snapshot(AppLocalizations l) {
    final overall = _sc('overall_career_strength_score');
    final col = _careerColor(overall);
    final summary = _str('plain_statement').isNotEmpty ? _str('plain_statement') : _str('career_verdict_explanation');
    final gauges = <List<Object>>[
      [l.crOverallCareer, overall],
      [l.crStability, _sc('career_stability_score')],
      [l.crGrowth, _sc('career_growth_potential_score')],
      [l.crRecognition, _sc('career_recognition_score')],
      [l.crSatisfaction, _sc('career_satisfaction_score')],
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [col.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
        borderRadius: BorderRadius.circular(22), border: Border.all(color: col.withOpacity(0.3)),
      ),
      child: Column(children: [
        Text(l.crCareerPotential.toUpperCase(), style: const TextStyle(color: AppColors.smoke, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
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
          child: Text(_potentialStatus(overall, l), style: TextStyle(color: col, fontSize: 14, fontWeight: FontWeight.w800))),
        if (summary.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(color: AppColors.midnight.withOpacity(0.35), borderRadius: BorderRadius.circular(14)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('🤖', style: TextStyle(fontSize: 14)), const SizedBox(width: 9),
              Expanded(child: Text(summary, style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, height: 1.5))),
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
    if (_sc('leadership_potential_score') >= 55) out.add(l.crChipLeadership);
    final cat = _str('primary_career_category').toLowerCase();
    if (cat.contains('creative')) out.add(l.crChipCreativity);
    if (cat.contains('technical')) out.add(l.crChipTechnical);
    if (_sc('entrepreneurship_fit_score') >= 55) out.add(l.crChipBusiness);
    if (_sc('career_stability_score') >= 55) out.add(l.crChipStableIncome);
    if (_sc('career_recognition_score') >= 55) out.add(l.crChipRecognition);
    if (_sc('career_growth_potential_score') >= 55) out.add(l.crChipGrowth);
    out.add(l.crChipLearning);
    return out.toSet().take(6).toList();
  }

  Widget _miniGauge(String label, double score) {
    final col = _careerColor(score);
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
  //  2 — TOP INSIGHTS
  // ══════════════════════════════════════════════════════════════════
  Widget _topInsights(AppLocalizations l) {
    final items = _list('career_strengths').map((e) => e.toString()).take(6).toList();
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.emoji_objects_rounded, title: l.crTopInsights, subtitle: l.crWhatDefines, color: AppColors.gold),
      ...items.map((s) => Container(
        margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: KColors.green.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: KColors.green.withOpacity(0.2))),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.check_circle_rounded, size: 17, color: KColors.green), const SizedBox(width: 10),
          Expanded(child: Text(_cap(s), style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, height: 1.4))),
        ]),
      )),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  3 — SOUL & CAREER PURPOSE
  // ══════════════════════════════════════════════════════════════════
  Widget _soulCareer(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    final soul = _str('atmakaraka_planet');
    final career = _str('amatyakaraka_planet');
    final align = _sc('soul_career_alignment_score');
    final col = _careerColor(align);
    final alignText = align >= 60 ? l.crAlignStrong : align >= 40 ? l.crAlignModerate : l.crAlignLow;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.self_improvement_rounded, title: l.crSoulCareer, color: KColors.purple),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: _planetCard('🕉️', l.crSoulPlanet, KundliNames.planet(soul, loc), _str('atmakaraka_soul_career_contract'), KColors.purple)),
        const SizedBox(width: 10),
        Expanded(child: _planetCard('💼', l.crCareerPlanet, KundliNames.planet(career, loc), _str('amatyakaraka_career_theme'), KColors.blue)),
      ]),
      const SizedBox(height: 12),
      _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(l.crAlignment, style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w800))),
          Text('${align.toStringAsFixed(0)}%', style: TextStyle(color: col, fontSize: 18, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 8),
        ClipRRect(borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(value: (align / 100).clamp(0, 1), minHeight: 7, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(col))),
        const SizedBox(height: 10),
        Text('🤖 $alignText', style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.4)),
      ])),
      _advanced(l, [
        '${l.crTechAtmakaraka}: ${KundliNames.planet(soul, loc)} · ${_sc('atmakaraka_degrees').toStringAsFixed(1)}°',
        '${l.crTechAmatyakaraka}: ${KundliNames.planet(career, loc)} · ${l.crDignity}: ${_str('amatyakaraka_dignity')}',
        'D9 ${l.crDignity}: ${_str('amatyakaraka_d9_dignity')} · D10 ${l.crDignity}: ${_str('amatyakaraka_d10_dignity')}',
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
      Text(_cap(meaning), style: const TextStyle(color: AppColors.parchment, fontSize: 11, height: 1.35)),
    ]),
  );

  // ══════════════════════════════════════════════════════════════════
  //  4 — CAREER FOUNDATION
  // ══════════════════════════════════════════════════════════════════
  Widget _foundation(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    final strength = _sc('tenth_house_strength_score');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.foundation_rounded, title: l.crFoundation, color: KColors.blue),
      Row(children: [
        Expanded(child: _iconTile('🔯', l.crCareerSign, _str('tenth_house_sign_name'))),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('🪐', l.crCareerLord, KundliNames.planet(_str('tenth_lord_planet'), loc))),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('💪', l.crCareerStrength, '${strength.toStringAsFixed(0)}%', color: _careerColor(strength))),
      ]),
      const SizedBox(height: 10),
      _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l.crProfStyle, style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(_cap(_str('tenth_lord_career_indication')), style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, height: 1.45)),
        const SizedBox(height: 12),
        Text(l.crBestFields, style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Wrap(spacing: 6, runSpacing: 6, children: _list('best_industries').map((e) => _pill(e.toString(), KColors.blue)).toList()),
      ])),
      _advanced(l, [
        '${l.crCareerLord} ${l.crHouseLabel}: ${_sc('tenth_lord_house').toStringAsFixed(0)}',
        '${l.crDignity}: ${_str('tenth_lord_dignity')} · D9: ${_str('tenth_lord_d9_dignity')}',
        'Nakshatra: ${_str('tenth_lord_nakshatra')} (${_str('tenth_lord_nakshatra_deity')})',
        if (_list('tenth_house_occupants').isNotEmpty) 'Occupants: ${_list('tenth_house_occupants').map((e) => KundliNames.planet(e.toString(), loc)).join(', ')}',
      ]),
    ]);
  }

  Widget _iconTile(String emoji, String label, String value, {Color? color}) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: AppColors.card.withOpacity(0.5), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.06))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(emoji, style: const TextStyle(fontSize: 17)), const SizedBox(height: 6),
      Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontWeight: FontWeight.w600)),
      Text(value, style: TextStyle(color: color ?? AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
    ]),
  );

  // ══════════════════════════════════════════════════════════════════
  //  5 — VERIFICATION ACROSS CHARTS
  // ══════════════════════════════════════════════════════════════════
  Widget _verification(AppLocalizations l) {
    final d10 = _map('d10_validation'), d9 = _map('d9_validation'), d60 = _map('d60_career_validation');
    final standing = (d10['d10_overall_career_standing']?.toString() ?? '').toLowerCase();
    final d10Score = standing.contains('strong') ? 75.0 : standing.contains('moderate') ? 50.0 : 30.0;
    final d9Score = (d9['d9_career_dharma_alignment_score'] is num ? d9['d9_career_dharma_alignment_score'] as num : null)?.toDouble() ?? 0;
    final d60Score = (d60['d60_past_life_work_capital_score'] is num ? d60['d60_past_life_work_capital_score'] as num : null)?.toDouble() ?? 0;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.verified_rounded, title: l.crVerification, color: KColors.green),
      _chartCard(l, l.crD10Career, d10Score, d10['d10_primary_career_signature']?.toString() ?? '',
        ['D10 10L: ${d10['d10_tenth_lord_dignity']}', 'Sun: ${d10['d10_sun_dignity']} · Saturn: ${d10['d10_saturn_dignity']}', 'AmK: ${d10['d10_amatyakaraka_dignity']}']),
      _chartCard(l, l.crD9Purpose, d9Score, d9['d9_career_notes']?.toString() ?? '',
        ['D9 10L: ${d9['d9_tenth_lord_dignity']}', 'D9 AmK: ${d9['d9_amatyakaraka_dignity']}']),
      _chartCard(l, l.crD60Karma, d60Score, d60['d60_career_past_life_signature']?.toString() ?? '',
        ['D60 10L: ${d60['d60_tenth_lord_dignity']}', 'D60 AmK: ${d60['d60_amatyakaraka_dignity']}']),
    ]);
  }

  Widget _chartCard(AppLocalizations l, String title, double score, String explain, List<String> tech) {
    final col = _careerColor(score);
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
  //  6 — CAREER PERSONALITY
  // ══════════════════════════════════════════════════════════════════
  Widget _personality(AppLocalizations l) {
    final archetype = _titleCase(_str('primary_career_archetype'));
    final env = [_titleCase(_str('ideal_work_environment')), _titleCase(_str('ideal_organization_size'))].where((s) => s.isNotEmpty).join(' · ');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.psychology_rounded, title: l.crPersonality, color: KColors.purple),
      Container(padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [KColors.purple.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
          borderRadius: BorderRadius.circular(18), border: Border.all(color: KColors.purple.withOpacity(0.3))),
        child: Column(children: [
          const Text('🎭', style: TextStyle(fontSize: 34)),
          const SizedBox(height: 8),
          Text(archetype, style: const TextStyle(color: AppColors.ivory, fontSize: 20, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
          if (_str('career_verdict_explanation').isNotEmpty) ...[const SizedBox(height: 8),
            Text('🤖 ${_cap(_str('career_verdict_explanation'))}', style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.5), textAlign: TextAlign.center)],
        ])),
      const SizedBox(height: 12),
      _chipBlock('💪', l.strengths, _list('career_strengths'), KColors.green),
      _chipBlock('🌱', l.crGrowthAreas, _list('career_weaknesses'), KColors.orange),
      _chipBlock('🎯', l.crBestRoles, _list('specific_job_role_fits'), KColors.blue),
      _chipBlock('🏭', l.crBestIndustries, _list('best_industries'), KColors.gold),
      if (env.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6),
        child: _card(child: Row(children: [const Text('🏢', style: TextStyle(fontSize: 15)), const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.crEnvironment, style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w700)),
            Text(env, style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, fontWeight: FontWeight.w600)),
          ]))]))),
    ]);
  }

  Widget _chipBlock(String emoji, String title, List items, Color c) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(padding: const EdgeInsets.only(bottom: 10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Text(emoji, style: const TextStyle(fontSize: 13)), const SizedBox(width: 6),
        Text(title, style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w800))]),
      const SizedBox(height: 7),
      Wrap(spacing: 6, runSpacing: 6, children: items.take(8).map((e) => _pill(_cap(e.toString()), c)).toList()),
    ]));
  }

  // ══════════════════════════════════════════════════════════════════
  //  7 — WORK STYLE
  // ══════════════════════════════════════════════════════════════════
  Widget _workStyle(AppLocalizations l) {
    final rec = _str('recommended_work_structure').toLowerCase();
    final rows = <List<Object>>[
      [l.crEmployment, _sc('employment_fit_score'), 'employ'],
      [l.crBusiness, _sc('entrepreneurship_fit_score'), 'entrepreneur'],
      [l.crFreelance, _sc('freelance_consulting_fit_score'), 'freelance'],
      [l.crPortfolio, _sc('mixed_portfolio_fit_score'), 'portfolio'],
      [l.crLeadership, _sc('team_leadership_fit_score'), 'leader'],
    ];
    rows.sort((a, b) => (b[1] is num ? (b[1] as num).toDouble() : 0.0).compareTo(a[1] as double));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.work_outline_rounded, title: l.crWorkStyle, color: KColors.blue),
      ...rows.map((r) {
        final score = r[1] as double;
        final tag = r[2] as String;
        final isBest = rec.contains(tag) || (rec.contains('business') && tag == 'entrepreneur') || (rec.contains('job') && tag == 'employ');
        final col = isBest ? KColors.green : _careerColor(score);
        return Container(
          margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: col.withOpacity(isBest ? 0.10 : 0.05), borderRadius: BorderRadius.circular(14),
            border: Border.all(color: col.withOpacity(isBest ? 0.4 : 0.18))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(r[0] as String, style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w700))),
              if (isBest) Container(margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(color: KColors.green.withOpacity(0.18), borderRadius: BorderRadius.circular(6)),
                child: Text('⭐ ${l.crBestFit}', style: const TextStyle(color: KColors.green, fontSize: 8.5, fontWeight: FontWeight.w800))),
              Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: col, fontSize: 15, fontWeight: FontWeight.w800)),
            ]),
            const SizedBox(height: 7),
            ClipRRect(borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(value: (score / 100).clamp(0, 1), minHeight: 6, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(col))),
          ]),
        );
      }),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  8 — CAREER TIMELINE
  // ══════════════════════════════════════════════════════════════════
  Widget _timeline(AppLocalizations l) {
    final launch = _list('career_launch_windows').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final risk = _list('career_risk_windows').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final cards = <Widget>[];
    void add(String title, Map<String, dynamic> m, Color c) {
      cards.add(_timelineCard(l, title, m['window']?.toString() ?? '', m['dasha']?.toString() ?? '', m['note']?.toString() ?? '', c));
    }
    if (launch.isNotEmpty) add(l.crPresentPhase, launch[0], KColors.green);
    if (launch.length > 1) add(l.crFutureExpansion, launch[1], KColors.blue);
    final trans = _flex('career_transition_windows');
    if (trans.isNotEmpty && cards.length < 3) cards.add(_timelineCard(l, l.crUpcoming, '', '', trans, KColors.purple));
    if (risk.isNotEmpty) add(l.crRiskPeriod, risk[0], KColors.orange);
    if (cards.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.timeline_rounded, title: l.crTimeline, color: AppColors.gold),
      ...cards,
    ]);
  }

  // A robust "rail" timeline card (colored left accent). No IntrinsicHeight /
  // Expanded-in-Column, so it can never throw a layout assertion inside the
  // scrolling list.
  Widget _timelineCard(AppLocalizations l, String title, String window, String dasha, String note, Color col) {
    final loc = Localizations.localeOf(context);
    final planet = dasha.isNotEmpty ? KundliNames.planet(dasha.split(' ').first, loc) : '';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(14, 13, 13, 13),
      decoration: BoxDecoration(
        color: col.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: col.withOpacity(0.28)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: col, shape: BoxShape.circle, border: Border.all(color: col.withOpacity(0.35), width: 3))),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: TextStyle(color: col, fontSize: 12.5, fontWeight: FontWeight.w800))),
          if (window.isNotEmpty) Text(window, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w600)),
        ]),
        if (planet.isNotEmpty) ...[const SizedBox(height: 4),
          Text('🪐 $planet', style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700))],
        if (note.isNotEmpty) ...[const SizedBox(height: 6),
          Text(_cap(note), style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.4))],
        if (dasha.isNotEmpty) _advanced(l, ['${l.crViewDasha}: $dasha']),
      ]),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  //  9 — CHALLENGES TO WATCH
  // ══════════════════════════════════════════════════════════════════
  Widget _risks(AppLocalizations l) {
    final rows = <List<Object>>[
      [l.crRiskBurnout, _sc('burnout_risk_score'), l.crBurnoutExp, l.crBurnoutFix],
      [l.crRiskRecognition, _sc('career_stagnation_risk_score'), l.crRecognitionExp, l.crRecognitionFix],
      [l.crRiskConflict, _sc('workplace_conflict_risk_score'), l.crConflictExp, l.crConflictFix],
      [l.crRiskFinancial, _sc('financial_instability_risk_score'), l.crFinancialExp, l.crFinancialFix],
      [l.crRiskOverqual, _sc('overqualification_underemployment_risk_score'), l.crOverqualExp, l.crOverqualFix],
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.shield_outlined, title: l.crChallenges, color: KColors.orange),
      ...rows.map((r) {
        final score = r[1] as double;
        final col = _riskColor(score);
        return Container(
          margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: col.withOpacity(0.05), borderRadius: BorderRadius.circular(14), border: Border.all(color: col.withOpacity(0.18))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(r[0] as String, style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w700))),
              Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: col, fontSize: 14, fontWeight: FontWeight.w800)),
            ]),
            const SizedBox(height: 6),
            ClipRRect(borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(value: (score / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(col))),
            const SizedBox(height: 8),
            Text(r[2] as String, style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.35)),
            const SizedBox(height: 6),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('🛡️ ${l.crPrevention}: ', style: const TextStyle(color: KColors.green, fontSize: 10.5, fontWeight: FontWeight.w800)),
              Expanded(child: Text(r[3] as String, style: const TextStyle(color: AppColors.ivory, fontSize: 11, height: 1.35))),
            ]),
          ]),
        );
      }),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  10 — IMPROVEMENT PLAN (remedies)
  // ══════════════════════════════════════════════════════════════════
  Widget _remedies(AppLocalizations l) {
    final planetary = _list('astrological_remedies').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final practical = _list('practical_solutions').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.spa_rounded, title: l.crImprovementPlan, color: KColors.green),
      if (practical.isNotEmpty) ...[
        _catLabel('🎯', l.crCatPractical, KColors.blue),
        ...practical.map((m) => _remedyCard(_titleCase(m['category']?.toString() ?? ''), m['advice']?.toString() ?? '', null, l, KColors.blue)),
      ],
      if (planetary.isNotEmpty) ...[
        const SizedBox(height: 6),
        _catLabel('🕉️', l.crCatPlanetary, KColors.purple),
        ...planetary.map((m) => _remedyCard(m['deity']?.toString() ?? '', m['remedy']?.toString() ?? '', m['deity']?.toString(), l, KColors.purple)),
      ],
    ]);
  }

  Widget _catLabel(String emoji, String t, Color c) => Padding(padding: const EdgeInsets.only(bottom: 8, top: 2),
    child: Row(children: [Text(emoji, style: const TextStyle(fontSize: 13)), const SizedBox(width: 6),
      Text(t, style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w800))]));

  Widget _remedyCard(String title, String body, String? tradition, AppLocalizations l, Color c) => Container(
    margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: c.withOpacity(0.2))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (title.isNotEmpty) Text(title, style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w800)),
      if (title.isNotEmpty) const SizedBox(height: 4),
      Text(_cap(body), style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.45)),
      if (tradition != null && tradition.isNotEmpty) _advanced(l, ['${l.crTraditionalExplain}: $tradition']),
    ]),
  );

  // ══════════════════════════════════════════════════════════════════
  //  11 — 30-DAY ACTION PLAN
  // ══════════════════════════════════════════════════════════════════
  Widget _actionPlan(AppLocalizations l) {
    final practical = _list('practical_solutions').whereType<Map>().map((e) => e['advice']?.toString() ?? '').toList();
    final weeks = <List<Object>>[
      [l.crWeek1, l.crWeek1Tip, l.crPriorityHigh, '2–3 hrs'],
      [l.crWeek2, l.crWeek2Tip, l.crPriorityHigh, '3–4 hrs'],
      [l.crWeek3, l.crWeek3Tip, l.crPriorityMedium, '2 hrs'],
      [l.crWeek4, l.crWeek4Tip, l.crPriorityMedium, '2–3 hrs'],
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.checklist_rounded, title: l.crActionPlan, color: AppColors.gold),
      ...List.generate(weeks.length, (idx) {
        final w = weeks[idx];
        final extra = idx < practical.length ? practical[idx] : '';
        return Container(
          margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.card.withOpacity(0.4), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.06))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(w[0] as String, style: const TextStyle(color: AppColors.gold, fontSize: 13, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(w[1] as String, style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.4)),
            if (extra.isNotEmpty) ...[const SizedBox(height: 5), Text('• ${_cap(extra)}', style: const TextStyle(color: AppColors.parchment, fontSize: 11, height: 1.4))],
            const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 6, children: [
              _tag('⚡ ${l.crPriority}: ${w[2]}', KColors.orange),
              _tag('⏱ ${l.crTimeRequired}: ${w[3]}', KColors.blue),
            ]),
          ]),
        );
      }),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  12 — AI CAREER ROADMAP
  // ══════════════════════════════════════════════════════════════════
  Widget _roadmap(AppLocalizations l) {
    final risks = _list('major_career_risks').whereType<Map>().map((e) => e['description']?.toString() ?? '')
        .where((s) => s.isNotEmpty && !s.toLowerCase().contains('no structural')).toList();
    final rows = <List<String>>[
      ['🎯', l.crBestFocus, _cap(_str('primary_career_direction_recommendation'))],
      ['📚', l.crSkillsLearn, _list('career_weaknesses').map((e) => _cap(e.toString())).join(' · ')],
      ['🏭', l.crIndustriesTarget, _list('best_industries').take(4).join(' · ')],
      ['⚠️', l.fdAvoid, risks.map(_cap).join(' · ')],
      ['🏆', l.crExpectedOutcome, _cap(_str('career_verdict_explanation'))],
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.rocket_launch_rounded, title: l.crRoadmap, subtitle: l.crNext12, color: KColors.purple),
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
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  13 — PREDICTION RELIABILITY
  // ══════════════════════════════════════════════════════════════════
  Widget _confidence(AppLocalizations l) {
    final raw = _sc('confidence_score');
    final pct = raw <= 1 ? raw * 100 : raw;
    final band = pct >= 75 ? l.crReliabilityHigh : pct >= 60 ? l.crReliabilityGood : l.crReliabilityModerate;
    final b = _map('confidence_breakdown');
    final layers = <List<Object>>[
      [l.crBirthChart, (b['d1'] is num ? b['d1'] as num : null)?.toDouble() ?? 0],
      [l.crNavamsa, (b['d9'] is num ? b['d9'] as num : null)?.toDouble() ?? 0],
      [l.crDashamsa, (b['d10'] is num ? b['d10'] as num : null)?.toDouble() ?? 0],
      [l.crShashtiamsa, (b['d60'] is num ? b['d60'] as num : null)?.toDouble() ?? 0],
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.verified_user_rounded, title: l.crReliability, color: KColors.blue),
      _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          KStars(filled: kStars(pct), size: 20, color: AppColors.gold), const Spacer(),
          Text('${pct.toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.gold, fontSize: 22, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 4),
        Text(band, style: const TextStyle(color: KColors.green, fontSize: 13, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        Text(l.crReliabilityExplain, style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.5)),
        _advanced(l, null, customTitle: l.crChartLayers, customChild: Column(children: layers.map((la) {
          final v = (la[1] is num ? (la[1] as num).toDouble() : 0.0) * 100;
          return Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [
            SizedBox(width: 130, child: Text(la[0] as String, style: const TextStyle(color: AppColors.ivory, fontSize: 11.5))),
            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(value: (v / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(_careerColor(v))))),
            const SizedBox(width: 8),
            Text('${v.toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w700)),
          ]));
        }).toList())),
      ])),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  14 — DISCUSS WITH AI
  // ══════════════════════════════════════════════════════════════════
  Widget _discussAi(AppLocalizations l) {
    final topics = <String>[l.crTopicChange, l.crTopicGovt, l.crTopicBusiness, l.crTopicPromotion, l.crTopicMarriage, l.crTopicAbroad, l.crTopicIncome, l.crTopicPurpose, l.crTopicResume];
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
    final q = '$topic — based on my Vedic career report for ${widget.chartName}.\n\n${_buildPrompt(_data!)}';
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

  Widget _tag(String t, Color c) => Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    decoration: BoxDecoration(color: c.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
    child: Text(t, style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.w700)));

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

  Color _careerColor(double s) {
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
  String _potentialStatus(double s, AppLocalizations l) {
    if (s >= 75) return l.crStatusStrong;
    if (s >= 60) return l.crStatusGood;
    if (s >= 45) return l.crStatusModerate;
    if (s >= 30) return l.crStatusDeveloping;
    return l.crStatusChallenging;
  }
  String _cap(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
  String _titleCase(String s) => s.replaceAll('_', ' ').replaceAll('-', ' ').split(' ')
    .where((w) => w.isNotEmpty).map((w) => '${w[0].toUpperCase()}${w.substring(1)}').join(' ');

  // ── AI prompt / launch (unchanged behaviour) ──
  String _buildPrompt(Map<String, dynamic> d) {
    final name = widget.chartName;
    final overall = d['overall_career_strength_score'] ?? '?';
    final archetype = d['primary_career_archetype'] ?? '';
    final verdict = d['overall_career_verdict'] ?? '';
    final jsonStr = const JsonEncoder.withIndent('  ').convert(d);
    return '''You are a Vedic career advisor. Analyze this career report for $name and provide actionable insights.

Key highlights:
- Overall career strength: $overall/100
- Career archetype: $archetype
- Career verdict: $verdict

Full report data (JSON):
$jsonStr

Please explain the key findings in simple language, highlight the most important timing windows, and suggest practical next steps.''';
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.reportCopiedOpeningAi(ai)), duration: const Duration(seconds: 3)));
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
