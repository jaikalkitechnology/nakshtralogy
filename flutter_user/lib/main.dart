import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
  runApp(const NakshtralogyUserApp());
}

class NakshtralogyUserApp extends StatefulWidget {
  const NakshtralogyUserApp({super.key});

  static void setLocale(BuildContext context, Locale locale) {
    context.findAncestorStateOfType<_NakshtralogyUserAppState>()?.setLocale(locale);
  }

  @override
  State<NakshtralogyUserApp> createState() => _NakshtralogyUserAppState();
}

class _NakshtralogyUserAppState extends State<NakshtralogyUserApp> {
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
        title: 'Nakshtralogy',
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
        if (state is AuthInitial) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return const LoginScreen();
      },
    );
  }
}
