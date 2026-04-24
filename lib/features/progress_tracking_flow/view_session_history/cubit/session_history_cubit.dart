import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pilates_app/core/network/api_result.dart';

import 'package:pilates_app/features/progress_tracking_flow/data/progress_repository.dart';
import 'package:pilates_app/features/progress_tracking_flow/view_session_history/cubit/session_history_state.dart';

class SessionHistoryCubit extends Cubit<SessionHistoryState> {
  SessionHistoryCubit(this._repository)
      : super(
          SessionHistoryState(
            sessionHistoryList: SessionHistory.values,
          ),
        ) {
    loadSessions();
  }

  final ProgressRepository _repository;

  Future<void> loadSessions({bool resetPage = true}) async {
    final page = resetPage ? 1 : state.currentPage;
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
      ),
    );
    final result = await _repository.getSessionHistory(
      filter: state.selectedSessionHistory.apiFilterValue,
      page: page,
      perPage: state.perPage,
    );
    switch (result) {
      case ApiSuccess(:final data):
        emit(
          state.copyWith(
            isLoading: false,
            sessions: data.items,
            total: data.total,
            currentPage: data.currentPage,
            lastPage: data.lastPage,
            perPage: data.perPage,
            errorMessage: null,
          ),
        );
      case ApiFailure(:final exception):
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: exception.message,
          ),
        );
    }
  }

  void setSelectedSessionHistory(SessionHistory history) {
    if (history == state.selectedSessionHistory) return;
    emit(state.copyWith(selectedSessionHistory: history));
    loadSessions(resetPage: true);
  }

  Future<void> refresh() => loadSessions(resetPage: true);
}
