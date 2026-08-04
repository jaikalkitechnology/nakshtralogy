import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../services/google_auth_service.dart';
import '../../widgets/language_selector.dart';
import '../home/home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _displayNameCtrl = TextEditingController();
  final _expCtrl = TextEditingController();
  final _qualCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  bool _obscure = true;

  // Backend enum values — not localized.
  final List<String> _allLanguages = ['Hindi', 'English', 'Sanskrit', 'Gujarati', 'Marathi', 'Tamil', 'Telugu', 'Bengali'];
  final List<String> _allSpecs = ['Vedic Astrology', 'Numerology', 'Tarot', 'Palmistry', 'Vastu Shastra', 'Kundli Matching', 'Horoscope'];
  final Set<String> _selectedLangs = {};
  final Set<String> _selectedSpecs = {};

  void _signup() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(AuthSignupRequested(
      name: _nameCtrl.text.trim(), email: _emailCtrl.text.trim(), password: _passCtrl.text,
      phone: _phoneCtrl.text.trim().isNotEmpty ? _phoneCtrl.text.trim() : null,
      displayName: _displayNameCtrl.text.trim().isNotEmpty ? _displayNameCtrl.text.trim() : null,
      experienceYears: int.tryParse(_expCtrl.text.trim()),
      languages: _selectedLangs.toList(), specializations: _selectedSpecs.toList(),
      qualification: _qualCtrl.text.trim().isNotEmpty ? _qualCtrl.text.trim() : null,
      bio: _bioCtrl.text.trim().isNotEmpty ? _bioCtrl.text.trim() : null,
    ));
  }

  /// Continue with Google — server-side redirect on every platform (web tab
  /// redirect / mobile external browser → `nakshatralogyastro://auth/callback`
  /// deep link, adopted by the app_links listener in main.dart). First-time
  /// astrologers land on HomeScreen, whose KYC gate starts onboarding. Reuses the
  /// web OAuth client — no native Google config / SHA-1 required.
  Future<void> _googleSignIn() async {
    final l = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(l.googleRedirecting), duration: const Duration(seconds: 2)));
    final ok = kIsWeb
        ? await GoogleAuthService().startWebRedirect()
        : await GoogleAuthService().startMobileServerRedirect();
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(l.googleWebLoginFailed), backgroundColor: AppColors.error));
    }
  }

  @override
  void dispose() { _nameCtrl.dispose(); _emailCtrl.dispose(); _phoneCtrl.dispose(); _passCtrl.dispose(); _confirmCtrl.dispose(); _displayNameCtrl.dispose(); _expCtrl.dispose(); _qualCtrl.dispose(); _bioCtrl.dispose(); super.dispose(); }

  Widget _chipSelector(String label, List<String> options, Set<String> selected) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
      const SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 8, children: options.map((opt) {
        final isSelected = selected.contains(opt);
        return FilterChip(label: Text(opt, style: TextStyle(color: isSelected ? Colors.black : AppColors.textSecondary, fontSize: 13)), selected: isSelected, selectedColor: AppColors.primary, backgroundColor: AppColors.surface, side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border), onSelected: (val) => setState(() => val ? selected.add(opt) : selected.remove(opt)));
      }).toList()),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false);
        else if (state is AuthFailure) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.error));
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary), onPressed: () => Navigator.pop(context)),
          actions: [
            TextButton.icon(
              onPressed: () => LanguageSelector.show(context),
              icon: const Icon(Icons.language, size: 18, color: AppColors.primary),
              label: Text(l.selectLanguage, style: const TextStyle(color: AppColors.primary, fontSize: 13)),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(children: [
              const SizedBox(height: 12),
              const Text('\u{1f52e}', style: TextStyle(fontSize: 44)),
              const SizedBox(height: 8),
              Text(l.registerAsAstrologer, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontSize: 22)),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)),
                child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(l.personalInfo, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 16),
                  TextFormField(controller: _nameCtrl, decoration: InputDecoration(labelText: l.fullNameLabel, prefixIcon: const Icon(Icons.person_outline, color: AppColors.textSecondary)), validator: (v) => (v == null || v.length < 2) ? l.requiredField : null),
                  const SizedBox(height: 12),
                  TextFormField(controller: _emailCtrl, keyboardType: TextInputType.emailAddress, decoration: InputDecoration(labelText: l.email, prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary)), validator: (v) => (v == null || !v.contains('@')) ? l.validEmailRequired : null),
                  const SizedBox(height: 12),
                  TextFormField(controller: _phoneCtrl, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: l.phoneOptional, prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.textSecondary))),
                  const SizedBox(height: 12),
                  TextFormField(controller: _passCtrl, obscureText: _obscure, decoration: InputDecoration(labelText: l.password, prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary), suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: AppColors.textSecondary), onPressed: () => setState(() => _obscure = !_obscure))), validator: (v) => (v == null || v.length < 6) ? l.minSixChars : null),
                  const SizedBox(height: 12),
                  TextFormField(controller: _confirmCtrl, obscureText: true, decoration: InputDecoration(labelText: l.confirmPassword, prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary)), validator: (v) => v != _passCtrl.text ? l.passwordsDoNotMatch : null),
                  const SizedBox(height: 24),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 16),
                  Text(l.professionalInfo, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 16),
                  TextFormField(controller: _displayNameCtrl, decoration: InputDecoration(labelText: l.displayNameLabel, prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.textSecondary))),
                  const SizedBox(height: 12),
                  TextFormField(controller: _expCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: l.yearsOfExperience, prefixIcon: const Icon(Icons.calendar_today, color: AppColors.textSecondary))),
                  const SizedBox(height: 12),
                  TextFormField(controller: _qualCtrl, decoration: InputDecoration(labelText: l.qualificationLabel, prefixIcon: const Icon(Icons.school_outlined, color: AppColors.textSecondary))),
                  const SizedBox(height: 12),
                  TextFormField(controller: _bioCtrl, maxLines: 3, decoration: InputDecoration(labelText: l.bioLabel, alignLabelWithHint: true)),
                  const SizedBox(height: 16),
                  _chipSelector(l.languagesLabel, _allLanguages, _selectedLangs),
                  const SizedBox(height: 16),
                  _chipSelector(l.specializationsLabel, _allSpecs, _selectedSpecs),
                  const SizedBox(height: 24),
                  BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                    final loading = state is AuthLoading;
                    return ElevatedButton(onPressed: loading ? null : _signup, child: loading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black)) : Text(l.createAccount));
                  }),
                  const SizedBox(height: 16),
                  Row(children: [const Expanded(child: Divider(color: AppColors.border)), Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(l.orDivider, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12))), const Expanded(child: Divider(color: AppColors.border))]),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(onPressed: _googleSignIn, icon: const Text('G', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)), label: Text(l.continueGoogle)),
                ])),
              ),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(l.alreadyRegistered, style: const TextStyle(color: AppColors.textSecondary)),
                TextButton(onPressed: () => Navigator.pop(context), child: Text(l.signIn, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600))),
              ]),
              const SizedBox(height: 20),
            ]),
          ),
        ),
      ),
    );
  }
}
