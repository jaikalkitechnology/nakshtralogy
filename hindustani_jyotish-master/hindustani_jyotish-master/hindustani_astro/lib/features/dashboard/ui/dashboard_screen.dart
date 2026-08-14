import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/responsive.dart';
import '../../../shared/premium_ui.dart';
import '../../auth/astro_session_cubit.dart';
import '../../notifications/notification_bell.dart';
import '../../portal/portal_repository.dart';
import '../dashboard_cubit.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DashboardCubit>(
      create: (_) => DashboardCubit(getIt<PortalRepository>())..load(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    final astro = context.select((AstroSessionCubit c) => c.state.astrologer);
    return SafeArea(
      bottom: false,
      child: BlocConsumer<DashboardCubit, DashboardState>(
        listenWhen: (p, c) => p.error != c.error && c.error != null,
        listener: (context, state) =>
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error!))),
        builder: (context, state) {
          final cubit = context.read<DashboardCubit>();
          return RefreshIndicator(
            onRefresh: cubit.refresh,
            color: AppColors.saffron,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                CenteredMaxWidth(
                  maxWidth: 640,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _Header(astro: astro),
                      const SizedBox(height: 18),
                      _OnlineCard(
                        online: state.isOnline,
                        busy: state.toggling,
                        onChanged: cubit.toggleOnline,
                      ),
                      const SizedBox(height: 24),
                      Text("Today's Overview",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.heading(size: 17, color: AppColors.ivoryDim)),
                      const SizedBox(height: 14),
                      _StatsOrLoader(state: state, astro: astro),
                      const SizedBox(height: 22),
                      PremiumPrimaryButton(
                        label: 'Go Live Now',
                        icon: Icons.videocam_rounded,
                        height: 58,
                        onPressed: () => context.push('/live'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Top row — Namaste greeting + astrologer name on the left, notification
/// bell on the right (settings/logout live on the Profile tab).
class _Header extends StatelessWidget {
  const _Header({required this.astro});
  final Astrologer? astro;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final photoUrl = astro?.photoUrl;
    final name = astro?.displayName ?? l.profileAstrologer;
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: (photoUrl == null || photoUrl.isEmpty)
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.saffronBright, AppColors.saffronDeep],
                  )
                : null,
            image: (photoUrl != null && photoUrl.isNotEmpty)
                ? DecorationImage(image: NetworkImage(photoUrl), fit: BoxFit.cover)
                : null,
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.5), width: 1.5),
          ),
          child: (photoUrl == null || photoUrl.isEmpty)
              ? Text(name.isNotEmpty ? name[0].toUpperCase() : '🪔',
                  style: AppTextStyles.display(size: 22, color: Colors.white))
              : null,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Namaste 🙏',
                  style: AppTextStyles.label(size: 11.5, color: AppColors.goldLight)),
              const SizedBox(height: 3),
              Text(name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.display(size: 22)),
            ],
          ),
        ),
        const SizedBox(width: 8),
        const NotificationBell(),
      ],
    );
  }
}

/// Filled indigo "You're Online / Offline" card with the availability toggle.
class _OnlineCard extends StatelessWidget {
  const _OnlineCard({required this.online, required this.busy, required this.onChanged});
  final bool online;
  final bool busy;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return HeroGradientCard(
      padding: const EdgeInsets.fromLTRB(20, 18, 16, 18),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(online ? "You're Online" : "You're Offline",
                    style: AppTextStyles.heading(size: 20)),
                const SizedBox(height: 5),
                Text(online ? l.dashOnlineSubtitle : l.dashOfflineSubtitle,
                    style: AppTextStyles.body(size: 13, color: AppColors.ivoryDim)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          busy
              ? const SizedBox(
                  width: 44,
                  height: 30,
                  child: Center(
                      child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: AppColors.success))))
              : Switch(
                  value: online,
                  onChanged: onChanged,
                  activeThumbColor: Colors.white,
                  activeTrackColor: AppColors.success,
                ),
        ],
      ),
    );
  }
}

class _StatsOrLoader extends StatelessWidget {
  const _StatsOrLoader({required this.state, required this.astro});
  final DashboardState state;
  final Astrologer? astro;

  @override
  Widget build(BuildContext context) {
    if (state.loading && state.data == null) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator(color: AppColors.saffron)),
      );
    }
    if (state.data != null) {
      return _Stats(data: state.data!, astro: astro, pending: state.pendingRequests);
    }
    return const SizedBox.shrink();
  }
}

class _Stats extends StatelessWidget {
  const _Stats({required this.data, required this.astro, required this.pending});
  final Map<String, dynamic> data;
  final Astrologer? astro;
  final int? pending;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final reviews = astro?.reviewCount ?? 0;
    // (label, value, subtitle, accent, icon) — real data only; no invented
    // deltas/breakdowns.
    final items = <(String, String, String, Color, IconData)>[
      (
        l.statTodayEarnings,
        '₹${data['today_earnings']}',
        '₹${data['available_balance']} balance',
        AppColors.gold,
        Icons.currency_rupee,
      ),
      (
        'Consultations',
        '${data['today_consultations']}',
        '${data['total_consultations']} lifetime',
        AppColors.success,
        Icons.forum_outlined,
      ),
      (
        l.statRating,
        '${data['avg_rating'] ?? '0.00'} ★',
        '$reviews reviews',
        AppColors.gold,
        Icons.star_rounded,
      ),
      (
        'Requests',
        '${pending ?? 0}',
        'incoming now',
        AppColors.saffron,
        Icons.inbox_rounded,
      ),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: 1.32,
      children: [for (final i in items) _StatCard(i.$1, i.$2, i.$3, i.$4, i.$5)],
    );
  }
}

/// A single overview stat card — coloured border + accent value, an icon
/// tile, and a faint subtitle line (matches the reference dashboard).
class _StatCard extends StatelessWidget {
  const _StatCard(this.label, this.value, this.subtitle, this.accent, this.icon);
  final String label;
  final String value;
  final String subtitle;
  final Color accent;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [accent.withValues(alpha: 0.10), AppColors.surface1],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(label.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.label(size: 10.5, color: AppColors.ivoryFaint)),
              ),
              Icon(icon, size: 18, color: accent),
            ],
          ),
          const Spacer(),
          Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.display(size: 24, color: accent)),
          const SizedBox(height: 4),
          Text(subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.label(size: 11, color: AppColors.success)),
        ],
      ),
    );
  }
}
