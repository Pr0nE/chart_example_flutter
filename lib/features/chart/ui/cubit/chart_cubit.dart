import 'package:chart_example_flutter/features/chart/ui/cubit/chart_state.dart';
import 'package:chart_example_flutter/features/chart/domain/models/robot_data_point.dart';
import 'package:chart_example_flutter/features/chart/domain/repository/chart_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChartCubit extends Cubit<ChartState> {
  final ChartRepository _repository;

  ChartCubit(this._repository) : super(const ChartState());

  Future<void> loadChartData() async {
    emit(state.clearError().copyWith(isLoading: true));

    try {
      final data = await _repository.getChartData();
      emit(state.clearError().copyWith(data: data, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> addDataPoint(DateTime date, int minutes) async {
    try {
      final dateExists = await _repository.dateExists(date);
      if (dateExists) {
        emit(state.copyWith(errorMessage: 'Date already exists'));
        return;
      }

      final dataPoint = RobotDataPoint(date: date, minutesActive: minutes);
      await _repository.addDataPoint(dataPoint);
      await loadChartData();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void clearError() {
    emit(state.clearError());
  }
}
