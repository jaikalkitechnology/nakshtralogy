import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../shared/responsive.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../home/promo_video.dart';
import '../broadcast_models.dart';
import '../broadcast_repository.dart';

typedef _LiveCubit = DataCubit<List<BroadcastNowItem>>;

/// Recorded astrologer videos (`GET /astrologer-videos`) shown under the live
/// list. A separate table from the Home promo carousel.
typedef _VideosCubit = DataCubit<List<AstrologerVideo>>;

/// Lists astrologers who are broadcasting right now. Tapping opens the
/// viewer. Below the live list, recorded astrologer videos (only entries that
/// are NOT currently live — a live astrologer shows their stream, not the
/// recording) open in the full-screen video player.
class LiveListScreen extends StatelessWidget {
  const LiveListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<_LiveCubit>(
          create: (_) =>
              DataCubit(() => getIt<BroadcastRepository>().now())..load(),
        ),
        BlocProvider<_VideosCubit>(
          create: (_) =>
              DataCubit(() => getIt<BroadcastRepository>().videos())..load(),
        ),
      ],
      child: const _LiveListView(),
    );
  }
}

class _LiveListView extends StatelessWidget {
  const _LiveListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: CenteredMaxWidth(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.canPop()
                            ? context.pop()
                            : context.go('/home'),
                        icon: Icon(
                          Icons.arrow_back,
                          color: AppColors.ivoryDim,
                        ),
                      ),
                      Text('Live now', style: AppTextStyles.display(size: 24)),
                      const SizedBox(width: 8),
                      const _LiveDot(),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<_LiveCubit, DataState<List<BroadcastNowItem>>>(
                    builder: (context, liveState) {
                      return BlocBuilder<_VideosCubit,
                          DataState<List<AstrologerVideo>>>(
                        builder: (context, videosState) {
                          return RefreshIndicator(
                            color: AppColors.saffron,
                            onRefresh: () => Future.wait([
                              context.read<_LiveCubit>().refresh(),
                              context.read<_VideosCubit>().refresh(),
                            ]),
                            child: _body(context, liveState, videosState),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _body(
    BuildContext context,
    DataState<List<BroadcastNowItem>> liveState,
    DataState<List<AstrologerVideo>> videosState,
  ) {
    final list = liveState.dataOrNull;
    if (list == null) {
      final err = liveState.errorMessage;
      if (err != null) return _scrollMessage(err, AppColors.danger);
      return const Center(
        child: CircularProgressIndicator(color: AppColors.saffron),
      );
    }
    // Recorded fallback: skip is_live entries — the live section above already
    // shows those astrologers' streams. Loading/error degrade to "none" so the
    // live list never waits on this nice-to-have section.
    final recorded = (videosState.dataOrNull ?? const <AstrologerVideo>[])
        .where((v) => !v.isLive)
        .toList();
    if (list.isEmpty && recorded.isEmpty) {
      return _scrollMessage(
        'No live sessions or recorded videos right now.\nPull down to refresh.',
        AppColors.ivoryFaint,
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = Responsive.gridColumns(constraints.maxWidth);
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            if (list.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 4, 12),
                child: Text(
                  'No one is live right now.\nPull down to refresh.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body(color: AppColors.ivoryFaint),
                ),
              )
            else if (columns == 1)
              for (final s in list)
                _LiveCard(
                  session: s,
                  onTap: () => context.push('/live/${s.id}'),
                )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  mainAxisExtent: 116,
                ),
                itemCount: list.length,
                itemBuilder: (context, i) => _LiveCard(
                  session: list[i],
                  onTap: () => context.push('/live/${list[i].id}'),
                ),
              ),
            if (recorded.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 12, 4, 12),
                child: Text(
                  'Recorded sessions',
                  style: AppTextStyles.heading(size: 16),
                ),
              ),
              if (columns == 1)
                for (final v in recorded)
                  _RecordedCard(video: v, onTap: () => _play(context, v))
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    mainAxisExtent: 116,
                  ),
                  itemCount: recorded.length,
                  itemBuilder: (context, i) => _RecordedCard(
                    video: recorded[i],
                    onTap: () => _play(context, recorded[i]),
                  ),
                ),
            ],
          ],
        );
      },
    );
  }

  /// Full-screen playback, reusing the Home featured-video player screen —
  /// same playback UI, different data source (astrologer-videos table).
  void _play(BuildContext context, AstrologerVideo v) {
    context.push(
      '/promo-video',
      extra: PromoVideo(
        id: v.id,
        title: v.title,
        videoUrl: v.videoUrl,
        thumbnailUrl: v.thumbnailUrl,
      ),
    );
  }

  Widget _scrollMessage(String text, Color color) => ListView(
    children: [
      const SizedBox(height: 160),
      Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyles.body(color: color),
        ),
      ),
    ],
  );
}

