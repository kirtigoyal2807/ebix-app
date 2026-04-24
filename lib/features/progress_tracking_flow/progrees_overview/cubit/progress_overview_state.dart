import 'package:equatable/equatable.dart';

import '../../data/models/progress_overview.dart';

enum ProgressOverviewStatus { initial, loading, success, failure }

class ProgressOverviewState extends Equatable {
  const ProgressOverviewState({
    this.status = ProgressOverviewStatus.initial,
    this.overview,
    this.errorMessage,
  });

  final ProgressOverviewStatus status;
  final ProgressOverview? overview;
  final String? errorMessage;

  static const Object _unset = Object();

  ProgressOverviewState copyWith({
    ProgressOverviewStatus? status,
    ProgressOverview? overview,
    Object? errorMessage = _unset,
  }) {
    return ProgressOverviewState(
      status: status ?? this.status,
      overview: overview ?? this.overview,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [status, overview, errorMessage];
}
