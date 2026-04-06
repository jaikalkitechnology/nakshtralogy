import 'package:equatable/equatable.dart';

abstract class StatusState extends Equatable {
  const StatusState();
  @override
  List<Object?> get props => [];
}

class StatusIdle extends StatusState {
  final bool isOnline;
  final bool isBusy;
  const StatusIdle({this.isOnline = false, this.isBusy = false});
  @override
  List<Object?> get props => [isOnline, isBusy];
}

class StatusUpdating extends StatusState {}

class StatusFailure extends StatusState {
  final String message;
  const StatusFailure({required this.message});
  @override
  List<Object?> get props => [message];
}
