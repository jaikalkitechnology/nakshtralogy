import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hj_core/hj_core.dart';

import '../../core/di.dart';
import 'notification_repository.dart';

/// App-bar bell with a live red unread-count badge. Fetches the count on load
/// and again whenever the app resumes; tapping opens the inbox and refreshes
/// on return. Kept intentionally quiet — any failure just leaves the last
/// known count (no error surfaced for a decorative badge).
class NotificationBell extends StatefulWidget {
  const NotificationBell({super.key});

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell>
    with WidgetsBindingObserver {
  int _count = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _load();
  }

  Future<void> _load() async {
    try {
      final c = await getIt<NotificationRepository>().unreadCount();
      if (mounted && c != _count) setState(() => _count = c);
    } catch (_) {/* leave the last known count */}
  }

  Future<void> _open() async {
    await context.push('/notifications');
    if (mounted) _load();
  }

  @override
  Widget build(BuildContext context) {
    final label = _count > 99 ? '99+' : '$_count';
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.notifications_none_rounded, color: AppColors.ivory),
          onPressed: _open,
          tooltip: MaterialLocalizations.of(context).moreButtonTooltip,
        ),
        if (_count > 0)
          Positioned(
            top: 8,
            right: 6,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              constraints:
                  const BoxConstraints(minWidth: 16, minHeight: 16),
              decoration: BoxDecoration(
                color: AppColors.danger,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: AppColors.indigoDeep, width: 1.5),
              ),
              alignment: Alignment.center,
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
