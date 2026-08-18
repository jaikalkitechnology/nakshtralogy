import 'package:flutter/material.dart';
import 'package:hj_core/hj_core.dart';

import 'cosmic_labels.dart';

/// Premium, recursive viewer for the COMPLETE Cosmic Services response.
///
/// The backend now returns the entire (localized) dev-API payload under
/// `data['full_response']`; this page renders every section of that arbitrarily
/// nested JSON as collapsible cards with clean key/value rows, chips and
/// sub-cards — so the user sees the full report, not just the curated tabs.
///
/// Push it with:
/// ```dart
/// Navigator.of(context).push(CosmicFullReportPage.route(title, full));
/// ```
class CosmicFullReportPage extends StatefulWidget {
  const CosmicFullReportPage({super.key, required this.title, required this.data});

  final String title;
  final Map<String, dynamic> data;

  static Route<void> route(String title, Map<String, dynamic> data) =>
      MaterialPageRoute<void>(
        builder: (_) => CosmicFullReportPage(title: title, data: data),
      );

  @override
  State<CosmicFullReportPage> createState() => _CosmicFullReportPageState();
}

class _CosmicFullReportPageState extends State<CosmicFullReportPage> {
  // Per-section expanded state, keyed by the section key. Defaults to expanded
  // so the "complete response" is visible on open.
  final Map<String, bool> _expanded = {};
  bool _allExpanded = true;

  static const _overviewKey = '__overview__';

  /// Top-level sections in render order: a single grouped "Overview" card for
  /// all top-level scalar fields (so a 180-field flat report isn't 180 cards),
  /// followed by one card per nested (map/list) section.
  List<MapEntry<String, dynamic>> get _sections {
    final scalars = <MapEntry<String, dynamic>>[];
    final complex = <MapEntry<String, dynamic>>[];
    for (final e in widget.data.entries) {
      if (_isBlank(e.value)) continue;
      if (e.value is Map || e.value is List) {
        complex.add(e);
      } else {
        scalars.add(e);
      }
    }
    return [
      if (scalars.isNotEmpty)
        MapEntry<String, dynamic>(
            _overviewKey, Map<String, dynamic>.fromEntries(scalars)),
      ...complex,
    ];
  }

  void _toggleAll() {
    setState(() {
      _allExpanded = !_allExpanded;
      for (final e in _sections) {
        _expanded[e.key] = _allExpanded;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final sections = _sections;

    return Scaffold(
      backgroundColor: AppColors.indigoVoid,
      appBar: AppBar(
        backgroundColor: AppColors.indigoDeep,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(cosmicUi('title', lang),
                style: AppTextStyles.heading(size: 18)),
            Text(cosmicUi('subtitle', lang),
                style: AppTextStyles.label(size: 11, color: AppColors.ivoryFaint)),
          ],
        ),
        actions: [
          if (sections.isNotEmpty)
            TextButton.icon(
              onPressed: _toggleAll,
              icon: Icon(
                _allExpanded ? Icons.unfold_less : Icons.unfold_more,
                size: 18,
                color: AppColors.copperLight,
              ),
              label: Text(
                cosmicUi(_allExpanded ? 'collapse_all' : 'expand_all', lang),
                style: AppTextStyles.label(size: 12, color: AppColors.copperLight),
              ),
            ),
        ],
      ),
      body: sections.isEmpty
          ? Center(
              child: Text(cosmicUi('empty', lang),
                  style: AppTextStyles.body(size: 14, color: AppColors.ivoryDim)),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 32),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 10),
                  child: Text(widget.title,
                      style: AppTextStyles.body(size: 13, color: AppColors.ivoryDim)),
                ),
                for (final e in sections)
                  _SectionCard(
                    sectionKey: e.key,
                    value: e.value,
                    lang: lang,
                    expanded: _expanded[e.key] ?? _allExpanded,
                    onToggle: () => setState(() =>
                        _expanded[e.key] = !(_expanded[e.key] ?? _allExpanded)),
                  ),
              ],
            ),
    );
  }
}

