import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../services/api_service.dart';
import '_section_loader.dart';

class LifeAreasWidget extends StatelessWidget {
  final String chartId;
  final dynamic initial;
  const LifeAreasWidget({super.key, required this.chartId, this.initial});

  static const _areas = [
    ['Career', Icons.work, Colors.blue],
    ['Wealth', Icons.attach_money, Colors.green],
    ['Marriage', Icons.favorite, Colors.pink],
    ['Health', Icons.favorite_border, Colors.red],
    ['Spirituality', Icons.self_improvement, Colors.purple],
  ];

  @override
  Widget build(BuildContext context) {
    return SectionLoader(
      initial: initial is Map ? (initial as Map).cast<String, dynamic>() : null,
      loader: () => ApiService().getKundliLifeAreas(chartId),
      builder: (ctx, data) {
        return ListView(padding: const EdgeInsets.all(16), children: _areas.map((a) {
          final key = (a[0] as String).toLowerCase();
          final info = (data[key] as Map? ?? data[a[0] as String] as Map? ?? {}).cast<String, dynamic>();
          final score = (info['score'] as num?)?.toDouble() ?? 0;
          final factors = (info['factors'] as List?) ?? [];
          final color = a[2] as Color;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color.withOpacity(0.15), color.withOpacity(0.05)]),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(a[1] as IconData, color: color, size: 22),
                const SizedBox(width: 10),
                Expanded(child: Text(a[0] as String, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w700))),
                Text('${score.toStringAsFixed(0)}', style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.w700)),
                Text('/100', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
              ]),
              const SizedBox(height: 6),
              ClipRRect(borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(value: score / 100, minHeight: 6, backgroundColor: Colors.white12, valueColor: AlwaysStoppedAnimation(color))),
              if (info['grade'] != null) Padding(padding: const EdgeInsets.only(top: 4),
                  child: Text('Grade: ${info['grade']}', style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600))),
              if (factors.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text('Factors:', style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                ...factors.map<Widget>((f) => Padding(padding: const EdgeInsets.only(bottom: 2),
                  child: Text('• ${f.toString()}', style: const TextStyle(color: AppColors.textPrimary, fontSize: 11)))),
              ],
            ]),
          );
        }).toList());
      },
    );
  }
}
