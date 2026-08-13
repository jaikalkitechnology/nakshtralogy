import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hj_core/hj_core.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/responsive.dart';
import '../../../shared/widgets/cosmic_background.dart';

/// Complete Profile after the first login — per spec §2 this collects ONLY the
/// profile name and the contact number (country-code picker per §1). Birth
/// date/time/place moved to Profile → Birth details; they only feed the
/// Kundli/insights features, not the signup gate.
class ProfileCompletionScreen extends StatefulWidget {
  const ProfileCompletionScreen({super.key});

  @override
  State<ProfileCompletionScreen> createState() => _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState extends State<ProfileCompletionScreen> {
  final _name = TextEditingController();
  final _mobile = TextEditingController();
  String _dialCode = '+91';
  bool _saving = false;
  bool _uploadingPhoto = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Prefill from the session user: Google users usually arrive with a name,
    // mobile-OTP users with a number. Older accounts may have the dial code
    // baked into `mobile` (e.g. "+919000000000") — split it back out.
    final user = getIt<AuthCubit>().state.user;
    _name.text = user?.name ?? '';
    var mobile = user?.mobile ?? '';
    if (user?.countryCode != null) {
      _dialCode = user!.countryCode!;
    } else if (mobile.startsWith('+')) {
      // Longest dial code first so "+91..." doesn't match a shorter prefix.
      final codes = kCountryCodes.map((c) => c.dialCode).toList()
        ..sort((a, b) => b.length.compareTo(a.length));
      for (final code in codes) {
        if (mobile.startsWith(code)) {
          _dialCode = code;
          mobile = mobile.substring(code.length);
          break;
        }
      }
    }
    _mobile.text = mobile.replaceAll(RegExp(r'\D'), '');
  }

  @override
  void dispose() {
    _name.dispose();
    _mobile.dispose();
    super.dispose();
  }

  /// Client-side mirror of the backend rule: +91 → exactly 10 digits, any
  /// other dial code → 4–15 digits. Returns the error message, or null if ok.
  String? _validate(AppLocalizations l) {
    if (_name.text.trim().isEmpty) return l.completeProfileNameRequired;
    final digits = _mobile.text.trim();
    if (_dialCode == '+91') {
      if (!RegExp(r'^\d{10}$').hasMatch(digits)) return l.completeProfileMobileIndia;
    } else {
      if (!RegExp(r'^\d{4,15}$').hasMatch(digits)) return l.completeProfileMobileGeneric;
    }
    return null;
  }

  /// Optional DP step — picks + uploads immediately via `POST /me/avatar` so
  /// the picture is set as soon as it's chosen, independent of "Save &
  /// Continue" (which only covers the name + contact fields).
  Future<void> _pickPhoto() async {
    final l = AppLocalizations.of(context);
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        imageQuality: 85,
      );
      if (picked == null) return;
      setState(() => _uploadingPhoto = true);
      final bytes = await picked.readAsBytes();
      final user = await getIt<AuthRepository>().uploadAvatar(bytes, picked.name);
      getIt<AuthCubit>().updateUser(user);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (e) {
      if (mounted) setState(() => _error = l.completeProfilePhotoUploadFailed);
    } finally {
      if (mounted) setState(() => _uploadingPhoto = false);
    }
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    final validation = _validate(l);
    if (validation != null) {
      setState(() => _error = validation);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final user = await getIt<AuthRepository>().updateProfile({
        'name': _name.text.trim(),
        'mobile': _mobile.text.trim(),
        'country_code': _dialCode,
      });
      getIt<AuthCubit>().updateUser(user);
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: CenteredMaxWidth(
            maxWidth: Responsive.readableMaxWidth,
            child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.completeProfileTitle, style: AppTextStyles.display(size: 26)),
                const SizedBox(height: 8),
                Text(l.completeProfileSubtitle,
                    style: AppTextStyles.body(color: AppColors.ivoryDim)),
                const SizedBox(height: 28),
                Center(child: _PhotoPicker(
                  uploading: _uploadingPhoto,
                  avatarUrl: getIt<AuthCubit>().state.user?.avatarUrl,
                  name: getIt<AuthCubit>().state.user?.name,
                  onTap: _pickPhoto,
                )),
                const SizedBox(height: 28),
                TextField(
                  controller: _name,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(labelText: l.completeProfileFullName),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CountryCodePicker(
                      dialCode: _dialCode,
                      enabled: !_saving,
                      onChanged: (c) => setState(() => _dialCode = c.dialCode),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _mobile,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(15),
                        ],
                        decoration: InputDecoration(
                          labelText: l.completeProfileContactNumber,
                          // Surface the +91 rule up front instead of only on error.
                          helperText: _dialCode == '+91' ? l.completeProfileMobileIndia : null,
                          helperStyle:
                              AppTextStyles.body(size: 11, color: AppColors.ivoryFaint),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_error != null) ...[
                  const SizedBox(height: 14),
                  Text(_error!, style: AppTextStyles.body(size: 13, color: AppColors.danger)),
                ],
                const SizedBox(height: 28),
                ElevatedButton(
      // Explicit full width: the shared theme no longer forces an
      // (invalid) infinite minimum width on every ElevatedButton.
      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(l.completeProfileSaveContinue),
                ),
              ],
            ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Optional profile-photo (DP) picker — tap the camera badge to pick from
/// the gallery and upload immediately via `POST /me/avatar`.
class _PhotoPicker extends StatelessWidget {
  const _PhotoPicker({
    required this.uploading,
    required this.avatarUrl,
    required this.name,
    required this.onTap,
  });

  final bool uploading;
  final String? avatarUrl;
  final String? name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final hasPhoto = avatarUrl != null && avatarUrl!.isNotEmpty;
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 44,
              backgroundColor: AppColors.surface2,
              backgroundImage: hasPhoto ? NetworkImage(avatarUrl!) : null,
              child: hasPhoto
                  ? null
                  : Text(
                      (name?.isNotEmpty ?? false) ? name![0].toUpperCase() : '🪔',
                      style: AppTextStyles.display(size: 28),
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
                  onTap: uploading ? null : onTap,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: uploading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          hasPhoto ? l.completeProfilePhotoChange : l.completeProfilePhotoAdd,
          style: AppTextStyles.body(size: 12, color: AppColors.ivoryDim),
        ),
      ],
    );
  }
}
