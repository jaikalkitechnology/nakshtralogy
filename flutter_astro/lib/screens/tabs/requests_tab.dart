import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/app_theme.dart';
import '../../bloc/dashboard/dashboard_bloc.dart';
import '../../bloc/dashboard/dashboard_event.dart';
import '../../bloc/dashboard/dashboard_state.dart';

class RequestsTab extends StatelessWidget {
  const RequestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state.loading && state.recentRequests.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        final requests = state.recentRequests;
        if (requests.isEmpty) {
          return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.inbox, size: 56, color: AppColors.textSecondary),
            const SizedBox(height: 12),
            const Text('No pending requests', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => context.read<DashboardBloc>().add(DashboardLoadRequested()),
              child: const Text('Refresh'),
            ),
          ]));
        }
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async => context.read<DashboardBloc>().add(DashboardLoadRequested()),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final req = requests[index] as Map<String, dynamic>;
              return _RequestActionCard(request: req);
            },
          ),
        );
      },
    );
  }
}

class _RequestActionCard extends StatelessWidget {
  final Map<String, dynamic> request;
  const _RequestActionCard({required this.request});

  @override
  Widget build(BuildContext context) {
    final type = request['type'] ?? 'chat';
    final userName = request['user_name'] ?? 'User';
    final status = request['status'] ?? 'pending';
    final createdAt = request['created_at'] ?? '';
    final duration = request['duration'] ?? '';

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

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: typeColor.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
            child: Icon(typeIcon, color: typeColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(userName, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 2),
            Text('$type consultation', style: TextStyle(color: typeColor, fontSize: 13, fontWeight: FontWeight.w500)),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: _statusColor(status).withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
            child: Text(status.toString().toUpperCase(), style: TextStyle(color: _statusColor(status), fontSize: 11, fontWeight: FontWeight.w600)),
          ),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(createdAt, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          if (duration.toString().isNotEmpty) ...[
            const SizedBox(width: 16),
            const Icon(Icons.timer, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(duration.toString(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ],
        ]),
        if (status == 'pending') ...[
          const SizedBox(height: 14),
          Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request declined')));
                },
                icon: const Icon(Icons.close, size: 18),
                label: const Text('Decline'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  minimumSize: const Size(0, 40),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request accepted')));
                },
                icon: const Icon(Icons.check, size: 18),
                label: const Text('Accept'),
                style: ElevatedButton.styleFrom(minimumSize: const Size(0, 40)),
              ),
            ),
          ]),
        ],
      ]),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'accepted':
        return AppColors.success;
      case 'declined':
      case 'cancelled':
        return AppColors.error;
      case 'completed':
        return AppColors.primary;
      default:
        return Colors.amber;
    }
  }
}
