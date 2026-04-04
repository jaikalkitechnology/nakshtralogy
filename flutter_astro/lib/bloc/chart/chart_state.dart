import 'package:equatable/equatable.dart';

abstract class ChartState extends Equatable {
  const ChartState();
  @override
  List<Object?> get props => [];
}

class ChartInitial extends ChartState {}
class ChartLoading extends ChartState {}

class ChartLoaded extends ChartState {
  final List<dynamic> charts;
  const ChartLoaded({required this.charts});
  @override
  List<Object?> get props => [charts];
}

class ChartCreated extends ChartState {
  final Map<String, dynamic> chart;
  const ChartCreated({required this.chart});
  @override
  List<Object?> get props => [chart];
}

class ChartFailure extends ChartState {
  final String message;
  const ChartFailure({required this.message});
  @override
  List<Object?> get props => [message];
}
