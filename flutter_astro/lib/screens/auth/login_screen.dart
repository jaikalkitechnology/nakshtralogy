import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_theme.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../services/api_service.dart';
import '../../services/google_auth_service.dart';
import '../../widgets/language_selector.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import '../home/home_screen.dart';
import '../../l10n/gen/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _biometricAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkBiometric();
    _checkWebGoogleError();
  }

  /// On web, if the Google server-redirect returned an error
  /// (`?google_error=...`), show it once after first frame.
  void _checkWebGoogleError() {
    if (!kIsWeb) return;
    final err = Uri.base.queryParameters['google_error'];
    if (err == null || err.isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.googleAuthCancelled),
        backgroundColor: AppColors.error,
      ));
    });
  }

  Future<void> _checkBiometric() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('biometric_enabled') ?? false;
    if (!enabled) return;
    final hasToken = prefs.getString('access_token') != null;
    if (!hasToken) return;
    try {
      final auth = LocalAuthentication();
      final canCheck = await auth.canCheckBiometrics || await auth.isDeviceSupported();
      if (canCheck && mounted) setState(() => _biometricAvailable = true);
    } catch (_) {}
  }

  Future<void> _doBiometric() async {
    try {
      final l = AppLocalizations.of(context)!;
      final ok = await LocalAuthentication().authenticate(
        localizedReason: l.signInWithBiometrics,
        options: const AuthenticationOptions(biometricOnly: false, stickyAuth: true),
      );
      if (!ok || !mounted) return;
      await ApiService().loadTokens();
      context.read<AuthBloc>().add(AuthBiometricVerified());
    } catch (_) {}
  }

  @override
  void dispose() { _emailCtrl.dispose(); _passCtrl.dispose(); super.dispose(); }

  void _login() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(AuthLoginRequested(email: _emailCtrl.text.trim(), password: _passCtrl.text));
  }

  Future<void> _googleSignIn() async {
    final l = AppLocalizations.of(context)!;
    // Web: server-side redirect flow (no native SDK). This redirects the whole
    // tab; tokens are captured by main() on return to /auth/callback.
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(l.googleRedirecting), duration: const Duration(seconds: 2)));
      final ok = await GoogleAuthService().startWebRedirect();
      if (!ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(l.googleWebLoginFailed), backgroundColor: AppColors.error));
      }
      return;
    }
    // Mobile: native google_sign_in → id_token → /google/verify (via bloc).
    try {
      final googleUser = await GoogleSignIn(
        scopes: ['email', 'profile'],
        serverClientId: const String.fromEnvironment('GOOGLE_WEB_CLIENT_ID', defaultValue: '410358361509-5h98nfjhdc9bu92rq7o39idkq3r9nieh.apps.googleusercontent.com'),
      ).signIn();
      if (googleUser == null) return;
      final auth = await googleUser.authentication;
      final idToken = auth.idToken;
      if (idToken == null) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.googleSignInNoToken),
          backgroundColor: AppColors.error, duration: const Duration(seconds: 5),
        ));
        return;
      }
      if (mounted) context.read<AuthBloc>().add(AuthGoogleLoginRequested(idToken: idToken));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.googleSignInError(e.toString())), backgroundColor: AppColors.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        else if (state is AuthFailure) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.error));
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(children: [
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => LanguageSelector.show(context),
                  icon: const Icon(Icons.language, size: 18, color: AppColors.primary),
                  label: Text(l.selectLanguage, style: const TextStyle(color: AppColors.primary, fontSize: 13)),
                ),
              ),
              const SizedBox(height: 24),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/icon/ic_launcher_foreground.png', width: 80, height: 80),
              ),
              const SizedBox(height: 12),
              Text(l.astrologerPanel, style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: AppColors.primary, fontSize: 28)),
              const SizedBox(height: 4),
              Text(l.authTagline, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)),
                child: Form(
                  key: _formKey,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(l.signIn, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 22)),
                    const SizedBox(height: 24),
                    TextFormField(controller: _emailCtrl, keyboardType: TextInputType.emailAddress, decoration: InputDecoration(labelText: l.email, prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary)), validator: (v) => (v == null || !v.contains('@')) ? l.validEmailRequired : null),
                    const SizedBox(height: 16),
                    TextFormField(controller: _passCtrl, obscureText: _obscure, decoration: InputDecoration(labelText: l.password, prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary), suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: AppColors.textSecondary), onPressed: () => setState(() => _obscure = !_obscure))), validator: (v) => (v == null || v.length < 6) ? l.minSixChars : null),
                    const SizedBox(height: 8),
                    Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordScreen())), child: Text(l.forgotPassword, style: const TextStyle(color: AppColors.primary)))),
                    const SizedBox(height: 16),
                    BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                      final loading = state is AuthLoading;
                      return ElevatedButton(onPressed: loading ? null : _login, child: loading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black)) : Text(l.signIn));
                    }),
                    const SizedBox(height: 16),
                    Row(children: [const Expanded(child: Divider(color: AppColors.border)), Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(l.orDivider, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12))), const Expanded(child: Divider(color: AppColors.border))]),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(onPressed: _googleSignIn, icon: const Text('G', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)), label: Text(l.continueGoogle)),
                    if (_biometricAvailable) ...[
                      const SizedBox(height: 16),
                      OutlinedButton.icon(onPressed: _doBiometric, icon: const Icon(Icons.fingerprint, size: 22), label: Text(l.biometricLogin)),
                    ],
                  ]),
                ),
              ),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(l.dontHaveAccount, style: const TextStyle(color: AppColors.textSecondary)),
                TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen())), child: Text(l.register, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600))),
              ]),
              const SizedBox(height: 20),
            ]),
          ),
        ),
      ),
    );
  }
}
