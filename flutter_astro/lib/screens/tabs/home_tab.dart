import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/dashboard/dashboard_bloc.dart';
import '../../bloc/dashboard/dashboard_event.dart';
import '../../bloc/dashboard/dashboard_state.dart';
import '../../bloc/astro_profile/astro_profile_bloc.dart';
import '../../bloc/astro_profile/astro_profile_event.dart';
import '../../bloc/astro_profile/astro_profile_state.dart';
import '../../services/api_service.dart';
import '../communication/live_host_screen.dart';
import '../rashi/rashi_list_screen.dart';
import '../specialist/specialist_milan_picker.dart';
import '../specialist/specialist_list_screen.dart';
import '../forecast/forecast_chart_picker.dart';

/// Optional callback so the dashboard can request the parent shell to switch
/// bottom-nav tabs (e.g. "See all requests" → Requests tab).
class HomeTab extends StatefulWidget {
  final void Function(int index)? onNavigate;
  const HomeTab({super.key, this.onNavigate});
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  // ── helpers ──────────────────────────────────────────────────────────
  double _d(dynamic v) => v is num ? v.toDouble() : (double.tryParse('$v') ?? 0);
  int _i(dynamic v) => v is num ? v.toInt() : (int.tryParse('$v') ?? 0);

  String _money(num v) {
    final s = v.round().toString();
    final b = StringBuffer();
    for (int k = 0; k < s.length; k++) {
      if (k > 0 && (s.length - k) % 3 == 0) b.write(',');
      b.write(s[k]);
    }
    return b.toString();
  }

