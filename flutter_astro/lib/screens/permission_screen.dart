import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

class PermissionScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const PermissionScreen({super.key, required this.onComplete});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  final List<_PermItem> _permissions = [];
  bool _requesting = false;

  @override
  void initState() {
    super.initState();
    _loadStatuses();
  }

  Future<void> _loadStatuses() async {
    final items = <_PermItem>[
      _PermItem(Permission.camera, Icons.camera_alt, 'Camera', 'For video calls and live streaming'),
      _PermItem(Permission.microphone, Icons.mic, 'Microphone', 'For voice/video calls and live streaming'),
      _PermItem(Permission.notification, Icons.notifications, 'Notifications', 'For incoming call alerts and chat messages'),
      _PermItem(Permission.storage, Icons.folder, 'Storage', 'For sharing photos and PDF files in chat'),
      _PermItem(Permission.bluetoothConnect, Icons.bluetooth, 'Bluetooth', 'For connecting audio devices during calls'),
    ];

    for (final item in items) {
      item.status = await item.permission.status;
    }

    setState(() => _permissions.addAll(items));
  }

  Future<void> _requestAll() async {
    setState(() => _requesting = true);

    for (final item in _permissions) {
      if (!item.status.isGranted) {
        item.status = await item.permission.request();
      }
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('permissions_requested', true);

    setState(() => _requesting = false);
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const Icon(Icons.shield_outlined, size: 64, color: AppColors.primary),
              const SizedBox(height: 16),
              Text('App Permissions', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontSize: 24)),
              const SizedBox(height: 8),
              const Text(
                'We need a few permissions to provide you the best experience with calls, live streaming, and notifications.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 32),

              Expanded(
                child: ListView.builder(
                  itemCount: _permissions.length,
                  itemBuilder: (_, i) {
                    final item = _permissions[i];
                    final granted = item.status.isGranted;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: granted ? AppColors.success.withOpacity(0.5) : AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(
                              color: granted ? AppColors.success.withOpacity(0.15) : AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(item.icon, color: granted ? AppColors.success : AppColors.primary, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(item.label, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 15)),
                              const SizedBox(height: 2),
                              Text(item.description, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                            ]),
                          ),
                          Icon(
                            granted ? Icons.check_circle : Icons.circle_outlined,
                            color: granted ? AppColors.success : AppColors.textSecondary,
                            size: 24,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _requesting ? null : _requestAll,
                child: _requesting
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                    : const Text('Grant Permissions'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _requesting ? null : () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('permissions_requested', true);
                  widget.onComplete();
                },
                child: const Text('Skip for now', style: TextStyle(color: AppColors.textSecondary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _PermItem {
  final Permission permission;
  final IconData icon;
  final String label;
  final String description;
  PermissionStatus status;

  _PermItem(this.permission, this.icon, this.label, this.description, {this.status = PermissionStatus.denied});
}


Future<bool> shouldShowPermissionScreen() async {
  final prefs = await SharedPreferences.getInstance();
  return !(prefs.getBool('permissions_requested') ?? false);
}
