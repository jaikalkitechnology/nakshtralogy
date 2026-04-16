import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../services/api_service.dart';
import '_section_loader.dart';

class BhavaWidget extends StatelessWidget {
  final String chartId;
  final dynamic initial;
  const BhavaWidget({super.key, required this.chartId, this.initial});

  static const _houseNames = [
    'Self / Body', 'Wealth / Family', 'Siblings / Courage', 'Home / Mother',
    'Children / Intellect', 'Enemies / Health', 'Marriage / Partner', 'Longevity',
    'Fortune / Guru', 'Career / Father', 'Gains / Friends', 'Loss / Moksha',
  ];

  @override
  Widget build(BuildContext context) {
    return SectionLoader(
      initial: initial is Map ? (initial as Map).cast<String, dynamic>() : null,
      loader: () => ApiService().getKundliBhava(chartId),
      builder: (ctx, data) {
        final houses = <int, Map<String, dynamic>>{};
        data.forEach((k, v) {
          if (v is Map && (v['house'] ?? -1) is num) {
            houses[(v['house'] as num).toInt()] = v.cast<String, dynamic>();
          }
        });
        final sorted = List.generate(12, (i) => i + 1);

        return ListView(padding: const EdgeInsets.all(16), children: sorted.map((h) {
          final hd = houses[h] ?? {};
          final score = (hd['score'] as num?)?.toDouble() ?? 0;
          final occupants = (hd['occupants'] as List? ?? []);
          final sav = hd['sav'];
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(width: 32, height: 32, decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), shape: BoxShape.circle),
                    child: Center(child: Text('H$h', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 11)))),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(_houseNames[h - 1], style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                  Text('${hd['sign'] ?? '-'} • Lord: ${hd['lord'] ?? '-'}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(score.toStringAsFixed(0), style: TextStyle(color: _sc(score), fontSize: 20, fontWeight: FontWeight.w700)),
                  if (sav != null) Text('SAV: $sav', style: const TextStyle(color: AppColors.textSecondary, fontSize: 9)),
                ]),
              ]),
              const SizedBox(height: 6),
              ClipRRect(borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(value: score / 100, minHeight: 3, backgroundColor: AppColors.surface, valueColor: AlwaysStoppedAnimation(_sc(score)))),
              if (occupants.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6),
                  child: Wrap(spacing: 4, children: occupants.map<Widget>((o) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                    child: Text(o.toString(), style: const TextStyle(color: AppColors.primary, fontSize: 10)),
                  )).toList())),
            ]),
          );
        }).toList());
      },
    );
  }

  Color _sc(double s) {
    if (s >= 70) return AppColors.success;
    if (s >= 50) return Colors.amber;
    if (s >= 30) return Colors.orange;
    return AppColors.error;
  }
}