  Future<void> _startLive(BuildContext context) async {
    final l = AppLocalizations.of(context)!;
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(l.goLive, style: const TextStyle(color: AppColors.primary)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Stream Title', prefixIcon: Icon(Icons.title))),
          const SizedBox(height: 10),
          TextField(controller: descCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'Description (optional)', prefixIcon: Icon(Icons.description))),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary))),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.trim().isEmpty) return;
              Navigator.pop(ctx, {'title': titleCtrl.text.trim(), 'description': descCtrl.text.trim()});
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
            child: Text(AppLocalizations.of(context)?.start ?? 'Start'),
          ),
        ],
      ),
    );
    if (result == null || !context.mounted) return;
    final resp = await ApiService().createLiveStream(result['title']!, description: result['description']!.isEmpty ? null : result['description']);
    if (!context.mounted) return;
    if (resp['statusCode'] == 201 || resp['statusCode'] == 200) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => LiveHostScreen(
        streamId: resp['id'], channelName: resp['channel_name'],
        agoraToken: resp['agora_token'], agoraAppId: resp['agora_app_id'],
        title: result['title']!,
      )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resp['detail'] ?? 'Failed'), backgroundColor: AppColors.error));
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardBloc>().add(DashboardLoadRequested());
      if (context.read<AstroProfileBloc>().state.me == null) {
        context.read<AstroProfileBloc>().add(AstroProfileLoadRequested());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    // astrologer name for greeting
    final authState = context.watch<AuthBloc>().state;
    String astroName = '';
    if (authState is AuthAuthenticated) astroName = (authState.user['name'] ?? '').toString();
    if (astroName.trim().isEmpty) astroName = l.astrologer;
    final firstName = astroName.trim().split(' ').first;

    // astrologer photo for the greeting (profile_image_url, else user avatar)
    final astroMe = context.watch<AstroProfileBloc>().state.me;
    String? photoUrl;
    if (astroMe != null) {
      final pf = astroMe['profile'] ?? astroMe['astrologer_profile'];
      if (pf is Map) photoUrl = (pf['profile_image_url'] ?? '').toString();
      if (photoUrl == null || photoUrl.isEmpty) photoUrl = (astroMe['avatar_url'] ?? '').toString();
    }
    if (photoUrl != null && photoUrl.isEmpty) photoUrl = null;

    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? l.goodMorning
        : hour < 17
            ? l.goodAfternoon
            : hour < 21
                ? l.goodEvening
                : l.goodNight;

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state.loading && state.stats == null) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        if (state.error != null && state.stats == null) {
          return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(state.error!, style: const TextStyle(color: AppColors.error)),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () => context.read<DashboardBloc>().add(DashboardLoadRequested()), child: Text(l.retry)),
          ]));
        }

        final stats = state.stats ?? {};
        final todayEarn = _d(stats['today_earning']);
        final totalEarn = _d(stats['total_earning']);
        final wallet = _d(stats['wallet_balance']);
        final rating = _d(stats['rating']);
        final reviews = _i(stats['total_reviews']);
        final consultations = _i(stats['total_consultations']);
        final minutes = _i(stats['total_minutes']);
        final isOnline = stats['is_online'] == true;
        final isBusy = stats['is_busy'] == true;

        final req = (stats['requests'] is Map) ? (stats['requests'] as Map) : const {};
        final chatTotal = _i(req['chat_total']);
        final voiceTotal = _i(req['voice_total']);
        final videoTotal = _i(req['video_total']);
        final pendingTotal = _i(req['pending_total']);

        // Derived (honest) goals — grounded in the astrologer's own history.
        final dailyGoal = math.max(500.0, totalEarn / 30);
        final goalPct = dailyGoal > 0 ? (todayEarn / dailyGoal).clamp(0.0, 1.0).toDouble() : 0.0;
        final satisfaction = (rating / 5).clamp(0.0, 1.0).toDouble();

        // Upcoming = accepted/pending sessions surfaced from recent requests.
        final upcoming = state.recentRequests
            .whereType<dynamic>()
            .where((r) => r is Map && (r['status'] == 'accepted' || r['status'] == 'pending'))
            .toList();

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async => context.read<DashboardBloc>().add(DashboardLoadRequested()),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              // ══════════════════════ GREETING HERO ══════════════════════
              _GreetingHero(greeting: greeting, name: firstName, subtitle: l.yourCosmicDashboard, imageUrl: photoUrl),
              const SizedBox(height: 18),

              // ══════════════════════ 1. LIVE STATUS ═════════════════════
              _LiveStatusCard(
                l: l,
                isOnline: isOnline,
                isBusy: isBusy,
                onGoLive: () => _startLive(context),
              ),
              const SizedBox(height: 18),

              // ══════════════════════ 2. PERFORMANCE OVERVIEW ════════════
              _SectionLabel(icon: Icons.insights, title: l.performanceOverview),
              const SizedBox(height: 10),
              _EarningsHero(
                l: l,
                todayEarn: todayEarn,
                dailyGoal: dailyGoal,
                goalPct: goalPct,
                money: _money,
              ),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: _MetricTile(icon: Icons.account_balance_wallet, label: l.walletBalance, value: '₹${_money(wallet)}', color: AppColors.aurora)),
                const SizedBox(width: 12),
                Expanded(child: _MetricTile(icon: Icons.trending_up, label: l.totalEarnings, value: '₹${_money(totalEarn)}', color: AppColors.success)),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: _RingTile(label: l.satisfaction, pct: satisfaction, centerText: rating.toStringAsFixed(1), sub: '$reviews ${l.reviews}', color: AppColors.gold)),
                const SizedBox(width: 12),
                Expanded(child: _RingTile(label: l.todayVsGoal, pct: goalPct, centerText: '${(goalPct * 100).round()}%', sub: l.dailyGoal, color: AppColors.cosmicPink)),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: _MetricTile(icon: Icons.headset_mic, label: l.totalSessions, value: '$consultations', color: AppColors.lavender)),
                const SizedBox(width: 12),
                Expanded(child: _MetricTile(icon: Icons.timer_outlined, label: l.minutesConsulted, value: '$minutes', color: AppColors.roseGold)),
              ]),
              const SizedBox(height: 22),

              // ══════════════════════ 3. TODAY'S REQUESTS ════════════════
              _SectionLabel(
                icon: Icons.notifications_active,
                title: l.todaysRequests,
                trailing: pendingTotal > 0
                    ? _Pill(text: '$pendingTotal ${l.pending}', color: AppColors.error)
                    : null,
              ),
              const SizedBox(height: 10),
              Row(children: [
                _RequestStat(icon: Icons.chat_bubble_rounded, label: l.chats, count: chatTotal, color: AppColors.aurora),
                const SizedBox(width: 10),
                _RequestStat(icon: Icons.call_rounded, label: l.voice, count: voiceTotal, color: AppColors.success),
                const SizedBox(width: 10),
                _RequestStat(icon: Icons.videocam_rounded, label: l.video, count: videoTotal, color: AppColors.gold),
              ]),
              if (pendingTotal > 0) ...[
                const SizedBox(height: 10),
                _WideButton(
                  icon: Icons.inbox_rounded,
                  label: '${l.activeRequests} ($pendingTotal)',
                  onTap: () => widget.onNavigate?.call(2),
                ),
              ],
              const SizedBox(height: 22),

              // ══════════════════════ 4. ASTROLOGY SERVICES ══════════════
              _SectionLabel(icon: Icons.auto_awesome, title: l.astrologyServices),
              const SizedBox(height: 10),
              _ServiceCard(
                emoji: '♈♉♊',
                title: l.rashiPredictions,
                subtitle: l.rashiServiceDesc,
                c1: AppColors.gold, c2: AppColors.saffron,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RashiListScreen())),
              ),
              const SizedBox(height: 10),
              _ServiceCard(
                emoji: '\u{1F4CA}',
                title: l.deptReports,
                subtitle: l.specialistAnalysesDesc,
                c1: AppColors.lavender, c2: AppColors.indigo,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SpecialistListScreen())),
              ),
              const SizedBox(height: 10),
              _ServiceCard(
                emoji: '❤️',
                title: '${l.kundli} ${l.milan}',
                subtitle: l.matchTwoChartsDesc,
                c1: AppColors.cosmicPink, c2: AppColors.roseGold,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SpecialistMilanPicker())),
              ),
              const SizedBox(height: 10),
              _ServiceCard(
                emoji: '☀️',
                title: l.todaysForecast,
                subtitle: l.dailyProbability,
                c1: AppColors.saffron, c2: AppColors.gold,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForecastChartPicker())),
              ),
              const SizedBox(height: 22),

              // ══════════════════════ 5. UPCOMING CONSULTATIONS ══════════
              _SectionLabel(icon: Icons.event_available, title: l.upcomingConsultations),
              const SizedBox(height: 10),
              if (upcoming.isEmpty)
                _EmptyState(icon: Icons.event_busy, text: l.noUpcomingConsultations)
              else
                ...upcoming.take(3).map((r) => _UpcomingCard(request: r as Map)),
              const SizedBox(height: 22),

              // ══════════════════════ 6. RECENT ACTIVITY ═════════════════
              _SectionLabel(
                icon: Icons.history,
                title: l.recentActivity,
                trailing: state.recentRequests.isNotEmpty
                    ? _LinkText(text: l.seeAll, onTap: () => widget.onNavigate?.call(2))
                    : null,
              ),
              const SizedBox(height: 10),
              if (state.recentRequests.isEmpty)
                _EmptyState(icon: Icons.hourglass_empty, text: l.noRecentRequests)
              else
                _ActivityTimeline(items: state.recentRequests.take(5).toList()),
              const SizedBox(height: 22),

              // ══════════════════════ 7. PERFORMANCE ANALYTICS ═══════════
              _SectionLabel(icon: Icons.bar_chart, title: l.performanceAnalytics),
              const SizedBox(height: 10),
              _AnalyticsCard(l: l, satisfaction: satisfaction, goalPct: goalPct, pendingTotal: pendingTotal, totalRequests: chatTotal + voiceTotal + videoTotal),
              const SizedBox(height: 22),

              // ══════════════════════ 8. AI ASSISTANT ════════════════════
              _AiAssistantCard(l: l),
              const SizedBox(height: 16),

              // ══════════════════════ 9. COSMIC INSIGHT ══════════════════
              _CosmicInsightCard(l: l),
              const SizedBox(height: 16),

              // ══════════════════════ 10. DAILY MOTIVATION ═══════════════
              _MotivationCard(l: l),
            ],
          ),
        );
      },
    );
  }
}

