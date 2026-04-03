import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_theme.dart';
import '../../utils/constants.dart';

class LiveViewerScreen extends StatefulWidget {
  final String streamId;
  final String title;
  final String hostName;

  const LiveViewerScreen({
    super.key,
    required this.streamId,
    required this.title,
    required this.hostName,
  });

  @override
  State<LiveViewerScreen> createState() => _LiveViewerScreenState();
}

class _LiveViewerScreenState extends State<LiveViewerScreen> {
  final _questionCtrl = TextEditingController();
  List<dynamic> _questions = [];
  List<dynamic> _gifts = [];
  int _viewerCount = 0;
  String? _agoraToken;
  String? _agoraAppId;

  @override
  void initState() {
    super.initState();
    _joinStream();
    _loadGifts();
  }

  Future<Map<String, String>> get _headers async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${prefs.getString('access_token')}',
    };
  }

  Future<void> _joinStream() async {
    final h = await _headers;
    final resp = await http.post(
      Uri.parse('${ApiConstants.commBase}/live/${widget.streamId}/join'),
      headers: h,
    );
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      setState(() {
        _agoraToken = data['agora_token'];
        _agoraAppId = data['agora_app_id'];
      });
      // TODO: Init Agora RTC as subscriber (audience) with _agoraAppId, _agoraToken
    }
    _loadQuestions();
  }

  Future<void> _loadGifts() async {
    final resp = await http.get(Uri.parse(ApiConstants.gifts));
    if (resp.statusCode == 200) {
      setState(() => _gifts = jsonDecode(resp.body));
    }
  }

  Future<void> _loadQuestions() async {
    final h = await _headers;
    final resp = await http.get(
      Uri.parse('${ApiConstants.commBase}/live/${widget.streamId}/questions'),
      headers: h,
    );
    if (resp.statusCode == 200) {
      setState(() => _questions = jsonDecode(resp.body));
    }
  }

  Future<void> _sendQuestion() async {
    if (_questionCtrl.text.trim().isEmpty) return;
    final h = await _headers;
    await http.post(
      Uri.parse('${ApiConstants.commBase}/live/${widget.streamId}/question'),
      headers: h,
      body: jsonEncode({'question': _questionCtrl.text.trim()}),
    );
    _questionCtrl.clear();
    _loadQuestions();
  }

  Future<void> _sendGift(String giftId) async {
    final h = await _headers;
    final resp = await http.post(
      Uri.parse('${ApiConstants.commBase}/live/${widget.streamId}/gift'),
      headers: h,
      body: jsonEncode({'gift_pricing_id': giftId}),
    );
    final data = jsonDecode(resp.body);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resp.statusCode == 200
              ? 'Sent ${data['gift_icon']} ${data['gift_name']}!'
              : data['detail'] ?? 'Failed'),
          backgroundColor: resp.statusCode == 200 ? AppColors.success : AppColors.error,
        ),
      );
    }
  }

  Future<void> _leaveStream() async {
    final h = await _headers;
    await http.post(
      Uri.parse('${ApiConstants.commBase}/live/${widget.streamId}/leave'),
      headers: h,
    );
    // TODO: Leave Agora channel
    if (mounted) Navigator.pop(context);
  }

  void _showGiftSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Send a Gift', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _gifts.map((g) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(ctx);
                    _sendGift(g['id']);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Center(child: Text(g['icon'] ?? '', style: const TextStyle(fontSize: 28))),
                      ),
                      const SizedBox(height: 4),
                      Text(g['name'] ?? '', style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                      Text('\u20b9${(g['price'] as num).toInt()}', style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w600)),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _questionCtrl.dispose();
    super.dispose();
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
                  IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary), onPressed: _leaveStream),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.hostName, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 15)),
                        Text(widget.title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12), overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
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
                  const SizedBox(width: 8),
                  const Icon(Icons.people, color: AppColors.textSecondary, size: 18),
                  const SizedBox(width: 4),
                  Text('$_viewerCount', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                ],
              ),
            ),

            // Video area placeholder (Agora renders here)
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.black,
                child: const Center(child: Text('🔮 Live Stream', style: TextStyle(color: Colors.white54, fontSize: 18))),
              ),
            ),

            // Questions feed
            Expanded(
              flex: 2,
              child: Container(
                color: AppColors.surface,
                child: _questions.isEmpty
                    ? const Center(child: Text('No questions yet', style: TextStyle(color: AppColors.textSecondary)))
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        reverse: true,
                        itemCount: _questions.length,
                        itemBuilder: (_, i) {
                          final q = _questions[i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${q['display_name'] ?? 'User'}: ', style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
                                Expanded(child: Text(q['question'] ?? '', style: const TextStyle(color: AppColors.textPrimary, fontSize: 13))),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),

            // Bottom input
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: const BoxDecoration(color: AppColors.card, border: Border(top: BorderSide(color: AppColors.border))),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _questionCtrl,
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Ask a question...',
                        hintStyle: const TextStyle(color: AppColors.textSecondary),
                        filled: true,
                        fillColor: AppColors.surface,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                      ),
                      onSubmitted: (_) => _sendQuestion(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _sendQuestion,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
                      child: const Icon(Icons.send, color: Colors.black, size: 18),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _showGiftSheet,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.accent.withOpacity(0.2), border: Border.all(color: AppColors.accent)),
                      child: const Icon(Icons.card_giftcard, color: AppColors.accent, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
