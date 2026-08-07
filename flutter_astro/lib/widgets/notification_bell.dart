import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';

/// Dashboard bell with a live red unread badge. The count comes from the
/// astrologer's unread in-app notifications — which include new chat / audio /
/// video requests (each is saved as a notification server-side). Tapping opens
/// the requests inbox and clears the badge (marks everything read).
class NotificationBell extends StatefulWidget {
  /// Opens the requests/notifications view (e.g. switches to the Requests tab).
  final VoidCallback onOpen;
  const NotificationBell({super.key, required this.onOpen});

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  int _count = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _load();
    _timer = Timer.periodic(const Duration(seconds: 20), (_) => _load());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final c = await ApiService().getUnreadCount();
      if (mounted && c != _count) setState(() => _count = c);
    } catch (_) {}
  }

  Future<void> _open() async {
    widget.onOpen();
    // "Clicked → bell without badge": clear the unread badge immediately, then
    // mark everything read on the server.
    if (mounted) setState(() => _count = 0);
    try {
      await ApiService().markAllNotificationsRead();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final label = _count > 99 ? '99+' : '$_count';
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded, color: AppColors.ivory),
          onPressed: _open,
          tooltip: 'Notifications',
        ),
        if (_count > 0)
          Positioned(
            top: 8,
            right: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: AppColors.midnight, width: 1.5),
              ),
              alignment: Alignment.center,
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold, height: 1.1),
              ),
            ),
          ),
      ],
    );
  }
}
