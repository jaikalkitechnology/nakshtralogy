import 'package:equatable/equatable.dart';

class AstrologerState extends Equatable {
  final bool loading;
  final List<dynamic> list;
  final List<dynamic> saved;
  final Set<String> savedIds;
  final String? error;
  final bool detailLoading;
  final Map<String, dynamic>? detail;
  final List<dynamic> detailReviews;
  final int reviewsTotal;
  final bool reviewsLoadingMore;
  final Map<String, dynamic> reviewsDistribution;

  const AstrologerState({
    this.loading = false,
    this.list = const [],
    this.saved = const [],
    this.savedIds = const {},
    this.error,
    this.detailLoading = false,
    this.detail,
    this.detailReviews = const [],
    this.reviewsTotal = 0,
    this.reviewsLoadingMore = false,
    this.reviewsDistribution = const {},
  });

  bool get reviewsHasMore => detailReviews.length < reviewsTotal;

  AstrologerState copyWith({
    bool? loading,
    List<dynamic>? list,
    List<dynamic>? saved,
    Set<String>? savedIds,
    String? error,
    bool? detailLoading,
    Map<String, dynamic>? detail,
    List<dynamic>? detailReviews,
    int? reviewsTotal,
    bool? reviewsLoadingMore,
    Map<String, dynamic>? reviewsDistribution,
    bool clearDetail = false,
    bool clearError = false,
  }) {
    return AstrologerState(
      loading: loading ?? this.loading,
      list: list ?? this.list,
      saved: saved ?? this.saved,
      savedIds: savedIds ?? this.savedIds,
      error: clearError ? null : (error ?? this.error),
      detailLoading: detailLoading ?? this.detailLoading,
      detail: clearDetail ? null : (detail ?? this.detail),
      detailReviews: detailReviews ?? this.detailReviews,
      reviewsTotal: reviewsTotal ?? this.reviewsTotal,
      reviewsLoadingMore: reviewsLoadingMore ?? this.reviewsLoadingMore,
      reviewsDistribution: reviewsDistribution ?? this.reviewsDistribution,
    );
  }

  @override
  List<Object?> get props => [
        loading, list, saved, savedIds, error, detailLoading, detail,
        detailReviews, reviewsTotal, reviewsLoadingMore, reviewsDistribution,
      ];
}
