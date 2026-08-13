import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hj_core/hj_core.dart';

import 'discovery_repository.dart';

/// Filter/sort/search inputs that drive the `/astrologers` query params.
class AstrologerFilters extends Equatable {
  const AstrologerFilters({
    this.sort = 'top_rated',
    this.onlineOnly = false,
    this.language,
    this.skill,
    this.search = '',
  });

  final String sort;
  final bool onlineOnly;
  final String? language;
  final String? skill;
  final String search;

  AstrologerFilters copyWith({
    String? sort,
    bool? onlineOnly,
    String? language,
    String? skill,
    String? search,
    bool clearLanguage = false,
    bool clearSkill = false,
  }) => AstrologerFilters(
    sort: sort ?? this.sort,
    onlineOnly: onlineOnly ?? this.onlineOnly,
    language: clearLanguage ? null : (language ?? this.language),
    skill: clearSkill ? null : (skill ?? this.skill),
    search: search ?? this.search,
  );

  int get activeCount =>
      (onlineOnly ? 1 : 0) +
      (language != null ? 1 : 0) +
      (skill != null ? 1 : 0);

  @override
  List<Object?> get props => [sort, onlineOnly, language, skill, search];
}

class AstrologersState extends Equatable {
  const AstrologersState({
    this.astrologers,
    this.loading = false,
    this.loadingMore = false,
    this.error,
    this.filters = const AstrologerFilters(),
    this.hasMore = true,
    this.page = 1,
  });

  final List<Astrologer>? astrologers;
  final bool loading;
  final bool loadingMore;
  final String? error;
  final AstrologerFilters filters;
  final bool hasMore;
  final int page;

  AstrologersState copyWith({
    List<Astrologer>? astrologers,
    bool? loading,
    bool? loadingMore,
    String? error,
    AstrologerFilters? filters,
    bool? hasMore,
    int? page,
    bool clearError = false,
  }) => AstrologersState(
    astrologers: astrologers ?? this.astrologers,
    loading: loading ?? this.loading,
    loadingMore: loadingMore ?? this.loadingMore,
    error: clearError ? null : (error ?? this.error),
    filters: filters ?? this.filters,
    hasMore: hasMore ?? this.hasMore,
    page: page ?? this.page,
  );

  @override
  List<Object?> get props => [
    astrologers,
    loading,
    loadingMore,
    error,
    filters,
    hasMore,
    page,
  ];
}

class AstrologersCubit extends Cubit<AstrologersState> {
  AstrologersCubit(this._repo) : super(const AstrologersState(loading: true));

  final DiscoveryRepository _repo;

  static const int _pageSize = 20;

  Future<void> load() => _fetch(reset: true, initial: true);
  Future<void> refresh() => _fetch(reset: true, initial: false);

  void setSort(String sort) {
    if (sort == state.filters.sort) return;
    emit(state.copyWith(filters: state.filters.copyWith(sort: sort)));
    _fetch(reset: true, initial: true);
  }

  void setOnlineOnly(bool value) {
    emit(state.copyWith(filters: state.filters.copyWith(onlineOnly: value)));
    _fetch(reset: true, initial: true);
  }

  void setLanguage(String? language) {
    emit(
      state.copyWith(
        filters: state.filters.copyWith(
          language: language,
          clearLanguage: language == null,
        ),
      ),
    );
    _fetch(reset: true, initial: true);
  }

  void setSkill(String? skill) {
    emit(
      state.copyWith(
        filters: state.filters.copyWith(
          skill: skill,
          clearSkill: skill == null,
        ),
      ),
    );
    _fetch(reset: true, initial: true);
  }

  void setSearch(String value) {
    emit(state.copyWith(filters: state.filters.copyWith(search: value)));
    _fetch(reset: true, initial: true);
  }

  void clearFilters() {
    final search = state.filters.search;
    emit(state.copyWith(filters: AstrologerFilters(search: search)));
    _fetch(reset: true, initial: true);
  }

  /// Loads the next page for infinite scroll. No-op while already busy or when
  /// the last page returned fewer than a full page of results.
  Future<void> loadMore() async {
    if (state.loading || state.loadingMore || !state.hasMore) return;
    final f = state.filters;
    final nextPage = state.page + 1;
    emit(state.copyWith(loadingMore: true, clearError: true));
    try {
      final more = await _repo.list(
        sort: f.sort,
        online: f.onlineOnly ? true : null,
        language: f.language,
        skill: f.skill,
        search: f.search,
        page: nextPage,
        pageSize: _pageSize,
      );
      emit(
        state.copyWith(
          astrologers: [...?state.astrologers, ...more],
          loadingMore: false,
          page: nextPage,
          hasMore: more.length >= _pageSize,
        ),
      );
    } on ApiException catch (e) {
      emit(state.copyWith(loadingMore: false, error: e.message));
    }
  }

  Future<void> _fetch({required bool reset, required bool initial}) async {
    final f = state.filters;
    if (initial) {
      emit(state.copyWith(loading: true, clearError: true, page: 1));
    }
    try {
      final list = await _repo.list(
        sort: f.sort,
        online: f.onlineOnly ? true : null,
        language: f.language,
        skill: f.skill,
        search: f.search,
        page: 1,
        pageSize: _pageSize,
      );
      emit(
        state.copyWith(
          astrologers: list,
          loading: false,
          clearError: true,
          page: 1,
          hasMore: list.length >= _pageSize,
        ),
      );
    } on ApiException catch (e) {
      emit(state.copyWith(loading: false, error: e.message));
    }
  }
}
