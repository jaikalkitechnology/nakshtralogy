import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../services/api_service.dart';
import '_section_loader.dart';

class GocharWidget extends StatelessWidget {
  final String chartId;
  final dynamic initial;
  const GocharWidget({super.key, required this.chartId, this.initial});

  @override
  Widget build(BuildContext context) {
    return SectionLoader(
      initial: initial is Map ? (initial as Map).cast<String, dynamic>() : null,
      loader: () => ApiService().getGocharToday(),
      builder: (ctx, data) => _GocharBody(data: data),
    );
  }
}

class _GocharBody extends StatelessWidget {
  final Map<String, dynamic> data;
  const _GocharBody({required this.data});

  @override
  Widget build(BuildContext context) {
    final rashis = (data['rashis'] as List? ?? []);
    final best = data['best']?.toString() ?? '';
    final worst = data['worst']?.toString() ?? '';
    final date = data['date']?.toString() ?? 'Today';
    final moonSign = data['moon_sign']?.toString();

    return ListView(padding: const EdgeInsets.all(16), children: [
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.primary.withOpacity(0.2), AppColors.accent.withOpacity(0.1)]),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primary.withOpacity(0.4)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.wb_sunny, color: AppColors.primary, size: 22),
            const SizedBox(width: 10),
            Expanded(child: Text('Gochar (Transit Scores) \u2014 $date',
                style: const TextStyle(color: AppColors.primary, fontSize: 15, fontWeight: FontWeight.w700))),
          ]),
          if (moonSign != null && moonSign.isNotEmpty)
            Padding(padding: const EdgeInsets.only(top: 4), child: Text('Native Moon: $moonSign', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11))),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _summaryChip('BEST', best, AppColors.success, Icons.arrow_upward)),
            const SizedBox(width: 8),
            Expanded(child: _summaryChip('WORST', worst, AppColors.error, Icons.arrow_downward)),
          ]),
        ]),
      ),
      const SizedBox(height: 12),
      ...rashis.map<Widget>((r) {
        final rm = (r as Map).cast<String, dynamic>();
        final score = (rm['score'] as num?)?.toDouble() ?? 0;
        final grade = rm['grade']?.toString() ?? '';
        final flags = (rm['flags'] as List? ?? []);
        return Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(8), border: Border.all(color: _color(score).withOpacity(0.4))),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(rm['rashi']?.toString() ?? '', style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
              if (flags.isNotEmpty) Text(flags.take(2).join(' · '), style: const TextStyle(color: AppColors.smoke, fontSize: 9), maxLines: 1, overflow: TextOverflow.ellipsis),
            ])),
            Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: _color(score).withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                child: Text(grade, style: TextStyle(color: _color(score), fontSize: 9, fontWeight: FontWeight.w600))),
            const SizedBox(width: 6),
            SizedBox(width: 40, child: Text(score.toStringAsFixed(1), style: TextStyle(color: _color(score), fontSize: 13, fontWeight: FontWeight.w700), textAlign: TextAlign.right)),
          ]),
        );
      }),
    ]);
  }

  Widget _summaryChip(String label, String rashi, Color c, IconData icon) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(color: c.withOpacity(0.15), borderRadius: BorderRadius.circular(10), border: Border.all(color: c.withOpacity(0.4))),
    child: Row(children: [
      Icon(icon, color: c, size: 18),
      const SizedBox(width: 6),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.w700)),
        Text(rashi, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
      ])),
    ]),
  );

  Color _color(double s) {
    if (s >= 5) return AppColors.success;
    if (s >= 0) return Colors.amber;
    if (s >= -5) return Colors.orange;
    return AppColors.error;
  }
}
