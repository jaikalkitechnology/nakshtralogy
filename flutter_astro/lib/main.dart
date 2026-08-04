import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:local_auth/local_auth.dart';
import 'l10n/gen/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/app_theme.dart';
import 'services/api_service.dart';
import 'services/fcm_service.dart';
import 'services/web_push_service.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_event.dart';
import 'bloc/auth/auth_state.dart';
import 'bloc/chart/chart_bloc.dart';
import 'bloc/status/status_bloc.dart';
import 'bloc/kyc/kyc_bloc.dart';
import 'bloc/dashboard/dashboard_bloc.dart';
import 'bloc/astro_wallet/astro_wallet_bloc.dart';
import 'bloc/astro_profile/astro_profile_bloc.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/permission_screen.dart';

bool _showPermissions = false;
Locale? _savedLocale;

/// On web, the backend Google callback redirects to
/// `https://astro.nakshatralogy.com/auth/callback?token=&refresh=`. Capture
/// those tokens at startup so the auth gate can route the astrologer straight
/// in. A `google_error` query param (error redirect) is surfaced by the login
/// screen, which re-reads `Uri.base` on web.
Future<void> _captureWebAuthCallback() async {
  if (!kIsWeb) return;
  final q = Uri.base.queryParameters;
  final token = q['token'];
  final refresh = q['refresh'];
  final err = q['google_error'];
  if (err != null && err.isNotEmpty) {
    return; // error path — login screen shows the message
  }
  if (token != null && token.isNotEmpty && refresh != null && refresh.isNotEmpty) {
    try {
      await ApiService().applyExternalTokens(token, refresh);
    } catch (e) {
      debugPrint('Web auth callback token apply failed: $e');
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiService().loadTokens();
  // Web Google server-redirect callback (must run before the auth gate reads
  // the session).
  await _captureWebAuthCallback();
  if (kIsWeb) {
    // Web push uses runtime PUBLIC config (never bundled Firebase options).
    WebPushService().init();
  } else {
    try {
      await FcmService().init();
    } catch (e) {
      debugPrint('FCM init failed (non-fatal): $e');
    }
  }
  _showPermissions = kIsWeb ? false : await shouldShowPermissionScreen();
  final prefs = await SharedPreferences.getInstance();
  final langCode = prefs.getString('app_language');
  if (langCode != null) {
    _savedLocale = _parseLocale(langCode);
    ApiService().setLang(langCode);
  }
  runApp(const NakshatralogyAstroApp());
}

/// Parse a stored language tag (e.g. 'hi', 'hi_Latn') into a [Locale],
/// preserving the script subtag when present.
Locale _parseLocale(String tag) {
  final parts = tag.split(RegExp(r'[_-]'));
  return parts.length > 1
      ? Locale.fromSubtags(languageCode: parts[0], scriptCode: parts[1])
      : Locale(tag);
}

class NakshatralogyAstroApp extends StatefulWidget {
  const NakshatralogyAstroApp({super.key});

  static void setLocale(BuildContext context, Locale locale) {
    context.findAncestorStateOfType<_NakshatralogyAstroAppState>()?.setLocale(locale);
  }

  @override
  State<NakshatralogyAstroApp> createState() => _NakshatralogyAstroAppState();
}

class _NakshatralogyAstroAppState extends State<NakshatralogyAstroApp> {
  Locale? _locale = _savedLocale;

  // Deep-link listener for the mobile Google server-redirect flow. The backend
  // `/google/callback` redirects to `nakshatralogyastro://auth/callback?token=&refresh=`;
  // `app_links` delivers that URI here (cold start via getInitialLink, warm via
  // the stream) so we can adopt the session and route the astrologer in.
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSub;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    // Cold start: the app was launched by the deep link.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final initial = await _appLinks.getInitialLink();
        if (initial != null) _handleAuthUri(initial);
      } catch (e) {
        debugPrint('Initial deep link read failed: $e');
      }
    });
    // Warm: the app was already running when the link arrived.
    _linkSub = _appLinks.uriLinkStream.listen(
      _handleAuthUri,
      onError: (e) => debugPrint('Deep link stream error: $e'),
    );
  }

  /// Adopt tokens carried by the Google callback deep link, then re-run the auth
  /// check so the gate routes the astrologer to Home (KYC gate handles first-time
  /// onboarding). Tokens may arrive as query OR fragment params depending on the
  /// redirect encoding.
  Future<void> _handleAuthUri(Uri uri) async {
    Map<String, String> params = uri.queryParameters;
    if ((params['token'] == null || params['token']!.isEmpty) && uri.fragment.isNotEmpty) {
      params = Uri.splitQueryString(uri.fragment);
    }
    final token = params['token'];
    final refresh = params['refresh'];
    final err = params['google_error'];
    final ctx = navigatorKey.currentContext;
    if (err != null && err.isNotEmpty) {
      if (ctx != null) {
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(ctx)!.googleAuthCancelled),
          backgroundColor: AppColors.error,
        ));
      }
      return;
    }
    if (token == null || token.isEmpty || refresh == null || refresh.isEmpty) return;
    try {
      await ApiService().applyExternalTokens(token, refresh);
    } catch (e) {
      debugPrint('Deep link token apply failed: $e');
    }
    final ctx2 = navigatorKey.currentContext;
    if (ctx2 != null) ctx2.read<AuthBloc>().add(AuthCheckRequested());
  }

  @override
  void dispose() {
    _linkSub?.cancel();
    super.dispose();
  }

  void setLocale(Locale locale) {
    setState(() => _locale = locale);
    // Preserve the script subtag (e.g. Hinglish → hi_Latn) so the saved value
    // round-trips and the API gets the correct language.
    final tag = locale.scriptCode != null
        ? '${locale.languageCode}_${locale.scriptCode}'
        : locale.languageCode;
    ApiService().setLang(tag);
    SharedPreferences.getInstance().then((p) => p.setString('app_language', tag));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()..add(AuthCheckRequested())),
        BlocProvider(create: (_) => ChartBloc()),
        BlocProvider(create: (_) => StatusBloc()),
        BlocProvider(create: (_) => KycBloc()),
        BlocProvider(create: (_) => DashboardBloc()),
        BlocProvider(create: (_) => AstroWalletBloc()),
        BlocProvider(create: (_) => AstroProfileBloc()),
      ],
      child: MaterialApp(
        title: 'Nakshatralogy Astro',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        navigatorKey: navigatorKey,
        locale: _locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: _showPermissions ? const _PermissionGate() : const _AuthGate(),
      ),
    );
  }
}

