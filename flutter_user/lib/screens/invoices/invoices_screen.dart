import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../../utils/money.dart';

/// User invoices — receipts for products and consultations. Tap to open the
/// printable invoice in the browser (save / print-to-PDF via a signed link).
class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  final _api = ApiService();
  List<dynamic> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final items = await _api.getMyInvoices();
    if (!mounted) return;
    setState(() { _items = items; _loading = false; });
  }

  Future<void> _open(Map inv) async {
    final token = inv['download_token']?.toString();
    if (token == null || token.isEmpty) return;
    final url = _api.invoiceViewUrl(inv['id'].toString(), token);
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the invoice'), backgroundColor: AppColors.error));
      }
    }
  }

  IconData _icon(String kind) =>
      kind == 'consultation' ? Icons.forum_outlined : Icons.receipt_long_outlined;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Invoices', style: TextStyle(color: AppColors.textPrimary)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _load,
              child: _items.isEmpty
                  ? ListView(children: const [
                      SizedBox(height: 140),
                      Icon(Icons.receipt_long_outlined, color: AppColors.textSecondary, size: 48),
                      SizedBox(height: 12),
                      Center(child: Text('No invoices yet.', style: TextStyle(color: AppColors.textSecondary))),
                    ])
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final inv = _items[i] as Map;
                        final cur = (inv['currency'] ?? 'INR').toString();
                        final total = (inv['total_amount'] as num?)?.toDouble() ?? 0;
                        final disc = (inv['discount_amount'] as num?)?.toDouble() ?? 0;
                        final li = (inv['line_items'] as List?) ?? const [];
                        final label = li.isNotEmpty ? (li.first['label']?.toString() ?? '') : (inv['kind']?.toString() ?? '');
                        final date = inv['issued_at'] != null
                            ? DateTime.tryParse(inv['issued_at'].toString())?.toLocal()
                            : null;
                        return InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () => _open(inv),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(children: [
                              Icon(_icon(inv['kind']?.toString() ?? ''), color: AppColors.primary, size: 22),
                              const SizedBox(width: 12),
                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700),
                                    maxLines: 1, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 2),
                                Text('${inv['invoice_no']}${date != null ? ' · ${date.day}/${date.month}/${date.year}' : ''}',
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                                if (disc > 0) Text('Coupon −${Money.format(disc, currency: cur)}',
                                    style: const TextStyle(color: AppColors.success, fontSize: 11)),
                              ])),
                              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                Text(Money.format(total, currency: cur),
                                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w800)),
                                const SizedBox(height: 4),
                                const Icon(Icons.download_rounded, color: AppColors.primary, size: 18),
                              ]),
                            ]),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
