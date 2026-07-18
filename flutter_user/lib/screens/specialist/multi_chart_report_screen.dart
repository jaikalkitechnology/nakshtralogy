import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';
import '../../l10n/gen/app_localizations.dart';
import 'report_components.dart';

class MultiChartReportScreen extends StatelessWidget {
  final String specialistKey;
  final String specialistLabel;
  final Map<String, dynamic> data;
  final List<String> participants;

  const MultiChartReportScreen({
    super.key,
    required this.specialistKey,
    required this.specialistLabel,
    required this.data,
    required this.participants,
  });

  // ── Theme accent per report type ──
  Color get _accent {
    switch (specialistKey) {
      case 'child_probability':
        return const Color(0xFFE8689C);
      case 'love_compatibility':
        return const Color(0xFFE85B8A);
      case 'karma_linkage':
        return AppColors.lavender;
      default:
        return AppColors.gold;
    }
  }

  String get _emoji {
    switch (specialistKey) {
      case 'child_probability':
        return '\u{1F476}'; // baby
      case 'love_compatibility':
        return '\u{1F49E}'; // revolving hearts
      case 'karma_linkage':
        return '\u{1F52E}'; // crystal ball
      default:
        return '\u{2728}';
    }
  }

  String _titlePrefix(AppLocalizations l) {
    switch (specialistKey) {
      case 'child_probability':
        return l.multiChartTitleChild;
      case 'love_compatibility':
        return l.multiChartTitleLove;
      case 'karma_linkage':
        return l.multiChartTitleKarma;
      default:
        return l.multiChartTitleDefault;
    }
  }

  String _titleSuffix(AppLocalizations l) {
    switch (specialistKey) {
      case 'child_probability':
        return l.multiChartSuffixProbability;
      case 'love_compatibility':
        return l.multiChartSuffixCompatibility;
      case 'karma_linkage':
        return l.multiChartSuffixLinkage;
      default:
        return l.multiChartSuffixReport;
    }
  }

