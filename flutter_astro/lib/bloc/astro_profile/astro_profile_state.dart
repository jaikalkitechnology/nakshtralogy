import 'package:equatable/equatable.dart';

class AstroProfileState extends Equatable {
  final bool loading;
  final bool saving;
  final Map<String, dynamic>? me;  // Full response from GET /astrologer/me
  final String? error;
  final String? successMessage;

  const AstroProfileState({
    this.loading = false,
    this.saving = false,
    this.me,
    this.error,
    this.successMessage,
  });

  AstroProfileState copyWith({
    bool? loading,
    bool? saving,
    Map<String, dynamic>? me,
    String? error,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return AstroProfileState(
      loading: loading ?? this.loading,
      saving: saving ?? this.saving,
      me: me ?? this.me,
      error: clearError ? null : (error ?? this.error),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [loading, saving, me, error, successMessage];
}
