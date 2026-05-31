import 'package:flutter/material.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../services/api_service.dart';
import '_section_loader.dart';

class CareerWidget extends StatelessWidget {
  final String chartId;
  final dynamic initial;
  const CareerWidget({super.key, required this.chartId, this.initial});

  @override
  Widget build(BuildContext context) {
    return SectionLoader(
      initial: initial is Map ? (initial as Map).cast<String, dynamic>() : null,
      loader: () => ApiService().getCareerAnalysis(chartId),
      builder: (ctx, data) {
        final api = (data['api'] as Map?)?.cast<String, dynamic>() ?? data;
        final summary = (api['summary'] as Map?)?.cast<String, dynamic>() ?? {};
        final scores = (api['scores'] as Map?)?.cast<String, dynamic>() ?? {};
        final careerType = (api['career_type'] as Map?)?.cast<String, dynamic>() ?? {};
        final careerDomain = (api['career_domain'] as Map?)?.cast<String, dynamic>() ?? {};
        final timeline = (api['timeline'] as Map?)?.cast<String, dynamic>() ?? {};
        final risks = (api['risks'] as List?) ?? [];
        final suggestions = (api['suggestions'] as List?) ?? [];
        final details = (api['details'] as Map?)?.cast<String, dynamic>() ?? {};

        return ListView(padding: const EdgeInsets.all(16), children: [
          _summaryCard(summary),
          const SizedBox(height: 14),
          _scoresCard(scores),
          const SizedBox(height: 14),
          _careerTypeCard(careerType, careerDomain),
          const SizedBox(height: 14),
          _timelineCard(timeline),
          if (risks.isNotEmpty) ...[
            const SizedBox(height: 14),
            _risksCard(risks),
          ],
          if (suggestions.isNotEmpty) ...[
            const SizedBox(height: 14),
            _suggestionsCard(suggestions),
          ],
          const SizedBox(height: 14),
          _detailsCard(details),
          const SizedBox(height: 24),
        ]);
      },
    );
  }

