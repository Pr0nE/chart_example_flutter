import 'dart:convert';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chart_example_flutter/features/chart/ui/cubit/chart_cubit.dart';
import 'package:chart_example_flutter/features/chart/data/chart_repository_impl.dart';
import 'package:chart_example_flutter/features/chart/ui/cubit/chart_state.dart';

void main() {
  late ChartCubit chartCubit;
  late ChartRepositoryImpl chartRepository;

  // Helper to create initial test data
  List<Map<String, dynamic>> getInitialTestData() {
    return List.generate(7, (index) {
      final date = DateTime(2025, 10, 8 + index);
      return {
        'date': date.toIso8601String(),
        'duration': 100 + (index * 50),
      };
    });
  }

  setUp(() async {
    // Pre-populate SharedPreferences with initial data
    final initialData = getInitialTestData();
    SharedPreferences.setMockInitialValues({
      'chart_data': json.encode(initialData),
    });
    final sharedPreferences = await SharedPreferences.getInstance();
    chartRepository = ChartRepositoryImpl(sharedPreferences: sharedPreferences);
    chartCubit = ChartCubit(chartRepository);
  });

  tearDown(() {
    chartCubit.close();
  });

  group('ChartCubit', () {
    test('initial state is correct', () {
      expect(chartCubit.state.isInitial, true);
      expect(chartCubit.state.isLoading, false);
      expect(chartCubit.state.errorMessage, null);
      expect(chartCubit.state.data, []);
    });

    blocTest<ChartCubit, ChartState>(
      'emits loading then loaded states when loadChartData succeeds',
      build: () => chartCubit,
      act: (cubit) => cubit.loadChartData(),
      expect: () => [
        isA<ChartState>()
            .having((s) => s.isLoading, 'isLoading', true)
            .having((s) => s.errorMessage, 'errorMessage', null),
        isA<ChartState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.hasData, 'hasData', true)
            .having((s) => s.errorMessage, 'errorMessage', null),
      ],
    );

    blocTest<ChartCubit, ChartState>(
      'emits loading then loaded states when adding new data point',
      build: () => chartCubit,
      act: (cubit) async {
        await cubit.loadChartData();
        await cubit.addDataPoint(DateTime(2025, 10, 20), 180);
      },
      skip: 2,
      expect: () => [
        isA<ChartState>()
            .having((s) => s.isLoading, 'isLoading', true),
        isA<ChartState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.hasData, 'hasData', true),
      ],
    );

    blocTest<ChartCubit, ChartState>(
      'emits error while keeping data when adding duplicate date',
      build: () => chartCubit,
      act: (cubit) async {
        await cubit.loadChartData();
        await cubit.addDataPoint(DateTime(2025, 10, 8), 100);
      },
      skip: 2,
      expect: () => [
        isA<ChartState>()
            .having((s) => s.errorMessage, 'errorMessage', 'Date already exists')
            .having((s) => s.hasData, 'hasData', true),
      ],
    );

    test('clearError removes error message while keeping data', () async {
      await chartCubit.loadChartData();
      chartCubit.emit(chartCubit.state.copyWith(errorMessage: 'Some error'));
      final dataBefore = chartCubit.state.data;

      chartCubit.clearError();

      expect(chartCubit.state.errorMessage, null);
      expect(chartCubit.state.data, dataBefore);
    });
  });
}