class _LiveCard extends StatelessWidget {
  const _LiveCard({required this.session, required this.onTap});
  final BroadcastNowItem session;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final photo = session.astrologerPhoto;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface1,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.borderSoft),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(18),
                ),
                child: SizedBox(
                  width: 96,
                  height: 96,
                  child: photo != null && photo.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: photo,
                          fit: BoxFit.cover,
                          placeholder: (_, _) =>
                              Container(color: AppColors.surface2),
                          errorWidget: (_, _, _) => const _AvatarFallback(),
                        )
                      : const _AvatarFallback(),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.live,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'LIVE',
                              style: AppTextStyles.mono(
                                size: 10,
                                weight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.visibility,
                            size: 14,
                            color: AppColors.ivoryFaint,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${session.currentViewers}',
                            style: AppTextStyles.mono(
                              size: 12,
                              color: AppColors.ivoryDim,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        session.astrologerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.heading(size: 16),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        session.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body(
                          size: 13,
                          color: AppColors.ivoryDim,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.play_circle_fill,
                  color: AppColors.saffron,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A recorded astrologer video card. Mirrors [_LiveCard]'s layout, but the
/// badge is a muted outlined "RECORDED" tag — deliberately distinct from the
/// solid red LIVE pill.
class _RecordedCard extends StatelessWidget {
  const _RecordedCard({required this.video, required this.onTap});
  final AstrologerVideo video;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final thumb = video.thumbnailUrl;
    final name = video.astrologerName;
    final photo = video.astrologerPhoto;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface1,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.borderSoft),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(18),
                ),
                child: SizedBox(
                  width: 96,
                  height: 96,
                  child: thumb != null && thumb.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: thumb,
                          fit: BoxFit.cover,
                          placeholder: (_, _) =>
                              Container(color: AppColors.surface2),
                          errorWidget: (_, _, _) => const _ThumbFallback(),
                        )
                      : const _ThumbFallback(),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface2,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.borderMid),
                        ),
                        child: Text(
                          'RECORDED',
                          style: AppTextStyles.mono(
                            size: 10,
                            weight: FontWeight.w700,
                            color: AppColors.ivoryDim,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (name != null && name.isNotEmpty)
                        Row(
                          children: [
                            if (photo != null && photo.isNotEmpty) ...[
                              CircleAvatar(
                                radius: 9,
                                backgroundColor: AppColors.indigoMid,
                                backgroundImage:
                                    CachedNetworkImageProvider(photo),
                              ),
                              const SizedBox(width: 6),
                            ],
                            Expanded(
                              child: Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.heading(size: 16),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 2),
                      Text(
                        video.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body(
                          size: 13,
                          color: AppColors.ivoryDim,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.play_circle_outline,
                  color: AppColors.saffron,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.indigoMid,
      alignment: Alignment.center,
      child: Icon(Icons.person, color: AppColors.ivoryFaint, size: 36),
    );
  }
}

/// Placeholder for recorded videos without a thumbnail.
class _ThumbFallback extends StatelessWidget {
  const _ThumbFallback();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.indigoMid,
      alignment: Alignment.center,
      child: Icon(
        Icons.ondemand_video,
        color: AppColors.ivoryFaint,
        size: 32,
      ),
    );
  }
}

class _LiveDot extends StatelessWidget {
  const _LiveDot();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: const BoxDecoration(
        color: AppColors.live,
        shape: BoxShape.circle,
      ),
    );
  }
}
