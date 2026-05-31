import 'package:flutter/material.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../services/api_service.dart';
import '_section_loader.dart';

class CharacterWidget extends StatelessWidget {
  final String chartId;
  final dynamic initial;
  const CharacterWidget({super.key, required this.chartId, this.initial});

  static const _groupMeta = <String, List<Object>>{
    'Core Personality':        ['Core Personality', Icons.person, Colors.indigo],
    'Trust & Honesty':         ['Trust & Honesty', Icons.verified_user, Colors.teal],
    'Loyalty & Commitment':    ['Loyalty & Commitment', Icons.handshake, Colors.blue],
    'Strategic & Privacy':     ['Strategic & Privacy', Icons.psychology, Colors.deepPurple],
    'Financial':               ['Financial', Icons.account_balance, Colors.green],
    'Anger & Conflict':        ['Anger & Conflict', Icons.local_fire_department, Colors.red],
    'Moral & Dharmic':         ['Moral & Dharmic', Icons.balance, Colors.amber],
    'Intellect & Communication': ['Intellect & Communication', Icons.school, Colors.cyan],
    'Emotional Profile':       ['Emotional Profile', Icons.favorite, Colors.pink],
    'Mental Health Indicators': ['Mental Health', Icons.spa, Colors.purple],
    'Romantic':                ['Romantic', Icons.volunteer_activism, Colors.redAccent],
    'Marriage & Family':       ['Marriage & Family', Icons.family_restroom, Colors.orange],
    'Overall Life':            ['Overall Life', Icons.auto_awesome, Colors.blueGrey],
  };

  static const _groupScoreKeys = <String, List<String>>{
    'Core Personality': ['personality_type','emotional_vs_logical','ego_level','stability_score'],
    'Trust & Honesty': ['trust_pattern','honesty_score','truthfulness_index','transparency_level'],
    'Loyalty & Commitment': ['loyalty','commitment_level','relationship_stability','partner_support'],
    'Strategic & Privacy': ['strategic_tendency','privacy_orientation','double_nature_tendency','selective_openness'],
    'Financial': ['greed_tendency','financial_mindset','risk_taking','financial_ethics'],
    'Anger & Conflict': ['anger_level','aggression_tendency','conflict_handling','patience_level'],
    'Moral & Dharmic': ['moral_integrity','dharma_inclination','ethics_score','decision_making_style'],
    'Intellect & Communication': ['intelligence','communication_clarity','social_behavior','leadership'],
    'Emotional Profile': ['emotional_attachment','possessiveness','attachment_intensity','dominance','adjustment_ability'],
    'Mental Health Indicators': ['mental_stability','anxiety_indicator','depression_risk','stress_handling'],
    'Romantic': ['attraction_pattern','romantic_nature','physical_vitality_compat'],
    'Marriage & Family': ['marriage_longevity','divorce_risk','family_adjustment','inlaw_compatibility'],
    'Overall Life': ['life_satisfaction','overall_character'],
  };

