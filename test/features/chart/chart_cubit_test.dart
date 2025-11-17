import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:chart_example_flutter/features/chart/ui/cubit/chart_cubit.dart';
import 'package:chart_example_flutter/features/chart/domain/repository/chart_repository.dart';
import 'package:chart_example_flutter/features/chart/domain/models/robot_data_point.dart';
import 'package:chart_example_flutter/features/chart/ui/cubit/chart_state.dart';

class MockChartRepository extends Mock implements ChartRepository {}

void main() {
  late ChartCubit chartCubit;
  late MockChartRepository mockChartRepository;

  List<RobotDataPoint> getInitialTestData() {
    return List.generate(7, (index) {
      final date = DateTime(2025, 10, 8 + index);
      return RobotDataPoint(date: date, minutesActive: 100 + (index * 50));
    });
  }

  setUpAll(() {
    registerFallbackValue(
      RobotDataPoint(date: DateTime(2025, 10, 1), minutesActive: 100),
    );
  });

  setUp(() {
    mockChartRepository = MockChartRepository();
    chartCubit = ChartCubit(mockChartRepository);
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
      build: () {
        when(
          () => mockChartRepository.getChartData(),
        ).thenAnswer((_) async => getInitialTestData());
        return ChartCubit(mockChartRepository);
      },
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
      build: () {
        when(
          () => mockChartRepository.getChartData(),
        ).thenAnswer((_) async => getInitialTestData());
        when(
          () => mockChartRepository.dateExists(any()),
        ).thenAnswer((_) async => false);
        when(
          () => mockChartRepository.addDataPoint(any()),
        ).thenAnswer((_) async {});
        return ChartCubit(mockChartRepository);
      },
      act: (cubit) async {
        await cubit.loadChartData();
        await cubit.addDataPoint(DateTime(2025, 10, 20), 180);
      },
      skip: 2,
      expect: () => [
        isA<ChartState>().having((s) => s.isLoading, 'isLoading', true),
        isA<ChartState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.hasData, 'hasData', true),
      ],
    );

    blocTest<ChartCubit, ChartState>(
      'emits error while keeping data when adding duplicate date',
      build: () {
        when(
          () => mockChartRepository.getChartData(),
        ).thenAnswer((_) async => getInitialTestData());
        when(
          () => mockChartRepository.dateExists(any()),
        ).thenAnswer((_) async => true);
        return ChartCubit(mockChartRepository);
      },
      act: (cubit) async {
        await cubit.loadChartData();
        await cubit.addDataPoint(DateTime(2025, 10, 8), 100);
      },
      skip: 2,
      expect: () => [
        isA<ChartState>()
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              'Date already exists',
            )
            .having((s) => s.hasData, 'hasData', true),
      ],
    );
  });
}
