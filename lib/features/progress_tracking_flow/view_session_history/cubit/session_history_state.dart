import 'package:equatable/equatable.dart';

import 'package:pilates_app/features/progress_tracking_flow/data/models/progress_session_history_item.dart';

class SessionHistoryState extends Equatable {
  SessionHistoryState({
    required this.sessionHistoryList,
    this.selectedSessionHistory = SessionHistory.allTime,
    this.isLoading = false,
    this.errorMessage,
    this.sessions = const [],
    this.total = 0,
    this.currentPage = 1,
    this.lastPage = 1,
    this.perPage = 20,
  });

  final List<SessionHistory> sessionHistoryList;
  final SessionHistory selectedSessionHistory;
  final bool isLoading;
  final String? errorMessage;
  final List<ProgressSessionHistoryItem> sessions;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;

  int get totalDurationMinutes =>
      sessions.fold<int>(0, (sum, e) => sum + e.durationMinutes);

  SessionHistoryState copyWith({
    List<SessionHistory>? sessionHistoryList,
    SessionHistory? selectedSessionHistory,
    bool? isLoading,
    Object? errorMessage = _sentinel,
    List<ProgressSessionHistoryItem>? sessions,
    int? total,
    int? currentPage,
    int? lastPage,
    int? perPage,
  }) {
    return SessionHistoryState(
      sessionHistoryList: sessionHistoryList ?? this.sessionHistoryList,
      selectedSessionHistory:
          selectedSessionHistory ?? this.selectedSessionHistory,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
      sessions: sessions ?? this.sessions,
      total: total ?? this.total,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      perPage: perPage ?? this.perPage,
    );
  }

  static const Object _sentinel = Object();

  @override
  List<Object?> get props => [
    sessionHistoryList,
    selectedSessionHistory,
    isLoading,
    errorMessage,
    sessions,
    total,
    currentPage,
    lastPage,
    perPage,
  ];
}

enum SessionHistory { allTime, thisMonth, last30Days }

extension SessionHistoryApiFilter on SessionHistory {
  String get apiFilterValue {
    switch (this) {
      case SessionHistory.allTime:
        return 'all';
      case SessionHistory.thisMonth:
        return 'this_month';
      case SessionHistory.last30Days:
        return 'last_30_days';
    }
  }
}
