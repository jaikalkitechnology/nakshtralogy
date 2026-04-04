import 'package:equatable/equatable.dart';

abstract class StatusEvent extends Equatable {
  const StatusEvent();
  @override
  List<Object?> get props => [];
}

class StatusToggleOnline extends StatusEvent {
  final bool isOnline;
  const StatusToggleOnline({required this.isOnline});
  @override
  List<Object?> get props => [isOnline];
}
