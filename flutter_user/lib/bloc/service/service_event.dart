import 'package:equatable/equatable.dart';

abstract class ServiceEvent extends Equatable {
  const ServiceEvent();
  @override
  List<Object?> get props => [];
}

class ServiceLoadRequested extends ServiceEvent {
  final String? category;
  const ServiceLoadRequested({this.category});
  @override
  List<Object?> get props => [category];
}
