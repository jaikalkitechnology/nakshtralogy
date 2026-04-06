import 'package:equatable/equatable.dart';

class AstroWalletState extends Equatable {
  final bool loading;
  final Map<String, dynamic>? wallet;  // balance, total_earned, total_withdrawn, withdrawable, withdrawal_config
  final List<dynamic> transactions;
  final int total;
  final int page;
  final String kind;
  final List<dynamic> withdrawals;
  final bool withdrawing;
  final String? error;
  final String? successMessage;

  const AstroWalletState({
    this.loading = false,
    this.wallet,
    this.transactions = const [],
    this.total = 0,
    this.page = 0,
    this.kind = 'all',
    this.withdrawals = const [],
    this.withdrawing = false,
    this.error,
    this.successMessage,
  });

  AstroWalletState copyWith({
    bool? loading,
    Map<String, dynamic>? wallet,
    List<dynamic>? transactions,
    int? total,
    int? page,
    String? kind,
    List<dynamic>? withdrawals,
    bool? withdrawing,
    String? error,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return AstroWalletState(
      loading: loading ?? this.loading,
      wallet: wallet ?? this.wallet,
      transactions: transactions ?? this.transactions,
      total: total ?? this.total,
      page: page ?? this.page,
      kind: kind ?? this.kind,
      withdrawals: withdrawals ?? this.withdrawals,
      withdrawing: withdrawing ?? this.withdrawing,
      error: clearError ? null : (error ?? this.error),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [loading, wallet, transactions, total, page, kind, withdrawals, withdrawing, error, successMessage];
}
