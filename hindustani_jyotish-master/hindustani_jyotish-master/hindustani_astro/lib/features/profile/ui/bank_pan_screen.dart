import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/premium_ui.dart';
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
          SectionLabel(l.bankPanPayoutSection),
          _payoutCard(l, method),
          SectionLabel(l.bankPanIdentitySection),
          _identityCard(l),
          SectionLabel(l.bankPanDocsSection),
          _docsCard(l),
          const SizedBox(height: 24),
        ],
        PremiumPrimaryButton(
          label: hasAny ? l.bankPanEditCta : l.bankPanAddCta,
          onPressed: _openEditor,
          icon: Icons.edit_outlined,
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
    rows.add(
      method == null
          ? _row(l.setPayoutMethodLabel, null)
          : _chipRow(
              l.setPayoutMethodLabel,
              StatusChip(
                isUpi ? l.setPayoutUpi : l.setPayoutBank,
                tone: ChipTone.info,
                icon: isUpi ? Icons.qr_code_2 : Icons.account_balance_outlined,
              ),
            ),
    );
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
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final tileWidth = (constraints.maxWidth - spacing) / 2;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final (label, url) in docs)
              SizedBox(width: tileWidth, child: _docTile(l, label, url)),
          ],
        );
      },
    );
  }

  /// One document card in the 2-column grid: thumbnail, name, and an uploaded /
  /// missing status badge. A null [url] renders a placeholder; otherwise tapping
  /// opens the full-screen viewer.
  Widget _docTile(AppLocalizations l, String label, String? url) {
    final uploaded = url != null && url.isNotEmpty;
    final Widget preview;
    if (url == null || url.isEmpty) {
      preview = AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface3,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderSoft),
          ),
          child: Icon(Icons.image_not_supported_outlined,
              size: 26, color: AppColors.ivoryFaint),
        ),
      );
    } else {
      preview = InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => showFullScreenImage(context, label: label, url: url),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              url,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  color: AppColors.surface2,
                  child: const Center(
                    child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppColors.surface2,
                child: Icon(Icons.broken_image_outlined,
                    size: 26, color: AppColors.ivoryFaint),
              ),
            ),
          ),
        ),
      );
    }
    return PremiumCard(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          preview,
          const SizedBox(height: 10),
          Text(label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body(size: 12, color: AppColors.ivoryDim)),
          const SizedBox(height: 8),
          Center(
            child: uploaded
                ? const StatusChip('✓', tone: ChipTone.success, icon: Icons.check)
                : StatusChip(l.setKycNotUploaded, tone: ChipTone.muted),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) => PremiumCard(child: child);

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
    return _chipRow(
      label,
      StatusChip(l.bankPanMasked(last4), tone: ChipTone.muted),
    );
  }

  /// Label on the left, a status pill on the right.
  Widget _chipRow(String label, Widget chip) {
    return Row(
      children: [
        Flexible(
          child: Text(label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body(size: 13, color: AppColors.ivoryDim)),
        ),
        const SizedBox(width: 12),
        chip,
      ],
    );
  }
}
