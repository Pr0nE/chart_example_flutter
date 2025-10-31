import 'package:equatable/equatable.dart';

class RobotDataPoint extends Equatable {
  final DateTime date;
  final int minutesActive;

  const RobotDataPoint({
    required this.date,
    required this.minutesActive,
  });

  double get hoursActive => minutesActive / 60.0;

  @override
  List<Object?> get props => [date, minutesActive];

  RobotDataPoint copyWith({
    DateTime? date,
    int? minutesActive,
  }) {
    return RobotDataPoint(
      date: date ?? this.date,
      minutesActive: minutesActive ?? this.minutesActive,
    );
  }
}
