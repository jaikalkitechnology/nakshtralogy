import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/full_screen_image_viewer.dart';
import '../../portal/portal_repository.dart';

/// First-class, profile-section entry for the astrologer's Bank & PAN details.
/// Read-model prefilled from `GET /astrologer/kyc/status`
/// ([PortalRepository.kycStatus]): payout method, bank name / IFSC /
/// account-holder, the masked account & Aadhaar last4 (the server stores/returns
/// last4 only — full numbers are never persisted), PAN number, and the document
/// thumbnails.
///
/// Editing itself is delegated to the existing KYC form (`/kyc`), which already
/// implements the exact partial `POST /astrologer/kyc` keep-current contract
/// ([PortalRepository.submitKyc]) — unchanged secret fields (Aadhaar / account
/// number) and un-replaced documents are resubmitted as-is, never blanked. This
/// screen intentionally does NOT re-implement that submit path; it presents the
/// details and routes into the form, so there is one source of truth for the
/// keep-current semantics. For a KYC-approved astrologer changes are STAGED for
/// admin approval (the live details stay active meanwhile), noted on this screen.
class BankPanScreen extends StatefulWidget {
  const BankPanScreen({super.key});

  @override
  State<BankPanScreen> createState() => _BankPanScreenState();
}

class _BankPanScreenState extends State<BankPanScreen> {
  final _repo = getIt<PortalRepository>();

  Map<String, dynamic>? _kyc;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _repo.kycStatus();
      if (!mounted) return;
      setState(() {
        _kyc = res;
        _loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    }
  }

  /// Opens the KYC form (which prefills from the same status payload and does
  /// the partial keep-current submit), then reloads on return so a staged
  /// change is reflected immediately.
  Future<void> _openEditor() async {
    await context.push('/kyc');
    if (mounted) await _load();
  }

