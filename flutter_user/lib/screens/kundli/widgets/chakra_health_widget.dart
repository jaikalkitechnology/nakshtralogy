import 'package:flutter/material.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../services/api_service.dart';
import '_section_loader.dart';

class ChakraHealthWidget extends StatelessWidget {
  final String chartId;
  final dynamic initial;
  const ChakraHealthWidget({super.key, required this.chartId, this.initial});

  @override
  Widget build(BuildContext context) {
    return SectionLoader(
      initial: initial is Map ? (initial as Map).cast<String, dynamic>() : null,
      loader: () => ApiService().getKundliChakraHealth(chartId),
      builder: (ctx, data) {
        final chakras = (data['chakras'] as List? ?? []);
        final overallScore = (data['overall_score'] as num?)?.toDouble() ?? 0;
        final overallStatus = data['overall_status']?.toString() ?? '';

        return ListView(padding: const EdgeInsets.all(16), children: [
          // Overall
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [_sColor(overallScore).withOpacity(0.25), _sColor(overallScore).withOpacity(0.1)]),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _sColor(overallScore).withOpacity(0.5)),
            ),
            child: Row(children: [
              const Icon(Icons.spa, color: AppColors.primary, size: 28),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(AppLocalizations.of(context)!.chakraOverallHealth, style: TextStyle(color: AppColors.primary, fontSize: 15, fontWeight: FontWeight.w700)),
                Text(overallStatus, style: TextStyle(color: _sColor(overallScore), fontSize: 13, fontWeight: FontWeight.w600)),
              ])),
              Text(overallScore.toStringAsFixed(0), style: TextStyle(color: _sColor(overallScore), fontSize: 28, fontWeight: FontWeight.w700)),
              const Text('/100', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
            ]),
          ),
          const SizedBox(height: 12),
          // 7 Chakras
          ...chakras.map<Widget>((c) => _chakraCard(c as Map)),
        ]);
      },
    );
  }

  Widget _chakraCard(Map c) {
    final score = (c['chakra_score'] as num?)?.toDouble() ?? 0;
    final status = c['chakra_status']?.toString() ?? '';
    final colorHex = c['color']?.toString() ?? '#FF5722';
    final chakraColor = _parseHex(colorHex);
    final beej = c['beej']?.toString() ?? '';
    final bodyParts = (c['body_parts'] as List? ?? []);
    final planets = (c['planets'] as List? ?? []);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: chakraColor.withOpacity(0.4), width: 1.5)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: chakraColor.withOpacity(0.3), shape: BoxShape.circle, border: Border.all(color: chakraColor, width: 2)),
              child: Center(child: Text(beej, style: TextStyle(color: chakraColor, fontSize: 16, fontWeight: FontWeight.w700)))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${c['number']}. ${c['name']}', style: TextStyle(color: chakraColor, fontSize: 14, fontWeight: FontWeight.w700)),
            if (bodyParts.isNotEmpty) Text(bodyParts.join(', '), style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
          ])),
          Column(children: [
            Text(score.toStringAsFixed(0), style: TextStyle(color: _sColor(score), fontSize: 18, fontWeight: FontWeight.w700)),
            Text(status, style: TextStyle(color: _sColor(score), fontSize: 9, fontWeight: FontWeight.w600)),
          ]),
        ]),
        if (planets.isNotEmpty) ...[
          const SizedBox(height: 8),
          ...planets.map<Widget>((p) {
            final pm = (p as Map).cast<String, dynamic>();
            final strength = (pm['strength'] as num?)?.toDouble() ?? 0;
            return Padding(padding: const EdgeInsets.only(top: 4), child: Row(children: [
              Text(pm['planet']?.toString() ?? '', style: const TextStyle(color: AppColors.textPrimary, fontSize: 11, fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              Text('${strength.toStringAsFixed(0)}%', style: TextStyle(color: _sColor(strength), fontSize: 10)),
              const SizedBox(width: 8),
              Expanded(child: Text(pm['status']?.toString() ?? '', style: const TextStyle(color: AppColors.textSecondary, fontSize: 10))),
            ]));
          }),
        ],
      ]),
    );
  }

  Color _parseHex(String hex) {
    try {
      final h = hex.replaceAll('#', '');
      return Color(int.parse('FF$h', radix: 16));
    } catch (_) { return AppColors.primary; }
  }

  Color _sColor(double s) {
    if (s >= 70) return AppColors.success;
    if (s >= 50) return Colors.amber;
    if (s >= 30) return Colors.orange;
    return AppColors.error;
  }
}
