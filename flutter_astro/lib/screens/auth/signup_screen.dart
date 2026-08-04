import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../services/api_service.dart';
import '../../services/google_auth_service.dart';
import '../../widgets/language_selector.dart';
import 'otp_verify_screen.dart';

/// Short astrologer signup — only the essentials (name, email, phone, password)
/// plus Terms acceptance. On submit we email an OTP and move to verification;
/// personal / professional / KYC details are collected after login during
/// onboarding.
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
  final _api = ApiService();
  bool _obscure = true;
  bool _terms = false;
  bool _sending = false;

  static const String _termsUrl = 'https://nakshatralogy.com/terms.html';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _openTerms() async {
    final uri = Uri.parse(_termsUrl);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_terms) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please accept the Terms & Conditions to continue'),
        backgroundColor: AppColors.error));
      return;
    }
    setState(() => _sending = true);
    try {
      final resp = await _api.signupSendOtp(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        password: _passCtrl.text,
        termsAccepted: true,
      );
      if (!mounted) return;
      if (resp['statusCode'] == 201 || resp['statusCode'] == 200) {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => OtpVerifyScreen(
            email: _emailCtrl.text.trim(),
            name: _nameCtrl.text.trim(),
          ),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(resp['detail']?.toString() ?? 'Could not send verification code'),
          backgroundColor: AppColors.error));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'), backgroundColor: AppColors.error));
    }
    if (mounted) setState(() => _sending = false);
  }

  /// Continue with Google — server-side redirect on every platform (web tab
  /// redirect / mobile external browser → `nakshatralogyastro://auth/callback`
  /// deep link, adopted by the app_links listener in main.dart). First-time
  /// astrologers land on HomeScreen, whose onboarding + KYC gate takes over.
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
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message), backgroundColor: AppColors.error));
        }
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
              const SizedBox(height: 4),
              const Text('Create your account in seconds — the rest comes after.',
                  textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)),
                child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(l.personalInfo, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 16),
                  TextFormField(controller: _nameCtrl, textCapitalization: TextCapitalization.words, decoration: InputDecoration(labelText: l.fullNameLabel, prefixIcon: const Icon(Icons.person_outline, color: AppColors.textSecondary)), validator: (v) => (v == null || v.trim().length < 2) ? l.requiredField : null),
                  const SizedBox(height: 12),
                  TextFormField(controller: _emailCtrl, keyboardType: TextInputType.emailAddress, decoration: InputDecoration(labelText: l.email, prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary)), validator: (v) => (v == null || !v.contains('@')) ? l.validEmailRequired : null),
                  const SizedBox(height: 12),
                  TextFormField(controller: _phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Mobile Number *', prefixIcon: Icon(Icons.phone_outlined, color: AppColors.textSecondary)), validator: (v) => (v == null || v.trim().length < 6) ? 'Valid mobile number required' : null),
                  const SizedBox(height: 12),
                  TextFormField(controller: _passCtrl, obscureText: _obscure, decoration: InputDecoration(labelText: l.password, prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary), suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: AppColors.textSecondary), onPressed: () => setState(() => _obscure = !_obscure))), validator: (v) => (v == null || v.length < 6) ? l.minSixChars : null),
                  const SizedBox(height: 16),
                  // Terms & Conditions acceptance
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(
                      width: 24, height: 24,
                      child: Checkbox(
                        value: _terms,
                        activeColor: AppColors.primary,
                        onChanged: (v) => setState(() => _terms = v ?? false),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                      const Text('I agree to the ', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      GestureDetector(
                        onTap: _openTerms,
                        child: const Text('Terms & Conditions',
                            style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600, decoration: TextDecoration.underline)),
                      ),
                    ])),
                  ]),
                  const SizedBox(height: 20),
                  SizedBox(width: double.infinity, child: ElevatedButton(
                    onPressed: _sending ? null : _sendOtp,
                    child: _sending
                        ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                        : const Text('Send Verification Code'),
                  )),
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