// ════════════════════════════════════════════════════════════════════════
//  SHARED SMALL PIECES
// ════════════════════════════════════════════════════════════════════════

class _GreetingHero extends StatelessWidget {
  final String greeting, name, subtitle;
  final String? imageUrl;
  const _GreetingHero({required this.greeting, required this.name, required this.subtitle, this.imageUrl});

  Widget _avatar() {
    final initial = Center(
      child: Text(
        name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '✨',
        style: const TextStyle(color: AppColors.midnight, fontSize: 22, fontWeight: FontWeight.w800),
      ),
    );
    Widget inner = initial;
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      inner = ClipOval(
        child: Image.network(
          ApiService.resolveMediaUrl(imageUrl!),
          width: 54, height: 54, fit: BoxFit.cover,
          headers: ApiService().mediaHeaders,
          loadingBuilder: (ctx, child, p) => p == null ? child : initial,
          errorBuilder: (_, __, ___) => initial,
        ),
      );
    }
    return Container(
      width: 54, height: 54,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [AppColors.gold, AppColors.saffron]),
      ),
      child: inner,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.nebula, AppColors.twilight],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withOpacity(0.18)),
      ),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(greeting, style: const TextStyle(color: AppColors.smoke, fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(height: 2),
            Text(name,
                maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.ivory, fontSize: 24, fontWeight: FontWeight.w800, fontFamily: 'Manrope')),
            const SizedBox(height: 6),
            Text(subtitle, style: TextStyle(color: AppColors.gold.withOpacity(0.85), fontSize: 12, fontWeight: FontWeight.w500)),
          ]),
        ),
        const SizedBox(width: 12),
        _avatar(),
      ]),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  const _SectionLabel({required this.icon, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 18, color: AppColors.gold),
      const SizedBox(width: 8),
      Expanded(
        child: Text(title, style: const TextStyle(color: AppColors.ivory, fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Manrope')),
      ),
      if (trailing != null) trailing!,
    ]);
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color color;
  const _Pill({required this.text, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.4))),
      child: Text(text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}

