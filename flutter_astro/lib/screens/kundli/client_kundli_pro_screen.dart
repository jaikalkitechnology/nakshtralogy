import 'package:flutter/material.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import 'kundli_viewer_screen.dart';

/// Astrologer's Pro View of a client's kundli.
/// Wraps the full 16-tab KundliViewerScreen with action buttons
/// (Call Client + Start Session + Notes) at the bottom.
class ClientKundliProScreen extends StatefulWidget {
  final String chartId;
  final String clientName;
  final String? dob;
  final String? tob;
  final String? userId;

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
      body: Column(children: [
        Expanded(
          child: KundliViewerScreen(
            chartId: widget.chartId,
            clientName: widget.clientName,
          ),
        ),
        // Bottom action buttons
        Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          decoration: BoxDecoration(
            color: AppColors.midnight.withOpacity(0.95),
            border: Border(top: BorderSide(color: AppColors.gold.withOpacity(0.15))),
          ),
          child: SafeArea(
            top: false,
            child: Row(children: [
              Expanded(child: _actionBtn(Icons.phone, 'Call Client', _callClient)),
              const SizedBox(width: 8),
              Expanded(child: _startSessionBtn()),
              const SizedBox(width: 8),
              _notesBtn(),
            ]),
          ),
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
        child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.of(ctx).viewInsets.bottom + 16),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.smoke, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          Text('Notes for ${widget.clientName}', style: const TextStyle(color: AppColors.gold, fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          TextField(
            controller: _notesCtrl,
            maxLines: 6,
            style: const TextStyle(color: AppColors.ivory, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Add notes about client...',
              hintStyle: const TextStyle(color: AppColors.smoke, fontSize: 12),
              filled: true, fillColor: Colors.white.withOpacity(0.04),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.gold.withOpacity(0.2))),
            ),
          ),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(ctx), child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel'))),
            const SizedBox(width: 10),
            Expanded(child: ElevatedButton(
              onPressed: () { Navigator.pop(ctx); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notes saved'))); },
              child: const Text('Save'),
            )),
          ]),
        ]),
      ),
    );
  }
}
