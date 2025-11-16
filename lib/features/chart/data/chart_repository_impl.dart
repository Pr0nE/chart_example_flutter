import 'dart:convert';
import 'package:chart_example_flutter/features/chart/domain/models/robot_data_point.dart';
import 'package:chart_example_flutter/features/chart/domain/models/chart_data_response.dart';
import 'package:chart_example_flutter/features/chart/domain/repository/chart_repository.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _ChartRepositoryConstants {
  static const String keyChartData = 'chart_data';
  static const String assetSampleDataPath = 'assets/sample_data.json';
}

class ChartRepositoryImpl implements ChartRepository {
  final SharedPreferences sharedPreferences;

  ChartRepositoryImpl({required this.sharedPreferences});

  @override
  Future<List<RobotDataPoint>> getChartData() async {
    final dataString = sharedPreferences.getString(
      _ChartRepositoryConstants.keyChartData,
    );

    if (dataString == null) {
      final initialData = await _getInitialData();
      await _saveChartData(initialData);
      return initialData;
    }

    final List<dynamic> jsonList = json.decode(dataString);
    return jsonList
        .map((json) => RobotDataPoint.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> addDataPoint(RobotDataPoint dataPoint) async {
    final currentData = await getChartData();
    currentData.add(dataPoint);
    currentData.sort((a, b) => a.date.compareTo(b.date));
    await _saveChartData(currentData);
  }

  @override
  Future<bool> dateExists(DateTime date) async {
    final data = await getChartData();
    final dateOnly = DateTime(date.year, date.month, date.day);

    return data.any((point) {
      final pointDateOnly = DateTime(
        point.date.year,
        point.date.month,
        point.date.day,
      );
      return pointDateOnly.isAtSameMomentAs(dateOnly);
    });
  }

  Future<void> _saveChartData(List<RobotDataPoint> data) async {
    final jsonList = data.map((point) => point.toJson()).toList();

    await sharedPreferences.setString(
      _ChartRepositoryConstants.keyChartData, 
      json.encode(jsonList),
    );
  }

  Future<List<RobotDataPoint>> _getInitialData() async {
    try {
      final String jsonString = await rootBundle.loadString(
        _ChartRepositoryConstants.assetSampleDataPath,
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      final response = ChartDataResponse.fromJson(jsonData);
      return response.collector;
    } catch (e) {
      return [];
    }
  }
}
