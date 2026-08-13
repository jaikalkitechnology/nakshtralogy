import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hj_core/hj_core.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/di.dart';
import '../../../shared/responsive.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../auth/astro_session_cubit.dart';
import '../../portal/portal_repository.dart';

/// Light client-side sanity checks before hitting the backend — same
/// reasoning/precedent as `welcome_screen.dart`'s `_emailPattern`: not the
/// sole source of truth (the backend has its own constraints), just fast
/// feedback so an obviously-malformed value doesn't round-trip to the
/// server before the astrologer finds out. Checked against the
/// trimmed+uppercased value, matching how the server itself normalises
/// `pan_number`/`bank_ifsc` (see `portal_service.submit_kyc`) — so typing
/// lowercase doesn't show a spurious error.
final _panPattern = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');
final _aadhaarPattern = RegExp(r'^\d{12}$');
final _ifscPattern = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
final _bankAccountPattern = RegExp(r'^\d{9,18}$');

/// VPA shape (`name@bank`) — client-side mirror of the backend's `upi_id`
/// validation.
final _upiPattern = RegExp(r'^[A-Za-z0-9][A-Za-z0-9._-]*@[A-Za-z]{2,}$');

/// Step 2 of onboarding — formal KYC: PAN (+ photo), Aadhaar (+ front AND
/// back photos), payout details (UPI ID, or full bank details + a required
/// typed supporting document), an optional certificate upload, and years of
/// experience. Runs only after the profile step ([CompleteProfileScreen]) is
/// done. On submit the application moves to "Under Review".
///
/// An already-APPROVED astrologer can also reach this screen (from Settings)
/// to change KYC/payout details: the backend then STAGES the submission for
/// admin approval instead of applying it, so the post-submit flow confirms
/// with a SnackBar and returns to Settings rather than going to `/review`.
///
/// §8 (signup_login.md) — Update UX: on open the screen loads
/// `GET /astrologer/kyc/status` and PRE-FILLS everything on file: PAN number,
/// payout method/UPI/bank fields, and the existing document keys (shown as
/// thumbnails from their `*_url`s with a "Replace" action — not replacing
/// resubmits the current `*_key` as-is, no re-upload). Full Aadhaar and bank
/// account numbers are deliberately never returned by the server (it stores
/// last4 only), so those two fields stay EMPTY with a
/// "Current: •••• 1234 — leave empty to keep" helper and become OPTIONAL:
/// left empty, `aadhaar_number`/`bank_account_number` are OMITTED from the
/// submit body and the server keeps the current masked values. On a FIRST
/// submission (no live KYC row yet) both remain required exactly as before.
/// A baseline snapshot is captured after prefill; if the composed submission
/// still equals it at Submit time, the tap is a silent no-op — no API call,
/// no validation, no "submitted" message (the button is also disabled live
/// while unchanged) — so an unchanged Submit never stages a pointless
/// approval request.
///
/// `POST /astrologer/kyc` (`KYCSubmit`) also carries `full_name`,
/// `skills`/`languages`/`bio`/rates — fields already collected and saved by
/// the profile step — because the backend mirrors them onto the astrologer
/// row unconditionally on every submission (see
/// `portal_service.submit_kyc`). This screen re-sends the astrologer's
/// current values for those (read from the session, not re-collected here)
/// purely so a (re)submission can't blank them out; it never displays those
/// fields for editing.
class KycFormScreen extends StatefulWidget {
  const KycFormScreen({super.key});

  @override
  State<KycFormScreen> createState() => _KycFormScreenState();
}

class _KycFormScreenState extends State<KycFormScreen> {
  final _experience = TextEditingController(text: '5');
  final _pan = TextEditingController();
  final _aadhaar = TextEditingController();
  final _upi = TextEditingController();
  final _bankName = TextEditingController();
  final _bankHolder = TextEditingController();
  final _bankAcc = TextEditingController();
  final _ifsc = TextEditingController();

  final _repo = getIt<PortalRepository>();

  bool _saving = false;
  String? _error;

