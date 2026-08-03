import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:local_auth/local_auth.dart';
import 'l10n/gen/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/app_theme.dart';
import 'services/api_service.dart';
import 'services/app_mode.dart';
import 'services/fcm_service.dart';
import 'services/web_push_service.dart';
import 'services/url_cleaner_stub.dart' if (dart.library.html) 'services/url_cleaner_web.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_event.dart';
import 'bloc/auth/auth_state.dart';
import 'bloc/chart/chart_bloc.dart';
import 'bloc/service/service_bloc.dart';
import 'bloc/astrologer/astrologer_bloc.dart';
import 'bloc/wallet/wallet_bloc.dart';
import 'bloc/profile/profile_bloc.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/google_profile_completion_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/permission_screen.dart';

/// Whether to show the permission screen on first launch.
bool _showPermissions = false;
Locale? _savedLocale;

/// Session handed back by the Google server-side redirect flow on web
/// (`/auth/callback?token=&refresh=`), captured at boot before the bloc starts.
Map<String, String>? _pendingGoogleSession;

/// A `google_error=...` surfaced on the web callback; shown once on the login
/// screen.
String? bootGoogleError;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Web: consume the OAuth callback query (token/refresh/error) before anything
  // else, then scrub it from the address bar. Harmless no-op off the web.
  if (kIsWeb) {
    final q = Uri.base.queryParameters;
    final err = q['google_error'];
    final token = q['token'];
    final refresh = q['refresh'];
    if (err != null && err.isNotEmpty) {
      bootGoogleError = err;
      cleanAuthQueryFromUrl();
    } else if (token != null && token.isNotEmpty && refresh != null && refresh.isNotEmpty) {
      _pendingGoogleSession = {'token': token, 'refresh': refresh};
      cleanAuthQueryFromUrl();
    }
  }

  await ApiService().loadTokens();
  try {
    await FcmService().init();
  } catch (e) {
    debugPrint('FCM init failed (non-fatal): $e');
  }
  // Web push (Firebase web + VAPID from public runtime config). Non-fatal;
  // registration happens after auth. Never blocks boot.
  if (kIsWeb) {
    try {
      await WebPushService().init();
    } catch (e) {
      debugPrint('Web push init failed (non-fatal): $e');
    }
  }
  _showPermissions = await shouldShowPermissionScreen();

  // AppMode (IN|INTL): load the cached region and send the device-country hint
  // so the backend can resolve region without a geo lookup. Drives which
  // language list is offered and the session currency — never any astrology.
  await AppMode.instance.load();
  ApiService().setDeviceCountry(AppMode.deviceCountry());

  final prefs = await SharedPreferences.getInstance();
  final langCode = prefs.getString('app_language');
  if (langCode != null) {
    _savedLocale = _parseLocale(langCode);
    ApiService().setLang(langCode);
  } else {
    // No explicit choice yet — in international mode default to the device
    // language when supported, else English; India keeps system default.
    final def = AppMode.instance.defaultLocaleTag();
    if (def != null) {
      _savedLocale = _parseLocale(def);
      ApiService().setLang(def);
    }
  }
  // Refresh region from the backend in the background (persists for next boot).
  AppMode.instance.refreshFromServer();
  runApp(const NakshatralogyUserApp());
}

/// Parse a stored language tag (e.g. 'hi', 'hi_Latn') into a [Locale],
/// preserving the script subtag when present.
Locale _parseLocale(String tag) {
  final parts = tag.split(RegExp(r'[_-]'));
  return parts.length > 1
      ? Locale.fromSubtags(languageCode: parts[0], scriptCode: parts[1])
      : Locale(tag);
}

class NakshatralogyUserApp extends StatefulWidget {
  const NakshatralogyUserApp({super.key});

  static void setLocale(BuildContext context, Locale locale) {
    context.findAncestorStateOfType<_NakshatralogyUserAppState>()?.setLocale(locale);
  }

  @override
  State<NakshatralogyUserApp> createState() => _NakshatralogyUserAppState();
}

class _NakshatralogyUserAppState extends State<NakshatralogyUserApp> {
  Locale? _locale = _savedLocale;

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
        BlocProvider(create: (_) {
          final bloc = AuthBloc();
          final s = _pendingGoogleSession;
          if (s != null) {
            // Web OAuth callback delivered a session — adopt it (routes new
            // users to profile completion) instead of the normal token check.
            bloc.add(AuthGoogleSessionReceived(token: s['token']!, refresh: s['refresh']!));
            _pendingGoogleSession = null;
          } else {
            bloc.add(AuthCheckRequested());
          }
          return bloc;
        }),
        BlocProvider(create: (_) => ChartBloc()),
        BlocProvider(create: (_) => ServiceBloc()),
        BlocProvider(create: (_) => AstrologerBloc()),
        BlocProvider(create: (_) => WalletBloc()),
        BlocProvider(create: (_) => ProfileBloc()),
      ],
      child: MaterialApp(
        title: 'Nakshatralogy',
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
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // On web, register the push token once a session is live.
        if (kIsWeb && state is AuthAuthenticated) {
          WebPushService().registerAfterLogin();
        }
      },
      builder: (context, state) {
        if (state is AuthAuthenticated) return const HomeScreen();
        if (state is AuthNewGoogleUser) {
          return GoogleProfileCompletionScreen(user: state.user);
        }
        if (state is AuthBiometricLocked) return const _BiometricLockScreen();
        if (state is AuthInitial || state is AuthLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
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
        const Text('Nakshatralogy', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
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
