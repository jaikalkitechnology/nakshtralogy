import 'package:equatable/equatable.dart';

abstract class ChartEvent extends Equatable {
  const ChartEvent();
  @override
  List<Object?> get props => [];
}

class ChartLoadRequested extends ChartEvent {}

class ChartCreateRequested extends ChartEvent {
  final String name;
  final String? gender;
  final String dob;
  final String tob;
  final String place;
  final String? serviceKey;
  const ChartCreateRequested({required this.name, this.gender, required this.dob, required this.tob, required this.place, this.serviceKey});
  @override
  List<Object?> get props => [name, dob, tob, place];
}

class ChartDeleteRequested extends ChartEvent {
  final String chartId;
  const ChartDeleteRequested({required this.chartId});
  @override
  List<Object?> get props => [chartId];
}