  /// True while `GET /astrologer/kyc/status` (the §8 prefill source) is in
  /// flight on open — the form renders a progress state instead, so the
  /// astrologer never sees (and starts typing into) a blank form that's
  /// about to be overwritten by the prefill.
  bool _statusLoading = true;

  /// Whether a live KYC row exists server-side (`submitted_at` non-null in
  /// the status payload). Drives the §8 behaviours: Aadhaar/bank-account
  /// numbers optional (empty = keep current masked value) and no-op
  /// detection at Submit. On a first submission both stay required and every
  /// Submit is real.
  bool _hasExistingKyc = false;

  /// Masked tails from the status payload — the server stores/returns last4
  /// ONLY (full numbers are deliberately never persisted), so these drive
  /// the "Current: •••• 1234 — leave empty to keep" helpers rather than any
  /// prefill of the number fields themselves.
  String? _aadhaarLast4;
  String? _bankAccountLast4;

  /// Normalised signature of the form captured right after prefill —
  /// compared against [_composeSignature] at Submit time for the §8 no-op
  /// detection. Null until the status load succeeds (in which case no-op
  /// detection stays off and every Submit goes through, same as before).
  String? _baseline;

  /// Payout method — 'upi' or 'bank'. Only the selected method's fields are
  /// rendered and submitted, matching the backend's conditional validation.
  String _payoutMethod = 'upi';

  /// What the bank supporting document is — 'passbook', 'cancelled_cheque'
  /// or 'bank_statement' (`bank_proof_type`). Only used when
  /// `_payoutMethod == 'bank'`, where both the type and the upload are
  /// required.
  String _bankProofType = 'passbook';

  // Document photo uploads — each uploaded immediately on pick via the
  // generic KYC-document endpoint (`doc_type` distinguishes them server-
  // side); the returned key rides along in the final KYC submit. Aadhaar
  // front+back and PAN photos are required; the bank proof is required when
  // the payout method is 'bank'; only the certificate stays optional.
  //
  // §8: the `*Key` fields are seeded from the status payload's raw `*_key`s,
  // so a document that is NOT replaced resubmits its existing key as-is (no
  // re-upload) and the `== null` required checks pass for either an existing
  // key or a fresh upload. The matching `*Url` fields hold the `*_url`
  // thumbnails shown until a replacement is picked.
  bool _aadhaarPhotoUploading = false;
  String? _aadhaarDocKey;
  String? _aadhaarFileName;
  String? _aadhaarDocUrl;

  bool _aadhaarBackUploading = false;
  String? _aadhaarBackDocKey;
  String? _aadhaarBackFileName;
  String? _aadhaarBackDocUrl;

  bool _panPhotoUploading = false;
  String? _panDocKey;
  String? _panFileName;
  String? _panDocUrl;

  bool _bankProofUploading = false;
  String? _bankProofKey;
  String? _bankProofFileName;
  String? _bankProofUrl;

  bool _certUploading = false;
  String? _certificateKey;
  String? _certificateFileName;
  String? _certificateUrl;

  /// The KYC selfie's existing storage key, if any. Not editable on this
  /// screen (the photo is managed elsewhere), but resubmitted as-is so a
  /// §8 update can't blank it out server-side.
  String? _photoKey;

  @override
  void initState() {
    super.initState();
    final astro = context.read<AstroSessionCubit>().state.astrologer;
    if (astro != null && astro.yearsExperience > 0) {
      _experience.text = '${astro.yearsExperience}';
    }
    // Live "unchanged" tracking for the Submit button — the selector/chip/
    // upload paths already call setState, but plain typing doesn't, so each
    // controller pings a rebuild to recompute [_isUnchanged].
    for (final c in [_experience, _pan, _aadhaar, _upi, _bankName, _bankHolder, _bankAcc, _ifsc]) {
      c.addListener(_onFieldChanged);
    }
    _loadStatus();
  }

