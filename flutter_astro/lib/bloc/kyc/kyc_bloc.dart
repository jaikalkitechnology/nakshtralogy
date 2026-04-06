import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import 'kyc_event.dart';
import 'kyc_state.dart';

class KycBloc extends Bloc<KycEvent, KycState> {
  final ApiService _api = ApiService();

  KycBloc() : super(const KycState()) {
    on<KycStatusRequested>(_onStatus);
    on<KycSubmitRequested>(_onSubmit);
  }

  Future<void> _onStatus(KycStatusRequested event, Emitter<KycState> emit) async {
    emit(state.copyWith(status: 'loading', clearError: true));
    try {
      final res = await _api.getKycStatus();
      if (res['statusCode'] == 200) {
        emit(state.copyWith(
          status: res['status'] ?? 'none',
          message: res['message'] as String?,
          rejectionReason: res['rejection_reason'] as String?,
          docType: res['doc_type'] as String?,
          docNumber: res['doc_number'] as String?,
          submittedAt: res['submitted_at'] as String?,
        ));
      } else {
        emit(state.copyWith(status: 'error', error: res['detail'] ?? 'Failed to load KYC status'));
      }
    } catch (e) {
      emit(state.copyWith(status: 'error', error: e.toString()));
    }
  }

  Future<void> _onSubmit(KycSubmitRequested event, Emitter<KycState> emit) async {
    emit(state.copyWith(submitting: true, clearError: true));
    try {
      final res = await _api.submitKyc(
        docType: event.docType,
        docNumber: event.docNumber,
        frontUrl: event.frontUrl,
        backUrl: event.backUrl,
        selfieUrl: event.selfieUrl,
      );
      if (res['statusCode'] == 200) {
        emit(state.copyWith(submitting: false, status: 'pending', message: res['message'] as String?));
        // reload for fresh data
        add(KycStatusRequested());
      } else {
        emit(state.copyWith(submitting: false, error: res['detail'] ?? 'Submission failed'));
      }
    } catch (e) {
      emit(state.copyWith(submitting: false, error: e.toString()));
    }
  }
}
