import 'package:equatable/equatable.dart';
import 'robot_data_point.dart';

abstract class ChartState extends Equatable {
  const ChartState();

  @override
  List<Object?> get props => [];
}

class ChartInitial extends ChartState {
  const ChartInitial();
}

class ChartLoading extends ChartState {
  const ChartLoading();
}

class ChartLoaded extends ChartState {
  final List<RobotDataPoint> data;

  const ChartLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class ChartError extends ChartState {
  final String message;

  const ChartError(this.message);

  @override
  List<Object?> get props => [message];
}