// ── Top-level collapsible section ────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.sectionKey,
    required this.value,
    required this.lang,
    required this.expanded,
    required this.onToggle,
  });

  final String sectionKey;
  final dynamic value;
  final String lang;
  final bool expanded;
  final VoidCallback onToggle;

  bool get _isOverview => sectionKey == '__overview__';

  @override
  Widget build(BuildContext context) {
    final label =
        _isOverview ? cosmicUi('overview', lang) : cosmicLabel(sectionKey, lang);
    final icon = _isOverview ? Icons.summarize_outlined : _iconFor(sectionKey);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.indigoDeep,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.copperGlow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon,
                        size: 18, color: AppColors.copperLight),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(label,
                        style: AppTextStyles.body(
                            size: 15, weight: FontWeight.w700, color: AppColors.ivory)),
                  ),
                  Icon(expanded ? Icons.expand_less : Icons.expand_more,
                      color: AppColors.ivoryFaint),
                ],
              ),
            ),
          ),
          if (expanded) ...[
            Divider(height: 1, color: AppColors.borderSoft),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _renderValue(value, lang, 0),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Recursive renderers ──────────────────────────────────────────────────────

/// Render any JSON value into a list of widgets (used for a section body or a
/// nested map). `depth` drives left indentation for hierarchy.
List<Widget> _renderValue(dynamic value, String lang, int depth) {
  if (value is Map) {
    final entries =
        value.entries.where((e) => !_isBlank(e.value)).toList();
    return [for (final e in entries) _entry('${e.key}', e.value, lang, depth)];
  }
  if (value is List) {
    return [_list(value, lang, depth)];
  }
  // bare scalar section
  return [_scalarLine(value, lang)];
}

/// One key → value entry inside a map.
Widget _entry(String key, dynamic v, String lang, int depth) {
  final label = cosmicLabel(key, lang);

  // nested map → grouped block with an accent rail + header
  if (v is Map) {
    final entries = v.entries.where((e) => !_isBlank(e.value)).toList();
    if (entries.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        margin: const EdgeInsets.only(top: 4),
        padding: const EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: AppColors.borderMid, width: 2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(label,
                  style: AppTextStyles.label(size: 12.5, color: AppColors.copperLight)),
            ),
            for (final e in entries) _entry('${e.key}', e.value, lang, depth + 1),
          ],
        ),
      ),
    );
  }

  // list value
  if (v is List) {
    if (v.where((e) => !_isBlank(e)).isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(label,
                style: AppTextStyles.label(size: 12.5, color: AppColors.copperLight)),
          ),
          _list(v, lang, depth + 1),
        ],
      ),
    );
  }

  // scalar → key/value row
  return _kvRow(label, v, lang);
}

/// A list: scalars → chips; maps → numbered sub-cards.
Widget _list(List value, String lang, int depth) {
  final items = value.where((e) => !_isBlank(e)).toList();
  if (items.isEmpty) return const SizedBox.shrink();

  final allScalar = items.every((e) => e is! Map && e is! List);
  if (allScalar) {
    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 4),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final e in items)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surface2,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderSoft),
              ),
              child: Text(_fmtScalar(e, lang),
                  style: AppTextStyles.body(size: 13, color: AppColors.ivoryDim)),
            ),
        ],
      ),
    );
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (var i = 0; i < items.length; i++) _listItem(items[i], i, lang, depth),
    ],
  );
}

