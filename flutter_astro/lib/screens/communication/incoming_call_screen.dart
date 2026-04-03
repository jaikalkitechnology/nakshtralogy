import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_theme.dart';
import '../../utils/constants.dart';

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

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _countdown--);
      if (_countdown <= 0) {
        _timer?.cancel();
        Navigator.pop(context); // auto-dismiss
      }
    });
  }

  Future<void> _respond(String action) async {
    _timer?.cancel();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final resp = await http.post(
      Uri.parse('${ApiConstants.commBase}/call/${widget.callId}/action'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode({'action': action}),
    );
    if (mounted) {
      if (action == 'accept' && resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        // TODO: Navigate to active call screen with Agora token
        Navigator.pop(context, data);
      } else {
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
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.card,
                  border: Border.all(color: AppColors.primary, width: 3),
                  boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 30, spreadRadius: 5)],
                ),
                child: const Center(child: Text('🧑', style: TextStyle(fontSize: 48))),
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

            // Countdown
            Text('Auto-decline in ${_countdown}s', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),

            const Spacer(flex: 3),

            // Accept / Reject buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Reject
                  GestureDetector(
                    onTap: () => _respond('reject'),
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.error),
                      child: const Icon(Icons.call_end, color: Colors.white, size: 32),
                    ),
                  ),
                  // Accept
                  GestureDetector(
                    onTap: () => _respond('accept'),
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.success),
                      child: Icon(
                        widget.callType == 'video' ? Icons.videocam : Icons.call,
                        color: Colors.white,
                        size: 32,
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
