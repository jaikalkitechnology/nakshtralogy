import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hj_core/hj_core.dart';

import '../features/auth/ui/profile_completion_screen.dart';
import '../features/auth/ui/splash_screen.dart';
import '../features/auth/ui/welcome_screen.dart';
import '../features/consultation/ui/consultation_history_screen.dart';
import '../features/invoices/ui/invoices_screen.dart';
import '../features/consultation/ui/consultation_screen.dart';
import '../features/discovery/ui/astrologer_profile_screen.dart';
import '../features/discovery/ui/astrologers_screen.dart';
import '../features/home/home_screen.dart';
import '../features/home/home_shell.dart';
import '../features/home/promo_video.dart';
import '../features/home/ui/promo_video_player_screen.dart';
import '../features/insights/ui/insights_screen.dart';
import '../features/insights/ui/kundli_analysis_screen.dart';
import '../features/insights/ui/my_reports_screen.dart';
import '../features/insights/ui/special_reports_screen.dart';
import '../features/live/ui/live_list_screen.dart';
import '../features/live/ui/live_viewer_screen.dart';
import '../features/notifications/ui/notifications_screen.dart';
import '../features/profile/ui/birth_details_screen.dart';
import '../features/profile/ui/edit_profile_screen.dart';
import '../features/profile/ui/profile_screen.dart';
import '../features/wallet/ui/wallet_screen.dart';

/// Bridges an [AuthCubit] stream to go_router's [refreshListenable].
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(AuthCubit cubit) {
    notifyListeners();
    _sub = cubit.stream.listen((_) => notifyListeners());
  }
  late final dynamic _sub;
  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final _homeKeys = [
  GlobalKey<NavigatorState>(debugLabel: 'home'),
  GlobalKey<NavigatorState>(debugLabel: 'astro'),
  GlobalKey<NavigatorState>(debugLabel: 'insights'),
  GlobalKey<NavigatorState>(debugLabel: 'wallet'),
  GlobalKey<NavigatorState>(debugLabel: 'profile'),
];

GoRouter buildRouter(AuthCubit auth) {
  return GoRouter(
    initialLocation: '/splash',
    navigatorKey: rootNavigatorKey,
    refreshListenable: GoRouterRefreshStream(auth),
    redirect: (context, state) {
      final s = auth.state;
      final loc = state.matchedLocation;
      final loggingIn = loc.startsWith('/auth');

      if (s.status == AuthStatus.unknown) return loc == '/splash' ? null : '/splash';
      if (s.status == AuthStatus.unauthenticated) {
        return loggingIn ? null : '/auth/welcome';
      }
      // authenticated
      if (s.needsProfile) return loc == '/auth/profile' ? null : '/auth/profile';
      if (loggingIn || loc == '/splash') return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/auth/welcome', builder: (_, _) => const WelcomeScreen()),
      GoRoute(path: '/auth/profile', builder: (_, _) => const ProfileCompletionScreen()),
      GoRoute(
        path: '/astrologers/:id',
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, st) => AstrologerProfileScreen(id: st.pathParameters['id']!),
      ),
      GoRoute(
        path: '/consultation/:id',
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, st) => ConsultationScreen(
          consultationId: st.pathParameters['id']!,
          type: (st.extra as ConsultationType?) ?? ConsultationType.chat,
        ),
      ),
      GoRoute(
        path: '/history',
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, _) => const ConsultationHistoryScreen(),
      ),
      GoRoute(
        path: '/invoices',
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, _) => const InvoicesScreen(),
      ),
      GoRoute(
        path: '/notifications',
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, _) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/profile/edit',
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, _) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/profile/birth-details',
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, _) => const BirthDetailsScreen(),
      ),
      GoRoute(
        path: '/insights/reports',
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, _) => const MyReportsScreen(),
      ),
      GoRoute(
        path: '/insights/special-reports',
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, _) => const SpecialReportsScreen(),
      ),
      GoRoute(
        path: '/kundli/:id',
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, st) => KundliAnalysisScreen(
          chartId: st.pathParameters['id']!,
          subjectName: st.extra is String ? st.extra as String : null,
        ),
      ),
      GoRoute(
        path: '/promo-video',
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, st) => PromoVideoPlayerScreen(video: st.extra as PromoVideo),
      ),
      GoRoute(
        path: '/live',
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, _) => const LiveListScreen(),
      ),
      GoRoute(
        path: '/live/:id',
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, st) => LiveViewerScreen(liveId: st.pathParameters['id']!),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => HomeShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(navigatorKey: _homeKeys[0], routes: [
            GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
          ]),
          StatefulShellBranch(navigatorKey: _homeKeys[1], routes: [
            GoRoute(path: '/astrologers', builder: (_, _) => const AstrologersScreen()),
          ]),
          StatefulShellBranch(navigatorKey: _homeKeys[2], routes: [
            GoRoute(path: '/insights', builder: (_, _) => const InsightsScreen()),
          ]),
          StatefulShellBranch(navigatorKey: _homeKeys[3], routes: [
            GoRoute(path: '/wallet', builder: (_, _) => const WalletScreen()),
          ]),
          StatefulShellBranch(navigatorKey: _homeKeys[4], routes: [
            GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
          ]),
        ],
      ),
    ],
  );
}

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// App-wide messenger so services without a `BuildContext` (e.g. push
/// notifications) can surface in-app banners/snackbars.
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
