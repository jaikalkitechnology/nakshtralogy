import 'package:flutter/material.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../services/api_service.dart';
import '_section_loader.dart';

class YogaWidget extends StatefulWidget {
  final String chartId;
  final dynamic initial;
  const YogaWidget({super.key, required this.chartId, this.initial});

  @override
  State<YogaWidget> createState() => _YogaWidgetState();
}

class _YogaWidgetState extends State<YogaWidget> {
  bool _showInactive = false;

  @override
  Widget build(BuildContext context) {
    return SectionLoader(
      initial: widget.initial is Map ? (widget.initial as Map).cast<String, dynamic>() : null,
      loader: () => ApiService().getKundliYoga(widget.chartId),
      builder: (ctx, data) {
        final total = (data['total'] as num?)?.toInt() ?? 0;
        final active = (data['active'] as num?)?.toInt() ?? 0;
        final allYogas = (data['yogas'] as List? ?? []).map((e) => (e as Map).cast<String, dynamic>()).toList();

        final activeList = allYogas.where((y) => y['present'] == true).toList()
          ..sort((a, b) => ((b['score'] as num?) ?? 0).compareTo((a['score'] as num?) ?? 0));
        final inactiveList = allYogas.where((y) => y['present'] != true).toList()
          ..sort((a, b) => ((b['score'] as num?) ?? 0).compareTo((a['score'] as num?) ?? 0));

        return ListView(padding: const EdgeInsets.all(16), children: [
          // Summary
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
                Text(AppLocalizations.of(context)?.yogaAnalysis ?? 'Yoga Analysis', style: TextStyle(color: AppColors.success, fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text('$active active / $total yogas checked', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: AppColors.success.withOpacity(0.25), borderRadius: BorderRadius.circular(20)),
                child: Text('$active', style: const TextStyle(color: AppColors.success, fontSize: 18, fontWeight: FontWeight.w800)),
              ),
            ]),
          ),
          const SizedBox(height: 14),

          // Active Yogas
          Row(children: [
            const Icon(Icons.check_circle, color: AppColors.success, size: 14),
            const SizedBox(width: 6),
            Text('ACTIVE YOGAS (${activeList.length})', style: const TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
          ]),
          const SizedBox(height: 8),
          if (activeList.isEmpty)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
              child: Text(AppLocalizations.of(context)?.noYogasActive ?? 'No yogas currently active.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            )
          else
            ...activeList.map((y) => _yogaCard(y, active: true)),

          const SizedBox(height: 16),

          // Toggle inactive
          InkWell(
            onTap: () => setState(() => _showInactive = !_showInactive),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
              child: Row(children: [
                Icon(_showInactive ? Icons.expand_less : Icons.expand_more, color: AppColors.textSecondary, size: 18),
                const SizedBox(width: 6),
                Text('${_showInactive ? "Hide" : "Show"} inactive yogas (${inactiveList.length})',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
              ]),
            ),
          ),

          if (_showInactive) ...[
            const SizedBox(height: 10),
            ...inactiveList.map((y) => _yogaCard(y, active: false)),
          ],
        ]);
      },
    );
  }

  Widget _yogaCard(Map y, {required bool active}) {
    final score = (y['score'] as num?)?.toDouble() ?? 0;
    final scoreColor = _scoreColor(score, active);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: active ? AppColors.success.withOpacity(0.08) : AppColors.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: active ? AppColors.success.withOpacity(0.35) : AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: Text(
              y['name']?.toString() ?? '',
              style: TextStyle(color: active ? AppColors.success : AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: scoreColor.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
            child: Text('${score.toStringAsFixed(0)}%',
                style: TextStyle(color: scoreColor, fontSize: 11, fontWeight: FontWeight.w700)),
          ),
        ]),
        if (y['category'] != null && y['category'].toString().isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(y['category'].toString(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w500)),
          ),
        if (y['description'] != null && y['description'].toString().isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(y['description'].toString(), style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, height: 1.35)),
          ),
        if (y['factors'] is List && (y['factors'] as List).isNotEmpty) ...[
          const SizedBox(height: 6),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: (y['factors'] as List).take(6).map<Widget>((f) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(4)),
                  child: Text(f.toString(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                )).toList(),
          ),
        ],
      ]),
    );
  }

  Color _scoreColor(double s, bool active) {
    if (!active) return AppColors.textSecondary;
    if (s >= 70) return AppColors.success;
    if (s >= 40) return Colors.amber;
    if (s > 0) return Colors.orange;
    return AppColors.textSecondary;
  }
}
