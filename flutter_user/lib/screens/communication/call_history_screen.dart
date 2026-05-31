import 'package:flutter/material.dart';
import '../../l10n/gen/app_localizations.dart';
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
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      _calls = await _api.getCallHistory(limit: 50);
      if (mounted) setState(() => _loading = false);
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)?.callHistory ?? 'Call History'),
        actions: [IconButton(onPressed: _load, icon: const Icon(Icons.refresh, size: 20))]),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _error != null
              ? _errorView()
              : _calls.isEmpty
                  ? _emptyView()
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

  Widget _errorView() => Center(child: Padding(
    padding: const EdgeInsets.all(24),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.error_outline, color: AppColors.error, size: 48),
      const SizedBox(height: 12),
      Text(_error!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13), textAlign: TextAlign.center),
      const SizedBox(height: 16),
      ElevatedButton(onPressed: _load, child: const Text('Retry')),
    ]),
  ));

  Widget _emptyView() => RefreshIndicator(
    onRefresh: _load,
    child: ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 80),
        Center(
          child: Container(
            width: 96, height: 96,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.12), shape: BoxShape.circle,
              border: Border.all(color: AppColors.success.withOpacity(0.3), width: 2)),
            child: const Icon(Icons.call_outlined, color: AppColors.success, size: 46),
          ),
        ),
        const SizedBox(height: 18),
        Center(child: Text(AppLocalizations.of(context)?.noCallsYet ?? 'No Calls Yet',
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700))),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text('${AppLocalizations.of(context)?.callAppearHere ?? 'Your call history with astrologers will appear here.'} ${AppLocalizations.of(context)?.pullToRefresh ?? 'Pull down to refresh.'}',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4)),
        ),
      ],
    ),
  );

  Widget _callCard(dynamic call) {
    final c = call as Map;
    final type = c['call_type']?.toString() ?? 'voice';
    final status = c['status']?.toString() ?? '';
    final dur = (c['duration_sec'] as num?)?.toInt() ?? 0;
    final amount = (c['total_amount'] as num?)?.toDouble() ?? 0;
    final rate = (c['rate_per_min'] as num?)?.toDouble() ?? 0;
    final date = c['created_at']?.toString() ?? '';
    final astrologerName = c['astrologer_name']?.toString() ?? 'Astrologer';
    final isVideo = type == 'video';
    final statusColor = status == 'completed' ? AppColors.success
        : status == 'active' ? AppColors.accent
        : status == 'missed' ? AppColors.error
        : status == 'rejected' ? Colors.orange
        : status == 'cancelled' ? AppColors.error
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
            borderRadius: BorderRadius.circular(12)),
          child: Icon(isVideo ? Icons.videocam : Icons.call, color: isVideo ? AppColors.primary : AppColors.success, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Flexible(child: Text(astrologerName, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14),
                maxLines: 1, overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
              child: Text(status.toUpperCase(), style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.bold)),
            ),
          ]),
          const SizedBox(height: 4),
          Text('${type == 'video' ? 'Video' : 'Voice'} call${dur > 0 ? '  •  ${_formatDuration(dur)}' : ''}',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
          Text(_formatDate(date), style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.center, children: [
          if (amount > 0) Text('₹${amount.toStringAsFixed(0)}',
              style: const TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w700)),
          if (rate > 0) Text('₹${rate.toStringAsFixed(0)}/min',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 9)),
        ]),
      ]),
    );
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
