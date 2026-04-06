import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final bool loading;
  final bool saving;
  final Map<String, dynamic>? me;
  final List<dynamic> orders;
  final int ordersTotal;
  final String? error;
  final String? successMessage;

  const ProfileState({
    this.loading = false,
    this.saving = false,
    this.me,
    this.orders = const [],
    this.ordersTotal = 0,
    this.error,
    this.successMessage,
  });

  ProfileState copyWith({
    bool? loading,
    bool? saving,
    Map<String, dynamic>? me,
    List<dynamic>? orders,
    int? ordersTotal,
    String? error,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return ProfileState(
      loading: loading ?? this.loading,
      saving: saving ?? this.saving,
      me: me ?? this.me,
      orders: orders ?? this.orders,
      ordersTotal: ordersTotal ?? this.ordersTotal,
      error: clearError ? null : (error ?? this.error),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [loading, saving, me, orders, ordersTotal, error, successMessage];
}
