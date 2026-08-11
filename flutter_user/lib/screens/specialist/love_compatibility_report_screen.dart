import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../kundli/widgets/kundli_ui.dart';

/// Love Compatibility report — premium AI love-coach redesign.
///
/// Presentation only. Receives the already-loaded `love_compatibility`
/// specialist result (`runLoveCompatibility`, a 2-chart Moola-Dasha
/// analysis) and re-presents it; every score, synastry dimension, dasha
/// window, challenge, remedy and confidence value comes straight from the
/// engine. Constructor unchanged so the multi-chart picker does not need
/// to change.
class LoveCompatibilityReportScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final List<String> participants;
  const LoveCompatibilityReportScreen({super.key, required this.data, required this.participants});
  @override
  State<LoveCompatibilityReportScreen> createState() => _LoveCompatibilityReportState();
}

class _LoveCompatibilityReportState extends State<LoveCompatibilityReportScreen> {
  Map<String, dynamic> get _data => widget.data;

  // ── typed accessors (type-checked, never throw on unexpected shapes) ──
  double _sc(String k) { final v = _data[k]; return v is num ? v.toDouble() : 0; }
  double _scOf(Map m, String k) { final v = m[k]; return v is num ? v.toDouble() : 0; }
  String _str(String k) { final v = _data[k]; return (v == null || v is List || v is Map) ? '' : v.toString(); }
  String _strOf(Map m, String k) { final v = m[k]; return (v == null || v is List || v is Map) ? '' : v.toString(); }
  Map<String, dynamic> _map(String k) { final v = _data[k]; return v is Map ? v.cast<String, dynamic>() : {}; }
  Map<String, dynamic> _mapOf(Map m, String k) { final v = m[k]; return v is Map ? v.cast<String, dynamic>() : {}; }
  List _listOf(Map m, String k) { final v = m[k]; return v is List ? v : const []; }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.ivory), onPressed: () => Navigator.pop(context)),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(widget.participants.join(' & '), style: const TextStyle(color: AppColors.ivory, fontSize: 15, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(l.lcSubtitle, style: const TextStyle(color: AppColors.gold, fontSize: 10)),
        ]),
      ),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 40), children: _sections(l)),
    );
  }

  List<Widget> _sections(AppLocalizations l) {
    const gap = SizedBox(height: 18);
    return [
      _breadcrumb(l),
      const SizedBox(height: 10),
      _snapshot(l),          // 1
      gap, _partners(l),        // 2
      gap, _attraction(l),      // 3
      gap, _emotional(l),       // 4
      gap, _mental(l),          // 5
      gap, _passion(l),         // 6
      gap, _longterm(l),        // 7
      gap, _karmic(l),          // 8
      gap, _challenges(l),      // 9
      gap, _timing(l),          // 10
      gap, _dynamics(l),        // 11
      gap, _remedies(l),        // 12
      gap, _summary(l),         // 13
      gap, _reliability(l),     // 14
      gap, _discussAi(l),       // 15
    ];
  }

  Widget _breadcrumb(AppLocalizations l) => Row(children: [
    Text(l.crCrumbHome, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Text(l.crCrumbReports, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Flexible(child: Text(l.lcTitle, style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
  ]);

  // ══════════════════════════════════════════════════════════════════
  //  1 — LOVE COMPATIBILITY SNAPSHOT
  // ══════════════════════════════════════════════════════════════════
  Widget _snapshot(AppLocalizations l) {
    final overall = _map('overall_love_compatibility');
    final score = _scOf(overall, 'overall_love_score');
    final col = _col(score);
    final grade = _strOf(overall, 'compatibility_grade');
    final band = _strOf(overall, 'compatibility_band');
    final comps = _mapOf(overall, 'score_components');
    final summary = _strOf(overall, 'love_verdict').isNotEmpty ? _strOf(overall, 'love_verdict') : _str('confidence_explanation');
    final gauges = <List<Object>>[
      [l.lcGaugeAttraction, _scOf(comps, 'attraction_chemistry')],
      [l.lcGaugeEmotional, _scOf(comps, 'emotional_harmony')],
      [l.lcGaugeMental, _scOf(comps, 'mental_rapport')],
      [l.lcGaugePassion, _scOf(comps, 'passion_physical')],
      [l.lcGaugeLongterm, _scOf(comps, 'longterm_harmony')],
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [col.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
        borderRadius: BorderRadius.circular(22), border: Border.all(color: col.withOpacity(0.3)),
      ),
      child: Column(children: [
        Text(l.lcSnapshotHeader.toUpperCase(), style: const TextStyle(color: AppColors.smoke, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
        const SizedBox(height: 14),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: score / 100), duration: const Duration(milliseconds: 900), curve: Curves.easeOutCubic,
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
        if (grade.isNotEmpty) Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(color: col.withOpacity(0.16), borderRadius: BorderRadius.circular(20)),
          child: Text(grade, style: TextStyle(color: col, fontSize: 14, fontWeight: FontWeight.w800))),
        if (band.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6),
          child: Text(band, style: const TextStyle(color: AppColors.parchment, fontSize: 11.5), textAlign: TextAlign.center)),
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
        Wrap(alignment: WrapAlignment.center, spacing: 8, runSpacing: 8, children: _snapshotChips(l, comps).map((t) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
          decoration: BoxDecoration(color: KColors.green.withOpacity(0.10), borderRadius: BorderRadius.circular(20), border: Border.all(color: KColors.green.withOpacity(0.28))),
          child: Text('✓ $t', style: const TextStyle(color: KColors.green, fontSize: 11.5, fontWeight: FontWeight.w700)),
        )).toList()),
      ]),
    );
  }

  List<String> _snapshotChips(AppLocalizations l, Map comps) {
    final out = <String>[];
    if (_scOf(comps, 'mental_rapport') >= 70) out.add(l.lcChipStrongMental);
    if (_scOf(comps, 'longterm_harmony') >= 60) out.add(l.lcChipStrongLongterm);
    if (_scOf(comps, 'passion_physical') >= 60) out.add(l.lcChipStrongPassion);
    if (_scOf(comps, 'challenge_penalty') < 20) out.add(l.lcChipLowFriction);
    if (_scOf(comps, 'karmic_bond') >= 50) out.add(l.lcChipKarmicPull);
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
  //  2 — PARTNER SNAPSHOT
  // ══════════════════════════════════════════════════════════════════
  Widget _partners(AppLocalizations l) {
    final header = _map('analysis_header');
    final p1 = _mapOf(header, 'partner1');
    final p2 = _mapOf(header, 'partner2');
    if (p1.isEmpty && p2.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.people_alt_rounded, title: l.lcPartnersTitle, color: KColors.blue),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (p1.isNotEmpty) Expanded(child: _partnerCard(l, p1, KColors.purple)),
        if (p1.isNotEmpty && p2.isNotEmpty) const SizedBox(width: 10),
        if (p2.isNotEmpty) Expanded(child: _partnerCard(l, p2, KColors.blue)),
      ]),
    ]);
  }

  Widget _partnerCard(AppLocalizations l, Map p, Color c) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(16), border: Border.all(color: c.withOpacity(0.22))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(p['name']?.toString() ?? '?', style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w800)),
      const SizedBox(height: 4),
      Text('${p['lagna'] ?? ''} ${l.cpLagnaSuffix}', style: const TextStyle(color: AppColors.smoke, fontSize: 10)),
      if (p['moon_sign'] != null) Text('${p['moon_sign']} ${l.cpMoonSuffix}', style: const TextStyle(color: AppColors.smoke, fontSize: 10)),
      if (p['venus_sign'] != null) Text('${p['venus_sign']} ${l.lcVenusSuffix}', style: const TextStyle(color: AppColors.smoke, fontSize: 10)),
    ]));

  // ══════════════════════════════════════════════════════════════════
  //  3 — ATTRACTION & CHEMISTRY
  // ══════════════════════════════════════════════════════════════════
  Widget _attraction(AppLocalizations l) {
    final a = _map('attraction_chemistry');
    if (a.isEmpty) return const SizedBox.shrink();
    final score = _scOf(a, 'attraction_score');
    final contacts = _listOf(a, 'venus_cross_contacts').whereType<Map>().map((e) => e.cast<String, dynamic>()).where((m) => m['present'] == true).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.bolt_rounded, title: l.lcAttractionTitle, color: KColors.orange),
      _statTile(l.lcAttractionScore, score),
      const SizedBox(height: 10),
      Wrap(spacing: 8, runSpacing: 8, children: [
        if (_strOf(a, 'magnetic_pull_direction').isNotEmpty) _pill(_titleCase(_strOf(a, 'magnetic_pull_direction')), KColors.orange),
        if (_strOf(a, 'initial_attraction_type').isNotEmpty) _pill(_titleCase(_strOf(a, 'initial_attraction_type')), KColors.purple),
      ]),
      if (_strOf(a, 'attraction_interpretation').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 10),
        child: Text(_cap(_strOf(a, 'attraction_interpretation')), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))),
      if (contacts.isNotEmpty) ...[const SizedBox(height: 10),
        _catLabel('✨', l.lcActiveContacts, KColors.orange),
        ...contacts.map((c) => Container(
          margin: const EdgeInsets.only(bottom: 6), padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: KColors.orange.withOpacity(0.06), borderRadius: BorderRadius.circular(10), border: Border.all(color: KColors.orange.withOpacity(0.2))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(c['contact']?.toString() ?? '', style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, fontWeight: FontWeight.w700)),
            if (c['effect'] != null) Text(c['effect'].toString(), style: const TextStyle(color: AppColors.parchment, fontSize: 10.5, height: 1.3)),
          ]))),
      ],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  4 — EMOTIONAL HARMONY
  // ══════════════════════════════════════════════════════════════════
  Widget _emotional(AppLocalizations l) {
    final e = _map('emotional_harmony');
    if (e.isEmpty) return const SizedBox.shrink();
    final moon = _mapOf(e, 'moon_sign_compatibility');
    final nak = _mapOf(e, 'moon_nakshatra_compatibility');
    final bhakoot = _mapOf(e, 'bhakoot_axis');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.mood_rounded, title: l.lcEmotionalTitle, color: KColors.blue),
      _statTile(l.lcEmotionalScore, _scOf(e, 'emotional_score')),
      const SizedBox(height: 10),
      if (moon.isNotEmpty) _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text('${moon['his_moon'] ?? ''} × ${moon['her_moon'] ?? ''}', style: const TextStyle(color: AppColors.ivory, fontSize: 12, fontWeight: FontWeight.w700))),
          if (moon['harmony'] != null) _pill(_titleCase(moon['harmony'].toString()), KColors.blue),
        ]),
        if (moon['element_match'] != null) Padding(padding: const EdgeInsets.only(top: 4),
          child: Text(moon['element_match'].toString(), style: const TextStyle(color: AppColors.smoke, fontSize: 10.5))),
        if (moon['interpretation'] != null) Padding(padding: const EdgeInsets.only(top: 6),
          child: Text(moon['interpretation'].toString(), style: const TextStyle(color: AppColors.parchment, fontSize: 11, height: 1.4))),
      ])),
      if (nak.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 10), child: _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l.lcNakshatraCompat, style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Wrap(spacing: 8, runSpacing: 8, children: [
          if (nak['yoni_koota'] != null) _pill('${l.lcYoniKoota}: ${nak['yoni_koota']}', KColors.purple),
          if (nak['gana_koota'] != null) _pill('${l.lcGanaKoota}: ${nak['gana_koota']}', KColors.blue),
          if (nak['tara_koota'] != null) _pill('${l.lcTaraKoota}: ${nak['tara_koota']}', KColors.gold),
        ]),
      ]))),
      if (bhakoot.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 10),
        child: Container(padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: (bhakoot['dosha_present'] == true ? KColors.orange : KColors.green).withOpacity(0.06),
            borderRadius: BorderRadius.circular(12), border: Border.all(color: (bhakoot['dosha_present'] == true ? KColors.orange : KColors.green).withOpacity(0.22))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(bhakoot['dosha_present'] == true ? Icons.warning_amber_rounded : Icons.check_circle_rounded, size: 16, color: bhakoot['dosha_present'] == true ? KColors.orange : KColors.green),
            const SizedBox(width: 8),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${l.lcBhakootAxis} ${bhakoot['axis'] ?? ''}', style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, fontWeight: FontWeight.w700)),
              if (bhakoot['interpretation'] != null) Text(bhakoot['interpretation'].toString(), style: const TextStyle(color: AppColors.parchment, fontSize: 10.5, height: 1.3)),
            ])),
          ]))),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  5 — MENTAL RAPPORT
  // ══════════════════════════════════════════════════════════════════
  Widget _mental(AppLocalizations l) {
    final m = _map('mental_rapport');
    if (m.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.psychology_rounded, title: l.lcMentalTitle, color: KColors.purple),
      _statTile(l.lcMentalScore, _scOf(m, 'mental_score')),
      const SizedBox(height: 10),
      Wrap(spacing: 8, runSpacing: 8, children: [
        if (_strOf(m, 'communication_style_match').isNotEmpty) _pill(_titleCase(_strOf(m, 'communication_style_match')), KColors.purple),
      ]),
      if (_strOf(m, 'mercury_dynamics').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8),
        child: Text(_strOf(m, 'mercury_dynamics'), style: const TextStyle(color: AppColors.smoke, fontSize: 10.5))),
      if (_strOf(m, 'intellectual_connection').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8),
        child: Text(_cap(_strOf(m, 'intellectual_connection')), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))),
      _advanced(l, [if (_strOf(m, 'interpretation').isNotEmpty) _strOf(m, 'interpretation')]),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  6 — PASSION & PHYSICAL
  // ══════════════════════════════════════════════════════════════════
  Widget _passion(AppLocalizations l) {
    final p = _map('passion_physical');
    if (p.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.local_fire_department_rounded, title: l.lcPassionTitle, color: KColors.red),
      _statTile(l.lcPassionScore, _scOf(p, 'passion_score')),
      const SizedBox(height: 10),
      Wrap(spacing: 8, runSpacing: 8, children: [
        if (_strOf(p, 'physical_chemistry').isNotEmpty) _pill(_titleCase(_strOf(p, 'physical_chemistry')), KColors.red),
        if (_strOf(p, 'yoni_compatibility').isNotEmpty) _pill('${l.lcYoniKoota}: ${_strOf(p, 'yoni_compatibility')}', KColors.purple),
      ]),
      if (_strOf(p, 'mars_venus_interplay').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8),
        child: Text(_strOf(p, 'mars_venus_interplay'), style: const TextStyle(color: AppColors.smoke, fontSize: 10.5))),
      if (_strOf(p, 'interpretation').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8),
        child: Text(_cap(_strOf(p, 'interpretation')), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  7 — LONG-TERM HARMONY
  // ══════════════════════════════════════════════════════════════════
  Widget _longterm(AppLocalizations l) {
    final t = _map('longterm_harmony');
    if (t.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.foundation_rounded, title: l.lcLongtermTitle, color: KColors.green),
      _statTile(l.lcLongtermScore, _scOf(t, 'longterm_score')),
      const SizedBox(height: 10),
      if (_strOf(t, 'commitment_potential').isNotEmpty) Padding(padding: const EdgeInsets.only(bottom: 8),
        child: _pill('${l.lcCommitmentPotential}: ${_titleCase(_strOf(t, 'commitment_potential'))}', KColors.green)),
      if (_strOf(t, 'seventh_house_synastry').isNotEmpty) styleRow(l.lc7thHouseSynastry, _strOf(t, 'seventh_house_synastry')),
      if (_strOf(t, 'jupiter_blessing').isNotEmpty) styleRow(l.lcJupiterBlessing, _strOf(t, 'jupiter_blessing')),
      if (_strOf(t, 'd9_navamsa_resonance').isNotEmpty) styleRow(l.lcD9Resonance, _strOf(t, 'd9_navamsa_resonance')),
      if (_strOf(t, 'saturn_longevity').isNotEmpty) styleRow(l.lcSaturnLongevity, _strOf(t, 'saturn_longevity')),
      if (_strOf(t, 'interpretation').isNotEmpty)
        Text(_cap(_strOf(t, 'interpretation')), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4)),
    ]);
  }

  Widget styleRow(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(padding: const EdgeInsets.only(bottom: 8), child: Container(padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(color: AppColors.card.withOpacity(0.4), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.06))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 9.5, fontWeight: FontWeight.w700)),
        const SizedBox(height: 3),
        Text(value, style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.35)),
      ])));
  }

  // ══════════════════════════════════════════════════════════════════
  //  8 — KARMIC LOVE BOND
  // ══════════════════════════════════════════════════════════════════
  Widget _karmic(AppLocalizations l) {
    final k = _map('karmic_love_bond');
    if (k.isEmpty) return const SizedBox.shrink();
    final ketu = _listOf(k, 'ketu_contacts').map((e) => e.toString()).where((s) => !s.toLowerCase().contains('none')).toList();
    final rahu = _listOf(k, 'rahu_contacts').map((e) => e.toString()).where((s) => !s.toLowerCase().contains('none')).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.history_edu_rounded, title: l.lcKarmicTitle, color: KColors.purple),
      _statTile(l.lcKarmicScore, _scOf(k, 'karmic_score')),
      const SizedBox(height: 10),
      if (_strOf(k, 'past_life_indication').isNotEmpty)
        Container(padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(gradient: LinearGradient(colors: [KColors.purple.withOpacity(0.1), AppColors.card.withOpacity(0.4)]),
            borderRadius: BorderRadius.circular(14), border: Border.all(color: KColors.purple.withOpacity(0.2))),
          child: Text(_cap(_strOf(k, 'past_life_indication')), style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.45))),
      if (ketu.isNotEmpty) ...[const SizedBox(height: 8), _chipBlock('☊', l.lcKetuContacts, ketu, KColors.blue)],
      if (rahu.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('☋', l.lcRahuContacts, rahu, KColors.orange)],
      if (_strOf(k, 'darakaraka_link').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8),
        child: Text(_strOf(k, 'darakaraka_link'), style: const TextStyle(color: AppColors.smoke, fontSize: 10.5))),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  9 — CHALLENGES & FRICTION
  // ══════════════════════════════════════════════════════════════════
  Widget _challenges(AppLocalizations l) {
    final c = _map('challenges_friction');
    final list = _listOf(c, 'challenges_detected').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    if (c.isEmpty) return const SizedBox.shrink();
    final penalty = _scOf(c, 'total_challenge_penalty');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.shield_outlined, title: l.lcChallengesTitle, color: KColors.orange),
      if (list.isEmpty)
        Container(padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: KColors.green.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: KColors.green.withOpacity(0.2))),
          child: Row(children: [const Icon(Icons.check_circle_rounded, size: 17, color: KColors.green), const SizedBox(width: 10),
            Expanded(child: Text(l.lcNoChallenges, style: const TextStyle(color: AppColors.ivory, fontSize: 12.5)))]))
      else ...[
        Container(padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: KColors.orange.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: KColors.orange.withOpacity(0.2))),
          child: Row(children: [
            Expanded(child: Text(l.lcTotalPenalty, style: const TextStyle(color: AppColors.ivory, fontSize: 12, fontWeight: FontWeight.w700))),
            Text('-${penalty.toStringAsFixed(1)}', style: const TextStyle(color: KColors.orange, fontSize: 16, fontWeight: FontWeight.w800)),
          ])),
        if (_strOf(c, 'challenge_summary').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8),
          child: Text(_strOf(c, 'challenge_summary'), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))),
        const SizedBox(height: 8),
        ...list.map((dm) {
          final severity = _strOf(dm, 'severity');
          final col = severity.toLowerCase().contains('high') || severity.toLowerCase().contains('severe') ? KColors.red
              : severity.toLowerCase().contains('moderate') ? KColors.orange : KColors.yellow;
          return Container(
            margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(color: col.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: col.withOpacity(0.24))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(dm['challenge']?.toString() ?? '', style: TextStyle(color: col, fontSize: 13, fontWeight: FontWeight.w800))),
                if (severity.isNotEmpty) _pill(_titleCase(severity), col),
              ]),
              if (dm['source'] != null) Padding(padding: const EdgeInsets.only(top: 4),
                child: Text(dm['source'].toString(), style: const TextStyle(color: AppColors.smoke, fontSize: 10.5))),
              if (dm['manifestation'] != null) Padding(padding: const EdgeInsets.only(top: 6),
                child: Text(dm['manifestation'].toString(), style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.4))),
              if (dm['navigation'] != null) Padding(padding: const EdgeInsets.only(top: 6),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('✓ ', style: const TextStyle(color: KColors.green, fontWeight: FontWeight.w800)),
                  Expanded(child: Text(dm['navigation'].toString(), style: const TextStyle(color: KColors.green, fontSize: 11, height: 1.35))),
                ])),
              _advanced(l, [if (dm['cancellation'] != null) dm['cancellation'].toString()]),
            ]),
          );
        }),
      ],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  10 — LOVE TIMING (MOOLA DASHA)
  // ══════════════════════════════════════════════════════════════════
  Widget _timing(AppLocalizations l) {
    final t = _map('love_timing_moola_dasha');
    if (t.isEmpty) return const SizedBox.shrink();
    final combinedScore = _scOf(t, 'combined_timing_score');
    final windows = _listOf(t, 'favorable_love_windows').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.hourglass_bottom_rounded, title: l.lcTimingTitle, color: KColors.green),
      _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(l.cpCombinedTiming, style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w800))),
          Text('${combinedScore.toStringAsFixed(0)}%', style: TextStyle(color: _col(combinedScore), fontSize: 18, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 8),
        ClipRRect(borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(value: (combinedScore / 100).clamp(0, 1), minHeight: 7, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(_col(combinedScore)))),
        if (_strOf(t, 'timing_verdict').isNotEmpty) ...[const SizedBox(height: 10),
          Text(_cap(_strOf(t, 'timing_verdict')), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))],
      ])),
      const SizedBox(height: 10),
      _dashaPartnerBlock(l, widget.participants.isNotEmpty ? widget.participants[0] : l.partnerOneLabel, _mapOf(t, 'current_dasha_partner1'), 'love_favorability'),
      const SizedBox(height: 8),
      _dashaPartnerBlock(l, widget.participants.length > 1 ? widget.participants[1] : l.partnerTwoLabel, _mapOf(t, 'current_dasha_partner2'), 'love_favorability'),
      if (windows.isNotEmpty) ...[const SizedBox(height: 10), ...windows.map((w) => _windowCard(w))],
      if (_strOf(t, 'next_favorable_window').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 4),
        child: Container(padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: KColors.green.withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: KColors.green.withOpacity(0.25))),
          child: Row(children: [
            const Icon(Icons.event_available_rounded, size: 16, color: KColors.green), const SizedBox(width: 8),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.cpNextWindow, style: const TextStyle(color: KColors.green, fontSize: 9.5, fontWeight: FontWeight.w700)),
              Text(_strOf(t, 'next_favorable_window'), style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, fontWeight: FontWeight.w600)),
            ])),
          ]))),
    ]);
  }

  Widget _dashaPartnerBlock(AppLocalizations l, String name, Map pd, String favKey) {
    if (pd.isEmpty) return const SizedBox.shrink();
    final moola = _mapOf(pd, 'moola');
    final favScore = _scOf(pd, 'favorability_score');
    final col = _col(favScore);
    return Container(padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.card.withOpacity(0.4), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.06))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(name, style: const TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.w800))),
          if (pd[favKey] != null) _pill(_titleCase(pd[favKey].toString()), col),
        ]),
        const SizedBox(height: 6),
        if (moola['md'] != null) Text('${l.mahadashaLabel}: ${moola['md']} (${moola['md_start']} — ${moola['md_end']})', style: const TextStyle(color: AppColors.ivory, fontSize: 10.5)),
        if (moola['ad'] != null) Text('${l.antardashaLabel}: ${moola['ad']} (${moola['ad_start']} — ${moola['ad_end']})', style: const TextStyle(color: AppColors.smoke, fontSize: 10.5)),
        if (moola['pd'] != null) Text('${l.pratyantardashaLabel}: ${moola['pd']}', style: const TextStyle(color: AppColors.smoke, fontSize: 10.5)),
        const SizedBox(height: 6),
        ClipRRect(borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(value: (favScore / 100).clamp(0, 1), minHeight: 5, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(col))),
        if (pd['reasoning'] != null) Padding(padding: const EdgeInsets.only(top: 6),
          child: Text(pd['reasoning'].toString(), style: const TextStyle(color: AppColors.parchment, fontSize: 10.5, height: 1.35, fontStyle: FontStyle.italic))),
      ]));
  }

  Widget _windowCard(Map<String, dynamic> w) {
    return Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: KColors.purple.withOpacity(0.06), borderRadius: BorderRadius.circular(12), border: Border.all(color: KColors.purple.withOpacity(0.22))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(w['period']?.toString() ?? '', style: const TextStyle(color: KColors.purple, fontSize: 12, fontWeight: FontWeight.w800)),
        if (w['start_date'] != null || w['end_date'] != null) Padding(padding: const EdgeInsets.only(top: 3),
          child: Text('${w['start_date'] ?? ''} — ${w['end_date'] ?? ''}', style: const TextStyle(color: AppColors.smoke, fontSize: 10))),
        if (w['significance'] != null) Padding(padding: const EdgeInsets.only(top: 4),
          child: Text(_titleCase(w['significance'].toString()), style: const TextStyle(color: AppColors.gold, fontSize: 10.5, fontWeight: FontWeight.w600))),
        if (w['activating_factor'] != null) Padding(padding: const EdgeInsets.only(top: 4),
          child: Text(w['activating_factor'].toString(), style: const TextStyle(color: AppColors.parchment, fontSize: 10.5, height: 1.3))),
      ]));
  }

  // ══════════════════════════════════════════════════════════════════
  //  11 — RELATIONSHIP DYNAMICS
  // ══════════════════════════════════════════════════════════════════
  Widget _dynamics(AppLocalizations l) {
    final d = _map('relationship_dynamics');
    if (d.isEmpty) return const SizedBox.shrink();
    final strengths = _listOf(d, 'potential_strengths').map((e) => e.toString()).toList();
    final nurture = _listOf(d, 'areas_to_nurture').map((e) => e.toString()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.compare_arrows_rounded, title: l.lcDynamicsTitle, color: KColors.blue),
      if (_strOf(d, 'power_balance').isNotEmpty) Padding(padding: const EdgeInsets.only(bottom: 8),
        child: _pill('${l.lcPowerBalance}: ${_titleCase(_strOf(d, 'power_balance'))}', KColors.blue)),
      if (_strOf(d, 'emotional_giver_receiver').isNotEmpty) styleRow(l.lcGiverReceiver, _strOf(d, 'emotional_giver_receiver')),
      if (_strOf(d, 'growth_dynamic').isNotEmpty) styleRow(l.lcGrowthDynamic, _strOf(d, 'growth_dynamic')),
      if (strengths.isNotEmpty) ...[const SizedBox(height: 6), _chipBlock('💪', l.strengths, strengths, KColors.green)],
      if (nurture.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('🌱', l.lcAreasToNurture, nurture, KColors.orange)],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  12 — REMEDIES & GUIDANCE
  // ══════════════════════════════════════════════════════════════════
  Widget _remedies(AppLocalizations l) {
    final r = _map('remedies_guidance');
    final list = _listOf(r, 'recommended_remedies').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    if (list.isEmpty && _strOf(r, 'relationship_guidance').isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.healing_rounded, title: l.cpRemediesTitle, color: KColors.green),
      ...list.map((m) => Container(
        margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: KColors.purple.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: KColors.purple.withOpacity(0.2))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            if (m['remedy_type'] != null) _pill(_titleCase(m['remedy_type'].toString()), KColors.purple),
            const Spacer(),
            if (m['for_whom'] != null) Text(_titleCase(m['for_whom'].toString()), style: const TextStyle(color: AppColors.smoke, fontSize: 10)),
          ]),
          const SizedBox(height: 6),
          Text(_cap(m['remedy']?.toString() ?? ''), style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.45)),
          if (m['addresses'] != null) Padding(padding: const EdgeInsets.only(top: 6),
            child: Text('${l.cpAddresses}: ${m['addresses']}', style: const TextStyle(color: AppColors.parchment, fontSize: 10.5, height: 1.3))),
          _advanced(l, [if (m['classical_basis'] != null) m['classical_basis'].toString()]),
        ]),
      )),
      if (_strOf(r, 'relationship_guidance').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 4),
        child: Text(_strOf(r, 'relationship_guidance'), style: const TextStyle(color: AppColors.parchment, fontSize: 11, height: 1.4, fontStyle: FontStyle.italic))),
      if (_strOf(r, 'note').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8),
        child: Text(_strOf(r, 'note'), style: const TextStyle(color: AppColors.smoke, fontSize: 10, height: 1.4, fontStyle: FontStyle.italic))),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  13 — SUMMARY & KEY INSIGHTS
  // ══════════════════════════════════════════════════════════════════
  Widget _summary(AppLocalizations l) {
    final s = _map('summary');
    final insights = _listOf(s, 'key_insights').map((e) => e.toString()).toList();
    final human = _strOf(s, 'human_summary');
    if (insights.isEmpty && human.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.summarize_rounded, title: l.summary, color: AppColors.gold),
      if (human.isNotEmpty) _card(child: Text(_cap(human), style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, height: 1.5))),
      if (insights.isNotEmpty) ...[const SizedBox(height: 10),
        ...insights.map((s2) => Container(
          margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.06), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.gold.withOpacity(0.2))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.check_circle_rounded, size: 15, color: AppColors.gold), const SizedBox(width: 9),
            Expanded(child: Text(_cap(s2), style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.4))),
          ]))),
      ],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  14 — PREDICTION RELIABILITY
  // ══════════════════════════════════════════════════════════════════
  Widget _reliability(AppLocalizations l) {
    final raw = _sc('confidence_score');
    final pct = raw <= 1 ? raw * 100 : raw;
    final band = pct >= 75 ? l.crReliabilityHigh : pct >= 60 ? l.crReliabilityGood : l.crReliabilityModerate;
    final explain = _str('confidence_explanation');
    final disclaimer = _str('engine_disclaimer');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.verified_user_rounded, title: l.crReliability, color: KColors.blue),
      _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          KStars(filled: kStars(pct), size: 20, color: AppColors.gold), const Spacer(),
          Text('${pct.toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.gold, fontSize: 22, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 4),
        Text(band, style: const TextStyle(color: KColors.green, fontSize: 13, fontWeight: FontWeight.w800)),
        if (explain.isNotEmpty) ...[const SizedBox(height: 10),
          Text(_cap(explain), style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.5))],
      ])),
      if (disclaimer.isNotEmpty) ...[const SizedBox(height: 10),
        Text(disclaimer, style: const TextStyle(color: AppColors.smoke, fontSize: 10.5, height: 1.4, fontStyle: FontStyle.italic))],
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  15 — DISCUSS WITH AI
  // ══════════════════════════════════════════════════════════════════
  Widget _discussAi(AppLocalizations l) {
    final topics = <String>[l.lcTopicTiming, l.lcTopicChallenges, l.lcTopicKarmic, l.lcTopicRemedies, l.lcTopicLongterm, l.lcTopicDynamics];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.forum_rounded, title: l.crDiscussAi, color: AppColors.gold),
      ReportAiChatCta(domainKey: 'love_relationship', label: 'Love & Relationship', emoji: '❤️'),
      const SizedBox(height: 14),
      Row(children: [
        _aiBtn('ChatGPT', '🤖', () => _launchAi(_data, 'chatgpt')),
        _aiBtn('Claude', '✳️', () => _launchAi(_data, 'claude')),
        _aiBtn('Gemini', '💎', () => _launchAi(_data, 'gemini')),
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
    final q = '$topic — based on the love-compatibility report for ${widget.participants.join(' & ')}.\n\n${_buildPrompt(_data)}';
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

  Widget _statTile(String label, double score) {
    final c = _col(score);
    return Container(padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: c.withOpacity(0.2))),
      child: Row(children: [
        Expanded(child: Text(label, style: const TextStyle(color: AppColors.ivory, fontSize: 12, fontWeight: FontWeight.w700))),
        Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: c, fontSize: 16, fontWeight: FontWeight.w800)),
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
  String _cap(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
  String _titleCase(String s) => s.replaceAll('_', ' ').replaceAll('-', ' ').split(' ')
    .where((w) => w.isNotEmpty).map((w) => '${w[0].toUpperCase()}${w.substring(1)}').join(' ');

  // ── AI prompt / launch (unchanged behaviour) ──
  String _buildPrompt(Map<String, dynamic> d) {
    final overall = _mapOf(d, 'overall_love_compatibility');
    final score = overall['overall_love_score'] ?? '?';
    final grade = overall['compatibility_grade'] ?? '';
    final jsonStr = const JsonEncoder.withIndent('  ').convert(d);
    return '''You are a Vedic love-compatibility advisor. Analyze this report for ${widget.participants.join(' & ')} and provide actionable insights.

Key highlights:
- Overall love compatibility: $score/100 ($grade)

Full report data (JSON):
$jsonStr

Please explain the key findings in simple language, highlight the most favorable timing windows, and suggest practical next steps for nurturing the bond.''';
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
}
