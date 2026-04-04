import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import 'status_event.dart';
import 'status_state.dart';

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  final ApiService _api = ApiService();

  StatusBloc() : super(const StatusIdle()) {
    on<StatusToggleOnline>(_onToggle);
  }

  Future<void> _onToggle(StatusToggleOnline event, Emitter<StatusState> emit) async {
    emit(StatusUpdating());
    try {
      await _api.updateStatus(isOnline: event.isOnline);
      emit(StatusIdle(isOnline: event.isOnline));
    } catch (e) {
      emit(StatusFailure(message: e.toString()));
    }
  }
}
