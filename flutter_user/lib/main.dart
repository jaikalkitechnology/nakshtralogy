import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:local_auth/local_auth.dart';
import 'l10n/gen/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/app_theme.dart';
import 'services/api_service.dart';
import 'services/fcm_service.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_event.dart';
import 'bloc/auth/auth_state.dart';
import 'bloc/chart/chart_bloc.dart';
import 'bloc/service/service_bloc.dart';
import 'bloc/astrologer/astrologer_bloc.dart';
import 'bloc/wallet/wallet_bloc.dart';
import 'bloc/profile/profile_bloc.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/permission_screen.dart';

/// Whether to show the permission screen on first launch.
bool _showPermissions = false;
Locale? _savedLocale;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiService().loadTokens();
  try {
    await FcmService().init();
  } catch (e) {
    debugPrint('FCM init failed (non-fatal): $e');
  }
  _showPermissions = await shouldShowPermissionScreen();
  final prefs = await SharedPreferences.getInstance();
  final langCode = prefs.getString('app_language');
  if (langCode != null) _savedLocale = Locale(langCode);
  runApp(const NakshatralogyUserApp());
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
    SharedPreferences.getInstance().then((p) => p.setString('app_language', locale.languageCode));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()..add(AuthCheckRequested())),
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
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) return const HomeScreen();
        if (state is AuthBiometricLocked) return const _BiometricLockScreen();
        if (state is AuthInitial) {
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
          onPressed: () => context.read<AuthBloc>().add(AuthLogoutRequested()),
          child: const Text('Sign in with password', style: TextStyle(color: Colors.white38, fontSize: 12)),
        ),
      ])),
    );
  }
}
