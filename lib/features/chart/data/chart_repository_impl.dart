import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/models/robot_data_point.dart';
import '../domain/repository/chart_repository.dart';

class ChartRepositoryImpl implements ChartRepository {
  static const String _keyChartData = 'chart_data';
  final SharedPreferences sharedPreferences;

  ChartRepositoryImpl({required this.sharedPreferences});

  @override
  Future<List<RobotDataPoint>> getChartData() async {
    final dataString = sharedPreferences.getString(_keyChartData);

    if (dataString == null) {
      final initialData = await _getInitialData();
      await _saveChartData(initialData);
      return initialData;
    }

    final List<dynamic> jsonList = json.decode(dataString);
    return jsonList.map((json) {
      return RobotDataPoint(
        date: DateTime.parse(json['date']),
        minutesActive: json['minutesActive'],
      );
    }).toList();
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
    final jsonList = data.map((point) {
      return {
        'date': point.date.toIso8601String(),
        'minutesActive': point.minutesActive,
      };
    }).toList();

    await sharedPreferences.setString(_keyChartData, json.encode(jsonList));
  }

  Future<List<RobotDataPoint>> _getInitialData() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/sample_data.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      final List<dynamic> collectorData =
          jsonData['Collector'] as List<dynamic>;

      final dateFormat = DateFormat('dd/MM/yyyy');
      return collectorData.map((item) {
        final String dateString = item['date'] as String;
        final DateTime date = dateFormat.parse(dateString);

        final String durationString = item['duration'] as String;
        final int minutes = int.parse(durationString.replaceAll(' min', ''));

        return RobotDataPoint(date: date, minutesActive: minutes);
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