  @override
  Widget build(BuildContext context) {
    return SectionLoader(
      initial: initial is Map ? (initial as Map).cast<String, dynamic>() : null,
      loader: () => ApiService().getCharacterAnalysis(chartId),
      builder: (ctx, data) {
        final overall = (data['overall_character'] as num?)?.toDouble() ?? 0;
        final lagna = data['lagna']?.toString() ?? '';
        final moon = data['moon_sign']?.toString() ?? '';
        final guna = data['dominant_guna']?.toString() ?? '';
        final gunaCounts = (data['guna_counts'] as Map?)?.cast<String, dynamic>() ?? {};
        final dasha = data['current_dasha']?.toString() ?? '';
        final yogas = (data['yogas_active'] as List?) ?? [];
        final doshas = (data['doshas_active'] as List?) ?? [];
        final scores = (data['scores'] as Map?)?.cast<String, dynamic>() ?? {};
        final groups = (data['group_summaries'] as Map?)?.cast<String, dynamic>() ?? {};

        return ListView(padding: const EdgeInsets.all(16), children: [
          _overviewCard(overall, lagna, moon, guna, gunaCounts, dasha),
          const SizedBox(height: 14),
          if (yogas.isNotEmpty || doshas.isNotEmpty) ...[
            _yogaDoshaCard(yogas, doshas),
            const SizedBox(height: 14),
          ],
          ..._groupMeta.entries.map((entry) {
            final groupKey = entry.key;
            final meta = entry.value;
            final groupData = (groups[groupKey] as Map?)?.cast<String, dynamic>() ?? {};
            final scoreKeys = _groupScoreKeys[groupKey] ?? [];
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _groupCard(
                meta[0] as String,
                meta[1] as IconData,
                meta[2] as Color,
                groupData,
                scoreKeys,
                scores,
              ),
            );
          }),
          const SizedBox(height: 24),
        ]);
      },
    );
  }

  Widget _overviewCard(double overall, String lagna, String moon,
      String guna, Map<String, dynamic> gunaCounts, String dasha) {
    final overallColor = overall >= 65 ? Colors.green : overall >= 45 ? Colors.orange : Colors.red;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.indigo.withOpacity(0.15), Colors.indigo.withOpacity(0.03)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.indigo.withOpacity(0.3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.person_pin, color: Colors.indigo, size: 22),
          const SizedBox(width: 8),
          Expanded(child: Text(AppLocalizations.of(context)?.characterOverview ?? 'Character Overview',
              style: TextStyle(color: Colors.indigo, fontSize: 15, fontWeight: FontWeight.w700))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: overallColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: overallColor.withOpacity(0.4)),
            ),
            child: Text('${overall.toStringAsFixed(0)}/100',
                style: TextStyle(color: overallColor, fontSize: 16, fontWeight: FontWeight.w700)),
          ),
        ]),
        const SizedBox(height: 10),
        Wrap(spacing: 8, runSpacing: 6, children: [
          _chip('Lagna', lagna, Colors.blue),
          _chip('Moon', moon, Colors.teal),
          _chip('Guna', guna, Colors.purple),
          if (dasha.isNotEmpty) _chip('Dasha', dasha, Colors.orange),
        ]),
        if (gunaCounts.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(children: [
            _gunaBar('Satwik', gunaCounts['satwik'] ?? 0, Colors.green),
            const SizedBox(width: 8),
            _gunaBar('Rajasik', gunaCounts['rajasik'] ?? 0, Colors.orange),
            const SizedBox(width: 8),
            _gunaBar('Tamasik', gunaCounts['tamasik'] ?? 0, Colors.red),
          ]),
        ],
      ]),
    );
  }

  Widget _gunaBar(String label, int count, Color color) {
    return Expanded(child: Column(children: [
      Text('$count', style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w700)),
      Text(label, style: TextStyle(color: color.withOpacity(0.7), fontSize: 9)),
    ]));
  }

  Widget _yogaDoshaCard(List yogas, List doshas) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (yogas.isNotEmpty) ...[
          const Text('Active Yogas', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Wrap(spacing: 6, runSpacing: 4, children: yogas.take(6).map<Widget>((y) =>
              _chip('', y.toString(), Colors.green)).toList()),
        ],
        if (yogas.isNotEmpty && doshas.isNotEmpty) const SizedBox(height: 10),
        if (doshas.isNotEmpty) ...[
          const Text('Active Doshas', style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Wrap(spacing: 6, runSpacing: 4, children: doshas.take(6).map<Widget>((d) =>
              _chip('', d.toString(), Colors.redAccent)).toList()),
        ],
      ]),
    );
  }

  Widget _groupCard(String title, IconData icon, Color color,
      Map<String, dynamic> groupData, List<String> scoreKeys, Map<String, dynamic> allScores) {
    final avg = (groupData['avg_score'] as num?)?.toDouble() ?? 0;
    final band = groupData['band']?.toString() ?? '';
    return _ExpandableGroupCard(
      title: title,
      icon: icon,
      color: color,
      avgScore: avg,
      band: band,
      scoreKeys: scoreKeys,
      allScores: allScores,
    );
  }

  Widget _chip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(label.isEmpty ? value : '$label: $value',
          style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
    );
  }
}