Widget _listItem(dynamic item, int index, String lang, int depth) {
  if (item is Map) {
    final (header, headerKey) = _itemHeader(item, lang);
    final entries = item.entries
        .where((e) => !_isBlank(e.value) && e.key != headerKey)
        .toList();
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface1,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.goldGlow,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('${index + 1}',
                    style: AppTextStyles.label(size: 11, color: AppColors.gold)),
              ),
              const SizedBox(width: 8),
              if (header != null)
                Expanded(
                  child: Text(header,
                      style: AppTextStyles.body(
                          size: 13.5, weight: FontWeight.w700, color: AppColors.ivory)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          for (final e in entries) _entry('${e.key}', e.value, lang, depth + 1),
        ],
      ),
    );
  }
  if (item is List) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: _list(item, lang, depth + 1),
    );
  }
  return _scalarLine(item, lang);
}

const _headerKeys = ['name', 'title', 'gun', 'rashi', 'planet', 'label', 'house'];

/// Picks a display header for a list-item map (so it isn't repeated in the
/// body). Returns the formatted header and the key it came from (to skip).
(String?, String?) _itemHeader(Map item, String lang) {
  for (final k in _headerKeys) {
    final v = item[k];
    if (v != null && '$v'.trim().isNotEmpty) {
      return (_fmtScalar(v, lang), k);
    }
  }
  return (null, null);
}

// ── Leaf widgets ─────────────────────────────────────────────────────────────

Widget _kvRow(String label, dynamic value, String lang) {
  final Widget valueWidget = value is bool
      ? _boolPill(value, lang)
      : Text(_fmtScalar(value, lang),
          textAlign: TextAlign.right,
          style: AppTextStyles.body(size: 13.5, color: AppColors.ivory));
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Text(label,
              style: AppTextStyles.body(size: 13, color: AppColors.ivoryDim)),
        ),
        const SizedBox(width: 12),
        Expanded(flex: 6, child: Align(alignment: Alignment.centerRight, child: valueWidget)),
      ],
    ),
  );
}

Widget _scalarLine(dynamic value, String lang) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(_fmtScalar(value, lang),
          style: AppTextStyles.body(size: 13.5, color: AppColors.ivory)),
    );

Widget _boolPill(bool v, String lang) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: v ? const Color(0x2634D399) : AppColors.surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: v ? AppColors.success : AppColors.borderSoft),
      ),
      child: Text(cosmicUi(v ? 'yes' : 'no', lang),
          style: AppTextStyles.label(
              size: 12, color: v ? AppColors.success : AppColors.ivoryDim)),
    );

// ── helpers ──────────────────────────────────────────────────────────────────

bool _isBlank(dynamic v) {
  if (v == null) return true;
  if (v is String) return v.trim().isEmpty;
  if (v is List) return v.where((e) => !_isBlank(e)).isEmpty;
  if (v is Map) return v.values.where((e) => !_isBlank(e)).isEmpty;
  return false;
}

String _fmtScalar(dynamic v, String lang) {
  if (v == null) return '—';
  if (v is bool) return cosmicUi(v ? 'yes' : 'no', lang);
  if (v is num) {
    final d = v.toDouble();
    return d == d.roundToDouble() ? '${d.round()}' : d.toStringAsFixed(2);
  }
  return '$v';
}

IconData _iconFor(String key) {
  switch (key) {
    case 'chart':
    case 'divisionals':
      return Icons.grid_on;
    case 'planets':
    case 'planet_strength':
    case 'shadbala':
      return Icons.public;
    case 'lagna':
      return Icons.explore;
    case 'vimshottari':
    case 'dasha_activation':
      return Icons.timeline;
    case 'dosh_analysis':
      return Icons.warning_amber;
    case 'yoga_analysis':
      return Icons.auto_awesome;
    case 'ashtakavarga':
      return Icons.calculate;
    case 'aspect_matrix':
      return Icons.call_split;
    case 'life_areas':
      return Icons.favorite_border;
    case 'bhava_strength':
      return Icons.home_outlined;
    case 'chakra_health':
      return Icons.spa;
    case 'gochar_today':
    case 'transit':
      return Icons.wb_twilight;
    case 'numerology':
      return Icons.pin;
    case 'ashtakoot_breakdown':
      return Icons.favorite;
    default:
      return Icons.auto_awesome_outlined;
  }
}
