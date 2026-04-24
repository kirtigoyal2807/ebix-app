import 'package:equatable/equatable.dart';

import '../../data/models/weekly_activity_result.dart';

enum WeeklyActivityStatus { initial, loading, success, failure }

class WeeklyActivityState extends Equatable {
  const WeeklyActivityState({
    this.status = WeeklyActivityStatus.initial,
    this.result,
    this.errorMessage,
  });

  final WeeklyActivityStatus status;
  final WeeklyActivityResult? result;
  final String? errorMessage;

  static const Object _unset = Object();

  WeeklyActivityState copyWith({
    WeeklyActivityStatus? status,
    WeeklyActivityResult? result,
    Object? errorMessage = _unset,
  }) {
    return WeeklyActivityState(
      status: status ?? this.status,
      result: result ?? this.result,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [status, result, errorMessage];
}
