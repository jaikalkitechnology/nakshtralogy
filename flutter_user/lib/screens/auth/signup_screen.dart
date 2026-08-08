import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../services/google_auth_service.dart';
import '../../services/api_service.dart';
import '../../services/fcm_service.dart';
import '../../widgets/language_selector.dart';
import '../../widgets/country_code_picker.dart';
import 'google_profile_completion_screen.dart';
import 'otp_verify_screen.dart';
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
  final _api = ApiService();
  Country _country = kDefaultCountry;
  bool _obscure = true;
  bool _sending = false;

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose(); _phoneCtrl.dispose();
    _passCtrl.dispose(); _confirmCtrl.dispose();
    super.dispose();
  }

  /// Manual signup now goes through an email OTP. We reserve the account +
  /// email the code, then move to verification. The phone (with its country
  /// code) is mandatory — it seeds the region (IN vs INTL) on the backend.
  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _sending = true);
    final localPhone = _phoneCtrl.text.trim().replaceAll(RegExp(r'^0+'), '');
    final fullPhone = '+${_country.dial}$localPhone';
    String? fcmToken;
    try { fcmToken = await FcmService().getToken(); } catch (_) {}
    try {
      final resp = await _api.signupSendOtp(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phone: fullPhone,
        password: _passCtrl.text,
        countryCode: _country.iso,
        phoneCountryCode: '+${_country.dial}',
        fcmToken: fcmToken,
      );
      if (!mounted) return;
      if (resp['statusCode'] == 201) {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => OtpVerifyScreen(email: _emailCtrl.text.trim()),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(resp['detail']?.toString() ?? 'Signup failed'),
          backgroundColor: AppColors.error));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$e'), backgroundColor: AppColors.error));
    }
    if (mounted) setState(() => _sending = false);
  }

  /// Continue with Google (sign-up). Same transport as login: web → server
  /// redirect; mobile → native sheet → /google/verify. First-time users route
  /// to profile completion.
  Future<void> _googleSignIn() async {
    final l = AppLocalizations.of(context)!;
    if (kIsWeb) {
      final ok = await GoogleAuthService.instance.startRedirectFlow();
      if (!ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.awGoogleFailed), backgroundColor: AppColors.error),
        );
      }
      return;
    }
    context.read<AuthBloc>().add(const AuthGoogleNativeRequested());
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false);
        } else if (state is AuthNewGoogleUser) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (_) => GoogleProfileCompletionScreen(user: state.user),
          ), (route) => false);
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.error));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary), onPressed: () => Navigator.pop(context)),
          actions: [
            TextButton.icon(
              onPressed: () => LanguageSelector.show(context),
              icon: const Icon(Icons.language, size: 20, color: AppColors.primary),
              label: Text(l.awChooseLanguage, style: const TextStyle(color: AppColors.primary)),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(children: [
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset('assets/icon/ic_launcher_foreground.png', width: 64, height: 64),
              ),
              const SizedBox(height: 8),
              Text(l.createAccount, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontSize: 24)),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)),
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    TextFormField(controller: _nameCtrl, decoration: InputDecoration(labelText: l.fullName, prefixIcon: const Icon(Icons.person_outline, color: AppColors.textSecondary)), validator: (v) => (v == null || v.length < 2) ? l.required : null),
                    const SizedBox(height: 16),
                    TextFormField(controller: _emailCtrl, keyboardType: TextInputType.emailAddress, decoration: InputDecoration(labelText: l.email, prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary)), validator: (v) => (v == null || !v.contains('@')) ? l.validEmailRequired : null),
                    const SizedBox(height: 16),
                    // Phone is mandatory — the country code seeds the region.
                    TextFormField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: l.phone,
                        prefixIcon: CountryCodePicker(
                          value: _country,
                          onSelected: (c) => setState(() => _country = c),
                        ),
                      ),
                      validator: (v) => (v == null || v.trim().length < 6) ? l.required : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(controller: _passCtrl, obscureText: _obscure, decoration: InputDecoration(labelText: l.password, prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary), suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: AppColors.textSecondary), onPressed: () => setState(() => _obscure = !_obscure))), validator: (v) => (v == null || v.length < 6) ? l.minSixChars : null),
                    const SizedBox(height: 16),
                    TextFormField(controller: _confirmCtrl, obscureText: true, decoration: InputDecoration(labelText: l.confirmPassword, prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary)), validator: (v) => v != _passCtrl.text ? l.passwordsMismatch : null),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _sending ? null : _signup,
                      child: _sending ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black)) : Text(l.createAccount),
                    ),
                    const SizedBox(height: 16),
                    Row(children: [
                      const Expanded(child: Divider(color: AppColors.border)),
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('OR', style: TextStyle(color: AppColors.textSecondary, fontSize: 12))),
                      const Expanded(child: Divider(color: AppColors.border)),
                    ]),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _googleSignIn,
                      icon: const Text('G', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      label: Text(l.continueGoogle),
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('${l.alreadyHaveAccount} ', style: TextStyle(color: AppColors.textSecondary)),
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
