import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../services/api_service.dart';
import '_section_loader.dart';

class YogaWidget extends StatelessWidget {
  final String chartId;
  final dynamic initial;
  const YogaWidget({super.key, required this.chartId, this.initial});

  @override
  Widget build(BuildContext context) {
    return SectionLoader(
      initial: initial is Map ? (initial as Map).cast<String, dynamic>() : null,
      loader: () => ApiService().getKundliYoga(chartId),
      builder: (ctx, data) {
        final total = data['total'] ?? 0;
        final active = data['active'] ?? 0;
        final top = (data['top'] as List? ?? []);
        final all = (data['yogas'] as List? ?? []);
        return ListView(padding: const EdgeInsets.all(16), children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.success.withOpacity(0.2), AppColors.success.withOpacity(0.05)]),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.success.withOpacity(0.4)),
            ),
            child: Row(children: [
              const Icon(Icons.auto_awesome, color: AppColors.success, size: 32),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Yoga Analysis', style: TextStyle(color: AppColors.success, fontSize: 16, fontWeight: FontWeight.w700)),
                Text('$active active / $total yogas checked', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ])),
            ]),
          ),
          const SizedBox(height: 12),
          if (top.isNotEmpty) ...[
            const Text('TOP ACTIVE YOGAS', style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            ...top.map<Widget>((y) => _yogaCard(y as Map, active: true)),
            const SizedBox(height: 12),
          ],
          const Text('ALL YOGAS', style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          ...all.where((y) => (y as Map)['present'] != true).map<Widget>((y) => _yogaCard(y as Map, active: false)),
        ]);
      },
    );
  }

  Widget _yogaCard(Map y, {required bool active}) {
    final score = (y['score'] as num?)?.toDouble() ?? 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: active ? AppColors.success.withOpacity(0.08) : AppColors.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: active ? AppColors.success.withOpacity(0.3) : AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(y['name']?.toString() ?? '', style: TextStyle(color: active ? AppColors.success : AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: _scoreColor(score).withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
            child: Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: _scoreColor(score), fontSize: 11, fontWeight: FontWeight.w700)),
          ),
        ]),
        if (y['category'] != null) Padding(padding: const EdgeInsets.only(top: 2), child: Text(y['category'].toString(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 10))),
        if (y['description'] != null && y['description'].toString().isNotEmpty)
          Padding(padding: const EdgeInsets.only(top: 6), child: Text(y['description'].toString(), style: const TextStyle(color: AppColors.textPrimary, fontSize: 12))),
      ]),
    );
  }

  Color _scoreColor(double s) {
    if (s >= 70) return AppColors.success;
    if (s >= 40) return Colors.amber;
    if (s > 0) return Colors.orange;
    return AppColors.textSecondary;
  }
}
