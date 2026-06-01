import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import 'report_components.dart';

class ChildProbabilityReportScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final List<String> participants;
  const ChildProbabilityReportScreen(
      {super.key, required this.data, required this.participants});

  static const _accent = Color(0xFFE8689C);
  static const _bg = Color(0xFF0A0A24);
  static const _cardBg = Color(0xFF1A1642);

  @override
  Widget build(BuildContext context) {
    final overall = _asMap(data['overall_probability']);
    final number = _asMap(data['number_of_children']);
    final timing = _asMap(data['timing_moola_dasha']);
    final fifth = _asMap(data['fifth_house_analysis']);
    final jupiter = _asMap(data['jupiter_analysis']);
    final d7 = _asMap(data['d7_saptamsa_analysis']);
    final beeja = _asMap(data['beeja_kshetra_sphuta']);
    final dosha = _asMap(data['dosha_analysis']);
    final remedies = _asMap(data['remedies']);
    final summary = _asMap(data['summary']);
    final header = _asMap(data['analysis_header']);
    final conf = (data['confidence_score'] as num?)?.toDouble();
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: _bg,
      body: CustomScrollView(slivers: [
        // ═══ APP BAR ═══
        SliverAppBar(
          backgroundColor: _bg,
          pinned: true,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.ivory),
              onPressed: () => Navigator.pop(context)),
          title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    participants.join(' & ').toUpperCase(),
                    style: const TextStyle(
                        color: AppColors.gold,
                        fontSize: 9,
                        letterSpacing: 1.5,
                        fontFamily: 'monospace'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const Text.rich(TextSpan(children: [
                  TextSpan(
                      text: 'Child ',
                      style: TextStyle(
                          color: AppColors.ivory,
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                  TextSpan(
                      text: 'Probability',
                      style: TextStyle(
                          color: _accent,
                          fontSize: 18,
                          fontStyle: FontStyle.italic)),
                ])),
              ]),
          centerTitle: true,
        ),

        SliverList(
            delegate: SliverChildListDelegate([
          // 1. HERO
          _buildHero(l, overall),

          // 2. PARTNER CARDS
          if (header.isNotEmpty) _buildPartnerCards(l, header),

          // 3. NUMBER OF CHILDREN
          if (number.isNotEmpty) ...[
            _header('Number of', 'Children'),
            _buildNumberOfChildren(l, number),
          ],

          // 4. TIMING (MOOLA DASHA)
          if (timing.isNotEmpty) ...[
            _header('Timing', 'Moola Dasha'),
            _buildTiming(l, timing),
          ],

          // 5. 5TH HOUSE ANALYSIS
          if (fifth.isNotEmpty) ...[
            _header('5th House', 'Analysis'),
            ...fifth.entries.map((e) => _buildFifthHouseCard(l, e.key, _asMap(e.value))),
          ],

          // 6. JUPITER ANALYSIS
          if (jupiter.isNotEmpty) ...[
            _header('Jupiter', 'Analysis'),
            ...jupiter.entries.map((e) => _buildJupiterCard(l, e.key, _asMap(e.value))),
          ],

          // 7. D7 SAPTAMSA
          if (d7.isNotEmpty) ...[
            _header('D7 Saptamsa', 'Analysis'),
            ...d7.entries.map((e) => _buildD7Card(l, e.key, _asMap(e.value))),
          ],

          // 8. BEEJA & KSHETRA
          if (beeja.isNotEmpty) ...[
            _header('Beeja & Kshetra', 'Sphuta'),
            _buildBeejaKshetra(l, beeja),
          ],

          // 9. DOSHA ANALYSIS
          if (dosha.isNotEmpty) ...[
            _header('Dosha', 'Analysis'),
            _buildDoshaAnalysis(l, dosha),
          ],

          // 10. REMEDIES
          if (remedies.isNotEmpty) ...[
            _header('Vedic', 'Remedies'),
            _buildRemedies(l, remedies),
          ],

          // 11. SUMMARY
          if (summary.isNotEmpty) _buildSummary(l, summary),

          // 12. CONFIDENCE
          if (conf != null) ...[
            ReportHeader('Analysis', 'Confidence', 'QUALITY'),
            ConfidenceBlock(
                score: conf,
                statement: data['confidence_explanation']?.toString(),
                breakdown: _asMap(data['confidence_breakdown'])),
          ],

          // 13. AI COPY BAR
          _buildAiCopyBar(context),
          const SizedBox(height: 40),
        ])),
      ]),
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // 1. HERO — Big score ring + grade + verdict + score component chips
  // ════════════════════════════════════════════════════════════════════

  Widget _buildHero(AppLocalizations l, Map<String, dynamic> overall) {
    final mainScore =
        (overall['overall_probability_score'] as num?)?.toDouble() ?? 0;
    final grade = overall['probability_grade']?.toString() ?? '';
    final band = overall['probability_band']?.toString() ?? '';
    final verdict = overall['combined_verdict']?.toString() ?? '';
    final sc = _scoreColor(mainScore);
    final components = _asMap(overall['score_components']);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            _accent.withOpacity(0.12),
            const Color(0xFF4A3B8C).withOpacity(0.1)
          ]),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _accent.withOpacity(0.3))),
      child: Column(children: [
        _label('PROGENY PROBABILITY'),
        const SizedBox(height: 14),

        // Main score ring
        SizedBox(
            width: 120,
            height: 120,
            child: Stack(alignment: Alignment.center, children: [
              SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                      value: (mainScore / 100).clamp(0, 1),
                      strokeWidth: 8,
                      backgroundColor: Colors.white.withOpacity(0.08),
                      valueColor: AlwaysStoppedAnimation(sc))),
              Column(mainAxisSize: MainAxisSize.min, children: [
                Text(mainScore.toStringAsFixed(0),
                    style: TextStyle(
                        color: sc,
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'serif')),
                Text(grade,
                    style: TextStyle(
                        color: sc,
                        fontSize: 10,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w600)),
              ]),
            ])),
        const SizedBox(height: 10),

        // Grade badge
        if (band.isNotEmpty)
          Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                  color: sc.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(band,
                  style: TextStyle(
                      color: sc, fontSize: 11, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center)),
        const SizedBox(height: 8),

        // Verdict text
        if (verdict.isNotEmpty)
          Text(verdict,
              style: const TextStyle(
                  color: AppColors.ivory,
                  fontSize: 11,
                  height: 1.4,
                  fontStyle: FontStyle.italic),
              textAlign: TextAlign.center),

        // Score component chips — row 1
        if (components.isNotEmpty) ...[
          const SizedBox(height: 14),
          Container(
              padding: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: _accent.withOpacity(0.2), width: 0.5))),
              child: Column(children: [
                Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    alignment: WrapAlignment.center,
                    children: [
                      _scoreChip('P1 5th House',
                          _num(components, 'partner1_5th_house_strength')),
                      _scoreChip('P2 5th House',
                          _num(components, 'partner2_5th_house_strength')),
                      _scoreChip('P1 Jupiter',
                          _num(components, 'partner1_jupiter_strength')),
                      _scoreChip('P2 Jupiter',
                          _num(components, 'partner2_jupiter_strength')),
                      _scoreChip(
                          'P1 D7', _num(components, 'partner1_d7_strength')),
                      _scoreChip(
                          'P2 D7', _num(components, 'partner2_d7_strength')),
                      _scoreChip(
                          'Beeja', _num(components, 'beeja_sphuta_score')),
                      _scoreChip('Kshetra',
                          _num(components, 'kshetra_sphuta_score')),
                      _scoreChip('Timing',
                          _num(components, 'dasha_timing_favorability')),
                      _scoreChip('Dosha Pen.',
                          _num(components, 'combined_dosha_penalty'),
                          isPenalty: true),
                    ]),
                if (components['explanation'] != null) ...[
                  const SizedBox(height: 8),
                  Text(components['explanation'].toString(),
                      style: const TextStyle(
                          color: AppColors.smoke,
                          fontSize: 9,
                          height: 1.3,
                          fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center),
                ],
              ])),
        ],
      ]),
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // 2. PARTNER CARDS — side-by-side info cards
  // ════════════════════════════════════════════════════════════════════

  Widget _buildPartnerCards(AppLocalizations l, Map<String, dynamic> header) {
    final p1 = _asMap(header['partner1']);
    final p2 = _asMap(header['partner2']);
    if (p1.isEmpty && p2.isEmpty) return const SizedBox.shrink();

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (p1.isNotEmpty) Expanded(child: _partnerCard(p1)),
              if (p1.isNotEmpty && p2.isNotEmpty) const SizedBox(width: 8),
              if (p2.isNotEmpty) Expanded(child: _partnerCard(p2)),
            ]));
  }

  Widget _partnerCard(Map<String, dynamic> p) {
    final role = p['role']?.toString() ?? '';
    final borderC = role.toLowerCase().contains('male') && !role.toLowerCase().contains('female')
        ? AppColors.aurora
        : _accent;
    return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: _cardBg.withOpacity(0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderC.withOpacity(0.3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (role.isNotEmpty)
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                    color: borderC.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6)),
                child: Text(role.toUpperCase(),
                    style: TextStyle(
                        color: borderC,
                        fontSize: 8,
                        letterSpacing: 1,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w700))),
          Text(p['name']?.toString() ?? '—',
              style: const TextStyle(
                  color: AppColors.ivory,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'serif')),
          const SizedBox(height: 6),
          _kvRow('Gender', p['gender']?.toString() ?? '—', AppColors.smoke),
          _kvRow('DOB', p['dob']?.toString() ?? '—', AppColors.smoke),
          _kvRow('TOB', p['tob']?.toString() ?? '—', AppColors.smoke),
          _kvRow('Place', p['place']?.toString() ?? '—', AppColors.smoke),
          const SizedBox(height: 4),
          _kvRow('Lagna', p['lagna']?.toString() ?? '—', AppColors.gold),
          _kvRow(
              'Moon Sign', p['moon_sign']?.toString() ?? '—', AppColors.gold),
        ]));
  }

  // ════════════════════════════════════════════════════════════════════
  // 3. NUMBER OF CHILDREN
  // ════════════════════════════════════════════════════════════════════

  Widget _buildNumberOfChildren(AppLocalizations l, Map<String, dynamic> number) {
    final probable = number['probable_number']?.toString() ?? '—';
    final genderTendency = number['gender_tendency']?.toString() ?? '';
    final genderScore = _asMap(number['gender_tendency_score']);
    final sonScore = (genderScore['son_score'] as num?)?.toInt() ?? 0;
    final daughterScore = (genderScore['daughter_score'] as num?)?.toInt() ?? 0;
    final numExp = number['number_explanation']?.toString() ?? '';
    final genderExp = number['gender_explanation']?.toString() ?? '';
    final note = number['important_note']?.toString() ?? '';

    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: _cardBg.withOpacity(0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _accent.withOpacity(0.2))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Big number
          Center(
              child: Column(children: [
            Text(l.probableNumber,
                style: const TextStyle(
                    color: _accent,
                    fontSize: 8,
                    letterSpacing: 2,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(probable,
                style: const TextStyle(
                    color: AppColors.ivory,
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'serif')),
          ])),
          const SizedBox(height: 12),

          // Gender tendency
          if (genderTendency.isNotEmpty) ...[
            Row(children: [
              Expanded(
                  child: Text(l.genderTendency,
                      style: TextStyle(
                          color: AppColors.smoke.withOpacity(0.8),
                          fontSize: 9,
                          fontFamily: 'monospace'))),
              _badge(genderTendency,
                  genderTendency.contains('Son') ? AppColors.aurora : genderTendency.contains('Daughter') ? _accent : AppColors.gold),
            ]),
            const SizedBox(height: 8),
          ],

          // Son/Daughter score visual
          if (sonScore > 0 || daughterScore > 0) ...[
            Row(children: [
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(l.son,
                        style: const TextStyle(
                            color: AppColors.aurora,
                            fontSize: 8,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 3),
                    Row(children: [
                      Expanded(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                  value: (sonScore / (sonScore + daughterScore == 0 ? 1 : sonScore + daughterScore)).clamp(0.0, 1.0),
                                  minHeight: 6,
                                  backgroundColor: Colors.white.withOpacity(0.06),
                                  valueColor: const AlwaysStoppedAnimation(AppColors.aurora)))),
                      const SizedBox(width: 8),
                      Text('$sonScore',
                          style: const TextStyle(
                              color: AppColors.aurora,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'serif')),
                    ]),
                  ])),
              const SizedBox(width: 16),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(l.daughter,
                        style: const TextStyle(
                            color: _accent,
                            fontSize: 8,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 3),
                    Row(children: [
                      Expanded(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                  value: (daughterScore / (sonScore + daughterScore == 0 ? 1 : sonScore + daughterScore)).clamp(0.0, 1.0),
                                  minHeight: 6,
                                  backgroundColor: Colors.white.withOpacity(0.06),
                                  valueColor: const AlwaysStoppedAnimation(_accent)))),
                      const SizedBox(width: 8),
                      Text('$daughterScore',
                          style: const TextStyle(
                              color: _accent,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'serif')),
                    ]),
                  ])),
            ]),
            const SizedBox(height: 12),
          ],

          // Explanations
          if (numExp.isNotEmpty) ...[
            Text(l.numberExplanation,
                style: TextStyle(
                    color: AppColors.smoke,
                    fontSize: 8,
                    fontFamily: 'monospace',
                    letterSpacing: 1)),
            const SizedBox(height: 3),
            Text(numExp,
                style: const TextStyle(
                    color: AppColors.ivory,
                    fontSize: 10,
                    height: 1.4)),
            const SizedBox(height: 8),
          ],
          if (genderExp.isNotEmpty) ...[
            Text(l.genderExplanation,
                style: TextStyle(
                    color: AppColors.smoke,
                    fontSize: 8,
                    fontFamily: 'monospace',
                    letterSpacing: 1)),
            const SizedBox(height: 3),
            Text(genderExp,
                style: const TextStyle(
                    color: AppColors.ivory,
                    fontSize: 10,
                    height: 1.4)),
            const SizedBox(height: 8),
          ],
          if (note.isNotEmpty)
            Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: AppColors.gold.withOpacity(0.08),
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8)),
                    border: const Border(
                        left: BorderSide(color: AppColors.gold, width: 3))),
                child: Text(note,
                    style: const TextStyle(
                        color: AppColors.ivory,
                        fontSize: 10,
                        height: 1.4,
                        fontStyle: FontStyle.italic))),
        ]));
  }

  // ════════════════════════════════════════════════════════════════════
  // 4. TIMING (MOOLA DASHA)
  // ════════════════════════════════════════════════════════════════════

  Widget _buildTiming(AppLocalizations l, Map<String, dynamic> timing) {
    final combinedScore =
        (timing['combined_timing_score'] as num?)?.toDouble() ?? 0;
    final timingVerdict = timing['timing_verdict']?.toString() ?? '';
    final nextWindow = timing['next_favorable_window']?.toString() ?? '';
    final p1Dasha = _asMap(timing['current_dasha_partner1']);
    final p2Dasha = _asMap(timing['current_dasha_partner2']);
    final windows = (timing['favorable_windows'] as List?) ?? [];

    final sc = _scoreColor(combinedScore);

    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: _cardBg.withOpacity(0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.aurora.withOpacity(0.2))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Combined timing score ring
          Center(
              child: Column(children: [
            _ring(combinedScore, 'COMBINED\nTIMING', sc),
            if (timingVerdict.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(timingVerdict,
                  style: const TextStyle(
                      color: AppColors.ivory,
                      fontSize: 11,
                      height: 1.4,
                      fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center),
            ],
          ])),
          const SizedBox(height: 14),

          // Partner 1 current dasha
          if (p1Dasha.isNotEmpty) _buildDashaPartnerBlock('Partner 1', p1Dasha),
          if (p1Dasha.isNotEmpty && p2Dasha.isNotEmpty)
            const SizedBox(height: 10),
          // Partner 2 current dasha
          if (p2Dasha.isNotEmpty) _buildDashaPartnerBlock('Partner 2', p2Dasha),

          // Favorable windows
          if (windows.isNotEmpty) ...[
            const SizedBox(height: 14),
            _label('FAVORABLE WINDOWS'),
            const SizedBox(height: 8),
            ...windows.map((w) {
              final wm = _asMap(w);
              final period = wm['period']?.toString() ?? '';
              final start = wm['start_date']?.toString() ?? '';
              final end = wm['end_date']?.toString() ?? '';
              final factor = wm['activating_factor']?.toString() ?? '';
              final appliesTo = wm['applies_to']?.toString() ?? '';
              final strength = wm['strength']?.toString() ?? '';
              final sC = strength.toLowerCase().contains('strong')
                  ? AppColors.success
                  : strength.toLowerCase().contains('moderate')
                      ? AppColors.gold
                      : AppColors.aurora;
              return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: sC.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: sC.withOpacity(0.2))),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Expanded(
                              child: Text(period,
                                  style: TextStyle(
                                      color: sC,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'serif'))),
                          if (strength.isNotEmpty) _badge(strength, sC),
                        ]),
                        if (start.isNotEmpty || end.isNotEmpty) ...[
                          const SizedBox(height: 3),
                          Text('$start  —  $end',
                              style: const TextStyle(
                                  color: AppColors.smoke,
                                  fontSize: 9,
                                  fontFamily: 'monospace')),
                        ],
                        if (factor.isNotEmpty) ...[
                          const SizedBox(height: 3),
                          Text('Factor: $factor',
                              style: const TextStyle(
                                  color: AppColors.lavender,
                                  fontSize: 9,
                                  height: 1.3)),
                        ],
                        if (appliesTo.isNotEmpty)
                          Text('Applies to: $appliesTo',
                              style: const TextStyle(
                                  color: AppColors.smoke,
                                  fontSize: 9)),
                      ]));
            }),
          ],

          // Next favorable window
          if (nextWindow.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: AppColors.success.withOpacity(0.2))),
                child: Row(children: [
                  const Icon(Icons.schedule,
                      color: AppColors.success, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(l.nextFavorableWindow,
                            style: const TextStyle(
                                color: AppColors.success,
                                fontSize: 8,
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1)),
                        const SizedBox(height: 2),
                        Text(nextWindow,
                            style: const TextStyle(
                                color: AppColors.ivory,
                                fontSize: 11,
                                fontWeight: FontWeight.w600)),
                      ])),
                ])),
          ],
        ]));
  }

  Widget _buildDashaPartnerBlock(String label, Map<String, dynamic> pd) {
    final moola = _asMap(pd['moola']);
    final favorability = pd['progeny_favorability']?.toString() ?? '';
    final favScore = (pd['favorability_score'] as num?)?.toDouble() ?? 0;
    final reasoning = pd['reasoning']?.toString() ?? '';

    final md = moola['md']?.toString() ?? '';
    final ad = moola['ad']?.toString() ?? '';
    final pdStr = moola['pd']?.toString() ?? '';
    final mdStart = moola['md_start']?.toString() ?? '';
    final mdEnd = moola['md_end']?.toString() ?? '';
    final adStart = moola['ad_start']?.toString() ?? '';
    final adEnd = moola['ad_end']?.toString() ?? '';

    final sc = _scoreColor(favScore);

    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(10)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(label.toUpperCase(),
                style: const TextStyle(
                    color: _accent,
                    fontSize: 9,
                    letterSpacing: 1.5,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600)),
            const Spacer(),
            if (favorability.isNotEmpty) _badge(favorability, sc),
          ]),
          const SizedBox(height: 6),
          if (md.isNotEmpty) _kvRow('Mahadasha', md, AppColors.gold),
          if (mdStart.isNotEmpty)
            _kvRow('MD Period', '$mdStart — $mdEnd', AppColors.smoke),
          if (ad.isNotEmpty) _kvRow('Antardasha', ad, AppColors.gold),
          if (adStart.isNotEmpty)
            _kvRow('AD Period', '$adStart — $adEnd', AppColors.smoke),
          if (pdStr.isNotEmpty) _kvRow('Pratyantardasha', pdStr, AppColors.gold),

          // Favorability score bar
          if (favScore > 0) ...[
            const SizedBox(height: 6),
            _progressBar('Favorability', favScore),
          ],

          if (reasoning.isNotEmpty)
            Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(reasoning,
                    style: const TextStyle(
                        color: AppColors.lavender,
                        fontSize: 9,
                        height: 1.3,
                        fontStyle: FontStyle.italic))),
        ]));
  }

  // ════════════════════════════════════════════════════════════════════
  // 5. 5TH HOUSE ANALYSIS — per person
  // ════════════════════════════════════════════════════════════════════

  Widget _buildFifthHouseCard(AppLocalizations l, String key, Map<String, dynamic> m) {
    final name = _personLabel(key);
    final sign = m['sign']?.toString() ?? '';
    final signEn = m['sign_english']?.toString() ?? '';
    final lord = m['lord']?.toString() ?? '';
    final lordHouse = m['lord_placement_house']?.toString() ?? '';
    final lordDignity = m['lord_dignity']?.toString() ?? '';
    final lordStrength = (m['lord_strength'] as num?)?.toDouble();
    final lordDust = m['lord_in_dusthana'];
    final occupants = (m['occupants'] as List?) ?? [];
    final benefics = (m['benefic_aspects'] as List?) ?? [];
    final malefics = (m['malefic_aspects'] as List?) ?? [];
    final houseScore = (m['house_strength_score'] as num?)?.toDouble() ?? 0;
    final interp = m['interpretation']?.toString() ?? '';

    return _personCard(name, _accent, [
      // Sign
      Row(children: [
        Text('$sign ${signEn.isNotEmpty ? "($signEn)" : ""}',
            style: const TextStyle(
                color: AppColors.ivory,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'serif')),
      ]),
      const SizedBox(height: 8),
      _kvRow('Lord', lord, AppColors.gold),
      _kvRow('Lord Placement', '${lordHouse}H', AppColors.gold),
      if (lordDignity.isNotEmpty) _kvRow('Lord Dignity', lordDignity, _dignityColor(lordDignity)),
      if (lordDust == true)
        _badge('LORD IN DUSTHANA', AppColors.error),
      if (lordStrength != null) ...[
        const SizedBox(height: 4),
        _progressBar('Lord Strength', lordStrength),
      ],

      // House strength
      const SizedBox(height: 4),
      _progressBar('House Strength', houseScore),

      // Occupants
      if (occupants.isNotEmpty) ...[
        const SizedBox(height: 8),
        Text(l.occupants,
            style: const TextStyle(
                color: AppColors.smoke,
                fontSize: 8,
                fontFamily: 'monospace',
                letterSpacing: 1)),
        const SizedBox(height: 4),
        Wrap(
            spacing: 6,
            runSpacing: 4,
            children: occupants
                .map((o) => _badge(o.toString(), AppColors.aurora))
                .toList()),
      ],

      // Benefic aspects
      if (benefics.isNotEmpty) ...[
        const SizedBox(height: 8),
        Text(l.beneficAspects,
            style: const TextStyle(
                color: AppColors.success,
                fontSize: 8,
                fontFamily: 'monospace',
                letterSpacing: 1)),
        const SizedBox(height: 4),
        Wrap(
            spacing: 6,
            runSpacing: 4,
            children: benefics
                .map((b) => _badge(b.toString(), AppColors.success))
                .toList()),
      ],

      // Malefic aspects
      if (malefics.isNotEmpty) ...[
        const SizedBox(height: 8),
        Text(l.maleficAspects,
            style: const TextStyle(
                color: AppColors.error,
                fontSize: 8,
                fontFamily: 'monospace',
                letterSpacing: 1)),
        const SizedBox(height: 4),
        Wrap(
            spacing: 6,
            runSpacing: 4,
            children: malefics
                .map((ml) => _badge(ml.toString(), AppColors.error))
                .toList()),
      ],

      // Interpretation
      if (interp.isNotEmpty) ...[
        const SizedBox(height: 8),
        Text(interp,
            style: const TextStyle(
                color: AppColors.lavender,
                fontSize: 10,
                height: 1.4,
                fontStyle: FontStyle.italic)),
      ],
    ]);
  }

  // ════════════════════════════════════════════════════════════════════
  // 6. JUPITER ANALYSIS — per person
  // ════════════════════════════════════════════════════════════════════

  Widget _buildJupiterCard(AppLocalizations l, String key, Map<String, dynamic> m) {
    final name = _personLabel(key);
    final sign = m['sign']?.toString() ?? '';
    final house = m['house']?.toString() ?? '';
    final dignity = m['dignity']?.toString() ?? '';
    final strength = (m['strength'] as num?)?.toDouble() ?? 0;
    final retrograde = m['retrograde'] == true;
    final combust = m['combust'] == true;
    final aspects5th = m['aspects_5th_house'] == true;
    final in5th = m['in_5th_house'] == true;
    final interp = m['interpretation']?.toString() ?? '';

    return _personCard(name, AppColors.gold, [
      Row(children: [
        Text('Jupiter in $sign',
            style: const TextStyle(
                color: AppColors.ivory,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'serif')),
      ]),
      const SizedBox(height: 8),
      _kvRow('House', house, AppColors.gold),
      if (dignity.isNotEmpty) _kvRow('Dignity', dignity, _dignityColor(dignity)),

      // Strength bar
      const SizedBox(height: 4),
      _progressBar('Strength', strength),
      const SizedBox(height: 8),

      // Status badges row
      Wrap(spacing: 6, runSpacing: 4, children: [
        if (retrograde)
          _badge('RETROGRADE', AppColors.error)
        else
          _badge('DIRECT', AppColors.success),
        if (combust)
          _badge('COMBUST', AppColors.error)
        else
          _badge('NOT COMBUST', AppColors.success),
        if (in5th) _badge('IN 5TH HOUSE', AppColors.success),
        if (aspects5th) _badge('ASPECTS 5TH', AppColors.success),
        if (!in5th && !aspects5th) _badge('NO 5TH CONNECTION', AppColors.smoke),
      ]),

      // Interpretation
      if (interp.isNotEmpty) ...[
        const SizedBox(height: 8),
        Text(interp,
            style: const TextStyle(
                color: AppColors.lavender,
                fontSize: 10,
                height: 1.4,
                fontStyle: FontStyle.italic)),
      ],
    ]);
  }

  // ════════════════════════════════════════════════════════════════════
  // 7. D7 SAPTAMSA ANALYSIS — per person
  // ════════════════════════════════════════════════════════════════════

  Widget _buildD7Card(AppLocalizations l, String key, Map<String, dynamic> m) {
    final name = _personLabel(key);
    final d7Lagna = m['d7_lagna']?.toString() ?? '';
    final d7Fifth = m['d7_fifth_sign']?.toString() ?? '';
    final d7FifthLord = m['d7_fifth_lord']?.toString() ?? '';
    final d7JupSign = m['d7_jupiter_sign']?.toString() ?? '';
    final d7JupDig = m['d7_jupiter_dignity']?.toString() ?? '';
    final d7Strength = (m['d7_strength'] as num?)?.toDouble() ?? 0;
    final d7Interp = m['d7_interpretation']?.toString() ?? '';
    final d7Planets = (m['d7_planets'] as List?) ?? [];

    return _personCard(name, AppColors.indigo, [
      Text(l.d7Saptamsa,
          style: TextStyle(
              color: AppColors.lavender,
              fontSize: 8,
              letterSpacing: 2,
              fontFamily: 'monospace',
              fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      _kvRow('D7 Lagna', d7Lagna, AppColors.gold),
      _kvRow('D7 5th Sign', d7Fifth, AppColors.gold),
      _kvRow('D7 5th Lord', d7FifthLord, AppColors.gold),
      _kvRow('Jupiter in D7', d7JupSign, AppColors.gold),
      if (d7JupDig.isNotEmpty)
        _kvRow('Jupiter Dignity', d7JupDig, _dignityColor(d7JupDig)),

      // Strength bar
      const SizedBox(height: 4),
      _progressBar('D7 Strength', d7Strength),

      // Planet table
      if (d7Planets.isNotEmpty) ...[
        const SizedBox(height: 10),
        Text(l.planetPositions,
            style: const TextStyle(
                color: AppColors.smoke,
                fontSize: 8,
                fontFamily: 'monospace',
                letterSpacing: 1)),
        const SizedBox(height: 4),
        // Table header
        Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(6))),
            child: Row(children: [
              Expanded(
                  flex: 3,
                  child: Text(l.planet,
                      style: const TextStyle(
                          color: AppColors.smoke,
                          fontSize: 8,
                          fontFamily: 'monospace'))),
              Expanded(
                  flex: 2,
                  child: Text(l.sign,
                      style: const TextStyle(
                          color: AppColors.smoke,
                          fontSize: 8,
                          fontFamily: 'monospace'))),
              Expanded(
                  flex: 2,
                  child: Text(l.house,
                      style: const TextStyle(
                          color: AppColors.smoke,
                          fontSize: 8,
                          fontFamily: 'monospace'))),
              Expanded(
                  flex: 2,
                  child: Text(l.inFifth,
                      style: const TextStyle(
                          color: AppColors.smoke,
                          fontSize: 8,
                          fontFamily: 'monospace'),
                      textAlign: TextAlign.right)),
            ])),
        ...d7Planets.map((p) {
          final pm = _asMap(p);
          final inFifth = pm['is_in_d7_5th'] == true;
          return Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Colors.white.withOpacity(0.04)))),
              child: Row(children: [
                Expanded(
                    flex: 3,
                    child: Text(pm['planet']?.toString() ?? '',
                        style: const TextStyle(
                            color: AppColors.ivory,
                            fontSize: 10,
                            fontWeight: FontWeight.w600))),
                Expanded(
                    flex: 2,
                    child: Text(pm['d7_sign']?.toString() ?? '',
                        style: const TextStyle(
                            color: AppColors.gold, fontSize: 10))),
                Expanded(
                    flex: 2,
                    child: Text(pm['d7_house']?.toString() ?? '',
                        style: const TextStyle(
                            color: AppColors.smoke, fontSize: 10))),
                Expanded(
                    flex: 2,
                    child: Text(inFifth ? 'Yes' : '—',
                        style: TextStyle(
                            color: inFifth
                                ? AppColors.success
                                : AppColors.smoke,
                            fontSize: 10,
                            fontWeight: inFifth
                                ? FontWeight.w700
                                : FontWeight.normal),
                        textAlign: TextAlign.right)),
              ]));
        }),
      ],

      // Interpretation
      if (d7Interp.isNotEmpty) ...[
        const SizedBox(height: 8),
        Text(d7Interp,
            style: const TextStyle(
                color: AppColors.lavender,
                fontSize: 10,
                height: 1.4,
                fontStyle: FontStyle.italic)),
      ],
    ]);
  }

  // ════════════════════════════════════════════════════════════════════
  // 8. BEEJA & KSHETRA SPHUTA
  // ════════════════════════════════════════════════════════════════════

  Widget _buildBeejaKshetra(AppLocalizations l, Map<String, dynamic> bk) {
    final beeja = _asMap(bk['beeja_sphuta']);
    final kshetra = _asMap(bk['kshetra_sphuta']);
    final combined = bk['combined_fertility_indication']?.toString() ?? '';

    return Column(children: [
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (beeja.isNotEmpty)
                  Expanded(child: _sphutaCard('BEEJA SPHUTA', AppColors.aurora, beeja)),
                if (beeja.isNotEmpty && kshetra.isNotEmpty)
                  const SizedBox(width: 8),
                if (kshetra.isNotEmpty)
                  Expanded(child: _sphutaCard('KSHETRA SPHUTA', _accent, kshetra)),
              ])),

      // Combined fertility indication
      if (combined.isNotEmpty)
        Container(
            margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.gold.withOpacity(0.2))),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.combinedFertility,
                      style: const TextStyle(
                          color: AppColors.gold,
                          fontSize: 8,
                          letterSpacing: 1,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(combined,
                      style: const TextStyle(
                          color: AppColors.ivory,
                          fontSize: 11,
                          height: 1.4)),
                ])),
    ]);
  }

  Widget _sphutaCard(
      String title, Color color, Map<String, dynamic> sp) {
    final degree = sp['degree']?.toString() ?? '';
    final sign = sp['sign']?.toString() ?? '';
    final signLord = sp['sign_lord']?.toString() ?? '';
    final score = (sp['strength_score'] as num?)?.toDouble() ?? 0;
    final rating = sp['strength_rating']?.toString() ?? '';
    final factors = (sp['factors'] as List?) ?? [];
    final interp = sp['interpretation']?.toString() ?? '';
    final sc = _scoreColor(score);

    return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: color.withOpacity(0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.25))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: TextStyle(
                  color: color,
                  fontSize: 8,
                  letterSpacing: 1.5,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),

          // Score
          Row(children: [
            Text(score.toStringAsFixed(0),
                style: TextStyle(
                    color: sc,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'serif')),
            const Text('/100',
                style: TextStyle(
                    color: AppColors.smoke, fontSize: 10)),
            const Spacer(),
            if (rating.isNotEmpty) _badge(rating, sc),
          ]),
          const SizedBox(height: 6),

          // Strength bar
          ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                  value: (score / 100).clamp(0, 1),
                  minHeight: 4,
                  backgroundColor: Colors.white.withOpacity(0.06),
                  valueColor: AlwaysStoppedAnimation(sc))),
          const SizedBox(height: 8),

          if (degree.isNotEmpty) _kvRow('Degree', degree, AppColors.gold),
          if (sign.isNotEmpty) _kvRow('Sign', sign, AppColors.gold),
          if (signLord.isNotEmpty)
            _kvRow('Sign Lord', signLord, AppColors.gold),

          // Factors as chips
          if (factors.isNotEmpty) ...[
            const SizedBox(height: 6),
            Wrap(
                spacing: 4,
                runSpacing: 3,
                children: factors
                    .map((f) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                            color: color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(4)),
                        child: Text(f.toString(),
                            style: TextStyle(
                                color: color,
                                fontSize: 8,
                                height: 1.2))))
                    .toList()),
          ],

          // Interpretation
          if (interp.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(interp,
                style: const TextStyle(
                    color: AppColors.lavender,
                    fontSize: 9,
                    height: 1.3,
                    fontStyle: FontStyle.italic)),
          ],
        ]));
  }

  // ════════════════════════════════════════════════════════════════════
  // 9. DOSHA ANALYSIS
  // ════════════════════════════════════════════════════════════════════

  Widget _buildDoshaAnalysis(AppLocalizations l, Map<String, dynamic> dosha) {
    final doshas = (dosha['doshas_detected'] as List?) ?? [];
    final totalPenalty =
        (dosha['total_dosha_penalty'] as num?)?.toDouble() ?? 0;
    final summary = dosha['dosha_summary']?.toString() ?? '';

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Summary + total penalty
      Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: _cardBg.withOpacity(0.5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.error.withOpacity(0.2))),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                  child: Text(l.totalDoshaPenalty,
                      style: const TextStyle(
                          color: AppColors.smoke,
                          fontSize: 9,
                          fontFamily: 'monospace',
                          letterSpacing: 1))),
              Text('-${totalPenalty.toStringAsFixed(1)}',
                  style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'serif')),
            ]),
            if (summary.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(summary,
                  style: const TextStyle(
                      color: AppColors.ivory,
                      fontSize: 10,
                      height: 1.4)),
            ],
          ])),

      // Individual doshas
      ...doshas.map((d) {
        final dm = _asMap(d);
        final doshaName = dm['dosha_name']?.toString() ?? '';
        final presentIn = dm['present_in']?.toString() ?? '';
        final severity = dm['severity']?.toString() ?? '';
        final desc = dm['description']?.toString() ?? '';
        final cancel = dm['cancellation_factors']?.toString() ?? '';
        final penalty = (dm['net_penalty'] as num?)?.toDouble() ?? 0;
        final sevC = severity.toLowerCase().contains('high') ||
                severity.toLowerCase().contains('severe')
            ? AppColors.error
            : severity.toLowerCase().contains('moderate')
                ? const Color(0xFFE5A93A)
                : AppColors.aurora;

        return Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  sevC.withOpacity(0.08),
                  sevC.withOpacity(0.02)
                ]),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: sevC.withOpacity(0.25))),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(
                        child: Text(doshaName,
                            style: TextStyle(
                                color: sevC,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'serif'))),
                    _badge(severity.toUpperCase(), sevC),
                  ]),
                  if (presentIn.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    _kvRow('Present In', presentIn, AppColors.smoke),
                  ],
                  if (penalty != 0) ...[
                    _kvRow('Net Penalty',
                        '-${penalty.toStringAsFixed(1)}', AppColors.error),
                  ],
                  if (desc.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(desc,
                        style: const TextStyle(
                            color: AppColors.ivory,
                            fontSize: 10,
                            height: 1.4)),
                  ],
                  if (cancel.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: AppColors.success.withOpacity(0.2))),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l.cancellationFactors,
                                  style: const TextStyle(
                                      color: AppColors.success,
                                      fontSize: 8,
                                      letterSpacing: 1,
                                      fontFamily: 'monospace',
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(height: 3),
                              Text(cancel,
                                  style: const TextStyle(
                                      color: AppColors.ivory,
                                      fontSize: 10,
                                      height: 1.4)),
                            ])),
                  ],
                ]));
      }),
    ]);
  }

  // ════════════════════════════════════════════════════════════════════
  // 10. REMEDIES — five categorized lists
  // ════════════════════════════════════════════════════════════════════

  Widget _buildRemedies(AppLocalizations l, Map<String, dynamic> remedies) {
    final gemstone = (remedies['gemstone_remedies'] as List?) ?? [];
    final mantra = (remedies['mantra_remedies'] as List?) ?? [];
    final ritual = (remedies['ritual_remedies'] as List?) ?? [];
    final lifestyle = (remedies['lifestyle_remedies'] as List?) ?? [];
    final charitable = (remedies['charitable_remedies'] as List?) ?? [];
    final combinedAdvice = remedies['combined_advice']?.toString() ?? '';

    final categories = <MapEntry<String, List>>[
      if (gemstone.isNotEmpty) MapEntry('GEMSTONE REMEDIES', gemstone),
      if (mantra.isNotEmpty) MapEntry('MANTRA REMEDIES', mantra),
      if (ritual.isNotEmpty) MapEntry('RITUAL REMEDIES', ritual),
      if (lifestyle.isNotEmpty) MapEntry('LIFESTYLE REMEDIES', lifestyle),
      if (charitable.isNotEmpty) MapEntry('CHARITABLE REMEDIES', charitable),
    ];

    final icons = {
      'GEMSTONE REMEDIES': Icons.diamond_outlined,
      'MANTRA REMEDIES': Icons.self_improvement,
      'RITUAL REMEDIES': Icons.local_fire_department_outlined,
      'LIFESTYLE REMEDIES': Icons.favorite_outline,
      'CHARITABLE REMEDIES': Icons.volunteer_activism_outlined,
    };
    final colors = {
      'GEMSTONE REMEDIES': AppColors.aurora,
      'MANTRA REMEDIES': AppColors.gold,
      'RITUAL REMEDIES': AppColors.saffron,
      'LIFESTYLE REMEDIES': AppColors.success,
      'CHARITABLE REMEDIES': _accent,
    };

    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: _cardBg.withOpacity(0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.gold.withOpacity(0.2))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ...categories.map((cat) {
            final catColor = colors[cat.key] ?? AppColors.gold;
            final catIcon = icons[cat.key] ?? Icons.star_outline;
            return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Icon(catIcon, color: catColor, size: 14),
                        const SizedBox(width: 6),
                        Text(cat.key,
                            style: TextStyle(
                                color: catColor,
                                fontSize: 9,
                                letterSpacing: 1,
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.w600)),
                      ]),
                      const SizedBox(height: 6),
                      ...cat.value.map((r) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('  ✦ ',
                                    style: TextStyle(
                                        color: catColor, fontSize: 10)),
                                Expanded(
                                    child: Text(
                                        r is Map
                                            ? (r['text'] ??
                                                    r['description'] ??
                                                    r.toString())
                                                .toString()
                                            : r.toString(),
                                        style: const TextStyle(
                                            color: AppColors.ivory,
                                            fontSize: 10,
                                            height: 1.4))),
                              ]))),
                    ]));
          }),
          if (combinedAdvice.isNotEmpty) ...[
            Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: AppColors.gold.withOpacity(0.08),
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8)),
                    border: const Border(
                        left: BorderSide(color: AppColors.gold, width: 3))),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.remedies,
                          style: const TextStyle(
                              color: AppColors.gold,
                              fontSize: 8,
                              letterSpacing: 1,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(combinedAdvice,
                          style: const TextStyle(
                              color: AppColors.ivory,
                              fontSize: 10,
                              height: 1.4,
                              fontStyle: FontStyle.italic)),
                    ])),
          ],
        ]));
  }

  // ════════════════════════════════════════════════════════════════════
  // 11. SUMMARY — gold card
  // ════════════════════════════════════════════════════════════════════

  Widget _buildSummary(AppLocalizations l, Map<String, dynamic> s) {
    final oneLiner = s['one_liner']?.toString() ?? '';
    final humanSummary = s['human_summary']?.toString() ?? '';
    final actionable = s['actionable_advice']?.toString() ?? '';
    final timingSummary = s['timing_summary']?.toString() ?? '';
    final outlook = s['overall_outlook']?.toString() ?? '';

    return Container(
        margin: const EdgeInsets.fromLTRB(16, 14, 16, 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppColors.gold.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gold.withOpacity(0.25))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _label('SUMMARY'),
          const SizedBox(height: 10),

          if (oneLiner.isNotEmpty) ...[
            Text(oneLiner,
                style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'serif',
                    height: 1.3)),
            const SizedBox(height: 10),
          ],
          if (humanSummary.isNotEmpty) ...[
            Text(l.detailedSummary,
                style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 8,
                    letterSpacing: 1,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 3),
            Text(humanSummary,
                style: const TextStyle(
                    color: AppColors.ivory,
                    fontSize: 11,
                    height: 1.4)),
            const SizedBox(height: 10),
          ],
          if (actionable.isNotEmpty) ...[
            Text(l.overallVerdict,
                style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 8,
                    letterSpacing: 1,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 3),
            Text(actionable,
                style: const TextStyle(
                    color: AppColors.ivory,
                    fontSize: 11,
                    height: 1.4)),
            const SizedBox(height: 10),
          ],
          if (timingSummary.isNotEmpty) ...[
            Text(l.bestWindows,
                style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 8,
                    letterSpacing: 1,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 3),
            Text(timingSummary,
                style: const TextStyle(
                    color: AppColors.ivory,
                    fontSize: 11,
                    height: 1.4)),
            const SizedBox(height: 10),
          ],
          if (outlook.isNotEmpty) ...[
            Text(l.overallVerdict,
                style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 8,
                    letterSpacing: 1,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 3),
            Text(outlook,
                style: const TextStyle(
                    color: AppColors.ivory,
                    fontSize: 11,
                    height: 1.4)),
          ],
        ]));
  }

  // ════════════════════════════════════════════════════════════════════
  // 13. AI COPY BAR
  // ════════════════════════════════════════════════════════════════════

  Widget _buildAiCopyBar(BuildContext ctx) {
    return Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              _cardBg.withOpacity(0.8),
              _bg,
            ]),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gold.withOpacity(0.25))),
        child: Column(children: [
          Text('DISCUSS WITH AI',
              style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 9,
                  letterSpacing: 2,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(children: [
            _aiBtn(
                ctx,
                'G',
                'ChatGPT',
                const LinearGradient(
                    colors: [Color(0xFF10A37F), Color(0xFF1A7F64)]),
                'Analyze this Vedic astrology Child Probability report and give detailed insights:\n\n'),
            const SizedBox(width: 8),
            _aiBtn(
                ctx,
                'C',
                'Claude',
                const LinearGradient(
                    colors: [Color(0xFFD97757), Color(0xFFB85B3F)]),
                'Here is a Vedic astrology Child Probability report. Analyze it thoroughly and provide actionable insights:\n\n'),
            const SizedBox(width: 8),
            _aiBtn(
                ctx,
                '✦',
                'Gemini',
                const LinearGradient(
                    colors: [Color(0xFF4285F4), Color(0xFF9B72CB)]),
                'Review this Child Probability astrology analysis and explain key findings simply:\n\n'),
          ]),
        ]));
  }

  Widget _aiBtn(BuildContext ctx, String icon, String name, Gradient g,
      String prefix) {
    return Expanded(
        child: GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: prefix + _fmt(data)));
              ScaffoldMessenger.of(ctx)
                  .showSnackBar(SnackBar(content: Text('Copied for $name!')));
              final urls = {
                'ChatGPT': 'https://chat.openai.com/',
                'Claude': 'https://claude.ai/new',
                'Gemini': 'https://gemini.google.com/app'
              };
              launchUrl(Uri.parse(urls[name]!),
                      mode: LaunchMode.externalApplication)
                  .catchError((_) => false);
            },
            child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(14),
                    border:
                        Border.all(color: AppColors.gold.withOpacity(0.2))),
                child: Column(children: [
                  Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                          gradient: g,
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                          child: Text(icon,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700)))),
                  const SizedBox(height: 5),
                  Text(name,
                      style: const TextStyle(
                          color: AppColors.ivory,
                          fontSize: 9,
                          fontWeight: FontWeight.w700)),
                  Text('COPY',
                      style: TextStyle(
                          color: AppColors.smoke,
                          fontSize: 7,
                          fontFamily: 'monospace')),
                ]))));
  }

  // ════════════════════════════════════════════════════════════════════
  // SHARED HELPER WIDGETS
  // ════════════════════════════════════════════════════════════════════

  Widget _header(String p1, String p2) => ReportHeader(p1, p2, '');

  Widget _label(String text) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 16,
                height: 1,
                color: AppColors.gold.withOpacity(0.4)),
            const SizedBox(width: 6),
            Text(text,
                style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 9,
                    letterSpacing: 2,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600)),
            const SizedBox(width: 6),
            Container(
                width: 16,
                height: 1,
                color: AppColors.gold.withOpacity(0.4)),
          ]);

  Widget _ring(double v, String lbl, Color c) => Column(children: [
        SizedBox(
            width: 76,
            height: 76,
            child: Stack(alignment: Alignment.center, children: [
              SizedBox(
                  width: 76,
                  height: 76,
                  child: CircularProgressIndicator(
                      value: (v / 100).clamp(0, 1),
                      strokeWidth: 6,
                      backgroundColor: Colors.white.withOpacity(0.08),
                      valueColor: AlwaysStoppedAnimation(c))),
              Text(v.toStringAsFixed(0),
                  style: TextStyle(
                      color: c,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'serif')),
            ])),
        const SizedBox(height: 6),
        Text(lbl,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: AppColors.smoke,
                fontSize: 8,
                letterSpacing: 1,
                fontFamily: 'monospace',
                height: 1.2)),
      ]);

  Widget _scoreChip(String label, double value, {bool isPenalty = false}) {
    final c = isPenalty
        ? (value > 0 ? AppColors.error : AppColors.success)
        : _scoreColor(value);
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: c.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: c.withOpacity(0.3))),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
              isPenalty
                  ? '-${value.toStringAsFixed(0)}'
                  : value.toStringAsFixed(0),
              style: TextStyle(
                  color: c,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'serif')),
          Text(label,
              style: TextStyle(
                  color: c.withOpacity(0.7),
                  fontSize: 7,
                  fontFamily: 'monospace'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ]));
  }

  Widget _badge(String text, Color c) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
          color: c.withOpacity(0.15),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: c.withOpacity(0.4))),
      child: Text(text.toUpperCase(),
          style: TextStyle(
              color: c,
              fontSize: 8,
              letterSpacing: 0.8,
              fontFamily: 'monospace',
              fontWeight: FontWeight.w700)));

  Widget _kvRow(String k, String v, Color vc) => Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
            width: 100,
            child: Text(k,
                style: const TextStyle(
                    color: AppColors.smoke,
                    fontSize: 9,
                    fontFamily: 'monospace'))),
        Expanded(
            child: Text(v,
                style: TextStyle(
                    color: vc,
                    fontSize: 11,
                    fontWeight: FontWeight.w600))),
      ]));

  Widget _progressBar(String label, double value) {
    final c = _scoreColor(value);
    return Column(children: [
      Row(children: [
        Expanded(
            child: Text(label,
                style: const TextStyle(
                    color: AppColors.ivory, fontSize: 10))),
        Text(value.toStringAsFixed(1),
            style: TextStyle(
                color: c,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                fontFamily: 'monospace')),
      ]),
      const SizedBox(height: 3),
      ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
              value: (value / 100).clamp(0, 1),
              minHeight: 4,
              backgroundColor: Colors.white.withOpacity(0.06),
              valueColor: AlwaysStoppedAnimation(c))),
    ]);
  }

  Widget _personCard(String name, Color borderColor, List<Widget> children) =>
      Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: _cardBg.withOpacity(0.5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor.withOpacity(0.25))),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name,
                style: TextStyle(
                    color: borderColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'serif')),
            const SizedBox(height: 8),
            ...children,
          ]));

  // ════════════════════════════════════════════════════════════════════
  // UTILITY METHODS
  // ════════════════════════════════════════════════════════════════════

  static Map<String, dynamic> _asMap(dynamic v) =>
      v is Map ? v.cast<String, dynamic>() : <String, dynamic>{};

  static double _num(Map<String, dynamic> m, String k) {
    final v = m[k];
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0;
    return 0;
  }

  static String _titleCase(String s) => s
      .replaceAll('_', ' ')
      .split(' ')
      .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');

  static String _personLabel(String key) {
    // Convert keys like "john_male" or "jane_female" to "John (Male)" / "Jane (Female)"
    if (key.endsWith('_male')) {
      return '${_titleCase(key.replaceAll('_male', ''))} (Male)';
    } else if (key.endsWith('_female')) {
      return '${_titleCase(key.replaceAll('_female', ''))} (Female)';
    }
    return _titleCase(key);
  }

  static Color _scoreColor(double v) => v >= 70
      ? AppColors.success
      : v >= 50
          ? AppColors.gold
          : v >= 30
              ? const Color(0xFFE5A93A)
              : AppColors.error;

  static Color _dignityColor(String dignity) {
    final d = dignity.toLowerCase();
    if (d.contains('exalt') || d.contains('moolatrikona')) {
      return AppColors.success;
    }
    if (d.contains('own') || d.contains('swakshetra')) return AppColors.gold;
    if (d.contains('friend')) return AppColors.aurora;
    if (d.contains('neech') || d.contains('debilitat') || d.contains('enemy')) {
      return AppColors.error;
    }
    return AppColors.smoke;
  }

  static String _fmt(Map<String, dynamic> d, {int indent = 0}) {
    final buf = StringBuffer();
    final pad = '  ' * indent;
    for (final e in d.entries) {
      if (e.value is Map) {
        buf.writeln('$pad${_titleCase(e.key)}:');
        buf.write(
            _fmt((e.value as Map).cast<String, dynamic>(), indent: indent + 1));
      } else if (e.value is List) {
        buf.writeln('$pad${_titleCase(e.key)}:');
        for (var i = 0; i < (e.value as List).length; i++) {
          final item = (e.value as List)[i];
          if (item is Map) {
            buf.writeln('$pad  ${i + 1}.');
            buf.write(
                _fmt(item.cast<String, dynamic>(), indent: indent + 2));
          } else {
            buf.writeln('$pad  ${i + 1}. $item');
          }
        }
      } else {
        buf.writeln('$pad${_titleCase(e.key)}: ${e.value}');
      }
    }
    return buf.toString();
  }
}
