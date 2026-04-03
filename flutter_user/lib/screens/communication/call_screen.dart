import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_theme.dart';
import '../../utils/constants.dart';

class CallScreen extends StatefulWidget {
  final String callId;
  final String channelName;
  final String agoraToken;
  final String agoraAppId;
  final String callType; // voice | video
  final String astrologerName;
  final double ratePerMin;

  const CallScreen({
    super.key,
    required this.callId,
    required this.channelName,
    required this.agoraToken,
    required this.agoraAppId,
    required this.callType,
    required this.astrologerName,
    required this.ratePerMin,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  String _status = 'ringing';
  int _seconds = 0;
  Timer? _timer;
  bool _isMuted = false;
  bool _isSpeaker = false;

  @override
  void initState() {
    super.initState();
    // TODO: Initialize Agora RTC Engine with widget.agoraAppId and widget.agoraToken
    // Join channel: widget.channelName
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });
  }

  String get _formattedTime {
    final min = _seconds ~/ 60;
    final sec = _seconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  double get _currentCost => (_seconds / 60).ceil() * widget.ratePerMin;

  Future<void> _endCall() async {
    _timer?.cancel();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    await http.post(
      Uri.parse('${ApiConstants.commBase}/call/${widget.callId}/action'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode({'action': 'end'}),
    );
    // TODO: Leave Agora channel
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    // TODO: Destroy Agora engine
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
            // Astrologer avatar
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.card,
                border: Border.all(color: AppColors.primary.withOpacity(0.5), width: 3),
              ),
              child: const Center(child: Text('🔮', style: TextStyle(fontSize: 48))),
            ),
            const SizedBox(height: 20),
            Text(widget.astrologerName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(
              widget.callType == 'video' ? 'Video Call' : 'Voice Call',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 16),

            // Timer & Cost
            if (_status == 'active') ...[
              Text(_formattedTime, style: const TextStyle(color: AppColors.primary, fontSize: 36, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
              const SizedBox(height: 4),
              Text('\u20b9${_currentCost.toStringAsFixed(0)} (\u20b9${widget.ratePerMin.toInt()}/min)',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            ] else ...[
              Text(_status == 'ringing' ? 'Ringing...' : _status,
                  style: TextStyle(color: AppColors.primary, fontSize: 18)),
              const SizedBox(height: 8),
              const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)),
            ],

            const Spacer(flex: 3),

            // Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _controlBtn(
                    icon: _isMuted ? Icons.mic_off : Icons.mic,
                    label: _isMuted ? 'Unmute' : 'Mute',
                    color: AppColors.surface,
                    onTap: () => setState(() => _isMuted = !_isMuted),
                  ),
                  // End call
                  GestureDetector(
                    onTap: _endCall,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.error),
                      child: const Icon(Icons.call_end, color: Colors.white, size: 32),
                    ),
                  ),
                  _controlBtn(
                    icon: _isSpeaker ? Icons.volume_up : Icons.volume_down,
                    label: 'Speaker',
                    color: AppColors.surface,
                    onTap: () => setState(() => _isSpeaker = !_isSpeaker),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _controlBtn({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color, border: Border.all(color: AppColors.border)),
            child: Icon(icon, color: AppColors.textPrimary, size: 24),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}
