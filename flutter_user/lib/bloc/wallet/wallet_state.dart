import 'package:equatable/equatable.dart';

class WalletState extends Equatable {
  final bool loading;
  final Map<String, dynamic>? wallet;   // balance, total_credit, total_debit
  final List<dynamic> transactions;
  final int total;
  final int page;
  final String txnType;
  final bool recharging;
  final String? error;
  final String? successMessage;

  const WalletState({
    this.loading = false,
    this.wallet,
    this.transactions = const [],
    this.total = 0,
    this.page = 0,
    this.txnType = 'all',
    this.recharging = false,
    this.error,
    this.successMessage,
  });

  WalletState copyWith({
    bool? loading,
    Map<String, dynamic>? wallet,
    List<dynamic>? transactions,
    int? total,
    int? page,
    String? txnType,
    bool? recharging,
    String? error,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return WalletState(
      loading: loading ?? this.loading,
      wallet: wallet ?? this.wallet,
      transactions: transactions ?? this.transactions,
      total: total ?? this.total,
      page: page ?? this.page,
      txnType: txnType ?? this.txnType,
      recharging: recharging ?? this.recharging,
      error: clearError ? null : (error ?? this.error),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [loading, wallet, transactions, total, page, txnType, recharging, error, successMessage];
}