class _LinkText extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _LinkText({required this.text, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Text(text, style: const TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String text;
  const _EmptyState({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.nebula.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: [
        Icon(icon, size: 30, color: AppColors.smoke.withOpacity(0.6)),
        const SizedBox(height: 10),
        Text(text, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.smoke, fontSize: 13)),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════
//  1. LIVE STATUS
// ════════════════════════════════════════════════════════════════════════

class _LiveStatusCard extends StatefulWidget {
  final AppLocalizations l;
  final bool isOnline, isBusy;
  final VoidCallback onGoLive;
  const _LiveStatusCard({required this.l, required this.isOnline, required this.isBusy, required this.onGoLive});
  @override
  State<_LiveStatusCard> createState() => _LiveStatusCardState();
}

class _LiveStatusCardState extends State<_LiveStatusCard> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.l;
    final statusText = widget.isBusy ? l.busy : (widget.isOnline ? l.online : l.offline);
    final statusColor = widget.isBusy ? AppColors.saffron : (widget.isOnline ? AppColors.success : AppColors.smoke);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.error.withOpacity(0.22), AppColors.saffron.withOpacity(0.10)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.error.withOpacity(0.35)),
      ),
      child: Row(children: [
        // pulsing live dot
        AnimatedBuilder(
          animation: _c,
          builder: (_, __) {
            final t = _c.value;
            return SizedBox(
              width: 56, height: 56,
              child: Stack(alignment: Alignment.center, children: [
                Container(
                  width: 36 + 20 * t, height: 36 + 20 * t,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.error.withOpacity(0.25 * (1 - t))),
                ),
                Container(
                  width: 34, height: 34,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.error),
                  child: const Icon(Icons.podcasts, color: Colors.white, size: 18),
                ),
              ]),
            );
          },
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.liveStatus, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.ivory, fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 3),
            Row(children: [
              Container(width: 7, height: 7, decoration: BoxDecoration(shape: BoxShape.circle, color: statusColor)),
              const SizedBox(width: 5),
              Text(statusText, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w600)),
            ]),
            const SizedBox(height: 2),
            Text(l.goLiveSubtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
          ]),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: widget.onGoLive,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error, foregroundColor: Colors.white,
            minimumSize: const Size(0, 42), padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(l.goLive, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
        ),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════
//  2. PERFORMANCE OVERVIEW
// ════════════════════════════════════════════════════════════════════════

class _EarningsHero extends StatelessWidget {
  final AppLocalizations l;
  final double todayEarn, dailyGoal, goalPct;
  final String Function(num) money;
  const _EarningsHero({required this.l, required this.todayEarn, required this.dailyGoal, required this.goalPct, required this.money});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.gold, AppColors.saffron], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.wb_sunny_rounded, size: 16, color: AppColors.midnight.withOpacity(0.7)),
          const SizedBox(width: 6),
          Text(l.todaysEarning.toUpperCase(),
              style: TextStyle(color: AppColors.midnight.withOpacity(0.75), fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1)),
        ]),
        const SizedBox(height: 8),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: todayEarn),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutCubic,
          builder: (_, v, __) => Text('₹${money(v)}',
              style: const TextStyle(color: AppColors.midnight, fontSize: 34, fontWeight: FontWeight.w800, fontFamily: 'Manrope')),
        ),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: goalPct,
            minHeight: 8,
            backgroundColor: AppColors.midnight.withOpacity(0.18),
            valueColor: AlwaysStoppedAnimation(AppColors.midnight.withOpacity(0.85)),
          ),
        ),
        const SizedBox(height: 6),
        Text('${(goalPct * 100).round()}% ${l.towardsGoal} • ₹${money(dailyGoal)}',
            style: TextStyle(color: AppColors.midnight.withOpacity(0.7), fontSize: 11, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color;
  const _MetricTile({required this.icon, required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.nebula.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.22)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(9)),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.smoke, fontSize: 11, fontWeight: FontWeight.w500)),
          ),
        ]),
        const SizedBox(height: 10),
        Text(value, style: const TextStyle(color: AppColors.ivory, fontSize: 20, fontWeight: FontWeight.w700, fontFamily: 'Manrope')),
      ]),
    );
  }
}

