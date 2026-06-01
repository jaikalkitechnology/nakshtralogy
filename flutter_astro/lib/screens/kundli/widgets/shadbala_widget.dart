import 'package:flutter/material.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../services/api_service.dart';
import '_section_loader.dart';

class ShadbalaWidget extends StatelessWidget {
  final String chartId;
  final dynamic initial;
  const ShadbalaWidget({super.key, required this.chartId, this.initial});

  @override
  Widget build(BuildContext context) {
    return SectionLoader(
      initial: initial is Map ? (initial as Map).cast<String, dynamic>() : null,
      loader: () => ApiService().getKundliShadbala(chartId),
      builder: (ctx, data) {
        final planets = (data['planets'] as Map? ?? {}).cast<String, dynamic>();
        final order = ['Sun','Moon','Mars','Mercury','Jupiter','Venus','Saturn'];
        // Sort by score
        final entries = order.where((p) => planets.containsKey(p)).map((p) => MapEntry(p, (planets[p] as Map).cast<String, dynamic>())).toList();
        entries.sort((a, b) => ((b.value['score_100'] as num?) ?? 0).compareTo((a.value['score_100'] as num?) ?? 0));

        return ListView(padding: const EdgeInsets.all(16), children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: Row(children: [
              const Icon(Icons.bar_chart, color: AppColors.primary, size: 22),
              const SizedBox(width: 10),
              Expanded(child: Text(AppLocalizations.of(context)?.shadbala ?? 'Shadbala', style: TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w700))),
            ]),
          ),
          const SizedBox(height: 12),
          ...entries.map((e) {
            final p = e.key;
            final v = e.value;
            final score = (v['score_100'] as num?)?.toDouble() ?? 0;
            final rupas = (v['total_rupas'] as num?)?.toDouble() ?? 0;
            final components = (v['components'] as Map? ?? {}).cast<String, dynamic>();
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(width: 36, height: 36, decoration: BoxDecoration(color: _pColor(p).withOpacity(0.2), shape: BoxShape.circle, border: Border.all(color: _pColor(p).withOpacity(0.5))),
                      child: Center(child: Text(p[0], style: TextStyle(color: _pColor(p), fontWeight: FontWeight.w700)))),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(p, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 14)),
                    Text('${rupas.toStringAsFixed(2)} rupas', style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                  ])),
                  Text('${score.toStringAsFixed(0)}', style: TextStyle(color: _scoreColor(score), fontSize: 20, fontWeight: FontWeight.w700)),
                  Text('/100', style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                ]),
                const SizedBox(height: 6),
                ClipRRect(borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(value: score / 100, minHeight: 4, backgroundColor: AppColors.surface, valueColor: AlwaysStoppedAnimation(_scoreColor(score)))),
                if (components.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(spacing: 6, runSpacing: 4, children: components.entries.map<Widget>((c) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(4)),
                    child: Text('${c.key}: ${(c.value as num).toStringAsFixed(1)}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                  )).toList()),
                ],
              ]),
            );
          }),
        ]);
      },
    );
  }

  Color _scoreColor(double s) {
    if (s >= 70) return AppColors.success;
    if (s >= 50) return Colors.amber;
    if (s >= 30) return Colors.orange;
    return AppColors.error;
  }

  Color _pColor(String p) {
    const m = {'Sun': Colors.orange, 'Moon': Colors.blueGrey, 'Mars': Colors.red,
      'Mercury': Colors.green, 'Jupiter': Colors.amber, 'Venus': Colors.pink, 'Saturn': Colors.indigo};
    return m[p] ?? AppColors.primary;
  }
}
