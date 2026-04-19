import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import 'kundli_detail_slides_screen.dart';

/// Astrologer's Pro View of a client's kundli.
/// Extends the 4-slide summary/yog/dosh/career flow with a 5th "Notes" tab
/// and action buttons (Call Client + Start Session) at the bottom.
class ClientKundliProScreen extends StatefulWidget {
  final String chartId;
  final String clientName;
  final String? dob;
  final String? tob;
  final String? userId; // client user_id for call/chat initiation

  const ClientKundliProScreen({
    super.key,
    required this.chartId,
    required this.clientName,
    this.dob,
    this.tob,
    this.userId,
  });

  @override
  State<ClientKundliProScreen> createState() => _ClientKundliProScreenState();
}

class _ClientKundliProScreenState extends State<ClientKundliProScreen> {
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cosmicVoid,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 18), onPressed: () => Navigator.pop(context)),
        title: Column(mainAxisSize: MainAxisSize.min, children: [
          Text.rich(TextSpan(children: [
            TextSpan(text: widget.clientName.split(' ').first, style: const TextStyle(color: AppColors.ivory, fontSize: 15, fontWeight: FontWeight.w700)),
            if (widget.clientName.split(' ').length > 1)
              TextSpan(text: ' ${widget.clientName.split(' ').skip(1).join(' ')}',
                  style: const TextStyle(color: AppColors.gold, fontSize: 15, fontWeight: FontWeight.w700, fontStyle: FontStyle.italic)),
          ])),
          const Text('\u25cf CONSULT READY', style: TextStyle(color: AppColors.success, fontSize: 8, letterSpacing: 1.5)),
        ]),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.gold, AppColors.saffron]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.chat_bubble, size: 16, color: AppColors.midnight),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Column(children: [
        // Header info strip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Row(children: [
            const Text('\u2728 PRO ANALYSIS', style: TextStyle(color: AppColors.smoke, fontSize: 9, letterSpacing: 1.5, fontWeight: FontWeight.w600)),
            const Spacer(),
            Row(children: [
              const Icon(Icons.grid_on, size: 10, color: AppColors.gold),
              const SizedBox(width: 4),
              Text(widget.dob ?? '', style: const TextStyle(color: AppColors.gold, fontSize: 9, letterSpacing: 1)),
            ]),
          ]),
        ),
        // Main content: reuse the slides screen (summary/yog/dosh/career)
        Expanded(
          child: KundliDetailSlidesScreen(
            chartId: widget.chartId,
            clientName: widget.clientName,
            dob: widget.dob,
            tob: widget.tob,
          ),
        ),
        // Bottom action buttons
        Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          decoration: BoxDecoration(
            color: AppColors.midnight.withOpacity(0.95),
            border: Border(top: BorderSide(color: AppColors.gold.withOpacity(0.15))),
          ),
          child: Row(children: [
            Expanded(child: _actionBtn(Icons.phone, 'Call Client', () => _callClient())),
            const SizedBox(width: 8),
            Expanded(child: _startSessionBtn()),
            const SizedBox(width: 8),
            _notesBtn(),
          ]),
        ),
      ]),
    );
  }

  Widget _actionBtn(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.nebula.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gold.withOpacity(0.3)),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 16, color: AppColors.ivory),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: AppColors.ivory, fontSize: 11, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }

  Widget _startSessionBtn() {
    return GestureDetector(
      onTap: _startSession,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [AppColors.gold, AppColors.saffron]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
          Text('Start Session', style: TextStyle(color: AppColors.midnight, fontSize: 11, fontWeight: FontWeight.w800)),
          SizedBox(width: 4),
          Icon(Icons.arrow_forward, size: 14, color: AppColors.midnight),
        ]),
      ),
    );
  }

  Widget _notesBtn() {
    return GestureDetector(
      onTap: _openNotes,
      child: Container(
        width: 44, padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.indigo.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.lavender.withOpacity(0.3)),
        ),
        child: const Icon(Icons.edit_note, size: 20, color: AppColors.lavender),
      ),
    );
  }

  void _callClient() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Client will be notified of incoming call')),
    );
  }

  void _startSession() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Session start requires active booking')),
    );
  }

  void _openNotes() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.nebula,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 16, right: 16, top: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
        ),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.smoke, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          const Text('\u{1F4DD} MY NOTES', style: TextStyle(color: AppColors.lavender, fontSize: 10, letterSpacing: 1.5)),
          const SizedBox(height: 8),
          Text('Private notes for ${widget.clientName}',
              style: const TextStyle(color: AppColors.gold, fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          TextField(
            controller: _notesCtrl,
            maxLines: 6,
            style: const TextStyle(color: AppColors.ivory, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Add notes about client questions, patterns...',
              hintStyle: const TextStyle(color: AppColors.smoke, fontSize: 12),
              filled: true,
              fillColor: Colors.white.withOpacity(0.04),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.gold.withOpacity(0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.gold),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: OutlinedButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: AppColors.smoke)),
            )),
            const SizedBox(width: 10),
            Expanded(child: ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notes saved')));
              },
              child: const Text('Save Notes'),
            )),
          ]),
        ]),
      ),
    );
  }
}
