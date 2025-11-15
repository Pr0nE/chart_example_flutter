import 'package:chart_example_flutter/features/chart/domain/models/robot_data_point.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chart_state.freezed.dart';

@freezed
class ChartState with _$ChartState {
  const factory ChartState({
    @Default([]) List<RobotDataPoint> data,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _ChartState;

  const ChartState._();

  bool get hasData => data.isNotEmpty;
  bool get hasError => errorMessage != null;
  bool get isInitial => data.isEmpty && !isLoading && errorMessage == null;
}
