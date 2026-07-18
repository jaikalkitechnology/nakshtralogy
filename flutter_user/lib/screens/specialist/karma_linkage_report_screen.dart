import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import 'report_components.dart';

class KarmaLinkageReportScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final List<String> participants;
  const KarmaLinkageReportScreen({
    super.key,
    required this.data,
    required this.participants,
  });

  static const _accent = AppColors.lavender;
  static const _bg = Color(0xFF0A0A24);
  static const _cardBg = Color(0xFF1A1642);

  @override
  Widget build(BuildContext context) {
    final overall = _asMap(data['overall_linkage_probability']);
    final perChart = _asList(data['per_chart_karmic_foundation']);
    final pairwise = _asList(data['pairwise_karmic_linkages']);
    final groupPattern = _asMap(data['group_karmic_pattern']);
    final pastGoals = _asMap(data['past_life_goals']);
    final learning = _asMap(data['current_life_learning']);
    final debts = _asMap(data['karmic_debts_resolutions']);
    final moolaTiming = _asMap(data['moola_dasha_karmic_timing']);
    final audit = _asMap(data['deep_audit_parameter_table']);
    final summary = _asMap(data['summary']);
    final conf = data['confidence_score'] is num ? (data['confidence_score'] as num).toDouble() : double.tryParse(data['confidence_score']?.toString() ?? '');
    final l = AppLocalizations.of(context)!;
    final confExp = data['confidence_explanation']?.toString();

    return Scaffold(
      backgroundColor: _bg,
      body: CustomScrollView(slivers: [
        // ═══ APP BAR ═══
        SliverAppBar(
          backgroundColor: _bg,
          pinned: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.ivory),
            onPressed: () => Navigator.pop(context),
          ),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                participants.join(' & ').toUpperCase(),
                style: const TextStyle(
                  color: AppColors.gold,
                  fontSize: 9,
                  letterSpacing: 1.5,
                  fontFamily: 'monospace',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text.rich(TextSpan(children: [
                TextSpan(
                  text: '${l.karmaLinkTitle1} ',
                  style: const TextStyle(
                    color: AppColors.ivory,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: l.karmaLinkTitle2,
                  style: const TextStyle(
                    color: _accent,
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ])),
            ],
          ),
          centerTitle: true,
        ),

        SliverList(
          delegate: SliverChildListDelegate([
            // 1. HERO
            _buildHero(l, overall),

            // 2. PER-CHART KARMIC FOUNDATION
            if (perChart.isNotEmpty) ...[
              _header(l.karmaFoundationHeader1, l.karmaFoundationHeader2),
              ...perChart.map((c) => _buildFoundationCard(l, _asMap(c))),
            ],

            // 3. PAIRWISE KARMIC LINKAGES
            if (pairwise.isNotEmpty) ...[
              _header(l.karmaPairwiseHeader1, l.karmaPairwiseHeader2),
              ...pairwise.map((p) => _buildPairwiseCard(l, _asMap(p))),
            ],

            // 4. GROUP KARMIC PATTERN
            if (groupPattern.isNotEmpty) ...[
              _header(l.karmaGroupHeader1, l.karmaGroupHeader2),
              _buildGroupPattern(l, groupPattern),
            ],

            // 5. PAST LIFE GOALS
            if (pastGoals.isNotEmpty) ...[
              _header(l.karmaPastLifeHeader1, l.karmaPastLifeHeader2),
              _buildPastLifeGoals(l, pastGoals),
            ],

            // 6. CURRENT LIFE LEARNING
            if (learning.isNotEmpty) ...[
              _header(l.karmaCurrentLifeHeader1, l.karmaCurrentLifeHeader2),
              _buildCurrentLifeLearning(l, learning),
            ],

            // 7. KARMIC DEBTS
            if (debts.isNotEmpty) ...[
              _header(l.karmaFoundationHeader1, l.karmaDebtsHeader2),
              _buildKarmicDebts(l, debts),
            ],

            // 8. MOOLA DASHA TIMING
            if (moolaTiming.isNotEmpty) ...[
              _header(l.karmaMoolaDashaHeader1, l.karmaMoolaDashaHeader2),
              _buildMoolaDashaTiming(l, moolaTiming),
            ],

            // 9. DEEP AUDIT TABLE
            if (audit.isNotEmpty) ...[
              _header(l.karmaDeepAuditHeader1, l.karmaDeepAuditHeader2),
              _buildAuditTable(l, audit),
            ],

            // 10. SUMMARY
            if (summary.isNotEmpty) _buildSummary(l, summary),

            // 11. CONFIDENCE
            if (conf != null) ...[
              ReportHeader(l.analysisWord, l.confidenceLabel, l.qualityTag),
              ConfidenceBlock(
                score: conf,
                statement: confExp,
                breakdown: _asMap(data['confidence_breakdown']),
              ),
            ],

            // 12. AI COPY BAR
            _buildAiCopyBar(context),
            const SizedBox(height: 40),
          ]),
        ),
      ]),
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // 1. HERO — Score ring + grade + verdict + probability + chips
  // ════════════════════════════════════════════════════════════════════

  Widget _buildHero(AppLocalizations l, Map<String, dynamic> overall) {
    final score = _num(overall, 'overall_linkage_score');
    final grade = overall['linkage_grade']?.toString() ?? '';
    final verdict = overall['linkage_verdict']?.toString() ?? '';
    final probability = overall['probability_statement']?.toString() ?? '';
    final sc = _scoreColor(score);
    final components = _asMap(overall['score_components']);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          _accent.withOpacity(0.12),
          const Color(0xFF4A3B8C).withOpacity(0.1),
        ]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _accent.withOpacity(0.3)),
      ),
      child: Column(children: [
        _label(l.karmaHeroLabel),
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
                value: (score / 100).clamp(0, 1),
                strokeWidth: 8,
                backgroundColor: Colors.white.withOpacity(0.08),
                valueColor: AlwaysStoppedAnimation(sc),
              ),
            ),
            Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                score.toStringAsFixed(0),
                style: TextStyle(
                  color: sc,
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'serif',
                ),
              ),
              Text(
                grade,
                style: TextStyle(
                  color: sc,
                  fontSize: 10,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ]),
          ]),
        ),
        const SizedBox(height: 10),

        // Grade badge
        if (grade.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: sc.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              grade,
              style: TextStyle(color: sc, fontSize: 11, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
        const SizedBox(height: 8),

        // Verdict
        if (verdict.isNotEmpty)
          Text(
            verdict,
            style: const TextStyle(
              color: AppColors.ivory,
              fontSize: 12,
              height: 1.4,
              fontWeight: FontWeight.w600,
              fontFamily: 'serif',
            ),
            textAlign: TextAlign.center,
          ),
        const SizedBox(height: 6),

        // Probability statement
        if (probability.isNotEmpty)
          Text(
            probability,
            style: const TextStyle(
              color: AppColors.lavender,
              fontSize: 10,
              height: 1.4,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),

        // Score component chips
        if (components.isNotEmpty) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: _accent.withOpacity(0.2), width: 0.5),
              ),
            ),
            child: Column(children: [
              Wrap(
                spacing: 8,
                runSpacing: 6,
                alignment: WrapAlignment.center,
                children: [
                  _scoreChip('Avg Pairwise', _num(components, 'avg_pairwise_linkage')),
                  _scoreChip('Group Cohesion', _num(components, 'group_cohesion')),
                  _scoreChip('Rahu-Ketu Axis', _num(components, 'rahu_ketu_axis_resonance')),
                  _scoreChip('Atmakaraka', _num(components, 'atmakaraka_resonance')),
                  _scoreChip('D60 Resonance', _num(components, 'D60_group_resonance') + _num(components, 'd60_group_resonance')),
                ],
              ),
              if (components['explanation'] != null) ...[
                const SizedBox(height: 8),
                Text(
                  components['explanation'].toString(),
                  style: const TextStyle(
                    color: AppColors.smoke,
                    fontSize: 9,
                    height: 1.3,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ]),
          ),
        ],
      ]),
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // 2. PER-CHART KARMIC FOUNDATION
  // ════════════════════════════════════════════════════════════════════

  Widget _buildFoundationCard(AppLocalizations l, Map<String, dynamic> chart) {
    final name = chart['chart_name']?.toString() ?? '—';
    final ketu = _asMap(chart['ketu_mastery']);
    final rahu = _asMap(chart['rahu_growth']);
    final atma = _asMap(chart['atmakaraka']);
    final saturn = _asMap(chart['saturn_karma']);
    final twelfth = _asMap(chart['twelfth_house']);
    final ninth = _asMap(chart['ninth_house_punya']);
    final d60 = _asMap(chart['d60_signature']);
    final karSummary = chart['individual_karmic_summary']?.toString() ?? '';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardBg.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _accent.withOpacity(0.25)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Person name header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: _accent.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            name,
            style: const TextStyle(
              color: _accent,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontFamily: 'serif',
            ),
          ),
        ),

        // Ketu Mastery
        if (ketu.isNotEmpty) ...[
          _subHeader(l.karmaKetuMastery, AppColors.lavender),
          _kvRow(l.house, 'H${ketu['house'] ?? "?"}', AppColors.gold),
          _kvRow(l.sign, ketu['sign']?.toString() ?? '—', AppColors.gold),
          _kvRow(l.nakshatraLabel, ketu['nakshatra']?.toString() ?? '—', AppColors.gold),
          if (ketu['nakshatra_deity'] != null)
            _kvRow(l.deityLabel, ketu['nakshatra_deity'].toString(), AppColors.aurora),
          _progressBar(l.masteryScoreLabel, _num(ketu, 'mastery_score')),
          if (ketu['interpretation'] != null) ...[
            const SizedBox(height: 4),
            _interpretationText(ketu['interpretation'].toString()),
          ],
          const SizedBox(height: 10),
        ],

        // Rahu Growth
        if (rahu.isNotEmpty) ...[
          _subHeader(l.karmaRahuGrowth, AppColors.cosmicPink),
          _kvRow(l.house, 'H${rahu['house'] ?? "?"}', AppColors.gold),
          _kvRow(l.sign, rahu['sign']?.toString() ?? '—', AppColors.gold),
          _kvRow(l.nakshatraLabel, rahu['nakshatra']?.toString() ?? '—', AppColors.gold),
          _progressBar(l.growthScoreLabel, _num(rahu, 'growth_score')),
          if (rahu['interpretation'] != null) ...[
            const SizedBox(height: 4),
            _interpretationText(rahu['interpretation'].toString()),
          ],
          const SizedBox(height: 10),
        ],

        // Atmakaraka
        if (atma.isNotEmpty) ...[
          _subHeader(l.karmaAtmakaraka, AppColors.gold),
          _kvRow(l.planet, atma['planet']?.toString() ?? '—', AppColors.gold),
          _kvRow(l.degreeLabel, '${_num(atma, 'degree').toStringAsFixed(2)}°', AppColors.aurora),
          _kvRow(l.house, 'H${atma['house'] ?? "?"}', AppColors.gold),
          if (atma['soul_agenda'] != null) ...[
            const SizedBox(height: 4),
            _interpretationText(atma['soul_agenda'].toString()),
          ],
          const SizedBox(height: 10),
        ],

        // Saturn Karma
        if (saturn.isNotEmpty) ...[
          _subHeader(l.karmaSaturnKarma, AppColors.smoke),
          _kvRow(l.house, 'H${saturn['house'] ?? "?"}', AppColors.gold),
          _kvRow(l.sign, saturn['sign']?.toString() ?? '—', AppColors.gold),
          if (saturn['dignity'] != null)
            _kvRow(l.dignityLabel, saturn['dignity'].toString(), _dignityColor(saturn['dignity'].toString())),
          if (saturn['karmic_duty'] != null) ...[
            const SizedBox(height: 4),
            _interpretationText(saturn['karmic_duty'].toString()),
          ],
          const SizedBox(height: 10),
        ],

        // 12th House
        if (twelfth.isNotEmpty) ...[
          _subHeader(l.karma12thHouse, AppColors.indigo),
          _kvRow(l.sign, twelfth['sign']?.toString() ?? '—', AppColors.gold),
          if (_asList(twelfth['occupants']).isNotEmpty) ...[
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: _asList(twelfth['occupants'])
                  .map((o) => _badge(o.toString(), AppColors.indigo))
                  .toList(),
            ),
          ],
          if (twelfth['past_life_carryover'] != null) ...[
            const SizedBox(height: 6),
            _interpretationText(twelfth['past_life_carryover'].toString()),
          ],
          const SizedBox(height: 10),
        ],

        // 9th House Punya
        if (ninth.isNotEmpty) ...[
          _subHeader(l.karma9thHousePunya, AppColors.success),
          _kvRow(l.sign, ninth['sign']?.toString() ?? '—', AppColors.gold),
          _kvRow(l.lordLabel, ninth['lord']?.toString() ?? '—', AppColors.gold),
          _progressBar(l.lordStrengthLabel, _num(ninth, 'lord_strength')),
          const SizedBox(height: 4),
          _progressBar(l.bhavaScoreLabel, _num(ninth, 'bhava_score')),
          if (ninth['accumulated_merit'] != null) ...[
            const SizedBox(height: 4),
            _interpretationText(ninth['accumulated_merit'].toString()),
          ],
          const SizedBox(height: 10),
        ],

        // D60 Signature
        if (d60.isNotEmpty) ...[
          _subHeader(l.karmaD60Signature, AppColors.saffron),
          _kvRow(l.lagna, d60['d60_lagna']?.toString() ?? '—', AppColors.gold),
          _kvRow(l.lagnaLord, d60['d60_lagna_lord']?.toString() ?? '—', AppColors.gold),
          _progressBar(l.depthScoreLabel, _num(d60, 'karmic_depth_score')),
          if (d60['interpretation'] != null) ...[
            const SizedBox(height: 4),
            _interpretationText(d60['interpretation'].toString()),
          ],
          const SizedBox(height: 10),
        ],

        // Individual karmic summary
        if (karSummary.isNotEmpty) ...[
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              border: const Border(left: BorderSide(color: AppColors.gold, width: 3)),
            ),
            child: Text(
              karSummary,
              style: const TextStyle(
                color: AppColors.ivory,
                fontSize: 10,
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ]),
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // 3. PAIRWISE KARMIC LINKAGES
  // ════════════════════════════════════════════════════════════════════

  Widget _buildPairwiseCard(AppLocalizations l, Map<String, dynamic> p) {
    final pair = p['pair']?.toString() ?? '—';
    final linkScore = _num(p, 'linkage_strength_score');
    final prob = p['linkage_probability']?.toString() ?? '';
    final relType = p['karmic_relationship_type']?.toString() ?? '';
    final relMeaning = p['relationship_type_meaning']?.toString() ?? '';
    final relReasoning = p['relationship_type_reasoning']?.toString() ?? '';
    final factors = _asList(p['linkage_factors']);
    final acRaw = p['active_factors_count'];
    final activeCount = acRaw is num ? acRaw.toInt() : (acRaw is String ? int.tryParse(acRaw) ?? 0 : 0);
    final pastConn = p['past_life_connection']?.toString() ?? '';
    final currentDyn = p['current_life_dynamic']?.toString() ?? '';
    final teach = p['what_they_teach_each_other']?.toString() ?? '';
    final interp = p['pair_interpretation']?.toString() ?? '';
    final sc = _scoreColor(linkScore);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          sc.withOpacity(0.08),
          _cardBg.withOpacity(0.5),
        ]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: sc.withOpacity(0.25)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Pair label + score
        Row(children: [
          Expanded(
            child: Text(
              pair,
              style: const TextStyle(
                color: AppColors.ivory,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: 'serif',
              ),
            ),
          ),
          Column(children: [
            Text(
              linkScore.toStringAsFixed(0),
              style: TextStyle(
                color: sc,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                fontFamily: 'serif',
              ),
            ),
            if (prob.isNotEmpty)
              _badge(prob, sc),
          ]),
        ]),
        const SizedBox(height: 8),

        // Linkage score bar
        _progressBar(l.linkageStrengthLabel, linkScore),
        const SizedBox(height: 10),

        // Karmic relationship type
        if (relType.isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _accent.withOpacity(0.25)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                relType,
                style: const TextStyle(
                  color: _accent,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'serif',
                ),
              ),
              if (relMeaning.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  relMeaning,
                  style: const TextStyle(
                    color: AppColors.ivory,
                    fontSize: 10,
                    height: 1.4,
                  ),
                ),
              ],
              if (relReasoning.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  relReasoning,
                  style: const TextStyle(
                    color: AppColors.smoke,
                    fontSize: 9,
                    height: 1.3,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ]),
          ),
          const SizedBox(height: 10),
        ],

        // Linkage factors table
        if (factors.isNotEmpty) ...[
          _subHeader(l.karmaLinkageFactorsHeader(activeCount), AppColors.aurora),
          const SizedBox(height: 4),
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(children: [
              Expanded(flex: 3, child: Text(l.factorColumnLabel, style: const TextStyle(color: AppColors.smoke, fontSize: 8, fontFamily: 'monospace', fontWeight: FontWeight.w600))),
              Expanded(flex: 1, child: Text(l.weightColumnLabel, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.smoke, fontSize: 8, fontFamily: 'monospace', fontWeight: FontWeight.w600))),
              Expanded(flex: 3, child: Text(l.meaningColumnLabel, style: const TextStyle(color: AppColors.smoke, fontSize: 8, fontFamily: 'monospace', fontWeight: FontWeight.w600))),
              SizedBox(width: 50, child: Text(l.statusColumnLabel, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.smoke, fontSize: 8, fontFamily: 'monospace', fontWeight: FontWeight.w600))),
            ]),
          ),
          ...factors.map((f) {
            final fm = _asMap(f);
            final present = fm['present'] == true;
            final weight = _num(fm, 'weight');
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.04))),
              ),
              child: Row(children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    fm['factor']?.toString() ?? '—',
                    style: const TextStyle(color: AppColors.ivory, fontSize: 9, height: 1.3),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    weight.toStringAsFixed(1),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.gold,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    fm['meaning']?.toString() ?? '—',
                    style: const TextStyle(color: AppColors.smoke, fontSize: 8, height: 1.3),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Center(
                    child: _badge(
                      present ? l.yesWord : l.noWord,
                      present ? AppColors.success : AppColors.error,
                    ),
                  ),
                ),
              ]),
            );
          }),
          const SizedBox(height: 10),
        ],

        // Past life connection
        if (pastConn.isNotEmpty) ...[
          _subHeader(l.karmaPastLifeConnection, AppColors.lavender),
          const SizedBox(height: 4),
          _interpretationText(pastConn),
          const SizedBox(height: 8),
        ],

        // Current life dynamic
        if (currentDyn.isNotEmpty) ...[
          _subHeader(l.karmaCurrentLifeDynamic, AppColors.aurora),
          const SizedBox(height: 4),
          _interpretationText(currentDyn),
          const SizedBox(height: 8),
        ],

        // What they teach each other
        if (teach.isNotEmpty) ...[
          _subHeader(l.karmaWhatTheyTeach, AppColors.gold),
          const SizedBox(height: 4),
          _interpretationText(teach),
          const SizedBox(height: 8),
        ],

        // Pair interpretation
        if (interp.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              border: const Border(left: BorderSide(color: AppColors.gold, width: 3)),
            ),
            child: Text(
              interp,
              style: const TextStyle(
                color: AppColors.ivory,
                fontSize: 10,
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ]),
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // 4. GROUP KARMIC PATTERN
  // ════════════════════════════════════════════════════════════════════

  Widget _buildGroupPattern(AppLocalizations l, Map<String, dynamic> gp) {
    final theme = gp['group_karmic_theme']?.toString() ?? '';
    final setting = gp['shared_past_life_setting']?.toString() ?? '';
    final ketuPattern = _asMap(gp['collective_ketu_pattern']);
    final rahuPattern = _asMap(gp['collective_rahu_pattern']);
    final cohesion = _num(gp, 'karmic_cohesion_score');
    final cohesionInterp = gp['cohesion_interpretation']?.toString() ?? '';
    final soulContract = gp['group_soul_contract']?.toString() ?? '';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          _accent.withOpacity(0.1),
          const Color(0xFF4A3B8C).withOpacity(0.08),
        ]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _accent.withOpacity(0.25)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Theme
        if (theme.isNotEmpty) ...[
          _subHeader(l.karmaGroupThemeHeader, _accent),
          const SizedBox(height: 4),
          Text(
            theme,
            style: const TextStyle(
              color: AppColors.ivory,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontFamily: 'serif',
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
        ],

        // Shared setting
        if (setting.isNotEmpty) ...[
          _subHeader(l.karmaSharedSettingHeader, AppColors.saffron),
          const SizedBox(height: 4),
          _interpretationText(setting),
          const SizedBox(height: 10),
        ],

        // Collective Ketu pattern
        if (ketuPattern.isNotEmpty) ...[
          _subHeader(l.karmaCollectiveKetuHeader, AppColors.lavender),
          const SizedBox(height: 4),
          if (_asList(ketuPattern['dominant_houses']).isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  Text(l.housesPrefixLabel, style: const TextStyle(color: AppColors.smoke, fontSize: 9)),
                  ..._asList(ketuPattern['dominant_houses'])
                      .map((h) => _badge('H$h', AppColors.lavender)),
                ],
              ),
            ),
          if (_asList(ketuPattern['dominant_signs']).isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  Text(l.signsPrefixLabel, style: const TextStyle(color: AppColors.smoke, fontSize: 9)),
                  ..._asList(ketuPattern['dominant_signs'])
                      .map((s) => _badge(s.toString(), AppColors.lavender)),
                ],
              ),
            ),
          if (ketuPattern['interpretation'] != null) ...[
            const SizedBox(height: 4),
            _interpretationText(ketuPattern['interpretation'].toString()),
          ],
          const SizedBox(height: 10),
        ],

        // Collective Rahu pattern
        if (rahuPattern.isNotEmpty) ...[
          _subHeader(l.karmaCollectiveRahuHeader, AppColors.cosmicPink),
          const SizedBox(height: 4),
          if (_asList(rahuPattern['dominant_houses']).isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  Text(l.housesPrefixLabel, style: const TextStyle(color: AppColors.smoke, fontSize: 9)),
                  ..._asList(rahuPattern['dominant_houses'])
                      .map((h) => _badge('H$h', AppColors.cosmicPink)),
                ],
              ),
            ),
          if (rahuPattern['interpretation'] != null) ...[
            const SizedBox(height: 4),
            _interpretationText(rahuPattern['interpretation'].toString()),
          ],
          const SizedBox(height: 10),
        ],

        // Cohesion score bar
        _progressBar(l.karmicCohesionLabel, cohesion),
        if (cohesionInterp.isNotEmpty) ...[
          const SizedBox(height: 4),
          _interpretationText(cohesionInterp),
        ],

        // Soul contract
        if (soulContract.isNotEmpty) ...[
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              border: const Border(left: BorderSide(color: AppColors.gold, width: 3)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                l.karmaGroupSoulContractHeader,
                style: const TextStyle(
                  color: AppColors.gold,
                  fontSize: 8,
                  letterSpacing: 1.5,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                soulContract,
                style: const TextStyle(
                  color: AppColors.ivory,
                  fontSize: 11,
                  height: 1.5,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ]),
          ),
        ],
      ]),
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // 5. PAST LIFE GOALS
  // ════════════════════════════════════════════════════════════════════

  Widget _buildPastLifeGoals(AppLocalizations l, Map<String, dynamic> goals) {
    final individual = _asList(goals['individual_past_goals']);
    final shared = goals['shared_past_life_goal']?.toString() ?? '';
    final assessment = goals['goal_completion_assessment']?.toString() ?? '';

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Per-person goal cards
      ...individual.map((g) {
        final gm = _asMap(g);
        final name = gm['chart_name']?.toString() ?? '—';
        final goal = gm['past_life_goal']?.toString() ?? '';
        final status = gm['completion_status']?.toString() ?? '';
        final carry = gm['carryover_to_now']?.toString() ?? '';
        final statusC = _completionColor(status);

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _cardBg.withOpacity(0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _accent.withOpacity(0.2)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    color: _accent,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'serif',
                  ),
                ),
              ),
              if (status.isNotEmpty) _badge(status, statusC),
            ]),
            if (goal.isNotEmpty) ...[
              const SizedBox(height: 6),
              _kvRow(l.goalLabel, goal, AppColors.ivory),
            ],
            if (carry.isNotEmpty) ...[
              const SizedBox(height: 4),
              _interpretationText(carry),
            ],
          ]),
        );
      }),

      // Shared past life goal
      if (shared.isNotEmpty)
        Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.gold.withOpacity(0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.gold.withOpacity(0.2)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              l.karmaSharedGoalHeader,
              style: const TextStyle(
                color: AppColors.gold,
                fontSize: 8,
                letterSpacing: 1.5,
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              shared,
              style: const TextStyle(
                color: AppColors.ivory,
                fontSize: 12,
                height: 1.4,
                fontWeight: FontWeight.w600,
                fontFamily: 'serif',
              ),
            ),
          ]),
        ),

      // Assessment
      if (assessment.isNotEmpty)
        Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            assessment,
            style: const TextStyle(
              color: AppColors.smoke,
              fontSize: 10,
              height: 1.4,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
    ]);
  }

  // ════════════════════════════════════════════════════════════════════
  // 6. CURRENT LIFE LEARNING
  // ════════════════════════════════════════════════════════════════════

  Widget _buildCurrentLifeLearning(AppLocalizations l, Map<String, dynamic> learning) {
    final lessons = _asList(learning['individual_lessons']);
    final sharedLesson = learning['shared_group_lesson']?.toString() ?? '';
    final teachMap = _asList(learning['mutual_teaching_map']);
    final growthDir = learning['group_growth_direction']?.toString() ?? '';

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Per-person lessons
      ...lessons.map((lessonItem) {
        final lm = _asMap(lessonItem);
        final name = lm['chart_name']?.toString() ?? '—';
        final lesson = lm['new_lesson']?.toString() ?? '';
        final house = lm['lesson_house'];
        final howToGrow = lm['how_to_grow']?.toString() ?? '';
        final moolaDasha = lm['moola_dasha_activation']?.toString() ?? '';

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _cardBg.withOpacity(0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.aurora.withOpacity(0.2)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.aurora,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'serif',
                  ),
                ),
              ),
              if (house != null)
                _badge('H$house', AppColors.aurora),
            ]),
            if (lesson.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                lesson,
                style: const TextStyle(
                  color: AppColors.ivory,
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
            ],
            if (howToGrow.isNotEmpty) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.success.withOpacity(0.15)),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    l.howToGrowHeader,
                    style: const TextStyle(
                      color: AppColors.success,
                      fontSize: 7,
                      letterSpacing: 1.5,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    howToGrow,
                    style: const TextStyle(
                      color: AppColors.ivory,
                      fontSize: 10,
                      height: 1.4,
                    ),
                  ),
                ]),
              ),
            ],
            if (moolaDasha.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                l.moolaDashaPrefix(moolaDasha),
                style: const TextStyle(
                  color: AppColors.smoke,
                  fontSize: 9,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ]),
        );
      }),

      // Shared group lesson
      if (sharedLesson.isNotEmpty)
        Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.gold.withOpacity(0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.gold.withOpacity(0.2)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              l.karmaSharedLessonHeader,
              style: const TextStyle(
                color: AppColors.gold,
                fontSize: 8,
                letterSpacing: 1.5,
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              sharedLesson,
              style: const TextStyle(
                color: AppColors.ivory,
                fontSize: 12,
                height: 1.4,
                fontWeight: FontWeight.w600,
                fontFamily: 'serif',
              ),
            ),
          ]),
        ),

      // Mutual teaching map
      if (teachMap.isNotEmpty) ...[
        Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _cardBg.withOpacity(0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _accent.withOpacity(0.2)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _subHeader(l.karmaMutualTeachingHeader, _accent),
            const SizedBox(height: 8),
            ...teachMap.map((t) {
              final tm = _asMap(t);
              final teacher = tm['teacher']?.toString() ?? '';
              final student = tm['student']?.toString() ?? '';
              final subject = tm['subject']?.toString() ?? '';
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _accent.withOpacity(0.1)),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.aurora.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                      child: Text(teacher.isNotEmpty ? teacher : '—', style: const TextStyle(color: AppColors.aurora, fontSize: 10, fontWeight: FontWeight.w700)),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(Icons.arrow_forward, size: 12, color: AppColors.smoke),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.cosmicPink.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                      child: Text(student.isNotEmpty ? student : '—', style: const TextStyle(color: AppColors.cosmicPink, fontSize: 10, fontWeight: FontWeight.w700)),
                    ),
                  ]),
                  if (subject.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(subject, style: const TextStyle(color: AppColors.ivory, fontSize: 10, height: 1.4)),
                  ],
                ]),
              );
            }),
          ]),
        ),
      ] else ...[
        Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _cardBg.withOpacity(0.5),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _subHeader(l.karmaMutualTeachingHeader, _accent),
            const SizedBox(height: 6),
            Text(l.karmaTeachingDynamicsPlaceholder, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontStyle: FontStyle.italic)),
          ]),
        ),
      ],

      // Growth direction
      if (growthDir.isNotEmpty)
        Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.success.withOpacity(0.15)),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('-> ', style: TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w700)),
            Expanded(
              child: Text(
                growthDir,
                style: const TextStyle(
                  color: AppColors.ivory,
                  fontSize: 10,
                  height: 1.4,
                ),
              ),
            ),
          ]),
        ),
    ]);
  }

  // ════════════════════════════════════════════════════════════════════
  // 7. KARMIC DEBTS & RESOLUTIONS
  // ════════════════════════════════════════════════════════════════════

  Widget _buildKarmicDebts(AppLocalizations l, Map<String, dynamic> debts) {
    final detected = _asList(debts['debts_detected']);
    final mutual = _asList(debts['mutual_debts']);
    final resSummary = debts['resolution_summary']?.toString() ?? '';

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Individual debt cards
      ...detected.map((d) {
        final dm = _asMap(d);
        final debtor = dm['debtor']?.toString() ?? '—';
        final creditor = dm['creditor']?.toString() ?? '—';
        final debtType = dm['debt_type']?.toString() ?? '';
        final basis = dm['debt_basis']?.toString() ?? '';
        final severity = dm['severity']?.toString() ?? '';
        final resolution = dm['resolution_path']?.toString() ?? '';
        final timing = dm['moola_dasha_timing']?.toString() ?? '';
        final sevC = _severityColor(severity);

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              sevC.withOpacity(0.08),
              _cardBg.withOpacity(0.5),
            ]),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: sevC.withOpacity(0.25)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Debtor -> Creditor
            Row(children: [
              Expanded(
                child: Text.rich(TextSpan(children: [
                  TextSpan(
                    text: debtor,
                    style: const TextStyle(color: AppColors.error, fontSize: 12, fontWeight: FontWeight.w700, fontFamily: 'serif'),
                  ),
                  const TextSpan(
                    text: ' -> ',
                    style: TextStyle(color: AppColors.smoke, fontSize: 10),
                  ),
                  TextSpan(
                    text: creditor,
                    style: const TextStyle(color: AppColors.aurora, fontSize: 12, fontWeight: FontWeight.w700, fontFamily: 'serif'),
                  ),
                ])),
              ),
              if (severity.isNotEmpty)
                _badge(severity, sevC),
            ]),
            if (debtType.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: _kvRow(l.typeFieldLabel, debtType, AppColors.gold),
              ),
            if (basis.isNotEmpty)
              _kvRow(l.basisFieldLabel, basis, AppColors.ivory),
            if (resolution.isNotEmpty) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.success.withOpacity(0.15)),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    l.resolutionPathHeader,
                    style: const TextStyle(
                      color: AppColors.success,
                      fontSize: 7,
                      letterSpacing: 1.5,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    resolution,
                    style: const TextStyle(color: AppColors.ivory, fontSize: 10, height: 1.4),
                  ),
                ]),
              ),
            ],
            if (timing.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                l.dashaTimingPrefix(timing),
                style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontStyle: FontStyle.italic),
              ),
            ],
          ]),
        );
      }),

      // Mutual debts
      if (mutual.isNotEmpty)
        Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.warning.withOpacity(0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.warning.withOpacity(0.2)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              l.mutualDebtsHeader,
              style: const TextStyle(
                color: AppColors.warning,
                fontSize: 8,
                letterSpacing: 1.5,
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            ...mutual.map((m) => Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                '* $m',
                style: const TextStyle(color: AppColors.ivory, fontSize: 10, height: 1.4),
              ),
            )),
          ]),
        ),

      // Resolution summary
      if (resSummary.isNotEmpty)
        Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.gold.withOpacity(0.08),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            border: const Border(left: BorderSide(color: AppColors.gold, width: 3)),
          ),
          child: Text(
            resSummary,
            style: const TextStyle(
              color: AppColors.ivory,
              fontSize: 10,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
    ]);
  }

  // ════════════════════════════════════════════════════════════════════
  // 8. MOOLA DASHA KARMIC TIMING
  // ════════════════════════════════════════════════════════════════════

  Widget _buildMoolaDashaTiming(AppLocalizations l, Map<String, dynamic> timing) {
    final perChart = _asList(timing['per_chart_timing']);
    final groupWindow = timing['group_karmic_window']?.toString() ?? '';
    final synthesis = timing['timing_synthesis']?.toString() ?? '';

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Per-chart timing blocks
      ...perChart.map((ct) {
        final ctm = _asMap(ct);
        final name = ctm['chart_name']?.toString() ?? '—';
        final moola = _asMap(ctm['current_moola']);
        final activation = ctm['karmic_activation']?.toString() ?? '';
        final reasoning = ctm['reasoning']?.toString() ?? '';
        final phase = ctm['karmic_phase']?.toString() ?? '';

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _cardBg.withOpacity(0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.saffron.withOpacity(0.2)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.saffron,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'serif',
                  ),
                ),
              ),
              if (phase.isNotEmpty)
                _badge(phase, AppColors.saffron),
            ]),
            const SizedBox(height: 8),

            // Moola dasha periods
            if (moola.isNotEmpty) ...[
              if (moola['md'] != null)
                _kvRow(l.mdLabel, moola['md'].toString(), AppColors.gold),
              if (moola['ad'] != null)
                _kvRow(l.adLabel, moola['ad'].toString(), AppColors.gold),
              if (moola['pd'] != null)
                _kvRow(l.pdLabel, moola['pd'].toString(), AppColors.gold),
              if (moola['dates'] != null)
                _kvRow(l.datesLabel, moola['dates'].toString(), AppColors.smoke),
            ],

            // Karmic activation
            if (activation.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                activation,
                style: const TextStyle(
                  color: AppColors.ivory,
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
            ],

            // Reasoning
            if (reasoning.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                reasoning,
                style: const TextStyle(
                  color: AppColors.smoke,
                  fontSize: 9,
                  height: 1.3,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ]),
        );
      }),

      // Group karmic window
      if (groupWindow.isNotEmpty)
        Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.gold.withOpacity(0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.gold.withOpacity(0.2)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              l.groupKarmicWindowHeader,
              style: const TextStyle(
                color: AppColors.gold,
                fontSize: 8,
                letterSpacing: 1.5,
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              groupWindow,
              style: const TextStyle(
                color: AppColors.ivory,
                fontSize: 12,
                height: 1.4,
                fontWeight: FontWeight.w600,
                fontFamily: 'serif',
              ),
            ),
          ]),
        ),

      // Timing synthesis
      if (synthesis.isNotEmpty)
        Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.gold.withOpacity(0.08),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            border: const Border(left: BorderSide(color: AppColors.gold, width: 3)),
          ),
          child: Text(
            synthesis,
            style: const TextStyle(
              color: AppColors.ivory,
              fontSize: 10,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
    ]);
  }

  // ════════════════════════════════════════════════════════════════════
  // 9. DEEP AUDIT TABLE
  // ════════════════════════════════════════════════════════════════════

  Widget _buildAuditTable(AppLocalizations l, Map<String, dynamic> audit) {
    final params = _asList(audit['audited_parameters']);
    final totalRaw = audit['total_parameters_audited'];
    final total = totalRaw is num ? totalRaw.toInt() : (totalRaw is String ? int.tryParse(totalRaw) ?? params.length : params.length);
    final completeness = audit['audit_completeness']?.toString() ?? '';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      decoration: BoxDecoration(
        color: _cardBg.withOpacity(0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.ash.withOpacity(0.4)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header info — stacked for mobile responsiveness
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              l.parametersAuditedHeading(total),
              style: const TextStyle(
                color: AppColors.gold,
                fontSize: 10,
                letterSpacing: 1.5,
                fontFamily: 'monospace',
                fontWeight: FontWeight.w700,
              ),
            ),
            if (completeness.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                completeness,
                style: const TextStyle(
                  color: AppColors.aurora,
                  fontSize: 9,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ]),
        ),

        // Parameter cards (mobile-friendly)
        if (params.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              children: params.take(50).map((p) {
                final pm = _asMap(p);
                final sc = _num(pm, 'score');
                final scC = _scoreColor(sc);
                final param = pm['parameter']?.toString() ?? '—';
                final raw = pm['raw_value']?.toString() ?? '—';
                final weight = _num(pm, 'weight');
                final basis = pm['classical_basis']?.toString() ?? '';
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: scC.withOpacity(0.15)),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: Text(param, style: const TextStyle(color: AppColors.ivory, fontSize: 10, fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: scC.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                        child: Text(sc.toStringAsFixed(1), style: TextStyle(color: scC, fontSize: 10, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
                      ),
                    ]),
                    const SizedBox(height: 4),
                    Row(children: [
                      Text(l.valuePrefixLabel, style: const TextStyle(color: AppColors.smoke, fontSize: 8, fontFamily: 'monospace')),
                      Expanded(child: Text(raw, style: const TextStyle(color: AppColors.gold, fontSize: 9), maxLines: 1, overflow: TextOverflow.ellipsis)),
                      Text(l.weightPrefix(weight.toStringAsFixed(2)), style: const TextStyle(color: AppColors.smoke, fontSize: 8, fontFamily: 'monospace')),
                    ]),
                    if (basis.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(basis, style: const TextStyle(color: AppColors.smoke, fontSize: 8, fontStyle: FontStyle.italic, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ]),
                );
              }).toList(),
            ),
          ),
      ]),
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // 10. SUMMARY
  // ════════════════════════════════════════════════════════════════════

  Widget _buildSummary(AppLocalizations l, Map<String, dynamic> summary) {
    final insights = _asList(summary['key_insights']);
    final humanSummary = summary['human_summary']?.toString() ?? '';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          _accent.withOpacity(0.1),
          const Color(0xFF4A3B8C).withOpacity(0.08),
        ]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _accent.withOpacity(0.25)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _subHeader(l.keyInsights, AppColors.gold),
        const SizedBox(height: 8),

        // Numbered insights
        ...insights.asMap().entries.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  '${e.key + 1}',
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                e.value.toString(),
                style: const TextStyle(
                  color: AppColors.ivory,
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
            ),
          ]),
        )),

        // Human summary
        if (humanSummary.isNotEmpty) ...[
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              border: const Border(left: BorderSide(color: AppColors.gold, width: 3)),
            ),
            child: Text(
              humanSummary,
              style: const TextStyle(
                color: AppColors.ivory,
                fontSize: 11,
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ]),
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // 12. AI COPY BAR
  // ════════════════════════════════════════════════════════════════════

  Widget _buildAiCopyBar(BuildContext ctx) {
    final l = AppLocalizations.of(ctx)!;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          _cardBg.withOpacity(0.8),
          _bg,
        ]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withOpacity(0.25)),
      ),
      child: Column(children: [
        _label(l.discussWithAI),
        const SizedBox(height: 12),
        Row(children: [
          _aiBtn(
            ctx,
            'G',
            'ChatGPT',
            const LinearGradient(colors: [Color(0xFF10A37F), Color(0xFF1A7F64)]),
            'Analyze this Vedic astrology Past Life Karma Linkage report and give detailed insights:\n\n',
          ),
          const SizedBox(width: 8),
          _aiBtn(
            ctx,
            'C',
            'Claude',
            const LinearGradient(colors: [Color(0xFFD97757), Color(0xFFB85B3F)]),
            'Here is a Vedic astrology Past Life Karma Linkage report. Analyze it thoroughly and provide actionable insights:\n\n',
          ),
          const SizedBox(width: 8),
          _aiBtn(
            ctx,
            '\u{2726}',
            'Gemini',
            const LinearGradient(colors: [Color(0xFF4285F4), Color(0xFF9B72CB)]),
            'Review this Past Life Karma Linkage astrology analysis and explain key findings simply:\n\n',
          ),
        ]),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: _fmt(data)));
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(content: Text(l.reportCopied)),
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.copy, size: 14, color: AppColors.smoke),
                const SizedBox(width: 6),
                Text(l.copyFullReport, style: const TextStyle(color: AppColors.smoke, fontSize: 10)),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget _aiBtn(BuildContext ctx, String icon, String name, Gradient g, String prefix) {
    final l = AppLocalizations.of(ctx)!;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Clipboard.setData(ClipboardData(text: prefix + _fmt(data)));
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(content: Text(l.copiedForName(name))),
          );
          final urls = {
            'ChatGPT': 'https://chat.openai.com/',
            'Claude': 'https://claude.ai/new',
            'Gemini': 'https://gemini.google.com/app',
          };
          launchUrl(
            Uri.parse(urls[name]!),
            mode: LaunchMode.externalApplication,
          ).catchError((_) => false);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.gold.withOpacity(0.2)),
          ),
          child: Column(children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                gradient: g,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  icon,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              name,
              style: const TextStyle(
                color: AppColors.ivory,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              l.copy,
              style: const TextStyle(
                color: AppColors.smoke,
                fontSize: 7,
                fontFamily: 'monospace',
              ),
            ),
          ]),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // SHARED HELPER WIDGETS
  // ════════════════════════════════════════════════════════════════════

  Widget _header(String p1, String p2) => ReportHeader(p1, p2, '');

  Widget _label(String text) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(width: 16, height: 1, color: AppColors.gold.withOpacity(0.4)),
      const SizedBox(width: 6),
      Text(
        text,
        style: const TextStyle(
          color: AppColors.gold,
          fontSize: 9,
          letterSpacing: 2,
          fontFamily: 'monospace',
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(width: 6),
      Container(width: 16, height: 1, color: AppColors.gold.withOpacity(0.4)),
    ],
  );

  Widget _subHeader(String text, Color c) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: TextStyle(
        color: c,
        fontSize: 8,
        letterSpacing: 2,
        fontFamily: 'monospace',
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  Widget _kvRow(String k, String v, Color vc) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        width: 100,
        child: Text(
          k,
          style: const TextStyle(
            color: AppColors.smoke,
            fontSize: 9,
            fontFamily: 'monospace',
          ),
        ),
      ),
      Expanded(
        child: Text(
          v,
          style: TextStyle(
            color: vc,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ]),
  );

  Widget _progressBar(String label, double value) {
    final c = _scoreColor(value);
    return Column(children: [
      Row(children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: AppColors.ivory, fontSize: 10),
          ),
        ),
        Text(
          value.toStringAsFixed(1),
          style: TextStyle(
            color: c,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            fontFamily: 'monospace',
          ),
        ),
      ]),
      const SizedBox(height: 3),
      ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: LinearProgressIndicator(
          value: (value / 100).clamp(0, 1),
          minHeight: 4,
          backgroundColor: Colors.white.withOpacity(0.06),
          valueColor: AlwaysStoppedAnimation(c),
        ),
      ),
    ]);
  }

  Widget _interpretationText(String text) => Text(
    text,
    style: const TextStyle(
      color: AppColors.lavender,
      fontSize: 10,
      height: 1.4,
      fontStyle: FontStyle.italic,
    ),
  );

  Widget _scoreChip(String label, double value, {bool isPenalty = false}) {
    final c = isPenalty
        ? (value > 0 ? AppColors.error : AppColors.success)
        : _scoreColor(value);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: c.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: c.withOpacity(0.3)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(
          isPenalty ? '-${value.toStringAsFixed(0)}' : value.toStringAsFixed(0),
          style: TextStyle(
            color: c,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            fontFamily: 'serif',
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: c.withOpacity(0.7),
            fontSize: 7,
            fontFamily: 'monospace',
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ]),
    );
  }

  Widget _badge(String text, Color c) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: c.withOpacity(0.15),
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: c.withOpacity(0.4)),
    ),
    child: Text(
      text.toUpperCase(),
      style: TextStyle(
        color: c,
        fontSize: 8,
        letterSpacing: 0.8,
        fontFamily: 'monospace',
        fontWeight: FontWeight.w700,
      ),
    ),
  );

  // ════════════════════════════════════════════════════════════════════
  // UTILITY METHODS
  // ════════════════════════════════════════════════════════════════════

  static Map<String, dynamic> _asMap(dynamic v) =>
      v is Map ? v.cast<String, dynamic>() : <String, dynamic>{};

  static List _asList(dynamic v) => v is List ? v : [];

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

  static Color _dignityColor(String dignity) {
    final d = dignity.toLowerCase();
    if (d.contains('exalt') || d.contains('moolatrikona')) return AppColors.success;
    if (d.contains('own') || d.contains('swakshetra')) return AppColors.gold;
    if (d.contains('friend')) return AppColors.aurora;
    if (d.contains('neech') || d.contains('debilitat') || d.contains('enemy')) return AppColors.error;
    return AppColors.smoke;
  }

  static Color _severityColor(String severity) {
    final s = severity.toLowerCase();
    if (s.contains('high') || s.contains('severe') || s.contains('heavy')) return AppColors.error;
    if (s.contains('moderate') || s.contains('medium') || s.contains('med')) return const Color(0xFFE5A93A);
    return AppColors.aurora;
  }

  static Color _completionColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('complete') || s.contains('fulfilled') || s.contains('done')) return AppColors.success;
    if (s.contains('partial') || s.contains('progress')) return AppColors.gold;
    if (s.contains('incomplete') || s.contains('pending') || s.contains('unfinished')) return AppColors.error;
    return AppColors.smoke;
  }

  static String _fmt(Map<String, dynamic> d, {int indent = 0}) {
    final buf = StringBuffer();
    final pad = '  ' * indent;
    for (final e in d.entries) {
      if (e.value is Map) {
        buf.writeln('$pad${_titleCase(e.key)}:');
        buf.write(_fmt((e.value as Map).cast<String, dynamic>(), indent: indent + 1));
      } else if (e.value is List) {
        buf.writeln('$pad${_titleCase(e.key)}:');
        for (var i = 0; i < (e.value as List).length; i++) {
          final item = (e.value as List)[i];
          if (item is Map) {
            buf.writeln('$pad  ${i + 1}.');
            buf.write(_fmt(item.cast<String, dynamic>(), indent: indent + 2));
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
