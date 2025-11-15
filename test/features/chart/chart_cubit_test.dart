import 'dart:convert';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chart_example_flutter/features/chart/ui/chart_cubit.dart';
import 'package:chart_example_flutter/features/chart/data/chart_repository_impl.dart';
import 'package:chart_example_flutter/features/chart/domain/chart_state.dart';

void main() {
  late ChartCubit chartCubit;
  late ChartRepositoryImpl chartRepository;

  // Helper to create initial test data
  List<Map<String, dynamic>> getInitialTestData() {
    return List.generate(7, (index) {
      final date = DateTime(2025, 10, 8 + index);
      return {
        'date': date.toIso8601String(),
        'minutesActive': 100 + (index * 50),
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
    test('initial state is ChartInitial', () {
      expect(chartCubit.state, const ChartInitial());
    });

    blocTest<ChartCubit, ChartState>(
      'emits [ChartLoading, ChartLoaded] when loadChartData succeeds',
      build: () => chartCubit,
      act: (cubit) => cubit.loadChartData(),
      expect: () => [
        const ChartLoading(),
        isA<ChartLoaded>(),
      ],
    );

    blocTest<ChartCubit, ChartState>(
      'emits [ChartLoading, ChartLoaded] when adding new data point',
      build: () => chartCubit,
      act: (cubit) async {
        await cubit.loadChartData();
        await cubit.addDataPoint(DateTime(2025, 10, 20), 180);
      },
      skip: 2,
      expect: () => [
        const ChartLoading(),
        isA<ChartLoaded>(),
      ],
    );

    blocTest<ChartCubit, ChartState>(
      'emits [ChartError] when adding duplicate date',
      build: () => chartCubit,
      act: (cubit) async {
        await cubit.loadChartData();
        await cubit.addDataPoint(DateTime(2025, 10, 8), 100);
      },
      skip: 2,
      expect: () => [
        const ChartError('Date already exists'),
        isA<ChartLoaded>(),
      ],
    );
  });
}
