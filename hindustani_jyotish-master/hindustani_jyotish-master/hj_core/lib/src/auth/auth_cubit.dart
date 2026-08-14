import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/user.dart';
import 'auth_repository.dart';

part 'auth_state.dart';

/// Single source of truth for session state; drives the go_router auth guard.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repo) : super(const AuthState());

  final AuthRepository _repo;

  /// Cold-start: try to restore a session from secure storage.
  Future<void> bootstrap() async {
    final user = await _repo.restoreSession();
    if (user != null) {
      emit(AuthState(status: AuthStatus.authenticated, user: user));
    } else {
      emit(const AuthState(status: AuthStatus.unauthenticated));
    }
  }

  void onAuthenticated(AppUser user) =>
      emit(AuthState(status: AuthStatus.authenticated, user: user));

  void updateUser(AppUser user) {
    if (state.isAuthenticated) emit(state.copyWith(user: user));
  }

  Future<void> refreshMe() async {
    if (!state.isAuthenticated) return;
    try {
      updateUser(await _repo.me());
    } catch (_) {/* keep last known */}
  }

  Future<void> logout() async {
    await _repo.logout();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  /// Delete the account, then drop to the unauthenticated state. Rethrows on
  /// failure (e.g. a 409 guard) so the caller can show the reason and stay
  /// signed in.
  Future<void> deleteAccount() async {
    await _repo.deleteAccount();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  void sessionExpired() => emit(const AuthState(status: AuthStatus.unauthenticated));
}
