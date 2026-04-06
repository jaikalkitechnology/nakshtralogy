import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/app_theme.dart';
import '../../bloc/dashboard/dashboard_bloc.dart';
import '../../bloc/dashboard/dashboard_event.dart';
import '../../bloc/dashboard/dashboard_state.dart';
import '../../bloc/status/status_bloc.dart';
import '../../bloc/status/status_event.dart';
import '../../services/api_service.dart';
import '../communication/chat_screen.dart';
import '../communication/active_call_screen.dart';

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
            const Text('No requests', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
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
              return _RequestActionCard(
                request: req,
                onUpdated: () => context.read<DashboardBloc>().add(DashboardLoadRequested()),
              );
            },
          ),
        );
      },
    );
  }
}

class _RequestActionCard extends StatefulWidget {
  final Map<String, dynamic> request;
  final VoidCallback onUpdated;
  const _RequestActionCard({required this.request, required this.onUpdated});

  @override
  State<_RequestActionCard> createState() => _RequestActionCardState();
}

class _RequestActionCardState extends State<_RequestActionCard> {
  final _api = ApiService();
  bool _loading = false;

  Future<void> _acceptChat(String sessionId, String userName) async {
    setState(() => _loading = true);
    try {
      final resp = await _api.chatAction(sessionId, 'accept');
      if (!mounted) return;
      if (resp['statusCode'] == 200 || resp['statusCode'] == 201) {
        widget.onUpdated();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => AstroChatScreen(
            sessionId: sessionId,
            userName: userName,
            ratePerMin: (resp['rate_per_min'] as num?)?.toDouble() ?? 0,
            ratePerSession: (resp['rate_per_session'] as num?)?.toDouble() ?? 0,
            billingMode: resp['billing_mode'] ?? 'per_session',
            sessionMessageLimit: resp['session_message_limit'] ?? 45,
          ),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(resp['detail'] ?? 'Failed to accept'), backgroundColor: AppColors.error),
        );
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error));
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _acceptCall(String callId, String userName, String callType) async {
    setState(() => _loading = true);
    try {
      final resp = await _api.callAction(callId, 'accept');
      if (!mounted) return;
      if (resp['statusCode'] == 200 || resp['statusCode'] == 201) {
        widget.onUpdated();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ActiveCallScreen(
            callId: callId,
            channelName: resp['channel_name'] ?? '',
            agoraToken: resp['agora_token'] ?? '',
            agoraAppId: resp['agora_app_id'] ?? '',
            callType: callType,
            peerName: userName,
            ratePerMin: (resp['rate_per_min'] as num?)?.toDouble() ?? 0,
            isAstrologer: true,
          ),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(resp['detail'] ?? 'Failed — may have expired'), backgroundColor: AppColors.error),
        );
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error));
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _decline(String id, String type) async {
    setState(() => _loading = true);
    try {
      if (type == 'chat') {
        await _api.chatAction(id, 'cancel');
      } else {
        await _api.callAction(id, 'reject');
      }
      widget.onUpdated();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request declined')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _endSession(String id, String type) async {
    setState(() => _loading = true);
    try {
      if (type == 'chat') {
        await _api.chatAction(id, 'end');
      } else {
        await _api.callAction(id, 'end');
      }
      // Release busy status
      if (mounted) context.read<StatusBloc>().add(const StatusToggleOnline(isOnline: true));
      widget.onUpdated();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Session ended'), backgroundColor: AppColors.success));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
    if (mounted) setState(() => _loading = false);
  }

  void _enterChat(String sessionId, String userName) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => AstroChatScreen(
        sessionId: sessionId,
        userName: userName,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.request['type'] ?? 'chat';
    final userName = widget.request['user_name'] ?? 'User';
    final status = widget.request['status'] ?? 'pending';
    final createdAt = widget.request['created_at'] ?? '';
    final id = widget.request['id'] ?? widget.request['session_id'] ?? widget.request['call_id'] ?? '';

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
            Text('${type.toString().toUpperCase()} consultation', style: TextStyle(color: typeColor, fontSize: 13, fontWeight: FontWeight.w500)),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: _statusColor(status).withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
            child: Text(status.toString().toUpperCase(), style: TextStyle(color: _statusColor(status), fontSize: 11, fontWeight: FontWeight.w600)),
          ),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(createdAt.toString(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ]),

        // ── Action Buttons based on status ──
        if (_loading)
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))),
          )
        // PENDING / WAITING / RINGING → Accept + Decline
        else if (status == 'pending' || status == 'waiting' || status == 'ringing') ...[
          const SizedBox(height: 14),
          Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _decline(id, type),
                icon: const Icon(Icons.close, size: 18),
                label: const Text('Decline'),
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error), minimumSize: const Size(0, 42)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  if (type == 'chat') {
                    _acceptChat(id, userName);
                  } else {
                    _acceptCall(id, userName, type);
                  }
                },
                icon: Icon(type == 'chat' ? Icons.chat : type == 'video' ? Icons.videocam : Icons.call, size: 18),
                label: const Text('Accept'),
                style: ElevatedButton.styleFrom(minimumSize: const Size(0, 42)),
              ),
            ),
          ]),
        ]
        // ACTIVE → Enter + End Session
        else if (status == 'active') ...[
          const SizedBox(height: 14),
          Row(children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  if (type == 'chat') {
                    _enterChat(id, userName);
                  }
                  // For active calls, user is already in the call screen
                },
                icon: Icon(type == 'chat' ? Icons.chat : Icons.open_in_new, size: 18),
                label: Text(type == 'chat' ? 'Enter Chat' : 'In Progress'),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, minimumSize: const Size(0, 42)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _endSession(id, type),
                icon: const Icon(Icons.stop, size: 18),
                label: const Text('End Session'),
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error), minimumSize: const Size(0, 42)),
              ),
            ),
          ]),
        ],
        // COMPLETED / CANCELLED / etc → no actions, just info
      ]),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'active':
        return AppColors.success;
      case 'accepted':
        return AppColors.success;
      case 'ringing':
      case 'waiting':
      case 'pending':
        return Colors.amber;
      case 'completed':
        return AppColors.primary;
      case 'declined':
      case 'cancelled':
      case 'rejected':
      case 'missed':
      case 'expired':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }
}
