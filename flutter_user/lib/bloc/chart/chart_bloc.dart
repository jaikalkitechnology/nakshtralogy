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
        category: event.category,
      );
      if (result['statusCode'] == 201) {
        emit(ChartCreated(chart: result));
        // reload list
        final charts = await _api.getMyCharts();
        emit(ChartLoaded(charts: charts));
      } else if (result['statusCode'] == 402) {
        // Extra-chart paywall: the free Primary is done, this chart needs a
        // one-time `extra_chart` unlock. Detail carries {service_key, price,
        // pricing_id} — surface it so the screen can offer the purchase.
        final d = result['detail'];
        final m = d is Map ? d : const <String, dynamic>{};
        emit(ChartPaymentRequired(
          serviceKey: (m['service_key'] ?? 'extra_chart').toString(),
          price: (m['price'] is num) ? (m['price'] as num).toDouble() : 0,
          pricingId: m['pricing_id']?.toString(),
        ));
      } else {
        final d = result['detail'];
        emit(ChartFailure(message: d is String ? d : 'Failed to create chart'));
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
