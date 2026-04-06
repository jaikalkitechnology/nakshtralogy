import 'package:equatable/equatable.dart';

class DashboardState extends Equatable {
  final bool loading;
  final Map<String, dynamic>? stats;
  final List<dynamic> recentRequests;
  final String? error;

  const DashboardState({
    this.loading = false,
    this.stats,
    this.recentRequests = const [],
    this.error,
  });

  DashboardState copyWith({
    bool? loading,
    Map<String, dynamic>? stats,
    List<dynamic>? recentRequests,
    String? error,
    bool clearError = false,
  }) {
    return DashboardState(
      loading: loading ?? this.loading,
      stats: stats ?? this.stats,
      recentRequests: recentRequests ?? this.recentRequests,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [loading, stats, recentRequests, error];
}
