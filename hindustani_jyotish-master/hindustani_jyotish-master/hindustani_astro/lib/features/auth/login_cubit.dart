import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hj_core/hj_core.dart';

import '../../core/app_config_repository.dart';
import 'astro_auth_repository.dart';
import 'astro_session_cubit.dart';
import 'google_auth.dart';

part 'login_state.dart';

/// Google-only login. Astrologer accounts are provisioned by the admin (the
/// Google OAuth client ids are admin-configured too, via
/// `GET /v1/public/app-config`) — there is no OTP path anymore.
///
/// Web needs a second, event-driven path in addition to [signInWithGoogle]:
/// `GoogleSignIn.signIn()` on web goes through the OAuth2 token flow, which
/// never returns an `idToken` our backend requires. The only web flow that
/// does is the GIS *credential* flow (the official button rendered by
/// `google_web_button_web.dart`), whose result arrives asynchronously via
/// `GoogleSignIn.onCurrentUserChanged` rather than as a call return value —
/// see [_initWeb] / [_onWebAccountChanged].
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._auth, this._session, this._appConfig, this._google)
      : super(const LoginState()) {
    if (kIsWeb) {
      unawaited(_initWeb());
    }
  }

  final AstroAuthRepository _auth;
  final AstroSessionCubit _session;
  final AppConfigRepository _appConfig;
  final AstroGoogleSignIn _google;
  StreamSubscription<GoogleSignInAccount?>? _webAccountSub;

  /// Resolves the `serverClientId` and builds (or reuses) the shared cached
  /// [GoogleSignIn]:
  ///
  /// 1. Admin-fed `google_astro_web_client_id` from `/public/app-config`
  ///    when set.
  /// 2. Config fetched but Google login not configured server-side at all →
  ///    returns null; the caller shows the friendly "configure it in the
  ///    admin console" message (attempting sign-in would only produce a
  ///    server-side rejection).
  /// 3. Compiled fallback [kAstroGoogleWebClientId] — both when the admin
  ///    left the astro id empty (but Google login IS configured, e.g. via
  ///    backend env) and when the config fetch itself failed (login must
  ///    still work offline-from-config, so the failure is only logged).
  Future<GoogleSignIn?> _resolveGoogleSignIn() async {
    var serverClientId = kAstroGoogleWebClientId;
    try {
      final cfg = await _appConfig.fetch();
      // Per-platform: Android and web usually need DIFFERENT OAuth clients
      // (only the web one carries Authorized JavaScript origins). The server
      // falls back to the web id when no Android-specific one is configured.
      final remoteId = cfg.googleClientIdFor(isWeb: kIsWeb);
      if (remoteId != null && remoteId.isNotEmpty) {
        serverClientId = remoteId;
      } else if (!cfg.googleLoginConfigured) {
        return null;
      }
    } catch (e) {
      debugPrint('[google] app-config fetch failed, using compiled client id: $e');
    }
    return _google.forServerClientId(serverClientId);
  }

  /// Mobile (and any non-web platform): the existing native
  /// GoogleSignIn.signIn() flow, which DOES return an idToken there.
  /// Untouched — the welcome screen only wires this button on mobile; on web
  /// it shows the GIS button instead (see [_initWeb]).
  Future<void> signInWithGoogle() async {
    emit(state.copyWith(status: LoginStatus.googleSigningIn, clearError: true));
    try {
      final googleSignIn = await _resolveGoogleSignIn();
      if (googleSignIn == null) {
        emit(state.copyWith(
            status: LoginStatus.failure,
            error:
                'Google login is not configured yet. Please add the Google OAuth client IDs in the admin console (Settings → Google Login).'));
        return;
      }
      final account = await googleSignIn.signIn();
      if (account == null) {
        // User cancelled the picker — return to idle silently.
        emit(state.copyWith(status: LoginStatus.idle));
        return;
      }
      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null) {
        emit(state.copyWith(
            status: LoginStatus.failure,
            error:
                'Google returned no ID token. Check that serverClientId is the OAuth Web client id.'));
        return;
      }
      await _completeGoogleLogin(idToken);
    } on PlatformException catch (e) {
      // Native Google sign-in failure — surface the actual code/message so we
      // can tell console/SHA-1 issues from cancellations.
      debugPrint(
          '[google] PlatformException code=${e.code} message=${e.message} details=${e.details}');
      emit(state.copyWith(status: LoginStatus.failure, error: _googleErrorText(e)));
    } catch (e, st) {
      debugPrint('[google] sign-in error: $e\n$st');
      emit(state.copyWith(
          status: LoginStatus.failure, error: 'Google sign-in failed: $e'));
    }
  }

  /// Web only: resolves the client id and builds (or reuses) the shared
  /// [GoogleSignIn] instance so the GIS "Sign in with Google" button (see
  /// `google_web_button_web.dart`) has something to render against, then
  /// listens for the account it (or a still-valid previous GIS session)
  /// produces. Runs once, from the constructor.
  Future<void> _initWeb() async {
    final googleSignIn = await _resolveGoogleSignIn();
    if (googleSignIn == null) {
      emit(state.copyWith(
          status: LoginStatus.failure,
          error:
              'Google login is not configured yet. Please add the Google OAuth client IDs in the admin console (Settings → Google Login).'));
      return;
    }
    // Exposed so the welcome screen only renders the GIS button once the
    // underlying plugin is initializing with the right client id.
    emit(state.copyWith(webGoogleSignIn: googleSignIn));
    _webAccountSub = googleSignIn.onCurrentUserChanged.listen(_onWebAccountChanged);
    try {
      // Picks up a returning astrologer's still-valid GIS session without
      // requiring them to click the button again. Failures here (no prior
      // session, expired session, popup blocked, …) are expected and not
      // worth surfacing — the rendered button remains the fallback.
      await googleSignIn.signInSilently();
    } catch (e, st) {
      debugPrint('[google web] signInSilently: $e\n$st');
    }
  }

  /// Web only: fired by [GoogleSignIn.onCurrentUserChanged] once the GIS
  /// button (or `signInSilently`) resolves an account. Reads the idToken —
  /// the only field the credential flow actually populates on web — and runs
  /// it through the SAME backend exchange the mobile path uses.
  Future<void> _onWebAccountChanged(GoogleSignInAccount? account) async {
    if (account == null) return;
    emit(state.copyWith(status: LoginStatus.googleSigningIn, clearError: true));
    try {
      final idToken = (await account.authentication).idToken;
      if (idToken == null) {
        emit(state.copyWith(
            status: LoginStatus.failure,
            error: 'Google sign-in did not return an ID token. Please try again.'));
        return;
      }
      await _completeGoogleLogin(idToken);
    } catch (e, st) {
      debugPrint('[google web] account exchange error: $e\n$st');
      emit(state.copyWith(
          status: LoginStatus.failure, error: 'Google sign-in failed: $e'));
    }
  }

  /// Shared with both the mobile and web sign-in paths: exchanges the Google
  /// idToken for our own session via the backend.
  Future<void> _completeGoogleLogin(String idToken) async {
    try {
      final astro = await _auth.googleLogin(idToken);
      _session.onAuthenticated(astro);
      emit(state.copyWith(status: LoginStatus.success));
    } on ApiException catch (e) {
      // Backend error — surface the real detail verbatim (e.g. the cross-role
      // 409 "already registered as a customer…").
      emit(state.copyWith(status: LoginStatus.failure, error: e.message));
    }
  }

  @override
  Future<void> close() async {
    await _webAccountSub?.cancel();
    return super.close();
  }

  /// Map a native Google sign-in [PlatformException] to a diagnosable message.
  /// The plugin usually reports the underlying status code either as [e.code]
  /// or embedded in [e.message] (e.g. "ApiException: 10: ").
  String _googleErrorText(PlatformException e) {
    final raw = '${e.code} ${e.message ?? ''}';
    if (raw.contains('10') && raw.contains('ApiException') ||
        e.code == '10') {
      return 'Google sign-in failed [DEVELOPER_ERROR 10]: SHA-1 fingerprint or OAuth client id '
          'mismatch in the Firebase/Google console. (${e.message ?? e.code})';
    }
    if (raw.contains('12501') || e.code == '12501') {
      return 'Google sign-in was cancelled [12501].';
    }
    if (raw.contains('12500') || e.code == '12500') {
      return 'Google sign-in failed [12500]: Play services / configuration issue. (${e.message ?? ''})';
    }
    return 'Google sign-in failed [${e.code}]: ${e.message ?? 'unknown error'}';
  }
}