  String? _str(String key) {
    final v = _kyc?[key];
    return (v is String && v.isNotEmpty) ? v : null;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.bankPanTitle)),
      body: CosmicBackground(
        child: SafeArea(
          top: false,
          child: RefreshIndicator(
            onRefresh: _load,
            color: AppColors.saffron,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: _body(l),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _body(AppLocalizations l) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }
    if (_error != null || _kyc == null) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 32),
        children: [
          Text(
            _error ?? l.bankPanLoadFailed,
            textAlign: TextAlign.center,
            style: AppTextStyles.body(size: 14, color: AppColors.danger),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton.icon(
              onPressed: _load,
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(l.commonRetry),
            ),
          ),
        ],
      );
    }

    final approved = _str('kyc_status') == 'approved';
    final method = _str('payout_method');
    final hasAny = method != null ||
        _str('pan_number') != null ||
        _str('aadhaar_last4') != null ||
        _str('bank_account_last4') != null;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      children: [
        Text(l.bankPanIntro,
            style: AppTextStyles.body(size: 13, color: AppColors.ivoryDim)),
        const SizedBox(height: 20),
        if (!hasAny)
          _card(child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(l.bankPanEmpty,
                style: AppTextStyles.body(size: 14, color: AppColors.ivoryDim)),
          ))
        else ...[
          _sectionTitle(l.bankPanPayoutSection),
          const SizedBox(height: 12),
          _payoutCard(l, method),
          const SizedBox(height: 24),
          _sectionTitle(l.bankPanIdentitySection),
          const SizedBox(height: 12),
          _identityCard(l),
          const SizedBox(height: 24),
          _sectionTitle(l.bankPanDocsSection),
          const SizedBox(height: 12),
          _docsCard(l),
          const SizedBox(height: 24),
        ],
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
          onPressed: _openEditor,
          icon: const Icon(Icons.edit_outlined),
          label: Text(hasAny ? l.bankPanEditCta : l.bankPanAddCta),
        ),
        if (approved) ...[
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline, size: 16, color: AppColors.gold),
              const SizedBox(width: 8),
              Expanded(
                child: Text(l.bankPanApprovalNote,
                    style: AppTextStyles.body(size: 12, color: AppColors.ivoryDim)),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _payoutCard(AppLocalizations l, String? method) {
    final isUpi = method == 'upi';
    final rows = <Widget>[];
    rows.add(_row(
      l.setPayoutMethodLabel,
      method == null ? null : (isUpi ? l.setPayoutUpi : l.setPayoutBank),
    ));
    if (isUpi) {
      rows.add(_row(l.bankPanUpiId, _str('upi_id')));
    } else if (method == 'bank') {
      rows.add(_row(l.bankPanBankName, _str('bank_name')));
      rows.add(_row(l.bankPanAccountHolder, _str('bank_account_holder')));
      rows.add(_maskedRow(l, l.bankPanAccountNumber, _str('bank_account_last4')));
      rows.add(_row(l.bankPanIfsc, _str('bank_ifsc')));
    }
    return _card(child: Column(children: _joined(rows)));
  }

  Widget _identityCard(AppLocalizations l) => _card(
        child: Column(
          children: _joined([
            _row(l.bankPanPan, _str('pan_number')),
            _maskedRow(l, l.bankPanAadhaar, _str('aadhaar_last4')),
          ]),
        ),
      );

  Widget _docsCard(AppLocalizations l) {
    final docs = <(String, String?)>[
      (l.setDocPan, _str('pan_doc_url')),
      (l.setDocAadhaar, _str('aadhaar_doc_url')),
      (l.setDocAadhaarBack, _str('aadhaar_back_doc_url')),
      (l.setDocBankProof, _str('bank_proof_url')),
    ];
    return _card(
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [for (final (label, url) in docs) _docTile(l, label, url)],
      ),
    );
  }

  /// One labeled document thumbnail; a null [url] renders a "Not uploaded"
  /// placeholder, otherwise tapping opens the full-screen viewer.
  Widget _docTile(AppLocalizations l, String label, String? url) {
    const double side = 92;
    final Widget preview;
    if (url == null || url.isEmpty) {
      preview = Container(
        width: side,
        height: side,
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderSoft),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported_outlined, size: 22, color: AppColors.ivoryFaint),
            const SizedBox(height: 6),
            Text(l.setKycNotUploaded,
                textAlign: TextAlign.center,
                style: AppTextStyles.body(size: 10, color: AppColors.ivoryFaint)),
          ],
        ),
      );
    } else {
      preview = InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => showFullScreenImage(context, label: label, url: url),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            url,
            width: side,
            height: side,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Container(
                width: side,
                height: side,
                color: AppColors.surface2,
                child: const Center(
                  child: SizedBox(
                      width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => Container(
              width: side,
              height: side,
              color: AppColors.surface2,
              child: Icon(Icons.broken_image_outlined, size: 22, color: AppColors.ivoryFaint),
            ),
          ),
        ),
      );
    }
    return SizedBox(
      width: side,
      child: Column(
        children: [
          preview,
          const SizedBox(height: 6),
          Text(label,
              textAlign: TextAlign.center,
              style: AppTextStyles.body(size: 11, color: AppColors.ivoryDim)),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) =>
      Text(text, style: AppTextStyles.heading(size: 16, color: AppColors.copperLight));

  Widget _card({required Widget child}) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface1,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderSoft),
        ),
        child: child,
      );

  /// Inserts hairline dividers between value rows.
  List<Widget> _joined(List<Widget> rows) {
    final out = <Widget>[];
    for (var i = 0; i < rows.length; i++) {
      out.add(rows[i]);
      if (i != rows.length - 1) {
        out.add(Divider(height: 20, color: AppColors.borderSoft));
      }
    }
    return out;
  }

  /// Label + value row; a null/empty value shows the muted "Not set" hint.
  Widget _row(String label, String? value) {
    final l = AppLocalizations.of(context);
    final has = value != null && value.isNotEmpty;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body(size: 13, color: AppColors.ivoryDim)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            has ? value : l.bankPanNotSet,
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body(
              size: 14,
              color: has ? AppColors.ivory : AppColors.ivoryFaint,
            ),
          ),
        ),
      ],
    );
  }

  /// Label + a masked-value chip showing only the last4 the server returns.
  Widget _maskedRow(AppLocalizations l, String label, String? last4) {
    if (last4 == null || last4.isEmpty) return _row(label, null);
    return Row(
      children: [
        Flexible(
          child: Text(label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body(size: 13, color: AppColors.ivoryDim)),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.copperLight.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.copperLight.withValues(alpha: 0.35)),
          ),
          child: Text(
            l.bankPanMasked(last4),
            style: AppTextStyles.mono(size: 12, color: AppColors.copperLight),
          ),
        ),
      ],
    );
  }
}
