import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../services/api_service.dart';
import '../../services/google_auth_service.dart';
import '../../widgets/language_selector.dart';
import '../../main.dart' show bootGoogleError;
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import 'google_profile_completion_screen.dart';
import '../home/home_screen.dart';

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
    // Surface a Google callback error carried from the web redirect (once).
    if (bootGoogleError != null) {
      final msg = bootGoogleError!;
      bootGoogleError = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg), backgroundColor: AppColors.error),
          );
        }
      });
    }
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
      final ok = await LocalAuthentication().authenticate(
        localizedReason: 'Sign in with biometrics',
        options: const AuthenticationOptions(biometricOnly: false, stickyAuth: true),
      );
      if (!ok || !mounted) return;
      await ApiService().loadTokens();
      context.read<AuthBloc>().add(AuthBiometricVerified());
    } catch (_) {}
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
      AuthLoginRequested(email: _emailCtrl.text.trim(), password: _passCtrl.text),
    );
  }

  /// Continue with Google.
  ///
  /// * Web (`kIsWeb`): the locked primary path — server-side redirect. Fetch
  ///   `login-url` (role=user, return_to = the SPA `/auth/callback`) and
  ///   navigate the tab to Google. The session returns via the callback route
  ///   with `?token=&refresh=` (consumed at app boot).
  /// * Mobile: use the native `google_sign_in` sheet → POST /google/verify
  ///   (the allowed native path, fully functional without a deep-link plugin);
  ///   the server-redirect + `nakshatralogy://auth/callback` deep link is wired
  ///   in the platform manifests for when a deep-link plugin is added.
  Future<void> _googleSignIn() async {
    final l = AppLocalizations.of(context)!;
    // Both web and mobile use the server-side redirect flow. On web the tab
    // navigates to Google and returns to the SPA `/auth/callback`; on mobile an
    // external browser returns via the `nakshatralogy://auth/callback` deep link,
    // adopted by the app_links listener in main.dart. Uses the same web OAuth
    // client as the web app — no SHA-1 / native Google config required.
    final ok = await GoogleAuthService.instance.startRedirectFlow();
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.awGoogleFailed), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        } else if (state is AuthNewGoogleUser) {
          // First-time Google user → profile/region/language completion.
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (_) => GoogleProfileCompletionScreen(user: state.user),
          ));
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 8),
                // Auth-screen language chooser — honors AppMode (India shows
                // Indian languages; International hides them). Persists + applies
                // immediately via LanguageSelector → NakshatralogyUserApp.setLocale.
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => LanguageSelector.show(context),
                    icon: const Icon(Icons.language, size: 20, color: AppColors.primary),
                    label: Text(l.awChooseLanguage,
                        style: const TextStyle(color: AppColors.primary)),
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/icon/ic_launcher_foreground.png', width: 80, height: 80),
                ),
                const SizedBox(height: 12),
                Text('Nakshatralogy', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: AppColors.primary, fontSize: 28)),
                const SizedBox(height: 4),
                Text('Your Cosmic Journey Awaits', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 40),

                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.card, borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.signIn, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 22)),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(labelText: l.email, hintText: 'your@email.com', prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary)),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Email is required';
                            if (!v.contains('@')) return 'Enter a valid email';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passCtrl,
                          obscureText: _obscure,
                          decoration: InputDecoration(
                            labelText: l.password, hintText: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022',
                            prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
                            suffixIcon: IconButton(
                              icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: AppColors.textSecondary),
                              onPressed: () => setState(() => _obscure = !_obscure),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Password is required';
                            if (v.length < 6) return 'Min 6 characters';
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordScreen())),
                            child: Text(l.forgotPassword, style: const TextStyle(color: AppColors.primary)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            final loading = state is AuthLoading;
                            return ElevatedButton(
                              onPressed: loading ? null : _login,
                              child: loading
                                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                                  : Text(l.signIn),
                            );
                          },
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
                        if (_biometricAvailable) ...[
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            onPressed: _doBiometric,
                            icon: const Icon(Icons.fingerprint, size: 22),
                            label: Text(l.biometricLogin),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${l.dontHaveAccount} ', style: TextStyle(color: AppColors.textSecondary)),
                    TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen())),
                      child: Text(l.createAccount, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
