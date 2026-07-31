import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/kundli_names.dart';
import '../kundli/widgets/kundli_ui.dart';

/// Kundli Milan report — premium AI marriage-compatibility coach redesign.
///
/// Presentation only. Receives the already-loaded `kundli_milan` specialist
/// result (`runSpecialistMilan`) and re-presents it; every score, guna,
/// dosha, karaka, yoga, timing window, remedy and confidence value comes
/// straight from the engine. Constructor unchanged so the picker screen that
/// navigates here does not need to change.
class MilanReportScreen extends StatefulWidget {
  final String name1, name2;
  final Map<String, dynamic> data;
  const MilanReportScreen({super.key, required this.name1, required this.name2, required this.data});
  @override
  State<MilanReportScreen> createState() => _MilanReportState();
}

class _MilanReportState extends State<MilanReportScreen> {
  Map<String, dynamic> get _data => widget.data;

  // ── typed accessors (type-checked, never throw on unexpected shapes) ──
  double _sc(String k) { final v = _data[k]; return v is num ? v.toDouble() : 0; }
  String _str(String k) { final v = _data[k]; return (v == null || v is List || v is Map) ? '' : v.toString(); }
  List _list(String k) { final v = _data[k]; return v is List ? v : const []; }
  Map<String, dynamic> _map(String k) { final v = _data[k]; return v is Map ? v.cast<String, dynamic>() : {}; }
  bool _bool(String k) => _data[k] == true;

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
          Text('${widget.name1} & ${widget.name2}', style: const TextStyle(color: AppColors.ivory, fontSize: 15, fontWeight: FontWeight.w700)),
          Text(l.kmSubtitle, style: const TextStyle(color: AppColors.gold, fontSize: 10)),
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
      gap, _ashtakoot(l),       // 2
      gap, _mangal(l),          // 3
      gap, _d9Cross(l),         // 4
      gap, _soulSpouseKarakas(l), // 5
      gap, _venusMars(l),       // 6
      gap, _houseCross(l),      // 7
      gap, _domains(l),         // 8
      gap, _dashaTransit(l),    // 9
      gap, _timing(l),          // 10
      gap, _risks(l),           // 11
      gap, _strengths(l),       // 12
      gap, _journey(l),         // 13
      gap, _coreTheme(l),       // 14
      gap, _verdict(l),         // 15
      gap, _reliability(l),     // 16
      gap, _discussAi(l),       // 17
    ];
  }

  Widget _breadcrumb(AppLocalizations l) => Row(children: [
    Text(l.crCrumbHome, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Text(l.crCrumbReports, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
    const Text('  ›  ', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
    Flexible(child: Text(l.kmTitle, style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
  ]);

  // ══════════════════════════════════════════════════════════════════
  //  1 — COMPATIBILITY SNAPSHOT
  // ══════════════════════════════════════════════════════════════════
  Widget _snapshot(AppLocalizations l) {
    final overall = _sc('unified_compatibility_score');
    final col = _col(overall);
    final grade = _str('unified_grade');
    final ashtakootPct = _sc('ashtakoot_total_probability');
    final summary = _str('unified_signature').isNotEmpty ? _str('unified_signature') : _str('plain_statement');
    final gauges = <List<Object>>[
      [l.kmGaugeAshtakoot, ashtakootPct],
      [l.kmGaugeD9, _sc('d9_compatibility_score')],
      [l.kmGaugeMangal, _sc('mangal_compatibility_score')],
      [l.kmGaugePapa, _sc('papa_compatibility_score')],
      [l.kmGaugeAk, _sc('atmakaraka_compatibility_score')],
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [col.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
        borderRadius: BorderRadius.circular(22), border: Border.all(color: col.withOpacity(0.3)),
      ),
      child: Column(children: [
        Text(l.kmSnapshotHeader.toUpperCase(), style: const TextStyle(color: AppColors.smoke, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
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
        if (grade.isNotEmpty) Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(color: col.withOpacity(0.16), borderRadius: BorderRadius.circular(20)),
          child: Text(_titleCase(grade), style: TextStyle(color: col, fontSize: 14, fontWeight: FontWeight.w800))),
        const SizedBox(height: 10),
        Text(l.kmAshtakootScore(_sc('ashtakoot_total_score').toStringAsFixed(1)), style: const TextStyle(color: AppColors.gold, fontSize: 13, fontWeight: FontWeight.w700)),
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
    if (!_bool('nadi_dosh_present')) out.add(l.kmChipNoNadi);
    if (!_bool('bhakoot_dosh_present')) out.add(l.kmChipNoBhakoot);
    if (_bool('mutual_cancellation_active')) out.add(l.kmChipMangalCancelled);
    if (_bool('papasamya_balanced')) out.add(l.kmChipPapaBalanced);
    if (_sc('physical_chemistry_score') >= 65) out.add(l.kmChipStrongChemistry);
    if (_sc('d9_compatibility_score') >= 60) out.add(l.kmChipStrongD9);
    if (_sc('longevity_alignment_score') >= 60) out.add(l.kmChipLongevity);
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
  //  2 — ASHTAKOOT GUNA MILAN (8 gunas)
  // ══════════════════════════════════════════════════════════════════
  Widget _ashtakoot(AppLocalizations l) {
    final gunas = _list('ashtakoot_breakdown').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    if (gunas.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.grid_view_rounded, title: l.kmAshtakootTitle, subtitle: l.kmAshtakootSubtitle, color: AppColors.gold),
      ...gunas.map((g) {
        final score = (g['score'] is num ? g['score'] as num : null)?.toDouble() ?? 0;
        final max = (g['max'] is num ? g['max'] as num : null)?.toDouble() ?? 1;
        final pct = max > 0 ? (score / max * 100) : 0.0;
        final hasDosha = g['has_dosha'] == true;
        final c = hasDosha ? KColors.orange : _col(pct);
        return Container(
          margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: c.withOpacity(0.2))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text('${g['gun_num'] ?? ''}. ${g['gun'] ?? ''}', style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w700))),
              if (hasDosha) const Padding(padding: EdgeInsets.only(right: 6), child: Icon(Icons.warning_amber_rounded, size: 15, color: KColors.orange)),
              Text('${score.toStringAsFixed(1)}/${max.toStringAsFixed(0)}', style: TextStyle(color: c, fontSize: 14, fontWeight: FontWeight.w800)),
            ]),
            const SizedBox(height: 7),
            ClipRRect(borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(value: (pct / 100).clamp(0, 1), minHeight: 6, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c))),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: _valPill(widget.name1, g['p1_val']?.toString() ?? '', KColors.blue)),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Icon(Icons.compare_arrows_rounded, size: 14, color: AppColors.smoke)),
              Expanded(child: _valPill(widget.name2, g['p2_val']?.toString() ?? '', KColors.purple)),
            ]),
            if (g['detail'] != null) ...[const SizedBox(height: 6),
              Text(g['detail'].toString(), style: const TextStyle(color: AppColors.parchment, fontSize: 11, height: 1.35))],
            if (hasDosha && g['remedy'] != null && g['remedy'].toString().isNotEmpty) ...[const SizedBox(height: 4),
              Text('✦ ${g['remedy']}', style: const TextStyle(color: AppColors.gold, fontSize: 10.5, fontStyle: FontStyle.italic))],
          ]),
        );
      }),
      _advanced(l, [
        '${l.kmNadiSeverity}: ${_titleCase(_str('nadi_dosh_severity'))} · ${_str('nadi_dosh_cancellation_signature')}',
        '${l.kmBhakootSeverity}: ${_titleCase(_str('bhakoot_dosh_severity'))}',
        '${l.kmGanaSignature}: ${_str('gana_dosh_signature')}',
      ]),
    ]);
  }

  Widget _valPill(String name, String val, Color c) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(name, style: TextStyle(color: c, fontSize: 8.5, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
      Text(val, style: const TextStyle(color: AppColors.ivory, fontSize: 10.5, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
    ]));

  // ══════════════════════════════════════════════════════════════════
  //  3 — MANGAL DOSHA CHECK
  // ══════════════════════════════════════════════════════════════════
  Widget _mangal(AppLocalizations l) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.local_fire_department_rounded, title: l.kmMangalTitle, color: KColors.orange),
      Row(children: [
        Expanded(child: _mangalCard(widget.name1, _str('partner1_net_mangal_status'), _sc('partner1_mangal_severity_score'))),
        const SizedBox(width: 10),
        Expanded(child: _mangalCard(widget.name2, _str('partner2_net_mangal_status'), _sc('partner2_mangal_severity_score'))),
      ]),
      const SizedBox(height: 10),
      if (_str('mangal_cross_chart_signature').isNotEmpty)
        _card(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Text(_cap(_str('mangal_cross_chart_signature')), style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.4))),
          const SizedBox(width: 10),
          Text('${_sc('mangal_compatibility_score').toStringAsFixed(0)}%', style: TextStyle(color: _col(_sc('mangal_compatibility_score')), fontSize: 16, fontWeight: FontWeight.w800)),
        ])),
      _advanced(l, [
        '${widget.name1}: ${_str('partner1_mangal_signature')}',
        '${widget.name2}: ${_str('partner2_mangal_signature')}',
      ]),
    ]);
  }

  Widget _mangalCard(String name, String status, double severity) {
    final manglik = status.toLowerCase().contains('manglik') && !status.toLowerCase().contains('non');
    final c = manglik ? KColors.orange : KColors.green;
    return Container(padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(color: c.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: c.withOpacity(0.28))),
      child: Column(children: [
        Text(name, style: const TextStyle(color: AppColors.ivory, fontSize: 12, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 6),
        Icon(manglik ? Icons.warning_amber_rounded : Icons.check_circle_rounded, color: c, size: 22),
        const SizedBox(height: 4),
        Text(_titleCase(status), style: TextStyle(color: c, fontSize: 10.5, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
        if (manglik) Text('${severity.toStringAsFixed(0)}%', style: TextStyle(color: c, fontSize: 9)),
      ]));
  }

  // ══════════════════════════════════════════════════════════════════
  //  4 — D9 NAVAMSA CROSS-CHART (marriage karma)
  // ══════════════════════════════════════════════════════════════════
  Widget _d9Cross(AppLocalizations l) {
    final score = _sc('d9_compatibility_score');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.auto_awesome_rounded, title: l.kmD9Title, subtitle: l.kmD9Subtitle, color: KColors.purple),
      _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(l.kmD9Score, style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w800))),
          Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: _col(score), fontSize: 18, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 8),
        ClipRRect(borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(value: (score / 100).clamp(0, 1), minHeight: 7, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(_col(score)))),
        if (_str('d9_classical_signature').isNotEmpty) ...[const SizedBox(height: 10),
          Text(_cap(_str('d9_classical_signature')), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))],
      ])),
      const SizedBox(height: 10),
      Wrap(spacing: 8, runSpacing: 8, children: [
        if (_str('d9_lagna_signs_relationship').isNotEmpty) _pill('${l.kmLagnaRelation}: ${_titleCase(_str('d9_lagna_signs_relationship'))}', KColors.blue),
        if (_str('d9_seventh_lords_relationship').isNotEmpty) _pill('${l.km7thLordRelation}: ${_titleCase(_str('d9_seventh_lords_relationship'))}', KColors.purple),
      ]),
      _advanced(l, [
        if (_str('d9_venus_to_partner_venus_signature').isNotEmpty) _str('d9_venus_to_partner_venus_signature'),
        if (_str('d9_jupiter_to_partner_jupiter_signature').isNotEmpty) _str('d9_jupiter_to_partner_jupiter_signature'),
        '${widget.name1} D9: Lagna lord ${_str('partner1_d9_lagna_lord_dignity')} · Venus ${_str('partner1_d9_venus_dignity')} · Jupiter ${_str('partner1_d9_jupiter_dignity')}',
        '${widget.name2} D9: Lagna lord ${_str('partner2_d9_lagna_lord_dignity')} · Venus ${_str('partner2_d9_venus_dignity')} · Jupiter ${_str('partner2_d9_jupiter_dignity')}',
      ]),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  5 — SOUL & SPOUSE KARAKAS (Atmakaraka / Darakaraka / Upapada)
  // ══════════════════════════════════════════════════════════════════
  Widget _soulSpouseKarakas(AppLocalizations l) {
    final loc = Localizations.localeOf(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.self_improvement_rounded, title: l.kmKarakasTitle, color: KColors.blue),
      Row(children: [
        Expanded(child: _iconTile('🕉️', '${widget.name1} ${l.kmAtmakaraka}', KundliNames.planet(_str('partner1_atmakaraka_planet'), loc))),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('🕉️', '${widget.name2} ${l.kmAtmakaraka}', KundliNames.planet(_str('partner2_atmakaraka_planet'), loc))),
      ]),
      const SizedBox(height: 10),
      _statTile(l.kmAkCompatibility, _sc('atmakaraka_compatibility_score')),
      if (_str('ak_cross_resonance_signature').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8),
        child: Text(_cap(_str('ak_cross_resonance_signature')), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))),
      const SizedBox(height: 12),
      _statTile(l.kmUlCompatibility, _sc('ul_compatibility_score')),
      if (_str('ul_dharma_alignment_signature').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8),
        child: Text(_cap(_str('ul_dharma_alignment_signature')), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))),
      _advanced(l, [
        if (_str('dk_cross_resonance_signature').isNotEmpty) _str('dk_cross_resonance_signature'),
        '${l.kmUlSigns}: ${widget.name1} — ${KundliNames.planet(_str('partner1_ul_lord'), loc)} · ${widget.name2} — ${KundliNames.planet(_str('partner2_ul_lord'), loc)}',
      ]),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  6 — VENUS-MARS CHEMISTRY
  // ══════════════════════════════════════════════════════════════════
  Widget _venusMars(AppLocalizations l) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.favorite_rounded, title: l.kmChemistryTitle, color: KColors.purple),
      Row(children: [
        Expanded(child: _statTile(l.kmPhysicalChemistry, _sc('physical_chemistry_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.kmEmotionalWarmth, _sc('emotional_warmth_score'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.kmAestheticAlignment, _sc('aesthetic_alignment_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.kmElementalSynthesis, _sc('elemental_synthesis_score'))),
      ]),
      if (_str('venus_mars_cross_signature').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 10),
        child: Text(_cap(_str('venus_mars_cross_signature')), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  7 — 7TH & 8TH HOUSE CROSS-ANALYSIS
  // ══════════════════════════════════════════════════════════════════
  Widget _houseCross(AppLocalizations l) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.home_rounded, title: l.kmHouseCrossTitle, color: KColors.blue),
      Row(children: [
        Expanded(child: _statTile('${widget.name1} 7H', _sc('partner1_seventh_house_strength_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile('${widget.name2} 7H', _sc('partner2_seventh_house_strength_score'))),
      ]),
      const SizedBox(height: 10),
      _statTile(l.km78Compatibility, _sc('h7_h8_compatibility_score')),
      const SizedBox(height: 10),
      if (_str('eighth_house_compatibility_signature').isNotEmpty)
        _iconTile('💫', l.km8thHouseSignature, _cap(_str('eighth_house_compatibility_signature'))),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.kmLongevityAlignment, _sc('longevity_alignment_score'))),
      ]),
      if (_str('ayur_yoga_alignment_signature').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 10),
        child: Text(_cap(_str('ayur_yoga_alignment_signature')), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))),
      _advanced(l, [
        '${l.km7thLordFriendship}: ${_titleCase(_str('seventh_lords_planetary_friendship'))}',
        if (_str('mutual_seventh_house_occupant_signature').isNotEmpty) _str('mutual_seventh_house_occupant_signature'),
      ]),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  8 — DOMAIN COMPATIBILITY
  // ══════════════════════════════════════════════════════════════════
  Widget _domains(AppLocalizations l) {
    final items = <List<Object>>[
      [l.emotional, _sc('emotional_compatibility_score')],
      [l.intellectual, _sc('intellectual_compatibility_score')],
      [l.spiritual, _sc('spiritual_alignment_score')],
      [l.financial, _sc('financial_alignment_score')],
      [l.domestic, _sc('domestic_living_compatibility_score')],
      [l.communicationWord, _sc('communication_alignment_score')],
      [l.sharedDharma, _sc('shared_dharma_alignment_score')],
      [l.familyCreation, _sc('family_creation_alignment_score')],
      [l.kmConflictEngagement, _sc('conflict_engagement_alignment_score')],
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.hub_rounded, title: l.kmDomainsTitle, color: AppColors.gold),
      _card(child: Column(children: items.map((i) {
        final v = i[1] as double;
        final c = _col(v);
        return Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children: [
          SizedBox(width: 110, child: Text(i[0] as String, style: const TextStyle(color: AppColors.ivory, fontSize: 11))),
          Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(value: (v / 100).clamp(0, 1), minHeight: 6, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
          const SizedBox(width: 8),
          SizedBox(width: 32, child: Text(v.toStringAsFixed(0), textAlign: TextAlign.right, style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w700))),
        ]));
      }).toList())),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  9 — DASHA & TRANSIT SYNC
  // ══════════════════════════════════════════════════════════════════
  Widget _dashaTransit(AppLocalizations l) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.hourglass_bottom_rounded, title: l.kmDashaTitle, color: KColors.gold),
      Row(children: [
        Expanded(child: _iconTile('🪐', widget.name1, '${_str('partner1_current_md_planet')} / ${_str('partner1_current_ad_planet')}')),
        const SizedBox(width: 10),
        Expanded(child: _iconTile('🪐', widget.name2, '${_str('partner2_current_md_planet')} / ${_str('partner2_current_ad_planet')}')),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _statTile(l.kmDashaSync, _sc('dasha_sync_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.kmTransitAlignment, _sc('transit_alignment_score'))),
      ]),
      if (_str('saade_sati_warning').isNotEmpty && !_str('saade_sati_warning').toLowerCase().contains('neither'))
        Padding(padding: const EdgeInsets.only(top: 10), child: _pill(_str('saade_sati_warning'), KColors.orange)),
      if (_str('ashtama_shani_warning').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6),
        child: _pill(_str('ashtama_shani_warning'), KColors.orange)),
      _advanced(l, [
        if (_str('jupiter_transit_to_partner1_moon_signature').isNotEmpty) '${widget.name1}: ${_str('jupiter_transit_to_partner1_moon_signature')}',
        if (_str('jupiter_transit_to_partner2_moon_signature').isNotEmpty) '${widget.name2}: ${_str('jupiter_transit_to_partner2_moon_signature')}',
        if (_str('mutual_marriage_supportive_transits').isNotEmpty) _str('mutual_marriage_supportive_transits'),
      ]),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  10 — MARRIAGE TIMING
  // ══════════════════════════════════════════════════════════════════
  Widget _timing(AppLocalizations l) {
    final marriage = _list('joint_marriage_windows').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final engagement = _list('joint_engagement_windows').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    final avoid = _list('avoid_periods').whereType<Map>().map((e) => e.cast<String, dynamic>())
        .where((m) => !(m['reason']?.toString().toLowerCase().contains('neither') ?? false)).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.event_rounded, title: l.kmTimingTitle, color: KColors.green),
      if (marriage.isNotEmpty) ...marriage.map((m) => _timelineCard(l, l.kmMarriageWindow, m, KColors.gold)),
      if (engagement.isNotEmpty) ...engagement.map((m) => _timelineCard(l, l.kmEngagementWindow, m, KColors.blue)),
      if (_str('recommended_marriage_year_range').isNotEmpty) Padding(padding: const EdgeInsets.only(bottom: 10),
        child: _iconTile('📅', l.kmRecommendedRange, _cap(_str('recommended_marriage_year_range')))),
      if (avoid.isNotEmpty) ...avoid.map((m) => Container(
        margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: KColors.red.withOpacity(0.06), borderRadius: BorderRadius.circular(12), border: Border.all(color: KColors.red.withOpacity(0.2))),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.block_rounded, size: 15, color: KColors.red), const SizedBox(width: 8),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(m['period']?.toString() ?? '', style: const TextStyle(color: AppColors.ivory, fontSize: 12, fontWeight: FontWeight.w700)),
            if (m['reason'] != null) Text(m['reason'].toString(), style: const TextStyle(color: AppColors.parchment, fontSize: 11, height: 1.3)),
          ])),
        ]))),
      if (_str('muhurta_recommendations').isNotEmpty) _advanced(l, [_str('muhurta_recommendations')], customTitle: l.kmMuhurtaNotes),
    ]);
  }

  Widget _timelineCard(AppLocalizations l, String title, Map<String, dynamic> m, Color col) {
    final window = m['window']?.toString() ?? '';
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
        if (note.isNotEmpty) ...[const SizedBox(height: 6),
          Text(_cap(note), style: const TextStyle(color: AppColors.ivory, fontSize: 11.5, height: 1.4))],
      ]),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  //  11 — RISKS TO ADDRESS
  // ══════════════════════════════════════════════════════════════════
  Widget _risks(AppLocalizations l) {
    final top3 = _list('top_3_risks_to_address').whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.shield_outlined, title: l.kmRisksTitle, color: KColors.orange),
      ...top3.map((r) {
        final severity = (r['severity'] is num ? r['severity'] as num : null)?.toDouble() ?? 0;
        final c = _riskColor(severity);
        return Container(
          margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: c.withOpacity(0.2))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(r['risk']?.toString() ?? '', style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, fontWeight: FontWeight.w700))),
              Text('${severity.toStringAsFixed(0)}%', style: TextStyle(color: c, fontSize: 13, fontWeight: FontWeight.w800)),
            ]),
            if (r['mitigation'] != null) ...[const SizedBox(height: 6),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('🛡️ ', style: const TextStyle(fontSize: 11)),
                Expanded(child: Text(r['mitigation'].toString(), style: const TextStyle(color: AppColors.parchment, fontSize: 11, height: 1.35))),
              ])],
          ]),
        );
      }),
      const SizedBox(height: 6),
      Row(children: [
        Expanded(child: _riskTile(l.kmConflictRisk, _sc('conflict_risk_score'))),
        const SizedBox(width: 10),
        Expanded(child: _riskTile(l.kmCommunicationRisk, _sc('communication_risk_score'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _riskTile(l.kmFinanceRisk, _sc('finance_conflict_risk_score'))),
        const SizedBox(width: 10),
        Expanded(child: _riskTile(l.kmFamilyDynamicsRisk, _sc('family_dynamics_risk_score'))),
      ]),
      const SizedBox(height: 10),
      _riskTile(l.kmMentalHealthRisk, _sc('mental_health_alignment_risk_score')),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  12 — STRENGTHS
  // ══════════════════════════════════════════════════════════════════
  Widget _strengths(AppLocalizations l) {
    final strengths = _list('top_compatibility_strengths').map((e) => e.toString()).toList();
    if (strengths.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.emoji_events_rounded, title: l.kmStrengthsTitle, color: KColors.green),
      ...strengths.map((s) => Container(
        margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: KColors.green.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: KColors.green.withOpacity(0.2))),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.check_circle_rounded, size: 17, color: KColors.green), const SizedBox(width: 10),
          Expanded(child: Text(_cap(s), style: const TextStyle(color: AppColors.ivory, fontSize: 12.5, height: 1.4))),
        ]),
      )),
      Row(children: [
        Expanded(child: _statTile(l.kmSharedGrowth, _sc('shared_growth_potential_score'))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(l.kmSharedCreative, _sc('shared_creative_potential_score'))),
      ]),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════
  //  13 — RELATIONSHIP JOURNEY & GROWTH
  // ══════════════════════════════════════════════════════════════════
  Widget _journey(AppLocalizations l) {
    final growth = _list('key_growth_areas').map((e) => e.toString()).toList();
    final protocols = _list('communication_protocols_recommended').map((e) => e.toString()).toList();
    final practices = _list('shared_practices_recommended').map((e) => e.toString()).toList();
    final trajectory = _map('couple_trajectory_by_phase');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.route_rounded, title: l.kmJourneyTitle, color: KColors.blue),
      if (_str('relationship_phase_classifier').isNotEmpty) Padding(padding: const EdgeInsets.only(bottom: 10),
        child: _pill('${l.kmCurrentPhase}: ${_titleCase(_str('relationship_phase_classifier'))}', KColors.blue)),
      if (trajectory.isNotEmpty) ...[
        if (trajectory['early_marriage_arc'] != null) styleRow(l.kmEarlyArc, trajectory['early_marriage_arc'].toString()),
        if (trajectory['middle_marriage_arc'] != null) styleRow(l.kmMiddleArc, trajectory['middle_marriage_arc'].toString()),
        if (trajectory['mature_marriage_arc'] != null) styleRow(l.kmMatureArc, trajectory['mature_marriage_arc'].toString()),
        if (trajectory['elder_marriage_arc'] != null) styleRow(l.kmElderArc, trajectory['elder_marriage_arc'].toString()),
      ],
      if (_str('peak_relationship_phase').isNotEmpty) Padding(padding: const EdgeInsets.only(bottom: 10),
        child: _iconTile('🏔️', l.kmPeakPhase, _cap(_str('peak_relationship_phase')))),
      if (growth.isNotEmpty) _chipBlock('🌱', l.kmGrowthAreas, growth, KColors.orange),
      if (protocols.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('💬', l.kmCommProtocols, protocols, KColors.blue)],
      if (practices.isNotEmpty) ...[const SizedBox(height: 4), _chipBlock('🤝', l.kmSharedPractices, practices, KColors.green)],
      if (_str('conflict_resolution_recommended_style').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6),
        child: Text(_cap(_str('conflict_resolution_recommended_style')), style: const TextStyle(color: AppColors.parchment, fontSize: 11.5, height: 1.4))),
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
  //  14 — CORE RELATIONSHIP THEME & IMPROVEMENT PLAN
  // ══════════════════════════════════════════════════════════════════
  Widget _coreTheme(AppLocalizations l) {
    final theme = _map('core_relationship_theme');
    final practical = _remedyItems('practical_solutions');
    final planetary = _remedyItems('astrological_remedies');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.healing_rounded, title: l.kmImprovementTitle, color: KColors.green),
      if (theme.isNotEmpty) Container(
        margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [(theme['is_gift'] == true ? KColors.green : KColors.orange).withOpacity(0.16), AppColors.card.withOpacity(0.4)]),
          borderRadius: BorderRadius.circular(18), border: Border.all(color: (theme['is_gift'] == true ? KColors.green : KColors.orange).withOpacity(0.3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(theme['is_gift'] == true ? '🎁' : '🔑', style: const TextStyle(fontSize: 20)), const SizedBox(width: 8),
            Expanded(child: Text(theme['primary_theme']?.toString() ?? '', style: const TextStyle(color: AppColors.ivory, fontSize: 14.5, fontWeight: FontWeight.w800))),
          ]),
          if (theme['explanation'] != null) ...[const SizedBox(height: 8),
            Text(theme['explanation'].toString(), style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.45))],
          if (theme['action_direction'] != null) ...[const SizedBox(height: 8),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('✓ ', style: TextStyle(color: KColors.green, fontWeight: FontWeight.w800)),
              Expanded(child: Text(theme['action_direction'].toString(), style: const TextStyle(color: KColors.green, fontSize: 11.5, height: 1.4))),
            ])],
        ])),
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
  //  15 — FINAL VERDICT
  // ══════════════════════════════════════════════════════════════════
  Widget _verdict(AppLocalizations l) {
    final verdict = _titleCase(_str('compatibility_verdict'));
    final proceed = _str('proceed_with_marriage_recommendation');
    final col = proceed.toLowerCase().contains('recommended') && !proceed.toLowerCase().contains('not') ? KColors.green : KColors.gold;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.rocket_launch_rounded, title: l.kmVerdictTitle, color: KColors.gold),
      if (verdict.isNotEmpty) Container(padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [col.withOpacity(0.18), AppColors.card.withOpacity(0.4)]),
          borderRadius: BorderRadius.circular(18), border: Border.all(color: col.withOpacity(0.3))),
        child: Column(children: [
          const Text('💍', style: TextStyle(fontSize: 30)),
          const SizedBox(height: 8),
          Text(verdict, style: const TextStyle(color: AppColors.ivory, fontSize: 20, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
          if (proceed.isNotEmpty) ...[const SizedBox(height: 8),
            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: col.withOpacity(0.16), borderRadius: BorderRadius.circular(20)),
              child: Text(_titleCase(proceed), style: TextStyle(color: col, fontSize: 12.5, fontWeight: FontWeight.w800)))],
          if (_str('verdict_explanation').isNotEmpty) ...[const SizedBox(height: 10),
            Text(_str('verdict_explanation'), style: const TextStyle(color: AppColors.parchment, fontSize: 12, height: 1.5), textAlign: TextAlign.center)],
        ])),
      const SizedBox(height: 10),
      _statTile(l.kmRealizationPotential, _sc('relationship_realization_potential_score')),
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
    double layer(String k) { final v = b[k]; return v is Map ? ((v['strength'] is num ? v['strength'] as num : null)?.toDouble() ?? 0) : 0; }
    final layers = <List<Object>>[
      [l.kmLayerAshtakoot, layer('ashtakoot')],
      [l.kmLayerD9, layer('d9_navamsa')],
      [l.kmLayerMangalPapa, layer('mangal_papasamya')],
      [l.kmLayerVenusMars, layer('venus_mars')],
      [l.kmLayerDashaSync, layer('dasha_sync')],
      [l.kmLayerH7H8, layer('h7_h8_cross')],
      [l.kmLayerAkResonance, layer('ak_resonance')],
      [l.kmLayerDomains, layer('domain_dimensions')],
    ];
    final plain = _str('plain_statement');
    final disclaimer = _str('milan_disclaimer');
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
    final topics = <String>[l.kmTopicAshtakoot, l.kmTopicMangal, l.kmTopicD9, l.kmTopicTiming, l.kmTopicRisks, l.kmTopicGrowth, l.kmTopicRemedies, l.kmTopicVerdict];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KSectionHeader(icon: Icons.forum_rounded, title: l.crDiscussAi, color: AppColors.gold),
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
        Text(name, style: const TextStyle(color: AppColors.ivory, fontSize: 11, fontWeight: FontWeight.w700)),
        const Text('OPEN ↗', style: TextStyle(color: AppColors.smoke, fontSize: 7, letterSpacing: 1)),
      ])))));

  void _copyTopic(String topic) {
    final q = '$topic — based on the Kundli Milan report for ${widget.name1} & ${widget.name2}.\n\n${_buildPrompt(_data)}';
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
      Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
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
    final overall = d['unified_compatibility_score'] ?? '?';
    final grade = d['unified_grade'] ?? '';
    final verdict = d['compatibility_verdict'] ?? '';
    final jsonStr = const JsonEncoder.withIndent('  ').convert(d);
    return '''You are a Vedic marriage-compatibility advisor. Analyze this Kundli Milan report for ${widget.name1} & ${widget.name2} and provide actionable insights.

Key highlights:
- Unified compatibility: $overall/100 ($grade)
- Ashtakoot: ${d['ashtakoot_total_score'] ?? '?'}/36
- Verdict: $verdict

Full report data (JSON):
$jsonStr

Please explain the key findings in simple language, highlight the most important timing windows and risks to address, and suggest practical next steps.''';
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
}
