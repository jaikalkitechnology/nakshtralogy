import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hj_core/hj_core.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/di.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/responsive.dart';
import '../../shared/widgets/astrologer_card.dart';
import '../discovery/discovery_repository.dart';
import 'banners_repository.dart';
import 'promo_video.dart';
import 'promo_videos_repository.dart';

typedef _FeaturedCubit = DataCubit<List<Astrologer>>;
typedef _PromoVideosCubit = DataCubit<List<PromoVideo>>;
typedef _BannersCubit = DataCubit<List<HomeBanner>>;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<_FeaturedCubit>(
          create: (_) =>
              DataCubit(() => getIt<DiscoveryRepository>().list(online: true))
                ..load(),
        ),
        BlocProvider<_PromoVideosCubit>(
          create: (_) => DataCubit(() => getIt<PromoVideosRepository>().list())..load(),
        ),
        BlocProvider<_BannersCubit>(
          create: (_) => DataCubit(() => getIt<BannersRepository>().list())..load(),
        ),
      ],
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthCubit c) => c.state.user);
    final l = AppLocalizations.of(context);
    return SafeArea(
      child: CenteredMaxWidth(
        maxWidth: Responsive.readableMaxWidth,
        child: RefreshIndicator(
          color: AppColors.saffron,
          onRefresh: () => Future.wait([
            context.read<_FeaturedCubit>().refresh(),
            context.read<_PromoVideosCubit>().refresh(),
            context.read<_BannersCubit>().refresh(),
          ]),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.homeGreeting,
                          style: AppTextStyles.label(
                            size: 12.5,
                            color: AppColors.copperLight,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user?.name ?? l.homeSeeker,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.display(size: 25),
                        ),
                      ],
                    ),
                  ),
                  _WalletChip(balance: user?.walletBalance ?? '0.00'),
                ],
              ),
              const SizedBox(height: 20),
              _PromoBanner(),
              const _AdminBannersSection(),
              const SizedBox(height: 12),
              _LiveBanner(),
              const SizedBox(height: 24),
              const _FeaturedVideosSection(),
              const SizedBox(height: 24),
              Text(l.homeCosmicInsights, style: AppTextStyles.heading(size: 18)),
              const SizedBox(height: 12),
              _QuickTools(),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l.homeOnlineAstrologers,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.heading(size: 18),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/astrologers'),
                    child: Text(
                      l.commonSeeAll,
                      style: AppTextStyles.label(
                        color: AppColors.saffronBright,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              BlocBuilder<_FeaturedCubit, DataState<List<Astrologer>>>(
                builder: (context, state) {
                  final list = state.dataOrNull;
                  if (list == null) {
                    final err = state.errorMessage;
                    if (err != null) return _ErrorNote(message: err);
                    return const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.saffron,
                        ),
                      ),
                    );
                  }
                  if (list.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        l.homeNoAstrologersOnline,
                        style: AppTextStyles.body(color: AppColors.ivoryFaint),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      for (final a in list)
                        AstrologerCard(
                          astrologer: a,
                          onTap: () => context.push('/astrologers/${a.id}'),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WalletChip extends StatelessWidget {
  const _WalletChip({required this.balance});
  final String balance;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/wallet'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.goldGlow,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.borderMid),
          boxShadow: const [
            BoxShadow(color: AppColors.goldHalo, blurRadius: 14, spreadRadius: -4),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.account_balance_wallet,
              color: AppColors.gold,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              '₹$balance',
              style: AppTextStyles.mono(size: 13, color: AppColors.gold),
            ),
          ],
        ),
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.heroGradient,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderMid),
        boxShadow: const [
          BoxShadow(color: AppColors.shadowSoft, blurRadius: 18, offset: Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.homePromoTitle,
                  style: AppTextStyles.heading(size: 17),
                ),
                const SizedBox(height: 6),
                Text(
                  l.homePromoSubtitle,
                  style: AppTextStyles.body(
                    size: 13,
                    color: AppColors.ivoryDim,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.goldGlow,
              boxShadow: [
                BoxShadow(color: AppColors.goldHalo, blurRadius: 18, spreadRadius: -2),
              ],
            ),
            child: const Icon(Icons.auto_awesome, color: AppColors.gold, size: 30),
          ),
        ],
      ),
    );
  }
}

