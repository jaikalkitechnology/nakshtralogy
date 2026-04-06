import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import 'astro_wallet_event.dart';
import 'astro_wallet_state.dart';

class AstroWalletBloc extends Bloc<AstroWalletEvent, AstroWalletState> {
  final ApiService _api = ApiService();
  static const int pageSize = 10;

  AstroWalletBloc() : super(const AstroWalletState()) {
    on<AstroWalletLoadRequested>(_onLoad);
    on<AstroWithdrawRequested>(_onWithdraw);
  }

  Future<void> _onLoad(AstroWalletLoadRequested event, Emitter<AstroWalletState> emit) async {
    emit(state.copyWith(loading: true, clearError: true, page: event.page, kind: event.kind));
    try {
      final walletRes = await _api.getMyWallet();
      final txnRes = await _api.getMyWalletTransactions(
        skip: event.page * pageSize,
        limit: pageSize,
        kind: event.kind,
      );
      final withdrawalsRes = await _api.getMyWithdrawals(limit: 10);
      emit(state.copyWith(
        loading: false,
        wallet: walletRes['statusCode'] == 200
            ? (Map<String, dynamic>.from(walletRes)..remove('statusCode'))
            : state.wallet,
        transactions: txnRes['statusCode'] == 200 ? (txnRes['transactions'] as List? ?? []) : [],
        total: txnRes['statusCode'] == 200 ? (txnRes['total'] as int? ?? 0) : 0,
        withdrawals: withdrawalsRes['statusCode'] == 200 ? (withdrawalsRes['withdrawals'] as List? ?? []) : [],
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onWithdraw(AstroWithdrawRequested event, Emitter<AstroWalletState> emit) async {
    emit(state.copyWith(withdrawing: true, clearError: true, clearSuccess: true));
    try {
      final res = await _api.requestWithdrawal(
        amount: event.amount,
        upiId: event.upiId,
        bankAccountName: event.bankAccountName,
        bankAccountNumber: event.bankAccountNumber,
        bankIfsc: event.bankIfsc,
        notes: event.notes,
      );
      if (res['statusCode'] == 200) {
        emit(state.copyWith(withdrawing: false, successMessage: res['message'] as String? ?? 'Withdrawal requested'));
        add(AstroWalletLoadRequested(page: 0, kind: state.kind));
      } else {
        emit(state.copyWith(withdrawing: false, error: res['detail'] ?? 'Withdrawal failed'));
      }
    } catch (e) {
      emit(state.copyWith(withdrawing: false, error: e.toString()));
    }
  }
}
