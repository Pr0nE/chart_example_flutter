import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chart_example_flutter/features/chart/data/chart_repository_impl.dart';
import 'package:chart_example_flutter/features/chart/domain/models/robot_data_point.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late ChartRepositoryImpl repository;
  late MockSharedPreferences mockSharedPreferences;

  List<RobotDataPoint> getInitialTestData() {
    return List.generate(7, (index) {
      final date = DateTime(2025, 10, 8 + index);
      return RobotDataPoint(date: date, minutesActive: 100 + (index * 50));
    });
  }

  String encodeData(List<RobotDataPoint> data) {
    final jsonList = data.map((point) => point.toJson()).toList();
    return json.encode(jsonList);
  }

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    repository = ChartRepositoryImpl(sharedPreferences: mockSharedPreferences);
  });

  group('ChartRepositoryImpl', () {
    test(
      'should return initial data when data exists in preferences',
      () async {
        final testData = getInitialTestData();
        when(
          () => mockSharedPreferences.getString('chart_data'),
        ).thenReturn(encodeData(testData));

        final data = await repository.getChartData();

        expect(data, isNotEmpty);
        expect(data.length, 7);
        verify(() => mockSharedPreferences.getString('chart_data')).called(1);
      },
    );

    test('should add new data point', () async {
      final initialData = getInitialTestData();
      when(
        () => mockSharedPreferences.getString('chart_data'),
      ).thenReturn(encodeData(initialData));
      when(
        () => mockSharedPreferences.setString(any(), any()),
      ).thenAnswer((_) async => true);

      final newPoint = RobotDataPoint(
        date: DateTime(2025, 10, 15),
        minutesActive: 150,
      );

      await repository.addDataPoint(newPoint);

      verify(
        () => mockSharedPreferences.setString('chart_data', any()),
      ).called(1);
    });

    test('should check if date exists', () async {
      final testData = getInitialTestData();
      when(
        () => mockSharedPreferences.getString('chart_data'),
      ).thenReturn(encodeData(testData));

      final existingDate = DateTime(2025, 10, 8);
      final nonExistingDate = DateTime(2025, 12, 25);

      final exists = await repository.dateExists(existingDate);
      final notExists = await repository.dateExists(nonExistingDate);

      expect(exists, true);
      expect(notExists, false);
    });
  });
}
