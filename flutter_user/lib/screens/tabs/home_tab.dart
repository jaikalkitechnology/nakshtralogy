import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../widgets/astro_avatar.dart';
import '../../widgets/banner_slider.dart';
import '../../widgets/hover_lift.dart';
import '../../services/api_service.dart';
import '../../services/app_mode.dart';
import '../../services/iap_service.dart';
import '../../utils/money.dart';
import '../../bloc/astrologer/astrologer_bloc.dart';
import '../../bloc/astrologer/astrologer_event.dart';
import '../../bloc/astrologer/astrologer_state.dart';
import '../../bloc/service/service_bloc.dart';
import '../../bloc/service/service_event.dart';
import '../../bloc/service/service_state.dart';
import '../../widgets/astrologer_profile_sheet.dart';
import '../rashi/rashi_list_screen.dart';
import '../ai/ai_specialist_chat_screen.dart';
import '../../utils/home_labels.dart';
import '../specialist/specialist_list_screen.dart';
import '../specialist/specialist_chart_picker.dart';
import '../specialist/specialist_milan_picker.dart';
import '../specialist/specialist_relationship_picker.dart';
import '../forecast/forecast_chart_picker.dart';

class HomeTab extends StatefulWidget {
  final VoidCallback onSeeAllAstrologers;
  final VoidCallback onSeeAllServices;
  final VoidCallback? onOpenKundli;
  const HomeTab({super.key, required this.onSeeAllAstrologers, required this.onSeeAllServices, this.onOpenKundli});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  // Admin-controlled AI agent metadata keyed by domain key: {status, is_paid,
  // price, unlocked, free_intro}. Empty until loaded (then we filter the list).
  Map<String, dynamic> _agentMeta = {};
  bool _agentMetaLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AstrologerBloc>().add(const AstrologerLoadRequested(limit: 10));
      context.read<AstrologerBloc>().add(AstrologerSavedLoadRequested());
      context.read<ServiceBloc>().add(const ServiceLoadRequested());
      _loadAgents();
    });
  }

  Future<void> _loadAgents() async {
    final m = await ApiService().getAiAgents();
    if (mounted) setState(() { _agentMeta = m; _agentMetaLoaded = true; });
  }

  /// Open an AI specialist, applying the admin paywall for paid agents.
  Future<void> _openAiSpecialist(Map s) async {
    final key = s['key'] as String;
    final meta = _agentMeta[key] as Map<String, dynamic>?;
    final label = HomeLabels.label(key, Localizations.localeOf(context), s['label'] as String);
    final emoji = s['emoji'] as String;

    if (meta != null && meta['is_paid'] == true && meta['unlocked'] != true) {
      // Region-aware unlock. The backend attaches a session view: India pays ₹
      // from the wallet; international pays the USD tier via store IAP.
      final intl = (meta['pay_via'] == 'iap') || AppMode.instance.isInternational;
      final sessCurrency = (meta['session_currency'] as String?) ?? (intl ? 'USD' : 'INR');
      final sessAmount = (meta['session_amount'] as num?)?.toDouble() ??
          (intl
              ? (meta['price_usd'] as num?)?.toDouble() ?? 0
              : (meta['price'] as num?)?.toDouble() ?? 0);
      final priceLabel = Money.format(sessAmount, currency: sessCurrency);
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.card,
          title: Row(children: [Text(emoji, style: const TextStyle(fontSize: 22)), const SizedBox(width: 8),
            Expanded(child: Text(label, style: const TextStyle(color: AppColors.primary, fontSize: 16)))]),
          content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            if ((meta['free_intro'] ?? '').toString().isNotEmpty)
              Padding(padding: const EdgeInsets.only(bottom: 12),
                child: Text(meta['free_intro'].toString(), style: const TextStyle(color: AppColors.textPrimary, fontSize: 13))),
            Text(
              intl
                  ? 'Unlock this AI specialist for $priceLabel (one time), purchased securely through the app store.'
                  : 'Unlock this AI specialist for $priceLabel (one time). The amount is deducted from your wallet.',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary))),
            ElevatedButton(onPressed: () => Navigator.pop(ctx, true),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.midnight),
                child: Text('Unlock $priceLabel')),
          ],
        ),
      );
      if (ok != true) return;

      if (intl) {
        // International → store IAP → backend verify + grant.
        final productId = (meta['iap_product_id'] as String?) ?? '';
        if (productId.isEmpty) {
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('This specialist is not available for purchase yet.'),
            backgroundColor: AppColors.error));
          return;
        }
        final res = await IapService.instance.buyAgent(productId: productId, agentKey: key);
        if (!res.ok) {
          if (mounted && res.error != 'canceled') {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Could not complete the purchase. Please try again.'),
              backgroundColor: AppColors.error));
          }
          return;
        }
      } else {
        final resp = await ApiService().unlockAiAgent(key);
        if (resp['statusCode'] != 200) {
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(resp['detail'] ?? 'Could not unlock (check wallet balance)'),
            backgroundColor: AppColors.error));
          return;
        }
      }
      _agentMeta = {..._agentMeta, key: {...meta, 'unlocked': true}};
    }
    if (!mounted) return;
    await Navigator.push(context, MaterialPageRoute(
      builder: (_) => AiSpecialistChatScreen(domainKey: key, label: label, emoji: emoji),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return RefreshIndicator(
      color: AppColors.gold,
      onRefresh: () async {
        context.read<AstrologerBloc>().add(const AstrologerLoadRequested(limit: 10));
        context.read<ServiceBloc>().add(const ServiceLoadRequested());
      },
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Hero banner
          _heroBanner(l),

          // Admin-managed promotional banners (slider)
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: BannerSlider(),
          ),

          // Quick actions
          _quickActions(l),

          // AI Specialists
          const SizedBox(height: 16),
          _sectionHeader(l.chatWithAISpecialist, l.tapToStart),
          const SizedBox(height: 10),
          _aiSpecialistCarousel(),

          // Reports (replaces Services)
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              Expanded(child: Text(l.specialistReports,
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
        Text(l.jupiterFavorsBold,
            style: const TextStyle(fontFamily: 'Manrope', fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.ivory, height: 1.1)),
        const SizedBox(height: 6),
        Text(l.careerIlluminated,
            style: const TextStyle(color: AppColors.lavender, fontSize: 12)),
      ]),
    );
  }

  Widget _quickActions(AppLocalizations l) {
    final actions = [
      {'icon': Icons.star, 'label': l.astrologer, 'color': AppColors.gold, 'onTap': widget.onSeeAllAstrologers},
      {'icon': Icons.auto_awesome, 'label': l.kundli, 'color': AppColors.aurora, 'onTap': widget.onOpenKundli},
      {'icon': Icons.assessment, 'label': l.reports, 'color': Colors.purple, 'onTap': () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => const SpecialistListScreen()))},
      {'icon': Icons.favorite, 'label': l.milan, 'color': AppColors.cosmicPink, 'onTap': () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => const SpecialistMilanPicker()))},
      {'icon': Icons.wb_sunny, 'label': l.forecast, 'color': Colors.orange, 'onTap': () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ForecastChartPicker()))},
      {'icon': Icons.auto_awesome_mosaic, 'label': l.rashi, 'color': AppColors.aurora, 'onTap': () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => const RashiListScreen()))},
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: LayoutBuilder(builder: (context, c) {
        // 6-up on desktop, 3-up on mobile — sized off the actual available
        // width so the tiles stay compact instead of ballooning on desktop.
        final cols = c.maxWidth >= 720 ? 6 : 3;
        const gap = 8.0;
        final tileW = (c.maxWidth - gap * (cols - 1)) / cols;
        return Wrap(spacing: gap, runSpacing: gap, children: actions.map((a) => SizedBox(
        width: tileW,
        child: HoverLift(child: GestureDetector(
          onTap: a['onTap'] as VoidCallback?,
          child: Container(
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
        ))),
      )).toList());
      }),
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
    // Show only the agents the admin has made visible to this user (published,
    // or testing + tester). We ALWAYS filter by the backend metadata so an
    // admin "draft" agent never leaks into the app — before metadata loads we
    // show nothing rather than the full static list (which would flash drafts).
    if (!_agentMetaLoaded) return const SizedBox.shrink();
    final visible =
        _aiSpecialists.where((s) => _agentMeta.containsKey(s['key'])).toList();
    if (visible.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: visible.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final s = visible[i];
          final color = s['color'] as Color;
          final meta = _agentMeta[s['key']] as Map<String, dynamic>?;
          final locked = meta != null && meta['is_paid'] == true && meta['unlocked'] != true;
          final price = (meta?['price'] as num?)?.toDouble() ?? 0;
          return GestureDetector(
            onTap: () => _openAiSpecialist(s),
            child: Stack(children: [
            Container(
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
                Text(HomeLabels.label(s['key'] as String, Localizations.localeOf(context), s['label'] as String), style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w700),
                    maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
              ]),
            ),
            if (locked)
              Positioned(top: 4, right: 4, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(8)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.lock, size: 9, color: AppColors.midnight),
                  const SizedBox(width: 2),
                  Text('₹${price.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.midnight, fontSize: 8, fontWeight: FontWeight.bold)),
                ]),
              )),
          ]));
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
      // Auto-fit columns by width (≈3-up desktop, 2-up mobile) with a fixed
      // compact row height so cards never stretch on large screens.
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 360, crossAxisSpacing: 10, mainAxisSpacing: 10, mainAxisExtent: 62,
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
                  specialistKey: r['key']!, specialistLabel: HomeLabels.label(r['key']!, Localizations.localeOf(context), r['label']!), specialistEmoji: r['emoji']!)));
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
              Expanded(child: Text(HomeLabels.label(r['key']!, Localizations.localeOf(context), r['label']!), maxLines: 2, overflow: TextOverflow.ellipsis,
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
            // Region-aware: the backend attaches a session view (USD/IAP for
            // international, ₹/wallet for India) using the X-Device-Country
            // hint. Show that instead of the raw ₹ column.
            final sessCurrency = (s['session_currency'] as String?) ??
                (AppMode.instance.isInternational ? 'USD' : 'INR');
            final sessAmount = (s['session_amount'] as num?)?.toDouble() ??
                (s['price'] as num?)?.toDouble() ?? 0;
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
                    child: Text(isFree ? 'FREE' : Money.format(sessAmount, currency: sessCurrency),
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

/// Region-aware per-minute chat rate label for an astrologer list row
/// (USD for international via the 5× rule, ₹ for India).
String _astroRate(dynamic astro) {
  final cur = (astro['session_currency'] as String?) ?? 'INR';
  final rate = (astro['rate_chat_display'] as num?)?.toDouble() ??
      (astro['rate_per_min_chat'] as num?)?.toDouble() ?? 0;
  return cur.toUpperCase() == 'USD'
      ? Money.format(rate, currency: 'USD', decimals: 2)
      : Money.format(rate, currency: 'INR', decimals: 0);
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
            AstroAvatar(
              // Fall back to the Google/account photo when no uploaded image,
              // matching the astrologers tab & profile sheet (else it's blank).
              imageUrl: ((astro['profile_image_url'] ?? '').toString().isNotEmpty)
                  ? astro['profile_image_url']?.toString()
                  : astro['user_avatar']?.toString(),
              name: (astro['display_name'] ?? '').toString(),
              size: 48,
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
              Text('  \u00b7  ${_astroRate(astro)}/min',
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
