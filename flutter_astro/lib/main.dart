import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme/app_theme.dart';
import 'services/api_service.dart';
import 'services/fcm_service.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiService().loadTokens();
  await FcmService().init();
  runApp(const NakshtralogyAstroApp());
}

class NakshtralogyAstroApp extends StatelessWidget {
  const NakshtralogyAstroApp({super.key});

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
        title: 'Nakshtralogy Astro',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) return const HomeScreen();
            if (state is AuthInitial) return const Scaffold(body: Center(child: CircularProgressIndicator()));
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
