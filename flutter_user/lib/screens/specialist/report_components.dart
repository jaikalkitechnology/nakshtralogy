import 'package:flutter/material.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';

// ═══════════════════════════════════════════════════════════════════
// Shared visual components matching nakshtralogy-career-detail.html
// Used by both CareerReportScreen and generic SpecialistReportScreen
// ═══════════════════════════════════════════════════════════════════

class ReportHeader extends StatelessWidget {
  final String prefix, suffix, tag;
  const ReportHeader(this.prefix, this.suffix, this.tag, {super.key});

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text.rich(TextSpan(children: [
        TextSpan(text: '$prefix ', style: const TextStyle(color: AppColors.ivory, fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'serif')),
        TextSpan(text: suffix, style: const TextStyle(color: AppColors.gold, fontSize: 15, fontWeight: FontWeight.w500, fontFamily: 'serif', fontStyle: FontStyle.italic)),
      ])),
      Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.gold.withOpacity(0.15))),
        child: Text(tag, style: const TextStyle(color: AppColors.smoke, fontSize: 8, letterSpacing: 1.5, fontFamily: 'monospace'))),
    ]));
}

class ScoreRing extends StatelessWidget {
  final double value;
  final String label;
  final Color color;
  final double size;
  const ScoreRing(this.value, this.label, this.color, {this.size = 76, super.key});

  @override
  Widget build(BuildContext context) => Column(children: [
    SizedBox(width: size, height: size, child: Stack(alignment: Alignment.center, children: [
      SizedBox(width: size, height: size, child: CircularProgressIndicator(
        value: (value / 100).clamp(0, 1), strokeWidth: size > 60 ? 6 : 4,
        backgroundColor: Colors.white.withOpacity(0.08), valueColor: AlwaysStoppedAnimation(color))),
      Text(value.toStringAsFixed(value >= 10 ? 0 : 1),
        style: TextStyle(color: color, fontSize: size > 60 ? 18 : 12, fontWeight: FontWeight.w700, fontFamily: 'serif')),
    ])),
    const SizedBox(height: 6),
    Text(label, textAlign: TextAlign.center,
      style: const TextStyle(color: AppColors.smoke, fontSize: 8, letterSpacing: 1, fontFamily: 'monospace', height: 1.2)),
  ]);
}

class KarakaCard extends StatelessWidget {
  final String tag, planet, meaning;
  final String? detail;
  const KarakaCard({required this.tag, required this.planet, required this.meaning, this.detail, super.key});

  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [AppColors.gold.withOpacity(0.12), AppColors.gold.withOpacity(0.02)]),
      borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.gold.withOpacity(0.25))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(tag, style: const TextStyle(color: AppColors.gold, fontSize: 8, letterSpacing: 1.5, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
      const SizedBox(height: 4),
      Text(planet, style: const TextStyle(color: AppColors.ivory, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'serif', height: 1)),
      const SizedBox(height: 2),
      Text(meaning, style: const TextStyle(color: AppColors.smoke, fontSize: 8, height: 1.3)),
      if (detail != null && detail!.isNotEmpty) ...[
        const SizedBox(height: 6),
        Text(detail!, maxLines: 2, overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColors.lavender, fontSize: 8, height: 1.3, fontStyle: FontStyle.italic))],
    ]));
}

class DignityBadge extends StatelessWidget {
  final String planet, dignity;
  const DignityBadge(this.planet, this.dignity, {super.key});

  Color get _color {
    final d = dignity.toLowerCase();
    if (d.contains('exalt') || d.contains('moolatrikona')) return AppColors.success;
    if (d.contains('own') || d.contains('swakshetra')) return AppColors.gold;
    if (d.contains('friend')) return AppColors.aurora;
    if (d.contains('neech') || d.contains('debilitat') || d.contains('enemy')) return AppColors.error;
    return AppColors.smoke;
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 5),
    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0x0DFFFFFF), width: 0.5))),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(planet, style: const TextStyle(color: AppColors.ivory, fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'serif')),
      Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(color: _color.withOpacity(0.15), borderRadius: BorderRadius.circular(4),
          border: Border.all(color: _color.withOpacity(0.4))),
        child: Text(dignity.toUpperCase(),
          style: TextStyle(color: _color, fontSize: 8, letterSpacing: 0.8, fontFamily: 'monospace', fontWeight: FontWeight.w700))),
    ]));
}

