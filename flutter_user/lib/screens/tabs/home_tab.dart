import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/app_theme.dart';
import '../../bloc/astrologer/astrologer_bloc.dart';
import '../../bloc/astrologer/astrologer_event.dart';
import '../../bloc/astrologer/astrologer_state.dart';
import '../../bloc/service/service_bloc.dart';
import '../../bloc/service/service_event.dart';
import '../../bloc/service/service_state.dart';
import '../../services/api_service.dart';
import '../../widgets/astrologer_profile_sheet.dart';
import '../rashi/rashi_detail_screen.dart';

class HomeTab extends StatefulWidget {
  final VoidCallback onSeeAllAstrologers;
  final VoidCallback onSeeAllServices;
  const HomeTab({super.key, required this.onSeeAllAstrologers, required this.onSeeAllServices});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  static const _zodiacFallback = [
    {'idx': 0,  'name': 'Aries',       'emoji': '♈'},
    {'idx': 1,  'name': 'Taurus',      'emoji': '♉'},
    {'idx': 2,  'name': 'Gemini',      'emoji': '♊'},
    {'idx': 3,  'name': 'Cancer',      'emoji': '♋'},
    {'idx': 4,  'name': 'Leo',         'emoji': '♌'},
    {'idx': 5,  'name': 'Virgo',       'emoji': '♍'},
    {'idx': 6,  'name': 'Libra',       'emoji': '♎'},
    {'idx': 7,  'name': 'Scorpio',     'emoji': '♏'},
    {'idx': 8,  'name': 'Sagittarius', 'emoji': '♐'},
    {'idx': 9,  'name': 'Capricorn',   'emoji': '♑'},
    {'idx': 10, 'name': 'Aquarius',    'emoji': '♒'},
    {'idx': 11, 'name': 'Pisces',      'emoji': '♓'},
  ];

