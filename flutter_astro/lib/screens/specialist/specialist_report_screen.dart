import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';

class SpecialistReportScreen extends StatefulWidget {
  final String specialistKey, specialistLabel, specialistEmoji, chartId, chartName;
  final Map<String, dynamic>? preloadedData;

  const SpecialistReportScreen({super.key, required this.specialistKey,
    required this.specialistLabel, required this.specialistEmoji,
    required this.chartId, required this.chartName, this.preloadedData});

  SpecialistReportScreen.fromData({super.key,
    required this.specialistLabel, required this.specialistEmoji,
    required this.chartName, required Map<String, dynamic> data})
      : specialistKey = '', chartId = '', preloadedData = data;

  @override
  State<SpecialistReportScreen> createState() => _SpecialistReportScreenState();
}

class _SpecialistReportScreenState extends State<SpecialistReportScreen> {
  final _api = ApiService();
  Map<String, dynamic>? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.preloadedData != null) {
      _data = widget.preloadedData;
      _loading = false;
    } else {
      _load();
    }
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final resp = await _api.runSpecialist(widget.specialistKey, widget.chartId);
      if (!mounted) return;
      if (resp['statusCode'] == 200 && resp['status'] == 'success') {
        setState(() { _data = (resp['data'] as Map).cast<String, dynamic>(); _loading = false; });
      } else {
        setState(() { _error = resp['detail']?.toString() ?? 'Analysis failed'; _loading = false; });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text('${widget.specialistEmoji} ${widget.specialistLabel}',
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w700)),
          Text(widget.chartName, style: const TextStyle(color: AppColors.primary, fontSize: 11)),
        ]),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _load)],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _error != null
              ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                  const SizedBox(height: 12),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(_error!, style: const TextStyle(color: AppColors.textSecondary), textAlign: TextAlign.center)),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: _load, child: const Text('Retry')),
                ]))
              : _buildReport(),
    );
  }

  Widget _buildReport() {
    if (_data == null) return const SizedBox.shrink();
    final d = _data!;

    // Extract scores (keys ending with _score or _pct or containing "score")
    final scoreEntries = <MapEntry<String, double>>[];
    final sectionEntries = <MapEntry<String, dynamic>>[];
    final metaEntries = <MapEntry<String, String>>[];

    for (final e in d.entries) {
      if (_isSkipKey(e.key)) continue;
      if (e.value is num && _isScoreKey(e.key)) {
        scoreEntries.add(MapEntry(e.key, (e.value as num).toDouble()));
      } else if (e.value is Map) {
        sectionEntries.add(e);
      } else if (e.value is String && e.key != 'disclaimer' && (e.value as String).length < 200) {
        metaEntries.add(MapEntry(e.key, e.value.toString()));
      } else if (e.value is List) {
        sectionEntries.add(e);
      }
    }

    return ListView(padding: const EdgeInsets.all(16), children: [
      // Score cards at top
      if (scoreEntries.isNotEmpty) ...[
        _scoresGrid(scoreEntries),
        const SizedBox(height: 14),
      ],
      // Meta info
      if (metaEntries.isNotEmpty) ...[
        _metaCard(metaEntries),
        const SizedBox(height: 14),
      ],
      // Sections
      ...sectionEntries.map((e) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: e.value is Map
            ? _sectionCard(e.key, (e.value as Map).cast<String, dynamic>())
            : e.value is List
                ? _listCard(e.key, e.value as List)
                : const SizedBox.shrink(),
      )),
      const SizedBox(height: 24),
    ]);
  }

  Widget _scoresGrid(List<MapEntry<String, double>> scores) {
    return Wrap(spacing: 10, runSpacing: 10, children: scores.map((e) {
      final isConfidence = e.key.contains('confidence');
      final raw = e.value;
      final display = isConfidence && raw <= 1.0 ? (raw * 100) : raw;
      final pct = display.clamp(0, 100).toDouble();
      final color = pct >= 70 ? Colors.green : pct >= 45 ? Colors.orange : Colors.red;
      final label = _formatKey(e.key);
      return Container(
        width: (MediaQuery.of(context).size.width - 52) / 2,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color.withOpacity(0.12), color.withOpacity(0.03)]),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600),
              maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Row(children: [
            Text('${pct.toStringAsFixed(0)}', style: TextStyle(color: color, fontSize: 26, fontWeight: FontWeight.w700)),
            Text(isConfidence ? '%' : '', style: TextStyle(color: color.withOpacity(0.6), fontSize: 12)),
          ]),
          const SizedBox(height: 4),
          ClipRRect(borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(value: pct / 100, minHeight: 4,
              backgroundColor: Colors.white12, valueColor: AlwaysStoppedAnimation(color))),
        ]),
      );
    }).toList());
  }

  Widget _metaCard(List<MapEntry<String, String>> entries) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12)),
      child: Wrap(spacing: 12, runSpacing: 8, children: entries.take(8).map((e) {
        return Row(mainAxisSize: MainAxisSize.min, children: [
          Text('${_formatKey(e.key)}: ', style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
          Flexible(child: Text(e.value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 11, fontWeight: FontWeight.w600),
              maxLines: 1, overflow: TextOverflow.ellipsis)),
        ]);
      }).toList()),
    );
  }

  Widget _sectionCard(String key, Map<String, dynamic> section) {
    final label = _formatKey(key);
    final scores = <String, double>{};
    final texts = <String, String>{};
    final lists = <String, List>{};
    final nested = <String, Map>{};

    for (final e in section.entries) {
      if (e.value is num && _isScoreKey(e.key)) {
        double v = (e.value as num).toDouble();
        if (e.key.contains('confidence') && v <= 1.0) v = v * 100;
        scores[e.key] = v;
      } else if (e.value is String && (e.value as String).isNotEmpty) {
        texts[e.key] = e.value.toString();
      } else if (e.value is List) {
        lists[e.key] = e.value as List;
      } else if (e.value is Map) {
        nested[e.key] = (e.value as Map).cast<String, dynamic>();
      }
    }

    return _ExpandableSection(
      label: label,
      scores: scores,
      texts: texts,
      lists: lists,
      nested: nested,
    );
  }

  Widget _listCard(String key, List items) {
    if (items.isEmpty) return const SizedBox.shrink();
    final label = _formatKey(key);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        ...items.take(10).map<Widget>((item) {
          if (item is Map) {
            return Padding(padding: const EdgeInsets.only(bottom: 6),
              child: _renderMapItem(item.cast<String, dynamic>()));
          }
          return Padding(padding: const EdgeInsets.only(bottom: 3),
            child: Text('• $item', style: const TextStyle(color: AppColors.textPrimary, fontSize: 11)));
        }),
      ]),
    );
  }

  Widget _renderMapItem(Map<String, dynamic> item) {
    final scores = <String, double>{};
    final texts = <String, String>{};
    for (final e in item.entries) {
      if (e.value is num && _isScoreKey(e.key)) {
        double v = (e.value as num).toDouble();
        if (e.key.contains('confidence') && v <= 1.0) v = v * 100;
        scores[e.key] = v;
      } else if (e.value is String) {
        texts[e.key] = e.value.toString();
      }
    }
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(8)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (scores.isNotEmpty) Wrap(spacing: 12, children: scores.entries.take(3).map((e) {
          final c = e.value >= 70 ? Colors.green : e.value >= 45 ? Colors.orange : Colors.red;
          return Text('${_formatKey(e.key)}: ${e.value.toStringAsFixed(0)}%',
              style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w600));
        }).toList()),
        ...texts.entries.take(4).map((e) => Text('${_formatKey(e.key)}: ${e.value}',
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 10), maxLines: 2, overflow: TextOverflow.ellipsis)),
      ]),
    );
  }

  static String _formatKey(String key) => key
      .replaceAll('_', ' ')
      .split(' ')
      .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');

  static bool _isScoreKey(String k) =>
      k.endsWith('_score') || k.endsWith('_pct') || k.endsWith('_percentage') ||
      k.contains('confidence') || k.contains('probability') || k.contains('_index');

  static bool _isSkipKey(String k) => const {
    'version', 'disclaimer', 'domain', '_schema_valid', '_schema_violations',
    'computation_errors', 'name',
  }.contains(k);
}

