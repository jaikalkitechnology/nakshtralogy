import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import 'report_components.dart';

class LoveCompatibilityReportScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final List<String> participants;
  const LoveCompatibilityReportScreen(
      {super.key, required this.data, required this.participants});

  static const _accent = Color(0xFFE85B8A);
  static const _bg = Color(0xFF0A0A24);
  static const _cardBg = Color(0xFF1A1642);

  @override
  Widget build(BuildContext context) {
    final overall = _asMap(data['overall_love_compatibility']);
    final attraction = _asMap(data['attraction_chemistry']);
    final emotional = _asMap(data['emotional_harmony']);
    final mental = _asMap(data['mental_rapport']);
    final passion = _asMap(data['passion_physical']);
    final longterm = _asMap(data['longterm_harmony']);
    final karmic = _asMap(data['karmic_love_bond']);
    final challenges = _asMap(data['challenges_friction']);
    final timing = _asMap(data['love_timing_moola_dasha']);
    final dynamics = _asMap(data['relationship_dynamics']);
    final remedies = _asMap(data['remedies_guidance']);
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
          title: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(participants.join(' & ').toUpperCase(),
                style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 9,
                    letterSpacing: 1.5,
                    fontFamily: 'monospace'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            Text.rich(TextSpan(children: [
              TextSpan(
                  text: '${l.loveCompatTitle1} ',
                  style: const TextStyle(
                      color: AppColors.ivory,
                      fontSize: 18,
                      fontWeight: FontWeight.w600)),
              TextSpan(
                  text: l.loveCompatTitle2,
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

          // 3. ATTRACTION & CHEMISTRY
          if (attraction.isNotEmpty) ...[
            _header(l.loveAttractionHeader1, l.loveAttractionHeader2),
            _buildAttractionChemistry(l, attraction),
          ],

          // 4. EMOTIONAL HARMONY
          if (emotional.isNotEmpty) ...[
            _header(l.loveEmotionalHeader1, l.loveEmotionalHeader2),
            _buildEmotionalHarmony(l, emotional),
          ],

          // 5. MENTAL RAPPORT
          if (mental.isNotEmpty) ...[
            _header(l.loveMentalHeader1, l.loveMentalHeader2),
            _buildMentalRapport(l, mental),
          ],

          // 6. PASSION & PHYSICAL
          if (passion.isNotEmpty) ...[
            _header(l.lovePassionHeader1, l.lovePassionHeader2),
            _buildPassionPhysical(l, passion),
          ],

          // 7. LONG-TERM HARMONY
          if (longterm.isNotEmpty) ...[
            _header(l.loveLongtermHeader1, l.loveEmotionalHeader2),
            _buildLongtermHarmony(l, longterm),
          ],

          // 8. KARMIC LOVE BOND
          if (karmic.isNotEmpty) ...[
            _header(l.loveKarmicHeader1, l.loveKarmicHeader2),
            _buildKarmicBond(l, karmic),
          ],

          // 9. CHALLENGES & FRICTION
          if (challenges.isNotEmpty) ...[
            _header(l.loveChallengesHeader1, l.loveChallengesHeader2),
            _buildChallenges(l, challenges),
          ],

          // 10. TIMING (MOOLA DASHA)
          if (timing.isNotEmpty) ...[
            _header(l.loveTimingHeader1, l.childTimingHeader2),
            _buildTiming(l, timing),
          ],

          // 11. RELATIONSHIP DYNAMICS
          if (dynamics.isNotEmpty) ...[
            _header(l.loveRelationshipHeader1, l.loveRelationshipHeader2),
            _buildDynamics(l, dynamics),
          ],

          // 12. REMEDIES
          if (remedies.isNotEmpty) ...[
            _header(l.loveRemediesHeader1, l.loveRemediesHeader2),
            _buildRemedies(l, remedies),
          ],

          // 13. SUMMARY
          if (summary.isNotEmpty) _buildSummary(l, summary),

          // 14. CONFIDENCE
          if (conf != null) ...[
            ReportHeader(l.analysisWord, l.confidenceLabel, l.qualityTag),
            ConfidenceBlock(
                score: conf,
                statement: data['confidence_explanation']?.toString(),
                breakdown: _asMap(data['confidence_breakdown'])),
          ],

          // 15. AI COPY BAR
          _buildAiCopyBar(l, context),
          const SizedBox(height: 40),
        ])),
      ]),
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // 1. HERO — Big score ring + grade + verdict + 7 score component chips
  // ════════════════════════════════════════════════════════════════════

  Widget _buildHero(AppLocalizations l, Map<String, dynamic> overall) {
    final mainScore =
        (overall['overall_love_score'] as num?)?.toDouble() ?? 0;
    final grade = overall['compatibility_grade']?.toString() ?? '';
    final band = overall['compatibility_band']?.toString() ?? '';
    final verdict = overall['love_verdict']?.toString() ?? '';
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
        _label(l.loveCompatHeroLabel),
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

        // Score component chips
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
                      _scoreChip(l.loveChipAttraction,
                          _num(components, 'attraction_chemistry'),
                          chipColor: _accent),
                      _scoreChip(l.loveEmotionalHeader1,
                          _num(components, 'emotional_harmony'),
                          chipColor: AppColors.aurora),
                      _scoreChip(l.loveMentalHeader1,
                          _num(components, 'mental_rapport'),
                          chipColor: AppColors.lavender),
                      _scoreChip(l.loveChipPassion,
                          _num(components, 'passion_physical'),
                          chipColor: AppColors.saffron),
                      _scoreChip(l.loveLongtermHeader1,
                          _num(components, 'longterm_harmony'),
                          chipColor: AppColors.success),
                      _scoreChip(l.karmic,
                          _num(components, 'karmic_bond'),
                          chipColor: AppColors.indigo),
                      _scoreChip(l.loveChipChallenge,
                          _num(components, 'challenge_penalty'),
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
              if (p1.isNotEmpty) Expanded(child: _partnerCard(l, p1)),
              if (p1.isNotEmpty && p2.isNotEmpty) const SizedBox(width: 8),
              if (p2.isNotEmpty) Expanded(child: _partnerCard(l, p2)),
            ]));
  }

  Widget _partnerCard(AppLocalizations l, Map<String, dynamic> p) {
    final role = p['role']?.toString() ?? '';
    final borderC =
        role.toLowerCase().contains('male') && !role.toLowerCase().contains('female')
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
          Text(p['name']?.toString() ?? '',
              style: const TextStyle(
                  color: AppColors.ivory,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'serif')),
          const SizedBox(height: 6),
          _kvRow(l.dob, p['dob']?.toString() ?? '', AppColors.smoke),
          _kvRow(l.place, p['place']?.toString() ?? '', AppColors.smoke),
          const SizedBox(height: 4),
          _kvRow(l.lagna, p['lagna']?.toString() ?? '', AppColors.gold),
          _kvRow(l.moonSignLabel, p['moon_sign']?.toString() ?? '', AppColors.gold),
          _kvRow(l.venusSignLabel, p['venus_sign']?.toString() ?? '', _accent),
        ]));
  }

  // ════════════════════════════════════════════════════════════════════
  // 3. ATTRACTION & CHEMISTRY
  // ════════════════════════════════════════════════════════════════════

  Widget _buildAttractionChemistry(AppLocalizations l, Map<String, dynamic> a) {
    final score = (a['attraction_score'] as num?)?.toDouble() ?? 0;
    final contacts = (a['venus_cross_contacts'] as List?) ?? [];
    final activeCount = (a['active_contacts_count'] as num?)?.toInt() ?? 0;
    final magneticPull = a['magnetic_pull_direction']?.toString() ?? '';
    final attractionType = a['initial_attraction_type']?.toString() ?? '';
    final interp = a['attraction_interpretation']?.toString() ?? '';

    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: _cardBg.withOpacity(0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _accent.withOpacity(0.2))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Score bar
          _progressBar(l.attractionScoreLabel, score, barColor: _accent),
          const SizedBox(height: 14),

          // Venus cross contacts table
          if (contacts.isNotEmpty) ...[
            Text(l.venusContacts,
                style: TextStyle(
                    color: _accent,
                    fontSize: 8,
                    letterSpacing: 1.5,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),

            // Table header
            Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(6))),
                child: Row(children: [
                  Expanded(
                      flex: 3,
                      child: Text(l.contact,
                          style: const TextStyle(
                              color: AppColors.smoke,
                              fontSize: 8,
                              fontFamily: 'monospace'))),
                  Expanded(
                      flex: 3,
                      child: Text(l.effect,
                          style: const TextStyle(
                              color: AppColors.smoke,
                              fontSize: 8,
                              fontFamily: 'monospace'))),
                  Expanded(
                      flex: 2,
                      child: Text(l.strength,
                          style: const TextStyle(
                              color: AppColors.smoke,
                              fontSize: 8,
                              fontFamily: 'monospace'))),
                  const Expanded(
                      flex: 1,
                      child: Text('',
                          style: TextStyle(
                              color: AppColors.smoke,
                              fontSize: 8,
                              fontFamily: 'monospace'),
                          textAlign: TextAlign.right)),
                ])),
            ...contacts.map((c) {
              final cm = _asMap(c);
              final contact = cm['contact']?.toString() ?? '';
              final effect = cm['effect']?.toString() ?? '';
              final strength = cm['strength']?.toString() ?? '';
              final present = cm['present'] == true;
              final sC = strength.toLowerCase().contains('strong')
                  ? AppColors.success
                  : strength.toLowerCase().contains('moderate')
                      ? AppColors.gold
                      : AppColors.smoke;
              return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  decoration: BoxDecoration(
                      color: present
                          ? _accent.withOpacity(0.04)
                          : Colors.transparent,
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.white.withOpacity(0.04)))),
                  child: Row(children: [
                    Expanded(
                        flex: 3,
                        child: Text(contact,
                            style: TextStyle(
                                color: present
                                    ? AppColors.ivory
                                    : AppColors.smoke.withOpacity(0.5),
                                fontSize: 9,
                                fontWeight: present
                                    ? FontWeight.w600
                                    : FontWeight.normal))),
                    Expanded(
                        flex: 3,
                        child: Text(effect,
                            style: TextStyle(
                                color: present
                                    ? AppColors.lavender
                                    : AppColors.smoke.withOpacity(0.4),
                                fontSize: 9))),
                    Expanded(
                        flex: 2,
                        child: present
                            ? _badge(strength, sC)
                            : Text(strength,
                                style: TextStyle(
                                    color: AppColors.smoke.withOpacity(0.4),
                                    fontSize: 8))),
                    Expanded(
                        flex: 1,
                        child: Icon(
                            present ? Icons.check_circle : Icons.cancel,
                            color: present
                                ? AppColors.success
                                : AppColors.smoke.withOpacity(0.3),
                            size: 14)),
                  ]));
            }),
            const SizedBox(height: 10),
            _kvRow(l.activeContactsLabel, '$activeCount', _accent),
          ],

          // Magnetic pull & attraction type
          if (magneticPull.isNotEmpty)
            _kvRow(l.magneticPullLabel, magneticPull, AppColors.gold),
          if (attractionType.isNotEmpty)
            _kvRow(l.initialAttractionLabel, attractionType, AppColors.gold),

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
        ]));
  }

  // ════════════════════════════════════════════════════════════════════
  // 4. EMOTIONAL HARMONY
  // ════════════════════════════════════════════════════════════════════

  Widget _buildEmotionalHarmony(AppLocalizations l, Map<String, dynamic> e) {
    final score = (e['emotional_score'] as num?)?.toDouble() ?? 0;
    final moonCompat = _asMap(e['moon_sign_compatibility']);
    final nakCompat = _asMap(e['moon_nakshatra_compatibility']);
    final bhakoot = _asMap(e['bhakoot_axis']);
    final interp = e['emotional_interpretation']?.toString() ?? '';

    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: _cardBg.withOpacity(0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.aurora.withOpacity(0.2))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Score bar
          _progressBar(l.emotionalScoreLabel, score, barColor: AppColors.aurora),
          const SizedBox(height: 14),

          // Moon sign compatibility card
          if (moonCompat.isNotEmpty) ...[
            Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: AppColors.aurora.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: AppColors.aurora.withOpacity(0.2))),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.moonSignCompat,
                          style: TextStyle(
                              color: AppColors.aurora,
                              fontSize: 8,
                              letterSpacing: 1.5,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Row(children: [
                        Expanded(
                            child: Column(children: [
                          Text(l.hisMoon,
                              style: TextStyle(
                                  color: AppColors.smoke,
                                  fontSize: 7,
                                  fontFamily: 'monospace',
                                  letterSpacing: 1)),
                          const SizedBox(height: 2),
                          Text(moonCompat['his_moon']?.toString() ?? '',
                              style: const TextStyle(
                                  color: AppColors.ivory,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'serif')),
                        ])),
                        Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                                color: _accent.withOpacity(0.15),
                                shape: BoxShape.circle),
                            child: const Center(
                                child: Icon(Icons.favorite,
                                    color: _accent, size: 14))),
                        Expanded(
                            child: Column(children: [
                          Text(l.herMoon,
                              style: TextStyle(
                                  color: AppColors.smoke,
                                  fontSize: 7,
                                  fontFamily: 'monospace',
                                  letterSpacing: 1)),
                          const SizedBox(height: 2),
                          Text(moonCompat['her_moon']?.toString() ?? '',
                              style: const TextStyle(
                                  color: AppColors.ivory,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'serif')),
                        ])),
                      ]),
                      const SizedBox(height: 8),
                      if (moonCompat['element_match'] != null)
                        _kvRow(l.elementMatchLabel,
                            moonCompat['element_match'].toString(),
                            AppColors.gold),
                      if (moonCompat['harmony'] != null)
                        _kvRow(l.harmonyLabel,
                            moonCompat['harmony'].toString(),
                            _harmonyColor(moonCompat['harmony'].toString())),
                      if (moonCompat['interpretation'] != null) ...[
                        const SizedBox(height: 4),
                        Text(moonCompat['interpretation'].toString(),
                            style: const TextStyle(
                                color: AppColors.lavender,
                                fontSize: 9,
                                height: 1.3,
                                fontStyle: FontStyle.italic)),
                      ],
                    ])),
            const SizedBox(height: 10),
          ],

          // Nakshatra compatibility — kootas
          if (nakCompat.isNotEmpty) ...[
            Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: AppColors.indigo.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: AppColors.indigo.withOpacity(0.2))),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.nakshatraCompat,
                          style: TextStyle(
                              color: AppColors.lavender,
                              fontSize: 8,
                              letterSpacing: 1.5,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Row(children: [
                        Expanded(
                            child: _kootaChip(
                                l.kootaYoni,
                                nakCompat['yoni_koota']?.toString() ?? '')),
                        const SizedBox(width: 6),
                        Expanded(
                            child: _kootaChip(
                                l.kootaGana,
                                nakCompat['gana_koota']?.toString() ?? '')),
                        const SizedBox(width: 6),
                        Expanded(
                            child: _kootaChip(
                                l.kootaTara,
                                nakCompat['tara_koota']?.toString() ?? '')),
                      ]),
                      if (nakCompat['interpretation'] != null) ...[
                        const SizedBox(height: 8),
                        Text(nakCompat['interpretation'].toString(),
                            style: const TextStyle(
                                color: AppColors.lavender,
                                fontSize: 9,
                                height: 1.3,
                                fontStyle: FontStyle.italic)),
                      ],
                    ])),
            const SizedBox(height: 10),
          ],

          // Bhakoot axis
          if (bhakoot.isNotEmpty) ...[
            Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: (bhakoot['dosha_present'] == true
                            ? AppColors.error
                            : AppColors.success)
                        .withOpacity(0.06),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: (bhakoot['dosha_present'] == true
                                ? AppColors.error
                                : AppColors.success)
                            .withOpacity(0.2))),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                            child: Text(l.bhakootAxis,
                                style: const TextStyle(
                                    color: AppColors.smoke,
                                    fontSize: 8,
                                    letterSpacing: 1.5,
                                    fontFamily: 'monospace',
                                    fontWeight: FontWeight.w600))),
                        if (bhakoot['dosha_present'] == true)
                          _badge(l.doshaPresentBadge, AppColors.error)
                        else
                          _badge(l.noDoshaBadge, AppColors.success),
                      ]),
                      const SizedBox(height: 6),
                      if (bhakoot['axis'] != null)
                        _kvRow(l.axisLabel, bhakoot['axis'].toString(),
                            AppColors.gold),
                      if (bhakoot['interpretation'] != null) ...[
                        const SizedBox(height: 4),
                        Text(bhakoot['interpretation'].toString(),
                            style: const TextStyle(
                                color: AppColors.lavender,
                                fontSize: 9,
                                height: 1.3,
                                fontStyle: FontStyle.italic)),
                      ],
                    ])),
          ],

          // Overall emotional interpretation
          if (interp.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(interp,
                style: const TextStyle(
                    color: AppColors.lavender,
                    fontSize: 10,
                    height: 1.4,
                    fontStyle: FontStyle.italic)),
          ],
        ]));
  }

  Widget _kootaChip(String label, String value) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
            color: AppColors.lavender.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.lavender.withOpacity(0.2))),
        child: Column(children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.smoke,
                  fontSize: 7,
                  fontFamily: 'monospace',
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 3),
          Text(value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.ivory,
                  fontSize: 11,
                  fontWeight: FontWeight.w700)),
        ]));
  }

  // ════════════════════════════════════════════════════════════════════
  // 5. MENTAL RAPPORT
  // ════════════════════════════════════════════════════════════════════

  Widget _buildMentalRapport(AppLocalizations l, Map<String, dynamic> m) {
    final score = (m['mental_score'] as num?)?.toDouble() ?? 0;
    final mercury = m['mercury_dynamics']?.toString() ?? '';
    final commStyle = m['communication_style_match']?.toString() ?? '';
    final intellectual = m['intellectual_connection']?.toString() ?? '';
    final interp = m['interpretation']?.toString() ?? '';

    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: _cardBg.withOpacity(0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.lavender.withOpacity(0.2))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _progressBar(l.mentalScoreLabel, score, barColor: AppColors.lavender),
          const SizedBox(height: 14),

          if (mercury.isNotEmpty) ...[
            _infoBlock(l.mercuryDynamicsLabel, mercury, AppColors.lavender),
            const SizedBox(height: 8),
          ],
          if (commStyle.isNotEmpty) ...[
            _infoBlock(
                l.communicationStyleLabel, commStyle, AppColors.aurora),
            const SizedBox(height: 8),
          ],
          if (intellectual.isNotEmpty) ...[
            _infoBlock(
                l.intellectualConnectionLabel, intellectual, AppColors.gold),
            const SizedBox(height: 8),
          ],

          if (interp.isNotEmpty)
            Text(interp,
                style: const TextStyle(
                    color: AppColors.lavender,
                    fontSize: 10,
                    height: 1.4,
                    fontStyle: FontStyle.italic)),
        ]));
  }

  // ════════════════════════════════════════════════════════════════════
  // 6. PASSION & PHYSICAL
  // ════════════════════════════════════════════════════════════════════

  Widget _buildPassionPhysical(AppLocalizations l, Map<String, dynamic> p) {
    final score = (p['passion_score'] as num?)?.toDouble() ?? 0;
    final marsVenus = p['mars_venus_interplay']?.toString() ?? '';
    final physChem = p['physical_chemistry']?.toString() ?? '';
    final yoni = p['yoni_compatibility']?.toString() ?? '';
    final interp = p['interpretation']?.toString() ?? '';

    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: _cardBg.withOpacity(0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.saffron.withOpacity(0.2))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _progressBar(l.passionScoreLabel, score, barColor: AppColors.saffron),
          const SizedBox(height: 14),

          if (marsVenus.isNotEmpty) ...[
            _infoBlock(l.marsVenusLabel, marsVenus, AppColors.saffron),
            const SizedBox(height: 8),
          ],
          if (physChem.isNotEmpty) ...[
            _infoBlock(l.physicalChemistryLabel, physChem, _accent),
            const SizedBox(height: 8),
          ],
          if (yoni.isNotEmpty) ...[
            _infoBlock(l.yoniCompatLabel, yoni, AppColors.gold),
            const SizedBox(height: 8),
          ],

          if (interp.isNotEmpty)
            Text(interp,
                style: const TextStyle(
                    color: AppColors.lavender,
                    fontSize: 10,
                    height: 1.4,
                    fontStyle: FontStyle.italic)),
        ]));
  }

  // ════════════════════════════════════════════════════════════════════
  // 7. LONG-TERM HARMONY
  // ════════════════════════════════════════════════════════════════════

  Widget _buildLongtermHarmony(AppLocalizations l, Map<String, dynamic> lt) {
    final score = (lt['longterm_score'] as num?)?.toDouble() ?? 0;
    final seventh = lt['seventh_house_synastry']?.toString() ?? '';
    final commitment = lt['commitment_potential']?.toString() ?? '';
    final jupiter = lt['jupiter_blessing']?.toString() ?? '';
    final d9 = lt['d9_navamsa_resonance']?.toString() ?? '';
    final saturn = lt['saturn_longevity']?.toString() ?? '';
    final interp = lt['interpretation']?.toString() ?? '';

    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: _cardBg.withOpacity(0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.success.withOpacity(0.2))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _progressBar(l.longtermScoreLabel, score, barColor: AppColors.success),
          const SizedBox(height: 14),

          if (seventh.isNotEmpty) ...[
            _infoBlock(l.seventhHouseSynastryLabel, seventh, AppColors.gold),
            const SizedBox(height: 8),
          ],
          if (commitment.isNotEmpty) ...[
            _infoBlock(l.commitmentPotentialLabel, commitment, AppColors.success),
            const SizedBox(height: 8),
          ],
          if (jupiter.isNotEmpty) ...[
            _infoBlock(l.jupiterBlessingLabel, jupiter, AppColors.gold),
            const SizedBox(height: 8),
          ],
          if (d9.isNotEmpty) ...[
            _infoBlock(l.d9NavamsaResonanceLabel, d9, AppColors.lavender),
            const SizedBox(height: 8),
          ],
          if (saturn.isNotEmpty) ...[
            _infoBlock(l.saturnLongevityLabel, saturn, AppColors.aurora),
            const SizedBox(height: 8),
          ],

          if (interp.isNotEmpty)
            Text(interp,
                style: const TextStyle(
                    color: AppColors.lavender,
                    fontSize: 10,
                    height: 1.4,
                    fontStyle: FontStyle.italic)),
        ]));
  }

  // ════════════════════════════════════════════════════════════════════
  // 8. KARMIC LOVE BOND
  // ════════════════════════════════════════════════════════════════════

  Widget _buildKarmicBond(AppLocalizations l, Map<String, dynamic> k) {
    final score = (k['karmic_score'] as num?)?.toDouble() ?? 0;
    final ketuContacts = (k['ketu_contacts'] as List?) ?? [];
    final rahuContacts = (k['rahu_contacts'] as List?) ?? [];
    final darakaraka = k['darakaraka_link']?.toString() ?? '';
    final pastLife = k['past_life_indication']?.toString() ?? '';
    final interp = k['interpretation']?.toString() ?? '';

    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: _cardBg.withOpacity(0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.indigo.withOpacity(0.3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _progressBar(l.karmicScoreLabel, score, barColor: AppColors.indigo),
          const SizedBox(height: 14),

          // Ketu contacts chips
          if (ketuContacts.isNotEmpty) ...[
            Text(l.ketuContacts,
                style: TextStyle(
                    color: AppColors.smoke,
                    fontSize: 8,
                    fontFamily: 'monospace',
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Wrap(
                spacing: 6,
                runSpacing: 4,
                children: ketuContacts
                    .map((c) =>
                        _badge(c.toString(), AppColors.lavender))
                    .toList()),
            const SizedBox(height: 10),
          ],

          // Rahu contacts chips
          if (rahuContacts.isNotEmpty) ...[
            Text(l.rahuContacts,
                style: TextStyle(
                    color: AppColors.smoke,
                    fontSize: 8,
                    fontFamily: 'monospace',
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Wrap(
                spacing: 6,
                runSpacing: 4,
                children: rahuContacts
                    .map((c) =>
                        _badge(c.toString(), AppColors.saffron))
                    .toList()),
            const SizedBox(height: 10),
          ],

          // Darakaraka link
          if (darakaraka.isNotEmpty) ...[
            _infoBlock(l.darakarakaLinkLabel, darakaraka, AppColors.gold),
            const SizedBox(height: 8),
          ],

          // Past life indication
          if (pastLife.isNotEmpty) ...[
            Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: AppColors.indigo.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: AppColors.indigo.withOpacity(0.25))),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.pastLifeIndication,
                          style: TextStyle(
                              color: AppColors.lavender,
                              fontSize: 8,
                              letterSpacing: 1,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(pastLife,
                          style: const TextStyle(
                              color: AppColors.ivory,
                              fontSize: 11,
                              height: 1.4)),
                    ])),
            const SizedBox(height: 8),
          ],

          if (interp.isNotEmpty)
            Text(interp,
                style: const TextStyle(
                    color: AppColors.lavender,
                    fontSize: 10,
                    height: 1.4,
                    fontStyle: FontStyle.italic)),
        ]));
  }

  // ════════════════════════════════════════════════════════════════════
  // 9. CHALLENGES & FRICTION
  // ════════════════════════════════════════════════════════════════════

  Widget _buildChallenges(AppLocalizations l, Map<String, dynamic> ch) {
    final detected = (ch['challenges_detected'] as List?) ?? [];
    final totalPenalty =
        (ch['total_challenge_penalty'] as num?)?.toDouble() ?? 0;
    final challengeSummary = ch['challenge_summary']?.toString() ?? '';

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Penalty header
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
                  child: Text(l.totalChallengePenalty,
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
            if (challengeSummary.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(challengeSummary,
                  style: const TextStyle(
                      color: AppColors.ivory,
                      fontSize: 10,
                      height: 1.4)),
            ],
          ])),

      // Individual challenges
      ...detected.map((d) {
        final dm = _asMap(d);
        final challenge = dm['challenge']?.toString() ?? '';
        final source = dm['source']?.toString() ?? '';
        final severity = dm['severity']?.toString() ?? '';
        final manifestation = dm['manifestation']?.toString() ?? '';
        final cancellation = dm['cancellation']?.toString() ?? '';
        final navigation = dm['navigation']?.toString() ?? '';
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
                  // Challenge name + severity badge
                  Row(children: [
                    Expanded(
                        child: Text(challenge,
                            style: TextStyle(
                                color: sevC,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'serif'))),
                    _badge(severity.toUpperCase(), sevC),
                  ]),

                  // Source
                  if (source.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    _kvRow(l.sourceLabel, source, AppColors.smoke),
                  ],

                  // Manifestation
                  if (manifestation.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(l.manifestation,
                        style: TextStyle(
                            color: AppColors.smoke,
                            fontSize: 8,
                            fontFamily: 'monospace',
                            letterSpacing: 1)),
                    const SizedBox(height: 3),
                    Text(manifestation,
                        style: const TextStyle(
                            color: AppColors.ivory,
                            fontSize: 10,
                            height: 1.4)),
                  ],

                  // Cancellation
                  if (cancellation.isNotEmpty) ...[
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
                              Text(l.cancellation,
                                  style: TextStyle(
                                      color: AppColors.success,
                                      fontSize: 8,
                                      letterSpacing: 1,
                                      fontFamily: 'monospace',
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(height: 3),
                              Text(cancellation,
                                  style: const TextStyle(
                                      color: AppColors.ivory,
                                      fontSize: 10,
                                      height: 1.4)),
                            ])),
                  ],

                  // Navigation
                  if (navigation.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: AppColors.gold.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: AppColors.gold.withOpacity(0.2))),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l.navigation,
                                  style: TextStyle(
                                      color: AppColors.gold,
                                      fontSize: 8,
                                      letterSpacing: 1,
                                      fontFamily: 'monospace',
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(height: 3),
                              Text(navigation,
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
  // 10. TIMING (MOOLA DASHA)
  // ════════════════════════════════════════════════════════════════════

  Widget _buildTiming(AppLocalizations l, Map<String, dynamic> timing) {
    final combinedScore =
        (timing['combined_timing_score'] as num?)?.toDouble() ?? 0;
    final timingVerdict = timing['timing_verdict']?.toString() ?? '';
    final nextWindow = timing['next_favorable_window']?.toString() ?? '';
    final p1Dasha = _asMap(timing['current_dasha_partner1']);
    final p2Dasha = _asMap(timing['current_dasha_partner2']);
    final windows = (timing['favorable_love_windows'] as List?) ?? [];

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
          if (p1Dasha.isNotEmpty)
            _buildDashaPartnerBlock(l, l.partnerOneLabel, p1Dasha),
          if (p1Dasha.isNotEmpty && p2Dasha.isNotEmpty)
            const SizedBox(height: 10),
          // Partner 2 current dasha
          if (p2Dasha.isNotEmpty)
            _buildDashaPartnerBlock(l, l.partnerTwoLabel, p2Dasha),

          // Favorable love windows
          if (windows.isNotEmpty) ...[
            const SizedBox(height: 14),
            _label(l.favorableLoveWindowsLabel),
            const SizedBox(height: 8),
            ...windows.map((w) {
              final wm = _asMap(w);
              final period = wm['period']?.toString() ?? '';
              final start = wm['start_date']?.toString() ?? '';
              final end = wm['end_date']?.toString() ?? '';
              final factor = wm['activating_factor']?.toString() ?? '';
              final appliesTo = wm['applies_to']?.toString() ?? '';
              final significance = wm['significance']?.toString() ?? '';
              final sC = significance.toLowerCase().contains('high') ||
                      significance.toLowerCase().contains('strong')
                  ? AppColors.success
                  : significance.toLowerCase().contains('moderate')
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
                          if (significance.isNotEmpty)
                            _badge(significance, sC),
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
                          Text(l.factorPrefix(factor),
                              style: const TextStyle(
                                  color: AppColors.lavender,
                                  fontSize: 9,
                                  height: 1.3)),
                        ],
                        if (appliesTo.isNotEmpty)
                          Text(l.appliesToLabel(appliesTo),
                              style: const TextStyle(
                                  color: AppColors.smoke, fontSize: 9)),
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

  Widget _buildDashaPartnerBlock(AppLocalizations l, String label, Map<String, dynamic> pd) {
    final moola = _asMap(pd['moola']);
    final favorability = pd['love_favorability']?.toString() ?? '';
    final favScore = (pd['favorability_score'] as num?)?.toDouble() ?? 0;
    final reasoning = pd['reasoning']?.toString() ?? '';

    final md = moola['md']?.toString() ?? '';
    final ad = moola['ad']?.toString() ?? '';
    final pdStr = moola['pd']?.toString() ?? '';
    final dates = moola['dates']?.toString() ?? '';

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
          if (md.isNotEmpty) _kvRow(l.mahadashaLabel, md, AppColors.gold),
          if (ad.isNotEmpty) _kvRow(l.antardashaLabel, ad, AppColors.gold),
          if (pdStr.isNotEmpty) _kvRow(l.pratyantardashaLabel, pdStr, AppColors.gold),
          if (dates.isNotEmpty) _kvRow(l.datesLabel, dates, AppColors.smoke),

          // Favorability score bar
          if (favScore > 0) ...[
            const SizedBox(height: 6),
            _progressBar(l.favorabilityLabel, favScore),
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
  // 11. RELATIONSHIP DYNAMICS
  // ════════════════════════════════════════════════════════════════════

  Widget _buildDynamics(AppLocalizations l, Map<String, dynamic> d) {
    final emotionalGiver = d['emotional_giver_receiver']?.toString() ?? '';
    final powerBalance = d['power_balance']?.toString() ?? '';
    final growthDynamic = d['growth_dynamic']?.toString() ?? '';
    final strengths = (d['potential_strengths'] as List?) ?? [];
    final nurture = (d['areas_to_nurture'] as List?) ?? [];
    final interp = d['interpretation']?.toString() ?? '';

    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: _cardBg.withOpacity(0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _accent.withOpacity(0.2))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Giver/Receiver
          if (emotionalGiver.isNotEmpty) ...[
            _infoBlock(
                l.emotionalGiverReceiverLabel, emotionalGiver, _accent),
            const SizedBox(height: 10),
          ],

          // Power balance
          if (powerBalance.isNotEmpty) ...[
            _infoBlock(l.powerBalanceLabel, powerBalance, AppColors.aurora),
            const SizedBox(height: 10),
          ],

          // Growth dynamic
          if (growthDynamic.isNotEmpty) ...[
            _infoBlock(l.growthDynamicLabel, growthDynamic, AppColors.gold),
            const SizedBox(height: 10),
          ],

          // Potential strengths chips
          if (strengths.isNotEmpty) ...[
            Text(l.potentialStrengths,
                style: TextStyle(
                    color: AppColors.success,
                    fontSize: 8,
                    letterSpacing: 1,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Wrap(
                spacing: 6,
                runSpacing: 4,
                children: strengths
                    .map((s) => _pill(s.toString(), AppColors.success))
                    .toList()),
            const SizedBox(height: 10),
          ],

          // Areas to nurture chips
          if (nurture.isNotEmpty) ...[
            Text(l.areasToNurture,
                style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 8,
                    letterSpacing: 1,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Wrap(
                spacing: 6,
                runSpacing: 4,
                children: nurture
                    .map((n) => _pill(n.toString(), AppColors.gold))
                    .toList()),
            const SizedBox(height: 10),
          ],

          if (interp.isNotEmpty)
            Text(interp,
                style: const TextStyle(
                    color: AppColors.lavender,
                    fontSize: 10,
                    height: 1.4,
                    fontStyle: FontStyle.italic)),
        ]));
  }

  // ════════════════════════════════════════════════════════════════════
  // 12. REMEDIES & GUIDANCE
  // ════════════════════════════════════════════════════════════════════

  Widget _buildRemedies(AppLocalizations l, Map<String, dynamic> remedies) {
    final recommended = (remedies['recommended_remedies'] as List?) ?? [];
    final guidance = remedies['relationship_guidance']?.toString() ?? '';
    final note = remedies['note']?.toString() ?? '';

    final typeIcons = {
      'gemstone': Icons.diamond_outlined,
      'mantra': Icons.self_improvement,
      'ritual': Icons.local_fire_department_outlined,
      'lifestyle': Icons.favorite_outline,
      'charitable': Icons.volunteer_activism_outlined,
      'puja': Icons.temple_hindu_outlined,
      'yantra': Icons.grid_on,
    };
    final typeColors = {
      'gemstone': AppColors.aurora,
      'mantra': AppColors.gold,
      'ritual': AppColors.saffron,
      'lifestyle': AppColors.success,
      'charitable': _accent,
      'puja': AppColors.gold,
      'yantra': AppColors.lavender,
    };

    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: _cardBg.withOpacity(0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.gold.withOpacity(0.2))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Individual remedy cards
          ...recommended.map((r) {
            final rm = _asMap(r);
            final remedyType = rm['remedy_type']?.toString().toLowerCase() ?? '';
            final remedy = rm['remedy']?.toString() ?? '';
            final forWhom = rm['for_whom']?.toString() ?? '';
            final addresses = rm['addresses']?.toString() ?? '';
            final classical = rm['classical_basis']?.toString() ?? '';
            final rColor = typeColors[remedyType] ?? AppColors.gold;
            final rIcon = typeIcons[remedyType] ?? Icons.star_outline;

            return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: rColor.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: rColor.withOpacity(0.2))),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Icon(rIcon, color: rColor, size: 14),
                        const SizedBox(width: 6),
                        _badge(remedyType.toUpperCase(), rColor),
                        const Spacer(),
                        if (forWhom.isNotEmpty)
                          _badge(forWhom, AppColors.smoke),
                      ]),
                      const SizedBox(height: 8),
                      Text(remedy,
                          style: const TextStyle(
                              color: AppColors.ivory,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              height: 1.4)),
                      if (addresses.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        _kvRow(l.addressesLabel, addresses, AppColors.lavender),
                      ],
                      if (classical.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                color: AppColors.gold.withOpacity(0.06),
                                borderRadius: BorderRadius.circular(4)),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l.basis,
                                      style: TextStyle(
                                          color: AppColors.gold,
                                          fontSize: 7,
                                          fontFamily: 'monospace',
                                          fontWeight: FontWeight.w600)),
                                  Expanded(
                                      child: Text(classical,
                                          style: const TextStyle(
                                              color: AppColors.smoke,
                                              fontSize: 9,
                                              height: 1.3))),
                                ])),
                      ],
                    ]));
          }),

          // Relationship guidance
          if (guidance.isNotEmpty) ...[
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
                      Text(l.relationshipGuidance,
                          style: TextStyle(
                              color: AppColors.gold,
                              fontSize: 8,
                              letterSpacing: 1,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(guidance,
                          style: const TextStyle(
                              color: AppColors.ivory,
                              fontSize: 10,
                              height: 1.4,
                              fontStyle: FontStyle.italic)),
                    ])),
            const SizedBox(height: 8),
          ],

          // Note
          if (note.isNotEmpty)
            Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: AppColors.smoke.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: AppColors.smoke.withOpacity(0.15))),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline,
                          color: AppColors.smoke, size: 14),
                      const SizedBox(width: 6),
                      Expanded(
                          child: Text(note,
                              style: const TextStyle(
                                  color: AppColors.smoke,
                                  fontSize: 9,
                                  height: 1.4))),
                    ])),
        ]));
  }

  // ════════════════════════════════════════════════════════════════════
  // 13. SUMMARY — key insights + human summary
  // ════════════════════════════════════════════════════════════════════

  Widget _buildSummary(AppLocalizations l, Map<String, dynamic> s) {
    final keyInsights = (s['key_insights'] as List?) ?? [];
    final humanSummary = s['human_summary']?.toString() ?? '';

    return Container(
        margin: const EdgeInsets.fromLTRB(16, 14, 16, 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppColors.gold.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gold.withOpacity(0.25))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _label(l.summary.toUpperCase()),
          const SizedBox(height: 10),

          // Key insights as numbered list
          if (keyInsights.isNotEmpty) ...[
            Text(l.keyInsights,
                style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 8,
                    letterSpacing: 1,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            ...keyInsights.asMap().entries.map((entry) {
              final idx = entry.key + 1;
              final insight = entry.value.toString();
              return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: 20,
                            height: 20,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                                color: _accent.withOpacity(0.15),
                                shape: BoxShape.circle),
                            child: Center(
                                child: Text('$idx',
                                    style: const TextStyle(
                                        color: _accent,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'monospace')))),
                        Expanded(
                            child: Text(insight,
                                style: const TextStyle(
                                    color: AppColors.ivory,
                                    fontSize: 11,
                                    height: 1.4))),
                      ]));
            }),
            const SizedBox(height: 10),
          ],

          // Human summary
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
          ],
        ]));
  }

  // ════════════════════════════════════════════════════════════════════
  // 15. AI COPY BAR
  // ════════════════════════════════════════════════════════════════════

  Widget _buildAiCopyBar(AppLocalizations l, BuildContext ctx) {
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
          Text(l.discussWithAI,
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
                'Analyze this Vedic astrology Love Compatibility report and give detailed insights:\n\n'),
            const SizedBox(width: 8),
            _aiBtn(
                ctx,
                'C',
                'Claude',
                const LinearGradient(
                    colors: [Color(0xFFD97757), Color(0xFFB85B3F)]),
                'Here is a Vedic astrology Love Compatibility report. Analyze it thoroughly and provide actionable insights:\n\n'),
            const SizedBox(width: 8),
            _aiBtn(
                ctx,
                '✦',
                'Gemini',
                const LinearGradient(
                    colors: [Color(0xFF4285F4), Color(0xFF9B72CB)]),
                'Review this Love Compatibility astrology analysis and explain key findings simply:\n\n'),
          ]),
        ]));
  }

  Widget _aiBtn(BuildContext ctx, String icon, String name, Gradient g,
      String prefix) {
    final l = AppLocalizations.of(ctx)!;
    return Expanded(
        child: GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: prefix + _fmt(data)));
              ScaffoldMessenger.of(ctx)
                  .showSnackBar(SnackBar(content: Text(l.copiedForName(name))));
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
                  Text(l.copy,
                      style: const TextStyle(
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

  Widget _scoreChip(String label, double value,
      {bool isPenalty = false, Color? chipColor}) {
    final c = isPenalty
        ? (value > 0 ? AppColors.error : AppColors.success)
        : chipColor ?? _scoreColor(value);
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
            width: 110,
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

  Widget _progressBar(String label, double value, {Color? barColor}) {
    final c = barColor ?? _scoreColor(value);
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

  Widget _infoBlock(String title, String content, Color color) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: color.withOpacity(0.06),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.2))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: TextStyle(
                  color: color,
                  fontSize: 8,
                  letterSpacing: 1,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(content,
              style: const TextStyle(
                  color: AppColors.ivory,
                  fontSize: 11,
                  height: 1.4)),
        ]));
  }

  Widget _pill(String text, Color c) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: c.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: c.withOpacity(0.3))),
      child: Text(text,
          style: TextStyle(
              color: c,
              fontSize: 10,
              fontWeight: FontWeight.w500)));

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

  static Color _scoreColor(double v) => v >= 70
      ? AppColors.success
      : v >= 50
          ? AppColors.gold
          : v >= 30
              ? const Color(0xFFE5A93A)
              : AppColors.error;

  static Color _harmonyColor(String harmony) {
    final h = harmony.toLowerCase();
    if (h.contains('excellent') || h.contains('high') || h.contains('strong')) {
      return AppColors.success;
    }
    if (h.contains('good') || h.contains('moderate')) return AppColors.gold;
    if (h.contains('low') || h.contains('poor') || h.contains('weak')) {
      return AppColors.error;
    }
    return AppColors.aurora;
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
