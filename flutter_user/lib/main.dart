import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'services/api_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiService().loadTokens();
  runApp(const NakshtralogyUserApp());
}

class NakshtralogyUserApp extends StatelessWidget {
  const NakshtralogyUserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nakshtralogy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: ApiService().isLoggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}
