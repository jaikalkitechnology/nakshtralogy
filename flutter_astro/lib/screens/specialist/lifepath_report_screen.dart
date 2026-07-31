import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../../utils/kundli_names.dart';
import '../kundli/widgets/kundli_ui.dart';

/// Life Path & Luck report — premium AI destiny-coach redesign.
///
/// Presentation only. Loads the `life_path` specialist
/// (`runSpecialist('life_path')`) unchanged and re-presents it; every score,
/// karaka, yoga, timing window, remedy and confidence value comes straight
/// from the engine.
class LifePathReportScreen extends StatefulWidget {
  final String chartId, chartName;
  final Map<String, dynamic>? preloadedData;
  const LifePathReportScreen({super.key, required this.chartId, required this.chartName, this.preloadedData});
  @override
  State<LifePathReportScreen> createState() => _LifePathReportState();
}

class _LifePathReportState extends State<LifePathReportScreen> {
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
      final resp = await _api.runSpecialist('life_path', widget.chartId);
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
          Text(l.lpSubtitle, style: const TextStyle(color: AppColors.gold, fontSize: 10)),
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
      gap, _soulPath(l),        // 2
      gap, _karakaTable(l),     // 3
      gap, _verification(l),    // 4
      gap, _yogas(l),           // 5
      gap, _purposeFame(l),     // 6
      gap, _timeline(l),        // 7
      gap, _milestones(l),      // 8
      gap, _destinyFreeWill(l), // 9
      gap, _karmicLessons(l),   // 10
      gap, _spiritualPath(l),   // 11
      gap, _difficulty(l),      // 12
      gap, _blessings(l),       // 13
      gap, _improvementPlan(l), // 14
      gap, _roadmap(l),         // 15
      gap, _reliability(l),     // 16
      gap, _discussAi(l),       // 17
    ];
  }

  Widget _breadcrumb(AppLocalizations l) => Row(children: [
    Text(l.crCrumbHome, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Text(l.crCrumbReports, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Flexible(child: Text(l.lpTitle, style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
  ]);

  // ══════════════════════════════════════════════════════════════════
  //  1 — LIFE PATH SNAPSHOT
  // ══════════════════════════════════════════════════════════════════
  Widget _snapshot(AppLocalizations l) {
    final dharma = _sc('dharma_clarity_score');
    final fortune = _sc('fortune_baseline_score');
    final coherence = _sc('life_path_coherence_score');
    final fulfillment = _sc('life_fulfillment_potential_pct');
    final momentum = _sc('karmic_momentum_score');
    final overall = ((dharma + fortune + coherence + fulfillment + momentum) / 5).clamp(0, 100).toDouble();
    final col = _col(overall);
    final verdict = _str('overall_life_path_verdict');
    final archetype = _titleCase(_str('life_path_archetype'));
    final domain = _titleCase(_str('primary_life_purpose_domain'));
    final summary = archetype.isNotEmpty
        ? l.lpHeroSummary(archetype, domain, fulfillment.toStringAsFixed(0))
        : _str('plain_statement');
    final gauges = <List<Object>>[
      [l.lpGaugeDharma, dharma],
      [l.lpGaugeFortune, fortune],
      [l.lpGaugeCoherence, coherence],
      [l.lpGaugeFulfillment, fulfillment],
      [l.lpGaugeMomentum, momentum],
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [col.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
        borderRadius: BorderRadius.circular(22), border: Border.all(color: col.withOpacity(0.3)),
      ),
      child: Column(children: [
        Text(l.lpSnapshotHeader.toUpperCase(), style: const TextStyle(color: AppColors.smoke, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
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
          children: gauges.map((g) => _miniGauge(g[0] as String, g[1] is num ? (g[0] as String, g[1] as num).toDouble() : 0.0)).toList()),
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
    if (_map('core_life_path_theme')['is_gift'] == true) out.add(l.lpChipRareGift);
    if (_sc('free_will_leverage_percentage') >= 35) out.add(l.lpChipFreeWillStrong);
    if (_str('effort_vs_grace_ratio').toLowerCase().contains('grace')) out.add(l.lpChipGraceSupported);
    if (_str('life_test_difficulty_level').toLowerCase() == 'light') out.add(l.lpChipLightKarma);
    if (_sc('fame_recognition_potential_score') >= 60) out.add(l.lpChipRecognitionPotential);
    if (_sc('spiritual_inclination_score') >= 55) out.add(l.lpChipSpiritualPath);
    if (_list('primary_life_blessings').isNotEmpty) out.add(l.lpChipBlessed);
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
  //  2 — YOUR SOUL PATH
  // ══════════════════════════════════════════════════════════════════
  Widget _soulPath(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    final archetype = _titleCase(_str('life_path_archetype'));
    if (archetype.isEmpty) return const SizedBox.shrink();
    final soul = KundliNames.planet(_str('atmakaraka_planet'), loc);
    final career = KundliNames.planet(_str('amatyakaraka_planet'), loc);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.self_improvement_rounded, title: l.lpSoulPathTitle, color: KColors.purple),
      Container(padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [KColors.purple.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
          borderRadius: BorderRadius.circular(18), border: Border.all(color: KColors.purple.withOpacity(0.3))),
        child: Column(children: [
          const Text('🌟', style: TextStyle(fontSize: 34)),
          const SizedBox(height: 8),
          Text(archetype, style: const TextStyle(color: AppColors.ivory, fontSize: 20, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
          if (_str('atmakaraka_focus').isNotEmpty) ...[const SizedBox(height: 8),
            Text(_cap(_str('atmakaraka_focus')), style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.5), textAlign: TextAlign.center)],
        ])),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _iconTile('🕉️', l.lpSoulPlanet, soul)),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('💼', l.lpCareerPlanet, career)),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('📖', l.lpSoulClarity, _titleCase(_str('soul_purpose_clarity')))),
      ]),
      _advanced(l, [
        '${l.lpLifeChapter}: ${_titleCase(_str('current_life_chapter_theme'))}',
        '${l.lpPrimaryDomain}: ${_titleCase(_str('primary_life_purpose_domain'))}',
      ]),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  3 — YOUR DHARMA PLANETS
  // ══════════════════════════════════════════════════════════════════
  Widget _karakaTable(AppLocalizations l) {
    final map = _map('karaka_dharma_table');
    if (map.isEmpty) return const SizedBox.shrink();
    final loc = Localizations.localeOf(context);
    final entries = map.entries.where((e) => e.value is Map).toList()
      ..sort((a, b) => (((b.value as Map)['strength'] is num ? (b.value as Map)['strength'] as num : null) ?? 0).compareTo(((a.value as Map)['strength'] is num ? (a.value as Map)['strength'] as num : null) ?? 0));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.insights_rounded, title: l.lpKarakaTitle, subtitle: l.lpKarakaSubtitle, color: KColors.purple),
      _card(child: Column(children: entries.map((e) {
        final v = ((e.value as Map)['strength'] is num ? (e.value as Map)['strength'] as num : null)?.toDouble() ?? 0;
        final c = _col(v);
        return Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(children: [
          SizedBox(width: 80, child: Text(KundliNames.planet(e.key, loc), style: TextStyle(color: c, fontSize: 11.5, fontWeight: FontWeight.w700))),
          Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(value: (v / 100).clamp(0, 1), minHeight: 6, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
          const SizedBox(width: 8),
          SizedBox(width: 30, child: Text(v.toStringAsFixed(0), textAlign: TextAlign.right, style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w800))),
        ]));
      }).toList())),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  4 — VERIFIED ACROSS CHARTS (D9 / D60)
  // ══════════════════════════════════════════════════════════════════
  Widget _verification(AppLocalizations l) {
    final d9 = _map('d9_validation');
    final d60 = _map('d60_validation');
    if (d9.isEmpty && d60.isEmpty) return const SizedBox.shrink();
    final d9Score = (d9['d9_soul_alignment_score'] is num ? d9['d9_soul_alignment_score'] as num : null)?.toDouble() ?? 0;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.verified_rounded, title: l.lpVerificationTitle, color: KColors.green),
      if (d9.isNotEmpty) _chartCard(l, l.lpD9Label, d9Score, l.lpD9Explain(_titleCase(d9['soul_evolution_stage']?.toString() ?? '')), [
        '${l.lpD9JupiterDignity}: ${d9['d9_jupiter_dignity'] ?? ''}',
        '${l.lpD9DharmaMultiplier}: ${(d9['d9_dharma_multiplier'] is num ? d9['d9_dharma_multiplier'] as num : null)?.toStringAsFixed(2) ?? ''}',
      ]),
      if (d60.isNotEmpty) Container(
        margin: const EdgeInsets.only(top: 4), padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: KColors.blue.withOpacity(0.06), borderRadius: BorderRadius.circular(16), border: Border.all(color: KColors.blue.withOpacity(0.2))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l.lpD60Label, style: const TextStyle(color: KColors.blue, fontSize: 13, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(_cap(d60['d60_past_life_signature']?.toString() ?? ''), style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.4)),
          _advanced(l, [
            '${l.lpKarmaType}: ${_titleCase(d60['past_life_karma_type']?.toString() ?? '')}',
            '${l.lpKetuMastery}: ${d60['ketu_past_life_mastery_area'] ?? ''}',
            '${l.lpRahuGrowthDir}: ${d60['rahu_future_growth_direction'] ?? ''}',
          ]),
        ])),
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
  //  5 — FORTUNE YOGAS & LUCK BLOCKS
  // ══════════════════════════════════════════════════════════════════
  Widget _yogas(AppLocalizations l) {
    final fortune = _list('active_fortune_yogas').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final blocks = _list('active_luck_blocks').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    if (fortune.isEmpty && blocks.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.auto_awesome_rounded, title: l.lpYogasTitle, color: AppColors.gold),
      Row(children: [
        Expanded(child: _statTile(l.lpFortuneBoost, _sc('total_fortune_boost_score'))),
        const SizedBox(width: 10),
        Expanded(child: _riskTile(l.lpLuckDrain, _sc('total_luck_drain_score'))),
      ]),
      const SizedBox(height: 10),
      if (fortune.isNotEmpty) ...[
        _catLabel('🍀', l.lpFortuneBoosters, KColors.green),
        ...fortune.take(8).map((m) => _yogaRow(m['name']?.toString() ?? '', (m['score'] is num ? m['score'] as num : null)?.toDouble() ?? 0, KColors.green)),
        const SizedBox(height: 6),
      ],
      if (blocks.isNotEmpty) ...[
        _catLabel('⛔', l.lpLuckBlocks, KColors.orange),
        ...blocks.map((m) => _yogaRow(m['name']?.toString() ?? '', (m['score'] is num ? m['score'] as num : null)?.toDouble() ?? 0, KColors.orange)),
      ],
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
  //  6 — PURPOSE DOMAINS & FAME
  // ══════════════════════════════════════════════════════════════════
  Widget _purposeFame(AppLocalizations l) {
    final domain = _str('primary_life_purpose_domain').toLowerCase();
    final rows = <List<Object>>[
      [l.lpDomainLeadership, _sc('leadership_path_indicator_score'), 'leadership'],
      [l.lpDomainWisdom, _sc('wisdom_teaching_path_score'), 'wisdom'],
      [l.lpDomainService, _sc('service_path_indicator_score'), 'service'],
      [l.lpDomainHealing, _sc('healing_path_indicator_score'), 'healing'],
      [l.lpDomainCreative, _sc('creative_expression_path_score'), 'creative'],
    ];
    rows.sort((a, b) => (b[1] is num ? (b[1] as num).toDouble() : 0.0).compareTo(a[1] is num ? (a[1] as num).toDouble() : 0.0));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.explore_rounded, title: l.lpPurposeTitle, color: KColors.blue),
      ...rows.map((r) {
        final score = r[1] as double;
        final tag = r[2] as String;
        final isBest = domain.contains(tag);
        final col = isBest ? KColors.green : _col(score);
        return Container(
          margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: col.withOpacity(isBest ? 0.10 : 0.05), borderRadius: BorderRadius.circular(14),
            border: Border.all(color: col.withOpacity(isBest ? 0.4 : 0.18))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(r[0] as String, style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w700))),
              if (isBest) Container(margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(color: KColors.green.withOpacity(0.18), borderRadius: BorderRadius.circular(6)),
                child: Text('⭐ ${l.lpPrimaryDomainBadge}', style: const TextStyle(color: KColors.green, fontSize: 8.5, fontWeight: FontWeight.w800))),
              Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: col, fontSize: 15, fontWeight: FontWeight.w800)),
            ]),
            const SizedBox(height: 7),
            ClipRRect(borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(value: (score / 100).clamp(0, 1), minHeight: 6, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(col))),
          ]),
        );
      }),
      const SizedBox(height: 6),
      Row(children: [
        Expanded(child: _statTile(l.lpFameRecognition, _sc('fame_recognition_potential_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.lpSocialInfluence, _sc('social_influence_capacity'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        if (_str('recognition_domain').isNotEmpty) Expanded(child: _iconTile('🏆', l.lpRecognitionDomain, _titleCase(_str('recognition_domain')))),
        if (_str('recognition_domain').isNotEmpty) const SizedBox(width: 10),
        if (_str('public_image_tendency').isNotEmpty) Expanded(child: _iconTile('🎭', l.lpPublicImage, _titleCase(_str('public_image_tendency')))),
      ]),
      _advanced(l, ['${l.lpHistoricalImpact}: ${_sc('historical_impact_potential_score').toStringAsFixed(0)}']),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  7 — FORTUNE & LIFE TIMELINE
  // ══════════════════════════════════════════════════════════════════
  Widget _timeline(AppLocalizations l) {
    final trend = _list('yearly_fortune_trend').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final peakYears = _list('peak_fortune_years').map((e) => e.toString()).toList();
    final challYears = _list('challenging_fortune_years').map((e) => e.toString()).toList();
    final golden = _list('golden_windows').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final transform = _list('transformation_windows').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.timeline_rounded, title: l.lpTimelineTitle, color: AppColors.gold),
      Row(children: [
        Expanded(child: _iconTile('📖', l.lpLifeChapter, _titleCase(_str('current_life_chapter_theme')))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.lpCurrentPhase, _sc('current_fortune_phase_score'))),
      ]),
      const SizedBox(height: 10),
      Wrap(spacing: 8, runSpacing: 8, children: [
        if (_str('jupiter_return_status').toLowerCase() != 'not-active') _pill('${l.lpJupiterReturn}: ${_titleCase(_str('jupiter_return_status'))}', KColors.blue),
        if (_str('saturn_return_status').toLowerCase() != 'not-active') _pill('${l.lpSaturnReturn}: ${_titleCase(_str('saturn_return_status'))}', KColors.purple),
        if (_str('sade_sati_status').toLowerCase() != 'not-active') _pill('${l.lpSadeSati}: ${_titleCase(_str('sade_sati_status'))}', KColors.orange),
      ]),
      if (golden.isNotEmpty) ...[const SizedBox(height: 10), ...golden.map((m) => _timelineCard(l, l.lpGoldenWindow, m, KColors.gold))],
      if (transform.isNotEmpty) ...[...transform.map((m) => _timelineCard(l, l.lpTransformationWindow, m, KColors.purple))],
      if (peakYears.isNotEmpty) ...[const SizedBox(height: 6), _chipBlock('🌟', l.lpPeakYears, peakYears, KColors.green)],
      if (challYears.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('⚠️', l.lpChallengingYears, challYears, KColors.orange)],
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
    return _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: trend.take(12).map((y) {
      final year = y['year']?.toString() ?? '';
      final fortune = (y['fortune'] is num ? y['fortune'] as num : null)?.toDouble() ?? 0;
      final peak = y['is_peak'] == true;
      final challenging = y['is_challenging'] == true;
      final c = peak ? KColors.green : challenging ? KColors.red : _col(fortune);
      return Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [
        SizedBox(width: 40, child: Text(year, style: const TextStyle(color: AppColors.ivory, fontSize: 11, fontWeight: FontWeight.w700))),
        Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(value: (fortune / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
        const SizedBox(width: 8),
        SizedBox(width: 30, child: Text(fortune.toStringAsFixed(0), textAlign: TextAlign.right, style: TextStyle(color: c, fontSize: 10.5, fontWeight: FontWeight.w700))),
      ]));
    }).toList()));
  }

  // ══════════════════════════════════════════════════════════════════
  //  8 — MAJOR MILESTONES & TURNING POINTS
  // ══════════════════════════════════════════════════════════════════
  Widget _milestones(AppLocalizations l) {
    final milestones = _list('major_milestones_expected').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final first = _map('first_major_turning_point');
    final midlife = _map('midlife_transformation_window');
    final late = _map('late_life_fulfillment_window');
    if (milestones.isEmpty && first.isEmpty && midlife.isEmpty && late.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.flag_rounded, title: l.lpMilestonesTitle, color: KColors.blue),
      if (first.isNotEmpty) _milestoneCard(l, l.lpFirstTurningPoint, first, KColors.blue),
      if (midlife.isNotEmpty) _milestoneCard(l, l.lpMidlifeTransform, midlife, KColors.purple),
      if (late.isNotEmpty) _milestoneCard(l, l.lpLateLifeFulfillment, late, KColors.gold),
      if (milestones.isNotEmpty) ...[
        const SizedBox(height: 4),
        ...milestones.map((m) => _milestoneCard(l, l.lpDharmicMilestone(m['age']?.toString() ?? '?'), m, KColors.green)),
      ],
    ]);
  }

  Widget _milestoneCard(AppLocalizations l, String title, Map<String, dynamic> m, Color col) {
    final age = m['age']?.toString() ?? '';
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
          if (age.isNotEmpty) Text(l.lpAgeLabel(age), style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontWeight: FontWeight.w600)),
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
  //  9 — DESTINY VS FREE WILL
  // ══════════════════════════════════════════════════════════════════
  Widget _destinyFreeWill(AppLocalizations l) {
    final destiny = _sc('destiny_weight_percentage');
    final freeWill = _sc('free_will_leverage_percentage');
    if (destiny == 0 && freeWill == 0) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.balance_rounded, title: l.lpDestinyTitle, color: KColors.purple),
      Row(children: [
        Expanded(child: _dualCard(l.lpDestinyStat, destiny, AppColors.lavender)),
        const SizedBox(width: 10),
        Expanded(child: _dualCard(l.lpFreeWillStat, freeWill, KColors.green)),
      ]),
      if (_str('destiny_vs_free_will_insight').isNotEmpty) ...[const SizedBox(height: 10),
        _card(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('🤖', style: TextStyle(fontSize: 14)), const SizedBox(width: 9),
          Expanded(child: Text(_cap(_str('destiny_vs_free_will_insight')), style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.5))),
        ]))],
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.lpFateStrength, _sc('fate_signature_strength_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.lpSelfCreation, _sc('self_creation_capacity_score'))),
      ]),
      if (_str('effort_vs_grace_ratio').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 10),
        child: _pill('${l.lpEffortGrace}: ${_titleCase(_str('effort_vs_grace_ratio'))}', KColors.gold)),
    ]);
  }

  Widget _dualCard(String label, double pct, Color c) => Container(padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: c.withOpacity(0.08), borderRadius: BorderRadius.circular(16), border: Border.all(color: c.withOpacity(0.3))),
    child: Column(children: [
      Text(label, style: TextStyle(color: c, fontSize: 10.5, fontWeight: FontWeight.w700)),
      const SizedBox(height: 6),
      Text('${pct.toStringAsFixed(0)}%', style: TextStyle(color: c, fontSize: 26, fontWeight: FontWeight.w800)),
    ]));

  // ══════════════════════════════════════════════════════════════════
  //  10 — KARMIC LESSONS
  // ══════════════════════════════════════════════════════════════════
  Widget _karmicLessons(AppLocalizations l) {
    final soulContract = _list('soul_contract_areas').map((e) => e.toString()).toList();
    final experience = _list('what_soul_came_to_experience').map((e) => e.toString()).toList();
    final master = _list('what_soul_came_to_master').map((e) => e.toString()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.school_rounded, title: l.lpKarmicTitle, color: KColors.blue),
      if (_str('primary_karmic_lesson_theme').isNotEmpty)
        _card(child: Text(_cap(_str('primary_karmic_lesson_theme')), style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, height: 1.5))),
      const SizedBox(height: 10),
      styleRow(l.lpRahuGrowthLabel, _str('rahu_growth_challenge')),
      styleRow(l.lpKetuSurrenderLabel, _str('ketu_surrender_theme')),
      styleRow(l.lpSaturnLessonLabel, _str('saturn_discipline_lesson')),
      const SizedBox(height: 6),
      Row(children: [
        Expanded(child: _iconTile('🎓', l.lpTestDifficulty, _titleCase(_str('life_test_difficulty_level')))),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('📚', l.lpLessonsInProgress, _sc('lessons_in_progress_count').toStringAsFixed(0))),
      ]),
      if (soulContract.isNotEmpty) ...[const SizedBox(height: 10), _chipBlock('📜', l.lpSoulContract, soulContract, KColors.purple)],
      if (experience.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('✨', l.lpSoulExperience, experience, KColors.blue)],
      if (master.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('🏅', l.lpSoulMastery, master, KColors.gold)],
    ]);
  }

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

  // ══════════════════════════════════════════════════════════════════
  //  11 — SPIRITUAL PATH
  // ══════════════════════════════════════════════════════════════════
  Widget _spiritualPath(AppLocalizations l) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.spa_rounded, title: l.lpSpiritualTitle, color: KColors.purple),
      Row(children: [
        Expanded(child: _statTile(l.lpSpiritualInclination, _sc('spiritual_inclination_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.lpMeditationReceptivity, _sc('meditation_receptivity_score'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.lpTeacherKarma, _sc('teacher_guru_karma_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.lpPilgrimageBenefit, _sc('pilgrimage_yatra_benefit_score'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.lpSelfRealization, _sc('self_realization_potential_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.lpDivineConnection, _sc('divine_connection_capacity_score'))),
      ]),
      if (_str('religious_tradition_affinity').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 10),
        child: _pill('${l.lpTraditionAffinity}: ${_titleCase(_str('religious_tradition_affinity'))}', KColors.purple)),
      _advanced(l, [
        '${l.lpIntuitionStrength}: ${_sc('intuition_strength_score').toStringAsFixed(0)}',
        '${l.lpMantraEfficacy}: ${_sc('prayer_mantra_efficacy_score').toStringAsFixed(0)}',
        '${l.lpInnerGuidance}: ${_sc('inner_guidance_trust_score').toStringAsFixed(0)}',
        '${l.lpPropheticDreams}: ${_sc('prophetic_dream_sensitivity_score').toStringAsFixed(0)}',
      ]),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  12 — LIFE DIFFICULTY & CHALLENGES
  // ══════════════════════════════════════════════════════════════════
  Widget _difficulty(AppLocalizations l) {
    final challenges = _list('primary_life_challenges').map((e) => e.toString())
        .where((s) => !s.toLowerCase().contains('standard life-stressors')).toList();
    final drains = _list('chronic_fortune_drains').map((e) => e.toString())
        .where((s) => !s.toLowerCase().contains('no structural')).toList();
    final regrets = _list('regret_vulnerability_areas').map((e) => e.toString())
        .where((s) => !s.toLowerCase().contains('no strong')).toList();
    final flags = _list('life_direction_red_flags').map((e) => e.toString())
        .where((s) => !s.toLowerCase().contains('standard awareness')).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.shield_outlined, title: l.lpDifficultyTitle, color: KColors.orange),
      Row(children: [
        Expanded(child: _riskTile(l.lpEarlyLife, _sc('early_life_difficulty_score'))),
        const SizedBox(width: 10),
        Expanded(child: _riskTile(l.lpMidlife, _sc('midlife_difficulty_score'))),
        const SizedBox(width: 10),
        Expanded(child: _riskTile(l.lpLateLife, _sc('late_life_difficulty_score'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.lpStruggleToSuccess, _sc('struggle_to_success_karma_score'))),
        const SizedBox(width: 10),
        Expanded(child: _riskTile(l.lpUnlivedLifeRisk, _sc('unlived_life_risk_score'))),
      ]),
      if (challenges.isNotEmpty) ...[const SizedBox(height: 10), _chipBlock('⚠️', l.lpChallenges, challenges, KColors.orange)],
      if (drains.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('🔻', l.lpFortuneDrains, drains, KColors.red)],
      if (regrets.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('💭', l.lpRegretAreas, regrets, KColors.blue)],
      if (flags.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('🚩', l.lpRedFlags, flags, KColors.red)],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  13 — BLESSINGS & CORE LIFE THEME
  // ══════════════════════════════════════════════════════════════════
  Widget _blessings(AppLocalizations l) {
    final theme = _map('core_life_path_theme');
    final blessings = _list('primary_life_blessings').map((e) => e.toString()).toList();
    final priorities = _list('fulfillment_priority_areas').map((e) => e.toString()).toList();
    if (theme.isEmpty && blessings.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.emoji_events_rounded, title: l.lpBlessingsTitle, color: KColors.gold),
      if (theme.isNotEmpty) Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [KColors.gold.withOpacity(0.16), AppColors.card.withOpacity(0.4)]),
          borderRadius: BorderRadius.circular(18), border: Border.all(color: KColors.gold.withOpacity(0.3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(theme['is_gift'] == true ? '🎁' : '🔑', style: const TextStyle(fontSize: 20)), const SizedBox(width: 8),
            Expanded(child: Text(theme['primary_theme']?.toString() ?? '', style: const TextStyle(color: AppColors.gold, fontSize: 14.5, fontWeight: FontWeight.w800))),
          ]),
          if (theme['explanation'] != null) ...[const SizedBox(height: 8),
            Text(theme['explanation'].toString(), style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.45))],
          if (theme['action_direction'] != null) ...[const SizedBox(height: 8),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('✓ ', style: TextStyle(color: KColors.green, fontWeight: FontWeight.w800)),
              Expanded(child: Text(theme['action_direction'].toString(), style: const TextStyle(color: KColors.green, fontSize: 11.5, height: 1.4))),
            ])],
          _advanced(l, [if (theme['karmic_root'] != null) '${l.lpKarmicRoot}: ${theme['karmic_root']}']),
        ])),
      if (blessings.isNotEmpty) ...[const SizedBox(height: 10), _chipBlock('✨', l.lpBlessingsList, blessings, KColors.gold)],
      if (priorities.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('🎯', l.lpFulfillmentPriorities, priorities, KColors.blue)],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  14 — IMPROVEMENT PLAN (remedies)
  // ══════════════════════════════════════════════════════════════════
  Widget _improvementPlan(AppLocalizations l) {
    final practical = _list('practical_solutions').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final planetary = _list('astrological_remedies').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.healing_rounded, title: l.lpImprovementTitle, color: KColors.green),
      if (practical.isNotEmpty) ...[
        _catLabel('🎯', l.crCatPractical, KColors.blue),
        ...practical.map((m) => _remedyCard(_titleCase(m['category']?.toString() ?? ''), m['advice']?.toString() ?? '', KColors.blue)),
      ],
      if (planetary.isNotEmpty) ...[
        const SizedBox(height: 6),
        _catLabel('🕉️', l.crCatPlanetary, KColors.purple),
        ...planetary.map((m) => _remedyCard(m['deity']?.toString() ?? '', m['remedy']?.toString() ?? '', KColors.purple)),
      ],
      if (_list('preventive_dharma_priorities').isNotEmpty) ...[const SizedBox(height: 6),
        _chipBlock('🛡️', l.lpDharmaPriorities, _list('preventive_dharma_priorities').map((e) => e.toString()).toList(), KColors.gold)],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  15 — YOUR DESTINY ROADMAP
  // ══════════════════════════════════════════════════════════════════
  Widget _roadmap(AppLocalizations l) {
    final verdict = _titleCase(_str('overall_life_path_verdict'));
    final strategy = _str('destiny_fulfillment_strategy');
    final focus = _str('recommended_life_focus_next_12_months');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.rocket_launch_rounded, title: l.lpRoadmapTitle, color: KColors.gold),
      if (verdict.isNotEmpty) Container(padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [KColors.gold.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
          borderRadius: BorderRadius.circular(18), border: Border.all(color: KColors.gold.withOpacity(0.3))),
        child: Column(children: [
          const Text('🏆', style: TextStyle(fontSize: 34)),
          const SizedBox(height: 8),
          Text(verdict, style: const TextStyle(color: AppColors.ivory, fontSize: 20, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
          if (strategy.isNotEmpty) ...[const SizedBox(height: 8),
            Text('${l.lpStrategy}: ${_titleCase(strategy)}', style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.5), textAlign: TextAlign.center)],
        ])),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.lpFulfillmentPotential, _sc('life_fulfillment_potential_pct'))),
        const SizedBox(width: 10),
        if (focus.isNotEmpty) Expanded(child: _iconTile('🧭', l.lpNext12Focus, _titleCase(focus))),
      ]),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  16 — PREDICTION RELIABILITY
  // ══════════════════════════════════════════════════════════════════
  Widget _reliability(AppLocalizations l) {
    final raw = _sc('confidence_score');
    final pct = raw <= 1 ? raw * 100 : raw;
    final band = pct >= 75 ? l.crReliabilityHigh : pct >= 60 ? l.crReliabilityGood : l.crReliabilityModerate;
    final b = _map('confidence_breakdown');
    double layer(String k) { final v = b[k]; return v is num ? v.toDouble() * 100 : 0; }
    final layers = <List<Object>>[
      [l.lpLayerD1, layer('d1')],
      [l.lpLayerD9, layer('d9')],
      [l.lpLayerD60, layer('d60')],
      [l.lpLayerDasha, layer('dasha')],
      [l.lpLayerTransit, layer('transit')],
    ];
    final plain = _str('plain_statement');
    final disclaimer = _str('life_path_disclaimer').isNotEmpty ? _str('life_path_disclaimer') : _str('disclaimer');
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
  //  17 — DISCUSS WITH AI
  // ══════════════════════════════════════════════════════════════════
  Widget _discussAi(AppLocalizations l) {
    final topics = <String>[l.lpTopicPurpose, l.lpTopicFortune, l.lpTopicKarma, l.lpTopicMilestones, l.lpTopicDestiny, l.lpTopicSpiritual, l.lpTopicChallenges, l.lpTopicTiming];
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
    final q = '$topic — based on my Vedic life-path & luck report for ${widget.chartName}.\n\n${_buildPrompt(_data!)}';
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
    final fulfillment = d['life_fulfillment_potential_pct'] ?? '?';
    final archetype = d['life_path_archetype'] ?? '';
    final verdict = d['overall_life_path_verdict'] ?? '';
    final jsonStr = const JsonEncoder.withIndent('  ').convert(d);
    return '''You are a Vedic life-path and destiny advisor. Analyze this life-path & luck report for $name and provide actionable insights.

Key highlights:
- Life fulfillment potential: $fulfillment%
- Life-path archetype: $archetype
- Overall verdict: $verdict

Full report data (JSON):
$jsonStr

Please explain the key findings in simple language, highlight the most important timing windows, and suggest practical next steps toward living out this life path.''';
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
