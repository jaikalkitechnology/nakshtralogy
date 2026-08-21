import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hj_core/hj_core.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/locale_cubit.dart';
import '../../../shared/avatar_compress.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/full_screen_image_viewer.dart';
import '../../../shared/premium_ui.dart';
import '../../auth/astro_session_cubit.dart';
import '../../portal/portal_repository.dart';

/// Lets the astrologer edit their charges, display name, bio/skills/languages
/// and profile picture. Saves via `PATCH /astrologer/me` and
/// `POST /astrologer/me/avatar`, then refreshes [AstroSessionCubit]. Also shows
/// the submitted KYC documents (from `GET /astrologer/kyc/status`) as read-only
/// thumbnails — once approved the backend 409s any resubmission, so they are
/// view-only; while pending/rejected a button routes back to the KYC form.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _repo = getIt<PortalRepository>();

  late final TextEditingController _name;
  late final TextEditingController _bio;
  late final TextEditingController _skills;
  late final TextEditingController _languages;
  late final TextEditingController _chat;
  late final TextEditingController _call;
  late final TextEditingController _video;

  /// Single Super Chat price (decimal string, e.g. `'20.00'`). The platform
  /// uses ONE price per astrologer, stored as a one-element
  /// `super_chat_presets` list (same shape signup's Complete Profile sends) —
  /// the backend list format is unchanged. Empty when none is set yet, which
  /// disables Super Chat during this astrologer's live broadcasts.
  late final TextEditingController _superChat;

  bool _saving = false;
  bool _uploading = false;

  /// Inline validation error for [_superChat]; set by `_save()` and cleared
  /// as soon as the astrologer edits the field again.
  String? _superChatError;

  /// Raw `GET /astrologer/kyc/status` payload — carries `kyc_status` plus the
  /// document URLs (`photo_url`, `pan_doc_url`, `aadhaar_doc_url`,
  /// `bank_proof_url`, `certificate_url`; string-or-null absolute URLs).
  Map<String, dynamic>? _kyc;
  bool _kycLoading = true;
  String? _kycError;

  @override
  void initState() {
    super.initState();
    final a = getIt<AstroSessionCubit>().state.astrologer;
    _name = TextEditingController(text: a?.displayName ?? '');
    _bio = TextEditingController(text: a?.bio ?? '');
    _skills = TextEditingController(text: a?.skills.join(', ') ?? '');
    _languages = TextEditingController(text: a?.languages.join(', ') ?? '');
    _chat = TextEditingController(text: a?.rateChatPerMsg ?? '0.00');
    _call = TextEditingController(text: a?.rateCallPerMin ?? '0.00');
    _video = TextEditingController(text: a?.rateVideoPerMin ?? '0.00');
    final presets = a?.superChatPresets ?? const <String>[];
    _superChat = TextEditingController(text: presets.isEmpty ? '' : presets.first);
    _superChat.addListener(() {
      if (_superChatError != null) setState(() => _superChatError = null);
    });
    _loadKycStatus();
  }

  /// Pull-to-refresh: reload `/astrologer/me` (session) and the KYC status
  /// together — the two sources this screen renders from.
  Future<void> _refreshAll() => Future.wait([
        getIt<AstroSessionCubit>().refresh(),
        _loadKycStatus(),
      ]);

  Future<void> _loadKycStatus() async {
    setState(() {
      _kycLoading = true;
      _kycError = null;
    });
    try {
      final res = await _repo.kycStatus();
      if (!mounted) return;
      setState(() {
        _kyc = res;
        _kycLoading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _kycError = e.message;
        _kycLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _bio.dispose();
    _skills.dispose();
    _languages.dispose();
    _chat.dispose();
    _call.dispose();
    _video.dispose();
    _superChat.dispose();
    super.dispose();
  }

  List<String> _splitList(String raw) =>
      raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final session = context.read<AstroSessionCubit>();
    // Client-side mirror of the backend's `_validate_presets` bounds (> 0,
    // platform ceiling ₹10000) — fails fast with an inline reason instead of
    // waiting for a raw API error. The backend still re-validates; the catch
    // below surfaces its message verbatim if it ever disagrees.
    final superChat = double.tryParse(_superChat.text.trim());
    if (superChat == null || superChat <= 0) {
      setState(() => _superChatError = l.setSuperChatInvalid);
      return;
    }
    if (superChat > 10000) {
      setState(() => _superChatError = l.setSuperChatMax);
      return;
    }
    setState(() => _saving = true);
    try {
      final updated = await _repo.updateProfile({
        // Omitted when blanked out — the backend derives `profile_completed`
        // from display_name (among others), so never clear it accidentally.
        if (_name.text.trim().isNotEmpty) 'display_name': _name.text.trim(),
        'bio': _bio.text.trim(),
        'skills': _splitList(_skills.text),
        'languages': _splitList(_languages.text),
        'rate_chat_per_msg': _chat.text.trim(),
        'rate_call_per_min': _call.text.trim(),
        'rate_video_per_min': _video.text.trim(),
        // Always a one-element list — see the `_superChat` field doc.
        'super_chat_presets': [superChat.toStringAsFixed(2)],
      });
      session.update(updated);
      // For KYC-approved astrologers the backend holds these edits for admin
      // approval instead of applying them immediately — say so explicitly.
      final pendingApproval = updated.pendingEdit?['status'] == 'pending';
      messenger.showSnackBar(SnackBar(
        content: Text(pendingApproval ? l.setChangesPendingApproval : l.setProfileUpdated),
      ));
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickAvatar() async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final session = context.read<AstroSessionCubit>();
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 90,
      );
      if (picked == null) return;
      setState(() => _uploading = true);
      final raw = await picked.readAsBytes();
      final c = await compressAvatar(raw, sourceName: picked.name);
      final updated =
          await _repo.uploadAvatar(c?.bytes ?? raw, c?.filename ?? picked.name);
      session.update(updated);
      // Same approval flow as _save: an approved astrologer's new photo is
      // held for admin review rather than applied immediately.
      final pendingApproval = updated.pendingEdit?['status'] == 'pending';
      messenger.showSnackBar(SnackBar(
        content: Text(pendingApproval ? l.setChangesPendingApproval : l.setPhotoUpdated),
      ));
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Could not pick an image: $e')));
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final photoUrl = context.select((AstroSessionCubit c) => c.state.astrologer?.photoUrl);
    final name = context.select((AstroSessionCubit c) => c.state.astrologer?.displayName);
    final pendingEdit =
        context.select((AstroSessionCubit c) => c.state.astrologer?.pendingEdit);
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.setTitle)),
      body: CosmicBackground(
        child: SafeArea(
          top: false,
          child: RefreshIndicator(
            onRefresh: _refreshAll,
            color: AppColors.saffron,
            child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: [
              if (pendingEdit != null) ...[
                _pendingEditBanner(l, pendingEdit),
                const SizedBox(height: 20),
              ],
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        // Tapping the photo itself opens it full screen; the
                        // camera badge below stays the (only) edit affordance.
                        GestureDetector(
                          onTap: (photoUrl != null && photoUrl.isNotEmpty)
                              ? () => showFullScreenImage(context,
                                  label: l.setDocPhoto, url: photoUrl)
                              : null,
                          child: CircleAvatar(
                            radius: 48,
                            backgroundColor: AppColors.indigoMid,
                            backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                                ? NetworkImage(photoUrl)
                                : null,
                            child: (photoUrl == null || photoUrl.isEmpty)
                                ? Text(
                                    (name?.isNotEmpty ?? false) ? name![0].toUpperCase() : '🪔',
                                    style: AppTextStyles.display(size: 30),
                                  )
                                : null,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Material(
                            color: AppColors.saffron,
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: _uploading ? null : _pickAvatar,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: _uploading
                                    ? const SizedBox(
                                        width: 16, height: 16,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                    : const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(l.setChangePhoto,
                        style: AppTextStyles.body(size: 12, color: AppColors.ivoryDim)),
                  ],
                ),
              ),
              _sectionTitle(l.appLanguageSection),
              const _LanguageTile(),
              _sectionTitle(l.setCharges),
              _rateField(_chat, l.setChatRate, l.setPerMessage),
              const SizedBox(height: 12),
              _rateField(_call, l.setCallRate, l.setPerMinute),
              const SizedBox(height: 12),
              _rateField(_video, l.setVideoRate, l.setPerMinute),
              const SizedBox(height: 12),
              _rateField(_superChat, l.setSuperChatRate, l.setPerSuperChat,
                  errorText: _superChatError),
              _sectionTitle(l.setAboutYou),
              TextField(
                controller: _name,
                decoration: InputDecoration(labelText: l.setDisplayName),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _bio,
                maxLines: 4,
                maxLength: 2000,
                decoration: InputDecoration(
                  labelText: l.setBio,
                  alignLabelWithHint: true,
                  hintText: l.setBioHint,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _skills,
                decoration: InputDecoration(
                  labelText: l.setSkills,
                  hintText: l.setSkillsHint,
                  helperText: l.setCommaSeparated,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _languages,
                decoration: InputDecoration(
                  labelText: l.setLanguagesField,
                  hintText: l.setLanguagesHint,
                  helperText: l.setCommaSeparated,
                ),
              ),
              _sectionTitle(l.setKycDocsTitle),
              _kycDocumentsSection(l),
              const SizedBox(height: 28),
              PremiumPrimaryButton(
                label: _saving ? l.setSaving : l.setSaveChanges,
                icon: Icons.check,
                onPressed: _saving ? null : _save,
              ),
            ],
              ),
            ),
            ),
          ),
        ),
      ),
    );
  }

  /// Persistent banner shown while a profile edit is awaiting admin review
  /// (`status == 'pending'`, amber/info) or after it was rejected
  /// (`status == 'rejected'`, danger, with the reviewer's notes). The form
  /// below always shows the LIVE values — the backend keeps them unchanged
  /// until approval — and stays editable so a rejected edit can simply be
  /// resubmitted.
  Widget _pendingEditBanner(AppLocalizations l, Map<String, dynamic> pendingEdit) {
    final rejected = pendingEdit['status'] == 'rejected';
    final color = rejected ? AppColors.danger : AppColors.gold;
    final changes = pendingEdit['changes'];
    final fields = changes is Map
        ? changes.keys.map((k) => _fieldLabel(l, '$k')).join(', ')
        : '';
    final notes = rejected ? '${pendingEdit['reviewer_notes'] ?? ''}'.trim() : '';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(rejected ? Icons.error_outline : Icons.hourglass_top, size: 20, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rejected ? l.setPendingEditRejected : l.setPendingEditBanner,
                  style: AppTextStyles.body(size: 14, weight: FontWeight.w600, color: color),
                ),
                if (notes.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(notes, style: AppTextStyles.body(size: 12, color: AppColors.ivory)),
                ],
                if (fields.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    l.setPendingEditFields(fields),
                    style: AppTextStyles.body(size: 12, color: AppColors.ivoryDim),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Human-readable label for a `pending_edit.changes` key, reusing the same
  /// localized labels the form fields carry; unknown keys fall through as-is.
  String _fieldLabel(AppLocalizations l, String key) => switch (key) {
        'display_name' => l.setDisplayName,
        'bio' => l.setBio,
        'skills' => l.setSkills,
        'languages' => l.setLanguagesField,
        'rate_chat_per_msg' => l.setChatRate,
        'rate_call_per_min' => l.setCallRate,
        'rate_video_per_min' => l.setVideoRate,
        'super_chat_presets' => l.setSuperChatRate,
        'photo' || 'photo_url' || 'photo_key' => l.setDocPhoto,
        'mobile' => l.setFieldMobile,
        'country_code' => l.setFieldCountryCode,
        'kyc' => l.setFieldKyc,
        _ => key,
      };

  /// Opens the KYC form (pushed, so it can pop back here) and reloads the
  /// KYC status + session afterwards — an approved astrologer's resubmission
  /// stages a pending edit that the banner above should reflect immediately.
  Future<void> _openKycForm() async {
    await context.push('/kyc');
    if (mounted) await _refreshAll();
  }

  /// One-line payout summary from `GET /astrologer/kyc/status`: the method
  /// plus a masked target — the UPI ID with most of its handle hidden, or
  /// just the bank name (the status payload never carries the account
  /// number). Hidden entirely until a payout method has been submitted.
  Widget _payoutSummary(AppLocalizations l, Map<String, dynamic> kyc) {
    final method = kyc['payout_method'] as String?;
    if (method == null || method.isEmpty) return const SizedBox.shrink();
    final String target;
    if (method == 'upi') {
      target = _maskUpi(kyc['upi_id'] as String?);
    } else {
      target = (kyc['bank_name'] as String?) ?? '';
    }
    final methodLabel = method == 'upi' ? l.setPayoutUpi : l.setPayoutBank;
    return Row(
      children: [
        Icon(
          method == 'upi' ? Icons.qr_code_2 : Icons.account_balance_outlined,
          size: 18,
          color: AppColors.copperLight,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            target.isEmpty
                ? '${l.setPayoutMethodLabel}: $methodLabel'
                : '${l.setPayoutMethodLabel}: $methodLabel · $target',
            style: AppTextStyles.body(size: 13),
          ),
        ),
      ],
    );
  }

  /// `myhandle@bank` → `my•••@bank`; anything unparseable is masked wholesale.
  String _maskUpi(String? upi) {
    if (upi == null || upi.isEmpty) return '';
    final at = upi.indexOf('@');
    if (at <= 0) return '•••';
    final handle = upi.substring(0, at);
    final visible = handle.length <= 2 ? handle : handle.substring(0, 2);
    return '$visible•••${upi.substring(at)}';
  }

  /// The identity documents submitted with KYC, straight from
  /// `GET /astrologer/kyc/status`. View-only once `kyc_status == approved`
  /// (the backend rejects resubmission with 409 after approval); while
  /// pending/rejected a button routes to the KYC form to resubmit.
  Widget _kycDocumentsSection(AppLocalizations l) {
    final Widget body;
    if (_kycLoading) {
      body = const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    } else if (_kycError != null || _kyc == null) {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _kycError ?? l.setKycLoadFailed,
            style: AppTextStyles.body(size: 13, color: AppColors.danger),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _loadKycStatus,
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(l.commonRetry),
            ),
          ),
        ],
      );
    } else {
      final kyc = _kyc!;
      final status = kyc['kyc_status'] as String?;
      final docs = <(String, String?)>[
        (l.setDocPhoto, kyc['photo_url'] as String?),
        (l.setDocPan, kyc['pan_doc_url'] as String?),
        (l.setDocAadhaar, kyc['aadhaar_doc_url'] as String?),
        (l.setDocAadhaarBack, kyc['aadhaar_back_doc_url'] as String?),
        (l.setDocBankProof, kyc['bank_proof_url'] as String?),
        (l.setDocCertificate, kyc['certificate_url'] as String?),
      ];
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.setKycDocsSubtitle,
            style: AppTextStyles.body(size: 12, color: AppColors.ivoryDim),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [for (final (label, url) in docs) _docTile(l, label, url)],
          ),
          const SizedBox(height: 14),
          _payoutSummary(l, kyc),
          const SizedBox(height: 14),
          if (status == 'approved') ...[
            // Post-approval, KYC/payout edits are allowed but STAGED for
            // admin approval (the live details stay active meanwhile).
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: _openKycForm,
                icon: const Icon(Icons.upload_file, size: 18),
                label: Text(l.setKycUpdateButton),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l.setKycUpdateNote,
              style: AppTextStyles.body(size: 12, color: AppColors.ivoryDim),
            ),
          ] else
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: _openKycForm,
                icon: const Icon(Icons.upload_file, size: 18),
                label: Text(l.setKycResubmit),
              ),
            ),
        ],
      );
    }
    return PremiumCard(child: body);
  }

  /// One labeled document thumbnail; a null [url] renders a "Not uploaded"
  /// placeholder, otherwise tapping opens the full-screen [_openDocViewer].
  Widget _docTile(AppLocalizations l, String label, String? url) {
    const double side = 96;
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
            Icon(Icons.image_not_supported_outlined,
                size: 24, color: AppColors.ivoryFaint),
            const SizedBox(height: 6),
            Text(
              l.setKycNotUploaded,
              textAlign: TextAlign.center,
              style: AppTextStyles.body(size: 10, color: AppColors.ivoryFaint),
            ),
          ],
        ),
      );
    } else {
      preview = InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _openDocViewer(label, url),
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
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => Container(
              width: side,
              height: side,
              color: AppColors.surface2,
              child: Icon(Icons.broken_image_outlined,
                  size: 24, color: AppColors.ivoryFaint),
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
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.body(size: 11, color: AppColors.ivoryDim),
          ),
        ],
      ),
    );
  }

  /// Full-screen, pinch-to-zoom viewer for one KYC document.
  void _openDocViewer(String label, String url) =>
      showFullScreenImage(context, label: label, url: url);

  Widget _sectionTitle(String text) => SectionLabel(text);

  Widget _rateField(TextEditingController c, String label, String suffix,
          {String? errorText}) =>
      TextField(
        controller: c,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
        decoration:
            InputDecoration(labelText: label, suffixText: suffix, errorText: errorText),
      );
}

