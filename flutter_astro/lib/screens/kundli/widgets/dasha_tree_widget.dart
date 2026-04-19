import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../services/api_service.dart';

/// Hierarchical dasha viewer. Click MD → shows its AD `sub` list.
/// Click AD → shows its PD list. Breadcrumb at top for back navigation.
///
/// Response shape (new):
///   {
///     system, total_years, moon_lord, balance_yrs,
///     dashas: [{planet, years, start, end, sub: [{planet, start, end, months, sub: [...]}]}]
///   }
class DashaTreeWidget extends StatefulWidget {
  final String chartId;
  final String type; // vimshottari | moola
  final Map<String, dynamic>? initial;

  const DashaTreeWidget({super.key, required this.chartId, required this.type, this.initial});

  @override
  State<DashaTreeWidget> createState() => _DashaTreeWidgetState();
}

class _DashaTreeWidgetState extends State<DashaTreeWidget> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Map<String, dynamic>? _root;
  bool _loading = false;
  String? _error;
  final List<_Level> _stack = [];

  @override
  void initState() {
    super.initState();
    if (widget.initial is Map) {
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
          ? await ApiService().getKundliMoola(widget.chartId, levels: 5)
          : await ApiService().getKundliVimshottari(widget.chartId, levels: 5);
      if (resp['statusCode'] == 200 && resp['status'] == 'success') {
        _root = (resp['data'] as Map).cast<String, dynamic>();
        _pushRoot();
        setState(() => _loading = false);
      } else {
        setState(() { _error = resp['detail']?.toString() ?? 'Failed'; _loading = false; });
      }
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  void _pushRoot() {
    _stack.clear();
    _stack.add(_Level(
      title: _root?['system']?.toString() ?? 'Dasha',
      level: 1,
      items: ((_root?['dashas'] as List?) ?? []).cast<Map<String, dynamic>>(),
    ));
  }

  void _drill(Map<String, dynamic> node) {
    final subs = ((node['sub'] as List?) ?? []).cast<Map<String, dynamic>>();
    if (subs.isEmpty) return;
    final lvl = _stack.length;
    String title;
    switch (lvl) {
      case 1: title = '${node['planet']} MD → Antardashas'; break;
      case 2: title = '${node['planet']} AD → Pratyantardashas'; break;
      case 3: title = '${node['planet']} PD → Sookshmadashas'; break;
      default: title = '${node['planet']} Sub-periods';
    }
    setState(() => _stack.add(_Level(title: title, level: lvl + 1, items: subs)));
  }

  void _pop() { if (_stack.length > 1) setState(() => _stack.removeLast()); }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_loading) return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    if (_error != null) return _errView();
    if (_stack.isEmpty) return const SizedBox.shrink();
    final current = _stack.last;

    return Column(children: [
      // Breadcrumb
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(color: AppColors.card, border: Border(bottom: BorderSide(color: AppColors.border))),
        child: Row(children: [
          if (_stack.length > 1) IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.primary), onPressed: _pop, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
          if (_stack.length > 1) const SizedBox(width: 8),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(current.title, style: const TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(_breadcrumb(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
          ])),
        ]),
      ),
      // Info banner
      if (current.level == 1 && _root?['balance_yrs'] != null)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: AppColors.accent.withOpacity(0.08),
          child: Row(children: [
            const Icon(Icons.info_outline, color: AppColors.accent, size: 14),
            const SizedBox(width: 8),
            Expanded(child: Text(
              widget.type == 'vimshottari'
                  ? 'Birth Lord: ${_root?['moon_lord']} • Balance: ${_root?['balance_yrs']} yrs'
                  : 'Lagna: ${_root?['lagna_sign'] ?? ''} • Balance: ${_root?['balance_yrs']} yrs',
              style: const TextStyle(color: AppColors.accent, fontSize: 11),
            )),
          ]),
        ),
      // List
      Expanded(child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: current.items.length,
        itemBuilder: (_, i) => _dashaCard(current.items[i]),
      )),
    ]);
  }

  Widget _dashaCard(Map<String, dynamic> item) {
    final planet = item['planet']?.toString() ?? '';
    final years = item['years'] ?? item['eff_yrs'];
    final start = item['start']?.toString() ?? '';
    final end = item['end']?.toString() ?? '';
    final subs = ((item['sub'] as List?) ?? []);
    final running = _isRunning(start, end);
    final past = _isPast(end);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: running ? AppColors.primary.withOpacity(0.12) : AppColors.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: running ? AppColors.primary : AppColors.border, width: running ? 1.5 : 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: subs.isNotEmpty ? () => _drill(item) : null,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: _pColor(planet).withOpacity(0.2), shape: BoxShape.circle, border: Border.all(color: _pColor(planet).withOpacity(0.5))),
              child: Center(child: Text(planet.isNotEmpty ? planet[0] : '?', style: TextStyle(color: _pColor(planet), fontWeight: FontWeight.w700, fontSize: 16))),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Flexible(child: Text(planet, style: TextStyle(color: past ? AppColors.textSecondary : AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 14), overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 8),
                if (running) Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4)), child: const Text('RUNNING', style: TextStyle(color: Colors.black, fontSize: 8, fontWeight: FontWeight.bold))),
                if (past) const Text('  (past)', style: TextStyle(color: AppColors.textSecondary, fontSize: 10)),
              ]),
              const SizedBox(height: 4),
              Text('$start → $end', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontFamily: 'monospace')),
              if (years != null) Text('${(years as num).toStringAsFixed(3)} years', style: const TextStyle(color: AppColors.primary, fontSize: 10)),
            ])),
            if (subs.isNotEmpty) const Icon(Icons.chevron_right, color: AppColors.primary),
          ]),
        ),
      ),
    );
  }

  Widget _errView() => Center(child: Padding(
    padding: const EdgeInsets.all(24),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.error_outline, color: AppColors.error, size: 40),
      const SizedBox(height: 12),
      Text(_error!, style: const TextStyle(color: AppColors.textSecondary), textAlign: TextAlign.center),
      const SizedBox(height: 12),
      ElevatedButton(onPressed: _load, child: const Text('Retry')),
    ]),
  ));

  String _breadcrumb() => List.generate(_stack.length, (i) => ['MD','AD','PD','SD','PrD','DD'][i.clamp(0, 5)]).join(' › ');

  bool _isRunning(String s, String e) { try { final now = DateTime.now(); return now.isAfter(_parseDate(s)) && now.isBefore(_parseDate(e)); } catch (_) { return false; } }
  bool _isPast(String e) { try { return DateTime.now().isAfter(_parseDate(e)); } catch (_) { return false; } }

  DateTime _parseDate(String s) {
    // Accept DD/MM/YYYY, YYYY-MM-DD, ISO
    if (s.contains('-')) return DateTime.parse(s);
    final parts = s.split('/');
    if (parts[0].length == 4) return DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
    return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
  }

  Color _pColor(String p) {
    const m = {'Sun': Colors.orange, 'Moon': Colors.blueGrey, 'Mars': Colors.red,
      'Mercury': Colors.green, 'Jupiter': Colors.amber, 'Venus': Colors.pink,
      'Saturn': Colors.indigo, 'Rahu': Colors.purple, 'Ketu': Colors.brown};
    return m[p] ?? AppColors.primary;
  }
}

class _Level {
  final String title;
  final int level;
  final List<Map<String, dynamic>> items;
  _Level({required this.title, required this.level, required this.items});
}
