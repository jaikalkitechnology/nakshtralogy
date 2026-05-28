import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';
import 'report_components.dart';

class ChildProbabilityReportScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final List<String> participants;
  const ChildProbabilityReportScreen({super.key, required this.data, required this.participants});

  static const _accent = Color(0xFFE8689C);

  @override
  Widget build(BuildContext context) {
    final overall = _asMap(data['overall_probability']);
    final number = _asMap(data['number_of_children']);
    final timing = _asMap(data['timing_moola_dasha']);
    final fifth = _asMap(data['fifth_house_analysis']);
    final jupiter = _asMap(data['jupiter_analysis']);
    final d7 = _asMap(data['d7_saptamsa_analysis']);
    final beeja = _asMap(data['beeja_kshetra_sphuta']);
    final dosha = _asMap(data['dosha_analysis']);
    final remedies = _asMap(data['remedies']);
    final summary = _asMap(data['summary']);
    final header = _asMap(data['analysis_header']);
    final conf = (data['confidence_score'] as num?)?.toDouble();

    final mainScore = (overall['composite_probability_score'] as num?)?.toDouble() ?? 0;
    final grade = overall['probability_grade']?.toString() ?? '';
    final verdict = overall['verdict']?.toString() ?? '';
    final sc = mainScore >= 70 ? AppColors.success : mainScore >= 50 ? AppColors.gold : mainScore >= 30 ? const Color(0xFFE5A93A) : AppColors.error;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A24),
      body: CustomScrollView(slivers: [
        SliverAppBar(backgroundColor: const Color(0xFF0A0A24), pinned: true,
          leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.ivory), onPressed: () => Navigator.pop(context)),
          title: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(participants.join(' & ').toUpperCase(), style: const TextStyle(color: AppColors.gold, fontSize: 9, letterSpacing: 1.5, fontFamily: 'monospace'), maxLines: 1, overflow: TextOverflow.ellipsis),
            const Text.rich(TextSpan(children: [
              TextSpan(text: 'Child ', style: TextStyle(color: AppColors.ivory, fontSize: 18, fontWeight: FontWeight.w600)),
              TextSpan(text: 'Probability', style: TextStyle(color: Color(0xFFE8689C), fontSize: 18, fontStyle: FontStyle.italic)),
            ])),
          ]), centerTitle: true),

        SliverList(delegate: SliverChildListDelegate([
          // ═══ HERO ═══
          Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 12), padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [_accent.withOpacity(0.12), const Color(0xFF4A3B8C).withOpacity(0.1)]),
              borderRadius: BorderRadius.circular(20), border: Border.all(color: _accent.withOpacity(0.3))),
            child: Column(children: [
              const Text('PROGENY PROBABILITY', style: TextStyle(color: _accent, fontSize: 8, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
              const SizedBox(height: 14),
              SizedBox(width: 110, height: 110, child: Stack(alignment: Alignment.center, children: [
                SizedBox(width: 110, height: 110, child: CircularProgressIndicator(
                  value: mainScore / 100, strokeWidth: 8,
                  backgroundColor: Colors.white.withOpacity(0.08), valueColor: AlwaysStoppedAnimation(sc))),
                Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(mainScore.toStringAsFixed(0), style: TextStyle(color: sc, fontSize: 32, fontWeight: FontWeight.w700, fontFamily: 'serif')),
                  Text(grade, style: TextStyle(color: sc, fontSize: 9, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
                ]),
              ])),
              const SizedBox(height: 10),
              if (verdict.isNotEmpty) Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(color: sc.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Text(verdict, style: TextStyle(color: sc, fontSize: 11, fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
              const SizedBox(height: 12),
              _scoreRow(overall),
            ])),

          // ═══ NUMBER OF CHILDREN ═══
          if (number.isNotEmpty) ...[
            _header('Number of', 'Children'),
            _card([
              if (number['predicted_count'] != null) _kv('Predicted', '${number['predicted_count']}', AppColors.gold, big: true),
              if (number['predicted_range'] != null) _kv('Range', number['predicted_range'].toString(), _accent),
              if (number['boy_girl_indication'] != null) _kv('Gender Indication', number['boy_girl_indication'].toString(), AppColors.lavender),
              if (number['explanation'] != null) _text(number['explanation'].toString()),
            ]),
          ],

          // ═══ TIMING ═══
          if (timing.isNotEmpty) ...[
            _header('Favorable', 'Timing'),
            _card([
              ..._renderTimingWindows(timing),
              if (timing['explanation'] != null) _text(timing['explanation'].toString()),
            ]),
          ],

          // ═══ 5TH HOUSE ═══
          if (fifth.isNotEmpty) ...[
            _header('5th House', 'Analysis'),
            ...fifth.entries.map((e) => _personSection(e.key, _asMap(e.value))),
          ],

          // ═══ JUPITER ═══
          if (jupiter.isNotEmpty) ...[
            _header('Jupiter', 'Analysis'),
            ...jupiter.entries.map((e) => _personSection(e.key, _asMap(e.value))),
          ],

          // ═══ D7 SAPTAMSA ═══
          if (d7.isNotEmpty) ...[
            _header('D7 Saptamsa', 'Analysis'),
            ...d7.entries.map((e) => _personSection(e.key, _asMap(e.value))),
          ],

          // ═══ BEEJA / KSHETRA ═══
          if (beeja.isNotEmpty) ...[
            _header('Beeja & Kshetra', 'Sphuta'),
            _card([
              ..._renderBeejaKshetra(beeja),
              if (beeja['combined_fertility_indication'] != null) _text(beeja['combined_fertility_indication'].toString()),
            ]),
          ],

          // ═══ DOSHA ═══
          if (dosha.isNotEmpty) ...[
            _header('Dosha', 'Analysis'),
            _card(_renderGenericMap(dosha)),
          ],

          // ═══ REMEDIES ═══
          if (remedies.isNotEmpty) ...[
            _header('Vedic', 'Remedies'),
            _card(_renderRemedies(remedies)),
          ],

          // ═══ SUMMARY ═══
          if (summary.isNotEmpty) _summaryCard(summary),

          // ═══ CONFIDENCE ═══
          if (conf != null) ...[
            ReportHeader('Analysis', 'Confidence', 'QUALITY'),
            ConfidenceBlock(score: conf, statement: data['confidence_explanation']?.toString(),
              breakdown: _asMap(data['confidence_breakdown'])),
          ],

          // ═══ AI COPY ═══
          _aiCopyBar(context),
          const SizedBox(height: 40),
        ])),
      ]),
    );
  }

  // ── Helpers ──

  Widget _header(String p1, String p2) => ReportHeader(p1, p2, '');

  Widget _card(List<Widget> children) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children));

  Widget _kv(String label, String value, Color vc, {bool big = false}) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(width: 110, child: Text(label, style: const TextStyle(color: AppColors.smoke, fontSize: 10, fontFamily: 'monospace'))),
      Expanded(child: Text(value, style: TextStyle(color: vc, fontSize: big ? 18 : 11, fontWeight: big ? FontWeight.w700 : FontWeight.w600, fontFamily: big ? 'serif' : null))),
    ]));

  Widget _text(String s) => Padding(padding: const EdgeInsets.only(top: 4), child: Text(s, style: const TextStyle(color: AppColors.ivory, fontSize: 10, height: 1.4, fontStyle: FontStyle.italic)));

  Widget _scoreRow(Map<String, dynamic> m) {
    final scores = m.entries.where((e) => e.value is num && e.key.contains('score') && e.key != 'composite_probability_score').toList();
    if (scores.isEmpty) return const SizedBox.shrink();
    return Wrap(spacing: 8, runSpacing: 6, alignment: WrapAlignment.center, children: scores.take(4).map((e) {
      final v = (e.value as num).toDouble();
      final c = v >= 70 ? AppColors.success : v >= 50 ? AppColors.gold : AppColors.warning;
      final lbl = e.key.replaceAll('_score', '').replaceAll('_', ' ');
      return Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: c.withOpacity(0.3))),
        child: Column(children: [
          Text(v.toStringAsFixed(0), style: TextStyle(color: c, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'serif')),
          Text(_titleCase(lbl), style: TextStyle(color: c.withOpacity(0.7), fontSize: 7, fontFamily: 'monospace'), maxLines: 1, overflow: TextOverflow.ellipsis),
        ]));
    }).toList());
  }

  Widget _personSection(String key, Map<String, dynamic> m) {
    final name = key.replaceAll('_male', ' (M)').replaceAll('_female', ' (F)');
    final scores = m.entries.where((e) => e.value is num).toList();
    final texts = m.entries.where((e) => e.value is String && (e.value as String).isNotEmpty).toList();
    final nested = m.entries.where((e) => e.value is Map || e.value is List).toList();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8), padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF1A1642).withOpacity(0.5), borderRadius: BorderRadius.circular(12), border: Border.all(color: _accent.withOpacity(0.2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(name, style: const TextStyle(color: _accent, fontSize: 12, fontWeight: FontWeight.w700, fontFamily: 'serif')),
        const SizedBox(height: 8),
        ...scores.map((e) {
          final v = (e.value as num).toDouble();
          final c = v >= 70 ? AppColors.success : v >= 50 ? AppColors.gold : v >= 30 ? AppColors.warning : AppColors.error;
          return Padding(padding: const EdgeInsets.only(bottom: 5), child: Column(children: [
            Row(children: [
              Expanded(child: Text(_titleCase(e.key), style: const TextStyle(color: AppColors.ivory, fontSize: 10))),
              Text(v.toStringAsFixed(v == v.roundToDouble() ? 0 : 1), style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
            ]),
            const SizedBox(height: 2),
            ClipRRect(borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(value: (v / 100).clamp(0, 1), minHeight: 3, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c))),
          ]));
        }),
        ...texts.map((e) => Padding(padding: const EdgeInsets.only(bottom: 4),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(width: 90, child: Text(_titleCase(e.key), style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontFamily: 'monospace'))),
            Expanded(child: Text(e.value.toString(), style: const TextStyle(color: AppColors.ivory, fontSize: 10, height: 1.3))),
          ]))),
        ...nested.map((e) {
          if (e.value is List) return _renderListInline(e.key, e.value as List);
          return const SizedBox.shrink();
        }),
      ]));
  }

  Widget _renderListInline(String key, List items) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(padding: const EdgeInsets.only(top: 4), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(_titleCase(key), style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontFamily: 'monospace')),
      ...items.take(5).map((item) => Padding(padding: const EdgeInsets.only(left: 8, top: 2),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('• ', style: TextStyle(color: _accent, fontSize: 10)),
          Expanded(child: Text(item is Map ? (item['text'] ?? item['description'] ?? item.toString()) : item.toString(),
            style: const TextStyle(color: AppColors.ivory, fontSize: 10, height: 1.3))),
        ]))),
    ]));
  }

  List<Widget> _renderTimingWindows(Map<String, dynamic> timing) {
    final widgets = <Widget>[];
    for (final e in timing.entries) {
      if (e.value is Map) {
        final m = (e.value as Map).cast<String, dynamic>();
        final period = m['period'] ?? m['window'] ?? e.key;
        final score = (m['score'] as num?)?.toDouble() ?? (m['favorability_score'] as num?)?.toDouble();
        final c = (score ?? 0) >= 70 ? AppColors.success : (score ?? 0) >= 50 ? AppColors.gold : AppColors.warning;
        widgets.add(Container(
          margin: const EdgeInsets.only(bottom: 6), padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(8)),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(period.toString(), style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
              if (m['description'] != null || m['reason'] != null)
                Text((m['description'] ?? m['reason']).toString(), style: const TextStyle(color: AppColors.smoke, fontSize: 9, height: 1.3)),
            ])),
            if (score != null) Text('${score.toStringAsFixed(0)}', style: TextStyle(color: c, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'serif')),
          ])));
      } else if (e.value is String && (e.value as String).isNotEmpty && e.key != 'explanation') {
        widgets.add(_kv(_titleCase(e.key), e.value.toString(), AppColors.gold));
      } else if (e.value is List) {
        widgets.add(_renderListInline(e.key, e.value as List));
      }
    }
    return widgets;
  }

  List<Widget> _renderBeejaKshetra(Map<String, dynamic> m) {
    final widgets = <Widget>[];
    for (final e in m.entries) {
      if (e.value is Map) {
        final sub = (e.value as Map).cast<String, dynamic>();
        final score = (sub['strength_score'] as num?)?.toDouble();
        final c = (score ?? 0) >= 70 ? AppColors.success : (score ?? 0) >= 50 ? AppColors.gold : AppColors.warning;
        widgets.add(Container(
          margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: c.withOpacity(0.06), borderRadius: BorderRadius.circular(10), border: Border.all(color: c.withOpacity(0.2))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(_titleCase(e.key), style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w700))),
              if (score != null) Text('${score.toStringAsFixed(0)}/100', style: TextStyle(color: c, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'serif')),
            ]),
            ...sub.entries.where((s) => s.value is String && s.key != 'strength_score').map((s) => Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text('${_titleCase(s.key)}: ${s.value}', style: const TextStyle(color: AppColors.ivory, fontSize: 10, height: 1.3)))),
          ])));
      }
    }
    return widgets;
  }

  List<Widget> _renderGenericMap(Map<String, dynamic> m) {
    final widgets = <Widget>[];
    for (final e in m.entries) {
      if (e.value is num) {
        final v = (e.value as num).toDouble();
        final c = v >= 70 ? AppColors.success : v >= 50 ? AppColors.gold : v >= 30 ? AppColors.warning : AppColors.error;
        widgets.add(Padding(padding: const EdgeInsets.only(bottom: 5), child: Column(children: [
          Row(children: [
            Expanded(child: Text(_titleCase(e.key), style: const TextStyle(color: AppColors.ivory, fontSize: 10))),
            Text(v.toStringAsFixed(v == v.roundToDouble() ? 0 : 1), style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
          ]),
          const SizedBox(height: 2),
          ClipRRect(borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(value: (v / 100).clamp(0, 1), minHeight: 3, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(c))),
        ])));
      } else if (e.value is String && (e.value as String).isNotEmpty) {
        widgets.add(Padding(padding: const EdgeInsets.only(bottom: 4),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(width: 100, child: Text(_titleCase(e.key), style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontFamily: 'monospace'))),
            Expanded(child: Text(e.value.toString(), style: const TextStyle(color: AppColors.ivory, fontSize: 10, height: 1.3))),
          ])));
      } else if (e.value is List) {
        widgets.add(_renderListInline(e.key, e.value as List));
      } else if (e.value is Map) {
        widgets.addAll(_renderGenericMap((e.value as Map).cast<String, dynamic>()));
      }
    }
    return widgets;
  }

  List<Widget> _renderRemedies(Map<String, dynamic> m) {
    final widgets = <Widget>[];
    for (final e in m.entries) {
      if (e.value is List) {
        widgets.add(Padding(padding: const EdgeInsets.only(bottom: 6), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(_titleCase(e.key).toUpperCase(), style: const TextStyle(color: _accent, fontSize: 8, letterSpacing: 1, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          ...(e.value as List).take(5).map((r) => Padding(padding: const EdgeInsets.only(bottom: 3),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('✦ ', style: TextStyle(color: _accent, fontSize: 10)),
              Expanded(child: Text(r is Map ? (r['text'] ?? r['description'] ?? r.toString()) : r.toString(),
                style: const TextStyle(color: AppColors.ivory, fontSize: 10, height: 1.4))),
            ]))),
        ])));
      } else if (e.value is String && (e.value as String).isNotEmpty) {
        widgets.add(_kv(_titleCase(e.key), e.value.toString(), AppColors.lavender));
      }
    }
    return widgets;
  }

  Widget _summaryCard(Map<String, dynamic> s) => Container(
    margin: const EdgeInsets.fromLTRB(16, 12, 16, 8), padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.gold.withOpacity(0.2))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('SUMMARY', style: TextStyle(color: AppColors.gold, fontSize: 8, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      ...s.entries.where((e) => e.value is String && (e.value as String).isNotEmpty).map((e) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(_titleCase(e.key), style: const TextStyle(color: AppColors.gold, fontSize: 9, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(e.value.toString(), style: const TextStyle(color: AppColors.ivory, fontSize: 11, height: 1.4)),
        ]))),
    ]));

  Widget _aiCopyBar(BuildContext ctx) => Container(
    margin: const EdgeInsets.fromLTRB(16, 16, 16, 8), padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [const Color(0xFF1A1642).withOpacity(0.8), const Color(0xFF0A0A24)]),
      borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.gold.withOpacity(0.25))),
    child: Column(children: [
      const Text('DISCUSS WITH AI', style: TextStyle(color: AppColors.gold, fontSize: 9, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
      const SizedBox(height: 12),
      Row(children: [
        _aiBtn(ctx, 'G', 'ChatGPT', const LinearGradient(colors: [Color(0xFF10A37F), Color(0xFF1A7F64)]),
          'Analyze this Vedic astrology Child Probability report and give detailed insights:\n\n'),
        const SizedBox(width: 8),
        _aiBtn(ctx, 'C', 'Claude', const LinearGradient(colors: [Color(0xFFD97757), Color(0xFFB85B3F)]),
          'Here is a Vedic astrology Child Probability report. Analyze it thoroughly and provide actionable insights:\n\n'),
        const SizedBox(width: 8),
        _aiBtn(ctx, '✦', 'Gemini', const LinearGradient(colors: [Color(0xFF4285F4), Color(0xFF9B72CB)]),
          'Review this Child Probability astrology analysis and explain key findings simply:\n\n'),
      ]),
    ]));

  Widget _aiBtn(BuildContext ctx, String icon, String name, Gradient g, String prefix) => Expanded(
    child: GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: prefix + _fmt(data)));
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('Copied for $name!')));
        final urls = {'ChatGPT': 'https://chat.openai.com/', 'Claude': 'https://claude.ai/new', 'Gemini': 'https://gemini.google.com/app'};
        launchUrl(Uri.parse(urls[name]!), mode: LaunchMode.externalApplication).catchError((_) => false);
      },
      child: Container(padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.gold.withOpacity(0.2))),
        child: Column(children: [
          Container(width: 26, height: 26, decoration: BoxDecoration(gradient: g, borderRadius: BorderRadius.circular(8)),
            child: Center(child: Text(icon, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)))),
          const SizedBox(height: 5),
          Text(name, style: const TextStyle(color: AppColors.ivory, fontSize: 9, fontWeight: FontWeight.w700)),
          const Text('COPY', style: TextStyle(color: AppColors.smoke, fontSize: 7, fontFamily: 'monospace')),
        ]))));

  static String _fmt(Map<String, dynamic> d, {int indent = 0}) {
    final buf = StringBuffer();
    final pad = '  ' * indent;
    for (final e in d.entries) {
      if (e.value is Map) { buf.writeln('$pad${_titleCase(e.key)}:'); buf.write(_fmt((e.value as Map).cast<String, dynamic>(), indent: indent + 1)); }
      else if (e.value is List) { buf.writeln('$pad${_titleCase(e.key)}:'); for (var i = 0; i < (e.value as List).length; i++) { final item = (e.value as List)[i]; if (item is Map) { buf.writeln('$pad  ${i+1}.'); buf.write(_fmt(item.cast<String, dynamic>(), indent: indent + 2)); } else { buf.writeln('$pad  ${i+1}. $item'); } } }
      else { buf.writeln('$pad${_titleCase(e.key)}: ${e.value}'); }
    }
    return buf.toString();
  }

  static Map<String, dynamic> _asMap(dynamic v) => v is Map ? v.cast<String, dynamic>() : <String, dynamic>{};
  static String _titleCase(String s) => s.replaceAll('_', ' ').split(' ').map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');
}
