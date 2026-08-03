import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
  const AuthLoginRequested({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

class AuthSignupRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String? phone;
  const AuthSignupRequested({required this.name, required this.email, required this.password, this.phone});
  @override
  List<Object?> get props => [name, email, password, phone];
}

class AuthGoogleLoginRequested extends AuthEvent {
  final String idToken;
  const AuthGoogleLoginRequested({required this.idToken});
  @override
  List<Object?> get props => [idToken];
}

/// Native mobile Google sheet → id_token → POST /google/verify. No web use.
class AuthGoogleNativeRequested extends AuthEvent {
  const AuthGoogleNativeRequested();
}

/// A session handed back by the server-side redirect flow (web callback route
/// or mobile deep link carrying `?token=&refresh=`).
class AuthGoogleSessionReceived extends AuthEvent {
  final String token;
  final String refresh;
  const AuthGoogleSessionReceived({required this.token, required this.refresh});
  @override
  List<Object?> get props => [token, refresh];
}

/// A first-time Google user finished the profile/region/language step.
class AuthProfileCompleted extends AuthEvent {
  final Map<String, dynamic> user;
  const AuthProfileCompleted({required this.user});
  @override
  List<Object?> get props => [user];
}

class AuthForgotPasswordRequested extends AuthEvent {
  final String email;
  const AuthForgotPasswordRequested({required this.email});
  @override
  List<Object?> get props => [email];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthBiometricVerified extends AuthEvent {}

class AuthBiometricSkipped extends AuthEvent {}
