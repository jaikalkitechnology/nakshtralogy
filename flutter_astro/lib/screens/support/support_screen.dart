import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import 'tickets_screen.dart';
import '../../widgets/desktop_center.dart';

/// Customer Support — a searchable FAQ (admin-managed) plus an entry point to
/// raise a support ticket. The FAQ content is served by the backend so admins
/// can edit it without an app update. Ticket buttons are added in the support
/// ticket feature.
class SupportScreen extends StatefulWidget {
  /// Optional widget shown above the FAQ (e.g. Raise Ticket / My Tickets buttons).
  final Widget? header;
  const SupportScreen({super.key, this.header});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _api = ApiService();
  List<dynamic> _all = [];
  bool _loading = true;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final faq = await _api.getFaq();
    if (!mounted) return;
    setState(() { _all = faq; _loading = false; });
  }

  List<dynamic> get _filtered {
    if (_query.trim().isEmpty) return _all;
    final q = _query.toLowerCase();
    return _all.where((f) =>
      (f['question'] ?? '').toString().toLowerCase().contains(q) ||
      (f['answer'] ?? '').toString().toLowerCase().contains(q) ||
      (f['category'] ?? '').toString().toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.midnight,
      appBar: AppBar(
        backgroundColor: AppColors.midnight,
        title: const Text('Customer Support', style: TextStyle(color: AppColors.ivory, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: AppColors.ivory),
      ),
      body: DesktopCenter(
        maxWidth: 900,
        child: RefreshIndicator(
        onRefresh: _load,
        color: AppColors.gold,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (widget.header != null) ...[widget.header!, const SizedBox(height: 16)],
            // Contact / tickets
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.gold.withOpacity(0.15), AppColors.gold.withOpacity(0.05)]),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.gold.withOpacity(0.2)),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Still need help?', style: TextStyle(color: AppColors.ivory, fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                const Text('Raise a ticket and our team will get back to you.', style: TextStyle(color: AppColors.smoke, fontSize: 12)),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RaiseTicketScreen())),
                    icon: const Icon(Icons.add_circle_outline, size: 18),
                    label: const Text('Raise Ticket'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.midnight),
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MyTicketsScreen())),
                    icon: const Icon(Icons.list_alt, size: 18),
                    label: const Text('My Tickets'),
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.gold, side: BorderSide(color: AppColors.gold.withOpacity(0.5))),
                  )),
                ]),
              ]),
            ),
            const Text('Frequently Asked Questions',
                style: TextStyle(color: AppColors.gold, fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            TextField(
              onChanged: (v) => setState(() => _query = v),
              style: const TextStyle(color: AppColors.ivory),
              decoration: InputDecoration(
                hintText: 'Search help…',
                hintStyle: const TextStyle(color: AppColors.smoke),
                prefixIcon: const Icon(Icons.search, color: AppColors.smoke),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            if (_loading)
              const Padding(padding: EdgeInsets.all(32), child: Center(child: CircularProgressIndicator(color: AppColors.gold)))
            else if (_filtered.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Center(child: Text(
                  _all.isEmpty ? 'No FAQ available yet.' : 'No results for "$_query".',
                  style: const TextStyle(color: AppColors.smoke),
                )),
              )
            else
              ..._filtered.map(_faqTile),
          ],
        ),
      )),
    );
  }

  Widget _faqTile(dynamic f) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold.withOpacity(0.12)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: AppColors.gold,
          collapsedIconColor: AppColors.smoke,
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          title: Text(f['question'] ?? '', style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w600)),
          subtitle: (f['category'] != null && (f['category'] as String).isNotEmpty)
              ? Text(f['category'], style: const TextStyle(color: AppColors.gold, fontSize: 11))
              : null,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(f['answer'] ?? '', style: const TextStyle(color: AppColors.parchment, fontSize: 13, height: 1.5)),
            ),
          ],
        ),
      ),
    );
  }
}