class _ExpandableGroupCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final double avgScore;
  final String band;
  final List<String> scoreKeys;
  final Map<String, dynamic> allScores;

  const _ExpandableGroupCard({
    required this.title, required this.icon, required this.color,
    required this.avgScore, required this.band,
    required this.scoreKeys, required this.allScores,
  });

  @override
  State<_ExpandableGroupCard> createState() => _ExpandableGroupCardState();
}

class _ExpandableGroupCardState extends State<_ExpandableGroupCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final barColor = widget.avgScore >= 65 ? Colors.green
        : widget.avgScore >= 45 ? widget.color
        : Colors.redAccent;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [widget.color.withOpacity(0.1), widget.color.withOpacity(0.03)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: widget.color.withOpacity(0.25)),
      ),
      child: Column(children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(children: [
              Row(children: [
                Icon(widget.icon, color: widget.color, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(widget.title,
                    style: TextStyle(color: widget.color, fontSize: 13, fontWeight: FontWeight.w700))),
                Text('${widget.avgScore.toStringAsFixed(0)}',
                    style: TextStyle(color: barColor, fontSize: 20, fontWeight: FontWeight.w700)),
                Text('/100', style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                const SizedBox(width: 6),
                Icon(_expanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.textSecondary, size: 20),
              ]),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: widget.avgScore / 100,
                  minHeight: 5,
                  backgroundColor: Colors.white12,
                  valueColor: AlwaysStoppedAnimation(barColor),
                ),
              ),
              if (widget.band.isNotEmpty) Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(widget.band, style: TextStyle(color: barColor, fontSize: 10)),
                ),
              ),
            ]),
          ),
        ),
        if (_expanded) ...[
          const Divider(color: Colors.white12, height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
            child: Column(children: widget.scoreKeys.map((key) {
              final sc = (widget.allScores[key] as Map?)?.cast<String, dynamic>() ?? {};
              return _scoreTile(key, sc, widget.color);
            }).toList()),
          ),
        ],
      ]),
    );
  }

  Widget _scoreTile(String key, Map<String, dynamic> sc, Color baseColor) {
    final score = (sc['score'] as num?)?.toDouble() ?? 0;
    final band = sc['band']?.toString() ?? '';
    final factors = (sc['contributing_factors'] as List?) ?? [];
    final explanation = sc['explanation_summary']?.toString() ?? '';
    final risks = (sc['risk_indicators'] as List?) ?? [];
    final tileColor = score >= 65 ? Colors.green : score >= 45 ? baseColor : Colors.redAccent;
    final label = key.replaceAll('_', ' ').split(' ').map((w) =>
        w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: tileColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(label, style: TextStyle(color: tileColor, fontSize: 12, fontWeight: FontWeight.w600))),
          Text('${score.toStringAsFixed(0)}', style: TextStyle(color: tileColor, fontSize: 16, fontWeight: FontWeight.w700)),
          if (band.isNotEmpty) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(color: tileColor.withOpacity(0.15), borderRadius: BorderRadius.circular(3)),
              child: Text(band, style: TextStyle(color: tileColor, fontSize: 9)),
            ),
          ],
        ]),
        if (explanation.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(explanation, style: const TextStyle(color: AppColors.textPrimary, fontSize: 10, height: 1.3)),
        ],
        if (factors.isNotEmpty) ...[
          const SizedBox(height: 4),
          ...factors.take(2).map<Widget>((f) => Text('• $f',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 9))),
        ],
        if (risks.isNotEmpty) ...[
          const SizedBox(height: 4),
          ...risks.take(1).map<Widget>((r) => Text('⚠ $r',
              style: const TextStyle(color: Colors.redAccent, fontSize: 9))),
        ],
      ]),
    );
  }
}