class _LiveBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return InkWell(
      onTap: () => context.push('/live'),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface1,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.live.withValues(alpha: 0.28)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.live,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.live.withValues(alpha: 0.45),
                    blurRadius: 12,
                    spreadRadius: -2,
                  ),
                ],
              ),
              child: Text(
                'LIVE',
                style: AppTextStyles.mono(
                  size: 11,
                  weight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.homeLiveTitle,
                    style: AppTextStyles.heading(size: 16),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l.homeLiveSubtitle,
                    style: AppTextStyles.body(
                      size: 12,
                      color: AppColors.ivoryDim,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.ivoryDim),
          ],
        ),
      ),
    );
  }
}

class _QuickTools extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final tools = <(String, IconData)>[
      (l.toolDailyHoroscope, Icons.wb_sunny_outlined),
      (l.toolDetailedKundli, Icons.grid_4x4),
      (l.toolLoveMatch, Icons.favorite_border),
      (l.toolPlanetPosition, Icons.public),
    ];
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 0.82,
      children: [
        for (final t in tools)
          InkWell(
            onTap: () => context.go('/insights'),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.surface2, AppColors.copperGlow],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderSoft),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(t.$2, color: AppColors.copperLight, size: 24),
                  const SizedBox(height: 8),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        t.$1,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.label(
                          size: 10,
                          color: AppColors.ivoryDim,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Admin-configured banner carousel from `GET /banners`, shown between the
/// promo card and the Live section. Same degrade philosophy as
/// [_FeaturedVideosSection]: hidden entirely while loading, on failure or
/// when the admin has configured no banners.
class _AdminBannersSection extends StatelessWidget {
  const _AdminBannersSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<_BannersCubit, DataState<List<HomeBanner>>>(
      builder: (context, state) {
        final banners =
            state.dataOrNull?.where((b) => b.imageUrl.isNotEmpty).toList();
        if (banners == null || banners.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // ~16:7 cards; with multiple banners the next card peeks in to
              // signal horizontal swipeability.
              final cardWidth = banners.length > 1
                  ? constraints.maxWidth * 0.92
                  : constraints.maxWidth;
              final height = cardWidth * 7 / 16;
              return SizedBox(
                height: height,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: banners.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, i) => SizedBox(
                    width: cardWidth,
                    child: _BannerCard(banner: banners[i]),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _BannerCard extends StatelessWidget {
  const _BannerCard({required this.banner});
  final HomeBanner banner;

  Future<void> _open(BuildContext context) async {
    final link = banner.linkUrl?.trim() ?? '';
    if (link.isEmpty) return;
    final uri = Uri.tryParse(link);
    if (uri == null) return;
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Exception {
      // Malformed/unhandled URL — the banner stays display-only.
    }
  }

  @override
  Widget build(BuildContext context) {
    final tappable = (banner.linkUrl?.trim().isNotEmpty ?? false);
    return Semantics(
      label: banner.title,
      button: tappable,
      child: InkWell(
        onTap: tappable ? () => _open(context) : null,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface1,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.borderSoft),
          ),
          clipBehavior: Clip.antiAlias,
          child: CachedNetworkImage(
            imageUrl: banner.imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            errorWidget: (_, _, _) => Container(color: AppColors.surface2),
          ),
        ),
      ),
    );
  }
}

/// Horizontal "Featured videos" carousel from `GET /promo-videos`. Degrades
/// to nothing (no empty-state clutter, no error banner) when there's no
/// content or the fetch fails — this section is a nice-to-have, not core
/// navigation.
class _FeaturedVideosSection extends StatelessWidget {
  const _FeaturedVideosSection();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return BlocBuilder<_PromoVideosCubit, DataState<List<PromoVideo>>>(
      builder: (context, state) {
        final videos = state.dataOrNull;
        if (videos == null || videos.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.homeFeaturedVideos, style: AppTextStyles.heading(size: 18)),
            const SizedBox(height: 12),
            SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: videos.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, i) => _VideoCard(video: videos[i]),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _VideoCard extends StatelessWidget {
  const _VideoCard({required this.video});
  final PromoVideo video;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/promo-video', extra: video),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          color: AppColors.surface1,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderSoft),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (video.thumbnailUrl != null && video.thumbnailUrl!.isNotEmpty)
              CachedNetworkImage(
                imageUrl: video.thumbnailUrl!,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) => Container(color: AppColors.surface2),
              )
            else
              Container(color: AppColors.surface2),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.75)],
                ),
              ),
            ),
            const Center(
              child: Icon(Icons.play_circle_fill, color: Colors.white, size: 40),
            ),
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: Text(
                video.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body(size: 13, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorNote extends StatelessWidget {
  const _ErrorNote({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        style: AppTextStyles.body(size: 13, color: AppColors.danger),
      ),
    );
  }
}
