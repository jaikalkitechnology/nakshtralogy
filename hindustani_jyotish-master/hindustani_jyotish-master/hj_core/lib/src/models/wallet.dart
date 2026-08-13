import 'package:equatable/equatable.dart';

class WalletTransaction extends Equatable {
  const WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.balanceAfter,
    required this.status,
    required this.createdAt,
    this.referenceId,
  });

  final String id;
  final String type;
  final String amount; // signed string
  final String balanceAfter;
  final String status;
  final String createdAt;
  final String? referenceId;

  bool get isCredit => !amount.startsWith('-');

  factory WalletTransaction.fromJson(Map<String, dynamic> j) => WalletTransaction(
        id: j['id'] as String,
        type: j['type'] as String,
        amount: '${j['amount']}',
        balanceAfter: '${j['balance_after']}',
        status: j['status'] as String,
        createdAt: j['created_at'] as String,
        referenceId: j['reference_id'] as String?,
      );

  @override
  List<Object?> get props => [id, amount, balanceAfter, status];
}

class Wallet {
  const Wallet({required this.balance, required this.transactions});

  final String balance;
  final List<WalletTransaction> transactions;

  factory Wallet.fromJson(Map<String, dynamic> j) => Wallet(
        balance: '${j['balance']}',
        transactions: (j['transactions'] as List)
            .map((e) => WalletTransaction.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
