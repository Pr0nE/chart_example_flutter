// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chart_data_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChartDataResponse _$ChartDataResponseFromJson(Map<String, dynamic> json) {
  return _ChartDataResponse.fromJson(json);
}

/// @nodoc
mixin _$ChartDataResponse {
  @JsonKey(name: 'Collector')
  List<RobotDataPoint> get collector => throw _privateConstructorUsedError;

  /// Serializes this ChartDataResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChartDataResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChartDataResponseCopyWith<ChartDataResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChartDataResponseCopyWith<$Res> {
  factory $ChartDataResponseCopyWith(
    ChartDataResponse value,
    $Res Function(ChartDataResponse) then,
  ) = _$ChartDataResponseCopyWithImpl<$Res, ChartDataResponse>;
  @useResult
  $Res call({@JsonKey(name: 'Collector') List<RobotDataPoint> collector});
}

/// @nodoc
class _$ChartDataResponseCopyWithImpl<$Res, $Val extends ChartDataResponse>
    implements $ChartDataResponseCopyWith<$Res> {
  _$ChartDataResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChartDataResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? collector = null}) {
    return _then(
      _value.copyWith(
            collector: null == collector
                ? _value.collector
                : collector // ignore: cast_nullable_to_non_nullable
                      as List<RobotDataPoint>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChartDataResponseImplCopyWith<$Res>
    implements $ChartDataResponseCopyWith<$Res> {
  factory _$$ChartDataResponseImplCopyWith(
    _$ChartDataResponseImpl value,
    $Res Function(_$ChartDataResponseImpl) then,
  ) = __$$ChartDataResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'Collector') List<RobotDataPoint> collector});
}

/// @nodoc
class __$$ChartDataResponseImplCopyWithImpl<$Res>
    extends _$ChartDataResponseCopyWithImpl<$Res, _$ChartDataResponseImpl>
    implements _$$ChartDataResponseImplCopyWith<$Res> {
  __$$ChartDataResponseImplCopyWithImpl(
    _$ChartDataResponseImpl _value,
    $Res Function(_$ChartDataResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChartDataResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? collector = null}) {
    return _then(
      _$ChartDataResponseImpl(
        collector: null == collector
            ? _value._collector
            : collector // ignore: cast_nullable_to_non_nullable
                  as List<RobotDataPoint>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChartDataResponseImpl implements _ChartDataResponse {
  const _$ChartDataResponseImpl({
    @JsonKey(name: 'Collector') required final List<RobotDataPoint> collector,
  }) : _collector = collector;

  factory _$ChartDataResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChartDataResponseImplFromJson(json);

  final List<RobotDataPoint> _collector;
  @override
  @JsonKey(name: 'Collector')
  List<RobotDataPoint> get collector {
    if (_collector is EqualUnmodifiableListView) return _collector;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_collector);
  }

  @override
  String toString() {
    return 'ChartDataResponse(collector: $collector)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChartDataResponseImpl &&
            const DeepCollectionEquality().equals(
              other._collector,
              _collector,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_collector));

  /// Create a copy of ChartDataResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChartDataResponseImplCopyWith<_$ChartDataResponseImpl> get copyWith =>
      __$$ChartDataResponseImplCopyWithImpl<_$ChartDataResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ChartDataResponseImplToJson(this);
  }
}

abstract class _ChartDataResponse implements ChartDataResponse {
  const factory _ChartDataResponse({
    @JsonKey(name: 'Collector') required final List<RobotDataPoint> collector,
  }) = _$ChartDataResponseImpl;

  factory _ChartDataResponse.fromJson(Map<String, dynamic> json) =
      _$ChartDataResponseImpl.fromJson;

  @override
  @JsonKey(name: 'Collector')
  List<RobotDataPoint> get collector;

  /// Create a copy of ChartDataResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChartDataResponseImplCopyWith<_$ChartDataResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
