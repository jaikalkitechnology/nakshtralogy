import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hj_core/hj_core.dart';

import 'astro_auth_repository.dart';
import 'google_auth.dart';

part 'astro_session_state.dart';

/// Session state for the astrologer. Drives the router: unauthenticated →
/// welcome; authenticated but not approved → KYC / under-review; else dashboard.
class AstroSessionCubit extends Cubit<AstroSessionState> {
  AstroSessionCubit(this._repo, this._google) : super(const AstroSessionState());

  final AstroAuthRepository _repo;
  final AstroGoogleSignIn _google;

  Future<void> bootstrap() async {
    final astro = await _repo.restoreSession();
    if (astro != null) {
      emit(AstroSessionState(status: SessionStatus.authenticated, astrologer: astro));
    } else {
      emit(const AstroSessionState(status: SessionStatus.unauthenticated));
    }
  }

  void onAuthenticated(Astrologer astro) =>
      emit(AstroSessionState(status: SessionStatus.authenticated, astrologer: astro));

  void update(Astrologer astro) {
    if (state.status == SessionStatus.authenticated) {
      emit(state.copyWith(astrologer: astro));
    }
  }

  Future<void> refresh() async {
    if (state.status != SessionStatus.authenticated) return;
    try {
      update(await _repo.me());
    } catch (_) {/* keep last */}
  }

  Future<void> logout() async {
    await _repo.logout();
    // Sign out of the SAME cached GoogleSignIn instance login built, so the
    // account picker shows again on the next sign-in.
    await _google.signOut();
    emit(const AstroSessionState(status: SessionStatus.unauthenticated));
  }

  void sessionExpired() => emit(const AstroSessionState(status: SessionStatus.unauthenticated));
}
