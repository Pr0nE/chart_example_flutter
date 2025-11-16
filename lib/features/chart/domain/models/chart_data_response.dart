// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'robot_data_point.dart';

part 'chart_data_response.freezed.dart';
part 'chart_data_response.g.dart';

@freezed
class ChartDataResponse with _$ChartDataResponse {
  const factory ChartDataResponse({
    @JsonKey(name: 'Collector') required List<RobotDataPoint> collector,
  }) = _ChartDataResponse;

  factory ChartDataResponse.fromJson(Map<String, dynamic> json) =>
      _$ChartDataResponseFromJson(json);
}
