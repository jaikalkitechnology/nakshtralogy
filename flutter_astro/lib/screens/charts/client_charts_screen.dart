import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../bloc/chart/chart_bloc.dart';
import '../../bloc/chart/chart_event.dart';
import '../../bloc/chart/chart_state.dart';
import 'add_client_chart_screen.dart';
import '../kundli/kundli_viewer_screen.dart';
import '../../widgets/desktop_center.dart';

const _months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];

String _formatDate(String dob) {
  final parts = dob.split('/');
  if (parts.length != 3) return dob;
  try {
    return '${parts[0]} ${_months[int.parse(parts[1]) - 1]} ${parts[2]}';
  } catch (_) {
    return dob;
  }
}

const List<List<Color>> _avatarGradients = [
  [AppColors.gold, AppColors.saffron],
  [AppColors.aurora, AppColors.indigo],
  [AppColors.cosmicPink, AppColors.saffron],
  [AppColors.lavender, AppColors.indigo],
];

class ClientChartsScreen extends StatefulWidget {
  const ClientChartsScreen({super.key});

  @override
  State<ClientChartsScreen> createState() => _ClientChartsScreenState();
}

class _ClientChartsScreenState extends State<ClientChartsScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';
  String _activeFilter = 'All';
  String _activeSort = 'Date';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final bloc = context.read<ChartBloc>();
    if (bloc.state is ChartInitial) bloc.add(ChartLoadRequested());

    return BlocConsumer<ChartBloc, ChartState>(
      listener: (context, state) {
        if (state is ChartCreated) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Client chart created!'),
            backgroundColor: AppColors.success,
          ));
        } else if (state is ChartFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: AppColors.error,
          ));
        }
      },
      builder: (context, state) {
        final allCharts = state is ChartLoaded ? state.charts : <dynamic>[];
        final loading = state is ChartLoading;
        final isFailure = state is ChartFailure;

        // Apply search filter
        final filtered = allCharts.where((c) {
          if (_query.isEmpty) return true;
          final q = _query.toLowerCase();
          final name = (c['name'] ?? '').toString().toLowerCase();
          final dob = (c['dob'] ?? '').toString().toLowerCase();
          final place = (c['place'] ?? '').toString().toLowerCase();
          return name.contains(q) || dob.contains(q) || place.contains(q);
        }).toList();

        return Stack(
          children: [
            DesktopCenter(
              maxWidth: 900,
              child: RefreshIndicator(
              onRefresh: () async => context.read<ChartBloc>().add(ChartLoadRequested()),
              color: AppColors.gold,
              backgroundColor: AppColors.nebula,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(child: _buildHeader(context, l)),
                  SliverToBoxAdapter(child: _buildSearchField()),
                  SliverToBoxAdapter(child: _buildFilterRows()),
                  if (loading)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: CircularProgressIndicator(color: AppColors.gold)),
                    )
                  else if (isFailure && allCharts.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            (state).message,
                            style: const TextStyle(color: AppColors.smoke),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  else if (filtered.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('\u{1F4DC}', style: TextStyle(fontSize: 56)),
                            const SizedBox(height: 16),
                            Text(
                              _query.isEmpty ? l.noChartsCreated : 'No matches found',
                              style: const TextStyle(color: AppColors.ivory, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    )
                  else ...[
                    SliverToBoxAdapter(child: _buildSectionHeader('RECENT', null)),
                    SliverList.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, i) => _buildChartItem(context, filtered[i], i, l),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                ],
              ),
            )),
            Positioned(
              right: 16,
              bottom: 16,
              child: _buildFloatingFilterButton(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ivory,
                  height: 1.2,
                ),
                children: [
                  TextSpan(text: 'Client '),
                  TextSpan(
                    text: 'Charts',
                    style: TextStyle(
                      color: AppColors.gold,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildAddButton(context),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AddClientChartScreen()),
      ),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.gold, AppColors.saffron],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withOpacity(0.35),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: AppColors.midnight, size: 22),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.gold.withOpacity(0.2)),
        ),
        child: TextField(
          controller: _searchCtrl,
          onChanged: (v) => setState(() => _query = v.trim()),
          style: const TextStyle(color: AppColors.ivory, fontSize: 13),
          decoration: InputDecoration(
            filled: false,
            hintText: 'Search by name, birth date, city...',
            hintStyle: const TextStyle(color: AppColors.smoke, fontSize: 13),
            prefixIcon: const Icon(Icons.search, color: AppColors.smoke, size: 18),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            isDense: true,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterRows() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildChip('All (148)', _activeFilter == 'All', () => setState(() => _activeFilter = 'All')),
                const SizedBox(width: 8),
                _buildChip('Today', _activeFilter == 'Today', () => setState(() => _activeFilter = 'Today')),
                const SizedBox(width: 8),
                _buildChip('Starred', _activeFilter == 'Starred', () => setState(() => _activeFilter = 'Starred')),
                const SizedBox(width: 8),
                _buildChip('Follow-up', _activeFilter == 'Follow-up', () => setState(() => _activeFilter = 'Follow-up')),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildChip('\u2648-\u264D', false, () {}),
                const SizedBox(width: 8),
                _buildChip('\u264E-\u2653', false, () {}),
                const SizedBox(width: 8),
                _buildChip('Date \u2193', _activeSort == 'Date', () => setState(() => _activeSort = 'Date')),
                const SizedBox(width: 8),
                _buildChip('Name \u2191', _activeSort == 'Name', () => setState(() => _activeSort = 'Name')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: active
              ? const LinearGradient(
                  colors: [AppColors.gold, AppColors.saffron],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: active ? null : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: active ? Colors.transparent : AppColors.gold.withOpacity(0.2),
          ),
        ),
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
    );
  }

  Widget _buildSectionHeader(String title, String? trailing) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.smoke,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
              fontFamily: 'Manrope',
            ),
          ),
          if (trailing != null)
            Text(
              trailing,
              style: const TextStyle(
                color: AppColors.gold,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                fontFamily: 'Manrope',
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChartItem(BuildContext context, dynamic c, int index, AppLocalizations l) {
    final name = (c['name'] ?? '').toString();
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final dob = (c['dob'] ?? '').toString();
    final tob = (c['tob'] ?? '').toString();
    final place = (c['place'] ?? '').toString().toUpperCase();
    final rashi = (c['rashi'] ?? c['moon_sign'] ?? '').toString();
    final gradient = _avatarGradients[index % _avatarGradients.length];

    final metaParts = <String>[];
    if (dob.isNotEmpty) metaParts.add(_formatDate(dob));
    if (tob.isNotEmpty) metaParts.add(tob);
    if (place.isNotEmpty) metaParts.add(place);
    final meta = metaParts.join(' \u00B7 ');

    final tagText = rashi.isNotEmpty
        ? rashi.substring(0, rashi.length > 3 ? 3 : rashi.length).toUpperCase()
        : null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => KundliViewerScreen(
                chartId: c['id'],
                clientName: c['name'] ?? 'Client',
              ),
            ),
          ),
          onLongPress: () => _confirmDelete(context, c),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.nebula.withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.gold.withOpacity(0.12)),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    initial,
                    style: const TextStyle(
                      color: AppColors.midnight,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Manrope',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: AppColors.ivory,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Manrope',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (meta.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          meta,
                          style: const TextStyle(
                            color: AppColors.smoke,
                            fontSize: 9,
                            fontFamily: 'Manrope',
                            letterSpacing: 0.6,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (tagText != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      tagText,
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Manrope',
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingFilterButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.gold, AppColors.saffron],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.tune, color: AppColors.midnight, size: 22),
      ),
    );
  }

  void _confirmDelete(BuildContext context, dynamic c) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.nebula,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete chart?', style: TextStyle(color: AppColors.ivory)),
        content: Text(
          'Remove ${c['name'] ?? 'this client'} from your charts?',
          style: const TextStyle(color: AppColors.smoke),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.smoke)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ChartBloc>().add(ChartDeleteRequested(chartId: c['id']));
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
