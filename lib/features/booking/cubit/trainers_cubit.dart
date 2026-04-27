import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pilates_app/features/booking/cubit/booking_state.dart';
import 'package:pilates_app/features/booking/cubit/trainers_state.dart';
import 'package:pilates_app/features/booking/data/trainers_repository.dart';

/// Maps UI filter chips to API §12.1 `specialty` (exact match in stored JSON array).
String? trainerSpecialtyQuery(TrainerType type) {
  switch (type) {
    case TrainerType.allTrainers:
      return null;
    case TrainerType.matPilates:
      return 'mat pilates';
    case TrainerType.reformer:
      return 'reformer';
    case TrainerType.seniorFriendly:
      return 'senior friendly';
  }
}

class TrainersCubit extends Cubit<TrainersState> {
  TrainersCubit(this._repository) : super(const TrainersState());

  final TrainersRepository _repository;

  int _requestId = 0;

  Future<void> load({
    String? branchId,
    String? specialty,
    String? search,
  }) async {
    final requestId = ++_requestId;
    emit(state.copyWith(status: TrainersLoadStatus.loading, clearError: true));
    final result = await _repository.listTrainers(
      branchId: branchId,
      specialty: specialty,
      search: search,
      page: 1,
    );
    if (isClosed || requestId != _requestId) return;
    result.when(
      success: (data, _) {
        emit(
          TrainersState(
            status: TrainersLoadStatus.success,
            items: data.items,
            pagination: data.pagination,
          ),
        );
      },
      failure: (e) {
        emit(
          TrainersState(
            status: TrainersLoadStatus.failure,
            items: state.items,
            pagination: state.pagination,
            errorMessage: e.message,
          ),
        );
      },
    );
  }
}
