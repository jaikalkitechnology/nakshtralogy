import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import 'service_event.dart';
import 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final ApiService _api = ApiService();

  ServiceBloc() : super(ServiceInitial()) {
    on<ServiceLoadRequested>(_onLoad);
  }

  Future<void> _onLoad(ServiceLoadRequested event, Emitter<ServiceState> emit) async {
    emit(ServiceLoading());
    try {
      final services = await _api.getServicePricing(category: event.category);
      emit(ServiceLoaded(services: services));
    } catch (e) {
      emit(ServiceFailure(message: e.toString()));
    }
  }
}
