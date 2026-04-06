import 'package:equatable/equatable.dart';

/// status values: loading | none | pending | approved | rejected | error
class KycState extends Equatable {
  final String status;
  final String? message;
  final String? rejectionReason;
  final String? docType;
  final String? docNumber;
  final String? submittedAt;
  final bool submitting;
  final String? error;

  const KycState({
    this.status = 'loading',
    this.message,
    this.rejectionReason,
    this.docType,
    this.docNumber,
    this.submittedAt,
    this.submitting = false,
    this.error,
  });

  KycState copyWith({
    String? status,
    String? message,
    String? rejectionReason,
    String? docType,
    String? docNumber,
    String? submittedAt,
    bool? submitting,
    String? error,
    bool clearError = false,
  }) {
    return KycState(
      status: status ?? this.status,
      message: message ?? this.message,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      docType: docType ?? this.docType,
      docNumber: docNumber ?? this.docNumber,
      submittedAt: submittedAt ?? this.submittedAt,
      submitting: submitting ?? this.submitting,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [status, message, rejectionReason, docType, docNumber, submittedAt, submitting, error];
}
