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
  final String? displayName;
  final int? experienceYears;
  final List<String>? languages;
  final List<String>? specializations;
  final String? qualification;
  final String? bio;
  const AuthSignupRequested({
    required this.name, required this.email, required this.password,
    this.phone, this.displayName, this.experienceYears,
    this.languages, this.specializations, this.qualification, this.bio,
  });
  @override
  List<Object?> get props => [name, email, password];
}

class AuthGoogleLoginRequested extends AuthEvent {
  final String idToken;
  const AuthGoogleLoginRequested({required this.idToken});
  @override
  List<Object?> get props => [idToken];
}

class AuthForgotPasswordRequested extends AuthEvent {
  final String email;
  const AuthForgotPasswordRequested({required this.email});
  @override
  List<Object?> get props => [email];
}

class AuthLogoutRequested extends AuthEvent {}
