import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import 'astrologer_event.dart';
import 'astrologer_state.dart';

class AstrologerBloc extends Bloc<AstrologerEvent, AstrologerState> {
  final ApiService _api = ApiService();

  AstrologerBloc() : super(const AstrologerState()) {
    on<AstrologerLoadRequested>(_onLoad);
    on<AstrologerSavedLoadRequested>(_onSavedLoad);
    on<AstrologerToggleSave>(_onToggleSave);
    on<AstrologerDetailRequested>(_onDetail);
    on<AstrologerDetailCleared>((e, emit) => emit(state.copyWith(clearDetail: true, detailReviews: const [])));
  }

  Future<void> _onLoad(AstrologerLoadRequested event, Emitter<AstrologerState> emit) async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      final list = await _api.fetchAstrologers(limit: event.limit, search: event.search);
      emit(state.copyWith(loading: false, list: list));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onSavedLoad(AstrologerSavedLoadRequested event, Emitter<AstrologerState> emit) async {
    try {
      final res = await _api.fetchMySavedAstrologers();
      if (res['statusCode'] == 200) {
        final saved = (res['saved'] as List?) ?? [];
        final ids = saved.map<String>((a) => a['id'] as String).toSet();
        emit(state.copyWith(saved: saved, savedIds: ids));
      }
    } catch (_) {}
  }

  Future<void> _onToggleSave(AstrologerToggleSave event, Emitter<AstrologerState> emit) async {
    final id = event.astrologerId;
    try {
      if (state.savedIds.contains(id)) {
        await _api.unsaveAstrologer(id);
      } else {
        await _api.saveAstrologer(id);
      }
      // Reload saved list
      final res = await _api.fetchMySavedAstrologers();
      if (res['statusCode'] == 200) {
        final saved = (res['saved'] as List?) ?? [];
        final ids = saved.map<String>((a) => a['id'] as String).toSet();
        emit(state.copyWith(saved: saved, savedIds: ids));
      }
    } catch (_) {}
  }

  Future<void> _onDetail(AstrologerDetailRequested event, Emitter<AstrologerState> emit) async {
    emit(state.copyWith(detailLoading: true, clearDetail: true, detailReviews: const []));
    try {
      final detailRes = await _api.fetchAstrologerDetail(event.astrologerId);
      final reviewsRes = await _api.fetchAstrologerReviews(event.astrologerId, limit: 10);
      final reviews = (reviewsRes['reviews'] as List?) ?? const [];
      if (detailRes['statusCode'] == 200) {
        final detail = Map<String, dynamic>.from(detailRes)..remove('statusCode');
        emit(state.copyWith(detailLoading: false, detail: detail, detailReviews: reviews));
      } else {
        emit(state.copyWith(detailLoading: false, error: 'Failed to load profile'));
      }
    } catch (e) {
      emit(state.copyWith(detailLoading: false, error: e.toString()));
    }
  }
}
