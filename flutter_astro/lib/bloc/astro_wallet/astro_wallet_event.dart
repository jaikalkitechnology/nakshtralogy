import 'package:equatable/equatable.dart';

abstract class AstroWalletEvent extends Equatable {
  const AstroWalletEvent();
  @override
  List<Object?> get props => [];
}

class AstroWalletLoadRequested extends AstroWalletEvent {
  final int page;
  final String kind;
  const AstroWalletLoadRequested({this.page = 0, this.kind = 'all'});
  @override
  List<Object?> get props => [page, kind];
}

class AstroWithdrawRequested extends AstroWalletEvent {
  final double amount;
  final String? upiId;
  final String? bankAccountName;
  final String? bankAccountNumber;
  final String? bankIfsc;
  final String? notes;
  const AstroWithdrawRequested({
    required this.amount,
    this.upiId,
    this.bankAccountName,
    this.bankAccountNumber,
    this.bankIfsc,
    this.notes,
  });
  @override
  List<Object?> get props => [amount, upiId, bankAccountName, bankAccountNumber, bankIfsc, notes];
}
