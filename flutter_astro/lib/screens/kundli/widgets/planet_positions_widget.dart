import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

/// Shows planetary positions table: planet, rashi, nakshatra, pada, dignity, flags.
class PlanetPositionsWidget extends StatelessWidget {
  final List<dynamic> planets;
  const PlanetPositionsWidget({super.key, required this.planets});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: planets.length,
      itemBuilder: (_, i) {
        final p = planets[i] as Map;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(child: Text(_planetSymbol(p['planet']?.toString() ?? ''), style: const TextStyle(fontSize: 18))),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text(p['planet']?.toString() ?? '', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 15)),
                  const SizedBox(width: 8),
                  if (p['retrograde'] == true) _flag('R', AppColors.error),
                  if (p['combust'] == true) _flag('C', Colors.orange),
                  if (p['vargottam'] == true) _flag('V', AppColors.success),
                ]),
                const SizedBox(height: 2),
                Text('${p['rashi']} • ${p['degree_in_rashi']?.toStringAsFixed(2)}°',
                    style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w500)),
              ])),
              if (p['dignity'] != null && p['dignity'].toString().isNotEmpty && p['dignity'] != '—')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: _dignityColor(p['dignity']).withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                  child: Text(p['dignity'].toString(), style: TextStyle(color: _dignityColor(p['dignity']), fontSize: 10, fontWeight: FontWeight.w600)),
                ),
            ]),
            const SizedBox(height: 10),
            Wrap(spacing: 6, runSpacing: 6, children: [
              _chip('Lord: ${p['rashi_lord']}'),
              _chip('Nak: ${p['nakshatra']} (${p['pada']})'),
              _chip('NL: ${p['nakshatra_lord']}'),
              _chip('D9: ${p['navamsha_rashi']}'),
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
    if (s.contains('moolatr') || s.contains('mool')) return Colors.amber;
    return AppColors.textSecondary;
  }

  String _planetSymbol(String name) {
    switch (name) {
      case 'Sun': return '☉';
      case 'Moon': return '☾';
      case 'Mars': return '♂';
      case 'Mercury': return '☿';
      case 'Jupiter': return '♃';
      case 'Venus': return '♀';
      case 'Saturn': return '♄';
      case 'Rahu': return '☊';
      case 'Ketu': return '☋';
      case 'Lagna': return '↑';
      default: return '✦';
    }
  }
}
