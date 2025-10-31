import '../models/robot_data_point.dart';

abstract class ChartRepository {
  Future<List<RobotDataPoint>> getChartData();
  Future<void> addDataPoint(RobotDataPoint dataPoint);
  Future<bool> dateExists(DateTime date);
}
