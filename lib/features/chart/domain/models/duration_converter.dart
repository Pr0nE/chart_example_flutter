import 'package:freezed_annotation/freezed_annotation.dart';

class DurationConverter implements JsonConverter<int, dynamic> {
  const DurationConverter();

  @override
  int fromJson(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is String) {
      final cleanValue = value.replaceAll(' min', '').trim();
      return int.parse(cleanValue);
    }

    throw ArgumentError('Cannot convert $value to int minutes');
  }

  @override
  dynamic toJson(int minutes) => minutes;
}
