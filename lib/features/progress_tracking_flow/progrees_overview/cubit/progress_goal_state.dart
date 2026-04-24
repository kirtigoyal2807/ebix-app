import 'package:equatable/equatable.dart';

import '../../data/models/progress_goal_settings.dart';

enum ProgressGoalStatus { initial, loading, success, failure }

class ProgressGoalState extends Equatable {
  const ProgressGoalState({
    this.status = ProgressGoalStatus.initial,
    this.goal,
    this.errorMessage,
    this.isSubmitting = false,
  });

  final ProgressGoalStatus status;
  final ProgressGoalSettings? goal;
  final String? errorMessage;
  final bool isSubmitting;

  static const Object _unset = Object();

  ProgressGoalState copyWith({
    ProgressGoalStatus? status,
    ProgressGoalSettings? goal,
    Object? errorMessage = _unset,
    bool? isSubmitting,
  }) {
    return ProgressGoalState(
      status: status ?? this.status,
      goal: goal ?? this.goal,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [status, goal, errorMessage, isSubmitting];
}
