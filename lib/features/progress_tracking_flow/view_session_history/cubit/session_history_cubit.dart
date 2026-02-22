import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:pilates_app/features/progress_tracking_flow/view_session_history/cubit/session_history_state.dart';

class SessionHistoryCubit extends Cubit<SessionHistoryState> {
  SessionHistoryCubit()
    : super(SessionHistoryState(sessionHistoryList: SessionHistory.values));

  void setSelectedSessionHistory(SessionHistory history) {
    emit(state.copyWith(selectedSessionHistory: history));
  }
}
