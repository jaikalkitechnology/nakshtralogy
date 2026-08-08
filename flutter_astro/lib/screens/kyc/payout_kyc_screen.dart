import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../../utils/astro_labels.dart';

/// Payout & tax KYC — captures the PAN/GST + bank details an astrologer needs
/// before withdrawing. Ask ONLY a PAN or GST number, the name as per PAN, the
/// PAN doc, and bank details + a proof (cancelled cheque / passbook /
/// statement). 10% TDS is deducted against the PAN at withdrawal time.
///
/// Uploads use bytes (web + mobile safe) via the existing /me/kyc/upload
/// endpoint, and the resulting media URLs are saved on the astrologer profile.
class PayoutKycScreen extends StatefulWidget {
  const PayoutKycScreen({super.key});

  @override
  State<PayoutKycScreen> createState() => _PayoutKycScreenState();
}

class _PayoutKycScreenState extends State<PayoutKycScreen> {
  final _api = ApiService();
  final _pan = TextEditingController();
  final _panName = TextEditingController();
  final _gst = TextEditingController();
  final _bankName = TextEditingController();
  final _bankNumber = TextEditingController();
  final _ifsc = TextEditingController();

  String? _panDocUrl;
  String? _panDocName;
  String? _bankProofUrl;
  String? _bankProofName;

