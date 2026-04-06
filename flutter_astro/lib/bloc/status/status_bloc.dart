import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import 'status_event.dart';
import 'status_state.dart';

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  final ApiService _api = ApiService();

  StatusBloc() : super(const StatusIdle()) {
    on<StatusLoadRequested>(_onLoad);
    on<StatusToggleOnline>(_onToggle);
    on<StatusSetBusy>(_onSetBusy);
  }

  Future<void> _onLoad(StatusLoadRequested event, Emitter<StatusState> emit) async {
    try {
      final res = await _api.getMe();
      if (res['statusCode'] == 200) {
        final profile = res['astrologer_profile'] ?? {};
        emit(StatusIdle(
          isOnline: profile['is_online'] == true,
          isBusy: profile['is_busy'] == true,
        ));
      }
    } catch (_) {}
  }

  Future<void> _onToggle(StatusToggleOnline event, Emitter<StatusState> emit) async {
    final prev = state is StatusIdle ? state as StatusIdle : const StatusIdle();
    emit(StatusUpdating());
    try {
      await _api.updateStatus(isOnline: event.isOnline, isBusy: false);
      emit(StatusIdle(isOnline: event.isOnline, isBusy: false));
    } catch (e) {
      emit(StatusIdle(isOnline: prev.isOnline, isBusy: prev.isBusy));
    }
  }

  Future<void> _onSetBusy(StatusSetBusy event, Emitter<StatusState> emit) async {
    final prev = state is StatusIdle ? state as StatusIdle : const StatusIdle();
    try {
      await _api.updateStatus(isBusy: event.isBusy);
      emit(StatusIdle(isOnline: prev.isOnline, isBusy: event.isBusy));
    } catch (_) {}
  }
}
