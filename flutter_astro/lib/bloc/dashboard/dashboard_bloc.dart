import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final ApiService _api = ApiService();

  DashboardBloc() : super(const DashboardState()) {
    on<DashboardLoadRequested>(_onLoad);
  }

  Future<void> _onLoad(DashboardLoadRequested event, Emitter<DashboardState> emit) async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      final statsRes = await _api.getMyStats();
      final recentRes = await _api.getRecentRequests();
      emit(state.copyWith(
        loading: false,
        stats: statsRes['statusCode'] == 200
            ? (Map<String, dynamic>.from(statsRes)..remove('statusCode'))
            : state.stats,
        recentRequests: recentRes['statusCode'] == 200 ? (recentRes['items'] as List? ?? []) : [],
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
