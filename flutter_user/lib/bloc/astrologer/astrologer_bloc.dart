import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import 'astrologer_event.dart';
import 'astrologer_state.dart';

class AstrologerBloc extends Bloc<AstrologerEvent, AstrologerState> {
  final ApiService _api = ApiService();

  /// Reviews page size on the astrologer profile sheet — kept deliberately
  /// small (the rating distribution chart is the headline, not a long
  /// list) and used for both the initial load and each "See More" tap.
  static const int reviewsPageSize = 2;

  AstrologerBloc() : super(const AstrologerState()) {
    on<AstrologerLoadRequested>(_onLoad);
    on<AstrologerSavedLoadRequested>(_onSavedLoad);
    on<AstrologerToggleSave>(_onToggleSave);
    on<AstrologerDetailRequested>(_onDetail);
    on<AstrologerDetailCleared>((e, emit) => emit(state.copyWith(
      clearDetail: true, detailReviews: const [], reviewsTotal: 0,
      reviewsLoadingMore: false, reviewsDistribution: const {},
    )));
    on<AstrologerMoreReviewsRequested>(_onMoreReviews);
  }

  Future<void> _onLoad(AstrologerLoadRequested event, Emitter<AstrologerState> emit) async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      final list = await _api.fetchAstrologers(limit: event.limit, search: event.search, specialization: event.specialization, language: event.language, onlineOnly: event.onlineOnly);
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
    emit(state.copyWith(
      detailLoading: true, clearDetail: true, detailReviews: const [],
      reviewsTotal: 0, reviewsLoadingMore: false, reviewsDistribution: const {},
    ));
    try {
      final detailRes = await _api.fetchAstrologerDetail(event.astrologerId);
      final reviewsRes = await _api.fetchAstrologerReviews(event.astrologerId, limit: reviewsPageSize);
      final reviews = (reviewsRes['reviews'] as List?) ?? const [];
      final total = (reviewsRes['total'] as num?)?.toInt() ?? reviews.length;
      final distribution = (reviewsRes['distribution'] as Map?)?.cast<String, dynamic>() ?? const {};
      if (detailRes['statusCode'] == 200) {
        final detail = Map<String, dynamic>.from(detailRes)..remove('statusCode');
        emit(state.copyWith(
          detailLoading: false, detail: detail, detailReviews: reviews,
          reviewsTotal: total, reviewsDistribution: distribution,
        ));
      } else {
        emit(state.copyWith(detailLoading: false, error: 'Failed to load profile'));
      }
    } catch (e) {
      emit(state.copyWith(detailLoading: false, error: e.toString()));
    }
  }

  /// Appends the next page of reviews for the astrologer currently open in
  /// `state.detail` ("See More" button). A no-op if a page is already in
  /// flight, if the astrologer id doesn't match the open detail (stale tap
  /// after the sheet was closed/reopened), or if everything is loaded.
  Future<void> _onMoreReviews(AstrologerMoreReviewsRequested event, Emitter<AstrologerState> emit) async {
    if (state.reviewsLoadingMore || !state.reviewsHasMore) return;
    if (state.detail == null || state.detail!['id'] != event.astrologerId) return;
    emit(state.copyWith(reviewsLoadingMore: true));
    try {
      final reviewsRes = await _api.fetchAstrologerReviews(
        event.astrologerId, skip: state.detailReviews.length, limit: reviewsPageSize,
      );
      final more = (reviewsRes['reviews'] as List?) ?? const [];
      final total = (reviewsRes['total'] as num?)?.toInt() ?? state.reviewsTotal;
      emit(state.copyWith(
        detailReviews: [...state.detailReviews, ...more],
        reviewsTotal: total,
        reviewsLoadingMore: false,
      ));
    } catch (_) {
      emit(state.copyWith(reviewsLoadingMore: false));
    }
  }
}
