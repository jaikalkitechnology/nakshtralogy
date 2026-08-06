import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/web_push_service.dart';

/// Web-only notifications control for the profile screen. Shows the current
/// browser permission and lets the user enable it with a tap (the gesture iOS
/// Safari requires). Renders nothing off the web platform.
class WebNotificationTile extends StatefulWidget {
  const WebNotificationTile({super.key});
  @override
  State<WebNotificationTile> createState() => _WebNotificationTileState();
}

class _WebNotificationTileState extends State<WebNotificationTile> {
  String _perm = 'unsupported';
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() => setState(() => _perm = WebPushService().permissionState);

  Future<void> _enable() async {
    setState(() => _busy = true);
    final ok = await WebPushService().enableFromGesture();
    if (!mounted) return;
    setState(() { _busy = false; _perm = WebPushService().permissionState; });
    if (!ok && _perm == 'denied') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Notifications are blocked. Turn them on in your browser/site settings, then reload.'),
        backgroundColor: AppColors.error, duration: Duration(seconds: 5),
      ));
    } else if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Notifications enabled'), backgroundColor: AppColors.success,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb || _perm == 'unsupported') return const SizedBox.shrink();
    final granted = _perm == 'granted';
    final denied = _perm == 'denied';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(children: [
        Icon(granted ? Icons.notifications_active : Icons.notifications_off,
            color: granted ? AppColors.success : AppColors.primary, size: 22),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Notifications', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
          Text(
            granted ? 'On — you\'ll get call & chat alerts'
                : denied ? 'Blocked in browser settings'
                : 'Off — tap to enable',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
          ),
        ])),
        if (_busy)
          const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
        else if (granted)
          const Icon(Icons.check_circle, color: AppColors.success, size: 22)
        else
          TextButton(
            onPressed: _enable,
            child: Text(denied ? 'How?' : 'Enable', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
          ),
      ]),
    );
  }
}
