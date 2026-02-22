import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SessionHistoryState extends Equatable {
  final List<SessionHistory> sessionHistoryList;
  final SessionHistory selectedSessionHistory;

  SessionHistoryState({
    required this.sessionHistoryList,

    this.selectedSessionHistory = SessionHistory.allTime,
  });

  SessionHistoryState copyWith({
    List<SessionHistory>? sessionHistoryList,
    SessionHistory? selectedSessionHistory,
  }) {
    return SessionHistoryState(
      sessionHistoryList: sessionHistoryList ?? this.sessionHistoryList,
      selectedSessionHistory:
          selectedSessionHistory ?? this.selectedSessionHistory,
    );
  }

  @override
  List<Object> get props => [sessionHistoryList, selectedSessionHistory];
}

enum SessionHistory { allTime, thisMonth, last30Days }
