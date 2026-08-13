part of 'login_cubit.dart';

enum LoginStatus { idle, googleSigningIn, success, failure }

class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.idle,
    this.error,
    this.webGoogleSignIn,
  });

  final LoginStatus status;
  final String? error;

  /// Web only: the [GoogleSignIn] instance once `LoginCubit` has resolved the
  /// client id and built it — the GIS "Sign in with Google" button (see
  /// `google_web_button_web.dart`) is only rendered once this is non-null, so
  /// it never renders against an uninitialized plugin. Always null on mobile.
  final GoogleSignIn? webGoogleSignIn;

  bool get isBusy => status == LoginStatus.googleSigningIn;

  LoginState copyWith({
    LoginStatus? status,
    String? error,
    bool clearError = false,
    GoogleSignIn? webGoogleSignIn,
  }) =>
      LoginState(
        status: status ?? this.status,
        error: clearError ? null : (error ?? this.error),
        webGoogleSignIn: webGoogleSignIn ?? this.webGoogleSignIn,
      );

  @override
  List<Object?> get props => [status, error, webGoogleSignIn];
}
