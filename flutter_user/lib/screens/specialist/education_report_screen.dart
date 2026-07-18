import 'dart:convert';
import 'package:flutter/material.dart';
import '../../l10n/gen/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';

class EducationReportScreen extends StatefulWidget {
  final String chartId, chartName;
  final Map<String, dynamic>? preloadedData;
  const EducationReportScreen({super.key, required this.chartId, required this.chartName, this.preloadedData});

  @override
  State<EducationReportScreen> createState() => _EduState();
}

class _EduState extends State<EducationReportScreen> {
  final _api = ApiService();
  Map<String, dynamic>? _d;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.preloadedData != null) { _d = widget.preloadedData; _loading = false; }
    else _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final r = await _api.runSpecialist('education', widget.chartId);
      if (!mounted) return;
      if (r['statusCode'] == 200 && r['status'] == 'success')
        setState(() { _d = (r['data'] as Map).cast<String, dynamic>(); _loading = false; });
      else setState(() { _error = r['detail']?.toString() ?? 'Failed'; _loading = false; });
    } catch (e) { if (!mounted) return; setState(() { _error = e.toString(); _loading = false; }); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color(0xFF0A0A24),
      body: _loading ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : _error != null ? _errV()
          : _d != null ? _report() : const SizedBox.shrink());
  }

  Widget _errV() => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    const Icon(Icons.error_outline, color: AppColors.error, size: 48), const SizedBox(height: 12),
    Padding(padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(_error!, style: const TextStyle(color: AppColors.smoke), textAlign: TextAlign.center)),
    const SizedBox(height: 16), ElevatedButton(onPressed: _load, child: Text(AppLocalizations.of(context)?.retry ?? 'Retry')),
  ]));

  Widget _report() {
    final l = AppLocalizations.of(context)!;
    final d = _d!;
    return CustomScrollView(slivers: [
      SliverAppBar(backgroundColor: const Color(0xFF0A0A24), pinned: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.ivory), onPressed: () => Navigator.pop(context)),
        title: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
          Text(widget.chartName.toUpperCase(), style: const TextStyle(color: AppColors.gold, fontSize: 9, letterSpacing: 1.5, fontFamily: 'monospace')),
          Text.rich(TextSpan(children: [
            TextSpan(text: '${l.educationWord} ', style: const TextStyle(color: AppColors.ivory, fontSize: 18, fontWeight: FontWeight.w600)),
            TextSpan(text: l.learningSuffix, style: const TextStyle(color: AppColors.gold, fontSize: 18, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500)),
          ])),
        ]),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.refresh, color: AppColors.ivory, size: 18), onPressed: _load)],
      ),
      SliverList(delegate: SliverChildListDelegate([
        _heroScores(d), _intellectualProfile(d), _subjectKaraka(d), _houseFoundation(d),
        _mercuryJupiter(d), _yogas(d), _divisionals(d), _subjectRanking(d),
        _degreeLikelihood(d), _studyPeriods(d), _learningPrefs(d), _challengesGifts(d),
        _remedies(d), _verdict(d), _confidence(d), _aiBar(d), const SizedBox(height: 30),
      ])),
    ]);
  }

  // ═══ HERO SCORES ═══
  Widget _heroScores(Map d) {
    final l = AppLocalizations.of(context)!;
    return Container(margin: const EdgeInsets.fromLTRB(16, 12, 16, 12), padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.gold.withOpacity(0.10), AppColors.saffron.withOpacity(0.04)]),
        borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.gold.withOpacity(0.25))),
      child: Column(children: [
        _label('📚 ${l.coreEducationScores}'),
        const SizedBox(height: 14),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _ring(_n(d, 'overall_education_strength_score'), l.overallStrength, AppColors.gold),
          _ring(_n(d, 'academic_success_potential_score'), l.academicSuccess, AppColors.aurora),
          _ring(_n(d, 'learning_capacity_score'), l.learningCapacity, AppColors.cosmicPink),
        ]),
        const SizedBox(height: 14),
        Container(padding: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColors.gold.withOpacity(0.2), width: 0.5))),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _mini(_n(d, 'memory_retention_score'), l.memory),
            _mini(_n(d, 'intellectual_strength_score'), l.intelligence),
            _mini(_n(d, 'research_capacity_score'), l.research),
          ])),
      ]));
  }

  // ═══ INTELLECTUAL PROFILE ═══
  Widget _intellectualProfile(Map d) {
    final style = d['learning_style_signature']?.toString() ?? '';
    final archetype = d['intellectual_archetype']?.toString() ?? '';
    final modality = d['visual_vs_auditory_vs_kinesthetic']?.toString() ?? '';
    if (style.isEmpty && archetype.isEmpty) return const SizedBox.shrink();
    final l = AppLocalizations.of(context)!;
    return Column(children: [
      _secH(l.hdrIntellectualProfile, '', '3 KEYS'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.cosmicPink.withOpacity(0.15), const Color(0xFF4A3B8C).withOpacity(0.15)]),
          borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.cosmicPink.withOpacity(0.3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l.learningSignature, style: const TextStyle(color: AppColors.cosmicPink, fontSize: 9, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(_tc(style), style: const TextStyle(color: AppColors.ivory, fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'serif')),
          if (archetype.isNotEmpty) ...[const SizedBox(height: 4),
            Text('Archetype: ${_tc(archetype)}', style: const TextStyle(color: AppColors.lavender, fontSize: 11, fontStyle: FontStyle.italic))],
          if (modality.isNotEmpty) ...[const SizedBox(height: 8),
            Wrap(spacing: 6, children: modality.split('-').where((m) => m.isNotEmpty).take(3).toList().asMap().entries.map((e) =>
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: e.key == 0 ? AppColors.aurora.withOpacity(0.2) : Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(20), border: Border.all(color: e.key == 0 ? AppColors.aurora.withOpacity(0.5) : Colors.white12)),
                child: Text(e.key == 0 ? '★ ${e.value.toUpperCase()}' : e.value.toUpperCase(),
                  style: TextStyle(color: e.key == 0 ? AppColors.aurora : AppColors.smoke, fontSize: 9, fontWeight: FontWeight.w700, fontFamily: 'monospace')))).toList())],
        ])),
    ]);
  }

  // ═══ SUBJECT KARAKA ═══
  Widget _subjectKaraka(Map d) {
    final planet = d['amatyakaraka_planet']?.toString() ?? '';
    final direction = d['amatyakaraka_subject_direction']?.toString() ?? '';
    if (planet.isEmpty) return const SizedBox.shrink();
    final l = AppLocalizations.of(context)!;
    final symbols = {'Sun': '☉', 'Moon': '☽', 'Mars': '♂', 'Mercury': '☿', 'Jupiter': '♃', 'Venus': '♀', 'Saturn': '♄'};
    return Column(children: [
      _secH(l.hdrSubjectKaraka, '', '4 KEYS'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.gold.withOpacity(0.12), AppColors.gold.withOpacity(0.02)]),
          borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.gold.withOpacity(0.25))),
        child: Row(children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [AppColors.gold, AppColors.saffron]), borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(symbols[planet] ?? '✦', style: const TextStyle(color: AppColors.midnight, fontSize: 20, fontWeight: FontWeight.w700)))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('AMATYAKARAKA', style: TextStyle(color: AppColors.gold, fontSize: 8, letterSpacing: 1.5, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
            Text(planet, style: const TextStyle(color: AppColors.ivory, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'serif')),
            if (direction.isNotEmpty) Text('Subject → $direction', maxLines: 2, overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.lavender, fontSize: 9, fontStyle: FontStyle.italic)),
          ])),
        ])),
    ]);
  }

  // ═══ 4TH + 5TH + 9TH HOUSE FOUNDATION ═══
  Widget _houseFoundation(Map d) {
    final l = AppLocalizations.of(context)!;
    return Column(children: [
      _secH(l.hdrHouseFoundations, '', '3 HOUSES'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(children: [
          Expanded(child: _houseCard('4TH', 'Primary', d['fourth_house_sign_name']?.toString() ?? '—',
            d['fourth_lord_planet']?.toString() ?? '—', _n(d, 'primary_education_quality_score'), false)),
          const SizedBox(width: 6),
          Expanded(child: _houseCard('5TH ★', 'Intelligence', d['fifth_house_sign_name']?.toString() ?? '—',
            d['fifth_lord_planet']?.toString() ?? '—', _n(d, 'intelligence_strength_score'), true)),
          const SizedBox(width: 6),
          Expanded(child: _houseCard('9TH', 'Higher Ed', d['ninth_house_sign_name']?.toString() ?? '—',
            d['ninth_lord_planet']?.toString() ?? '—', _n(d, 'higher_learning_strength_score'), false)),
        ])),
    ]);
  }

  Widget _houseCard(String num, String purpose, String sign, String lord, double strength, bool featured) {
    return Container(padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: featured ? LinearGradient(colors: [AppColors.gold.withOpacity(0.15), AppColors.saffron.withOpacity(0.08)]) : null,
        color: featured ? null : const Color(0xFF1A1642).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: featured ? AppColors.gold.withOpacity(0.4) : AppColors.gold.withOpacity(0.15))),
      child: Column(children: [
        Text(num, style: TextStyle(color: featured ? AppColors.gold : AppColors.smoke, fontSize: 9, fontFamily: 'monospace', fontWeight: FontWeight.w700)),
        Text(purpose, style: const TextStyle(color: AppColors.smoke, fontSize: 7, fontFamily: 'monospace')),
        const SizedBox(height: 4),
        Text(sign, style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'serif')),
        Text('L: $lord', style: const TextStyle(color: AppColors.lavender, fontSize: 8)),
        const SizedBox(height: 4),
        Text(strength.toStringAsFixed(1), style: TextStyle(color: featured ? AppColors.gold : AppColors.aurora, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'serif')),
        Text(featured ? 'STRENGTH' : 'QUALITY', style: const TextStyle(color: AppColors.smoke, fontSize: 6, fontFamily: 'monospace')),
      ]));
  }

  // ═══ MERCURY & JUPITER ═══
  Widget _mercuryJupiter(Map d) {
    final mc = (d['mercury_condition'] as Map?)?.cast<String, dynamic>() ?? {};
    final jc = (d['jupiter_condition'] as Map?)?.cast<String, dynamic>() ?? {};
    if (mc.isEmpty && jc.isEmpty) return const SizedBox.shrink();
    final l = AppLocalizations.of(context)!;
    return Column(children: [
      _secH(l.hdrMercuryJupiter, '', '14 KEYS'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(children: [
          Expanded(child: _pillarCard('☿ Mercury', mc, _n(d, 'mercury_strength_score'), AppColors.aurora)),
          const SizedBox(width: 8),
          Expanded(child: _pillarCard('♃ Jupiter', jc, _n(d, 'jupiter_strength_score'), AppColors.gold)),
        ])),
    ]);
  }

  Widget _pillarCard(String name, Map<String, dynamic> c, double strength, Color color) {
    final dignity = c['dignity']?.toString() ?? '—';
    return Container(padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.6), borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.25))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(name, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700, fontFamily: 'serif')),
        const SizedBox(height: 6),
        _kvRow('HOUSE', '${c['house'] ?? "?"}H'), _kvRow('SIGN', c['sign_name']?.toString() ?? '—'),
        _kvRow('NAKSHATRA', c['nakshatra']?.toString() ?? '—'),
        const SizedBox(height: 4),
        _dignityBadge(dignity),
        const SizedBox(height: 4),
        Text('Str: ${strength.toStringAsFixed(1)}', style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
      ]));
  }

  // ═══ EDUCATION YOGAS ═══
  Widget _yogas(Map d) {
    final yogas = [
      ['Budha Aditya', d['budha_aditya_yoga_present'] == true],
      ['Gaja Kesari', d['gaja_kesari_yoga_present'] == true],
      ['Saraswati', d['saraswati_yoga_present'] == true],
    ];
    final l = AppLocalizations.of(context)!;
    return Column(children: [
      _secH(l.hdrEducationYogas, '', '3 KEYS'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(children: yogas.map((y) {
          final present = y[1] as bool;
          final c = present ? AppColors.success : AppColors.smoke;
          return Expanded(child: Container(margin: const EdgeInsets.symmetric(horizontal: 3), padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: c.withOpacity(present ? 0.12 : 0.06), borderRadius: BorderRadius.circular(10),
              border: Border.all(color: c.withOpacity(present ? 0.4 : 0.15))),
            child: Column(children: [
              Text(y[0] as String, style: TextStyle(color: c, fontSize: 9, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
              Text(present ? '✓ PRESENT' : '✗ ABSENT', style: TextStyle(color: c, fontSize: 8, fontFamily: 'monospace', fontWeight: FontWeight.w700)),
            ])));
        }).toList())),
      if (!yogas.any((y) => y[1] as bool)) Container(margin: const EdgeInsets.fromLTRB(16, 8, 16, 4), padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.1),
          borderRadius: const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
          border: const Border(left: BorderSide(color: AppColors.warning, width: 3))),
        child: Text(AppLocalizations.of(context)?.noClassicalYogas ?? 'Success comes from consistent effort.',
          style: TextStyle(color: AppColors.ivory, fontSize: 9, height: 1.4, fontStyle: FontStyle.italic))),
    ]);
  }

  // ═══ DIVISIONAL VALIDATION ═══
  Widget _divisionals(Map d) {
    final d24 = (d['d24_validation'] as Map?)?.cast<String, dynamic>() ?? {};
    final d4 = (d['d4_validation'] as Map?)?.cast<String, dynamic>() ?? {};
    final d9 = (d['d9_validation'] as Map?)?.cast<String, dynamic>() ?? {};
    if (d24.isEmpty && d4.isEmpty) return const SizedBox.shrink();
    final l = AppLocalizations.of(context)!;
    return Column(children: [
      _secH(l.hdrDivisionalValidation, '', 'D24·D4·D9·D60'),
      if (d24.isNotEmpty) _divCard('D-24 SIDDHAMSA ★ · LEARNING', [
        ['Mercury', d24['d24_mercury_dignity']], ['Jupiter', d24['d24_jupiter_dignity']],
        ['4L', d24['d24_4_lord_dignity']], ['5L', d24['d24_5_lord_dignity']],
        ['AK', d24['d24_amatyakaraka_dignity']],
      ], d24['d24_overall_education_standing'], d24['d24_primary_education_signature']),
      if (d4.isNotEmpty) _divCard('D-4 CHATURTHAMSA · FORMAL', [
        ['4L', d4['d4_4_lord_dignity']], ['Mercury', d4['d4_mercury_dignity']],
        ['Jupiter', d4['d4_jupiter_dignity']], ['5L', d4['d4_5_lord_dignity']],
      ], '${(d4['d4_formal_education_strength_score'] as num?)?.toStringAsFixed(0) ?? "?"}%', d4['d4_formal_education_signature']),
      if (d9.isNotEmpty) _divCard('D-9 NAVAMSA · DHARMA', [
        ['Jupiter', d9['d9_jupiter_dignity']], ['9L', d9['d9_9_lord_dignity']], ['Mercury', d9['d9_mercury_dignity']],
      ], '${(d9['d9_dharmic_learning_score'] as num?)?.toStringAsFixed(0) ?? "?"}%', d9['d9_learning_dharma_signature']),
    ]);
  }

  Widget _divCard(String title, List<List<dynamic>> rows, String? verdict, String? notes) {
    return Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 8), padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold.withOpacity(0.15))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.gold, AppColors.saffron]), borderRadius: BorderRadius.circular(8)),
          child: Text(title, style: const TextStyle(color: AppColors.midnight, fontSize: 8, letterSpacing: 1, fontFamily: 'monospace', fontWeight: FontWeight.w700))),
        const SizedBox(height: 8),
        ...rows.where((r) => r[1] != null).map((r) => _dignityRow(r[0] as String, r[1] as String)),
        if (verdict != null) ...[const SizedBox(height: 6),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.08), borderRadius: BorderRadius.circular(6)),
            child: Row(children: [Text(AppLocalizations.of(context)!.standing, style: const TextStyle(color: AppColors.smoke, fontSize: 8, fontFamily: 'monospace')),
              const Spacer(), Text(verdict.toUpperCase(), style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700))]))],
        if (notes != null) ...[const SizedBox(height: 4),
          Text(notes, style: const TextStyle(color: AppColors.lavender, fontSize: 9, fontStyle: FontStyle.italic), maxLines: 3)],
      ]));
  }

  // ═══ SUBJECT RANKING ═══
  Widget _subjectRanking(Map d) {
    final list = (d['subject_affinity_ranking'] as List?) ?? [];
    if (list.isEmpty) return const SizedBox.shrink();
    final l = AppLocalizations.of(context)!;
    return Column(children: [
      _secH(l.hdrSubjectRanking, '', '${list.length} SUBJECTS'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(14)),
        child: Column(children: list.asMap().entries.map((e) {
          final i = e.key; final item = (e.value as Map).cast<String, dynamic>();
          final name = _tc(item['subject']?.toString() ?? '');
          final score = (item['score'] as num?)?.toDouble() ?? 0;
          final isTop = i < 3;
          final c = isTop ? AppColors.gold : AppColors.smoke;
          return Container(margin: const EdgeInsets.only(bottom: 6), padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            decoration: BoxDecoration(color: isTop ? AppColors.gold.withOpacity(0.06) : Colors.transparent, borderRadius: BorderRadius.circular(6)),
            child: Row(children: [
              SizedBox(width: 22, child: Text('${(i + 1).toString().padLeft(2, '0')}',
                style: TextStyle(color: isTop ? AppColors.gold : AppColors.smoke, fontSize: 10, fontFamily: 'monospace', fontWeight: FontWeight.w700))),
              const SizedBox(width: 8),
              Expanded(child: Text(name, style: TextStyle(color: isTop ? AppColors.ivory : AppColors.smoke, fontSize: 11, fontWeight: isTop ? FontWeight.w600 : FontWeight.normal))),
              SizedBox(width: 60, child: ClipRRect(borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(value: score / 100, minHeight: 4, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c)))),
              const SizedBox(width: 8),
              SizedBox(width: 30, child: Text(score.toStringAsFixed(1), textAlign: TextAlign.right,
                style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.w700, fontFamily: 'monospace'))),
            ]));
        }).toList())),
    ]);
  }

  // ═══ DEGREE LIKELIHOOD ═══
  Widget _degreeLikelihood(Map d) {
    final items = [
      ['FORMAL DEGREE', _n(d, 'formal_degree_likelihood_score')],
      ['POSTGRADUATE', _n(d, 'postgraduate_likelihood_score')],
      ['DOCTORATE', _n(d, 'doctorate_likelihood_score')],
      ['FOREIGN ED', _n(d, 'foreign_education_likelihood_score')],
    ];
    final l = AppLocalizations.of(context)!;
    return Column(children: [
      _secH(l.hdrDegreeLikelihood, '', '4 LEVELS'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Wrap(spacing: 8, runSpacing: 8, children: items.map((item) {
          final score = item[1] as double;
          final c = score >= 60 ? AppColors.success : score >= 45 ? AppColors.gold : score >= 30 ? AppColors.warning : AppColors.error;
          return SizedBox(width: (MediaQuery.of(context).size.width - 48) / 2,
            child: Container(padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(12),
                border: Border.all(color: c.withOpacity(0.2))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item[0] as String, style: const TextStyle(color: AppColors.smoke, fontSize: 8, fontFamily: 'monospace', letterSpacing: 1)),
                Text(score.toStringAsFixed(1), style: TextStyle(color: c, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'serif')),
                ClipRRect(borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(value: score / 100, minHeight: 4, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c))),
              ])));
        }).toList())),
    ]);
  }

  // ═══ STUDY PERIODS ═══
  Widget _studyPeriods(Map d) {
    final early = (d['early_schooling_windows'] as List?) ?? [];
    final higher = (d['higher_education_windows'] as List?) ?? [];
    final postgrad = (d['postgrad_research_windows'] as List?) ?? [];
    if (early.isEmpty && higher.isEmpty && postgrad.isEmpty) return const SizedBox.shrink();
    final l = AppLocalizations.of(context)!;
    return Column(children: [
      _secH(l.hdrStudyPeriods, '', '${early.length + higher.length + postgrad.length} ENTRIES'),
      ...early.take(2).map((w) => _windowCard(w, l.earlySchooling, 'A', AppColors.aurora, false)),
      ...higher.take(2).map((w) => _windowCard(w, '${l.higherEducation} ★', '★', AppColors.gold, true)),
      ...postgrad.take(2).map((w) => _windowCard(w, l.postgradResearch, '▲', AppColors.cosmicPink, false)),
    ]);
  }

  Widget _windowCard(dynamic w, String title, String icon, Color c, bool isPeak) {
    if (w is! Map) return const SizedBox.shrink();
    final m = (w).cast<String, dynamic>();
    return Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 6), padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: isPeak ? LinearGradient(colors: [AppColors.gold.withOpacity(0.10), AppColors.gold.withOpacity(0.02)]) : null,
        color: isPeak ? null : const Color(0xFF1A1642).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12), border: Border.all(color: c.withOpacity(isPeak ? 0.4 : 0.2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Text(title, style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'serif')),
          const Spacer(), Text(icon, style: TextStyle(color: c, fontSize: 14))]),
        const SizedBox(height: 4),
        Text(m['dasha']?.toString() ?? '', style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w700)),
        Text(m['window']?.toString() ?? '', style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontFamily: 'monospace')),
        if (m['note'] != null) Text(m['note'].toString(), style: const TextStyle(color: AppColors.lavender, fontSize: 9, fontStyle: FontStyle.italic)),
      ]));
  }

  // ═══ LEARNING PREFERENCES ═══
  Widget _learningPrefs(Map d) {
    final rows = [
      ['COLLAB VS SOLO', d['collaborative_vs_solo_study_preference']],
      ['MORNING VS EVENING', d['morning_vs_evening_learner']],
      ['IDEAL ENVIRONMENT', d['ideal_study_environment']],
    ].where((r) => r[1] != null).toList();
    if (rows.isEmpty) return const SizedBox.shrink();
    final l = AppLocalizations.of(context)!;
    return Column(children: [
      _secH(l.hdrLearningPreferences, '', '${rows.length} KEYS'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(14)),
        child: Column(children: rows.map((r) => Container(padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0x0DFFFFFF)))),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(r[0] as String, style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontFamily: 'monospace')),
            Flexible(child: Text(_tc(r[1].toString()), textAlign: TextAlign.right,
              style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w600))),
          ]))).toList())),
    ]);
  }

  // ═══ CHALLENGES & GIFTS ═══
  Widget _challengesGifts(Map d) {
    final conc = _n(d, 'concentration_difficulty_score');
    final breakRisk = _n(d, 'education_break_risk_score');
    final gifts = (d['cognitive_gifts'] as List?) ?? [];
    final abilities = (d['natural_learning_abilities'] as List?) ?? [];
    final l = AppLocalizations.of(context)!;
    return Column(children: [
      _secH(l.hdrChallengesGifts, '', '8 KEYS'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Challenges
          Expanded(child: Container(padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.08), borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.warning.withOpacity(0.2))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('⚠ ${l.challenges}', style: const TextStyle(color: AppColors.warning, fontSize: 8, fontFamily: 'monospace', fontWeight: FontWeight.w700, letterSpacing: 1)),
              const SizedBox(height: 6),
              _challengeBar('Concentration', conc), _challengeBar('Break Risk', breakRisk),
              const SizedBox(height: 4),
              Text(conc <= 30 && breakRisk <= 30 ? 'LOW · MANAGEABLE' : 'MODERATE',
                style: const TextStyle(color: AppColors.smoke, fontSize: 7, fontFamily: 'monospace')),
            ]))),
          const SizedBox(width: 8),
          // Gifts
          Expanded(child: Container(padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.success.withOpacity(0.08), borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.success.withOpacity(0.2))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('✦ ${l.cognitiveGifts}', style: const TextStyle(color: AppColors.success, fontSize: 8, fontFamily: 'monospace', fontWeight: FontWeight.w700, letterSpacing: 1)),
              const SizedBox(height: 6),
              ...gifts.take(3).map((g) => Container(margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: AppColors.success.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                child: Text('★ ${g.toString().toUpperCase()}', style: const TextStyle(color: AppColors.success, fontSize: 8, fontFamily: 'monospace', fontWeight: FontWeight.w700)))),
              if (abilities.isNotEmpty) ...[const SizedBox(height: 4),
                Text(l.naturalAbilities, style: const TextStyle(color: AppColors.success, fontSize: 7, fontFamily: 'monospace', letterSpacing: 1)),
                ...abilities.take(3).map((a) => Container(margin: const EdgeInsets.only(top: 3),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(4)),
                  child: Text(a.toString().toUpperCase(), style: const TextStyle(color: AppColors.aurora, fontSize: 7, fontFamily: 'monospace'))))],
            ]))),
        ])),
    ]);
  }

  Widget _challengeBar(String label, double v) {
    return Padding(padding: const EdgeInsets.only(bottom: 4), child: Column(children: [
      Row(children: [Text(label, style: const TextStyle(color: AppColors.ivory, fontSize: 9)),
        const Spacer(), Text(v.toStringAsFixed(0), style: const TextStyle(color: AppColors.warning, fontSize: 9, fontFamily: 'monospace', fontWeight: FontWeight.w700))]),
      ClipRRect(borderRadius: BorderRadius.circular(2),
        child: LinearProgressIndicator(value: v / 100, minHeight: 3, backgroundColor: Colors.white10, valueColor: const AlwaysStoppedAnimation(AppColors.warning))),
    ]));
  }

  // ═══ REMEDIES ═══
  Widget _remedies(Map d) {
    final list = (d['astrological_remedies'] as List?)?.where((r) => r is Map).toList() ?? [];
    if (list.isEmpty) return const SizedBox.shrink();
    final symbols = {'Saraswati': 'श्री', 'Mercury': '☿', 'Jupiter': '♃', 'Sun': '☉', 'Moon': '☽'};
    final l = AppLocalizations.of(context)!;
    return Column(children: [
      _secH(l.hdrSaraswatiRemedies, '', '${list.length} KEYS'),
      ...list.take(5).map((r) {
        final rem = (r as Map).cast<String, dynamic>();
        final deity = rem['deity']?.toString() ?? '';
        final text = rem['remedy']?.toString() ?? '';
        final sym = symbols.entries.firstWhere((e) => deity.toLowerCase().contains(e.key.toLowerCase()), orElse: () => const MapEntry('', '✦')).value;
        return Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 6), padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gold.withOpacity(0.2))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(width: 36, height: 36, decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.gold, AppColors.saffron]), borderRadius: BorderRadius.circular(10)),
              child: Center(child: Text(sym, style: const TextStyle(color: AppColors.midnight, fontSize: 14, fontWeight: FontWeight.w700)))),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(deity, style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'serif')),
              const SizedBox(height: 3),
              Text(text, style: const TextStyle(color: AppColors.ivory, fontSize: 10, height: 1.4)),
            ])),
          ]));
      }),
    ]);
  }

  // ═══ VERDICT ═══
  Widget _verdict(Map d) {
    final verdict = d['overall_education_verdict']?.toString() ?? '';
    final linkage = d['education_to_career_linkage_signature']?.toString() ?? '';
    final direction = d['primary_education_direction_recommendation']?.toString() ?? '';
    if (verdict.isEmpty) return const SizedBox.shrink();
    final l = AppLocalizations.of(context)!;
    return Column(children: [
      _secH(l.hdrFinalVerdict, '', '2 KEYS'),
      Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.gold.withOpacity(0.12), const Color(0xFF4A3B8C).withOpacity(0.1)]),
          borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.gold.withOpacity(0.3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _label('★ ${l.studentVerdict} ★'),
          const SizedBox(height: 8),
          Text(_tc(verdict), style: const TextStyle(color: AppColors.ivory, fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'serif')),
          if (direction.isNotEmpty) ...[const SizedBox(height: 6),
            Text(direction, style: const TextStyle(color: AppColors.lavender, fontSize: 10, height: 1.4, fontStyle: FontStyle.italic))],
          if (linkage.isNotEmpty) ...[const SizedBox(height: 10),
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(
              color: AppColors.aurora.withOpacity(0.08), borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.aurora.withOpacity(0.2))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l.educationCareerLinkage, style: const TextStyle(color: AppColors.aurora, fontSize: 8, fontFamily: 'monospace', letterSpacing: 1, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(_tc(linkage), style: const TextStyle(color: AppColors.ivory, fontSize: 12, fontWeight: FontWeight.w600)),
              ]))],
        ])),
    ]);
  }

  // ═══ CONFIDENCE ═══
  Widget _confidence(Map d) {
    final raw = (d['confidence_score'] as num?)?.toDouble() ?? 0;
    final pct = raw <= 1.0 ? raw * 100 : raw;
    final stmt = d['plain_statement']?.toString() ?? '';
    final bd = (d['confidence_breakdown'] as Map?)?.cast<String, dynamic>() ?? {};
    final layers = bd.entries.where((e) => e.value is num).take(8).toList();
    final l = AppLocalizations.of(context)!;
    return Column(children: [
      _secH(l.analysisConfidence, '', 'QUALITY'),
      Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 12), padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.aurora.withOpacity(0.12), const Color(0xFF4A3B8C).withOpacity(0.15)]),
          borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.aurora.withOpacity(0.3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            SizedBox(width: 70, height: 70, child: Stack(alignment: Alignment.center, children: [
              SizedBox(width: 70, height: 70, child: CircularProgressIndicator(value: pct / 100, strokeWidth: 5,
                backgroundColor: Colors.white10, valueColor: const AlwaysStoppedAnimation(AppColors.aurora))),
              Text('${pct.toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.aurora, fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'serif')),
            ])),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.confidence, style: const TextStyle(color: AppColors.aurora, fontSize: 8, letterSpacing: 2, fontFamily: 'monospace')),
              Text(pct >= 70 ? l.reliabilityGoodEdu : pct >= 50 ? l.reliabilityModerate : l.reliabilityLow,
                style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'serif')),
            ])),
          ]),
          if (stmt.isNotEmpty) ...[const SizedBox(height: 8), Text(stmt, style: const TextStyle(color: AppColors.lavender, fontSize: 10, height: 1.5))],
          if (layers.isNotEmpty) ...[const SizedBox(height: 10),
            ...layers.map((e) {
              final v = ((e.value as num).toDouble() * (e.value is double && (e.value as double) <= 1.0 ? 100 : 1)).clamp(0, 100).toDouble();
              return Padding(padding: const EdgeInsets.only(bottom: 4), child: Column(children: [
                Row(children: [Text(e.key.toUpperCase(), style: const TextStyle(color: AppColors.lavender, fontSize: 9)),
                  const Spacer(), Text('${v.toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.gold, fontSize: 9, fontFamily: 'monospace', fontWeight: FontWeight.w700))]),
                ClipRRect(borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(value: v / 100, minHeight: 3, backgroundColor: Colors.white10, valueColor: const AlwaysStoppedAnimation(AppColors.aurora))),
              ]));
            })],
        ])),
    ]);
  }

  // ═══ AI BAR ═══
  Widget _aiBar(Map d) {
    final l = AppLocalizations.of(context)!;
    return Container(margin: const EdgeInsets.fromLTRB(16, 16, 16, 8), padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [const Color(0xFF1A1642).withOpacity(0.8), const Color(0xFF0A0A24)]),
        borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.gold.withOpacity(0.25))),
      child: Column(children: [
        _label('★ ${l.discussReportWithAI} ★'), const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _aiBtn('G', 'ChatGPT', const LinearGradient(colors: [Color(0xFF10A37F), Color(0xFF1A7F64)]), () => _launchAi(d, 'chatgpt'))),
          const SizedBox(width: 8),
          Expanded(child: _aiBtn('C', 'Claude', const LinearGradient(colors: [Color(0xFFD97757), Color(0xFFB85B3F)]), () => _launchAi(d, 'claude'))),
          const SizedBox(width: 8),
          Expanded(child: _aiBtn('✦', 'Gemini', const LinearGradient(colors: [Color(0xFF4285F4), Color(0xFF9B72CB)]), () => _launchAi(d, 'gemini'))),
        ]),
        const SizedBox(height: 10),
        GestureDetector(onTap: () { Clipboard.setData(ClipboardData(text: _prompt(d)));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.reportCopied))); },
          child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(10)),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.copy, size: 14, color: AppColors.smoke), const SizedBox(width: 6),
              Text(l.copyFullReport, style: const TextStyle(color: AppColors.smoke, fontSize: 10))]))),
      ]));
  }

  Widget _aiBtn(String icon, String name, Gradient g, VoidCallback onTap) => GestureDetector(onTap: onTap,
    child: Container(padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold.withOpacity(0.2))),
      child: Column(children: [
        Container(width: 26, height: 26, decoration: BoxDecoration(gradient: g, borderRadius: BorderRadius.circular(8)),
          child: Center(child: Text(icon, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)))),
        const SizedBox(height: 5), Text(name, style: const TextStyle(color: AppColors.ivory, fontSize: 9, fontWeight: FontWeight.w700)),
        Text(AppLocalizations.of(context)!.openLink, style: const TextStyle(color: AppColors.smoke, fontSize: 7, fontFamily: 'monospace')),
      ])));

  String _prompt(Map d) {
    final j = const JsonEncoder.withIndent('  ').convert(d);
    return 'You are a Vedic education advisor. Analyze this education report for ${widget.chartName}.\n\n'
        'Overall: ${d['overall_education_strength_score'] ?? "?"}/100\nArchetype: ${d['intellectual_archetype'] ?? ""}\n'
        'Verdict: ${d['overall_education_verdict'] ?? ""}\nTop subjects: ${(d['top_3_subject_categories'] as List?)?.join(", ") ?? ""}\n\n'
        'Full JSON:\n$j\n\nExplain key findings and suggest actionable study strategies.';
  }

  Future<void> _launchAi(Map d, String ai) async {
    await Clipboard.setData(ClipboardData(text: _prompt(d)));
    final urls = {'chatgpt': 'https://chat.openai.com/', 'claude': 'https://claude.ai/new', 'gemini': 'https://gemini.google.com/app'};
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.copiedOpening(ai)), duration: const Duration(seconds: 3)));
    final uri = Uri.parse(urls[ai]!); if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  // ═══ HELPERS ═══
  double _n(Map d, String k) => (d[k] as num?)?.toDouble() ?? 0;
  static String _tc(String s) => s.replaceAll('_', ' ').replaceAll('-', ' ').split(' ')
      .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');

  Widget _ring(double v, String label, Color c) => Column(children: [
    SizedBox(width: 76, height: 76, child: Stack(alignment: Alignment.center, children: [
      SizedBox(width: 76, height: 76, child: CircularProgressIndicator(value: v / 100, strokeWidth: 6,
        backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c))),
      Text(v.toStringAsFixed(1), style: TextStyle(color: c, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'serif')),
    ])), const SizedBox(height: 6),
    Text(label, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.smoke, fontSize: 8, letterSpacing: 1, fontFamily: 'monospace', height: 1.2)),
  ]);

  Widget _mini(double v, String label) => Column(children: [
    Text(v.toStringAsFixed(1), style: const TextStyle(color: AppColors.gold, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'serif')),
    Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 7, fontFamily: 'monospace')),
  ]);

  Widget _label(String text) => Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    Container(width: 16, height: 1, color: AppColors.gold.withOpacity(0.4)), const SizedBox(width: 6),
    Text(text, style: const TextStyle(color: AppColors.gold, fontSize: 9, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
    const SizedBox(width: 6), Container(width: 16, height: 1, color: AppColors.gold.withOpacity(0.4)),
  ]);

  Widget _secH(String p, String s, String tag) => Container(padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text.rich(TextSpan(children: [
        TextSpan(text: '$p ', style: const TextStyle(color: AppColors.ivory, fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'serif')),
        TextSpan(text: s, style: const TextStyle(color: AppColors.gold, fontSize: 15, fontStyle: FontStyle.italic, fontFamily: 'serif')),
      ])),
      Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.gold.withOpacity(0.15))),
        child: Text(tag, style: const TextStyle(color: AppColors.smoke, fontSize: 8, letterSpacing: 1.5, fontFamily: 'monospace'))),
    ]));

  Widget _kvRow(String k, String v) => Padding(padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(k, style: const TextStyle(color: AppColors.smoke, fontSize: 8, fontFamily: 'monospace')),
      Text(v, style: const TextStyle(color: AppColors.gold, fontSize: 10, fontWeight: FontWeight.w600, fontFamily: 'serif')),
    ]));

  Widget _dignityBadge(String dignity) {
    final dl = dignity.toLowerCase();
    final c = dl.contains('exalt') || dl.contains('moolatrikona') ? AppColors.success
        : dl.contains('own') || dl.contains('swakshetra') ? AppColors.gold
        : dl.contains('friend') ? AppColors.aurora
        : dl.contains('neech') || dl.contains('enemy') ? AppColors.error : AppColors.smoke;
    return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: c.withOpacity(0.15), borderRadius: BorderRadius.circular(4), border: Border.all(color: c.withOpacity(0.4))),
      child: Text(dignity.toUpperCase(), style: TextStyle(color: c, fontSize: 8, fontFamily: 'monospace', fontWeight: FontWeight.w700)));
  }

  Widget _dignityRow(String planet, String dignity) {
    final dl = dignity.toLowerCase();
    final c = dl.contains('exalt') || dl.contains('moolatrikona') ? AppColors.success
        : dl.contains('own') || dl.contains('swakshetra') ? AppColors.gold
        : dl.contains('friend') ? AppColors.aurora
        : dl.contains('neech') || dl.contains('enemy') ? AppColors.error : AppColors.smoke;
    return Container(padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0x0DFFFFFF)))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(planet, style: const TextStyle(color: AppColors.ivory, fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'serif')),
        _dignityBadge(dignity),
      ]));
  }
}

