import 'chart_state.dart';

abstract class ChartIO {
  Stream<ChartState> get chartStateStream;
  ChartState get currentState;

  Future<void> loadChartData();
  Future<void> addDataPoint(DateTime date, int minutes);
}
