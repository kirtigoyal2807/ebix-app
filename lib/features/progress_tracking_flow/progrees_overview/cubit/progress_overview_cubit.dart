import 'package:bloc/bloc.dart';

import 'package:pilates_app/core/network/api_result.dart';

import '../../data/progress_repository.dart';
import 'progress_overview_state.dart';

class ProgressOverviewCubit extends Cubit<ProgressOverviewState> {
  ProgressOverviewCubit(this._repository)
    : super(const ProgressOverviewState());

  final ProgressRepository _repository;

  Future<void> load() async {
    emit(
      state.copyWith(
        status: ProgressOverviewStatus.loading,
        errorMessage: null,
      ),
    );
    final result = await _repository.getOverview();
    switch (result) {
      case ApiSuccess(:final data):
        emit(
          ProgressOverviewState(
            status: ProgressOverviewStatus.success,
            overview: data,
          ),
        );
      case ApiFailure(:final exception):
        emit(
          ProgressOverviewState(
            status: ProgressOverviewStatus.failure,
            overview: state.overview,
            errorMessage: exception.message,
          ),
        );
    }
  }
}
