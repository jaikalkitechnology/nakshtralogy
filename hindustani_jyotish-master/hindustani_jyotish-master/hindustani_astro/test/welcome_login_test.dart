// Google-only login: the welcome screen offers exactly one login action
// ("Continue with Google", no email/OTP affordances) and the LoginCubit
// surfaces the admin-console hint when the backend reports Google login as
// unconfigured with no astro client id.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hindustani_astro/core/app_config_repository.dart';
import 'package:hindustani_astro/features/auth/astro_auth_repository.dart';
import 'package:hindustani_astro/features/auth/astro_session_cubit.dart';
import 'package:hindustani_astro/features/auth/google_auth.dart';
import 'package:hindustani_astro/features/auth/login_cubit.dart';
import 'package:hindustani_astro/features/auth/ui/welcome_screen.dart';
import 'package:hindustani_astro/l10n/app_localizations.dart';
import 'package:hj_core/hj_core.dart';

/// Serves a canned [RemoteAppConfig] (or throws) — no network in tests.
class _FakeAppConfigRepository extends AppConfigRepository {
  _FakeAppConfigRepository(super.api, {this.config, this.error});

  final RemoteAppConfig? config;
  final Object? error;

  @override
  Future<RemoteAppConfig> fetch() async {
    if (error != null) throw error!;
    return config!;
  }
}

void main() {
  // Never dials out: cubit paths under test return before any HTTP call.
  final api = ApiClient(
      config: const AppConfig(apiBaseUrl: 'http://127.0.0.1:9'), tokenStore: TokenStore());
  final auth = AstroAuthRepository(api: api, tokens: TokenStore());

  LoginCubit buildCubit(AppConfigRepository configRepo) {
    final google = AstroGoogleSignIn();
    return LoginCubit(auth, AstroSessionCubit(auth, google), configRepo, google);
  }

  testWidgets('welcome screen shows only the Google login action', (tester) async {
    final cubit = buildCubit(
        _FakeAppConfigRepository(api, config: const RemoteAppConfig(googleLoginConfigured: true)));
    addTearDown(cubit.close);

    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<LoginCubit>.value(
        value: cubit,
        child: const WelcomeScreen(),
      ),
    ));
    await tester.pump();

    expect(find.text('Continue with Google'), findsOneWidget);
    // No email/mobile input and no OTP affordances of the old flow.
    expect(find.byType(TextField), findsNothing);
    expect(find.text('Continue'), findsNothing);
    expect(find.text('or'), findsNothing);
  });

  test('unconfigured Google login (no astro client id) emits the admin-console hint', () async {
    final cubit = buildCubit(_FakeAppConfigRepository(api,
        config: const RemoteAppConfig(googleLoginConfigured: false)));
    addTearDown(cubit.close);

    await cubit.signInWithGoogle();

    expect(cubit.state.status, LoginStatus.failure);
    expect(
        cubit.state.error,
        'Google login is not configured yet. Please add the Google OAuth client IDs '
        'in the admin console (Settings → Google Login).');
  });

  test('admin-provided astro client id overrides the compiled fallback', () async {
    const remoteId = 'remote-astro-id.apps.googleusercontent.com';
    final google = AstroGoogleSignIn();
    final cubit = LoginCubit(
        auth,
        AstroSessionCubit(auth, google),
        _FakeAppConfigRepository(api,
            config: const RemoteAppConfig(
                googleAstroWebClientId: remoteId, googleLoginConfigured: true)),
        google);
    addTearDown(cubit.close);

    // The sign-in itself can't run in a test (no Google plugin), but the
    // GoogleSignIn instance must have been built with the ADMIN id, not the
    // compiled constant, before the plugin call failed.
    await cubit.signInWithGoogle();
    expect(google.serverClientId, remoteId);
  });

  test('config fetch failure falls back to the compiled client id silently', () async {
    final google = AstroGoogleSignIn();
    final cubit = LoginCubit(auth, AstroSessionCubit(auth, google),
        _FakeAppConfigRepository(api, error: Exception('offline')), google);
    addTearDown(cubit.close);

    await cubit.signInWithGoogle();

    // Not the "not configured" message — the flow proceeded to the (plugin-
    // less, hence failing) Google sign-in with the compiled fallback id.
    expect(cubit.state.error, isNot(contains('admin console')));
    expect(google.serverClientId, kAstroGoogleWebClientId);
  });
}
