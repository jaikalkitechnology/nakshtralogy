import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hj_core/hj_core.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/premium_ui.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/full_screen_image_viewer.dart';
import '../../auth/astro_session_cubit.dart';
import '../../portal/portal_repository.dart';

/// First-class, profile-section entry for editing the astrologer's public
/// profile: display name, bio, skills, languages, chat/call/video rates, the
/// single Super Chat price and the avatar. Reuses the exact same backend
/// contract as Settings — `PATCH /astrologer/me` ([PortalRepository.updateProfile])
/// and `POST /astrologer/me/avatar` ([PortalRepository.uploadAvatar]) — so there
/// is no new endpoint or payload shape here.
///
/// Once the astrologer is KYC-approved the backend STAGES publicly-visible
/// edits for admin approval instead of applying them immediately; that state is
/// surfaced by the pending-edit banner at the top (mirroring Settings) and by
/// the "submitted for approval" SnackBar after a save. The KYC/payout documents
/// and app language live on Settings / the dedicated Bank & PAN screen, not here.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _repo = getIt<PortalRepository>();

  late final TextEditingController _name;
  late final TextEditingController _bio;
  late final TextEditingController _skills;
  late final TextEditingController _languages;
  late final TextEditingController _experience;
  late final TextEditingController _chat;
  late final TextEditingController _call;
  late final TextEditingController _video;

  /// Single Super Chat price (decimal string). The platform stores ONE price
  /// per astrologer as a one-element `super_chat_presets` list — same shape
  /// Settings and the signup step send; empty disables Super Chat.
  late final TextEditingController _superChat;

  bool _saving = false;
  bool _uploading = false;

  /// Snapshot of the GATED (admin-reviewed) fields as last saved/loaded. Used
  /// to tell whether THIS save actually touched a gated field — if only the
  /// charges changed, the save applies immediately and must NOT claim it's
  /// waiting for admin approval. Refreshed after every successful save.
  late String _savedName;
  late String _savedBio;
  late String _savedSkills;
  late String _savedLanguages;
  late String _savedExperience;

  void _snapshotGated() {
    _savedName = _name.text;
    _savedBio = _bio.text;
    _savedSkills = _skills.text;
    _savedLanguages = _languages.text;
    _savedExperience = _experience.text;
  }

  /// True if any gated field differs from the last saved snapshot. Charges
  /// (chat/call/video/Super Chat) are deliberately excluded — they never need
  /// approval.
  bool get _gatedChanged =>
      _name.text != _savedName ||
      _bio.text != _savedBio ||
      _skills.text != _savedSkills ||
      _languages.text != _savedLanguages ||
      _experience.text != _savedExperience;

  /// Inline validation error for [_superChat]; cleared as soon as the field
  /// is edited again.
  String? _superChatError;

  @override
  void initState() {
    super.initState();
    final a = getIt<AstroSessionCubit>().state.astrologer;
    _name = TextEditingController(text: a?.displayName ?? '');
    _bio = TextEditingController(text: a?.bio ?? '');
    _skills = TextEditingController(text: a?.skills.join(', ') ?? '');
    _languages = TextEditingController(text: a?.languages.join(', ') ?? '');
    _experience = TextEditingController(
        text: (a?.yearsExperience ?? 0) > 0 ? '${a!.yearsExperience}' : '');
    _chat = TextEditingController(text: a?.rateChatPerMsg ?? '0.00');
    _call = TextEditingController(text: a?.rateCallPerMin ?? '0.00');
    _video = TextEditingController(text: a?.rateVideoPerMin ?? '0.00');
    final presets = a?.superChatPresets ?? const <String>[];
    _superChat = TextEditingController(text: presets.isEmpty ? '' : presets.first);
    _superChat.addListener(() {
      if (_superChatError != null) setState(() => _superChatError = null);
    });
    _snapshotGated();
  }

  @override
  void dispose() {
    _name.dispose();
    _bio.dispose();
    _skills.dispose();
    _languages.dispose();
    _experience.dispose();
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
    // Client-side mirror of the backend `_validate_presets` bounds (> 0,
    // platform ceiling ₹10000) — fails fast with an inline reason; the
    // backend still re-validates and the catch below surfaces its message.
    final superChat = double.tryParse(_superChat.text.trim());
    if (superChat == null || superChat <= 0) {
      setState(() => _superChatError = l.setSuperChatInvalid);
      return;
    }
    if (superChat > 10000) {
      setState(() => _superChatError = l.setSuperChatMax);
      return;
    }
    // Captured BEFORE the await so the message reflects THIS save: charges-only
    // edits apply immediately and must read "updated", not "pending approval".
    final gatedChanged = _gatedChanged;
    setState(() => _saving = true);
    try {
      final updated = await _repo.updateProfile({
        // Omitted when blanked — the backend derives `profile_completed`
        // from display_name, so never clear it accidentally.
        if (_name.text.trim().isNotEmpty) 'display_name': _name.text.trim(),
        'bio': _bio.text.trim(),
        'skills': _splitList(_skills.text),
        'languages': _splitList(_languages.text),
        'years_experience': int.tryParse(_experience.text.trim()) ?? 0,
        'rate_chat_per_msg': _chat.text.trim(),
        'rate_call_per_min': _call.text.trim(),
        'rate_video_per_min': _video.text.trim(),
        'super_chat_presets': [superChat.toStringAsFixed(2)],
      });
      session.update(updated);
      // Only a GATED change that the backend actually staged waits for admin
      // approval. A charges-only save (chat/call/video/Super Chat) applies
      // immediately, so it always reads "updated" — even if an unrelated
      // profile edit is still pending from before.
      final pendingApproval =
          gatedChanged && updated.pendingEdit?['status'] == 'pending';
      messenger.showSnackBar(SnackBar(
        content: Text(pendingApproval ? l.setChangesPendingApproval : l.setProfileUpdated),
      ));
      // Re-baseline so a follow-up charges-only save doesn't re-report the
      // (now-submitted) gated change as pending again.
      _snapshotGated();
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
        maxWidth: 1024,
        imageQuality: 85,
      );
      if (picked == null) return;
      setState(() => _uploading = true);
      final bytes = await picked.readAsBytes();
      final updated = await _repo.uploadAvatar(bytes, picked.name);
      session.update(updated);
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
      appBar: AppBar(title: Text(l.editProfileTitle)),
      body: CosmicBackground(
        child: SafeArea(
          top: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                children: [
                  Text(l.editProfileSubtitle,
                      style: AppTextStyles.body(size: 13, color: AppColors.ivoryDim)),
                  const SizedBox(height: 20),
                  if (pendingEdit != null) ...[
                    _pendingEditBanner(l, pendingEdit),
                    const SizedBox(height: 20),
                  ],
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Soft outer ring.
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.gold.withValues(alpha: 0.12), width: 1),
                              ),
                              // Gold ring wrapping the avatar.
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColors.gold.withValues(alpha: 0.4), width: 2),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: AppColors.goldHalo,
                                      blurRadius: 24,
                                      spreadRadius: -4,
                                    ),
                                  ],
                                ),
                                child: GestureDetector(
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
                                            (name?.isNotEmpty ?? false)
                                                ? name![0].toUpperCase()
                                                : '🪔',
                                            style: AppTextStyles.display(size: 30),
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColors.indigoVoid, width: 2),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: AppColors.saffronHalo,
                                      blurRadius: 14,
                                      spreadRadius: -3,
                                    ),
                                  ],
                                ),
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
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 2, color: Colors.white))
                                          : const Icon(Icons.camera_alt,
                                              size: 16, color: Colors.white),
                                    ),
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
                  SectionLabel(l.setAboutYou),
                  PremiumCard(
                    child: Column(
                      children: [
                        TextField(
                          controller: _name,
                          decoration: _dec(l.setDisplayName),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _bio,
                          maxLines: 4,
                          maxLength: 2000,
                          decoration: _dec(
                            l.setBio,
                            hint: l.setBioHint,
                            alignLabelWithHint: true,
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextField(
                          controller: _skills,
                          decoration: _dec(
                            l.setSkills,
                            hint: l.setSkillsHint,
                            helper: l.setCommaSeparated,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _languages,
                          decoration: _dec(
                            l.setLanguagesField,
                            hint: l.setLanguagesHint,
                            helper: l.setCommaSeparated,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _experience,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),
                          ],
                          decoration: _dec(l.profileExperience),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  SectionLabel(l.setCharges),
                  PremiumCard(
                    child: Column(
                      children: [
                        _rateField(_chat, l.setChatRate, l.setPerMessage),
                        const SizedBox(height: 16),
                        _rateField(_call, l.setCallRate, l.setPerMinute),
                        const SizedBox(height: 16),
                        _rateField(_video, l.setVideoRate, l.setPerMinute),
                        const SizedBox(height: 16),
                        _rateField(_superChat, l.setSuperChatRate, l.setPerSuperChat,
                            errorText: _superChatError),
                      ],
                    ),
                  ),
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
    );
  }

  /// Persistent banner while a profile edit awaits admin review
  /// (`status == 'pending'`, gold) or after it was rejected
  /// (`status == 'rejected'`, danger, with the reviewer's notes) — the form
  /// below always shows the LIVE values (the backend keeps them until
  /// approval) and stays editable so a rejected edit can be resubmitted.
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
        'years_experience' => l.profileExperience,
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

  /// Shared premium field decoration — gold label, filled glassy surface,
  /// soft copper hairline that warms to saffron on focus. Purely visual; the
  /// fields keep their own controllers, formatters and validators.
  InputDecoration _dec(
    String label, {
    String? hint,
    String? helper,
    String? suffix,
    String? errorText,
    bool alignLabelWithHint = false,
  }) {
    OutlineInputBorder border(Color color, [double width = 1]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: color, width: width),
        );
    return InputDecoration(
      labelText: label,
      hintText: hint,
      helperText: helper,
      suffixText: suffix,
      errorText: errorText,
      alignLabelWithHint: alignLabelWithHint,
      filled: true,
      fillColor: AppColors.surface1,
      labelStyle: AppTextStyles.label(size: 13, color: AppColors.gold),
      floatingLabelStyle: AppTextStyles.label(size: 13, color: AppColors.saffron),
      suffixStyle: AppTextStyles.label(size: 12, color: AppColors.gold),
      hintStyle: AppTextStyles.body(size: 13, color: AppColors.ivoryFaint),
      helperStyle: AppTextStyles.body(size: 11, color: AppColors.ivoryDim),
      enabledBorder: border(AppColors.borderSoft),
      border: border(AppColors.borderSoft),
      focusedBorder: border(AppColors.saffron, 1.5),
    );
  }

  Widget _rateField(TextEditingController c, String label, String suffix,
          {String? errorText}) =>
      TextField(
        controller: c,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
        decoration: _dec(label, suffix: suffix, errorText: errorText),
      );
}
