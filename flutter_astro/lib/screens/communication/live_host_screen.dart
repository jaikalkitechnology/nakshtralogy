import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_theme.dart';
import '../../utils/constants.dart';

class LiveHostScreen extends StatefulWidget {
  final String streamId;
  final String channelName;
  final String agoraToken;
  final String agoraAppId;
  final String title;

  const LiveHostScreen({
    super.key,
    required this.streamId,
    required this.channelName,
    required this.agoraToken,
    required this.agoraAppId,
    required this.title,
  });

  @override
  State<LiveHostScreen> createState() => _LiveHostScreenState();
}

class _LiveHostScreenState extends State<LiveHostScreen> {
  List<dynamic> _questions = [];
  int _viewerCount = 0;
  int _peakViewers = 0;
  double _totalGifts = 0;
  bool _isLive = false;

  @override
  void initState() {
    super.initState();
    // TODO: Init Agora RTC as broadcaster with widget.agoraAppId, widget.agoraToken
    // Join channel widget.channelName
  }

  Future<Map<String, String>> get _headers async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${prefs.getString('access_token')}',
    };
  }

  Future<void> _goLive() async {
    final h = await _headers;
    final resp = await http.post(
      Uri.parse('${ApiConstants.commBase}/live/${widget.streamId}/start'),
      headers: h,
    );
    if (resp.statusCode == 200) {
      setState(() => _isLive = true);
      _pollData();
    }
  }

  Future<void> _endStream() async {
    final h = await _headers;
    await http.post(
      Uri.parse('${ApiConstants.commBase}/live/${widget.streamId}/end'),
      headers: h,
    );
    // TODO: Leave Agora channel
    if (mounted) Navigator.pop(context);
  }

  Future<void> _pollData() async {
    // Poll questions and viewers periodically
    while (_isLive && mounted) {
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) break;
      final h = await _headers;

      // questions
      final qResp = await http.get(
        Uri.parse('${ApiConstants.commBase}/live/${widget.streamId}/questions'),
        headers: h,
      );
      if (qResp.statusCode == 200) {
        setState(() => _questions = jsonDecode(qResp.body));
      }

      // viewers
      final vResp = await http.get(
        Uri.parse('${ApiConstants.commBase}/live/${widget.streamId}/viewers'),
        headers: h,
      );
      if (vResp.statusCode == 200) {
        final data = jsonDecode(vResp.body);
        setState(() {
          _viewerCount = data['total'] ?? 0;
          _peakViewers = data['peak'] ?? 0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(color: AppColors.card, border: Border(bottom: BorderSide(color: AppColors.border))),
              child: Row(
                children: [
                  if (_isLive)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.error.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, color: AppColors.error, size: 8),
                          SizedBox(width: 4),
                          Text('LIVE', style: TextStyle(color: AppColors.error, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(widget.title, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 15), overflow: TextOverflow.ellipsis)),
                  const Icon(Icons.people, color: AppColors.textSecondary, size: 18),
                  const SizedBox(width: 4),
                  Text('$_viewerCount', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  const SizedBox(width: 12),
                  Text('Peak: $_peakViewers', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                ],
              ),
            ),

            // Camera preview area (Agora local view)
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.black,
                child: Center(
                  child: _isLive
                      ? const Text('Camera Preview', style: TextStyle(color: Colors.white54, fontSize: 16))
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🔮', style: TextStyle(fontSize: 64)),
                            const SizedBox(height: 16),
                            const Text('Ready to go live?', style: TextStyle(color: Colors.white70, fontSize: 18)),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: _goLive,
                              icon: const Icon(Icons.videocam),
                              label: const Text('Go Live'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.error,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(160, 48),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),

            // Questions from viewers
            Expanded(
              flex: 2,
              child: Container(
                color: AppColors.surface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text('Questions (${_questions.length})', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 14)),
                    ),
                    Expanded(
                      child: _questions.isEmpty
                          ? const Center(child: Text('No questions yet', style: TextStyle(color: AppColors.textSecondary)))
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              itemCount: _questions.length,
                              itemBuilder: (_, i) {
                                final q = _questions[i];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.card,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: q['is_pinned'] == true ? AppColors.primary : AppColors.border),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(q['display_name'] ?? 'User', style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
                                            const SizedBox(height: 2),
                                            Text(q['question'] ?? '', style: const TextStyle(color: AppColors.textPrimary, fontSize: 13)),
                                          ],
                                        ),
                                      ),
                                      if (q['is_answered'] == true)
                                        const Icon(Icons.check_circle, color: AppColors.success, size: 16),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom controls
            if (_isLive)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(color: AppColors.card, border: Border(top: BorderSide(color: AppColors.border))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _controlBtn(Icons.flip_camera_ios, 'Flip', () {}),
                    _controlBtn(Icons.mic, 'Mute', () {}),
                    GestureDetector(
                      onTap: _endStream,
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.error),
                        child: const Icon(Icons.stop, color: Colors.white, size: 28),
                      ),
                    ),
                    _controlBtn(Icons.chat_bubble, 'Chat', () {}),
                    _controlBtn(Icons.more_horiz, 'More', () {}),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _controlBtn(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.surface, border: Border.all(color: AppColors.border)),
            child: Icon(icon, color: AppColors.textPrimary, size: 20),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
        ],
      ),
    );
  }
}
