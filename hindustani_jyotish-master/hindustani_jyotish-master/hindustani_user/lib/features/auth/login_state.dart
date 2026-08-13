part of 'login_cubit.dart';

enum LoginStatus { idle, googleSigningIn, success, failure }

class LoginState extends Equatable {
  const LoginState({this.status = LoginStatus.idle, this.error});

  final LoginStatus status;
  final String? error;

  bool get isBusy => status == LoginStatus.googleSigningIn;

  LoginState copyWith({
    LoginStatus? status,
    String? error,
    bool clearError = false,
  }) =>
      LoginState(
        status: status ?? this.status,
        error: clearError ? null : (error ?? this.error),
      );

  @override
  List<Object?> get props => [status, error];
}
