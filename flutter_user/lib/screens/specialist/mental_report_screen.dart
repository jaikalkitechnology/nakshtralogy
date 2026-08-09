import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../kundli/widgets/kundli_ui.dart';

/// Mental & Stress report — premium AI wellness-coach redesign.
///
/// Presentation only. Loads the `mental_stress` specialist
/// (`runSpecialist('mental_stress')`) unchanged and re-presents it; every
/// score, karaka, yoga, timing window, remedy and confidence value comes
/// straight from the engine. Tone is deliberately warm, reassuring and
/// non-alarming — this is a wellness companion, never a diagnosis.
class MentalReportScreen extends StatefulWidget {
  final String chartId, chartName;
  final Map<String, dynamic>? preloadedData;
  const MentalReportScreen({super.key, required this.chartId, required this.chartName, this.preloadedData});
  @override
  State<MentalReportScreen> createState() => _MentalState();
}

class _MentalState extends State<MentalReportScreen> {
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
      final resp = await _api.runSpecialist('mental_stress', widget.chartId);
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
          Text(l.mnSubtitle, style: const TextStyle(color: AppColors.gold, fontSize: 10)),
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
      _snapshot(l),              // 1
      gap, _supportBanner(l),       // (conditional)
      gap, _profile(l),             // 2
      gap, _karakaTable(l),         // 3
      gap, _strengthsGrowth(l),     // 4
      gap, _verification(l),        // 5
      gap, _moodPatterns(l),        // 6
      gap, _regulationCoping(l),    // 7
      gap, _sleepRest(l),           // 8
      gap, _burnoutEnergy(l),       // 9
      gap, _connectionSupport(l),   // 10
      gap, _selfAwareness(l),       // 11
      gap, _therapyFit(l),          // 12
      gap, _wellnessTimeline(l),    // 13
      gap, _dailyPractices(l),      // 14
      gap, _improvementPlan(l),     // 15
      gap, _reliability(l),         // 16
      gap, _discussAi(l),           // 17
    ];
  }

  Widget _breadcrumb(AppLocalizations l) => Row(children: [
    Text(l.crCrumbHome, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Text(l.crCrumbReports, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Flexible(child: Text(l.mnTitle, style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
  ]);

  // ══════════════════════════════════════════════════════════════════
  //  1 — WELLNESS SNAPSHOT
  // ══════════════════════════════════════════════════════════════════
  Widget _snapshot(AppLocalizations l) {
    final overall = _sc('mental_resilience_score');
    final col = _col(overall);
    final theme = _map('core_mental_theme');
    final summary = _str('chart_reminds_you_that').isNotEmpty ? _str('chart_reminds_you_that')
      : (theme['explanation']?.toString().isNotEmpty == true ? theme['explanation'].toString() : _str('plain_statement'));
    final innerCalm = (100 - ((_sc('anxiety_vulnerability_score') + _sc('depression_vulnerability_score')) / 2)).clamp(0, 100).toDouble();
    final gauges = <List<Object>>[
      [l.mnResilience, overall],
      [l.mnStability, _sc('mental_stability_score')],
      [l.mnEmotionalBalance, _sc('emotional_baseline_score')],
      [l.mnInnerCalm, innerCalm],
      [l.mnSelfAwareness, _sc('self_awareness_score')],
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [col.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
        borderRadius: BorderRadius.circular(22), border: Border.all(color: col.withOpacity(0.3)),
      ),
      child: Column(children: [
        Text(l.mnSnapshotHeader.toUpperCase(), style: const TextStyle(color: AppColors.smoke, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
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
    if (_sc('mental_stability_score') >= 60) out.add(l.mnChipStable);
    if (_sc('social_support_quality_score') >= 60) out.add(l.mnChipSupported);
    if (_sc('self_awareness_score') >= 60) out.add(l.mnChipSelfAware);
    if (_sc('recovery_from_burnout_capacity_score') >= 60) out.add(l.mnChipResilient);
    if (_str('attachment_style_indicator').toLowerCase() == 'secure') out.add(l.mnChipSecureAttachment);
    if (_sc('healing_readiness_score') >= 60) out.add(l.mnChipHealingReady);
    if (_sc('body_mind_integration_score') >= 60) out.add(l.mnChipMindBodyBalance);
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
  //  supportive callout — only when the chart suggests extra care
  // ══════════════════════════════════════════════════════════════════
  Widget _supportBanner(AppLocalizations l) {
    if (!_bool('urgent_mental_health_support_suggested')) return const SizedBox.shrink();
    final note = _str('crisis_resources_note');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: KColors.blue.withOpacity(0.10), borderRadius: BorderRadius.circular(18), border: Border.all(color: KColors.blue.withOpacity(0.3))),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.favorite_rounded, color: KColors.blue, size: 22),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l.mnSupportBannerTitle, style: const TextStyle(color: KColors.blue, fontSize: 13, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(l.mnSupportBannerBody, style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.45)),
          if (note.isNotEmpty) ...[const SizedBox(height: 6),
            Text(note, style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))],
        ])),
      ]),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  //  2 — YOUR EMOTIONAL BLUEPRINT
  // ══════════════════════════════════════════════════════════════════
  Widget _profile(AppLocalizations l) {
    final constitution = _str('emotional_constitution');
    if (constitution.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.favorite_border_rounded, title: l.mnProfileTitle, color: AppColors.gold),
      Container(padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.gold.withOpacity(0.14), AppColors.card.withOpacity(0.4)]),
          borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.gold.withOpacity(0.28))),
        child: Column(children: [
          Text(_titleCase(constitution), style: const TextStyle(color: AppColors.gold, fontSize: 19, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Wrap(alignment: WrapAlignment.center, spacing: 6, runSpacing: 6, children: [
            if (_str('primary_stress_driver').isNotEmpty) _pill('${l.mnStressDriver}: ${_str('primary_stress_driver')}', KColors.orange),
            if (_str('primary_stability_anchor').isNotEmpty) _pill('${l.mnStabilityAnchor}: ${_str('primary_stability_anchor')}', KColors.green),
            if (_str('stress_response_pattern').isNotEmpty) _pill(_titleCase(_str('stress_response_pattern')), KColors.blue),
            if (_str('attachment_style_indicator').isNotEmpty) _pill(_titleCase(_str('attachment_style_indicator')), KColors.purple),
            if (_str('current_burnout_stage').isNotEmpty) _pill(_titleCase(_str('current_burnout_stage')), AppColors.gold),
          ]),
        ])),
      _advanced(l, [
        if (_str('soul_level_mental_karma').isNotEmpty) '${l.mnSoulLevelKarma}: ${_titleCase(_str('soul_level_mental_karma'))}',
        if (_str('subtle_emotional_signature').isNotEmpty) '${l.mnSubtleSignature}: ${_titleCase(_str('subtle_emotional_signature'))}',
      ]),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  3 — YOUR MIND & PLANETS
  // ══════════════════════════════════════════════════════════════════
  Widget _karakaTable(AppLocalizations l) {
    final map = _map('karaka_mental_weight_table');
    if (map.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.hub_rounded, title: l.mnKarakaTitle, subtitle: l.mnKarakaSubtitle, color: KColors.purple),
      _card(child: Column(children: map.entries.map((e) {
        final v = e.value is num ? (e.value is num ? e.value as num : 0).toDouble() : 0.0;
        final c = _col(v);
        return Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(children: [
          SizedBox(width: 70, child: Text(e.key.toString(), style: TextStyle(color: c, fontSize: 11.5, fontWeight: FontWeight.w700))),
          Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(value: (v / 100).clamp(0, 1), minHeight: 6, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
          const SizedBox(width: 8),
          SizedBox(width: 28, child: Text(v.toStringAsFixed(0), textAlign: TextAlign.right, style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w800))),
        ]));
      }).toList())),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  4 — STRENGTHS & GROWTH AREAS (yogas)
  // ══════════════════════════════════════════════════════════════════
  Widget _strengthsGrowth(AppLocalizations l) {
    final protective = _list('active_mental_protective_yogas').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final pressures = _list('active_stress_yogas').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    if (protective.isEmpty && pressures.isEmpty) return const SizedBox.shrink();
    final phase = _str('active_emotional_phase');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.auto_awesome_rounded, title: l.mnYogasTitle, color: AppColors.gold),
      if (phase.isNotEmpty) Padding(padding: const EdgeInsets.only(bottom: 10),
        child: _pill('${l.mnCurrentPhase}: ${_titleCase(phase)}', KColors.blue)),
      Row(children: [
        Expanded(child: _statTile(l.mnCurrentStressLevel, _sc('current_stress_level'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.mnRecentStrain, _sc('recent_emotional_strain_score'))),
      ]),
      const SizedBox(height: 10),
      if (protective.isNotEmpty) ...[
        _catLabel('🛡️', l.mnStrengths, KColors.green),
        ...protective.take(6).map((m) => _yogaRow(m['name']?.toString() ?? '', (m['score'] is num ? m['score'] as num : null)?.toDouble() ?? 0, KColors.green)),
        const SizedBox(height: 6),
      ],
      if (pressures.isNotEmpty) ...[
        _catLabel('🌱', l.mnGrowthAreas, KColors.orange),
        ...pressures.take(6).map((m) => _yogaRow(m['name']?.toString() ?? '', (m['score'] is num ? m['score'] as num : null)?.toDouble() ?? 0, KColors.orange)),
      ],
      if (_str('saturn_sade_sati_status').isNotEmpty) ...[const SizedBox(height: 6),
        _pill('${l.mnSadeSatiStatus}: ${_titleCase(_str('saturn_sade_sati_status'))}', KColors.purple)],
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
  //  5 — VERIFIED ACROSS CHARTS (D9 / D30)
  // ══════════════════════════════════════════════════════════════════
  Widget _verification(AppLocalizations l) {
    final d9 = (_sc('d9_mental_multiplier') * 100).clamp(0, 100).toDouble();
    final d30 = (_sc('d30_vulnerability_multiplier') * 100).clamp(0, 100).toDouble();
    if (d9 == 0 && d30 == 0) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.verified_rounded, title: l.mnVerificationTitle, color: KColors.green),
      Row(children: [
        Expanded(child: _statTile(l.mnD9Confirmation, d9)),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.mnD30Confirmation, d30)),
      ]),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  6 — MOOD & ANXIETY PATTERNS (gentle framing)
  // ══════════════════════════════════════════════════════════════════
  Widget _moodPatterns(AppLocalizations l) {
    final anxiety = _map('anxiety_type_scores');
    final mood = _map('low_mood_pattern_scores');
    if (anxiety.isEmpty && mood.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.cloud_outlined, title: l.mnMoodPatternsTitle, subtitle: l.mnMoodPatternsSubtitle, color: KColors.blue),
      if (anxiety.isNotEmpty) ...[
        _catLabel('🌬️', l.mnAnxietyPatterns, KColors.blue),
        _sortedBars(anxiety, gentle: true),
        if (_str('primary_anxiety_pattern').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6),
          child: _pill('${l.mnPrimaryPattern}: ${_titleCase(_str('primary_anxiety_pattern'))}', KColors.blue)),
        const SizedBox(height: 10),
      ],
      if (mood.isNotEmpty) ...[
        _catLabel('🌤️', l.mnMoodPatterns, KColors.purple),
        _sortedBars(mood, gentle: true),
        if (_str('primary_low_mood_pattern').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6),
          child: _pill('${l.mnPrimaryPattern}: ${_titleCase(_str('primary_low_mood_pattern'))}', KColors.purple)),
      ],
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _riskTile(l.mnRumination, _sc('rumination_tendency_score'))),
        const SizedBox(width: 10),
        Expanded(child: _riskTile(l.mnHypervigilance, _sc('hypervigilance_score'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _riskTile(l.mnHopelessnessVuln, _sc('hopelessness_vulnerability_score'))),
        const SizedBox(width: 10),
        Expanded(child: _riskTile(l.mnEnergyDepletion, _sc('energy_depletion_tendency'))),
      ]),
      const SizedBox(height: 10),
      _statTile(l.mnMotivationBaseline, _sc('motivation_baseline_score')),
      _advanced(l, _list('anxiety_trigger_list').map((e) => e.toString()).toList()),
    ]);
  }

  Widget _sortedBars(Map<String, dynamic> m, {bool gentle = false}) {
    final sorted = m.entries.where((e) => e.value is num).toList()..sort((a, b) => (b.value is num ? b.value as num : 0).compareTo(a.value as num));
    return _card(child: Column(children: sorted.take(8).map((e) {
      final v = (e.value is num ? e.value as num : 0).toDouble();
      final c = gentle ? _gentleColor(v) : _col(v);
      return Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children: [
        SizedBox(width: 96, child: Text(_titleCase(e.key), style: const TextStyle(color: AppColors.ivory, fontSize: 11))),
        Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(value: (v / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
        const SizedBox(width: 8),
        SizedBox(width: 32, child: Text('${v.toStringAsFixed(0)}%', textAlign: TextAlign.right, style: TextStyle(color: c, fontSize: 10.5, fontWeight: FontWeight.w700))),
      ]));
    }).toList()));
  }

  // ══════════════════════════════════════════════════════════════════
  //  7 — EMOTIONAL REGULATION & COPING
  // ══════════════════════════════════════════════════════════════════
  Widget _regulationCoping(AppLocalizations l) {
    final healthy = _list('healthy_coping_mechanisms').map((e) => e.toString()).toList();
    final unhealthy = _list('unhealthy_coping_risks').map((e) => e.toString()).toList();
    final triggers = _list('primary_stress_triggers').map((e) => e.toString()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.self_improvement_rounded, title: l.mnRegulationTitle, color: KColors.green),
      Row(children: [
        Expanded(child: _statTile(l.mnEmotionalRegulation, _sc('emotional_regulation_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.mnSelfSoothing, _sc('self_soothing_capacity_score'))),
      ]),
      const SizedBox(height: 10),
      Wrap(spacing: 8, runSpacing: 8, children: [
        if (_str('emotional_expression_style').isNotEmpty) _pill('${l.mnExpressionStyle}: ${_titleCase(_str('emotional_expression_style'))}', KColors.blue),
        if (_str('recovery_after_trigger_tendency').isNotEmpty) _pill('${l.mnRecoveryTime}: ${_titleCase(_str('recovery_after_trigger_tendency'))}', KColors.green),
      ]),
      const SizedBox(height: 10),
      _riskTile(l.mnTriggerIntensity, _sc('trigger_intensity_score')),
      if (healthy.isNotEmpty) ...[const SizedBox(height: 10), _chipBlock('✓', l.mnHealthyCoping, healthy, KColors.green)],
      if (unhealthy.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('👀', l.mnWatchFor, unhealthy, KColors.orange)],
      _advanced(l, triggers),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  8 — SLEEP & REST
  // ══════════════════════════════════════════════════════════════════
  Widget _sleepRest(AppLocalizations l) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.bedtime_rounded, title: l.mnSleepTitle, color: KColors.purple),
      Row(children: [
        Expanded(child: _statTile(l.mnSleepQuality, _sc('sleep_quality_tendency_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.mnSleepAsRegulator, _sc('sleep_as_emotional_regulator_score'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _riskTile(l.mnInsomniaTendency, _sc('insomnia_vulnerability_score'))),
        const SizedBox(width: 10),
        Expanded(child: _riskTile(l.mnNightmareTendency, _sc('nightmare_tendency_score'))),
      ]),
      if (_str('sleep_hygiene_priority').isNotEmpty) ...[const SizedBox(height: 10),
        _pill('${l.mnSleepHygienePriority}: ${_titleCase(_str('sleep_hygiene_priority'))}', KColors.blue)],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  9 — BURNOUT & ENERGY
  // ══════════════════════════════════════════════════════════════════
  Widget _burnoutEnergy(AppLocalizations l) {
    final triggers = _list('burnout_triggers').map((e) => e.toString()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.battery_charging_full_rounded, title: l.mnBurnoutTitle, color: KColors.orange),
      Row(children: [
        Expanded(child: _riskTile(l.mnBurnoutVulnerability, _sc('burnout_vulnerability_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.mnBurnoutRecovery, _sc('recovery_from_burnout_capacity_score'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _iconTile('🔥', l.mnBurnoutStage, _titleCase(_str('current_burnout_stage')))),
        const SizedBox(width: 10),
        Expanded(child: _riskTile(l.mnSelfDrivingTendency, _sc('self_driving_tendency_score'))),
      ]),
      if (triggers.isNotEmpty) ...[const SizedBox(height: 10), _chipBlock('⚡', l.mnBurnoutTriggers, triggers, KColors.orange)],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  10 — CONNECTION & SUPPORT
  // ══════════════════════════════════════════════════════════════════
  Widget _connectionSupport(AppLocalizations l) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.diversity_3_rounded, title: l.mnConnectionTitle, color: KColors.blue),
      Row(children: [
        Expanded(child: _statTile(l.mnSocialSupport, _sc('social_support_quality_score'))),
        const SizedBox(width: 10),
        Expanded(child: _riskTile(l.mnLonelinessVuln, _sc('loneliness_vulnerability_score'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.mnSolitudeNeed, _sc('need_for_solitude_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.mnSocialComfort, _sc('social_anxiety_vs_comfort_score'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _riskTile(l.mnTraumaSensitivity, _sc('trauma_sensitivity_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.mnHealingReadiness, _sc('healing_readiness_score'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _iconTile('🌊', l.mnProcessingStyle, _titleCase(_str('processing_style')))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.mnMindBodyIntegration, _sc('body_mind_integration_score'))),
      ]),
      _advanced(l, [
        '${l.mnPtsdVuln}: ${_sc('ptsd_response_vulnerability').toStringAsFixed(0)}',
      ]),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  11 — SELF-AWARENESS & GROWTH
  // ══════════════════════════════════════════════════════════════════
  Widget _selfAwareness(AppLocalizations l) {
    final alternatives = _list('healthy_alternatives_chart_suggests').map((e) => e.toString()).toList();
    final escapeChannels = _list('likely_escape_channels').map((e) => e.toString())
      .where((s) => !s.toLowerCase().contains('no specific')).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.psychology_alt_rounded, title: l.mnSelfAwarenessTitle, color: KColors.green),
      Row(children: [
        Expanded(child: _statTile(l.mnSelfAwarenessScore, _sc('self_awareness_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.mnEmotionalVocabulary, _sc('emotional_vocabulary_score'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.mnTherapyReadiness, _sc('therapy_readiness_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.mnJournalingBenefit, _sc('journaling_benefit_score'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _iconTile('💭', l.mnInnerDialogue, _titleCase(_str('inner_dialogue_quality')))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.mnAwarenessOfPatterns, _sc('awareness_of_patterns_score'))),
      ]),
      const SizedBox(height: 10),
      _riskTile(l.mnEscapePatternVuln, _sc('escape_pattern_vulnerability_score')),
      if (escapeChannels.isNotEmpty) ...[const SizedBox(height: 10), _chipBlock('👀', l.mnEscapeChannels, escapeChannels, KColors.orange)],
      if (alternatives.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('🌿', l.mnHealthyAlternatives, alternatives, KColors.green)],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  12 — THERAPY & SUPPORT FIT
  // ══════════════════════════════════════════════════════════════════
  Widget _therapyFit(AppLocalizations l) {
    final fits = _map('therapy_modality_fit_scores');
    final support = _list('support_network_activation_suggestions').map((e) => e.toString()).toList();
    if (fits.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.spa_rounded, title: l.mnTherapyFitTitle, color: KColors.purple),
      _sortedBars(fits),
      const SizedBox(height: 10),
      Wrap(spacing: 8, runSpacing: 8, children: [
        if (_str('peer_support_vs_professional_fit').isNotEmpty) _pill(_str('peer_support_vs_professional_fit'), KColors.blue),
      ]),
      if (_str('crisis_support_recommendation').isNotEmpty) ...[const SizedBox(height: 10),
        _pill('${l.mnCrisisSupportRec}: ${_titleCase(_str('crisis_support_recommendation'))}', KColors.blue)],
      if (support.isNotEmpty) ...[const SizedBox(height: 10), _chipBlock('🤝', l.mnSupportNetwork, support, KColors.green)],
      const SizedBox(height: 10),
      _statTile(l.mnSelfAdvocacy, _sc('self_advocacy_readiness_score')),
      _advanced(l, [
        if (_str('medication_receptivity_tendency').isNotEmpty) '${l.mnMedicationReceptivity}: ${_str('medication_receptivity_tendency')}',
      ]),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  13 — WELLNESS TIMELINE
  // ══════════════════════════════════════════════════════════════════
  Widget _wellnessTimeline(AppLocalizations l) {
    final trend = _list('yearly_mental_wellness_trend').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final peakYears = _list('peak_wellness_years').map((e) => e.toString()).toList();
    final careYears = _list('challenging_years').map((e) => e.toString()).toList();
    final therapyWindows = _list('recommended_therapy_windows').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final positiveWindows = _list('positive_transformation_windows').map((e) => e.toString()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.timeline_rounded, title: l.mnTimelineTitle, color: AppColors.gold),
      if (peakYears.isNotEmpty) _chipBlock('🌟', l.mnPeakWellnessYears, peakYears, KColors.green),
      if (careYears.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('🌱', l.mnExtraCareYears, careYears, KColors.blue)],
      if (positiveWindows.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('✨', l.mnTransformationWindows, positiveWindows, KColors.purple)],
      if (therapyWindows.isNotEmpty) ...[const SizedBox(height: 10),
        ...therapyWindows.map((m) => _timelineCard(l, l.mnTherapyWindow, m, KColors.purple))],
      if (trend.isNotEmpty) ...[const SizedBox(height: 10), _trendChart(trend)],
    ]);
  }

  Widget _timelineCard(AppLocalizations l, String title, Map<String, dynamic> m, Color col) {
    final window = m['window']?.toString() ?? '';
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
          if (window.isNotEmpty) Text(window, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w600)),
        ]),
        if (dasha.isNotEmpty) ...[const SizedBox(height: 4),
          Text('🪐 ${l.crViewDasha}: $dasha', style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700))],
        if (note.isNotEmpty) ...[const SizedBox(height: 6),
          Text(_cap(note), style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.4))],
      ]),
    );
  }

  Widget _trendChart(List<Map<String, dynamic>> trend) {
    return _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: trend.take(10).map((y) {
      final year = y['year']?.toString() ?? '';
      final wellness = (y['wellness'] is num ? y['wellness'] as num : null)?.toDouble() ?? 0;
      final peak = y['is_peak'] == true;
      final c = peak ? KColors.green : _col(wellness);
      return Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [
        SizedBox(width: 40, child: Text(year, style: const TextStyle(color: AppColors.ivory, fontSize: 11, fontWeight: FontWeight.w700))),
        Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(value: (wellness / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
        const SizedBox(width: 8),
        SizedBox(width: 30, child: Text(wellness.toStringAsFixed(0), textAlign: TextAlign.right, style: TextStyle(color: c, fontSize: 10.5, fontWeight: FontWeight.w700))),
      ]));
    }).toList()));
  }

  // ══════════════════════════════════════════════════════════════════
  //  14 — DAILY WELLNESS PRACTICES
  // ══════════════════════════════════════════════════════════════════
  Widget _dailyPractices(AppLocalizations l) {
    final morning = _list('morning_practice_recommendations').map((e) => e.toString()).toList();
    final evening = _list('evening_practice_recommendations').map((e) => e.toString()).toList();
    if (morning.isEmpty && evening.isEmpty && _str('breathwork_practice_fit').isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.wb_sunny_rounded, title: l.mnPracticesTitle, color: KColors.green),
      if (morning.isNotEmpty) _chipBlock('🌅', l.mnMorningPractices, morning, KColors.gold),
      if (evening.isNotEmpty) ...[const SizedBox(height: 6), _chipBlock('🌙', l.mnEveningPractices, evening, KColors.purple)],
      const SizedBox(height: 10),
      if (_str('breathwork_practice_fit').isNotEmpty) _practiceRow('🫁', l.mnBreathwork, _str('breathwork_practice_fit')),
      if (_str('movement_practice_fit').isNotEmpty) _practiceRow('🏃', l.mnMovement, _str('movement_practice_fit')),
      if (_str('nutrition_for_mental_health').isNotEmpty) _practiceRow('🥗', l.mnNutrition, _str('nutrition_for_mental_health')),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.mnNatureExposure, _sc('nature_exposure_need_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.mnDigitalDetox, _sc('digital_detox_need_score'))),
      ]),
    ]);
  }

  Widget _practiceRow(String emoji, String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Container(padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.card.withOpacity(0.4), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.06))),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(emoji, style: const TextStyle(fontSize: 16)), const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w700)),
          const SizedBox(height: 3),
          Text(value, style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.35)),
        ])),
      ])));

  // ══════════════════════════════════════════════════════════════════
  //  15 — IMPROVEMENT PLAN (remedies)
  // ══════════════════════════════════════════════════════════════════
  Widget _improvementPlan(AppLocalizations l) {
    final practical = _list('practical_solutions').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final planetary = _list('astrological_remedies').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.emoji_nature_rounded, title: l.mnImprovementTitle, color: KColors.green),
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
  //  16 — RELIABILITY
  // ══════════════════════════════════════════════════════════════════
  Widget _reliability(AppLocalizations l) {
    final raw = _sc('confidence_score');
    final pct = raw <= 1 ? raw * 100 : raw;
    final band = pct >= 75 ? l.crReliabilityHigh : pct >= 60 ? l.crReliabilityGood : l.crReliabilityModerate;
    final b = _map('confidence_breakdown');
    double layer(String k) { final v = b[k]; return v is num ? v.toDouble() * 100 : 0; }
    final layers = <List<Object>>[
      [l.mnLayerD1, layer('d1')],
      [l.mnLayerD9, layer('d9')],
      [l.mnLayerD30, layer('d30')],
      [l.mnLayerDasha, layer('dasha')],
      [l.mnLayerTransit, layer('transit')],
    ];
    final plain = _str('plain_statement');
    final disclaimer = _str('mental_wellness_disclaimer').isNotEmpty ? _str('mental_wellness_disclaimer') : _str('disclaimer');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.verified_user_rounded, title: l.mnReliabilityTitle, color: KColors.blue),
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
            SizedBox(width: 140, child: Text(la[0] as String, style: const TextStyle(color: AppColors.ivory, fontSize: 11.5))),
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
  //  17 — DISCUSS WITH AI
  // ══════════════════════════════════════════════════════════════════
  Widget _discussAi(AppLocalizations l) {
    final topics = <String>[l.mnTopicResilience, l.mnTopicCoping, l.mnTopicSleep, l.mnTopicBurnout, l.mnTopicTherapy, l.mnTopicPractices, l.mnTopicTiming, l.mnTopicSupport];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.forum_rounded, title: l.crDiscussAi, color: AppColors.gold),
      ReportPdfButton(path: 'report/mental_stress/${widget.chartId}', filename: 'report-${widget.chartName}'),
      const SizedBox(height: 10),
      ReportAiChatCta(domainKey: 'mental_stress', label: 'Mental Stress', emoji: '🧠'),
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
        Text(name, style: const TextStyle(color: AppColors.ivory, fontSize: 11, fontWeight: FontWeight.w700)),
        const Text('OPEN ↗', style: TextStyle(color: AppColors.smoke, fontSize: 7, letterSpacing: 1)),
      ])))));

  void _copyTopic(String topic) {
    final q = '$topic — based on my Vedic mental-wellness report for ${widget.chartName}.\n\n${_buildPrompt(_data!)}';
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

  Widget _iconTile(String emoji, String label, String value, {Color? color}) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: AppColors.card.withOpacity(0.5), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.06))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(emoji, style: const TextStyle(fontSize: 17)), const SizedBox(height: 6),
      Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontWeight: FontWeight.w600)),
      Text(value, style: TextStyle(color: color ?? AppColors.ivory, fontSize: 12.5, fontWeight: FontWeight.w800), maxLines: 2, overflow: TextOverflow.ellipsis),
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

  /// Gentle "sensitivity" tile — same visual language as a risk tile but
  /// used only where softer wording is warranted (mood/anxiety patterns).
  Widget _riskTile(String label, double score) {
    final c = _gentleColor(score);
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

  /// Softer color scale for sensitivity/vulnerability metrics — reserves red
  /// for genuinely high values so moderate scores don't read as alarming.
  Color _gentleColor(double s) {
    if (s >= 60) return KColors.red;
    if (s >= 40) return KColors.orange;
    if (s >= 20) return KColors.yellow;
    return KColors.green;
  }

  String _statusLabel(double s, AppLocalizations l) {
    if (s >= 75) return l.mnStatusThriving;
    if (s >= 60) return l.mnStatusSteady;
    if (s >= 45) return l.mnStatusBuildingStrength;
    if (s >= 30) return l.mnStatusNeedsGentleCare;
    return l.mnStatusReachOut;
  }
  String _cap(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
  String _titleCase(String s) => s.replaceAll('_', ' ').replaceAll('-', ' ').split(' ')
    .where((w) => w.isNotEmpty).map((w) => '${w[0].toUpperCase()}${w.substring(1)}').join(' ');

  // ── AI prompt / launch (unchanged behaviour) ──
  String _buildPrompt(Map<String, dynamic> d) {
    final name = widget.chartName;
    final resilience = d['mental_resilience_score'] ?? '?';
    final verdict = d['overall_mental_wellness_verdict'] ?? '';
    final constitution = d['emotional_constitution'] ?? '';
    final jsonStr = const JsonEncoder.withIndent('  ').convert(d);
    return '''You are a warm, supportive Vedic wellness companion. Analyze this mental & emotional wellness report for $name and provide gentle, encouraging, actionable insights. Never diagnose — this is astrological tendency guidance, not a clinical assessment.

Key highlights:
- Mental resilience: $resilience/100
- Emotional constitution: $constitution
- Overall wellness verdict: $verdict

Full report data (JSON):
$jsonStr

Please explain the key findings in warm, simple language, celebrate strengths first, and suggest gentle, practical daily-wellness next steps.''';
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
