import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import '../../services/app_mode.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ApiService _api = ApiService();

  ProfileBloc() : super(const ProfileState()) {
    on<ProfileLoadRequested>(_onLoad);
    on<ProfileUpdateRequested>(_onUpdate);
    on<ProfileOrdersLoadRequested>(_onOrders);
  }

  Future<void> _onLoad(ProfileLoadRequested event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      final res = await _api.getMe();
      if (res['statusCode'] == 200) {
        final me = Map<String, dynamic>.from(res)..remove('statusCode');
        emit(state.copyWith(loading: false, me: me));
        // Safeguard: feed the declared profile country into region resolution
        // so a device UI-language of "English (US)" can't force USD/international.
        AppMode.instance.setProfileCountry(
            me['country_code']?.toString(), me['phone']?.toString());
      } else {
        emit(state.copyWith(loading: false, error: res['detail'] ?? 'Failed to load profile'));
      }
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
    // also load orders
    add(ProfileOrdersLoadRequested());
  }

  Future<void> _onUpdate(ProfileUpdateRequested event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(saving: true, clearError: true, clearSuccess: true));
    try {
      final res = await _api.updateMe(event.fields);
      if (res['statusCode'] == 200) {
        final me = Map<String, dynamic>.from(res)..remove('statusCode');
        emit(state.copyWith(saving: false, me: me, successMessage: 'Profile updated'));
      } else {
        emit(state.copyWith(saving: false, error: res['detail'] ?? 'Update failed'));
      }
    } catch (e) {
      emit(state.copyWith(saving: false, error: e.toString()));
    }
  }

  Future<void> _onOrders(ProfileOrdersLoadRequested event, Emitter<ProfileState> emit) async {
    try {
      final res = await _api.fetchMyOrdersPaginated(limit: 20);
      if (res['statusCode'] == 200) {
        final orders = (res['orders'] as List?) ?? [];
        final total = res['total'] as int? ?? 0;
        emit(state.copyWith(orders: orders, ordersTotal: total));
      }
    } catch (_) {}
  }
}
