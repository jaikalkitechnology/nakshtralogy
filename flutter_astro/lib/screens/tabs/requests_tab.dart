import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/responsive.dart';
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
            Text(AppLocalizations.of(context)?.noRequests ?? 'No requests', style: const TextStyle(color: AppColors.textSecondary, fontSize: 16)),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => context.read<DashboardBloc>().add(DashboardLoadRequested()),
              child: Text(AppLocalizations.of(context)?.refresh ?? 'Refresh'),
            ),
          ]));
        }
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async => context.read<DashboardBloc>().add(DashboardLoadRequested()),
          child: Center(child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Responsive.isDesktop(context) ? 900 : double.infinity),
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
          ))),
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
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)?.requestDeclined ?? 'Request declined')));
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
      if (mounted) context.read<StatusBloc>().add(const StatusToggleOnline(isOnline: true));
      widget.onUpdated();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)?.sessionEnded ?? 'Session ended'), backgroundColor: AppColors.success));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
    if (mounted) setState(() => _loading = false);
  }

  /// Re-open a still-active call (the astrologer left the call screen — e.g. an
  /// app-switch — and taps "In Progress" to return). Fetches the live channel +
  /// token; if the call has since ended, just refreshes the list.
  Future<void> _reenterCall(String callId, String userName, String callType) async {
    setState(() => _loading = true);
    try {
      final resp = await _api.getCall(callId);
      if (!mounted) return;
      if (resp['statusCode'] == 200 && resp['status'] == 'active') {
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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Call is no longer active'), backgroundColor: AppColors.error));
        widget.onUpdated();
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _enterChat(String sessionId, String userName) async {
    setState(() => _loading = true);
    try {
      final resp = await _api.getChatSession(sessionId);
      if (!mounted) return;
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => AstroChatScreen(
          sessionId: sessionId,
          userName: userName,
          ratePerMin: (resp['rate_per_min'] as num?)?.toDouble() ?? 0,
          ratePerSession: (resp['rate_per_session'] as num?)?.toDouble() ?? 0,
          billingMode: resp['billing_mode'] as String? ?? 'per_session',
          sessionMessageLimit: (resp['session_message_limit'] as num?)?.toInt() ?? 45,
        ),
      ));
    } catch (_) {
      if (mounted) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => AstroChatScreen(sessionId: sessionId, userName: userName),
        ));
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  void _viewCompletedSession() {
    final req = widget.request;
    final type = req['type'] ?? 'chat';
    final id = req['id'] ?? '';
    final userName = req['user_name'] ?? 'User';
    final earning = (req['earning'] as num?)?.toDouble() ?? 0;
    final totalAmount = (req['total_amount'] as num?)?.toDouble() ?? 0;
    final dur = (req['duration_sec'] as num?)?.toInt() ?? 0;
    final ratePerMin = (req['rate_per_min'] as num?)?.toDouble() ?? 0;
    final date = req['created_at']?.toString() ?? '';

    if (type == 'chat') {
      final billing = req['billing_mode']?.toString() ?? 'per_session';
      final ratePerSession = (req['rate_per_session'] as num?)?.toDouble() ?? 0;
      final msgCount = (req['user_message_count'] as num?)?.toInt() ?? 0;
      final msgLimit = (req['session_message_limit'] as num?)?.toInt() ?? 45;
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => _CompletedChatView(
          sessionId: id, userName: userName, earning: earning,
          totalAmount: totalAmount, duration: dur, ratePerMin: ratePerMin,
          ratePerSession: ratePerSession, billingMode: billing,
          msgCount: msgCount, msgLimit: msgLimit, date: date,
        ),
      ));
    } else {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => _CompletedCallView(
          userName: userName, callType: type, earning: earning,
          totalAmount: totalAmount, duration: dur, ratePerMin: ratePerMin, date: date,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.request['type'] ?? 'chat';
    final userName = widget.request['user_name'] ?? 'User';
    final status = widget.request['status'] ?? 'pending';
    final createdAt = widget.request['created_at'] ?? '';
    final id = widget.request['id'] ?? widget.request['session_id'] ?? widget.request['call_id'] ?? '';
    final earning = (widget.request['earning'] as num?)?.toDouble() ?? 0;
    final dur = (widget.request['duration_sec'] as num?)?.toInt() ?? 0;
    final isCompleted = status == 'completed' || status == 'expired' || status == 'cancelled';

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

    return GestureDetector(
      onTap: isCompleted ? _viewCompletedSession : null,
      child: Container(
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
              Text('${type.toString().toUpperCase()} ${AppLocalizations.of(context)?.consultation ?? 'consultation'}', style: TextStyle(color: typeColor, fontSize: 13, fontWeight: FontWeight.w500)),
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
            Expanded(child: Text(_formatDate(createdAt.toString()), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12))),
            if (dur > 0) ...[
              Text(_formatDuration(dur), style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(width: 10),
            ],
            if (earning > 0) Text('₹${earning.toStringAsFixed(0)}',
                style: const TextStyle(color: AppColors.success, fontSize: 13, fontWeight: FontWeight.w700)),
          ]),

          if (isCompleted) Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(children: [
              Icon(type == 'chat' ? Icons.chat_bubble_outline : Icons.info_outline, size: 14, color: AppColors.accent),
              const SizedBox(width: 4),
              Text(type == 'chat' ? (AppLocalizations.of(context)?.tapViewChat ?? 'Tap to view chat history') : (AppLocalizations.of(context)?.tapViewCall ?? 'Tap to view call details'),
                  style: TextStyle(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.w500)),
              const Spacer(),
              const Icon(Icons.chevron_right, size: 16, color: AppColors.accent),
            ]),
          ),

          if (_loading)
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))),
            )
          else if (status == 'pending' || status == 'waiting' || status == 'ringing') ...[
            const SizedBox(height: 14),
            Row(children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _decline(id, type),
                  icon: const Icon(Icons.close, size: 18),
                  label: Text(AppLocalizations.of(context)?.decline ?? 'Decline'),
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error), minimumSize: const Size(0, 42)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (type == 'chat') _acceptChat(id, userName);
                    else _acceptCall(id, userName, type);
                  },
                  icon: Icon(type == 'chat' ? Icons.chat : type == 'video' ? Icons.videocam : Icons.call, size: 18),
                  label: Text(AppLocalizations.of(context)?.accept ?? 'Accept'),
                  style: ElevatedButton.styleFrom(minimumSize: const Size(0, 42)),
                ),
              ),
            ]),
          ]
          else if (status == 'active') ...[
            const SizedBox(height: 14),
            Row(children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (type == 'chat') _enterChat(id, userName);
                    else _reenterCall(id, userName, type);
                  },
                  icon: Icon(type == 'chat' ? Icons.chat : Icons.open_in_new, size: 18),
                  label: Text(type == 'chat' ? (AppLocalizations.of(context)?.enterChat ?? 'Enter Chat') : (AppLocalizations.of(context)?.inProgress ?? 'In Progress')),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, minimumSize: const Size(0, 42)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _endSession(id, type),
                  icon: const Icon(Icons.stop, size: 18),
                  label: Text(AppLocalizations.of(context)?.endSession ?? 'End Session'),
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error), minimumSize: const Size(0, 42)),
                ),
              ),
            ]),
          ],
        ]),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'active': case 'accepted': return AppColors.success;
      case 'ringing': case 'waiting': case 'pending': return Colors.amber;
      case 'completed': return AppColors.primary;
      case 'declined': case 'cancelled': case 'rejected': case 'missed': case 'expired': return AppColors.error;
      default: return AppColors.textSecondary;
    }
  }

  String _formatDuration(int sec) {
    final m = sec ~/ 60;
    final s = sec % 60;
    if (m == 0) return '${s}s';
    return '${m}m ${s}s';
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}, ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) { return iso; }
  }
}


