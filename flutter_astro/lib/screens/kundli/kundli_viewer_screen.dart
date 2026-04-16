import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import 'widgets/kundli_grid_widget.dart';
import 'widgets/planet_positions_widget.dart';
import 'widgets/divisional_charts_widget.dart';
import 'widgets/dasha_tree_widget.dart';

/// Main kundli viewer — shows all birth chart sections in tabs.
class KundliViewerScreen extends StatefulWidget {
  final String chartId;
  final String clientName;

  const KundliViewerScreen({
    super.key,
    required this.chartId,
    required this.clientName,
  });

  @override
  State<KundliViewerScreen> createState() => _KundliViewerScreenState();
}

class _KundliViewerScreenState extends State<KundliViewerScreen> with SingleTickerProviderStateMixin {
  final _api = ApiService();
  late final TabController _tabs;
  Map<String, dynamic>? _full;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 6, vsync: this);
    _loadFullKundli();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _loadFullKundli() async {
    setState(() { _loading = true; _error = null; });
    try {
      final resp = await _api.getKundliFull(widget.chartId, dashaDepth: 2);
      if (resp['statusCode'] == 200) {
        setState(() { _full = Map<String, dynamic>.from(resp)..remove('statusCode'); _loading = false; });
      } else {
        setState(() { _error = resp['detail']?.toString() ?? 'Failed to load kundli'; _loading = false; });
      }
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(widget.clientName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
          const Text('Birth Chart', style: TextStyle(color: AppColors.primary, fontSize: 11)),
        ]),
        actions: [
          IconButton(icon: const Icon(Icons.refresh, color: AppColors.primary), onPressed: _loadFullKundli, tooltip: 'Reload'),
        ],
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard, size: 18), text: 'Summary'),
            Tab(icon: Icon(Icons.public, size: 18), text: 'Planets'),
            Tab(icon: Icon(Icons.grid_on, size: 18), text: 'Kundli'),
            Tab(icon: Icon(Icons.apps, size: 18), text: 'Divisions'),
            Tab(icon: Icon(Icons.timeline, size: 18), text: 'Vimshottari'),
            Tab(icon: Icon(Icons.schedule, size: 18), text: 'Moola Dasha'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _error != null
              ? Center(child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                    const SizedBox(height: 12),
                    Text(_error!, style: const TextStyle(color: AppColors.textSecondary), textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(onPressed: _loadFullKundli, child: const Text('Retry')),
                  ]),
                ))
              : _full == null
                  ? const SizedBox.shrink()
                  : TabBarView(
                      controller: _tabs,
                      children: [
                        _SummaryTab(full: _full!),
                        PlanetPositionsWidget(planets: (_full!['planets'] as List?) ?? []),
                        _KundliTab(full: _full!),
                        DivisionalChartsWidget(chartId: widget.chartId, divisionals: (_full!['divisional_charts'] as List?) ?? []),
                        DashaTreeWidget(chartId: widget.chartId, type: 'vimshottari', initial: _full!['vimshottari_dasha']),
                        DashaTreeWidget(chartId: widget.chartId, type: 'moola', initial: _full!['moola_dasha']),
                      ],
                    ),
    );
  }
}


// ═══════════════════════════════════════════════════════════════════
//  SUMMARY TAB
// ═══════════════════════════════════════════════════════════════════

class _SummaryTab extends StatelessWidget {
  final Map<String, dynamic> full;
  const _SummaryTab({required this.full});

  @override
  Widget build(BuildContext context) {
    final summary = full['summary'] as Map? ?? {};
    final meta = full['meta'] as Map? ?? {};
    final lagna = summary['lagna'] as Map?;
    final moon = summary['moon_sign'] as Map?;
    final sun = summary['sun_sign'] as Map?;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Birth details
        _card(
          title: 'Birth Details',
          icon: Icons.info_outline,
          children: [
            _row('Name', meta['name']?.toString() ?? ''),
            _row('Gender', (meta['gender']?.toString() ?? '').toUpperCase()),
            _row('Date', meta['dob']?.toString() ?? ''),
            _row('Time', meta['tob']?.toString() ?? ''),
            _row('Place', meta['place']?.toString() ?? ''),
            _row('Latitude', '${(meta['latitude'] as num?)?.toStringAsFixed(4) ?? "-"}°'),
            _row('Longitude', '${(meta['longitude'] as num?)?.toStringAsFixed(4) ?? "-"}°'),
            _row('Timezone', 'UTC+${meta['timezone']}'),
          ],
        ),
        const SizedBox(height: 12),

        if (lagna != null) _summaryCard('Ascendant (Lagna)', lagna, AppColors.primary, Icons.wb_sunny),
        if (moon != null) _summaryCard('Moon Sign (Rashi)', moon, AppColors.accent, Icons.nightlight_round),
        if (sun != null) _summaryCard('Sun Sign', sun, Colors.orange, Icons.brightness_7),

        const SizedBox(height: 20),
        Text('Engine: ${meta['engine']}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 10), textAlign: TextAlign.center),
      ],
    );
  }

  Widget _card({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 10),
        ...children,
      ]),
    );
  }

  Widget _summaryCard(String title, Map m, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withOpacity(0.15), color.withOpacity(0.05)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(title, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 10),
        Text(
          '${m['rashi']} (${m['rashi_short']})',
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text('Lord: ${m['rashi_lord']} • ${m['degree']}°',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        Text('Nakshatra: ${m['nakshatra']} (Pada ${m['pada']}) — ${m['nak_lord']}',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ]),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        SizedBox(width: 90, child: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12))),
        Expanded(child: Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w500))),
      ]),
    );
  }
}


// ═══════════════════════════════════════════════════════════════════
//  KUNDLI TAB — Lagna / Moon / Sun chart switcher
// ═══════════════════════════════════════════════════════════════════

class _KundliTab extends StatefulWidget {
  final Map<String, dynamic> full;
  const _KundliTab({required this.full});

  @override
  State<_KundliTab> createState() => _KundliTabState();
}

class _KundliTabState extends State<_KundliTab> {
  String _base = 'Lagna';

  @override
  Widget build(BuildContext context) {
    final m = widget.full;
    Map<String, dynamic> grid;
    switch (_base) {
      case 'Moon': grid = (m['moon_chart'] as Map? ?? {}).cast<String, dynamic>(); break;
      case 'Sun': grid = (m['sun_chart'] as Map? ?? {}).cast<String, dynamic>(); break;
      default: grid = (m['lagna_chart'] as Map? ?? {}).cast<String, dynamic>();
    }

    return ListView(padding: const EdgeInsets.all(16), children: [
      // Base selector
      SegmentedButton<String>(
        segments: const [
          ButtonSegment(value: 'Lagna', label: Text('Lagna')),
          ButtonSegment(value: 'Moon', label: Text('Moon')),
          ButtonSegment(value: 'Sun', label: Text('Sun')),
        ],
        selected: {_base},
        onSelectionChanged: (s) => setState(() => _base = s.first),
      ),
      const SizedBox(height: 16),
      Text('$_base Chart — Base: ${grid['base_rashi'] ?? ''}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w700)),
      const SizedBox(height: 12),
      KundliGridWidget(houses: (grid['houses'] as List?) ?? []),
    ]);
  }
}
