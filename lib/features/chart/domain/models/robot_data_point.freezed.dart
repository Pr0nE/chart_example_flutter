// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'robot_data_point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RobotDataPoint _$RobotDataPointFromJson(Map<String, dynamic> json) {
  return _RobotDataPoint.fromJson(json);
}

/// @nodoc
mixin _$RobotDataPoint {
  @JsonKey()
  @DateConverter()
  DateTime get date => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration')
  @DurationConverter()
  int get minutesActive => throw _privateConstructorUsedError;

  /// Serializes this RobotDataPoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RobotDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RobotDataPointCopyWith<RobotDataPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RobotDataPointCopyWith<$Res> {
  factory $RobotDataPointCopyWith(
    RobotDataPoint value,
    $Res Function(RobotDataPoint) then,
  ) = _$RobotDataPointCopyWithImpl<$Res, RobotDataPoint>;
  @useResult
  $Res call({
    @JsonKey() @DateConverter() DateTime date,
    @JsonKey(name: 'duration') @DurationConverter() int minutesActive,
  });
}

/// @nodoc
class _$RobotDataPointCopyWithImpl<$Res, $Val extends RobotDataPoint>
    implements $RobotDataPointCopyWith<$Res> {
  _$RobotDataPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RobotDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? minutesActive = null}) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            minutesActive: null == minutesActive
                ? _value.minutesActive
                : minutesActive // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RobotDataPointImplCopyWith<$Res>
    implements $RobotDataPointCopyWith<$Res> {
  factory _$$RobotDataPointImplCopyWith(
    _$RobotDataPointImpl value,
    $Res Function(_$RobotDataPointImpl) then,
  ) = __$$RobotDataPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey() @DateConverter() DateTime date,
    @JsonKey(name: 'duration') @DurationConverter() int minutesActive,
  });
}

/// @nodoc
class __$$RobotDataPointImplCopyWithImpl<$Res>
    extends _$RobotDataPointCopyWithImpl<$Res, _$RobotDataPointImpl>
    implements _$$RobotDataPointImplCopyWith<$Res> {
  __$$RobotDataPointImplCopyWithImpl(
    _$RobotDataPointImpl _value,
    $Res Function(_$RobotDataPointImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RobotDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? minutesActive = null}) {
    return _then(
      _$RobotDataPointImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        minutesActive: null == minutesActive
            ? _value.minutesActive
            : minutesActive // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RobotDataPointImpl extends _RobotDataPoint {
  const _$RobotDataPointImpl({
    @JsonKey() @DateConverter() required this.date,
    @JsonKey(name: 'duration') @DurationConverter() required this.minutesActive,
  }) : super._();

  factory _$RobotDataPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$RobotDataPointImplFromJson(json);

  @override
  @JsonKey()
  @DateConverter()
  final DateTime date;
  @override
  @JsonKey(name: 'duration')
  @DurationConverter()
  final int minutesActive;

  @override
  String toString() {
    return 'RobotDataPoint(date: $date, minutesActive: $minutesActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RobotDataPointImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.minutesActive, minutesActive) ||
                other.minutesActive == minutesActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, minutesActive);

  /// Create a copy of RobotDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RobotDataPointImplCopyWith<_$RobotDataPointImpl> get copyWith =>
      __$$RobotDataPointImplCopyWithImpl<_$RobotDataPointImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RobotDataPointImplToJson(this);
  }
}

abstract class _RobotDataPoint extends RobotDataPoint {
  const factory _RobotDataPoint({
    @JsonKey() @DateConverter() required final DateTime date,
    @JsonKey(name: 'duration')
    @DurationConverter()
    required final int minutesActive,
  }) = _$RobotDataPointImpl;
  const _RobotDataPoint._() : super._();

  factory _RobotDataPoint.fromJson(Map<String, dynamic> json) =
      _$RobotDataPointImpl.fromJson;

  @override
  @JsonKey()
  @DateConverter()
  DateTime get date;
  @override
  @JsonKey(name: 'duration')
  @DurationConverter()
  int get minutesActive;

  /// Create a copy of RobotDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RobotDataPointImplCopyWith<_$RobotDataPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
