import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../bloc/service/service_bloc.dart';
import '../../bloc/service/service_event.dart';
import '../../bloc/service/service_state.dart';
import '../charts/my_charts_screen.dart';

class ServicesTab extends StatefulWidget {
  const ServicesTab({super.key});

  @override
  State<ServicesTab> createState() => _ServicesTabState();
}

class _ServicesTabState extends State<ServicesTab> {
  String _category = 'all';

  static const _categories = ['all', 'kundli', 'report', 'ai'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceBloc>().add(const ServiceLoadRequested());
    });
  }

  void _onCategoryChange(String cat) {
    setState(() => _category = cat);
    context.read<ServiceBloc>().add(
          ServiceLoadRequested(category: cat == 'all' ? null : cat),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(l),
        const SizedBox(height: 4),
        _subtitle(),
        const SizedBox(height: 12),
        _categoryChips(),
        const SizedBox(height: 10),
        Expanded(
          child: BlocBuilder<ServiceBloc, ServiceState>(
            builder: (context, state) {
              if (state is ServiceLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.gold),
                );
              }
              final services = state is ServiceLoaded ? state.services : <dynamic>[];
              if (services.isEmpty) {
                return const Center(
                  child: Text(
                    'No services available',
                    style: TextStyle(color: AppColors.smoke, fontSize: 12),
                  ),
                );
              }
              return RefreshIndicator(
                color: AppColors.gold,
                onRefresh: () async {
                  context.read<ServiceBloc>().add(
                        ServiceLoadRequested(
                          category: _category == 'all' ? null : _category,
                        ),
                      );
                },
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                  itemCount: services.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final s = services[i] as Map;
                    final sKey = s['service_key']?.toString() ?? '';
                    final isAI = sKey.contains('ai');
                    return GestureDetector(
                      onTap: isAI ? null : () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyChartsScreen())),
                      child: _ServiceCard(
                        service: Map<String, dynamic>.from(s),
                        index: i,
                        featured: (s['is_featured'] == true) || i == 1,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ---------- HEADER ----------
  Widget _header(AppLocalizations? l) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l?.services ?? 'Services',
              style: const TextStyle(
                fontFamily: 'Manrope',
                color: AppColors.ivory,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.gold.withOpacity(0.15)),
            ),
            child: const Icon(Icons.settings, color: AppColors.gold, size: 16),
          ),
        ],
      ),
    );
  }

  // ---------- SUBTITLE ----------
  Widget _subtitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'UNLOCK THE WISDOM OF YOUR CHART',
        style: TextStyle(
          fontFamily: 'monospace',
          color: AppColors.smoke,
          fontSize: 9,
          letterSpacing: 3,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ---------- CATEGORY CHIPS ----------
  Widget _categoryChips() {
    return SizedBox(
      height: 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final c = _categories[i];
          final active = _category == c;
          final label = c == 'all' ? 'All' : '${c[0].toUpperCase()}${c.substring(1)}';
          return GestureDetector(
            onTap: () => _onCategoryChange(c),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                gradient: active
                    ? const LinearGradient(colors: [AppColors.gold, AppColors.saffron])
                    : null,
                color: active ? null : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: active ? Colors.transparent : AppColors.gold.withOpacity(0.2),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  color: active ? AppColors.midnight : AppColors.ivory,
                  fontSize: 10,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------- SERVICE CARD ----------
class _ServiceCard extends StatelessWidget {
  final Map<String, dynamic> service;
  final int index;
  final bool featured;
  const _ServiceCard({
    required this.service,
    required this.index,
    required this.featured,
  });

  List<Color> _iconGradient(int idx) {
    final combos = <List<Color>>[
      [AppColors.gold, AppColors.saffron],
      [AppColors.aurora, AppColors.indigo],
      [AppColors.cosmicPink, AppColors.saffron],
      [AppColors.lavender, AppColors.indigo],
      [AppColors.saffron, AppColors.cosmicPink],
    ];
    return combos[idx % combos.length];
  }

  @override
  Widget build(BuildContext context) {
    final price = (service['price'] as num?)?.toDouble() ?? 0;
    final orig = (service['original_price'] as num?)?.toDouble();
    final isFree = service['is_free'] == true || price == 0;
    final name = service['service_name']?.toString() ?? '';
    final desc = service['description']?.toString() ?? '';
    final priceLabel = service['price_label']?.toString() ?? 'ONE-TIME';
    final iconEmoji = service['icon']?.toString() ?? '\u{1F4DC}';

    final titleColor = featured ? AppColors.midnight : AppColors.ivory;
    final descColor = featured
        ? AppColors.midnight.withOpacity(0.7)
        : AppColors.smoke;
    final metaColor = featured
        ? AppColors.midnight.withOpacity(0.7)
        : AppColors.smoke;
    final priceColor = featured ? AppColors.midnight : AppColors.gold;
    final strikeColor = featured
        ? AppColors.midnight.withOpacity(0.5)
        : AppColors.smoke;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: featured
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.gold, AppColors.saffron],
              )
            : null,
        color: featured ? null : Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: featured
            ? null
            : Border.all(color: AppColors.gold.withOpacity(0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon box
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: featured
                  ? LinearGradient(
                      colors: [
                        AppColors.midnight.withOpacity(0.15),
                        AppColors.midnight.withOpacity(0.08),
                      ],
                    )
                  : LinearGradient(colors: _iconGradient(index)),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              iconEmoji,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(width: 12),
          // Title + desc
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    color: titleColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (desc.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      color: descColor,
                      fontSize: 11,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Price column
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isFree)
                Text(
                  'FREE',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    color: featured ? AppColors.midnight : AppColors.success,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                )
              else
                RichText(
                  textAlign: TextAlign.right,
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      color: priceColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      height: 1.0,
                    ),
                    children: [
                      TextSpan(
                        text: '\u20b9 ',
                        style: TextStyle(
                          fontSize: 14,
                          color: priceColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(text: price.toInt().toString()),
                    ],
                  ),
                ),
              if (!isFree && orig != null && orig > price) ...[
                const SizedBox(height: 2),
                Text(
                  '\u20b9${orig.toInt()}',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    color: strikeColor,
                    fontSize: 11,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
              const SizedBox(height: 4),
              Text(
                priceLabel.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: metaColor,
                  fontSize: 8,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
