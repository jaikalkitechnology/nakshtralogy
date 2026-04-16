import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

/// Displays planet positions using the new V2/helper response shape where
/// `planets` is a Map keyed by planet name with fields:
///   sign, sign_full, sign_idx, degree, longitude, nakshatra, nak_lord,
///   pada, dignity, vakri, combust, vargottam
class PlanetPositionsWidget extends StatelessWidget {
  final Map<String, dynamic> planetsMap;
  const PlanetPositionsWidget({super.key, required this.planetsMap});

  static const _order = ['Lagna','Sun','Moon','Mars','Mercury','Jupiter','Venus','Saturn','Rahu','Ketu'];

  @override
  Widget build(BuildContext context) {
    final items = <Map<String, dynamic>>[];
    for (final name in _order) {
      final p = planetsMap[name];
      if (p is Map) items.add({'_name': name, ...p.cast<String, dynamic>()});
    }

    if (items.isEmpty) {
      return const Center(child: Text('No planet data', style: TextStyle(color: AppColors.textSecondary)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final p = items[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), shape: BoxShape.circle),
                child: Center(child: Text(_symbol(p['_name']?.toString() ?? ''), style: const TextStyle(fontSize: 18))),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text(p['_name']?.toString() ?? '', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 15)),
                  const SizedBox(width: 8),
                  if (p['vakri'] == true) _flag('R', AppColors.error),
                  if (p['combust'] == true) _flag('C', Colors.orange),
                  if (p['vargottam'] == true) _flag('V', AppColors.success),
                ]),
                const SizedBox(height: 2),
                Text('${p['sign_full']} • ${(p['degree'] as num?)?.toStringAsFixed(2)}°',
                    style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w500)),
              ])),
              if (p['dignity'] != null && p['dignity'].toString().isNotEmpty && p['dignity'].toString() != 'Normal')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: _dignityColor(p['dignity']).withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                  child: Text(p['dignity'].toString(), style: TextStyle(color: _dignityColor(p['dignity']), fontSize: 10, fontWeight: FontWeight.w600)),
                ),
            ]),
            const SizedBox(height: 10),
            Wrap(spacing: 6, runSpacing: 6, children: [
              _chip('Nak: ${p['nakshatra']} (${p['pada']})'),
              _chip('NL: ${p['nak_lord']}'),
              _chip('Lon: ${(p['longitude'] as num?)?.toStringAsFixed(2)}°'),
            ]),
          ]),
        );
      },
    );
  }

  Widget _chip(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(6), border: Border.all(color: AppColors.border)),
    child: Text(text, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
  );

  Widget _flag(String s, Color c) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
    decoration: BoxDecoration(color: c.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
    child: Text(s, style: TextStyle(color: c, fontSize: 9, fontWeight: FontWeight.bold)),
  );

  Color _dignityColor(dynamic d) {
    final s = d.toString().toLowerCase();
    if (s.contains('exalt')) return AppColors.success;
    if (s.contains('debil')) return AppColors.error;
    if (s.contains('own')) return AppColors.primary;
    if (s.contains('mool')) return Colors.amber;
    return AppColors.textSecondary;
  }

  String _symbol(String name) {
    const s = {'Sun':'☉','Moon':'☾','Mars':'♂','Mercury':'☿','Jupiter':'♃',
               'Venus':'♀','Saturn':'♄','Rahu':'☊','Ketu':'☋','Lagna':'↑'};
    return s[name] ?? '✦';
  }
}
