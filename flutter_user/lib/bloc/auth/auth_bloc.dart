import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/api_service.dart';
import '../../services/fcm_service.dart';
import '../../services/google_auth_service.dart';
import '../../services/web_push_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService _api = ApiService();

  AuthBloc() : super(AuthInitial()) {
    on<AuthCheckRequested>(_onCheck);
    on<AuthLoginRequested>(_onLogin);
    on<AuthSignupRequested>(_onSignup);
    on<AuthGoogleLoginRequested>(_onGoogleLogin);
    on<AuthGoogleNativeRequested>(_onGoogleNative);
    on<AuthGoogleSessionReceived>(_onGoogleSession);
    on<AuthProfileCompleted>(_onProfileCompleted);
    on<AuthForgotPasswordRequested>(_onForgotPassword);
    on<AuthLogoutRequested>(_onLogout);
    on<AuthBiometricVerified>(_onBiometricVerified);
    on<AuthBiometricSkipped>(_onBiometricSkipped);
    _api.onAuthExpired = () => add(AuthLogoutRequested());
  }

  Future<void> _onCheck(AuthCheckRequested event, Emitter<AuthState> emit) async {
    await _api.loadTokens();
    if (_api.isLoggedIn) {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('user_data');
      final user = raw != null ? jsonDecode(raw) as Map<String, dynamic> : <String, dynamic>{};
      final biometricEnabled = prefs.getBool('biometric_enabled') ?? false;
      if (biometricEnabled) {
        emit(AuthBiometricLocked(user: user));
      } else {
        emit(AuthAuthenticated(user: user));
      }
      _syncFcmTokenInBackground();
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onBiometricVerified(AuthBiometricVerified event, Emitter<AuthState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('user_data');
    final user = raw != null ? jsonDecode(raw) as Map<String, dynamic> : <String, dynamic>{};
    emit(AuthAuthenticated(user: user));
  }

  Future<void> _onBiometricSkipped(AuthBiometricSkipped event, Emitter<AuthState> emit) async {
    emit(AuthUnauthenticated());
  }

  Future<void> _onLogin(AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final fcmToken = await FcmService().getToken();
      debugPrint('Login FCM token: ${fcmToken != null ? "${fcmToken.substring(0, 20)}..." : "NULL - ${FcmService().getStatusMessage()}"}');
      final result = await _api.login(email: event.email, password: event.password, fcmToken: fcmToken);
      if (result['statusCode'] == 200) {
        emit(AuthAuthenticated(user: result['user'] ?? {}));
        // Ensure FCM token synced after login
        _syncFcmTokenInBackground();
      } else {
        emit(AuthFailure(message: result['detail'] ?? 'Login failed'));
      }
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _onSignup(AuthSignupRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final fcmToken = await FcmService().getToken();
      debugPrint('Signup FCM token: ${fcmToken != null ? "${fcmToken.substring(0, 20)}..." : "NULL - ${FcmService().getStatusMessage()}"}');
      final result = await _api.signup(
        name: event.name,
        email: event.email,
        password: event.password,
        phone: event.phone,
        fcmToken: fcmToken,
      );
      if (result['statusCode'] == 201) {
        emit(AuthAuthenticated(user: result['user'] ?? {}));
        _syncFcmTokenInBackground();
      } else {
        emit(AuthFailure(message: result['detail'] ?? 'Signup failed'));
      }
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _onGoogleLogin(AuthGoogleLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final fcmToken = await FcmService().getToken();
      debugPrint('Google login FCM token: ${fcmToken != null ? "${fcmToken.substring(0, 20)}..." : "NULL - ${FcmService().getStatusMessage()}"}');
      final result = await _api.googleLogin(event.idToken, fcmToken: fcmToken);
      if (result['statusCode'] == 200) {
        emit(AuthAuthenticated(user: result['user'] ?? {}));
        _syncFcmTokenInBackground();
      } else {
        emit(AuthFailure(message: result['detail'] ?? 'Google login failed'));
      }
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  /// Native mobile Google sheet → /google/verify. Mobile-only path.
  Future<void> _onGoogleNative(AuthGoogleNativeRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final fcmToken = await FcmService().getToken();
      final result = await GoogleAuthService.instance.nativeVerify(fcmToken: fcmToken);
      if (result == null) {
        // User cancelled the sheet — return to the login screen.
        emit(AuthUnauthenticated());
        return;
      }
      if (result['statusCode'] == 200) {
        final user = (result['user'] ?? {}) as Map<String, dynamic>;
        if (result['is_new_user'] == true) {
          emit(AuthNewGoogleUser(user: user));
        } else {
          emit(AuthAuthenticated(user: user));
          _syncFcmTokenInBackground();
        }
      } else {
        emit(AuthFailure(message: result['detail'] ?? 'Google sign-in failed'));
      }
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  /// Adopt a session returned by the server-side redirect flow (web callback /
  /// mobile deep link). First-time users are routed to profile completion.
  Future<void> _onGoogleSession(AuthGoogleSessionReceived event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await _api.adoptSessionTokens(token: event.token, refresh: event.refresh);
      if (result['statusCode'] == 200) {
        final user = (result['user'] ?? {}) as Map<String, dynamic>;
        if (result['is_new_user'] == true) {
          emit(AuthNewGoogleUser(user: user));
        } else {
          emit(AuthAuthenticated(user: user));
          _syncFcmTokenInBackground();
        }
      } else {
        emit(AuthFailure(message: result['detail'] ?? 'Google sign-in failed'));
      }
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _onProfileCompleted(AuthProfileCompleted event, Emitter<AuthState> emit) async {
    emit(AuthAuthenticated(user: event.user));
    _syncFcmTokenInBackground();
  }

  Future<void> _onForgotPassword(AuthForgotPasswordRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await _api.forgotPassword(event.email);
      emit(AuthForgotPasswordSuccess(message: result['message'] ?? 'Reset link sent'));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _onLogout(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    try {
      // Empty fcm_token → backend clears BOTH native + web tokens for this account.
      await _api.updateMe({'fcm_token': ''});
    } catch (_) {}
    await FcmService().clearToken();
    if (kIsWeb) WebPushService().clearOnLogout();
    final prefs = await SharedPreferences.getInstance();
    final biometricEnabled = prefs.getBool('biometric_enabled') ?? false;
    await _api.clearTokens(keepForBiometric: biometricEnabled);
    emit(AuthUnauthenticated());
  }

  /// Sync FCM token to backend via PUT /me in background.
  /// Retries getting the token if not available yet.
  void _syncFcmTokenInBackground() {
    Future.delayed(const Duration(seconds: 2), () async {
      try {
        // Web / iOS PWA: the login/signup call already registered the single push
        // token. Don't re-register from here — the device holds only one push
        // registration and a second one invalidated the working token on iOS.
        if (!kIsWeb) {
          await FcmService().ensureTokenSynced();
        }
      } catch (e) {
        debugPrint('FCM background sync failed: $e');
      }
    });
  }
}