class _RingTile extends StatelessWidget {
  final String label, centerText, sub;
  final double pct;
  final Color color;
  const _RingTile({required this.label, required this.pct, required this.centerText, required this.sub, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.nebula.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.22)),
      ),
      child: Row(children: [
        SizedBox(
          width: 52, height: 52,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: pct),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (_, v, __) => CustomPaint(
              painter: _RingPainter(pct: v, color: color),
              child: Center(child: Text(centerText, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w800))),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(sub, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
          ]),
        ),
      ]),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double pct;
  final Color color;
  _RingPainter({required this.pct, required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = math.min(size.width, size.height) / 2 - 3;
    final bg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..color = color.withOpacity(0.18);
    final fg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawCircle(c, r, bg);
    canvas.drawArc(Rect.fromCircle(center: c, radius: r), -math.pi / 2, 2 * math.pi * pct.clamp(0.0, 1.0), false, fg);
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.pct != pct || old.color != color;
}

// ════════════════════════════════════════════════════════════════════════
//  3. TODAY'S REQUESTS
// ════════════════════════════════════════════════════════════════════════

class _RequestStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;
  const _RequestStat({required this.icon, required this.label, required this.count, required this.color});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.28)),
        ),
        child: Column(children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: count.toDouble()),
            duration: const Duration(milliseconds: 800),
            builder: (_, v, __) => Text('${v.round()}', style: TextStyle(color: color, fontSize: 19, fontWeight: FontWeight.w800)),
          ),
          Text(label, style: TextStyle(color: color.withOpacity(0.85), fontSize: 11, fontWeight: FontWeight.w500)),
        ]),
      ),
    );
  }
}