class RiskCard extends StatelessWidget {
  final String type, severity, description;
  final String? mitigation;
  const RiskCard({required this.type, required this.severity, required this.description, this.mitigation, super.key});

  Color get _color {
    final s = severity.toLowerCase();
    if (s == 'high' || s == 'notable' || s == 'severe') return AppColors.error;
    if (s == 'moderate' || s == 'med' || s == 'medium') return const Color(0xFFE5A93A);
    return AppColors.aurora;
  }

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 8), padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [_color.withOpacity(0.10), _color.withOpacity(0.02)]),
      borderRadius: BorderRadius.circular(14), border: Border.all(color: _color.withOpacity(0.3))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Flexible(child: Text(type, style: TextStyle(color: _color, fontSize: 13, fontWeight: FontWeight.w700, fontFamily: 'serif'))),
        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(color: _color.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
          child: Text(severity.toUpperCase(), style: TextStyle(color: _color, fontSize: 8, letterSpacing: 1, fontFamily: 'monospace', fontWeight: FontWeight.w700))),
      ]),
      if (description.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6),
        child: Text(description, style: const TextStyle(color: AppColors.ivory, fontSize: 11, height: 1.4))),
      if (mitigation != null && mitigation!.isNotEmpty) Container(margin: const EdgeInsets.only(top: 8), padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColors.success.withOpacity(0.08), borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.success.withOpacity(0.2))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('✓ ${AppLocalizations.of(context)!.mitigation}', style: const TextStyle(color: AppColors.success, fontSize: 8, letterSpacing: 1.5, fontFamily: 'monospace', fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(mitigation!, style: const TextStyle(color: AppColors.ivory, fontSize: 10, height: 1.4)),
        ])),
    ]));
}

class RemedyCard extends StatelessWidget {
  final String deity, text;
  const RemedyCard({required this.deity, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    final ch = deity.isNotEmpty ? deity.split(' ').first.substring(0, 1).toUpperCase() : '✦';
    return Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 6), padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gold.withOpacity(0.2))),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 38, height: 38,
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.gold, AppColors.saffron]),
            borderRadius: BorderRadius.circular(10)),
          child: Center(child: Text(ch, style: const TextStyle(color: AppColors.midnight, fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'serif')))),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(deity, style: const TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'serif')),
          const SizedBox(height: 3),
          Text(text, style: const TextStyle(color: AppColors.ivory, fontSize: 10, height: 1.4)),
        ])),
      ]));
  }
}

class ConfidenceBlock extends StatelessWidget {
  final double score;
  final String? statement;
  final Map<String, dynamic> breakdown;
  const ConfidenceBlock({required this.score, this.statement, required this.breakdown, super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final pct = score <= 1.0 ? score * 100 : score;
    final layers = breakdown.entries.where((e) => e.value is num && e.key != 'final' && e.key != 'ceiling').toList();

    return Container(margin: const EdgeInsets.fromLTRB(16, 0, 16, 12), padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.aurora.withOpacity(0.12), const Color(0xFF4A3B8C).withOpacity(0.15)]),
        borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.aurora.withOpacity(0.3))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          SizedBox(width: 70, height: 70, child: Stack(alignment: Alignment.center, children: [
            SizedBox(width: 70, height: 70, child: CircularProgressIndicator(value: pct / 100, strokeWidth: 5,
              backgroundColor: Colors.white.withOpacity(0.08), valueColor: const AlwaysStoppedAnimation(AppColors.aurora))),
            Text('${pct.toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.aurora, fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'serif')),
          ])),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.confidence, style: const TextStyle(color: AppColors.aurora, fontSize: 8, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(pct >= 80 ? l.reliabilityVeryHigh : pct >= 65 ? l.reliabilityHigh : pct >= 50 ? l.reliabilityModerate : l.reliabilityGuidanceLevel,
              style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'serif')),
          ])),
        ]),
        if (statement != null && statement!.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 10),
          child: Text(statement!, style: const TextStyle(color: AppColors.lavender, fontSize: 10, height: 1.5))),
        if (layers.isNotEmpty) ...[
          const SizedBox(height: 12),
          ...layers.take(8).map((layer) {
            final v = ((layer.value as num).toDouble() * (layer.value is double && (layer.value as double) <= 1.0 ? 100 : 1)).clamp(0, 100).toDouble();
            return Padding(padding: const EdgeInsets.only(bottom: 6), child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(_fmt(layer.key), style: const TextStyle(color: AppColors.lavender, fontSize: 9)),
                Text('${v.toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.gold, fontSize: 9, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
              ]),
              const SizedBox(height: 3),
              ClipRRect(borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(value: v / 100, minHeight: 3,
                  backgroundColor: Colors.white.withOpacity(0.06), valueColor: const AlwaysStoppedAnimation(AppColors.aurora))),
            ]));
          }),
        ],
      ]));
  }

  static String _fmt(String k) => k.replaceAll('_', ' ').split(' ').map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');
}

