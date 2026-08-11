import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../../widgets/desktop_center.dart';

const _kCategories = ['Notifications', 'Calls', 'Chat', 'Payments', 'Withdrawal', 'Account', 'Other'];

Color _statusColor(String s) {
  switch (s) {
    case 'pending': return AppColors.warning;
    case 'in_progress': return AppColors.gold;
    case 'completed': return AppColors.success;
    case 'closed': return AppColors.smoke;
    default: return AppColors.smoke;
  }
}

String _statusLabel(String s) => {
  'pending': 'Pending', 'in_progress': 'In progress',
  'completed': 'Completed', 'closed': 'Closed',
}[s] ?? s;

/// My tickets — list with statuses, plus a button to raise a new one.
class MyTicketsScreen extends StatefulWidget {
  const MyTicketsScreen({super.key});
  @override
  State<MyTicketsScreen> createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends State<MyTicketsScreen> {
  final _api = ApiService();
  List<dynamic> _tickets = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    final t = await _api.getMyTickets();
    if (!mounted) return;
    setState(() { _tickets = t; _loading = false; });
  }

  Future<void> _raise() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const RaiseTicketScreen()),
    );
    if (created == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.midnight,
      appBar: AppBar(
        backgroundColor: AppColors.midnight,
        title: const Text('My Tickets', style: TextStyle(color: AppColors.ivory, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: AppColors.ivory),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.midnight,
        onPressed: _raise,
        icon: const Icon(Icons.add),
        label: const Text('Raise Ticket'),
      ),
      body: DesktopCenter(
        maxWidth: 900,
        child: RefreshIndicator(
        onRefresh: _load,
        color: AppColors.gold,
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
            : _tickets.isEmpty
                ? ListView(children: const [
                    SizedBox(height: 120),
                    Icon(Icons.support_agent, color: AppColors.smoke, size: 48),
                    SizedBox(height: 12),
                    Center(child: Text('No tickets yet', style: TextStyle(color: AppColors.smoke))),
                    Center(child: Text('Tap "Raise Ticket" to get help', style: TextStyle(color: AppColors.smoke, fontSize: 12))),
                  ])
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _tickets.length,
                    itemBuilder: (_, i) => _ticketCard(_tickets[i]),
                  ),
      )),
    );
  }

  Widget _ticketCard(dynamic t) {
    final status = (t['status'] ?? 'pending').toString();
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(builder: (_) => TicketDetailScreen(ticketId: t['id'])));
        _load();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.gold.withOpacity(0.12)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(t['subject'] ?? '', style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: _statusColor(status).withOpacity(0.18), borderRadius: BorderRadius.circular(10)),
              child: Text(_statusLabel(status), style: TextStyle(color: _statusColor(status), fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ]),
          const SizedBox(height: 6),
          Text(t['description'] ?? '', style: const TextStyle(color: AppColors.smoke, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Row(children: [
            if ((t['category'] ?? '').toString().isNotEmpty)
              Text(t['category'], style: const TextStyle(color: AppColors.gold, fontSize: 11)),
            const Spacer(),
            Text((t['created_at'] ?? '').toString().split('.').first, style: const TextStyle(color: AppColors.smoke, fontSize: 10)),
          ]),
        ]),
      ),
    );
  }
}

/// Raise a new ticket: subject, category, description, up to 2 images.
class RaiseTicketScreen extends StatefulWidget {
  const RaiseTicketScreen({super.key});
  @override
  State<RaiseTicketScreen> createState() => _RaiseTicketScreenState();
}

class _RaiseTicketScreenState extends State<RaiseTicketScreen> {
  final _api = ApiService();
  final _subject = TextEditingController();
  final _desc = TextEditingController();
  String _category = _kCategories.first;
  final List<_PickedImage> _images = [];
  bool _submitting = false;

  @override
  void dispose() { _subject.dispose(); _desc.dispose(); super.dispose(); }

  Future<void> _pickImage() async {
    if (_images.length >= 2) return;
    final res = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
    if (res == null || res.files.isEmpty) return;
    final f = res.files.first;
    if (f.bytes == null) return;
    setState(() => _images.add(_PickedImage(f.bytes!, f.name)));
  }

