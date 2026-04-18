import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';

class CallHistoryScreen extends StatefulWidget {
  const CallHistoryScreen({super.key});
  @override
  State<CallHistoryScreen> createState() => _CallHistoryScreenState();
}

class _CallHistoryScreenState extends State<CallHistoryScreen> {
  final _api = ApiService();
  List<dynamic> _calls = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    _calls = await _api.getCallHistory(limit: 50);
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Call History')),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _calls.isEmpty
              ? const Center(child: Text('No calls yet', style: TextStyle(color: AppColors.textSecondary)))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _calls.length,
                    itemBuilder: (_, i) => _callCard(_calls[i]),
                  ),
                ),
    );
  }

  Widget _callCard(dynamic call) {
    final c = call as Map;
    final type = c['call_type']?.toString() ?? 'voice';
    final status = c['status']?.toString() ?? '';
    final dur = (c['duration_sec'] as num?)?.toInt() ?? 0;
    final amount = (c['total_amount'] as num?)?.toDouble() ?? 0;
    final date = c['created_at']?.toString() ?? '';
    final isVideo = type == 'video';
    final statusColor = status == 'completed' ? AppColors.success
        : status == 'missed' ? AppColors.error
        : status == 'rejected' ? Colors.orange
        : AppColors.textSecondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Row(children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            color: (isVideo ? AppColors.primary : AppColors.success).withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(isVideo ? Icons.videocam : Icons.call, color: isVideo ? AppColors.primary : AppColors.success, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(type == 'video' ? 'Video Call' : 'Voice Call',
                style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
              child: Text(status.toUpperCase(), style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.bold)),
            ),
          ]),
          const SizedBox(height: 4),
          Text(_formatDate(date), style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          if (dur > 0) Text(_formatDuration(dur), style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
          if (amount > 0) Text('\u20b9${amount.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.primary, fontSize: 11)),
        ]),
      ]),
    );
  }

  String _formatDuration(int sec) {
    final m = sec ~/ 60;
    final s = sec % 60;
    return '${m}m ${s}s';
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso;
    }
  }
}
