import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/chart_io.dart';
import '../domain/models/chart_state.dart';
import '../domain/models/robot_data_point.dart';
import '../domain/repository/chart_repository.dart';

class ChartCubit extends Cubit<ChartState> implements ChartIO {
  final ChartRepository _repository;

  ChartCubit(this._repository) : super(const ChartInitial());

  @override
  Stream<ChartState> get chartStateStream => stream;

  @override
  ChartState get currentState => state;

  @override
  Future<void> loadChartData() async {
    emit(const ChartLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final data = await _repository.getChartData();
      emit(ChartLoaded(data));
    } catch (e) {
      emit(ChartError(e.toString()));
    }
  }

  @override
  Future<void> addDataPoint(DateTime date, int minutes) async {
    final previousState = state;

    try {
      final dateExists = await _repository.dateExists(date);
      if (dateExists) {
        emit(const ChartError('Date already exists'));
        await Future.delayed(const Duration(milliseconds: 100));
        if (previousState is ChartLoaded) {
          emit(ChartLoaded(previousState.data));
        }
        return;
      }

      final dataPoint = RobotDataPoint(date: date, minutesActive: minutes);
      await _repository.addDataPoint(dataPoint);
      await loadChartData();
    } catch (e) {
      emit(ChartError(e.toString()));
      await Future.delayed(const Duration(milliseconds: 100));
      if (previousState is ChartLoaded) {
        emit(ChartLoaded(previousState.data));
      }
    }
  }
}
