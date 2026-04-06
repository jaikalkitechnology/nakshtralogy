import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final ApiService _api = ApiService();
  static const int pageSize = 10;

  WalletBloc() : super(const WalletState()) {
    on<WalletLoadRequested>(_onLoad);
    on<WalletRechargeRequested>(_onRecharge);
  }

  Future<void> _onLoad(WalletLoadRequested event, Emitter<WalletState> emit) async {
    emit(state.copyWith(loading: true, clearError: true, page: event.page, txnType: event.txnType));
    try {
      final walletRes = await _api.fetchMyWallet();
      final txnRes = await _api.fetchMyWalletTransactions(
        skip: event.page * pageSize,
        limit: pageSize,
        txnType: event.txnType,
      );
      emit(state.copyWith(
        loading: false,
        wallet: walletRes['statusCode'] == 200
            ? Map<String, dynamic>.from(walletRes)..remove('statusCode')
            : state.wallet,
        transactions: txnRes['statusCode'] == 200 ? (txnRes['transactions'] as List? ?? []) : [],
        total: txnRes['statusCode'] == 200 ? (txnRes['total'] as int? ?? 0) : 0,
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onRecharge(WalletRechargeRequested event, Emitter<WalletState> emit) async {
    emit(state.copyWith(recharging: true, clearError: true, clearSuccess: true));
    try {
      final res = await _api.rechargeMyWallet(amount: event.amount, note: event.note);
      if (res['statusCode'] == 200) {
        emit(state.copyWith(
          recharging: false,
          successMessage: res['message'] ?? '₹${event.amount} added',
        ));
        // reload wallet + txns
        add(WalletLoadRequested(page: 0, txnType: state.txnType));
      } else {
        emit(state.copyWith(recharging: false, error: res['detail'] ?? 'Recharge failed'));
      }
    } catch (e) {
      emit(state.copyWith(recharging: false, error: e.toString()));
    }
  }
}
