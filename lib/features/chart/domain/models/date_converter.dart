import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

class DateConverter implements JsonConverter<DateTime, String> {
  const DateConverter();

  @override
  DateTime fromJson(String value) {
    if (value.contains('/')) {
      final dateFormat = DateFormat('dd/MM/yyyy');
      return dateFormat.parse(value);
    }

    return DateTime.parse(value);
  }

  @override
  String toJson(DateTime date) {
    return date.toIso8601String();
  }
}
