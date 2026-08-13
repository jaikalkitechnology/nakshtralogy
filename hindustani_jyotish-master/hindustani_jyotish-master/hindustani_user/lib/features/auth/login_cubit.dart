import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hj_core/hj_core.dart';

import 'google_auth.dart';

part 'login_state.dart';

/// Drives the Google-only login flow, then hands the session to [AuthCubit].
/// (Email/mobile OTP login was removed — Google is the single entry point,
/// with its client id fed live from the admin console via
/// `GET /public/app-config`; see `google_auth.dart`.)
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._auth, this._session) : super(const LoginState()) {
    // Web has no equivalent of the mobile `signIn()` → idToken flow (see
    // `signInWithGoogle` below): the GIS credential button rendered by
    // `GoogleWebSignInButton` (welcome_screen.dart, web-only) is the entry
    // point instead, and its result arrives asynchronously through
    // `GoogleSignIn.onCurrentUserChanged`. Subscribe to it here so it's
    // handled regardless of which screen is on top, and kick off
    // `signInSilently()` so a returning user is picked up without a click.
    if (kIsWeb) {
      unawaited(_initWebGoogleSignIn());
    }
  }

  final AuthRepository _auth;
  final AuthCubit _session;
  StreamSubscription<GoogleSignInAccount?>? _googleAccountSub;

  Future<void> _initWebGoogleSignIn() async {
    try {
      final google = await obtainGoogleSignIn();
      if (google == null) {
        // Backend reachable, admin hasn't set the client ids, and there is no
        // compiled fallback either — same message as the mobile path.
        emit(state.copyWith(
            status: LoginStatus.failure,
            error: 'Google login is not configured yet. Please add the Google '
                'OAuth client IDs in the admin console (Settings → Google '
                'Login).'));
        return;
      }
      _googleAccountSub ??=
          google.onCurrentUserChanged.listen(_onWebGoogleAccountChanged);
      // Picks up a returning user (previously-consented session) without
      // requiring a click; a no-op if there is none (or the browser blocks
      // the silent flow), in which case the GIS button remains the entry
      // point.
      await google.signInSilently();
    } catch (e) {
      debugPrint('[google] web auto sign-in setup failed (ignored): $e');
    }
  }

  /// Handles the account [GoogleWebSignInButton] (or `signInSilently`)
  /// produced on web, running the same backend exchange + session handling
  /// as the mobile path in [signInWithGoogle].
  Future<void> _onWebGoogleAccountChanged(GoogleSignInAccount? account) async {
    if (account == null || state.status == LoginStatus.success) return;
    emit(state.copyWith(status: LoginStatus.googleSigningIn, clearError: true));
    try {
      final idToken = (await account.authentication).idToken;
      if (idToken == null || idToken.isEmpty) {
        debugPrint('[google] web sign-in returned a null/empty idToken — the '
            "OAuth Web client id passed as `clientId` likely doesn't match "
            'the one configured in Google Cloud / the admin console.');
        emit(state.copyWith(
            status: LoginStatus.failure,
            error: 'Google did not return an ID token. The app’s OAuth '
                'Web client id is likely misconfigured.'));
        return;
      }
      final result = await _auth.signInWithGoogle(idToken, deviceLabel: 'web');
      _session.onAuthenticated(result.user);
      emit(state.copyWith(status: LoginStatus.success));
    } on ApiException catch (e) {
      // Includes the cross-role 409 ("…already registered as an astrologer.
      // Please use the astrologer app…") — show its detail verbatim.
      debugPrint('[google] API error ${e.statusCode}: ${e.message}');
      emit(state.copyWith(status: LoginStatus.failure, error: e.message));
    } catch (e) {
      debugPrint('[google] unexpected error: $e');
      emit(state.copyWith(
          status: LoginStatus.failure, error: 'Google sign-in failed: $e'));
    }
  }

  /// "Continue with Google": obtain a Google id_token and exchange it for our
  /// own session via [AuthRepository.signInWithGoogle].
  ///
  /// Failures are surfaced with their real cause rather than a generic message:
  /// the backend detail verbatim for API errors (incl. the cross-role 409), and
  /// the plugin's `code`/`message` for platform errors (code `10` =
  /// DEVELOPER_ERROR → SHA-1 / client-id mismatch; `12500` = Play services
  /// config; `12501` = user cancel).
  Future<void> signInWithGoogle() async {
    emit(state.copyWith(status: LoginStatus.googleSigningIn, clearError: true));
    try {
      final google = await obtainGoogleSignIn();
      if (google == null) {
        // Backend reachable, admin hasn't set the client ids, and there is no
        // compiled fallback either — name the fix instead of DEVELOPER_ERROR.
        emit(state.copyWith(
            status: LoginStatus.failure,
            error: 'Google login is not configured yet. Please add the Google '
                'OAuth client IDs in the admin console (Settings → Google '
                'Login).'));
        return;
      }
      final account = await google.signIn();
      if (account == null) {
        // User dismissed the Google account picker — return to the idle form.
        emit(state.copyWith(status: LoginStatus.idle));
        return;
      }
      final idToken = (await account.authentication).idToken;
      if (idToken == null || idToken.isEmpty) {
        debugPrint('[google] sign-in returned a null/empty idToken — this '
            'usually means serverClientId (Web client id) is missing or the '
            "app's SHA-1 is not registered.");
        emit(state.copyWith(
            status: LoginStatus.failure,
            error: 'Google did not return an ID token. The app’s OAuth '
                'Web client id or SHA-1 fingerprint is likely misconfigured.'));
        return;
      }
      final result = await _auth.signInWithGoogle(idToken, deviceLabel: 'mobile');
      _session.onAuthenticated(result.user);
      emit(state.copyWith(status: LoginStatus.success));
    } on ApiException catch (e) {
      // Includes the cross-role 409 ("…already registered as an astrologer.
      // Please use the astrologer app…") — show its detail verbatim.
      debugPrint('[google] API error ${e.statusCode}: ${e.message}');
      emit(state.copyWith(status: LoginStatus.failure, error: e.message));
    } on PlatformException catch (e) {
      debugPrint('[google] PlatformException code=${e.code} message=${e.message} '
          'details=${e.details}');
      // 12501 / sign_in_canceled: the user backed out — return to idle quietly.
      if (e.code == '12501' || e.code == GoogleSignIn.kSignInCanceledError) {
        emit(state.copyWith(status: LoginStatus.idle));
        return;
      }
      emit(state.copyWith(
          status: LoginStatus.failure, error: _googleErrorText(e)));
    } catch (e) {
      // Unknown plugin/runtime failure (e.g. web without a client id).
      debugPrint('[google] unexpected error: $e');
      emit(state.copyWith(
          status: LoginStatus.failure, error: 'Google sign-in failed: $e'));
    }
  }

  /// Turns a Google [PlatformException] into a message that names the real
  /// failure so a misconfiguration is diagnosable from the UI.
  String _googleErrorText(PlatformException e) {
    final raw = (e.message ?? '').trim();
    // Android wraps the numeric ApiException status inside `message`
    // (e.g. "10: " = DEVELOPER_ERROR); iOS/web report it via `code`.
    if (e.code == '10' || raw.startsWith('10') || raw.contains('DEVELOPER_ERROR')) {
      return 'Google sign-in failed (code 10, DEVELOPER_ERROR): the app’s '
          'SHA-1 fingerprint or OAuth client id does not match the Firebase / '
          'Google Cloud configuration.';
    }
    if (e.code == '12500' || raw.startsWith('12500')) {
      return 'Google sign-in failed (code 12500): Google Play services '
          'configuration error.${raw.isEmpty ? '' : ' $raw'}';
    }
    return 'Google sign-in failed (${e.code})${raw.isEmpty ? '' : ': $raw'}';
  }

  void reset() => emit(const LoginState());

  @override
  Future<void> close() {
    _googleAccountSub?.cancel();
    return super.close();
  }
}
