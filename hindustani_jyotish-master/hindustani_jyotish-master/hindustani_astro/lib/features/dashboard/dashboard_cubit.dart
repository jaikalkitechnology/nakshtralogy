import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hj_core/hj_core.dart';

import '../portal/portal_repository.dart';

class DashboardState extends Equatable {
  const DashboardState({this.data, this.loading = false, this.toggling = false, this.error});

  final Map<String, dynamic>? data;
  final bool loading;
  final bool toggling;
  final String? error;

  bool get isOnline => data?['is_online'] == true;

  DashboardState copyWith({
    Map<String, dynamic>? data,
    bool? loading,
    bool? toggling,
    String? error,
    bool clearError = false,
  }) =>
      DashboardState(
        data: data ?? this.data,
        loading: loading ?? this.loading,
        toggling: toggling ?? this.toggling,
        error: clearError ? null : (error ?? this.error),
      );

  @override
  List<Object?> get props => [data, loading, toggling, error];
}

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._repo) : super(const DashboardState(loading: true));

  final PortalRepository _repo;

  Future<void> load() async => _fetch(initial: true);
  Future<void> refresh() async => _fetch(initial: false);

  Future<void> _fetch({required bool initial}) async {
    if (initial) emit(state.copyWith(loading: true, clearError: true));
    try {
      emit(state.copyWith(data: await _repo.dashboard(), loading: false, clearError: true));
    } on ApiException catch (e) {
      emit(state.copyWith(loading: false, error: e.message));
    }
  }

  Future<void> toggleOnline(bool value) async {
    emit(state.copyWith(toggling: true, clearError: true));
    try {
      final res = await _repo.toggleOnline(value);
      final data = Map<String, dynamic>.of(state.data ?? {})..['is_online'] = res['is_online'];
      emit(state.copyWith(data: data, toggling: false));
    } on ApiException catch (e) {
      emit(state.copyWith(toggling: false, error: e.message));
    }
  }
}