/// Language switcher. Reflects the current [LocaleCubit] choice and opens a
/// bottom sheet with English / हिन्दी / system-default; picking one persists the
/// choice and rebuilds the whole app in the new locale immediately.
class _LanguageTile extends StatelessWidget {
  const _LanguageTile();

  String _currentLabel(AppLocalizations l, Locale? locale) => switch (locale?.languageCode) {
        'en' => l.languageEnglish,
        'hi' => l.languageHindi,
        'bn' => l.languageBengali,
        'gu' => l.languageGujarati,
        'kn' => l.languageKannada,
        'ml' => l.languageMalayalam,
        'mr' => l.languageMarathi,
        'pa' => l.languagePunjabi,
        'ta' => l.languageTamil,
        'te' => l.languageTelugu,
        _ => l.languageSystem,
      };

  Future<void> _open(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final cubit = context.read<LocaleCubit>();
    final current = cubit.state;
    final selected = await showModalBottomSheet<({Locale? locale})>(
      context: context,
      backgroundColor: AppColors.indigoDeep,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(l.appLanguage, style: AppTextStyles.heading(size: 16)),
              ),
            ),
            // 10 languages + "system" can exceed the sheet height on small
            // phones — keep the list scrollable so no tile is clipped.
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _option(context, l.languageEnglish, const Locale('en'), current),
                    _option(context, l.languageHindi, const Locale('hi'), current),
                    _option(context, l.languageBengali, const Locale('bn'), current),
                    _option(context, l.languageGujarati, const Locale('gu'), current),
                    _option(context, l.languageKannada, const Locale('kn'), current),
                    _option(context, l.languageMalayalam, const Locale('ml'), current),
                    _option(context, l.languageMarathi, const Locale('mr'), current),
                    _option(context, l.languagePunjabi, const Locale('pa'), current),
                    _option(context, l.languageTamil, const Locale('ta'), current),
                    _option(context, l.languageTelugu, const Locale('te'), current),
                    _option(context, l.languageSystem, null, current),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    if (selected != null) await cubit.setLocale(selected.locale);
  }

  Widget _option(BuildContext context, String label, Locale? locale, Locale? current) {
    final active = current?.languageCode == locale?.languageCode;
    return ListTile(
      title: Text(label, style: AppTextStyles.body(size: 14)),
      trailing: active ? const Icon(Icons.check, color: AppColors.saffron) : null,
      onTap: () => Navigator.pop(context, (locale: locale)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locale = context.watch<LocaleCubit>().state;
    return PremiumCard(
      onTap: () => _open(context),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          const IconTile(Icons.translate, tone: TileTone.info),
          const SizedBox(width: 14),
          Expanded(
            child: Text(l.appLanguage, style: AppTextStyles.body(size: 15)),
          ),
          Text(
            _currentLabel(l, locale),
            style: AppTextStyles.label(size: 12, color: AppColors.saffronBright),
          ),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right, color: AppColors.ivoryFaint),
        ],
      ),
    );
  }
}