class TimingWindowCard extends StatelessWidget {
  final String title, icon;
  final Color color;
  final List items;
  final bool isPeak;
  const TimingWindowCard({required this.title, required this.icon, required this.color, required this.items, this.isPeak = false, super.key});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 8), padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      gradient: isPeak ? LinearGradient(colors: [AppColors.gold.withOpacity(0.10), AppColors.gold.withOpacity(0.02)]) : null,
      color: isPeak ? null : const Color(0xFF1A1642).withOpacity(0.5),
      borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withOpacity(isPeak ? 0.4 : 0.2))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'serif')),
        Container(width: 26, height: 26, decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
          child: Center(child: Text(icon, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700)))),
      ]),
      const SizedBox(height: 8),
      ...items.take(3).map((item) {
        if (item is! Map) return const SizedBox.shrink();
        final w = (item as Map).cast<String, dynamic>();
        return Container(margin: const EdgeInsets.only(bottom: 6), padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(8)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Flexible(child: Text(w['dasha']?.toString() ?? w['md']?.toString() ?? '—',
                style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700, fontFamily: 'serif'))),
              Text(w['window']?.toString() ?? w['start']?.toString() ?? '',
                style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontFamily: 'monospace')),
            ]),
            if (w['note'] != null) Padding(padding: const EdgeInsets.only(top: 3),
              child: Text(w['note'].toString(), maxLines: 2, overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.lavender, fontSize: 9, height: 1.3, fontStyle: FontStyle.italic))),
          ]));
      }),
    ]));
}

class InfoChip extends StatelessWidget {
  final String text;
  final Color color;
  final bool isHighlighted;
  const InfoChip(this.text, this.color, {this.isHighlighted = false, super.key});

  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: color.withOpacity(isHighlighted ? 0.18 : 0.10),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withOpacity(isHighlighted ? 0.5 : 0.3))),
    child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w500)));
}

class KeyValueBox extends StatelessWidget {
  final Map<String, String> rows;
  final String? callout;
  const KeyValueBox({required this.rows, this.callout, super.key});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.6), borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.gold.withOpacity(0.2))),
    child: Column(children: [
      ...rows.entries.map((e) => Container(padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0x14FFFFFF), width: 0.5))),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(e.key, style: const TextStyle(color: AppColors.smoke, fontSize: 9, letterSpacing: 1, fontFamily: 'monospace')),
          Flexible(child: Text(e.value, textAlign: TextAlign.right,
            style: const TextStyle(color: AppColors.gold, fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'serif'),
            maxLines: 2, overflow: TextOverflow.ellipsis)),
        ]))),
      if (callout != null && callout!.isNotEmpty) Container(margin: const EdgeInsets.only(top: 10), padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.08),
          borderRadius: const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
          border: const Border(left: BorderSide(color: AppColors.gold, width: 3))),
        child: Text(callout!, style: const TextStyle(color: AppColors.ivory, fontSize: 10, height: 1.5, fontStyle: FontStyle.italic))),
    ]));
}

String titleCase(String s) => s.replaceAll('_', ' ').replaceAll('-', ' ').split(' ')
  .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');
