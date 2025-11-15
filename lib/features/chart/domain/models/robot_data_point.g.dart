// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'robot_data_point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RobotDataPointImpl _$$RobotDataPointImplFromJson(Map<String, dynamic> json) =>
    _$RobotDataPointImpl(
      date: const DateConverter().fromJson(json['date'] as String),
      minutesActive: const DurationConverter().fromJson(json['duration']),
    );

Map<String, dynamic> _$$RobotDataPointImplToJson(
  _$RobotDataPointImpl instance,
) => <String, dynamic>{
  'date': const DateConverter().toJson(instance.date),
  'duration': const DurationConverter().toJson(instance.minutesActive),
};
