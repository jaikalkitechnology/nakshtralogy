import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/app_theme.dart';
import '../../bloc/dashboard/dashboard_bloc.dart';
import '../../bloc/dashboard/dashboard_event.dart';
import '../../bloc/dashboard/dashboard_state.dart';
import '../../services/api_service.dart';
import '../communication/live_host_screen.dart';
import '../rashi/rashi_list_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  Future<void> _startLive(BuildContext context) async {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('Go Live', style: TextStyle(color: AppColors.primary)),
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
            child: const Text('Start'),
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state.loading && state.stats == null) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        if (state.error != null && state.stats == null) {
          return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(state.error!, style: const TextStyle(color: AppColors.error)),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () => context.read<DashboardBloc>().add(DashboardLoadRequested()), child: const Text('Retry')),
          ]));
        }
        final stats = state.stats ?? {};
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async => context.read<DashboardBloc>().add(DashboardLoadRequested()),
          child: ListView(padding: const EdgeInsets.all(16), children: [
            // ── KPI Cards (2x2 grid) ──
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.6,
              children: [
                _KpiCard(icon: Icons.currency_rupee, label: "Today's Earning", value: '₹${stats['today_earning'] ?? 0}', color: AppColors.success),
                _KpiCard(icon: Icons.account_balance_wallet, label: 'Wallet Balance', value: '₹${stats['wallet_balance'] ?? 0}', color: AppColors.accent),
                _KpiCard(icon: Icons.star, label: 'Rating', value: '${(stats['avg_rating'] ?? 0.0).toStringAsFixed(1)}', color: Colors.amber),
                _KpiCard(icon: Icons.headset_mic, label: 'Total Sessions', value: '${stats['total_sessions'] ?? 0}', color: AppColors.primary),
              ],
            ),
            const SizedBox(height: 20),

            // ── Request Counts ──
            // ── Go Live Button ──
            ElevatedButton.icon(
              onPressed: () => _startLive(context),
              icon: const Icon(Icons.live_tv, size: 20),
              label: const Text('Go Live'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            const SizedBox(height: 12),

            // ── Rashi Predictions quick access ──
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RashiListScreen())),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.primary.withOpacity(0.18), AppColors.accent.withOpacity(0.08)]),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                ),
                child: Row(children: [
                  const Text('\u2648\u2649\u264a', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Rashi Predictions', style: TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w700)),
                      SizedBox(height: 2),
                      Text("Today's gochar for all 12 signs — tap to drill in",
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                    ]),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.primary),
                ]),
              ),
            ),
            const SizedBox(height: 20),

            const Text('Request Summary', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Row(children: [
              _RequestCountChip(icon: Icons.chat_bubble, label: 'Chat', count: stats['chat_requests'] ?? 0, color: AppColors.accent),
              const SizedBox(width: 10),
              _RequestCountChip(icon: Icons.phone, label: 'Voice', count: stats['voice_requests'] ?? 0, color: AppColors.success),
              const SizedBox(width: 10),
              _RequestCountChip(icon: Icons.videocam, label: 'Video', count: stats['video_requests'] ?? 0, color: AppColors.primary),
            ]),
            const SizedBox(height: 20),

            // ── Recent Requests ──
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Recent Requests', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
              if (state.loading) const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)),
            ]),
            const SizedBox(height: 10),
            if (state.recentRequests.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                child: const Center(child: Text('No recent requests', style: TextStyle(color: AppColors.textSecondary))),
              )
            else
              ...state.recentRequests.map((req) => _RequestCard(request: req)),
          ]),
        );
      },
    );
  }
}

class _KpiCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _KpiCard({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, color: color, size: 26),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ]),
    );
  }
}

class _RequestCountChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;
  const _RequestCountChip({required this.icon, required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text('$count', style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
          Text(label, style: TextStyle(color: color.withOpacity(0.8), fontSize: 12)),
        ]),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final Map<String, dynamic> request;
  const _RequestCard({required this.request});

  @override
  Widget build(BuildContext context) {
    final type = request['type'] ?? 'chat';
    final userName = request['user_name'] ?? 'User';
    final status = request['status'] ?? 'pending';
    final createdAt = request['created_at'] ?? '';

    IconData typeIcon;
    Color typeColor;
    switch (type) {
      case 'voice':
        typeIcon = Icons.phone;
        typeColor = AppColors.success;
        break;
      case 'video':
        typeIcon = Icons.videocam;
        typeColor = AppColors.primary;
        break;
      default:
        typeIcon = Icons.chat_bubble;
        typeColor = AppColors.accent;
    }

    Color statusColor;
    switch (status) {
      case 'accepted':
        statusColor = AppColors.success;
        break;
      case 'declined':
      case 'cancelled':
        statusColor = AppColors.error;
        break;
      case 'completed':
        statusColor = AppColors.primary;
        break;
      default:
        statusColor = Colors.amber;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: typeColor.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
          child: Icon(typeIcon, color: typeColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(userName, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
          Text(createdAt, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
          child: Text(status.toString().toUpperCase(), style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w600)),
        ),
      ]),
    );
  }
}