class _CompletedChatView extends StatefulWidget {
  final String sessionId, userName, billingMode, date;
  final double earning, totalAmount, ratePerMin, ratePerSession;
  final int duration, msgCount, msgLimit;
  const _CompletedChatView({required this.sessionId, required this.userName, required this.earning,
    required this.totalAmount, required this.duration, required this.ratePerMin,
    required this.ratePerSession, required this.billingMode,
    required this.msgCount, required this.msgLimit, required this.date});
  @override
  State<_CompletedChatView> createState() => _CompletedChatViewState();
}

class _CompletedChatViewState extends State<_CompletedChatView> {
  final _api = ApiService();
  List<dynamic> _messages = [];
  bool _loading = true;
  String? _myUserId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final me = await _api.getMe();
      _myUserId = me['id']?.toString();
      _messages = await _api.getChatMessages(widget.sessionId, limit: 500);
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Chat with ${widget.userName}')),
      body: Column(children: [
        _summaryCard(),
        const Divider(height: 1, color: AppColors.border),
        Expanded(child: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _messages.isEmpty
              ? const Center(child: Text('No messages in this session', style: TextStyle(color: AppColors.textSecondary)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (_, i) => _msgBubble(_messages[i]),
                ),
        ),
      ]),
    );
  }

  Widget _summaryCard() {
    final rate = widget.billingMode == 'per_session'
        ? '₹${widget.ratePerSession.toStringAsFixed(0)}/session'
        : '₹${widget.ratePerMin.toStringAsFixed(0)}/min';
    return Container(
      padding: const EdgeInsets.all(14),
      color: AppColors.card,
      child: Column(children: [
        Row(children: [
          _statChip('EARNED', '₹${widget.earning.toStringAsFixed(0)}', AppColors.success),
          const SizedBox(width: 10),
          _statChip('CHARGED', '₹${widget.totalAmount.toStringAsFixed(0)}', AppColors.primary),
          const SizedBox(width: 10),
          _statChip('MESSAGES', '${widget.msgCount}/${widget.msgLimit}', AppColors.accent),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Text('Rate: $rate', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
          const Spacer(),
          if (widget.duration > 0) Text('Duration: ${_fmtDur(widget.duration)}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
        ]),
        Row(children: [
          Text(_fmtDate(widget.date), style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
        ]),
      ]),
    );
  }

  Widget _statChip(String label, String value, Color c) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Column(children: [
        Text(value, style: TextStyle(color: c, fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: c.withOpacity(0.7), fontSize: 8, fontWeight: FontWeight.w600, letterSpacing: 1, fontFamily: 'monospace')),
      ]),
    ),
  );

  Widget _msgBubble(dynamic msg) {
    final m = msg as Map;
    final isMe = m['sender_id']?.toString() == _myUserId;
    final content = m['content']?.toString() ?? '';
    final type = m['message_type']?.toString() ?? 'text';
    final time = m['created_at']?.toString() ?? '';

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary.withOpacity(0.2) : AppColors.card,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14), topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(isMe ? 14 : 4), bottomRight: Radius.circular(isMe ? 4 : 14)),
          border: Border.all(color: isMe ? AppColors.primary.withOpacity(0.4) : AppColors.border),
        ),
        child: Column(crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
          if (!isMe) Padding(padding: const EdgeInsets.only(bottom: 2),
            child: Text(widget.userName, style: const TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.w600))),
          if (type == 'text')
            Text(content, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13))
          else
            Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(type == 'image' ? Icons.image : type == 'audio' ? Icons.mic : Icons.attach_file, size: 14, color: AppColors.accent),
              const SizedBox(width: 4),
              Flexible(child: Text(m['file_name']?.toString() ?? content, style: const TextStyle(color: AppColors.accent, fontSize: 12), overflow: TextOverflow.ellipsis)),
            ]),
          const SizedBox(height: 4),
          Text(_fmtTime(time), style: const TextStyle(color: AppColors.textSecondary, fontSize: 9)),
        ]),
      ),
    );
  }

  String _fmtTime(String iso) {
    try { final dt = DateTime.parse(iso).toLocal(); return '${dt.hour}:${dt.minute.toString().padLeft(2, '0')}'; }
    catch (_) { return ''; }
  }

  String _fmtDur(int sec) {
    final m = sec ~/ 60; final s = sec % 60;
    if (m == 0) return '${s}s';
    return '${m}m ${s}s';
  }

  String _fmtDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}, ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) { return iso; }
  }
}


