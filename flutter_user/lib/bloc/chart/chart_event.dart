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
  final bool isPrimary;
  final String? serviceKey;
  const ChartCreateRequested({
    required this.name, this.gender, required this.dob,
    required this.tob, required this.place,
    this.isPrimary = false, this.serviceKey,
  });
  @override
  List<Object?> get props => [name, gender, dob, tob, place, isPrimary];
}

class ChartDeleteRequested extends ChartEvent {
  final String chartId;
  const ChartDeleteRequested({required this.chartId});
  @override
  List<Object?> get props => [chartId];
}
