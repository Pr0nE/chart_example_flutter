// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChartDataResponseImpl _$$ChartDataResponseImplFromJson(
  Map<String, dynamic> json,
) => _$ChartDataResponseImpl(
  collector: (json['Collector'] as List<dynamic>)
      .map((e) => RobotDataPoint.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$ChartDataResponseImplToJson(
  _$ChartDataResponseImpl instance,
) => <String, dynamic>{'Collector': instance.collector};
