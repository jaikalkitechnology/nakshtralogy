import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../services/api_service.dart';

/// Hierarchical dasha viewer. Click MD → shows AD children.
/// Click AD → shows PD children. Breadcrumb at top for back navigation.
///
/// type: 'vimshottari' | 'moola'
class DashaTreeWidget extends StatefulWidget {
  final String chartId;
  final String type;
  final Map<String, dynamic>? initial;

  const DashaTreeWidget({super.key, required this.chartId, required this.type, this.initial});

  @override
  State<DashaTreeWidget> createState() => _DashaTreeWidgetState();
}

class _DashaTreeWidgetState extends State<DashaTreeWidget> {
  Map<String, dynamic>? _root;
  bool _loading = false;
  String? _error;

  // Navigation stack: each entry has {title, children}
  final List<_DashaLevel> _stack = [];

  @override
  void initState() {
    super.initState();
    if (widget.initial != null && widget.initial is Map) {
      _root = Map<String, dynamic>.from(widget.initial!);
      _pushRoot();
    } else {
      _load();
    }
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final resp = widget.type == 'moola'
          ? await ApiService().getKundliMoola(widget.chartId, depth: 3)
          : await ApiService().getKundliVimshottari(widget.chartId, depth: 3);
      if (resp['statusCode'] == 200) {
        _root = Map<String, dynamic>.from(resp)..remove('statusCode');
        _pushRoot();
        setState(() => _loading = false);
      } else {
        setState(() { _error = resp['detail']?.toString() ?? 'Failed to load'; _loading = false; });
      }
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  void _pushRoot() {
    _stack.clear();
    _stack.add(_DashaLevel(
      title: widget.type == 'moola' ? 'Moola Mahadasha' : 'Vimshottari Mahadasha',
      level: 1,
      items: (_root?['dashas'] as List?)?.cast<Map<String, dynamic>>() ?? [],
    ));
  }

  void _drillDown(Map<String, dynamic> node) {
    final children = (node['children'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (children.isEmpty) return;
    final level = (node['level'] as num?)?.toInt() ?? 1;
    String title;
    switch (level) {
      case 1: title = '${node['planet']} Mahadasha → Antardashas'; break;
      case 2: title = '${node['planet']} Antardasha → Pratyantardashas'; break;
      case 3: title = '${node['planet']} Pratyantardasha → Sookshmadashas'; break;
      case 4: title = '${node['planet']} Sookshmadasha → Pranadashas'; break;
      default: title = '${node['planet']} Sub-periods';
    }
    setState(() => _stack.add(_DashaLevel(title: title, level: level + 1, items: children)));
  }

  void _pop() {
    if (_stack.length > 1) setState(() => _stack.removeLast());
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    if (_error != null) {
      return Center(child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 48),
          const SizedBox(height: 12),
          Text(_error!, style: const TextStyle(color: AppColors.textSecondary), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _load, child: const Text('Retry')),
        ]),
      ));
    }
    if (_stack.isEmpty) return const SizedBox.shrink();

    final current = _stack.last;