  bool _loading = true;
  bool _saving = false;
  String? _uploadingField; // 'pan' | 'proof'

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _pan.dispose();
    _panName.dispose();
    _gst.dispose();
    _bankName.dispose();
    _bankNumber.dispose();
    _ifsc.dispose();
    super.dispose();
  }

  String _L(String k) => AstroLabels.of(context, k);

  Future<void> _load() async {
    try {
      final r = await _api.getPayoutKyc();
      if (r['statusCode'] == 200) {
        _pan.text = (r['pan_number'] ?? '').toString();
        _panName.text = (r['pan_name'] ?? '').toString();
        _gst.text = (r['gst_number'] ?? '').toString();
        _bankName.text = (r['bank_account_name'] ?? '').toString();
        _bankNumber.text = (r['bank_account_number'] ?? '').toString();
        _ifsc.text = (r['bank_ifsc'] ?? '').toString();
        _panDocUrl = r['pan_doc_url'];
        _bankProofUrl = r['bank_proof_url'];
        if (_panDocUrl != null) _panDocName = _L('uploaded');
        if (_bankProofUrl != null) _bankProofName = _L('uploaded');
      }
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _pickAndUpload(String field) async {
    Uint8List? bytes;
    String? fileName;
    try {
      final choice = await showModalBottomSheet<String>(
        context: context,
        backgroundColor: AppColors.card,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
        builder: (ctx) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.gold),
              title: Text(_L('tapToUpload'), style: const TextStyle(color: AppColors.ivory)),
              onTap: () => Navigator.pop(ctx, 'gallery'),
            ),
            ListTile(
              leading: const Icon(Icons.upload_file, color: AppColors.gold),
              title: const Text('Choose File (image or PDF)', style: TextStyle(color: AppColors.ivory)),
              onTap: () => Navigator.pop(ctx, 'file'),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.gold),
              title: const Text('Camera', style: TextStyle(color: AppColors.ivory)),
              onTap: () => Navigator.pop(ctx, 'camera'),
            ),
          ]),
        ),
      );
      if (choice == null) return;
      if (choice == 'file') {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: const ['jpg', 'jpeg', 'png', 'webp', 'pdf'],
          withData: true,
        );
        if (result == null || result.files.isEmpty) return;
        bytes = result.files.first.bytes;
        fileName = result.files.first.name;
      } else {
        final picked = await ImagePicker().pickImage(
          source: choice == 'camera' ? ImageSource.camera : ImageSource.gallery,
          imageQuality: 80,
          maxWidth: 1600,
        );
        if (picked == null) return;
        bytes = await picked.readAsBytes();
        fileName = picked.name;
      }
    } catch (e) {
      _snack('Error: $e', AppColors.error);
      return;
    }
    if (bytes == null || fileName == null) return;

    setState(() => _uploadingField = field);
    try {
      final resp = await _api.uploadKycFile(bytes, fileName);
      if (resp['statusCode'] == 200) {
        setState(() {
          if (field == 'pan') {
            _panDocUrl = resp['media_url'];
            _panDocName = resp['file_name'];
          } else {
            _bankProofUrl = resp['media_url'];
            _bankProofName = resp['file_name'];
          }
        });
      } else {
        _snack(resp['detail']?.toString() ?? 'Upload failed', AppColors.error);
      }
    } catch (e) {
      _snack('Error: $e', AppColors.error);
    }
    if (mounted) setState(() => _uploadingField = null);
  }

  Future<void> _save() async {
    final pan = _pan.text.trim().toUpperCase();
    final gst = _gst.text.trim().toUpperCase();
    if (pan.isEmpty && gst.isEmpty) {
      _snack(_L('panOrGstNote'), AppColors.error);
      return;
    }
    setState(() => _saving = true);
    try {
      final resp = await _api.savePayoutKyc({
        'pan_number': pan,
        'pan_name': _panName.text.trim(),
        'gst_number': gst,
        'pan_doc_url': _panDocUrl,
        'bank_account_name': _bankName.text.trim(),
        'bank_account_number': _bankNumber.text.trim(),
        'bank_ifsc': _ifsc.text.trim().toUpperCase(),
        'bank_proof_url': _bankProofUrl,
      });
      if (resp['statusCode'] == 200) {
        _snack(resp['message']?.toString() ?? _L('payoutSaved'), AppColors.success);
        if (mounted) Navigator.pop(context, true);
      } else {
        _snack(resp['detail']?.toString() ?? 'Failed', AppColors.error);
      }
    } catch (e) {
      _snack('Error: $e', AppColors.error);
    }
    if (mounted) setState(() => _saving = false);
  }

  void _snack(String msg, Color c) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: c));
  }

  bool get _payoutReady =>
      _pan.text.trim().isNotEmpty && _bankNumber.text.trim().isNotEmpty && _bankProofUrl != null;

  Widget _field(TextEditingController c, String label, {String? hint, IconData? icon, List<TextInputFormatter>? fmt, TextCapitalization cap = TextCapitalization.none}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        inputFormatters: fmt,
        textCapitalization: cap,
        style: const TextStyle(color: AppColors.textPrimary),
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: icon != null ? Icon(icon, size: 20) : null,
        ),
      ),
    );
  }

  Widget _uploadTile(String label, String field, String? fileName) {
    final busy = _uploadingField == field;
    final done = fileName != null;
    return GestureDetector(
      onTap: busy ? null : () => _pickAndUpload(field),
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: done ? AppColors.success.withOpacity(0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: done ? AppColors.success.withOpacity(0.4) : AppColors.border),
        ),
        child: Row(children: [
          busy
              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
              : Icon(done ? Icons.check_circle : Icons.upload_file, color: done ? AppColors.success : AppColors.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w500)),
            Text(busy ? _L('uploadingFile') : (done ? fileName : _L('tapToUpload')),
                style: TextStyle(color: done ? AppColors.success : AppColors.textSecondary, fontSize: 11)),
          ])),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
        ]),
      ),
    );
  }

  Widget _sectionTitle(String s) => Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 4),
        child: Text(s, style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w700)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_L('payoutTitle'))),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: (_payoutReady ? AppColors.success : AppColors.primary).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: (_payoutReady ? AppColors.success : AppColors.primary).withOpacity(0.4)),
                  ),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Icon(_payoutReady ? Icons.verified : Icons.account_balance_wallet_outlined,
                        color: _payoutReady ? AppColors.success : AppColors.primary, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _payoutReady ? _L('payoutReady') : _L('payoutSub'),
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 18),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _sectionTitle(_L('taxSection')),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(_L('panOrGstNote'), style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                    ),
                    _field(_pan, _L('panLabel'), hint: 'ABCDE1234F', icon: Icons.badge_outlined,
                        cap: TextCapitalization.characters,
                        fmt: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]'))]),
                    _field(_panName, _L('panNameLabel'), icon: Icons.person_outline, cap: TextCapitalization.words),
                    _uploadTile(_L('uploadPanDoc'), 'pan', _panDocName),
                    _field(_gst, _L('gstLabel'), icon: Icons.receipt_long_outlined,
                        cap: TextCapitalization.characters,
                        fmt: [LengthLimitingTextInputFormatter(15), FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]'))]),
                  ]),
                ),
                const SizedBox(height: 14),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _sectionTitle(_L('bankSection')),
                    _field(_bankName, _L('bankNameLabel'), icon: Icons.person_outline, cap: TextCapitalization.words),
                    _field(_bankNumber, _L('bankNumberLabel'), icon: Icons.account_balance_outlined,
                        fmt: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(20)]),
                    _field(_ifsc, _L('ifscLabel'), icon: Icons.qr_code_2_outlined,
                        cap: TextCapitalization.characters,
                        fmt: [LengthLimitingTextInputFormatter(11), FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]'))]),
                    _uploadTile(_L('uploadBankProof'), 'proof', _bankProofName),
                  ]),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? Row(mainAxisSize: MainAxisSize.min, children: [
                            const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                            const SizedBox(width: 8),
                            Text(_L('saving')),
                          ])
                        : Text(_L('saveDetails')),
                  ),
                ),
                const SizedBox(height: 24),
              ]),
            ),
    );
  }
}
