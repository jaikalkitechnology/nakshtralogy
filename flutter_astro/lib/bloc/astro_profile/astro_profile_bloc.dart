import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import 'astro_profile_event.dart';
import 'astro_profile_state.dart';

class AstroProfileBloc extends Bloc<AstroProfileEvent, AstroProfileState> {
  final ApiService _api = ApiService();

  AstroProfileBloc() : super(const AstroProfileState()) {
    on<AstroProfileLoadRequested>(_onLoad);
    on<AstroProfileUpdateRequested>(_onUpdate);
  }

  Future<void> _onLoad(AstroProfileLoadRequested event, Emitter<AstroProfileState> emit) async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      final res = await _api.getMe();
      if (res['statusCode'] == 200) {
        final me = Map<String, dynamic>.from(res)..remove('statusCode');
        emit(state.copyWith(loading: false, me: me));
      } else {
        emit(state.copyWith(loading: false, error: res['detail'] ?? 'Failed to load profile'));
      }
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onUpdate(AstroProfileUpdateRequested event, Emitter<AstroProfileState> emit) async {
    emit(state.copyWith(saving: true, clearError: true, clearSuccess: true));
    try {
      // 1. Update user-level fields if any provided
      if (event.userFields.isNotEmpty) {
        final r = await _api.updateMeFields(event.userFields);
        if (r['statusCode'] != 200) {
          emit(state.copyWith(saving: false, error: r['detail'] ?? 'User update failed'));
          return;
        }
      }
      // 2. Update astrologer profile fields if any provided
      if (event.profileFields.isNotEmpty) {
        final r = await _api.updateProfile(event.profileFields);
        if (r['statusCode'] != 200) {
          emit(state.copyWith(saving: false, error: r['detail'] ?? 'Profile update failed'));
          return;
        }
      }
      // 3. Reload full me
      final res = await _api.getMe();
      if (res['statusCode'] == 200) {
        final me = Map<String, dynamic>.from(res)..remove('statusCode');
        emit(state.copyWith(saving: false, me: me, successMessage: 'Profile updated'));
      } else {
        emit(state.copyWith(saving: false, successMessage: 'Profile updated'));
      }
    } catch (e) {
      emit(state.copyWith(saving: false, error: e.toString()));
    }
  }
}