    return Column(children: [
      // Breadcrumb
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(color: AppColors.card, border: Border(bottom: BorderSide(color: AppColors.border))),
        child: Row(children: [
          if (_stack.length > 1)
            IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.primary),
              onPressed: _pop,
              padding: EdgeInsets.zero, constraints: const BoxConstraints(),
              tooltip: 'Back',
            ),
          if (_stack.length > 1) const SizedBox(width: 8),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(current.title, style: const TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(_breadcrumb(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
          ])),
        ]),
      ),

      // Balance info for MD level (Vimshottari only)
      if (current.level == 1 && _root?['balance_years'] != null)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: AppColors.accent.withOpacity(0.08),
          child: Row(children: [
            const Icon(Icons.info_outline, color: AppColors.accent, size: 14),
            const SizedBox(width: 8),
            Expanded(child: Text(
              widget.type == 'vimshottari'
                ? 'Birth dasha: ${_root?['birth_nak_lord']}  •  Balance: ${(_root?['balance_years'] as num?)?.toStringAsFixed(3)} years'
                : 'Moola Dasha (Lagna Kendradi Graha)',
              style: const TextStyle(color: AppColors.accent, fontSize: 11),
            )),
          ]),
        ),

      // Items list
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: current.items.length,
          itemBuilder: (_, i) {
            final item = current.items[i];
            final planet = item['planet']?.toString() ?? '';
            final years = (item['years'] as num?)?.toDouble() ?? 0;
            final start = item['start_date']?.toString() ?? '';
            final end = item['end_date']?.toString() ?? '';
            final hasChildren = (item['children'] as List?)?.isNotEmpty ?? false;
            final isRunning = _isRunning(item);
            final isPast = _isPast(item);

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: isRunning ? AppColors.primary.withOpacity(0.12) : AppColors.card,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isRunning ? AppColors.primary : AppColors.border,
                  width: isRunning ? 1.5 : 1,
                ),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: hasChildren ? () => _drillDown(item) : null,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: _planetColor(planet).withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: _planetColor(planet).withOpacity(0.5)),
                      ),
                      child: Center(child: Text(planet.isNotEmpty ? planet[0] : '?',
                          style: TextStyle(color: _planetColor(planet), fontWeight: FontWeight.w700, fontSize: 16))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Text(planet, style: TextStyle(
                            color: isPast ? AppColors.textSecondary : AppColors.textPrimary,
                            fontWeight: FontWeight.w700, fontSize: 14)),
                        const SizedBox(width: 8),
                        if (isRunning) Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4)),
                          child: const Text('RUNNING', style: TextStyle(color: Colors.black, fontSize: 8, fontWeight: FontWeight.bold)),
                        ),
                        if (isPast) const Text('  (past)', style: TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                      ]),
                      const SizedBox(height: 4),
                      Text('$start → $end',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontFamily: 'monospace')),
                      Text('${years.toStringAsFixed(3)} years (${(years * 12).toStringAsFixed(1)} months)',
                          style: const TextStyle(color: AppColors.primary, fontSize: 10)),
                    ])),
                    if (hasChildren)
                      const Icon(Icons.chevron_right, color: AppColors.primary),
                  ]),
                ),
              ),
            );
          },
        ),
      ),
    ]);
  }

  String _breadcrumb() {
    final parts = <String>[];
    for (int i = 0; i < _stack.length; i++) {
      parts.add(['MD', 'AD', 'PD', 'SD', 'PrD', 'DD'][i.clamp(0, 5)]);
    }
    return parts.join(' › ');
  }

  bool _isRunning(Map item) {
    // Parse dates, compare with today (simple DD/MM/YYYY compare)
    try {
      final s = item['start_date']?.toString() ?? '';
      final e = item['end_date']?.toString() ?? '';
      if (s.isEmpty || e.isEmpty) return false;
      final start = _parseDate(s);
      final end = _parseDate(e);
      final now = DateTime.now();
      return now.isAfter(start) && now.isBefore(end);
    } catch (_) { return false; }
  }

  bool _isPast(Map item) {
    try {
      final e = item['end_date']?.toString() ?? '';
      if (e.isEmpty) return false;
      final end = _parseDate(e);
      return DateTime.now().isAfter(end);
    } catch (_) { return false; }
  }

  DateTime _parseDate(String s) {
    final parts = s.split('/');
    return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
  }

  Color _planetColor(String p) {
    switch (p) {
      case 'Sun': return Colors.orange;
      case 'Moon': return Colors.blueGrey;
      case 'Mars': return Colors.red;
      case 'Mercury': return Colors.green;
      case 'Jupiter': return Colors.amber;
      case 'Venus': return Colors.pink;
      case 'Saturn': return Colors.indigo;
      case 'Rahu': return Colors.purple;
      case 'Ketu': return Colors.brown;
      default: return AppColors.primary;
    }
  }
}

class _DashaLevel {
  final String title;
  final int level;
  final List<Map<String, dynamic>> items;
  _DashaLevel({required this.title, required this.level, required this.items});
}
