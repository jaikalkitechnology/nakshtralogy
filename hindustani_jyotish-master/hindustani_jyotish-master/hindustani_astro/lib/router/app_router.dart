import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/astro_session_cubit.dart';
import '../features/auth/ui/splash_screen.dart';
import '../features/auth/ui/welcome_screen.dart';
import '../features/dashboard/ui/dashboard_screen.dart';
import '../features/dashboard/ui/home_shell.dart';
import '../features/earnings/ui/earnings_screen.dart';
import '../features/kyc/ui/complete_profile_screen.dart';
import '../features/kyc/ui/kyc_form_screen.dart';
import '../features/kyc/ui/under_review_screen.dart';
import '../features/live/ui/go_live_screen.dart';
import '../features/portal/ui/consultation_history_screen.dart';
import '../features/portal/ui/payment_history_screen.dart';
import '../features/portal/ui/ratings_screen.dart';
import '../features/profile/ui/astro_profile_screen.dart';
import '../features/requests/ui/requests_screen.dart';
import '../features/settings/ui/settings_screen.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(AstroSessionCubit cubit) {
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

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _branchKeys = [
  GlobalKey<NavigatorState>(debugLabel: 'dash'),
  GlobalKey<NavigatorState>(debugLabel: 'req'),
  GlobalKey<NavigatorState>(debugLabel: 'earn'),
  GlobalKey<NavigatorState>(debugLabel: 'prof'),
];

GoRouter buildRouter(AstroSessionCubit session) {
  return GoRouter(
    initialLocation: '/splash',
    navigatorKey: rootNavigatorKey,
    refreshListenable: GoRouterRefreshStream(session),
    redirect: (context, state) {
      final s = session.state;
      final loc = state.matchedLocation;
      final inAuth = loc.startsWith('/auth');
      // The 3-step onboarding flow for a not-yet-approved astrologer:
      // Complete Profile -> KYC -> Approval Pending ("/review"). Once inside
      // any of these, navigation between them is left to the screens
      // themselves (e.g. "Resubmit KYC" from "/review" -> "/kyc") rather than
      // forced back to the "correct" step on every route change — mirrors
      // the pre-existing /kyc<->/review leniency.
      final inOnboarding = loc == '/profile/complete' || loc == '/kyc' || loc == '/review';

      if (s.status == SessionStatus.unknown) return loc == '/splash' ? null : '/splash';
      if (s.status == SessionStatus.unauthenticated) return inAuth ? null : '/auth/welcome';
      // authenticated
      if (!s.isApproved) {
        if (inOnboarding) return null;
        final astro = s.astrologer;
        if (!(astro?.profileCompleted ?? false)) return '/profile/complete';
        if (astro?.kycSubmittedAt == null) return '/kyc';
        return '/review';
      }
      // Approved astrologers may still open the KYC form to submit a
      // KYC/payout CHANGE (staged server-side for admin approval) — only
      // '/kyc', never the other onboarding routes, which would bounce them
      // back into the signup flow.
      if (loc == '/kyc') return null;
      if (inAuth || inOnboarding || loc == '/splash') return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/auth/welcome', builder: (_, _) => const WelcomeScreen()),
      GoRoute(path: '/review', builder: (_, _) => const UnderReviewScreen()),
      GoRoute(path: '/profile/complete', builder: (_, _) => const CompleteProfileScreen()),
      GoRoute(path: '/kyc', builder: (_, _) => const KycFormScreen()),
      GoRoute(
        path: '/live',
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, _) => const GoLiveScreen(),
      ),
      GoRoute(
        path: '/settings',
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, _) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/history/consultations',
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, _) => const ConsultationHistoryScreen(),
      ),
      GoRoute(
        path: '/ratings',
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, _) => const RatingsScreen(),
      ),
      GoRoute(
        path: '/history/payments',
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, _) => const PaymentHistoryScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => HomeShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(navigatorKey: _branchKeys[0], routes: [
            GoRoute(path: '/dashboard', builder: (_, _) => const DashboardScreen()),
          ]),
          StatefulShellBranch(navigatorKey: _branchKeys[1], routes: [
            GoRoute(path: '/requests', builder: (_, _) => const RequestsScreen()),
          ]),
          StatefulShellBranch(navigatorKey: _branchKeys[2], routes: [
            GoRoute(path: '/earnings', builder: (_, _) => const EarningsScreen()),
          ]),
          StatefulShellBranch(navigatorKey: _branchKeys[3], routes: [
            GoRoute(path: '/profile', builder: (_, _) => const AstroProfileScreen()),
          ]),
        ],
      ),
    ],
  );
}