class _PermissionGate extends StatelessWidget {
  const _PermissionGate();

  @override
  Widget build(BuildContext context) {
    return PermissionScreen(
      onComplete: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const _AuthGate()),
        );
      },
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) return const HomeScreen();
        if (state is AuthBiometricLocked) return const _BiometricLockScreen();
        if (state is AuthInitial) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        return const LoginScreen();
      },
    );
  }
}

class _BiometricLockScreen extends StatefulWidget {
  const _BiometricLockScreen();
  @override
  State<_BiometricLockScreen> createState() => _BiometricLockScreenState();
}

class _BiometricLockScreenState extends State<_BiometricLockScreen> {
  final _auth = LocalAuthentication();
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _authenticate());
  }

  Future<void> _authenticate() async {
    if (_checking) return;
    setState(() => _checking = true);
    try {
      final ok = await _auth.authenticate(
        localizedReason: 'Verify your identity to continue',
        options: const AuthenticationOptions(biometricOnly: false, stickyAuth: true),
      );
      if (ok && mounted) context.read<AuthBloc>().add(AuthBiometricVerified());
    } catch (_) {}
    if (mounted) setState(() => _checking = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A24),
      body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08), shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.15))),
          child: const Icon(Icons.fingerprint, size: 42, color: Colors.white70),
        ),
        const SizedBox(height: 20),
        const Text('Nakshatralogy Astro', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        const Text('Tap to unlock with biometrics', style: TextStyle(color: Colors.white54, fontSize: 13)),
        const SizedBox(height: 24),
        if (_checking)
          const CircularProgressIndicator(color: Colors.white54)
        else
          ElevatedButton.icon(
            onPressed: _authenticate,
            icon: const Icon(Icons.fingerprint, size: 20),
            label: const Text('Unlock'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
          ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => context.read<AuthBloc>().add(AuthBiometricSkipped()),
          child: const Text('Sign in with password', style: TextStyle(color: Colors.white38, fontSize: 12)),
        ),
      ])),
    );
  }
}
