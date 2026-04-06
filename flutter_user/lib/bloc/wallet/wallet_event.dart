import 'package:equatable/equatable.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();
  @override
  List<Object?> get props => [];
}

class WalletLoadRequested extends WalletEvent {
  final int page;
  final String txnType;
  const WalletLoadRequested({this.page = 0, this.txnType = 'all'});
  @override
  List<Object?> get props => [page, txnType];
}

class WalletRechargeRequested extends WalletEvent {
  final double amount;
  final String? note;
  const WalletRechargeRequested({required this.amount, this.note});
  @override
  List<Object?> get props => [amount, note];
}