  static const _skip = {
    'version', 'disclaimer', 'domain', '_schema_valid', '_schema_violations',
    'computation_errors', 'intelligence_disclaimer', 'chart_count',
  };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A24),
      body: CustomScrollView(slivers: [
        // ── App bar ──
        SliverAppBar(
          backgroundColor: const Color(0xFF0A0A24),
          pinned: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.ivory),
            onPressed: () => Navigator.pop(context),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                participants.join(' & ').toUpperCase(),
                style: const TextStyle(color: AppColors.gold, fontSize: 9, letterSpacing: 1.5, fontFamily: 'monospace'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text.rich(TextSpan(children: [
                TextSpan(text: '${_titlePrefix(l)} ', style: const TextStyle(color: AppColors.ivory, fontSize: 18, fontWeight: FontWeight.w600)),
                TextSpan(text: _titleSuffix(l), style: const TextStyle(color: AppColors.gold, fontSize: 18, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500)),
              ])),
            ],
          ),
          centerTitle: true,
        ),
        // ── Body ──
        SliverList(delegate: SliverChildListDelegate([
          _heroScoreSection(l),
          _participantsBar(l),
          ..._buildSections(l),
          _aiBar(context),
          const SizedBox(height: 40),
        ])),
      ]),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  HERO SCORE
  // ═══════════════════════════════════════════════════════════════════
  Widget _heroScoreSection(AppLocalizations l) {
    // Extract top-level numeric scores
    final scores = <String, double>{};
    for (final e in data.entries) {
      if (_skip.contains(e.key)) continue;
      if (e.value is num && _isScore(e.key)) {
        double v = (e.value as num).toDouble();
        if (e.key.contains('confidence') && v <= 1.0) v *= 100;
        scores[e.key] = v;
      }
    }
    if (scores.isEmpty) return const SizedBox.shrink();

    final sorted = scores.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final topRings = sorted.take(3).toList();
    final extra = sorted.skip(3).take(4).toList();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [_accent.withOpacity(0.12), const Color(0xFF4A3B8C).withOpacity(0.15)]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _accent.withOpacity(0.3)),
      ),
      child: Column(children: [
        _label('$_emoji ${specialistLabel.toUpperCase()}'),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: topRings.map((e) {
            final c = e.value >= 70 ? AppColors.success : e.value >= 50 ? AppColors.gold : AppColors.warning;
            return ScoreRing(e.value, _shortLabel(e.key), c);
          }).toList(),
        ),
        if (extra.isNotEmpty) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(border: Border(top: BorderSide(color: _accent.withOpacity(0.2), width: 0.5))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: extra.map((e) => Column(children: [
                Text(e.value.toStringAsFixed(0), style: TextStyle(color: _accent, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'serif')),
                Text(_shortLabel(e.key), style: const TextStyle(color: AppColors.smoke, fontSize: 7, letterSpacing: 1, fontFamily: 'monospace')),
              ])).toList(),
            ),
          ),
        ],
      ]),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  PARTICIPANTS BAR
  // ═══════════════════════════════════════════════════════════════════
  Widget _participantsBar(AppLocalizations l) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1642).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _accent.withOpacity(0.2)),
      ),
      child: Row(children: [
        Text(l.multiChartParticipantsLabel, style: TextStyle(color: _accent, fontSize: 8, letterSpacing: 1.5, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
        const Spacer(),
        ...participants.asMap().entries.map((e) => Padding(
          padding: EdgeInsets.only(left: e.key > 0 ? 8 : 0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: _accent.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
            child: Text(e.value, style: TextStyle(color: _accent, fontSize: 10, fontWeight: FontWeight.w600)),
          ),
        )),
      ]),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  BUILD ALL SECTIONS
  // ═══════════════════════════════════════════════════════════════════
  List<Widget> _buildSections(AppLocalizations l) {
    final widgets = <Widget>[];
    final summaryTexts = <String, String>{};
    final confScore = data['confidence_score'];
    final confBreakdown = data['confidence_breakdown'];
    final confStatement = data['plain_statement'] ?? data['confidence_explanation'];

    for (final e in data.entries) {
      if (_skip.contains(e.key)) continue;
      // Top-level nums already in hero
      if (e.value is num) continue;

      if (e.value is String && (e.value as String).isNotEmpty) {
        summaryTexts[e.key] = e.value as String;
      } else if (e.value is Map && (e.value as Map).isNotEmpty) {
        widgets.add(_CollapsibleSection(
          title: titleCase(e.key),
          accent: _accent,
          child: _renderMap((e.value as Map).cast<String, dynamic>()),
        ));
      } else if (e.value is List && (e.value as List).isNotEmpty) {
        widgets.add(_CollapsibleSection(
          title: '${titleCase(e.key)} (${(e.value as List).length})',
          accent: _accent,
          child: _renderList(e.value as List),
        ));
      }
    }

    // Insert summary texts at the top
    if (summaryTexts.isNotEmpty) {
      widgets.insert(0, _summaryBlock(summaryTexts));
    }

    // Add confidence at the end
    if (confScore != null && confScore is num) {
      widgets.add(ReportHeader(l.multiChartAnalysisWord, l.multiChartConfidenceSuffix, l.multiChartQualityBadge));
      widgets.add(ConfidenceBlock(
        score: confScore.toDouble(),
        statement: confStatement?.toString(),
        breakdown: (confBreakdown is Map) ? confBreakdown.cast<String, dynamic>() : {},
      ));
    }

    return widgets;
  }

  // ── Summary texts block ──
  Widget _summaryBlock(Map<String, String> texts) {
    final important = texts.entries.where((e) => _isSummaryKey(e.key) || e.value.length >= 60).toList();
    final meta = texts.entries.where((e) => !_isSummaryKey(e.key) && e.value.length < 60).toList();

    return Column(children: [
      if (important.isNotEmpty)
        Container(
          margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.gold.withOpacity(0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.gold.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: important.take(4).map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(titleCase(e.key).toUpperCase(), style: const TextStyle(
                  color: AppColors.gold, fontSize: 8, letterSpacing: 1.5, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(e.value, style: const TextStyle(color: AppColors.ivory, fontSize: 12, height: 1.5)),
              ]),
            )).toList(),
          ),
        ),
      if (meta.isNotEmpty)
        Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(10)),
          child: Wrap(spacing: 12, runSpacing: 6, children: meta.take(8).map((e) =>
            Row(mainAxisSize: MainAxisSize.min, children: [
              Text('${titleCase(e.key)}: ', style: const TextStyle(color: AppColors.smoke, fontSize: 9)),
              Flexible(child: Text(e.value, style: const TextStyle(color: AppColors.gold, fontSize: 10, fontWeight: FontWeight.w600),
                maxLines: 1, overflow: TextOverflow.ellipsis)),
            ])).toList(),
          ),
        ),
    ]);
  }

  // ── Render a Map recursively ──
  Widget _renderMap(Map<String, dynamic> map) {
    final children = <Widget>[];
    for (final e in map.entries) {
      if (e.value is num) {
        final v = (e.value as num).toDouble();
        final clamped = v.clamp(0.0, 100.0);
        final c = v >= 70 ? AppColors.success : v >= 45 ? AppColors.gold : v >= 25 ? const Color(0xFFE5A93A) : AppColors.error;
        children.add(Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Flexible(child: Text(titleCase(e.key), style: const TextStyle(color: AppColors.ivory, fontSize: 10))),
              Text(v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1),
                style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
            ]),
            if (_isScore(e.key)) ...[
              const SizedBox(height: 3),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: clamped / 100, minHeight: 3,
                  backgroundColor: Colors.white.withOpacity(0.06), valueColor: AlwaysStoppedAnimation(c)),
              ),
            ],
          ]),
        ));
      } else if (e.value is String && (e.value as String).isNotEmpty) {
        children.add(Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(titleCase(e.key), style: const TextStyle(color: AppColors.smoke, fontSize: 9, fontFamily: 'monospace')),
            const SizedBox(height: 2),
            Text(e.value as String, style: const TextStyle(color: AppColors.ivory, fontSize: 11, height: 1.4),
              maxLines: 6, overflow: TextOverflow.ellipsis),
          ]),
        ));
      } else if (e.value is Map && (e.value as Map).isNotEmpty) {
        children.add(_NestedSection(
          title: titleCase(e.key),
          child: _renderMap((e.value as Map).cast<String, dynamic>()),
        ));
      } else if (e.value is List && (e.value as List).isNotEmpty) {
        children.add(_NestedSection(
          title: '${titleCase(e.key)} (${(e.value as List).length})',
          child: _renderList(e.value as List),
        ));
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1642).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  // ── Render a List ──
  Widget _renderList(List items) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1642).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.asMap().entries.take(20).map<Widget>((entry) {
          final i = entry.key;
          final item = entry.value;
          if (item is Map) {
            return _mapTile(i + 1, item.cast<String, dynamic>());
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${i + 1}. ', style: TextStyle(color: _accent, fontSize: 10, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
              Expanded(child: Text('$item', style: const TextStyle(color: AppColors.ivory, fontSize: 11, height: 1.4))),
            ]),
          );
        }).toList(),
      ),
    );
  }

  Widget _mapTile(int idx, Map<String, dynamic> item) {
    final title = item['name'] ?? item['factor'] ?? item['type'] ?? item['planet'] ?? item['category'] ?? item['title'] ?? '';
    final desc = item['description'] ?? item['advice'] ?? item['text'] ?? item['note'] ?? item['explanation'] ?? '';
    final score = item.entries.where((e) => e.value is num && _isScore(e.key)).map((e) => (e.value as num).toDouble()).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(8)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('$idx. ', style: TextStyle(color: _accent, fontSize: 10, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
          if (title.toString().isNotEmpty)
            Expanded(child: Text(title.toString(), style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'serif'))),
          if (score.isNotEmpty)
            Text('${score.first.clamp(0, 100).toStringAsFixed(0)}%',
              style: TextStyle(
                color: score.first >= 65 ? AppColors.success : score.first >= 40 ? AppColors.gold : AppColors.error,
                fontSize: 12, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
        ]),
        if (desc.toString().isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 3, left: 20),
            child: Text(desc.toString(), style: const TextStyle(color: AppColors.ivory, fontSize: 10, height: 1.4),
              maxLines: 4, overflow: TextOverflow.ellipsis),
          ),
      ]),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  AI COPY BAR
  // ═══════════════════════════════════════════════════════════════════
  Widget _aiBar(BuildContext ctx) {
    final l = AppLocalizations.of(ctx)!;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [const Color(0xFF1A1642).withOpacity(0.8), const Color(0xFF0A0A24)]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withOpacity(0.25)),
      ),
      child: Column(children: [
        _label(l.discussReportWithAI),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _aiCopyBtn(ctx, 'G', 'ChatGPT',
            const LinearGradient(colors: [Color(0xFF10A37F), Color(0xFF1A7F64)]),
            'chatgpt')),
          const SizedBox(width: 8),
          Expanded(child: _aiCopyBtn(ctx, 'C', 'Claude',
            const LinearGradient(colors: [Color(0xFFD97757), Color(0xFFB85B3F)]),
            'claude')),
          const SizedBox(width: 8),
          Expanded(child: _aiCopyBtn(ctx, '\u{2726}', 'Gemini',
            const LinearGradient(colors: [Color(0xFF4285F4), Color(0xFF9B72CB)]),
            'gemini')),
        ]),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: _formatDataAsText(data)));
            ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(l.reportCopied)));
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(10)),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.copy, size: 14, color: AppColors.smoke),
              const SizedBox(width: 6),
              Text(l.copyFullReport, style: const TextStyle(color: AppColors.smoke, fontSize: 10)),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _aiCopyBtn(BuildContext ctx, String icon, String name, Gradient g, String ai) {
    final l = AppLocalizations.of(ctx)!;
    return GestureDetector(
      onTap: () => _copyForAi(ctx, ai),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.gold.withOpacity(0.2)),
        ),
        child: Column(children: [
          Container(
            width: 26, height: 26,
            decoration: BoxDecoration(gradient: g, borderRadius: BorderRadius.circular(8)),
            child: Center(child: Text(icon, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))),
          ),
          const SizedBox(height: 5),
          Text(name, style: const TextStyle(color: AppColors.ivory, fontSize: 9, fontWeight: FontWeight.w700)),
          Text(l.copy, style: const TextStyle(color: AppColors.smoke, fontSize: 7, fontFamily: 'monospace')),
        ]),
      ),
    );
  }

  void _copyForAi(BuildContext ctx, String ai) {
    final l = AppLocalizations.of(ctx)!;
    final formatted = _formatDataAsText(data);
    String prompt;
    String label;
    switch (ai) {
      case 'chatgpt':
        prompt = l.multiChartPromptChatgpt(formatted);
        label = 'ChatGPT';
        break;
      case 'claude':
        prompt = l.multiChartPromptClaude(formatted);
        label = 'Claude';
        break;
      case 'gemini':
        prompt = l.multiChartPromptGemini(formatted);
        label = 'Gemini';
        break;
      default:
        prompt = formatted;
        label = 'AI';
    }
    Clipboard.setData(ClipboardData(text: prompt));
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(l.multiChartCopiedForLabel(label))));

    // Try to launch the AI app
    final urls = {'chatgpt': 'https://chat.openai.com/', 'claude': 'https://claude.ai/new', 'gemini': 'https://gemini.google.com/app'};
    final uri = Uri.parse(urls[ai] ?? '');
    launchUrl(uri, mode: LaunchMode.externalApplication).catchError((_) => false);
  }

  // ── Format data recursively as readable text ──
  static String _formatDataAsText(Map<String, dynamic> data, {int indent = 0}) {
    final buf = StringBuffer();
    final pad = '  ' * indent;
    for (final e in data.entries) {
      if (e.value is Map) {
        buf.writeln('$pad${titleCase(e.key)}:');
        buf.write(_formatDataAsText((e.value as Map).cast<String, dynamic>(), indent: indent + 1));
      } else if (e.value is List) {
        buf.writeln('$pad${titleCase(e.key)}:');
        for (var i = 0; i < (e.value as List).length; i++) {
          final item = (e.value as List)[i];
          if (item is Map) {
            buf.writeln('$pad  ${i + 1}.');
            buf.write(_formatDataAsText(item.cast<String, dynamic>(), indent: indent + 2));
          } else {
            buf.writeln('$pad  ${i + 1}. $item');
          }
        }
      } else {
        buf.writeln('$pad${titleCase(e.key)}: ${e.value}');
      }
    }
    return buf.toString();
  }

  // ── Helpers ──
  Widget _label(String text) => Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    Container(width: 16, height: 1, color: AppColors.gold.withOpacity(0.4)),
    const SizedBox(width: 6),
    Text(text, style: const TextStyle(color: AppColors.gold, fontSize: 9, letterSpacing: 2, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
    const SizedBox(width: 6),
    Container(width: 16, height: 1, color: AppColors.gold.withOpacity(0.4)),
  ]);

  static bool _isScore(String k) => k.endsWith('_score') || k.endsWith('_pct') || k.endsWith('_percentage')
      || k.contains('confidence') || k.contains('probability') || k.contains('_index');

  static bool _isSummaryKey(String k) => const {
    'human_summary', 'actionable_advice', 'human_readable', 'one_liner_advice',
    'advice', 'core_theme', 'verdict', 'overall_verdict', 'recommendation',
    'primary_direction', 'soul_career_integration_strategy',
  }.contains(k);

  static String _shortLabel(String key) {
    return key.replaceAll('_score', '').replaceAll('_pct', '').replaceAll('overall_', '')
        .replaceAll('_percentage', '').toUpperCase().replaceAll('_', '\n');
  }
}

