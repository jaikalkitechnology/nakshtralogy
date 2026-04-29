import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/gen/app_localizations.dart';
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
import '../ai/ai_specialist_chat_screen.dart';
import '../milan/milan_chart_selector.dart';
import '../specialist/specialist_list_screen.dart';
import '../specialist/specialist_chart_picker.dart';
import '../specialist/specialist_milan_picker.dart';
import '../specialist/specialist_relationship_picker.dart';
import '../forecast/forecast_chart_picker.dart';
import '../forecast/rashi_report_screen.dart';

class HomeTab extends StatefulWidget {
  final VoidCallback onSeeAllAstrologers;
  final VoidCallback onSeeAllServices;
  final VoidCallback? onOpenKundli;
  const HomeTab({super.key, required this.onSeeAllAstrologers, required this.onSeeAllServices, this.onOpenKundli});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  static const _zodiacFallback = [
    {'idx': 0,  'name': 'Aries',       'emoji': '\u2648'},
    {'idx': 1,  'name': 'Taurus',      'emoji': '\u2649'},
    {'idx': 2,  'name': 'Gemini',      'emoji': '\u264a'},
    {'idx': 3,  'name': 'Cancer',      'emoji': '\u264b'},
    {'idx': 4,  'name': 'Leo',         'emoji': '\u264c'},
    {'idx': 5,  'name': 'Virgo',       'emoji': '\u264d'},
    {'idx': 6,  'name': 'Libra',       'emoji': '\u264e'},
    {'idx': 7,  'name': 'Scorpio',     'emoji': '\u264f'},
    {'idx': 8,  'name': 'Sagittarius', 'emoji': '\u2650'},
    {'idx': 9,  'name': 'Capricorn',   'emoji': '\u2651'},
    {'idx': 10, 'name': 'Aquarius',    'emoji': '\u2652'},
    {'idx': 11, 'name': 'Pisces',      'emoji': '\u2653'},
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
        setState(() { _rashis = list.map((e) => e.cast<String, dynamic>()).toList(); });
      }
    } catch (_) {}
  }

  Color _scoreColor(num? s) {
    final v = (s ?? 0).toDouble();
    if (v >= 2.5) return AppColors.success;
    if (v >= 0.5) return AppColors.aurora;
    if (v >= -1.5) return AppColors.goldBright;
    if (v >= -3.5) return AppColors.saffron;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return RefreshIndicator(
      color: AppColors.gold,
      onRefresh: () async {
        context.read<AstrologerBloc>().add(const AstrologerLoadRequested(limit: 10));
        context.read<ServiceBloc>().add(const ServiceLoadRequested());
        _loadRashiToday();
      },
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Hero banner
          _heroBanner(l),

          // Quick actions
          _quickActions(l),

          // AI Specialists
          const SizedBox(height: 16),
          _sectionHeader('Chat with AI Specialist', 'Tap to start'),
          const SizedBox(height: 10),
          _aiSpecialistCarousel(),

          // Rashi carousel
          const SizedBox(height: 16),
          _sectionHeader(l.todaysRashi, l.tapDetails),
          const SizedBox(height: 10),
          _rashiCarousel(),

          // Reports (replaces Services)
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              const Expanded(child: Text('Specialist Reports',
                  style: TextStyle(fontFamily: 'Manrope', color: AppColors.ivory, fontSize: 16, fontWeight: FontWeight.w700))),
              GestureDetector(
                onTap: widget.onSeeAllServices,
                child: Text('${l.seeAll} \u2192', style: const TextStyle(color: AppColors.gold, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1)),
              ),
            ]),
          ),
          const SizedBox(height: 10),
          _reportsGrid(),

          // Astrologers
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              Expanded(child: Text(l.topAstrologers,
                  style: const TextStyle(fontFamily: 'Manrope', color: AppColors.ivory, fontSize: 16, fontWeight: FontWeight.w700))),
              GestureDetector(
                onTap: widget.onSeeAllAstrologers,
                child: Text('${l.seeAll} \u2192', style: const TextStyle(color: AppColors.gold, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1)),
              ),
            ]),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(l.onlineExperts, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
          ),
          const SizedBox(height: 10),
          _astrologersList(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _heroBanner(AppLocalizations l) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0x33E8B547), Color(0x26E07A3C), Color(0x4D4A3B8C)],
        ),
        border: Border.all(color: AppColors.gold.withOpacity(0.3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l.todaysHoroscope, style: TextStyle(
          fontFamily: 'Manrope', fontSize: 9, letterSpacing: 3, color: AppColors.gold, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        const Text('Jupiter favors bold moves',
            style: TextStyle(fontFamily: 'Manrope', fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.ivory, height: 1.1)),
        const SizedBox(height: 6),
        const Text('Your career sector is illuminated \u2014 trust your instincts.',
            style: TextStyle(color: AppColors.lavender, fontSize: 12)),
      ]),
    );
  }

  Widget _quickActions(AppLocalizations l) {
    final actions = [
      {'icon': Icons.chat_bubble, 'label': l.chat, 'color': AppColors.gold, 'onTap': widget.onSeeAllAstrologers},
      {'icon': Icons.call, 'label': l.call, 'color': AppColors.saffron, 'onTap': widget.onSeeAllAstrologers},
      {'icon': Icons.videocam, 'label': l.video, 'color': AppColors.cosmicPink, 'onTap': widget.onSeeAllAstrologers},
      {'icon': Icons.auto_awesome, 'label': l.kundli, 'color': AppColors.aurora, 'onTap': widget.onOpenKundli},
      {'icon': Icons.favorite, 'label': 'Milan', 'color': AppColors.cosmicPink, 'onTap': () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => const MilanChartSelector()))},
      {'icon': Icons.assessment, 'label': 'Reports', 'color': Colors.purple, 'onTap': () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => const SpecialistListScreen()))},
      {'icon': Icons.wb_sunny, 'label': 'Forecast', 'color': Colors.orange, 'onTap': () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ForecastChartPicker()))},
      {'icon': Icons.auto_awesome, 'label': 'Rashi', 'color': AppColors.aurora, 'onTap': () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => const RashiReportScreen()))},
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(children: actions.map((a) => Expanded(
        child: GestureDetector(
          onTap: a['onTap'] as VoidCallback?,
          child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.gold.withOpacity(0.15)),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [a['color'] as Color, AppColors.saffron]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(a['icon'] as IconData, color: AppColors.midnight, size: 18),
            ),
            const SizedBox(height: 6),
            Text(a['label'] as String, style: const TextStyle(color: AppColors.ivory, fontSize: 10, fontWeight: FontWeight.w600)),
          ]),
        )),
      )).toList()),
    );
  }

  Widget _sectionHeader(String title, String trailing) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(children: [
        Text(title, style: const TextStyle(fontFamily: 'Manrope', color: AppColors.ivory, fontSize: 16, fontWeight: FontWeight.w700)),
        const Spacer(),
        Text(trailing, style: const TextStyle(color: AppColors.smoke, fontSize: 10)),
      ]),
    );
  }

  static const _aiSpecialists = [
    {'key': 'career_job',       'label': 'Career & Job',          'emoji': '\u{1F4BC}', 'color': AppColors.gold},
    {'key': 'business_startup', 'label': 'Business & Startup',    'emoji': '\u{1F680}', 'color': AppColors.saffron},
    {'key': 'education_career', 'label': 'Education',             'emoji': '\u{1F393}', 'color': AppColors.aurora},
    {'key': 'money_wealth',     'label': 'Money & Wealth',        'emoji': '\u{1F4B0}', 'color': AppColors.goldBright},
    {'key': 'debt_recovery',    'label': 'Debt Recovery',         'emoji': '\u{1F4C9}', 'color': AppColors.error},
    {'key': 'love_relationship','label': 'Love & Relationship',   'emoji': '\u2764\ufe0f','color': AppColors.cosmicPink},
    {'key': 'marriage_family',  'label': 'Marriage & Family',     'emoji': '\u{1F492}', 'color': AppColors.lavender},
    {'key': 'health_wellness',  'label': 'Health & Wellness',     'emoji': '\u{1F3E5}', 'color': AppColors.success},
    {'key': 'mental_stress',    'label': 'Mental Stress',         'emoji': '\u{1F9E0}', 'color': AppColors.indigo},
    {'key': 'property_assets',  'label': 'Property & Assets',     'emoji': '\u{1F3E0}', 'color': AppColors.saffron},
    {'key': 'legal_dispute',    'label': 'Legal & Dispute',       'emoji': '\u2696\ufe0f','color': AppColors.smoke},
    {'key': 'life_path_luck',   'label': 'Life Path & Luck',      'emoji': '\u{1F31F}', 'color': AppColors.gold},
  ];

  Widget _aiSpecialistCarousel() {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _aiSpecialists.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final s = _aiSpecialists[i];
          final color = s['color'] as Color;
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => AiSpecialistChatScreen(
                domainKey: s['key'] as String,
                label: s['label'] as String,
                emoji: s['emoji'] as String,
              ),
            )),
            child: Container(
              width: 90,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(s['emoji'] as String, style: const TextStyle(fontSize: 26)),
                const SizedBox(height: 4),
                Text(s['label'] as String, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w700),
                    maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
              ]),
            ),
          );
        },
      ),
    );
  }

  Widget _rashiCarousel() {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
              builder: (_) => RashiDetailScreen(rashiIdx: idx, initialName: z['name']?.toString()),
            )),
            child: Container(
              width: 78,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: score != null ? color.withOpacity(0.4) : AppColors.gold.withOpacity(0.12)),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(z['emoji']?.toString() ?? '', style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 2),
                Text(z['name']?.toString() ?? '', style: const TextStyle(color: AppColors.ivory, fontSize: 9, fontWeight: FontWeight.w600),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                if (score != null) Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                  child: Text(grade ?? score.toStringAsFixed(1),
                      style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.w700),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
              ]),
            ),
          );
        },
      ),
    );
  }

  static const _reportsPreview = <Map<String, String>>[
    {'key': 'career',        'label': 'Career & Job',      'emoji': '💼'},
    {'key': 'wealth',        'label': 'Wealth',            'emoji': '💰'},
    {'key': 'marriage',      'label': 'Marriage',          'emoji': '💒'},
    {'key': 'love',          'label': 'Love',              'emoji': '❤️'},
    {'key': 'health',        'label': 'Health',            'emoji': '🏥'},
    {'key': 'business',      'label': 'Business',          'emoji': '🚀'},
    {'key': 'kundli_milan',  'label': 'Kundli Milan',      'emoji': '💑'},
    {'key': 'relationship',  'label': 'Relationships',     'emoji': '🔗'},
  ];

  Widget _reportsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.6,
      ),
      itemCount: _reportsPreview.length,
      itemBuilder: (_, i) {
        final r = _reportsPreview[i];
        return GestureDetector(
          onTap: () {
            if (r['key'] == 'kundli_milan') {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SpecialistMilanPicker()));
            } else if (r['key'] == 'relationship') {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SpecialistRelationshipPicker()));
            } else {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => SpecialistChartPicker(
                  specialistKey: r['key']!, specialistLabel: r['label']!, specialistEmoji: r['emoji']!)));
            }
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.gold.withOpacity(0.10), AppColors.saffron.withOpacity(0.04)]),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.gold.withOpacity(0.2)),
            ),
            child: Row(children: [
              Container(width: 38, height: 38,
                decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                child: Center(child: Text(r['emoji']!, style: const TextStyle(fontSize: 18)))),
              const SizedBox(width: 10),
              Expanded(child: Text(r['label']!, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.ivory, fontSize: 11, fontWeight: FontWeight.w700))),
            ]),
          ),
        );
      },
    );
  }

  Widget _servicesGrid() {
    return BlocBuilder<ServiceBloc, ServiceState>(
      builder: (context, state) {
        if (state is ServiceLoading) {
          return const Padding(padding: EdgeInsets.all(20), child: Center(child: CircularProgressIndicator(color: AppColors.gold)));
        }
        final services = state is ServiceLoaded ? state.services : <dynamic>[];
        if (services.isEmpty) return const SizedBox.shrink();
        final preview = services.take(6).toList();
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.2,
          ),
          itemCount: preview.length,
          itemBuilder: (_, i) {
            final s = preview[i];
            final price = (s['price'] as num?)?.toDouble() ?? 0;
            final isFree = s['is_free'] == true || price == 0;
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.gold.withOpacity(0.12)),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text(s['icon'] ?? '\u{1F4DC}', style: const TextStyle(fontSize: 20)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isFree ? AppColors.success.withOpacity(0.15) : AppColors.gold.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(isFree ? 'FREE' : '\u20b9${price.toInt()}',
                        style: TextStyle(color: isFree ? AppColors.success : AppColors.gold, fontSize: 9, fontWeight: FontWeight.w700)),
                  ),
                ]),
                const SizedBox(height: 8),
                Text(s['service_name'] ?? '', style: const TextStyle(color: AppColors.ivory, fontSize: 12, fontWeight: FontWeight.w600),
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Expanded(child: Text(s['description'] ?? '', style: const TextStyle(color: AppColors.smoke, fontSize: 9),
                    maxLines: 3, overflow: TextOverflow.ellipsis)),
              ]),
            );
          },
        );
      },
    );
  }

  Widget _astrologersList() {
    return BlocBuilder<AstrologerBloc, AstrologerState>(
      builder: (context, state) {
        if (state.loading) {
          return const SizedBox(height: 120, child: Center(child: CircularProgressIndicator(color: AppColors.gold)));
        }
        if (state.list.isEmpty) return const SizedBox.shrink();
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: state.list.length.clamp(0, 5),
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) => _AstroCard(astro: state.list[i]),
        );
      },
    );
  }
}

