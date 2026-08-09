import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';

/// Astrologer self-serve discount offers. Create a first-time / consultation
/// coupon that shows on your profile and auto-applies to chat/call/video
/// billing. New/edited coupons go to admin review before going live.
class MyCouponsScreen extends StatefulWidget {
  const MyCouponsScreen({super.key});

  @override
  State<MyCouponsScreen> createState() => _MyCouponsScreenState();
}

class _MyCouponsScreenState extends State<MyCouponsScreen> {
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
    final items = await _api.getMyCoupons();
    if (!mounted) return;
    setState(() { _items = items; _loading = false; });
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'active': return AppColors.success;
      case 'pending_review': return AppColors.gold;
      case 'rejected': return AppColors.error;
      default: return AppColors.textSecondary;
    }
  }

  String _discount(Map c) {
    final t = c['discount_type']?.toString();
    final v = (c['discount_value'] as num?)?.toDouble() ?? 0;
    if (t == 'flat') return '₹${v.toStringAsFixed(0)} off';
    return '${v.toStringAsFixed(0)}% off';
  }

  Future<void> _openCreate() async {
    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => const _CreateCouponSheet(),
    );
    if (created == true) _load();
  }

  Future<void> _delete(String id) async {
    final ok = await _api.deleteCoupon(id);
    if (!mounted) return;
    if (ok) { _load(); } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not delete'), backgroundColor: AppColors.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('My Offers', style: TextStyle(color: AppColors.textPrimary)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.gold, foregroundColor: AppColors.background,
        onPressed: _openCreate,
        icon: const Icon(Icons.add), label: const Text('New offer'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : RefreshIndicator(
              color: AppColors.gold,
              onRefresh: _load,
              child: _items.isEmpty
                  ? ListView(children: const [
                      SizedBox(height: 120),
                      Icon(Icons.local_offer_outlined, color: AppColors.textSecondary, size: 48),
                      SizedBox(height: 12),
                      Center(child: Text('No offers yet.\nCreate a first-time discount to attract new clients.',
                          textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary))),
                    ])
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final c = _items[i] as Map;
                        final status = c['status']?.toString() ?? '';
                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.gold.withOpacity(0.18)),
                          ),
                          child: Row(children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                              child: Text(_discount(c), style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w800)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text((c['title'] ?? 'Offer').toString(),
                                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 3),
                              Row(children: [
                                if ((c['code'] ?? '').toString().isNotEmpty) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: AppColors.gold.withOpacity(0.4)),
                                    ),
                                    child: Text(c['code'].toString(),
                                        style: const TextStyle(color: AppColors.gold, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                                  ),
                                  const SizedBox(width: 6),
                                ],
                                Text(c['first_time_only'] == true ? 'First-time' : 'All clients',
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                              ]),
                              const SizedBox(height: 2),
                              Text('${c['redeemed_count'] ?? 0} used',
                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                            ])),
                            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(color: _statusColor(status).withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                                child: Text(status.replaceAll('_', ' '), style: TextStyle(color: _statusColor(status), fontSize: 10, fontWeight: FontWeight.w700)),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                                onPressed: () => _delete(c['id'] as String),
                              ),
                            ]),
                          ]),
                        );
                      },
                    ),
            ),
    );
  }
}

class _CreateCouponSheet extends StatefulWidget {
  const _CreateCouponSheet();
  @override
  State<_CreateCouponSheet> createState() => _CreateCouponSheetState();
}

class _CreateCouponSheetState extends State<_CreateCouponSheet> {
  final _title = TextEditingController(text: 'Get a discount on your consultation');
  final _value = TextEditingController(text: '20');
  final _code = TextEditingController();
  String _discountType = 'percent';
  bool _firstTimeOnly = true;   // true → first_consult ; false → consultation (all clients)
  bool _saving = false;

  @override
  void dispose() { _title.dispose(); _value.dispose(); _code.dispose(); super.dispose(); }

  Future<void> _save() async {
    final v = double.tryParse(_value.text.trim()) ?? 0;
    if (v <= 0) return;
    setState(() => _saving = true);
    final resp = await ApiService().createCoupon(
      kind: _firstTimeOnly ? 'first_consult' : 'consultation',
      discountType: _discountType, discountValue: v,
      code: _code.text.trim().isEmpty ? null : _code.text.trim().toUpperCase(),
      title: _title.text.trim().isEmpty ? null : _title.text.trim(),
    );
    if (!mounted) return;
    final ok = resp['statusCode'] == 200 || resp['statusCode'] == 201;
    if (ok) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Offer submitted for review'), backgroundColor: AppColors.success));
    } else {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resp['detail']?.toString() ?? 'Failed'), backgroundColor: AppColors.error));
    }
  }

  Widget _audienceChip(String label, bool firstTime) {
    final sel = _firstTimeOnly == firstTime;
    return GestureDetector(
      onTap: () => setState(() => _firstTimeOnly = firstTime),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: sel ? AppColors.gold.withOpacity(0.16) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: sel ? AppColors.gold : AppColors.border),
        ),
        child: Text(label,
            style: TextStyle(color: sel ? AppColors.gold : AppColors.textSecondary,
                fontSize: 12, fontWeight: sel ? FontWeight.w700 : FontWeight.w500)),
      ),
    );
  }

  Widget _field(TextEditingController c, String label, {bool number = false}) => TextField(
        controller: c,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.textSecondary),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.border)),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.gold)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('New offer', style: TextStyle(color: AppColors.textPrimary, fontSize: 17, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        const Text('Shown on your profile and applied to chat / call / video billing. Goes to admin review before going live.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        const SizedBox(height: 16),
        _field(_title, 'Offer title (optional)'),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: DropdownButtonFormField<String>(
            value: _discountType,
            dropdownColor: AppColors.card,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(labelText: 'Type', labelStyle: TextStyle(color: AppColors.textSecondary),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.border))),
            items: const [
              DropdownMenuItem(value: 'percent', child: Text('Percentage %')),
              DropdownMenuItem(value: 'flat', child: Text('Flat ₹')),
            ],
            onChanged: (v) => setState(() => _discountType = v ?? 'percent'),
          )),
          const SizedBox(width: 12),
          Expanded(child: _field(_value, _discountType == 'percent' ? 'Value %' : 'Value ₹', number: true)),
        ]),
        const SizedBox(height: 12),
        _field(_code, 'Coupon code (optional — leave blank to auto-apply)'),
        const SizedBox(height: 6),
        const Text('With a code, clients enter/copy it to apply. Without a code, the offer applies automatically at billing.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
        const SizedBox(height: 14),
        // Audience: first-time clients only vs all clients.
        const Text('Who can use it', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        const SizedBox(height: 6),
        Row(children: [
          Expanded(child: _audienceChip('First-time clients', true)),
          const SizedBox(width: 8),
          Expanded(child: _audienceChip('All clients', false)),
        ]),
        const SizedBox(height: 18),
        SizedBox(width: double.infinity, height: 48, child: ElevatedButton(
          onPressed: _saving ? null : _save,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.background),
          child: _saving
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.background))
              : const Text('Submit for review', style: TextStyle(fontWeight: FontWeight.w800)),
        )),
      ]),
    );
  }
}
