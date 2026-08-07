import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../../l10n/gen/app_localizations.dart';

class NotificationScreen extends StatefulWidget {
  /// When true, renders just the list body (no Scaffold/AppBar) so it can be
  /// embedded inside a tab (e.g. the notification hub).
  final bool embedded;
  const NotificationScreen({super.key, this.embedded = false});
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _api = ApiService();
  List<Map<String, dynamic>> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final resp = await _api.getNotifications(limit: 50);
    if (mounted) {
      setState(() {
        _items = ((resp['items'] as List?) ?? []).map((e) => (e as Map).cast<String, dynamic>()).toList();
        _loading = false;
      });
    }
  }

  Future<void> _markAllRead() async {
    await _api.markAllNotificationsRead();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final body = _loading
        ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
        : _items.isEmpty
            ? _emptyView(l)
            : RefreshIndicator(
                onRefresh: _load,
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: _items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                  itemBuilder: (_, i) => _notifCard(_items[i], l),
                ),
              );
    if (widget.embedded) return body;

    final unread = _items.where((n) => n['is_read'] != true).length;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l.notifications, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
        actions: [
          if (unread > 0) TextButton(
            onPressed: _markAllRead,
            child: Text(l.markAllRead, style: const TextStyle(fontSize: 11)),
          ),
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh, size: 20)),
        ],
      ),
      body: body,
    );
  }

  Widget _emptyView(AppLocalizations l) => RefreshIndicator(
    onRefresh: _load,
    child: ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 100),
        Center(child: Container(
          width: 80, height: 80,
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
          child: const Icon(Icons.notifications_none, color: AppColors.primary, size: 40),
        )),
        const SizedBox(height: 16),
        Center(child: Text(l.noNotificationsYet, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600))),
        const SizedBox(height: 6),
        Center(child: Text(l.pullToRefresh, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12))),
      ],
    ),
  );

  Widget _notifCard(Map<String, dynamic> n, AppLocalizations l) {
    final isRead = n['is_read'] == true;
    final type = n['type']?.toString() ?? '';
    final title = n['title']?.toString() ?? '';
    final body = n['body']?.toString() ?? '';
    final date = n['created_at']?.toString() ?? '';
    final id = n['id']?.toString() ?? '';

    IconData icon;
    Color iconColor;
    switch (type) {
      case 'incoming_call': icon = Icons.call; iconColor = AppColors.success; break;
      case 'call_accepted': icon = Icons.call_made; iconColor = AppColors.success; break;
      case 'chat_request': icon = Icons.chat_bubble_outline; iconColor = AppColors.accent; break;
      case 'chat_accepted': icon = Icons.chat; iconColor = AppColors.accent; break;
      case 'chat_message': icon = Icons.message; iconColor = AppColors.primary; break;
      default: icon = Icons.notifications; iconColor = AppColors.primary;
    }

    return GestureDetector(
      onTap: () async {
        if (!isRead) {
          await _api.markNotificationRead(id);
          setState(() => n['is_read'] = true);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isRead ? AppColors.card : AppColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isRead ? AppColors.border : AppColors.primary.withOpacity(0.3)),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: iconColor.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(title, style: TextStyle(
                color: AppColors.textPrimary, fontSize: 13,
                fontWeight: isRead ? FontWeight.w500 : FontWeight.w700))),
              if (!isRead) Container(
                width: 8, height: 8,
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
            ]),
            if (body.isNotEmpty) ...[const SizedBox(height: 2),
              Text(body, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis)],
            const SizedBox(height: 4),
            Text(_formatDate(date, l), style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
          ])),
        ]),
      ),
    );
  }

  String _formatDate(String iso, AppLocalizations l) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 1) return l.justNow;
      if (diff.inMinutes < 60) return l.minutesAgo(diff.inMinutes);
      if (diff.inHours < 24) return l.hoursAgo(diff.inHours);
      if (diff.inDays < 7) return l.daysAgo(diff.inDays);
      final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) { return iso; }
  }
}
