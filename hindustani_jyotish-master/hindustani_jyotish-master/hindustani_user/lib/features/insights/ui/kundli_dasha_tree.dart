import 'package:flutter/material.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
import '../insights_repository.dart';
import 'kundli_section_scaffold.dart';

/// Vimshottari dasha drill-down: MD → AD → PD → SD … (levels deep), with a
/// breadcrumb + back button, a "RUNNING" badge on the current period and
/// past periods greyed. Moola is intentionally NOT supported.
///
/// Response shape (`GET /kundli/{id}/dasha/vimshottari?levels=`):
///   {system, total_years, moon_lord, balance_yrs,
///    dashas: [{planet, years, start, end, sub: [{planet, start, end, months, sub: [...]}]}]}
class KundliDashaTree extends StatefulWidget {
  const KundliDashaTree({super.key, required this.chartId});
  final String chartId;

  @override
  State<KundliDashaTree> createState() => _KundliDashaTreeState();
}

class _KundliDashaTreeState extends State<KundliDashaTree>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Map<String, dynamic>? _root;
  bool _loading = false;
  String? _error;
  final List<_Level> _stack = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await getIt<InsightsRepository>()
          .kundliVimshottari(widget.chartId, levels: 5);
      if (!mounted) return;
      _root = data;
      _pushRoot();
      setState(() => _loading = false);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = AppLocalizations.of(context).commonErrorGeneric;
        _loading = false;
      });
    }
  }

  void _pushRoot() {
    _stack
      ..clear()
      ..add(_Level(
        title: '${_root?['system'] ?? 'Vimshottari'}',
        level: 1,
        items: [
          for (final e in (_root?['dashas'] as List? ?? const []))
            if (e is Map) e.cast<String, dynamic>(),
        ],
      ));
  }

  void _drill(AppLocalizations l, Map<String, dynamic> node) {
    final subs = [
      for (final e in (node['sub'] as List? ?? const []))
        if (e is Map) e.cast<String, dynamic>(),
    ];
    if (subs.isEmpty) return;
    final lvl = _stack.length;
    final planet = '${node['planet'] ?? ''}';
    final title = switch (lvl) {
      1 => l.dashaAntardashasOf(planet),
      2 => l.dashaPratyantardashasOf(planet),
      3 => l.dashaSookshmaOf(planet),
      _ => l.dashaSubperiodsOf(planet),
    };
    setState(() => _stack.add(_Level(title: title, level: lvl + 1, items: subs)));
  }

  void _pop() {
    if (_stack.length > 1) setState(() => _stack.removeLast());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l = AppLocalizations.of(context);
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.saffron));
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.error_outline, color: AppColors.danger, size: 40),
            const SizedBox(height: 12),
            Text(_error!,
                textAlign: TextAlign.center,
                style: AppTextStyles.body(color: AppColors.ivoryDim)),
            const SizedBox(height: 14),
            ElevatedButton(onPressed: _load, child: Text(l.kunRetry)),
          ]),
        ),
      );
    }
    if (_stack.isEmpty) return const SizedBox.shrink();
    final current = _stack.last;

    return Column(
      children: [
        // Breadcrumb + back
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surface1,
            border: const Border(bottom: BorderSide(color: AppColors.borderSoft)),
          ),
          child: Row(children: [
            if (_stack.length > 1)
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.copperLight),
                onPressed: _pop,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            if (_stack.length > 1) const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(current.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.label(size: 13, color: AppColors.copperLight)),
                const SizedBox(height: 2),
                Text(_breadcrumb(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.mono(size: 10.5, color: AppColors.ivoryFaint)),
              ]),
            ),
          ]),
        ),
        if (current.level == 1 && _root?['balance_yrs'] != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.goldGlow,
            child: Text(
              l.dashaBirthBalance('${_root?['moon_lord'] ?? '—'}',
                  '${_root?['balance_yrs'] ?? '—'}'),
              style: AppTextStyles.body(size: 11.5, color: AppColors.gold),
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: current.items.length,
            itemBuilder: (_, i) => _dashaCard(l, current.items[i]),
          ),
        ),
      ],
    );
  }

  Widget _dashaCard(AppLocalizations l, Map<String, dynamic> item) {
    final planet = '${item['planet'] ?? ''}';
    final years = item['years'];
    final start = '${item['start'] ?? ''}';
    final end = '${item['end'] ?? ''}';
    final subs = (item['sub'] as List? ?? const []);
    final running = _isRunning(start, end);
    final past = _isPast(end);
    final pc = kundliPlanetColor(planet);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: running ? AppColors.saffronGlow : AppColors.surface1,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: running ? AppColors.saffron : AppColors.borderSoft,
          width: running ? 1.4 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: subs.isNotEmpty ? () => _drill(l, item) : null,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: pc.withValues(alpha: 0.18),
                shape: BoxShape.circle,
                border: Border.all(color: pc.withValues(alpha: 0.5)),
              ),
              child: Text(
                kundliPlanetSymbols[planet] ??
                    (planet.isNotEmpty ? planet.characters.first : '?'),
                style: TextStyle(color: pc, fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Flexible(
                    child: Text(planet,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body(
                            size: 14,
                            weight: FontWeight.w700,
                            color: past ? AppColors.ivoryFaint : AppColors.ivory)),
                  ),
                  const SizedBox(width: 8),
                  if (running)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                          color: AppColors.saffron,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(l.dashaRunning,
                          style: TextStyle(
                              color: AppColors.indigoVoid,
                              fontSize: 8.5,
                              fontWeight: FontWeight.w800)),
                    ),
                ]),
                const SizedBox(height: 3),
                Text('$start → $end',
                    style: AppTextStyles.mono(size: 11, color: AppColors.ivoryDim)),
                if (years != null)
                  Text(l.cardYears((years as num).toStringAsFixed(2)),
                      style: AppTextStyles.body(size: 10.5, color: AppColors.copperLight)),
              ]),
            ),
            if (subs.isNotEmpty)
              const Icon(Icons.chevron_right, color: AppColors.copperLight),
          ]),
        ),
      ),
    );
  }

  static const _levelLabels = ['MD', 'AD', 'PD', 'SD', 'PrD', 'DD'];

  String _breadcrumb() =>
      List.generate(_stack.length, (i) => _levelLabels[i.clamp(0, 5)]).join(' › ');

  bool _isRunning(String s, String e) {
    final sd = _parseDate(s), ed = _parseDate(e);
    if (sd == null || ed == null) return false;
    final now = DateTime.now();
    return now.isAfter(sd) && now.isBefore(ed);
  }

  bool _isPast(String e) {
    final ed = _parseDate(e);
    return ed != null && DateTime.now().isAfter(ed);
  }

  DateTime? _parseDate(String s) {
    if (s.isEmpty) return null;
    try {
      if (s.contains('-')) return DateTime.parse(s);
      final p = s.split('/');
      if (p.length != 3) return null;
      if (p[0].length == 4) {
        return DateTime(int.parse(p[0]), int.parse(p[1]), int.parse(p[2]));
      }
      return DateTime(int.parse(p[2]), int.parse(p[1]), int.parse(p[0]));
    } catch (_) {
      return null;
    }
  }
}

class _Level {
  _Level({required this.title, required this.level, required this.items});
  final String title;
  final int level;
  final List<Map<String, dynamic>> items;
}
