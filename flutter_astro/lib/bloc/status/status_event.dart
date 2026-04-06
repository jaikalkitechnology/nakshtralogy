import 'package:equatable/equatable.dart';

abstract class StatusEvent extends Equatable {
  const StatusEvent();
  @override
  List<Object?> get props => [];
}

class StatusLoadRequested extends StatusEvent {}

class StatusToggleOnline extends StatusEvent {
  final bool isOnline;
  const StatusToggleOnline({required this.isOnline});
  @override
  List<Object?> get props => [isOnline];
}

class StatusSetBusy extends StatusEvent {
  final bool isBusy;
  const StatusSetBusy({required this.isBusy});
  @override
  List<Object?> get props => [isBusy];
}
