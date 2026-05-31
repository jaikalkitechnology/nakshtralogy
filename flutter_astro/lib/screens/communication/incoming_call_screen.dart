import 'dart:async';
import 'package:flutter/material.dart';
import '../../l10n/gen/app_localizations.dart';
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
  bool _expired = false;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);

    // First check if call is still valid
    _checkCallStatus();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_countdown <= 1) {
        _timer?.cancel();
        setState(() {
          _countdown = 0;
          _expired = true;
        });
        // Auto-close after showing expired message
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) Navigator.pop(context);
        });
        return;
      }
      setState(() => _countdown--);
    });
  }

  Future<void> _checkCallStatus() async {
    try {
      final resp = await _api.getCall(widget.callId);
      if (!mounted) return;
      final status = resp['status'] ?? '';
      if (status != 'ringing') {
        setState(() => _expired = true);
        _timer?.cancel();
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) Navigator.pop(context);
        });
      }
    } catch (e) {
      debugPrint('Call status check failed: $e — will retry');
      // Retry after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && !_expired && !_responding) _checkCallStatus();
      });
    }
  }

  Future<void> _respond(String action) async {
    if (_responding || _expired) return;
    _responding = true;
    _timer?.cancel();

    try {
      final resp = await _api.callAction(widget.callId, action);
      if (!mounted) return;

      if (action == 'accept') {
        if (resp['statusCode'] == 200 || resp['statusCode'] == 201) {
          // Navigate to active call screen
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
          // Call expired or error
          final detail = resp['detail'] ?? 'Call is no longer available';
          setState(() => _expired = true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(detail), backgroundColor: AppColors.error),
          );
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) Navigator.pop(context);
          });
        }
      } else {
        // Rejected
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
        );
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
            if (!_expired)
              AnimatedBuilder(
                animation: _pulseCtrl,
                builder: (_, child) {
                  final scale = 1.0 + _pulseCtrl.value * 0.1;
                  return Transform.scale(scale: scale, child: child);
                },
                child: Container(
                  width: 130, height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.card,
                    border: Border.all(color: AppColors.primary, width: 3),
                    boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 30, spreadRadius: 5)],
                  ),
                  child: const Center(child: Text('\u{1F9D1}', style: TextStyle(fontSize: 48))),
                ),
              )
            else
              Container(
                width: 130, height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.card,
                  border: Border.all(color: AppColors.error, width: 3),
                ),
                child: const Center(child: Icon(Icons.call_end, color: AppColors.error, size: 48)),
              ),
            const SizedBox(height: 24),

            if (!_expired) ...[
              Text('Incoming ${widget.callType == 'video' ? 'Video' : 'Voice'} Call',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              const SizedBox(height: 8),
              Text(widget.callerName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('\u20b9${widget.ratePerMin.toInt()}/min', style: const TextStyle(color: AppColors.primary, fontSize: 16)),
              const SizedBox(height: 16),

              // Countdown with visual ring
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: _countdown <= 10 ? AppColors.error.withOpacity(0.2) : AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _countdown <= 10 ? AppColors.error : AppColors.border),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.timer, size: 16, color: _countdown <= 10 ? AppColors.error : AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Text(
                    'Auto-decline in ${_countdown}s',
                    style: TextStyle(
                      color: _countdown <= 10 ? AppColors.error : AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: _countdown <= 10 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ]),
              ),
            ] else ...[
              const SizedBox(height: 8),
              const Text('Call Expired', style: TextStyle(color: AppColors.error, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('${widget.callerName}\'s call request has expired',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
            ],

            const Spacer(flex: 3),

            // Accept / Reject buttons
            if (!_expired)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Reject
                    Column(mainAxisSize: MainAxisSize.min, children: [
                      GestureDetector(
                        onTap: _responding ? null : () => _respond('reject'),
                        child: Container(
                          width: 72, height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, color: AppColors.error,
                            boxShadow: [BoxShadow(color: AppColors.error.withOpacity(0.3), blurRadius: 12)],
                          ),
                          child: const Icon(Icons.call_end, color: Colors.white, size: 32),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('Decline', style: TextStyle(color: AppColors.error, fontSize: 12)),
                    ]),
                    // Accept
                    Column(mainAxisSize: MainAxisSize.min, children: [
                      GestureDetector(
                        onTap: _responding ? null : () => _respond('accept'),
                        child: Container(
                          width: 72, height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, color: AppColors.success,
                            boxShadow: [BoxShadow(color: AppColors.success.withOpacity(0.3), blurRadius: 12)],
                          ),
                          child: Icon(
                            widget.callType == 'video' ? Icons.videocam : Icons.call,
                            color: Colors.white, size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('Accept', style: TextStyle(color: AppColors.success, fontSize: 12)),
                    ]),
                  ],
                ),
              )
            else
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(minimumSize: const Size(200, 48)),
                child: Text(AppLocalizations.of(context)?.ok ?? 'Close'),
              ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