class _WideButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _WideButton({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: AppColors.gold.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.gold.withOpacity(0.4)),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 18, color: AppColors.gold),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: AppColors.gold, fontSize: 13, fontWeight: FontWeight.w700)),
        ]),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════
//  4. ASTROLOGY SERVICES
// ════════════════════════════════════════════════════════════════════════

class _ServiceCard extends StatelessWidget {
  final String emoji, title, subtitle;
  final Color c1, c2;
  final VoidCallback onTap;
  const _ServiceCard({required this.emoji, required this.title, required this.subtitle, required this.c1, required this.c2, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [c1.withOpacity(0.18), c2.withOpacity(0.06)]),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: c1.withOpacity(0.35)),
        ),
        child: Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: c1.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
            ]),
          ),
          Icon(Icons.chevron_right, color: c1.withOpacity(0.8)),
        ]),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════
//  5. UPCOMING CONSULTATIONS
// ════════════════════════════════════════════════════════════════════════

class _UpcomingCard extends StatelessWidget {
  final Map request;
  const _UpcomingCard({required this.request});
  @override
  Widget build(BuildContext context) {
    final type = (request['type'] ?? 'chat').toString();
    final userName = (request['user_name'] ?? 'User').toString();
    final status = (request['status'] ?? 'pending').toString();
    IconData icon;
    Color color;
    switch (type) {
      case 'voice':
        icon = Icons.call_rounded; color = AppColors.success; break;
      case 'video':
        icon = Icons.videocam_rounded; color = AppColors.gold; break;
      default:
        icon = Icons.chat_bubble_rounded; color = AppColors.aurora;
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.nebula.withOpacity(0.7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.22)),
      ),
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(11)),
          child: Icon(icon, color: color, size: 19),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(userName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(type.toUpperCase(), style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
          ]),
        ),
        _Pill(text: status.toUpperCase(), color: status == 'accepted' ? AppColors.success : AppColors.saffron),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════
//  6. RECENT ACTIVITY (timeline)
// ════════════════════════════════════════════════════════════════════════

class _ActivityTimeline extends StatelessWidget {
  final List<dynamic> items;
  const _ActivityTimeline({required this.items});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.nebula.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          final r = items[i] is Map ? items[i] as Map : const {};
          final type = (r['type'] ?? 'chat').toString();
          final userName = (r['user_name'] ?? 'User').toString();
          final status = (r['status'] ?? 'pending').toString();
          final createdAt = (r['created_at'] ?? '').toString();
          final isLast = i == items.length - 1;

          IconData icon;
          Color color;
          switch (type) {
            case 'voice':
              icon = Icons.call_rounded; color = AppColors.success; break;
            case 'video':
              icon = Icons.videocam_rounded; color = AppColors.gold; break;
            default:
              icon = Icons.chat_bubble_rounded; color = AppColors.aurora;
          }
          Color statusColor;
          switch (status) {
            case 'accepted':
            case 'completed':
              statusColor = AppColors.success; break;
            case 'declined':
            case 'cancelled':
              statusColor = AppColors.error; break;
            default:
              statusColor = AppColors.saffron;
          }

          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // rail (fixed height — no IntrinsicHeight/Expanded)
            SizedBox(
              width: 30,
              child: Column(children: [
                Container(
                  width: 30, height: 30,
                  decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
                  child: Icon(icon, size: 15, color: color),
                ),
                if (!isLast) Container(width: 2, height: 30, color: AppColors.border),
              ]),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 4, bottom: isLast ? 12 : 18),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Text(userName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.ivory, fontSize: 13, fontWeight: FontWeight.w600))),
                    Text(status.toUpperCase(), style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.w700)),
                  ]),
                  const SizedBox(height: 2),
                  Text(createdAt.length > 16 ? createdAt.substring(0, 16) : createdAt,
                      style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
                ]),
              ),
            ),
          ]);
        }),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════
