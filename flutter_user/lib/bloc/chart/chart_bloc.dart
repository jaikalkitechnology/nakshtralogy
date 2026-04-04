import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import 'chart_event.dart';
import 'chart_state.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  final ApiService _api = ApiService();

  ChartBloc() : super(ChartInitial()) {
    on<ChartLoadRequested>(_onLoad);
    on<ChartCreateRequested>(_onCreate);
    on<ChartDeleteRequested>(_onDelete);
  }

  Future<void> _onLoad(ChartLoadRequested event, Emitter<ChartState> emit) async {
    emit(ChartLoading());
    try {
      final charts = await _api.getMyCharts();
      emit(ChartLoaded(charts: charts));
    } catch (e) {
      emit(ChartFailure(message: e.toString()));
    }
  }

  Future<void> _onCreate(ChartCreateRequested event, Emitter<ChartState> emit) async {
    emit(ChartLoading());
    try {
      final result = await _api.createChart(
        name: event.name,
        gender: event.gender,
        dob: event.dob,
        tob: event.tob,
        place: event.place,
        isPrimary: event.isPrimary,
        serviceKey: event.serviceKey,
      );
      if (result['statusCode'] == 201) {
        emit(ChartCreated(chart: result));
        // reload list
        final charts = await _api.getMyCharts();
        emit(ChartLoaded(charts: charts));
      } else {
        emit(ChartFailure(message: result['detail'] ?? 'Failed to create chart'));
      }
    } catch (e) {
      emit(ChartFailure(message: e.toString()));
    }
  }

  Future<void> _onDelete(ChartDeleteRequested event, Emitter<ChartState> emit) async {
    try {
      await _api.deleteChart(event.chartId);
      final charts = await _api.getMyCharts();
      emit(ChartLoaded(charts: charts));
    } catch (e) {
      emit(ChartFailure(message: e.toString()));
    }
  }
}