// ═══════════════════════════════════════════════════════════════════
//  Collapsible section card (top-level)
// ═══════════════════════════════════════════════════════════════════
class _CollapsibleSection extends StatefulWidget {
  final String title;
  final Color accent;
  final Widget child;
  const _CollapsibleSection({required this.title, required this.accent, required this.child});

  @override
  State<_CollapsibleSection> createState() => _CollapsibleSectionState();
}

class _CollapsibleSectionState extends State<_CollapsibleSection> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      InkWell(
        onTap: () => setState(() => _open = !_open),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: widget.accent.withOpacity(0.1))),
          ),
          child: Row(children: [
            Container(
              width: 4, height: 20,
              decoration: BoxDecoration(color: widget.accent, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(widget.title, style: TextStyle(
                color: widget.accent, fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'serif')),
            ),
            Icon(_open ? Icons.expand_less : Icons.expand_more, color: AppColors.smoke, size: 20),
          ]),
        ),
      ),
      if (_open) Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: widget.child,
      ),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════════
//  Nested subsection (inside a map)
// ═══════════════════════════════════════════════════════════════════
class _NestedSection extends StatefulWidget {
  final String title;
  final Widget child;
  const _NestedSection({required this.title, required this.child});

  @override
  State<_NestedSection> createState() => _NestedSectionState();
}

class _NestedSectionState extends State<_NestedSection> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      GestureDetector(
        onTap: () => setState(() => _open = !_open),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(children: [
            Expanded(child: Text(widget.title, style: const TextStyle(
              color: AppColors.lavender, fontSize: 11, fontWeight: FontWeight.w600))),
            Icon(_open ? Icons.expand_less : Icons.expand_more, color: AppColors.smoke, size: 16),
          ]),
        ),
      ),
      if (_open) widget.child,
    ]);
  }
}