  Future<void> _submit() async {
    if (_subject.text.trim().length < 2 || _desc.text.trim().length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a subject and description')));
      return;
    }
    setState(() => _submitting = true);
    // Upload images first.
    final urls = <String>[];
    for (final img in _images) {
      final url = await _api.uploadSupportImage(img.bytes, img.name);
      if (url != null) urls.add(url);
    }
    final resp = await _api.createSupportTicket(
      subject: _subject.text.trim(), description: _desc.text.trim(),
      category: _category, images: urls,
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    if (resp['statusCode'] == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ticket submitted'), backgroundColor: AppColors.success));
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resp['detail'] ?? 'Failed to submit'), backgroundColor: AppColors.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.midnight,
      appBar: AppBar(
        backgroundColor: AppColors.midnight,
        title: const Text('Raise a Ticket', style: TextStyle(color: AppColors.ivory, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: AppColors.ivory),
      ),
      body: DesktopCenter(
        maxWidth: 900,
        child: ListView(padding: const EdgeInsets.all(16), children: [
        _label('Subject'),
        _input(_subject, 'Brief summary of the issue'),
        const SizedBox(height: 14),
        _label('Category'),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.gold.withOpacity(0.15))),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _category, isExpanded: true, dropdownColor: AppColors.nebula,
              style: const TextStyle(color: AppColors.ivory),
              items: _kCategories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _category = v ?? _category),
            ),
          ),
        ),
        const SizedBox(height: 14),
        _label('Description'),
        _input(_desc, 'Describe what happened…', maxLines: 5),
        const SizedBox(height: 14),
        _label('Attachments (max 2 images)'),
        Row(children: [
          ..._images.asMap().entries.map((e) => Container(
            margin: const EdgeInsets.only(right: 8),
            width: 72, height: 72,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.gold.withOpacity(0.2))),
            child: Stack(fit: StackFit.expand, children: [
              ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.memory(e.value.bytes, fit: BoxFit.cover)),
              Positioned(top: 2, right: 2, child: GestureDetector(
                onTap: () => setState(() => _images.removeAt(e.key)),
                child: Container(decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle), child: const Icon(Icons.close, color: Colors.white, size: 16)),
              )),
            ]),
          )),
          if (_images.length < 2)
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 72, height: 72,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.gold.withOpacity(0.2))),
                child: const Icon(Icons.add_a_photo, color: AppColors.gold),
              ),
            ),
        ]),
        const SizedBox(height: 24),
        SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: _submitting ? null : _submit,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.midnight),
            child: _submitting
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.midnight))
                : const Text('Submit Ticket', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ])),
    );
  }

  Widget _label(String s) => Padding(padding: const EdgeInsets.only(bottom: 6, left: 2), child: Text(s, style: const TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.w700)));
  Widget _input(TextEditingController c, String hint, {int maxLines = 1}) => TextField(
    controller: c, maxLines: maxLines, style: const TextStyle(color: AppColors.ivory),
    decoration: InputDecoration(
      hintText: hint, hintStyle: const TextStyle(color: AppColors.smoke),
      filled: true, fillColor: Colors.white.withOpacity(0.05),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    ),
  );
}

class _PickedImage {
  final Uint8List bytes;
  final String name;
  _PickedImage(this.bytes, this.name);
}

/// Ticket detail — description, attachments, thread, and a reply box.
class TicketDetailScreen extends StatefulWidget {
  final String ticketId;
  const TicketDetailScreen({super.key, required this.ticketId});
  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  final _api = ApiService();
  final _reply = TextEditingController();
  Map<String, dynamic>? _ticket;
  bool _loading = true;
  bool _sending = false;

  @override
  void initState() { super.initState(); _load(); }
  @override
  void dispose() { _reply.dispose(); super.dispose(); }

  Future<void> _load() async {
    final t = await _api.getTicketDetail(widget.ticketId);
    if (!mounted) return;
    setState(() { _ticket = t; _loading = false; });
  }

  Future<void> _send() async {
    final msg = _reply.text.trim();
    if (msg.isEmpty || _sending) return;
    setState(() => _sending = true);
    await _api.replyToTicket(widget.ticketId, msg);
    _reply.clear();
    await _load();
    if (mounted) setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    final t = _ticket;
    final status = (t?['status'] ?? 'pending').toString();
    final replies = (t?['replies'] as List?) ?? [];
    return Scaffold(
      backgroundColor: AppColors.midnight,
      appBar: AppBar(
        backgroundColor: AppColors.midnight,
        iconTheme: const IconThemeData(color: AppColors.ivory),
        title: Text(t?['subject'] ?? 'Ticket', style: const TextStyle(color: AppColors.ivory, fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          if (t != null) Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: _statusColor(status).withOpacity(0.18), borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.center,
            child: Text(_statusLabel(status), style: TextStyle(color: _statusColor(status), fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : t == null
              ? const Center(child: Text('Ticket not found', style: TextStyle(color: AppColors.smoke)))
              : Column(children: [
                  Expanded(child: ListView(padding: const EdgeInsets.all(16), children: [
                    _bubble(true, 'You', t['description'] ?? ''),
                    if ((t['images'] as List?)?.isNotEmpty ?? false)
                      Wrap(spacing: 8, runSpacing: 8, children: (t['images'] as List).map((u) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(ApiService.resolveMediaUrl(u.toString()), headers: _api.mediaHeadersFor(u.toString()), width: 90, height: 90, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const SizedBox()),
                      )).toList()),
                    const SizedBox(height: 8),
                    ...replies.map((r) => _bubble(r['author'] == 'user', r['author'] == 'user' ? 'You' : 'Support', r['message'] ?? '')),
                  ])),
                  if (status != 'closed')
                    Container(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                      color: AppColors.nebula.withOpacity(0.4),
                      child: Row(children: [
                        Expanded(child: TextField(
                          controller: _reply, style: const TextStyle(color: AppColors.ivory),
                          decoration: InputDecoration(
                            hintText: 'Write a reply…', hintStyle: const TextStyle(color: AppColors.smoke),
                            filled: true, fillColor: Colors.white.withOpacity(0.06),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                        )),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _sending ? null : _send,
                          child: Container(width: 44, height: 44, decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
                            child: _sending ? const Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.midnight)) : const Icon(Icons.send, color: AppColors.midnight, size: 20)),
                        ),
                      ]),
                    ),
                ]),
    );
  }

  Widget _bubble(bool mine, String who, String text) {
    return Align(
      alignment: mine ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        decoration: BoxDecoration(
          color: mine ? Colors.white.withOpacity(0.06) : AppColors.gold.withOpacity(0.16),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: (mine ? Colors.white : AppColors.gold).withOpacity(0.12)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(who, style: TextStyle(color: mine ? AppColors.smoke : AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700)),
          const SizedBox(height: 3),
          Text(text, style: const TextStyle(color: AppColors.ivory, fontSize: 13, height: 1.4)),
        ]),
      ),
    );
  }
}
