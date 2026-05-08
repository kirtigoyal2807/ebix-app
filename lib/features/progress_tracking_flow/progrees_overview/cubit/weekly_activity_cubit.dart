import 'package:bloc/bloc.dart';

import 'package:pilates_app/core/network/api_result.dart';

import '../../data/progress_repository.dart';
import 'weekly_activity_state.dart';

class WeeklyActivityCubit extends Cubit<WeeklyActivityState> {
  WeeklyActivityCubit(this._repository) : super(const WeeklyActivityState());

  final ProgressRepository _repository;

  Future<void> load() async {
    emit(
      state.copyWith(status: WeeklyActivityStatus.loading, errorMessage: null),
    );
    final result = await _repository.getWeeklyActivity();
    switch (result) {
      case ApiSuccess(:final data):
        emit(
          WeeklyActivityState(
            status: WeeklyActivityStatus.success,
            result: data,
          ),
        );
      case ApiFailure(:final exception):
        emit(
          WeeklyActivityState(
            status: WeeklyActivityStatus.failure,
            result: state.result,
            errorMessage: exception.message,
          ),
        );
    }
  }
}
