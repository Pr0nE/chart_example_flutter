import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chart_example_flutter/features/chart/data/chart_repository_impl.dart';
import 'package:chart_example_flutter/features/chart/domain/models/robot_data_point.dart';

void main() {
  late ChartRepositoryImpl repository;

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
    repository = ChartRepositoryImpl(sharedPreferences: sharedPreferences);
  });

  group('ChartRepositoryImpl', () {
    test('should return initial data when no data exists', () async {
      final data = await repository.getChartData();
      expect(data, isNotEmpty);
      expect(data.length, 7);
    });

    test('should add new data point', () async {
      final initialData = await repository.getChartData();
      final newPoint = RobotDataPoint(
        date: DateTime(2025, 10, 15),
        minutesActive: 150,
      );

      await repository.addDataPoint(newPoint);
      final updatedData = await repository.getChartData();

      expect(updatedData.length, initialData.length + 1);
    });

    test('should check if date exists', () async {
      final existingDate = DateTime(2025, 10, 8);
      final nonExistingDate = DateTime(2025, 12, 25);

      final exists = await repository.dateExists(existingDate);
      final notExists = await repository.dateExists(nonExistingDate);

      expect(exists, true);
      expect(notExists, false);
    });

    test('should sort data by date', () async {
      final newPoint1 = RobotDataPoint(
        date: DateTime(2025, 10, 20),
        minutesActive: 100,
      );
      final newPoint2 = RobotDataPoint(
        date: DateTime(2025, 10, 15),
        minutesActive: 150,
      );

      await repository.addDataPoint(newPoint1);
      await repository.addDataPoint(newPoint2);

      final data = await repository.getChartData();
      for (int i = 0; i < data.length - 1; i++) {
        expect(
          data[i].date.isBefore(data[i + 1].date) ||
              data[i].date.isAtSameMomentAs(data[i + 1].date),
          true,
        );
      }
    });
  });
}