class _ExpandableSection extends StatefulWidget {
  final String label;
  final Map<String, double> scores;
  final Map<String, String> texts;
  final Map<String, List> lists;
  final Map<String, Map> nested;
  const _ExpandableSection({required this.label, required this.scores,
    required this.texts, required this.lists, required this.nested});

  @override
  State<_ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<_ExpandableSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final hasContent = widget.scores.isNotEmpty || widget.texts.isNotEmpty ||
        widget.lists.isNotEmpty || widget.nested.isNotEmpty;
    if (!hasContent) return const SizedBox.shrink();

    final topScore = widget.scores.isNotEmpty
        ? widget.scores.values.reduce((a, b) => a > b ? a : b) : null;
    final headerColor = topScore != null
        ? (topScore >= 70 ? Colors.green : topScore >= 45 ? Colors.orange : Colors.red)
        : AppColors.primary;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [headerColor.withOpacity(0.08), headerColor.withOpacity(0.02)]),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: headerColor.withOpacity(0.2)),
      ),
      child: Column(children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: BorderRadius.circular(12),
          child: Padding(padding: const EdgeInsets.all(12), child: Row(children: [
            Expanded(child: Text(widget.label,
                style: TextStyle(color: headerColor, fontSize: 13, fontWeight: FontWeight.w700))),
            if (topScore != null) Text('${topScore.toStringAsFixed(0)}',
                style: TextStyle(color: headerColor, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(width: 4),
            Icon(_expanded ? Icons.expand_less : Icons.expand_more, color: AppColors.textSecondary, size: 20),
          ])),
        ),
        if (_expanded) ...[
          const Divider(color: Colors.white12, height: 1),
          Padding(padding: const EdgeInsets.fromLTRB(12, 8, 12, 12), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Scores
              if (widget.scores.isNotEmpty) ...widget.scores.entries.map((e) {
                final v = e.value.clamp(0, 100).toDouble();
                final c = v >= 70 ? Colors.green : v >= 45 ? Colors.orange : Colors.red;
                return Padding(padding: const EdgeInsets.only(bottom: 6), child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(child: Text(_SpecialistReportScreenState._formatKey(e.key),
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 11))),
                      Text('${v.toStringAsFixed(0)}%', style: TextStyle(color: c, fontSize: 13, fontWeight: FontWeight.w700)),
                    ]),
                    ClipRRect(borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(value: v / 100, minHeight: 3,
                        backgroundColor: Colors.white12, valueColor: AlwaysStoppedAnimation(c))),
                  ],
                ));
              }),
              // Texts
              if (widget.texts.isNotEmpty) ...widget.texts.entries.take(8).map((e) =>
                  Padding(padding: const EdgeInsets.only(bottom: 4),
                    child: RichText(text: TextSpan(children: [
                      TextSpan(text: '${_SpecialistReportScreenState._formatKey(e.key)}: ',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w600)),
                      TextSpan(text: e.value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 10)),
                    ])))),
              // Lists
              if (widget.lists.isNotEmpty) ...widget.lists.entries.map((e) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(_SpecialistReportScreenState._formatKey(e.key),
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w600)),
                  ...(e.value).take(5).map<Widget>((item) => Padding(
                    padding: const EdgeInsets.only(left: 8, top: 2),
                    child: Text('• ${item.toString()}', style: const TextStyle(color: AppColors.textPrimary, fontSize: 10),
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                  )),
                ],
              )),
            ],
          )),
        ],
      ]),
    );
  }
}
