import 'package:equatable/equatable.dart';

abstract class ServiceState extends Equatable {
  const ServiceState();
  @override
  List<Object?> get props => [];
}

class ServiceInitial extends ServiceState {}

class ServiceLoading extends ServiceState {}

class ServiceLoaded extends ServiceState {
  final List<dynamic> services;
  const ServiceLoaded({required this.services});
  @override
  List<Object?> get props => [services];
}

class ServiceFailure extends ServiceState {
  final String message;
  const ServiceFailure({required this.message});
  @override
  List<Object?> get props => [message];
}
