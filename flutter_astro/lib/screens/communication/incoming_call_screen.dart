import 'dart:async';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import 'active_call_screen.dart';

class IncomingCallScreen extends StatefulWidget {
  final String callId;
  final String callerName;
  final String callType; // voice | video
  final double ratePerMin;

  const IncomingCallScreen({
    super.key,
    required this.callId,
    required this.callerName,
    required this.callType,
    required this.ratePerMin,
  });

  @override
  State<IncomingCallScreen> createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  int _countdown = 60;
  Timer? _timer;
  final _api = ApiService();
  bool _responding = false;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _countdown--);
      if (_countdown <= 0) {
        _timer?.cancel();
        if (mounted) Navigator.pop(context);
      }
    });
  }

  Future<void> _respond(String action) async {
    if (_responding) return;
    _responding = true;
    _timer?.cancel();

    try {
      final resp = await _api.callAction(widget.callId, action);
      if (!mounted) return;

      if (action == 'accept' && (resp['statusCode'] == 200 || resp['statusCode'] == 201)) {
        // Navigate to active call screen with Agora details
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (_) => ActiveCallScreen(
            callId: widget.callId,
            channelName: resp['channel_name'] ?? '',
            agoraToken: resp['agora_token'] ?? '',
            agoraAppId: resp['agora_app_id'] ?? '',
            callType: widget.callType,
            peerName: widget.callerName,
            ratePerMin: widget.ratePerMin,
            isAstrologer: true,
          ),
        ));
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),

            // Pulsing avatar
            AnimatedBuilder(
              animation: _pulseCtrl,
              builder: (_, child) {
                final scale = 1.0 + _pulseCtrl.value * 0.1;
                return Transform.scale(scale: scale, child: child);
              },
              child: Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.card,
                  border: Border.all(color: AppColors.primary, width: 3),
                  boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 30, spreadRadius: 5)],
                ),
                child: const Center(child: Text('\u{1F9D1}', style: TextStyle(fontSize: 48))),
              ),
            ),
            const SizedBox(height: 24),

            Text('Incoming ${widget.callType == 'video' ? 'Video' : 'Voice'} Call',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
            const SizedBox(height: 8),
            Text(widget.callerName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('\u20b9${widget.ratePerMin.toInt()}/min', style: const TextStyle(color: AppColors.primary, fontSize: 16)),
            const SizedBox(height: 16),
            Text('Auto-decline in ${_countdown}s', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),

            const Spacer(flex: 3),

            // Accept / Reject
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _responding ? null : () => _respond('reject'),
                    child: Container(
                      width: 72, height: 72,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.error),
                      child: const Icon(Icons.call_end, color: Colors.white, size: 32),
                    ),
                  ),
                  GestureDetector(
                    onTap: _responding ? null : () => _respond('accept'),
                    child: Container(
                      width: 72, height: 72,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.success),
                      child: Icon(
                        widget.callType == 'video' ? Icons.videocam : Icons.call,
                        color: Colors.white, size: 32,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
