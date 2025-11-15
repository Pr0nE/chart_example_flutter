// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chart_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ChartState {
  List<RobotDataPoint> get data => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of ChartState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChartStateCopyWith<ChartState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChartStateCopyWith<$Res> {
  factory $ChartStateCopyWith(
    ChartState value,
    $Res Function(ChartState) then,
  ) = _$ChartStateCopyWithImpl<$Res, ChartState>;
  @useResult
  $Res call({List<RobotDataPoint> data, bool isLoading, String? errorMessage});
}

/// @nodoc
class _$ChartStateCopyWithImpl<$Res, $Val extends ChartState>
    implements $ChartStateCopyWith<$Res> {
  _$ChartStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChartState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as List<RobotDataPoint>,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChartStateImplCopyWith<$Res>
    implements $ChartStateCopyWith<$Res> {
  factory _$$ChartStateImplCopyWith(
    _$ChartStateImpl value,
    $Res Function(_$ChartStateImpl) then,
  ) = __$$ChartStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<RobotDataPoint> data, bool isLoading, String? errorMessage});
}

/// @nodoc
class __$$ChartStateImplCopyWithImpl<$Res>
    extends _$ChartStateCopyWithImpl<$Res, _$ChartStateImpl>
    implements _$$ChartStateImplCopyWith<$Res> {
  __$$ChartStateImplCopyWithImpl(
    _$ChartStateImpl _value,
    $Res Function(_$ChartStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChartState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$ChartStateImpl(
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<RobotDataPoint>,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$ChartStateImpl extends _ChartState {
  const _$ChartStateImpl({
    final List<RobotDataPoint> data = const [],
    this.isLoading = false,
    this.errorMessage,
  }) : _data = data,
       super._();

  final List<RobotDataPoint> _data;
  @override
  @JsonKey()
  List<RobotDataPoint> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'ChartState(data: $data, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChartStateImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_data),
    isLoading,
    errorMessage,
  );

  /// Create a copy of ChartState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChartStateImplCopyWith<_$ChartStateImpl> get copyWith =>
      __$$ChartStateImplCopyWithImpl<_$ChartStateImpl>(this, _$identity);
}

abstract class _ChartState extends ChartState {
  const factory _ChartState({
    final List<RobotDataPoint> data,
    final bool isLoading,
    final String? errorMessage,
  }) = _$ChartStateImpl;
  const _ChartState._() : super._();

  @override
  List<RobotDataPoint> get data;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;

  /// Create a copy of ChartState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChartStateImplCopyWith<_$ChartStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
