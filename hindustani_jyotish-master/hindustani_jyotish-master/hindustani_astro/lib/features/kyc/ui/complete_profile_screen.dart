import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hj_core/hj_core.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/di.dart';
import '../../../shared/avatar_compress.dart';
import '../../../shared/responsive.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../auth/astro_session_cubit.dart';
import '../../portal/portal_repository.dart';

/// Step 1 of onboarding — the basic profile (photo, name, bio, skills,
/// languages, rates), saved via `PATCH /astrologer/me`. On success this
/// screen navigates to `/kyc` ITSELF — the router's redirect deliberately
/// returns null for any location already inside the onboarding trio
/// (`/profile/complete`, `/kyc`, `/review`; see app_router.dart's
/// `inOnboarding`), so a session update alone never moves the astrologer
/// off this screen: relying on that (as this screen originally did) left
/// the Continue button saving successfully but visibly doing nothing.
///
/// Deliberately split from [KycFormScreen] — the two save to different
/// endpoints (`PATCH /astrologer/me` vs `POST /astrologer/kyc`) and the
/// product flow is "profile first, then formal KYC/documents" rather than
/// one combined form. `years_experience` lives on the KYC screen instead:
/// `AstrologerProfileUpdate` (the schema behind `PATCH /astrologer/me`)
/// doesn't carry it, only `KYCSubmit` does.
class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _name = TextEditingController();
  final _mobile = TextEditingController();
  final _skills = TextEditingController(text: 'vedic');
  final _languages = TextEditingController(text: 'hi, en');
  final _bio = TextEditingController();
  // No pre-filled amounts: the astrologer chooses their own rates freely
  // (any value > 0) — a hardcoded starting figure read as a platform-imposed
  // minimum, which it never was.
  final _rateChat = TextEditingController();
  final _rateCall = TextEditingController();
  final _rateVideo = TextEditingController();
  final _superChat = TextEditingController();

  final _repo = getIt<PortalRepository>();

  bool _saving = false;
  String? _error;

  bool _photoUploading = false;
  String? _photoUrl;

  /// Selected dial code for the contact number — defaults to India, the
  /// primary market. Client-side mirror of the backend rule: +91 → exactly
  /// 10 digits, any other code → 4–15 digits.
  String _dialCode = '+91';

  @override
  void initState() {
    super.initState();
    // Prefill from the session (e.g. an OTP signup already has a mobile).
    final astro = context.read<AstroSessionCubit>().state.astrologer;
    if (astro?.mobile != null && astro!.mobile!.isNotEmpty) {
      _mobile.text = astro.mobile!;
    }
    if (astro?.countryCode != null && astro!.countryCode!.isNotEmpty) {
      _dialCode = astro.countryCode!;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _mobile.dispose();
    _skills.dispose();
    _languages.dispose();
    _bio.dispose();
    _rateChat.dispose();
    _rateCall.dispose();
    _rateVideo.dispose();
    _superChat.dispose();
    super.dispose();
  }

  List<String> _split(String s) =>
      s.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

  Future<void> _pickPhoto() async {
    setState(() => _error = null);
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 90, // re-encodes HEIC/PNG to JPEG on-device first
      );
      if (picked == null) return;
      setState(() => _photoUploading = true);
      final raw = await picked.readAsBytes();
      // Accept any photo of any size — shrink it to a ≤200 KB JPEG on-device so
      // the upload never fails on size/format, then save.
      final c = await compressAvatar(raw, sourceName: picked.name);
      final astro = await _repo.uploadAvatar(c?.bytes ?? raw, c?.filename ?? picked.name);
      if (mounted) context.read<AstroSessionCubit>().update(astro);
      setState(() => _photoUrl = astro.photoUrl);
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = 'Could not upload the photo: $e');
    } finally {
      if (mounted) setState(() => _photoUploading = false);
    }
  }

  /// Mirrors the backend's `PATCH /astrologer/me` rule: +91 → exactly 10
  /// digits; any other dial code → 4–15 digits. Returns an error message, or
  /// null when [digits] is valid for [_dialCode].
  String? _mobileError(String digits) {
    if (digits.isEmpty) return 'Contact number is required.';
    if (!RegExp(r'^\d+$').hasMatch(digits)) {
      return 'The contact number must contain digits only.';
    }
    if (_dialCode == '+91') {
      if (digits.length != 10) {
        return 'Enter a valid 10-digit mobile number for +91.';
      }
    } else if (digits.length < 4 || digits.length > 15) {
      return 'Enter a valid mobile number (4–15 digits).';
    }
    return null;
  }

  Future<void> _submit() async {
    if (_name.text.trim().isEmpty) {
      setState(() => _error = 'Full name is required.');
      return;
    }
    final mobile = _mobile.text.trim();
    final mobileError = _mobileError(mobile);
    if (mobileError != null) {
      setState(() => _error = mobileError);
      return;
    }
    if (_photoUrl == null || _photoUrl!.isEmpty) {
      setState(() => _error = 'Please upload a profile photo.');
      return;
    }
    // The backend derives `profile_completed` from display_name, photo, BIO,
    // skills, languages, and all three rates (see Astrologer.profile_completed
    // in app/models/astrologer.py) — every one of those must be validated
    // here, or the save "succeeds" while profile_completed stays false and
    // the astrologer is silently stuck on this step with no visible error.
    if (_bio.text.trim().isEmpty) {
      setState(() => _error = 'A short bio is required.');
      return;
    }
    if (_split(_skills.text).isEmpty) {
      setState(() => _error = 'At least one skill is required.');
      return;
    }
    if (_split(_languages.text).isEmpty) {
      setState(() => _error = 'At least one language is required.');
      return;
    }
    for (final (c, label) in [
      (_rateChat, 'chat'),
      (_rateCall, 'call'),
      (_rateVideo, 'video'),
    ]) {
      final v = double.tryParse(c.text.trim());
      if (v == null || v <= 0) {
        setState(() => _error = 'Enter a valid $label rate (greater than 0).');
        return;
      }
    }
    // Single Super Chat price, stored as a one-element preset list (the
    // platform uses ONE price per astrologer; Settings edits the same single
    // value afterwards). Same bounds as the backend's preset validation
    // (> 0, platform ceiling ₹10000).
    final superChat = double.tryParse(_superChat.text.trim());
    if (superChat == null || superChat <= 0) {
      setState(() => _error = 'Enter a valid Super Chat price (greater than 0).');
      return;
    }
    if (superChat > 10000) {
      setState(() => _error = 'The Super Chat price must not exceed ₹10000.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final updated = await _repo.updateProfile({
        'display_name': _name.text.trim(),
        'mobile': mobile,
        'country_code': _dialCode,
        'bio': _bio.text.trim(),
        'skills': _split(_skills.text),
        'languages': _split(_languages.text),
        'rate_chat_per_msg': _rateChat.text.trim(),
        'rate_call_per_min': _rateCall.text.trim(),
        'rate_video_per_min': _rateVideo.text.trim(),
        'super_chat_presets': [superChat.toStringAsFixed(2)],
      });
      if (!mounted) return;
      context.read<AstroSessionCubit>().update(updated);
      if (updated.profileCompleted) {
        // Explicit navigation — the router's redirect deliberately doesn't
        // move between onboarding steps (see the class doc comment).
        context.go('/kyc');
      } else {
        // Defensive: the client-side checks above should make this
        // unreachable, but if the backend's completeness rules ever gain a
        // field this form doesn't collect, showing SOMETHING beats the
        // button silently doing nothing again.
        setState(() =>
            _error = 'Profile saved, but something is still missing. Please review every field.');
      }
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      // Non-API failure (unexpected response shape, etc.) — must still be
      // surfaced, or the button appears to do nothing.
      setState(() => _error = 'Could not save the profile: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Text('STEP 1 OF 2',
                      style: AppTextStyles.label(size: 11, color: AppColors.saffronBright)),
                ),
              ),
              const SizedBox(height: 10),
              Text('Complete your profile', style: AppTextStyles.display(size: 24)),
              const SizedBox(height: 6),
              Text('Tell seekers who you are before we move on to verification.',
                  style: AppTextStyles.body(color: AppColors.ivoryDim)),
              const SizedBox(height: 20),
              Center(child: _photoPicker()),
              const SizedBox(height: 16),
              _field(_name, 'Full name'),
              _contactField(),
              _field(_skills, 'Skills (comma separated)'),
              _field(_languages, 'Languages (comma separated)'),
              _field(_bio, 'Short bio (required)', lines: 2),
              Row(children: [
                Expanded(child: _field(_rateChat, 'Chat ₹/msg', number: true)),
                const SizedBox(width: 10),
                Expanded(child: _field(_rateCall, 'Call ₹/min', number: true)),
                const SizedBox(width: 10),
                Expanded(child: _field(_rateVideo, 'Video ₹/min', number: true)),
              ]),
              _field(_superChat, 'Super Chat price ₹', number: true),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: AppTextStyles.body(size: 13, color: AppColors.danger)),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
      // Explicit full width: the shared theme no longer forces an
      // (invalid) infinite minimum width on every ElevatedButton.
      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                onPressed: _saving ? null : _submit,
                child: _saving
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Continue'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.read<AstroSessionCubit>().logout(),
                child: Text('Sign out', style: AppTextStyles.label(color: AppColors.ivoryDim)),
              ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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

  /// Contact number with the shared country-code picker (hj_core). Shows a
  /// live length error via [_mobileError] the moment the typed value can't be
  /// valid for the selected dial code — same reactive pattern as the KYC
  /// form's `_validatedField`.
  Widget _contactField() => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CountryCodePicker(
              dialCode: _dialCode,
              onChanged: (c) => setState(() => _dialCode = c.dialCode),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _mobile,
                builder: (context, value, _) {
                  final text = value.text.trim();
                  final error = text.isEmpty ? null : _mobileError(text);
                  return TextField(
                    controller: _mobile,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Contact number',
                      errorText: error,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );

  /// Profile photo (required) — tap the avatar to pick from gallery; uploads
  /// immediately, same as SettingsScreen's avatar picker.
  Widget _photoPicker() => Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderMid, width: 1.5),
                ),
                child: CircleAvatar(
                radius: 44,
                backgroundColor: AppColors.indigoMid,
                backgroundImage:
                    (_photoUrl != null && _photoUrl!.isNotEmpty) ? NetworkImage(_photoUrl!) : null,
                child: (_photoUrl == null || _photoUrl!.isEmpty)
                    ? Icon(Icons.person_outline, size: 36, color: AppColors.ivoryDim)
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
                    onTap: _photoUploading ? null : _pickPhoto,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: _photoUploading
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
          const SizedBox(height: 8),
          Text('Profile photo (required)',
              style: AppTextStyles.body(size: 12, color: AppColors.ivoryDim)),
        ],
      );
}