  List<Map<String, dynamic>> _rashis = List<Map<String, dynamic>>.from(_zodiacFallback);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AstrologerBloc>().add(const AstrologerLoadRequested(limit: 10));
      context.read<AstrologerBloc>().add(AstrologerSavedLoadRequested());
      context.read<ServiceBloc>().add(const ServiceLoadRequested());
      _loadRashiToday();
    });
  }

  Future<void> _loadRashiToday() async {
    try {
      final resp = await ApiService().getRashiToday();
      if (!mounted) return;
      if (resp['statusCode'] == 200 && resp['status'] == 'success') {
        final list = ((resp['data'] as Map)['rashis'] as List).cast<Map>();
        setState(() {
          _rashis = list.map((e) => e.cast<String, dynamic>()).toList();
        });
      }
    } catch (_) {/* keep fallback */}
  }

  Color _scoreColor(num? s) {
    final v = (s ?? 0).toDouble();
    if (v >= 2.5) return AppColors.success;
    if (v >= 0.5) return Colors.lightGreen;
    if (v >= -1.5) return Colors.amber;
    if (v >= -3.5) return Colors.orange;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        context.read<AstrologerBloc>().add(const AstrologerLoadRequested(limit: 10));
        context.read<ServiceBloc>().add(const ServiceLoadRequested());
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Greeting
          const Text(
            'Welcome back 🙏',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text(
            'What does the cosmos say today?',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 20),

          // Zodiac strip — today's gochar prediction, tap to open detail
          Row(children: const [
            Text('Rashi — Today\'s Prediction',
                style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
            Spacer(),
            Text('Tap to read more',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 10)),
          ]),
          const SizedBox(height: 10),
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _rashis.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final z = _rashis[i];
                final idx = (z['idx'] as num?)?.toInt() ?? i;
                final score = z['score'] as num?;
                final grade = z['grade']?.toString();
                final color = _scoreColor(score);
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => RashiDetailScreen(
                      rashiIdx: idx,
                      initialName: z['name']?.toString(),
                    ),
                  )),
                  child: Container(
                    width: 86,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: score != null ? color.withOpacity(0.5) : AppColors.border),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(z['emoji']?.toString() ?? z['symbol']?.toString() ?? '',
                            style: const TextStyle(fontSize: 26)),
                        const SizedBox(height: 2),
                        Text(
                          z['name']?.toString() ?? '',
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 10, fontWeight: FontWeight.w600),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        if (score != null) Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            grade ?? score.toStringAsFixed(1),
                            style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w700),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                        ) else const Text('tap', style: TextStyle(color: AppColors.textSecondary, fontSize: 8)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 22),

          // Services grid (center)
          Row(
            children: [
              const Expanded(
                child: Text('All Services',
                    style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
              ),
              TextButton(
                onPressed: widget.onSeeAllServices,
                child: const Text('View All', style: TextStyle(color: AppColors.primary, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          BlocBuilder<ServiceBloc, ServiceState>(
            builder: (context, state) {
              if (state is ServiceLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                );
              }
              final services = state is ServiceLoaded ? state.services : <dynamic>[];
              if (services.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Text('No services available',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                  ),
                );
              }
              final preview = services.take(6).toList();
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.4,
                ),
                itemCount: preview.length,
                itemBuilder: (_, i) {
                  final s = preview[i];
                  final price = (s['price'] as num?)?.toDouble() ?? 0;
                  final isFree = s['is_free'] == true || price == 0;
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s['icon'] ?? '📜', style: const TextStyle(fontSize: 20)),
                        const SizedBox(height: 6),
                        Text(
                          s['service_name'] ?? '',
                          style: const TextStyle(
                              color: AppColors.textPrimary, fontSize: 11, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          s['description'] ?? '',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 9),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isFree
                                ? AppColors.success.withValues(alpha: 0.15)
                                : AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            isFree ? 'FREE' : '₹${price.toInt()}',
                            style: TextStyle(
                              color: isFree ? AppColors.success : AppColors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 22),

          // Top Astrologers horizontal slider
          Row(
            children: [
              const Expanded(
                child: Text('Top Astrologers',
                    style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
              ),
              TextButton(
                onPressed: widget.onSeeAllAstrologers,
                child: const Text('View All', style: TextStyle(color: AppColors.primary, fontSize: 11)),
              ),
            ],
          ),
          const Text('Online experts ready for chat, call & video',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 9)),
          const SizedBox(height: 10),
          BlocBuilder<AstrologerBloc, AstrologerState>(
            builder: (context, state) {
              if (state.loading) {
                return const SizedBox(
                  height: 260,
                  child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                );
              }
              if (state.list.isEmpty) {
                return const SizedBox(
                  height: 120,
                  child: Center(
                    child: Text('No astrologers available',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                  ),
                );
              }
              return SizedBox(
                height: 260,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.list.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, i) {
                    final a = state.list[i];
                    return _AstroCard(astro: a);
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _AstroCard extends StatelessWidget {
  final dynamic astro;
  const _AstroCard({required this.astro});

  @override
  Widget build(BuildContext context) {
    final rating = (astro['rating'] as num?)?.toDouble() ?? 0.0;
    final isOnline = astro['is_online'] == true && astro['is_busy'] != true;
    final isBusy = astro['is_busy'] == true;

    return GestureDetector(
      onTap: () => showAstrologerProfileSheet(context, astro['id'] as String),
      child: Container(
        width: 170,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status + rating row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isOnline
                        ? AppColors.success.withValues(alpha: 0.15)
                        : isBusy
                            ? const Color(0xFFFACC15).withValues(alpha: 0.15)
                            : AppColors.border,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isOnline ? 'Online' : (isBusy ? 'Busy' : 'Offline'),
                    style: TextStyle(
                      color: isOnline
                          ? AppColors.success
                          : isBusy
                              ? const Color(0xFFFACC15)
                              : AppColors.textSecondary,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.star, color: AppColors.primary, size: 12),
                const SizedBox(width: 2),
                Text(
                  rating.toStringAsFixed(1),
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.surface,
                    backgroundImage: astro['profile_image_url'] != null
                        ? NetworkImage(astro['profile_image_url'] as String)
                        : null,
                    child: astro['profile_image_url'] == null
                        ? const Text('🔮', style: TextStyle(fontSize: 24))
                        : null,
                  ),
                  if (isOnline)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.card, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              astro['display_name'] ?? '—',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              ((astro['specializations'] as List?) ?? []).isNotEmpty
                  ? (astro['specializations'] as List).first.toString()
                  : 'Astrologer',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.primary, fontSize: 9),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${astro['experience_years'] ?? 0} yrs · ${astro['total_consultations'] ?? 0} sessions',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 8),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.only(top: 6),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _miniRate(Icons.chat_bubble_outline, (astro['rate_per_min_chat'] as num?)?.toDouble() ?? 0),
                  _miniRate(Icons.call, (astro['rate_per_min_call'] as num?)?.toDouble() ?? 0),
                  _miniRate(Icons.videocam, (astro['rate_per_min_video'] as num?)?.toDouble() ?? 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniRate(IconData icon, double rate) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 10),
        const SizedBox(height: 2),
        Text('₹${rate.toInt()}/m',
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 8)),
      ],
    );
  }
}
