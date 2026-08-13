import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/responsive.dart';
import '../../auth/astro_session_cubit.dart';
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
          final desktop = context.isDesktop;
          return RefreshIndicator(
            onRefresh: cubit.refresh,
            color: AppColors.saffron,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                CenteredMaxWidth(
                  maxWidth: context.responsive(mobile: 640, tablet: 760, desktop: 1160),
                  child: desktop
                      ? _DesktopBody(state: state, astro: astro, cubit: cubit)
                      : _CompactBody(state: state, astro: astro, cubit: cubit),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Single-column layout for phones and tablets.
class _CompactBody extends StatelessWidget {
  const _CompactBody({required this.state, required this.astro, required this.cubit});
  final DashboardState state;
  final Astrologer? astro;
  final DashboardCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Hero(astro: astro),
        const SizedBox(height: 16),
        _OnlineCard(online: state.isOnline, busy: state.toggling, onChanged: cubit.toggleOnline),
        const SizedBox(height: 20),
        _StatsOrLoader(state: state),
        const SizedBox(height: 20),
        const _ActionRow(),
        const SizedBox(height: 12),
        _SettingsLink(onTap: () => context.push('/settings')),
      ],
    );
  }
}

/// Two-column layout that fills the extra width on desktop browsers: the
/// profile/online/actions column on the left, the stats grid on the right.
class _DesktopBody extends StatelessWidget {
  const _DesktopBody({required this.state, required this.astro, required this.cubit});
  final DashboardState state;
  final Astrologer? astro;
  final DashboardCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Hero(astro: astro),
              const SizedBox(height: 16),
              _OnlineCard(online: state.isOnline, busy: state.toggling, onChanged: cubit.toggleOnline),
              const SizedBox(height: 16),
              const _ActionRow(),
              const SizedBox(height: 12),
              _SettingsLink(onTap: () => context.push('/settings')),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 6,
          child: _StatsOrLoader(state: state),
        ),
      ],
    );
  }
}

class _StatsOrLoader extends StatelessWidget {
  const _StatsOrLoader({required this.state});
  final DashboardState state;

  @override
  Widget build(BuildContext context) {
    if (state.loading && state.data == null) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator(color: AppColors.saffron)),
      );
    }
    if (state.data != null) return _Stats(data: state.data!);
    return const SizedBox.shrink();
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.podcasts,
            label: l.dashGoLive,
            color: AppColors.live,
            filled: true,
            onTap: () => context.push('/live'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionButton(
            icon: Icons.inbox,
            label: l.dashRequests,
            color: AppColors.saffron,
            onTap: () => context.go('/requests'),
          ),
        ),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.astro});
  final Astrologer? astro;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final photoUrl = astro?.photoUrl;
    final name = astro?.displayName ?? l.profileAstrologer;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.indigoSoft, AppColors.indigoMid, AppColors.indigoDeep],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderMid),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderMid, width: 1.5),
            ),
            child: CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.indigo,
            backgroundImage:
                (photoUrl != null && photoUrl.isNotEmpty) ? NetworkImage(photoUrl) : null,
            child: (photoUrl == null || photoUrl.isEmpty)
                ? Text(name.isNotEmpty ? name[0].toUpperCase() : '🪔',
                    style: AppTextStyles.display(size: 22))
                : null,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.dashWelcomeBack, style: AppTextStyles.body(size: 12, color: AppColors.ivoryDim)),
                const SizedBox(height: 2),
                Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.display(size: 22)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 16, color: AppColors.gold),
                    const SizedBox(width: 4),
                    Text(astro?.avgRating ?? '0.00',
                        style: AppTextStyles.body(size: 13, weight: FontWeight.w700, color: AppColors.gold)),
                    Flexible(
                      child: Text('  •  ${l.dashReviews(astro?.reviewCount ?? 0)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body(size: 12, color: AppColors.ivoryDim)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                tooltip: l.dashSettings,
                onPressed: () => context.push('/settings'),
                icon: Icon(Icons.settings_outlined, color: AppColors.ivoryDim),
              ),
              IconButton(
                tooltip: l.commonSignOut,
                onPressed: () => context.read<AstroSessionCubit>().logout(),
                icon: Icon(Icons.logout, color: AppColors.ivoryDim),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  const _Stats({required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final items = <(String, String, IconData, Color)>[
      (l.statTodayEarnings, '₹${data['today_earnings']}', Icons.currency_rupee, AppColors.success),
      (l.statBalance, '₹${data['available_balance']}', Icons.account_balance_wallet_outlined, AppColors.gold),
      (l.statTodayConsults, '${data['today_consultations']}', Icons.today_outlined, AppColors.info),
      (l.statTotalConsults, '${data['total_consultations']}', Icons.history, AppColors.ivory),
      (l.statRating, (data['avg_rating'] ?? '0.00').toString(), Icons.star_rounded, AppColors.gold),
      (l.statFollowers, '${data['follower_count']}', Icons.groups_outlined, AppColors.copperLight),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth > 560 ? 3 : 2;
        return GridView.count(
          crossAxisCount: cols,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.7,
          children: [
            for (final i in items)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [i.$4.withValues(alpha: 0.10), AppColors.surface1],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: i.$4.withValues(alpha: 0.22)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(i.$3, size: 18, color: i.$4),
                    const SizedBox(height: 8),
                    Text(i.$2,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body(size: 18, weight: FontWeight.w700, color: i.$4)),
                    const SizedBox(height: 2),
                    Text(i.$1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.label(size: 11, color: AppColors.ivoryDim)),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class _OnlineCard extends StatelessWidget {
  const _OnlineCard({required this.online, required this.busy, required this.onChanged});
  final bool online;
  final bool busy;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: online
            ? [AppColors.success.withValues(alpha: 0.3), AppColors.indigoMid]
            : [AppColors.indigoMid, AppColors.indigoSoft]),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: online ? AppColors.success.withValues(alpha: 0.4) : AppColors.borderSoft),
        boxShadow: online
            ? [
                BoxShadow(
                  color: AppColors.success.withValues(alpha: 0.16),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(online ? l.dashOnline : l.dashOffline,
                    style: AppTextStyles.heading(size: 18)),
                const SizedBox(height: 4),
                Text(online ? l.dashOnlineSubtitle : l.dashOfflineSubtitle,
                    style: AppTextStyles.body(size: 13, color: AppColors.ivoryDim)),
              ],
            ),
          ),
          busy
              ? const SizedBox(width: 40, child: Center(child: CircularProgressIndicator(strokeWidth: 2)))
              : Switch(value: online, onChanged: onChanged, activeThumbColor: AppColors.success),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.filled = false,
  });
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 22),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: filled
                ? [color.withValues(alpha: 0.24), color.withValues(alpha: 0.10)]
                : [color.withValues(alpha: 0.08), AppColors.surface1],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: filled ? color.withValues(alpha: 0.5) : color.withValues(alpha: 0.25)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(label, style: AppTextStyles.body(size: 14, weight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _SettingsLink extends StatelessWidget {
  const _SettingsLink({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface1,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderSoft),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.copperLight.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.tune, size: 18, color: AppColors.copperLight),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.dashSettings, style: AppTextStyles.body(size: 14, weight: FontWeight.w600)),
                  Text(l.dashSettingsSubtitle,
                      style: AppTextStyles.body(size: 12, color: AppColors.ivoryDim)),
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
