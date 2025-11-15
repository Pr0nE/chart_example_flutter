// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'date_converter.dart';
import 'duration_converter.dart';

part 'robot_data_point.freezed.dart';
part 'robot_data_point.g.dart';

@freezed
class RobotDataPoint with _$RobotDataPoint {
  const RobotDataPoint._();

  const factory RobotDataPoint({
    @JsonKey() @DateConverter() required DateTime date,
    @JsonKey(name: 'duration') @DurationConverter() required int minutesActive,
  }) = _RobotDataPoint;

  factory RobotDataPoint.fromJson(Map<String, dynamic> json) =>
      _$RobotDataPointFromJson(json);

  double get hoursActive => minutesActive / 60.0;
}
