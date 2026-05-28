import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/api_service.dart';
import '../../services/fcm_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService _api = ApiService();

  AuthBloc() : super(AuthInitial()) {
    on<AuthCheckRequested>(_onCheck);
    on<AuthLoginRequested>(_onLogin);
    on<AuthSignupRequested>(_onSignup);
    on<AuthGoogleLoginRequested>(_onGoogleLogin);
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
      await _api.updateMe({'fcm_token': ''});
    } catch (_) {}
    await FcmService().clearToken();
    await _api.clearTokens();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('biometric_enabled');
    emit(AuthUnauthenticated());
  }

  /// Sync FCM token to backend via PUT /me in background.
  /// Retries getting the token if not available yet.
  void _syncFcmTokenInBackground() {
    Future.delayed(const Duration(seconds: 2), () async {
      try {
        await FcmService().ensureTokenSynced();
      } catch (e) {
        debugPrint('FCM background sync failed: $e');
      }
    });
  }
}
