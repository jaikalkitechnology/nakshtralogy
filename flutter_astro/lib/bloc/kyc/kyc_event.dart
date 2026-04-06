import 'package:equatable/equatable.dart';

abstract class KycEvent extends Equatable {
  const KycEvent();
  @override
  List<Object?> get props => [];
}

class KycStatusRequested extends KycEvent {}

class KycSubmitRequested extends KycEvent {
  final String docType;
  final String? docNumber;
  final String? frontUrl;
  final String? backUrl;
  final String? selfieUrl;
  const KycSubmitRequested({
    required this.docType,
    this.docNumber,
    this.frontUrl,
    this.backUrl,
    this.selfieUrl,
  });
  @override
  List<Object?> get props => [docType, docNumber, frontUrl, backUrl, selfieUrl];
}