  Widget _summaryCard(Map<String, dynamic> s) {
    final confidence = (s['confidence'] as num?)?.toDouble() ?? 0;
    return _Card(
      title: 'Career Summary',
      icon: Icons.summarize,
      color: Colors.blue,
      children: [
        if (s['human_readable'] != null)
          Text(s['human_readable'].toString(),
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, height: 1.5)),
        if (s['one_liner_advice'] != null) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Row(children: [
              const Icon(Icons.lightbulb, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(s['one_liner_advice'].toString(),
                  style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600))),
            ]),
          ),
        ],
        const SizedBox(height: 10),
        Row(children: [
          if (s['current_phase'] != null)
            Expanded(child: _miniChip('Phase', s['current_phase'].toString(), Colors.teal)),
          const SizedBox(width: 8),
          _miniChip('Confidence', '${confidence.toStringAsFixed(0)}%',
              confidence >= 70 ? Colors.green : confidence >= 40 ? Colors.orange : Colors.red),
        ]),
      ],
    );
  }

  Widget _scoresCard(Map<String, dynamic> scores) {
    final strength = (scores['strength'] as num?)?.toDouble() ?? 0;
    final stability = (scores['stability'] as num?)?.toDouble() ?? 0;
    final growth = (scores['growth'] as num?)?.toDouble() ?? 0;
    final reasoning = (scores['reasoning'] as Map?)?.cast<String, dynamic>() ?? {};

    return _Card(
      title: 'Career Scores',
      icon: Icons.analytics,
      color: Colors.indigo,
      children: [
        _scoreBar('Strength', strength, Colors.blue, reasoning['strength_factors'] as List?),
        const SizedBox(height: 12),
        _scoreBar('Stability', stability, Colors.teal, reasoning['stability_factors'] as List?),
        const SizedBox(height: 12),
        _scoreBar('Growth', growth, Colors.green, reasoning['growth_factors'] as List?),
      ],
    );
  }

  Widget _scoreBar(String label, double value, Color color, List? factors) {
    String grade;
    if (value >= 75) {
      grade = 'Excellent';
    } else if (value >= 60) {
      grade = 'Good';
    } else if (value >= 45) {
      grade = 'Average';
    } else if (value >= 30) {
      grade = 'Below Avg';
    } else {
      grade = 'Weak';
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(child: Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600))),
        Text('${value.toStringAsFixed(0)}', style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w700)),
        Text('/95', style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
          child: Text(grade, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
        ),
      ]),
      const SizedBox(height: 4),
      ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: value / 95,
          minHeight: 6,
          backgroundColor: Colors.white12,
          valueColor: AlwaysStoppedAnimation(color),
        ),
      ),
      if (factors != null && factors.isNotEmpty) ...[
        const SizedBox(height: 4),
        ...factors.take(2).map<Widget>((f) => Text('• $f',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 10))),
      ],
    ]);
  }

  Widget _careerTypeCard(Map<String, dynamic> ct, Map<String, dynamic> cd) {
    final scoresPct = (ct['scores_pct'] as Map?)?.cast<String, dynamic>() ?? {};
    return _Card(
      title: 'Career Type & Domain',
      icon: Icons.category,
      color: Colors.deepPurple,
      children: [
        if (ct['verdict'] != null)
          Text(ct['verdict'].toString().toUpperCase(),
              style: const TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.w700)),
        if (ct['description'] != null) ...[
          const SizedBox(height: 4),
          Text(ct['description'].toString(),
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
        ],
        const SizedBox(height: 12),
        if (scoresPct.isNotEmpty)
          Wrap(spacing: 8, runSpacing: 6, children: scoresPct.entries.map((e) {
            final val = (e.value as num?)?.toDouble() ?? 0;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: val > 30 ? Colors.indigo.withOpacity(0.15) : Colors.white10,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: val > 30 ? Colors.indigo.withOpacity(0.4) : Colors.white12),
              ),
              child: Text('${e.key}: ${val.toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: val > 30 ? Colors.indigo[200] : AppColors.textSecondary,
                    fontSize: 11, fontWeight: val > 30 ? FontWeight.w600 : FontWeight.normal,
                  )),
            );
          }).toList()),
        if (cd['dominant_planet'] != null || cd['primary_domain'] != null) ...[
          const SizedBox(height: 12),
          const Divider(color: Colors.white12),
          const SizedBox(height: 8),
          if (cd['dominant_planet'] != null)
            Row(children: [
              const Icon(Icons.stars, color: AppColors.primary, size: 16),
              const SizedBox(width: 6),
              Text('Dominant Planet: ', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
              Text(cd['dominant_planet'].toString(),
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
            ]),
          if (cd['primary_domain'] != null) ...[
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.domain, color: AppColors.primary, size: 16),
              const SizedBox(width: 6),
              Expanded(child: Text(cd['primary_domain'].toString(),
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 12))),
            ]),
          ],
        ],
      ],
    );
  }

  Widget _timelineCard(Map<String, dynamic> tl) {
    final current = (tl['current'] as Map?)?.cast<String, dynamic>() ?? {};
    final good = (tl['good_periods'] as List?) ?? [];
    final bad = (tl['bad_periods'] as List?) ?? [];

    return _Card(
      title: 'Career Timeline',
      icon: Icons.timeline,
      color: Colors.teal,
      children: [
        if (current.isNotEmpty) ...[
          _periodTile(current, isCurrent: true),
          const Divider(color: Colors.white12, height: 20),
        ],
        if (good.isNotEmpty) ...[
          Text(AppLocalizations.of(context)?.favorablePeriods ?? 'Favorable Periods',
              style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          ...good.take(3).map<Widget>((p) => _periodTile((p as Map).cast<String, dynamic>(), isGood: true)),
        ],
        if (bad.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(AppLocalizations.of(context)?.challengingPeriods ?? 'Challenging Periods',
              style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          ...bad.take(3).map<Widget>((p) => _periodTile((p as Map).cast<String, dynamic>(), isGood: false)),
        ],
      ],
    );
  }

  Widget _periodTile(Map<String, dynamic> p, {bool isCurrent = false, bool isGood = true}) {
    final score = (p['career_score'] as num?)?.toDouble() ?? 0;
    final color = isCurrent ? Colors.amber : isGood ? Colors.green : Colors.redAccent;
    final reasons = (p['reasons'] as List?) ?? [];
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          if (isCurrent) const Icon(Icons.play_circle, size: 16, color: Colors.amber),
          if (isCurrent) const SizedBox(width: 4),
          Expanded(child: Text(p['window']?.toString() ?? '', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600))),
          Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w700)),
        ]),
        if (p['dasha'] != null)
          Text('Dasha: ${p['dasha']}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
        if (p['description'] != null)
          Text(p['description'].toString(), style: const TextStyle(color: AppColors.textPrimary, fontSize: 11)),
        if (reasons.isNotEmpty) ...[
          const SizedBox(height: 4),
          ...reasons.take(2).map<Widget>((r) => Text('• $r',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 10))),
        ],
      ]),
    );
  }

  Widget _risksCard(List risks) {
    return _Card(
      title: 'Career Risks',
      icon: Icons.warning_amber,
      color: Colors.orange,
      children: risks.take(5).map<Widget>((r) {
        final risk = (r as Map).cast<String, dynamic>();
        final severity = risk['severity']?.toString() ?? 'mild';
        final sevColor = severity == 'notable' ? Colors.red
            : severity == 'moderate' ? Colors.orange
            : Colors.yellow;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: sevColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.warning, size: 14, color: sevColor),
            const SizedBox(width: 8),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(risk['type']?.toString().replaceAll('_', ' ').toUpperCase() ?? '',
                  style: TextStyle(color: sevColor, fontSize: 10, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(risk['description']?.toString() ?? '',
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 11)),
            ])),
          ]),
        );
      }).toList(),
    );
  }

  Widget _suggestionsCard(List suggestions) {
    return _Card(
      title: 'Improvement Suggestions',
      icon: Icons.tips_and_updates,
      color: Colors.green,
      children: suggestions.take(5).map<Widget>((s) {
        final sug = (s as Map).cast<String, dynamic>();
        final priority = sug['priority']?.toString() ?? 'medium';
        final pColor = priority == 'high' ? Colors.orange : priority == 'low' ? Colors.grey : Colors.blue;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: pColor.withOpacity(0.06),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(color: pColor.withOpacity(0.2), borderRadius: BorderRadius.circular(3)),
                child: Text(priority.toUpperCase(), style: TextStyle(color: pColor, fontSize: 9, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 6),
              if (sug['category'] != null)
                Text(sug['category'].toString().toUpperCase(),
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 9)),
            ]),
            const SizedBox(height: 4),
            Text(sug['suggestion']?.toString() ?? '',
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 12)),
            if (sug['rationale'] != null) ...[
              const SizedBox(height: 2),
              Text(sug['rationale'].toString(),
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontStyle: FontStyle.italic)),
            ],
          ]),
        );
      }).toList(),
    );
  }

  Widget _detailsCard(Map<String, dynamic> det) {
    final houses = (det['houses'] as Map?)?.cast<String, dynamic>() ?? {};
    final keyPlanets = (det['key_planets'] as Map?)?.cast<String, dynamic>() ?? {};
    if (houses.isEmpty && keyPlanets.isEmpty) return const SizedBox.shrink();
    return _Card(
      title: 'Chart Details',
      icon: Icons.info_outline,
      color: Colors.blueGrey,
      children: [
        if (houses.isNotEmpty) ...[
          Text(AppLocalizations.of(context)?.keyHouses ?? 'Key Houses',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          ...houses.entries.take(6).map<Widget>((e) {
            final h = (e.value as Map).cast<String, dynamic>();
            final occ = (h['occupants'] as List?)?.join(', ') ?? 'Empty';
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                'H${e.key}: ${h['sign_name'] ?? h['sign'] ?? ''} • Lord: ${h['lord'] ?? ''} (${h['lord_dignity'] ?? ''}) • $occ',
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 11),
              ),
            );
          }),
        ],
        if (keyPlanets.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(AppLocalizations.of(context)?.keyPlanets ?? 'Key Planets',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          ...keyPlanets.entries.take(6).map<Widget>((e) {
            final p = (e.value as Map).cast<String, dynamic>();
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '${e.key}: H${p['house'] ?? '?'} • ${p['dignity'] ?? ''} • Str: ${((p['strength'] as num?)?.toDouble() ?? 0).toStringAsFixed(0)}% • ${p['role'] ?? ''}',
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 11),
              ),
            );
          }),
        ],
      ],
    );
  }

  Widget _miniChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text('$label: $value',
          style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
    );
  }
}

class _Card extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<Widget> children;

  const _Card({required this.title, required this.icon, required this.color, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withOpacity(0.1), color.withOpacity(0.03)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(title, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 10),
        ...children,
      ]),
    );
  }
}