class _CompletedCallView extends StatelessWidget {
  final String userName, callType, date;
  final double earning, totalAmount, ratePerMin;
  final int duration;
  const _CompletedCallView({required this.userName, required this.callType, required this.earning,
    required this.totalAmount, required this.duration, required this.ratePerMin, required this.date});

  @override
  Widget build(BuildContext context) {
    final isVideo = callType == 'video';
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('${isVideo ? 'Video' : 'Voice'} Call Details')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        const SizedBox(height: 20),
        Center(child: Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            color: (isVideo ? AppColors.primary : AppColors.success).withOpacity(0.15),
            shape: BoxShape.circle),
          child: Icon(isVideo ? Icons.videocam : Icons.call, color: isVideo ? AppColors.primary : AppColors.success, size: 36),
        )),
        const SizedBox(height: 16),
        Center(child: Text(userName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w700))),
        const SizedBox(height: 4),
        Center(child: Text('${isVideo ? 'Video' : 'Voice'} Call • Completed',
            style: const TextStyle(color: AppColors.success, fontSize: 13))),
        Center(child: Text(_fmtDate(date), style: const TextStyle(color: AppColors.textSecondary, fontSize: 11))),
        const SizedBox(height: 24),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
          child: Column(children: [
            _detailRow('Duration', _fmtDur(duration), AppColors.textPrimary),
            const Divider(color: AppColors.border, height: 20),
            _detailRow('Rate', '₹${ratePerMin.toStringAsFixed(0)}/min', AppColors.textSecondary),
            const Divider(color: AppColors.border, height: 20),
            _detailRow('Total Charged', '₹${totalAmount.toStringAsFixed(0)}', AppColors.primary),
            const Divider(color: AppColors.border, height: 20),
            _detailRow('Your Earning', '₹${earning.toStringAsFixed(0)}', AppColors.success),
          ]),
        ),
      ]),
    );
  }

  Widget _detailRow(String label, String value, Color vc) => Row(children: [
    Expanded(child: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13))),
    Text(value, style: TextStyle(color: vc, fontSize: 15, fontWeight: FontWeight.w700)),
  ]);

  String _fmtDur(int sec) {
    final m = sec ~/ 60; final s = sec % 60;
    if (m == 0 && s == 0) return '—';
    if (m == 0) return '${s}s';
    return '${m}m ${s}s';
  }

  String _fmtDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}, ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) { return iso; }
  }
}