  void _onFieldChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _experience.dispose();
    _pan.dispose();
    _aadhaar.dispose();
    _upi.dispose();
    _bankName.dispose();
    _bankHolder.dispose();
    _bankAcc.dispose();
    _ifsc.dispose();
    super.dispose();
  }

  /// §8 prefill — loads `GET /astrologer/kyc/status` and seeds the form from
  /// whatever is on file, then captures the no-op baseline. A brand-new
  /// astrologer gets a payload of nulls (the endpoint doesn't 404), which
  /// leaves the form blank; on a fetch FAILURE the form also just falls back
  /// to blank (exactly the pre-§8 behaviour, with no-op detection off) —
  /// KYC submission must not be blocked by a transient status hiccup.
  Future<void> _loadStatus() async {
    try {
      final res = await _repo.kycStatus();
      if (!mounted) return;
      setState(() {
        _applyPrefill(res);
        _statusLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _statusLoading = false);
    }
  }

  void _applyPrefill(Map<String, dynamic> res) {
    _hasExistingKyc = res['submitted_at'] != null;

    String? str(String key) {
      final v = res[key];
      return (v is String && v.isNotEmpty) ? v : null;
    }

    final pan = str('pan_number');
    if (pan != null) _pan.text = pan;
    _aadhaarLast4 = str('aadhaar_last4');
    _bankAccountLast4 = str('bank_account_last4');

    final method = str('payout_method');
    if (method == 'upi' || method == 'bank') _payoutMethod = method!;
    final upi = str('upi_id');
    if (upi != null) _upi.text = upi;
    final bankName = str('bank_name');
    if (bankName != null) _bankName.text = bankName;
    final holder = str('bank_account_holder');
    if (holder != null) _bankHolder.text = holder;
    final ifsc = str('bank_ifsc');
    if (ifsc != null) _ifsc.text = ifsc;
    final proofType = str('bank_proof_type');
    if (const {'passbook', 'cancelled_cheque', 'bank_statement'}.contains(proofType)) {
      _bankProofType = proofType!;
    }

    _photoKey = str('photo_key');
    _panDocKey = str('pan_doc_key');
    _aadhaarDocKey = str('aadhaar_doc_key');
    _aadhaarBackDocKey = str('aadhaar_back_doc_key');
    _bankProofKey = str('bank_proof_key');
    _certificateKey = str('certificate_key');
    _panDocUrl = str('pan_doc_url');
    _aadhaarDocUrl = str('aadhaar_doc_url');
    _aadhaarBackDocUrl = str('aadhaar_back_doc_url');
    _bankProofUrl = str('bank_proof_url');
    _certificateUrl = str('certificate_url');

    _baseline = _composeSignature();
  }

  /// Canonical signature of what Submit WOULD send, using the exact same
  /// normalisation `_submit` applies (trim, PAN/IFSC uppercased). The
  /// Aadhaar/bank-account entries are '' both at baseline (never prefilled —
  /// server stores last4 only) and when left empty at Submit (omitted from
  /// the body = keep current), so an untouched number counts as unchanged.
  /// Only the selected payout method's fields participate, mirroring what is
  /// actually submitted.
  String _composeSignature() => [
        'exp:${int.tryParse(_experience.text.trim()) ?? 0}',
        'pan:${_pan.text.trim().toUpperCase()}',
        'aadhaar:${_aadhaar.text.trim()}',
        'pan_doc:${_panDocKey ?? ''}',
        'aadhaar_doc:${_aadhaarDocKey ?? ''}',
        'aadhaar_back:${_aadhaarBackDocKey ?? ''}',
        'cert:${_certificateKey ?? ''}',
        'method:$_payoutMethod',
        if (_payoutMethod == 'upi')
          'upi:${_upi.text.trim()}'
        else ...[
          'bank_name:${_bankName.text.trim()}',
          'holder:${_bankHolder.text.trim()}',
          'acc:${_bankAcc.text.trim()}',
          'ifsc:${_ifsc.text.trim().toUpperCase()}',
          'proof_type:$_bankProofType',
          'proof_key:${_bankProofKey ?? ''}',
        ],
      ].join('|');

  /// §8 no-op detection — true when a live KYC row exists, the baseline was
  /// captured, and nothing on the form differs from it.
  bool get _isUnchanged =>
      _hasExistingKyc && _baseline != null && _composeSignature() == _baseline;

  /// Shared upload flow for every document photo (Aadhaar/PAN/bank
  /// proof/certificate) — picks from the gallery, uploads to
  /// `POST /astrologer/kyc/upload` with the given `doc_type`, and reports
  /// the result back via the two callbacks so each caller can update its
  /// own key/filename/uploading state without duplicating the picker +
  /// upload + error-handling logic four times.
  Future<void> _pickDocument({
    required String docType,
    required void Function(bool uploading) setUploading,
    required void Function(String key, String fileName) onUploaded,
  }) async {
    setState(() => _error = null);
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 2048,
        imageQuality: 90,
      );
      if (picked == null) return;
      setState(() => setUploading(true));
      final bytes = await picked.readAsBytes();
      final key = await _repo.uploadKycDocument(bytes, picked.name, docType);
      setState(() => onUploaded(key, picked.name));
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = 'Could not upload the document: $e');
    } finally {
      if (mounted) setState(() => setUploading(false));
    }
  }

  Future<void> _pickAadhaarPhoto() => _pickDocument(
        docType: 'aadhaar',
        setUploading: (v) => _aadhaarPhotoUploading = v,
        onUploaded: (key, name) {
          _aadhaarDocKey = key;
          _aadhaarFileName = name;
        },
      );

  Future<void> _pickAadhaarBackPhoto() => _pickDocument(
        docType: 'aadhaar_back',
        setUploading: (v) => _aadhaarBackUploading = v,
        onUploaded: (key, name) {
          _aadhaarBackDocKey = key;
          _aadhaarBackFileName = name;
        },
      );

  Future<void> _pickPanPhoto() => _pickDocument(
        docType: 'pan',
        setUploading: (v) => _panPhotoUploading = v,
        onUploaded: (key, name) {
          _panDocKey = key;
          _panFileName = name;
        },
      );

  Future<void> _pickBankProof() => _pickDocument(
        docType: 'bank_proof',
        setUploading: (v) => _bankProofUploading = v,
        onUploaded: (key, name) {
          _bankProofKey = key;
          _bankProofFileName = name;
        },
      );

  Future<void> _pickCertificate() => _pickDocument(
        docType: 'certificate',
        setUploading: (v) => _certUploading = v,
        onUploaded: (key, name) {
          _certificateKey = key;
          _certificateFileName = name;
        },
      );

  Future<void> _submit() async {
    // §8 no-op: nothing differs from what's already on file — no API call,
    // no validation message, no "submitted" toast (an identical resubmit
    // would be pointless, and for an approved astrologer would needlessly
    // stage an approval request). If the screen was pushed (Settings →
    // Update KYC), silently pop back; inside the onboarding flow (/review →
    // resubmit, reached via `go`) there's nothing to pop to, so just stay.
    // Checked BEFORE validation: the untouched form legitimately has empty
    // Aadhaar/bank-account fields (empty = keep current masked values).
    if (_isUnchanged) {
      if (context.canPop()) context.pop();
      return;
    }

    final pan = _pan.text.trim().toUpperCase();
    final aadhaar = _aadhaar.text.trim();
    final upi = _upi.text.trim();
    final bankName = _bankName.text.trim();
    final bankHolder = _bankHolder.text.trim();
    final bankAcc = _bankAcc.text.trim();
    final ifsc = _ifsc.text.trim().toUpperCase();

    if (pan.isEmpty) {
      setState(() => _error = 'PAN number is required.');
      return;
    }
    if (!_panPattern.hasMatch(pan)) {
      setState(() => _error = 'Enter a valid 10-character PAN number (e.g. ABCDE1234F).');
      return;
    }
    // §8: with a masked Aadhaar on file, an empty field means "keep the
    // current number" (omitted from the body). Required only on the first
    // submission; the format check applies whenever something was typed.
    if (aadhaar.isEmpty) {
      if (_aadhaarLast4 == null) {
        setState(() => _error = 'Aadhaar number is required.');
        return;
      }
    } else if (!_aadhaarPattern.hasMatch(aadhaar)) {
      setState(() => _error = 'Enter a valid 12-digit Aadhaar number.');
      return;
    }
    if (_panDocKey == null) {
      setState(() => _error = 'Please upload a photo of your PAN card.');
      return;
    }
    if (_aadhaarDocKey == null) {
      setState(() => _error = 'Please upload the FRONT photo of your Aadhaar card.');
      return;
    }
    if (_aadhaarBackDocKey == null) {
      setState(() => _error = 'Please upload the BACK photo of your Aadhaar card.');
      return;
    }
    // Payout — only the selected method's fields are validated/sent.
    if (_payoutMethod == 'upi') {
      if (upi.isEmpty) {
        setState(() => _error = 'UPI ID is required.');
        return;
      }
      if (!_upiPattern.hasMatch(upi)) {
        setState(() => _error = 'Enter a valid UPI ID (e.g. name@bank).');
        return;
      }
    } else {
      if (bankName.isEmpty) {
        setState(() => _error = 'Bank name is required.');
        return;
      }
      if (bankHolder.isEmpty) {
        setState(() => _error = 'Account holder name is required.');
        return;
      }
      // §8: same empty-means-keep rule as Aadhaar, driven by the masked
      // last4 on file.
      if (bankAcc.isEmpty) {
        if (_bankAccountLast4 == null) {
          setState(() => _error = 'Bank account details are required.');
          return;
        }
      } else if (!_bankAccountPattern.hasMatch(bankAcc)) {
        setState(() => _error = 'Enter a valid bank account number (9–18 digits).');
        return;
      }
      if (ifsc.isEmpty) {
        setState(() => _error = 'Bank account details are required.');
        return;
      }
      if (!_ifscPattern.hasMatch(ifsc)) {
        setState(() => _error = 'Enter a valid 11-character IFSC code (e.g. SBIN0001234).');
        return;
      }
      if (_bankProofKey == null) {
        setState(() => _error =
            'Please upload the bank supporting document (passbook, cancelled cheque or bank statement).');
        return;
      }
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    final session = context.read<AstroSessionCubit>();
    final astro = session.state.astrologer;
    // Whether this is a post-approval change (staged for admin review) or the
    // original onboarding submission — decided BEFORE the refresh below.
    final wasApproved = astro?.isApproved ?? false;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await _repo.submitKyc({
        // Already collected/saved by the Complete Profile step — carried
        // through unedited so this submission doesn't blank them out
        // (see the class doc comment).
        'full_name': astro?.displayName ?? '',
        'skills': astro?.skills ?? const <String>[],
        'languages': astro?.languages ?? const <String>[],
        'rate_chat_per_msg': astro?.rateChatPerMsg ?? '0.00',
        'rate_call_per_min': astro?.rateCallPerMin ?? '0.00',
        'rate_video_per_min': astro?.rateVideoPerMin ?? '0.00',
        'bio': astro?.bio ?? '',
        // Collected here.
        'years_experience': int.tryParse(_experience.text) ?? 0,
        'pan_number': pan,
        // §8: omitted when left empty against a masked value on file — the
        // server keeps the current (last4-masked) number.
        if (aadhaar.isNotEmpty) 'aadhaar_number': aadhaar,
        'pan_doc_key': _panDocKey,
        'aadhaar_doc_key': _aadhaarDocKey,
        'aadhaar_back_doc_key': _aadhaarBackDocKey,
        // Not editable here — resubmitted as-is so an update can't blank it.
        if (_photoKey != null) 'photo_key': _photoKey,
        'payout_method': _payoutMethod,
        if (_payoutMethod == 'upi') 'upi_id': upi,
        if (_payoutMethod == 'bank') ...{
          'bank_name': bankName,
          'bank_account_holder': bankHolder,
          // §8: same omitted-means-keep rule as aadhaar_number above.
          if (bankAcc.isNotEmpty) 'bank_account_number': bankAcc,
          'bank_ifsc': ifsc,
          'bank_proof_key': _bankProofKey,
          'bank_proof_type': _bankProofType,
        },
        if (_certificateKey != null) 'certificate_key': _certificateKey,
      });
      // The response is KYCStatusOut, not the full astrologer — refresh the
      // session from /astrologer/me so kycSubmittedAt (or pending_edit, for
      // an approved astrologer's staged change) reflects the change, then
      // navigate EXPLICITLY: the router's redirect deliberately returns null
      // for any location already inside the onboarding trio (see
      // app_router.dart's `inOnboarding`), so a session update alone never
      // moves this screen forward — relying on it left the Submit button
      // saving successfully but visibly doing nothing.
      if (!mounted) return;
      await session.refresh();
      if (!mounted) return;
      if (wasApproved) {
        // Post-approval resubmission: the backend STAGES the change for admin
        // approval (live KYC/payout data unchanged) — confirm that instead of
        // sending an already-approved astrologer to the Under-Review gate.
        messenger.showSnackBar(const SnackBar(
          content: Text('Submitted for admin approval — your current details stay active until then.'),
        ));
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/settings');
        }
      } else {
        context.go('/review');
      }
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      // Non-API failure (unexpected response shape, etc.) — must still be
      // surfaced, or the button appears to do nothing.
      setState(() => _error = 'Could not submit: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_statusLoading) {
      // §8 prefill in flight — never show a blank form that is about to be
      // seeded (typing into it would be lost/confusing).
      return const Scaffold(
        body: CosmicBackground(
          child: SafeArea(
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
        ),
      );
    }
    final unchanged = _isUnchanged;
    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: [
              CenteredMaxWidth(
                maxWidth: 640,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.saffron.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.saffron.withValues(alpha: 0.35)),
                  ),
                  child: Text('STEP 2 OF 2',
                      style: AppTextStyles.label(size: 11, color: AppColors.saffronBright)),
                ),
              ),
              const SizedBox(height: 10),
              Text('KYC Verification', style: AppTextStyles.display(size: 24)),
              const SizedBox(height: 6),
              Text(
                  _hasExistingKyc
                      ? 'Your details on file are pre-filled — change only what you need to.'
                      : 'Submit your documents to get verified and start consulting.',
                  style: AppTextStyles.body(color: AppColors.ivoryDim)),
              const SizedBox(height: 20),
              _field(_experience, 'Years of experience', number: true),
              _validatedField(
                _pan,
                'PAN number',
                pattern: _panPattern,
                patternError: 'Enter a valid 10-character PAN (e.g. ABCDE1234F).',
                uppercase: true,
              ),
              _docPicker(
                icon: Icons.badge_outlined,
                title: 'PAN card photo',
                subtitle: _panFileName ??
                    (_panDocKey != null
                        ? 'Current document on file — replace only if it changed'
                        : 'Required — a clear photo of your PAN card'),
                uploading: _panPhotoUploading,
                hasFile: _panDocKey != null,
                thumbUrl: _panFileName == null ? _panDocUrl : null,
                onTap: _pickPanPhoto,
              ),
              const SizedBox(height: 8),
              _validatedField(
                _aadhaar,
                'Aadhaar number',
                number: true,
                pattern: _aadhaarPattern,
                patternError: 'Enter a valid 12-digit Aadhaar number.',
                helper: _aadhaarLast4 != null
                    ? 'Current: •••• •••• $_aadhaarLast4 — leave empty to keep'
                    : null,
              ),
              _docPicker(
                icon: Icons.badge_outlined,
                title: 'Aadhaar front photo',
                subtitle: _aadhaarFileName ??
                    (_aadhaarDocKey != null
                        ? 'Current document on file — replace only if it changed'
                        : 'Required — the front side of your Aadhaar card'),
                uploading: _aadhaarPhotoUploading,
                hasFile: _aadhaarDocKey != null,
                thumbUrl: _aadhaarFileName == null ? _aadhaarDocUrl : null,
                onTap: _pickAadhaarPhoto,
              ),
              _docPicker(
                icon: Icons.badge_outlined,
                title: 'Aadhaar back photo',
                subtitle: _aadhaarBackFileName ??
                    (_aadhaarBackDocKey != null
                        ? 'Current document on file — replace only if it changed'
                        : 'Required — the back side of your Aadhaar card'),
                uploading: _aadhaarBackUploading,
                hasFile: _aadhaarBackDocKey != null,
                thumbUrl: _aadhaarBackFileName == null ? _aadhaarBackDocUrl : null,
                onTap: _pickAadhaarBackPhoto,
              ),
              const SizedBox(height: 4),
              _docPicker(
                icon: Icons.workspace_premium_outlined,
                title: 'Certificate (optional)',
                subtitle: _certificateFileName ??
                    (_certificateKey != null
                        ? 'Current document on file — replace only if it changed'
                        : 'e.g. astrology qualification'),
                uploading: _certUploading,
                hasFile: _certificateKey != null,
                thumbUrl: _certificateFileName == null ? _certificateUrl : null,
                onTap: _pickCertificate,
              ),
              _section('Payout details'),
              _payoutMethodSelector(),
              const SizedBox(height: 12),
              if (_payoutMethod == 'upi')
                _validatedField(
                  _upi,
                  'UPI ID',
                  pattern: _upiPattern,
                  patternError: 'Enter a valid UPI ID (e.g. name@bank).',
                )
              else ...[
                _field(_bankName, 'Bank name'),
                _field(_bankHolder, 'Account holder name'),
                _validatedField(
                  _bankAcc,
                  'Account number',
                  number: true,
                  pattern: _bankAccountPattern,
                  patternError: 'Enter a valid account number (9–18 digits).',
                  helper: _bankAccountLast4 != null
                      ? 'Current: •••• $_bankAccountLast4 — leave empty to keep'
                      : null,
                ),
                _validatedField(
                  _ifsc,
                  'IFSC code',
                  pattern: _ifscPattern,
                  patternError: 'Enter a valid 11-character IFSC code (e.g. SBIN0001234).',
                  uppercase: true,
                ),
                const SizedBox(height: 4),
                _bankProofTypeSelector(),
                _docPicker(
                  icon: Icons.account_balance_outlined,
                  title: 'Supporting document',
                  subtitle: _bankProofFileName ??
                      (_bankProofKey != null
                          ? 'Current document on file — replace only if it changed'
                          : 'Required — a clear photo of the selected document'),
                  uploading: _bankProofUploading,
                  hasFile: _bankProofKey != null,
                  thumbUrl: _bankProofFileName == null ? _bankProofUrl : null,
                  onTap: _pickBankProof,
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: AppTextStyles.body(size: 13, color: AppColors.danger)),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
      // Explicit full width: the shared theme no longer forces an
      // (invalid) infinite minimum width on every ElevatedButton.
      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                // §8: disabled live while nothing differs from the values on
                // file — [_submit] also guards against an unchanged tap (the
                // mandatory silent no-op), so the disable is purely UX.
                onPressed: (_saving || unchanged) ? null : _submit,
                child: _saving
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Submit for review'),
              ),
              if (unchanged) ...[
                const SizedBox(height: 8),
                Text(
                  'No changes yet — edit a field or replace a document to submit.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body(size: 12, color: AppColors.ivoryDim),
                ),
              ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section(String title) => Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 8),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: AppColors.copperLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Text(title, style: AppTextStyles.heading(size: 16, color: AppColors.copperLight)),
          ],
        ),
      );

  /// UPI | Bank Account segmented control — flips which payout fields are
  /// rendered (and later validated/submitted). Values typed elsewhere are
  /// kept in their controllers so switching back doesn't lose input.
  Widget _payoutMethodSelector() => SegmentedButton<String>(
        segments: const [
          ButtonSegment(
            value: 'upi',
            label: Text('UPI'),
            icon: Icon(Icons.qr_code_2, size: 18),
          ),
          ButtonSegment(
            value: 'bank',
            label: Text('Bank Account'),
            icon: Icon(Icons.account_balance_outlined, size: 18),
          ),
        ],
        selected: {_payoutMethod},
        onSelectionChanged: (sel) => setState(() => _payoutMethod = sel.first),
        style: SegmentedButton.styleFrom(
          foregroundColor: AppColors.ivoryDim,
          selectedForegroundColor: Colors.white,
          selectedBackgroundColor: AppColors.saffron,
          side: const BorderSide(color: AppColors.borderSoft),
        ),
      );

  /// Which bank supporting document is being uploaded (`bank_proof_type`) —
  /// one required choice of three.
  Widget _bankProofTypeSelector() => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Supporting document type',
                style: AppTextStyles.body(size: 12, color: AppColors.ivoryDim)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final (value, label) in const [
                  ('passbook', 'Passbook'),
                  ('cancelled_cheque', 'Cancelled cheque'),
                  ('bank_statement', 'Bank statement'),
                ])
                  ChoiceChip(
                    label: Text(label),
                    selected: _bankProofType == value,
                    onSelected: (_) => setState(() => _bankProofType = value),
                    selectedColor: AppColors.saffron,
                    backgroundColor: AppColors.surface1,
                    labelStyle: AppTextStyles.body(
                      size: 12,
                      color: _bankProofType == value ? Colors.white : AppColors.ivoryDim,
                    ),
                    side: const BorderSide(color: AppColors.borderSoft),
                  ),
              ],
            ),
          ],
        ),
      );

  Widget _field(TextEditingController c, String label, {bool number = false, int lines = 1}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
          controller: c,
          maxLines: lines,
          keyboardType: number ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(labelText: label),
        ),
      );

  /// Same as [_field], but shows a live format error (e.g. "Enter a valid
  /// PAN") the moment what's typed so far doesn't match [pattern] — mirrors
  /// `welcome_screen.dart`'s email-field validation pattern rather than
  /// only checking on submit. [ValueListenableBuilder] bound directly to
  /// the controller keeps this reactive without a `Form`/`GlobalKey`, since
  /// nothing else on this screen uses one. Blank is never flagged as an
  /// error here (that's [_submit]'s "required" check) — only a genuinely
  /// malformed non-empty value is. [helper] (§8) renders the masked
  /// "Current: •••• 1234 — leave empty to keep" hint for the two
  /// number fields the server only stores last4 of.
  Widget _validatedField(
    TextEditingController c,
    String label, {
    required RegExp pattern,
    required String patternError,
    bool number = false,
    bool uppercase = false,
    String? helper,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: c,
        builder: (context, value, _) {
          final text = value.text.trim();
          final normalised = uppercase ? text.toUpperCase() : text;
          final error = text.isNotEmpty && !pattern.hasMatch(normalised) ? patternError : null;
          return TextField(
            controller: c,
            keyboardType: number ? TextInputType.number : TextInputType.text,
            textCapitalization: uppercase ? TextCapitalization.characters : TextCapitalization.none,
            decoration: InputDecoration(
              labelText: label,
              errorText: error,
              helperText: helper,
              helperMaxLines: 2,
            ),
          );
        },
      ),
    );
  }

  /// Shared document-photo picker row — used for the PAN/Aadhaar/bank-proof/
  /// certificate uploads. [hasFile] drives the button label ("Upload" vs.
  /// "Replace"); [subtitle] shows the picked filename once one exists.
  /// [thumbUrl] (§8) shows a small thumbnail of the document already on file
  /// in place of the icon — passed only while the doc hasn't been replaced
  /// this session (a fresh upload has no URL, just a key).
  Widget _docPicker({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool uploading,
    required bool hasFile,
    required VoidCallback onTap,
    String? thumbUrl,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface1,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: hasFile
                    ? AppColors.success.withValues(alpha: 0.35)
                    : AppColors.borderSoft),
          ),
          child: Row(
            children: [
              if (thumbUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    thumbUrl,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    // Broken/unreachable URL (e.g. a PDF certificate) —
                    // quietly fall back to the doc-type icon.
                    errorBuilder: (_, _, _) => Icon(icon, color: AppColors.copperLight),
                  ),
                )
              else
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.copperLight.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 22, color: AppColors.copperLight),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.body(size: 14, weight: FontWeight.w600)),
                        ),
                        if (hasFile) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.check_circle, size: 14, color: AppColors.success),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body(size: 12, color: AppColors.ivoryDim),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: uploading ? null : onTap,
                child: uploading
                    ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(hasFile ? 'Replace' : 'Upload'),
              ),
            ],
          ),
        ),
      );
}