//  7. PERFORMANCE ANALYTICS
// ════════════════════════════════════════════════════════════════════════

class _AnalyticsCard extends StatelessWidget {
  final AppLocalizations l;
  final double satisfaction, goalPct;
  final int pendingTotal, totalRequests;
  const _AnalyticsCard({required this.l, required this.satisfaction, required this.goalPct, required this.pendingTotal, required this.totalRequests});
  @override
  Widget build(BuildContext context) {
    final responseRate = totalRequests > 0 ? (1 - pendingTotal / totalRequests).clamp(0.0, 1.0).toDouble() : 1.0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.nebula.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withOpacity(0.15)),
      ),
      child: Column(children: [
        _AnalyticsBar(label: l.satisfaction, pct: satisfaction, color: AppColors.gold),
        const SizedBox(height: 14),
        _AnalyticsBar(label: l.responseRate, pct: responseRate, color: AppColors.success),
        const SizedBox(height: 14),
        _AnalyticsBar(label: l.todayVsGoal, pct: goalPct, color: AppColors.cosmicPink),
      ]),
    );
  }
}

class _AnalyticsBar extends StatelessWidget {
  final String label;
  final double pct;
  final Color color;
  const _AnalyticsBar({required this.label, required this.pct, required this.color});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(color: AppColors.ivory, fontSize: 12, fontWeight: FontWeight.w500)),
        Text('${(pct * 100).round()}%', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)),
      ]),
      const SizedBox(height: 6),
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: pct),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutCubic,
          builder: (_, v, __) => LinearProgressIndicator(
            value: v, minHeight: 7,
            backgroundColor: color.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ),
    ]);
  }
}

// ════════════════════════════════════════════════════════════════════════
//  8. AI ASSISTANT
// ════════════════════════════════════════════════════════════════════════

class _AiAssistantCard extends StatelessWidget {
  final AppLocalizations l;
  const _AiAssistantCard({required this.l});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.indigo.withOpacity(0.35), AppColors.twilight.withOpacity(0.25)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.lavender.withOpacity(0.3)),
      ),
      child: Row(children: [
        Container(
          width: 46, height: 46,
          decoration: BoxDecoration(color: AppColors.lavender.withOpacity(0.18), borderRadius: BorderRadius.circular(13)),
          child: const Icon(Icons.auto_awesome, color: AppColors.lavender, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.aiAssistant, style: const TextStyle(color: AppColors.ivory, fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 3),
            Text(l.aiAssistantSubtitle, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
          ]),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(color: AppColors.lavender.withOpacity(0.9), borderRadius: BorderRadius.circular(20)),
          child: Text(l.comingSoon, style: const TextStyle(color: AppColors.midnight, fontSize: 10, fontWeight: FontWeight.w700)),
        ),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════
//  9. COSMIC INSIGHT
// ════════════════════════════════════════════════════════════════════════

class _CosmicInsightCard extends StatelessWidget {
  final AppLocalizations l;
  const _CosmicInsightCard({required this.l});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.twilight.withOpacity(0.6), AppColors.nebula.withOpacity(0.6)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.gold.withOpacity(0.2)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('\u{1F319}', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Text(l.cosmicInsight, style: const TextStyle(color: AppColors.gold, fontSize: 14, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 8),
        Text(l.cosmicInsightBody, style: const TextStyle(color: AppColors.parchment, fontSize: 13, height: 1.45)),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════
//  10. DAILY MOTIVATION
// ════════════════════════════════════════════════════════════════════════

class _MotivationCard extends StatelessWidget {
  final AppLocalizations l;
  const _MotivationCard({required this.l});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.nebula.withOpacity(0.5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: [
        Icon(Icons.format_quote_rounded, color: AppColors.gold.withOpacity(0.7), size: 26),
        const SizedBox(height: 6),
        Text(l.dailyMotivationQuote, textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontStyle: FontStyle.italic, height: 1.5)),
      ]),
    );
  }
}