class _AstroCard extends StatelessWidget {
  final dynamic astro;
  const _AstroCard({required this.astro});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final rating = (astro['rating'] as num?)?.toDouble() ?? 0.0;
    final isOnline = astro['is_online'] == true && astro['is_busy'] != true;
    final isBusy = astro['is_busy'] == true;
    final initial = (astro['display_name'] ?? 'A').toString()[0].toUpperCase();

    return GestureDetector(
      onTap: () => showAstrologerProfileSheet(context, astro['id'] as String),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.nebula.withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.gold.withOpacity(0.15)),
        ),
        child: Row(children: [
          // Avatar with online dot
          Stack(children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(colors: [AppColors.saffron, AppColors.cosmicPink]),
                border: Border.all(color: AppColors.gold, width: 2),
              ),
              child: astro['profile_image_url'] != null
                  ? ClipOval(child: Image.network(astro['profile_image_url'], fit: BoxFit.cover, width: 48, height: 48,
                      errorBuilder: (_, __, ___) => Center(child: Text(initial, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)))))
                  : Center(child: Text(initial, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700))),
            ),
            if (isOnline) Positioned(bottom: 1, right: 1, child: Container(
              width: 12, height: 12,
              decoration: BoxDecoration(color: AppColors.success, shape: BoxShape.circle, border: Border.all(color: AppColors.midnight, width: 2)),
            )),
          ]),
          const SizedBox(width: 12),
          // Info
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(astro['display_name'] ?? '\u2014', style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w700)),
            Text(
              ((astro['specializations'] as List?) ?? []).isNotEmpty
                  ? (astro['specializations'] as List).take(2).join(' \u00b7 ')
                  : 'Astrologer',
              style: const TextStyle(color: AppColors.smoke, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 3),
            Row(children: [
              Text('\u2605 ${rating.toStringAsFixed(1)}', style: const TextStyle(color: AppColors.gold, fontSize: 10, fontWeight: FontWeight.w600)),
              Text('  \u00b7  \u20b9${(astro['rate_per_min_chat'] as num?)?.toInt() ?? 0}/min',
                  style: const TextStyle(color: AppColors.smoke, fontSize: 10)),
            ]),
          ])),
          // CTA
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.gold, AppColors.saffron]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(l.chat, style: const TextStyle(color: AppColors.midnight, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
          ),
        ]),
      ),
    );
  }
}
