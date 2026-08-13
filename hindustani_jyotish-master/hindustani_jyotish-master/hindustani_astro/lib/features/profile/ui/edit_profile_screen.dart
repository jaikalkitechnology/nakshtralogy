import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hj_core/hj_core.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
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
  late final TextEditingController _chat;
  late final TextEditingController _call;
  late final TextEditingController _video;

  /// Single Super Chat price (decimal string). The platform stores ONE price
  /// per astrologer as a one-element `super_chat_presets` list — same shape
  /// Settings and the signup step send; empty disables Super Chat.
  late final TextEditingController _superChat;

  bool _saving = false;
  bool _uploading = false;

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
    _chat = TextEditingController(text: a?.rateChatPerMsg ?? '0.00');
    _call = TextEditingController(text: a?.rateCallPerMin ?? '0.00');
    _video = TextEditingController(text: a?.rateVideoPerMin ?? '0.00');
    final presets = a?.superChatPresets ?? const <String>[];
    _superChat = TextEditingController(text: presets.isEmpty ? '' : presets.first);
    _superChat.addListener(() {
      if (_superChatError != null) setState(() => _superChatError = null);
    });
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
    setState(() => _saving = true);
    try {
      final updated = await _repo.updateProfile({
        // Omitted when blanked — the backend derives `profile_completed`
        // from display_name, so never clear it accidentally.
        if (_name.text.trim().isNotEmpty) 'display_name': _name.text.trim(),
        'bio': _bio.text.trim(),
        'skills': _splitList(_skills.text),
        'languages': _splitList(_languages.text),
        'rate_chat_per_msg': _chat.text.trim(),
        'rate_call_per_min': _call.text.trim(),
        'rate_video_per_min': _video.text.trim(),
        'super_chat_presets': [superChat.toStringAsFixed(2)],
      });
      session.update(updated);
      // KYC-approved astrologers have these edits held for admin approval.
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
                          children: [
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
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2, color: Colors.white))
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
                  const SizedBox(height: 28),
                  _sectionTitle(l.setAboutYou),
                  const SizedBox(height: 12),
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
                  const SizedBox(height: 28),
                  _sectionTitle(l.setCharges),
                  const SizedBox(height: 12),
                  _rateField(_chat, l.setChatRate, l.setPerMessage),
                  const SizedBox(height: 12),
                  _rateField(_call, l.setCallRate, l.setPerMinute),
                  const SizedBox(height: 12),
                  _rateField(_video, l.setVideoRate, l.setPerMinute),
                  const SizedBox(height: 12),
                  _rateField(_superChat, l.setSuperChatRate, l.setPerSuperChat,
                      errorText: _superChatError),
                  const SizedBox(height: 28),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                    onPressed: _saving ? null : _save,
                    icon: _saving
                        ? const SizedBox(
                            width: 18, height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.check),
                    label: Text(_saving ? l.setSaving : l.setSaveChanges),
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

  Widget _sectionTitle(String text) =>
      Text(text, style: AppTextStyles.heading(size: 16, color: AppColors.copperLight));

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
