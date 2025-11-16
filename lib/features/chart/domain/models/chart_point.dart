import 'package:chart_example_flutter/features/chart/domain/models/robot_data_point.dart';

class ChartPoint {
  final int index;
  final double x;
  final double y;
  final RobotDataPoint data;

  const ChartPoint({
    required this.index,
    required this.x,
    required this.y,
    required this.data,
  });
}
