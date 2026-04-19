import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../bloc/chart/chart_bloc.dart';
import '../../bloc/chart/chart_event.dart';
import '../../bloc/chart/chart_state.dart';
import '../kundli/kundli_viewer_screen.dart';
import 'add_chart_screen.dart';

class MyChartsScreen extends StatefulWidget {
  const MyChartsScreen({super.key});

  @override
  State<MyChartsScreen> createState() => _MyChartsScreenState();
}

class _MyChartsScreenState extends State<MyChartsScreen> {
  static const _months = [
    'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
  ];

  static const _avatarGradients = <List<Color>>[
    [AppColors.gold, AppColors.saffron],
    [AppColors.saffron, AppColors.cosmicPink],
    [AppColors.aurora, AppColors.indigo],
    [AppColors.lavender, AppColors.indigo],
    [AppColors.cosmicPink, AppColors.saffron],
  ];

  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';
  String _activeFilter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<ChartBloc>();
      if (bloc.state is ChartInitial) {
        bloc.add(ChartLoadRequested());
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  String _formatDob(String? dob) {
    if (dob == null || dob.isEmpty) return '';
    final parts = dob.split('/');
    if (parts.length != 3) return dob;
    final m = int.tryParse(parts[1]);
    if (m == null || m < 1 || m > 12) return dob;
    return '${parts[0].padLeft(2, '0')} ${_months[m - 1]} ${parts[2]}';
  }

  String _metaLine(Map c) {
    final date = _formatDob(c['dob']?.toString());
    final tob = (c['tob']?.toString() ?? '').trim();
    final place = (c['place']?.toString() ?? '').trim();
    final parts = <String>[];
    if (date.isNotEmpty) parts.add(date);
    if (tob.isNotEmpty) parts.add(tob);
    if (place.isNotEmpty) parts.add(place.toUpperCase());
    return parts.join(' \u00b7 ');
  }

  String? _rashiAbbr(Map c) {
    final raw = (c['rashi'] ?? c['moon_sign'] ?? c['zodiac'] ?? c['sun_sign'])?.toString();
    if (raw == null || raw.isEmpty) return null;
    return raw.trim().substring(0, raw.length >= 3 ? 3 : raw.length).toUpperCase();
  }

  List<Color> _gradientFor(String name) {
    if (name.isEmpty) return _avatarGradients[0];
    final h = name.codeUnits.fold<int>(0, (acc, u) => (acc + u) & 0x7fffffff);
    return _avatarGradients[h % _avatarGradients.length];
  }

  String _initial(String name) {
    final t = name.trim();
    return t.isEmpty ? '?' : t.substring(0, 1).toUpperCase();
  }

  List<dynamic> _applyFilters(List<dynamic> charts) {
    final q = _query.trim().toLowerCase();
    return charts.where((c) {
      final name = (c['name']?.toString() ?? '').toLowerCase();
      final dob = (c['dob']?.toString() ?? '').toLowerCase();
      if (q.isNotEmpty && !name.contains(q) && !dob.contains(q)) return false;
      switch (_activeFilter) {
        case 'recent':
          // show all; server typically returns recent-first
          return true;
        case 'family':
          return c['relationship'] == 'family' || c['is_primary'] == true;
        case 'friends':
          return c['relationship'] == 'friend';
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return BlocConsumer<ChartBloc, ChartState>(
      listener: (context, state) {
        if (state is ChartCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Birth chart created!'), backgroundColor: AppColors.success),
          );
        } else if (state is ChartFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
          );
        }
      },
      builder: (context, state) {
        if (state is ChartLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: AppColors.gold)),
          );
        }

        final allCharts = state is ChartLoaded ? state.charts : <dynamic>[];
        final filtered = _applyFilters(allCharts);

        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: RefreshIndicator(
              color: AppColors.gold,
              onRefresh: () async => context.read<ChartBloc>().add(ChartLoadRequested()),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // ====== TITLE + ADD BUTTON ======
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'My ',
                                    style: TextStyle(color: AppColors.ivory),
                                  ),
                                  TextSpan(
                                    text: 'Charts',
                                    style: TextStyle(
                                      color: AppColors.gold,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const AddChartScreen()),
                            ),
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [AppColors.gold, AppColors.saffron],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.gold.withOpacity(0.3),
                                    blurRadius: 12,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.add, color: AppColors.midnight, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ====== SEARCH ======
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.nebula,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: AppColors.gold.withOpacity(0.15)),
                        ),
                        child: TextField(
                          controller: _searchCtrl,
                          onChanged: (v) => setState(() => _query = v),
                          style: const TextStyle(color: AppColors.ivory, fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Search by name or birth date...',
                            hintStyle: const TextStyle(color: AppColors.smoke, fontSize: 13),
                            prefixIcon: const Icon(Icons.search, color: AppColors.smoke, size: 20),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                            filled: false,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ====== FILTER CHIPS ======
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 38,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          _filterChip('All (${allCharts.length})', 'all'),
                          const SizedBox(width: 8),
                          _filterChip('Family', 'family'),
                          const SizedBox(width: 8),
                          _filterChip('Friends', 'friends'),
                          const SizedBox(width: 8),
                          _filterChip('Recent', 'recent'),
                          const SizedBox(width: 8),
                          _filterChip('Leo', 'leo'),
                        ],
                      ),
                    ),
                  ),

                  // ====== SECTION LABEL ======
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Text(
                        allCharts.isEmpty ? '' : 'RECENT',
                        style: const TextStyle(
                          color: AppColors.smoke,
                          fontSize: 9,
                          letterSpacing: 2.5,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ),

                  // ====== LIST ======
                  if (filtered.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('\u{1F4DC}', style: TextStyle(fontSize: 56)),
                              const SizedBox(height: 16),
                              Text(
                                allCharts.isEmpty ? l.noCharts : 'No charts match your search',
                                style: const TextStyle(color: AppColors.ivory, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                allCharts.isEmpty ? l.createFirst : 'Try a different filter',
                                style: const TextStyle(color: AppColors.smoke),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              if (allCharts.isEmpty)
                                ElevatedButton.icon(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const AddChartScreen()),
                                  ),
                                  icon: const Icon(Icons.add),
                                  label: Text(l.createChart),
                                ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      sliver: SliverList.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, i) =>
                            _chartRow(context, filtered[i] as Map, l),
                      ),
                    ),
                ],
              ),
            ),
          ),
          floatingActionButton: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.gold, AppColors.saffron],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withOpacity(0.4),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddChartScreen()),
                ),
                child: const Icon(Icons.add, color: AppColors.midnight, size: 24),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _filterChip(String label, String key) {
    final active = _activeFilter == key;
    return GestureDetector(
      onTap: () => setState(() => _activeFilter = key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: active
              ? const LinearGradient(
                  colors: [AppColors.gold, AppColors.saffron],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: active ? null : AppColors.nebula,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? Colors.transparent : AppColors.gold.withOpacity(0.2),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: active ? AppColors.midnight : AppColors.ivory,
              fontSize: 12,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              fontFamily: 'Manrope',
            ),
          ),
        ),
      ),
    );
  }

  Widget _chartRow(BuildContext context, Map c, AppLocalizations l) {
    final name = c['name']?.toString() ?? '';
    final isPrimary = c['is_primary'] == true;
    final rashi = _rashiAbbr(c);
    final grad = _gradientFor(name);
    final meta = _metaLine(c);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isPrimary
              ? AppColors.gold.withOpacity(0.4)
              : AppColors.gold.withOpacity(0.1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => KundliViewerScreen(
                chartId: c['id']?.toString() ?? '',
                clientName: name.isEmpty ? 'Chart' : name,
              ),
            ),
          ),
          onLongPress: () => _confirmDelete(context, c, l),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Gradient avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: grad,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _initial(name),
                      style: const TextStyle(
                        color: AppColors.midnight,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Name + meta
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              name.isEmpty ? '\u2014' : name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.ivory,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Manrope',
                              ),
                            ),
                          ),
                          if (isPrimary) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.gold.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                l.primary,
                                style: const TextStyle(
                                  color: AppColors.gold,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      if (meta.isNotEmpty)
                        Text(
                          meta,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.smoke,
                            fontSize: 9,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'monospace',
                          ),
                        ),
                    ],
                  ),
                ),

                // Rashi tag
                if (rashi != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.gold.withOpacity(0.3)),
                    ),
                    child: Text(
                      rashi,
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  )
                else
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 18),
                    onPressed: () => _confirmDelete(context, c, l),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Map c, AppLocalizations l) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(l.deleteChart, style: const TextStyle(color: AppColors.textPrimary)),
        content: Text(l.cannotUndo, style: const TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ChartBloc>().add(ChartDeleteRequested(chartId: c['id']));
            },
            child: Text(l.delete, style: const TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
