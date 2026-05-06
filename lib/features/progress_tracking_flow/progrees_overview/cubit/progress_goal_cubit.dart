import 'package:bloc/bloc.dart';

import 'package:pilates_app/core/network/api_result.dart';

import '../../data/progress_repository.dart';
import 'progress_goal_state.dart';

class ProgressGoalCubit extends Cubit<ProgressGoalState> {
  ProgressGoalCubit(this._repository) : super(const ProgressGoalState());

  final ProgressRepository _repository;

  Future<void> load() async {
    emit(
      state.copyWith(status: ProgressGoalStatus.loading, errorMessage: null),
    );
    final result = await _repository.getGoal();
    switch (result) {
      case ApiSuccess(:final data):
        emit(ProgressGoalState(status: ProgressGoalStatus.success, goal: data));
      case ApiFailure(:final exception):
        emit(
          ProgressGoalState(
            status: ProgressGoalStatus.failure,
            goal: state.goal,
            errorMessage: exception.message,
          ),
        );
    }
  }

  /// Persists changed fields then refreshes from `GET /progress/goal`.
  Future<bool> save({
    int? monthlyGoal,
    String? experience,
    String? goal,
  }) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null));
    final result = await _repository.updateGoal(
      monthlyGoal: monthlyGoal,
      experience: experience,
      goal: goal,
    );
    switch (result) {
      case ApiSuccess():
        final reload = await _repository.getGoal();
        switch (reload) {
          case ApiSuccess(:final data):
            emit(
              ProgressGoalState(
                status: ProgressGoalStatus.success,
                goal: data,
                isSubmitting: false,
              ),
            );
            return true;
          case ApiFailure(:final exception):
            emit(
              ProgressGoalState(
                status: ProgressGoalStatus.failure,
                goal: state.goal,
                errorMessage: exception.message,
                isSubmitting: false,
              ),
            );
            return false;
        }
      case ApiFailure(:final exception):
        emit(
          state.copyWith(isSubmitting: false, errorMessage: exception.message),
        );
        return false;
    }
  }
}
