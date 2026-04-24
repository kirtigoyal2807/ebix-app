import 'package:equatable/equatable.dart';

import 'package:pilates_app/features/auth/data/models/pagination_meta.dart';
import 'package:pilates_app/features/booking/data/models/trainer_resource.dart';

enum TrainersLoadStatus { initial, loading, success, failure }

class TrainersState extends Equatable {
  const TrainersState({
    this.status = TrainersLoadStatus.initial,
    this.items = const [],
    this.errorMessage,
    this.pagination,
  });

  final TrainersLoadStatus status;
  final List<TrainerResource> items;
  final String? errorMessage;
  final PaginationMeta? pagination;

  TrainersState copyWith({
    TrainersLoadStatus? status,
    List<TrainerResource>? items,
    String? errorMessage,
    PaginationMeta? pagination,
    bool clearError = false,
  }) {
    return TrainersState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      pagination: pagination ?? this.pagination,
    );
  }

  @override
  List<Object?> get props => [status, items, errorMessage, pagination];
}
