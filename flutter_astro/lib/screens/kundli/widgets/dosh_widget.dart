import 'package:flutter/material.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../services/api_service.dart';
import '_section_loader.dart';

class DoshWidget extends StatelessWidget {
  final String chartId;
  final dynamic initial;
  const DoshWidget({super.key, required this.chartId, this.initial});

  @override
  Widget build(BuildContext context) {
    return SectionLoader(
      initial: initial is Map ? (initial as Map).cast<String, dynamic>() : null,
      loader: () => ApiService().getKundliDosh(chartId),
      builder: (ctx, data) {
        final total = data['total'] ?? 0;
        final active = data['active'] ?? 0;
        final doshas = (data['doshas'] as List? ?? []);
        final top = (data['top'] as List? ?? []);
        return ListView(padding: const EdgeInsets.all(16), children: [
          // Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.error.withOpacity(0.2), AppColors.error.withOpacity(0.05)]),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.error.withOpacity(0.4)),
            ),
            child: Row(children: [
              const Icon(Icons.warning, color: AppColors.error, size: 32),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(AppLocalizations.of(context)?.dosh ?? 'Dosha Analysis', style: TextStyle(color: AppColors.error, fontSize: 16, fontWeight: FontWeight.w700)),
                Text('$active active / $total checked', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ])),
            ]),
          ),
          const SizedBox(height: 12),
          if (top.isNotEmpty) ...[
            const Text('TOP ACTIVE DOSHAS', style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            ...top.map<Widget>((d) => _doshCard(d as Map, active: true)),
            const SizedBox(height: 12),
          ],
          const Text('ALL DOSHAS', style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          ...doshas.where((d) => (d as Map)['present'] != true).map<Widget>((d) => _doshCard(d as Map, active: false)),
        ]);
      },
    );
  }

  Widget _doshCard(Map d, {required bool active}) {
    final score = (d['score'] as num?)?.toDouble() ?? 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: active ? AppColors.error.withOpacity(0.08) : AppColors.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: active ? AppColors.error.withOpacity(0.3) : AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(d['name']?.toString() ?? '', style: TextStyle(color: active ? AppColors.error : AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: _scoreColor(score).withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
            child: Text('${score.toStringAsFixed(0)}%', style: TextStyle(color: _scoreColor(score), fontSize: 11, fontWeight: FontWeight.w700)),
          ),
        ]),
        if (d['category'] != null) Padding(padding: const EdgeInsets.only(top: 2), child: Text(d['category'].toString(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 10))),
        if (d['description'] != null && d['description'].toString().isNotEmpty)
          Padding(padding: const EdgeInsets.only(top: 6), child: Text(d['description'].toString(), style: const TextStyle(color: AppColors.textPrimary, fontSize: 12))),
        if (d['factors'] is List && (d['factors'] as List).isNotEmpty) ...[
          const SizedBox(height: 6),
          Wrap(spacing: 4, runSpacing: 4, children: (d['factors'] as List).map<Widget>((f) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(4)),
            child: Text(f.toString(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
          )).toList()),
        ],
      ]),
    );
  }

  Color _scoreColor(double s) {
    if (s >= 70) return AppColors.error;
    if (s >= 40) return Colors.orange;
    if (s > 0) return Colors.amber;
    return AppColors.success;
  }
}
